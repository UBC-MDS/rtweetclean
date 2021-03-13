

# Helper data to test clean_df function

test_raw_df <- rtweet::read_twitter_csv("../rtweet_raw_df.csv", unflatten = FALSE)
# Test 1 for clean_df function
test_that('clean_df should take a dataframe as input', {
 testthat::expect_error(clean_df("not a dataframe"))
 testthat::expect_error(clean_df(123))
})
# Test 2 for clean_df function
test_that('clean_df should raise error if column is missing', {

  no_text_df <- data.frame(test_raw_df)
  no_text_df <- test_raw_df$text <- NULL

  no_retweet_count_df <- data.frame(test_raw_df)
  no_retweet_count_df$retweet_count <- NULL

  no_favorite_count_df <- data.frame(test_raw_df)
  no_favorite_count_df$favorite_count <- NULL

  testthat::expect_error(clean_df(no_text_df))
  testthat::expect_error(clean_df(no_retweet_count_df))
  testthat::expect_error(clean_df(no_favorite_count_df))

})

# Test 3 for clean_df function
test_that('clean_df should return a dataframe', {

  test_clean_df <- clean_df(test_raw_df)

  testthat::expect_true(is.data.frame(test_raw_df))

})

# # Test 4 for clean_df function
test_that('clean_df should contain generated columns', {

  test_clean_df <- clean_df(test_raw_df)

  testthat::expect_true("text_only" %in% names(test_clean_df))
  testthat::expect_true("word_count" %in% names(test_clean_df))
  testthat::expect_true("emojis" %in% names(test_clean_df))
  testthat::expect_true("prptn_rts_vs_avg" %in% names(test_clean_df))
  testthat::expect_true("prptn_favorites_vs_avg" %in% names(test_clean_df))

})

# # Test 5 for clean_df function
test_that('clean_df column types should be the right type', {

  test_clean_df <- clean_df(test_raw_df)
  data_types <- sapply(test_clean_df, class)

  testthat::expect_true("character" == data_types["text_only"])
  testthat::expect_true("integer" == data_types["word_count"])
  testthat::expect_true("list" == data_types["emojis"])
  testthat::expect_true("numeric" == data_types["prptn_rts_vs_avg"])
  testthat::expect_true("numeric" == data_types["prptn_favorites_vs_avg"])

})

# # Test 6 for clean_df function
test_that('clean_df column types should be the right type', {

  df_wrong_text_type <- data.frame(text = c(1, 2, 3),
                   retweet_count = c(23, 41, 32),
                   favorite_count = c(23, 41, 32)
  )

  df_wrong_retweet_type <- data.frame(text = c("tweet", "tweeet", "tweeeeeeeeeet"),
                                   retweet_count = c(23, 41, 32),
                                   favorite_count = c("a", "b", "c")
  )

  df_wrong_favorite_type <- data.frame(text = c("tweet", "tweeet", "tweeeeeeeeeet"),
                                      retweet_count = c(23, 41, 32),
                                      favorite_count = c("a", "b", "c")
  )

  testthat::expect_error(clean_df(df_wrong_text_type))
  testthat::expect_error(clean_df(df_wrong_retweet_type))
  testthat::expect_error(clean_df(df_wrong_favorite_type))

})

#Helper data for engagement_by_hour function
df <- data.frame (created_at  = c("2021-03-06 16:03:31", "2021-03-05 21:57:47", '2021-03-05 05:50:50'),
                  favorite_count = c(20, 10, 2),
                  retweet_count = c(20, 10, 2))

#Test 1 for engagement_by_hour function
test_that('Plot should use geom_line', {

  plot <- engagement_by_hour(df)

  testthat::expect_true("GeomLine" %in% c(class(plot$layers[[1]]$geom)))

})

#Test 2 for engagement_by_hour function
test_that('Plot should map x to x-axis and y to y-axis.', {

  plot <- engagement_by_hour(df)

  testthat::expect_true("hour"  == rlang::get_expr(plot$mapping$x))
  testthat::expect_true("average_engagement" == rlang::get_expr(plot$mapping$y))

})

# Test 1 for tweet_words function
test_that('tweet_words should return an error for wrong input data or datatypes', {
  # first input is an int when should be a tibble
  testthat::expect_error(tweet_words(5, 3))
  # second argument should be an int
  testthat::expect_error(tweet_words(5, "not an int"))
  # second argument should be a value greater than 0
  testthat::expect_error(tweet_words(5, 0))
})

# Test 2 for tweet_words function
test_that('tweet_words is not returning the correct dataframe', {
  # create input data
  input_data = data.frame(id = c(1,2,3,4,5),
                          text_only = c("this is example tweet 1",
                                        "this is example tweet 2 with a few extra words",
                                        "is third",
                                        "4th tweet",
                                        "fifth tweet"))
  # create expected output data
  expected_output_1 = data.frame(words = c("tweet"),
                                 count = as.integer(c(4)))
  expected_output_3 = data.frame(words = c("tweet", "is", "this"),
                               count = as.integer(c(4, 3, 2)))
  expected_output_1000 = data.frame(words =  c("tweet", "is", "this", "example", "words", "with", "third",
                                              "fifth", "few", "extra", "a", "4th", "2", "1"),
                                    count = as.integer(c(4,3,2,2,1,1,1,1,1,1,1,1,1,1)))


  # tests
  testthat::expect_true(dplyr::all_equal(tweet_words(input_data, 3), expected_output_3))
  testthat::expect_true(dplyr::all_equal(tweet_words(input_data, 1), expected_output_1))
  testthat::expect_true(dplyr::all_equal(tweet_words(input_data, 1000), expected_output_1000))

})


# tests for sentiment_total function

tweets <- data.frame(word = c("this is example tweet 1",
                                  "this is example tweet 2 with a few extra words",
                                  "is third",
                                  "4th tweet",
                                  "fifth tweet"))

sentiment_output <- rtweetclean::sentiment_total(tweets)
sentiment_output2 <- rtweetclean::sentiment_total(tweets, drop_sentiment = TRUE)

test_that('sentiment_total requires a list type for tweets input', {

  testthat::expect_equal(typeof(tweets), "list")
})

test_that('sentiment_total output object is not a data.frame', {

   testthat::expect_type(sentiment_output, "list")
})

test_that('sentiment_total sentiment column is not a chr data type', {
   testthat::expect_equal(class(sentiment_output$sentiment), "character")
})

test_that('sentiment_total word_count column is not integer data type', {
  testthat::expect_equal(typeof(sentiment_output$word_count), "integer")
})

test_that('sentiment_total total_words column is not integer data type', {
 testthat::expect_equal(typeof(sentiment_output$total_words), "integer")
})

test_that('sentiment_total is not dropping sentiments with word_counts==0)', {
 testthat::expect_equal(min(sentiment_output2$word_count), 1)
})





