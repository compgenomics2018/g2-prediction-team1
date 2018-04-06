#!/usr/bin/bash

intersect () {
	bedtools intersect -f 0.80 -r -s -a $1 -b $2 > "intersect.gff"  ##find intersection of the results between 2 tools with 99% coverage using bedtools  	
}

intersect "prodigal_output.gff" "genemarkS_output.gff" 


coverage () {  ##calculate the coverage of each tool in order to find the best tool
	bedtools intersect -f 0.80 -r -s-a $1 -b $2 > "overlap_$1_$2"
	matching=$(cat "overlap_$1_$2" | wc -l) ##count for the number of matching gene between the result of a tool and the merged result
	total_gene=$(cat $2 | wc -l) ##count the number of total genes after merging
	coverage=$(echo $(((matching * 100) / total_gene)) | bc) ##calculate the coverage for one genome
	echo "$3 matching to intersect: $matching" > "$3_report.txt"
	echo "$3 total gene predicted: $total_gene" >> "$3_report.txt"
	echo "$3 coverage: $coverage%" >> "$3_report.txt"
}

coverage "intersect.gff" "prodigal_output.gff" "prodigal"
coverage "intersect.gff" "genemarkS_output.gff" "genemarkS"

rm overlap* ##remove processing files
