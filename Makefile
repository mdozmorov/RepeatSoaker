all: hg19.Dukeblacklist.chr.parsed.fa.gz hg19.DACblacklist.chr.parsed.fa.gz hg19.rmsk.chr.parsed.fa.gz

# ToDo: Automate getting FASTA files for repeat regions
# hg19.rmsk.fasta
# hg19.Dukeblacklist.fasta
# hg19.DACblacklist.fasta

## Obtaining FASTA files for repeat regions
# Go to http://genome.ucsc.edu/cgi-bin/hgTables?command=start
hg19.Dukeblacklist.fasta.gz:
# Group: Mapping and Sequencing; track: Mapability; output format: sequence
# output file: hg19.Dukeblacklist.fasta; file type returned: gzip compressed
hg19.DACblacklist.fasta.gz:
# Group: Mapping and Sequencing; track: Mapability; output format: sequence
# output file: hg19.DACblacklist.fasta; file type returned: gzip compressed
hg19.rmsk.fasta.gz:
# Group: Repeats; track: RepeatMasker; output format: sequence
# output file: hg19.rmsk.fasta; file type returned: gzip compressed

## Reprocessing the FASTA files
# Parsing FASTA headers, to keep only "chr#" part
# Merging reads on the same chromosome into single contigs interspersed with 5bp random sequences
hg19.Dukeblacklist.chr.fasta:			hg19.Dukeblacklist.fasta.gz
										zcat hg19.Dukeblacklist.fasta.gz | sed 's/hg.*range=//' | sed 's/:.*//' > hg19.Dukeblacklist.chr.fasta
hg19.Dukeblacklist.chr.parsed.fa.gz:	hg19.Dukeblacklist.chr.fasta
										python2.7 repeatSoakerParser.py hg19.Dukeblacklist.chr.fasta | sed '1d' | gzip > hg19.Dukeblacklist.chr.parsed.fa.gz
hg19.DACblacklist.chr.fasta:			hg19.DACblacklist.fasta.gz
										zcat hg19.DACblacklist.fasta.gz | sed 's/hg.*range=//' | sed 's/:.*//' > hg19.DACblacklist.chr.fasta
hg19.DACblacklist.chr.parsed.fa.gz:		hg19.DACblacklist.chr.fasta
										python2.7 repeatSoakerParser.py hg19.DACblacklist.chr.fasta | sed '1d' | gzip > hg19.DACblacklist.chr.parsed.fa.gz
hg19.rmsk.chr.fasta:					hg19.rmsk.fasta.gz
										zcat hg19.rmsk.fasta.gz | sed 's/hg.*range=//' | sed 's/:.*//' > hg19.rmsk.chr.fasta
hg19.rmsk.chr.parsed.fa.gz:				hg19.rmsk.chr.fasta
										python2.7 repeatSoakerParser.py hg19.rmsk.chr.fasta | sed '1d' | gzip > hg19.rmsk.chr.parsed.fa.gz

										
clean:
										rm *.chr.fasta