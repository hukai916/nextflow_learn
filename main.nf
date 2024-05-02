nextflow.enable.dsl = 2

include { PREP_REF } from 'modules/prep_ref'

workflow {
    data = channel.fromPath('/some/data/*.txt')
    foo(data)
}