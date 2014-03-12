all: hg19.Dukeblacklist.chr.parsed.fa.gz

# ToDo: Automate getting FASTA files for repeat regions
# hg19.rmsk.fasta
# hg19.Dukeblacklist.fasta
# hg19.DACblacklist.fasta

# Parsing FASTA headers, to keep only "chr#" part
hg19.Dukeblacklist.chr.fasta:			hg19.Dukeblacklist.fasta.gz
										zcat hg19.Dukeblacklist.fasta.gz | sed 's/hg.*range=//' | sed 's/:.*//' > hg19.Dukeblacklist.chr.fasta
# Merging reads on the same chromosome into single contigs interspersed with 5bp random sequences
hg19.Dukeblacklist.chr.parsed.fa.gz:	hg19.Dukeblacklist.chr.fasta
										python2.7 repeatSoakerParser.py hg19.Dukeblacklist.chr.fasta | sed '1d' | gzip > hg19.Dukeblacklist.chr.parsed.fa.gz
										
clean:
										rm *.chr.fasta