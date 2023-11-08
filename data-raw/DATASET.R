## code to prepare `DATASET` dataset goes here

## generate survey
# surv <- generate_survey_plan(bbx_xmin = 5, bbx_xmax = 85, bbx_ymin = 5, bbx_ymax = 85,
#                              start_x = 5, end_x = 85, start_y = 5, end_y = 85,
#                              space_out_factor = 4, segmentize = TRUE, seg_length = 1,
#                              buffer = TRUE, buffer_width = 0.2
# )
# flight_id <- c(1:80, 160:81, 161:240, 320:241, 321:400, 480:401, 481:560, 640:561, 641:720, 800:721, 801:880, 960:881, 961:1040,
               # 1120:1041, 1121:1200, 1280:1201, 1281:1360, 1440:1361, 1441:1520, 1600:1521, 1601:1680)

surv <- generate_survey_plan(bbx_xmin = 30, bbx_xmax = 65, bbx_ymin = 30, bbx_ymax = 65,
                             start_x = 34, end_x = 60, start_y = 34, end_y = 68,
                             space_out_factor = 2, segmentize = TRUE, seg_length = 1,
                             buffer = TRUE, buffer_width = 0.2
)


# assign the time periods to each segment
flight_plan <- assign_flight_plan(
  sf_segments = surv$buffered_segments,
  flight_id = c(1:468),
  col_trans_id = "transect",
  flight_day = "2022-08-01",
  survey_start_hour = "06:00:00",
  flight_speed = 160,
  intertransect_gap_duration = 60*30
)

## generate species movements
grid <- create_grid()
env <- generate_env_layer(grid = grid, n = 1)
colony_location <- data.frame(Lon = 50, Lat = 50)

pop.traj <- pbapply::pblapply(1:100, function(i){
  traj <-  simulate_trajectory_FR(initial_position = colony_location,
                                  resource_layer = env$rasters$sim1,
                                  starting_hour = ymd_hms("2022-08-01 06:00:00"),
                                  starting_bearing = c(90,10),
                                  starting_step = c(4.5, 3),
                                  travel_bearing = c(0, 20),
                                  travel_step = c(3, 3),
                                  foraging_bearing = c(0, 0.5),
                                  foraging_step = c(1, 3),
                                  minx = 0, maxx = 90,
                                  miny = 0, maxy = 90,
                                  step_duration = 5,
                                  activity_threshold = 0.7,
                                  max_duration = 400)
  traj$ind_id <- i
  return(traj)
})
full_pop <- do.call("rbind", pop.traj)

library(ggplot2)
ggplot(full_pop)+
  geom_sf(data = surv$buffered_segments) +
  geom_point(aes(x = Lon, y = Lat, color = ind_id))

## put everything in a list
example_data <- list(
  env_resource_layers = env$dataframe, # doit enlever le SpatRaster sinon ça bug à la réouverture puise que pointe vers un fichier temporaire inexistante
  mvmt_data = full_pop,
  survey = surv,
  flight_plan = flight_plan
)

## Copy to data
# create the rda
usethis::use_data(example_data, overwrite = TRUE)

# resave with best suited compression
tools::resaveRdaFiles("data/example_data.rda")

# check which compression is chosen : xy
tools::checkRdaFiles("data/")


## Create the documentation
checkhelper::use_data_doc("example_data") # do not rerun if update only values, bc rewrite the file
rstudioapi::navigateToFile("R/doc_example_data.R")

attachment::att_amend_desc()


