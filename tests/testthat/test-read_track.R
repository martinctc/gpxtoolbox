# Locate a sample FIT file bundled with the FITfileR package, skipping the
# calling test when FITfileR (or the specific sample file) is unavailable.
# Using FITfileR's own samples avoids committing binary fixtures to this repo.
fit_sample <- function(...) {
  skip_if_not_installed("FITfileR")
  path <- system.file("extdata", ..., package = "FITfileR")
  if (!nzchar(path) || !file.exists(path)) {
    skip("FITfileR sample FIT file not available")
  }
  path
}

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
  fit_path <- fit_sample("Activities", "garmin-edge530-ride.fit")
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
  fit_path <- fit_sample("Activities", "garmin-edge530-ride.fit")
  
  track_data_via_read_track <- read_track(fit_path)
  track_data_via_read_fit <- read_fit_track(fit_path)
  
  expect_equal(track_data_via_read_track, track_data_via_read_fit)
})

test_that("read_fit_track keeps valid coordinates in files with invalid sentinels", {
  # garmin-fenix6-swim.fit mixes valid points near 46.8N with position_lat
  # sentinel values of 180. These outliers must not trigger a spurious
  # semicircle conversion that would collapse the whole track toward zero.
  fit_path <- fit_sample("Activities", "garmin-fenix6-swim.fit")
  track_data <- read_fit_track(fit_path)
  
  expect_gt(nrow(track_data), 0)
  expect_true(all(abs(track_data$lat) <= 90))
  expect_true(all(abs(track_data$lon) <= 180))
  expect_true(all(track_data$lat > 40 & track_data$lat < 50))
  expect_true(all(track_data$lon > 5 & track_data$lon < 15))
})

test_that("read_fit_track handles FIT files without altitude data", {
  # garmin-fenix6-swim.fit has no altitude field; elevation should be NA and the
  # downstream elevation statistics should degrade gracefully (not error or Inf).
  fit_path <- fit_sample("Activities", "garmin-fenix6-swim.fit")
  track_data <- read_fit_track(fit_path)
  
  expect_true("ele" %in% colnames(track_data))
  expect_true(all(is.na(track_data$ele)))
  
  track_data <- calculate_distance(track_data)
  track_data <- calculate_elevation_stats(track_data)
  stats <- calculate_route_stats(track_data)
  
  expect_true(is.na(stats$max_elevation_m))
  expect_true(is.na(stats$min_elevation_m))
  expect_equal(stats$total_elevation_gain_m, 0)
  expect_equal(stats$total_elevation_loss_m, 0)
})

test_that("read_fit_track errors informatively on files without GPS fields", {
  fit_path <- fit_sample("Activities", "garmin-fenix6-turbo.fit")
  expect_error(read_fit_track(fit_path), "Missing required GPS fields")
})

test_that("read_fit_track errors informatively on files without record data", {
  fit_path <- fit_sample("FIT_SDK", "MonitoringFile.fit")
  expect_error(read_fit_track(fit_path), "No record data found")
})
