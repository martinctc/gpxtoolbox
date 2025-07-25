test_that("analyse_track works with GPX files", {
  example_gpx_path <- system.file("extdata", "icc_intro_ride.gpx", package = "gpxtoolbox")
  
  # Test default behavior (return = "stats")
  stats <- analyse_track(example_gpx_path)
  expect_type(stats, "list")
  expect_true("distance_km" %in% names(stats))
  
  # Test return = "data"
  track_data <- analyse_track(example_gpx_path, return = "data")
  expect_s3_class(track_data, "data.frame")
  expect_true(all(c("lon", "lat", "ele", "time") %in% colnames(track_data)))
  expect_gt(nrow(track_data), 0)
})

test_that("analyse_track maintains backward compatibility with analyse_gpx", {
  example_gpx_path <- system.file("extdata", "icc_intro_ride.gpx", package = "gpxtoolbox")
  
  # Both functions should produce the same results
  stats_track <- analyse_track(example_gpx_path)
  stats_gpx <- analyse_gpx(example_gpx_path)
  
  expect_equal(stats_track, stats_gpx)
})

test_that("analyse_track handles missing files gracefully", {
  expect_error(analyse_track("nonexistent_file.gpx"), "track file is missing")
})