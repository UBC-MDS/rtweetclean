#' Adds new column(s) to dataframe returned by rtweet get_timeline() function with
#' default parameters based on user specified input
#'
#'Returns a new dataframe containing additional columns that were not in the original
#'Generatable columns include...
#'  handle: contains specified twitter handle, (default is none and adds no column)
#'  text_only: strips emojis, hashtags, and hyperlinks from the text column
#'  word_count: counts the number of words contained in the text_only column
#'  emojis: contains the extracted emojis from text
#'  hashtags: contains the extracted hashtags from text
#'  sentiment: contains the a sentiment polarity score
#'  flesch_readability: contains the a flesch readability score
#'  proportion_of_avg_retweets: a proportion value of how many retweets a tweet received compared to the account average
#'  proportion_of_avg_favorites: a proportion value of how many favorites a tweet received compared to the account average
#'
#'alphabetical order for any word ties.
#'
#' @param raw_tweets_df dataframe
#' @param handle str
#' @param text_only bool
#' @param word_count bool
#' @param emojis bool
#' @param hashtags bool
#' @param sentiment bool
#' @param flesch_readability bool
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
clean_df <- function(raw_tweets_df, handle = "", text_only = TRUE, word_count = TRUE, emojis = TRUE, hashtags = TRUE, sentiment = TRUE, flesch_readability = TRUE, proportion_of_avg_retweets = TRUE, proportion_of_avg_favorites = TRUE) {

}


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
sentiment_total <- function(tweets, drop_sentiment = FALSE) {

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
