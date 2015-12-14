#!perl

###This script was used to split big fastq data into small fq data set###
###usage: perl split_FQ.pl fq_file number_of_parts###


use Getopt::Std;
getopts "i:n:";
if( (!defined $opt_i) or (!defined $opt_n) ){
	die "**********************************************
	This script was used to split big fastq data into small fq data set
	Usage: perl split_FQ.pl -i fq_file -n number_of_parts
	   -i: the input fastq file
	   -n: how many parts you want to split
	   -h: help and usage
**********************************************\n";
	}else{
  print "************************************************************************\n";
  print "Version 1.0\n";
  print "Copyright to Tanger, tanger.zhang@gmail.com\n";
  print "RUNNING...\n";
  print "************************************************************************\n";
	
	}


$n_part = $opt_n;
$fq_file = $opt_i;
$total_reads = 0;

open(IN, $fq_file) or die"";
while($line1=<IN>){
	$line2=<IN>;
	$line3=<IN>;
	$line4=<IN>;
	$total_reads++;
	$infordb{$total_reads} = $line1."".$line2."".$line3."".$line4;
	}
close IN;

$part_reads = int ($total_reads/$n_part);
$n = 0;
for($i=1;$i<=$total_reads;$i=$i+$part_reads){
	$n++;
	$output = $fq_file."_".$n;
	open($fh, "> $output") or die"";
	if($n == $n_part){
	 for($j=$i;$j<=$total_reads;$j++){
	  	print $fh "$infordb{$j}";
		 }
		last;
		}else{
    	for($j=$i;$j<$i+$part_reads;$j++){
    		print $fh "$infordb{$j}";
    		}			
			}
	close $fh;
	}
