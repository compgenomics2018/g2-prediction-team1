#!/usr/bin/bash

complement () {  ##calculate the coverage of each tool in order to find the best tool
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
	bedtools intersect -f 0.80 -r -wa -v -s -a ${array1[$j]} -b ${array2[$j]} > "complement_${array1[$j]}"
	done

	
 
}
complement "prodigal_list.txt" "intersect_list.txt" 
ls complement*Prodigal.gff > "prodigal_complement.txt"

complement "hmm_list.txt" "intersect_list.txt" 
ls complement*HMM.gff > "hmm_complement.txt"


union (){
	i=0
	exec 3<"$1"
	exec 4<"$2"
	exec 5<"$3"
	exec 6<"$4"
	while read value1 <&3
	do
	read value2 <&4
	read value3 <&5
	read value4 <&6
	array1[$i]=$value1
	array2[$i]=$value2
	array3[$i]=$value3
	array4[$i]=$value4
	i=$(($i +1))
	done
	
	for ((j=0;j<=$(($i-1));j+=1))
	do
	cat ${array1[$j]} ${array2[$j]} ${array3[$j]} > "${array4[$j]}.gff"
	done
}
union "prodigal_complement.txt" "hmm_complement.txt" "intersect_list.txt" "genome.txt"
rm complement*
rm intersect*