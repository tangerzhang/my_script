#!perl

###Usage: perl cds2pro.pl input.cds.fasta > output.pro.fasta

use Bio::SeqIO;


$file_name = $ARGV[0];
my $sequences = Bio::SeqIO->new( 
    -file   => $file_name,
    -format => "fasta",
);

while ( my $dna = $sequences->next_seq ){
    my $protein = $dna->translate( 
        -codontable_id => 1, # standard genetic code
        -frame         => 0, #reading-frame offset 0
    );
    print ">", $dna->display_id, "\n";
    print $protein->seq, "\n\n";
}
