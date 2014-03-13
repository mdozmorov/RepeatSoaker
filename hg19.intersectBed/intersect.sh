#/usr/bin/bash
for f1 in *.bed
do
	for f2 in *.bed
	do
		echo $f1,$f2": "`intersectBed -wa -u -a $f1 -b $f2 | wc -l`
	done
done
