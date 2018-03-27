#!/usr/bin/perl -w
use strict;

my $input_dir = $ARGV[0];
my $output_dir = $ARGV[1];
my $count=$ARGV[2];#number of files in the directory that you want to run
opendir(DIR,$input_dir) or die "couldn't open directory $input_dir\n";

my @file_list= grep (/\.fa$|\.fasta$/, readdir DIR);
my @output_list = @file_list;
for (@output_list){
	s/.fa//;
	s/.fasta//;
}

if ($count>@file_list){
	print "The directory does not have enough input file\n";
	exit;
}

for (my $i=0; $i<$count;$i++){
	system("rnammer -S bac -m lsu,ssu,tsu -multi -gff $output_dir/$output_list[$i].gff -f $output_dir/$output_list[$i].fasta < $input_dir/$file_list[$i]");
}
closedir(DIR);
