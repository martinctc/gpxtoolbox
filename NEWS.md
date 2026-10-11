# gpxtoolbox (development version)

## New features

* Added `read_track()` as a unified interface that dispatches to
  `read_gpx_track()` or `read_fit_track()` based on file extension.
* Added `read_fit_track()` for reading GPS tracks from Garmin FIT files
  (requires the FITfileR package, installed from GitHub).
* Added `analyse_track()`, a file-format-agnostic version of `analyse_gpx()`.
  `analyse_gpx()` now delegates to it.
* Added `identify_geo()` for reverse geocoding key track points.
* Added leaflet markers to `plot_route()` map visualisations.
* Added unit tests and a test-coverage CI workflow (covr + Codecov).

## Bug fixes

* Elevation gain no longer over-estimates by double-counting trackpoints
  with identical coordinates.
* `calculate_elevation_stats()` handles tracks without elevation data
  (`NA` stats instead of `-Inf`/`Inf`) and 0-row input.
* `calculate_route_stats()` returns `NA_real_` for average speed when the
  track duration is zero, and guards small-track index calculations.
* `read_fit_track()` supports current FITfileR releases (S4 `FitFile`
  object, chunked record messages), avoids double-converting coordinates
  from semicircles, and accepts both POSIXct and numeric timestamps.
* `analyse_track()` cleans up temporary files downloaded from URLs even
  when an error occurs.
* `plot_route()` no longer errors when elevation data is missing from the
  leaflet popups.
