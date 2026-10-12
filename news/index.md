# Changelog

## gpxtoolbox (development version)

### New features

- Added
  [`read_track()`](https://martinctc.github.io/gpxtoolbox/reference/read_track.md)
  as a unified interface that dispatches to
  [`read_gpx_track()`](https://martinctc.github.io/gpxtoolbox/reference/read_gpx_track.md)
  or
  [`read_fit_track()`](https://martinctc.github.io/gpxtoolbox/reference/read_fit_track.md)
  based on file extension.
- Added
  [`read_fit_track()`](https://martinctc.github.io/gpxtoolbox/reference/read_fit_track.md)
  for reading GPS tracks from Garmin FIT files (requires the FITfileR
  package, installed from GitHub).
- Added
  [`analyse_track()`](https://martinctc.github.io/gpxtoolbox/reference/analyse_track.md),
  a file-format-agnostic version of
  [`analyse_gpx()`](https://martinctc.github.io/gpxtoolbox/reference/analyse_gpx.md).
  [`analyse_gpx()`](https://martinctc.github.io/gpxtoolbox/reference/analyse_gpx.md)
  now delegates to it.
- Added
  [`identify_geo()`](https://martinctc.github.io/gpxtoolbox/reference/identify_geo.md)
  for reverse geocoding key track points.
- Added leaflet markers to
  [`plot_route()`](https://martinctc.github.io/gpxtoolbox/reference/plot_route.md)
  map visualisations.
- Added unit tests and a test-coverage CI workflow (covr + Codecov).

### Bug fixes

- Elevation gain no longer over-estimates by double-counting trackpoints
  with identical coordinates.
- [`calculate_elevation_stats()`](https://martinctc.github.io/gpxtoolbox/reference/calculate_elevation_stats.md)
  handles tracks without elevation data (`NA` stats instead of
  `-Inf`/`Inf`) and 0-row input.
- [`calculate_route_stats()`](https://martinctc.github.io/gpxtoolbox/reference/calculate_route_stats.md)
  returns `NA_real_` for average speed when the track duration is zero,
  and guards small-track index calculations.
- [`read_fit_track()`](https://martinctc.github.io/gpxtoolbox/reference/read_fit_track.md)
  supports current FITfileR releases (S4 `FitFile` object, chunked
  record messages), avoids double-converting coordinates from
  semicircles, discards invalid out-of-range position sentinels, and
  accepts both POSIXct and numeric timestamps.
- [`analyse_track()`](https://martinctc.github.io/gpxtoolbox/reference/analyse_track.md)
  cleans up temporary files downloaded from URLs even when an error
  occurs.
- [`plot_route()`](https://martinctc.github.io/gpxtoolbox/reference/plot_route.md)
  no longer errors when elevation data is missing from the leaflet
  popups.
