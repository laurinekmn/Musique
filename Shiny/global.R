

######################################
# Packages 
######################################

library(bslib)
library(colourpicker)
library(data.table)
library(DT)
library(dplyr)
library(tidyverse)
library(ggplot2)
library(FactoMineR)
library(plotly)
library(rAmCharts)
library(readr)
library(shiny)


######################################
# Data importation and preprocessing 
######################################

# music <- fread("Data/musique.csv", sep=";", dec=".")
# 
# 
# dim0 <- dim(music)
dim0 <- c(50005, 18)
# 
# ## FEATURES CLASS
# 
# #as.factor
# music$artist_name = as.factor(music$artist_name)
# music$track_name = as.factor(music$track_name)
# music$instance_id = as.factor(music$instance_id)
# music$mode = as.factor(music$mode)
# music$obtained_date = as.factor(music$obtained_date)
# music$music_genre = as.factor(music$music_genre)
# music$key = as.factor(music$key)
# 
# #as.numeric
# music$acousticness = as.numeric(music$acousticness)
# music$instrumentalness = as.numeric(music$instrumentalness)
# music$tempo=as.numeric(music$tempo)
# 
# ## CLEANING 
# 
# music <- na.omit(music) # drop rows with NAs
# music <- music[which(music$duration_ms>0)] # keep rows with positive durations_ms
# music <- music[which(artist_name!="empty_field")] # remove rows 
# music <- droplevels(music) # droplevels 
# 
# # remove duplicated lines with different popularity grades 
# # we choose to keep the highest popularity grade
# 
# options(dplyr.summarise.inform = FALSE)
# music <- music %>% dplyr::group_by(artist_name,track_name) %>%
#   dplyr::summarise(instance_id = instance_id[which.max(popularity)],popularity = max(popularity)) %>% 
#   dplyr::inner_join(music, music2, by = "instance_id", copy=FALSE, suffix = c("","."))
# 
# 
# music <- as.data.frame(music)
# music <- music[,-(5:7)]
# write.csv(music, file = "Data/musique2.csv")

musique <- fread("Data/musique2.csv", sep=",")
musique <- musique[, -1]

#as.factor
musique$artist_name = as.factor(musique$artist_name)
musique$track_name = as.factor(musique$track_name)
musique$instance_id = as.factor(musique$instance_id)
musique$mode = as.factor(musique$mode)
musique$obtained_date = as.factor(musique$obtained_date)
musique$music_genre = as.factor(musique$music_genre)
musique$key = as.factor(musique$key)

#as.numeric
musique$acousticness = as.numeric(musique$acousticness)
musique$instrumentalness = as.numeric(musique$instrumentalness)
musique$tempo=as.numeric(musique$tempo)

dim1 <- dim(musique)


## CSV file with info about dataset features

tabfeat <- fread("Data/features_info.csv", sep=";")

best_model_prediction <- lm(popularity ~ acousticness + danceability + duration_ms + energy + instrumentalness + liveness + loudness + speechiness + tempo + valence + acousticness:music_genre + danceability:music_genre + duration_ms:music_genre + energy:music_genre + instrumentalness:music_genre + liveness:music_genre + loudness:music_genre + speechiness:music_genre + tempo:music_genre + valence:music_genre, data = musique)


######################################
# Functions
######################################







