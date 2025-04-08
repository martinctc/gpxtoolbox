# gpxtoolbox

Tools for analysing and visualising GPX files.

## Overview

`gpxtoolbox` is an R package designed for processing, analysing, and visualising GPS track data from GPX files. It provides tools for calculating route metrics such as distance, elevation gain/loss, and speed, as well as visualisation capabilities for elevation profiles and route maps. This package is ideal for outdoor enthusiasts, athletes, and researchers working with GPS tracking data.

## Installation

You can install the development version of `gpxtoolbox` from GitHub:

```r
# Install devtools if not already installed
install.packages("devtools")

# Install gpxtoolbox
devtools::install_github("martinchan/gpxtoolbox")
```

## Key Features

- **Read GPX Files**: Extract track points, including latitude, longitude, elevation, and time.
- **Calculate Metrics**: Compute distances, elevation gain/loss, and cumulative metrics.
- **Visualise Routes**: Create elevation profiles and route maps using `ggplot2`.
- **Summarise Statistics**: Generate summary statistics for distance, elevation, and time.

## Usage

### Example Workflow

```r
# Load the package
library(gpxtoolbox)

# Use the example GPX file included in the package
example_gpx_path <- system.file("extdata", "icc_intro_ride.gpx", package = "gpxtoolbox")

# Read the GPX file
track_data <- read_gpx_track(example_gpx_path)

# Calculate distances and elevation statistics
track_data <- calculate_distance(track_data)
track_data <- calculate_elevation_stats(track_data)

# Generate route statistics
stats <- calculate_route_stats(track_data)
print(stats)

# Visualise the route
plot_route(track_data)
```

### Analyse a GPX File in One Step

```r
# Analyse the example GPX file and get summary statistics
example_gpx_path <- system.file("extdata", "icc_intro_ride.gpx", package = "gpxtoolbox")
stats <- analyse_gpx(example_gpx_path, return = "stats")

# Generate a plot of the route
analyse_gpx(example_gpx_path, return = "plot")

# Get processed track points data
track_data <- analyse_gpx(example_gpx_path, return = "data")
```

## Key Functions

- `read_gpx_track()`: Reads a GPX file and extracts track points.
- `calculate_distance()`: Calculates distances between consecutive track points.
- `calculate_elevation_stats()`: Computes elevation gain/loss and cumulative metrics.
- `calculate_route_stats()`: Summarises route statistics such as total distance, elevation gain, and average speed.
- `plot_route()`: Creates visualisations of the route, including an elevation profile and a route map.
- `analyse_gpx()`: A high-level function to process a GPX file and return statistics, plots, or processed data.

## Dependencies

The package depends on the following R packages:
- `sf`: For reading GPX files.
- `dplyr`: For data manipulation.
- `geosphere`: For distance calculations.
- `ggplot2`: For creating visualisations.

## License

This package is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests on the [GitHub repository](https://github.com/martinchan/gpxtoolbox).

## Acknowledgements

Special thanks to the authors of the `sf`, `dplyr`, `geosphere`, and `ggplot2` packages, which are integral to the functionality of `gpxtoolbox`.
