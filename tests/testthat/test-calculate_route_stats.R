test_that("calculate_route_stats calculates route stats correctly", {
  example_gpx_path <- system.file("extdata", "icc_intro_ride.gpx", package = "gpxtoolbox")
  track_data <- read_gpx_track(example_gpx_path)
  track_data <- calculate_distance(track_data)
  track_data <- calculate_elevation_stats(track_data)
  stats <- calculate_route_stats(track_data)
  
  expect_named(
    stats,
    c(
      "total_distance_km",
      "total_elevation_gain_m",
      "total_elevation_loss_m",
      "max_elevation_m",
      "min_elevation_m"
    ),
    ignore.order = TRUE
  )
  expect_gt(stats$total_distance_km, 0)
  expect_gt(stats$total_elevation_gain_m, 0)
})
