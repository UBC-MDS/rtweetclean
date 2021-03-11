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
