local _Config = GameConfig.Pve
local daySeconds = 86400
PveEntranceData = class("PveEntranceData")
PveEntranceData.ESort = {Open = 1, Lock = 2}
function PveEntranceData.SortFunc(l, r)
  local l_sortId = l:GetSortId()
  local r_sortId = r:GetSortId()
  if l_sortId == r_sortId then
    if l.configSortID == r.configSortID then
      return l.id < r.id
    else
      return l.configSortID < r.configSortID
    end
  else
    return l_sortId < r_sortId
  end
end
function PveEntranceData:ctor(id)
  self.id = id
  self.staticData = Table_PveRaidEntrance[id]
  self.raidType = self.staticData.RaidType
  self.lv = self.staticData.RecommendLv
  self.name = self.staticData.Name
  self.diffType = self.staticData.DifficultyName[1]
  local staticLayer = self.staticData.DifficultyName[2]
  self.difficulty = staticLayer
  if self:IsPveCard() then
    self.pveCardDifficulty = staticLayer % 10000
    self.pveCardlayer = math.floor(staticLayer / 10000)
  end
  self.unlockMsgId = self.staticData.UnlockMsgId
  self.groupid = self.staticData.GroupId
  self.configSortID = _Config.RaidType[self.groupid].sortID
  self.UnlockLv = self.staticData.UnlockLv
  if nil == self.configSortID then
    redlog("策划未配置GameConfig.Pve.RaidType 对应的sortID。错误GroupId k值: ", self.groupid)
    self.configSortID = 1
  end
  self.difficultyRaid = self.staticData.Difficulty
end
function PveEntranceData:GetSortId()
  if self:IsOpen() then
    return PveEntranceData.ESort.Open
  else
    return PveEntranceData.ESort.Lock
  end
end
function PveEntranceData:IsPveCard()
  return self.raidType == PveRaidType.PveCard
end
function PveEntranceData:IsHeadWear()
  return self.raidType == PveRaidType.Headwear
end
function PveEntranceData:IsCrack()
  return self.raidType == PveRaidType.Crack
end
function PveEntranceData:IsNew()
  local openTime = self.groupid and _Config.RaidType[self.groupid] and _Config.RaidType[self.groupid].openTime
  if not openTime then
    return false
  end
  if not StringUtil.IsEmpty(openTime) then
    local dateTime = ClientTimeUtil.GetOSDateTime(openTime)
    local curServerTime = ServerTime.CurServerTime() / 1000
    local delta = curServerTime - dateTime
    if delta > 0 and delta < _Config.NewRaidInterval * daySeconds then
      return true
    end
  end
  return false
end
function PveEntranceData:IsOpen()
  return PveEntranceProxy.Instance:IsOpen(self.staticData.id)
end
function PveEntranceData:CheckPveCardTrebleReward()
  return self:IsPveCard() and PveEntranceProxy.Instance:GetPassTime(self.id) < 3
end
function PveEntranceData:IsRedTipNew()
  local isNew = RedTipProxy.Instance:IsNew(SceneTip_pb.EREDSYS_PVERAID_ENTRANCE, self.groupid) or false
  local hasReward = RedTipProxy.Instance:IsNew(SceneTip_pb.EREDSYS_PVERAID_ACHIEVE, self.groupid) or false
  return isNew or hasReward
end
