#!/usr/bin/perl -w

use Getopt::Std;
getopts "l:d:o:";

my $list = $opt_l;
my $database = $opt_d;
my $output = $opt_o;

if ((!defined $opt_l)|| (!defined $opt_d) || (!defined $opt_o) ) {
        die "************************************************************************
        Usage: perl $0 -l listfile -d database -o output
          -h : help and usage.
          -l : gene list. Note the the name of gene should be same with the database
          -d : database fasta file
          -o : output
************************************************************************\n";
}

my %listdb;
open(IN, $list) or die"";
while(<IN>){
	chomp;
	my $line = $_;
	$line =~ s/\s+.*//g;
	$listdb{$line} += 1;
	}
close IN;

open(OUT, "> $output") or die"";
open(IN, $database) or die"";
$/='>';
<IN>;
while(<IN>){
	chomp;
	my ($gene,$seq) = split(/\n/,$_,2);
	$gene =~ s/\s+.*//g;
	$seq  =~ s/\s+//g;
	next if(exists($listdb{$gene}));
	print OUT ">$gene\n$seq\n";
	}
close IN;
close OUT;
