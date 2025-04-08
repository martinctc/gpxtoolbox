#' @title 
#' Analyse GPX File
#' 
#' @description
#' Processes a GPX file to extract route information, calculate metrics such as
#' distance and elevation, and provide summary statistics or visualization.
#'
#' @param gpx_path Character string specifying the path to the GPX file.
#' @param return Character string indicating the type of output to return.
#'   Options are:
#'   \itemize{
#'     \item "stats" (default): Returns a list of summary statistics
#'     \item "plot": Generates a plot of the route and elevation profile
#'     \item "data": Returns the processed track points data
#'   }
#' 
#' @return Depending on the \code{return} parameter:
#'   \itemize{
#'     \item If "stats": A named list of route statistics
#'     \item If "plot": Generates a plot
#'     \item If "data": A data frame of processed track points with calculated
#'     metrics
#'   }
#' 
#' @examples
#' \dontrun{
#' # Get route statistics
#' stats <- analyse_gpx("path/to/file.gpx")
#'
#' # Generate a plot
#' analyse_gpx("path/to/file.gpx", return = "plot")
#'
#' # Get processed data
#' track_data <- analyse_gpx("path/to/file.gpx", return = "data")
#' }
#'
#' @export
analyse_gpx <- function(gpx_path, return = "stats") {
  # Read GPX data
  cat("Reading GPX file:", gpx_path, "\n")
  track_points <- read_gpx_track(gpx_path)
  
  # Calculate metrics
  track_points <- calculate_distance(track_points)
  track_points <- calculate_elevation_stats(track_points)
  
  # Identify geographic locations
  track_points <- identify_geo(track_points)
  
  # Calculate and print summary statistics
  stats <- calculate_route_stats(track_points)

  if(return == "plot"){
    # Plot route
    plot_route(track_points)
  } else if(return == "stats"){
    # Return statistics
    return(stats)
  } else if(return == "data"){
    # Return data
    return(track_points)
  }
}