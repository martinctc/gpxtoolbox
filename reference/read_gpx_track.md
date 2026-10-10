# Read GPX file and extract track points

This function reads a GPX file and extracts the track points, including
latitude, longitude, elevation, and time.

## Usage

``` r
read_gpx_track(gpx_path)
```

## Arguments

- gpx_path:

  string. Path to the GPX file.

## Value

A data frame containing track points with the following columns:

- lon - longitude in decimal degrees

- lat - latitude in decimal degrees

- ele - elevation in meters

- time - timestamp in POSIXct format (UTC)

## Details

The function uses sf package to read GPX files. It specifically extracts
the track_points layer, which contains the sequential points that make
up a GPS track. Time values are converted to POSIXct objects in UTC
timezone.

## Examples

``` r
# Use the example GPX file included in the package
example_gpx_path <- system.file("extdata", "icc_intro_ride.gpx", package = "gpxtoolbox")

# Read track points from a GPX file
track_data <- read_gpx_track(example_gpx_path)

# View the first few points
head(track_data)
#> # A tibble: 6 × 4
#>      lon   lat   ele time  
#>    <dbl> <dbl> <dbl> <dttm>
#> 1 -0.105  51.5  42.8 NA    
#> 2 -0.105  51.5  42.7 NA    
#> 3 -0.105  51.5  42.1 NA    
#> 4 -0.105  51.5  41.5 NA    
#> 5 -0.105  51.5  41.4 NA    
#> 6 -0.106  51.5  40.7 NA    
```
