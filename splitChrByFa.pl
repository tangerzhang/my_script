#!/usr/bin/perl -w

my %chrdb;
die "Usage: perl splitFabyChr.pl ref.fasta\n" if(!defined $ARGV[0]);
open(IN, $ARGV[0]) or die"Usage: perl splitFabyChr.pl ref.fasta\n";
$/='>';
<IN>;
while(<IN>){
	chomp;
	my ($chrn,$seq) = split(/\n/,$_,2);
	$chrn =~ s/\s.*//g;
	$seq =~ s/\s+//g;
	$chrdb{$chrn} = $seq;
	}
close IN;

system("rm -rf fabyChr");
mkdir fabyChr;
foreach my $chrn (keys %chrdb){
	my $outfile = $chrn.".fasta";
	open(my $out, ">fabyChr/$outfile") or die"";
	print $out ">$chrn\n$chrdb{$chrn}\n";
	close $out;
	}


