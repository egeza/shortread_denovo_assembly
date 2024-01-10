process minia_run {
    publishDir "${params.outdir}/miniaOut/", mode: 'copy', overwrite: true
    label 'high_memory'
    //container '/cbio/projects/026/images/shortread_denovo_assemblers_2023-12-04.simg'
    tag "${sample}"

    input:
    tuple val(sample), val(reads), path(bestkmerfile)
    
    output:
    tuple val(sample), path("${sample}_minia-contig.fa"), emit: miniaout
   
    script:
    """
    kmersize=\$(cat ${bestkmerfile})
    /bin/fq2fa --filter --merge  ${reads[0]}  ${reads[1]}  "${sample}.fa"
    minia -in  "${sample}.fa" -out "${sample}_minia" -kmer-size \$kmersize  -nb-cores 1 
    mv ${sample}_minia.contigs.fa ${sample}_minia-contig.fa
    """
    // mv "${sample}.contigs.fa" "${sample}-minia.contigs.fa"
}
