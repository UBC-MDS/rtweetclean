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




