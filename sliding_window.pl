#!/usr/bin/perl -w

use Getopt::Std;
getopts "i:o:w:s:";


if ((!defined $opt_i)|| (!defined $opt_o)  || (!defined $opt_w) || (!defined $opt_s)) {
    die "************************************************************************
    Usage: perl sliding_window.pl -i input.fasta -o output.fasta -w window_size -s step_length
      -h : help and usage
      -i : input.fasta
      -o : output.bed
      -w : window size
      -s : step length
************************************************************************\n";
}else{
  print "************************************************************************\n";
  print "Version 1.1\n";
  print "Copyright to Tanger\n";
  print "RUNNING...\n";
  print "************************************************************************\n";   
        }

my $ws          = $opt_w;
my $step        = $opt_s;
my $start_p     = 1; 

print "Length of each sequence:\n";
open(OUT, ">$opt_o") or die"";
open(IN, $opt_i) or die"";
$/='>';
<IN>;
while(<IN>){
	chomp;
	my ($name,$seq) = split(/\n/,$_,2);
	$name           =~ s/\s.*//g;
	$seq            =~ s/\s+//g;
	my $len         = length $seq;
	my $num_win     = int $len/$step;  ###how many windows will be generated
	print "$name	$len	\n";
	my $a = $start_p;
	for(my $i=1;$i<=$num_win;$i++){
		my $b = $a + $ws - 1;
		$b = $len if($b>$len);
		print OUT "$name	$a	$b\n";
		$a   += $step ;
		}
	}
close IN;
close OUT;






