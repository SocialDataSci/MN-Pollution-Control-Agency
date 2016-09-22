# install packages and connect to the ACS  api
install.packages ('leaflet')
install.packages ('acs')
install.packages('dplyr')
library(leaflet)
library(acs)
library(dplyr)
api_key = 'fd03623f08e6dad5ec49d40d699ee55ab4429cc4'
acs::api.key.install(key = api_key)

# How to look up which tables to bring in. Find table numbers from metadata excel file

acs.lookup(2014, span =5, dataset = "acs", table.number = "B01002")

# Bring in data by Urban Area

census_data <- 
  acs::acs.fetch(
    endyear = 2014,
    span = 5,
    geography = acs::geo.make(
      urban.area = '*'
    ),
    variable = c('B19013_001','B01002_001', 'B19080_001', 'B19080_002','B19080_003', 'B19080_004', 'B02001_001', 'B02001_002', 'B03003_003', 'B02001_003', 'B02001_005', 'B02001_008', 'C15010_001', "B23025_005", "B23025_007", "B19083_001", "B25064_001")
  )


#Create data frame
demographic <-
  dplyr::data_frame(
    STATEFP = census_data@geography$NAME,
    UrbanAreaNo = census_data@geography$urbanarea,
    income = census_data@estimate %>% data.frame %>% .[,1],
    age = census_data@estimate %>% data.frame %>% .[,2],
    income.LowestQuintile = census_data@estimate %>% data.frame %>% .[,3],
    income.SecondQuintile = census_data@estimate %>% data.frame %>% .[,4],
    income.ThirdQuintile = census_data@estimate %>% data.frame %>% .[,5],
    income.FourthQuintile = census_data@estimate %>% data.frame %>% .[,6],
    pop = census_data@estimate %>% data.frame %>% .[,7],
    white = census_data@estimate %>% data.frame %>% .[,8],
    hispanic = census_data@estimate %>% data.frame %>% .[,9],
    africanamerican = census_data@estimate %>% data.frame %>% .[,10],
    asian = census_data@estimate %>% data.frame %>% .[,11],
    twoormoreraces = census_data@estimate %>% data.frame %>% .[,12],
    educated = census_data@estimate %>% data.frame %>% .[,13],
    unemployed = census_data@estimate %>% data.frame %>% .[,14],
    notworkforce = census_data@estimate %>% data.frame %>% .[,15],
    gini = census_data@estimate %>% data.frame %>% .[,16],
    rent = census_data@estimate %>% data.frame %>% .[,17]

    #Clean Data       
  ) %>%
  dplyr::mutate(
    STATEFP = gsub("\\(2010\\)", "", STATEFP),
    STATEFP = gsub(" Urban Cluster ", "", STATEFP),
    STATEFP = gsub(" Urbanized Area ", "", STATEFP),
    State =      gsub("^.*\\,", "", STATEFP),
    UrbanArea =  gsub(",.*", "",STATEFP),
    pct_white = white/pop,
    pct_africanamerican = africanamerican/pop,
    pct_asian = asian /pop,
    pct_hispanic = hispanic/pop,
    pct_twoormoreraces = twoormoreraces /pop,
    pct_highed = educated/pop,
    pct_unem = unemployed/(pop-notworkforce)
  ) 


#Write CSV 
install.packages("readr")
load("readr")
write.csv(demographic, file = "demographic.csv")



