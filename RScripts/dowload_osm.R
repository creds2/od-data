library(OSMtools)
library(opentripplanner)
osmt_geofabrik_dl("europe/great-britain", "F:/otp-GB/gb-raw.pbf")
dir.create("F:/otp-GB/graphs/active")
dir.create("F:/otp-GB/graphs/drive")
# Convert to o5m format for editing, and drop author info
osmt_convert(file = "F:/otp-GB/gb-raw.pbf", format_out = "o5m")
# Keep just the roads
osmt_filter(file = "F:/otp-GB/gb-raw.o5m",
            path_out = "F:/otp-GB/graphs/active/roads.o5m",
            keep = "highway=")

# Make a driving version
osmt_filter(file = "F:/otp-GB/graphs/active/roads.o5m",
            path_out = "F:/otp-GB/graphs/drive/roads-drive.o5m",
            drop = "highway=track =footway =path =cycleway",
            drop_tags = "cycleway= cycleway:left= cycleway:right=")

# Convert Back to pbf format for OTP
osmt_convert(file = "F:/otp-GB/graphs/drive/roads-drive.o5m", format_out = "pbf")
osmt_convert(file = "F:/otp-GB/graphs/active/roads.o5m", format_out = "pbf")
# remove files
file.remove("F:/otp-GB/graphs/drive/roads-drive.o5m")
file.remove("F:/otp-GB/graphs/active/roads.o5m")

#Mnually copy in DEM and needed
# Build Graphs
path_otp = "F:/otp-GB/otp-1.4.jar"
path_data = "F:/otp-GB"
memory = 30000

# Config otp
build <- otp_make_config("build")
build$osmWayPropertySet <- "norway"

router <- otp_make_config("router")
router$routingDefaults$driveOnRight <- FALSE
router$timeout <- 20
router$timeouts <- c(20, 10, 5, 4, 3)

otp_validate_config(build)
otp_validate_config(router)

otp_write_config(build, path_data, router = "drive")
otp_write_config(router, path_data, router = "drive")
otp_write_config(build, path_data, router = "active")
otp_write_config(router, path_data, router = "active")

# Run Onece
log_drive = otp_build_graph(otp = path_otp, dir = path_data, memory = memory, router = "drive")
log_active = otp_build_graph(otp = path_otp, dir = path_data, memory = memory, router = "active")
