# g2-prediction-team1

## run_gmhmm.pl usage
before using:
this script should run under the path where the asseblied genomes are.

`prompt> perl run_gmhmm.pl list.txt`

*list.txt is a intermediate file which you can rename it whatever you want. It will contain a list of all the names of asseblied genomes under this path.*


## run_rnammer.pl usage
Command:
./run_rnammer.pl <input_directory> <output_directory> <number of input files you want to run>

Compare to run_rnammer_new.pl, this script is more convenient to use when you don't have the name list of the files, or when you don't want to run all the files at once.

## run_rnammer_new.pl usage
Command:
./run_rnammer_new.pl -i <test_file_list> -d <input_directory>

## run_aragorn.sh usage
Command:
./run_aragorn.sh -i <input directory> -o <output directory>

## run_prodigal usage


## wrapper.sh usage
Add these to .bashrc before running the script:
export PATH=$PATH:/projects/data/team1_GenePrediction/bin/Prodigal
export PATH=$PATH:/projects/data/team1_GenePrediction/bin/bedtools2-master/bin
export PATH=$PATH:/projects/data/team1_GenePrediction/bin/infernal-1.1.2/src/                                                                                    
export PATH=$PATH:/projects/data/team1_GenePrediction/bin/Prodigal/rnammer1.2                                                                                     
export PERL5LIB=/projects/data/team1_GenePrediction/bin/rnammer1.2/XML-Simple-2.24/lib:$PERL5LIB                                                                   
export PERL5LIB=/projects/data/team1_GenePrediction/bin/rnammer1.2/hmmer-2.3.2/Perl4-CoreLibs-0.004/lib:$PERL5LIB

Go here and select GeneMarkS and linux64, and download the gm_key_64: http://opal.biology.gatech.edu/GeneMark/license_download.cgi
copy this "key" to your home directory: 
$gunzip gm_key_64.gz
$cp gm_key_64 ~/.gm_key

*need to have info about aliases for GeneMark, RNAmmer, and Aragorn
*need to have info about adding Infernal models

User must have input files in the current directory and union.sh in the current directory. Output directory will be created upon running the program.

command:
./genePrediction.sh -i <input_file> -o <output_file> -h <help>
