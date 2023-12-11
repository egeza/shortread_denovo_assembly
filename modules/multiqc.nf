process multiqc {
    publishDir("${params.outdir}/multiqc/", mode: 'copy', overwrite: true)
    label 'medium'
    //container '/cbio/projects/026/images/shortread_denovo_assemblers_2023-12-04.simg'

    input:
    path (inputfiles)

    output:
    path "multiqc_report.html"					

    script:
    """
    multiqc .
    """
}
