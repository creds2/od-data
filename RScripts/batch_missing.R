library(data.table)
library(sf)
library(tmap)
tmap_mode("view")
od_all <- readRDS("F:/lsoa_routes_all/lsoa_od_all.Rds")
od_all <- as.data.table(od_all)
od_all_chk <- od_all[1:6460000,]
od_fail <- od_all_chk[!od_all_chk$done,]
od_succ <- od_all_chk[od_all_chk$done,]

lsoa_succ <- unique(c(as.character(od_succ$from), as.character(od_succ$to)))
lsoa_f1 <- unique(c(as.character(od_fail$from), as.character(od_fail$to)))
lsoa_f2 <- lsoa_f1[!lsoa_f1 %in% lsoa_succ]

#lsoa_f2 should be all the problem lsoas but lets check

od_fail$ck1 <- od_fail$from %in% lsoa_f2
od_fail$ck2 <- od_fail$to %in% lsoa_f2
od_fail$ck3 <- od_fail$ck1 | od_fail$ck2 

summary(od_fail$ck3)
# bum 34% for failed pairs are not included

# Lets fix the ones we can first
cents_lsoa <- read_sf("D:/Users/earmmor/OneDrive - University of Leeds/Cycling Big Data/LSOA/england_lsoa_2011_centroids_mod.shp")
st_crs(cents_lsoa) <- 27700
cents_lsoa <- st_transform(cents_lsoa, 4326)
cents_lsoa <- cents_lsoa[,c("code")]

cent_wrong <- cents_lsoa[cents_lsoa$code %in% lsoa_f2,]
qtm(cent_wrong)

cents_lsoa$fix <- as.character(cents_lsoa$code %in% lsoa_f2)
write_sf(cents_lsoa, "data/lsoa_centroids_modified.gpkg")

# Lest look at the others
cents_odd <- od_fail[!od_fail$ck3,]
cents_odd <- c(as.character(cents_odd$from), as.character(cents_odd$to))
cents_odd <- as.data.frame(table(cents_odd))
cents_odd <- dplyr::left_join(cents_odd, cents_lsoa, by = c("cents_odd" = "code"))
cents_odd <- st_as_sf(cents_odd)
qtm(cents_odd, dots.col = "Freq")
cents_odd_top <- cents_odd[cents_odd$Freq > 10,]
qtm(cents_odd_top, dots.col = "Freq")
# lots around islands, and a few random one that can be fixed. Most only occure a few times which might just be timeouts

# fire up otp again and retry
cents_new <- st_read("data/lsoa_centroids_modified.gpkg")
cents_new$code <- as.character(cents_new$code)
fromPlace <- cents_new[match(od_fail$from, cents_new$code),]

toPlace <- cents_new[match(od_fail$to, cents_new$code),]
mode = "CAR"

routes <- otp_plan(otpcon, 
                   fromPlace, 
                   toPlace, 
                   fromPlace$code, 
                   toPlace$code,
                   mode = mode,
                   ncores = 6)

saveRDS(routes, paste0("F:/lsoa_routes_all/batch_routes/r_",mode,"_missing_1_to_646_att_1.Rds"))
