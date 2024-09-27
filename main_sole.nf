#!/usr/bin/env nextflow

nextflow.enable.dsl=2

workflow.onComplete = {
   // any workflow property can be used here
   println "Pipeline complete"
   println "Command line: $workflow.commandLine"
}

workflow.onError = {
   println "Error: something when wrong"
}

process FASTQC {
   publishDir "${projectDir}/fastqc", mode: 'copy'
   container 'biocontainers/fastqc:v0.11.9_cv8'

   input:
       tuple val(sample_id), path(reads) // Accept the paired reads as a list

   output:
       file "*_fastqc.{zip,html}"

   script:

   """
   fastqc ${reads.join(' ')} -o .
   """
}


process MULTIQC {

   container 'ghcr.io/multiqc/multiqc'


   output:

   file "multiqc_report.html"

   file "multiqc_data"



   script:

   """

   multiqc $projectDir

   """

}



workflow {

   // Define the path to the input files

   reads = "${params.inputDir}/*{1,2}.{fq,fastq}.gz"

   // Channel to pair files and pass to FastQC

   read_files_fastqc = Channel.fromFilePairs(reads)

   // Kai added: use .view() to check if the channel is expected
   read_files_fastqc.view()


   // Run the FastQC process using the paired files
   read_files_fastqc | FASTQC

   MULTIQC()

}
