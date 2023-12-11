// Define the process
process fastqc {
    publishDir "${params.outdir}/raw_fastqc/", mode: 'copy', overwrite: true
    label 'medium'
    //container '/cbio/projects/026/images/shortread_denovo_assemblers_2023-12-04.simg'

    input:
    tuple val(sample), path(reads)  
    
    output:
    path("*_fastqc.{zip,html}"), emit: fastqc_out // output files produced by fastqc 

    script:
    """
    fastqc ${reads}
    """
}
