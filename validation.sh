#!/usr/bin/bash

ls *Prodigal* > prodigal_list.txt
ls *HMM* > hmm_list.txt
##ls *glimmer* > glimmer_list.txt

intersect () {
	i=0
	exec 3<"$1"   ##read two files line by line into 2 arrays, in order to read two files at the same time
	exec 4<"$2"
	while read value1 <&3
	do
	read value2 <&4
	array1[$i]=$value1
	array2[$i]=$value2
	i=$(($i +1))
	done
	
	for ((j=0;j<=$(($i-1));j+=1)) ##iterate through the array to get the file name from file name list
	do
	bedtools intersect -f 0.99 -r -a ${array1[$j]} -b ${array2[$j]}> "overlap_${array1[$j]}_${array2[$j]}"  ##find intersection of the results between 2 tools with 99% coverage using bedtools  	
	done
}


intersect "prodigal_list.txt" "hmm_list.txt"
##intersect "prodigal_list.txt" "glimmer_list.txt"
##intersect "glimmer_list.txt" "hmm_list.txt"

combine_result () {            ##combining the result from the three comparisons above
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
	
	for ((j=0;j<=$(($i-1));j+=1))
	do
	cat "overlap_${array1[$j]}_${array2[$j]}" >> "combined_${array3[$j]}.gff"	
	done
}
##combine_result "prodigal_list.txt" "glimmer_list.txt" "genome.txt"
combine_result "prodigal_list.txt" "hmm_list.txt" "genome.txt"
##combine_result "glimmer_list.txt" "hmm_list.txt" "genome.txt"

merge_result () {                ##merging the result, get rid of duplicate
	while read line 
	do 
	bedtools merge -d -200 -i "combined_$line.gff" > "merged_$line.gff"
	done < $1 
}

merge_result genome.txt
rm overlap*

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
	##echo "$3 matching: $matching"
	##echo "$3 total_gene: $total_gene"
	echo $coverage >> "$3_report.txt"
	done
}
ls merged*.gff > merged_list.txt
coverage "merged_list.txt" "prodigal_list.txt" "prodigal"
##coverage "merged_list.txt" "glimmer_list.txt" "glimmer"
coverage "merged_list.txt" "hmm_list.txt" "gmhmm"

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
rm overlap*  ##remove processing file
rm combined*  ##remove processing file