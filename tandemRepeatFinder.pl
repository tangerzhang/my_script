#!/usr/bin/perl -w

use Getopt::Std;
getopts "i:";


if (!defined $opt_i) {
    die "************************************************************************
    Usage: perl $0 -i input.fasta 
      -h : help and usage.
      -i : input.fasta
************************************************************************\n";
}else{
  print "************************************************************************\n";
  print "Version demo\n";
  print "Copyright to tanger.zhang\@gmail.com\n";
  print "RUNNING...\n";
  print "************************************************************************\n";
        
        }


system("/public1/home/zhangxt/bin/splitChrByFa.pl $opt_i");
while(my $file = glob "fabyChr/*.fasta"){
	my $trf_cmd = "/public1/home/zhangxt/bin/trf ".$file." 1 1 2 80 5 200 2000 -d -h";
	system($trf_cmd);
	}

my %infordb;
open(OUT, "> tandem.all.bed") or die"";
while(my $dat = glob "*.dat"){

	open(my $fh, $dat) or die"";
	while(<$fh>){
		chomp;
	  my $cont = $dat;
	     $cont =~ s/.fasta.1.1.2.80.5.200.2000.dat//g;
		my @data = split(/\s+/,$_);
		next if(@data < 10);
		my $str  = $data[14];
		my $a    = $data[0];
		my $b    = $data[1];
 		my $len  = abs($data[0]-$data[1]);
 		print OUT "$cont	$a	$b	$len	$str\n";
		}
	close $fh;
	}
close OUT;


system("rm -rf dat_dir");
system("mkdir dat_dir");
system("mv *.dat dat_dir/");
