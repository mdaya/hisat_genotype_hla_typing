class: CommandLineTool
cwlVersion: v1.0
label: type_hla
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: ResourceRequirement
  ramMin: 8000
- class: DockerRequirement
  dockerPull: quay.io/mdaya/hisat_genotype_hla_typing:0.09

inputs:
- id: fq_1
  label: fq_1
  doc: FASTQ gunzipped files with reads from pair 1
  type: File
  inputBinding:
    position: 1
    shellQuote: false
  sbg:fileTypes: .FQ.GZ
- id: fq_2
  label: fq_2
  doc: FASTQ gunzipped files with reads from pair 2
  type: File
  inputBinding:
    position: 2
    shellQuote: false
  sbg:fileTypes: .FQ.GZ
- id: hisat_gt_ref_files
  label: hisat_gt_ref_files
  doc: List of reference files required by HISAT-genotype
  type: File[]
  inputBinding:
    position: 3
    shellQuote: false

outputs:
- id: hla_report
  label: hla_report
  doc: HLA typing report
  type: File
  outputBinding:
    glob: '*_hla_report.txt'

baseCommand:
- bash /home/biodocker/hisat_genotype_run/type_hla.sh
arguments:
- prefix: ''
  position: 0
  valueFrom: '4'
  shellQuote: false
id: midaya/hisat-genotype-hla-typing/type-hla/3
sbg:appVersion:
- v1.0
sbg:content_hash: ab00b7e53cd3921467ed8c792ed0ad1375d278cca00d0f61d26aeb82ca7c831ff
sbg:contributors:
- midaya
sbg:createdBy: midaya
sbg:createdOn: 1589324638
sbg:id: midaya/hisat-genotype-hla-typing/type-hla/3
sbg:image_url:
sbg:latestRevision: 3
sbg:modifiedBy: midaya
sbg:modifiedOn: 1589575248
sbg:project: midaya/hisat-genotype-hla-typing
sbg:projectName: HISAT-genotype HLA typing
sbg:publisher: sbg
sbg:revision: 3
sbg:revisionNotes: Changed ref files to have end binding
sbg:revisionsInfo:
- sbg:modifiedBy: midaya
  sbg:modifiedOn: 1589324638
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: midaya
  sbg:modifiedOn: 1589324927
  sbg:revision: 1
  sbg:revisionNotes: initial version
- sbg:modifiedBy: midaya
  sbg:modifiedOn: 1589327600
  sbg:revision: 2
  sbg:revisionNotes: Added list of HISAT-genotype reference files
- sbg:modifiedBy: midaya
  sbg:modifiedOn: 1589575248
  sbg:revision: 3
  sbg:revisionNotes: Changed ref files to have end binding
sbg:sbgMaintained: false
sbg:validationErrors: []
