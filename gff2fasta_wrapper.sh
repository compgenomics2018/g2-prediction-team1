#!/bin/bash

#this is the usage message that displays when no input is passed or when -h is passed
usage="Command line options:	
-i path to directory of input gff files
-o output directory (to be created)
-h usage information"

if [ $# == 0 ] ; then	#if nothing is input, then usage message is printed and the script exits
    echo $usage
    exit;
fi

while getopts "i:o:h" opt; 
do
    case $opt in
    i) iopt=$OPTARG;;   
    o) oopt=$OPTARG;;
	h) echo $usage; exit;
esac
done

for file in $ipot/*;
    do
        gff2fasta_conversion_script > $oopt/$(basename "$file").output
exit;
