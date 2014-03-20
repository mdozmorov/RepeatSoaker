#!/usr/bin/env python

import argparse
import sys
from itertools import groupby
from operator import attrgetter

from BioTK.io import BEDFile
from BioTK.genome import RAMIndex
import pysam

def main(args):
    parser = argparse.ArgumentParser(description='Post-processing of NGS data by filtering out alignments overlapping low complexity regions', usage='%(prog)s bam_file -r rmsk.bed [-p 85] [-s] > filtered_bam_file')
    parser.add_argument("bam_file", nargs=1, help="Input file in BAM format.")
    parser.add_argument("-r", "--repeat-regions", required=True, metavar="rmsk.bed",
            help="A BED file with genomic coordinates of repetitive regions.")
    parser.add_argument("-p", "--percent-overlap", metavar="85",
            type=float,
            default=85,
            help="Alignments that overlap with repetitive regions at this percentage or greater will be filtered out.Default - 85.")
    parser.add_argument("-s", "--output-sam", metavar="", help="Output in SAM format, otherwise, in BAM (default).")

    # TODO: not implemented
    #parser.add_argument("--genome", "-g",
    #        help="A UCSC genome name (e.g., 'hg19')")

    args = parser.parse_args(args)

    assert (args.percent_overlap >= 0) and (args.percent_overlap <= 100), \
           "--percent-overlap (-p) must be between 0 and 100."

    index = RAMIndex()

    out_mode = "w"  if args.output_sam else "wb"

    with pysam.Samfile(args.bam_file[0], "rb") as bam, \
            pysam.Samfile("-", out_mode, template=bam) as out:
        contigs = dict([(i, bam.getrname(i)) 
            for i in range(bam.nreferences)])

        with BEDFile(args.repeat_regions) as h:
            for region in h:
                index.add(region)
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
                matches = list(index.search(contigs[aln.tid], aln.pos, aln.aend))
                ok = True
                if matches:
                    positions = set(range(aln.pos, aln.aend)) 
                    for m in matches:
                        m_s = m.start
                        m_e = m.end
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
            if n_reads % 1000 == 0:
                print("\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b", end="\r", file=sys.stderr)
                print("%d alignments processed." % n_reads, end="\r", file=sys.stderr)

        print("%s / %s alignments removed." % (alns_removed, n_alns),
                file=sys.stderr)
        print("%s / %s reads removed." % (reads_removed, n_reads),
                file=sys.stderr)

if __name__ == "__main__":
    main(sys.argv[1:])
