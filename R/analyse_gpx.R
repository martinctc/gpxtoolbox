#' @title 
#' Analyse GPX File
#' 
#' @description
#' Processes a GPX file to extract route information, calculate metrics such as
#' distance and elevation, and provide summary statistics or visualization.
#'
#' @param gpx_path Character string specifying the path to the GPX file or a web link
#'   to a route on Strava or RideWithGPS.
#' @param return Character string indicating the type of output to return.
#'   Options are:
#'   \itemize{
#'     \item "stats" (default): Returns a list of summary statistics
#'     \item "plot": Generates a plot of the route and elevation profile. Supports
#'       additional modes via the `plot_route()` function (e.g., "ggplot" or "leaflet").
#'     \item "data": Returns the processed track points data
#'   }
#' @param plot_mode Character string. The plotting mode to use when `return = "plot"`. 
#'   Options are:
#'   \itemize{
#'     \item "ggplot" (default): Uses ggplot2 for visualisation.
#'     \item "leaflet": Uses the leaflet package to create an interactive map.
#'   }
#' @return Depending on the \code{return} parameter:
#'   \itemize{
#'     \item If "stats": A named list of route statistics
#'     \item If "plot": Generates a plot
#'     \item If "data": A data frame of processed track points with calculated
#'     metrics
#'   }
#' 
#' @details
#' If a web link is provided for \code{gpx_path}, the function will automatically
#' construct the appropriate GPX export URL, download the file to a temporary location,
#' and process it.
#' 
#' @examples
#' \dontrun{
#' # Get route statistics from a local GPX file
#' stats <- analyse_gpx("path/to/file.gpx")
#'
#' # Get route statistics from a Strava link
#' stats <- analyse_gpx("https://www.strava.com/routes/3193200014155699162")
#'
#' # Get route statistics from a RideWithGPS link
#' stats <- analyse_gpx("https://ridewithgps.com/routes/39294504")
#' }
#' 
#' # Use the example GPX file included in the package
#' example_gpx_path <- system.file("extdata", "icc_intro_ride.gpx", package = "gpxtoolbox")
#'
#' # Analyse the example GPX file
#' stats <- analyse_gpx(example_gpx_path)
#' print(stats)
#'
#' # Generate a plot of the example GPX file
#' analyse_gpx(example_gpx_path, return = "plot")
#'
#' @importFrom httr GET write_disk status_code
#' @export
analyse_gpx <- function(gpx_path, return = "stats", plot_mode = "ggplot") {
  # Helper function to download GPX file from a web link
  download_gpx <- function(link) {
    if (grepl("strava.com/routes", link)) {
      gpx_url <- paste0(link, "/export_gpx")
    } else if (grepl("ridewithgps.com/routes", link)) {
      # Remove trailing backslash from `link`
      link <- sub("/$", "", link)
      gpx_url <- paste0(link, ".gpx?sub_format=track")
    } else {
      stop("Unsupported link format. Only Strava and RideWithGPS links are supported.")
    }
    temp_file <- tempfile(fileext = ".gpx")
    response <- httr::GET(gpx_url, httr::write_disk(temp_file, overwrite = TRUE))
    if (httr::status_code(response) != 200) {
      stop("Failed to download GPX file. Please check the URL or your internet connection.")
    }
    return(temp_file)
  }
  
  # Check if gpx_path is a web link
  if (grepl("^https?://", gpx_path)) {
    cat("Downloading GPX file from:", gpx_path, "\n")
    gpx_path <- download_gpx(gpx_path)
  }
  
  # Validate the GPX file
  if (!file.exists(gpx_path) || file.size(gpx_path) == 0) {
    stop("The GPX file is missing or empty. Please check the file or URL.")
  }
  
  # Read GPX data
  cat("Reading GPX file:", gpx_path, "\n")
  track_points <- tryCatch(
    read_gpx_track(gpx_path),
    error = function(e) {
      stop("Failed to read the GPX file. The file may be corrupt or in an unsupported format.")
    }
  )
  
  # Calculate metrics
  track_points <- calculate_distance(track_points)
  track_points <- calculate_elevation_stats(track_points)
  
  # Identify geographic locations
  track_points <- identify_geo(track_points)

  # Calculate and print summary statistics
  stats <- calculate_route_stats(track_points)

  if (return == "plot") {
    # Plot route with the specified mode
    plot_route(track_points, mode = plot_mode)
  } else if (return == "stats") {
    # Return statistics
    return(stats)
  } else if (return == "data") {
    # Return data
    return(track_points)
  }
}