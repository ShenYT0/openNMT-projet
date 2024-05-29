# openNMT-projet
openNMT-projet pour le cours Traduction Automatique et Assistée

## Groupe member
Siman Chen [simannnc](https://github.com/simannnc)

Yutian Shen [ShenYT0](https://github.com/ShenYT0)

Xinlei Chen [chenxinlei1](https://github.com/chenxinlei1)

# File functions

test_example.ipynb & test_example.yaml : test opennmt using example data : Europarl10k

split_corpus.ipynb :  cut corpus data to train, dev and test.

preprocess.ipynb & mose.sh : pre-processed the data using mosedecoder, the shell version is for windows user who can't use perl in jupyter.

lemmatiser.py & lemmatisation.ipynb & lemma.ipynb : lemmatization , lemma.ipynb is the final version

compare_Spacy.ipynb : compare with nltk and spaCy to find the better lemmatizer

calculate_bert_score.py & train_and_compare.ipynb : train the model and calculate BLEU score and bert score to compare different models.