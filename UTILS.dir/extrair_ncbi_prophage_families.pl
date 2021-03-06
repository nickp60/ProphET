#!/usr/bin/env perl

use strict;

# Given a tab delimited file having as the first column
# a bacteriophage family and its respective
# Taxonomy ID (NCBI) as the second column
# this script retrieves from Genbank the proteome 
# of all species belonging to each family

my $input = $ARGV[0];
open (INPUT, "$input");
my @N_seq = <INPUT>;
close(INPUT);

# Add date and time to summary stats
my $datestring = localtime();
`echo $datestring > phage_db.summary.stats`;

for (my $i=0; $i<=$#N_seq; $i++) {
	my @temp1 = split (/\t/, $N_seq[$i]); 
	my $name = $temp1[0];
	my $Tx_id = $temp1[1];
	
	print "Downloading $name from Genbank (NCBI) ...\n";
	mkdir ("$name.dir", 0755);
	chdir "$name.dir";
	my $output = system("../../UTILS.dir/retrieve_proteins.sh $name $Tx_id");
	chdir "../";
	
	chomp($Tx_id);
	# Add stats (#genomes #proteins) to phage_db.summary.stats
	`echo $name TaxId: $Tx_id >> phage_db.summary.stats`;
	`cat $name.dir/$Tx_id.ncbi_utils.log >> phage_db.summary.stats`;
	`cat $name.dir/$Tx_id.prot.log >> phage_db.summary.stats`;
}
