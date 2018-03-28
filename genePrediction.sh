#!/bin/bash
export PATH=/projects/data/team1_GenePrediction/bin/Prodigal/:$PATH # Prodigal PATH                                                                                                  
export PATH=/projects/data/team1_GenePrediction/bin/infernal-1.1.2/src/:$PATH # Infernal PATH                                                                                        
export PATH=/projects/data/team1_GenePrediction/bin/Prodigal/rnammer1.2:$PATH # RNAmer PATH                                                                                          
export PERL5LIB=/projects/data/team1_GenePrediction/bin/rnammer1.2/XML-Simple-2.24/lib:$PERL5LIB  # RNAmer PATH                                                                      
export PERL5LIB=/projects/data/team1_GenePrediction/bin/rnammer1.2/hmmer-2.3.2/Perl4-CoreLibs-0.004/lib:$PERL5LIB  # RNAmer PATH   
export PATH=/projects/data/team1_GenePrediction/bin/bedtools2-master/bin:$PATH # Bedtools PATH


#this is the usage message that displays when no input is passed or when -h is passed
usage="Gene Prediction Pipeline. Command line options:	
-i Input assembly file
-o Output directory 
-h usage information "

#we will assume that a person running this script will be in their home directory on the server and have the assembly file(s) in that same directory

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
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#run Prodigal
prodigal -i $iopt -f gff -o "$oopt/prodigal_output.gff"

#run GeneMarkS
cd /projects/data/team1_GenePrediction/bin/genemark_suite_linux_64/gmsuite/
perl gmsn.pl --prok --output "$DIR/$oopt/genemarkS_output.gff" --format GFF "$DIR/$iopt"
cd $DIR   #moving us back to current directory

#run Aragorn
cd /projects/data/team1_GenePrediction/bin/aragorn1.2.38/ #we change into the directory containing aragorn
./aragorn -t "$DIR/$iopt" -o "$DIR/$oopt/aragorn_output"
cd $DIR

#run Infernal
cmscan --tblout "$oopt/`basename $iopt`.RF01400.cm.tblout" --fmt 2 "/projects/data/team1_GenePrediction/bin/infernal-1.1.2/cm/RF01400.cm" $iopt > trash.cmscan
`rm trash.cmscan`

#run RNAmmer
#echo $iopt > file_list_RNAmmer
#perl $SCRIPT_DIR/run_rnammer.pl -i file_list_RNAmmer -d `dirname $iopt`
#rm file_list_RNAmmer
#mv *fsa* $oopt
perl $SCRIPT_DIR/run_rnammer.pl $DIR $oopt 1

#validate outputs
#to do this, just run validation.sh and have the prodigal output and genemark output in the same directory as well
cd $oopt
mv prodigal_output.gff "/projects/data/team1_GenePrediction/validation/"
mv genemarkS_output.gff "/projects/data/team1_GenePrediction/validation/"
mv **.gff "/projects/data/team1_GenePrediction/validation/"
mv **.fasta "/projects/data/team1_GenePrediction/validation/"
mv **.tblout "/projects/data/team1_GenePrediction/validation/"
cd "/projects/data/team1_GenePrediction/validation/"
bash validation_wrapper.sh
bash union_wrapper.sh > "$DIR/$oopt/protein_coding_result.gff"
rm prodigal_output.gff
rm genemarkS_output.gff
cd $DIR

#we need to add the gff to fasta file (but we need to keep both the .gff and the .fa files)
#cp $iopt "/projects/data/team1_GenePrediction/bin/genemark_suite_linux_64/gmsuite/"
#cd $oopt
#cp protein_coding_result.gff "/projects/data/team1_GenePrediction/bin/genemark_suite_linux_64/gmsuite/"
#cd "/projects/data/team1_GenePrediction/bin/genemark_suite_linux_64/gmsuite/"
#perl GFF2fasta.pl -i protein_coding_result.gff -a $iopt -o protein_coding_result.fasta 
#here we need to delete the extra files (prodigal files, genemark files, and any temporary files that we don't need)
#the only output should be the merged file from the validation script (protein_coding_result.fasta, protein_coding_result.gff) and the ncRNA output files (gff and fasta form)
exit;
