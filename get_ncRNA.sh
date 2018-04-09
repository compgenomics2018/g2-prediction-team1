#!/bin/bash

############### This script is for getting merged result of ncRNA prediction

./run_aragorn_single_input.sh $1
./run_infernal_single_input.sh $1
./run_rnammer_single_input.sh $1

cat ncRNA_output/*.gff > ncRNA_output/$1.ncRNA.gff

rm ncRNA_output/*.infernal.gff
rm ncRNA_output/*.rnammer.gff
rm ncRNA_output/*.aragorn.gff
