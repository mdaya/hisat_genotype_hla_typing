A docker environment and calling script to run HISAT\_genotype on Seven Bridges on Biodata catalyst.

The docker build can be pulled from https://quay.io/repository/mdaya/hisat\_genotype\_hla\_typing

The .cwl file contains the workflow steps to run this on Seven Bridges

To run HLA-typing from a docker instance on a local machine, use the following commands from the docker instance:

## Step 1

```
bash /home/biodocker/hisat_genotype_run/extract_reads.sh \<nr\_threads\> \<cram\_file\_name\> \<ref\_fasta\_file\_name\> 
```

### extract_threads parameters

All parameters are mandatory and should be specified in order

#### nr_threads

Set to the number of CPU cores available on the compute instance

#### cram_file_name

Full path name of the CRAM file on which HLA typing should be run. A corresponding CRAM index file should also be available.

#### ref_fasta_file_name

The reference fasta file used originally to create the CRAM file. A corresoponding index file should also be available.


## Step 2

```
bash /home/biodocker/hisat_genotype_run/type_hla.sh \<nr\_threads\> \<fq\_1\> \<fq\_2\> \<list\_of\_files\_in\_extracted\_hist\_gt\_ref\>
```

### type_hla parameters

#### nr_threads

Set to the number of CPU cores available on the compute instance

#### fq_1

The name of the first FASTQ file output by the extract\_threads step

#### fq_2

The name of the second FASTQ file output by the extract\_threads step

#### list_of_files_in_extracted_hist_gt_ref

A list of HISAT-genotype reference files in the hisat\_gt\_ref directory (see
steps to create below)

## Creation of the graph file archive

The reference files required by HISAT-genotype for HLA typing was created as
follows (running from a docker instance with HISAT-genotype installed):

```
mkdir hisat_gt_ref
cd hisat_gt_ref
wget ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat-genotype/data/genotype_genome_20180128.tar.gz
tar xvzf genotype_genome_20180128.tar.gz
wget ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat-genotype/data/hla/ILMN.tar.gz
tar xvzf ILMN.tar.gz
hisatgenotype --base hla -1 ILMN/NA12892.extracted.1.fq.gz -2 ILMN/NA12892.extracted.2.fq.gz
rm -r ILMN
rm ILMN.tar.gz
rm genotype_genome_20180128.tar.gz
rm -r hisatgenotype_out
rm -r hisatgenotype_db
rm -r grch38
rm grch38.tar.gz
cd ..
tar -czvf hisat_gt_ref.tar.gz ./hisat_gt_ref
```
