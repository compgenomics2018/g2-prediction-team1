#!/usr/bin/perl -w
use strict;
use Getopt::Long;

my $gff_name;
my $prodigal_fasta_name;
my $genemark_fasta_name;
my $output_name = "output.fasta";
my $help=0;
my @prodigal_lines;
my @genemark_lines;
my @output;
#names of files
#GFF: SRR_name.gff
#Prodigal: SRR_name.nucleotide.fa
#gmhmm: SRR_name_HMM.nucleotide.fasta
#faa files:
#gmhmm: protein_SRR_HMM.nucleotide.fasta
#Prodigal: SRR_name.protein.fa

sub usage{
  print "\nUsage:\n";
  print "./gff_to_fasta.pl -i [name of gff file] -p [prodigal fasta file] -g [genemark fasta file] -o [output file name]\n";
}

sub initialize{
  GetOptions(
    'i=s' => \$gff_name,
		'p=s' => \$prodigal_fasta_name,
    'g=s' => \$genemark_fasta_name,
    'o=s' => \$output_name,
    'h'   => \$help,
  ) or die "Incorrect usage!\n";

  if ($help ne 0) { usage(); exit 1;}
  unless (defined $gff_name && defined $prodigal_fasta_name && defined $genemark_fasta_name) {
    print "You need to enter all the files\n"; usage(); exit 1;
  }
}

sub openFile{
  my ($filename) = @_;
	my @lines;
  open (FILE, "<",  $filename) or die "Can't open the file $filename!!!!\n";

  #read the lines
  while (<FILE>) {
    chomp $_;
    push @lines, $_;
  }
  close FILE;
	return @lines;
}

sub getGenes{
  my @gff_lines = openFile($gff_name);
  my $num_genes = scalar @gff_lines;
  my $method;
  my $gene_id;
  for (my $i=0; $i < $num_genes; $i++) {
    #print $gff_lines[$i], "\n";
    my @columns = split("\t", $gff_lines[$i]);
    if ($columns[1] =~ /^Prodigal/) {
      $method = 0;
      #print $gff_lines[$i], "\n";
      my @ids = split(";", $columns[8]);
      $gene_id = $ids[0];
      getFastaLine($gene_id, $method);
    }
    elsif ($columns[1] =~ /^GeneMark/) {
      $method = 1;
      my @ids = split("=", $columns[8]);
      $gene_id = $ids[1];
      getFastaLine($gene_id, $method);
    }
  }
}

sub getFastaLine{
  my ($gene_id, $method) = @_;
  #print $gene_id, "\t", $method, "\n";
  if ($method == 0) {
    #print "yes\n";
    my $file_size = scalar @prodigal_lines;
    for (my $i=0; $i < $file_size; $i++) {
      if ($prodigal_lines[$i] =~ /^>/) {
        my @columns = split('\s', $prodigal_lines[$i]);
        my @ids = split(";", $columns[8]);
        my $fasta_id = $ids[0];
        #print $fasta_id, "\n";
        if ($gene_id eq $fasta_id) {
          push @output, $prodigal_lines[$i];
          push @output, $prodigal_lines[$i+1];
          last;
        }
      }
    }
  }
  elsif ($method == 1) {
    my $file_size = scalar @genemark_lines;
    for (my $i=0; $i< $file_size; $i++) {
      if ($genemark_lines[$i] =~ /^>/) {
        my @columns = split /[|_]+/, $genemark_lines[$i];
        my $fasta_id = $columns[1];

        if ($fasta_id eq $gene_id) {
          push @output, $genemark_lines[$i];
          push @output, $genemark_lines[$i+1];
          last;
        }
      }
    }
  }
}

initialize();
@prodigal_lines = openFile($prodigal_fasta_name);
@genemark_lines = openFile($genemark_fasta_name);
getGenes();

open (OUT, ">",  $output_name) or die "Can't open the file $output_name!!!!\n";
my $output_size = scalar @output;
for (my $i=0; $i< $output_size; $i++) {
  print OUT $output[$i], "\n";
}
close OUT;
