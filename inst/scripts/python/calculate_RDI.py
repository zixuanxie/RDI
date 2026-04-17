#!/usr/bin/env python3

import argparse
import pandas as pd
import numpy as np
import math
import os

def process_expression_file(file_path):
    ratios = {}

    with open(file_path, 'r') as input_file:
        next(input_file)
        for line in input_file:
            expression_5_line = line.strip().split('\t')
            est_counts_5 = float(expression_5_line[3])  # est_counts for 3'
            
            expression_3_line = next(input_file).strip().split('\t')
            est_counts_3 = float(expression_3_line[3])  # est_counts for 5'
            
            transcript_id = expression_5_line[0].rsplit('_', 1)[0]  # Extract the transcript ID without '_3' or '_5'

            
            # Calculate ratios
            if est_counts_5 == 0:
                if est_counts_3 == 0:
                    est_counts_ratio = 'infin'
                    degradation_mode = "both0"
                else:
                    est_counts_ratio = est_counts_5 / est_counts_3
                    degradation_mode = "from5"
            else:
                if est_counts_3 == 0:
                    est_counts_ratio = est_counts_3 / est_counts_5
                    degradation_mode = "from3"
                else:
                    if est_counts_3 <= est_counts_5:
                        est_counts_ratio = est_counts_3 / est_counts_5
                        if est_counts_3 == est_counts_5:
                            degradation_mode = "fromBoth"
                        else:
                            degradation_mode = "from3"
                    else:
                        est_counts_ratio = est_counts_5 / est_counts_3
                        degradation_mode = "from5"


            est_counts_ratio = round(est_counts_ratio, 2) if est_counts_ratio != 'infin' else 'infin'
            ratios[transcript_id] = (est_counts_ratio, degradation_mode)

    return ratios

def process_summary(ratios):
    data = pd.DataFrame(ratios, index=['est_counts_ratio', 'degradation_mode']).T

    # Remove 'infin' values
    data = data.replace('infin', np.nan).replace(0, np.nan).dropna()

    # Convert columns to numeric
    data['est_counts_ratio'] = pd.to_numeric(data['est_counts_ratio'])

    return data


def write_output_RDI(output_file, ratios):
    with open(output_file, 'w') as out_file:
        out_file.write('transcript_id\test_counts_ratio\tdegradation_mode\n')
        for transcript_id, (est_counts_ratio, degradation_mode) in ratios.items():
            out_file.write(f'{transcript_id}\t{est_counts_ratio}\t{degradation_mode}\n')
            
def write_summary(output_file, data):
    with open(output_file, 'w') as out_file:
        out_file.write('transcript_id\tIndex(mean)\tIndex(median)\tIndex(stdev)\n')
        mean_value = data.mean()
        median_value = data.median()
        std_dev_value = data.std()
        out_file.write(f'{data.name}\t{mean_value:.2f}\t{median_value:.2f}\t{std_dev_value:.2f}\n')

def main():
    # Create a command-line parser
    parser = argparse.ArgumentParser(description='Calculate RDI')
    parser.add_argument('--input', help='Path to the expression file')
    parser.add_argument('--output1', help='Path to the transcripts\' RDI file')
    parser.add_argument('--output2', help='Path to the RDI summary file')


    # Parse the command-line arguments
    args = parser.parse_args()
    
    # Normalize paths for cross-platform compatibility
    input_file = os.path.normpath(args.input)
    output1_file = os.path.normpath(args.output1)
    output2_file = os.path.normpath(args.output2)
    
    # Create output directories if they don't exist
    os.makedirs(os.path.dirname(output1_file), exist_ok=True)
    os.makedirs(os.path.dirname(output2_file), exist_ok=True)
    
    ratios = process_expression_file(input_file)
    data = process_summary(ratios)
    write_output_RDI(output1_file, ratios)
    write_summary(output2_file, data['est_counts_ratio'])


if __name__ == "__main__":
    main()
