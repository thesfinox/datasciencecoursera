# return the best hospital (lowest mortality rate) in a State
best <- function(state, outcome) {

    # read the csv file
    data <- read.csv("outcome-of-care-measures.csv",
                     stringsAsFactors = FALSE,
                     na.strings = "Not Available"
                    )
    
    # validate state
    if( !state %in% data$State ) { stop("invalid state") }
    data <- data[data$State == state,]

    # validate outcome
    selection <- NULL
    if( outcome == "heart attack" ) { selection <- "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack" }
    if( outcome == "heart failure" ) { selection <- "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure" }
    if( outcome == "pneumonia" ) { selection <- "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia" }
    if( is.null(selection) ) { stop("invalid outcome") }

    # output lowest mortality rate
    min_val     <- min(data[selection], na.rm = TRUE)
    desired_sel <- data[data[selection] == min_val & !is.na(data[selection]),]
    desired_sel[order(desired_sel$Hospital.Name),]$Hospital.Name
}
