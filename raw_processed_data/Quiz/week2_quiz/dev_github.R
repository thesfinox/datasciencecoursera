library(httr)
library(rjson)

# get OAuth settings
oauth_endpoints("github")
options(browser="firefox")

# authenticate
app <- oauth_app("github", key="95ad6f9d4493e8152825", secret="ef15f1c233fb633f26dd3cb6d640e69f0a3afb3d")
github_token <- oauth2.0_token(oauth_endpoints("github"), app)
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)
stop_for_status(req)
content <- content(req)

# read JSON
repo <- NULL
for(i in 1:length(content)) { if("datasharing" %in% content[[i]]$name) repo <- content[[i]] }
print(repo$created_at)

