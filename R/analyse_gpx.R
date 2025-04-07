#' @title 
#' Analyse GPX File
#' 
#' @description
#' Processes a GPX file to extract route information, calculate metrics such as distance and elevation,
#' and provide summary statistics or visualization.
#'
#' @param gpx_path Character string specifying the path to the GPX file.
#' @param return Character string indicating the type of output to return. Options are:
#'   \itemize{
#'     \item "stats" (default): Returns a list of summary statistics
#'     \item "plot": Generates a plot of the route and returns track points
#'     \item "data": Returns the processed track points data
#'   }
#'
#' @return Depending on the \code{return} parameter:
#'   \itemize{
#'     \item If "stats": A named list of route statistics
#'     \item If "plot": Generates a plot and returns the track points data
#'     \item If "data": A data frame of processed track points with calculated metrics
#'   }
#'
#' @examples
#' \dontrun{
#' # Get route statistics
#' stats <- analyze_gpx("path/to/file.gpx")
#'
#' # Generate a plot
#' analyze_gpx("path/to/file.gpx", return = "plot")
#'
#' # Get processed data
#' track_data <- analyze_gpx("path/to/file.gpx", return = "data")
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
  
  # Calculate and print summary statistics
  stats <- calculate_route_stats(track_points)
  cat("\nRoute Statistics:\n")
  for (name in names(stats)) {
    cat(sprintf("%s: %s\n", gsub("_", " ", name), stats[[name]]))
  }

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
  # Return processed data
  return(track_points)
}