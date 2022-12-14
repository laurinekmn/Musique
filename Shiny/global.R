
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

music <- fread("Data/musique.csv", sep=";", dec=".")


dim0 <- dim(music)


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


dim1 <- dim(musique)

## CSV file with info about dataset features

tabfeat <- fread("Data/features_info.csv", sep=";")

## Subset: 10% of each music_genre  (used in FAMD tab) 

subset <- musique %>% 
  group_by(music_genre) %>%
  sample_frac(size = 0.10, replace = FALSE)


######################################
# Functions
######################################


# returns the id of a song when given the name of the song and of the artist
song_id <- function(track, artist){
  S = subset[subset$artist_name == artist,]
  S = subset[subset$track_name== track,]
  S <- as.data.frame(S)
  id = as.character(S[1,3])
  
  return(id)
}


# returns euclidian distance between two songs
eucl_dist <- function(id1, id2, coord.tmp){
  c1 <- coord.tmp[which(coord.tmp$id == id1),]
  c1[2:5] <- as.numeric(c1[2:5])
  c2 <- coord.tmp[which(coord.tmp$id == id2),]
  c2[2:5] <- as.numeric(c2[2:5])
  dist <- sqrt(
    (c2$Dim.1-c1$Dim.1)^2
    +(c2$Dim.2-c1$Dim.2)^2
    +(c2$Dim.3-c1$Dim.3)^2
    +(c2$Dim.4-c1$Dim.4)^2
  )
  
  return(dist)

}

