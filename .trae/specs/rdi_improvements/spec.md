# RDI Package Improvements - Product Requirement Document

## Overview
- **Summary**: This project aims to improve the RDI (RNA Degradation Index) package by enhancing dependency management, error handling, cross-platform compatibility, user experience, documentation, test coverage, and code quality.
- **Purpose**: The RDI package is used to assess RNA degradation from RNA-seq data, and these improvements will make it more robust, user-friendly, and maintainable.
- **Target Users**: Bioinformaticians and researchers working with RNA-seq data who need to assess RNA degradation quality.

## Goals
- Improve dependency management by removing embedded kallisto executables and adding system dependency checks
- Add proper error handling and input validation to R functions
- Fix cross-platform path handling for Python scripts
- Enhance Python dependency checks and installation
- Add progress indication for long-running tasks
- Improve documentation with more detailed vignette
- Expand test coverage
- Reduce code duplication between R functions

## Non-Goals (Out of Scope)
- Adding new functionality beyond the existing RDI calculation
- Modifying the core RDI calculation algorithm
- Supporting single-end RNA-seq data
- Creating a GUI interface

## Background & Context
The RDI package currently uses embedded kallisto executables for different platforms, which increases package size and maintenance burden. It also lacks comprehensive error handling, cross-platform compatibility, and detailed documentation. These improvements will address these issues and make the package more reliable and user-friendly.

## Functional Requirements
- **FR-1**: Remove embedded kallisto executables and use system-installed kallisto
- **FR-2**: Add input validation and error handling to R functions
- **FR-3**: Fix cross-platform path handling in Python scripts
- **FR-4**: Enhance Python dependency detection and installation
- **FR-5**: Add progress indication and timing information for long-running tasks
- **FR-6**: Improve documentation with a detailed vignette
- **FR-7**: Expand test coverage for edge cases and error handling
- **FR-8**: Reduce code duplication by creating helper functions

## Non-Functional Requirements
- **NFR-1**: Cross-platform compatibility (Windows, Linux, macOS)
- **NFR-2**: Robust error handling with clear error messages
- **NFR-3**: Improved user experience with progress feedback
- **NFR-4**: Comprehensive documentation
- **NFR-5**: Maintainable code structure

## Constraints
- **Technical**: Requires kallisto and Python 3 to be installed on the user's system
- **Dependencies**: Requires Python packages pandas and numpy

## Assumptions
- Users have basic knowledge of RNA-seq data and R packages
- Users can install system dependencies (kallisto, Python)
- Users have access to a command-line interface

## Acceptance Criteria

### AC-1: Dependency Management Improvement
- **Given**: A user installs the RDI package
- **When**: The user runs RDI functions
- **Then**: The package uses system-installed kallisto and provides clear error messages if kallisto is not available
- **Verification**: `programmatic`
- **Notes**: The package should not include embedded kallisto executables

### AC-2: Input Validation and Error Handling
- **Given**: A user provides invalid input to RDI functions
- **When**: The user runs `create_index` or `calculate_RDI` with invalid parameters
- **Then**: The functions throw clear, informative error messages
- **Verification**: `programmatic`
- **Notes**: Functions should check for file existence, valid parameter types, and create output directories if needed

### AC-3: Cross-Platform Compatibility
- **Given**: A user runs RDI on Windows, Linux, or macOS
- **When**: The user runs RDI functions with file paths
- **Then**: The functions handle paths correctly on all platforms
- **Verification**: `programmatic`
- **Notes**: Python scripts should use os.path functions for path manipulation

### AC-4: Python Dependency Management
- **Given**: A user installs the RDI package
- **When**: The package is loaded
- **Then**: The package checks for required Python modules and installs them if missing
- **Verification**: `programmatic`
- **Notes**: Should handle both `python` and `python3` commands

### AC-5: Progress Indication
- **Given**: A user runs long-running RDI tasks
- **When**: The user runs `create_index` or `calculate_RDI`
- **Then**: The functions provide progress messages and timing information
- **Verification**: `human-judgment`
- **Notes**: Should show start/end times and elapsed time for each step

### AC-6: Improved Documentation
- **Given**: A user opens the RDI vignette
- **When**: The user reads the vignette
- **Then**: The vignette provides comprehensive documentation including installation, usage, and troubleshooting
- **Verification**: `human-judgment`
- **Notes**: Should include example workflows and result interpretation

### AC-7: Expanded Test Coverage
- **Given**: A developer runs the test suite
- **When**: The tests are executed
- **Then**: All tests pass, including tests for edge cases and error handling
- **Verification**: `programmatic`
- **Notes**: Tests should cover file existence checks, directory creation, and parameter validation

### AC-8: Code Duplication Reduction
- **Given**: A developer examines the codebase
- **When**: The developer reviews the R functions
- **Then**: Common functionality is extracted into helper functions
- **Verification**: `human-judgment`
- **Notes**: Helper functions should be well-documented and reused across both main functions

## Open Questions
- [ ] Should we add support for custom kallisto paths if it's not in the system PATH?
- [ ] Should we include a function to check all dependencies at once?
- [ ] Should we add a function to summarize RDI results across multiple samples?
