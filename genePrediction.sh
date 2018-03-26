#!/bin/bash
export PATH=/projects/data/team1_GenePrediction/bin/Prodigal/:/projects/data/team1_GenePrediction/bin/Prodigal/rnammer1.2:$PATH

#this is the usage message that displays when no input is passed or when -h is passed
usage="Gene Prediction Pipeline. Command line options:	
-i Input assembly file
-o Output directory 
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

if [ -d $oopt ]
then
    :
else
    mkdir $oopt
fi

cd ..; #going back to the main directory

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
#Prodigal -i "$iopt" -f gff -o prodigal_output.gff -d prodigal_nucleotide.fa -a prodigal_protein.fa 

#run GeneMarkHMM
perl gmhmmp.pl --output genemark_output.GFF --format GFF "$iopt"    #WE NEED TO ADD THE PATH TO the .pl script

#run Aragorn
#for running aragorn, the aragorn script itself must be in the same directory as this script
#maybe we can change the directory so that we are in the same directory as the Aragorn script, then we can send the output to this directory
#./aragorn -t "$iopt" -o outputs/aragorn_output

#run Infernal
bash run_internal.sh $iopt $oopt 

#run RNAmmer
echo $iopt > file_list_RNAmmer
perl run_rnammer.pl -i file_list_RNAmmer -d `dirname $iopt`
rm file_list_RNAmmer
mv *fsa* $oopt

#validate outputs
    #to do this, just run validation.sh and have the prodigal output and genemark output in the same directory as well
exit;
