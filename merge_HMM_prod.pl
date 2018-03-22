#!/usr/bin/perl -w
use strict;
use Getopt::Std;	#using getopts to take in single character switches


my %opts; #getopts options
my %prod_genes;
my %hmm_genes;
my %glim_genes;

sub usage {
  print "\nHow to run this code:\n";
  print "./validation.pl -p [prodigal gff file] -m [genemark HMM gff file] -g [glimmer gff file] -o [output file name]\n";
  print "The three input files should be the output from the gene prediction tools\n";
	print "All files are mandatory\n";
  print "Use -h to get this message\n\n";
}

sub initialize{
	getopts('p:m:g:o:h', \%opts); #the values in the string are the single character options, and the values are stored in %opts
	#p = prodigal .gff file
	#h = genemarkhmm .gff file
	#g = glimmer .gff file
	#o = output file name

  #check to see if the help message was activated
  if ($opts{h}) { usage(); exit 1;}
  #check for the input files
  unless (defined $opts{p} && defined $opts{m} && defined $opts{g}) { print "You need to enter the input files\n";
    usage(); exit 1; }
	unless (defined $opts{o}) { $opts{o} = "output.gff";}
}

sub openFile{
	my ($filename) = @_;
	open (FILE, "<",  $filename) or die "Can't open the file $filename!!!!\n";
	my @lines;

	#read the lines
	while (<FILE>) {
		chomp $_;
		#put the lines into an array
		push @lines, $_;
	}
	close FILE;
	return @lines;
}

initialize();
my @prod = openFile($opts{p}); #opening prodigal file
my @hmm = openFile($opts{m}); #opening gene mark file

#reading the prodigal file
sub readProdigal{
	#for prodigal (gff 3):
	#lines starting with the contig ID (not '#'): column 4 (start), column 5 (stop), column 7 (strand)
	my $line; #each line string
	my $gene_num=0; #gene counter
	my $seq_num=1;
	my @values; #values of each line
	my $contig_id; #contig identifier;
	my $start; #start position
	my $stop; #stop position

	foreach $line(@prod){	#going through the lines of the Prodigal file
		chomp $line;	#removing newline character from each line
		if ($line !~ /^#/){ #lines that do not start with # (non-genes)
			$gene_num += 1;
			@values = split("\t", $line); #split the lines by tab
			$contig_id = $values[0];
			$start = $values[3];
			$stop = $values[4];
			$prod_genes{$gene_num}{"contig_id"} = $contig_id; #stores the contig identifier
			#get contig number
			if ($gene_num == 1 || $prod_genes{$gene_num}{"contig_id"} eq $prod_genes{$gene_num-1}{"contig_id"}) { #if it's the first gene or if the gene ID equals the one before it
				$prod_genes{$gene_num}{"seq_num"} = $seq_num;
			}
			else{ #if the gene ID doesn't equal the one before it then increase the sequence number
				$seq_num += 1;
				$prod_genes{$gene_num}{"seq_num"} = $seq_num;
			}
			$prod_genes{$gene_num}{"start"} = $start;	#this stores the start value for the 1st gene (and then so on..) found by Prodigal
			$prod_genes{$gene_num}{"stop"} = $stop;	#same with stop position
		}
	}
}

sub readHMM{
	#for HMM (gff 2):
		#for lines starting with conig_id (not '#' or space): column 4 (start), column 5 (stop),  column 7 (strand)
	my $line; #each line string
	my $gene_num=0; #gene counter
	my $seq_num=1; #contig counter
	my @values; #values of each line
	my $contig_id; #contig identifier;
	my $start; #start position
	my $stop; #stop position

	foreach $line(@hmm){	#going through the lines of the HMM file
		chomp $line;	#removing newline character from each line
		if ($line !~ /^#/ && $line !~ /^\s*$/){ #making sure that the line isn't a header or spaces
			$gene_num += 1;
			@values = split("\t", $line);
			$contig_id = $values[0];
			$start = $values[3];
			$stop = $values[4];
			$hmm_genes{$gene_num}{"contig_id"} = $contig_id; #stores the contig identifier
			#get contig number
			if ($gene_num == 1 || $hmm_genes{$gene_num}{"contig_id"} eq $hmm_genes{$gene_num-1}{"contig_id"}) { #if it's the first gene or if the gene ID equals the one before it
				$hmm_genes{$gene_num}{"seq_num"} = $seq_num;
			}
			else{ #if the gene ID doesn't equal the one before it then increase the sequence number
				$seq_num += 1;
				$hmm_genes{$gene_num}{"seq_num"} = $seq_num;
			}
			$hmm_genes{$gene_num}{"start"} = $start;	#this stores the start value for the 1st gene (and then so on..) found by Prodigal
			$hmm_genes{$gene_num}{"stop"} = $stop;	#same with stop position
		}
	}
}

sub compareGFF{
	my (%genes1, %genes2), @_;
	my $size1 = keys %genes1;
	my $size2 = keys %genes2;
	if ($size1 >= $size2) {

	}

}
readProdigal();
readHMM();
readGlimmer();
#get the length of the longest hash




##this is to test if your output looks ok##
foreach my $val(sort(keys %prod_genes)){	#these are not sorted 100% correctly but its fine for testing the output
 	print $val, "\t", $prod_genes{$val}{"start"}, "\t", $prod_genes{$val}{"stop"}, "\n";
}

#get the length of the longest hash



=put
Things to do:
First: update the reading subroutines to get all the information from the GFF file so it can be easily printed
Second: get the longest hash
Third: print the overlapped genes to a file, and some sort of statistic to the terminal
