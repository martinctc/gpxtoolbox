#' @title Plot GPX route visualisation
#' @description
#' Creates visualisations of a GPS route, including an elevation profile and a route map.
#' 
#' @param track_points A data frame containing track points with the following required columns:
#' \itemize{
#'   \item lon - longitude in decimal degrees
#'   \item lat - latitude in decimal degrees
#'   \item ele - elevation in metres
#'   \item cumulative_distance - distance in kilometres
#' }
#' @param mode Character string. The plotting mode to use. Options are:
#'   \itemize{
#'     \item "ggplot" (default): Uses ggplot2 for visualisation.
#'     \item "leaflet": Uses the leaflet package to create an interactive map.
#'   }
#'
#' @return For "ggplot" mode, plots are displayed in the current graphics device. 
#'   For "leaflet" mode, an interactive map is returned.
#'
#' @details
#' This function creates visualisations based on the selected mode:
#' \itemize{
#'   \item "ggplot": An elevation profile and a static route map.
#'   \item "leaflet": An interactive map with a greyscale tile layer (CartoDB.Positron).
#' }
#' 
#' @examples
#' # Use the example GPX file included in the package
#' example_gpx_path <- system.file("extdata", "icc_intro_ride.gpx", package = "gpxtoolbox")
#' 
#' # First read a GPX file
#' track_data <- read_gpx_track(example_gpx_path)
#' 
#' # Calculate cumulative distance (required for plotting)
#' track_data <- calculate_distance(track_data)
#' 
#' # Plot the route visualisations
#' plot_route(track_data, mode = "ggplot")
#' plot_route(track_data, mode = "leaflet")
#' 
#' @importFrom ggplot2 ggplot aes geom_line geom_path labs theme_minimal coord_quickmap
#' @importFrom leaflet leaflet addProviderTiles addPolylines providers
#' 
#' @export
plot_route <- function(track_points, mode = "ggplot") {
  if (mode == "ggplot") {
    # Plot elevation profile
    elevation_plot <- ggplot(track_points, aes(x = cumulative_distance, y = ele)) +
      geom_line() +
      labs(x = "Distance (km)", y = "Elevation (m)", title = "Elevation Profile") +
      theme_minimal()
    
    # Plot route on map (simplified)
    route_plot <- ggplot(track_points, aes(x = lon, y = lat)) +
      geom_path() +
      labs(x = "Longitude", y = "Latitude", title = "Route Map") +
      theme_minimal() +
      coord_quickmap()
    
    # Print both plots
    print(elevation_plot)
    print(route_plot)
  } else if (mode == "leaflet") {
    # Create an interactive map using leaflet with CartoDB.Positron tiles
    leaflet_map <- leaflet(data = track_points) %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addPolylines(lng = ~lon, lat = ~lat, color = "blue", weight = 2)
    
    # Return the leaflet map
    return(leaflet_map)
  } else {
    stop("Invalid mode. Use 'ggplot' or 'leaflet'.")
  }
}
