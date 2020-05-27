#!/bin/bash

#Input parameters
nr_threads=$1
cram_file_name=$2
ref_fasta_file_name=$3
sample_id=`basename $cram_file_name | cut -f1 -d"."` 
let "nr_threads = nr_threads - 1"   #Minus the main thread as required by samtools

#Output parameters
fq_1=${sample_id}_extract.bam.1.fq.gz 
fq_2=${sample_id}_extract.bam.2.fq.gz 

#Extract MHC region to a temporary bam file
/usr/bin/samtools view -F 4 \
   -@ $nr_threads \
   -T $ref_fasta_file_name -t ${ref_fasta_file_name}.fai \
   -bo ${sample_id}_MHC.bam $cram_file_name chr6:2700000-35000000

#Extract unmapped reads to a temporary bam file
/usr/bin/samtools view -f 4 \
   -@ $nr_threads \
   -T $ref_fasta_file_name -t ${ref_fasta_file_name}.fai \
   -bo ${sample_id}_unmapped.bam $cram_file_name 

#Extract supplementary reads to a temporary bam file
/usr/bin/samtools view -F 800 \
   -@ $nr_threads \
   -T $ref_fasta_file_name -t ${ref_fasta_file_name}.fai \
   -bo ${sample_id}_suppl.bam $cram_file_name 

#Merge the 2 temporary bam files
/usr/bin/samtools merge  -@ $nr_threads ${sample_id}_extract.bam \
   ${sample_id}_MHC.bam ${sample_id}_unmapped.bam ${sample_id}_suppl.bam 

#Extract reads from the merged bam file to fastq zipped files
java -Xmx10G -jar /home/biodocker/picard/picard.jar SamToFastq \
   I=${sample_id}_extract.bam \
   FASTQ=$fq_1 SECOND_END_FASTQ=$fq_2 \
   NON_PF=true RE_REVERSE=true VALIDATION_STRINGENCY=LENIENT

