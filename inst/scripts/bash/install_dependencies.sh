#!/bin/bash

# Function to check if package is installed
check_package() {
    if command -v "$1" &> /dev/null; then
        return 0  # Package is installed
    else
        return 1  # Package is not installed
    fi
}

# # Function to check if conda is available
# check_conda() {
#     if [ -n "$CONDA_EXE" ]; then
#         return 0  # Conda is available
#     else
#         return 1  # Conda is not available
#     fi
# }
#
# # Function to install dependencies using conda
# install_conda() {
#     conda install -y -c conda-forge bio python-random argparse pandas numpy
# }

# # Function to install dependencies using pip
# install_pip() {
#     pip install Bio python-random argparse pandas numpy
# }

# Function to install kallisto from source
install_kallisto_from_source() {
    wget https://github.com/pachterlab/kallisto/releases/download/v0.46.1/kallisto_linux-v0.46.1.tar.gz
    tar -xvf kallisto_linux-v0.46.1.tar.gz
    cd kallisto-v0.46.1
    mkdir build
    cd build
    cmake ..
    make
    sudo make install
}

# Function to check if a Python module is installed
check_module() {
    python -c "import $1" &> /dev/null
}

# Function to check Python version and install Python 3.8 if needed
check_and_install_python() {
    if ! check_package "python"; then
        echo "Python not found, installing Python 3.8..."
        sudo apt-get update
        sudo apt-get install -y python3.8
    elif [ "$(python --version | grep -o '3\.')" != "3." ]; then
        echo "Warning: Python 3.x is required. Please install Python 3.8 or higher manually."
        exit 1
    fi
}

# Main script

# Check and install Python
check_and_install_python

# List of required python modules
modules=("Bio" "random" "argparse" "pandas" "numpy" "os" "math")

for module in "${modules[@]}"; do
    if ! check_module "$module"; then
        echo "Warning: Module '$module' not found, installing..."
        pip install "$module"
    fi
done

if ! check_package "kallisto"; then
    echo "kallisto not found, installing..."
    install_kallisto_from_source
fi

# # Check if conda is available
# if check_conda; then
#     echo "Conda found, installing dependencies using conda..."
#     install_conda
# else
#     echo "Conda not found, installing python modules using pip..."
#     install_pip
#     echo "Conda not found, installing kallisto from source..."
#     install_kallisto_from_source
# fi

# Check if all dependencies are installed
echo "Checking if all modules are installed..."
missing_dependencies=()

for module in "${modules[@]}"; do
    if ! check_module "$module"; then
        echo "Warning: Module '$module' not found. Please install manually before calculating RDI."
        missing_dependencies+=("$module")
    fi
done

if ! check_package "kallisto"; then
    echo "kallisto not found. Please install manually before calculating RDI."
    missing_dependencies+=("kallisto")
fi

# Display the results
if [ ${#missing_dependencies[@]} -eq 0 ]; then
    echo "All dependencies are installed successfully."
else
    echo "Warning: Some dependencies are missing: ${missing_dependencies[@]}"
fi
