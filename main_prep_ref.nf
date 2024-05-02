nextflow.enable.dsl = 2

include { PREP_REF } from './modules/prep_ref'
include { BWA } from './modules/bwa'
include { BWA_LENGTH } from './modules/bwa_length'

workflow {
    reads = file('./assets/Str-6718-D10A-5pR3-3pR3-UMI02_R1_001.fastq.gz')
    PREP_REF()
    BWA (PREP_REF.out.ref, reads)
    BWA_LENGTH (BWA.out.bam_reads)
}

