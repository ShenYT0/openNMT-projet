import argparse
from bert_score import score

def calculate_bert_score(translated_text, reference_text, lang="fr", verbose=False):
    """
    Calculate the BERT score for the given translated and reference texts.
    
    Args:
    translated_text (list of str): Translated sentences.
    reference_text (list of str): Reference sentences.
    lang (str): Language code for BERT model.
    verbose (bool): Verbosity of BERT score function.

    Returns:
    tuple: Mean Precision, Recall, and F1 scores.
    """
    P, R, F1 = score(translated_text, reference_text, lang=lang, verbose=verbose)
    print(f"Mean Precision: {P.mean():.4f}")
    print(f"Mean Recall: {R.mean():.4f}")
    print(f"Mean F1: {F1.mean():.4f}")

    return P, R, F1

def main():
    parser = argparse.ArgumentParser(description="Calculate BERT scores for translated texts.")
    parser.add_argument("reference_path", type=str, help="Path to the reference text file.")
    parser.add_argument("translated_path", type=str, help="Path to the translated text file.")
    args = parser.parse_args()

    try:
        with open(args.reference_path, "r") as file:
            reference_text = file.readlines()

        with open(args.translated_path, "r") as file:
            translated_text = file.readlines()

        assert len(reference_text) == len(translated_text), "The two files must have the same number of lines"

        calculate_bert_score(translated_text, reference_text, lang="fr", verbose=True)

    except Exception as e:
        print(f"Error: {str(e)}")

if __name__ == "__main__":
    main()
