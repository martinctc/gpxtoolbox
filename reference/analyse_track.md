# Analyse Track File

Processes a track file (GPX or FIT) to extract route information,
calculate metrics such as distance and elevation, and provide summary
statistics or visualization.

## Usage

``` r
analyse_track(file_path, return = "stats", plot_mode = "ggplot")
```

## Arguments

- file_path:

  Character string specifying the path to the track file (.gpx or .fit)
  or a web link to a route on Strava or RideWithGPS (GPX only).

- return:

  Character string indicating the type of output to return. Options are:

  - "stats" (default): Returns a list of summary statistics

  - "plot": Generates a plot of the route and elevation profile.
    Supports additional modes via the
    [`plot_route()`](https://martinctc.github.io/gpxtoolbox/reference/plot_route.md)
    function (e.g., "ggplot" or "leaflet").

  - "data": Returns the processed track points data

- plot_mode:

  Character string. The plotting mode to use when `return = "plot"`.
  Options are:

  - "ggplot" (default): Uses ggplot2 for visualisation.

  - "leaflet": Uses the leaflet package to create an interactive map.

## Value

Depending on the `return` parameter:

- If "stats": A named list of route statistics

- If "plot": Generates a plot

- If "data": A data frame of processed track points with calculated
  metrics

## Details

The function automatically detects the file format based on the file
extension:

- .gpx files are processed using read_gpx_track()

- .fit files are processed using read_fit_track() (requires FITfileR
  package)

If a web link is provided for `file_path`, the function will
automatically construct the appropriate GPX export URL, download the
file to a temporary location, and process it. Note: web link support is
only available for GPX files.

## Examples

``` r
if (FALSE) { # \dontrun{
# Get route statistics from a local GPX file
stats <- analyse_track("path/to/file.gpx")

# Get route statistics from a local FIT file
stats <- analyse_track("path/to/file.fit")

# Get route statistics from a Strava link (GPX only)
stats <- analyse_track("https://www.strava.com/routes/3193200014155699162")

# Get route statistics from a RideWithGPS link (GPX only)
stats <- analyse_track("https://ridewithgps.com/routes/39294504")
} # }

# Use the example GPX file included in the package
example_gpx_path <- system.file("extdata", "icc_intro_ride.gpx", package = "gpxtoolbox")

# Analyse the example track file
stats <- analyse_track(example_gpx_path)
#> Reading GPX file: /home/runner/work/_temp/Library/gpxtoolbox/extdata/icc_intro_ride.gpx
print(stats)
#> $total_distance_km
#> [1] 42.81
#> 
#> $total_elevation_gain_m
#> [1] 621.9
#> 
#> $total_elevation_loss_m
#> [1] 556.3
#> 
#> $max_elevation_m
#> [1] 143
#> 
#> $min_elevation_m
#> [1] 29.9
#> 
#> $start_point
#> [1] "43, Fieldway Crescent, Highbury, London Borough of Islington, Greater London, England, N5 1PU, United Kingdom"
#> 
#> $end_point
#> [1] "Highgate Shoe Care, 367, Archway Road, Muswell Hill, London Borough of Haringey, Greater London, England, N6 5FJ, United Kingdom"
#> 
#> $p25_point
#> [1] "Highwood Hill, Mill Hill, London Borough of Barnet, Greater London, England, NW7 4HN, United Kingdom"
#> 
#> $p50_point
#> [1] "36, Camlet Way, Hadley Wood, London Borough of Enfield, Greater London, England, EN4 0LJ, United Kingdom"
#> 
#> $p75_point
#> [1] "Lincoln Road, Colney Hatch, London Borough of Barnet, Greater London, England, N2 9EL, United Kingdom"
#> 

# Generate a plot of the example track file
analyse_track(example_gpx_path, return = "plot")
#> Reading GPX file: /home/runner/work/_temp/Library/gpxtoolbox/extdata/icc_intro_ride.gpx


```
