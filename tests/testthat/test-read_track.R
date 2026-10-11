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
  skip_if(requireNamespace("FITfileR", quietly = TRUE), "FITfileR is installed; cannot test missing-dependency error")
  
  # Create a dummy FIT file
  temp_fit_file <- tempfile(fileext = ".fit")
  writeLines("dummy FIT content", temp_fit_file)
  
  # When FITfileR is not installed, read_fit_track should error with a clear message
  expect_error(read_fit_track(temp_fit_file), "FITfileR package is required")
  
  # Clean up
  unlink(temp_fit_file)
})

test_that("read_fit_track extracts track points from a real FIT file", {
  skip_if_not_installed("FITfileR")
  
  # Use a sample FIT file shipped with FITfileR so no binary fixture
  # needs to be committed to this repository
  fit_path <- system.file("extdata", "Activities", "garmin-edge530-ride.fit",
                          package = "FITfileR")
  skip_if(!nzchar(fit_path) || !file.exists(fit_path),
          "FITfileR sample FIT file not available")
  
  track_data <- read_fit_track(fit_path)
  
  expect_s3_class(track_data, "data.frame")
  expect_true(all(c("lon", "lat", "ele", "time") %in% colnames(track_data)))
  expect_gt(nrow(track_data), 0)
  
  # Coordinates must be valid decimal degrees, not raw semicircles
  # and not double-converted values collapsed toward zero
  expect_true(all(abs(track_data$lat) <= 90, na.rm = TRUE))
  expect_true(all(abs(track_data$lon) <= 180, na.rm = TRUE))
  expect_gt(max(abs(track_data$lat), na.rm = TRUE), 1)
  expect_false(any(is.na(track_data$lat)))
  expect_false(any(is.na(track_data$lon)))
  
  # Timestamps should be parsed as POSIXct
  expect_s3_class(track_data$time, "POSIXct")
  
  # Elevation should be present and plausible for this ride
  expect_false(any(is.na(track_data$ele)))
  expect_true(all(track_data$ele > -500 & track_data$ele < 10000))
})

test_that("read_track correctly routes to read_fit_track for FIT files", {
  skip_if_not_installed("FITfileR")
  
  fit_path <- system.file("extdata", "Activities", "garmin-edge530-ride.fit",
                          package = "FITfileR")
  skip_if(!nzchar(fit_path) || !file.exists(fit_path),
          "FITfileR sample FIT file not available")
  
  track_data_via_read_track <- read_track(fit_path)
  track_data_via_read_fit <- read_fit_track(fit_path)
  
  expect_equal(track_data_via_read_track, track_data_via_read_fit)
})
