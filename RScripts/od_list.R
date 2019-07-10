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

szudzik_pairing <- function(x, id1 = names(x)[1], id2 = names(x)[2], ordermatters = FALSE, simple = FALSE) {
  val1 <- x[id1]
  val2 <- x[id2]
  lvls <- unique(c(val1, val2))
  val1 <- as.integer(factor(val1, levels = lvls))
  val2 <- as.integer(factor(val2, levels = lvls))
  if(ordermatters){
    ismax <- val1 > val2
    stplanr.key <- (ismax * 1) * (val1^2 + val1 + val2) + ((!ismax) * 1) * (val2^2 + val1)
  }else{
    a <- ifelse(val1 > val2, val2, val1)
    b <- ifelse(val1 > val2, val1, val2)
    stplanr.key <- b^2 + a
  }
  if(simple){
    return(stplanr.key)
  }else{
    return(data.frame(stplanr.id1 = x[,id1],
                      stplanr.id2 = x[,id2],
                      stplanr.key = stplanr.key))
  }
  
  
}

dist_pairs$id <- pairing(as.integer(dist_pairs$from), as.integer(dist_pairs$to))
dist_pairs <- dist_pairs[!duplicated(dist_pairs$id),]
dist_pairs$imp_dist <- 1 - dist_pairs$dist / max(dist_pairs$dist)
dist_pairs <- dist_pairs[,c("from","to","imp_dist")]

# flow lsoa commute

flow_lsoa_commute <- readr::read_csv("D:/Users/earmmor/OneDrive - University of Leeds/Cycling Big Data/LSOA/WM12EW[CT0489]_lsoa/WM12EW[CT0489]_lsoa.csv")
flow_lsoa_commute <- flow_lsoa_commute[,c("Area of usual residence","Area of Workplace","AllMethods_AllSexes_Age16Plus")]
names(flow_lsoa_commute) <- c("from","to","flow")
flow_lsoa_commute <- flow_lsoa_commute[flow_lsoa_commute$from != flow_lsoa_commute$to,]
flow_lsoa_commute$from <- as.character(flow_lsoa_commute$from)
flow_lsoa_commute$to <- as.character(flow_lsoa_commute$to)
flow_lsoa_commute <- as.data.frame(flow_lsoa_commute)
#x = flow_lsoa_commute[1:100,]
flow_lsoa_commute$key <- szudzik_pairing(flow_lsoa_commute, simple = TRUE)
flow_lsoa_commute <- flow_lsoa_commute %>%
  group_by(key) %>%
  summarise(from = first(from),
            to = first(to),
            is_two_way = n() - 1,
            flow = sum(flow))

flow_lsoa_commute$imp_commute <- flow_lsoa_commute$flow / max(flow_lsoa_commute$flow)
summary(flow_lsoa_commute$imp_commute)
flow_lsoa_commute <- flow_lsoa_commute[,c("from","to","imp_commute")]

# Join togther
od_all <- left_join(dist_pairs, flow_lsoa_commute, by = c("from","to"))
rm(dist_pairs, flow_lsoa_commute)
od_all$imp_commute[is.na(od_all$imp_commute)] <- 0
od_all$from <- as.factor(od_all$from)
od_all$to <- as.factor(od_all$to)
od_all$imp_all <- od_all$imp_commute + od_all$imp_dist
od_all <- od_all[order(od_all$imp_all, decreasing = TRUE), ]
saveRDS(od_all,"data/lsoa_od_all.Rds")
