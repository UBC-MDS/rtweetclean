


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

tweets = data.frame(id = c(1,2,3,4,5),
                    text_only = c("this is example tweet 1",
                                  "this is example tweet 2 with a few extra words",
                                  "is third",
                                  "4th tweet",
                                  "fifth tweet"))

sentiment_output <- sentiment_total(tweets)
sentiment_output2 <- sentiment_total(tweets, drop_sentiment = TRUE)

test_that('sentiment_total requires a list type for tweets input', {
  testthat::expect_error(sentiment_total(5)) # wrong data type
})

test_that('sentiment_total output is not a data.frame', {
  testthat::expect_equal(typeof(sentiment_total), "data.frame")
})

test_that('sentiment_total sentiment column is not a chr data type', {
  testthat::expect_equal(typeof(sentiment_total$sentiment), "chr")
})

test_that('sentiment_total word_count column is not integer data type', {
  testthat::expect_equal(typeof(sentiment_total$word_count), "int")
})

test_that('sentiment_total total_words column is not integer data type', {
  testthat::expect_equal(typeof(sentiment_total$total_words), "int")
})

test_that('sentiment_total is not dropping sentiments with word_counts==0)', {
  testthat::expect_equal(typeof(min(sentiment_output2$word_count), 1))
})



