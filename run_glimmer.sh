#!/usr/bin/bash

# Add GLIMMER3 executables to PATH:
export PATH="/projects/data/team1_GenePrediction/bin/glimmer3.02/bin/:/projects/data/team1_GenePrediction/bin/glimmer3.02/bin/scripts:$PATH"

inputdir=$1

# Run GLIMMER3 pipeline of gene prediction on assemblies, and save log information in log folder:
`mkdir -p logs`
for file in  $inputdir/*.fa $inputdir/*.fasta; do g3-from-scratch.csh $file `basename $file` >> ./logs/`basename $file`.log; done;

# Convert GLIMMER3 outputs (.predict) to GFF:
`mkdir -p GFF`
for file in ./*.predict; do
        while IFS="     " read -r orfID start stop strand score remainder
        do
                if [[ $orfID = ">"* ]];  then
                        contigID=${orfID:1:${#orfID}}
                else
                        if [[ $strand = "+"* ]]; then
                                echo -e "$contigID\tGLIMMER\tgene\t$start\t$stop\t$score\t${strand:0:1}\tID=$orfID\tORF prediction" >> ./GFF/`basename $file`.gff
                        else
                                echo -e "$contigID\tGLIMMER\tgene\t$stop\t$start\t$score\t${strand:0:1}\tID=$orfID\tORF prediction" >> ./GFF/`basename $file`.gff
                        fi
                fi
        done < $file
done
