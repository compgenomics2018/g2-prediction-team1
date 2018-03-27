#!/bin/bash

# this runs infernal's `cmscan` program 
# before using this, add to your path PATH=$PATH:/projects/data/team1_GenePrediction/bin/infernal-1.1.2/src
# --tblout and --fmt write output in a more concise format
# standard cmscan output is all written to trash.cmscan because it is less easily parsed than the
# tblout format and therefore not desirable 

cd /projects/data/team1_GenePrediction/true_assemblies
for f in *.fasta; do

	for cm in  RF01400.cm; do
		sh -c "cmscan --tblout /projects/data/team1_GenePrediction/infernal_output/$f.$cm.tblout --fmt 2 /projects/data/team1_GenePrediction/bin/infernal-1.1.2/cm/$cm $f > trash.cmscan"
	done
done
