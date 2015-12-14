#!perl

###I can't remember makeblastdb and blast paramters all the time
###Therefore develop this script for simple blast+

use Getopt::Std;
getopts "i:d:p:c:e:o:f:n:";


if ((!defined $opt_i)|| (!defined $opt_d)  || (!defined $opt_p)) {
    die "************************************************************************
    Usage: perl simple_blast.pl -i query.fasta -d database -p blastn -c cpu -e evalue -o output -f outfmt -n num_of_align
      -h : help and usage.
      -i : query.fasta
      -d : database.fasta
      -p : program, could be blastn, blastp or blastx
      -c : cpu (default 4)
      -e : evalue (default 1e-3)
      -o : output (default: blast.out)
      -f : output format (default 6);
      -n : number of alignment (default all)
************************************************************************\n";
}else{
  print "************************************************************************\n";
  print "Version demo\n";
  print "Copyright to Tanger, tanger.zhang@gmail.com\n";
  print "RUNNING...\n";
  print "************************************************************************\n";
	
	}

my $database = $opt_d;
my $query    = $opt_i;
my $program  = $opt_p;
my $cpu      = (defined $opt_c)?$opt_c:4;
my $evalue   = (defined $opt_e)?$opt_e:1e-3;
my $output   = (defined $opt_o)?$opt_o:"blast.out";
my $outfmt   = (defined $opt_f)?$opt_f:6;
my $num_aln  = (defined $opt_n)?$opt_n:0;
my $dbtype;

if($program eq "blastn"){
	$dbtype = "nucl";
}else{
	$dbtype = "prot";
	}

$files = `ls *`;
print "\n\nWill overwrite dbname\n" if($files =~ /dbname/);
	
$cmd = "makeblastdb -in ".$database." -dbtype ".$dbtype." -out dbname";
print "$cmd\n";
system($cmd);

$cmd = $program." -query ".$query." -db dbname -out blast.out -evalue ".$evalue." -outfmt ".$outfmt." -num_threads ".$cpu;

if($num_aln != 0){
	$cmd .= " -num_alignments ".$num_aln;
	}

print "\n\n$cmd\n";
system($cmd);
