# gpxtoolbox

Tools for analysing and visualising GPX and FIT files.

## Overview

`gpxtoolbox` is an R package designed for processing, analysing, and
visualising GPS track data from GPX and FIT files. It provides tools for
calculating route metrics such as distance, elevation gain/loss, and
speed, as well as visualisation capabilities for elevation profiles and
route maps. This package is ideal for outdoor enthusiasts, athletes, and
researchers working with GPS tracking data.

### Supported File Formats

- **GPX files**: Standard GPS data format used by many fitness apps and
  GPS devices
- **FIT files**: Garmin’s proprietary format used by Garmin devices and
  many other fitness devices

One of the more powerful features from this package is
[`gen_description()`](https://martinctc.github.io/gpxtoolbox/reference/gen_description.md),
which uses LLMs to generate a title and description for a given GPX
file. It uses the information extracted from a GPX file, including
distance, elevation, and geography to simulate a title and description.
{ellmer} is used to interface with LLMs, providing access from a wide
range of options including Azure OpenAI, Anthropic Claude, and Google
Gemini.

An example of the output would be:

    **Title:** Tonbridge Castle Loop - 112.5 km, 903 m Elevation Gain

    **Description:**
    Experience an exhilarating adventure on this scenic loop that starts and ends at the historic Tonbridge Castle. Covering a distance of 112.52 km with a total elevation gain of 902.97 m, this route showcases the beautiful Kent countryside.

    At the 25% mark, you'll pass Pearsons Green Road in Paddock Wood, where the lush greenery sets the perfect backdrop for your journey. Midway, at Bitchet Green, soak in picturesque views that highlight the charm of Seal and Sevenoaks. As you approach the 75% point, enjoy the sights at Pootings Oast in Crockham Hill, an idyllic area known for its rolling hills and quaint charm.

    This route's elevation variations, featuring a maximum rise up to 242 m, ensure that both challenge and reward await every cyclist, making it ideal for those seeking a blend of stunning landscapes and a fulfilling ride. Whether you're out for a leisure ride or training for a longer event, this loop promises to deliver on both adventure and scenic beauty.

## Installation

You can install the development version of `gpxtoolbox` from GitHub:

``` r

# Install devtools if not already installed
install.packages("devtools")

# Install gpxtoolbox
devtools::install_github("martinctc/gpxtoolbox")
```

### FIT File Support

FIT support is optional, so `FITfileR` is not installed automatically
with `gpxtoolbox`. To use FIT files, install it separately from GitHub —
it is not on CRAN, which is why it isn’t a standard dependency:

``` r

# Install FITfileR for FIT file support
remotes::install_github("grimbough/FITfileR")
```

## Key Features

- **Read GPX and FIT Files**: Extract track points, including latitude,
  longitude, elevation, and time from both GPX and FIT formats.
- **Calculate Metrics**: Compute distances, elevation gain/loss, and
  cumulative metrics.
- **Visualise Routes**: Create elevation profiles and route maps using
  `ggplot2`.
- **Summarise Statistics**: Generate summary statistics for distance,
  elevation, and time.
- **Generate Titles and Descriptions from track files**: Use LLMs to
  generate titles and descriptions for your GPX and FIT files.

## Usage

### Working with GPX and FIT Files

The package now supports both GPX and FIT files with unified functions
that automatically detect the file format:

``` r

library(gpxtoolbox)

# Works with GPX files
example_gpx_path <- system.file("extdata", "icc_intro_ride.gpx", package = "gpxtoolbox")
track_data <- read_track(example_gpx_path)

# Also works with FIT files (requires FITfileR package)
# track_data <- read_track("path/to/your_activity.fit")

# Get complete analysis
stats <- analyse_track(example_gpx_path)
print(stats)

# Generate plots
analyse_track(example_gpx_path, return = "plot")
```

### Example Workflow

``` r

# Load the package
library(gpxtoolbox)

# Use the example GPX file included in the package
example_gpx_path <- system.file("extdata", "icc_intro_ride.gpx", package = "gpxtoolbox")

# Read the track file (works with both .gpx and .fit files)
track_data <- read_track(example_gpx_path)

# Calculate distances and elevation statistics
track_data <- calculate_distance(track_data)
track_data <- calculate_elevation_stats(track_data)

# Generate route statistics
stats <- calculate_route_stats(track_data)
print(stats)

# Visualise the route
plot_route(track_data)
```

### Analyse a Track File in One Step

``` r

# Analyse any track file (GPX or FIT) and get summary statistics
example_gpx_path <- system.file("extdata", "icc_intro_ride.gpx", package = "gpxtoolbox")

# New generic function that works with both formats
stats <- analyse_track(example_gpx_path, return = "stats")

# Backward compatible - original function still works
stats <- analyse_gpx(example_gpx_path, return = "stats")

# Generate a plot of the route
analyse_gpx(example_gpx_path, return = "plot")

# Get processed track points data
track_data <- analyse_gpx(example_gpx_path, return = "data")
```

## Key Functions

| Function | Input | Output |
|----|----|----|
| [`read_track()`](https://martinctc.github.io/gpxtoolbox/reference/read_track.md) | Path to a GPX or FIT file | Data frame of track points (latitude, longitude, elevation, time) |
| [`read_gpx_track()`](https://martinctc.github.io/gpxtoolbox/reference/read_gpx_track.md) | Path to a GPX file | Data frame of track points (latitude, longitude, elevation, time) |
| [`read_fit_track()`](https://martinctc.github.io/gpxtoolbox/reference/read_fit_track.md) | Path to a FIT file (requires FITfileR) | Data frame of track points (latitude, longitude, elevation, time) |
| [`calculate_distance()`](https://martinctc.github.io/gpxtoolbox/reference/calculate_distance.md) | Data frame of track points | Data frame with added column for cumulative distance |
| [`calculate_elevation_stats()`](https://martinctc.github.io/gpxtoolbox/reference/calculate_elevation_stats.md) | Data frame of track points | Data frame with added columns for elevation gain/loss |
| [`calculate_route_stats()`](https://martinctc.github.io/gpxtoolbox/reference/calculate_route_stats.md) | Data frame of track points | Named list of route statistics (e.g., total distance, elevation gain, start/end points) |
| [`plot_route()`](https://martinctc.github.io/gpxtoolbox/reference/plot_route.md) | Data frame of track points | Visualisation of the route (elevation profile and map) |
| [`analyse_track()`](https://martinctc.github.io/gpxtoolbox/reference/analyse_track.md) | Path to a GPX/FIT file or web link | Route statistics, visualisation, or processed track points (depending on `return` value) |
| [`analyse_gpx()`](https://martinctc.github.io/gpxtoolbox/reference/analyse_gpx.md) | Path to a GPX file or web link | Route statistics, visualisation, or processed track points (depending on `return` value) |
| [`identify_geo()`](https://martinctc.github.io/gpxtoolbox/reference/identify_geo.md) | Data frame of track points | Data frame with added location column (via Nominatim reverse geocoding) |
| [`gen_description()`](https://martinctc.github.io/gpxtoolbox/reference/gen_description.md) | Named list of route statistics, LLM platform, API key, and model | Title and description for the GPX route generated by an LLM |

### Functions Called by `analyse_track()`

- [`read_track()`](https://martinctc.github.io/gpxtoolbox/reference/read_track.md)
  (dispatches to
  [`read_gpx_track()`](https://martinctc.github.io/gpxtoolbox/reference/read_gpx_track.md)
  or
  [`read_fit_track()`](https://martinctc.github.io/gpxtoolbox/reference/read_fit_track.md))
- [`calculate_distance()`](https://martinctc.github.io/gpxtoolbox/reference/calculate_distance.md)
- [`calculate_elevation_stats()`](https://martinctc.github.io/gpxtoolbox/reference/calculate_elevation_stats.md)
- [`identify_geo()`](https://martinctc.github.io/gpxtoolbox/reference/identify_geo.md)
- [`calculate_route_stats()`](https://martinctc.github.io/gpxtoolbox/reference/calculate_route_stats.md)
- [`plot_route()`](https://martinctc.github.io/gpxtoolbox/reference/plot_route.md)
  (if `return = "plot"`)

### Updated Key Functions

- [`read_gpx_track()`](https://martinctc.github.io/gpxtoolbox/reference/read_gpx_track.md):
  Reads a GPX file and extracts track points.
- [`calculate_distance()`](https://martinctc.github.io/gpxtoolbox/reference/calculate_distance.md):
  Calculates distances between consecutive track points.
- [`calculate_elevation_stats()`](https://martinctc.github.io/gpxtoolbox/reference/calculate_elevation_stats.md):
  Computes elevation gain/loss and cumulative metrics.
- [`calculate_route_stats()`](https://martinctc.github.io/gpxtoolbox/reference/calculate_route_stats.md):
  Summarises route statistics such as total distance, elevation gain,
  and average speed.
- [`plot_route()`](https://martinctc.github.io/gpxtoolbox/reference/plot_route.md):
  Creates visualisations of the route, including an elevation profile
  and a route map.
- [`analyse_gpx()`](https://martinctc.github.io/gpxtoolbox/reference/analyse_gpx.md):
  A high-level function to process a GPX file and return statistics,
  plots, or processed data. Calls multiple helper functions internally.
- [`gen_description()`](https://martinctc.github.io/gpxtoolbox/reference/gen_description.md):
  Uses LLMs to generate a title and description for a GPX route based on
  its statistics.

## Dependencies

The package depends on the following R packages:

- `sf`: For reading GPX files.
- `dplyr`: For data manipulation.
- `geosphere`: For distance calculations.
- `ggplot2`: For creating visualisations.
- `ellmer`: For interfacing with LLMs.

## License

This package is licensed under the MIT License. See the
[LICENSE](https://martinctc.github.io/gpxtoolbox/LICENSE) file for
details.

## Contributing

Contributions are welcome! Feel free to open issues or submit pull
requests on the [GitHub
repository](https://github.com/martinctc/gpxtoolbox).

## Acknowledgements

Special thanks to the authors of the `sf`, `dplyr`, `geosphere`, and
`ggplot2` packages, which are integral to the functionality of
`gpxtoolbox`.
