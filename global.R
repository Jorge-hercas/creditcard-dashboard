
library(shiny)
library(dplyr)
library(echarts4r)
library(lubridate)
library(shinyWidgets)
library(particlesjs)
library(shinythemes)
library(reactable)
library(reactablefmtr)

df <- readxl::read_excel("data/BA_Take_Home_Assessment_Data.xlsx")

df$`Date of Transaction` <- as.Date(df$`Date of Transaction`)

df$`Commerce of Transaction`[is.na(df$`Commerce of Transaction`)] <- "Another commerce"
dates <- 
  df |> 
  select(`Date of Transaction`) |> 
  arrange(`Date of Transaction`) |> 
  unique()

df <- 
df |> 
  mutate(
    day_of_w = weekdays(`Date of Transaction`)
  )





