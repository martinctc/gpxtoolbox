# Calculate elevation statistics from GPS track points

Calculates elevation gain and loss between consecutive GPS track points
and adds these metrics to the track points data frame.

## Usage

``` r
calculate_elevation_stats(track_points)
```

## Arguments

- track_points:

  A data frame containing track points with at least the following
  column:

  - ele - elevation in meters

## Value

The input data frame with the following additional columns:

- ele_gain - elevation gain in meters (0 for flat or downhill segments)

- ele_loss - elevation loss in meters (0 for flat or uphill segments)

- cumulative_ele_gain - cumulative elevation gain in meters

- cumulative_ele_loss - cumulative elevation loss in meters

## Details

This function calculates the elevation difference between consecutive
points. Positive changes are recorded as elevation gain, while negative
changes are recorded as elevation loss. The function also calculates
cumulative metrics to track total elevation change over the entire
route.

## Examples

``` r
if (FALSE) { # \dontrun{
# First read a GPX file
track_data <- read_gpx_track("path/to/activity.gpx")

# Calculate elevation statistics
track_data <- calculate_elevation_stats(track_data)

# View the elevation data
head(track_data[, c("ele", "ele_gain", "ele_loss", "cumulative_ele_gain")])
} # }
```
