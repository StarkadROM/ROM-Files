ProfessionNewHeroTaskData = class("ProfessionNewHeroTaskData")
function ProfessionNewHeroTaskData:ctor(serverData)
  local staticData = Table_HeroGrowthQuest[serverData.id]
  self:SetStaticData(staticData)
  self:SetServerData(serverData)
end
function ProfessionNewHeroTaskData:SetStaticData(staticData)
  self.id = staticData.id
  self.staticData = staticData
end
function ProfessionNewHeroTaskData:SetServerData(serverData)
  if serverData and serverData.id == self.id then
    if not self.serverData then
      self.serverData = {}
    end
    self.serverData.process = serverData.process
    self.serverData.goal = serverData.goal
  end
end
function ProfessionNewHeroTaskData:IsCompleted()
  return self.serverData and self.serverData.process >= self.serverData.goal
end
function ProfessionNewHeroTaskData:GetProcess()
  return self.serverData and self.serverData.process or 0
end
function ProfessionNewHeroTaskData:GetGoal()
  return self.serverData and self.serverData.goal or 0
end
function ProfessionNewHeroTaskData:GetTraceInfo()
  local traceInfo = self.staticData and self.staticData.TraceInfo or ""
  return traceInfo
end
function ProfessionNewHeroTaskData:GetGoto()
  return self.staticData and self.staticData.Goto
end
function ProfessionNewHeroTaskData:GetProgressStr()
  local progress = self:GetProcess() or 0
  local goal = self:GetGoal() or 1
  if progress == 0 then
    return string.format("([c][f56556]%s[-][/c]/%s)", progress, goal)
  else
    return string.format("(%s/%s)", progress, goal)
  end
end
