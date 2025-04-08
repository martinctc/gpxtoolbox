#' @title Identify geographic location from GPS coordinates
#' @description
#' Adds geographic location information (e.g., city, country) to GPS track points
#' based on latitude and longitude using the OpenStreetMap Nominatim API.
#'
#' @param track_points A data frame containing track points with at least the following columns:
#' \itemize{
#'   \item lon - longitude in decimal degrees
#'   \item lat - latitude in decimal degrees
#' }
#' @param all Logical. If \code{TRUE}, identifies the location for all track points.
#'   If \code{FALSE} (default), only identifies the location for the start and end points
#'   of the route. Setting \code{all = FALSE} helps reduce API usage.
#'
#' @return The input data frame with an additional column for geographic information:
#' \itemize{
#'   \item location - a string describing the geographic location (e.g., "City, Country")
#' }
#'
#' @details
#' This function uses the OpenStreetMap Nominatim API for reverse geocoding. Ensure you have an
#' active internet connection as the function queries an external API. Be mindful of the API usage policy.
#'
#' @examples
#' \dontrun{
#' # First read a GPX file
#' track_data <- read_gpx_track("path/to/activity.gpx")
#'
#' # Identify geographic locations for start and end points only
#' track_data <- identify_geo(track_data)
#'
#' # Identify geographic locations for all points
#' track_data <- identify_geo(track_data, all = TRUE)
#'
#' # View the location data
#' head(track_data[, c("lon", "lat", "location")])
#' }
#'
#' @importFrom httr GET content
#' @export
identify_geo <- function(track_points, all = FALSE) {
  # Helper function to query the Nominatim API
  get_location <- function(lat, lon) {
    url <- sprintf("https://nominatim.openstreetmap.org/reverse?format=json&lat=%f&lon=%f", lat, lon)
    response <- httr::GET(url, httr::user_agent("gpxtoolbox R package"))
    if (httr::status_code(response) == 200) {
      content <- httr::content(response, as = "parsed", encoding = "UTF-8")
      return(content$display_name)
    } else {
      return(NA)
    }
  }

  if(all == TRUE){

    # Apply reverse geocoding to each point
    track_points$location <- mapply(get_location, track_points$lat, track_points$lon)

  } else if(all == FALSE){

    # Only apply to start and end tracking point
    start_location <- get_location(track_points$lat[1], track_points$lon[1])
    end_location <- get_location(track_points$lat[nrow(track_points)], track_points$lon[nrow(track_points)])

    track_points$location <- NA  # Initialize with NA
    track_points$location[1] <- start_location
    track_points$location[nrow(track_points)] <- end_location

  }
  
  return(track_points)
}
