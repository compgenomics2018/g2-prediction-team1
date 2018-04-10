#!/bin/bash

###################################                                             
# Notice:                                                                       
# 1. This script is used to run infernal cmscan on a single sample fasta file           
# 2. This script need to be used within the same directory as the input file
# 3. cm model RF01400.cm is already available in /projects/data/team1_GenePrediction/bin/infernal-1.1.2/cm/
# 4. The output file will be named input_file_name.aragorn.gff in ncRNA_output/export PATH=$PATH:/projects/data/team1_GenePrediction/bin/infernal-1.1.2/src
###################################

mkdir -p ncRNA_output

test ! $1 && printf "\nplease specify input fasta file\nExample: $0 sample_assembly.fasta\n\n" && exit 1;

printf "\n[infernal]running infernal cmscan...\n"

# trash default report and output table format
cmscan --fmt 2 --tblout "ncRNA_output/infernal_output.tblout" $2 $1 > trash.cmscan
rm trash.cmscan

printf "\n[infernal]finish infernal cmscan...\n"
printf "\n[infernal]converting output to gff3...\n"

awk '{if (substr($0, 0, 1) != "#" && $19 == "!" ) printf "%s\t%s\t%s\t%d\t%d\t%.5f\t%s\t%s\ttarget name=%s, accession=%s\n",$4,"Infernal-1.1.2","sRNA",$10,$11,$18,$12,".",$2,$3}' "ncRNA_output/infernal_output.tblout"  > ncRNA_output/infernal_output.temp
awk '{ if( $4 > $5) {t=$5; $5=$4; $4=t; print} else {print} }' ncRNA_output/infernal_output.temp > ncRNA_output/output.infernal.gff
sed -i 's/ /\t/g' "ncRNA_output/output.infernal.gff"

rm ncRNA_output/infernal_output.tblout
rm ncRNA_output/infernal_output.temp
