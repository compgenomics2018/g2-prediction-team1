# g2-prediction-team1

## wrapper script genePrediction.sh usage
Add to your PATH:
Prodigal
Infernal/src
Infernal/cm
Aragorn/bin
Rnammer/bin

Using the full path to gsmn.pl, create an alias for gsmn.pl in order to run GenemarkS.

Go here and select GeneMarkS and linux64, and download the gm_key_64: http://opal.biology.gatech.edu/GeneMark/license_download.cgi
copy this "key" to your home directory: 
$gunzip gm_key_64.gz
$cp gm_key_64 ~/.gm_key

User must have input files in the current directory and union.sh in the current directory. Output directory will be created upon running the program.

command:
chmod u+x genePrediction.sh
./genePrediction.sh -i <input_file> -o <output_file> -h <help>


## run_gmhmm.pl usage
before using:
this script should run under the path where the asseblied genomes are.

`prompt> perl run_gmhmm.pl list.txt`

*list.txt is a intermediate file which you can rename it whatever you want. It will contain a list of all the names of asseblied genomes under this path.*

## run_GeneMarkS.pl usage
`prompt> perl run_GeneMarkS.pl <input.fasta>`
*<input.fasta> should be the nucleotide sequences in fasta format.*

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
