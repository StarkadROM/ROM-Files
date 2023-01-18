autoImport("MainStageData")
DungeonProxy = class("DungeonProxy", pm.Proxy)
DungeonProxy.Instance = nil
DungeonProxy.NAME = "DungeonProxy"
DungeonProxy.RoguelikeCoinId = 5900
function DungeonProxy:ctor(proxyName, data)
  self.proxyName = proxyName or DungeonProxy.NAME
  self.lastChallengeSubStage = nil
  if DungeonProxy.Instance == nil then
    DungeonProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
end
function DungeonProxy:Init()
  self.mainStageMap = {}
  self.mainStageList = {}
  self.maxMainStageID = 0
  self.maxMainStep = 0
  local mainStage
  for id, data in pairs(Table_Ectype) do
    mainStage = MainStageData.new(id, data)
    self.mainStageMap[id] = mainStage
    self.mainStageList[#self.mainStageList + 1] = mainStage
  end
  table.sort(self.mainStageList, function(l, r)
    return l.id < r.id
  end)
  for i = 1, #self.mainStageList do
    self.mainStageList[i].previous = self.mainStageList[i - 1]
    self.mainStageList[i].next = self.mainStageList[i + 1]
  end
  if #self.mainStageList > 0 then
    self.mainStageList[1]:SetState(MainStageData.UnLockState)
  end
  self.januaryRaidRewards = {}
end
function DungeonProxy:onRegister()
end
function DungeonProxy:onRemove()
end
function DungeonProxy:Reconnect()
  self:ResetRaidSelectCard()
end
function DungeonProxy:GetMainStage(id)
  return self.mainStageMap[id]
end
function DungeonProxy:InitMainStageInfo(serverList)
  self.initedMainStage = true
  local mainStage, data
  for i = 1, #serverList do
    data = serverList[i]
    mainStage = self.mainStageMap[data.id]
    mainStage:SetStar(data.star)
    mainStage:SetGetRewards(data.getList)
    mainStage:SetState(MainStageData.UnLockState)
  end
end
function DungeonProxy:SetNormalStageProgress(id, stepID)
  self.maxMainStageID = id
  self.maxMainStep = stepID
  local mainPreviousStage = self.mainStageMap[id - 1]
  if mainPreviousStage ~= nil then
    mainPreviousStage:TryInitSubs()
    mainPreviousStage:SetEliteStep(1)
  end
  if self:HandlerCurrent(id, stepID) == false and mainPreviousStage ~= nil then
    stepID = mainPreviousStage:MaxNormalStep()
    self:HandlerCurrent(mainPreviousStage.id, stepID)
  end
end
function DungeonProxy:HandlerCurrent(id, stepid)
  local mainStage = self.mainStageMap[id]
  if mainStage == nil then
    return false
  end
  mainStage:TryInitSubs()
  mainStage:SetNormalStep(stepid)
  mainStage:SetState(MainStageData.UnLockState)
  return true
end
function DungeonProxy:GetReward(stageID, star)
  local mainStage = self.mainStageMap[stageID]
  mainStage:AddGetReward(star)
end
function DungeonProxy:UpdateMainStageSubs(data)
  local mainStage = self.mainStageMap[data.stageid]
  mainStage.isServerSync = true
  mainStage:TryInitSubs()
  mainStage:SetNormalSubStars(data.normalist)
  mainStage:SetEliteSub(data.hardlist)
end
function DungeonProxy:UpdateMainStageInfo(data)
  local mainStage = self.mainStageMap[data.stageid]
  if mainStage then
    if data.type == SubStageData.EliteType then
      self.lastChallengeSubStage = mainStage.eliteSubStage[data.stepid]
    else
      self.lastChallengeSubStage = mainStage.normalSubStage[data.stepid]
    end
  end
  if mainStage.isServerSync then
    if data.type == SubStageData.EliteType then
      mainStage:SetEliteSub(data.stepid, data.star == 1)
      mainStage:SetEliteSub(data.stepid + 1)
    elseif data.type == SubStageData.NormalType then
      local addStar = mainStage:SetNormalSubStar(data.stepid, data.star)
      mainStage:SetStar(addStar + mainStage.currentStars)
      if mainStage.id == self.maxMainStageID and data.stepid == self.maxMainStep then
        local nextMain = 0
        local nextSub = 0
        if self.maxMainStep >= mainStage:MaxNormalStep() then
          nextMain = self.maxMainStageID + 1
          nextSub = 1
        else
          nextMain = self.maxMainStageID
          nextSub = self.maxMainStep + 1
        end
        self:StepForward(nextMain, nextSub)
      end
    end
  end
end
function DungeonProxy:StepForward(id, step)
  self:SetNormalStageProgress(id, step)
end
function DungeonProxy:GetPreivousSub(subStage)
  if subStage.staticData.Step == 1 then
    if subStage.type == SubStageData.NormalType then
      local mainPreviousStage = self.mainStageMap[subStage.mainStage.id - 1]
      if mainPreviousStage ~= nil then
        mainPreviousStage:TryInitSubs()
        return mainPreviousStage.normalSubStage[mainPreviousStage:MaxNormalStep()]
      end
      return nil
    elseif subStage.type == SubStageData.EliteType then
      return subStage.mainStage.eliteSubStage[#subStage.mainStage.eliteSubStage]
    end
  elseif subStage.type == SubStageData.NormalType then
    return subStage.mainStage.normalSubStage[subStage.staticData.Step - 1]
  elseif subStage.type == SubStageData.EliteType then
    return subStage.mainStage.eliteSubStage[subStage.staticData.Step - 1]
  end
end
function DungeonProxy:DebugLog()
  local mainStage
  for i = 1, #self.mainStageList do
    mainStage = self.mainStageList[i]
    mainStage:DebugLog()
  end
end
function DungeonProxy:RequestCreateSingleTeam(raidType)
  FunctionPlayerTip.CreateTeam()
  self.createSingleTeamRequested = raidType
  TimeTickManager.Me():CreateOnceDelayTick(3000, function(owner, deltaTime)
    self.createSingleTeamRequested = nil
  end, self)
end
function DungeonProxy.InviteTeamRaid(isCancel, raidType, isFromNpcFunc, customStartFunc, difficulty)
  if raidType ~= ERAIDTYPE_SEAL then
    if TeamProxy.Instance:ForbiddenByRaidType(raidType) then
      MsgManager.ShowMsgByID(42042)
      return
    end
    local t = PvpProxy.RaidType2PvpType[raidType]
    if t and not TeamProxy.Instance:CheckMatchTypeSupportDiffServer(t) then
      MsgManager.ShowMsgByID(42042)
      return
    end
  end
  if not TeamProxy.Instance:IHaveTeam() then
    if raidType == FuBenCmd_pb.ERAIDTYPE_HEADWEAR or raidType == FuBenCmd_pb.ERAIDTYPE_COMODO_TEAM_RAID or raidType == FuBenCmd_pb.ERAIDTYPE_SEVEN_ROYAL_TEAM_RAID or raidType == FuBenCmd_pb.ERAIDTYPE_HEADWEARACTIVITY then
      DungeonProxy.Instance:RequestCreateSingleTeam(raidType)
      return
    else
      MsgManager.ShowMsgByIDTable(332)
      return
    end
  end
  local memberList = TeamProxy.Instance.myTeam:GetMembersList()
  local hasMemberInRaid, raid, raidData = false, nil, nil
  for i = 1, #memberList do
    raid = not memberList[i]:IsOffline() and memberList[i].raid
    raidData = raid and Table_MapRaid[raid]
    if raidData and raidData.Type == raidType then
      hasMemberInRaid = true
      break
    end
  end
  if hasMemberInRaid and (raidType ~= FuBenCmd_pb.ERAIDTYPE_COMODO_TEAM_RAID or raidType ~= FuBenCmd_pb.ERAIDTYPE_SEVEN_ROYAL_TEAM_RAID) then
    ServiceTeamRaidCmdProxy.Instance:CallTeamRaidEnterCmd(raidType)
    return
  end
  if not TeamProxy.Instance:CheckIHaveLeaderAuthority() then
    MsgManager.ShowMsgByIDTable(7303)
    return
  end
  RaidEnterWaitView.SetListenEvent(ServiceEvent.TeamRaidCmdTeamRaidReplyCmd, function(view, note)
    local charid, agree = note.body.charid, note.body.reply
    view:UpdateMemberEnterState(charid, agree)
    view:UpdateWaitList()
  end)
  RaidEnterWaitView.SetListenEvent(TeamEvent.MemberOffline, function(view)
    view:UpdateWaitList()
  end)
  RaidEnterWaitView.SetListenEvent(TeamEvent.MemberOnline, function(view)
    view:UpdateWaitList()
  end)
  RaidEnterWaitView.SetStartFunc(function(view)
    ServiceTeamRaidCmdProxy.Instance:CallTeamRaidEnterCmd(raidType, nil, nil, nil, nil, difficulty)
    if type(customStartFunc) == "function" then
      customStartFunc()
    end
  end)
  RaidEnterWaitView.SetCancelFunc(function(view)
    ServiceTeamRaidCmdProxy.Instance:CallTeamRaidInviteCmd(true, raidType)
  end)
  RaidEnterWaitView:SetShowOfflineMembersInWaitList(true)
  RaidEnterWaitView.PreEnableButton_Start(false)
  RaidEnterWaitView.SetAllApplyCall(function(view)
    view:EnableButton_Start(view:IsAllMembersAgreed())
  end, true)
  if not hasMemberInRaid or hasMemberInRaid and (raidType ~= FuBenCmd_pb.ERAIDTYPE_COMODO_TEAM_RAID or raidType ~= FuBenCmd_pb.ERAIDTYPE_SEVEN_ROYAL_TEAM_RAID) then
    ServiceTeamRaidCmdProxy.Instance:CallTeamRaidInviteCmd(isCancel, raidType, difficulty)
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.RaidEnterWaitView,
      viewdata = {isNpcFuncView = isFromNpcFunc}
    })
  elseif hasMemberInRaid and raidType == FuBenCmd_pb.ERAIDTYPE_COMODO_TEAM_RAID or raidType == FuBenCmd_pb.ERAIDTYPE_SEVEN_ROYAL_TEAM_RAID then
    MsgManager.ShowMsgByIDTable(26228)
  end
end
function DungeonProxy.CanShowDeathPopView()
  return not Game.MapManager:IsPVEMode_HeadwearRaid() and not Game.MapManager:IsInGuildRaidMap() and (not Game.MapManager:IsPVEMode_Roguelike() or not UIManagerProxy.Instance:HasUINode(PanelConfig.RoguelikeResultView))
end
function DungeonProxy:InitCards()
  if self.cache_cards == nil then
    self.cache_cards = {}
  else
    TableUtility.TableClear(self.cache_cards)
  end
end
function DungeonProxy:ReSetCardDatas(server_cards)
  self:InitCards()
  local server_card
  for i = 1, #server_cards do
    server_card = server_cards[i]
    local cache = {}
    self.cache_cards[server_card.index] = cache
    TableUtility.ArrayShallowCopy(cache, server_card.cardids)
  end
end
function DungeonProxy:GetCardDatas()
  return self.cache_cards
end
function DungeonProxy:GetCardData(index)
  if self.cache_cards == nil then
    return
  end
  return self.cache_cards[index]
end
function DungeonProxy:SyncProcessPveCard(select_index, cardIds, progress)
  self.select_cardIds = {}
  for i = 1, #cardIds do
    table.insert(self.select_cardIds, cardIds[i])
  end
  self.select_index = select_index
  self:UpdateProcessPveCard(progress)
  helplog("SyncProcessPveCard:", select_index, #self.select_cardIds, progress)
end
function DungeonProxy:UpdateProcessPveCard(progress)
  helplog("UpdateProcessPveCard", progress)
  self.now_progress = progress
end
function DungeonProxy:GetNowProgress()
  return self.now_progress
end
function DungeonProxy:GetNowPveCardPlayingIndex()
  return self.select_index
end
function DungeonProxy:GetNextPlayingCardIds()
  if self.select_cardIds == nil then
    return
  end
  local progress = self.now_progress
  if progress == nil or progress == 0 then
    return
  end
  local result = {}
  for i = 0, 2 do
    local v = self.select_cardIds[progress + i]
    if v ~= nil then
      table.insert(result, v)
    end
  end
  return result
end
function DungeonProxy:GetSelectCardIds()
  return self.select_cardIds
end
function DungeonProxy:GetConfigPvpTeamRaid()
  local raidId = Game.MapManager:GetRaidID()
  local _PvpTeamRaid = GameConfig.PvpTeamRaid[raidId]
  if _PvpTeamRaid == nil then
    _, _PvpTeamRaid = next(GameConfig.PvpTeamRaid)
  end
  return _PvpTeamRaid
end
function DungeonProxy:GetOthelloConfigRaid()
  local raidConfig = GameConfig.Othello.RaidMode
  if raidConfig then
    return raidConfig[1]
  end
  return nil
end
function DungeonProxy:UpdateAltManRaidInfo(lefttime, killcount, selfkill)
  self.altman_lefttime = lefttime or 0
  self.altman_killcount = killcount or 0
  self.altman_selfkill = selfkill or 0
end
function DungeonProxy:GetAltManRaidInfo()
  return self.altman_lefttime, self.altman_killcount, self.altman_selfkill
end
function DungeonProxy:RecvAltmanRewardUserCmd(data)
  self.passtime = data.passtime or 0
  if data.items then
    if not self.rewardmap then
      self.rewardmap = {}
    end
    local items = data.items
    local len = #items
    for i = 1, len do
      local single = items[i]
      self.rewardmap[single.rewardid] = single.status
    end
  end
end
function DungeonProxy:GetRewardStatus(rewardid)
  if self.rewardmap and self.rewardmap[rewardid] then
    return self.rewardmap[rewardid]
  end
  return nil
end
local ratinglist = GameConfig.EVA.time_rank_desc
function DungeonProxy:GetMyRate()
  for i = 1, #ratinglist do
    local single = ratinglist[i]
    if self.passtime and self.passtime ~= 0 and self.passtime <= single.time then
      return single.id
    end
  end
  return 0
end
function DungeonProxy:CheckRedtip()
  if self.rewardmap then
    for k, v in pairs(self.rewardmap) do
      if v == SceneUser2_pb.EREWEARD_STATUS_CAN_GET then
        return true
      end
    end
  end
  return false
end
function DungeonProxy:UpdateIPRaidInfo(lefttime, killcount, selfkill)
  self.ipraid_lefttime = lefttime or 0
  self.ipraid_killcount = killcount or 0
  self.ipraid_selfkill = selfkill or 0
end
function DungeonProxy:GetIPRaidInfo()
  return self.ipraid_lefttime, self.ipraid_killcount, self.ipraid_selfkill
end
function DungeonProxy:InviteRoguelike(isSingle, grade, saveDataIndex)
  local lvLimit, teamIns = GameConfig.Roguelike.LimitLv, TeamProxy.Instance
  if lvLimit > Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL) then
    MsgManager.ShowMsgByID(204)
    return
  end
  if TeamProxy.Instance:ForbiddenByRaidType(FuBenCmd_pb.ERAIDTYPE_ROGUELIKE) then
    MsgManager.ShowMsgByID(42042)
    return
  end
  if not teamIns:IHaveTeam() then
    FunctionPlayerTip.CreateTeam()
    self.roguelikeCreateSingleTeamRequested = isSingle
    TimeTickManager.Me():CreateOnceDelayTick(3000, function(owner, deltaTime)
      self.roguelikeCreateSingleTeamRequested = nil
    end, self)
    return
  end
  local memberList = teamIns.myTeam:GetPlayerMemberList(true, false)
  if #memberList > GameConfig.Roguelike.MaxTeamUser then
    MsgManager.ShowMsgByID(40717)
    return
  end
  if isSingle then
    memberList = teamIns.myTeam:GetPlayerMemberList(false, true)
    if #memberList > 0 then
      MsgManager.ShowMsgByID(40711)
      return
    end
  else
    if not teamIns:CheckIHaveLeaderAuthority() then
      MsgManager.ShowMsgByIDTable(7303)
      return
    end
    local saveData = self:GetRoguelikeSaveData(false, saveDataIndex)
    local saveDataUsers, user = saveData and saveData.users, nil
    local myMemberList = teamIns.myTeam:GetPlayerMemberList(true, true)
    for i = 1, #myMemberList do
      user = myMemberList[i]
      if lvLimit > user.baselv then
        MsgManager.ShowMsgByID(39203)
        return
      end
      if saveDataUsers and not TableUtility.ArrayFindByPredicate(saveDataUsers, function(data)
        return data.charid == user.id and not user:IsOffline()
      end) then
        MsgManager.ShowMsgByID(40714)
        return
      end
    end
    if saveDataUsers then
      for i = 1, #saveDataUsers do
        if not TableUtility.ArrayFindByPredicate(myMemberList, function(data)
          return data.id == saveDataUsers[i].charid
        end) then
          MsgManager.ShowMsgByID(40714)
          return
        else
        end
      end
    else
    end
  end
  RaidEnterWaitView.SetListenEvent(ServiceEvent.RoguelikeCmdRoguelikeReplyCmd, function(view, note)
    local charId, agreed = note.body.charid, note.body.reply
    view:UpdateMemberEnterState(charId, agreed)
    view:UpdateWaitList()
  end)
  local weekMode = FunctionPlayerPrefs.Me():GetBool(LocalSaveProxy.SAVE_KEY.RoguelikeWeekMode)
  RaidEnterWaitView.SetStartFunc(function(view)
    self:ClearRoguelikeStatistics()
    ServiceRoguelikeCmdProxy.Instance:CallRoguelikeCreateCmd(grade, Game.Myself.data.id, saveDataIndex)
    self:SetCurrentRoguelikeSaveDataIndex(saveDataIndex)
  end)
  RaidEnterWaitView.SetCancelFunc(function(view)
    ServiceRoguelikeCmdProxy.Instance:CallRoguelikeInviteCmd(false, grade, saveDataIndex, nil, weekMode)
  end)
  RaidEnterWaitView:SetShowOfflineMembersInWaitList(true)
  RaidEnterWaitView.PreEnableButton_Start(false)
  RaidEnterWaitView.SetAllApplyCall(function(view)
    view:EnableButton_Start(view:IsAllMembersAgreed())
  end, true)
  ServiceRoguelikeCmdProxy.Instance:CallRoguelikeInviteCmd(true, grade, saveDataIndex, nil, weekMode)
  self.roguelikeCreateSingleTeamRequested = nil
end
function DungeonProxy.ReplyRoguelikeInvite(agreed)
  DungeonProxy.Instance:ClearRoguelikeStatistics()
  ServiceRoguelikeCmdProxy.Instance:CallRoguelikeReplyCmd(agreed, Game.Myself.data.id)
end
function DungeonProxy.RequestRoguelikeMaxGrade()
  ServiceRoguelikeCmdProxy.Instance:CallRoguelikeInfoCmd()
end
function DungeonProxy:SetRoguelikeMaxGrade(grade)
  if type(grade) ~= "number" then
    LogUtility.Warning("RoguelikeMaxGrade is nil")
  end
  self.roguelikeMaxGrade = grade or 0
end
function DungeonProxy:GetRoguelikeSaveData(isSingle, index)
  local localDatas = isSingle and self.roguelikeSingleSaveDatas or self.roguelikeMultiSaveDatas
  if type(index) == "number" then
    return localDatas[index]
  else
    return localDatas
  end
end
function DungeonProxy:UpdateRoguelikeRaidInfo(serverData)
  local raid = self.roguelikeRaid or {}
  raid.scoreModeTime = serverData.time
  raid.keyCount = serverData.keynum
  raid.reliveCount = serverData.relive
  raid.score = serverData.score
  raid.grade = serverData.layer
  raid.exitRoom = serverData.exitroom
  if raid.curRoomIndex ~= serverData.current_room then
    self:sendNotification(RoguelikeEvent.RoomChange, serverData.current_room)
  end
  raid.curRoomIndex = serverData.current_room
  raid.unlockRooms = raid.unlockRooms or {}
  TableUtility.ArrayClear(raid.unlockRooms)
  TableUtility.ArrayShallowCopy(raid.unlockRooms, serverData.unlockrooms)
  self:UpdateRoguelikeItem(raid, serverData.items)
  raid.npcVisitorMap = raid.npcVisitorMap or {}
  TableUtility.TableClear(raid.npcVisitorMap)
  local pair
  for i = 1, #serverData.visited_npcs do
    pair = serverData.visited_npcs[i]
    raid.npcVisitorMap[pair.npcguid] = pair.visitor
  end
  raid.finishRoomMap = raid.finishRoomMap or {}
  TableUtility.TableClear(raid.finishRoomMap)
  for i = 1, #serverData.finishrooms do
    raid.finishRoomMap[serverData.finishrooms[i]] = true
  end
  local exCharged = raid.bottleCharged
  raid.bottleCharged = serverData.bottle_charged
  if exCharged == false and raid.bottleCharged == true then
    MsgManager.ShowMsgByID(26265)
    local myRole = Game.Myself.assetRole
    if myRole then
      myRole:PlayEffectOneShotOn("Skill/Eff_taluopai_sengquan_buff", 3)
    end
  end
  self.roguelikeRaid = raid
end
local swapListElements = function(list, lIndex, rIndex)
  if lIndex == rIndex then
    return
  end
  local t = list[lIndex]
  list[lIndex] = list[rIndex]
  list[rIndex] = t
end
function DungeonProxy:UpdateRoguelikeItem(raid, serverItems)
  raid.items = raid.items or {}
  raid.coinCount = 0
  local staticIdMap, magicBottleItemId = ReusableTable.CreateTable(), GameConfig.Roguelike.MagicBottleItemID
  local dataId, itemData, item, sId, maxNum, num = 1, nil, nil, nil, nil, nil
  for i = 1, #serverItems do
    item = serverItems[i]
    sId = item.id
    if sId == DungeonProxy.RoguelikeCoinId then
      raid.coinCount = raid.coinCount + item.count
    else
      maxNum = Table_Item[sId] and Table_Item[sId].MaxNum
      if not maxNum or maxNum <= 0 then
        maxNum = item.count
      end
      num = item.count
      while num > 0 do
        itemData = raid.items[dataId] or ItemData.new()
        itemData:ResetData(dataId, sId)
        itemData.num = math.min(num, maxNum)
        raid.items[dataId] = itemData
        staticIdMap[sId] = (staticIdMap[sId] or 0) + itemData.num
        num = num - maxNum
        dataId = dataId + 1
      end
    end
  end
  raid.magicBottleCount = staticIdMap[magicBottleItemId] or 0
  if not staticIdMap[magicBottleItemId] then
    itemData = raid.items[dataId] or ItemData.new()
    itemData:ResetData("MagicBottle", magicBottleItemId)
    itemData.num = 0
    raid.items[dataId] = itemData
    dataId = dataId + 1
  end
  for i = dataId, #raid.items do
    raid.items[i] = nil
  end
  TableUtility.TableClear(staticIdMap)
  for i = 1, #raid.items do
    sId = raid.items[i].staticData.id
    if not staticIdMap[sId] then
      staticIdMap[sId] = i
    end
  end
  local forceCfg, forcedItemIndex, index = GameConfig.Roguelike.TarotItemForceIndex, 1, nil
  for i = 1, #forceCfg do
    sId = forceCfg[i]
    index = staticIdMap[sId]
    if index then
      while index <= #raid.items and raid.items[index].staticData.id == sId do
        swapListElements(raid.items, forcedItemIndex, index)
        forcedItemIndex = forcedItemIndex + 1
        index = index + 1
      end
    end
  end
  local tmp = ReusableTable.CreateArray()
  for i = forcedItemIndex, #raid.items do
    TableUtility.ArrayPushBack(tmp, raid.items[i])
  end
  table.sort(tmp, function(l, r)
    return l.staticData.id < r.staticData.id
  end)
  for i = 1, #tmp do
    raid.items[i + forcedItemIndex - 1] = tmp[i]
  end
  ReusableTable.DestroyAndClearArray(tmp)
  ReusableTable.DestroyAndClearTable(staticIdMap)
end
function DungeonProxy:UpdateScoreMode(data)
  self.isRoguelikeScoreMode = data.scoremodel and true or false
end
function DungeonProxy:GetRoguelikeItemNumByStaticId(id)
  if not self.roguelikeRaid then
    return 0
  end
  local c = 0
  for _, data in pairs(self.roguelikeRaid.items) do
    if data.staticData.id == id then
      c = c + data.num
    end
  end
  return c
end
function DungeonProxy:GetRoguelikeItemByStaticId(id)
  if not self.roguelikeRaid then
    return
  end
  for _, data in pairs(self.roguelikeRaid.items) do
    if data.staticData.id == id then
      return data
    end
  end
end
function DungeonProxy.RequestRoguelikeRankInfo(isSingle, page)
  ServiceRoguelikeCmdProxy.Instance:CallRoguelikeQueryBoardCmd(isSingle and 0 or 1, page or 1)
end
local copyRoguelikeRankData = function(target, source)
  target.rank = source.rank
  target.score = source.score
  target.grade = source.layer
  target.time = source.time
end
local copyUserPortraitData = function(target, source)
  target.portrait = source.portrait
  target.body = source.body
  target.hair = source.hair
  target.haircolor = source.haircolor
  target.gender = source.gender
  target.head = source.head
  target.face = source.face
  target.mouth = source.mouth
  target.eye = source.eye
  target.portrait_frame = source.portrait_frame
end
local copyRoguelikeUserData = function(target, source)
  target.charid = source.charid
  target.name = source.name
  target.level = source.level
  target.profession = source.profession
  target.portrait = target.portrait or {}
  copyUserPortraitData(target.portrait, source.portrait)
end
function DungeonProxy:UpdateRoguelikeRankInfo(isSingle, serverDatas, myselfData)
  if not self.roguelikeSingleRankData then
    self.roguelikeSingleRankData = {}
    self.roguelikeMultiRankData = {}
    self.roguelikeRankDataSearchResult = {}
    self.roguelikeMyselfSingleRankData = {}
    self.roguelikeMyselfMultiRankData = {}
  end
  local target, data, serverData = self:GetRoguelikeRankData(isSingle)
  for i = 1, #serverDatas do
    serverData = serverDatas[i]
    data = target[serverData.rank] or {}
    copyRoguelikeRankData(data, serverData)
    data.user = data.user or {}
    copyRoguelikeUserData(data.user, serverData)
    target[serverData.rank] = data
  end
  if myselfData and myselfData.charid == Game.Myself.data.id then
    copyRoguelikeRankData(self:GetRoguelikeMyselfRankData(isSingle), myselfData)
  end
  TableUtility.TableClear(self.roguelikeRankDataSearchResult)
end
function DungeonProxy:GetRoguelikeRankData(isSingle, dataCount)
  local data
  if isSingle ~= false and isSingle ~= nil then
    data = self.roguelikeSingleRankData
  else
    data = self.roguelikeMultiRankData
  end
  if type(dataCount) ~= "number" or dataCount <= 0 then
    return data
  end
  TableUtility.TableClear(self.roguelikeRankDataSearchResult)
  for i = 1, math.min(dataCount, #data) do
    self.roguelikeRankDataSearchResult[i] = data[i]
  end
  return self.roguelikeRankDataSearchResult
end
function DungeonProxy:GetRoguelikeMyselfRankData(isSingle)
  if isSingle ~= false and isSingle ~= nil then
    return self.roguelikeMyselfSingleRankData
  else
    return self.roguelikeMyselfMultiRankData
  end
end
function DungeonProxy:GetRoguelikeRankSearchResult(isSingle, keyword, range)
  if not self.roguelikeRankDataSearchResult then
    LogUtility.Error("You're trying to search Roguelike rank data before the rank data is initialized!")
    return
  end
  TableUtility.TableClear(self.roguelikeRankDataSearchResult)
  keyword = string.lower(keyword)
  range = range or GameConfig.Roguelike.RankShowNum
  local source, data = self:GetRoguelikeRankData(isSingle)
  for i = 1, math.min(range, #source) do
    data = source[i]
    if data.user and string.find(string.lower(data.user.name), keyword) then
      TableUtility.ArrayPushBack(self.roguelikeRankDataSearchResult, data)
    end
  end
  return self.roguelikeRankDataSearchResult
end
function DungeonProxy:GetRoguelikeNpcOptionName(npcId, opt)
  if not self.roguelikeEventStaticData then
    self.roguelikeEventStaticData = {}
    local optionDescMap
    for _, data in pairs(Table_RoguelikeEvent) do
      optionDescMap = self.roguelikeEventStaticData[data.NpcID] or {}
      optionDescMap[data.Option] = data.Desc
      self.roguelikeEventStaticData[data.NpcID] = optionDescMap
    end
  end
  if not npcId or not opt then
    return
  end
  return self.roguelikeEventStaticData[npcId] and self.roguelikeEventStaticData[npcId][opt]
end
function DungeonProxy.RequestRoguelikeShopData()
  ServiceRoguelikeCmdProxy.Instance:CallRoguelikeShopCmd(RoguelikeCmd_pb.ROGUESHOPOPT_QUERY)
end
function DungeonProxy.RefreshRoguelikeShopData()
  ServiceRoguelikeCmdProxy.Instance:CallRoguelikeShopCmd(RoguelikeCmd_pb.ROGUESHOPOPT_REFRESH)
end
function DungeonProxy.BuyRoguelikeShopData(id)
  ServiceRoguelikeCmdProxy.Instance:CallRoguelikeShopCmd(RoguelikeCmd_pb.ROGUESHOPOPT_BUY, id)
end
function DungeonProxy.RoguelikeUseItem(id, count)
  ServiceRoguelikeCmdProxy.Instance:CallRoguelikeUseItemCmd(id, count)
end
function DungeonProxy:CheckRoguelikeItemUsable(itemId)
  return Game.MapManager:IsPVEMode_Roguelike() and self:GetRoguelikeItemNumByStaticId(itemId) > 0
end
local copyRoguelikeShopData = function(target, source)
  if source.itemData then
    target.itemData = source.itemData
  elseif source.id then
    target.itemData = ItemData.new("RoguelikeShopItem", source.id)
  end
  target.cost = source.coin
  target.soldOut = source.sold
end
function DungeonProxy:UpdateRoguelikeShopData(serverDatas, refreshedCount)
  self.roguelikeShopData = self.roguelikeShopData or {}
  local data
  for i = 1, #serverDatas do
    data = self.roguelikeShopData[i] or {}
    copyRoguelikeShopData(data, serverDatas[i])
    self.roguelikeShopData[i] = data
  end
  for i = #serverDatas + 1, #self.roguelikeShopData do
    self.roguelikeShopData[i] = nil
  end
  self.roguelikeLeftRefreshCount = GameConfig.Roguelike.MaxRefreshShopNum - (refreshedCount or 0)
end
function DungeonProxy:CheckRoguelikeCanRevive(mapManager)
  mapManager = mapManager or Game.MapManager
  if not mapManager:IsPVEMode_Roguelike() then
    return false
  end
  return 0 < GameConfig.Roguelike.ReliveTimes - (self.roguelikeRaid and self.roguelikeRaid.reliveCount or 0)
end
function DungeonProxy.RequestRoguelikeStatistics(grade)
  ServiceRoguelikeCmdProxy.Instance:CallRoguelikeFightInfo(grade)
end
local updateRoguelikeStatistics = function(localDatas, serverDatas)
  local maxGrade, sGrade, lData, sData = 0, nil, nil, nil
  for i = 1, #serverDatas do
    sData = serverDatas[i]
    sGrade = sData.layer
    lData = localDatas[sGrade] or GroupRaidTeamShowData.new()
    lData:SetData(sData.fight)
    localDatas[sGrade] = lData
    if maxGrade < sGrade then
      maxGrade = sGrade
    end
  end
  local charIdStatisticsMap, charIdArr, statisticsArr = ReusableTable.CreateTable(), ReusableTable.CreateArray(), ReusableTable.CreateArray()
  local gsDatas, gsData, charId
  for i = 1, maxGrade do
    gsDatas = localDatas[i] and localDatas[i].showdataMap
    if type(gsDatas) == "table" then
      for j = 1, #gsDatas do
        gsData = gsDatas[j]
        charId = gsData.charid
        if charIdStatisticsMap[charId] then
          charIdStatisticsMap[charId]:MergeWith(gsData)
        else
          charIdStatisticsMap[charId] = gsData:Clone()
          TableUtility.ArrayPushBack(charIdArr, charId)
        end
      end
    end
  end
  table.sort(charIdArr)
  for i = 1, #charIdArr do
    TableUtility.ArrayPushBack(statisticsArr, charIdStatisticsMap[charIdArr[i]])
  end
  ReusableTable.DestroyAndClearTable(charIdStatisticsMap)
  ReusableTable.DestroyAndClearArray(charIdArr)
  localDatas[0] = localDatas[0] or GroupRaidTeamShowData.new()
  localDatas[0]:SetData(statisticsArr)
  ReusableTable.DestroyAndClearArray(statisticsArr)
end
function DungeonProxy:UpdateRoguelikeStatistics(infos)
  self.roguelikeStatistics = self.roguelikeStatistics or {}
  updateRoguelikeStatistics(self.roguelikeStatistics, infos)
end
function DungeonProxy:ClearRoguelikeStatistics()
  if not self.roguelikeStatistics then
    return
  end
  TableUtility.TableClear(self.roguelikeStatistics)
end
function DungeonProxy:GetRoguelikeStatistics(grade, filter)
  if self.roguelikeStatistics and self.roguelikeStatistics[grade] then
    self.roguelikeStatistics[grade]:SetValue(filter)
    return self.roguelikeStatistics[grade].showdataMap
  end
end
function DungeonProxy:GetRoguelikeStatisticsWeight(grade)
  if self.roguelikeStatistics and self.roguelikeStatistics[grade] then
    return self.roguelikeStatistics[grade].weightMap
  end
end
function DungeonProxy:UpdateRoguelikeWeekReward(grade, rewardHasGot)
  self.roguelikeWeekRewardGrade = math.floor((grade or 0) / 10) * 10
  self.roguelikeWeekRewardHasGot = rewardHasGot or false
end
local updateRoguelikeResultData = function(localData, serverData)
  if not serverData or not serverData.layer then
    localData.grade = nil
    return
  end
  localData.grade = serverData.layer
  localData.score = serverData.score
  localData.time = serverData.costtime
  localData.deathCount = serverData.dienum
  localData.eventCount = serverData.eventnpc
  localData.isAllPassed = serverData.passall or false
  local itemCount, coinCount, item = 0, 0, nil
  for i = 1, #serverData.items do
    item = serverData.items[i]
    if item.id == DungeonProxy.RoguelikeCoinId then
      coinCount = coinCount + item.count
    else
      itemCount = itemCount + item.count
    end
  end
  localData.itemCount = itemCount
  localData.coinCount = coinCount
  localData.passRoomMap = localData.passRoomMap or {}
  TableUtility.TableClear(localData.passRoomMap)
  local room
  for i = 1, #serverData.passroom do
    room = serverData.passroom[i]
    localData.passRoomMap[room.roomtype] = room.num
  end
  localData.statistics = localData.statistics or {}
  TableUtility.TableClear(localData.statistics)
  updateRoguelikeStatistics(localData.statistics, serverData.fight)
end
function DungeonProxy:RecvRoguelikeSettlement(data)
  LogUtility.InfoFormat("Recv RoguelikeResult grade:{0}, score:{1}, time:{2}", data.layer, data.score, data.costtime)
  if not data.layer or not data.score then
    LogUtility.Warning("RecvRoguelikeResult with wrong data")
    return
  end
  self.roguelikeResultData = self.roguelikeResultData or {}
  updateRoguelikeResultData(self.roguelikeResultData, data)
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.RoguelikeResultView
  })
end
function DungeonProxy:RecvRoguelikeTarotInfo(stage, tarotIds, unlockedTarotDatas)
  local exStage = self.roguelikeTarotStage
  LogUtility.InfoFormat("Recv RoguelikeTarotInfo stage:{0}", stage)
  self.roguelikeTarotStage = stage
  self.roguelikeTarotIds = self.roguelikeTarotIds or {}
  TableUtility.TableClear(self.roguelikeTarotIds)
  if not tarotIds then
    return
  end
  TableUtility.ArrayShallowCopy(self.roguelikeTarotIds, tarotIds)
  local sb = LuaStringBuilder.CreateAsTable()
  sb:Append("Recv RoguelikeTarotInfo tarotIds:")
  for i = 1, #tarotIds do
    sb:Append(tarotIds[i])
    if i ~= #tarotIds then
      sb:Append(", ")
    end
  end
  LogUtility.Info(sb:ToString())
  sb:Destroy()
  self.roguelikeUnlockedTarotDatas = self.roguelikeUnlockedTarotDatas or {}
  if not unlockedTarotDatas then
    TableUtility.TableClear(self.roguelikeUnlockedTarotDatas)
    return
  end
  local d
  for i = 1, #unlockedTarotDatas do
    d = self.roguelikeUnlockedTarotDatas[i] or {}
    d.index = unlockedTarotDatas[i].index
    d.id = unlockedTarotDatas[i].id
    self.roguelikeUnlockedTarotDatas[i] = d
  end
  for i = #unlockedTarotDatas + 1, #self.roguelikeUnlockedTarotDatas do
    self.roguelikeUnlockedTarotDatas[i] = nil
  end
  if exStage == RoguelikeCmd_pb.EROGUETAROTPROG_MIN and stage == RoguelikeCmd_pb.EROGUETAROTPROG_NO_CONFIRM then
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.RoguelikeTarotView
    })
  end
end
function DungeonProxy:CheckIsInTarotProgress()
  return self.roguelikeTarotStage ~= nil and self.roguelikeTarotStage ~= RoguelikeCmd_pb.EROGUETAROTPROG_MIN and self.roguelikeTarotStage ~= RoguelikeCmd_pb.EROGUETAROTPROG_DONE
end
function DungeonProxy:TryUpdateExitPointState(id, state)
  if not Game.MapManager:IsPVEMode_Roguelike() then
    return
  end
  SceneProxy.Instance.currentScene:UpdateExitPointState(id, state)
end
function DungeonProxy:CheckRoguelikeCoin(needCoinCount)
  local coinCount = self.roguelikeRaid and self.roguelikeRaid.coinCount or 0
  return needCoinCount <= coinCount, coinCount
end
local roguelikeItemIdMaxLevelMap = {}
function DungeonProxy.GetRoguelikeItemMaxLevel(itemId)
  if not next(roguelikeItemIdMaxLevelMap) then
    local exLevel
    for _, d in pairs(Table_RoguelikeItem) do
      exLevel = roguelikeItemIdMaxLevelMap[d.ItemID] or 0
      roguelikeItemIdMaxLevelMap[d.ItemID] = exLevel < d.Level and d.Level or exLevel
    end
  end
  return roguelikeItemIdMaxLevelMap[itemId] or 0
end
local roguelikeItemIdCdTimeMap = {}
function DungeonProxy.GetRoguelikeItemCdTime(itemId)
  if not next(roguelikeItemIdCdTimeMap) then
    for _, d in pairs(Table_RoguelikeItem) do
      if d.CDTime then
        roguelikeItemIdCdTimeMap[d.ItemID] = d.CDTime
      end
    end
  end
  return roguelikeItemIdCdTimeMap[itemId] or 0
end
function DungeonProxy.GetGradeStr(grade)
  return string.format(ZhString.Roguelike_MapNameSuffix, grade or 0)
end
function DungeonProxy.GetRoguelikeRoomTypeByIndex(i)
  local subScenes = SceneProxy.Instance.currentScene.subScenes
  local totalRoomCount = subScenes and #subScenes
  if type(totalRoomCount) ~= "number" or totalRoomCount <= 0 then
    return
  end
  return Table_RoguelikeRoom[subScenes[i]].Type
end
function DungeonProxy.GetMyRollCoinCount()
  return BagProxy.Instance:GetItemNumByStaticID(GameConfig.RollRaid.roll_coin_itemid, GameConfig.PackageMaterialCheck.rollcoin_pack)
end
local RollNeedCatB
function DungeonProxy.SetMyRollNeedCatB(count)
  RollNeedCatB = count
end
function DungeonProxy.GetMyRollNeedCatB(count)
  return RollNeedCatB
end
function DungeonProxy._RollInvitationTypeSwitch(invitation, pveRaidHandler, groupRaidHandler, worldBossHandler, deadBossHandler, guildHandler, comodoRaidHandle, multiBossRaidHandler, defaultRet)
  local t, param = invitation and invitation and invitation.type, invitation.param
  if t == FuBenCmd_pb.EROLLRAIDREWARD_PVERAID then
    return pveRaidHandler(param) or defaultRet
  elseif t == FuBenCmd_pb.EROLLRAIDREWARD_GROUPRAID then
    return groupRaidHandler(param) or defaultRet
  elseif t == FuBenCmd_pb.EROLLRAIDREWARD_WORLDBOSS then
    return worldBossHandler(param) or defaultRet
  elseif t == FuBenCmd_pb.EROLLRAIDREWARD_DEADBOSS then
    return deadBossHandler(param) or defaultRet
  elseif t == FuBenCmd_pb.EROLLRAIDREWARD_GUILD then
    return guildHandler(param) or defaultRet
  elseif t == FuBenCmd_pb.EROLLRAIDREWARD_COMODO_TEAM_RAID then
    return comodoRaidHandle(param) or defaultRet
  elseif t == FuBenCmd_pb.EROLLRAIDREWARD_SEVEN_ROYAL_TEAM_RAID then
    return multiBossRaidHandler(param) or defaultRet
  end
  return defaultRet
end
function DungeonProxy.GetTotalRollTimes(invitation)
  return DungeonProxy._RollInvitationTypeSwitch(invitation, function()
    return GameConfig.RollRaid.pveraid_count
  end, function()
    return GameConfig.RollRaid.groupraid_count
  end, function()
    return GameConfig.RollRaid.worldboss_count
  end, function()
    return GameConfig.RollRaid.deadboss_count
  end, function()
    return GameConfig.RollRaid.guildraid_count
  end, function()
    local curmapid = SceneProxy.Instance:GetCurRaidID()
    return GameConfig.RollRaid.comodoraid_count[curmapid]
  end, function()
    local curmapid = SceneProxy.Instance:GetCurRaidID()
    return GameConfig.RollRaid.multibossraid_count[curmapid]
  end, 0)
end
function DungeonProxy.GetRestRollTimes(invitation)
  local finishedTimes = DungeonProxy._RollInvitationTypeSwitch(invitation, function()
    return MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_ROLL_PVERAID)
  end, function()
    return MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_ROLL_GROUPRAID)
  end, function()
    return MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_ROLL_WORLDBOSS)
  end, function()
    return MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_ROLL_DEADBOSS)
  end, function()
    return MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_ROLL_GUILD)
  end, function()
    return invitation.count
  end, function()
    return invitation.count
  end, 0)
  if invitation.type == FuBenCmd_pb.EROLLRAIDREWARD_COMODO_TEAM_RAID or invitation.type == FuBenCmd_pb.EROLLRAIDREWARD_SEVEN_ROYAL_TEAM_RAID then
    return math.max(0, finishedTimes)
  else
    return math.max(0, DungeonProxy.GetTotalRollTimes(invitation) - finishedTimes)
  end
end
function DungeonProxy.GetRollRaidDesc(invitation)
  return DungeonProxy._RollInvitationTypeSwitch(invitation, function(param)
    local sData = Table_PveRaid[param]
    return sData and GameConfig.RollRaid.roll_cardraid_desc[sData.Difficulty] or ""
  end, function(param)
    return GameConfig.RollRaid.roll_groupraid_desc[Game.MapManager:GetRaidID()]
  end, function(param)
    return GameConfig.RollRaid.roll_worldboss_desc[param]
  end, function(param)
    return string.format(GameConfig.RollRaid.roll_deadboss_desc, Table_Monster[param] and Table_Monster[param].NameZh or "")
  end, function(param)
    return string.format(GameConfig.RollRaid.roll_guildraid_desc, Table_Monster[param] and Table_Monster[param].NameZh or "")
  end, function(param)
    return GameConfig.RollRaid.roll_ComodoRaid_desc[param]
  end, function(param)
    return GameConfig.RollRaid.roll_MultiBoss_desc[param]
  end, "")
end
function DungeonProxy:PopRollRewardInvitation()
  if not self.rollInvitations then
    return
  end
  local inv = self.rollInvitations:Pop()
  if inv then
    ReusableTable.DestroyAndClearTable(inv)
  end
end
function DungeonProxy:PeekRollRewardInvitation()
  if not self.rollInvitations then
    return
  end
  return self.rollInvitations:Peek()
end
function DungeonProxy:ClearRollRewardInvitation()
  if not self.rollInvitations then
    return
  end
  local inv = self.rollInvitations:Pop()
  while inv ~= nil do
    ReusableTable.DestroyAndClearTable(inv)
    inv = self.rollInvitations:Pop()
  end
end
function DungeonProxy:GetRestRewardInvitationCount()
  return self.rollInvitations and self.rollInvitations:Count() or -1
end
function DungeonProxy:GetRollingPlayerCount()
  return self.rollPlayers and #self.rollPlayers or -1
end
function DungeonProxy:RecvInviteRollReward(t, param, coinCost, count)
  self.rollInvitations = self.rollInvitations or LuaQueue.new()
  local inv = ReusableTable.CreateTable()
  inv.playerid = Game.Myself.data.id
  inv.type = t
  inv.param = param
  inv.coinCost = coinCost
  inv.count = count
  self.rollInvitations:Push(inv)
end
function DungeonProxy:RecvTeamRollStatus(data)
  local t = type(data)
  self.rollPlayers = self.rollPlayers or {}
  if t == "number" then
    TableUtility.ArrayRemove(self.rollPlayers, data)
    if not next(self.rollPlayers) then
      self:sendNotification(UIEvent.CloseUI, UIViewType.Lv4PopUpLayer)
    end
  elseif t == "table" then
    TableUtility.TableClear(self.rollPlayers)
    for i = 1, #data do
      self.rollPlayers[i] = data[i]
    end
  end
end
local rollRewardEffectName = "Skill/Eff_GoldCoin_roll"
local playRollEffect = function(char)
  if not char or not char.assetRole then
    return
  end
  char.assetRole:PlayEffectOneShotOn(rollRewardEffectName, 1)
end
function DungeonProxy:RecvPreReplyRollReward(charId, t, param)
  local char = SceneCreatureProxy.FindCreature(charId)
  if not char then
    return
  end
  if charId == Game.Myself.data.id then
    self.myRollRewardTickDatas = self.myRollRewardTickDatas or LuaQueue.new()
    self.myRollRewardTickDatas:Push({type = t, param = param})
    if not self.myRollRewardCurTick then
      self:TryNextRollReward()
    end
  else
    playRollEffect(char)
  end
end
function DungeonProxy:TryNextRollReward()
  if not self.myRollRewardTickDatas then
    return
  end
  local data = self.myRollRewardTickDatas:Pop()
  if data then
    playRollEffect(Game.Myself)
    self.myRollRewardCurTick = TimeTickManager.Me():CreateOnceDelayTick(1900, function(self)
      local needCatB = DungeonProxy.GetMyRollNeedCatB()
      DungeonProxy.SetMyRollNeedCatB(nil)
      if needCatB then
        ServiceFuBenCmdProxy.Instance:CallReplyRollRewardFubenCmd(true, data.type, data.param, needCatB)
      else
        ServiceFuBenCmdProxy.Instance:CallReplyRollRewardFubenCmd(true, data.type, data.param, needCatB)
      end
      self:TryNextRollReward()
      self.myRollRewardCurTick = nil
    end, self)
  elseif self.myRollRewardCurTick then
    self.myRollRewardCurTick:Destroy()
    self.myRollRewardCurTick = nil
  end
end
function DungeonProxy:RecvJanuaryFubenInfo(data)
  redlog("RecvJanuaryFubenInfo", data.oper)
  local operType = data.oper
  if operType == 2 and data.scorereward and #data.scorereward > 0 then
    for i = 1, #data.scorereward do
      local single = data.scorereward[i]
      self.januaryRaidRewards[single.index] = single.status
    end
  end
end
function DungeonProxy:GetJanuaryFubenRate(index)
  if self.januaryRaidRewards and self.januaryRaidRewards[index] then
    return self.januaryRaidRewards[index]
  end
  return 0
end
function DungeonProxy:RecvResultSyncFubenCmd(data)
  self:sendNotification(UIEvent.ShowUI, {
    viewname = "BattleResultView",
    callback = function()
      self:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.RaidResultPopUp,
        viewdata = data
      })
    end
  })
end
function DungeonProxy:RecvClientQueryRaid(raidId, achievementDatas, treasureBoxes, rewardedScores)
  self.clientRaidAchProcessMap = self.clientRaidAchProcessMap or {}
  self.clientRaidAchFinishedMap = self.clientRaidAchFinishedMap or {}
  local single, id
  for i = 1, #achievementDatas do
    single = achievementDatas[i]
    id = single.achievement_id
    self.clientRaidAchProcessMap[id] = single.process
    self.clientRaidAchFinishedMap[id] = single.finished
  end
  self.clientRaidTreasureBoxMap = self.clientRaidTreasureBoxMap or {}
  local map = self.clientRaidTreasureBoxMap[raidId] or {}
  TableUtility.TableClear(map)
  for i = 1, #treasureBoxes do
    map[treasureBoxes[i]] = true
  end
  self.clientRaidTreasureBoxMap[raidId] = map
  if self.clientRaidAchRewardedMap and self.clientRaidAchRewardedMap[raidId] then
    TableUtility.TableClear(self.clientRaidAchRewardedMap[raidId])
  end
  for i = 1, #rewardedScores do
    self:AddClientRaidAchievementReward(raidId, rewardedScores[i])
  end
  if self.clientRaidSaveDataCache then
    TableUtility.TableClear(self.clientRaidSaveDataCache)
  end
end
function DungeonProxy:SetClientRaidSaveData(raidId, saveData)
  self.clientRaidSaveDataMap = self.clientRaidSaveDataMap or {}
  self.clientRaidSaveDataMap[raidId] = saveData
end
function DungeonProxy:AddClientRaidAchievementReward(raidId, rewardScore)
  if not raidId or not rewardScore then
    return
  end
  self.clientRaidAchRewardedMap = self.clientRaidAchRewardedMap or {}
  local map = self.clientRaidAchRewardedMap[raidId] or {}
  map[rewardScore] = true
  self.clientRaidAchRewardedMap[raidId] = map
end
function DungeonProxy:CheckClientRaidTreasureBoxOpened(raidId, box)
  local map = raidId and self.clientRaidTreasureBoxMap and self.clientRaidTreasureBoxMap[raidId]
  return map and box and map[box] or false
end
function DungeonProxy:CheckClientRaidAchRewarded(raidId, score)
  local map = raidId and self.clientRaidAchRewardedMap and self.clientRaidAchRewardedMap[raidId]
  return map and score and map[score] or false
end
function DungeonProxy:GetClientRaidAchievementProcess(achId)
  return achId and self.clientRaidAchProcessMap and self.clientRaidAchProcessMap[achId] or 0
end
function DungeonProxy:GetClientRaidAchievementFinished(achId)
  return achId and self.clientRaidAchFinishedMap and self.clientRaidAchFinishedMap[achId] or false
end
function DungeonProxy:GetClientRaidAchievementScore(raidId)
  local score = 0
  DungeonProxy.ForEachClientRaidAchievement(function(d)
    score = score + self:GetClientRaidAchievementProcess(d.id) * d.Point
  end, raidId)
  return score
end
function DungeonProxy:GetClientRaidSaveData(raidId)
  return raidId and self.clientRaidSaveDataMap and self.clientRaidSaveDataMap[raidId]
end
local saveDataAchIndex, saveDataDetailIndex = 1, 2
function DungeonProxy:ResetClientRaid(raidId)
  local achArr = ReusableTable.CreateArray()
  DungeonProxy.ForEachClientRaidAchievement(function(achData)
    local id = achData.id
    TableUtility.ArrayPushBack(achArr, DungeonProxy.MakeClientRaidAchServerData(id, self:GetClientRaidAchievementProcess(id)))
  end, raidId)
  local saveData = self:GetClientRaidSaveData(raidId)
  local saveDataTable = saveData and json.decode(saveData) or _EmptyTable
  if next(saveDataTable) then
    saveDataTable[saveDataDetailIndex] = nil
  end
  self:_SaveClientRaid(raidId, saveDataTable, achArr)
  ReusableTable.DestroyAndClearArray(achArr)
end
function DungeonProxy:SaveClientRaid(raidId, saveDataTable)
  if type(saveDataTable) ~= "table" then
    return
  end
  local achArr = ReusableTable.CreateArray()
  DungeonProxy.TryAddClientRaidAchDataToArray(achArr, raidId, saveDataTable[saveDataAchIndex])
  self:_SaveClientRaid(raidId, saveDataTable, achArr)
  ReusableTable.DestroyAndClearArray(achArr)
end
function DungeonProxy:_SaveClientRaid(raidId, dataTable, achArr)
  local j = dataTable and json.encode(dataTable) or ""
  self.clientRaidSaveDataCache = self.clientRaidSaveDataCache or {}
  local tag = #self.clientRaidSaveDataCache + 1
  self.clientRaidSaveDataCache[tag] = j
  ServiceRaidCmdProxy.Instance:CallClientSaveCmd(raidId, tag, j, achArr)
  self:RecordClientRaidSaveResult(raidId, tag)
end
function DungeonProxy:RecordClientRaidSaveResult(raidId, tag)
  if not self.clientRaidSaveDataCache or not tag then
    return
  end
  if self.clientRaidSaveDataCache[tag] then
    self:SetClientRaidSaveData(raidId, self.clientRaidSaveDataCache[tag])
    self.clientRaidSaveDataCache[tag] = nil
  end
end
local achTypeProcessGetters = {
  [1] = function(enemyArr)
    return #enemyArr
  end,
  [2] = function(score)
    return score
  end,
  [3] = function(itemGotArr, params)
    for _, d in pairs(itemGotArr) do
      if d.id == params[1] then
        return d.count
      end
    end
  end,
  [4] = function(changedObjArr, params)
    for _, d in pairs(changedObjArr) do
      if d.id == params[1] then
        return 1
      end
    end
    return 0
  end,
  [5] = function(count)
    return count
  end,
  [6] = function(count)
    return count
  end,
  [7] = function(dataArr, params)
    for _, d in pairs(dataArr) do
      if d.id == params[1] then
        return d.dis
      end
    end
  end,
  [8] = function(boxArr)
    return #boxArr
  end,
  [9] = function(count)
    return count
  end,
  [10] = function(count)
    return count
  end,
  [11] = function(dataArr, params)
    for _, d in pairs(dataArr) do
      if d.id == params[1] then
        return d.count
      end
    end
  end,
  [12] = function(enemyArr)
    return #enemyArr
  end,
  [13] = function(count)
    return count
  end,
  [14] = function(enemyArr)
    return #enemyArr
  end
}
function DungeonProxy.TryAddClientRaidAchDataToArray(array, raidId, saveDataAchTable)
  if type(array) ~= "table" or type(saveDataAchTable) ~= "table" then
    return
  end
  DungeonProxy.ForEachClientRaidAchievement(function(achData)
    local t = achData.Type
    local processData, getter = saveDataAchTable[t], achTypeProcessGetters[t]
    DungeonProxy.MakeClientRaidAchServerData(achData.id, processData and getter and getter(processData, achData.Params) or 0)
  end, raidId)
end
function DungeonProxy.MakeClientRaidAchServerData(id, process)
  local achData = NetConfig.PBC and {} or RaidCmd_pb.ClientRaidAchievement()
  achData.achievement_id = id
  achData.process = process
  return achData
end
function DungeonProxy.GetClientRaidAchievementMaxScore(raidId)
  local score = 0
  DungeonProxy.ForEachClientRaidAchievement(function(achData)
    score = score + achData.Count * achData.Point
  end, raidId)
  return score
end
function DungeonProxy.ForEachClientRaidAchievement(action, raidId)
  if not action then
    return
  end
  for _, data in pairs(Table_ClientRaidAchievement) do
    if not raidId or data.RaidID == raidId then
      action(data)
    end
  end
end
function DungeonProxy:RecvRaidSelectCard(endTime, cardIds, recommendedIds)
  local ids = {}
  TableUtility.ArrayShallowCopy(ids, cardIds)
  self.raidSelectRecommendedCardMap = self.raidSelectRecommendedCardMap or {}
  TableUtility.TableClear(self.raidSelectRecommendedCardMap)
  for i = 1, #recommendedIds do
    self.raidSelectRecommendedCardMap[recommendedIds[i]] = true
  end
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.RaidSelectCardView,
    viewdata = {endTime = endTime, cardIds = ids}
  })
  self:TryAddRaidSelectCardPage()
end
function DungeonProxy:RecvRaidSelectCardResult(result)
  self.raidSelectResults = self.raidSelectResults or {}
  if result and result > 0 then
    TableUtility.ArrayPushBack(self.raidSelectResults, result)
    self:TryAddRaidSelectCardPage()
  end
end
function DungeonProxy:RecvRaidSelectCardHistory(ids)
  ids = ids or _EmptyTable
  self.raidSelectResults = self.raidSelectResults or {}
  TableUtility.TableClear(self.raidSelectResults)
  TableUtility.ArrayShallowCopy(self.raidSelectResults, ids)
  if ids[1] then
    self:TryAddRaidSelectCardPage()
  end
end
function DungeonProxy:RecvRaidSelectCardReset()
  self:ResetRaidSelectCard()
end
function DungeonProxy:TryAddRaidSelectCardPage()
  self:sendNotification(MainViewEvent.AddDungeonInfoBord, "MainViewRaidSelectCardPage")
end
function DungeonProxy:ResetRaidSelectCard()
  self:RecvRaidSelectCardHistory()
end
function DungeonProxy:IsRecommendedSelectCard(id)
  return id and self.raidSelectRecommendedCardMap and self.raidSelectRecommendedCardMap[id] and true or false
end
function DungeonProxy.IsRaidSelectSkillCard(id)
  local isActiveSkill, id1 = DungeonProxy.IsRaidSelectActiveSkillCard(id)
  if isActiveSkill then
    return true, id1
  end
  local isPassiveSkill, id2 = DungeonProxy.IsRaidSelectPassiveSkillCard(id)
  if isPassiveSkill then
    return true, id2
  end
  return false
end
function DungeonProxy.IsRaidSelectActiveSkillCard(id)
  local data = id and Table_SelectCardEffect[id]
  local eff = data and data.Effect
  if eff and eff.type == "client_useskill" then
    return true, eff.id
  end
  return false
end
function DungeonProxy.IsRaidSelectPassiveSkillCard(id)
  local data = id and Table_SelectCardEffect[id]
  local eff = data and data.Effect
  if eff and eff.type == "add_passive_skill" then
    return true, eff.id
  end
  return false
end
function DungeonProxy.UpdateRaidSelectCardItem(card, data, prefabLoadFunc, prefabLoadFuncOwner)
  if type(data) == "number" then
    data = Table_SelectCardEffect[data]
  end
  if type(data) ~= "table" then
    return
  end
  if card.item and data.Item then
    card.itemData:ResetData("Card", data.Item)
    card.item:SetData(card.itemData)
  elseif card.item and not data.Item then
    GameObject.Destroy(card.item.gameObject)
    card.item = nil
    card.itemData = nil
  elseif not card.item and data.Item then
    local obj = prefabLoadFunc(prefabLoadFuncOwner, "cell/ItemCell", card.icon.gameObject)
    obj.transform.localPosition = LuaGeometry.Const_V3_zero
    card.item = ItemCell.new(obj)
    card.itemData = card.itemData or ItemData.new()
    card.itemData:ResetData("Card", data.Item)
    card.item:SetData(card.itemData)
  end
  local isSkillCard, skillId = DungeonProxy.IsRaidSelectSkillCard(data.id)
  local iconEnabled = isSkillCard or not StringUtil.IsEmpty(data.Icon) and not card.item
  card.icon.enabled = iconEnabled
  if iconEnabled then
    if isSkillCard then
      IconManager:SetSkillIcon(Table_Skill[skillId].Icon, card.icon)
    else
      IconManager:SetUIIcon(data.Icon, card.icon)
    end
  end
end
