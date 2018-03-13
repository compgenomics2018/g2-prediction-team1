#!/usr/bin/perl -w
use strict;

#for now, run file as perl Validation.pl Prodigal_file GeneMarkHMM_file Glimmer_file

my ($filenames, $file1, $file2, $file3, @prod, @hmm, @glim, $line1, $line2, $line3, $start1, $start2, $start3, $stop1, $stop2, $stop3);
my (@line1_split, @line2_split, @line3_split, %prod_genes, %hmm_genes, %glim_genes);
my $val;
my $gene_num = 0;
($filenames) = @ARGV;	#@ARGV is the input from the command line
chomp $filenames;	#cuts the newline character from the input
$file1 = $ARGV[0];	#Prodigal file
$file2 = $ARGV[1];	#GeneMarkHMM file
$file3 = $ARGV[2];	#Glimmer file

open(FILE, $file1);	#opening the files..
@prod = <FILE>;
open(FILE, $file2);
@hmm = <FILE>;
open(FILE, $file3);
@glim = <FILE>;

#for prodigal (gff 3): 
	#for lines starting with Contig... column 4 (start), column 5 (stop), column 7 (strand)

#for HMM (gff 2):
	#for lines starting with NZ_... column 4 (start), column 5 (stop),  column 7 (strand)

#for Glimmer:
	#for all lines... column 5 (start), column 4 (stop), column 7 (strand)

#We want to count the number of exact matches (same start and stop position) as well as the number of end matches (same stop position)


foreach $line1(@prod){	#going through the lines of the Prodigal file
	chomp $line1;	#removing newline character from each line
	if ($line1 =~ /^Contig/){
		$gene_num += 1;	#we probably need a better way to specify genes, but this is a first start | if we just compare all genes from 1 tool against all genes from another tool, it shouldn't matter too much though
		@line1_split = split("\t", $line1);
		$start1 = $line1_split[3];
		$stop1 = $line1_split[4];
		$prod_genes{$gene_num}{"start"} = $start1;	#this stores the start value for the 1st gene (and then so on..) found by Prodigal
		$prod_genes{$gene_num}{"stop"} = $stop1;	#same with stop position
	}
}

##this is to test if your output looks ok##
# foreach $val(sort(keys %prod_genes)){	#these are not sorted 100% correctly but its fine for testing the output
# 	print $val, "\t", $prod_genes{$val}{"start"}, "\t", $prod_genes{$val}{"stop"}, "\n";
# }

$gene_num=0;
foreach $line2(@hmm){	#going through the lines of the Prodigal file
	chomp $line2;	#removing newline character from each line
	if ($line2 =~ /^NZ_/){
		$gene_num += 1;	#we probably need a better way to specify genes, but this is a first start | if we just compare all genes from 1 tool against all genes from another tool, it shouldn't matter too much though
		@line2_split = split("\t", $line2);
		$start2 = $line2_split[3];
		$stop2 = $line2_split[4];
		$hmm_genes{$gene_num}{"start"} = $start2;	#this stores the start value for the 1st gene (and then so on..) found by Prodigal
		$hmm_genes{$gene_num}{"stop"} = $stop2;	#same with stop position
	}
}

$gene_num=0;
foreach $line3(@glim){	#going through the lines of the Prodigal file
	chomp $line3;	#removing newline character from each line
	$gene_num += 1;	#we probably need a better way to specify genes, but this is a first start | if we just compare all genes from 1 tool against all genes from another tool, it shouldn't matter too much though
	@line3_split = split("\t", $line3);
	$start3 = $line3_split[3];
	$stop3 = $line3_split[4];
	$glim_genes{$gene_num}{"start"} = $start3;	#this stores the start value for the 1st gene (and then so on..) found by Prodigal
	$glim_genes{$gene_num}{"stop"} = $stop3;	#same with stop position
}
