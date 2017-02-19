#!/usr/bin/perl -w

my %removedb;
open(IN, "removedb.txt") or die"";
while(<IN>){
	chomp;
	my $mk_r = (split/\s+/,$_)[1];
	$removedb{$mk_r}+=1;
	}
close IN;

open(OUT, "> identical_mk.txt") or die"";
open(IN, $ARGV[0]) or die"";
while(<IN>){
	chomp;
	my $mk = (split/\s+/,$_)[0];
	next if(exists($removedb{$mk}));
	print OUT "$_\n";
	}
close IN;
close OUT;

