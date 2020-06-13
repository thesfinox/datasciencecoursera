# return the num-th best hospital per State
rankall <- function(outcome, num = "best") {

    # read the csv file
    data <- read.csv("outcome-of-care-measures.csv",
                     stringsAsFactors = FALSE,
                     na.strings = "Not Available"
                    )

    # source previous function
    source("rankhospital.R")
    
    # validate outcome
    selection <- NULL
    if( outcome == "heart attack" ) { selection <- "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack" }
    if( outcome == "heart failure" ) { selection <- "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure" }
    if( outcome == "pneumonia" ) { selection <- "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia" }
    if( is.null(selection) ) { stop("invalid outcome") }
    data <- data[!is.na(data[selection]),]

    # output best hospital per state
    lstates <- unique(data$State)
    output  <- NULL
    for( state in lstates[order(lstates)] ) {
        output <- rbind(output, c(state, rankhospital(state, outcome, num)))
    }
    colnames(output) <- c("state", "hospital")
    data_output <- data.frame(output)
    return(data_output)
}

