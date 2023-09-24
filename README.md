# RHEA
 Real-world observaional Health data Exploration Application (RHEA)

Introduction
==========
RHEA provides a process for creating a data exploration system focus on patient with cancer from a medical database in OMOP-CDM format.

Technology
==========
RHEA is an R package codes for process of the study.

Dependencies
============
install.package(data.table)

install.package(DatabaseConnector)

install.package(rjson)

install.package(purrr)

install.package(SqlRender)

install.package(dplyr)

install.package(highcharter)

install.package(listviewer)

install.package(tidyr)

install.package(tidyverse)

install.package(cli)

install.package(collapsibleTree)

install.package(DT)

install.package(fansi)

install.package(xfun)

install.package(lubridate)

install.package(ggplot2)

install.package(plyr)

install.package(RSQLite)

install.package(plotly)

install.package(quantmod)

install.package(shiny)

install.package(shinyalert)

install.package(shinycssloaders)

install.package(shinydashboard)

install.package(shinythemes)

install.package(shinyWidgets)

install.package(summaryBox)

install.package(ggrepel)

install.package(gridExtra)

install.package(stringr)

install.package(xml2)

install.package(htmlwidgets)

install.package(RColorBrewer)

Getting started
============
In R, use the following commands to download and install:
install.packages("devtools")
devtools::install_github("ABMI/RHEA")
library(RHEA)

```r
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
```

License
=======
  RHEA is licensed under Apache License 2.0

Development
===========
  RHEA is being developed in R Studio.
