#!/usr/bin/env Rscript

# Load required library
library(seqinr)

# Function to read fasta file
read_fasta <- function(file_path) {
  sequences <- read.fasta(file_path)
  return(sequences)
}

# Function to split sequences
split_sequences <- function(sequences) {
  split_sequences <- list()
  percentile <- 3

  for (i in 1:length(sequences)) {
    seq <- as.character(sequences[[i]])
    length_seq <- nchar(seq)
    split_point <- length_seq %/% percentile
    pos3end <- split_point * (percentile - 1)
    pos5end <- split_point
    posm5 <- (length_seq - split_point) %/% 2
    posm3 <- (length_seq + split_point) %/% 2

    # 5' part
    header_5 <- paste0(names(sequences)[i], "_5")
    sequence_5 <- substr(seq, 1, pos5end)
    split_sequences[[header_5]] <- sequence_5

    # 3' part
    header_3 <- paste0(names(sequences)[i], "_3")
    sequence_3 <- substr(seq, pos3end + 1, nchar(seq))
    split_sequences[[header_3]] <- sequence_3
  }

  return(split_sequences)
}

# Function to write fasta file
write_fasta <- function(output_file, sequences) {
  headers <- names(sequences)

  write.fasta(sequences, names = headers, file = output_file, open = "w")
}

input_file <- "extdata/test.fasta"
output_file <- "tests/testoutput/test.fa"

seqs <- read_fasta(input_file)
split_seqs <- split_sequences(seqs)
write_fasta(output_file, split_seqs)

# Main function
main <- function() {
  # Command-line arguments
  args <- commandArgs(trailingOnly = TRUE)

  # Input and output files
  input_file <- args[1]
  output_file <- args[2]

  # Read sequences from fasta file
  seqs <- read_fasta(input_file)

  # Split sequences into 5' and 3' ends
  split_seqs <- split_sequences(seqs)

  # Write split sequences to fasta file
  write_fasta(output_file, split_seqs)
}

# Execute main function
main()
