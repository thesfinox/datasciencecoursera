complete <- function(directory, id = 1:332) {

    ids  <- NULL
    rows <- NULL

    for(i in id) {

        data          <- read.csv(file.path(directory,
                                            paste(formatC(i,
                                                          width = 3,
                                                          flag = "0"
                                                          ),
                                                  ".csv",
                                                  sep = "")
                                            )
        )
        complete_data <- data[complete.cases(data),]
        complete_rows <- nrow(complete_data)

        ids  <- c(ids, i)
        rows <- c(rows, complete_rows)
    }
    
    return(data.frame(id = ids, nobs = rows))
}
