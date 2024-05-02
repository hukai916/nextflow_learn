process BWA {
    label 'process_medium'
    container "hukai916/miniconda3_bio:0.3"

    input:
    path ref 
    path reads

    output:
    tuple path("*.bam"), path(reads), emit: bam_reads
    path  "versions.yml", emit: versions

    """
    bwa index $ref
    bwa mem -t $task.cpus $ref $reads | samtools view -F 256 | samtools sort -o test.bam

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$( python --version | sed -e "s/python //g" )
    END_VERSIONS

    """
}
