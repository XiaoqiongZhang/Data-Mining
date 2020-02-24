source("libs.R")
source("import.R")

shinyServer(function(input, output) {
  
  ## Tasks
  # Box_total
  output$total_tasks = renderValueBox({
      taskData %>% 
        group_by(Assigned.To) %>% 
        summarise(n()) %>%
        filter(Assigned.To == input$name) %>%
        select('number' = 'n()') %>%
        as.integer() %>%
        prettyNum(big.mark = ",") %>%
        valueBox(subtitle = "Total Number of Tasks",color="blue")
  })
  # Box_uncomplete
  output$uncompleted_tasks = renderValueBox({
    taskData %>% 
      filter(Status != status_list[1]) %>% 
      group_by(Assigned.To) %>% 
      summarise(number = n()) %>%
      filter(Assigned.To == input$name) %>%
      select(number) %>%
      as.integer() %>%
      prettyNum(big.mark = ",") %>%
      valueBox(subtitle = "Uncompleted Tasks",color = "blue")
    })
  # Box_percentage
  output$percent_completed = renderValueBox({
    taskData %>% 
      group_by(Assigned.To) %>% 
      filter(Assigned.To == input$name) %>% 
      mutate(completed = ifelse(Status == status_list[1],1,0)) %>% 
      summarise(completions = sum(completed,na.rm = TRUE),total = n()) %>%
      collect() %>% 
      mutate(percent= (completions/total)*100) %>%
      pull() %>%
      round() %>%
      paste0("%") %>%
      valueBox(subtitle = "Completion Percentage", color="olive")
  })
  
  # Plot_timeline
  output$taskTimeline = renderPlotly({
    taskData %>% 
      group_by(Assigned.To) %>% 
      filter(Assigned.To == input$name) %>%
      vistime(start = "Start", end = "End", events = "X.Tasks", groups = "Status")
  })
  
  
  # Plot_task_distributin_brief
  output$distTaskPlot = renderPlot({
    ggplot(indi_task,aes(fill=completed,y=number,x=Assigned.To)) +
      geom_bar(position="stack",stat = "identity") + coord_flip()+
      scale_fill_brewer(palette = "Blues") +
      ggtitle("Completion Distribution") + 
      theme(axis.text.x = element_text(angle = 90, hjust = 1))+
      theme(legend.position="bottom",
            legend.title = element_blank())+
      labs(x = NULL, y = "Number of Tasks",fill = NULL)
  })
  # Plot_task_percentage_brief
  output$percentTaskPlot = renderPlot({
    taskStatus = indi_task %>% group_by(completed) %>% summarise(number=sum(number))
    ggplot(taskStatus,aes(x="", y=number, fill=completed)) +
      geom_bar(width=1, stat="identity") +
      coord_polar("y", start=0) +
      theme(legend.position="bottom",
            legend.title = element_blank()) +
      geom_text(aes(label = paste0(number, " (",scales::percent(number / sum(number)),")")),
                position = position_stack(vjust = 0.5))+
      ggtitle("Completion Percentage")
  })
  # Plot_task_distributin_detailed
  output$DetailDistTaskPlot = renderPlot({
    ggplot(indi_status_task,aes(fill=Status,y=number,x=Assigned.To)) +
      geom_bar(position="stack",stat = "identity") + coord_flip()+
      scale_fill_brewer(palette = "Blues") +
      ggtitle("Task Status Distribution") + 
      theme(axis.text.x = element_text(angle = 90, hjust = 1))+
      theme(legend.title = element_blank(),
            legend.position="bottom")
  })
  # Plot_task_percentage_detail
  output$DetailPercTaskPlot = renderPlot({
    taskStatus = indi_status_task %>% group_by(Status) %>% summarise(number=sum(number))
    ggplot(taskStatus,aes(x="", y=number, fill=Status)) +
      geom_bar(width=1, stat="identity") +
      coord_polar("y", start=0) +
      theme(legend.position="bottom",
            legend.text = element_text(size=5),
            legend.title = element_blank()) +
      geom_text(aes(label = paste0(number, " (",scales::percent(number / sum(number)),")")),
                position = position_stack(vjust = 0.5))+
      ggtitle("Status Percentage")
  })

  
  ## Budget
  # Valuebox
  output$PlannedBudget = renderValueBox({
    budgetData$amount[1] %>%
      as.integer() %>%
      prettyNum(big.mark = ",") %>%
      valueBox(subtitle = "Planned Budget",color = "teal")
  })
  output$AcutualBudget = renderValueBox({
    budgetData$amount[2] %>%
      as.integer() %>%
      prettyNum(big.mark = ",") %>%
      valueBox(subtitle = "Actual Used Budget",color = "teal")
  })
  output$BudgetDifference = renderValueBox({
    budgetData$amount[3] %>%
      as.integer() %>%
      prettyNum(big.mark = ",") %>%
      valueBox(subtitle = "Surplus Budget", color="orange")
  })
  # Plot_budget_percentage
  output$percentBudgetPlot = renderPlot({
    budget = budgetData[2:3,]
    ggplot(budget,aes(x="", y=amount, fill=Budget)) +
      geom_bar(width=1, stat="identity") +
      coord_polar("y", start=0) +
      theme(legend.position="bottom",
            legend.title = element_blank()) +
      geom_text(aes(label = paste0(amount, " (",scales::percent(amount / sum(amount)),")")),
                position = position_stack(vjust = 0.5))+
      ggtitle("Budget Used Percentage")
  })
  
  ## Pending
  # ValueBox
  output$DecPending = renderValueBox({
    pendingData$Amount[1] %>%
      as.integer() %>%
      prettyNum(big.mark = ",") %>%
      valueBox(subtitle = "Pending Decisions",color = "teal")
  })
  output$ActPending = renderValueBox({
    pendingData$Amount[2] %>%
      as.integer() %>%
      prettyNum(big.mark = ",") %>%
      valueBox(subtitle = "Pending Actions",color = "teal")
  })
  output$ReqPending = renderValueBox({
    pendingData$Amount[3] %>%
      as.integer() %>%
      prettyNum(big.mark = ",") %>%
      valueBox(subtitle = "Pending Requests",color = "teal")
  })
  output$TotalPending = renderValueBox({
    sum(pendingData$Amount) %>%
      as.integer() %>%
      prettyNum(big.mark = ",") %>%
      valueBox(subtitle = "Total",color = "red")
  })
    
  # Plot
  output$PendingPlot = renderPlot({
    ggplot(pendingData,aes(x=Pending,y=Amount)) + 
      geom_bar(stat="identity",width=0.5,fill="tomato3") +
      theme(axis.text.x = element_text(angle = 25, hjust = 1),
            legend.title = element_blank()) +
      ggtitle("Number of Pendings") + xlab("Pending Category")
  })
  output$PercentPendingPlot = renderPlot({
    ggplot(pendingData,aes(x="", y=Amount, fill=Pending)) + 
      geom_bar(width=1, stat="identity") +
      coord_polar("y", start=0) +
      theme(legend.position="bottom",
            legend.title = element_blank()) +
      geom_text(aes(label = paste0(Amount, " (",scales::percent(Amount / sum(Amount)),")")),
                position = position_stack(vjust = 0.5))+
      ggtitle("Pending Category Percentage")
  })
  
})