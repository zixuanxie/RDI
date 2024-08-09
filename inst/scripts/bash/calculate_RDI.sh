#!/bin/bash
time kallisto quant -i "output.idx" -o "output_directory" -b 100 -t "$4" "$1" "$2"
python3 inst/scripts/python/calculate_RDI.py --input "output_directory/abundance.tsv" --output1 "RDI.tsv" --output2 "RDI_sum.txt" "$@"
