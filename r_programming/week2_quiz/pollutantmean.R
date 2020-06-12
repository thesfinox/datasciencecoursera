pollutantmean <- function(directory, pollutant, id = 1:332) {

    files <- file.path(directory, paste(formatC(id, width = 3, flag = "0"), ".csv", sep = ""))
    tot_sum <- 0
    tot_row <- 0
    for( file in files ) {
        data     <- read.csv(file)
        data_col <- data[!is.na(data[pollutant]),][pollutant]
        rows     <- nrow(data_col) 

        if(rows == 0) { next }
        tot_sum  <- tot_sum + sum(data_col)
        tot_row  <- tot_row + rows
    }

    if(tot_row > 0) { return(tot_sum / tot_row) }
    else { return(0) }
}
