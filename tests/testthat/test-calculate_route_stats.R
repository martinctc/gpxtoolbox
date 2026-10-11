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

test_that("calculate_route_stats returns NA elevation stats when elevation is missing", {
  test_data <- data.frame(
    lat = c(51.549, 51.550, 51.551, 51.552),
    lon = c(-0.105, -0.106, -0.107, -0.108),
    ele = c(NA_real_, NA_real_, NA_real_, NA_real_),
    time = as.POSIXct(paste("2022-05-03 09:21:2", 7:10, sep = ""), tz = "UTC")
  )

  test_data <- calculate_distance(test_data)
  test_data <- calculate_elevation_stats(test_data)
  stats <- calculate_route_stats(test_data)

  expect_true(is.na(stats$max_elevation_m))
  expect_true(is.na(stats$min_elevation_m))
  expect_equal(stats$total_elevation_gain_m, 0)
  expect_equal(stats$total_elevation_loss_m, 0)
})
