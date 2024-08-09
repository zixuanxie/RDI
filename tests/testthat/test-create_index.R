# tests/test_create_index.R

context("create_index function")

test_that("create_index runs without errors", {
  # Create a temporary directory for testing
  temp_dir <- testthat::testthat_tempdir()

  # Paths for the test files
  fasta_file <- system.file("extdata", "test.fasta", package = "RDI")
  output_prefix <- file.path(temp_dir, "test_output")

  # Test the create_index function
  create_index(fasta_file, output_prefix)

  # Check if the output files are created
  expect_true(file.exists(paste(output_prefix, ".fa", sep = "")))
  expect_true(file.exists(paste(output_prefix, ".idx", sep = "")))
})

# Additional tests can be added as needed
