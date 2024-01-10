process integratecontigs {
	publishDir "${params.outdir}/intergratedcontigOut/", mode: "copy", overwrite: true
	label 'high_spades'
	tag "${sample}"

	input:
	tuple val(sample), path(contigs)

	output:
	tuple val(sample), path("${sample}_master_contigs.fa"), emit: mastercontigs
	tuple val(sample), path("${sample}_master_integrated_contigs.fa"), emit: cisaintegratedcontigs
	//tuple val(sample), path("${sample}_master_integrated_contigs.fa"), emit: cisaintegratedquastcontigs

	shell:
	'''
	#!/bin/sh
	echo count=6 > Merge.config
	echo data=!{contigs[0]},title=Contigs0 >> Merge.config
	echo data=!{contigs[1]},title=Contigs1 >> Merge.config
	echo data=!{contigs[2]},title=Contigs2 >> Merge.config
	echo data=!{contigs[3]},title=Contigs3 >> Merge.config
	echo data=!{contigs[4]},title=Contigs4 >> Merge.config
	echo data=!{contigs[5]},title=Contigs5 >> Merge.config
	echo Master_file=!{sample}_master_contigs.fa >> Merge.config
	Merge.py Merge.config
	echo genome=`grep "Whole Genome" 'Merge_info' | cut -d ':' -f2 | sort -rn | head -n 1 | tr -d [:space:]` > CISA.config
	echo infile=!{sample}_master_contigs.fa >> CISA.config
	echo outfile=!{sample}_master_integrated_contigs.fa >> CISA.config
	echo nucmer=`which nucmer` >> CISA.config
	echo R2_Gap=0.95 >> CISA.config
	echo CISA=${CISA} >> CISA.config
	echo makeblastdb=`which makeblastdb` >> CISA.config
	echo blastn=`which blastn` >> CISA.config
	CISA.py CISA.config
	'''
}
//echo data=!{contigs[6]},title=Contigs6 >> Merge.config
	