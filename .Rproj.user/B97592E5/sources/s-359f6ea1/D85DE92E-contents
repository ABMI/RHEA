# Copyright 2020 Observational Health Data Sciences and Informatics
#
# This file is part of CancerTxPathway
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#' sankey for regimen and surgery
#' Visualization tool for sankey for regimen and surgery
#' @param connectionDetails
#' @param cohortDatabaseSchema
#' @param minimumRegimenChange
#' @param treatmentLine
#' @param collapseDates
#' @param standardCycle
#' @param minSubject
#' @param outputFolder
#' @param outputFileTitle
#' @param cohortDescript
#' @keywords sankey
#' @return sankey for regimen with other evnets
#' @examples
#' @import dplyr
#' @import networkD3
#' @export treatmentPathway
treatmentPathway<-function(connection,
                           cohortDatabaseSchema,
                           current_data,
                           outputFolder,
                           cohortDescript,
                           minimumRegimenChange = 1,
                           treatmentLine = 3,
                           collapseDates = 0,
                           minSubject = 0,
                           i
){
  ##Treatment cohort##
  current_data <- current_data %>% subset(cycle == 1)
  cohortData <- current_data %>% select(-cohortName, -cycle)
  cohortData$cohortStartDate<-as.Date(cohortData$cohortStartDate)
  cohortData$cohortEndDate<-as.Date(cohortData$cohortEndDate)
  cohortData <- as.data.frame(cohortData)
  cohortDescript <- as.data.frame(cohortDescript)
  cohortData <- dplyr::left_join(cohortData, cohortDescript,
                                 by= c("cohortDefinitionId"="cohortDefinitionId"))

  # Add Surgery
  cohort_ids <- cohortData$subjectId
  surgeryids <- cohortDescript %>% filter(type == "Surgery")
  surgeryids <- surgeryids$conceptId

  sql_surgery <- 'SELECT person_id, procedure_concept_id, procedure_date
          FROM @oncology_database_schema.procedure_occurrence
          WHERE person_id in (@cohort_ids) and procedure_concept_id in (@surgery_ids)'

  sql_surgery <- SqlRender::render(sql_surgery,
                                   oncology_database_schema = oncologyDatabaseSchema,
                                   cohort_ids = paste(cohort_ids, collapse=","),
                                   surgery_ids = paste(surgeryids, collapse=","))
  surgeryRecords <- DatabaseConnector::querySql(connection, sql_surgery)
  surgeryRecords <- dplyr::left_join(surgeryRecords, cohortDescript,
                                    by = c("PROCEDURE_CONCEPT_ID" = "conceptId"))

  surgeryRecords$cohortEndDate <- surgeryRecords$PROCEDURE_DATE
  surgeryCohort <- surgeryRecords %>%
    rename(subjectId = PERSON_ID,
           cohortStartDate = PROCEDURE_DATE,
           conceptId= PROCEDURE_CONCEPT_ID) %>%
    select(cohortDefinitionId, subjectId, cohortStartDate, cohortEndDate, cohortName, type, conceptId)

  cohortData <- rbind(cohortData, surgeryCohort) %>% arrange(subjectId)

  ##Ignore the change to same regimen##
  cohortData <- cohortData %>%
    arrange(subjectId, cohortStartDate) %>%
    group_by(subjectId) %>%
    mutate(lagCDI = lag(cohortName)) %>%
    subset(is.na(lagCDI)|lagCDI != cohortName) %>%
    select(-lagCDI)
  cohortData <- as.data.frame(cohortData)

  ##Bind event and target cohort, Ignore duplicated event records##
  eventAndTarget <- cohortData %>%
    arrange(subjectId, cohortStartDate) %>%
    group_by(subjectId) %>%
    mutate(lagCDI = lag(cohortName)) %>%
    subset(is.na(lagCDI)|lagCDI != cohortName) %>%
    select(-lagCDI) %>%
    ungroup()
  eventAndTarget$cohortName <- as.character(eventAndTarget$cohortName)
  eventAndTarget <- as.data.frame(eventAndTarget)

  ##If regimens apart from each other less than collapseDates, collapse using '/'##
  collapsedRecords <- data.table::rbindlist(lapply(unique(eventAndTarget$subjectId),
                                                   function(targetSubjectId){
    reconstructedRecords <- data.frame()
    targeteventAndTarget <- eventAndTarget %>% subset(subjectId == targetSubjectId)
    reconstructedRecords <- rbind(reconstructedRecords,targeteventAndTarget[1,])

    if(nrow(targeteventAndTarget)>=2){
      for(x in 2:nrow(targeteventAndTarget)){
        if(as.integer(targeteventAndTarget[x, 3]-reconstructedRecords[nrow(reconstructedRecords), 3])>collapseDates){
          reconstructedRecords <- rbind(reconstructedRecords,
                                        targeteventAndTarget[x,])
          }else{sortNames <- sort(c(targeteventAndTarget[x,5],
                                    reconstructedRecords[nrow(reconstructedRecords),5]))
          reconstructedRecords[nrow(reconstructedRecords),5]<-paste0(sortNames,collapse = '/')
          }}}
    return(reconstructedRecords)}))

  ##Set minimum regimen change count##
  eventAndTarget <- collapsedRecords
  minimunIndexId <- unique(eventAndTarget %>%
                             arrange(subjectId,cohortStartDate) %>%
                             group_by(subjectId) %>%
                             mutate(line = row_number()) %>%
                             subset(line >= minimumRegimenChange+1) %>%
                             select(subjectId) %>%
                             ungroup())
  eventAndTarget <- eventAndTarget %>%
    subset(subjectId %in% minimunIndexId$subjectId) %>%
    arrange(subjectId, cohortStartDate)

  ##Maximum treatment line in graph##
  eventAndTarget <- eventAndTarget %>%
    group_by(subjectId) %>%
    arrange(subjectId, cohortStartDate) %>%
    mutate(rowNumber = row_number()) %>%
    subset(rowNumber <= treatmentLine) %>%
    select(subjectId, cohortName, rowNumber) %>%
    mutate(nameOfConcept = paste0(rowNumber,'_',cohortName)) %>%
    ungroup()

  ##Label##
  label <- unique(eventAndTarget %>% select(cohortName,nameOfConcept) %>% arrange(nameOfConcept))
  label <- label %>% mutate(num = seq(from = 0,length.out = nrow(label)))

  ##Nodes##
  treatmentRatio <- data.table::rbindlist(lapply(1:treatmentLine,
                                                 function(x){
                                                   eventAndTarget %>%
                                                     subset(rowNumber==x) %>%
                                                     group_by(nameOfConcept) %>%
                                                     summarise(n=n()) %>%
                                                     mutate(ratio=round(n/sum(n)*100,1))}))
  treatmentRatio <- treatmentRatio %>% subset(n>=minSubject)
  label <- dplyr::left_join(treatmentRatio,
                            label,
                            by=c("nameOfConcept"="nameOfConcept")) %>%
    mutate(name = paste0(cohortName,' (n=',n,', ',ratio,'%)'))
  label <- label %>% mutate(num = seq(from = 0, length.out = nrow(label)))
  nodes <- label %>% select(name)
  nodes <- data.frame(nodes)

  ##Pivot table##
  pivotRecords <- reshape2::dcast(eventAndTarget,subjectId ~ rowNumber, value.var="nameOfConcept")

  ##Link##
  link <- data.table::rbindlist(lapply(2:max(eventAndTarget$rowNumber),
                                       function(x){
    source <- pivotRecords[,x]
    target <- pivotRecords[,x+1]
    link <- data.frame(source,target)
    link$source <- as.character(link$source)
    link$target <- as.character(link$target)
    link <- na.omit(link)
    return(link)}))

  link$source <- as.character(link$source)
  link$target <- as.character(link$target)
  link <- link %>%
    select(source, target) %>%
    group_by(source, target) %>%
    summarise(n=n()) %>%
    ungroup()

  source <- dplyr::left_join(link, label, by = c("source" = "nameOfConcept")) %>% select(num)
  target <- dplyr::left_join(link, label, by = c("target" = "nameOfConcept")) %>% select(num)
  freq <- link %>% select(n)
  links <- data.frame(source,target,freq)
  links <- na.omit(links)
  colnames(links) <- c('source','target','value')
  links$source <- as.integer(links$source)
  links$target <- as.integer(links$target)
  links$value <- as.numeric(links$value)

  ##Sankey data##
  if(!is.null(outputFolder)){
    fileNameNodes <- paste0("RHEA_stage", i, '_','SankeyNodes.csv')
    write.csv(nodes, file.path(outputFolder, fileNameNodes),row.names = F)
    fileNameLinks <- paste0("RHEA_stage", i, '_','SankeyLinks.csv')
    write.csv(links, file.path(outputFolder, fileNameLinks),row.names = F)}

  treatment <-list(nodes=nodes, links=links)
  treatmentPathway <- networkD3::sankeyNetwork(Links = treatment$links,
                                               Nodes = treatment$nodes,
                                               Source = "source",
                                               Target = "target",
                                               Value = "value",
                                               NodeID = "name",
                                               fontSize = 17,
                                               nodeWidth = 20,
                                               sinksRight = FALSE)
  return(treatmentPathway)
}

