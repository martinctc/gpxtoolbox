# Calculate distances between GPS track points

Calculates the distance between consecutive GPS track points and adds
both individual segment distances and cumulative distance to the track
points data frame.

## Usage

``` r
calculate_distance(track_points)
```

## Arguments

- track_points:

  A data frame containing track points with at least the following
  columns:

  - lon - longitude in decimal degrees

  - lat - latitude in decimal degrees

## Value

The input data frame with the following additional columns:

- distance - distance to previous point in meters (0 for the first
  point)

- cumulative_distance - cumulative distance traveled in kilometers

## Details

This function uses the Haversine formula to calculate the great-circle
distance between consecutive GPS points, accounting for the curvature of
the Earth. The first point has a distance of 0, and each subsequent
point's distance is measured from the previous point.

## Examples

``` r
if (FALSE) { # \dontrun{
# First read a GPX file
track_data <- read_gpx_track("path/to/activity.gpx")

# Calculate distances
track_data <- calculate_distance(track_data)

# View the distance data
head(track_data[, c("lon", "lat", "distance", "cumulative_distance")])
} # }
```
