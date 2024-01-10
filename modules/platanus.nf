process platanus_run {
    publishDir "${params.outdir}/platanusOut/", mode: 'copy', overwrite: true
    label 'high_memory'
    //container '/cbio/projects/026/images/shortread_denovo_assemblers_2023-12-04.simg'
    tag "${sample}"

    input:
    tuple val(sample), val(reads)
    
    output:
    tuple val(sample),  path("${sample}_platanus-contig.fa"), emit: platanusout
    tuple val(sample), path("${sample}_platanus-32merFrq.tsv"), emit: platanusfrq_tsv
   
   //avg_len=\$(head -n 2 ${reads[0]} | tail -n 2 | wc -c)
    script:
    """
    ls -1h ${reads[0]} > ${sample}_pe.fofn
    ls -1h ${reads[1]} >> ${sample}_pe.fofn
    platanus_trim -i "${sample}_pe.fofn" -t ${params.threads}
    platanus assemble -o "${sample}_platanus" -t ${params.threads} -f "${reads[0]}.trimmed"  "${reads[1]}.trimmed" 
    mv ${sample}_platanus_contig.fa ${sample}_platanus-contig.fa
    mv ${sample}_platanus_32merFrq.tsv ${sample}_platanus-32merFrq.tsv
    """
    }
