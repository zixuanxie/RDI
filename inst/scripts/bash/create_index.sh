#!/bin/bash
python3 inst/scripts/python/create_index.py "$@"
kallisto index -i "output.idx" "output.fa"
