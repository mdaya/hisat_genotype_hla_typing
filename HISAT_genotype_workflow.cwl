class: Workflow
cwlVersion: v1.0
label: HISAT genotype workflow
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: InlineJavascriptRequirement
- class: StepInputExpressionRequirement

inputs:
- id: input_archive_file
  label: Input archive file
  doc: The input archive file to be unpacked.
  type: File
  sbg:fileTypes: TAR, TAR.GZ, TGZ, TAR.BZ2, TBZ2, GZ, BZ2, ZIP
  sbg:x: -1162
  sbg:y: -945
- id: ref_fasta_file
  label: ref_fasta_file
  doc: Reference FASTA file used for alignment in CRAM file
  type: File
  secondaryFiles:
  - .fai
  sbg:fileTypes: .FA
  sbg:x: -1163
  sbg:y: -810
- id: cram_file
  label: cram_file
  doc: CRAM file
  type: File
  secondaryFiles:
  - .crai
  sbg:fileTypes: .CRAM
  sbg:x: -1162
  sbg:y: -664

outputs:
- id: hla_report
  label: hla_report
  doc: HLA typing report
  type: File
  outputSource:
  - type_hla/hla_report
  sbg:x: -466
  sbg:y: -829

steps:
- id: extract_reads
  label: extract_reads
  in:
  - id: cram_file
    source: cram_file
  - id: ref_fasta_file
    source: ref_fasta_file
  run: HISAT_genotype_workflow.cwl.steps/extract_reads.cwl
  out:
  - id: fq_1
  - id: fq_2
  sbg:x: -912
  sbg:y: -728
- id: type_hla
  label: type_hla
  in:
  - id: fq_1
    source: extract_reads/fq_1
  - id: fq_2
    source: extract_reads/fq_2
  - id: hisat_gt_ref_files
    source:
    - sbg_decompressor_cwl1_0/output_files
  run: HISAT_genotype_workflow.cwl.steps/type_hla.cwl
  out:
  - id: hla_report
  sbg:x: -650
  sbg:y: -829
- id: sbg_decompressor_cwl1_0
  label: SBG Decompressor CWL1.0
  in:
  - id: input_archive_file
    source: input_archive_file
  run: HISAT_genotype_workflow.cwl.steps/sbg_decompressor_cwl1_0.cwl
  out:
  - id: output_files
  sbg:x: -915
  sbg:y: -946
sbg:appVersion:
- v1.0
sbg:content_hash: a7ec596ba06b0724b969db6f14024c09aaf2c8a2eb6ddefbad885e6183ca1a4e1
sbg:contributors:
- midaya
sbg:createdBy: midaya
sbg:createdOn: 1589839101
sbg:id: midaya/hla-typing-fhs-duplicates-1/hisat-genotype-workflow-3/1
sbg:image_url: |-
  https://platform.sb.biodatacatalyst.nhlbi.nih.gov/ns/brood/images/midaya/hla-typing-fhs-duplicates-1/hisat-genotype-workflow-3/1.png
sbg:latestRevision: 1
sbg:modifiedBy: midaya
sbg:modifiedOn: 1590719717
sbg:original_source: |-
  https://api.sb.biodatacatalyst.nhlbi.nih.gov/v2/apps/midaya/hla-typing-fhs-duplicates-1/hisat-genotype-workflow-3/1/raw/
sbg:project: midaya/hla-typing-fhs-duplicates-1
sbg:projectName: HLA typing FHS duplicates
sbg:publisher: sbg
sbg:revision: 1
sbg:revisionNotes: Changed to docker build tag 0.09
sbg:revisionsInfo:
- sbg:modifiedBy: midaya
  sbg:modifiedOn: 1589839101
  sbg:revision: 0
  sbg:revisionNotes: Copy of midaya/hisat-genotype-hla-typing/hisat-genotype-workflow-3/1
- sbg:modifiedBy: midaya
  sbg:modifiedOn: 1590719717
  sbg:revision: 1
  sbg:revisionNotes: Changed to docker build tag 0.09
sbg:sbgMaintained: false
sbg:validationErrors: []
