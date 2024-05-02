process RCLONE {
    label 'process_single'
    conda "conda-forge::rclone-1.65.2"
    container "hukai916/rclone:0.2"

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
