# Currently requires assemblies to be in a directory called "assemblies".  Place script next to the assemblies directory to run. 

mkdir output nucleotide protein log 2> /dev/null;

for file in assemblies/*; do
    base=`echo $file | awk -F'[/.]' '{print $2}'`;
    echo "Running Prodigal on $base";
    Prodigal -i $file -f gff -o output/"$base"_Prodigal.gff -d nucleotide/"$base"_Prodigal.nucleotide.fa -a protein/"$base"_Prodigal.protein.fa 2> log/"$base"_Prodigal.txt;
    echo "Finished $base on `date`";
done

echo "done!";
exit
