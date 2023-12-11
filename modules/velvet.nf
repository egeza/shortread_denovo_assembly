process velvet_run {
    publishDir("${params.outdir}/velvetOut/", mode: 'copy', overwrite: true)
    label 'high_memory'
    //container '/cbio/projects/026/images/shortread_denovo_assemblers_2023-12-04.simg' // /cbio/projects/025/images/769bd43d8bc4-2019-03-04-4d3032297a78.img
    tag "${sample}"

    input:
    tuple val(sample), val(reads), path(bestkmerfile)
    
    output:
    tuple val(sample), path("${sample}/contigs.fa"), path("$sample/stats.txt"), emit: velvetout
   
    script:
    """
    kmersize=\$(cat ${bestkmerfile})
    velvetoptimiser -f "-shortPaired -fastq -separate ${reads[0]} ${reads[1]}" -s 30 -e 75 -d ${sample}
    """
    }
