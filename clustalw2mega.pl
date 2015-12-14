#!perl

use Getopt::Std;
getopts "i:o:";

$aln    = $opt_i;
$output = $opt_o;

if ((!defined $opt_i)|| (!defined $opt_o)) {
    die "************************************************************************
    Usage: perl clustalw2mega.pl -i aln -o out.fasta 
      -h : help and usage.
      -i : clustalw output.aln
      -o : aligned fasta sequence 
************************************************************************\n";
}else{
  print "************************************************************************\n";
  print "Version 1.1\n";
  print "Copyright to Tanger\n";
  print "RUNNING...\n";
  print "************************************************************************\n";
	
	}

open(IN, $aln) or die"";
<IN>;
while(<IN>){
	chomp;
	($name,$subseq) = split(/\s+/,$_);
	next if($name eq "");
	$infordb{$name} .= $subseq;
	}
close IN;

open(OUT, "> $output") or die"";
foreach $name(sort keys %infordb){
	print OUT ">$name\n$infordb{$name}\n";
	}
close OUT;

