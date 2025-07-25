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
  # Call the generic analyse_track function for backward compatibility
  # This maintains the same interface while utilizing the new unified functionality
  analyse_track(gpx_path, return = return, plot_mode = plot_mode)
}