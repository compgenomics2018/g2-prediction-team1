#!/usr/bin/bash

#For running this simple script using Aragorn, the aragorn script itself must be in the same directory as this script
#This script goes through all the folders in a directory and runs aragorn -t and outputs results to previously created directory
#check for the location of the input folders as well as for the output, these are currently hardcoded
# 
# -t =>  searches for tRNA genes
# -o => indicates output file (not used in this script)
# -fasta => Print out primary sequence in fasta format
# -fo => Prints out primary sequence in fasta format only (no secondary structure)


for file in /projects/data/team1_GenePrediction/true_assemblies/*; 
	do 
		./aragorn -t $file > /projects/data/team1_GenePrediction/Aragorn_output/$(basename "$file").out ;
		echo Processing: $file; 
	done
