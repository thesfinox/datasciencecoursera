corr <- function(directory, threshold = 0) {

    files <- list.files(directory)
    cor   <- NULL

    for( file in files ) {

        data       <- read.csv(file.path(directory, file))
        data_compl <- data[complete.cases(data),]
        n_compl    <- nrow(data_compl)

        if(n_compl > threshold) {

            correlation <- cor(data_compl["sulfate"], data_compl["nitrate"])
            cor         <- c(cor, correlation)
        }
    }

    return(cor)
}
