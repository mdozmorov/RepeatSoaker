RepeatSoaker: a simple method to eliminate low-complexity short reads
======================================================================

RepeatSoaker pipeline removes low-complexity short reads (repeat reads) from
aligned sequencing data.

Installation
=============

RepeatSoaker is written in Python3 and is dependent on `BioTK <https://github.com/gilesc/BioTK>`_ functionality. First, ensure you have *python3* installed, then install BioTK:

.. code-block:: bash

    git clone https://github.com/gilesc/BioTK.git
    sudo apt-get install pkg-config python3-pandas python3-numpy python3-scipy libhdf5-dev mdbtools-dev
    pip3 install patsy
    pip3 install -r requirements.txt
    sudo python3 setup.py install 

Then, install RepeatSoaker, which uses the pysam module.

.. code-block:: bash

   sudo pip3 install pysam
   git clone https://github.com/mdozmorov/RepeatSoaker.git

Usage
=====

Obtain organism-specific genomic coordinates of low-complexity regions in .BED format. 

.. code-block:: bash

    make rmsk
	make clean

This will generate the *rmsk.hg19.bed* and *rmsk.mm9.bed* files. (TODO: better automation)
	
Run RepeatSoaker.py directly on a **name sorted** BAM file.

.. code-block:: bash

   sudo pip3 install pysam
   git clone https://github.com/mdozmorov/RepeatSoaker.git
   (optional: sort a file by name) samtools sort -n <in.bam> <out.prefix>
   cat <in.namesorted.bam> | python3 /path/to/RepeatSoaker.py - -r <lowcomplexity.bed> -p <%overlap> > <out.filtered.bam>

Example: cat experiment1.bam | python3 RepeatSoaker.py - -r rmsk.hg19.bed -p 85 > experiment1.f.bam

This will use *rmsk.hg19.bed* file to obtain genomic coordinates of low complexity regions identified by RepeatMasker and filter *experiment1.bam* alignments/whole reads [#] overlapping with low complexity regions >85%. The results are outputted into *experiment1.f.bam* file.

Changelog
=========

- 03-14-2014: Branch python now contains implementation of RepeatSoaker through masking algorithm
- 03-12-2014: RepeatSoaker repo is online

.. [#] A read can have multiple alignments in the genome. RepeatMasker treats each alignment separately, and removes only those satisfying overlap with low complexity regions percentage. If all read-specific alignments overlap with low complecity regions, the whole read is removed.