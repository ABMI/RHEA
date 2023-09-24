# RHEA: Real-world observational Health data Exploration Application
# The framework consists of two main parts.
# 1) Process to prepare data
# 2) process to represent it as an r shiny application.


###############
### LIBRARY ###
###############
# library for data preparation
library(data.table)
library(DatabaseConnector)
library(rjson)
library(purrr)
library(SqlRender)
library(dplyr)
library(highcharter)
library(listviewer)
library(tidyr)
library(tidyverse)
library(cli)
library(collapsibleTree)
library(DT)
library(fansi)
library(xfun)



# library for dashboard
library(lubridate)
library(ggplot2)
library(plyr)
library(RSQLite)
library(plotly)
library(quantmod)
library(data.table)
library(shiny)
library(shinyalert)
library(shinycssloaders)
library(shinydashboard)
library(shinythemes)
library(shinyWidgets)
library(summaryBox)
library(DT)
library(ggrepel)
library(gridExtra)
library(stringr)
library(dplyr)
library(xml2)
library(htmlwidgets)
library(RColorBrewer)
library(highcharter)


################
## DB connect ##
################
# Details for connectiong to the server
connectionDetails <- DatabaseConnector::createConnectionDetails(dbms= 'dbmd',
                                                                server='server',
                                                                user='user',
                                                                password='password',
                                                                port='port')
oracleTempSchema <- NULL
cdmDatabaseSchema <- "cdmDatabaseSchema"
cohortDatabaseSchema <- "cohortDatabaseSchema"
vocaDatabaseSchema <- cdmDatabaseSchema
oncologyDatabaseSchema <- cdmDatabaseSchema

#########################
## 1. data preparation ##
#########################
# 1) OMOP-CDM tables - COHORT, EPISODE, EPISODE_EVENT
# - The cohorts in this package are designed to work with Atlas.
atlasID <- 2087 # ATLAS Cohort Definition ID
cohortTable <- "cohortTable_name"
episodeTable <- "episodeTable_name"
episodeEventTable <- "episodeEventTable_name"


# 2) Treatment pathway
Graph_cohort <- "Graph_cohort_name"
outputFolder <- 'outputFolder pathway'
minSubject <- 0 # under 0 patients are removed from plot
collapseDates <- 0
treatmentLine <- 3 # Treatment line number for visualize in graph
minimumRegimenChange <- 1 # Target patients for at least 1 regimen change

# Draw and save a flow chart of the treatment pathway
executeExtraction(connectionDetails,
                  oracleTempSchema,
                  cdmDatabaseSchema,
                  vocaDatabaseSchema = cdmDatabaseSchema,
                  cohortDatabaseSchema,
                  oncologyDatabaseSchema= cdmDatabaseSchema,
                  cohortTable,
                  episodeTable,
                  episodeEventTable,
                  maxCores = 1,
                  # COHORT
                  createCohortTable = TRUE, # Create cohort table for your cohort table
                  # EPISODE, EPISODE_EVENT
                  createEpisodeAndEventTable = TRUE  # warning: existing table might be erased
                  )

# Load note report
BiopsyResult <- loadReportTable()

# Draw and save a flow chart of the treatment pathway
Txpathway(connectionDetails,
          oracleTempSchema,
          cdmDatabaseSchema,
          cohortDatabaseSchema,
          oncologyDatabaseSchema,
          vocaDatabaseSchema,
          cohortTable,
          Graph_cohort,
          episodeTable,
          outputFolder,
          identicalSeriesCriteria = 60,
          maximumCycleNumber = 18,
          minSubject = 0,
          collapseDates = 0,
          conditionCohortIds = atlasID,
          treatmentLine = 3,
          minimumRegimenChange = 1)


##################
## 2. Dashboard ##
##################

# Load Cohort table
Cohort <- loadCohortTable()

# Load Episode table
Episode <- loadEpisodTable()

# TNM stage code
TNMcode <- read.csv("./inst/csv/TNMcode.csv")

# TreatmentPathway figure
RegimenInfo <- loadRegimenlist()

# Calculation Patient care
PatientCareSummary <- calculation()

Antibiotics <- read.csv("./inst/csv/AntibioticsConcepts.csv")

connection <- DatabaseConnector::connect(connectionDetails = connectionDetails)

# 3. Run APP
runShinyApp()
