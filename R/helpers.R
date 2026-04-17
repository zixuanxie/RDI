# Helper functions for RDI package

# Get the path to the embedded kallisto executable
get_kallisto_path <- function() {
  # First check if kallisto is in PATH
  if (system("kallisto version", ignore.stdout = TRUE, ignore.stderr = TRUE) == 0) {
    return("kallisto")
  }
  
  # If not, use the embedded kallisto based on platform
  os <- .Platform$OS.type
  arch <- .Platform$r_arch
  
  # Define possible paths
  if (os == "windows") {
    possible_paths <- c(
      system.file("exec", "kallisto_windows-v0.46.1", "kallisto.exe", package = "RDI"),
      system.file("scripts", "kallisto_windows-v0.46.1", "kallisto.exe", package = "RDI")
    )
  } else if (os == "unix") {
    if (Sys.info()[["sysname"]] == "Darwin") {
      # macOS
      possible_paths <- c(
        system.file("exec", "kallisto_mac-v0.46.1", "kallisto", package = "RDI"),
        system.file("scripts", "kallisto_mac-v0.46.1", "kallisto", package = "RDI")
      )
    } else {
      # Linux
      possible_paths <- c(
        system.file("exec", "kallisto_linux-v0.46.1", "kallisto", package = "RDI"),
        system.file("scripts", "kallisto_linux-v0.46.1", "kallisto", package = "RDI")
      )
    }
  } else {
    stop("Error: Unsupported operating system")
  }
  
  # Find the first existing path
  kallisto_path <- NULL
  for (path in possible_paths) {
    if (file.exists(path)) {
      kallisto_path <- path
      break
    }
  }
  
  # Make sure the file exists
  if (is.null(kallisto_path)) {
    stop("Error: Embedded kallisto executable not found. Please install kallisto from https://pachterlab.github.io/kallisto/")
  }
  
  return(kallisto_path)
}

# Check if kallisto is available
check_kallisto <- function() {
  kallisto_path <- get_kallisto_path()
  if (system(paste(kallisto_path, "version"), ignore.stdout = TRUE, ignore.stderr = TRUE) != 0) {
    stop("Error: kallisto is not available. Please install kallisto from https://pachterlab.github.io/kallisto/")
  }
}

# Get Python command
get_python_command <- function() {
  python_cmd <- if (system("python --version", ignore.stdout = TRUE, ignore.stderr = TRUE) == 0) {
    "python"
  } else if (system("python3 --version", ignore.stdout = TRUE, ignore.stderr = TRUE) == 0) {
    "python3"
  } else {
    stop("Error: Python is not available. Please install Python 3 before using RDI package")
  }
  return(python_cmd)
}

# Run system command with timing
run_command <- function(command, description) {
  cat(paste(description, "...\n"))
  start_time <- Sys.time()
  system(command)
  end_time <- Sys.time()
  elapsed_time <- difftime(end_time, start_time, units = "secs")
  cat(paste(description, "completed in", round(elapsed_time, 2), "seconds\n"))
}

# Create output directory if it doesn't exist
create_output_dir <- function(output_dir) {
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
    cat(paste("Created output directory:", output_dir, "\n"))
  }
}

# Check if file exists
check_file_exists <- function(file_path, file_description) {
  if (!file.exists(file_path)) {
    stop(paste("Error:", file_description, "does not exist:", file_path))
  }
}
