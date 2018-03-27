#!/usr/bin/bash

complement () {  ##calculate the coverage of each tool in order to find the best tool
	bedtools intersect -f 0.99 -r -wa -v -a $1 -b $2 > "$3_complement.gff"
}

complement "prodigal_output.gff" "intersect.gff" "prodigal"
complement "genemarkS_output.gff" "intersect.gff" "genemarkS"

union (){
	cat $1 $2 $3 > "union.gff"
}
union "prodigal_complement.gff" "genemarkS_complement.gff" "intersect.gff" 
rm *complement.gff
rm intersect*