#!/bin/bash

#echo "Running Prodigal on $File" > Prodigal_out/"$File".prodigal.txt;
prodigal -i $1 -f gff -o prodigal.gff -d prodigal.fna -a prodigal.faa;
#echo "Finished $File on `date`" >> Prodigal_out/"$File".prodigal.txt;

python reformatFasta.py prodigal.fna;
python reformatFasta.py prodigal.faa;

exit
