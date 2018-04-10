#!/usr/bin/bash                                                                 

###################################                                             
# Notice:                                                                       
# 1. This script is used to run aragorn on a single sample fasta file           
# 2. This script need to be used within the same directory as the input file    
# 3. The output file will be named input_file_name.aragorn.gff in ncRNA_output/                  


mkdir -p ncRNA_output

test ! $1 && printf "\nplease specify input fasta file\nExample: $0 sample_assembly.fasta\n\n" && exit 1;

printf "\n\n[aragorn]running aragorn...\n"

aragorn -t -fasta -O ncRNA_output/aragorn.report $1

printf "\n[aragorn]finished running aragorn \n"
printf "\n[aragorn]converting output report to gff...\n\n"

python crisis_single_input.py ncRNA_output/aragorn.report

rm ncRNA_output/aragorn.report


