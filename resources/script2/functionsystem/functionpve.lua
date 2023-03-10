local _InvalidMsg = {
  noTeam = 332,
  lvLimited = 7301,
  member_lvLimited = 7305,
  diffServer = 42042,
  leaderAuthority = 7303,
  memberInRaid = 26228,
  roguelikeLoadError = 40714,
  roguelikeSingleLoadError = 40711,
  cannotFollow = 329,
  memberOffline = 39208,
  groupLeader = 25970,
  thanatosMemberInRaid = 25964
}
local _MidEnter_RaidMap = {
  [PveRaidType.Thanatos] = 1
}
local _SingleDiffRaidMap = {
  [PveRaidType.Headwear] = 1,
  [PveRaidType.DeadBoss] = 1
}
local _ArrayFindByPredicate = TableUtility.ArrayFindByPredicate
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
local updateRoguelikeSaveData = function(localData, serverData)
  if not serverData or not serverData.time then
    localData.time = nil
    return
  end
  localData.index = serverData.index
  localData.time = serverData.time
  localData.grade = serverData.layer
  localData.score = serverData.score
  localData.users = localData.users or {}
  if type(serverData.users) ~= "table" then
    TableUtility.TableClear(localData.users)
  else
    for i = #serverData.users + 1, #localData.users do
      localData.users[i] = nil
    end
    local userData
    for i = 1, #serverData.users do
      userData = localData.users[i] or {}
      copyRoguelikeUserData(userData, serverData.users[i])
      localData.users[i] = userData
    end
  end
  localData.items = localData.items or {}
  TableUtility.ArrayClear(localData.items)
  local itemData, item, maxNum, num
  if type(serverData.items) == "table" then
    local dataId = 1
    for i = 1, #serverData.items do
      item = serverData.items[i]
      maxNum = Table_Item[item.id] and Table_Item[item.id].MaxNum
      if not maxNum or maxNum <= 0 then
        maxNum = item.count
      end
      num = item.count
      while num > 0 do
        itemData = ItemData.new(dataId, item.id)
        itemData.num = math.min(num, maxNum)
        TableUtility.ArrayPushBack(localData.items, itemData)
        num = num - maxNum
        dataId = dataId + 1
      end
    end
  end
end
local clearRoguelikeSaveData = function(datas, i)
  TableUtility.TableClear(datas[i])
end
local clearRoguelikeSaveDatas = function(datas, count)
  for i = 1, count do
    datas[i] = datas[i] or {}
    TableUtility.TableClear(datas[i])
  end
end
autoImport("PveEntranceData")
FunctionPve = class("FunctionPve", EventDispatcher)
FunctionPve.Debug_Mode = false
function FunctionPve.Debug(...)
  if FunctionPve.Debug_Mode then
    redlog(...)
  end
end
function FunctionPve.Me()
  if nil == FunctionPve.me then
    FunctionPve.me = FunctionPve.new()
  end
  return FunctionPve.me
end
function FunctionPve.MaxPrepareTime()
  return GameConfig.Pve and GameConfig.Pve.InvitePrepareTime or 60
end
function FunctionPve.IsOpen(static_id)
  return PveEntranceProxy.Instance:IsOpen(static_id)
end
function FunctionPve:HasLeaderAuthority()
  local _TeamMrg = TeamProxy.Instance
  if self:IsServerThanatosInviting() or self:IsClientThanatosInvite() then
    return _TeamMrg:CheckIHaveGroupLeaderAuthority()
  else
    return _TeamMrg:CheckIHaveLeaderAuthority()
  end
end
function FunctionPve.DoQuery()
  FunctionPve.QueryGroupRaidStatus()
  FunctionPve.QueryPvePassInfo()
  FunctionPve.QueryTower()
end
function FunctionPve.QueryTower()
  if TeamProxy.Instance:IHaveTeam() then
    ServiceInfiniteTowerProxy.Instance:CallTeamTowerInfoCmd(TeamProxy.Instance.myTeam.id)
  else
    ServiceInfiniteTowerProxy.Instance:CallTowerInfoCmd()
  end
end
function FunctionPve.QueryPvePassInfo()
  ServiceFuBenCmdProxy.Instance:CallSyncPvePassInfoFubenCmd()
end
function FunctionPve.QueryGroupRaidStatus()
  ServiceTeamGroupRaidProxy.Instance:CallQueryGroupRaidStatusCmd()
end
function FunctionPve.GetGrade(difficulty)
  return 1 + 10 * (difficulty - 1)
end
function FunctionPve.GetDifficulty(layer)
  return math.floor((layer - 1) / 10 + 1)
end
function FunctionPve.QueryRoguelikeArchive()
  ServiceRoguelikeCmdProxy.Instance:CallRoguelikeArchiveCmd(RoguelikeCmd_pb.ROGUEARCHIVEOPT_QUERY)
end
function FunctionPve:RefreshRoguelikeSaveDatas(serverDatas)
  self.roguelikeAutoSaveDatas = self.roguelikeAutoSaveDatas or {}
  self.roguelikeManualSaveDatas = self.roguelikeManualSaveDatas or {}
  clearRoguelikeSaveDatas(self.roguelikeAutoSaveDatas, GameConfig.Roguelike.AutoSchedule or 1)
  clearRoguelikeSaveDatas(self.roguelikeManualSaveDatas, GameConfig.Roguelike.MultiSchedule or 4)
  local sData, localDatas
  for i = 1, #serverDatas do
    sData = serverDatas[i]
    localDatas = self:GetRoguelikeSaveData(sData.index >= 1000)
    local index = sData.index % 1000
    updateRoguelikeSaveData(localDatas[index], sData)
  end
end
function FunctionPve.DelRoguelikeSaveData(saveDataIndex)
  if not saveDataIndex or saveDataIndex <= 0 then
    return
  end
  ServiceRoguelikeCmdProxy.Instance:CallRoguelikeArchiveCmd(RoguelikeCmd_pb.ROGUEARCHIVEOPT_DEL, nil, saveDataIndex)
end
function FunctionPve.SaveRoguelike()
  local teamIns = TeamProxy.Instance
  if not teamIns:CheckIHaveLeaderAuthority() then
    MsgManager.ShowMsgByIDTable(39100)
    return
  end
  ServiceRoguelikeCmdProxy.Instance:CallRoguelikeArchiveCmd(RoguelikeCmd_pb.ROGUEARCHIVEOPT_SAVE, nil, DungeonProxy.Instance.roguelikeCurSaveDataIndex or 1)
end
function FunctionPve:SetCurrentRoguelikeSaveDataIndex(index)
  self.roguelikeCurSaveDataIndex = index
end
local optDescMap, resultDescMap
function FunctionPve:HandleRecvRoguelikeArchiveOption(data)
  if not optDescMap then
    optDescMap = {
      [RoguelikeCmd_pb.ROGUEARCHIVEOPT_SAVE] = ZhString.Roguelike_ArchiveCmdOperationSave,
      [RoguelikeCmd_pb.ROGUEARCHIVEOPT_DEL] = ZhString.Roguelike_ArchiveCmdOperationDelete
    }
  end
  if not resultDescMap then
    resultDescMap = {
      ["true"] = ZhString.Roguelike_ArchiveCmdOperationSuccess,
      ["false"] = ZhString.Roguelike_ArchiveCmdOperationFailed
    }
  end
  local optDesc = optDescMap[data.opt]
  local resultDesc = resultDescMap[tostring(data.result or false)]
  if not optDesc or not resultDesc then
    return
  end
  MsgManager.FloatMsg(nil, optDesc .. resultDesc)
  if data.opt == RoguelikeCmd_pb.ROGUEARCHIVEOPT_DEL then
    self:_DelRoguelikeSaveDataByServer(data.index)
  end
end
function FunctionPve:GetRoguelikeSaveData(isAuto, index)
  local localDatas = isAuto and self.roguelikeAutoSaveDatas or self.roguelikeManualSaveDatas
  if type(index) == "number" then
    index = index % 1000
    return localDatas[index]
  else
    return localDatas
  end
end
function FunctionPve:_DelRoguelikeSaveDataByServer(index)
  if index >= 1000 then
    return
  end
  local localDatas = self:GetRoguelikeSaveData(false)
  local localData = localDatas[index]
  if not localData then
    LogUtility.WarningFormat("Cannot find local roguelike save data with isSingle={0} and index={1} while trying to delete by server", isSingle, index)
    return
  end
  TableUtility.TableClear(localData)
  for i = index, #localDatas - 1 do
    localDatas[i] = localDatas[i + 1]
  end
  localDatas[#localDatas] = localData
  for i = 1, #localDatas do
    localDatas[i].index = i
  end
end
function FunctionPve:HandleGroupRaidStatus(data)
  FunctionPve.Debug("Pve??????????????????????????????????????????????????????????????? open | canjoin:   ", data.open, data.canjoin)
  self.groupRaid_open = data.open
  self.groupRaid_canJoin = data.canjoin
end
function FunctionPve:ctor()
  self:Init()
end
function FunctionPve:Init()
  self.enterCall = {}
  self.enterCall[PveRaidType.PveCard] = self.Enter_PveCard
  self.enterCall[PveRaidType.Rugelike] = self.Enter_Rugelike
  self.enterCall[PveRaidType.InfiniteTower] = self.Enter_InfiniteTower
  self.enterCall[PveRaidType.Thanatos] = self.Enter_Thasnatos
  self.enterCall[PveRaidType.DeadBoss] = self.Enter_Common
  self.enterCall[PveRaidType.Headwear] = self.Enter_Common
  self.enterCall[PveRaidType.Comodo] = self.Enter_Common
  self.enterCall[PveRaidType.MultiBoss] = self.Enter_Common
  self.enterCall[PveRaidType.Crack] = self.Enter_Common
  self.enterCall[PveRaidType.GuildRaid] = self.Enter_Common
  self.inviteCall = {}
  self.inviteCall[PveRaidType.PveCard] = self.Invite_PveCard
  self.inviteCall[PveRaidType.Rugelike] = self.Invite_Rugelike
  self.inviteCall[PveRaidType.InfiniteTower] = self.Invite_InfiniteTower
  self.inviteCall[PveRaidType.Thanatos] = self.Invite_GroupRaid
  self.inviteCall[PveRaidType.DeadBoss] = self.Invite_Common
  self.inviteCall[PveRaidType.Headwear] = self.Invite_Common
  self.inviteCall[PveRaidType.Comodo] = self.Invite_Common
  self.inviteCall[PveRaidType.MultiBoss] = self.Invite_Common
  self.inviteCall[PveRaidType.Crack] = self.Invite_Common
  self.inviteCall[PveRaidType.GuildRaid] = self.Invite_Common
  self.cancelCall = {}
  self.cancelCall[PveRaidType.PveCard] = self.Cancel_PveCard
  self.cancelCall[PveRaidType.Rugelike] = self.Cancel_Rugelike
  self.cancelCall[PveRaidType.InfiniteTower] = self.Cancel_InfiniteTower
  self.cancelCall[PveRaidType.Thanatos] = self.Cancel_Thasnatos
  self.cancelCall[PveRaidType.DeadBoss] = self.Cancel_Common
  self.cancelCall[PveRaidType.Headwear] = self.Cancel_Common
  self.cancelCall[PveRaidType.Comodo] = self.Cancel_Common
  self.cancelCall[PveRaidType.MultiBoss] = self.Cancel_Common
  self.cancelCall[PveRaidType.Crack] = self.Cancel_Common
  self.cancelCall[PveRaidType.GuildRaid] = self.Cancel_Common
  self.replyCall = {}
  self.replyCall[PveRaidType.PveCard] = self.Reply_PveCard
  self.replyCall[PveRaidType.Rugelike] = self.Reply_Rugelike
  self.replyCall[PveRaidType.InfiniteTower] = self.Reply_InfiniteTower
  self.replyCall[PveRaidType.Thanatos] = self.Reply_Thanatos
  self.replyCall[PveRaidType.DeadBoss] = self.Reply_Common
  self.replyCall[PveRaidType.Headwear] = self.Reply_Common
  self.replyCall[PveRaidType.Comodo] = self.Reply_Common
  self.replyCall[PveRaidType.MultiBoss] = self.Reply_Common
  self.replyCall[PveRaidType.Crack] = self.Reply_Common
  self.replyCall[PveRaidType.GuildRaid] = self.Reply_Common
  self.checkFunc = {}
  self.checkFunc[PveRaidType.Thanatos] = self.CheckThanatos
  self.checkFunc[PveRaidType.Rugelike] = self.CheckRoguelike
  self.checkFunc[PveRaidType.Comodo] = self.CheckComodo
  self.checkFunc[PveRaidType.MultiBoss] = self.CheckMultiBoss
  self.checkFunc[PveRaidType.GuildRaid] = self.CheckGuildRaid
  self.midEnterFunc = {}
  self.midEnterFunc[PveRaidType.Thanatos] = self.MidEnter_Thanatos
  self.replyMap = {}
end
function FunctionPve:CheckThanatos(type, difficulty)
  if not self:HasLeaderAuthority() then
    MsgManager.ShowMsgByID(_InvalidMsg.groupLeader)
    return false
  end
  if TeamProxy.Instance:HasRobotInTeam() then
    MsgManager.ShowMsgByID(43166)
    return false
  end
  if nil ~= self.groupRaid_open and nil ~= self.groupRaid_canJoin and self.groupRaid_open == true and self.groupRaid_canJoin == false then
    MsgManager.ShowMsgByID(_InvalidMsg.thanatosMemberInRaid)
    return false
  end
  local diffCfg = GameConfig.Thanatos_Public.Diff
  local raidid = diffCfg[difficulty] and diffCfg[difficulty].raidID
  if raidid and TeamProxy.Instance:ForbiddenByRaidID(raidid) then
    MsgManager.ShowMsgByID(_InvalidMsg.diffServer)
    return false
  end
  return true
end
function FunctionPve:CheckComodo(type, difficulty)
  local diffCfg = GameConfig.ComodoRaid.Diff
  local raidid = diffCfg[difficulty] and diffCfg[difficulty].raidID
  if raidid and TeamProxy.Instance:ForbiddenByRaidID(raidid) then
    MsgManager.ShowMsgByID(_InvalidMsg.diffServer)
    return false
  end
  return true
end
local _MultiBossRaidType = PveRaidType.MultiBoss
function FunctionPve:CheckMultiBoss(type, difficulty)
  local diffCfg = GameConfig.MultiBoss.Raid[_MultiBossRaidType].Diff
  local raidid = diffCfg[difficulty] and diffCfg[difficulty].raidID
  if raidid and TeamProxy.Instance:ForbiddenByRaidID(raidid) then
    MsgManager.ShowMsgByID(_InvalidMsg.diffServer)
    return false
  end
  return true
end
function FunctionPve:CheckRoguelike(type, difficulty, saveDataIndex, isSingleSelected)
  local _TeamMrg = TeamProxy.Instance
  local memberList
  if isSingleSelected then
    if _TeamMrg:IHaveTeam() then
      memberList = _TeamMrg.myTeam:GetPlayerMemberList(false, true)
      if #memberList > 0 then
        MsgManager.ShowMsgByID(_InvalidMsg.roguelikeSingleLoadError)
        return false
      end
    end
  else
    if _TeamMrg:IHaveTeam() then
      memberList = _TeamMrg.myTeam:GetPlayerMemberList(true, true)
      local isAuto = saveDataIndex and saveDataIndex >= 1000
      local saveData = FunctionPve.Me():GetRoguelikeSaveData(isAuto, saveDataIndex)
      local saveDataUsers = saveData and saveData.users
      if saveDataUsers then
        for i = 1, #memberList do
          if not _ArrayFindByPredicate(saveDataUsers, function(data)
            return data.charid == memberList[i].id and not memberList[i]:IsOffline()
          end) then
            MsgManager.ShowMsgByID(_InvalidMsg.roguelikeLoadError)
            return false
          else
          end
        end
        for i = 1, #saveDataUsers do
          if not _ArrayFindByPredicate(memberList, function(data)
            return data.id == saveDataUsers[i].charid
          end) then
            MsgManager.ShowMsgByID(_InvalidMsg.roguelikeLoadError)
            return false
          else
          end
        end
      end
    else
    end
  end
  return true
end
function FunctionPve:CheckGuildRaid()
  if not GuildProxy.Instance:IHaveGuild() then
    MsgManager.ConfirmMsgByID(43199, function()
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.GuildFindPopUp
      })
    end, nil, nil)
    return false
  end
  return true
end
function FunctionPve.Invite_PveCard(_, difficulty, entranceid)
  FunctionPve.Debug("Pve????????????????????????????????????  difficulty:   ", difficulty)
  ServicePveCardProxy.Instance:CallInvitePveCardCmd(difficulty, false, entranceid)
end
function FunctionPve.Invite_InfiniteTower(_, difficulty, entranceid)
  local layer = FunctionPve.GetGrade(difficulty)
  FunctionPve.Debug("Pve??????????????????????????????????????? difficulty:   ", difficulty)
  ServiceInfiniteTowerProxy.Instance:CallTeamTowerInviteCmd(false, difficulty, entranceid)
end
function FunctionPve.Invite_GroupRaid(_, difficulty, entranceid)
  FunctionPve.Debug("Pve???????????????????????????????????? difficulty:   ", difficulty)
  ServiceTeamGroupRaidProxy.Instance:CallInviteGroupJoinRaidTeamCmd(false, difficulty, entranceid)
end
function FunctionPve.SetRugelikeInviteParam(layer, save_index)
  FunctionPve.rugelike_layer = layer
  FunctionPve.rugelike_saveIndex = save_index
end
function FunctionPve.ClearRugelikeInviteParam()
  FunctionPve.rugelike_layer = nil
  FunctionPve.rugelike_saveIndex = nil
end
function FunctionPve.Invite_Rugelike(_, difficulty, entranceid)
  local send_layer = FunctionPve.rugelike_layer or difficulty
  local save_index = FunctionPve.rugelike_saveIndex or 0
  FunctionPve.Debug("Pve??????????????????????????????????????????  send_layer | save_index:   ", send_layer, save_index)
  ServiceRoguelikeCmdProxy.Instance:CallRoguelikeInviteCmd(true, send_layer, save_index, nil, nil, nil, entranceid)
end
function FunctionPve.Invite_Common(type, difficulty, entranceid)
  difficulty = FunctionPve.Me():IsClientSingleDifficultyRaid() and 0 or difficulty
  FunctionPve.Debug("Pve???????????????????????????????????? type | difficulty:   ", type, difficulty)
  ServiceTeamRaidCmdProxy.Instance:CallTeamRaidInviteCmd(false, type, difficulty, entranceid)
end
function FunctionPve.Reply_PveCard(var)
  FunctionPve.Debug("Pve????????????????????????????????????????????????:   ", var)
  ServicePveCardProxy.Instance:CallReplyPveCardCmd(var, Game.Myself.data.id)
end
function FunctionPve.Reply_Rugelike(var)
  DungeonProxy.Instance:ClearRoguelikeStatistics()
  FunctionPve.Debug("Pve????????????????????????????????????????????????:   ", var)
  ServiceRoguelikeCmdProxy.Instance:CallRoguelikeReplyCmd(var, Game.Myself.data.id)
end
function FunctionPve.Reply_InfiniteTower(var)
  FunctionPve.Debug("Pve?????????????????????????????????????????????:   ", var)
  local pbEnum = var and InfiniteTower_pb.ETOWERREPLY_AGREE or InfiniteTower_pb.ETOWERREPLY_DISAGREE
  ServiceInfiniteTowerProxy.Instance:CallTeamTowerReplyCmd(pbEnum, Game.Myself.data.id)
end
function FunctionPve.Reply_Thanatos(var)
  FunctionPve.Debug("Pve???????????????????????????????????????????????????:   ", var)
  ServiceTeamGroupRaidProxy.Instance:CallReplyGroupJoinRaidTeamCmd(var, Game.Myself.data.id)
end
function FunctionPve.Reply_Common(var, type)
  FunctionPve.Debug("Pve??????????????????????????????????????????  type,var:   ", type, var)
  ServiceTeamRaidCmdProxy.Instance:CallTeamRaidReplyCmd(var, Game.Myself.data.id, type)
end
function FunctionPve.Enter_Rugelike(_, difficulty, saveDataIndex)
  local me = Game.Myself.data.id
  DungeonProxy.Instance:ClearRoguelikeStatistics()
  local send_layer = FunctionPve.rugelike_layer or FunctionPve.GetGrade(difficulty)
  local send_saveIndex = FunctionPve.rugelike_saveIndex or saveDataIndex
  FunctionPve.Debug("Pve??????????????????????????????????????????  layer,saveDataIndex:   ", difficulty, send_saveIndex)
  ServiceRoguelikeCmdProxy.Instance:CallRoguelikeCreateCmd(difficulty, me, send_saveIndex)
  FunctionPve.Me():SetCurrentRoguelikeSaveDataIndex(saveDataIndex)
  FunctionPve.ClearRugelikeInviteParam()
end
function FunctionPve.Enter_PveCard(_, difficulty)
  ServicePveCardProxy.Instance:CallSelectPveCardCmd(difficulty)
  FunctionPve.Debug("Pve??????????????????????????????????????????  difficulty:    ", difficulty)
  ServicePveCardProxy.Instance:CallEnterPveCardCmd(difficulty)
end
function FunctionPve.Enter_Thasnatos(_, _)
  FunctionPve.Debug("Pve????????????????????????????????????????????? ")
  ServiceTeamGroupRaidProxy.Instance:CallOpenGroupRaidTeamCmd()
end
function FunctionPve.Enter_InfiniteTower(_, difficulty)
  local layer = FunctionPve.GetGrade(difficulty)
  FunctionPve.Debug("Pve???????????????????????????????????????:    ", layer)
  ServiceInfiniteTowerProxy.Instance:CallEnterTower(difficulty, Game.Myself.data.id)
end
function FunctionPve.Enter_Common(type, difficulty)
  difficulty = FunctionPve.Me():IsServerSingleDifficultyRaid() and 0 or difficulty
  FunctionPve.Debug("Pve?????????????????????????????????????????? type | difficulty:     ", type, difficulty)
  ServiceTeamRaidCmdProxy.Instance:CallTeamRaidEnterCmd(type, nil, nil, nil, nil, difficulty)
end
function FunctionPve.MidEnter_Thanatos()
  FunctionPve.Debug("Pve???????????????????????????????????????????????????")
  ServiceTeamGroupRaidProxy.Instance:CallJoinGroupRaidTeamCmd()
end
function FunctionPve.Cancel_Thasnatos(_, _, entranceid)
  FunctionPve.Debug("Pve??????????????????????????????????????????????????????")
  ServiceTeamGroupRaidProxy.Instance:CallInviteGroupJoinRaidTeamCmd(true, nil, entranceid)
end
function FunctionPve.Cancel_InfiniteTower(_, _, entranceid)
  FunctionPve.Debug("Pve????????????????????????????????????????????????")
  ServiceInfiniteTowerProxy.Instance:CallTeamTowerInviteCmd(true, nil, entranceid)
end
function FunctionPve.Cancel_Rugelike(_, difficulty, entranceid)
  FunctionPve.Debug("Pve???????????????????????????????????????????????????")
  ServiceRoguelikeCmdProxy.Instance:CallRoguelikeInviteCmd(false, difficulty, nil, nil, nil, nil, entranceid)
end
function FunctionPve.Cancel_PveCard(_, difficulty, entranceid)
  FunctionPve.Debug("Pve???????????????????????????????????????????????????")
  ServicePveCardProxy.Instance:CallInvitePveCardCmd(difficulty, true, entranceid)
end
function FunctionPve.Cancel_Common(type, difficulty, entranceid)
  FunctionPve.Debug("Pve?????????????????????????????????????????????type | difficulty | entranceid:    ", type, difficulty, entranceid)
  ServiceTeamRaidCmdProxy.Instance:CallTeamRaidInviteCmd(true, type, difficulty, entranceid)
end
function FunctionPve:DoChallenge()
  if not self.client_raidType then
    return false
  end
  if self:_CheckInviteInValid() then
    return false
  end
  if self:_TryMidEnter() then
    return true
  end
  self:_DoInvite()
  return true
end
function FunctionPve:DoMatch()
  if not self.client_staticData then
    return
  end
  local goal = self.client_staticData.Goal
  if not goal then
    MsgManager.FloatMsg(nil, "??????Goal?????????Table_PveRaidEntrance ID " .. self.client_staticData.id)
    return
  end
  local matchResult = FunctionTeam.Me():OnClickMatch(goal, false, self.client_staticData.id)
  return matchResult
end
function FunctionPve:DoPublish()
  if not self.client_staticData then
    return
  end
  local goal = self.delayPublishGoal or self.client_staticData.Goal
  FunctionTeam.Me():OnClickPublish(goal)
end
function FunctionPve:DoEnter()
  if not self.serverEntranceData then
    return
  end
  if not self:CheckEnterValid() then
    return
  end
  local type, diff = self.serverEntranceData.raidType, self.serverEntranceData.difficultyRaid
  if not type or not diff then
    return
  end
  local func = self.enterCall[type]
  if func then
    func(type, diff)
  end
end
function FunctionPve:DoCancel()
  if not self.serverEntranceData then
    return
  end
  local type, diff, entranceid = self.serverEntranceData.raidType, self.sendInviteDifficulty, self.serverEntranceData.id
  if not type or not diff then
    return
  end
  local func = self.cancelCall[type]
  if func then
    func(type, diff, entranceid)
  end
end
function FunctionPve:DoTimeUp()
  if not self.serverEntranceData then
    return
  end
  local raidType = self.serverEntranceData.raidType
  if not raidType then
    return
  end
  if self:HasLeaderAuthority() then
    self:DoCancel()
  else
    local my_reply = self:GetMyReply()
    if nil == my_reply then
      local func = self.replyCall[raidType]
      func(false, raidType)
    end
  end
  self:TryReset()
end
function FunctionPve:DoReply(agree)
  if not self.serverEntranceData then
    return
  end
  local raidType = self.serverEntranceData.raidType
  if not raidType then
    return
  end
  local func = self.replyCall[raidType]
  if func then
    func(agree, raidType)
  end
end
function FunctionPve:SetCurPve(entranceData)
  if not entranceData then
    return
  end
  self.client_staticData = entranceData.staticData
  self.client_raidType = entranceData.raidType
  self.client_difficulty = entranceData.difficultyRaid
end
function FunctionPve:GetCurInviteingRaidName()
  if self.serverEntranceData and self.serverEntranceData.staticData and self.serverEntranceData.staticData.RaidType == PveRaidType.PveCard then
    return ZhString.PveShenYu .. GameConfig.CardRaid.cardraid_DifficultyName[self.serverEntranceData.staticData.Difficulty]
  else
    return self.serverEntranceData and self.serverEntranceData.staticData and self.serverEntranceData.staticData.Name or ""
  end
end
function FunctionPve:TryResetLeaderReady(leaderId)
  if not self:IsInivteing() then
    return
  end
  self:_SetReply(self.client_invite_leaderid, nil)
  self.client_invite_leaderid = leaderId
  self:_SetReply(leaderId, true)
  GameFacade.Instance:sendNotification(PVEEvent.ReplyInvite)
end
function FunctionPve:SetServerInvite(entranceid, difficulty, lefttime)
  self.serverEntranceData = PveEntranceData.new(entranceid)
  self.sendInviteDifficulty = difficulty
  if not lefttime or lefttime == 0 then
    lefttime = FunctionPve.MaxPrepareTime()
  end
  self.serverInviteEndTime = ServerTime.CurServerTime() / 1000 + lefttime
  self.client_invite_leaderid = self:GetCurLeaderID()
  self:_SetReply(self.client_invite_leaderid, true)
  local isSceneLoading = SceneProxy.Instance:IsLoading()
  if not isSceneLoading then
    GameFacade.Instance:sendNotification(PVEEvent.BeginInvite)
    self:TryOpenInviteView()
  else
    self.delayInivte = true
  end
end
function FunctionPve:GetCurLeaderID()
  if self:IsServerThanatosInviting() or self:IsClientThanatosInvite() then
    return TeamProxy.Instance:GetGroupLeaderGuid()
  else
    return TeamProxy.Instance.myTeam:GetNowLeaderID()
  end
end
function FunctionPve:CheckDelayInvite()
  if not self.delayInivte then
    return
  end
  self.delayInivte = nil
  GameFacade.Instance:sendNotification(PVEEvent.BeginInvite)
  self:TryOpenInviteView()
end
function FunctionPve:IsClientRoguelike()
  return self.client_raidType == PveRaidType.Rugelike
end
function FunctionPve:IsClientPveCard()
  return self.client_raidType == PveRaidType.PveCard
end
function FunctionPve:IsClientSingleDifficultyRaid()
  return nil ~= _SingleDiffRaidMap[self.client_raidType]
end
function FunctionPve:IsServerSingleDifficultyRaid()
  if self.serverEntranceData then
    return nil ~= _SingleDiffRaidMap[self.serverEntranceData.raidType]
  end
  return false
end
function FunctionPve:IsServerThanatosInviting()
  return self.serverEntranceData and self.serverEntranceData.raidType == PveRaidType.Thanatos
end
function FunctionPve:IsClientThanatosInvite()
  return self.client_raidType == PveRaidType.Thanatos
end
function FunctionPve:TryOpenInviteView()
  if self.serverEntranceData then
    if self:IsServerThanatosInviting() then
      PveGroupInvitePopUp.Show()
    else
      PveInvitePopUp.Show()
    end
  end
end
function FunctionPve:GetReadyEndTime()
  return self.serverInviteEndTime
end
function FunctionPve:IsInivteing()
  return nil ~= self.serverEntranceData
end
function FunctionPve:HandleServerInvite(cancel, entranceid, difficulty, lefttime)
  PveEntranceProxy.Instance:PreprocessTable()
  if cancel then
    FunctionPve.Debug("Pve??????????????????????????????????????????????????? entranceid | difficulty:    ", raid_type, entranceid, difficulty)
    self:TryReset()
  else
    FunctionPve.Debug("Pve??????????????????????????????????????????????????? entranceid | difficulty:    ", entranceid, difficulty)
    self:SetServerInvite(entranceid, difficulty, lefttime)
  end
end
function FunctionPve:HandleReplay(reply_charid, reply_agree, reply_type)
  if not self.serverEntranceData then
    return
  end
  if reply_type ~= self.serverEntranceData.raidType then
    FunctionPve.Debug("???Pve???????????????????????????????????????????????????!  ????????????????????? | ????????????????????????    ", self.serverEntranceData.raidType, reply_type)
    return
  end
  if reply_agree == true then
    self:_SetReply(reply_charid, reply_agree)
    GameFacade.Instance:sendNotification(PVEEvent.ReplyInvite)
    FunctionPve.Debug("Pve????????????????????????????????????????????????????????? ??????id  | ????????????:    ", reply_charid, reply_type)
  elseif self:IsServerThanatosInviting() then
    if reply_charid == Game.Myself.data.id then
      FunctionPve.Debug("Pve???????????????????????????????????????????????????????????????,??????????????????????????????")
      self:TryReset()
    else
      FunctionPve.Debug("Pve??????????????????????????????????????????????????????????????? ??????id:   ", reply_charid)
      self:_SetReply(reply_charid, reply_agree)
      GameFacade.Instance:sendNotification(PVEEvent.ReplyInvite)
    end
  else
    FunctionPve.Debug("Pve????????????????????????????????? ??????????????????????????????????????????????????????????????????????????????????????????id:   ", reply_charid)
    self:TryReset()
  end
end
function FunctionPve:_SetReply(charid, reply)
  self.replyMap[charid] = reply
end
function FunctionPve:GetReplyStatus(id)
  return self.replyMap[id]
end
function FunctionPve:GetMyReply()
  return self:GetReplyStatus(Game.Myself.data.id)
end
function FunctionPve:GetPlayerReplyMap()
  return self.replyMap
end
function FunctionPve:CheckEnterValid()
  if not self:IsServerThanatosInviting() and not self:CheckAllOnlinePlayerAgreed() then
    return false
  end
  return true
end
function FunctionPve:CheckAllOnlinePlayerAgreed()
  local _TeamMrg = TeamProxy.Instance
  if not _TeamMrg:IHaveTeam() then
    return false
  end
  local members = _TeamMrg.myTeam:GetPlayerMemberList(true, true)
  for i = 1, #members do
    if not members[i]:IsOffline() and not self:GetReplyStatus(members[i].id) then
      return false
    end
  end
  return true
end
function FunctionPve:Getclient_difficulty()
  return self.client_difficulty
end
function FunctionPve:TryReset()
  if nil == self.serverEntranceData then
    return
  end
  self.serverEntranceData = nil
  self.sendInviteDifficulty = nil
  self.delayInivte = nil
  self.serverInviteEndTime = nil
  self.groupRaid_open = nil
  self.groupRaid_canJoin = nil
  TableUtility.TableClear(self.replyMap)
  GameFacade.Instance:sendNotification(PVEEvent.CancelInvite)
end
function FunctionPve:_CheckInviteInValid()
  local _TeamMrg = TeamProxy.Instance
  local raidType = self.client_raidType
  if _TeamMrg:ForbiddenByRaidType(raidType) then
    MsgManager.ShowMsgByID(_InvalidMsg.diffServer)
    return true
  end
  local t = PvpProxy.RaidType2PvpType[raidType]
  if t and not _TeamMrg:CheckMatchTypeSupportDiffServer(t) then
    MsgManager.ShowMsgByID(_InvalidMsg.diffServer)
    return true
  end
  if _TeamMrg:IHaveTeam() then
    local md = _TeamMrg.myTeam:GetMembersListExceptMe()
    for i = 1, #md do
      if md[i]:IsOffline() then
        MsgManager.ShowMsgByID(_InvalidMsg.memberOffline)
        return true
      end
    end
  end
  if not _TeamMrg:IHaveTeam() then
    self:_AutoCreatTeam(self.client_staticData)
    return true
  end
  local raidtype, difficulty = self.client_raidType, self.client_difficulty
  if not _MidEnter_RaidMap[raidtype] and not self:HasLeaderAuthority() then
    MsgManager.ShowMsgByID(_InvalidMsg.leaderAuthority)
    return true
  end
  local checkCall = self.checkFunc[raidtype]
  if "function" == type(checkCall) and not checkCall(self, raidtype, difficulty) then
    return true
  end
  return false
end
function FunctionPve:_TryMidEnter()
  local raidtype = self.client_raidType
  local diff = self.client_difficulty
  local _TeamMrg = TeamProxy.Instance
  local isMemberInRaid = _TeamMrg.myTeam:HasMemberInRaid(raidtype)
  if isMemberInRaid and _MidEnter_RaidMap[raidtype] then
    local midEnterCall = self.midEnterFunc[raidtype]
    if "function" ~= type(midEnterCall) then
      return false
    end
    midEnterCall()
    return true
  end
  return false
end
function FunctionPve:_DoInvite()
  local inviteRaidStaticData = self.autoCreatTeamRaidEntrance or self.client_staticData
  local raidtype = inviteRaidStaticData.RaidType
  local entranceId = inviteRaidStaticData.id
  local diff = self.client_difficulty
  local inviteCall = self.inviteCall[raidtype]
  if "function" == type(inviteCall) then
    inviteCall(raidtype, diff, entranceId)
  end
end
function FunctionPve:_AutoCreatTeam(staticData)
  FunctionPlayerTip.CreateTeam()
  self.autoCreatTeamRaidEntrance = staticData
  TimeTickManager.Me():CreateOnceDelayTick(3000, function(owner, deltaTime)
    self.autoCreatTeamRaidEntrance = nil
  end, self)
end
function FunctionPve:TryInviteAfterCreatTeam()
  TimeTickManager.Me():CreateOnceDelayTick(2000, function(owner, deltaTime)
    self:_TryInviteAfterCreatTeam()
  end, self)
end
function FunctionPve:_TryInviteAfterCreatTeam()
  if nil == self.autoCreatTeamRaidEntrance then
    return
  end
  if nil == self.client_staticData then
    return
  end
  self:_DoInvite()
  self.autoCreatTeamRaidEntrance = nil
  GameFacade.Instance:sendNotification(PVEEvent.AutoCreatTeamForInvite)
end
function FunctionPve:OnClickPublish()
  if not self.client_staticData then
    return
  end
  if TeamProxy.Instance:IHaveTeam() then
    self:DoPublish()
  else
    self.delayPublishGoal = self.client_staticData.Goal
    FunctionPlayerTip.CreateTeam()
  end
end
function FunctionPve:ClearClientData()
  self.client_staticData = nil
  self.client_raidType = nil
  self.client_difficulty = nil
  self.delayPublishGoal = nil
end
function FunctionPve:TryDelayPublish()
  if not self.delayPublishGoal then
    return
  end
  self.delayPublishGoal = nil
  self:DoPublish()
end
function FunctionPve:OnCreateMyTeam()
  self:TryInviteAfterCreatTeam()
  self:TryDelayPublish()
end
