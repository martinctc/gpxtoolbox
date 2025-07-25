test_that("plot_route function works with ggplot mode", {
  # Skip on CI or if ggplot2 is not available
  skip_if_not_installed("ggplot2")
  
  example_gpx_path <- system.file("extdata", "icc_intro_ride.gpx", package = "gpxtoolbox")
  
  # Read and process track data
  track_data <- read_gpx_track(example_gpx_path)
  track_data <- calculate_distance(track_data)
  
  # Test that plot_route doesn't error
  expect_no_error(plot_route(track_data, mode = "ggplot"))
})

test_that("plot_route function works with leaflet mode", {
  # Skip on CI or if leaflet is not available
  skip_if_not_installed("leaflet")
  
  example_gpx_path <- system.file("extdata", "icc_intro_ride.gpx", package = "gpxtoolbox")
  
  # Read and process track data
  track_data <- read_gpx_track(example_gpx_path)
  track_data <- calculate_distance(track_data)
  
  # Test that plot_route returns a leaflet object
  result <- plot_route(track_data, mode = "leaflet")
  expect_s3_class(result, "leaflet")
})