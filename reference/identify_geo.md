# Identify geographic location from GPS coordinates

Adds geographic location information (e.g., city, country) to GPS track
points based on latitude and longitude using the OpenStreetMap Nominatim
API.

## Usage

``` r
identify_geo(track_points, all = FALSE)
```

## Arguments

- track_points:

  A data frame containing track points with at least the following
  columns:

  - lon - longitude in decimal degrees

  - lat - latitude in decimal degrees

- all:

  Logical. If `TRUE`, identifies the location for all track points. If
  `FALSE` (default), identifies the location for the start, end, and
  25%, 50%, and 75% points of the route. Setting `all = FALSE` helps
  reduce API usage.

## Value

The input data frame with an additional column for geographic
information:

- location - a string describing the geographic location (e.g., "City,
  Country")

## Details

This function uses the OpenStreetMap Nominatim API for reverse
geocoding. Ensure you have an active internet connection as the function
queries an external API. Be mindful of the API usage policy.

## Examples

``` r
if (FALSE) { # \dontrun{
# First read a GPX file
track_data <- read_gpx_track("path/to/activity.gpx")

# Identify geographic locations for start, end, and key points
track_data <- identify_geo(track_data)

# Identify geographic locations for all points
track_data <- identify_geo(track_data, all = TRUE)

# View the location data
head(track_data[, c("lon", "lat", "location")])
} # }
```
