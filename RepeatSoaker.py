#!/usr/bin/env python

import argparse
import sys
from itertools import groupby
from operator import attrgetter

from BioTK.io import BEDFile
from BioTK.genome import RAMIndex
import pysam

def main(args):
    parser = argparse.ArgumentParser()
    parser.add_argument("--repeat-regions", "-r",
            help="A BED file with repetitive regions to be masked.")

    # TODO: not implemented
    #parser.add_argument("--genome", "-g",
    #        help="A UCSC genome name (e.g., 'hg19')")

    parser.add_argument("--output-sam", "-S")

    parser.add_argument("--percent-overlap", "-p",
            type=float,
            default=85,
            help="Alignments that overlap with repetitive regions at this percentage or greater will be filtered out.")
    parser.add_argument("bam_file", nargs=1)

    args = parser.parse_args(args)

    assert (args.percent_overlap >= 0) and (args.percent_overlap <= 100), \
           "--percent-overlap (-p) must be between 0 and 100."

    index = RAMIndex()

    out_mode = "w"  if args.output_sam else "wb"

    with pysam.Samfile(args.bam_file[0], "rb") as bam, \
            pysam.Samfile("-", out_mode, template=bam) as out:
        contigs = dict([(bam.getrname(i), i) 
            for i in range(bam.nreferences)])

        with BEDFile(args.repeat_regions) as h:
            for region in h:
                contig_id = contigs.get(region.contig)
                if contig_id is not None:
                    index.add(contig_id, region.start, region.end)
        index.build()

        print("Repetitive region index loaded.",
                file=sys.stderr)

        n_alns = n_reads = alns_removed = reads_removed = 0
        #prev_name = None

        for name, alns in groupby(bam, attrgetter("qname")):
            # FIXME: samtools apparently uses something else besides simple lex sort
            # with the -n function...
            #if (prev_name is not None) and (prev_name > name):
            #    raise Exception("Input is not sorted by read name! Exiting.")

            alns = list(alns)
            n_reads += 1
            removed = 0

            for aln in alns:
                n_alns += 1
                matches = list(index.search(aln.tid, aln.pos, aln.aend))
                ok = True
                if matches:
                    positions = set(range(aln.pos, aln.aend)) 
                    for m in matches:
                        _, m_s, m_e, _ = m
                        positions = set([p for p in positions
                            if not ((p >= m_s) and (p <= m_e))])

                    aln_len = (aln.aend - aln.pos)
                    n_overlap = aln_len - len(positions)
                    pct_overlap = n_overlap / aln_len
                    if (pct_overlap * 100) > args.percent_overlap:
                        removed += 1
                        ok = False
                if ok:
                    out.write(aln)

            if removed == len(alns):
                reads_removed += 1
            alns_removed += removed
            #prev_name = name
        
        print("%s / %s alignments removed." % (alns_removed, n_alns),
                file=sys.stderr)
        print("%s / %s reads removed." % (reads_removed, n_reads),
                file=sys.stderr)


if __name__ == "__main__":
    main(sys.argv[1:])
