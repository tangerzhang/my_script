#!/usr/bin/perl -w

use Getopt::Std;
getopts "i:n:";
if( (!defined $opt_i) or (!defined $opt_n) ){
        die "********************************************************************* 
        Usage: perl merge_scaf2chr.pl -i genome.fasta -n No._of_chr
           -i: the input fasta file
           -n: Number of Chr 
           -h: help and usage
*********************************************************************\n";
 }


system("splitFA2parts -i $opt_i -n $opt_n");
open(OUT, "> chr_info.txt") or die"";
my $chrn = 0;
my %infordb;
my $Nseq = "N" x 150;
my $Nlen = length $Nseq;
while(my $file = glob "part_*.fasta"){
	my $count = 0;
	$chrn++;
	my ($a, $b, $len) = (1,0,0);
	my $chrname = "Chr".$chrn;
	print OUT ">$chrname\n";
	open(my $in, $file) or die"";
	$/='>';
	<$in>;
	while(<$in>){
		chomp;
		$count++;
		my ($scaf,$seq) = split(/\n/,$_,2);
		$seq            =~ s/\s+//g;
		$scaf           =~ s/\s+.*//g;
		$a          += $len if($count==1);
		$a          += $len + $Nlen if($count>1);
		$len         = length $seq;
		$b          += $len if($count==1);
		$b          += $len + $Nlen if($count>1);
		print OUT "$scaf	$a	$b\n";
		$infordb{$chrname} = $seq if($count==1);
		$infordb{$chrname} .= $Nseq."".$seq if($count>1);
		}
	close $in;
	
	}
close OUT;


open(OUT, "> Chr.fasta") or die"";
foreach my $chrn(sort keys %infordb){
	print OUT ">$chrn\n$infordb{$chrn}\n";
	}
close OUT;
system("rm parts*.fasta");


