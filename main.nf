// one step dsl2 pipeline to align fastq file tu human genome using bwa

process bwa {

  container 'biocontainers/bwa:0.7.13'
  publishDir "s3://hynstoun/test/", mode: 'copy'
  
  input:
  path fastq1
  path fastq2
  path index_files

  output:
  file("zid.bam")

  script:
  """
  bwa mem -t 2 -R '@RG\tID:foo\tSM:bar' Homo_sapiens_assembly38.fasta.64 ${fastq1} ${fastq2} | samtools view -bS - > zid.bam
  """

}

workflow {
  fastq1 = file('s3://hynstoun/2A1_CGATGT_L001_R1_001.fastq.gz')
  fastq2 = file('s3://hynstoun/2A1_CGATGT_L001_R2_001.fastq.gz')
  
  index_extensions = ['amb', 'ann', 'bwt', 'pac', 'sa']
  index_files = index_extensions.collect { ext -> file("s3://hynstoun/index/Homo_sapiens_assembly38.fasta.64.${ext}") }
  
  bwa(fastq1, fastq2, index_files)
}