#!/usr/bin/env python3
import random
import argparse

def read_fasta(file_path):
    sequences = {}
    current_sequence = None

    with open(file_path, 'r') as fasta_file:
        for line in fasta_file:
            line = line.strip()
            if line.startswith('>'):
                current_sequence = line[1:]
                sequences[current_sequence] = ''
            else:
                sequences[current_sequence] += line

    return sequences

def split_sequences(sequences):
    split_sequences = {}
    percentile = 3
    
    for name, seq in sequences.items():
        length = len(seq)
        split_point = length // percentile
        pos3end = split_point * (percentile - 1)
        pos5end = split_point
        posm5 = (length - split_point) // 2
        posm3 = (length + split_point) // 2

        # 5' part
        header_5 = f'{name}_5'
        sequence_5 = seq[:pos5end]
        split_sequences[header_5] = sequence_5
        
        # 3' part
        header_3 = f'{name}_3'
        sequence_3 = seq[pos3end:]
        split_sequences[header_3] = sequence_3

    return split_sequences

def write_fasta(output_file, sequences):
    with open(output_file, 'w') as out_file:
        for header, sequence in sequences.items():
            out_file.write(f'>{header}\n{sequence}\n')
            
def main():
    # Create a command-line parser
    
    parser = argparse.ArgumentParser(description='Split sequences into 5 and 3 ends')
    parser.add_argument('--input', help='Path to the original fasta file')
    parser.add_argument('--output', help='Path to splited fasta file')


    # Parse the command-line arguments
    args = parser.parse_args()
    
    seqs = read_fasta(args.input)
    split_seqs = split_sequences(seqs)
    write_fasta(args.output, split_seqs)

    
if __name__ == "__main__":
    main()
