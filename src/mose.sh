#!/bin/bash

# Tokenize
tokenizer="mosesdecoder/scripts/tokenizer/tokenizer.perl"

for file in data/raw/*/*; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        
        # get filename without extension and the extension
        filename_prefix="${filename%.*}"
        filename_extension="${filename##*.}"

        output_file="data/raw/tokenized/${file:9:-3}.tok.${filename_extension}"

        echo "Tokenizer: Processing $file to $output_file"

        if [ "$filename_extension" = "en" ]; then
            mkdir -p "$(dirname "$output_file")"
            $tokenizer -l en < "$file" > "$output_file"
        fi

        if [ "$filename_extension" = "fr" ]; then
            mkdir -p "$(dirname "$output_file")"
            $tokenizer -l fr < "$file" > "$output_file"
        fi
    fi
done

# conversion: maj -> mini
train_truecaser="mosesdecoder/scripts/recaser/train-truecaser.perl"

for file in data/raw/tokenized/Merged/*train*.tok.*; do
    if [ -f "$file" ]; then
        filename_extension="${file##*.}"
        if [ "$filename_extension" = "en" ]; then
            mkdir -p "data/model/truecase/"
            $train_truecaser --model data/model/truecase/truecase-model.en --corpus "$file"
        elif [ "$filename_extension" = "fr" ]; then
            $train_truecaser --model data/model/truecase/truecase-model.fr --corpus "$file"
        fi
    fi
done

truecaser="mosesdecoder/scripts/recaser/truecase.perl"

for file in data/raw/tokenized/*/*; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")

        filename_extension="${filename##*.}"

        output_file="data/raw/truecased/${file:19:-3}.true.${filename_extension}"

        mkdir -p "$(dirname "$output_file")"

        echo "Truecase: Processing $file to $output_file"

        $truecaser --model data/model/truecase/truecase-model.$filename_extension < "$file" > "$output_file"
    fi
done

# clean - save first 80 characters
cleaner="mosesdecoder/scripts/training/clean-corpus-n.perl"

for file in data/raw/truecased/*/*; do
    if [ -f "$file" ]; then
        
        echo "Cleaning: Processing ${file:0:-3} to data/clean/${file:19:-3}.clean"

        parent_dir=$(basename "$(dirname "$file")")

        mkdir -p "data/clean/$parent_dir"

        $cleaner "${file:0:-3}" fr en "data/clean/${file:19:-3}.clean" 1 80
    fi
done