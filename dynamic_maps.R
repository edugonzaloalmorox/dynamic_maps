# Libraries

library(tidyverse)
library(sf)
library(viridis)
library(ggplot2)
library(gganimate)
library(readxl)
library(janitor)
library(knitr)
library(DT)





# Load the data -------------------



england = sf::read_sf("./data/geography/england_lad_2017/Local_Authority_Districts_December_2017_Ultra_Generalised_Clipped_Boundaries_in_United_Kingdom_WGS84.shp") %>% 
filter(str_detect(lad17cd, "^E0")) 





ageing = read_excel("data/raw/ons_uk_ageing.xls", sheet = "Old Age Dependency Ratio" ) %>%
clean_names() %>%
filter(str_detect(area_code, "^E0")) 


## Tidy the data -----------------



ageing = ageing %>%
gather(year, dependency, x1996:x2036, -area_code, -area_name) %>%
mutate(year = gsub("x", "", year)) %>%
arrange(area_code, year)



ageing = ageing %>%
mutate(quintile_dep = ntile(dependency, 7), 
lab_dep = as.factor(ordered(case_when(quintile_dep == 1 ~ "[81 - 218)", 
quintile_dep == 2 ~ "[218 - 250)", 
quintile_dep == 3 ~ "[250 - 283)",
quintile_dep == 4 ~ "[283 - 329)",
quintile_dep == 5 ~ "[329 - 392)", 
quintile_dep == 6 ~ "[392 - 478)", 
quintile_dep == 7 ~ "[478 - 928)")))) 


england_ext = full_join(england, ageing, by = c("lad17cd" = "area_code", "lad17nm" ="area_name") )

england_ext$quintile_dep = as.factor(england_ext$quintile_dep)

# Plot the data



england_ext %>%
filter(year == "2016") %>%
mutate(lab_dep = gsub("[[:alpha:]]", "", lab_dep)) %>%
rename(OADR = quintile_dep) %>%
ggplot(., aes(x = long, y = lat, fill = OADR)) + 
geom_sf(colour = alpha("grey", 1 /3), size = 0.2) +
coord_sf( datum = NA) +
scale_fill_viridis(option = "viridis",
labels = c("[81 - 218)", "[218 - 250)", "[250 - 283)", "[283 - 329)", "[329 - 392)", "[392 - 478)","[478 - 928)"),
alpha = 0.85, 
discrete = T, 
direction = -1)





plot_ageing = england_ext %>%
mutate(lab_dep = gsub("[[:alpha:]]", "", lab_dep)) %>%
rename(OADR = quintile_dep) %>%
ggplot(., aes(x = long, y = lat, fill = OADR)) + 
geom_sf(colour = alpha("grey", 1 /3), size = 0.2) +
coord_sf( datum = NA) +
scale_fill_viridis(option = "viridis",
labels = c("[81 - 218)", "[218 - 250)", "[250 - 283)", "[283 - 329)", "[329 - 392)", "[392 - 478)","[478 - 928)"),
alpha = 0.85, 
discrete = T, 
direction = -1, 
guide = guide_legend(
direction = "horizontal",
title.position = "top",
title.hjust =0.5)) +
facet_wrap(~ year, ncol = 3) +
theme(axis.text = element_blank()
,axis.title = element_blank()
,axis.ticks = element_blank()
,axis.line=element_blank()
,panel.grid = element_blank()
,legend.text = element_text(size = 10)
,legend.key.width = unit(0.35,"cm")
,legend.key.height = unit(0.35,"cm")
,plot.title = element_text(size= 6)
,legend.position = "bottom"
,plot.caption = element_text()
,legend.background = element_blank()
,panel.background = element_blank()
,legend.spacing.x = unit(0.25, 'cm')
,strip.text.x = element_text(size = 12)) 



### Animate the plot 


aniplot = england_ext %>%
mutate(lab_dep = gsub("[[:alpha:]]", "", lab_dep)) %>%
rename(OADR = quintile_dep) %>%
ggplot(., aes(x = long, y = lat, fill = OADR)) + 
geom_sf(colour = alpha("grey", 1 /3), size = 0.2) +
coord_sf( datum = NA) +
labs(title = "Old Age Dependency Ratio (OADR)",
subtitle = 'Year: {current_frame}') +
transition_manual(year) + 
scale_fill_viridis(option = "viridis",
labels = c("[81 - 218)", "[218 - 250)", "[250 - 283)", "[283 - 329)", "[329 - 392)", "[392 - 478)","[478 - 928)"),
alpha = 0.85, 
discrete = T, 
direction = -1, 
guide = guide_legend(
direction = "horizontal",
title.position = "top",
title.hjust =0.5)) +
theme(axis.text = element_blank()
,axis.title = element_blank()
,axis.ticks = element_blank()
,axis.line=element_blank()
,panel.grid = element_blank()
,legend.title = element_blank()
,legend.text = element_text(size = 14)
,legend.key.width = unit(0.35,"cm")
,legend.key.height = unit(0.5,"cm")
,plot.title = element_text(size= 22)
,plot.subtitle=element_text(size=18)
,legend.position = "bottom"
,plot.caption = element_text()
,legend.background = element_blank()
,panel.background = element_blank()
,legend.spacing.x = unit(0.25, 'cm'))






animate(aniplot, height = 1000, width = 1000)


