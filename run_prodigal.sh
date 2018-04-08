#!/bin/bash

mkdir Prodigal_out 2> /dev/null;

File=$1;

echo "Running Prodigal on $File" > Prodigal_out/"$File".prodigal.txt;
Prodigal -i $File -f gff -o Prodigal_out/"$File".prodigal.gff -d Prodigal_out/"$File".prodigal.fna -a Prodigal_out/"$File".prodigal.faa;
echo "Finished $File on `date`" >> Prodigal_out/"$File".prodigal.txt;

python reformatFasta.py Prodigal_out/"$File".prodigal.fna;
python reformatFasta.py Prodigal_out/"$File".prodigal.faa;

exit
