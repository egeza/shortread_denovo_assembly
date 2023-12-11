process masurca_run {
    publishDir "${params.outdir}/masurcaOut/${sample}/", mode: 'copy', overwrite: true
    label 'high_masurca'
    //container '/cbio/projects/026/images/denovo_assemblers_latest-2023-07-03-ee279da8a081.simg'
    tag "${sample}"

    input:
    tuple val(sample), val(reads), path(meanstdfile)
    
    output:
    tuple val(sample), path("CA/*.genome.scf.fasta"), path("test_var.txt"), emit: masurcaout
   
    script:
    """
    masurca -g masurca_config
    frag_mean=\$(cat ${meanstdfile} | head -1)
    frag_std=\$(cat ${meanstdfile}  | tail -1)
    samplename=\$(echo ${sample} | sed -E "s/.*(..)/\\1/")
    grep "PE= " masurca_config >> test_var.txt
    echo PE= \${samplename} \${frag_mean} \${frag_std} ${reads[0]} ${reads[1]} >> test_var.txt
    read=\$(cat test_var.txt | head -1)
    repl=\$(cat test_var.txt | tail -1)
    sed -i "s|\${read}|\${repl}|" masurca_config
    sed -i "s|USE_LINKING_MATES = 0|USE_LINKING_MATES = 1|g" masurca_config
    sed -i "s|USE_GRID=0|#USE_GRID=0|g" masurca_config
    sed -i "s|GRID_ENGINE=SGE|#GRID_ENGINE=SGE|g" masurca_config
    sed -i "s|GRID_QUEUE=all.q|#GRID_QUEUE=all.q|g" masurca_config
    sed -i "s|GRID_BATCH_SIZE=500000000|#GRID_BATCH_SIZE=500000000|g" masurca_config
    sed -i "s|LIMIT_JUMP_COVERAGE = 300|#LIMIT_JUMP_COVERAGE = 300|g" masurca_config
    sed -i "s|FLYE_ASSEMBLY=1|#FLYE_ASSEMBLY=1|g" masurca_config 
    masurca masurca_config
    ./assemble.sh
    """
}
