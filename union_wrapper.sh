#!/usr/bin/bash

intersect () {
	bedtools intersect -f 0.80 -r -s -wa -a $1 -b $2 > "intersect.gff"  ##find intersection of the results between 2 tools with 99% coverage using bedtools  	
}

intersect "prodigal.gff" "genemark.gff" 


complement () {  ##calculate the coverage of each tool in order to find the best tool
	bedtools intersect -f 0.80 -r -wa -s -v -a $1 -b $2 > "$3_complement.gff"
}

complement "prodigal.gff" "intersect.gff" "prodigal"
complement "genemark.gff" "intersect.gff" "genemarkS"

union (){
	cat $1 $2 $3 > "union.gff"
}
union "prodigal_complement.gff" "genemarkS_complement.gff" "intersect.gff" 
rm *complement.gff
rm intersect.gff
