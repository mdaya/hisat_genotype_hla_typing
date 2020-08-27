class: CommandLineTool
cwlVersion: v1.0
label: extract_reads
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: ResourceRequirement
  ramMin: 8000
- class: DockerRequirement
  dockerPull: quay.io/mdaya/hisat_genotype_hla_typing:0.09

inputs:
- id: cram_file
  label: cram_file
  doc: CRAM file
  type: File
  secondaryFiles:
  - .crai
  inputBinding:
    position: 1
    shellQuote: false
  sbg:fileTypes: .CRAM
- id: ref_fasta_file
  label: ref_fasta_file
  doc: Reference FASTA file used for alignment in CRAM file
  type: File
  secondaryFiles:
  - .fai
  inputBinding:
    position: 2
    shellQuote: false
  sbg:fileTypes: .FA

outputs:
- id: fq_1
  label: fq_1
  doc: FASTQ gunzipped files with reads from pair 1
  type: File
  outputBinding:
    glob: '*_extract.bam.1.fq.gz '
  sbg:fileTypes: .FQ.GZ
- id: fq_2
  label: fq_2
  doc: FASTQ gunzipped files with reads from pair 2
  type: File
  outputBinding:
    glob: '*_extract.bam.2.fq.gz '
  sbg:fileTypes: .FQ.GZ

baseCommand:
- bash /home/biodocker/hisat_genotype_run/extract_reads.sh
arguments:
- prefix: ''
  position: 0
  valueFrom: '4'
  shellQuote: false

hints:
- class: sbg:AWSInstanceType
  value: m3.xlarge;ebs-gp2;50
id: midaya/hisat-genotype-hla-typing/extract-reads/2
sbg:appVersion:
- v1.0
sbg:content_hash: a1e7e2de68da2fb6a3aa0db6b6951b3d65501da66961f86f363789a198e7b91f5
sbg:contributors:
- midaya
sbg:createdBy: midaya
sbg:createdOn: 1589322781
sbg:id: midaya/hisat-genotype-hla-typing/extract-reads/2
sbg:image_url:
sbg:latestRevision: 2
sbg:modifiedBy: midaya
sbg:modifiedOn: 1589401569
sbg:project: midaya/hisat-genotype-hla-typing
sbg:projectName: HISAT-genotype HLA typing
sbg:publisher: sbg
sbg:revision: 2
sbg:revisionNotes: Added computational hint
sbg:revisionsInfo:
- sbg:modifiedBy: midaya
  sbg:modifiedOn: 1589322781
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: midaya
  sbg:modifiedOn: 1589324114
  sbg:revision: 1
  sbg:revisionNotes: Initial version
- sbg:modifiedBy: midaya
  sbg:modifiedOn: 1589401569
  sbg:revision: 2
  sbg:revisionNotes: Added computational hint
sbg:sbgMaintained: false
sbg:validationErrors: []
