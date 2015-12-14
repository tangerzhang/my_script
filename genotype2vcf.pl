#!perl

use Getopt::Std;
getopts "i:o:";


if ((!defined $opt_i)|| (!defined $opt_o) ) {
    die "************************************************************************
    Usage: perl genotype2vcf.pl -i genotype.file -o snp.vcf
           -h : help and usage
           -i : genotype input
           -o : vcf output
************************************************************************\n";
}else{
           print "************************************************************************\n";
           print "Version 1.0\n";
           print "Copyright to Tanger: tanger.zhang\@gmail.com\n";
           print "RUNNING ...\n";
           print "************************************************************************\n";
        }

my %iupac = (
  "A" => "a a",
  "C" => "c c",
  "G" => "g g",
  "T" => "t t",
  "M" => "a c", 
  "K" => "g t",   
  "Y" => "c t",
  "R" => "a g", 
  "W" => "a t", 
  "S" => "c g",
  "-" => "- -",
  "N" => "N N"
);

open(OUT, ">$opt_o") or die"";
print OUT "#CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO	FORMAT\n";
$id=0;
open(IN, $opt_i) or die"";
while(<IN>){
	chomp;
	my %basedb = ();
	my $i; my @data; my $chrn; my $posi; my $refN; my $nucl; my $alt; 
	@data = split(/\s+/,$_);
	$chrn = $data[0];
	$posi = $data[1];
	$refN = $data[2];
	foreach $i(3..$#data){
		($a,$b) = split(/\s+/,$iupac{$data[$i]});
		$a = uc $a; $b = uc $b;
		next if($a eq $refN); next if($b eq $refN);
		$basedb{$a} += 1;
		$basedb{$b} += 1;
		}
	$num_NA = $basedb{'-'};
	foreach $nucl(sort {$basedb{$b}<=>$basedb{$a}} keys %basedb){
		$alt = $nucl;
		last;
		}
	$id++;
	$id_name = "SNP".$id;
	print OUT "$chrn	$posi	$id_name	$refN	$alt	qual	PASS	LitChi67individuals	.\n" if($basedb{$alt}>$num_NA);
	}
close IN;
close OUT;



