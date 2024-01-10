process abyss_run {
    publishDir "${params.outdir}/abyssOut/", mode: 'copy', overwrite: true
    label 'high_spades'
    //container '/cbio/projects/026/images/denovo_assemblers_latest-2023-07-03-ee279da8a081.simg'
    tag "${sample}"

    input:
    tuple val(sample), val(reads), path(bestkmerfile)
    
    output:
    tuple val(sample), path("${sample}_abyss-contigs.fa"), emit: abyssout
    tuple  val(sample), path("${sample}_abyss-scaffolds.fa"), path("${sample}_abyss-unitigs.fa"), emit: abyssscaffolds

    script:
    """
    kmersize=\$(cat ${bestkmerfile})
    abyss-pe k=\$kmersize l=1 n=5 s=100 np=4 name="${sample}" lib='reads' in="${reads[0]} ${reads[1]}"
    #mv     
    """
    
    }
