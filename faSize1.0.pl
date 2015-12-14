#!perl

print "faSize.pl v1: output fasta file stat\n";

$n_200 = 0;
$n_2k  = 0;

open(IN, $ARGV[0]) or die"";
$/='>';
<IN>;
while(<IN>){
	chomp;
	($gene,$seq) = split(/\n/,$_,2);
	$seq =~ s/\s+//g;
	$infordb{$gene}->{'seq'} = $seq;
	$l = length $seq;
	if($l>500){
		$n_500++;
	}
        if($l>2000){
		$n_2k++;
		}
	$sum_l += $l;
	$infordb{$gene}->{'len'} = $l;
	}
close IN;

$num = keys %infordb;

foreach $gene(sort {$infordb{$b}->{'len'}<=>$infordb{$a}->{'len'}} keys %infordb){
  $l = $infordb{$gene}->{'len'};
  push @data, $l;
	}
$min = $data[-1];
$max = $data[0];

foreach $gene(sort {$infordb{$b}->{'len'}<=>$infordb{$a}->{'len'}} keys %infordb){
  $l = $infordb{$gene}->{'len'};
  $tmp += $l;
  if($tmp>=$sum_l/2){
  	$N50 = $l;
  	last;
  	}
	}
$tmp = 0;

foreach $gene(sort {$infordb{$b}->{'len'}<=>$infordb{$a}->{'len'}} keys %infordb){
  $l = $infordb{$gene}->{'len'};
  $tmp += $l;
  if($tmp>=$sum_l*0.6){
  	$N60 = $l;
  	last;
  	}
	}
$tmp = 0;

foreach $gene(sort {$infordb{$b}->{'len'}<=>$infordb{$a}->{'len'}} keys %infordb){
  $l = $infordb{$gene}->{'len'};
  $tmp += $l;
  if($tmp>=$sum_l*0.7){
  	$N70 = $l;
  	last;
  	}
	}
$tmp = 0;

foreach $gene(sort {$infordb{$b}->{'len'}<=>$infordb{$a}->{'len'}} keys %infordb){
  $l = $infordb{$gene}->{'len'};
  $tmp += $l;
  if($tmp>=$sum_l*0.8){
  	$N80 = $l;
  	last;
  	}
	}
$tmp = 0;

foreach $gene(sort {$infordb{$b}->{'len'}<=>$infordb{$a}->{'len'}} keys %infordb){
  $l = $infordb{$gene}->{'len'};
  $tmp += $l;
  if($tmp>=$sum_l*0.9){
  	$N90 = $l;
  	last;
  	}
	}
$tmp = 0;

print "number of seq:	$num\n";
print "min length: $min\n";
print "max length: $max\n";
print "total size: $sum_l\n";
print "N90: $N90\n";
print "N80: $N80\n";
print "N70: $N70\n";
print "N60: $N60\n";
print "N50: $N50\n";

print "Total number (>500bp):	$n_500\n";
print "Total number (>2kb):	$n_2k\n";


