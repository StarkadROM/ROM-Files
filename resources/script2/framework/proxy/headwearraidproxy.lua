HeadwearRaidProxy = class("HeadwearRaidProxy", pm.Proxy)
function HeadwearRaidProxy:ctor(proxyName, data)
  self.proxyName = proxyName or "HeadwearRaidProxy"
  if not HeadwearRaidProxy.Instance then
    HeadwearRaidProxy.Instance = self
  end
  if data then
    self:setData(data)
  end
  self:Init()
end
function HeadwearRaidProxy:Init()
  self.isActivityRaid = false
end
function HeadwearRaidProxy:InitRaidData(isActivity)
  self.isActivityRaid = isActivity
  self.towerSkillBtnData = nil
  self.monsters = {}
  self.round = 0
  if isActivity then
    self.config = GameConfig.HeadWearActivity
  else
    self.config = GameConfig.HeadWear
  end
  self.skip_time = self.config.skipTime
  self.rage_time = self.config.furyTime - self.config.skipTime
  self.hp_pct = 0
  self.crystals = {}
  for _, v in pairs(self.config.crystalIDs) do
    self.crystals[v] = 0
  end
  self.towers = {}
  for k, v in pairs(self.config.tower) do
    local tab = {}
    tab.id = k
    tab.level = self.config.Initiallevel or 0
    tab.crystals = {}
    tab.crystals[v.crystlA] = 0
    tab.crystals[v.crystlB] = 0
    tab.crystalInfo = {}
    TableUtility.ArrayPushBack(tab.crystalInfo, v.crystlA)
    TableUtility.ArrayPushBack(tab.crystalInfo, v.crystlB)
    tab.energybuff = v.energybuff or 0
    tab.bufflayer = v.bufflayer or 0
    tab.range = v.range or 0
    tab.towerlevel = v.towerlevel or 0
    tab.specskillname = v.specskillname or ""
    tab.specskillicon = v.specskillicon or ""
    self.towers[k] = tab
  end
  self.skills = {}
  for i = 1, #self.config.skills do
    TableUtility.ArrayPushBack(self.skills, self.config.skills[i])
  end
end
function HeadwearRaidProxy:RecvHeadwearNpcUserCmd(server_data)
  for i = 1, #server_data.npcs do
    self.monsters[server_data.npcs[i].round] = {
      round = server_data.npcs[i].round,
      first = server_data.npcs[i].firstid,
      second = server_data.npcs[i].secondid
    }
  end
end
function HeadwearRaidProxy:GetMonsterList()
  if #self.monsters > 0 then
    local result = {}
    for _, monster in pairs(self.monsters) do
      table.insert(result, monster)
    end
    return result
  end
end
function HeadwearRaidProxy:GetWeekRewardLimit()
  local data
  for _, d in pairs(Table_PveRaidEntrance) do
    if d.GroupId == 3 then
      data = d
      break
    end
  end
  if data then
    return data.RewardLimit
  end
end
function HeadwearRaidProxy:RecvHeadwearRoundUserCmd(server_data)
  if server_data.round ~= self.round then
    self.refreshRound = true
    self.round = server_data.round
    self.refreshTime = true
    self.skip_time = self.config.skipTime
    self.rage_time = self.config.furyTime - self.config.skipTime
  end
  if server_data.skiptime ~= 0 then
    self.refreshTime = true
    self.skip_time = server_data.skiptime
    self.rage_time = self.config.furyTime - self.config.skipTime
  end
  if server_data.furytime ~= 0 then
    self.refreshTime = true
    self.skip_time = 0
    self.rage_time = server_data.furytime
  end
  if server_data.blood ~= self.hp_pct then
    self.hp_pct = server_data.blood
    self.refreshHp = true
  end
  local crystal_id = 0
  local crystal_num = 0
  for i = 1, #server_data.crystals do
    crystal_id = server_data.crystals[i] >> 16
    crystal_num = server_data.crystals[i] & 65535
    if self.crystals[crystal_id] ~= crystal_num then
      self.refreshCrystal = true
      self.crystals[crystal_id] = crystal_num
    end
  end
  for i = 1, #server_data.skills do
    if self.skills[i] ~= server_data.skills[i] then
      self.refreshSkill = true
      self.skills[i] = server_data.skills[i]
    end
  end
end
function HeadwearRaidProxy:RecvHeadwearTowerUserCmd(server_data)
  if server_data.npcid ~= 0 then
    if not self.towers[server_data.npcid] then
      self.towers[server_data.npcid] = {}
      self.towers[server_data.npcid].id = server_data.npcid
      self.towers[server_data.npcid].refreshBuff = true
      self.towers[server_data.npcid].refreshCrystal = true
      self.towers[server_data.npcid].crystals = {}
    end
    if self.towers[server_data.npcid].level ~= server_data.level then
      self.towers[server_data.npcid].refreshCrystal = true
      self.towers[server_data.npcid].level = server_data.level
    end
    local crystal_id = 0
    local crystal_num = 0
    for i = 1, #server_data.crystals do
      if 0 < server_data.crystals[i] then
        crystal_id = server_data.crystals[i] >> 16
        crystal_num = server_data.crystals[i] & 65535
        if self.towers[server_data.npcid].crystals[crystal_id] ~= crystal_num then
          self.towers[server_data.npcid].refreshCrystal = true
          self.towers[server_data.npcid].crystals[crystal_id] = crystal_num
        end
      end
    end
  end
end
function HeadwearRaidProxy:RecvHeadwearEndUserCmd(data)
  if not data then
    LogUtility.Warning("RecvHeadwearRaidResult with data == nil")
    return
  end
  LogUtility.InfoFormat("Recv ExpRaidResult round:{0}, weektimes:{1}, coldtime:{2}", data.round, data.weektimes, data.coldtime)
  LogUtility.InfoFormat("NowTime:{0}", math.floor(ServerTime.CurServerTime() / 1000))
  if not data.round or not data.weektimes or not data.coldtime then
    LogUtility.Warning("RecvHeadwearRaidResult with the wrong data")
    return
  end
  self:CopyHeadwearRaidResultData(data)
  self:sendNotification(UIEvent.ShowUI, {
    viewname = "BattleResultView",
    callback = function()
      self:sendNotification(UIEvent.JumpPanel, self.showResultNotifyBody)
    end
  })
end
function HeadwearRaidProxy:RecvHeadwearActivityEndUserCmd(data)
  if not data then
    redlog("RecvHeadwearRaidResult with data == nil")
    return
  end
  LogUtility.InfoFormat("Recv ExpRaidResult round:{0}, weektimes:{1}, coldtime:{2}", data.round, data.weektimes, data.coldtime)
  LogUtility.InfoFormat("NowTime:{0}", math.floor(ServerTime.CurServerTime() / 1000))
  if not data.round or not data.coldtime then
    redlog("RecvHeadwearRaidResult with the wrong data")
    return
  end
  self:CopyHeadwearActivityRaidResultData(data)
  self:sendNotification(UIEvent.ShowUI, {
    viewname = "BattleResultView",
    callback = function()
      self:sendNotification(UIEvent.JumpPanel, self.showResultNotifyBody)
    end
  })
end
function HeadwearRaidProxy:CopyHeadwearRaidResultData(data)
  if not self.showResultNotifyBody then
    self.showResultNotifyBody = {}
  end
  TableUtility.TableClear(self.showResultNotifyBody)
  self.showResultNotifyBody.view = PanelConfig.HeadwearRaidResultView
  self.showResultNotifyBody.viewdata = {}
  local viewdata = self.showResultNotifyBody.viewdata
  viewdata.winNeedRound = self.config.batRound or 5
  viewdata.round = data.round
  viewdata.maxRound = self.config.maxRound or 15
  viewdata.weektimes = data.weektimes
  viewdata.weekMaxTime = self:GetWeekRewardLimit() or 4
  viewdata.closetime = data.coldtime
  viewdata.noRewardReason = data.type
  viewdata.iswin = viewdata.round >= viewdata.winNeedRound
  self.rewardDataArray = self.rewardDataArray or {}
  if next(self.rewardDataArray) then
    TableUtility.ArrayClear(self.rewardDataArray)
  end
  local itemid
  if data.coinanum and data.coinanum > 0 then
    itemid = self.config.rewardItem and self.config.rewardItem[1] or 100
    table.insert(self.rewardDataArray, DojoRewardData.new({
      id = itemid,
      count = data.coinanum or 0
    }))
  end
  if data.coinbnum and 0 < data.coinbnum then
    itemid = self.config.rewardItem and self.config.rewardItem[2] or 100
    table.insert(self.rewardDataArray, DojoRewardData.new({
      id = itemid,
      count = data.coinbnum or 0
    }))
  end
  viewdata.items = self.rewardDataArray
end
function HeadwearRaidProxy:CopyHeadwearActivityRaidResultData(data)
  if not self.showResultNotifyBody then
    self.showResultNotifyBody = {}
  end
  TableUtility.TableClear(self.showResultNotifyBody)
  self.showResultNotifyBody.view = PanelConfig.HeadwearRaidResultView
  self.showResultNotifyBody.viewdata = {}
  local viewdata = self.showResultNotifyBody.viewdata
  viewdata.winNeedRound = self.config.batRound or 5
  viewdata.round = data.round
  viewdata.maxRound = self.config.maxRound or 15
  viewdata.closetime = data.coldtime
  viewdata.noRewardReason = data.type
  viewdata.iswin = data.win
  viewdata.winNeedRound = data.minRewardRound
  self.rewardDataArray = self.rewardDataArray or {}
  if next(self.rewardDataArray) then
    TableUtility.ArrayClear(self.rewardDataArray)
  end
  local rewardList = {}
  if data.items then
    for i = 1, #data.items do
      local single = data.items[i]
      if not rewardList[single.id] then
        rewardList[single.id] = single.count
      else
        rewardList[single.id] = rewardList[single.id] + single.count
      end
    end
    for k, v in pairs(rewardList) do
      local data = {id = k, count = v}
      table.insert(self.rewardDataArray, DojoRewardData.new(data))
    end
  end
  viewdata.items = self.rewardDataArray
end
function HeadwearRaidProxy:UpdateTowerSkillBtn()
  if self.towerSkillBtnData then
    if self.towers[self.towerSkillBtnData.tower].isShow then
      return
    end
    QuickUseProxy.Instance:RemoveCommonNow(self.towerSkillBtnData)
    self.towerSkillBtnData = nil
  end
  local showId
  for k, v in pairs(self.towers) do
    if v.isShow then
      showId = k
      break
    end
  end
  if showId then
    self.towerSkillBtnData = {
      iconStr = self.towers[showId].specskillname,
      btnStr = ZhString.HeadwearRaid_UseTowerSkill,
      iconType = "skillIcon",
      iconID = self.towers[showId].specskillicon,
      tower = showId,
      ClickCall = function()
        self:CallUseTowerSkill()
      end
    }
    QuickUseProxy.Instance:AddCommonCallBack(self.towerSkillBtnData)
  end
end
function HeadwearRaidProxy:CallUseTowerSkill()
  if self.towerSkillBtnData then
    if self.isActivityRaid then
      ServiceRaidCmdProxy.Instance:CallHeadwearActivityRangeUserCmd(self.towerSkillBtnData.tower)
    else
      ServiceNUserProxy.Instance:CallHeadwearRangeUserCmd(self.towerSkillBtnData.tower)
    end
  end
  self.towers[self.towerSkillBtnData.tower].isShow = nil
  self.towers[self.towerSkillBtnData.tower].lastUseSkillTime = ServerTime.CurClientTime()
  self:UpdateTowerSkillBtn()
end
function HeadwearRaidProxy:CallUpgradeTower(towerid, crystals)
  local crystalCompose = {}
  for k, v in pairs(crystals) do
    if v > 0 then
      local crCompose = (k << 16) + (v & 65535)
      TableUtility.ArrayPushBack(crystalCompose, crCompose)
    end
  end
  if self.isActivityRaid then
    ServiceRaidCmdProxy.Instance:CallHeadwearActivityTowerUserCmd(towerid, 0, crystalCompose)
  else
    ServiceNUserProxy.Instance:CallHeadwearTowerUserCmd(towerid, 0, crystalCompose)
  end
end
function HeadwearRaidProxy:GetTowerInfo(towerid)
  return self.towers and self.towers[towerid]
end
function HeadwearRaidProxy:IsHeadwearRaidTower(staticid)
  return self.towers and self.towers[staticid]
end
function HeadwearRaidProxy:IsHeadwearRaidSkill(skillid)
  return TableUtility.ArrayFindIndex(self.skills, skillid) ~= 0
end
function HeadwearRaidProxy:GetHeadwearRaidCrystalNum(crystalId)
  return self.crystals and self.crystals[crystalId]
end
function HeadwearRaidProxy:UpdateTowers()
  for k, _ in pairs(self.towers) do
    self:UpdateTowerBuffSkillStatus(k)
  end
  self:UpdateTowerSkillBtn()
end
function HeadwearRaidProxy:UpdateTowerBuffSkillStatus(towerid)
  local currentClientTime = ServerTime.CurClientTime()
  local tower = NSceneNpcProxy.Instance:FindNpcs(towerid)
  if tower and next(tower) then
    tower = tower[1]
    local sceneUI = tower:GetSceneUI()
    if sceneUI then
      sceneUI.roleBottomUI:UpdateHeadwearRaidTowerInfo(tower)
    end
    local towerinfo = self:GetTowerInfo(towerid)
    if towerinfo.level >= towerinfo.towerlevel then
      local buffLayerOK = tower:GetBuffLayer(towerinfo.energybuff) >= towerinfo.bufflayer
      if buffLayerOK and (not self.towers[towerid].lastUseSkillTime or currentClientTime - self.towers[towerid].lastUseSkillTime >= self.config.towerskillCD) then
        local rangeSq = towerinfo.range * towerinfo.range
        local disSq = VectorUtility.DistanceXZ_Square(Game.Myself:GetPosition(), tower:GetPosition())
        if rangeSq >= disSq then
          self.towers[towerid].isShow = true
          return
        end
      end
    end
  end
  self.towers[towerid].isShow = false
end
