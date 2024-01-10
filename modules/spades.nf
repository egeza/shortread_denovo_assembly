process spades_run {
    publishDir "${params.outdir}/spadesOut/", mode: 'copy', overwrite: true
    label 'high_spades'
    tag "${sample}"

    input:
    tuple val(sample), val(reads)
    
    output:
    tuple val("${sample}"), path("${sample}_spades-contig.fa"), emit: spadesout
    tuple val(sample), path("${sample}_spades-scaffolds.fa"), emit: spadesscaf
    
    script:
    """
    spades.py --careful -t ${params.threads} -1 ${reads[0]} -2 ${reads[1]} -o ${sample}
    mv ${sample}/contigs.fasta ${sample}_spades-contig.fa
    mv ${sample}/scaffolds.fasta ${sample}_spades-scaffolds.fa
    """
}
