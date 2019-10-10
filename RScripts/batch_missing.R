library(data.table)
library(sf)
library(tmap)
library(stplanr)
library(dplyr)
library(opentripplanner)
tmap_mode("view")
od_all <- readRDS("F:/lsoa_routes_all/lsoa_od_all2.Rds")
od_all <- as.data.table(od_all)
od_all_chk <- od_all[1:(438 * 10000),]
od_all_chk <- od_all_chk[od_all_chk$try,]
od_fail <- od_all_chk[!od_all_chk$done,]
od_succ <- od_all_chk[od_all_chk$done,]

# Calcualte a sucess rate for centroids
cents_lsoa <- read_sf("data/lsoa_centroids_modified.gpkg")

#cent_rate <- rbind(od_all_chk[,c("from","done")], od_all_chk[,c("to","done")], use.names = FALSE)
cent_rate <- od_all_chk[,c("from","done")]
names(cent_rate) <- c("to","done")
cent_rate <- rbind(cent_rate, od_all_chk[,c("to","done")])

cent_rate <- cent_rate %>%
  group_by(to) %>%
  summarise(attempt = n(),
            work = length(done[done]),
            fail = length(done[!done]))
cent_rate$rate <- cent_rate$fail / cent_rate$attempt
cent_rate <- cent_rate[order(cent_rate$rate, decreasing = TRUE),]
bad_cent <- cent_rate$to[cent_rate$rate > 0.1 & cent_rate$rate <= 0.5]
bad_cent <- cents_lsoa[cents_lsoa$code %in% bad_cent,]

qtm(bad_cent, dots.col = "fix")

line_fail = stplanr::od2line(od_fail, cents_lsoa)
qtm(line_fail)
# lsoa_succ <- unique(c(as.character(od_succ$from), as.character(od_succ$to)))
# lsoa_f1 <- unique(c(as.character(od_fail$from), as.character(od_fail$to)))
# lsoa_f2 <- lsoa_f1[!lsoa_f1 %in% lsoa_succ]
# 
# #lsoa_f2 should be all the problem lsoas but lets check
# 
# od_fail$ck1 <- od_fail$from %in% lsoa_f2
# od_fail$ck2 <- od_fail$to %in% lsoa_f2
# od_fail$ck3 <- od_fail$ck1 | od_fail$ck2 
# 
# summary(od_fail$ck3)
# # bum 34% for failed pairs are not included
# 
# lines <- stplanr::od2line(od_fail, cents_lsoa)
# qtm(lines[1:1000,])

# Lets fix the ones we can first
#cents_lsoa <- read_sf("D:/Users/earmmor/OneDrive - University of Leeds/Cycling Big Data/LSOA/england_lsoa_2011_centroids_mod.shp")
#st_crs(cents_lsoa) <- 27700
#cents_lsoa <- st_transform(cents_lsoa, 4326)
#cents_lsoa <- cents_lsoa[,c("code")]

# 
# cent_wrong <- cents_lsoa[cents_lsoa$code %in% lsoa_f2,]
# qtm(cent_wrong)
# 
# cents_lsoa$fix <- as.character(cents_lsoa$code %in% lsoa_f2)
# write_sf(cents_lsoa, "data/lsoa_centroids_modified.gpkg")

# Lest look at the others
# cents_odd <- od_fail[!od_fail$ck3,]
# cents_odd <- c(as.character(cents_odd$from), as.character(cents_odd$to))
# cents_odd <- as.data.frame(table(cents_odd))
# cents_odd <- dplyr::left_join(cents_odd, cents_lsoa, by = c("cents_odd" = "code"))
# cents_odd <- st_as_sf(cents_odd)
# qtm(cents_odd, dots.col = "Freq")
# cents_odd_top <- cents_odd[cents_odd$Freq > 10,]
# qtm(cents_odd_top, dots.col = "Freq")
# lots around islands, and a few random one that can be fixed. Most only occure a few times which might just be timeouts

# fire up otp again and retry
cents_new <- st_read("data/lsoa_centroids_modified.gpkg")
cents_new$code <- as.character(cents_new$code)
fromPlace <- cents_new[match(od_fail$from, cents_new$code),]

toPlace <- cents_new[match(od_fail$to, cents_new$code),]
mode = "CAR"
otpcon <- otp_connect(hostname =  "localhost", router = "drive", port = 8801)

routes <- otp_plan(otpcon, 
                   fromPlace, 
                   toPlace, 
                   fromPlace$code, 
                   toPlace$code,
                   mode = mode,
                   ncores = 4)

saveRDS(routes, paste0("F:/lsoa_routes_all/batch_routes2/r_",mode,"_missing_1_to_438_att_4.Rds"))

# Update the master records

head(od_all_chk)
od_all_chk$id <- paste0(od_all_chk$from," ",od_all_chk$to)
routes_id <- paste0(routes$fromPlace," ",routes$toPlace)
head(routes_id)
od_all_chk$done2 <- od_all_chk$id %in% routes_id
summary(od_all_chk$done2)
summary(od_all_chk$done)
od_all_chk$done <- ifelse(od_all_chk$done,TRUE,od_all_chk$done2)
summary(od_all_chk$done)
od_all$done[1:4380000] <- od_all_chk$done
saveRDS(od_all, "F:/lsoa_routes_all/lsoa_od_all2.Rds")
