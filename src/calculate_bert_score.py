import sys
from bert_score import score


def calcul_bert_score(translated_text, reference_text, lang="fr", verbose=False):
    P, R, F1 = score(translated_text, reference_text, lang=lang, verbose=verbose)


    print(f"Mean Precision: {P.mean():.4f}")
    print(f"Mean Recall: {R.mean():.4f}")
    print(f"Mean F1: {F1.mean():.4f}")

    return P, R, F1


def main():
    reference_path = sys.argv[1]
    translated_path = sys.argv[2]


    with open(reference_path, "r") as file:
        reference_text = file.readlines()

    with open(translated_path, "r") as file:
        translated_text = file.readlines()

    assert len(reference_text) == len(
        translated_text
    ), "The two files must have the same numbers of lines"

    P, R, F1 = calcul_bert_score(
        translated_text, reference_text, lang="fr", verbose=True
    )


if __name__ == "__main__":
    main()