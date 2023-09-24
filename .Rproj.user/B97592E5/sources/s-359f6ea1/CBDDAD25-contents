#' Create Episode / Episode_event table

#' @param connection
#' @param oracleTempSchema
#' @param oncologyDatabaseSchema
#' @param episodeTable
#' @param episodeEventTable

#' @export
createEpisodeTables <- function(connection,
                                oracleTempSchema,
                                oncologyDatabaseSchema,
                                episodeTable,
                                episodeEventTable
){
  # Create Episode and Episode_event
  ParallelLogger::logInfo("Create Episode table and Episode_event table")
  sql <- SqlRender::loadRenderTranslateSql(sqlFilename= "CreateEpisodeTables.sql",
                                           packageName = "RHEA",
                                           dbms = attr(connection,"dbms"),
                                           oracleTempSchema = NULL,
                                           oncology_database_schema = oncologyDatabaseSchema,
                                           episode_table = episodeTable,
                                           episode_event_table = episodeEventTable)
  DatabaseConnector::executeSql(connection, sql, progressBar = TRUE, reportOverallTime = TRUE)

}
