test_that("identify_geo identifies geographic locations correctly", {
  example_gpx_path <- system.file("extdata", "icc_intro_ride.gpx", package = "gpxtoolbox")
  track_data <- read_gpx_track(example_gpx_path)
  track_data <- identify_geo(track_data, all = FALSE)
  indices <- unique(c(
    1L,
    floor(nrow(track_data) * 0.25),
    floor(nrow(track_data) * 0.5),
    floor(nrow(track_data) * 0.75),
    nrow(track_data)
  ))
  non_key_indices <- setdiff(seq_len(nrow(track_data)), indices)
  
  expect_true("location" %in% colnames(track_data))
  expect_equal(length(track_data$location), nrow(track_data))
  expect_true(all(is.na(track_data$location[non_key_indices])))
})
