#' @title Read track file (GPX or FIT) and extract track points
#' @description
#' This function automatically detects the file format and reads either a GPX or FIT file,
#' extracting the track points including latitude, longitude, elevation, and time.
#' 
#' @param file_path string. Path to the track file (GPX or FIT).
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
#' The function automatically detects the file format based on the file extension:
#' \itemize{
#'   \item .gpx files are processed using read_gpx_track()
#'   \item .fit files are processed using read_fit_track()
#' }
#' 
#' For FIT files, the FITfileR package is required.
#' 
#' @examples
#' # Use the example GPX file included in the package
#' example_gpx_path <- system.file("extdata", "icc_intro_ride.gpx", package = "gpxtoolbox")
#'
#' # Read track points from a GPX file
#' track_data <- read_track(example_gpx_path)
#' 
#' \dontrun{
#' # Read track points from a FIT file
#' fit_track_data <- read_track("path/to/file.fit")
#' }
#' 
#' # View the first few points
#' head(track_data)
#'
#' @export
read_track <- function(file_path) {
  # Check if file exists
  if (!file.exists(file_path)) {
    stop("File not found: ", file_path)
  }
  
  # Get file extension
  file_ext <- tolower(tools::file_ext(file_path))
  
  # Route to appropriate reader based on file extension
  if (file_ext == "gpx") {
    return(read_gpx_track(file_path))
  } else if (file_ext == "fit") {
    return(read_fit_track(file_path))
  } else {
    stop("Unsupported file format: ", file_ext, ". Supported formats are: gpx, fit")
  }
}