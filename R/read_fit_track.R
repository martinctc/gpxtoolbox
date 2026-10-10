#' @title Read FIT file and extract track points
#' @description
#' This function reads a FIT file and extracts the track points, including latitude, longitude, elevation, and time.
#' 
#' @param fit_path string. Path to the FIT file.
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
#' The function uses FITfileR package to read FIT files. It extracts the records
#' data which contains the sequential points that make up a GPS track. Time values are
#' converted to POSIXct objects in UTC timezone.
#' 
#' @examples
#' \dontrun{
#' # Read track points from a FIT file
#' track_data <- read_fit_track("path/to/file.fit")
#' 
#' # View the first few points
#' head(track_data)
#' }
#' 
#' @importFrom dplyr tibble 
#'
#' @export
read_fit_track <- function(fit_path) {
  # Check if FITfileR is available
  if (!requireNamespace("FITfileR", quietly = TRUE)) {
    stop("FITfileR package is required to read FIT files. Please install it using:\ninstall.packages('FITfileR')")
  }
  
  # Read the FIT file
  fit_data <- FITfileR::readFitFile(fit_path)
  
  # Extract record data (contains GPS track points)
  if (!("record" %in% names(fit_data))) {
    stop("No record data found in FIT file. This may not be a valid GPS track file.")
  }
  
  records <- fit_data$record
  
  # Check for required fields
  required_fields <- c("position_lat", "position_long")
  missing_fields <- required_fields[!required_fields %in% names(records)]
  if (length(missing_fields) > 0) {
    stop(paste("Missing required GPS fields in FIT file:", paste(missing_fields, collapse = ", ")))
  }
  
  # Convert semicircles to degrees (FIT files store position in semicircles)
  # 1 semicircle = 180/2^31 degrees
  semicircles_to_degrees <- 180 / (2^31)
  
  # Extract relevant columns and convert to data frame
  track_points <- dplyr::tibble(
    lon = records$position_long * semicircles_to_degrees,
    lat = records$position_lat * semicircles_to_degrees,
    ele = if ("altitude" %in% names(records)) records$altitude else NA_real_,
    time = if ("timestamp" %in% names(records)) as.POSIXct(records$timestamp, origin = "1989-12-31", tz = "UTC") else NA
  )
  
  # Remove rows with missing coordinates
  track_points <- track_points[!is.na(track_points$lon) & !is.na(track_points$lat), ]
  
  if (nrow(track_points) == 0) {
    stop("No valid GPS coordinates found in FIT file.")
  }
  
  return(track_points)
}