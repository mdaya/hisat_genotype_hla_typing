#!/bin/bash

#Input parameters
nr_threads=$1
fq_1=$2
fq_2=$3
sample_id=`basename $fq_1 | cut -f1 -d"_"` 
#Create soft links to reference files required by HISAT-genotype to be in the current
#working directory
shift
shift
shift
for file in "$@"
do
  target_file=`basename $file`
  ln -s $file $target_file
done

#Output parameters
out_file_name=${sample_id}_hla_report.txt

#Setup paths
export PATH="/home/biodocker/hisat-genotype:/home/biodocker/hisat-genotype/hisatgenotype_scripts:$PATH"
export PYTHONPATH="${PYTHONPATH}:/home/biodocker/hisat-genotype/hisatgenotype_modules/"

#Extract reads that map to HLA
hisatgenotype_toolkit extract-reads --base hla -1 $fq_1 -2 $fq_2 --threads $nr_threads

#Type HLA
hisatgenotype_toolkit locus -x genotype_genome \
   --base hla \
   --locus-list A,B,C,DRB1,DQA1,DQB1 \
   -1 ${sample_id}_extract.bam.1.fq.gz-hla-extracted-1.fq.gz \
   -2 ${sample_id}_extract.bam.1.fq.gz-hla-extracted-2.fq.gz \
   --threads $nr_threads

#Copy output
mv assembly_graph-hla-${sample_id}_extract.report $out_file_name 
