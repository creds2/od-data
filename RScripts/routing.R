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

otp_validate_config(build)
otp_validate_config(router)

otp_write_config(build, path_data)
otp_write_config(router, path_data)

# Run Onece
log1 = otp_build_graph(otp = path_otp, dir = path_data, memory = memory)
