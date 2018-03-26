#!/bin/bash

#this is the usage message that displays when no input is passed or when -h is passed
usage="Gene Prediction Pipeline. Command line options:	
-i Input assembly file
-o Output file 
-h usage information "

if [ $# == 0 ] ; then	#if nothing is input, then usage message is printed and the script exits
    echo $usage
    exit;
fi

while getopts "i:o:h" opt;  #colons after certain letters specify that arguments need to follow 
do
    case $opt in
    i) iopt=$OPTARG;;   #stores input after i as aopt
    o) oopt=$OPTARG;;
	h) echo $usage; exit;
esac
done

if [ -e $iopt ]	#this checks if the input file exists
then
	:	#the colon means to "continue"
else
	echo "$iopt: no such file exists"; exit;
fi

if [ -d outputs ]
then
    :
else
    mkdir outputs

cd outputs
if [ -e $oopt ]	#this checks if the output file already exists
then
	echo "$oopt already exists. would you like to overwrite the file or exit the program? (type overwrite or exit) "
	read response
        if [ "$response" == "overwrite" ]
        then
	        rm $oopt #removes existing output file (in output directory) so we can make a new file
        else
	        exit;
fi
fi

#we will assume that a person running this script will be in their home directory on the server and have the assembly file(s) in that same directory

#run Prodigal
Prodigal -i "$iopt" -f gff -o prodigal_output.gff -d prodigal_nucleotide.fa -a prodigal_protein.fa 

#run GeneMarkHMM
perl gmhmmp.pl --output genemark_output.GFF --format GFF "$iopt"

#run Aragorn
./aragorn -t "$iopt" -o outputs/aragorn_output #must make this a directory first

#run Infernal
#run RNAmmer
#validate outputs


