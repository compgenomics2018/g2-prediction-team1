#!/usr/bin/bash

#convert aragorn fasta files to gff, containing 1,2,4,5 (name, source, start, stop)

for file in /projects/data/team1_GenePrediction/Aragorn_output/Fasta_only/*.out; 
	do 
grep ">" $file | awk '{ print $1,"Aragorn", $2 }'| sed 's/,/\t/g' | sed 's/^.//' | sed 's/.$//' | tr -d 'c['| tr ' ' \\t >> /projects/data/team1_GenePrediction/Aragorn_output/Aragorn_gff/$(basename "$file").gff; 
	done

