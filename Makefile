rmsk:			rmsk.mm9.bed#rmsk.hg19.bed

rmsk.hg19.bed:
				wget http://hgdownload.cse.ucsc.edu/goldenPath/hg19/database/rmsk.txt.gz
				zcat rmsk.txt.gz | awk 'BEGIN {OFS="\t"} {print $$6,$$7,$$8,$$11,".",$$10}' | sort -k1,1 -k2,2n > rmsk.hg19.bed
rmsk.mm9.bed:
				wget http://hgdownload.cse.ucsc.edu/goldenPath/mm9/database/chr1_rmsk.txt.gz
				wget http://hgdownload.cse.ucsc.edu/goldenPath/mm9/database/chr2_rmsk.txt.gz
				wget http://hgdownload.cse.ucsc.edu/goldenPath/mm9/database/chr3_rmsk.txt.gz
				wget http://hgdownload.cse.ucsc.edu/goldenPath/mm9/database/chr4_rmsk.txt.gz
				wget http://hgdownload.cse.ucsc.edu/goldenPath/mm9/database/chr5_rmsk.txt.gz
				wget http://hgdownload.cse.ucsc.edu/goldenPath/mm9/database/chr6_rmsk.txt.gz
				wget http://hgdownload.cse.ucsc.edu/goldenPath/mm9/database/chr7_rmsk.txt.gz
				wget http://hgdownload.cse.ucsc.edu/goldenPath/mm9/database/chr8_rmsk.txt.gz
				wget http://hgdownload.cse.ucsc.edu/goldenPath/mm9/database/chr9_rmsk.txt.gz
				wget http://hgdownload.cse.ucsc.edu/goldenPath/mm9/database/chr10_rmsk.txt.gz
				wget http://hgdownload.cse.ucsc.edu/goldenPath/mm9/database/chr11_rmsk.txt.gz
				wget http://hgdownload.cse.ucsc.edu/goldenPath/mm9/database/chr12_rmsk.txt.gz
				wget http://hgdownload.cse.ucsc.edu/goldenPath/mm9/database/chr13_rmsk.txt.gz
				wget http://hgdownload.cse.ucsc.edu/goldenPath/mm9/database/chr14_rmsk.txt.gz
				wget http://hgdownload.cse.ucsc.edu/goldenPath/mm9/database/chr15_rmsk.txt.gz
				wget http://hgdownload.cse.ucsc.edu/goldenPath/mm9/database/chr16_rmsk.txt.gz
				wget http://hgdownload.cse.ucsc.edu/goldenPath/mm9/database/chr17_rmsk.txt.gz
				wget http://hgdownload.cse.ucsc.edu/goldenPath/mm9/database/chr18_rmsk.txt.gz
				wget http://hgdownload.cse.ucsc.edu/goldenPath/mm9/database/chr19_rmsk.txt.gz
				wget http://hgdownload.cse.ucsc.edu/goldenPath/mm9/database/chrM_rmsk.txt.gz
				wget http://hgdownload.cse.ucsc.edu/goldenPath/mm9/database/chrX_rmsk.txt.gz
				wget http://hgdownload.cse.ucsc.edu/goldenPath/mm9/database/chrY_rmsk.txt.gz
				for file in chr*rmsk.txt.gz; do zcat $$file | awk 'BEGIN {OFS="\t"} {print $$6,$$7,$$8,$$11,".",$$10}' >> rmsk.mm9.bed; done
				sort -k1,1 -k2,2n -o rmsk.mm9.bed rmsk.mm9.bed
clean:
				rm *.txt.gz