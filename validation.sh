#!/usr/bin/bash

ls *Prodigal*.gff > prodigal_list.txt
ls *HMM*.gff > hmm_list.txt

intersect () {
	i=0
	exec 3<"$1"
	exec 4<"$2"
	exec 5<"$3"
	while read value1 <&3
	do
	read value2 <&4
	read value3 <&5
	array1[$i]=$value1
	array2[$i]=$value2
	array3[$i]=$value3
	i=$(($i +1))
	done
	
	for ((j=0;j<=$(($i-1));j+=1)) ##iterate through the array to get the file name from file name list
	do
	bedtools intersect -f 0.99 -r -a ${array1[$j]} -b ${array2[$j]}> "intersect_${array3[$j]}.gff"  ##find intersection of the results between 2 tools with 99% coverage using bedtools  	
	done
}


intersect "prodigal_list.txt" "hmm_list.txt" "genome.txt"
ls intersect*.gff > intersect_list.txt


coverage () {  ##calculate the coverage of each tool in order to find the best tool
	i=0
	exec 3<"$1"
	exec 4<"$2"
	while read value1 <&3
	do
	read value2 <&4
	array1[$i]=$value1
	array2[$i]=$value2
	i=$(($i +1))
	done
	
	for ((j=0;j<=$(($i-1));j+=1))
	do
	bedtools intersect -f 0.99 -r -a ${array1[$j]} -b ${array2[$j]} > "overlap_${array1[$j]}_${array2[$j]}"
	matching=$(cat "overlap_${array1[$j]}_${array2[$j]}" | wc -l) ##count for the number of matching gene between the result of a tool and the merged result
	total_gene=$(cat ${array2[$j]} | wc -l) ##count the number of total genes after merging
	coverage=$(echo $(((matching * 100) / total_gene)) | bc) ##calculate the coverage for one genome
	##echo "$3 coverage: $coverage"
	echo -e "${array2[$j]}\t\t\t$matching\t\t\t$total_gene" >> "$3_stareport.txt"
	##echo "${array2[$j]} total_gene: $total_gene" 
	echo $coverage >> "$3_report.txt"
	done
}

coverage "intersect_list.txt" "prodigal_list.txt" "prodigal"
coverage "intersect_list.txt" "hmm_list.txt" "gmhmm"

average (){
	while read line 
	do 
	counting=0
	total_coverage=0
	let "counting++" ##keep tract of the number of genome
	let "total_coverage += $line" ##add up the coverage for all genome
	ave=$(echo $((total_coverage / counting)) | bc) ##find the average coverage for a tool
	done < $1 
	echo "coverage for $2: $ave%" >> report.txt
}
average "prodigal_report.txt" "prodigal"
average "gmhmm_report.txt" "gmhmm"

rm overlap* ##remove processing files