#' @title Create kallisto Index
#' @description Function to create the reference transcript and the indexed reference transcript
#' @param fasta_file Path to the input the original reference transcript, in fasta format
#' @param output_prefix Path to the generated reference transcript
#' @return Outputs the kallisto index that will be used for calculating RDI
#' @examples
#' create_index(fasta_file, output_prefix)
#' @export
create_index <- function(fasta_file, output_prefix) {
  package_root <- system.file(package = "RDI")
  command <- paste("python", shQuote(file.path(package_root, "scripts/python/create_index.py")),
                   "--input", shQuote(fasta_file), "--output", shQuote(paste(output_prefix, ".fa", sep = "")))
  system(command)

  if (Sys.info()['sysname'] == "Windows") {
    command_kallisto <- paste(shQuote(file.path(package_root, "scripts/kallisto_windows-v0.46.1/kallisto.exe")),
                              "index -i", shQuote(paste(output_prefix, ".idx", sep = "")), shQuote(paste(output_prefix, ".fa", sep = "")))
    system(command_kallisto)
  } else if (Sys.info()['sysname'] == "Linux") {
    command_chmod <- paste("chmod +x", shQuote(file.path(package_root, "scripts/kallisto_linux-v0.46.1/kallisto")))
    system(command_chmod)
    command_kallisto <- paste(shQuote(file.path(package_root, "scripts/kallisto_linux-v0.46.1/kallisto")),
                              "index -i", shQuote(paste(output_prefix, ".idx", sep = "")), shQuote(paste(output_prefix, ".fa", sep = "")))
    system(command_kallisto)
  } else if (Sys.info()['sysname'] == "Darwin") {
    command_chmod <- paste("chmod +x", shQuote(file.path(package_root, "scripts/kallisto_mac-v0.46.1/kallisto")))
    system(command_chmod)
    command_kallisto <- paste(shQuote(file.path(package_root, "scripts/kallisto_mac-v0.46.1/kallisto")),
                              "index -i", shQuote(paste(output_prefix, ".idx", sep = "")), shQuote(paste(output_prefix, ".fa", sep = "")))
    system(command_kallisto)
  }
}
