#!usr/bin/bash

for gff in /projects/data/team1_GenePrediction/finalResults/union_latest/*
do
	filename=`basename $gff`
	SRRID=${filename%.*}
	fasta_prodigal="/projects/data/team1_GenePrediction/Prodigal_output_all/protein/$SRRID.protein.fa.reformatted"
	fasta_genemark="/projects/data/team1_GenePrediction/GeneMark_HMM_output/final_protein_fasta/$SRRID.sspace.final.scaffolds.fasta.HMM.protein.fasta.reformatted"
	#ls $gff
	#ls $fasta_prodigal
	#ls $fasta_genemark
	output_fasta="/projects/data/team1_GenePrediction/final_results_Apr_5th/$SRRID.faa"
	/projects/data/team1_GenePrediction/validation/g2-prediction-team1/gff_to_fasta.pl -i $gff -p $fasta_prodigal -g $fasta_genemark -o $output_fasta

done
