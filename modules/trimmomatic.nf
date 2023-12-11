// Process trimmomatic
process trimmomatic {
  publishDir "${params.outdir}/trimmed-reads", mode: 'copy'
  label "high"
  //container '/cbio/projects/026/images/shortread_denovo_assemblers_2023-12-04.simg'

  // Same input as fastqc on raw reads, comes from the same channel. 
  input:
  tuple val(sample), path(reads) 

  output:
  tuple val("${sample}"), path("${sample}*_paired.fastq"), emit: paired_fastq
  tuple val("${sample}"), path("${sample}*_unpaired.fastq"), emit: unpaired_fastq

  script:
  """
  trimmomatic PE -threads ${params.threads} \\
  ${reads[0]} ${reads[1]} ${sample}_1_paired.fastq ${sample}_1_unpaired.fastq \\
  ${sample}_2_paired.fastq ${sample}_2_unpaired.fastq \\
  ${params.slidingwindow} \\
  ${params.adapters} \\
  ${params.crop} \\
  ${params.leading} \\
  ${params.trailing}
  """
}
