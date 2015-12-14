#!perl
use Getopt::Std;
getopts "i:l:o:";

$fasta = $opt_i;
$len   = $opt_l; 
$outfile = $opt_o;
if ((!defined $opt_i)|| (!defined $opt_l) || (!defined $opt_o) ) {
        die "************************************************************************
        Usage: perl getSeqLongerThanXbp.pl -i fasta_file -l X bp -o outfile
          -h : help and usage.
          -i : fasta file
          -o : outfile
          -l : length of sequences you want to get
************************************************************************\n";
}

open(OUT, ">$outfile") or die"";
open(IN, $fasta) or die"";
$/='>';
<IN>;
while(<IN>){
	chomp;
	($gene,$seq) = split(/\n/,$_,2);
	$gene =~ s/\s+//g;
	$seq  =~ s/\s+//g;
	$l    = length $seq;
	next if($l<=$len);
	print OUT ">$gene\n$seq\n";
	}
close IN;
close OUT;


