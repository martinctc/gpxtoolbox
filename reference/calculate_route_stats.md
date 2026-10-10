# Calculate route statistics

Calculates basic statistics from GPS track data, including distance,
elevation, and time metrics.

## Usage

``` r
calculate_route_stats(track_points)
```

## Arguments

- track_points:

  A data frame containing track points with the following required
  columns:

  - cumulative_distance - distance in kilometers

  - ele - elevation in meters

  - ele_gain - elevation gain in meters

  - ele_loss - elevation loss in meters

  - time - timestamps in POSIXct format (optional, for time-based
    calculations)

  - location - (optional) geographic location of points (e.g., "City,
    Country")

## Value

A list containing the following route statistics:

- total_distance_km - total distance in kilometers

- total_elevation_gain_m - cumulative elevation gain in meters

- total_elevation_loss_m - cumulative elevation loss in meters

- max_elevation_m - maximum elevation in meters

- min_elevation_m - minimum elevation in meters

- total_time_hours - total activity time in hours (if time data
  available)

- avg_speed - average speed in km/h (if time data available)

- start_point - (optional) location of the starting point

- end_point - (optional) location of the ending point

- p25_point - (optional) location at 25% of the route

- p50_point - (optional) location at 50% of the route

- p75_point - (optional) location at 75% of the route

## Details

This function processes track point data to extract key statistics about
a GPS route. Time-based statistics are only calculated if the input data
contains valid timestamps. All numeric values are rounded to 2 decimal
places for readability.

## Examples

``` r
if (FALSE) { # \dontrun{
# First read a GPX file
track_data <- read_gpx_track("path/to/activity.gpx")

# Calculate distance and elevation changes
track_data <- calculate_distance(track_data)

# Calculate route statistics
stats <- calculate_route_stats(track_data)

# Print the statistics
print(stats)
} # }
```
