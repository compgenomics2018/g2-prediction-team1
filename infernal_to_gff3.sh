#!/bin/bash                                                                     

#### This script is for transforming infernal tblout output to gff3 format

# The directory can be changed at any time according to the file location

cd /projects/data/team1_GenePrediction/infernal_output;
mkdir gff3_output;
    
for f in *.tblout; do
	echo "##gff-version 3" > gff3_output/$f.gff;
	awk '{if (substr($0, 0, 1) != "#" && $19 == "!" ) printf "%s\t%s\t%s\t%d\t%d\t%.5f\t%s\t%s\ttarget name=%s, accession=%s\n",$4,"Infernal-1.1.2","sRNA",$10,$11,$18,$12,".",$2,$3}' $f >> gff3_output/$f.gff;

done
