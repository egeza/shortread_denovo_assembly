#!/usr/bin/env nextflow

log.info """\
      LIST OF PARAMETERS
================================
            GENERAL
Data-folder      : ${params.datadir}
Results-folder   : ${params.outdir}
================================
      INPUT
Input-files      : ${params.reads}
================================
          TRIMMOMATIC
Sliding window   			:	${params.slidingwindow}
Average quality  			:	${params.avgqual}
Adapters				:	${params.adapters}
Trim end reads				:	${params.crop}
Trim low Qual reads at beginning	:	${params.leading}
Trim low Qual reads at end		:	${params.trailing}

================================
             SpaDes
Threads          : ${params.threads}
=================================
              Running pipeline
nextflow assembly.nf \
--datadir "/cbio/projects/026/results/test-nextflow/fastq"  \
--outdir "/cbio/projects/026/results/test-nextflow/check/" \
-config "/cbio/projects/026/results/test-nextflow/denovo-assembly.conf" -resume
================================
"""

// Also channels are being created. 
read_pairs_ch = Channel
        .fromFilePairs(params.reads, checkIfExists:true)

include { fastqc as fastqc_raw; fastqc as fastqc_trim } from "${projectDir}/modules/fastqc" //addParams(OUTPUT: fastqcOutputFolder)
include { trimmomatic } from "${projectDir}/modules/trimmomatic"
include {spades_run  } from "${projectDir}/modules/spades"
include {minia_run  } from "${projectDir}/modules/minia"
//include {abyss_run  } from "${projectDir}/modules/abyss"
include {velvet_run } from "${projectDir}/modules/velvet"
include {soapdenovo_run } from "${projectDir}/modules/soapdenovo"
include {stride_run  } from "${projectDir}/modules/stride"
include {mean_std  } from "${projectDir}/modules/meanstd"
include {masurca_run  } from "${projectDir}/modules/masurca"
include {platanus_run  } from "${projectDir}/modules/platanus"
include {integratecontigs  } from "${projectDir}/modules/cisa"
include {qcmetrics_quast  } from "${projectDir}/modules/quast"
include { multiqc } from "${projectDir}/modules/multiqc" 
include { identifybestkmer } from "${projectDir}/modules/best-k" 

// Running a workflow with the defined processes here.  
workflow {
  // QC on raw reads
  fastqc_raw(read_pairs_ch) 
	
  // Trimming & QC
  trimmomatic(read_pairs_ch)
  fastqc_trim(trimmomatic.out.paired_fastq)
	
  // kmergenie
  identifybestkmer(trimmomatic.out.paired_fastq)
  
  // SpaDes
  spades_run(trimmomatic.out.paired_fastq)
  
  // PLATANUS ASSEMBLY KILLED IT MIGHT BE MEMORY ISSUE
  platanus_run(trimmomatic.out.paired_fastq)

  // STRIDE
  stride_run(trimmomatic.out.paired_fastq)
  
  //SOAPDENOVO
  soapdenovo_run(identifybestkmer.out.kmergenieout)
  
 // MINIA
  minia_run(identifybestkmer.out.kmergenieout)

 // ABYSS ASSEMBLY
// abyss_run(identifybestkmer.out.kmergenieout)

 //MASURCA mean_std for calculating avg_ins and std
  mean_std(trimmomatic.out.paired_fastq)
  masurca_run(mean_std.out.meanstdout)

 //VELVET
  velvet_run(identifybestkmer.out.kmergenieout)

 // Multi QC on all results
  multiqc_input = fastqc_raw.out.fastqc_out
    .mix(fastqc_trim.out.fastqc_out)
    .collect()
  multiqc(multiqc_input)
 
 // Concatenate or produce a tuple of assemble to ensure they are integrated well in CISA
 cisa_input = velvet_run.out.velvetout.concat(
		masurca_run.out.masurcaout,
		spades_run.out.spadesout,
		stride_run.out.strideout,
		platanus_run.out.platanusout,
		soapdenovo_run.out.soapdenovoout,
		minia_run.out.miniaout
		)
  
  integratecontigs(cisa_input)
	//.groupTuple(sort: true, size: 7)
	//.into { grouped_assembly_contigs }

  //Evaluate the assemblies
  quast_input = velvet_run.out.velvetout.concat(
		masurca_run.out.masurcaout,
		spades_run.out.spadesout,
		stride_run.out.strideout,
		platanus_run.out.platanusout,
		soapdenovo_run.out.soapdenovoout,
		minia_run.out.miniaout,
		integratecontigs.out.cisaintegratedcontigs
		)
  qcmetrics_quast(quast_input)
  //velvet_run.out.velvetout.concat(
}
