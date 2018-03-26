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

if [ -d $oopt ] #this checks if the output directory already exists
then
    :
else
    mkdir $oopt
fi

DIR=$(pwd); #this captures the main working directory as the variable DIR

#we will assume that a person running this script will be in their home directory on the server and have the assembly file(s) in that same directory

#run Prodigal
prodigal -i $iopt -f gff -o "$oopt/prodigal_output.gff" -d "$oopt/prodigal_nucleotide.fa" -a "$oopt/prodigal_protein.fa" 

#run GeneMarkHMM
#perl "/projects/data/team1_GenePrediction/bin/genemark_suite_linux_64/gmsuite/gmhmmp.pl" --output genemark_output.GFF --format GFF $iopt  #not working yet

#run Aragorn
#for running aragorn, the aragorn script itself must be in the same directory as this script
cd /projects/data/team1_GenePrediction/bin/aragorn1.2.38/ #we change into the directory containing aragorn
./aragorn -t "$DIR/$iopt" -o "$DIR/$oopt/aragorn_output"
cd ..

#run Infernal
bash run_internal.sh $iopt $oopt 

#run RNAmmer
#validate outputs
    #to do this, just run validation.sh and have the prodigal output and genemark output in the same directory as well
exit;
