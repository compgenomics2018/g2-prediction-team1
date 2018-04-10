#!/usr/bin/bash

###################################
# Notice:
# 1. This script is used to run rnammer on a single sample fasta file
# 2. This script need to be used within the same directory as the input file
# 3. The output file will be named input_file_name.rnammer.gff
###################################

mkdir -p ncRNA_output
test ! $1 && printf "\nplease specify input fasta file\nExample: $0 sample_assembly.fasta\n\n" && exit 1;

printf "\n[rnammer]running rnammer... \n"

rnammer -S bac -m lsu,ssu,tsu -gff ncRNA_output/output.rnammer.gff $1
printf "[rnammer]finished running rnammer \n"

# remove extra format information for merging
sed -i '$ d' ncRNA_output/output.rnammer.gff $1
sed -i -e '1,6d' ncRNA_output/output.rnammer.gff $1
