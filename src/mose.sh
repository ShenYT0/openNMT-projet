#!/bin/bash

# run in ./ not in ./src

execute_operation_tok=false
execute_operation_tt=false
execute_operation_tr=false
execute_operation_c=false

for arg in "$@"; do
    case "$arg" in
        -tok )
        execute_operation_tok=true
        ;;
        -tt )
        execute_operation_tt=true
        ;;
        -tr )
        execute_operation_tr=true
        ;;
        -c )
        execute_operation_c=true
        ;;
        * )
        echo "Unkown : $1"
        exit 1
        ;;
    esac
    shift
done

if [ "$execute_operation_tok" = true ]; then
    echo "Tokenization"
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
fi


if [ "$execute_operation_tt" = true ]; then
    # conversion: maj -> mini
    train_truecaser="mosesdecoder/scripts/recaser/train-truecaser.perl"

    for file in data/raw/tokenized/*/*train*.tok.*; do
        if [ -f "$file" ]; then
            filename_extension="${file##*.}"
            parent_dir=$(basename "$(dirname "$file")")
            mkdir -p "data/model/$parent_dir/"
            $train_truecaser --model data/model/$parent_dir/truecase-model.$filename_extension --corpus "$file"
        fi
    done
fi

if [ "$execute_operation_tr" = true ]; then
    truecaser="mosesdecoder/scripts/recaser/truecase.perl"

    for file in data/raw/tokenized/*/*; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")

            filename_extension="${filename##*.}"

            parent_dir=$(basename "$(dirname "$file")")

            output_file="data/raw/truecased/${file:19:-3}.true.${filename_extension}"

            mkdir -p "$(dirname "$output_file")"

            echo "Truecase: Processing $file to $output_file"

            $truecaser --model data/model/$parent_dir/truecase-model.$filename_extension < "$file" > "$output_file"
        fi
    done
fi

if [ "$execute_operation_c" = true ]; then
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
fi