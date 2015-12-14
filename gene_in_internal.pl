#!perl
###This script was used to find genes in some intervals
###you need provide gene gff3 file and internal file

use Getopt::Std;
getopts "g:i:o:";

$input = $opt_i;
$gfffile = $opt_g;
$output = $opt_o;

if ((!defined $opt_g)|| (!defined $opt_i) || (!defined $opt_o) ) {
        die "************************************************************************
        Usage: perl gene_in_internal.pl -g gff_file -i inputfile -o outfile
          -h : help and usage.
          -g : gff file
          -i : interval file
          -o : output
************************************************************************\n";
}

open(IN, $input) or die"";
while(<IN>){
	chomp;
	($scaf,$a,$b) = (split/\s+/,$_)[0,1,2];
	foreach $i($a..$b){
		$key = $scaf." ".$i;
		$intdb{$key} += 1;
		}
	}
close IN;

open(GFF, $gfffile) or die"";
while(<GFF>){
	chomp;
	next if !/mRNA/; ###you can change here if you want gene/CDS overlap rather than mRNA overlap
	($scaf, $a, $b, $gene) = (split/\s+/,$_)[0,3,4,9];
	$gene =~ s/id=//g; $gene =~ s/;//g;
	foreach $i($a..$b){
		$key = $scaf." ".$i;
		$genedb{$gene}++ if exists($intdb{$key});
		last if exists($intdb{$key});
		}
	}
close GFF;

open(OUT, "> $output") or die"";
foreach $gene(keys %genedb){
	print OUT "$gene\n";
	}
close OUT;

