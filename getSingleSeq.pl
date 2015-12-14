#!perl

###get single fasta seq you are calling###
###usage: perl getSeq.pl datadb.fasta fasta_header 
$datadb = $ARGV[0];
$fa_header = $ARGV[1];
open(IN, $datadb) or die"usage: perl getSeq.pl datadb.fasta fasta_header\n";
$/='>';
<IN>;
while(<IN>){
	chomp;
	($name, $seq) = split(/\s+/,$_,2);
	$infordb{$name} = uc $seq;
	}
close IN;

if(exists($infordb{$fa_header})){
	print ">$fa_header\n$infordb{$fa_header}\n";
}else{
	print "There is no such fasta seq\n";
	}
