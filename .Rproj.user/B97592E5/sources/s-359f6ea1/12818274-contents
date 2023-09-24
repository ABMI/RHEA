#' Drawing proportion graph
#'
#' @param Cohort
#'
#' @export sexProportionGraph
sexProportionGraph <- function(){
  tempSex <- Cohort %>% distinct(SUBJECT_ID, GENDER_SOURCE_VALUE)
  sexProportion <- plot_ly(tempSex, labels = ~GENDER_SOURCE_VALUE, type = 'pie',
                           textposition = 'inside',
                           textinfo = 'label+percent',
                           insidetextfont = list(color = '#FFFFFF'),
                           showlegend = F
                           ) %>%
    add_trace(
      marker = list(colors = case_when(
        tempSex$GENDER_SOURCE_VALUE == "Female" ~ "#FF7F0E",
        tempSex$GENDER_SOURCE_VALUE == "Male" ~ "#1F77B4",
        TRUE ~ "#AAAAAA"  # 다른 값에 대한 색상 지정
      ))
    )
  return(sexProportion)
}

#' @export ageProportionGraph
ageProportionGraph <- function(){
  tempAge <- Cohort %>%
    distinct(SUBJECT_ID, GENDER_SOURCE_VALUE, ageGroup) %>%
    select(GENDER_SOURCE_VALUE, ageGroup) %>%
    group_by(GENDER_SOURCE_VALUE, ageGroup) %>%
    summarise(n=n())
  tempAge <- rename(tempAge, gender = GENDER_SOURCE_VALUE)
  tempAge <- tempAge %>% mutate(percentage = round(n/sum(n) * 100, digits = 2))

  temptext <- Cohort %>% distinct(SUBJECT_ID, ageGroup) %>%
    select(ageGroup) %>%
    group_by(ageGroup) %>%
    summarise(n=n())
  temptext <- temptext %>% mutate(percentage = round(n/sum(n) * 100, digits = 2))
  temptext <- temptext %>% mutate(total = paste0(n, ' (', percentage, '%)'))


  ageProportion <- plot_ly(tempAge, x = ~ageGroup, y = ~n,
                           color = ~gender,
                           text = ~paste0('ageGroup: ', ageGroup, '\n ', n, ' (', percentage, '%)'),
                           textposition = 'inside',
                           hoverinfo = 'text',
                           colors = c("#FF7F0E", "#1F77B4"),
                           type = 'bar') %>%
    layout(xaxis = list(title = ''),
           yaxis = list(title = 'Count', tickformat = "digits"),
           barmode = 'stack',
           legend = list(x = 0.5, xanchor = "center", yanchor = "top", orientation = "h")) %>%
    add_annotations(text =  ~temptext$total,
                    textposition = 'outside',
                    x = temptext$ageGroup,
                    y = temptext$n)

  return(ageProportion)
}

#' @export convert_code_to_numeric
# 코드를 숫자로 변환하는 함수 정의
convert_code_to_numeric <- function(code) {
  str_extract_all(code, "\\d+") %>% unlist() %>% as.numeric()
}

#' @export TGraph
TGraph <- function(target){
  Tis <- convert_code_to_numeric(TNMcode$code[1])
  T1 <- convert_code_to_numeric(TNMcode$code[2])
  T2 <- convert_code_to_numeric(TNMcode$code[3])
  T3 <- convert_code_to_numeric(TNMcode$code[4])
  T4 <- convert_code_to_numeric(TNMcode$code[5])

  # T stage cohort
  tempTis <- target %>%
    filter(VALUE_AS_CONCEPT_ID %in% Tis) %>%
    distinct(SUBJECT_ID, MEASUREMENT_SOURCE_VALUE) %>%
    mutate(TNMstage = "Tis")

  tempT1 <- target %>%
    filter(VALUE_AS_CONCEPT_ID %in% T1) %>%
    distinct(SUBJECT_ID, MEASUREMENT_SOURCE_VALUE) %>%
    mutate(TNMstage = "T1")

  tempT2 <- target %>%
    filter(VALUE_AS_CONCEPT_ID %in% T2) %>%
    distinct(SUBJECT_ID, MEASUREMENT_SOURCE_VALUE) %>%
    mutate(TNMstage = "T2")

  tempT3 <- target %>%
    filter(VALUE_AS_CONCEPT_ID %in% T3) %>%
    distinct(SUBJECT_ID, MEASUREMENT_SOURCE_VALUE) %>%
    mutate(TNMstage = "T3")

  tempT4 <- target %>%
    filter(VALUE_AS_CONCEPT_ID %in% T4) %>%
    distinct(SUBJECT_ID, MEASUREMENT_SOURCE_VALUE) %>%
    mutate(TNMstage = "T4")

  totalTstage <- rbind(tempT1, tempT2, tempT3, tempT4)

  T_color_palette <- c('Tis' = '#72A4A8', 'T1' = '#93C6EA', 'T2' = '#84ADE0', 'T3' = '#4577BD', 'T4' = '#21598A')

  # TNMstage 값에 따른 색상 할당
  totalTstage$color <- T_color_palette[totalTstage$TNMstage]

  # 그래프 생성
  ProportionT <- plot_ly(totalTstage, labels = ~TNMstage, type = 'pie',
                         textposition = 'inside',
                         textinfo = 'label+percent',
                         insidetextfont = list(color = 'black'),
                         marker = list(line = list(color = '#FFFFFF', width = 1),
                                       colors = totalTstage$color),  # color 열을 색상으로 사용
                         showlegend = FALSE) %>%
    layout(title = paste("T stage", "(n =", n_distinct(totalTstage$SUBJECT_ID), ", ",
                         round(n_distinct(totalTstage$SUBJECT_ID)/n_distinct(target$SUBJECT_ID)*100,
                               digits = 2), "%)"))
  return(ProportionT)
}

#' @export NGraph
NGraph <- function(target){
  N0 <- convert_code_to_numeric(TNMcode$code[6])
  N1 <- convert_code_to_numeric(TNMcode$code[7])
  N2 <- convert_code_to_numeric(TNMcode$code[8])
  N3 <- convert_code_to_numeric(TNMcode$code[9])

  # N stage cohort
  tempN0 <- target %>%
    filter(VALUE_AS_CONCEPT_ID %in% N0) %>%
    distinct(SUBJECT_ID, MEASUREMENT_SOURCE_VALUE) %>%
    mutate(TNMstage = "N0")

  tempN1 <- target %>%
    filter(VALUE_AS_CONCEPT_ID %in% N1) %>%
    distinct(SUBJECT_ID, MEASUREMENT_SOURCE_VALUE) %>%
    mutate(TNMstage = "N1")

  tempN2 <- target %>%
    filter(VALUE_AS_CONCEPT_ID %in% N2) %>%
    distinct(SUBJECT_ID, MEASUREMENT_SOURCE_VALUE) %>%
    mutate(TNMstage = "N2")

  tempN3 <- target %>%
    filter(VALUE_AS_CONCEPT_ID %in% N3) %>%
    distinct(SUBJECT_ID, MEASUREMENT_SOURCE_VALUE) %>%
    mutate(TNMstage = "N3")


  totalNstage <- rbind(tempN0, tempN1, tempN2, tempN3)

  N_color_palette <- c('N0' = '#81B18C', 'N1' = '#6F944D', 'N2' = '#3D6B2E', 'N3' = '#005222')

  # TNMstage 값에 따른 색상 할당
  totalNstage$color <- N_color_palette[totalNstage$TNMstage]

  # N stage graph
  ProportionN <- plot_ly(totalNstage, labels = ~TNMstage, type = 'pie',
                         textposition = 'inside',
                         textinfo = 'label+percent',
                         insidetextfont = list(color = 'black'),
                         marker = list(line = list(color = '#FFFFFF', width = 1),
                                       colors = totalNstage$color),  # color 열을 색상으로 사용
                         showlegend = FALSE) %>%
    layout(title = paste("N stage", "(n =", n_distinct(totalNstage$SUBJECT_ID), ", ",
                         round(n_distinct(totalNstage$SUBJECT_ID)/n_distinct(target$SUBJECT_ID)*100,
                               digits = 2), "%)"))
  return(ProportionN)
}

#' @export MGraph
MGraph <- function(target){
  M0 <- convert_code_to_numeric(TNMcode$code[10])
  M1 <- convert_code_to_numeric(TNMcode$code[11])

  # M stage cohort
  tempM0 <- target %>%
    filter(VALUE_AS_CONCEPT_ID %in% M0) %>%
    distinct(SUBJECT_ID, MEASUREMENT_SOURCE_VALUE) %>%
    mutate(TNMstage = "M0")

  tempM1 <- target %>%
    filter(VALUE_AS_CONCEPT_ID %in% M1) %>%
    distinct(SUBJECT_ID, MEASUREMENT_SOURCE_VALUE) %>%
    mutate(TNMstage = "M1")

  totalMstage <- rbind(tempM0, tempM1)

  # M stage graph
  ProportionM <- plot_ly(totalMstage, labels = ~TNMstage, type = 'pie',
                         textposition = 'inside',
                         textinfo = 'label+percent',
                         insidetextfont = list(color = 'black'),
                         marker = list(line = list(color = '#FFFFFF', width = 1)),
                         showlegend = FALSE) %>%
    layout(title = paste("M stage", "(n =", n_distinct(totalMstage$SUBJECT_ID), ", ",
                         round(n_distinct(totalMstage$SUBJECT_ID)/n_distinct(target$SUBJECT_ID)*100,
                               digits = 2), "%)"),
           colorway = c("#C7C6C4","#E67452"))
  return(ProportionM)
}
