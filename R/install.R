# Check if Python is available

# Function to check if Python is available
check_python_available <- function() {
  # Try python first
  python_available <- system("python --version", ignore.stdout = TRUE, ignore.stderr = TRUE) == 0
  if (!python_available) {
    # Try python3
    python_available <- system("python3 --version", ignore.stdout = TRUE, ignore.stderr = TRUE) == 0
  }
  return(python_available)
}

# Function to get Python command
get_python_command <- function() {
  if (system("python --version", ignore.stdout = TRUE, ignore.stderr = TRUE) == 0) {
    return("python")
  } else if (system("python3 --version", ignore.stdout = TRUE, ignore.stderr = TRUE) == 0) {
    return("python3")
  } else {
    return(NULL)
  }
}

# Function to get pip command
get_pip_command <- function() {
  if (system("pip --version", ignore.stdout = TRUE, ignore.stderr = TRUE) == 0) {
    return("pip")
  } else if (system("pip3 --version", ignore.stdout = TRUE, ignore.stderr = TRUE) == 0) {
    return("pip3")
  } else {
    return(NULL)
  }
}

# Function for checking Python module
check_module <- function(module_name, python_cmd){
  # Create a temporary Python script to check for the module
  check_module_script <- sprintf("try:\n    import %s\n    print('Module available')\nexcept ImportError:\n    print('Module not available')\n", module_name)
  # Write the script to a temporary file
  script_file <- tempfile(fileext = ".py")
  writeLines(check_module_script, script_file)
  # Run the Python script using system command
  result <- system(sprintf("%s %s", python_cmd, script_file), intern = TRUE)
  # Delete the temporary script file
  unlink(script_file)
  # Print the result
  return(result)
}

# Main dependency check
tryCatch({
  # Check if Python is available
  if (!check_python_available()) {
    warning("Python is not available. Please install Python 3 before using RDI package")
  } else {
    # Get Python command
    python_cmd <- get_python_command()
    
    # Check Python version
    python_version <- gsub("Python ","",system(paste(python_cmd, "--version"), intern = TRUE))
    if (!startsWith(python_version,"3")) {
      warning("Python 3 is required, please install before using RDI package")
    } else {
      cat(paste("Python version:", python_version, "\n"))
    }
    
    # Get pip command
    pip_cmd <- get_pip_command()
    if (is.null(pip_cmd)) {
      warning("pip is not available. Please install pip before using RDI package")
    } else {
      # Check required Python modules
      required_modules <- c("argparse", "pandas", "numpy")
      
      for (module in required_modules) {
        if (check_module(module, python_cmd) == "Module not available"){
          cat(paste("Installing missing module:", module, "\n"))
          system(paste(pip_cmd, "install", module))
        } else {
          cat(paste("Required Python module", module, "is installed.\n"))
        }
      }
    }
  }
  
  # Check if kallisto is available
  tryCatch({
    # Check if kallisto is in PATH
    if (system("kallisto version", ignore.stdout = TRUE, ignore.stderr = TRUE) == 0) {
      cat("kallisto is installed in PATH.\n")
    } else {
      warning("kallisto is not installed or not in PATH. The package will use embedded kallisto if available.")
    }
  }, error = function(e) {
    warning("Error checking kallisto: ", e$message)
  })
}, error = function(e) {
  warning(paste("Error during dependency check:", e$message))
})


