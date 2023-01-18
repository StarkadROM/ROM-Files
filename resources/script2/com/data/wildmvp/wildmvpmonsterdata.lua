WildMvpMonsterData = class("WildMvpMonsterData")
local EmptyTable = {}
function WildMvpMonsterData:ctor(staticData)
  self:SetStaticData(staticData)
end
function WildMvpMonsterData:SetStaticData(staticData)
  self.id = staticData.id
  self.staticData = staticData
  local monsterConfig = Table_Monster[self.id]
  if monsterConfig then
    self.type = monsterConfig.Type
  end
  if self.type == "MVP" then
    self.mapSymbolDisabled = "map_mvpcamp1"
    self.mapSymbolProgress = "map_mvpcamp2"
    self.mapSymbolActive = "map_mvpcamp3"
    self.symbolSize = 28.0
  elseif self.type == "RareElite" then
    self.mapSymbolDisabled = "map_elite1"
    self.mapSymbolProgress = "map_elite2"
    self.mapSymbolActive = "map_elite2"
    self.symbolSize = 24.0
  end
  self.cd = staticData and staticData.cd
  local respawnPos = staticData and staticData.RespawnPos
  if respawnPos then
    self.pos = staticData and LuaVector3.New(respawnPos[1], respawnPos[2], respawnPos[3])
  end
  self.holdPercent = 0.8
end
function WildMvpMonsterData:SetServerData(serverData)
  if serverData and serverData.npcid == self.id then
    if not self.serverData then
      self.serverData = {}
    end
    self.serverData.status = serverData.status
    local leftTime = serverData.lefttime or 0
    self.serverData.endTime = leftTime + ServerTime.CurServerTime() / 1000
    self.serverData.posX = serverData.pos and serverData.pos.x
    self.serverData.posY = serverData.pos and serverData.pos.y
    self.serverData.posZ = serverData.pos and serverData.pos.z
    self.serverData.firstKilled = serverData.first_killed
  end
end
function WildMvpMonsterData:GetStaticMonsterData()
  return Table_Monster[self.id]
end
function WildMvpMonsterData:GetStaticData()
  return self.staticData
end
function WildMvpMonsterData:GetServerData()
  return self.serverData
end
function WildMvpMonsterData:GetTimeLeft()
  if self:IsDead() then
    return self.serverData.endTime - ServerTime.CurServerTime() / 1000
  end
end
function WildMvpMonsterData:IsCharUnLock()
  if self.staticData and FunctionUnLockFunc.Me():CheckCanOpen(self.staticData.CharacteristicMenu) then
    return true
  end
  return false
end
function WildMvpMonsterData:GetStatus()
  if self.serverData then
    return self.serverData.status
  end
  return ERAREELITESTATUS.ERAREELITESTATUS_UNKNOWN
end
function WildMvpMonsterData:IsSummoned()
  if self.serverData then
    return self.serverData.status ~= ERAREELITESTATUS.ERAREELITESTATUS_UNKNOWN
  end
  return false
end
function WildMvpMonsterData:IsAlive()
  if self.serverData then
    return self.serverData.status == ERAREELITESTATUS.ERAREELITESTATUS_ALIVE
  end
  return false
end
function WildMvpMonsterData:IsDead()
  if self.serverData then
    return self.serverData.status == ERAREELITESTATUS.ERAREELITESTATUS_DEAD
  end
  return false
end
function WildMvpMonsterData:GetElitePositionXYZ()
  if self.serverData and self.serverData.posX and self.serverData.posY and self.serverData.posZ then
    return self.serverData.posX / 1000, self.serverData.posY / 1000, self.serverData.posZ / 1000
  end
end
function WildMvpMonsterData:GetMapID()
  if self.staticData then
    return self.staticData.MapID
  end
end
function WildMvpMonsterData:GetSkillIds()
  if self.staticData then
    return self.staticData.Skill
  end
end
function WildMvpMonsterData:GetType()
  return self.type
end
function WildMvpMonsterData:GetDisabledMapSymbolIcon()
  return self.mapSymbolDisabled
end
function WildMvpMonsterData:GetProgressMapSymbolIcon()
  return self.mapSymbolProgress
end
function WildMvpMonsterData:GetActiveMapSymbolIcon()
  return self.mapSymbolActive
end
function WildMvpMonsterData:GetMapSymbolDepth()
  return 1
end
function WildMvpMonsterData:GetMapSymbolProgress()
  local progress = 0
  local isAlive = false
  if self:IsAlive() then
    isAlive = true
    progress = 1
  elseif self:IsDead() then
    isAlive = false
    if self.cd and 0 < self.cd then
      progress = 1.0 - (self:GetTimeLeft() or 0) / self.cd
      progress = math.clamp(progress, 0, 1)
    else
      progress = 1
    end
  else
    progress = 1
    isAlive = false
  end
  return progress, isAlive
end
function WildMvpMonsterData:IsUnlocked()
  return FunctionUnLockFunc.Me():CheckCanOpen(self.staticData and self.staticData.IconShowMenu)
end
local tempRewards = {}
function WildMvpMonsterData:GetRewards()
  TableUtility.ArrayClear(tempRewards)
  if self.staticData then
    if self.serverData and self.serverData.firstKilled then
      for i, v in ipairs(self.staticData.Reward) do
        WildMvpMonsterData.TryAddReusableReward(tempRewards, v)
      end
      for i, v in ipairs(self.staticData.DropReward) do
        WildMvpMonsterData.TryAddReusableReward(tempRewards, v, true, true)
      end
    else
      for i, v in ipairs(self.staticData.DropReward) do
        WildMvpMonsterData.TryAddReusableReward(tempRewards, v, true)
      end
      for i, v in ipairs(self.staticData.Reward) do
        WildMvpMonsterData.TryAddReusableReward(tempRewards, v)
      end
    end
  end
  return tempRewards
end
function WildMvpMonsterData.TryAddReusableReward(rewardItemArr, teamId, isFirst, isGot)
  local items = teamId and ItemUtil.GetRewardItemIdsByTeamId(teamId)
  if items then
    for i, v in ipairs(items) do
      local tbl = {}
      TableUtility.TableShallowCopy(tbl, v)
      tbl.isFirst = isFirst
      tbl.isGot = isGot
      TableUtility.ArrayPushBack(rewardItemArr, tbl)
    end
  end
end
