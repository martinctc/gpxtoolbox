test_that("calculate_distance calculates distances correctly", {
  example_gpx_path <- system.file("extdata", "icc_intro_ride.gpx", package = "gpxtoolbox")
  track_data <- read_gpx_track(example_gpx_path)
  track_data <- calculate_distance(track_data)
  
  expect_true("distance" %in% colnames(track_data))
  expect_true("cumulative_distance" %in% colnames(track_data))
  expect_gt(max(track_data$cumulative_distance, na.rm = TRUE), 0)
})
