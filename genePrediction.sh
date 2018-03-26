#!/bin/bash

#this is the usage message that displays when no input is passed or when -h is passed
usage="Gene Prediction Pipeline. Command line options:	
-i Input assembly file
-o Output file 
-h usage information "

#steps
#run Prodigal
#run GeneMarkHMM
#run Aragorn
#run Infernal
#run RNAmmer
#validate outputs

#we will assume that a person running this script will be in their home directory on the server

