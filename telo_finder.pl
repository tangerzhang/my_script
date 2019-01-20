#!/usr/bin/perl -w

use Getopt::Std;
getopts "i:d:";


if ((!defined $opt_i)||(!defined $opt_d)) {
    die "************************************************************************
    Usage: perl $0 -i input.fasta -d trf_out_dir
      -h : help and usage.
      -i : input.fasta
      -d : trf output dir
************************************************************************\n";
}else{
  print "************************************************************************\n";
  print "Version demo\n";
  print "Copyright to tanger.zhang\@gmail.com\n";
  print "RUNNING...\n";
  print "************************************************************************\n";
        
        }

my %sizedb;
system("perl /public1/home/zhangxt/software/script/getFaLen.pl -i $opt_i -o chr.len.txt");
open(IN, "chr.len.txt") or die"";
while(<IN>){
	chomp;
	my ($cont,$len) = split(/\s+/,$_);
	$sizedb{$cont}  = $len;
	}
close IN;

#system("splitChrByFa.pl $opt_i");
#while(my $file = glob "fabyChr/*.fasta"){
#	my $trf_cmd = "trf ".$file." 1 1 2 80 5 200 2000 -d -h";
#	system($trf_cmd);
#	}

my $telo1     = "TTTAGGG" x 10;
my $telo_rev1 = "CCCTAAA" x 10;
my $telo2     = "TTTAGGG" x 8;
my $telo_rev2 = "CCCTAAA" x 8;
open(OUT1, ">trf.all.10r.bed") or die"";	
open(OUT2, ">trf.all.8r.bed") or die"";
print OUT1 "Contig_Name	Contig_Size	Start_of_telo	End_of_telo	Size_of_telo	Teleomeric_repeat_sequence	posi_of_telo	No_of_tel\n";
print OUT2 "Contig_Name	Contig_Size	Start_of_telo	End_of_telo	Size_of_telo	Teleomeric_repeat_sequence	posi_of_telo	No_of_tel\n";
while(my $dat = glob "$opt_d/*.dat"){

	open(my $fh, $dat) or die"";
	while(<$fh>){
		chomp;
	  my $cont = $dat;
             $cont =~ s/$opt_d\///g;
	     $cont =~ s/.fasta.1.1.2.80.5.200.2000.dat//g;
	  my $len  = $sizedb{$cont};		
		my ($posi,$size_of_telo,$str,$cn);
		my @data = split(/\s+/,$_);
		next if(@data < 10);
		$str  = $data[14];
		$size_of_telo = abs($data[0]-$data[1]);
		$posi = "start" if($data[0] < $len/2);
		$posi = "end"   if($data[1] > $len/2);
    $cn   = $data[3];
		print OUT1 "$cont	$len	$data[0]	$data[1]	$size_of_telo	$data[13]	$posi	$cn\n" if($str=~/$telo1/ or $str=~/$telo_rev1/);
		print OUT2 "$cont	$len	$data[0]	$data[1]	$size_of_telo	$data[13]	$posi	$cn\n" if($str=~/$telo2/ or $str=~/$telo_rev2/);
		}
	close $fh;
	}
close OUT1;
close OUT2;
