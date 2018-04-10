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
bash "./run_prodigal.sh" $iopt 

#run GeneMarkS
perl "./run_GeneMarkS.pl" $iopt

#union protein coding genes and output gff
bash "./union_wrapper.sh" > "$DIR/$oopt/$iopt_protein_coding_result.gff"
rm prodigal.gff
rm genemark.gff

#output union fna and faa format
perl  "./gff_to_fasta.pl -i $iopt_protein_coding_result.gff -p prodigal.fna.reformatted -g genemark.gff.fnn -o $DIR/$oopt/$iopt_protein_coding_result.fna"
perl  "./gff_to_fasta.pl -i $iopt_protein_coding_result.gff -p prodigal.faa.reformatted -g genemark.gff.faa -o $DIR/$oopt/$iopt_protein_coding_result.faa"
rm prodigal.fna
rm prodigal.faa
rm genemark.gff.fnn
rm genemark.gff.fna

#run ncRNA prediction and get merged gff output
bash "./get_ncRNA.sh" $iopt
mv "$iopt.ncRNA.gff" "$DIR/$oopt"

exit;
