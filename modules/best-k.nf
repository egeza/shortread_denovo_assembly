process identifybestkmer {
	publishDir("${params.outdir}/kmerOut/", mode: 'copy', overwrite: true)
    label 'high_spades'
	//container '/cbio/projects/025/images/769bd43d8bc4-2019-03-04-4d3032297a78.img'
    tag "${sample}"


	input:
		tuple val(sample), val(reads)

	output:
		tuple val(sample), val(reads), path("${sample}_bestk.txt"), emit: kmergenieout
		
	script:	
	"""
	echo ${reads[0]} > ${sample}_kmerlist.txt
	echo ${reads[1]} >> ${sample}_kmerlist.txt
	kmergenie "${sample}_kmerlist.txt" -o ${sample} | tail -n 1 | awk '{print \$3}' > ${sample}_bestk.txt
	"""
    }
