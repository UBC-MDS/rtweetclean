#' NRC Word-Emotion Association Lexicon (aka EmoLex)
#'
#' `nrc_emotion_lexicon` contains a tibble of words commonly used in the english
#' along with emotions/sentiments commonly associated with those words.
#'
#' @format A tibble:
#' \describe{
#'   \item{text_only}{List of words commonly used in the english language}
#'   \item{sentiment}{Emotions/sentiments associated with each word}
#'   \item{count}{Binary of if the sentiment is associated with the word}
#' }
#' @source {http://saifmohammad.com/WebDocs/Lexicons}
"nrc_emotion_lexicon"