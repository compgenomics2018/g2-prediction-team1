#!/usr/bin/perl -w
#######################
#before using:
#this script should run under the path where the asseblied genomes are.
# useage: perl run_gmhmmp.perl <input.fasta>
# <input.fasta> should be the nucleotide sequences in fasta format.
#######################

use strict;

my $filename = ();
#input file
$filename = $ARGV[0];
#open file
chomp $filename;
#run GeneMarkhmm, you can replace the command line in ``
`gmsn.pl --prok --output genemark.gff --format GFF --fnn --faa $filename`;
#remove intermediate files
`rm *.mod gms.log`
