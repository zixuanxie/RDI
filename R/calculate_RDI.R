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
  package_root <- system.file(package = "RDI")

  if (Sys.info()['sysname'] == "Windows") {
    command_kallisto <- paste(shQuote(file.path(package_root, "scripts/kallisto_windows-v0.46.1/kallisto.exe")), "quant -i", shQuote(index_path), "-o", shQuote(output_dir), "-b 100 -t", num_threads, shQuote(fq_file1), shQuote(fq_file2))
    system(command_kallisto)
  } else if (Sys.info()['sysname'] == "Linux") {
    command_chmod <- paste("chmod +x", shQuote(file.path(package_root, "scripts/kallisto_linux-v0.46.1/kallisto")))
    system(command_chmod)
    command_kallisto <- paste(shQuote(file.path(package_root, "scripts/kallisto_linux-v0.46.1/kallisto")), "quant -i", shQuote(index_path), "-o", shQuote(output_dir), "-b 100 -t", num_threads, shQuote(fq_file1), shQuote(fq_file2))
    system(command_kallisto)
  } else if (Sys.info()['sysname'] == "Darwin") {
    command_chmod <- paste("chmod +x", shQuote(file.path(package_root, "scripts/kallisto_mac-v0.46.1/kallisto")))
    system(command_chmod)
    command_kallisto <- paste(shQuote(file.path(package_root, "scripts/kallisto_mac-v0.46.1/kallisto")), "quant -i", shQuote(index_path), "-o", shQuote(output_dir), "-b 100 -t", num_threads, shQuote(fq_file1), shQuote(fq_file2))
    system(command_kallisto)
  }

  command_python <- paste("python", shQuote(file.path(package_root, "scripts/python/calculate_RDI.py")), "--input", shQuote(file.path(output_dir, "abundance.tsv")), "--output1", shQuote(file.path(output_dir, "transcripts_RDI.tsv")), "--output2", shQuote(file.path(output_dir, "RDI_sum.tsv")))
  system(command_python)
}
