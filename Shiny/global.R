

######################################
# Packages 
######################################

library(bslib)
library(colourpicker)
library(data.table)
library(DT)
library(dplyr)
library(rAmCharts)
library(shiny)
library(tidyverse)
library(ggplot2)

######################################
# Data importation and preprocessing 
######################################

music <- fread("Data/musique.csv", sep=";", dec=".")

## FEATURES CLASS

#as.factor
music$artist_name = as.factor(music$artist_name)
music$track_name = as.factor(music$track_name)
music$instance_id = as.factor(music$instance_id)
music$mode = as.factor(music$mode)
music$obtained_date = as.factor(music$obtained_date)
music$music_genre = as.factor(music$music_genre)
music$key = as.factor(music$key)

#as.numeric
music$acousticness = as.numeric(music$acousticness)
music$instrumentalness = as.numeric(music$instrumentalness)
music$tempo=as.numeric(music$tempo)

## CLEANING 

music <- na.omit(music) # drop rows with NAs
music <- music[which(music$duration_ms>0)] # keep rows with positive durations_ms
music <- music[which(artist_name!="empty_field")] # remove rows 
music <- droplevels(music) # droplevels 

# remove duplicated lines with different popularity grades 
# we choose to keep the highest popularity grade

options(dplyr.summarise.inform = FALSE)
music <- music %>% dplyr::group_by(artist_name,track_name) %>%
  dplyr::summarise(instance_id = instance_id[which.max(popularity)],popularity = max(popularity)) %>% 
  dplyr::inner_join(music, music2, by = "instance_id", copy=FALSE, suffix = c("","."))


music <- as.data.frame(music)
musique <- music[,-(5:7)]

######################################
# Functions
######################################







