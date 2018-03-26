#!/usr/bin/perl -w

#######################################
#useage: perl gff2fasta.perl <input_file>
# input_file is a list of all the names of gff files

use strict;
#define variables
my $filename = ();
my @SRRname = ();
#input file
$filename = $ARGV[0];
#check file if exit and open file
unless (-e $filename){
    print "This file \"$filename\" do not exit! Please check it!";
    exit;
}
unless (open FILENAME, $filename){
    print "Cannot open this file!!";
    exit;
}
#
@SRRname = <FILENAME>;
chomp @SRRname;
close FILENAME;
#convert GFF to fasta
foreach my $i (@SRRname){
    `bedtools getfasta -fi ../../../true_assemblies/$i -fo ./$i.hmm.fa -s -bed ./$i.hmm.GFF`
}
