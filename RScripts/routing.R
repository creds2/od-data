remotes::install_github("ITSleeds/opentripplanner")
library(opentripplanner)
library(sf)
library(pct)

path_otp = "D:/otp_optitruck/otp.jar"
path_data = "F:/otp-GB"
memory = 30

# Config otp

build <- otp_make_config("build")
build$osmWayPropertySet <- "norway"

router <- otp_make_config("router")
router$routingDefaults$driveOnRight <- FALSE
router$timeout <- 20
router$timeouts <- c(20, 10, 5, 4, 3)

otp_validate_config(build)
otp_validate_config(router)

otp_write_config(build, path_data)
otp_write_config(router, path_data)

# Run Onece
#log1 = otp_build_graph(otp = path_otp, dir = path_data, memory = memory)
log2 = otp_setup(otp = path_otp,
                         dir = dir,
                         memory = memory,
                         port = 8801,
                         securePort = 8802,
                         analyst = FALSE,
                         wait = TRUE)

otpcon <- otp_connect(hostname =  "localhost", router = "default", port = 8801)

# Get lines
u = "https://github.com/ropensci/stplanr/releases/download/0.2.9/desire_lines_cars.Rds"
f = file.path(tempdir(), "lines_cars.Rds")
download.file(u, f, mode = "wb")
lines_cars = readRDS(f)
lines_cars$`Drive to work (%)` = lines_cars$car_driver / lines_cars$all * 100
# plot(lines_cars["car_km"], lwd = lines_cars$car_km / 1000)
sum(lines_cars$all)
lines_cars$energy_cars = lines_cars$car_km *
  2.5 * # average energy use per vehicle km 
  220 * # estimated number of commutes/yr
  2.6   # circuity (estimated at 1.3) multiplied by 2 

lines_cars_top = lines_cars %>% 
  top_n(n = 100000, wt = energy_cars)

coords <- st_coordinates(lines_cars_top)
fromPlace <- coords[seq(1,nrow(coords), 2),]
toPlace <- coords[seq(2,nrow(coords), 2),]

fromPlace <- fromPlace[,1:2]
toPlace <- toPlace[,1:2]
routes <- otp_plan(otpcon, 
                  fromPlace, 
                  toPlace, 
                  lines_cars_top$geo_code1, 
                  lines_cars_top$geo_code2,
                  mode = "CAR",
                  ncores = 3)
saveRDS(routes,"top10000routes.Rds")

# Check the missing ones

routes$id <- paste0(routes$fromPlace," ",routes$toPlace)
lines_cars_top$id <- paste0(lines_cars_top$geo_code1," ",lines_cars_top$geo_code2)

missing <- lines_cars_top[!lines_cars_top$id %in% routes$id, ]
coords_missing <- st_coordinates(missing)
fromPlace_missing <- coords_missing[seq(1,nrow(coords_missing), 2),]
toPlace_missing <- coords_missing[seq(2,nrow(coords_missing), 2),]
fromPlace_missing <- fromPlace_missing[,1:2]
toPlace_missing <- toPlace_missing[,1:2]
routes_missing <- otp_plan(otpcon, 
                           fromPlace_missing, 
                           toPlace_missing, 
                           missing$geo_code1, 
                           missing$geo_code2,
                           mode = c("CAR","WALK"),
                           ncores = 3,
                           maxWalkDistance = 2000)
saveRDS(routes_missing,"top10000routes_missing.Rds")




# notmissing <- lines_cars_top[lines_cars_top$id %in% routes$id, ]
# 
# missing$length <- as.numeric(st_length(missing))
# notmissing$length <- as.numeric(st_length(notmissing))
# 
# qtm(missing[missing$length < 5000,])
# foo = otp_plan(otpcon, 
#                c(-1.977514, 50.73152), 
#                c(-1.97828, 50.71755), 
#                mode = c("WALK"),
#                maxWalkDistance = 5000)
# qtm(st_zm(foo))
