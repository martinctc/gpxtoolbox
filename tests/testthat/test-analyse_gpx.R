test_that("analyse_gpx processes GPX file correctly", {
  example_gpx_path <- system.file("extdata", "icc_intro_ride.gpx", package = "gpxtoolbox")
  
  stats <- analyse_gpx(example_gpx_path, return = "stats")
  expect_named(
    stats,
    c(
      "total_distance_km",
      "total_elevation_gain_m",
      "total_elevation_loss_m",
      "max_elevation_m",
      "min_elevation_m",
      "start_point",
      "end_point",
      "p25_point",
      "p50_point",
      "p75_point"
    ),
    ignore.order = TRUE
  )
  
  track_data <- analyse_gpx(example_gpx_path, return = "data")
  expect_s3_class(track_data, "data.frame")
  
  expect_error(analyse_gpx("invalid_path.gpx"), "The GPX file is missing or empty")
})
