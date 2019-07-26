od_all <- readRDS("F:/lsoa_routes_all/lsoa_od_all.Rds")
#od_all$try <- FALSE
#od_all$done <- FALSE


cents_lsoa <- read_sf("D:/Users/earmmor/OneDrive - University of Leeds/Cycling Big Data/LSOA/england_lsoa_2011_centroids_mod.shp")
st_crs(cents_lsoa) <- 27700
cents_lsoa <- st_transform(cents_lsoa, 4326)
cents_lsoa <- cents_lsoa[,c("code")]

batch <- 10000
mode <- "CAR"
n <- ceiling(nrow(od_all) / batch)
nr <- nrow(od_all)
otpcon <- otp_connect(hostname =  "localhost", router = "default", port = 8801)
for(i in 647:n){
  message(paste0(Sys.time()," doing ",i," of ",n))
  b <- batch * i
  a <- b - batch + 1
  if(b > nr){
    b <- nr
  }
  message(paste0(a," to ",b))
  od <- od_all[a:b,]
  fromPlace <- cents_lsoa[match(od$from, cents_lsoa$code),]
  toPlace <- cents_lsoa[match(od$to, cents_lsoa$code),]
  
  routes <- otp_plan(otpcon, 
                     fromPlace, 
                     toPlace, 
                     fromPlace$code, 
                     toPlace$code,
                     mode = mode,
                     ncores = 6)
  
  saveRDS(routes, paste0("F:/lsoa_routes_all/batch_routes/r_",mode,"_bch_",i,"_",a,"to",b,".Rds"))
  
  od_all$try[a:b] <- TRUE
  od$id <- paste0(od$from," ",od$to)
  routes$odid <- paste0(routes$fromPlace," ",routes$toPlace)
  od$done <- od$id %in% routes$odid
  
  od_all$done[a:b] <- od$done
  
  if(i %% 10 == 0){
    saveRDS(od_all, "F:/lsoa_routes_all/lsoa_od_all.Rds")
  }
  
  
}
