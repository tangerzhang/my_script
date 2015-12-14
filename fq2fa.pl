#!perl

use Getopt::Std;
getopts "i:o:";


if ((!defined $opt_i)|| (!defined $opt_o)) {
    die "************************************************************************
    Usage: perl fq2fa.pl -i fastq_file -o fasta_file
      -h : help and usage.
      -i : fastq file
      -o : fasta file
************************************************************************\n";
}
open(OUT, ">$opt_o") or die"";
open(IN, $opt_i) or die"";
while($line1=<IN>){
	$line2=<IN>;
	$line3=<IN>;
	$line4=<IN>;
	$name = $line1;
        $name =~ s/\n//g;
	$seq  = $line2;
	print OUT ">$name\n$seq";
	}
close IN;
close OUT;

