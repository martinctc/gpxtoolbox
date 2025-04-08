#' @title Read GPX file and extract track points
#' @description
#' This function reads a GPX file and extracts the track points, including latitude, longitude, elevation, and time.
#' 
#' @param gpx_path string. Path to the GPX file.
#'
#' @return A data frame containing track points with the following columns:
#' \itemize{
#'   \item lon - longitude in decimal degrees
#'   \item lat - latitude in decimal degrees
#'   \item ele - elevation in meters
#'   \item time - timestamp in POSIXct format (UTC)
#' }
#'
#' @details
#' The function uses sf package to read GPX files. It specifically extracts the track_points
#' layer, which contains the sequential points that make up a GPS track. Time values are
#' converted to POSIXct objects in UTC timezone.
#' 
#' @examples
#' \dontrun{
#' # Read track points from a GPX file
#' track_data <- read_gpx_track("path/to/activity.gpx")
#' 
#' # View the first few points
#' head(track_data)
#' }
#' 
#' @importFrom sf st_read
#' @importFrom sf st_coordinates
#' @importFrom dplyr tibble 
#'
#' @export
read_gpx_track <- function(gpx_path) {
  # Read the GPX file as spatial data
  gpx_data <- st_read(gpx_path, layer = "track_points", quiet = TRUE)
  
  # Extract relevant columns and convert to data frame
  track_points <- dplyr::tibble(
    lon = st_coordinates(gpx_data)[, "X"],
    lat = st_coordinates(gpx_data)[, "Y"],
    ele = gpx_data$ele,
    time = as.POSIXct(gpx_data$time, format = "%Y-%m-%dT%H:%M:%OSZ", tz = "UTC")
  )
  
  return(track_points)
}