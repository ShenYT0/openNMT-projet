#!/usr/bin/python3

#python3 ./scr/lematiser.py -p ./data/clean/Europarl
#python3 ./scr/lematiser.py -p ./data/clean/Emea

import argparse
import os
import nltk
from nltk.stem import WordNetLemmatizer
from french_lefff_lemmatizer.french_lefff_lemmatizer import FrenchLefffLemmatizer

def process_file(file_path):
    # Create a new file name
    file_parts = file_path.split('.')
    file_parts.insert(-1, 'lemma')
    new_file_name = '.'.join(file_parts)

    # Determine the language based on the file extension
    extension = file_path.split('.')[-1]
    if extension == "en":
        nltk.download('wordnet')
        lemmatizer = WordNetLemmatizer()
    elif extension == "fr":
        lemmatizer = FrenchLefffLemmatizer()
    else:
        print("Skipping file with unsupported extension:", file_path)
        return

    # Read, lemmatize, and write the new file
    with open(file_path, "r") as input_file:
        tokens = input_file.read().split(' ')
    lemmas = [lemmatizer.lemmatize(token) for token in tokens]
    with open(new_file_name, "w") as output_file:
        output_file.write(' '.join(lemmas))
    print("Processed:", file_path, "->", new_file_name)

def main(args):
    # Check if the provided path is a directory or a file
    if os.path.isdir(args.path):
        # Iterate through each file in the directory
        for filename in os.listdir(args.path):
            if filename.endswith('.en') or filename.endswith('.fr'):
                file_path = os.path.join(args.path, filename)
                process_file(file_path)
    elif os.path.isfile(args.path):
        process_file(args.path)
    else:
        print("The provided path is neither a file nor a directory")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Lemmatize text files in a specified directory or a single file.")
    parser.add_argument("-p", "--path", type=str, help="Path to the directory or file to process")
    args = parser.parse_args()
    main(args)
