# Outsource the extraction of all the data from the given sources

source("libs.R")

# Task
taskData = read.csv(file="data/task.csv",header=TRUE,sep=",",stringsAsFactors = FALSE)
taskData$Start = mdy(taskData$Start)
taskData$End = mdy(taskData$End)
taskData$Assigned.To[taskData$Assigned.To == ""] = "others"
name_list = unique(taskData$Assigned.To)
status_list = unique(taskData$Status)

indi_task = taskData %>%
  filter(Status!="") %>%
  mutate(completed = ifelse(Status == status_list[1],"Completed","Uncompleted")) %>%
  group_by(Assigned.To,completed) %>%
  summarise(number = n())

indi_status_task = taskData %>%
  filter(Status!="") %>%
  group_by(Assigned.To,Status) %>%
  summarise(number = n())

# Budget
budgetData = read.csv(file="data/budget.csv",header=TRUE,sep=",",stringsAsFactors = FALSE)
budgetData[3,] = c("Planned-Actual",budgetData$amount[1]-budgetData$amount[2])
budgetData$amount = as.integer(budgetData$amount)

# Pending
pendingData = read.csv(file="data/pending.csv",header=TRUE,sep=",",stringsAsFactors = FALSE)

