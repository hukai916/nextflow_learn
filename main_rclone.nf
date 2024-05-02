nextflow.enable.dsl = 2

include { RCLONE } from './modules/rclone'

workflow {
    RCLONE(channel.from("test1"))
}