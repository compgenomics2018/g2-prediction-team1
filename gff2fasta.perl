#!/usr/bin/perl -w
use strict;
use Getopt::Long;

my $input_gff;
my $input_assembly;
my $output_fasta = "output.fasta";
my $help = 0;

sub usage{
  print "\nUsage:\n";
  print "perl gff2fasta.perl -i [input gff file] -a [input assembly] -o [output fasta name]\n";
}

sub initialize{
  GetOptions(
    'i=s' => \$input_gff,
		'a=s' => \$input_assembly,
    'o=s' => \$output_fasta,
    'h'   => \$help,
  ) or die "Incorrect usage!\n";

  if ($help ne 0) { usage(); exit 1;}
  unless (defined $input_gff && defined $input_assembly) { print "You need to enter the input gff and the input assembly\n";
    usage(); exit 1; }
}

sub doFunction{
  `bedtools getfasta -fi $input_assembly -fo $output_fasta -s -bed $input_gff`
}
initialize();
doFunction();


=put
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
