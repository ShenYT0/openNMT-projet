def merge_files(file_list, output_file):
    with open(output_file, 'w', encoding='utf-8') as outfile:
        for fname in file_list:
            with open(fname, 'r', encoding='utf-8') as infile:
                # Read each line from the source files and write it to the output file
                for line in infile:
                    outfile.write(line)

# merge English training data
merge_files(['../data/raw/Europarl_train_100k.en', '../data/raw/Emea_train_10k.en'], '../data/raw/Merged_train_110k.en')

# merge French training data
merge_files(['../data/raw/Europarl_train_100k.fr', '../data/raw/Emea_train_10k.fr'], '../data/raw/Merged_train_110k.fr')
