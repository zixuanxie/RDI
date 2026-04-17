#' @title Calculate RNA Degradation Index - RDI
#' @description Function to calculate RDI
#' @param fq_file1 Path to the first RNAseq fq.gz file
#' @param fq_file2 Path to the second RNAseq fq.gz file
#' @param index_path Path to the Kallisto index
#' @param num_threads Number of threads to use
#' @param output_dir Path to the output directory
#' @return Outputs two files: RDI for each transcript, and the RDI for the sample
#' @examples
#' calculate_RDI(fq_file1, fq_file2, index_path, num_threads, output_dir)
#' @export
calculate_RDI <- function(fq_file1, fq_file2, index_path, num_threads, output_dir) {
  # Input validation
  check_file_exists(fq_file1, "Fastq file 1")
  check_file_exists(fq_file2, "Fastq file 2")
  check_file_exists(index_path, "Kallisto index")
  
  if (!is.numeric(num_threads) || num_threads <= 0 || num_threads != as.integer(num_threads)) {
    stop("Error: num_threads must be a positive integer")
  }
  
  # Create output directory if it doesn't exist
  create_output_dir(output_dir)
  
  # Check if kallisto is installed
  check_kallisto()

  package_root <- system.file(package = "RDI")
  
  # Get Python command
  python_cmd <- get_python_command()
  
  # Get kallisto path
  kallisto_path <- get_kallisto_path()
  
  tryCatch({
    # Use kallisto (system-installed or embedded)
    command_kallisto <- paste(shQuote(kallisto_path), "quant -i", shQuote(index_path), "-o", shQuote(output_dir), "-b 100 -t", num_threads, shQuote(fq_file1), shQuote(fq_file2))
    run_command(command_kallisto, "Running kallisto quant")

    # Check if abundance.tsv was generated
    abundance_file <- file.path(output_dir, "abundance.tsv")
    if (!file.exists(abundance_file)) {
      stop("Error: kallisto did not generate abundance.tsv file")
    }

    command_python <- paste(python_cmd, shQuote(file.path(package_root, "scripts/python/calculate_RDI.py")), "--input", shQuote(abundance_file), "--output1", shQuote(file.path(output_dir, "transcripts_RDI.tsv")), "--output2", shQuote(file.path(output_dir, "RDI_sum.tsv")))
    run_command(command_python, "Calculating RDI")

    # Check if output files were generated
    transcripts_rdi_file <- file.path(output_dir, "transcripts_RDI.tsv")
    rdi_sum_file <- file.path(output_dir, "RDI_sum.tsv")
    
    if (!file.exists(transcripts_rdi_file)) {
      warning("Warning: transcripts_RDI.tsv was not generated")
    } else {
      cat(paste("Generated:", transcripts_rdi_file, "\n"))
    }
    
    if (!file.exists(rdi_sum_file)) {
      warning("Warning: RDI_sum.tsv was not generated")
    } else {
      cat(paste("Generated:", rdi_sum_file, "\n"))
    }
    
    cat("RDI calculation completed successfully!\n")
    cat(paste("Results saved to:", output_dir, "\n"))
  }, error = function(e) {
    stop(paste("Error during RDI calculation:", e$message))
  })
}
