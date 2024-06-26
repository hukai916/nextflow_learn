process RCLONE {
    label 'process_single'
    conda "conda-forge::rclone"
    // conda '/Users/kaihu/anaconda3/envs/rclone/'
    // conda '/home/kai.hu-umw/pi/mccb-umw/miniconda3/envs/rclone'
    container "hukai916/rclone:0.2" // when running on Mac, use 0.1

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
