#!/usr/bin/perl -w
use strict;

my @output_list = @ARGV;
for (@output_list){
        s/.fa//;
        s/.fasta//;
}

for (my $i=0; $i<@ARGV;$i++){
    system("rnammer -S bac -m lsu,ssu,tsu -multi -gff $output_list[$i].rnammer.gff -f $output_list[$i].rnammer.fasta < $ARGV[$i]");
    system("grep -v '^[!#]' $output_list[$i].rnammer.gff >> $output_list[$i].gff3");
    system("rm $output_list[$i].rnammer.gff");
}
