#!/usr/bin/perl -w
use strict;

my %infordb;
my %refdb;
my %sampledb;
while(my $file = glob "*.vcf"){
	my $sample = $file;
	   $sample =~ s/.vcf//g;
	$sampledb{$sample}++;
	open(my $fh, $file) or die"";
	while(<$fh>){
		chomp;
		next if(/#/);
		my @data = split(/\s+/,$_);
		my $key  = $data[0]."_".$data[1];
		$infordb{$key}->{$sample} = $data[4];
		$refdb{$key}              = $data[3];
		}
	close $fh;
	}
print "scaf	posi	refN	";
foreach my $samp (sort keys %sampledb){
	print "$samp	";
	}
print "\n";

foreach my $key (sort keys %refdb){
	my $altN;
	my $refN = $refdb{$key};
	print "$key	$refN	";
	foreach my $samp (sort keys %sampledb){
		$altN     = $infordb{$key}->{$samp} if(exists($infordb{$key}->{$samp}));
		$altN     = "-" if(!exists($infordb{$key}->{$samp}));
		print "$altN	";
		}
	print "\n";
	}

