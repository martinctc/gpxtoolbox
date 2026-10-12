# Read FIT file and extract track points

This function reads a FIT file and extracts the track points, including
latitude, longitude, elevation, and time.

## Usage

``` r
read_fit_track(fit_path)
```

## Arguments

- fit_path:

  string. Path to the FIT file.

## Value

A data frame containing track points with the following columns:

- lon - longitude in decimal degrees

- lat - latitude in decimal degrees

- ele - elevation in meters

- time - timestamp in POSIXct format (UTC)

## Details

The function uses FITfileR package to read FIT files. It extracts the
records data which contains the sequential points that make up a GPS
track. Time values are converted to POSIXct objects in UTC timezone. FIT
files store positions as integers in semicircles; if the values are not
already in decimal degrees (as returned by FITfileR \>= 0.1.0), they are
converted to degrees.

## Examples

``` r
if (FALSE) { # \dontrun{
# Read track points from a FIT file
track_data <- read_fit_track("path/to/file.fit")

# View the first few points
head(track_data)
} # }
```
