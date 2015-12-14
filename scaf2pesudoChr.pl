#!perl
###This script was used to convert scaffold position to chr position.
###chr position are joined every scaffolds by inserting 150 Ns between the scaffolds
###The script support two kinds of data type: gff file and txt file
###gff file format looks like this: (the 0, 3 and 4 elements are useful)
###nscaf1022   glean   mRNA    11153   14469   0.453529    +   .   id=BGIBMGA000001-TA;
###txt file format looks like this: (the 0, 1 and 2 elements are useful)
###nscaf1022	11153	14469
###usage: perl scaf2chr.pl -t gff/txt -i inputfile -o outfile

use Getopt::Std;
getopts "t:i:o:";

$input = $opt_i;
$type = $opt_t;
$output = $opt_o;

if ((!defined $opt_t)|| (!defined $opt_i) || (!defined $opt_o) ) {
        die "************************************************************************
        Usage: perl scaf2chr.pl -t gff/txt -i inputfile -o outfile
          -h : help and usage.
          -t : type of your file
          -i : input
          -o : output
************************************************************************\n";
}else{
  print "************************************************************************\n";
  print "Version 1.0\n";
  print "Copyright to Tanger, tanger.zhang@gmail.com\n";
  print "RUNNING...\n";
  print "************************************************************************\n";

        }

open(IN, "/Users/xingtanzhang/software/my_script/chr_infor.txt") or die "This script need chr_infor.txt file";
$/='>';
<IN>;
while(<IN>){
	chomp;
	($chr, $infor) = split(/\n/,$_,2);
	@t = split(/\n/,$infor);
	foreach $t(@t){
		($scaf, $a) = (split/\s+/,$t)[0,1];
		$chrdb{$chr}->{$scaf} = $a;
		}
	}
close IN;

	print "The type of your input file is wrong!!!\n" if ($type ne "gff" and $type ne "txt");
open(OUT, "> $output") or die"";
open(INN, $input) or die "";
$content = <INN>;
@lines = split(/\n/,$content);
foreach $line(@lines){
#	($scaf,$a,$b) = (split/\s+/,$line)[0,3,4] if $type eq "gff";
#	($scaf,$a,$b) = (split/\s+/,$line)[0,1,2] if $type eq "txt";
	@data = split(/\s+/,$line);
	if($type eq "gff"){
		$scaf = $data[0]; $a = $data[3]; $b = $data[4];
		foreach $chr(keys %chrdb){
			if(exists($chrdb{$chr}->{$scaf})){
				$data[3] = $chrdb{$chr}->{$scaf} + $data[3] - 1;
				$data[4] = $chrdb{$chr}->{$scaf} + $data[4] - 1;
				$data[0] = $chr;
				}
			}
		$re_line = join"\t", @data;
		print OUT "$re_line\n";
	}elsif($type eq "txt"){
		$scaf = $data[0]; $a = $data[1]; $b = $data[2];
		foreach $chr(keys %chrdb){
			if(exists($chrdb{$chr}->{$scaf})){
				$data[1] = $chrdb{$chr}->{$scaf} + $data[1] - 1;
				$data[2] = $chrdb{$chr}->{$scaf} + $data[2] - 1;
				$data[0] = $chr;
				}
			}
		$re_line = join"\t", @data;
		print OUT "$re_line\n";
	 }else{last;}	
	}
close INN;
close OUT;

#foreach $chr(sort keys %chrdb){
#	foreach $scaf(keys %{$chrdb{$chr}}){
#		print "$chr	$scaf	$chrdb{$chr}->{$scaf}\n";
#		}
#	}
