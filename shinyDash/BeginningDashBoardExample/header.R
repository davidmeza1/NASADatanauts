header <- dashboardHeader(title = "Dashboard Example", titleWidth = 250,
                          dropdownMenu(
                               type = "messages",
                               messageItem(
                                    from = "David Meza",
                                    message = "About Me",
                                    href= "http://davidmeza1.github.io/"
                               ),
                               messageItem(
                                    from = "Documentation",
                                    message = "View Documentation and Source",
                                    icon = icon("question"),
                                    ## time = "13:45",
                                    href = "https://developer.nasa.gov/dmeza/shiny-dashboard-DSD"
                               ),
                               messageItem(
                                    from = "Issues",
                                    message = "Report Issues Here.",
                                    icon = icon("life-ring"),
                                    ## time = "2014-12-01",
                                    href = "https://developer.nasa.gov/dmeza/shiny-dashboard-DSD/issues"
                               )
                               
                          ),
                          dropdownMenu(type = "notifications",
                                       notificationItem(
                                            text = "5 new users today",
                                            icon("users")
                                       ),
                                       notificationItem(
                                            text = "12 items delivered",
                                            icon("truck"),
                                            status = "success"
                                       ),
                                       notificationItem(
                                            text = "Server load at 86%",
                                            icon = icon("exclamation-triangle"),
                                            status = "warning"
                                       )
                          ),
                          dropdownMenu(type = "tasks", badgeStatus = "success",
                                       taskItem(value = 90, color = "green",
                                                "Documentation"
                                       ),
                                       taskItem(value = 17, color = "aqua",
                                                "Project X"
                                       ),
                                       taskItem(value = 75, color = "yellow",
                                                "Server deployment"
                                       ),
                                       taskItem(value = 80, color = "red",
                                                "Overall project"
                                       )
                          )
)