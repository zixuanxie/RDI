#' @title Create kallisto Index
#' @description Function to create the reference transcript and the indexed reference transcript
#' @param fasta_file Path to the input the original reference transcript, in fasta format
#' @param output_prefix Path to the generated reference transcript
#' @return Outputs the kallisto index that will be used for calculating RDI
#' @examples
#' create_index(fasta_file, output_prefix)
#' @export
create_index <- function(fasta_file, output_prefix) {
  # Input validation
  check_file_exists(fasta_file, "Fasta file")
  
  if (!is.character(output_prefix)) {
    stop("Error: output_prefix must be a character string")
  }
  
  # Check if kallisto is installed
  check_kallisto()

  package_root <- system.file(package = "RDI")
  
  # Get Python command
  python_cmd <- get_python_command()
  
  # Get kallisto path
  kallisto_path <- get_kallisto_path()
  
  tryCatch({
    split_fasta_file <- paste(output_prefix, ".fa", sep = "")
    command <- paste(python_cmd, shQuote(file.path(package_root, "scripts/python/create_index.py")),
                     "--input", shQuote(fasta_file), "--output", shQuote(split_fasta_file))
    run_command(command, "Processing fasta file")
    
    # Check if split fasta was generated
    if (!file.exists(split_fasta_file)) {
      stop("Error: split fasta file was not generated")
    }
    cat(paste("Generated split fasta:", split_fasta_file, "\n"))

    index_file <- paste(output_prefix, ".idx", sep = "")
    command_kallisto <- paste(shQuote(kallisto_path), "index -i", shQuote(index_file), shQuote(split_fasta_file))
    run_command(command_kallisto, "Creating kallisto index")
    
    # Check if index was created
    if (!file.exists(index_file)) {
      stop("Error: kallisto index was not created")
    }
    
    cat("Index creation completed successfully!\n")
    cat(paste("Index saved to:", index_file, "\n"))
  }, error = function(e) {
    stop(paste("Error during index creation:", e$message))
  })
}
