#' Most common words
#'
#'Returns the most common words and counts from a list of tweets.
#'The output is sorted descending by the count of words and in reverse
#'alphabetical order for any word ties.
#'
#' @param clean_dataframe dataframe
#' @param top_n int
#'
#' @return dataframe
#' @export
#'
#' @examples
#' tweet_words(dataframe, 3)
tweet_words <- function(clean_dataframe, top_n=1) {

}


sentiment_total <- function(tweets, drop_sentiment = FALSE) {

#' Sentiment Word Counts
#'
#'Takes an input of of single english words and outputs the number of words associated
#'with eight emotions and positive/negative sentiment. This is based on the the
#'crowd-sourced NRC Emotion Lexicon, which associates words with eight basic emotions
#'(anger, fear, anticipation, trust, surprise, sadness, joy, and disgust) and two
#'sentiments (negative and positive). For more information on NRC:
#'http://saifmohammad.com/WebPages/NRC-Emotion-Lexicon.htm

#'Note that words can be 0:n with emotions (either associated with none, 1, or many).
#'
#' @param tweets 1-column dataframe
#' @param drop_sentiment. A true/false bool that drops sentiment rows if no words are
#'  associated with that sentiment
#'
#' @return dataframe
#' @export
#'
#' @examples
#' sentiment_total(df['tweets'], drop_sentiment = FALSE)
}


engagement_by_hour <- function(tweets_df) {

#' Average engagement by hour
#'
#' Creates a line chart of average number of likes and retweets received based on hour of tweet posted.
#'
#' @param tweets_df dataframe
#'
#' @return ggplot object
#' @export
#'
#' @examples
#' engagement_by_hour(my_tweets)
engagement_by_hour <- function(tweets_df) {

}
