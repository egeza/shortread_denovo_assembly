process qcmetrics_quast {
	publishDir "${params.outdir}/assemblyReport", mode: "move"
    label 'high_memory'
    tag "${sample}"


	input:
	tuple val(sample), path(quastcontigs)

	output:
	path("${sample}_*"), emit: quastevaluation
	
	shell:
	'''
	#!/bin/sh
	quast.py !{quastcontigs[0]} !{quastcontigs[1]} !{quastcontigs[2]} !{quastcontigs[3]} !{quastcontigs[4]} !{quastcontigs[5]} !{quastcontigs[6]} !{quastcontigs[7]} --space-efficient --threads ${params.threads} -o output
        mkdir quast_output
        find output/ -maxdepth 2 -type f | xargs mv -t quast_output
        cd quast_output
        ls * | xargs -I {} mv {} !{sample}_{}
        mv * ../
	'''	
}

