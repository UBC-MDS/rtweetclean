library(tidyr)
library(tidyverse)

#' Adds new column(s) to dataframe returned by rtweet get_timeline() function with
#' default parameters based on user specified input
#'
#'Returns a new dataframe containing additional columns that were not in the original
#'Generatable columns include...
#'  text_only: strips emojis, hashtags, and hyperlinks from the text column
#'  word_count: counts the number of words contained in the text_only column
#'  emojis: contains the extracted emojis from text
#'  proportion_of_avg_retweets: a proportion value of how many retweets a tweet received compared to the account average
#'  proportion_of_avg_favorites: a proportion value of how many favorites a tweet received compared to the account average
#'
#' @param raw_tweets_df dataframe
#' @param text_only bool
#' @param word_count bool
#' @param emojis bool
#' @param proportion_of_avg_retweets bool
#' @param proportion_of_avg_favorites bool
#'
#' @return dataframe
#' @export
#'
#' @examples
#' function(raw_tweets_df)
#' function(raw_tweets_df, handle = "Canucks")
#' function(raw_tweets_df, handle = "Canucks", word_count = FALSE)
clean_df <- function(raw_tweets_df,
                     text_only = TRUE,
                     word_count = TRUE,
                     emojis = TRUE,
                     proportion_of_avg_retweets = TRUE,
                     proportion_of_avg_favorites = TRUE)
{

  data_types <- sapply(raw_tweets_df, class)

  # test that input is df
  if(!is.data.frame(raw_tweets_df)){
    stop("Input needs to be of type data.frame")
  }

  # test that retweet_count exists
  if (!("retweet_count" %in% colnames(raw_tweets_df))) {
    stop("
         No retweet_count column present in dataframe needed to
         generate proportion_of_avg_retweets")
  }

  # test that input is df
  if(!data_types["retweet_count"] == "integer"){
    stop("'retweet_count' col of input wrong datatype should be integer")
  }

  # test that favorite_count exists
  if (!("favorite_count" %in% colnames(raw_tweets_df))) {
    stop("
         No favorite_count column present in dataframe needed to
         generate proportion_of_avg_favorites")
  }

  # test that input is df
  if(!data_types["favorite_count"] == "integer"){
    stop("'favorite_count' col of input wrong datatype should be integer")
  }

  # test that text exists
  if (!("text" %in% colnames(raw_tweets_df))) {
    stop("
         No text column present in dataframe needed to
         generate text_only and/or word_count")
  }

  # test that input is df
  if(!data_types["text"] == "character"){
    stop("'text' col of input wrong datatype should be character")
  }

  tweets_df <- data.frame(raw_tweets_df)

  if (proportion_of_avg_retweets) {
    avg_retweets <- mean(tweets_df$retweet_count)
  }

  if (proportion_of_avg_favorites) {
    avg_favorites <- mean(tweets_df$favorite_count)
  }

  for (i in 1:nrow(tweets_df)) {

    tweet_text <- tweets_df$text[i]

    # Remove emojis
    text_only_str <- gsub("\\p{So}|\\p{Cn}", " ", tweet_text, perl = TRUE)
    # Remove "@'s"
    text_only_str <- gsub("@\\w+ *", " ", text_only_str)
    # Remove "#'s"
    text_only_str <- gsub("#\\w+ *", " ", text_only_str)
    # Replace https ampersands
    text_only_str <- gsub("&amp;", "&", text_only_str)
    # Remove https links
    text_only_str <- gsub(" ?(f|ht)(tp)(s?)(://)(.*)[.|/](.*)", " ", text_only_str)
    # Remove new lines
    text_only_str <- gsub("[\r\n]", " ", text_only_str)
    # Remove double spaces
    text_only_str <- gsub(" +", " ", text_only_str)
    # Remove  whitespace
    text_only_str <- trimws(text_only_str)

    if (text_only) {
      tweets_df$text_only[i] <- text_only_str
    }

    if (word_count){
      tweets_df$word_count[i] <- sapply(strsplit(text_only_str, "\\s+"), length)
    }

    if (emojis) {
      tweets_df$emojis[i] <- as.list(str_extract_all(tweets_df$text[i], "\\p{So}|\\p{Cn}"))
    }

    if (proportion_of_avg_retweets) {
      tweets_df$prptn_rts_vs_avg[i] <- tweets_df$retweet_count[i] / avg_retweets
    }

    if (proportion_of_avg_favorites) {
      tweets_df$prptn_favorites_vs_avg[i] <- tweets_df$favorite_count[i] / avg_favorites
    }

  }

  return(tweets_df)

}

#' Most common words
#'
#'Returns the top_n most common words and counts of occurrences from a list of tweets.
#'The output is sorted descending by the count of words and in reverse
#'alphabetical order for any word ties.
#'
#' @param clean_dataframe dataframe
#' @param top_n numeric
#'
#' @return dataframe
#' @export
#'
#' @examples
#' tweet_words(dataframe, 3)
tweet_words <- function(clean_dataframe, top_n=1) {
  # check that clean_dataframe is a dataframe
  if(!is.data.frame(clean_dataframe)){
    stop("Input needs to be of type data.frame")
  }
   # check that top_n is an int
  if(!is.numeric(top_n)){
    stop("Input needs to be of type data.frame")
  }
  # check that top_n is greater than 0
  if(!(top_n > 0)){
    stop("Input needs to be of type data.frame")
  }

  data <- tidyr::as_tibble(clean_dataframe)

  output <- data %>%
    tidytext::unnest_tokens(word, text_only) %>%
    dplyr::count(word) %>%
    dplyr::arrange(-n, desc(word)) %>%
    dplyr::mutate(words = word,
                  count = as.integer(n)) %>%
    dplyr::select(words, count) %>%
    dplyr::slice_head(n = top_n)

  output <- data.frame(output)
  output
}


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
#' @param drop_sentiment A true/false bool that drops sentiment rows if no words are
#'  associated with that sentiment
#'
#' @return dataframe
#' @export
#'
#' @examples
#' sentiment_total(tweets, drop_sentiment = FALSE)
sentiment_total <- function(tweets, drop_sentiment = FALSE) {

  # Check tweets is a list
  if(typeof(tweets) != 'list'){
    stop("tweets input must be  a list")
  }

  # Check drop_sentiment is bool
  if(drop_sentiment != TRUE & drop_sentiment != FALSE){
    stop("drop_sentiment must be a bool")
  }

  # messy wrangling necessary for separate_rows() to work
  tweet_words <- tweets %>% mutate(id = row_number())
  tweet_words <- separate_rows(tweets, word)
  tweet_words <- tweet_words %>% select(word)
  total_words = nrow(tweet_words)

  # lexicon
  emotion_lexicon_df <- read.csv("NRC-Emotion-Lexicon-Wordlevel-v0.92.txt",
                                 header = TRUE, sep = "\t") # NRC dataset

  # inner join on 2 dataframes
  tweet_words_sentiment <- merge(tweet_words, emotion_lexicon_df, all = FALSE)

  #if user deviates from default parameter drop 0 count sentiments
  if (drop_sentiment == TRUE) {
    tweet_words_sentiment <- tweet_words_sentiment %>%
      dplyr::filter(count == 1)
  }
  # get aggregated sentiment-words counts
  tweet_words_sentiment <- tweet_words_sentiment %>%
    dplyr::group_by(sentiment) %>%
    dplyr::summarise(word_count = sum(count))

  # add total words from input list of tweets
  tweet_words_sentiment <- tweet_words_sentiment %>%
    dplyr::mutate(total_words = total_words)


  return(tweet_words_sentiment)
}

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

  # Check input type of tweets_df
  if(!is.data.frame(tweets_df)){
    stop("Input needs to be of type data.frame")
  }

  # Wrangle data
  grouped_df <- tweets_df %>%
    dplyr::mutate(hour = lubridate::hour(lubridate::ymd_hms(as.character(factor(created_at))))) %>%
    dplyr::mutate(total_engagement = favorite_count + retweet_count) %>%
    dplyr::group_by(hour) %>%
    dplyr::summarise(average_engagement = mean(total_engagement))

  # Plot chart
  grouped_df %>% ggplot2::ggplot(ggplot2::aes(x=hour, y=average_engagement)) +
    ggplot2::geom_line() +
    ggplot2::labs(title = 'Average engagement (likes + retweets) by hour',
         x = 'Time (hour of day)',
         y = 'Average engagement')
}



tweets = data.frame(word = c("this is example tweet 1",
                                                "this is example tweet 2 with a few extra words",
                                                "is third",
                                                "4th tweet",
                                                "fifth tweet"))

z <- sentiment_total(tweets2)


