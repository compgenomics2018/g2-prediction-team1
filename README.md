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
