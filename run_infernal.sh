#!/bin/bash
export PATH=/projects/data/team1_GenePrediction/bin/infernal-1.1.2/src/:$PATH

file=$1
outdir=$2

cmscan --tblout "$outdir/`basename $file`.RF01400.cm.tblout" --fmt 2 "/projects/data/team1_GenePrediction/bin/infernal-1.1.2/cm/RF01400.cm" $file > trash.cmscan
