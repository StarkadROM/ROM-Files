PvePassInfo = class("PvePassInfo")
function PvePassInfo:ctor(serverdata)
  self.id = serverdata.id
  self.isFirstPass = false
  self.open = false
  self.passtime = 0
  self.quick = false
  self:setData(serverdata)
end
function PvePassInfo:Update(serverdata)
  self:setData(serverdata)
end
function PvePassInfo:setData(serverdata)
  local cacheFirstPass = self.isFirstPass
  if nil ~= serverdata.firstpass then
    self.isFirstPass = serverdata.firstpass
  end
  if serverdata.passtime then
    self.passtime = serverdata.passtime
  end
  if nil ~= serverdata.open then
    self.open = serverdata.open
  end
  if serverdata.quick ~= nil then
    self.quick = serverdata.quick
  end
  local cacheWeeklyRoundRewardId = self.weeklyRoundRewardId
  if serverdata.roundrewardid and serverdata.roundrewardid > 0 then
    self.weeklyRoundRewardId = serverdata.roundrewardid
  end
  if nil ~= serverdata.pickup then
    self.pickup = serverdata.pickup
  end
  if nil ~= serverdata.norlenfirst then
    self.norlenfirst = serverdata.norlenfirst
  end
  local firstpassDirty = nil ~= cacheFirstPass and cacheFirstPass ~= self.isFirstPass
  local WeeklyRoundRewardDirty = nil ~= cacheWeeklyRoundRewardId and cacheWeeklyRoundRewardId ~= self.weeklyRoundRewardId
  if firstpassDirty or WeeklyRoundRewardDirty then
    PveEntranceProxy.Instance:ResetDropReward(self.id)
  end
  if nil ~= serverdata.pass then
    self.pass = serverdata.pass
  end
end
function PvePassInfo:IsPickup()
  return self.pickup == true
end
function PvePassInfo:GetWeeklyRoundRewardId()
  return self.weeklyRoundRewardId
end
function PvePassInfo:GetPassTime()
  return self.passtime
end
function PvePassInfo:CheckFirstPass()
  return self.isFirstPass
end
function PvePassInfo:CheckPass()
  return self.pass
end
function PvePassInfo:CheckNorlenFirstPass()
  return self.norlenfirst
end
function PvePassInfo:IsOpen()
  return self.open
end
function PvePassInfo:GetQuick()
  return self.quick
end
