#' @title 
#' Analyse Track File (GPX or FIT)
#' 
#' @description
#' Processes a track file (GPX or FIT) to extract route information, calculate metrics such as
#' distance and elevation, and provide summary statistics or visualization.
#'
#' @param file_path Character string specifying the path to the track file (.gpx or .fit) or a web link
#'   to a route on Strava or RideWithGPS (GPX only).
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
#' The function automatically detects the file format based on the file extension:
#' \itemize{
#'   \item .gpx files are processed using read_gpx_track()
#'   \item .fit files are processed using read_fit_track() (requires FITfileR package)
#' }
#' 
#' If a web link is provided for \code{file_path}, the function will automatically
#' construct the appropriate GPX export URL, download the file to a temporary location,
#' and process it. Note: web link support is only available for GPX files.
#' 
#' @examples
#' \dontrun{
#' # Get route statistics from a local GPX file
#' stats <- analyse_track("path/to/file.gpx")
#' 
#' # Get route statistics from a local FIT file
#' stats <- analyse_track("path/to/file.fit")
#'
#' # Get route statistics from a Strava link (GPX only)
#' stats <- analyse_track("https://www.strava.com/routes/3193200014155699162")
#'
#' # Get route statistics from a RideWithGPS link (GPX only)
#' stats <- analyse_track("https://ridewithgps.com/routes/39294504")
#' }
#' 
#' # Use the example GPX file included in the package
#' example_gpx_path <- system.file("extdata", "icc_intro_ride.gpx", package = "gpxtoolbox")
#'
#' # Analyse the example track file
#' stats <- analyse_track(example_gpx_path)
#' print(stats)
#'
#' # Generate a plot of the example track file
#' analyse_track(example_gpx_path, return = "plot")
#'
#' @importFrom httr GET write_disk status_code
#' @export
analyse_track <- function(file_path, return = "stats", plot_mode = "ggplot") {
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
      stop("Failed to download track file. Please check the URL or your internet connection.")
    }
    return(temp_file)
  }
  
  # Check if file_path is a web link (only supported for GPX)
  if (grepl("^https?://", file_path)) {
    cat("Downloading GPX file from:", file_path, "\n")
    file_path <- download_gpx(file_path)
  }
  
  # Validate the file
  if (!file.exists(file_path) || file.size(file_path) == 0) {
    stop("The track file is missing or empty. Please check the file or URL.")
  }
  
  # Determine file type
  file_ext <- tolower(tools::file_ext(file_path))
  file_type <- if (file_ext == "gpx") "GPX" else if (file_ext == "fit") "FIT" else "track"
  
  # Read track data
  cat("Reading", file_type, "file:", file_path, "\n")
  track_points <- tryCatch(
    read_track(file_path),
    error = function(e) {
      stop(paste("Failed to read the", file_type, "file. The file may be corrupt or in an unsupported format. Error:", e$message))
    }
  )
  
  # Calculate metrics
  track_points <- calculate_distance(track_points)
  track_points <- calculate_elevation_stats(track_points)
  
  # Identify geographic locations (skip if offline)
  tryCatch({
    track_points <- identify_geo(track_points)
  }, error = function(e) {
    warning("Geographic location identification skipped (requires internet connection): ", e$message)
    track_points$location <- NA
  })

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