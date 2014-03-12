#!/usr/bin/python
import gzip
from random import choice
from collections import namedtuple
import sys
## ==================================================================
## Converts gzipped FASTA file with sequences into contiguous chromosome-specific
##  sequences, interspersed with random sequences. Output into stdout
##
## Usage: python repeatSoaker.py [filename.fa.gz] | sed '1d' > [filenameOut.fa]
## ==================================================================

FASTA = namedtuple("FASTA", "key seq") # Generator to keep 
# SEQ = ['A', 'T', 'C', 'G']
SEQ = ['a', 't', 'c', 'g']

def read_fasta(handle): # Returns record-specific sequences
	key = None # Initialize record variable
	for line in handle: # Go through each line in FASTA file
		if line.strip() == '': # Special case - if EOF, force return of the last pair
			yield FASTA(key, seq)
		if line.startswith(">"): # For each record starting with ">"
			if key: # If new record
				yield FASTA(key, seq) # Return previous record-sequence pait
			key = line.strip()[1:] # Keep current record
			seq = "" # Empty sequence variable
		else: # If current record continues, just new line with sequence,
			seq += line.strip() # Accumulate sequence

			
def random_seq(n = 5): # Random sequence generator
	random_seq=""
	for i in range(0, n):
		random_seq += choice(SEQ)
	return random_seq

with open(sys.argv[1], 'rt') as h: # If gzipped is needed, use gzip.open
	curr_key = None
	for record in read_fasta(h):
		#print record.key
		#print record.seq
		if record.key == curr_key:
			sys.stdout.write(record.seq)
			sys.stdout.write(random_seq())
		else:
			sys.stdout.write("\n")
			sys.stdout.write(">")
			sys.stdout.write(record.key)
			sys.stdout.write("\n")
			sys.stdout.write(record.seq)
			sys.stdout.write(random_seq())
			curr_key = record.key
sys.stdout.flush()