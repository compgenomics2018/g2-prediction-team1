#!/bin/bash

#this is the usage message that displays when no input is passed or when -h is passed
usage="Gene Prediction Pipeline. Command line options:	
-i Input assembly file
-o Output directory 
-h usage information "

if [ $# == 0 ] ; then	#if nothing is input, then usage message is printed and the script exits
    echo $usage
    exit;
fi

while getopts "i:o:h" opt; 
do
    case $opt in
    i) iopt=$OPTARG;;   
    o) oopt=$OPTARG;;
    c) cm_path=$OPTARG;;
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

DIR=$(pwd); 

#run Prodigal
prodigal -i $iopt -f gff -o "prodigal_output.gff"

#run GeneMarkS
perl gmsn.pl --prok --output "genemarkS_output.gff" --format GFF "$DIR/$iopt"


#####run Aragorn#####

mkdir temp_afasta;

for file in $iopt;
	do
	./aragorn -t -fasta $file > temp_afasta/$(basename "$file").out; # if aragorn is in PATH, change ./aragorn to aragorn
	done

for file in temp_afasta/*;
	 do
	 	python crisis.py $file ; 
	done
 
mv temp_afasta/*.gff3 $oopt;

rm -r temp_afasta;

#######################



#run Infernal
cmscan --tblout "$oopt/`basename $iopt`.tblout" --fmt 2 $cm_path $iopt > trash.cmscan
`rm trash.cmscan`

#run RNAmmer
perl run_rnammer.pl $DIR $oopt 1

#validate outputs
bash validation_wrapper.sh
bash union_wrapper.sh > "$DIR/$oopt/protein_coding_result.gff"
rm prodigal_output.gff
rm genemarkS_output.gff

exit;
