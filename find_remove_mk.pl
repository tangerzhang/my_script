#!/usr/bin/perl -w
use Text::Levenshtein qw(distance);
use threads;
use threads::shared; 
use Getopt::Std;
getopts "i:d:t:l:";

if ((!defined $opt_i)|| (!defined $opt_d)) {
    die "************************************************************************
    Usage: perl $0 -i input.geno -d identity -t threads
      -h : help and usage.
      -i : input file, only support ll/lm genotype
      -d : identity
      -t : threads, default 10
      -l : default len.txt, store length information for each scaffold
************************************************************************\n";
}
###ll=a;lm=b;..=-

my $input        = $opt_i;
my $cutoff_i     = $opt_d;
my $maxThreads   = (defined $opt_t)?$opt_t:10;
my $len_file     = (defined $opt_l)?$opt_l:"len.txt";
my %lendb;
open(IN, $len_file) or die"";
while(<IN>){
	chomp;
	my ($scaf,$len) = split(/\s+/,$_);
	$lendb{$scaf} = $len;
	}
close IN;

open(OUT, "> tmp.txt") or die"";
open(IN, $input) or die"";
while(<IN>){
	chomp;
	my $scaf = (split)[0];
	$scaf    =~ s/\_.*//g;
	next if(!exists($lendb{$scaf}));
	my @data = split(/\s+/,$_);
	foreach my $i(0..$#data){
		$data[$i] = "a" if($data[$i] eq "ll");
		$data[$i] = "b" if($data[$i] eq "lm");
		$data[$i] = "-" if($data[$i] eq "..");
		}
	print OUT "$scaf	$lendb{$scaf}	@data\n";
	}
close IN;
close OUT;

my %infordb;
my $count;
open(IN, "sort -k 2 -n -r tmp.txt |") or die"";
while(<IN>){
	chomp;
	$count++;
	my @data = split(/\s+/,$_);
	my $str = "";
	my $info = "";
	foreach my $i(3..$#data){
		$str .= $data[$i];
		$info .= $data[$i]."	";
		}
	$infordb{$count}->{'scaf'}   = $data[0];
	$infordb{$count}->{'marker'} = $data[2];
	$infordb{$count}->{'str'}    = $str;
	$infordb{$count}->{'info'}   = $info;
	}
close IN;

my $num_of_job  = keys %infordb;
my $i=2;
while($i<=$num_of_job){
	while(scalar(threads->list())<=$maxThreads){
		threads->new(\&repeat_comp,$i);
		$i++;
		}
  foreach $thread(threads->list(threads::all)){
     if($thread->is_joinable()){
       $thread->join();
     }
   }	
	}

foreach $thread(threads->list(threads::all)){
    $thread->join();
   }

system("rm tmp.txt");

sub repeat_comp{
	my $n       = shift;
	my $mk_c    = $infordb{$n}->{'marker'};
	my $str_c   = $infordb{$n}->{'str'};
	my $num_l   = length $str_c;
	for(my $i=1;$i<$n;$i++){
		my $mk_p   = $infordb{$i}->{'marker'};
		my $str_p  = $infordb{$i}->{'str'};
		my $score  = distance($str_c,$str_p);
		my $ident  = ($num_l - $score)/$num_l;
		   $ident  = sprintf("%.2f",$ident);
		if($ident>=$cutoff_i){
			print "Remove $mk_c as it has high identity ($ident) with $mk_p\n";
			last;
			}		
		}
	}

