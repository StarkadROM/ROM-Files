AdventureAchieveData = class("AdventureAchieveData")
function AdventureAchieveData:ctor(serverData)
  self:updateServerData(serverData)
  self:initStaticData()
end
function AdventureAchieveData:updateServerData(serverData)
  self.id = serverData.id
  self.finishtime = serverData.finishtime
  self.process = serverData.process
  self.reward_get = serverData.reward_get
  self:updateQuests(serverData)
  self:initCompleteString()
end
function AdventureAchieveData:updateQuests(serverData)
  local quests = serverData.quests
  if quests and #quests > 0 then
    self.questDatas = {}
    for i = 1, #quests do
      local single = quests[i]
      local id = single.id
      local name = single.name
      local data = {id = id, name = name}
      local pre = single.pre
      if pre and #pre > 0 then
        local pres = {}
        for j = 1, #pre do
          pres[#pres + 1] = {
            id = pre[j].id,
            name = pre[j].name
          }
        end
        data.pre = pres
      end
      self.questDatas[#self.questDatas + 1] = data
    end
  end
end
function AdventureAchieveData:initStaticData()
  self.staticData = Table_Achievement[self.id]
end
function AdventureAchieveData:initCompleteString()
  if self.finishtime and self.finishtime > 0 then
    self.dateStr = os.date("%Y.%m.%d", self.finishtime)
  else
    self.dateStr = nil
  end
end
function AdventureAchieveData:getCompleteString()
  return self.dateStr
end
function AdventureAchieveData:getProcess()
  return self.process or 0
end
function AdventureAchieveData:canGetReward()
  if not self.dateStr then
    return false
  end
  return not self.reward_get
end
function AdventureAchieveData:setSelected(bRet)
  self.isSelected = bRet
end
function AdventureAchieveData:getSelected()
  return self.isSelected
end
