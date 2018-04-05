# g2-prediction-team1

## wrapper script genePrediction.sh usage
Add to your PATH:
GenemarkS
Prodigal
Infernal/src
Infernal/cm
Aragorn/bin
Rnammer/bin

Go here and select GeneMarkS and linux64, and download the gm_key_64: http://opal.biology.gatech.edu/GeneMark/license_download.cgi
copy this "key" to your home directory: 
$gunzip gm_key_64.gz
$cp gm_key_64 ~/.gm_key

User must have input files in the current directory and union.sh in the current directory. Output directory will be created upon running the program.

command:
chmod u+x genePrediction.sh
./genePrediction.sh -i <input_file> -o <output_file> -h <help>
