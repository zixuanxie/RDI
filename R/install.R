# Check if Python is available

python_version <- gsub("Python ","",system("python --version", intern = T))
required_modules <- c("random", "argparse", "pandas", "numpy", "os", "math")

#Function for checking Python module
check_module <- function(module_name){
  # Create a temporary Python script to check for the module
  check_module_script <- sprintf("try:\n    import %s\n    print('Module available')\nexcept ImportError:\n    print('Module not available')\n", module_name)
  # Write the script to a temporary file
  script_file <- tempfile(fileext = ".py")
  writeLines(check_module_script, script_file)
  # Run the Python script using system command
  result <- system(sprintf("python %s", script_file), intern = TRUE)
  # Delete the temporary script file
  unlink(script_file)
  # Print the result
  return(result)

}

if (startsWith(python_version,"3")) {
  # Check and install required Python modules
  for (module in required_modules) {
    if (check_module(module) == "Module not available"){
      cat(paste("\033[92Installing missing module:", module, "\n"))
      system(paste("pip install", module))
    } else {
      cat(paste("\033[92mRequired Python module", module, "is installed.\n"))
    }
  }
} else {
  print("\033[93mWaining: Python3 is required, please install before using RDI package")
}

for (module in required_modules) {
  if (check_module(module) == "Module not available"){
    cat(paste("\033[93mWarning:\nRequired Python module:", module, "is missing, please install it before using RDI package."))
  }
}

