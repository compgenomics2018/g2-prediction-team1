#!/usr/bin/perl -w
use strict;
use Getopt::Long;

#this script runs RNAmmer on a list of files
my $input_file_list;
my $input_dir;
my $num_files;
my $help = 0;
my @files;
my @out_list;

sub usage{
	print "\nUsage:\n";
  print "./run_rnammer_new.pl -i [input file list] -d [input directory]\n";
	print "Where the input file list is a list of the name of each input file each on a new line\n";
	print "Where the input directory is where to find the input files\n";
}

sub initialize {
  GetOptions(
    'i=s' => \$input_file_list,
		'd=s' => \$input_dir,
    'h'   => \$help,
  ) or die "Incorrect usage!\n";

  if ($help ne 0) { usage(); exit 1;}
  unless (defined $input_file_list) { print "You need to enter the input file list\n";
    usage(); exit 1; }
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

sub makeOutput {
	my (@file_list) = @_;
	my @output;
	for (my $i=0; $i<$num_files; $i++) {
		my $newname = $file_list[$i];
		$newname =~ s/.fasta//;
		$newname =~ s/.fa//;
		push @output, $newname;
	}
	return @output;
}

sub runRNAMMER{
	for (my $i=0; $i < $num_files; $i++) {
		system("/projects/data/team1_GenePrediction/bin/rnammer1.2/rnammer -S bac -m lsu,ssu,tsu -multi -gff $out_list[$i]\.gff -f $out_list[$i]\.fasta < $input_dir/$files[$i]");
	}
}

initialize();
@files = openFile($input_file_list);
$num_files = scalar @files;
@out_list = makeOutput(@files);
runRNAMMER(@files,@out_list);
