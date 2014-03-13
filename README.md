RepeatSoaker: a simple method to eliminate low-complexity short reads
======================================================================

RepeatSoaker pipeline removes low-complexity short reads (repeat reads) from raw sequencing data. The remaining reads should then be used for alignment.

Use

    make

to create FASTA files of the repeat regions.

We are using 3 sources of low-complexity regions:

1. [DAC Blacklisted Regions from ENCODE/DAC(Kundaje)](http://genome.ucsc.edu/cgi-bin/hgTables?db=hg19&hgta_group=map&hgta_track=wgEncodeMapability&hgta_table=wgEncodeDacMapabilityConsensusExcludable&hgta_doSchema=describe+table+schema); **hg19.DACblacklist.fasta.gz**
2. [Duke Excluded Regions from ENCODE/OpenChrom(Duke)](http://genome.ucsc.edu/cgi-bin/hgTables?db=hg19&hgta_group=map&hgta_track=wgEncodeMapability&hgta_table=wgEncodeDukeMapabilityRegionsExcludable&hgta_doSchema=describe+table+schema); **hg19.Dukeblacklist.fasta.gz**
3. [Repeating Elements by RepeatMasker](http://genome.ucsc.edu/cgi-bin/hgTables?db=hg19&hgta_group=rep&hgta_track=rmsk&hgta_table=rmsk&hgta_doSchema=describe+table+schema); **hg19.rmsk.fasta.gz**

The files are processed to serve as low-complexity "genomes" used for soaking low-complexity short reads

1. hg19.DACblacklist.chr.parsed.fa.gz
2. hg19.Dukeblacklist.chr.parsed.fa.gz
3. hg19.rmsk.chr.parsed.fa.gz

----
## changelog
* 03-12-2014: RepeatSoaker repo is online
