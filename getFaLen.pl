#!perl

###This script is used to get length information for each sequence in a fasta file

use Getopt::Std;
getopts "i:o:";

$input = $opt_i;
$output = $opt_o;

if ((!defined $opt_i) || (!defined $opt_o) ) {
        die "************************************************************************
        Usage: perl getFalen.pl -i input.fasta -o output
          -h : help and usage.
          -i : input fasta
          -o : output
************************************************************************\n";
}
open(OUT, ">$output") or die"";
open(IN, $input) or die"";
$/='>';
<IN>;
while(<IN>){
	chomp;
	($gene,$seq) = split(/\n/,$_,2);
        $gene =~ s/\s+.*//g;
	$seq  =~ s/\s+//g;
	$len  = length $seq;
	print OUT "$gene	$len\n";
	}
close IN;
close OUT;


