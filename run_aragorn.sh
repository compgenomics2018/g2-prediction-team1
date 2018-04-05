#!/usr/bin/bash

#For running this simple script using Aragorn, the aragorn script itself must be in the same directory as this script
#This script goes through all the folders in a directory and runs aragorn -t and outputs results to previously created directory
#check for the location of the input folders as well as for the output
# 
# -t =>  searches for tRNA genes
# -o => indicates output file (not used in this script)
# -fasta => Print out primary sequence in fasta format
# -fo => Prints out primary sequence in fasta format only (no secondary structure)
#./run_aragorn.sh -i <path to input directory> -o <path to output directory>

echo " "
echo "Starting to run Aragorn..."
echo " "
usage="Command line options:	
-i [path to directory where fasta files are located]
-o [path to directory where the ouput will be ]"

while getopts "a:b:h" opt;  
do
    case $opt in
    i) iopt=$OPTARG;;   #first fasta file
    o) oopt=$OPTARG;;   #second fasta file

esac
done

for file in $iopt/*; 
	do 
		./aragorn -t -fasta $file > $oopt/$(basename "$file").out ;
		echo Processing: $file; 
	done
