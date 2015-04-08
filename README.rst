RepeatSoaker: clean NGS data by filtering out reads overlapping low-complexity regions
==========================================================================================

RepeatSoaker removes reads overlapping low-complexity (repeat) regions from aligned sequencing data. Although RepeatSoaker removes ~3% of the reads, it helps to emphasize the biological signals within the data (manuscript submitted), reflected by more significant p-values of gene ontology and pathway enrichment analyses (for RNA-seq data), and motif enrichment analyses (for ChIP-seq data).

Input
------

- A **coordinate sorted** .bam file, obtainable  with

.. code-block:: bash

    samtools sort <in.bam> <in.coordsorted>
    picard-tools SortSam INPUT=<in.bam> OUTPUT=<in.coordsorted.bam> SORT_ORDER=coordinate

Output
--------

- A .bam file with reads overlapping low complexity regions at a given threshold filtered out

Installation
============

1. Install `bedtools <https://github.com/arq5x/bedtools2>`_.

2. Clone `RepeatSoaker  <https://github.com/mdozmorov/RepeatSoaker>`_
in your program folder.

.. code-block:: bash

    git clone https://github.com/mdozmorov/RepeatSoaker.git

3. Run 

.. code-block:: bash

    make mappability
    make clean

to generate (once) the ``DukeMappability.hg19.bed`` and ``DacMappability.hg19.bed`` files containing genomic coordinates of blacklisted regions that should be avoided due to mappability issues (generated using ``make mappability``). Other tracks that may be used with RepeatSoaker include the ``rmsk.hg19.bed`` and ``rmsk.mm9.bed`` files containing genomic coordinates of low complexity regions, as defined by the `RepeatMasker  <http://www.repeatmasker.org/>`_
program (generated with ``make rmsk`` command). Other options include using Retroposed Genes V5, Including Pseudogenes track (``ucscRetroAli5.hg19.bed`` file, generated using ``make retrogenes``), Database of Genomic Variants: Structural Variation (CNV, Inversion, In/del) (``dgvMerged.hg19.bed`` file, generated using ``make dgv``), and Segmental Dups - Duplications of >1000 Bases of Non-RepeatMasked Sequence (``genomicSuperDups.hg19.bed`` file, generated using ``make superdups``).

Usage
======

Run ``repeat-soaker`` script directly

.. code-block:: bash

    ./repeat-soaker -r <rmsk.bed> -o <out.soaked.bam> <in.coordsorted.bam>

Tips
----

Using more rigorous filtering threshold helps to improve the significance of the biological signals. Use ``-p 0`` flag to test it.

Support
========

Contact Mikhail Dozmorov at first_name.last_name@gmail.com.
