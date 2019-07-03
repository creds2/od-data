# Make a list of OD Pairs and prioritise
library(sf)
library(stplanr)
library(geodist)
library(dplyr)

# LSOA centroids
# pct modified centroids

cents_lsoa <- read_sf("D:/Users/earmmor/OneDrive - University of Leeds/Cycling Big Data/LSOA/england_lsoa_2011_centroids_mod.shp")
st_crs(cents_lsoa) <- 27700
cents_lsoa <- st_transform(cents_lsoa, 4326)
cents_lsoa$code <- as.factor(cents_lsoa$code)


# Nearest pairs
coord <- st_coordinates(cents_lsoa)
dists <- geodist(coord, measure = "cheap")

dist_pairs <- data.frame(from = rep(cents_lsoa$code, times = length(cents_lsoa$code)),
                         to = rep(cents_lsoa$code, each = length(cents_lsoa$code)))
dist_pairs$dist <- as.integer(dists)
rm(coord, dists, cents_lsoa)
dist_pairs <- dist_pairs[dist_pairs$from != dist_pairs$to, ]
gc()
pairing <- function(x, y, ordermatters = FALSE){
  if(ordermatters){
    ismax <- x > y
    return((ismax * 1) * (x^2 + x + y) + ((!ismax) * 1) * (y^2 + x))
  }else{
    a <- ifelse(x > y, y, x)
    b <- ifelse(x > y, x, y)
    return(b^2 + a)
  }
  
}

dist_pairs$id <- pairing(as.integer(dist_pairs$from), as.integer(dist_pairs$to))
dist_pairs <- dist_pairs[!duplicated(dist_pairs$id),]

#dist_pairs$ODsame <- dist_pairs$from == dist_pairs$to
dist_pairs$imp_dist <- 1 - dist_pairs$dist / max(dist_pairs$dist)

# flow lsoa

#flow_lsoa_commute <- readRDS("D:/Users/earmmor/OneDrive - University of Leeds/Cycling Big Data/LSOA/LSOA_flow.Rds")
#flow_lsoa_commute <- flow_lsoa_commute[,c("lsoa1","lsoa2","all_16p","is_two_way")]

flow_lsoa_commute <- readr::read_csv("D:/Users/earmmor/OneDrive - University of Leeds/Cycling Big Data/LSOA/WM12EW[CT0489]_lsoa/WM12EW[CT0489]_lsoa.csv")
flow_lsoa_commute <- flow_lsoa_commute[,c("Area of usual residence","Area of Workplace","AllMethods_AllSexes_Age16Plus")]
names(flow_lsoa_commute) <- c("from","to","flow")

flow_lsoa_commute <- onewayid(flow_lsoa_commute, attrib = "flow")
#flow_lsoa_commute$ODsame <- flow_lsoa_commute$from == flow_lsoa_commute$to
flow_lsoa_commute$imp_commute <- flow_lsoa_commute$flow / max(flow_lsoa_commute$flow)
summary(flow_lsoa_commute$imp_commute)



# Join togther

od_all <- left_join(dist_pairs, flow_lsoa_commute, by = c("from","to"))

