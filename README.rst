RepeatSoaker: a simple method to eliminate low-complexity short reads
======================================================================

RepeatSoaker removes alignments overlapping low-complexity (repeat) regions from aligned sequencing data.

Installation
=============

RepeatSoaker is a command line sctipt utilizing `bedtools <https://github.com/arq5x/bedtools2>`_ functionality. Install it from Github

.. code-block:: bash

   git clone https://github.com/mdozmorov/RepeatSoaker.git

The ``repeat-soaker`` script may be executed directly.

Usage
=====

Obtain organism-specific genomic coordinates of low-complexity regions in .BED format. 

.. code-block:: bash

    make rmsk
    make clean

This will generate the ``rmsk.hg19.bed`` and ``rmsk.mm9.bed`` files. (TODO: better automation)
	
Run ``repeat-soaker`` directly on a **coordinate sorted** BAM file.

.. code-block:: bash

    samtools sort <in.bam> <in.coordsorted> OR picard-tools SortSam INPUT=<in.bam> OUTPUT=<in.coordsorted.bam> SORT_ORDER=coordinate
    ./repeat-soaker -r <rmsk.bed> -p 0.85 -o <out.soaked.bam> <in.coordsorted.bam>

Example: ./repeat-soaker -r rmsk.hg19.bed -p 0.85 -o test.soaked.bam test.bam

This will use ``rmsk.hg19.bed`` file to obtain genomic coordinates of low complexity regions identified by RepeatMasker and filter ``test.bam`` alignments/whole reads [#] overlapping with low complexity regions >85%. The results are outputted into ``test.soaked.bam`` file.

Changelog
=========

- 03-21-2014: Bedtools implementation of RepeatSoaker, ``bedtools`` branch
- 03-19-2014: Branches merged, alpha status
- 03-14-2014: Branch python now contains implementation of RepeatSoaker through masking algorithm
- 03-12-2014: RepeatSoaker repo is online

.. [#] A read can have multiple alignments in the genome. RepeatMasker treats each alignment separately, and removes only those satisfying overlap with low complexity regions percentage. If all read-specific alignments overlap with low complecity regions, the whole read is removed.
