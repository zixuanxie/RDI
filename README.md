# RDI
A Fast Algorithm for Calculating a Novel Degradation Index from RNA-seq Data

## Prerequisite
Before using RDI package, make sure you have installed python3 and the required modules: argparse, numpy, pandas, math, and random. 

## Install RDI
To install RDI, download the latest release RDI-1.0.1.tar.gz, then run
```
install.packages("RDI-RDIv1.0.0.tar.gz",repo=NULL,type="source")
```
Or install from GitHub (if available)
```
devtools::install_github("zixuanxie/RDI")
```
After installation, load the package:
```
library(RDI)
```
## Test Code

The RDI package includes test data and test functions to verify that the package is working correctly. Here's how to run the tests:

### Test Data

The package includes the following test files in the `extdata` directory: 
- `test.fasta`: A small test reference transcriptome
- `test_1.fq.gz`: Test RNA-seq reads (forward)
- `test_2.fq.gz`: Test RNA-seq reads (reverse)

### Running Tests

You can run the tests using the `testthat` package:

```
# Install testthat if not already installed
# install.packages("testthat")

# Run tests from the source directory (when developing)
library(testthat)
# If running from the source directory
test_dir("tests")

# If running from the installed package (after installation with tests)
# test_dir(system.file("tests", package = "RDI"))
```

## Test Commands

You can also run the test commands manually to verify the functionality:

```
# Set paths to test data
test_data_dir <- system.file("extdata", package = "RDI")
fasta_file <- file.path(test_data_dir, "test.fasta")
fq_file1 <- file.path(test_data_dir, "test_1.fq.gz")
fq_file2 <- file.path(test_data_dir, "test_2.fq.gz")

# Create output directory
output_dir <- tempdir()
index_prefix <- file.path(output_dir, "test_index")

# Test create_index function
cat("Testing create_index...\n")
create_index(fasta_file, index_prefix)

# Test calculate_RDI function
cat("Testing calculate_RDI...\n")
index_path <- paste0(index_prefix, ".idx")
rdi_output_dir <- file.path(output_dir, "rdi_test")
calculate_RDI(fq_file1, fq_file2, index_path, 1, rdi_output_dir)

# Check results
cat("Checking test results...\n")
rdi_sum_file <- file.path(rdi_output_dir, "RDI_sum.tsv")
if (file.exists(rdi_sum_file)) {
  rdi_result <- read.table(rdi_sum_file, header = TRUE, sep = "\t")
  cat("RDI test result:", rdi_result$Index.median., "\n")
} else {
  cat("Test failed: RDI_sum.tsv not found\n")
}
```

## Quick Start Guide

### Step 1: Create a kallisto index

First, you need to create a kallisto index from a reference transcriptome fasta file. This step splits each transcript into 5' and 3' regions and creates an index for kallisto.

```
# Path to reference transcriptome fasta file
fasta_file <- "/path/to/reference_transcriptome.fa"

# Output prefix for the index
output_prefix <- "/path/to/output/index"

# Create the index
create_index(fasta_file, output_prefix)
```

This will generate two files: 
- `output_prefix.fa`: The split transcriptome fasta file
- `output_prefix.idx`: The kallisto index file

### Step 2: Calculate RDI

Once you have the index, you can calculate RDI for your RNA-seq samples:

```
# Paths to paired-end RNA-seq fastq files
fq_file1 <- "/path/to/sample_R1.fq.gz"
fq_file2 <- "/path/to/sample_R2.fq.gz"

# Path to the kallisto index created in Step 1
index_path <- "/path/to/output/index.idx"

# Number of threads to use
num_threads <- 4

# Output directory for results
output_dir <- "/path/to/output/rdi_results"

# Calculate RDI
calculate_RDI(fq_file1, fq_file2, index_path, num_threads, output_dir)
```

This will generate three files in the output directory: 
- `abundance.tsv`: kallisto quantification results
- `transcripts_RDI.tsv`: RDI values for each transcript
- `RDI_sum.tsv`: Summary RDI values for the sample

## Interpreting Results

### Transcript-level RDI

The `transcripts_RDI.tsv` file contains: 
- `transcript_id`: The ID of the transcript - `est_counts_ratio`: The ratio of 3' to 5' coverage (values closer to 0 indicate more degradation)
- `degradation_mode`: The direction of degradation ("from3", "from5", "fromBoth", or "both0")

## Sample-level RDI

The `RDI_sum.tsv` file contains: - `transcript_id`: Set to "est_counts_ratio" (placeholder) 
- `Index(mean)`: The mean RDI across all transcripts
- `Index(median)`: The median RDI across all transcripts (this is the main RDI score)
- `Index(stdev)`: The standard deviation of RDI values across transcripts

#### RDI Score Interpretation

- **RDI ≈ 100**: Minimal degradation (3' and 5' coverage are balanced)
- **RDI \< 100**: RNA degradation (one end's coverage is higher than the other end)

Generally, samples with RDI \< 60 are considered to have significant degradation.

## Example Workflow

Here's a complete example workflow for calculating RDI for multiple samples:

```
# Set paths
reference_fasta <- "/path/to/human_transcriptome.fa"
index_prefix <- "/path/to/output/human_index"
samples <- list(
  sample1 = c("/path/to/sample1_R1.fq.gz", "/path/to/sample1_R2.fq.gz"),
  sample2 = c("/path/to/sample2_R1.fq.gz", "/path/to/sample2_R2.fq.gz"),
  sample3 = c("/path/to/sample3_R1.fq.gz", "/path/to/sample3_R2.fq.gz")
)
output_base <- "/path/to/output/rdi_results"

# Create index (only need to do this once)
create_index(reference_fasta, index_prefix)
index_path <- paste0(index_prefix, ".idx")

# Calculate RDI for each sample
for (sample_name in names(samples)) {
  cat(paste("Processing sample:", sample_name, "\n"))
  fq1 <- samples[[sample_name]][1]
  fq2 <- samples[[sample_name]][2]
  output_dir <- file.path(output_base, sample_name)
  
  calculate_RDI(fq1, fq2, index_path, 4, output_dir)
}

# Collect and summarize results
results <- list()
for (sample_name in names(samples)) {
  rdi_file <- file.path(output_base, sample_name, "RDI_sum.tsv")
  if (file.exists(rdi_file)) {
    rdi_data <- read.table(rdi_file, header = TRUE, sep = "\t")
    results[[sample_name]] <- rdi_data$Index.median.
  }
}

# Create summary table
summary_table <- data.frame(
  sample = names(results),
  RDI = unlist(results)
)

print(summary_table)
```
To run RDI, first create and index the reference transcriptome for calculating RDI
```
create_index(fasta_file, output_prefix) # fasta file is the reference transcriptome, for example GRCm38 for mouse
```
Then calculate RDI value for each sample
```
calculate_RDI(fq_file1, fq_file2, index_path, num_threads, output_dir)
```
## Troubleshooting

### Common Issues

1.  **kallisto not found**: Ensure kallisto is installed and in your system PATH
2.  **Python not found**: Ensure Python 3 is installed and in your system PATH
3.  **Missing Python packages**: The install script should automatically install required packages, but you can install them manually with `pip install pandas numpy`
4.  **File not found errors**: Double-check all file paths
5.  **Permission errors**: Ensure you have write access to the output directories

### Debugging Tips

-   Run with verbose output to see detailed progress
-   Check the output files to ensure they're being generated correctly
-   Verify that kallisto and Python are working correctly by running `kallisto --version` and `python --version` in your terminal
