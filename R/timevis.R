library(readxl)
ARMDdata <- read_excel("~/OneDrive/GitHub/NASADatanauts/data/ARMDdata.xlsx", 
                       na = "NA")
ARMDgroups <- read_excel("~/OneDrive/GitHub/NASADatanauts/data/ARMDgroups.xlsx", 
                         na = "NA")

timevis(data = data.frame(
    start = c(Sys.Date(), Sys.Date(), Sys.Date() + 1, Sys.Date() + 2, Sys.Date() + 3, Sys.Date() + 4),
    content = c("one", "two", "three", "four", "five", "six"),
    group = c(1, 2, 1, 3, 5, 6)),
    groups = data.frame(id = 1:6, content = c("G1", "G2", "G3", "G4", "G5", "G6"))
) %>%
    setGroups(data.frame(id = 1:6, content = c("Top", "Tech Transfer", "Advanced Concepts",
                                               "Safety Managment for Emergent Risks", "Integrated Modeling", 
                                               "Airspace Operations Performance Enablers")))


timevis(data = ARMDdata, groups = ARMDgroups, width = 1400)
