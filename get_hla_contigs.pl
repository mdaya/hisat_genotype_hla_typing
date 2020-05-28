#!/usr/bin/env perl

#The contents of this perl script was selectively extracted from HLA-LA.pl
#https://github.com/DiltheyLab/HLA-LA, commit 5311e5b

use warnings;
use strict;

#Set arguments; note that these file locations assume the environmenet specified in the Dockerfile
my $BAM = $ARGV[0];
my $samtools_bin = "/usr/bin/samtools";
my $known_references_dir = "/home/biodocker/hisat_genotype_run/known_references";

# get index for this BAM
my $command_idxstats = qq($samtools_bin idxstats $BAM);
my $command_idxstats_output = `$command_idxstats`;
unless($command_idxstats_output)
{
	die "Didn't get a sensible output from command $command_idxstats";
}
my %BAM_idx;
my @BAM_idx_contigOrder;
my @idxstats_lines = split(/\n/, $command_idxstats_output);
foreach my $l (@idxstats_lines)
{
	my @l_fields = split(/\t/, $l);
	die unless(scalar(@l_fields) >= 1);
	die if(exists $BAM_idx{$l_fields[0]});
	$BAM_idx{$l_fields[0]} = $l_fields[1];
	push(@BAM_idx_contigOrder, $l_fields[0]);
}

my @files_references = glob($known_references_dir . '/*.txt');
die "No known reference files in knownReferences ($known_references_dir)?" unless(@files_references);

my @compatible_files;
my %extractContigs_complete_byFile;
my %extractContigs_partial_byFile;
foreach my $f (@files_references)
{
	open(F, '<', $f) or die "Cannot open $f";
	my $F_firstLine = <F>;
	chomp($F_firstLine);
	my @firstLine_fields = split(/\t/, $F_firstLine);
	my @expected_firstLine_fields = qw/contigID contigLength ExtractCompleteContig PartialExtraction_Start PartialExtraction_Stop/;
	die "Incorrect header for $f ($#firstLine_fields vs $#expected_firstLine_fields)" unless($#firstLine_fields == $#expected_firstLine_fields);
	for(my $i = 0; $i <= $#firstLine_fields; $i++)
	{
		die "Incorrect header for $f - expect $expected_firstLine_fields[$i], got $firstLine_fields[$i]" unless($firstLine_fields[$i] eq $expected_firstLine_fields[$i]);
	}
	
	my $n_contigs = 0;
	my $n_contigs_matching = 0;
	while(<F>)
	{
		my $line = $_;
		chomp($line);
		next unless($line);
		my @line_fields = split(/\t/, $line, -1);
		$n_contigs++;
		if((exists $BAM_idx{$line_fields[0]}) and ($BAM_idx{$line_fields[0]} == $line_fields[1]))
		{
			$n_contigs_matching++;
		}
		else
		{
			# print "Mismatch $line_fields[0] - $line_fields[1] - " . $BAM_idx{$line_fields[0]} . "\n";
		}
		
		die if(($line_fields[2]) and (($line_fields[3]) and ($line_fields[4])));
		
		if($line_fields[2])
		{
			if($line_fields[0] eq '*')
			{
				$extractContigs_complete_byFile{$f}{$line_fields[0]} = 1;
			}
			else
			{
				$extractContigs_partial_byFile{$f}{$line_fields[0]} = [1, $line_fields[1]];						
			}
		}
		
		if(($line_fields[3]) and ($line_fields[4]))
		{	
			die if($line_fields[0] eq '*');
			die "Coordinate field $line_fields[3] has non-numeric characters" unless($line_fields[3] =~ /^\d+$/);
			die "Coordinate field $line_fields[4] has non-numeric characters" unless($line_fields[4] =~ /^\d+$/);
			
			$extractContigs_partial_byFile{$f}{$line_fields[0]} = [$line_fields[3], $line_fields[4]];			
		}
	}	
	close(F);

	if(($n_contigs_matching == $n_contigs) and ($n_contigs == scalar(@BAM_idx_contigOrder)))
	{
		push(@compatible_files, $f);
	}
}

if(scalar(@compatible_files) == 0)
{
	die "Have found no compatible reference specifications in $known_references_dir - create a file for this BAM file and try again.";
}
if(scalar(@compatible_files) > 1)
{
	die "Found more than one compatible reference file in $known_references_dir - a duplicate?\n\n".Dumper(\@compatible_files);
}

my $compatible_reference_file = $compatible_files[0];

my @refIDs_for_extraction;
foreach my $refID (@BAM_idx_contigOrder)
{
	next if($refID eq '*');
	die if((exists $extractContigs_complete_byFile{$compatible_reference_file}{$refID}) and (exists $extractContigs_partial_byFile{$compatible_reference_file}{$refID}));
	die unless((not defined $extractContigs_complete_byFile{$compatible_reference_file}{$refID}) or ($extractContigs_complete_byFile{$compatible_reference_file}{$refID} eq '0') or ($extractContigs_complete_byFile{$compatible_reference_file}{$refID} eq '1'));
	if($extractContigs_complete_byFile{$compatible_reference_file}{$refID})
	{
		push(@refIDs_for_extraction, $refID);
	}
	if($extractContigs_partial_byFile{$compatible_reference_file}{$refID})
	{
		push(@refIDs_for_extraction, $refID . ':' . $extractContigs_partial_byFile{$compatible_reference_file}{$refID}[0] . '-' . $extractContigs_partial_byFile{$compatible_reference_file}{$refID}[1]);
	}
}

die "No contigs for extraction specified in $compatible_reference_file?" unless(scalar(@refIDs_for_extraction));

open(FH, '>', "contigs.txt") or die $!;
print FH join(' ', @refIDs_for_extraction);
close(FH);
