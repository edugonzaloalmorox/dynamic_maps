# Dynamic maps

This repository shows the code and steps for creating dynamic maps with `gganimate()`. The analysis consists of three main steps:

  - Extract and clean the data
  - Link with geographical data
  - Produce the map
  
It is composed by the data and the code to produce the maps. Information is referred to the spending power of local authorities in England. 

### The dataset

First step consists of loading the dataset to fill the map. Information is obtained from the Financial Settlement released by the Governement and Social Communities. There are several variables that may be interesting. I use the revenue percentage change. Loading the data is done with the following code 

```
spending = read_csv("data/processed/) %>%
kable()

```

### Creating variables of interest

It is not the same a 1% change than a 27% or a -1% than 10%. To capture significant changes I use the first and last quintile of the distribution. I use `dplyr::ntile()` to create positive and negative changes in the spending power. 




