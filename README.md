  <!-- badges: start -->
  [![R build status](https://github.com/UBC-MDS/rtweetclean/workflows/R-CMD-check/badge.svg)](https://github.com/UBC-MDS/rtweetclean/actions)
  <!-- badges: end -->

# rtweetclean

rtweetclean is a R package built to act as a processor of data generated by the existing [rtweet package](https://www.rdocumentation.org/packages/rtweet/versions/0.4.0) that can produce clean data frames, summarize data, and generate new features.

Our package aims to add additional resources for users of the already existing rtweet package. rtweet is a package built around Twitter's API and is used to scrape tweet information from their servers. Our package creates functionality which enables users to process the raw data from rtweet into a more understandable format by extracting and organizing the contents of tweets for a user. rtweet is specifically built to be used in analysis of a specific user's timeline (generated using tweepy's api.user\_timeline function). Users can easily visualize average engagement based on time of day posted, see basic summary statistics of word contents and sentiment analysis of tweets and have a processed dataset that can be used in a wide variety of machine learning models.

## Installation

-   TODO

## Features

-   TODO

## Dependencies

-   TODO

## Usage

**Functions**

`clean_df(raw_tweets_df, handle = "", text_only = TRUE, word_count = TRUE, emojis = TRUE, hashtags = TRUE, sentiment = TRUE, flesch_readability = TRUE, proportion_of_avg_retweets = TRUE, proportion_of_avg_favorites = TRUE)`: Creates new columns based on the data in the dataframe generated by raw\_df() and returns a new dataframe. Can generate the following columns.

-   handle: Adds a column containing the a specified twitter handle.

-   text\_only: Adds a column of the tweet text containing no emojis, links, hashtags, or mentions.

-   emojis: Adds a column of the extracted emojis from tweet text and places them in their own column

-   hashtags: Add a column of the extracted hashtags from tweet text

-   sentiment: add a column containing the nltk.sentiment.vader SentimentIntensityAnalyzer sentiment score for each tweet

-   flesch\_readability: Adds a column containing the textstat flesch readability score (default is TRUE)

-   media\_links: Adds a column containing links to photo or video attached to a tweet

-   proportion\_of\_avg\_retweets: Adds a column containing a proportion value of how many retweets a tweet received compared to the account average.

-   proportion\_of\_avg\_hearts: Adds a column containing a proportion value of how many hearts a tweet received compared to the account average

`engagement_by_hour(tweets_df)` : Creates an ggplot line chart of average number of likes and retweets received by hour of tweet posted.

`tweet_words(clean_dataframe, top_n=1)` : Returns a dataframe of the most common words and counts from a list of tweets.

`sentiment_total(tweets, drop_sentiment = FALSE)`: Takes a list of tweets and summarizes the number of tweeted words associated with particular emotional sentiments. Returns a dataframe.

## rtweetclean Place in the R Ecosystem

rtweetclean provides functionality that is the first of its kind. Working with rtweet data has always required extensive data processing in order to produce a clean dataframe with useful features. By using rtweetclean it is easy and straightforward to extract the data hidden within the features that rtweet already scrapes, while also allowing users to optionally apply various forms of statistical analysis and language processing tools (such as sentiment analysis) to the data. This is combined with streamlined summary statistics methods that can quickly and effortlessly produce figures and tables of various different factors in your rtweet data. This allows users to easily understand and analyze information about a twitter user's timeline. Specifically, examining an accounts engagement, most common words, and emotional sentiment can each be done with a single function.

## Documentation

- TODO

## Contributors

We welcome and recognize all contributions. You can see a list of current contributors in the [contributors tab]. This repository is currently maintained by [@nashmakh], [@calsvein], [@MattTPin], [@syak].

