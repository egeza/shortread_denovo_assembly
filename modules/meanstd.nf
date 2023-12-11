process mean_std {
    publishDir "${params.outdir}/mean_std/${sample}/", mode: 'copy', overwrite: true
    label 'high'
    //container '/cbio/projects/026/images/shortread_denovo_assemblers_2023-12-04.simg'
    tag "${sample}"

    input:
    tuple val(sample), val(reads)
    //path(inputfiles)
    
    output:
    tuple val(sample), val(reads), path("${sample}_mean_std.txt"), emit: meanstdout
       
    script:
    """
    echo ${sample}
    seqtk comp ${reads[0]}  | cut -f 2 | datamash mean 1 | datamash round 1 > ${sample}_mean_std.txt
    seqtk comp ${reads[0]}  | cut -f 2 | datamash sstdev 1 | datamash round 1 >> ${sample}_mean_std.txt
    """
}
