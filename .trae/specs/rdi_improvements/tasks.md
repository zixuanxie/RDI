# RDI Package Improvements - Implementation Plan

## [ ] Task 1: Remove Embedded kallisto Executables and Add System Dependency Checks
- **Priority**: P0
- **Depends On**: None
- **Description**: 
  - Remove embedded kallisto executables from the package
  - Update R functions to use system-installed kallisto
  - Add kallisto installation checks with clear error messages
- **Acceptance Criteria Addressed**: AC-1
- **Test Requirements**:
  - `programmatic` TR-1.1: Functions throw error when kallisto is not installed
  - `programmatic` TR-1.2: Functions use system kallisto when available
- **Notes**: Update both `create_index` and `calculate_RDI` functions

## [ ] Task 2: Add Input Validation and Error Handling to R Functions
- **Priority**: P0
- **Depends On**: Task 1
- **Description**: 
  - Add file existence checks for input files
  - Validate parameter types and values
  - Add try-catch blocks for error handling
  - Create output directories if they don't exist
- **Acceptance Criteria Addressed**: AC-2
- **Test Requirements**:
  - `programmatic` TR-2.1: Functions throw errors for non-existent files
  - `programmatic` TR-2.2: Functions throw errors for invalid parameters
  - `programmatic` TR-2.3: Functions create output directories if needed
- **Notes**: Implement in both `create_index` and `calculate_RDI` functions

## [ ] Task 3: Fix Cross-Platform Path Handling for Python Scripts
- **Priority**: P0
- **Depends On**: None
- **Description**: 
  - Update Python scripts to use os.path functions for path manipulation
  - Add path normalization and output directory creation
  - Ensure compatibility with Windows, Linux, and macOS
- **Acceptance Criteria Addressed**: AC-3
- **Test Requirements**:
  - `programmatic` TR-3.1: Python scripts handle paths correctly on all platforms
  - `programmatic` TR-3.2: Python scripts create output directories if needed
- **Notes**: Update both `create_index.py` and `calculate_RDI.py`

## [ ] Task 4: Enhance Python Dependency Checks and Installation
- **Priority**: P1
- **Depends On**: None
- **Description**: 
  - Update install.R to detect both `python` and `python3`
  - Add pip detection and installation of required modules
  - Improve error messages for Python-related issues
- **Acceptance Criteria Addressed**: AC-4
- **Test Requirements**:
  - `programmatic` TR-4.1: Package detects Python 3 installation
  - `programmatic` TR-4.2: Package installs missing Python modules
- **Notes**: Handle both `pip` and `pip3` commands

## [ ] Task 5: Add Progress Indication for Long-Running Tasks
- **Priority**: P1
- **Depends On**: Task 1, Task 2
- **Description**: 
  - Add progress messages for each step of the workflow
  - Include timing information for each step
  - Provide confirmation messages for generated files
- **Acceptance Criteria Addressed**: AC-5
- **Test Requirements**:
  - `human-judgment` TR-5.1: Functions display clear progress messages
  - `human-judgment` TR-5.2: Functions show timing information for each step
- **Notes**: Implement in both R functions

## [ ] Task 6: Improve Documentation with More Detailed Vignette
- **Priority**: P1
- **Depends On**: None
- **Description**: 
  - Rewrite the vignette to provide comprehensive documentation
  - Include installation instructions and prerequisites
  - Add usage examples and workflow examples
  - Include troubleshooting tips and result interpretation
- **Acceptance Criteria Addressed**: AC-6
- **Test Requirements**:
  - `human-judgment` TR-6.1: Vignette is well-structured and informative
  - `human-judgment` TR-6.2: Vignette includes all necessary information
- **Notes**: Use RMarkdown format and include code examples

## [ ] Task 7: Expand Test Coverage
- **Priority**: P1
- **Depends On**: Task 2
- **Description**: 
  - Add tests for edge cases and error handling
  - Create test data files
  - Add tests for directory creation and file existence checks
  - Ensure tests pass on all platforms
- **Acceptance Criteria Addressed**: AC-7
- **Test Requirements**:
  - `programmatic` TR-7.1: All tests pass
  - `programmatic` TR-7.2: Tests cover edge cases and error handling
- **Notes**: Use testthat framework and create test data in extdata

## [x] Task 8: Reduce Code Duplication Between R Functions
- **Priority**: P2
- **Depends On**: Task 1, Task 2, Task 5
- **Description**: 
  - Create a helper functions file with common functionality
  - Extract shared code into helper functions
  - Update both R functions to use helper functions
  - Ensure helper functions are well-documented
- **Acceptance Criteria Addressed**: AC-8
- **Test Requirements**:
  - `human-judgment` TR-8.1: Code duplication is reduced
  - `human-judgment` TR-8.2: Helper functions are well-documented
- **Notes**: Create helpers.R file in the R directory
