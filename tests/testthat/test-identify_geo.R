test_that("identify_geo identifies geographic locations correctly", {
  example_gpx_path <- system.file("extdata", "icc_intro_ride.gpx", package = "gpxtoolbox")
  track_data <- read_gpx_track(example_gpx_path)
  track_data <- identify_geo(track_data, all = FALSE)
  
  expect_true("location" %in% colnames(track_data))
  expect_true(!is.na(track_data$location[1]))
  expect_true(!is.na(track_data$location[nrow(track_data)]))
})
