# Install gh package
devtools::install_github("r-lib/gh")
devtools::install_github("hadley/purrr")


library(dplyr)
library(gh)
library(purrr)
my_repos <- gh("/users/davidmeza1/repos", type = "public")
vapply(my_repos, "[[", "", "name")

repos <- gh("/users/ironholds/repos", .limit = Inf)
length(repos)

iss_df <-
    data_frame(
        repo = repos %>% map_chr("name"),
        issue = repo %>%
            map(~ gh(repo = .x, endpoint = "/repos/ironholds/:repo/issues",
                     .limit = Inf))
    )
str(iss_df, max.level = 1)


ND_repos <- gh("/users/nasadatanauts/repos", type = "public", .limit = Inf)
vapply(ND_repos, "[[", "", "name")
length(ND_repos)

ND_lang <- gh("/repos/:owner/:repo/languages", owner = "nasadatanauts")
NDlang_df <-
    data_frame(
        repo = ND_repos %>% map_chr("name"),
        language = repo %>%
            map(~ gh(repo = .x, endpoint = "/repos/nasadatanauts/:repo/languages",
                     .limit = Inf)),
        tags = repo %>%
            map(~ gh(repo = .x, endpoint = "/repos/nasadatanauts/:repo/tags", 
                     .limit = Inf))
    )
