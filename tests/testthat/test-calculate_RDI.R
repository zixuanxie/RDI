# tests/test_calculate_RDI.R

context("calculate_RDI function")

test_that("calculate_RDI runs without errors", {
  # Create a temporary directory for testing
  temp_dir <- testthat::testthat_tempdir()

  # Paths for the test files
  fq_file1 <- system.file("extdata", "test1.fq.gz", package = "RDI")
  fq_file2 <- system.file("extdata", "test2.fq.gz", package = "RDI")
  index_path <- system.file("extdata", "test.idx", package = "RDI")
  num_threads <- 4
  output_dir <- file.path(temp_dir, "test_output")

  # Test the calculate_RDI function
  calculate_RDI(fq_file1, fq_file2, index_path, num_threads, output_dir)

  # Check if the output files are created
  expect_true(file.exists(paste(output_dir, "/transcripts_RDI.tsv", sep = "")))
  expect_true(file.exists(paste(output_dir, "/RDI_sum.tsv", sep = "")))
})

# Additional tests can be added as needed
