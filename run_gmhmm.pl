#!/usr/bin/perl -w
#######################
#before using:
#this script should run under the path where the asseblied genomes are.
# useage: perl run_gmhmmp.perl list.txt
# list.txt is a intermediate file which you can rename it whatever you want. It will contain a list of all the names of asseblied genomes under this path.
######################

use strict;
#define variables
my $filename = ();
my @SRRname = ();
#input file
$filename = $ARGV[0];
#generate the intermediate file
`ls *fasta* > $filename`
#check file if exit and open file
unless (-e $filename){
    print "This file \"$filename\" do not exit! Please check it!";
    exit;
}
unless (open FILENAME, $filename){
    print "Cannot open this file!!";
    exit;
}

@SRRname = <FILENAME>;
chomp @SRRname;
close FILENAME;
#run GeneMarkhmm, you can replace the command line in ``
foreach my $i (@SRRname){
    `gmhmmp -o $i.HMM.gff -f G -m -A $i.protein.fasta -D $i.nucleotide.fasta /projects/data/team1_GenePrediction/bin/genemark_suite_linux_64/gmsuite/GeneMark_hmm.mod $i`
}
