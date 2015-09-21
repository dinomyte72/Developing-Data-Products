library(shiny)
library(dplyr)
library(googleVis)

# Load data
MLBattend <- read.csv('mlbdata.csv')

# Create team and year lists for widgets
teams <- MLBattend %>% distinct(franchise)
teamList <- as.vector(teams$franchise)
years <- MLBattend %>% distinct(year)
yearList <- as.vector(years$year)

# Create new features
MLBattend <- MLBattend %>%
        mutate(percentage=round(wins/(wins+losses),3)) %>%
        mutate(diff=runs.scored-runs.allowed)

shinyServer(function(input, output) {

        # Drop-down selection box for team
        output$selectTeam <- renderUI({
                selectInput("teamSelected", "", as.list(teamList), selected = "Montreal Expos")
                })
        # Numeric selection for year
        output$selectYear <- renderUI({
                numericInput("yearSelected", "",
                             min=min(yearList),
                             max=max(yearList),
                             step = 1,
                             value = yearList[trunc(length(yearList)/2)])
                })

        # Display charts for team
        output$plot1 <- renderGvis({
                filteredData <- MLBattend %>%
                        filter(franchise == input$teamSelected) %>%
                        select(year,attendance,percentage)
                p <- gvisComboChart(
                        filteredData,
                        xvar = "year",
                        yvar = c("attendance","percentage"),
                        options=list(title = "Team Attendance vs. Percentage",
                                     width=800,
                                     height=500,
                                     seriesType = "bars",
                                     series = "[{type:'bars',targetAxisIndex: 0},{type:'line',targetAxisIndex: 1}]",
                                     vAxes = "[{title:'Attendance'},{title:'Percentage'}]"
                        )
                )
                return(p)
                })

        # Display table of stats for team/year
        output$table1 <- renderGvis({
                tableData <- MLBattend %>%
                        filter(franchise == input$teamSelected, year == input$yearSelected) %>%
                        select(year, wins, losses, percentage, games.behind, runs.scored, runs.allowed, attendance)
                t <- gvisTable(tableData)
                return(t)
        })

        # Display team logo at top right of main panel
        output$logo <- renderImage({
                fileName <-paste('www/',input$teamSelected,'.png', sep="")
                list(
                        src = fileName,
                        align = 'left',
                        width = 150,
                        filetype = 'image/png',
                        alt = fileName
                )
        }, deleteFile = FALSE)
})