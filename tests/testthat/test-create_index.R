# tests/test_create_index.R

context("create_index function")

test_that("create_index runs without errors", {
  # Create a temporary directory for testing
  temp_dir <- tempdir()

  # Paths for the test files
  fasta_file <- system.file("extdata", "test.fasta", package = "RDI")
  output_prefix <- file.path(temp_dir, "test_output")

  # Test the create_index function
  create_index(fasta_file, output_prefix)

  # Check if the output files are created
  expect_true(file.exists(paste(output_prefix, ".fa", sep = "")))
  expect_true(file.exists(paste(output_prefix, ".idx", sep = "")))
})

test_that("create_index handles non-existent fasta file", {
  # Create a temporary directory for testing
  temp_dir <- tempdir()

  # Paths for the test files
  fasta_file <- file.path(temp_dir, "non_existent.fasta")
  output_prefix <- file.path(temp_dir, "test_output")

  # Test that create_index throws an error for non-existent fasta file
  expect_error(create_index(fasta_file, output_prefix), "Error: Fasta file does not exist:")
})

test_that("create_index handles invalid output_prefix", {
  # Paths for the test files
  fasta_file <- system.file("extdata", "test.fasta", package = "RDI")
  output_prefix <- 123  # Not a character string

  # Test that create_index throws an error for invalid output_prefix
  expect_error(create_index(fasta_file, output_prefix), "Error: output_prefix must be a character string")
})

test_that("create_index creates output directory if it doesn't exist", {
  # Create a temporary directory for testing
  temp_dir <- tempdir()
  sub_dir <- file.path(temp_dir, "subdir")

  # Paths for the test files
  fasta_file <- system.file("extdata", "test.fasta", package = "RDI")
  output_prefix <- file.path(sub_dir, "test_output")

  # Test the create_index function
  create_index(fasta_file, output_prefix)

  # Check if the output files are created
  expect_true(file.exists(paste(output_prefix, ".fa", sep = "")))
  expect_true(file.exists(paste(output_prefix, ".idx", sep = "")))
})
