process stride_run {
    publishDir "${params.outdir}/strideOut/", mode: 'copy', overwrite: true
    label 'high_memory'
    //container '/cbio/projects/026/images/shortread_denovo_assemblers_2023-12-04.simg'
    tag "${sample}"

    input:
    tuple val(sample), val(reads)
    
    output:
    tuple val(sample), path("${sample}_stride-contig.fa"), emit: strideout
   
    script:
    """
    avg_len=\$(head -n 2 ${reads[0]} | tail -n 2 | wc -c)
    max_read_len=\$(seqkit stat -T ${reads[0]} | awk 'NR == 2 { print \$8 }')
    stride all -r \$max_read_len -i \$avg_len ${reads[0]} ${reads[1]}
    mv StriDe-contigs.fa ${sample}_stride-contig.fa
    """
}
