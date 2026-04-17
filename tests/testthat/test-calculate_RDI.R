# tests/test_calculate_RDI.R

context("calculate_RDI function")

test_that("calculate_RDI handles non-existent fastq files", {
  # Create a temporary directory for testing
  temp_dir <- tempdir()

  # Paths for the test files
  fq_file1 <- file.path(temp_dir, "non_existent1.fq.gz")
  fq_file2 <- file.path(temp_dir, "non_existent2.fq.gz")
  index_path <- system.file("extdata", "test.idx", package = "RDI")
  num_threads <- 4
  output_dir <- file.path(temp_dir, "test_output")

  # Test that calculate_RDI throws an error for non-existent fastq files
  expect_error(calculate_RDI(fq_file1, fq_file2, index_path, num_threads, output_dir), "Error: Fastq file 1 does not exist:")
})

test_that("calculate_RDI handles non-existent index file", {
  # Create a temporary directory for testing
  temp_dir <- tempdir()

  # Paths for the test files
  fq_file1 <- system.file("extdata", "test_1.fq.gz", package = "RDI")
  fq_file2 <- system.file("extdata", "test_2.fq.gz", package = "RDI")
  index_path <- file.path(temp_dir, "non_existent.idx")
  num_threads <- 4
  output_dir <- file.path(temp_dir, "test_output")

  # Test that calculate_RDI throws an error for non-existent index file
  expect_error(calculate_RDI(fq_file1, fq_file2, index_path, num_threads, output_dir), "Error: Kallisto index does not exist:")
})

test_that("calculate_RDI handles invalid num_threads", {
  # Create a temporary directory for testing
  temp_dir <- tempdir()

  # Paths for the test files
  fq_file1 <- system.file("extdata", "test_1.fq.gz", package = "RDI")
  fq_file2 <- system.file("extdata", "test_2.fq.gz", package = "RDI")
  # Create a temporary index file
  fasta_file <- system.file("extdata", "test.fasta", package = "RDI")
  output_prefix <- file.path(temp_dir, "test_index")
  create_index(fasta_file, output_prefix)
  index_path <- paste0(output_prefix, ".idx")
  num_threads <- -1  # Invalid number of threads
  output_dir <- file.path(temp_dir, "test_output")

  # Test that calculate_RDI throws an error for invalid num_threads
  expect_error(calculate_RDI(fq_file1, fq_file2, index_path, num_threads, output_dir), "Error: num_threads must be a positive integer")
})

test_that("calculate_RDI creates output directory if it doesn't exist", {
  # Create a temporary directory for testing
  temp_dir <- tempdir()
  sub_dir <- file.path(temp_dir, "subdir")

  # Paths for the test files
  fq_file1 <- system.file("extdata", "test_1.fq.gz", package = "RDI")
  fq_file2 <- system.file("extdata", "test_2.fq.gz", package = "RDI")
  # Create a temporary index file
  fasta_file <- system.file("extdata", "test.fasta", package = "RDI")
  output_prefix <- file.path(temp_dir, "test_index")
  create_index(fasta_file, output_prefix)
  index_path <- paste0(output_prefix, ".idx")
  num_threads <- 4
  output_dir <- file.path(sub_dir, "test_output")

  # Test that calculate_RDI creates the output directory
  expect_true(!dir.exists(output_dir))
  # Run calculate_RDI - it should succeed now that test files exist
  calculate_RDI(fq_file1, fq_file2, index_path, num_threads, output_dir)
  expect_true(dir.exists(output_dir))
})
