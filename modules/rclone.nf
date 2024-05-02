process RCLONE {
    label 'process_single'
    conda "bioconda::bwa=0.7.17"
    container "hukai916/rclone:0.1"

    input:
    val x

    output:
    path  "versions.yml", emit: versions

    script:

    """
    touch $x
    rclone copy -L $x dropbox:/test_rclone/


    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$( python --version | sed -e "s/python //g" )
    END_VERSIONS

    """
}
