#' loadRegimenlist function
#'
#' This is a function of loaded the Regimenlist
#'
#' @export loadRegimenlist
loadRegimenlist <- function(){
  path_Regimenlist <- system.file("csv", "Info_CohortDescription.csv", package = "RHEA")
  Regimenlist <-read.csv(path_Regimenlist,stringsAsFactors = F)
  return(Regimenlist)
}


