#!/usr/bin/perl -w

###This script was used to split big fasta data into small fasta data set

use Getopt::Std;
getopts "i:n:";
if( (!defined $opt_i) or (!defined $opt_n) ){
        die "********************************************************************* 
        Usage: perl $0 -i fasta_file -n number_of_parts
           -i: the input fasta file
           -n: how many parts you want to split
           -h: help and usage
*********************************************************************\n";
 }

my $refSeq = $opt_i;
my $num_of_file = $opt_n;
my $total_size = 0;
open(IN, $refSeq) or die"";
$/='>';
<IN>;
while(<IN>){
	chomp;
	my ($name,$seq) = split(/\n/,$_,2);
	$seq =~ s/\s+//g;
	$total_size += length $seq;
	$infordb{$name} = $seq;
	}
close IN;

my $size_per_file = int ($total_size/$num_of_file);
my $sum;
my $len;
my %partdb;
my $i = 1;
foreach my $name(sort keys %infordb){
	$len = length $infordb{$name};
	$sum += $len;
	$partdb{$name} = $infordb{$name};
	my $output = "part_".$i.".fasta";
	if($sum > $size_per_file * $i){
		open(my $out, "> $output") or die"";
		foreach my $gene (sort keys %partdb){
			print $out ">$gene\n$partdb{$gene}\n";
			}
		close $out;
		%partdb = ();
		$i++;
		}
	}


