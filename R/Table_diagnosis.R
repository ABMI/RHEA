#' list of diagnosis
#'
#' @export sortDiagnosis
sortDiagnosis <- function(){
  sortTable <- Cohort %>%
    filter(CONDITION_CONCEPT_ID != 0) %>%
    group_by(CONDITION_CONCEPT_ID, CONCEPT_NAME) %>%
    summarise(n = n()) %>%
    arrange(desc(n))
  sortTable$percentage <- round(sortTable$n / length(Cohort$CONDITION_CONCEPT_ID) * 100,
                                digits = 3)
  sortTable <- data.frame(sortTable)

  return(sortTable)
}
