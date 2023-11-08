#' example_data
#'
#' Example data for the simtools package. All the data have been generated with functions from the package.
#'
#' @format A data frame with  rows and  variables:
#' \describe{
#'   \item{ env_resource_layers }{  the environmental resource layers, as dataframe (output from \code{\link{generate_env_layer}}) }
#'   \item{ mvmt_data }{  data.frame with trajectories of 500 individuals (output from \code{\link{simulate_trajectory_CPF}}) }
#'   \item{ survey }{  list of the survey plan at various formats (output from \code{\link{generate survey plan}})  }
#'   \item{ flight_plan }{  sf,data.frame survey plan with the flight plan assigned to it (output from \code{\link{assign_flight_plan}} )}
#' }
#' @source Source
"example_data"
