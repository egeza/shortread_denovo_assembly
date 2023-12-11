process quast {
    publishDir "${params.outdir}/quastOut/${sample}/", mode: 'copy', overwrite: true
    label 'high'
    container '/cbio/projects/026/images/shortread_denovo_assemblers_2023-12-04.simg'
    tag "${sample}"

    input:
    tuple val(sample), val(reads)
    
    output:
    tuple val(sample), path(".fa"), emit: quastout
   
   // Run QUAST FOR ALL TOOLS
    script:
    """
    quast.py --output-dir ${params.outdir}"quastOut/"${sample}/  \
			 ${params.outdir}${tool}"Out/"${sample}/${samp}_contig.fa
        """
}
