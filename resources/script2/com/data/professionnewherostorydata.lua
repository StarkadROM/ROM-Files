ProfessionNewHeroStoryData = class("ProfessionNewHeroStoryData")
function ProfessionNewHeroStoryData:ctor(serverData)
  local staticData = Table_HeroStoryQuest[serverData.id]
  self:SetStaticData(staticData)
  self:SetServerData(serverData)
end
function ProfessionNewHeroStoryData:SetStaticData(staticData)
  self.id = staticData.id
  self.staticData = staticData
end
function ProfessionNewHeroStoryData:SetServerData(serverData)
  if serverData and serverData.id == self.id then
    if not self.serverData then
      self.serverData = {}
    end
    self.serverData.state = serverData.queststate
  end
end
function ProfessionNewHeroStoryData:IsLocked()
  return self.serverData and self.serverData.state == SceneUser3_pb.HEROSTORY_QUSET_STATE_UNLOCK
end
function ProfessionNewHeroStoryData:IsWaitUnlock()
  return self.serverData and self.serverData.state == SceneUser3_pb.HEROSTORY_QUSET_STATE_UNACCEPT
end
function ProfessionNewHeroStoryData:IsInProgress()
  return self.serverData and self.serverData.state == SceneUser3_pb.HEROSTORY_QUSET_STATE_INPROCESS
end
function ProfessionNewHeroStoryData:IsCompleted()
  return self.serverData and self.serverData.state == SceneUser3_pb.HEROSTORY_QUSET_STATE_COMPLETE
end
function ProfessionNewHeroStoryData:IsRewarded()
  return self.serverData and self.serverData.state == SceneUser3_pb.HEROSTORY_QUSET_STATE_REWARD
end
function ProfessionNewHeroStoryData:UnlockByServer()
  if self:IsWaitUnlock() then
    self.serverData.state = SceneUser3_pb.HEROSTORY_QUSET_STATE_INPROCESS
  end
end
function ProfessionNewHeroStoryData:GetTitlePrefix()
  return self.staticData and self.staticData.StoryNamePrefix or ""
end
function ProfessionNewHeroStoryData:GetTitle()
  return self.staticData and self.staticData.StoryName or ""
end
function ProfessionNewHeroStoryData:GetDesc()
  return self.staticData and self.staticData.StoryContent or ""
end
function ProfessionNewHeroStoryData:GetUnlockDesc()
  return self.staticData and self.staticData.UnlockDesc or ""
end
function ProfessionNewHeroStoryData:GetQuestData()
  local firstQuestId = self.staticData and self.staticData.FirstQuestID
  if firstQuestId then
    return QuestProxy.Instance:getSameQuestID(firstQuestId)
  end
end
function ProfessionNewHeroStoryData:GetTaskDesc()
  local questData = self:GetQuestData()
  if questData then
    return questData:parseTranceInfo()
  end
  return ""
end
function ProfessionNewHeroStoryData:GetReward()
  return self.staticData and self.staticData.Reward and self.staticData.Reward[1]
end
function ProfessionNewHeroStoryData:GetRewardItemId()
  local reward = self:GetReward()
  return reward and reward[1]
end
function ProfessionNewHeroStoryData:GetRewardItemIcon()
  local itemId = self:GetRewardItemId()
  if itemId then
    local itemConfig = Table_Item[itemId]
    return itemConfig and itemConfig.Icon
  end
end
function ProfessionNewHeroStoryData:GetRewardItemNum()
  local reward = self:GetReward()
  return reward and reward[2]
end
function ProfessionNewHeroStoryData:OnRewarded()
  if self:IsCompleted() then
    self.serverData.state = SceneUser3_pb.HEROSTORY_QUSET_STATE_REWARD
  end
end
