process idba_run {
    publishDir "${params.outdir}/idbaOut/", mode: 'copy', overwrite: true
    label 'high_memory'
    //container '/cbio/projects/026/images/shortread_denovo_assemblers_2023-12-04.simg'
    tag "${sample}"

    input:
    tuple val(sample), val(reads)
    
    output:
    tuple val(sample), path("${sample}_idba-contig.fa"), path("${sample}_idba-scaffold.fa"), emit: idbaout
   
    script:
    """
    fq2fa --filter --merge  ${reads[0]}  ${reads[1]}  "${sample}.fa"
    idba_ud -r  "${sample}.fa" --num_threads ${params.threads} -o  ${sample}_idba
    mv ${sample}_idba/contig.fa ${sample}_idba-contig.fa
    mv ${sample}_idba/scaffold.fa ${sample}_idba-scaffold.fa
    """
    // ${IDBA}raw_n50  scaffold.fa
}
