SHELL=/bin/bash

rmsk:			rmsk.hg19.bed rmsk.mm9.bed

mappability:	DukeMappability.hg19.bed DacMappability.hg19.bed

retrogenes:		uscsRetroAli5.hg19.bed

dgv:			dgvMerged.hg19.bed

superdups:		genomicSuperDups.hg19.bed

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

DukeMappability.hg19.bed:
	wget http://hgdownload.cse.ucsc.edu/goldenPath/hg19/database/wgEncodeDukeMapabilityRegionsExcludable.txt.gz
	zcat < wgEncodeDukeMapabilityRegionsExcludable.txt.gz | awk 'BEGIN {OFS="\t"} {print $$2,$$3,$$4,$$5,$$6}' | bedtools sort -i - > $@

DacMappability.hg19.bed:
	wget http://hgdownload.cse.ucsc.edu/goldenPath/hg19/database/wgEncodeDacMapabilityConsensusExcludable.txt.gz
	zcat wgEncodeDacMapabilityConsensusExcludable.txt.gz | awk 'BEGIN {OFS="\t"} {print $$2,$$3,$$4,$$5,$$6}' | bedtools sort -i - > $@

uscsRetroAli5.hg19.bed:
	wget http://hgdownload.cse.ucsc.edu/goldenpath/hg19/database/ucscRetroAli5.txt.gz
	zcat < ucscRetroAli5.txt.gz | awk 'BEGIN {OFS="\t"} {print $$15,$$17,$$18,$$11,".",$$10}' | bedtools sort -i - > $@

dgvMerged.hg19.bed:
	wget http://hgdownload.cse.ucsc.edu/goldenpath/hg19/database/dgvMerged.txt.gz
	zcat < dgvMerged.txt.gz | awk 'BEGIN {OFS="\t"} {print $$2,$$3,$$4,$$5,$$6,$$7}' | bedtools sort -i - > $@

genomicSuperDups.hg19.bed:
	wget http://hgdownload.cse.ucsc.edu/goldenpath/hg19/database/genomicSuperDups.txt.gz
	zcat < genomicSuperDups.txt.gz | awk 'BEGIN {OFS="\t"} {print $$2,$$3,$$4,$$5,$$6,$$7}' | bedtools sort -i - > $@

rmsk.test:
				# https://gist.github.com/gilesc/9607495
				# Need ftp command
				cat <<EOF | ftp
				open hgdownload.cse.ucsc.edu
				anonymous
				mail@your-mail.com
				cd goldenPath/mm9/database
				prompt
				mget chr*rmsk.txt.gz
				bye
				EOF
clean:
				rm *.txt.gz