
#' Most common words
#'
#'Returns the top_n most common words and counts of occurrences from a list of tweets.
#'The output is sorted descending by the count of words and in reverse
#'alphabetical order for any word ties.
#'
#' @param clean_dataframe data.frame
#' @param top_n numeric
#'
#' @return data.frame
#' @export
#'
#' @examples
#' input_data <- (data.frame(id = c(1,2,3,4,5),
#' text_only = c("this is example tweet 1",
#'              "this is example tweet 2 with a few extra words",
#'              "is third",
#'              "4th tweet",
#'              "fifth tweet")))
#' tweet_words(input_data, 3)
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

