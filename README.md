# RDI
A Fast Algorithm for Calculating a Novel Degradation Index from RNA-seq Data
## Install RDI
To install RDI, download the source file RDI_0.0.0.9000.tar.gz, then run
```
install.packages("RDI_0.0.0.9000.tar.gz",repo=NULL,type="source")
```

## Run RDI
To run RDI, first create and index the reference transcriptome for calculating RDI
```
create_index(fasta_file, output_prefix) # fasta file is the reference transcriptome, for example GRCm38 for mouse
```
Then calculate RDI value for each sample
```
calculate_RDI(fq_file1, fq_file2, index_path, num_threads, output_dir)
```
