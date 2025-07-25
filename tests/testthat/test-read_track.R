test_that("read_track correctly routes to read_gpx_track for GPX files", {
  example_gpx_path <- system.file("extdata", "icc_intro_ride.gpx", package = "gpxtoolbox")
  
  # Test that read_track works for GPX files
  track_data_via_read_track <- read_track(example_gpx_path)
  track_data_via_read_gpx <- read_gpx_track(example_gpx_path)
  
  expect_s3_class(track_data_via_read_track, "data.frame")
  expect_true(all(c("lon", "lat", "ele", "time") %in% colnames(track_data_via_read_track)))
  expect_gt(nrow(track_data_via_read_track), 0)
  
  # Should produce the same result as direct GPX reading
  expect_equal(track_data_via_read_track, track_data_via_read_gpx)
})

test_that("read_track rejects unsupported file formats", {
  # Create a temporary file with unsupported extension
  temp_file <- tempfile(fileext = ".txt")
  writeLines("dummy content", temp_file)
  
  expect_error(read_track(temp_file), "Unsupported file format")
  
  # Clean up
  unlink(temp_file)
})

test_that("read_track handles missing files gracefully", {
  expect_error(read_track("nonexistent_file.gpx"), "File not found")
})

test_that("read_fit_track gives informative error when FITfileR is not available", {
  # Create a dummy FIT file
  temp_fit_file <- tempfile(fileext = ".fit")
  writeLines("dummy FIT content", temp_fit_file)
  
  # Mock the requireNamespace function to return FALSE
  with_mocked_bindings(
    requireNamespace = function(...) FALSE,
    {
      expect_error(read_fit_track(temp_fit_file), "FITfileR package is required")
    }
  )
  
  # Clean up
  unlink(temp_fit_file)
})