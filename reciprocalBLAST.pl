#!/usr/bin/perl -w

use Getopt::Std;
getopts "a:b:p:c:d:t:";


if ((!defined $opt_a)|| (!defined $opt_b)  || (!defined $opt_p)) {
    die "************************************************************************
    Usage: perl $0 -a A.fasta -b B.fasta -p blast_program 
      -h : help and usage.
      -a : A.fasta, cds/protein in species A
      -b : B.fasta, cds/protein in species B
      -p : blast program, blastn/blastp
      -d : identity (optional, default is 0.6)
      -c : coverage (optional, defalut is 0.6)
      -t : threads (optional, default is 6)
      -o : output
************************************************************************\n";
}

my $coverage 	   = (defined $opt_c) ? $opt_c : 0.6;
my $identity     = (defined $opt_d) ? $opt_d : 0.6;
my $threads      = (defined $opt_t) ? $opt_t : 6;

system("simple_blast -p $opt_p -i $opt_a -d $opt_b -o AvsB.blast.out -c 6");
system("blastn_parse.pl -i AvsB.blast.out -o EAvsB.blast.out -q $opt_a -b 1 -c $opt_c -d $opt_d");

system("simple_blast -p $opt_p -i $opt_b -d $opt_a -o BvsA.blast.out -c 6");
system("blastn_parse.pl -i BvsA.blast.out -o EBvsA.blast.out -q $opt_b -b 1 -c $opt_c -d $opt_d");

system("rm dbname*");

open(IN, "EAvsB.blast.out") or die"";
while(<IN>){
	chomp;
	my @data = split(/\s+/,$_);
	my ($na,$nb) = sort ($data[0],$data[1]);
	my $key  = $na.":".$nb;
	$infordb{$key}++;
	}
close IN;


open(OUT, "|sort -k 1 > reciprocalBLAST_out.txt") or die"";
open(IN, "EBvsA.blast.out") or die"";
while(<IN>){
	chomp;
	my @data = split(/\s+/,$_);
	my ($na,$nb) = sort ($data[0],$data[1]);
	my $key  = $na.":".$nb;
	$infordb{$key}++;
	}
close IN;

my %dataSet_one = ();
foreach my $key (keys %infordb){
	next if($infordb{$key}==1);
	my ($aa,$bb) = split(/:/,$key);
	print OUT "$aa	$bb\n";
	}
close OUT;


