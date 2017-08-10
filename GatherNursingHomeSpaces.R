################
#Download data to the care technology project
#Henning Øien
#Sykehjemsplasser
#
##############

#Clear workspace
rm(list = ls())

#Packages needed to collect data through SSB api
#For more information see: http://data.ssb.no/api

library(rjstat)
library(mosaic)
library(httr)

#Getting data from the following table: 
#07790: F1. Konsern - Pleie og omsorg - grunnlagsdata (K) 1999 - 2016
#See "http://www.ssb.no/tabell/07790"

url <- "http://data.ssb.no/api/v0/no/table/07790"

#The following variables are in the table

#1 Region
#2 ContentsCode
#3 Tid

# Defining the variables I need

## I include all municipalities (an alternative is to use all)

region <- '{ "code": "Region",
"selection": {  "filter": "item", "values": [/*Østfold*/"0101","0104",
"0105", "0106"], "valueTexts":["Halden", "Moss", "Sarpsborg"], "elimination": true}}'

## Here I include plasser i institusjon korrigert for utleie

content <- '{
  "code": "ContentsCode",
"selection": {
"filter": "item",
"values": ["CRC27802820"]  }
}'

##I include all time periods

tid <- '{
  "code": "Tid",
"selection": {
"filter": "all",
"values": ["*"]
}  
}'

##The data format

format<-'"response":{"format":"json-stat"}'

###Alle calls are written in this format: {query:[{variables}]format}

#I use the paste function to make a string of all the content

variables<-paste(region, content, tid, sep = ",")
variables<-paste0("[", variables, "]")
variables<-paste(variables, format, sep = ",")

data<-paste0("{", "query:", variables, "}")

#Make the call

temp <- POST(url , body = data, encode = "json", verbose())

#Make a table and data frame of table

table <- fromJSONstat(content(temp, "text")) #naming = "id"

NursingSpaces <- table[[1]]
View(NursingSpaces)

write.csv(NursingSpaces, file = "NursingSpaces.csv")

#Testing the test branch




