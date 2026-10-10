test_that("calculate_elevation_stats calculates elevation stats correctly", {
  example_gpx_path <- system.file("extdata", "icc_intro_ride.gpx", package = "gpxtoolbox")
  track_data <- read_gpx_track(example_gpx_path)
  track_data <- calculate_elevation_stats(track_data)
  
  expect_true(all(c("ele_gain", "ele_loss", "cumulative_ele_gain", "cumulative_ele_loss") %in% colnames(track_data)))
  expect_gt(max(track_data$cumulative_ele_gain, na.rm = TRUE), 0)
})

test_that("calculate_elevation_stats handles duplicate coordinates correctly", {
  # Test data with duplicate coordinates and GPS noise
  test_data <- data.frame(
    lat = c(51.549, 51.550, 51.550, 51.551, 51.551, 51.552), # Duplicates at positions 2-3 and 4-5
    lon = c(-0.105, -0.106, -0.106, -0.107, -0.107, -0.108), # Duplicates at positions 2-3 and 4-5
    ele = c(100, 101, 102, 99, 101, 105), # GPS noise between duplicates
    time = as.POSIXct(paste("2022-05-03 09:21:2", 7:12, sep=""), tz = "UTC")
  )
  
  # Calculate using old method for comparison
  ele_diff_old <- c(0, diff(test_data$ele))
  ele_gain_old_total <- sum(ifelse(ele_diff_old > 0, ele_diff_old, 0))
  
  # Calculate using new method
  result <- calculate_elevation_stats(test_data)
  
  # New method should give same or lower elevation gain due to duplicate filtering
  expect_lte(max(result$cumulative_ele_gain), ele_gain_old_total)
  
  # Duplicate points should have 0 elevation gain/loss
  duplicate_coords <- duplicated(test_data[, c("lat", "lon")])
  expect_true(all(result$ele_gain[duplicate_coords] == 0))
  expect_true(all(result$ele_loss[duplicate_coords] == 0))
  
  # Cumulative values should be preserved for duplicate points
  if (any(duplicate_coords)) {
    for (i in which(duplicate_coords)) {
      expect_equal(result$cumulative_ele_gain[i], result$cumulative_ele_gain[i-1])
      expect_equal(result$cumulative_ele_loss[i], result$cumulative_ele_loss[i-1])
    }
  }
})
