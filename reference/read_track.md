# Read track file (GPX or FIT) and extract track points

This function automatically detects the file format and reads either a
GPX or FIT file, extracting the track points including latitude,
longitude, elevation, and time.

## Usage

``` r
read_track(file_path)
```

## Arguments

- file_path:

  string. Path to the track file (GPX or FIT).

## Value

A data frame containing track points with the following columns:

- lon - longitude in decimal degrees

- lat - latitude in decimal degrees

- ele - elevation in meters

- time - timestamp in POSIXct format (UTC)

## Details

The function automatically detects the file format based on the file
extension:

- .gpx files are processed using read_gpx_track()

- .fit files are processed using read_fit_track()

For FIT files, the FITfileR package is required.

## Examples

``` r
# Use the example GPX file included in the package
example_gpx_path <- system.file("extdata", "icc_intro_ride.gpx", package = "gpxtoolbox")

# Read track points from a GPX file
track_data <- read_track(example_gpx_path)

if (FALSE) { # \dontrun{
# Read track points from a FIT file
fit_track_data <- read_track("path/to/file.fit")
} # }

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
