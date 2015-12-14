#!perl
###Get sequence from a list of genes


use Getopt::Std;
getopts "l:d:o:";

$list = $opt_l;
$database = $opt_d;
$output = $opt_o;

if ((!defined $opt_l)|| (!defined $opt_d) || (!defined $opt_o) ) {
        die "************************************************************************
        Usage: perl getSeqFromList.pl -l listfile -d database -o output
          -h : help and usage.
          -l : gene list. Note the the name of gene should be same with the database
          -d : database fasta file
          -o : output
************************************************************************\n";
}

open(IN, $database) or die"";
$/='>';
<IN>;
while(<IN>){
chomp;
($name,$seq) = split(/\n/,$_,2);
$name =~ s/\s+.*//g;
$seq =~ s/\s+//g;
$genedb{$name} = $seq;
}
close IN;

open(OUT, ">$output") or die"";
open(IN, $list) or die"";
$content = <IN>;
@lines = split(/\n/,$content);
foreach $line(@lines){
$line =~ s/\s+.*//g;
print OUT ">$line\n$genedb{$line}\n";
}
close IN;
close OUT;
