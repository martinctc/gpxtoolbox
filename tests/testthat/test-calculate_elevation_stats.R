test_that("calculate_elevation_stats calculates elevation stats correctly", {
  example_gpx_path <- system.file("extdata", "icc_intro_ride.gpx", package = "gpxtoolbox")
  track_data <- read_gpx_track(example_gpx_path)
  track_data <- calculate_elevation_stats(track_data)
  
  expect_true(all(c("ele_gain", "ele_loss", "cumulative_ele_gain", "cumulative_ele_loss") %in% colnames(track_data)))
  expect_gt(max(track_data$cumulative_ele_gain, na.rm = TRUE), 0)
})
