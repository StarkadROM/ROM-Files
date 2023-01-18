PveRaidType = {
  Rugelike = FuBenCmd_pb.ERAIDTYPE_ROGUELIKE or 46,
  PveCard = FuBenCmd_pb.ERAIDTYPE_PVECARD or 28,
  DeadBoss = FuBenCmd_pb.ERAIDTYPE_DEADBOSS or 51,
  Headwear = FuBenCmd_pb.ERAIDTYPE_HEADWEAR or 43,
  Comodo = FuBenCmd_pb.ERAIDTYPE_COMODO_TEAM_RAID or 59,
  MultiBoss = FuBenCmd_pb.ERAIDTYPE_SEVEN_ROYAL_TEAM_RAID or 62,
  InfiniteTower = FuBenCmd_pb.ERAIDTYPE_TOWER or 4,
  Thanatos = FuBenCmd_pb.ERAIDTYPE_THANATOS or 35,
  Crack = FuBenCmd_pb.ERAIDTYPE_CRACK or 65,
  GuildRaid = FuBenCmd_pb.ERAIDTYPE_GUILDRAID
}
RaidType2GroupID = {
  [PveRaidType.Rugelike] = 8,
  [PveRaidType.PveCard] = 4,
  [PveRaidType.DeadBoss] = 6,
  [PveRaidType.Headwear] = 3,
  [PveRaidType.Comodo] = 1,
  [PveRaidType.MultiBoss] = 2,
  [PveRaidType.InfiniteTower] = 5,
  [PveRaidType.Thanatos] = 7,
  [PveRaidType.Crack] = 9,
  [PveRaidType.GuildRaid] = 19
}
autoImport("PveEntranceData")
autoImport("PvePassInfo")
autoImport("PveDropItemData")
PveEntranceProxy = class("PveEntranceProxy", pm.Proxy)
PveEntranceProxy.Instance = nil
PveEntranceProxy.NAME = "PveEntranceProxy"
function PveEntranceProxy:ctor(proxyName, data)
  self.proxyName = proxyName or PveEntranceProxy.NAME
  if PveEntranceProxy.Instance == nil then
    PveEntranceProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end
function PveEntranceProxy:Init()
  self.raidMap = {}
  self.catalogAll = {}
  self.catalogMap = {}
  self.crackCatalogAll = {}
  self.crackCatalogMap = {}
  self.passInfoMap = {}
  self.targetMap = {}
  self.dropMap = {}
  self.raidCombinedMap = {}
  self.teamLeaderOpenMap = {}
  self.pvecardRewardTime = {}
  self.goalMap = {}
end
function PveEntranceProxy:PreprocessTable()
  if self.inited then
    return
  end
  self.inited = true
  local _catalog = GameConfig.Pve and GameConfig.Pve.Catalog
  if not _catalog then
    redlog("未找到配置GameConfig.Pve.Catalog")
    return
  end
  local _TablePve = Table_PveRaidEntrance
  self.minUnlockLv = 999
  for k, v in pairs(_TablePve) do
    if v.Goal then
      self.goalMap[v.Goal] = v.id
    end
    local difficultyMap = self.raidMap[v.GroupId]
    if nil == difficultyMap then
      difficultyMap = {}
    end
    difficultyMap[v.DifficultyName[2]] = PveEntranceData.new(k)
    self.raidMap[v.GroupId] = difficultyMap
    self.minUnlockLv = math.min(self.minUnlockLv, v.UnlockLv)
  end
  for t, entranceMap in pairs(self.raidMap) do
    local raidFirstEntranceData = entranceMap[1]
    if raidFirstEntranceData:IsCrack() then
      self.crackCatalogAll[#self.crackCatalogAll + 1] = raidFirstEntranceData
    else
      local catalog = raidFirstEntranceData.staticData.Catalog
      for k, v in pairs(catalog) do
        local catalogData = self.catalogMap[v]
        catalogData = catalogData or {}
        catalogData[#catalogData + 1] = raidFirstEntranceData
        self.catalogMap[v] = catalogData
      end
      self.catalogAll[#self.catalogAll + 1] = raidFirstEntranceData
    end
  end
  self:SortEntrance()
end
function PveEntranceProxy:PreprocessCrackEntrance()
  if self.crackInited then
    return
  end
  self.crackInited = true
  table.sort(self.crackCatalogAll, function(l, r)
    return PveEntranceData.SortFunc(l, r)
  end)
  local maxLvEntranceData
  for i = #self.crackCatalogAll, 1, -1 do
    if self.crackCatalogAll[i]:IsOpen() then
      maxLvEntranceData = self.crackCatalogAll[i]
      break
    end
  end
  self.crackRaidFirstEntranceData = maxLvEntranceData or self.crackCatalogAll[1]
  local catalog = self.crackRaidFirstEntranceData.staticData.Catalog
  for k, v in pairs(catalog) do
    local catalogData = self.catalogMap[v]
    catalogData = catalogData or {}
    catalogData[#catalogData + 1] = self.crackRaidFirstEntranceData
    self.catalogMap[v] = catalogData
  end
  self.catalogAll[#self.catalogAll + 1] = self.crackRaidFirstEntranceData
end
function PveEntranceProxy:GetAllCrackEntranceData()
  return self.crackCatalogAll
end
function PveEntranceProxy:GetMinUnlockLv()
  return self.minUnlockLv
end
function PveEntranceProxy:SortEntrance()
  table.sort(self.catalogAll, function(l, r)
    return PveEntranceData.SortFunc(l, r)
  end)
  for _, v in pairs(self.catalogMap) do
    table.sort(v, function(l, r)
      return PveEntranceData.SortFunc(l, r)
    end)
  end
end
function PveEntranceProxy:IsNewEntrancePveByRaidType(type)
  if not next(self.raidMap) then
    self:PreprocessTable()
  end
  return nil ~= self.raidMap[type]
end
function PveEntranceProxy.IsNewEntrancePveById(id)
  return nil ~= id and nil ~= Table_PveRaidEntrance[id]
end
function PveEntranceProxy:GetCatalogData(c)
  return self.catalogMap[c]
end
function PveEntranceProxy:GetRaidData(groupid)
  return self.raidMap[groupid]
end
function PveEntranceProxy:GetDifficultyData(groupid, pvecardLayer)
  local diffDatas = {}
  local diffMap = self:GetRaidData(groupid)
  if diffMap then
    for k, data in pairs(diffMap) do
      if pvecardLayer then
        if data.pveCardlayer == pvecardLayer then
          diffDatas[#diffDatas + 1] = data
        end
      else
        diffDatas[#diffDatas + 1] = data
      end
    end
  end
  table.sort(diffDatas, function(a, b)
    return a.difficulty < b.difficulty
  end)
  return diffDatas
end
function PveEntranceProxy:GetRaidDifficultyData(type, difficulty)
  local map = self:GetRaidData(type)
  return map and map[difficulty]
end
function PveEntranceProxy:HandleSyncPvePassInfo(server_data, battletime)
  if not server_data and not battletime then
    return
  end
  self.battletime = battletime
  for i = 1, #server_data do
    self:UpdatePassInfo(server_data[i])
  end
  self:PreprocessCrackEntrance()
  self:SortEntrance()
  GameFacade.Instance:sendNotification(PVEEvent.SyncPvePassInfo)
end
function PveEntranceProxy:HandleTeamLeaderPveCardOpenState(server_passinfos)
  if not server_passinfos then
    return
  end
  for i = 1, #server_passinfos do
    self.teamLeaderOpenMap[server_passinfos[i].id] = server_passinfos[i].open
  end
end
function PveEntranceProxy:CheckTeamLeaderOpenState(id)
  return self.teamLeaderOpenMap[id]
end
function PveEntranceProxy:UpdatePassInfo(data)
  local typeInfo = self.passInfoMap[data.id]
  if nil == typeInfo then
    self.passInfoMap[data.id] = PvePassInfo.new(data)
  else
    typeInfo:Update(data)
  end
end
function PveEntranceProxy:IsOpen(id)
  local _teamMgr = TeamProxy.Instance
  if _teamMgr:IHaveTeam() and _teamMgr:CheckIHaveLeaderAuthority() then
    local leaderOpenState = self:CheckTeamLeaderOpenState(id)
    if nil ~= leaderOpenState then
      return leaderOpenState
    end
  end
  local passInfo = self:GetPassInfo(id)
  if nil ~= passInfo then
    return passInfo:IsOpen()
  end
  return false
end
function PveEntranceProxy:IsSweepOpen(id)
  local passInfo = self:GetPassInfo(id)
  if nil ~= passInfo then
    return passInfo:GetQuick()
  end
  return false
end
function PveEntranceProxy:IsPickup(id)
  local passInfo = self:GetPassInfo(id)
  if nil ~= passInfo then
    return passInfo:IsPickup()
  end
  return false
end
function PveEntranceProxy:GetPassInfo(id)
  return self.passInfoMap[id]
end
function PveEntranceProxy:GetPassTime(id)
  local info = self:GetPassInfo(id)
  return info and info:GetPassTime() or 0
end
function PveEntranceProxy:IsFirstPass(id)
  local info = self:GetPassInfo(id)
  return info and info:CheckFirstPass()
end
function PveEntranceProxy:IsPass(id)
  local info = self:GetPassInfo(id)
  return info and info:CheckPass()
end
function PveEntranceProxy:IsNorlenFirstPass(id)
  local info = self:GetPassInfo(id)
  return info and info:CheckNorlenFirstPass()
end
function PveEntranceProxy:GetWeeklyRoundRewardId(id)
  local info = self:GetPassInfo(id)
  return info and info:GetWeeklyRoundRewardId()
end
function PveEntranceProxy:GetDropData(key)
  return self.dropMap[key] or {}
end
function PveEntranceProxy:ResetDropReward(id)
  self.dropMap[id] = nil
end
local rewardTeamids
function PveEntranceProxy:SetRewardData(data)
  if not data then
    return
  end
  local id, firstPassReward, reward, probabilityReward = data.id, data.staticData.FirstPassReward, data.staticData.Reward, data.staticData.ProbabilityReward
  if nil ~= self.dropMap[id] then
    return
  end
  local result = {}
  local isFirstPass
  if data:IsPveCard() then
    isFirstPass = self:IsNorlenFirstPass(id)
  else
    isFirstPass = self:IsFirstPass(id)
  end
  if not isFirstPass then
    for i = 1, #firstPassReward do
      rewardTeamids = ItemUtil.GetRewardItemIdsByTeamId(firstPassReward[i])
      if rewardTeamids then
        for _, data in pairs(rewardTeamids) do
          local item = PveDropItemData.new("PveDropReward", data.id)
          item.num = data.num
          item:SetType(PveDropItemData.Type.E_First)
          result[#result + 1] = item
        end
      end
    end
  end
  local specialFirstPassRewardCfg = GameConfig.Pve.SpecialFirstPassReward
  local specialFirstPassReward = specialFirstPassRewardCfg and specialFirstPassRewardCfg[id]
  if specialFirstPassReward then
    for i = 1, #specialFirstPassReward do
      rewardTeamids = ItemUtil.GetRewardItemIdsByTeamId(specialFirstPassReward[i])
      if rewardTeamids then
        for _, data in pairs(rewardTeamids) do
          local item = PveDropItemData.new("PveDropReward", data.id)
          item.num = data.num
          local t = isFirstPass and PveDropItemData.Type.E_Normal or PveDropItemData.Type.E_First
          item:SetType(t)
          item:SetOwnPveId(id)
          result[#result + 1] = item
        end
      end
    end
  end
  for i = 1, #probabilityReward do
    rewardTeamids = ItemUtil.GetRewardItemIdsByTeamId(probabilityReward[i])
    if rewardTeamids then
      for _, data in pairs(rewardTeamids) do
        local item = PveDropItemData.new("PveDropReward", data.id)
        item.num = data.num
        item:SetType(PveDropItemData.Type.E_Probability)
        result[#result + 1] = item
      end
    end
  end
  for i = 1, #reward do
    rewardTeamids = ItemUtil.GetRewardItemIdsByTeamId(reward[i])
    if rewardTeamids then
      for _, data in pairs(rewardTeamids) do
        local item = PveDropItemData.new("PveDropReward", data.id)
        item.num = data.num
        item:SetType(PveDropItemData.Type.E_Normal)
        result[#result + 1] = item
      end
    end
  end
  local weeklyRoundRewardId = self:GetWeeklyRoundRewardId(id)
  if weeklyRoundRewardId and weeklyRoundRewardId > 0 then
    rewardTeamids = ItemUtil.GetRewardItemIdsByTeamId(weeklyRoundRewardId)
    if rewardTeamids then
      for _, data in pairs(rewardTeamids) do
        local item = PveDropItemData.new("PveDropReward", data.id)
        item.num = data.num
        item:SetType(PveDropItemData.Type.E_Probability)
        result[#result + 1] = item
      end
    end
  end
  self.dropMap[id] = result
end
function PveEntranceProxy:OpenTargetPve(t, gid)
  self:PreprocessTable()
  if not t then
    return
  end
  gid = gid or RaidType2GroupID[t]
  local targetData = self.targetMap[gid]
  if not targetData then
    targetData = self.raidMap[gid]
    if not next(targetData) then
      redlog("检查配置表 Table_PveRaidEntrance . RaidType: ", t)
      return
    end
    self.targetMap[gid] = targetData
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.PveView,
    viewdata = {
      targetData = {
        targetData[1]
      }
    }
  })
end
function PveEntranceProxy:OpenMultiTargetPve(t, gid)
  self:PreprocessTable()
  if not t then
    return
  end
  local resultList = {}
  for i = 1, #t do
    gid = gid or RaidType2GroupID[t[i]]
    local targetData = self.targetMap[gid]
    if not targetData then
      targetData = self.raidMap[gid]
      if not next(targetData) then
        redlog("检查配置表 Table_PveRaidEntrance . RaidType: ", t[i])
        return
      end
      self.targetMap[gid] = targetData
    end
    table.insert(resultList, targetData[1])
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.PveView,
    viewdata = {targetData = resultList}
  })
end
function PveEntranceProxy:OpenMultiTargetPveByGroupID(gids)
  self:PreprocessTable()
  if not gids then
    return
  end
  local resultList = {}
  local crackList = {}
  for i = 1, #gids do
    local targetData = self.targetMap[gids[i]]
    if targetData == nil then
      targetData = self.raidMap[gids[i]]
      if not next(targetData) then
        redlog("检查配置表 Table_PveRaidEntrance . 缺少groupid: ", gids[i])
        return
      end
      self.targetMap[gids[i]] = targetData
    end
    if targetData[1]:IsCrack() then
      crackList[#crackList + 1] = targetData[1]
    else
      resultList[#resultList + 1] = targetData[1]
    end
  end
  table.sort(crackList, function(l, r)
    return PveEntranceData.SortFunc(l, r)
  end)
  self.targetMaxLvEntranceData = nil
  for i = #crackList, 1, -1 do
    if crackList[i]:IsOpen() then
      self.targetMaxLvEntranceData = crackList[i]
      break
    end
  end
  if self.targetMaxLvEntranceData then
    table.insert(resultList, 1, self.targetMaxLvEntranceData)
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.PveView,
    viewdata = {targetData = resultList}
  })
end
function PveEntranceProxy:GetCurCrackRaidFirstEnternceData()
  return self.targetMaxLvEntranceData or self.crackRaidFirstEntranceData
end
function PveEntranceProxy:HandleSyncPveRaidAchieveFubenCmd(server_data)
  if not server_data then
    return
  end
  for i = 1, #server_data do
    self:UpdateAchieveInfo(server_data[i])
  end
  GameFacade.Instance:sendNotification(PVEEvent.SyncPvePassInfo)
end
function PveEntranceProxy:UpdateAchieveInfo(data)
  if not self.achieveMap then
    self.achieveMap = {}
  end
  local p = self.achieveMap[data.groupid]
  p = p or {}
  local achID
  for i = 1, #data.achieveids do
    local single = data.achieveids[i]
    achID = single.achieveid
    if achID then
      p[achID] = data.achieveids[i].pick
    end
  end
  self.achieveMap[data.groupid] = p
end
function PveEntranceProxy:CheckDone(groupid, index)
  if not self.achieveMap or not self.achieveMap[groupid] then
    return nil
  end
  return self.achieveMap[groupid][index]
end
function PveEntranceProxy:GetGroupAchieve(groupid)
  if not self.achieveMap or not self.achieveMap[groupid] or not self.achieveMap[groupid] then
    return 0
  end
  local count = 0
  for key, value in pairs(self.achieveMap[groupid]) do
    if value then
      count = count + 1
    end
  end
  return count
end
local BattleTimeStringColor = {
  [1] = "[000000]%d[-])",
  [2] = "[E4593D]%d[-]"
}
function PveEntranceProxy:GetBattleTimelen(cost, strFormat)
  local color = 1
  if (self.battletime or 0) < cost * 60 then
    color = 2
  end
  return string.format(strFormat, string.format(BattleTimeStringColor[color], cost)), color
end
function PveEntranceProxy:HandlePveCardTimes(data)
  self.pveCard_addTimes = data.addtimes
  self.pveCard_battleTime = data.battletime
  self.pveCard_totalBattleTime = data.totalbattletime
  self.pvecardTimeInited = true
end
function PveEntranceProxy:GetPveCardAddTimes()
  return self.pveCard_addTimes or 0
end
function PveEntranceProxy:HandlePveCardRewardTime(items)
  if not items then
    return
  end
  for i = 1, #items do
    self.pvecardRewardTime[items[i].diff] = {
      times = items[i].times,
      firstpass = items[i].firstpass
    }
  end
end
function PveEntranceProxy:GetPveCardRewardTime(diff)
  local rewardTimeData = self.pvecardRewardTime[diff]
  if not rewardTimeData then
    return 0, false
  else
    return rewardTimeData.times, rewardTimeData.firstpass
  end
end
function PveEntranceProxy:CanAddPveCardTime(show_msg)
  if not self.pvecardTimeInited then
    return
  end
  local config = GameConfig.AddPveCardTimes
  if not config then
    FunctionPve.Debug("未配置GameConfig.AddPveCardTimes")
    return false
  end
  local unit_price = config.BattleTime
  if not unit_price then
    FunctionPve.Debug("未配置GameConfig.AddPveCardTimes.BattleTime")
    return false
  end
  if unit_price > self.pveCard_battleTime then
    if show_msg then
      MsgManager.ShowMsgByID(43144)
    end
    return false
  end
  local limitTimes = config.LimitTimes
  if "number" == type(limitTimes) and limitTimes > 0 then
    if limitTimes <= self.pveCard_addTimes then
      if show_msg then
        MsgManager.ShowMsgByID(43143)
      end
      return false
    end
  else
    self.pvecard_noLimited = true
  end
  return true
end
function PveEntranceProxy:IsOpenByTeamGoal(teamgoal)
  local id = self.goalMap and self.goalMap[teamgoal]
  return self:IsOpen(id)
end
