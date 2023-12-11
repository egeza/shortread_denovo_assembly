process spades_run {
    publishDir "${params.outdir}/spadesOut/", mode: 'copy', overwrite: true
    label 'high_spades'
    tag "${sample}"

    input:
    tuple val(sample), val(reads)
    
    output:
    tuple val("${sample}"), path("${sample}/*s.fasta"), path("${sample}/assembly_graph.fastg"), 
path("${sample}/spades.log"), path("${sample}/*.yaml"), emit: spadesout
    
    script:
    """
    spades.py --careful -t ${params.threads} -1 ${reads[0]} -2 ${reads[1]} -o ${sample}
    """
}
