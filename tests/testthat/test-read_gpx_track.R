test_that("read_gpx_track reads GPX file correctly", {
  example_gpx_path <- system.file("extdata", "icc_intro_ride.gpx", package = "gpxtoolbox")
  track_data <- read_gpx_track(example_gpx_path)
  
  expect_s3_class(track_data, "data.frame")
  expect_true(all(c("lon", "lat", "ele", "time") %in% colnames(track_data)))
  expect_gt(nrow(track_data), 0)
})
