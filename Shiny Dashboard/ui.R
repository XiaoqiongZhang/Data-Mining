
source("libs.R")
source("import.R")

dashboardPage(
  dashboardHeader(title = "Joan's Dashboard"),
  dashboardSidebar(
    selectInput(inputId = "name",
                label = "Assigned.To:",
                choices = name_list,
                selected = "Summary",
                selectize = FALSE),
    sidebarMenu(
      menuItem("Overall-Task",
               tabName = "PercentageofTasksComplete",
               icon = icon("completion")),
      menuItem("Budget",
               tabName = "Budget",
               icon = icon("Budget")),
      menuItem("Pending",
               tabName = "Pending",
               icon = icon("Pending")))),

  dashboardBody(
    tabsetPanel(id = "tabs",
                tabPanel(title = "Individual Task Dashboard",
                         value = "task",
                         fluidRow(
                            valueBoxOutput("total_tasks"),
                            valueBoxOutput("uncompleted_tasks"),
                            valueBoxOutput("percent_completed")),
                         fluidRow(),
                         fluidRow(
                            plotlyOutput("taskTimeline",height = "200px")))),
    tabItems(
      tabItem(tabName = "PercentageofTasksComplete",
              h2('Completion Analytics Dashboard'),
              fluidRow(),
              fluidRow(
                column(width=8,plotOutput("distTaskPlot",height = "300px")),
                column(width=4,plotOutput("percentTaskPlot",height = "300px"))),
              fluidRow(
                column(width=8,plotOutput("DetailDistTaskPlot",height = "300px")),
                column(width=4,plotOutput("DetailPercTaskPlot",height = "300px")))),
      tabItem(tabName = "Budget",
              h2('Budget Analytics Dashboard'),
              fluidRow(
                valueBoxOutput("PlannedBudget"),
                valueBoxOutput("AcutualBudget"),
                valueBoxOutput("BudgetDifference")),
              fluidRow(
                plotOutput("percentBudgetPlot"))),
      tabItem(tabName = "Pending",
              h2('Pending Analytics Dashboard'),
              fluidRow(
                valueBoxOutput("DecPending",width = 3),
                valueBoxOutput("ActPending",width = 3),
                valueBoxOutput("ReqPending",width = 3),
                valueBoxOutput("TotalPending",width = 3)),
              fluidRow(
                column(width=7,plotOutput("PendingPlot")),
                column(width=5,plotOutput("PercentPendingPlot"))))
  ))
)