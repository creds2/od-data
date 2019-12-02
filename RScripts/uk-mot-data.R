# aim: read-in UK MOT data

library(tidyverse)

system("head -10 '19029 Robin Lovelace MSOA.txt'")
d = readr::read_csv("19029 Robin Lovelace MSOA.txt")
ncol(d)
names(d)

d = d %>% 
  rename_all(snakecase::to_snake_case) 

d_bands = d %>% 
  group_by(yr, msoa) %>% 
  summarise_at(vars(new_band_a:unknown), sum)

d_bands

d_bands_yr = d_bands %>% 
  group_by(yr) %>% 
  summarise_at(vars(new_band_a:unknown), sum)

d_bands_yr_long = pivot_longer(d_bands_yr, cols = -yr, names_to = "Band")
d_bands_yr_long %>% 
  filter(str_detect(string = Band, pattern = "new_band_[a,b,c,d,e,m,l]")) %>% 
  ggplot() +
  geom_line(aes(yr, value, col = Band))
