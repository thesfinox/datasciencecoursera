# return the num-th best hospital in a State
rankhospital <- function(state, outcome, num = "best") {

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
    data <- data[!is.na(data[selection]),]

    # output ordered data frame
    output <- data[order(data[selection], data$Hospital.Name),]$Hospital.Name
    if( num == "best" ) { return(output[1]) }
    if( num == "worst" ) { return(output[length(output)]) }
    return(output[num])
}
