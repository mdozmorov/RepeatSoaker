all:	intersect.txt

.download.complete:
					wget http://hgdownload.cse.ucsc.edu/goldenPath/hg19/database/wgEncodeDacMapabilityConsensusExcludable.txt.gz
					wget http://hgdownload.cse.ucsc.edu/goldenPath/hg19/database/wgEncodeDukeMapabilityRegionsExcludable.txt.gz
					wget http://hgdownload.cse.ucsc.edu/goldenPath/hg19/database/rmsk.txt.gz
					wget http://hgdownload.cse.ucsc.edu/goldenPath/hg19/database/nestedRepeats.txt.gz
					wget http://hgdownload.cse.ucsc.edu/goldenPath/hg19/database/microsat.txt.gz
					wget http://hgdownload.cse.ucsc.edu/goldenPath/hg19/database/simpleRepeat.txt.gz
					touch .download.complete
.bed.complete:		.download.complete
					zcat wgEncodeDacMapabilityConsensusExcludable.txt.gz | cut -f2-6 > DACblacklist.bed
					zcat wgEncodeDukeMapabilityRegionsExcludable.txt.gz | cut -f2-6 > Dukeblacklist.bed
					zcat nestedRepeats.txt.gz | cut -f1-6 > nestedRepeats.bed
					zcat microsat.txt.gz | cut -f1-4 > microsat.bed
					zcat simpleRepeat.txt.gz | cut -f1-4 > simpleRepeats.bed
					zcat rmsk.txt.gz | awk 'BEGIN {OFS="\t"} {print $$6,$$7,$$8,$$11"_"$$12"_"$$13,".",$$10}' > rmsk.bed
					touch .bed.complete
# Submit job to SGE. If no SGE is present, just run ./intersect.sh > intersect.txt			
intersect.txt:		.bed.complete
					qsub -b y -l h_vmem=10G -V -j y -m e -M dozmorovm@omrf.org -cwd -q all.q -N intersect "./intersect.sh > intersect.txt"

clean:
					rm *txt.gz *.bed .download.complete .bed.complete