iredata.tasks = iredata.tasks or {}
iredata.taskFunctions = iredata.taskFunctions or {}

function iredata.taskFunctions:tasklist()
  local tasks = gmcp.IRE.Tasks.List
  iredata.tasks.quests = {}
  iredata.tasks.quests.all = {}
  iredata.tasks.quests.complete = {}
  iredata.tasks.quests.current = {}
  iredata.tasks.achievements = {}
  iredata.tasks.achievements.all = {}
  iredata.tasks.achievements.groupNames = {}
  iredata.tasks.achievements.groups = {}
  for _,task in ipairs(tasks) do
    if task.type == "quests" then
      table.insert(iredata.tasks.quests.all, task)
      if task.status == "1" then
        table.insert(iredata.tasks.quests.complete, task)
      else
        table.insert(iredata.tasks.quests.current, task)
      end
    elseif task.type == "achievements" or task.type == "Task" or task.type == "tasks" then
      table.insert(iredata.tasks.achievements.all, task)
      if not table.contains(iredata.tasks.achievements.groupNames, task.group) then
        table.insert(iredata.tasks.achievements.groupNames, task.group)
        iredata.tasks.achievements.groups[task.group] = {}
      end
      table.insert(iredata.tasks.achievements.groups[task.group], task)
    end
  end
  table.sort(iredata.tasks.achievements.groupNames)
  raiseEvent("iredata.quests updated")
  raiseEvent("iredata.achievements updated")
end

function iredata.taskFunctions:taskupdate()
  local task = gmcp.IRE.Tasks.Update[1]
  if task.type == "quests" then
    if task.status == "0" then
      for index,taskToCheck in ipairs(iredata.tasks.quests.current) do
        if taskToCheck.id == task.id then
          table.remove(iredata.tasks.quests.current, index)
          break
        end
      end
      table.insert(iredata.tasks.quests.current, task)
    else
      for index, taskToCheck in ipairs(iredata.tasks.quests.current) do
        if taskToCheck.id == task.id then
          table.remove(iredata.tasks.quests.current, index)
          break
        end
      end
      for index, taskToCheck in ipairs(iredata.tasks.quests.complete) do
        if taskToCheck.id == task.id then
          table.remove(iredata.tasks.quests.complete, index)
          break
        end
      end
      table.insert(iredata.tasks.quests.complete)
    end
    raiseEvent("iredata.quests updated")
  elseif task.type == "achievements" or task.type == "Task" or task.type == "tasks" then
    for index, taskToCheck in ipairs(iredata.tasks.achievements.groups[task.group]) do
      if taskToCheck.id == task.id then
        table.remove(iredata.tasks.achievements.groups[task.group], index)
        break
      end
    end
    table.insert(iredata.tasks.achievements.groups[task.group], task)
    raiseEvent("iredata.achievements updated")
  end
end

function iredata.taskFunctions:initialize()
  gmod.disableModule('iredata', 'IRE.Tasks.List')
  gmod.disableModule('iredata', 'IRE.Tasks.Update')
  gmod.enableModule('iredata', 'IRE.Tasks.List')
  gmod.enableModule('iredata', 'IRE.Tasks.Update')
  if iredata.taskFunctions.eventHandlers then
    for _,handlerID in ipairs(iredata.taskFunctions.eventHandlers) do
      killAnonymousEventHandler(handlerID)
    end
  end
  iredata.taskFunctions.eventHandlers = {}
  table.insert(iredata.taskFunctions.eventHandlers, registerAnonymousEventHandler("gmcp.IRE.Tasks.List", iredata.taskFunctions.tasklist))
  table.insert(iredata.taskFunctions.eventHandlers, registerAnonymousEventHandler("gmcp.IRE.Tasks.Update", iredata.taskFunctions.taskupdate))
  iredata:sendGMCP("IRE.Tasks.Request")
end
