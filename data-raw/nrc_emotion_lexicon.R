## code to prepare `nrc_emotion_lexicon` dataset goes here
download.file("http://saifmohammad.com/WebDocs/Lexicons/NRC-Emotion-Lexicon.zip", "NRC-Emotion-Lexicon.zip")
unzip("NRC-Emotion-Lexicon.zip")
file.remove("NRC-Emotion-Lexicon/NRC - Sentiment Lexicon - Research EULA Sept 2017 .pdf")
file.remove("NRC-Emotion-Lexicon/NRC-Emotion-Lexicon-v0.92/NRC-Emotion-Lexicon-v0.92-In105Languages-Nov2017Translations.xlsx")
file.remove("NRC-Emotion-Lexicon/NRC-Emotion-Lexicon-v0.92/Older Versions/NRC-Emotion-Lexicon-v0.92-InManyLanguages.xlsx")
file.remove("NRC-Emotion-Lexicon/NRC-Emotion-Lexicon-v0.92/Older Versions/readme.txt")
file.remove("NRC-Emotion-Lexicon/EmoLex-Ethics-Data-Statement.pdf")
file.remove("NRC-Emotion-Lexicon/NRC-Emotion-Lexicon-v0.92/Paper1_NRC_Emotion_Lexicon.pdf")
file.remove("NRC-Emotion-Lexicon/NRC-Emotion-Lexicon-v0.92/Paper2_NRC_Emotion_Lexicon.pdf")
file.remove("NRC-Emotion-Lexicon/NRC-Emotion-Lexicon-v0.92/Older Versions")
nrc_emotion_lexicon <- readr::read_table2("NRC-Emotion-Lexicon/NRC-Emotion-Lexicon-v0.92/NRC-Emotion-Lexicon-Wordlevel-v0.92.txt",
                                          col_names = c("text_only", "sentiment", "count"))
usethis::use_data(nrc_emotion_lexicon, overwrite = TRUE)