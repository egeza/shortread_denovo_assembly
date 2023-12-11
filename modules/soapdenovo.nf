process soapdenovo_run {
    publishDir "${params.outdir}/soapdenovoOut/${sample}/", mode: 'copy', overwrite: true
    label 'high_memory'
    //container '/cbio/projects/026/images/shortread_denovo_assemblers_2023-12-04.simg'
    tag "${sample}"

    input:
    tuple val(sample), val(reads), path(bestkmerfile)
    //path(inputfiles)
    
    output:
    tuple val(sample), path("${sample}.contig"), path("${sample}.kmerFreq"), path("${sample}.peGrads"), path("${sample}.scafSeq"), path("${sample}.scafStatistics"), emit: soapdenovoout
   
    script:
    """
    echo [LIB] >> soapconfig
    echo avg_ins=\$(head -n 2 ${reads[0]} | tail -n 2 | wc -c) >> soapconfig
    echo reverse_seq=0 >> soapconfig
    echo asm_flags=3 >> soapconfig
    echo rank=1 >> soapconfig
    echo "# ${sample}" >> soapconfig
    echo q1=${reads[0]} >> soapconfig
    echo q2=${reads[1]} >> soapconfig
    kmersize=\$(cat ${bestkmerfile})
    soapdenovo2-63mer all -s soapconfig -o ${sample} -F -R -u -K \$kmersize -p ${params.threads} \
    >> ${sample}"_soapdenovo-assembly.log"
    """
    //GapCloser -b soapconfig -a 	${sample}".scafSeq" -o ${sample}".new.scafSeq" -t ${params.threads} >> ${sample}"_gapcloser.log"
    }
