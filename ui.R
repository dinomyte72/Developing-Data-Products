library(shiny)
library(shinythemes)

totalWidth <- 12
sidePanelWidth <- 3
mainPanelWidth <- totalWidth - sidePanelWidth

shinyUI(fluidPage(
        theme = shinytheme('united'),
        title = "Comparison of MLB Team Record and Attendance",
        column(sidePanelWidth,
               imageOutput('logo'),
               p("This application allows you to select a Major League Baseball (MLB) team and see whether or not the team's percentage record affected their attendance record."),
               p("Begin by selecting a MLB team and a Year. The app will display a table with some vital team stats for the selected year as well as a chart displaying the attendance and perecentage records."),
               p("This app uses the MLBAttend dataset from the UsingR package and the charts are built using the googleVis package. If you hover over the chart, you will see the values."),
               p("I hope you enjoy this application!")
               ),
        column(mainPanelWidth,
                fluidRow(
                       h2("Comparison of MLB Team Record and Attendance"),
                        column(trunc(mainPanelWidth/2), uiOutput('selectTeam')),
                        column(trunc(mainPanelWidth/2), uiOutput('selectYear'))
                ),
                fluidRow(h4("")),
                fluidRow(
                        h4("Record for Year Selected"),
                        column(mainPanelWidth,htmlOutput('table1'))
                ),
                fluidRow(h4("")),
                fluidRow(
                        h4("Attendance and Percentage for 1969-2000"),
                        column(mainPanelWidth,htmlOutput('plot1'))
                )
        )
))