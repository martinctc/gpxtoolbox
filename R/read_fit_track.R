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
#' converted to POSIXct objects in UTC timezone. FIT files store positions as
#' integers in semicircles; if the values are not already in decimal degrees
#' (as returned by FITfileR >= 0.1.0), they are converted to degrees.
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
    stop("FITfileR package is required to read FIT files. Please install it using:\nremotes::install_github('grimbough/FITfileR')")
  }
  
  # Read the FIT file
  fit_data <- FITfileR::readFitFile(fit_path)

  # Extract record data (contains GPS track points).
  # FITfileR >= 0.1.0 returns an S4 FitFile object; older versions returned
  # a plain named list of message types. Support both.
  if (inherits(fit_data, "FitFile")) {
    if (!"record" %in% FITfileR::listMessageTypes(fit_data)) {
      stop("No record data found in FIT file. This may not be a valid GPS track file.")
    }
    # records() may return a list of data frame chunks (one per record message)
    record_data <- dplyr::bind_rows(FITfileR::records(fit_data))
  } else if (is.list(fit_data)) {
    if (!("record" %in% names(fit_data))) {
      stop("No record data found in FIT file. This may not be a valid GPS track file.")
    }
    record_data <- dplyr::bind_rows(fit_data$record)
  } else {
    stop("No record data found in FIT file. This may not be a valid GPS track file.")
  }

  # Check for required fields
  required_fields <- c("position_lat", "position_long")
  missing_fields <- required_fields[!required_fields %in% names(record_data)]
  if (length(missing_fields) > 0) {
    stop(paste("Missing required GPS fields in FIT file:", paste(missing_fields, collapse = ", ")))
  }

  lat <- record_data$position_lat
  lon <- record_data$position_long

  # FIT files store position as integers in semicircles (1 semicircle =
  # 180 / 2^31 degrees). FITfileR >= 0.1.0 already converts these to decimal
  # degrees, so no further conversion is normally needed. Raw semicircle values
  # are large, so detection uses a majority test rather than any(): a handful of
  # invalid sentinel points (e.g. position_lat = 180) in an otherwise converted
  # file must not trigger a spurious conversion of the whole track.
  frac_out_of_range <- mean(abs(lat) > 90 | abs(lon) > 180, na.rm = TRUE)
  if (is.finite(frac_out_of_range) && frac_out_of_range > 0.5) {
    semicircles_to_degrees <- 180 / (2^31)
    lat <- lat * semicircles_to_degrees
    lon <- lon * semicircles_to_degrees
  }

  # Out-of-range positions are invalid FIT sentinels; treat them as missing so
  # they are dropped along with the other missing coordinates below.
  lat[which(abs(lat) > 90)] <- NA_real_
  lon[which(abs(lon) > 180)] <- NA_real_

  # Extract relevant columns and convert to data frame
  track_points <- dplyr::tibble(
    lon = lon,
    lat = lat,
    ele = if ("altitude" %in% names(record_data)) as.numeric(record_data$altitude) else NA_real_,
    time = if ("timestamp" %in% names(record_data)) {
      ts <- record_data$timestamp
      if (inherits(ts, "POSIXct") || inherits(ts, "POSIXt")) {
        as.POSIXct(ts, tz = "UTC")
      } else {
        as.POSIXct(ts, origin = "1989-12-31", tz = "UTC")
      }
    } else NA
  )
  
  # Remove rows with missing coordinates
  track_points <- track_points[!is.na(track_points$lon) & !is.na(track_points$lat), ]
  
  if (nrow(track_points) == 0) {
    stop("No valid GPS coordinates found in FIT file.")
  }
  
  return(track_points)
}