#!/usr/bin/perl -w

die "Usage: perl $0 trf_dat_dir\nPlease run trf first\n" if(!defined($ARGV[0]));

my %sumdb;
my $trf_dir = $ARGV[0];
open(OUT, "> tandem.all.bed") or die"";
print OUT "seqid	start	end	period	copynum	consensusSize	pctmatch	pctindel	score	A	C	G	T	repeat_pattern	repeat_seq\n";
while(my $dat = glob "$trf_dir/*.dat"){

	open(my $fh, $dat) or die"";
	while(<$fh>){
		chomp;
	  my $cont = $dat;
	     $cont =~ s/$trf_dir//g;
	     $cont =~ s/\///g;
	     $cont =~ s/\.fasta.*//g;
		my @data = split(/\s+/,$_);
		next if(@data < 10);
    $sumdb{$data[2]} += abs($data[0]-$data[1])+1 if($data[2]>=50 and $data[2]<=200);
 		print OUT "$cont	";
 		foreach my $i(0..$#data){
 			print OUT "$data[$i]	";
 			}
 		print OUT "\n";
		}
	close $fh;
	}
close OUT;

my $count = 0;
my $len_p = 0;
print "Check the patterns:\n";
foreach my $i(sort {$sumdb{$b}<=>$sumdb{$a}} keys %sumdb){
	$count++;
	next if($count>10);
	$len_p = $i if($count==1);
	print "$i	$sumdb{$i}\n";
	}

print "Centromere partern is $len_p bp\n";

open(OUT, ">pattern.info") or die"";
$count = 0;
foreach my $i(sort {$a<=>$b} keys %sumdb){
	$count++;
	next if($count>200);
	print OUT "$i	$sumdb{$i}\n";
	}
close OUT;

open(OUT, ">Rscript.cmd") or die"";
print OUT "data<-read.table(\"pattern.info\")\n";
print OUT "x<-data\$V1\n";
print OUT "y<-data\$V2\n";
print OUT "pdf(\"plot.pdf\")\n";
print OUT "plot(x,y,type=\"l\")\n";
print OUT "dev.off()\n";
close OUT;
system("chmod +x Rscript.cmd");
system("R CMD BATCH --no-save ./Rscript.cmd");


open(OUT, "> centro.trf.bed") or die"";
open(IN, "tandem.all.bed") or die"";
my $line=<IN>;
print OUT "$line";
while(<IN>){
	chomp;
	my @data = split(/\s+/,$_);
	my $pattern = $data[3];
	my $copynum = $data[4];
	my $score   = $data[8];
	next if($copynum<10);
	next if($score<1000);
	print OUT "$_\n" if($pattern>=$len_p-1 and $pattern<=$len_p+1);
	}
close IN;
close OUT;
