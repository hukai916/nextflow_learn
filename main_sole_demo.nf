#!/usr/bin/env nextflow

nextflow.enable.dsl=2

process FASTQC {
   publishDir "${params.outputDir}/fastqc"
   container "quay.io/biocontainers/fastqc:0.12.1--hdfd78af_0"

   input:
       tuple val(sample_id), path(reads)

   output:
       path "*_fastqc.{zip,html}"

   script:

   """
   fastqc ${reads.join(' ')} -o .
   """
}

process CUTADAPT {
   publishDir "${params.outputDir}/cutadapt"
   container "quay.io/biocontainers/cutadapt:4.9--py310h7c593f9_1"

   input:
      tuple val(sample_id), path(reads)

   output:
      tuple val(sample_id), path("*.fastq.gz"), emit: reads
      path "*.txt", emit: log


   script:

   """
   cutadapt \
            -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC \
            -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTAGATCTCGGTGGTCGCCGTATCATT \
            -o ${sample_id}.trimmed.1.fastq.gz -p ${sample_id}.trimmed.2.fastq.gz \
            ${reads.join(' ')} \
            > log_${sample_id}.txt 2>&1
   """
}

process MULTIQC {
   publishDir "${params.outputDir}/multiqc"
   // container "quay.io/biocontainers/multiqc:1.25--pyhdfd78af_0"
   container "quay.io/biocontainers/multiqc:1.25--pyhdfd78af_0"

   input:
      path res 

   output:
      path "multiqc_report.html"
      path "multiqc_data"

   script:

   """
   multiqc ${res}

   """
}

workflow {
   reads = "${params.inputDir}/*{1,2}.{fq,fastq}.gz"

   reads = Channel.fromFilePairs(reads)
   // reads.view()
   
   FASTQC (reads)
   CUTADAPT (reads)
   MULTIQC (FASTQC.out.mix(CUTADAPT.out.log).collect())
}
