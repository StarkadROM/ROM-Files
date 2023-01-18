autoImport("GvgDefenseData")
autoImport("GvgSettleInfo")
autoImport("GVGPointInfoData")
autoImport("GVGGroupZone")
autoImport("NewGvgRankData")
autoImport("GuildInfoForQuery")
autoImport("GvgSandTableData")
autoImport("GVGCookingHelper")
autoImport("MiniMapGvgStrongHoldData")
local _fubenCmd = FuBenCmd_pb
local _queueEnterCmd = QueueEnterCmd_pb
local _debugSeasonDesc = {
  [0] = "预备赛阶段",
  [1] = "正赛阶段",
  [2] = "休闲赛阶段",
  [3] = "中断阶段"
}
local _debugQueueTypeDesc = {
  [1] = "攻方",
  [2] = "守方"
}
local EGvgState = {
  None = _fubenCmd.EGVGRAIDSTATE_MIN,
  Peace = _fubenCmd.EGVGRAIDSTATE_PEACE,
  Fire = _fubenCmd.EGVGRAIDSTATE_FIRE,
  Calm = _fubenCmd.EGVGRAIDSTATE_CALM,
  PerfectDefense = _fubenCmd.EGVGRAIDSTATE_PERFECT
}
local EQueueEnter = {
  NONE = _queueEnterCmd.EQUEUEENTERTYPE_MIN,
  GVG_ATT = _queueEnterCmd.EQUEUEENTERTYPE_GVG_ATT,
  GVG_DEF = _queueEnterCmd.EQUEUEENTERTYPE_GVG_DEF
}
local _TableClear = TableUtility.TableClear
local _ArrayClear = TableUtility.ArrayClear
local _ArrayFindIndex = TableUtility.ArrayFindIndex
local _ArrayPushBack = TableUtility.ArrayPushBack
local _InsertArray = TableUtil.InsertArray
local _TimeDate_format = "%Y-%m-%d %H:%M:%S"
local _DateTime = function(time_stamp)
  return os.date(_TimeDate_format, time_stamp)
end
local _queryInterval = 60
local _debugStateDesc = {
  [0] = "未定义",
  [1] = "战斗尚未开启",
  [2] = "战斗中",
  [3] = "冷静期",
  [4] = "完美防守成功"
}
local _playerSitAction = "sit_down2"
GvgProxy = class("GvgProxy", pm.Proxy)
GvgProxy.Instance = nil
GvgProxy.NAME = "GvgProxy"
GvgProxy.ESeasonType = {
  Battle = 1,
  Leisure = 2,
  Break = 3
}
GvgProxy.EpointState = {
  None = _fubenCmd.EGVGPOINT_STATE_MIN,
  Occupied = _fubenCmd.EGVGPOINT_STATE_OCCUPIED
}
GvgProxy.MaxQuestRound = 3
GvgProxy.GvgQuestMap = {
  [_fubenCmd.EGVGDATA_PARTINTIME] = "partin_time",
  [_fubenCmd.EGVGDATA_RELIVE] = "relive_other",
  [_fubenCmd.EGVGDATA_EXPEL] = "expel_enemy",
  [_fubenCmd.EGVGDATA_DAMMETAL] = "dam_metal",
  [_fubenCmd.EGVGDATA_KILLMETAL] = "kill_metal",
  [_fubenCmd.EGVGDATA_KILLUSER] = "kill_one_user",
  [_fubenCmd.EGVGDATA_HONOR] = "get_honor",
  [_fubenCmd.EGVGDATA_OCCUPY_POINT] = "occupy_point",
  [_fubenCmd.EGVGDATA_DEF_POINT_TIME] = "def_point_time",
  [_fubenCmd.EGVGDATA_PARTIN_KILLMETAL] = "partin_kill_metal"
}
GvgProxy.GvgQuestListp = {
  _fubenCmd.EGVGDATA_HONOR,
  _fubenCmd.EGVGDATA_KILLUSER,
  _fubenCmd.EGVGDATA_PARTINTIME,
  _fubenCmd.EGVGDATA_RELIVE,
  _fubenCmd.EGVGDATA_EXPEL,
  _fubenCmd.EGVGDATA_DAMMETAL,
  _fubenCmd.EGVGDATA_KILLMETAL,
  _fubenCmd.EGVGDATA_PARTIN_KILLMETAL,
  _fubenCmd.EGVGDATA_OCCUPY_POINT,
  _fubenCmd.EGVGDATA_DEF_POINT_TIME
}
function GvgProxy.GVGBuildingUniqueID(npcid, lv)
  return npcid * 10000 + lv
end
GvgProxy.MaxMorale = GameConfig.GVGConfig and GameConfig.GVGConfig.max_morale or 100
function GvgProxy:ctor(proxyName, data)
  self.proxyName = proxyName or GvgProxy.NAME
  if GvgProxy.Instance == nil then
    GvgProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:InitProxy()
end
GvgProxy.newGVGDebug = true
function GvgProxy:Debug(...)
  if GvgProxy.newGVGDebug then
    helplog(...)
  end
end
function GvgProxy.ClientGroupId(id)
  return math.fmod(id, 10000) + 1
end
function GvgProxy:InitProxy()
  self.ruleGuild_Map = {}
  self.questInfoData = {}
  self.glandstatus_map = {}
  self.gLandStatusGroupList = {}
  self.GvgSandTableInfo = {}
  self:InitNewGVG()
end
function GvgProxy.SetDungeonCalmDown(calm)
  local currentDungeon = Game.DungeonManager.currentDungeon
  if currentDungeon ~= nil and currentDungeon.SetCalmDown ~= nil then
    currentDungeon:SetCalmDown(calm)
  end
end
function GvgProxy:OnEnterPeaceState()
  GvgProxy.SetDungeonCalmDown(true)
end
function GvgProxy:OnEnterFireState()
  GvgProxy.SetDungeonCalmDown(false)
end
function GvgProxy:OnEnterCalmState()
  GvgProxy.SetDungeonCalmDown(true)
end
function GvgProxy.OnEnterPerfect()
  GvgProxy.SetDungeonCalmDown(true)
end
function GvgProxy:InitNewGVG()
  GvgProxy.RaidStatusDirtyCall = {
    [EGvgState.Peace] = GvgProxy.OnEnterPeaceState,
    [EGvgState.Fire] = GvgProxy.OnEnterFireState,
    [EGvgState.Calm] = GvgProxy.OnEnterCalmState,
    [EGvgState.PerfectDefense] = GvgProxy.OnEnterPerfect
  }
  self.groupZoneMap = {}
  self.groupZoneList = {}
  self.pointInfoMap = {}
  self.myGuildPoints = {}
  self.curOccupingPointID = nil
  self.gvgRaidState = EGvgState.None
  self:ResetQueue()
  self.guildSmallMetalCnt = {}
  self.currentSeaonRankList = {}
  self.queryGuildInfo = GuildInfoForQuery.new()
end
function GvgProxy:HandleQueryGuildInfo(server_data)
  if not server_data then
    return
  end
  self.queryGuildInfo:Reset(server_data)
end
function GvgProxy:GetQueryGuildInfo()
  return self.queryGuildInfo
end
function GvgProxy:SetCurrentPointID(id)
  local myself = Game.Myself
  if myself and myself.data and not myself.data:InGvgZone() and not self.showDiffGvgZoneMsg then
    self.showDiffGvgZoneMsg = true
    MsgManager.ShowMsgByID(2224)
  end
  local pointData = self.pointInfoMap[id]
  if pointData then
    self.curOccupingPointID = id
    self:Debug("NewGVG 更新当前争夺的据点ID： ", id)
    GameFacade.Instance:sendNotification(GVGEvent.GVG_UpdatePointPercentTip)
  else
    self:RemoveCurrentPointID()
  end
  self:_UpdateHoldMetalNpc(id)
end
function GvgProxy:RemoveCurrentPointID()
  self:Debug("NewGVG 删除当前争夺的据点ID: ", self.curOccupingPointID)
  self.curOccupingPointID = -1
  GameFacade.Instance:sendNotification(GVGEvent.GVG_RemovePointPercentTip)
end
function GvgProxy:GetCurOccupingPointID()
  return self.curOccupingPointID or -1
end
function GvgProxy:DoQueryGvgZoneGroup(force_query)
  if force_query or nil == self.queryGroupZoneTime or UnityRealtimeSinceStartup - self.queryGroupZoneTime > _queryInterval then
    self.queryGroupZoneTime = UnityRealtimeSinceStartup
    ServiceGuildCmdProxy.Instance:CallQueryGvgZoneGroupGuildCCmd()
    self:Debug("NewGVG 客户端请求公会战线分组")
  end
end
function GvgProxy:SeasonDirtyCall()
  self.queryGroupZoneTime = nil
  self:ClearMyGuildUnionGroupID()
  _TableClear(self.groupZoneMap)
  _ArrayClear(self.groupZoneList)
  self:ClearCurPerfectDefenseState()
  self:ClearRank()
  self.scoreInfo = nil
end
function GvgProxy:GetBattleWeeklyCount()
  if not self.battle_weekly_count then
    self.battle_weekly_count = 0
    local startTimeConfig = GameConfig.GVGConfig.start_time
    for i = 1, #startTimeConfig do
      if not startTimeConfig[i].super then
        self.battle_weekly_count = self.battle_weekly_count + 1
      end
    end
  end
  return self.battle_weekly_count
end
function GvgProxy:GetWeekBattleCount()
  if not self.weekBattleCnt then
    local weekcnt = self:GetBattleWeeklyCount()
    self.weekBattleCnt = weekcnt * GameConfig.GVGConfig.season_week_count
  end
  return self.weekBattleCnt
end
function GvgProxy:RecvQueryGvgZoneGroupGuildCCmd(data)
  self:Debug("NewGVG 服务器初始化赛季信息")
  TableUtil.Print(data)
  if self.season and self.season ~= data.season then
    self:SeasonDirtyCall()
  end
  local curServerTime = ServerTime.CurServerTime() / 1000
  self.season = data.season
  self:Debug("NewGVG 当前赛季 ：  ", data.season)
  self.begintime = data.begintime or 0
  self.battleCount = data.count or 0
  self.break_begintime = data.break_begintime or 0
  self.break_endtime = data.break_endtime or 0
  self.next_season_begintime = data.next_begintime or 0
  if curServerTime >= self.break_begintime and curServerTime <= self.break_endtime then
    self.seasonStatus = GvgProxy.ESeasonType.Break
  else
    local battle_count = GameConfig.GVGConfig.season_week_count
    local battle_week = math.floor(battle_count / self:GetBattleWeeklyCount())
    if battle_week < self.battleCount or self.season == 0 then
      self.seasonStatus = GvgProxy.ESeasonType.Leisure
      self:Debug("[NewGVG休闲模式] server_battleCount|周场次|season : ", self.battleCount, battle_week, self.season)
    else
      self.seasonStatus = GvgProxy.ESeasonType.Battle
    end
  end
  self:_debugSeasonTime()
  _TableClear(self.groupZoneMap)
  _ArrayClear(self.groupZoneList)
  local infos = data.infos
  if not infos or #infos == 0 then
    self:Debug("NewGVG 后端未推送赛季信息")
    return
  end
  self:Debug("NewGVG 后端推送赛季信息 infoCount ", #infos)
  TableUtil.Print(infos)
  local myGuildZoneId = GuildProxy.Instance:GetMyGuildZoneId()
  self:Debug("NewGVG 自己公会线ID: ", myGuildZoneId)
  self.groupCnt = #infos
  self:Debug("NewGVG 公会线分组数: ", self.groupCnt)
  for i = 1, #infos do
    local groupid = infos[i].groupid
    redlog("groupid: ", groupid)
    local zoneids = infos[i].zoneids
    self.groupZoneMap[groupid] = zoneids
    self.groupZoneList[#self.groupZoneList + 1] = GVGGroupZone.new(groupid, zoneids)
  end
  table.sort(self.groupZoneList, function(a, b)
    return a.groupid < b.groupid
  end)
  self:ResetMyGuildUnionGroupID()
end
function GvgProxy:ClearMyGuildUnionGroupID()
  self.myGuildGvgGroupServerID = nil
  self.myGuildGvgGroupID = nil
  self.myGuildUnionGvgGroupServerID = nil
  self.myGuildUnionGroupID = nil
end
function GvgProxy:ResetMyGuildUnionGroupID()
  self:ClearMyGuildUnionGroupID()
  if not self.groupZoneList or not next(self.groupZoneList) then
    return
  end
  local myGuildZoneId = GuildProxy.Instance:GetMyGuildZoneId()
  local guildUnionZoneId = GuildProxy.Instance:GetMyGuildUnionZoneId()
  local groupid
  for i = 1, #self.groupZoneList do
    groupid = self.groupZoneList[i].server_groupid
    if myGuildZoneId and myGuildZoneId > 0 and self.groupZoneList[i]:CheckZoneIndex(myGuildZoneId) then
      self.myGuildGvgGroupServerID = groupid
      self.myGuildGvgGroupID = GvgProxy.ClientGroupId(groupid)
      self:Debug("自己公会线分组groupidID|ClientGroupidID: ", groupid, self.myGuildGvgGroupID)
    end
    if guildUnionZoneId and guildUnionZoneId > 0 and self.groupZoneList[i]:CheckZoneIndex(guildUnionZoneId) then
      self.myGuildUnionGvgGroupServerID = groupid
      self.myGuildUnionGroupID = GvgProxy.ClientGroupId(groupid)
      self:Debug("自己公会共同体分组groupidID|ClientGroupidID: ", groupid, self.myGuildUnionGroupID)
    end
  end
end
function GvgProxy:GetMyGuildUnionGroupID()
  return self.myGuildUnionGvgGroupServerID
end
function GvgProxy:CheckCurMapIsInGuildUnionGroup()
  local curMapGroupId = self:GetCurMapGvgGroupID()
  local myGuildUnionGroupId = self:GetMyGuildUnionGroupID()
  return curMapGroupId == myGuildUnionGroupId
end
function GvgProxy:GetGroupIDByRealZone()
  local real_zone = Game.Myself.data.userdata:Get(UDEnum.REAL_ZONEID)
  for k, v in pairs(self.groupZoneMap) do
    if 0 ~= _ArrayFindIndex(v, real_zone) then
      return GvgProxy.ClientGroupId(k)
    end
  end
end
function GvgProxy:GetMyGuildGvgGroupID()
  return self.myGuildGvgGroupID
end
function GvgProxy:GetMyGuildGvgGroupServerID()
  return self.myGuildGvgGroupServerID
end
function GvgProxy:GetCurMapGvgGroupDesc()
  local result = ""
  local groupId = self:GetGroupIDByRealZone()
  if groupId then
    result = string.format(ZhString.NewGVG_GroupID, tostring(groupId))
  end
  return result
end
function GvgProxy:_debugSeasonTime()
  self:Debug("NewGVG 开赛次数 ：  ", self.battleCount)
  if self.begintime > 0 then
    self:Debug("NewGVG 赛季开始时间 ：  ", _DateTime(self.begintime))
  end
  if 0 < self.break_begintime then
    self:Debug("NewGVG 赛季中断开始时间 ：  ", _DateTime(self.break_begintime))
  end
  if 0 < self.break_endtime then
    self:Debug("NewGVG 赛季中断结束时间 ：  ", _DateTime(self.break_endtime))
  end
  if 0 < self.next_season_begintime then
    self:Debug("NewGVG 下赛季开始时间 ：  ", _DateTime(self.next_season_begintime))
  end
  self:Debug("NewGVG 赛季阶段： ", _debugSeasonDesc[self.seasonStatus])
end
function GvgProxy:GetSeasonStatus()
  return self.seasonStatus
end
function GvgProxy:IsBattleSeason()
  return self.seasonStatus == GvgProxy.ESeasonType.Battle
end
function GvgProxy:IsBreakSeason()
  return self.seasonStatus == GvgProxy.ESeasonType.Break
end
function GvgProxy:IsLeisureSeason()
  return self.seasonStatus == GvgProxy.ESeasonType.Leisure
end
function GvgProxy:NowSeason()
  return self.season or 0
end
function GvgProxy:NowBattleCount()
  return self.battleCount
end
function GvgProxy:GetGroupCnt()
  return self.groupCnt or 0
end
function GvgProxy:GetGvgGroupID(zoneid)
  for i = 1, #self.groupZoneList do
    if self.groupZoneList[i]:CheckZoneIndex(zoneid) then
      return self.groupZoneList[i].server_groupid
    end
  end
  return -1
end
function GvgProxy:GetGvgGroupIDBySimplyZoneId(simply_zoneid)
  for i = 1, #self.groupZoneList do
    if self.groupZoneList[i]:CheckSimplyZoneIndex(simply_zoneid) then
      return self.groupZoneList[i].server_groupid
    end
  end
  return -1
end
function GvgProxy:GetCurMapGvgGroupID()
  if Game.MapManager:GetMapID() == 1 then
    local curRealzoneid = Game.Myself.data.userdata:Get(UDEnum.REAL_ZONEID) or 0
    local groupid = self:GetGvgGroupID(curRealzoneid)
    return groupid
  else
    local curZoneid = Game.Myself.data.userdata:Get(UDEnum.ZONEID) or 0
    local groupid = self:GetGvgGroupIDBySimplyZoneId(curZoneid)
    return groupid
  end
end
function GvgProxy:GetGroupZoneList()
  return self.groupZoneList
end
local _GLandfilterMap = {}
function GvgProxy:GetGLandGroupZoneFilter()
  _TableClear(_GLandfilterMap)
  local curMapGroupId = self:GetCurMapGvgGroupID()
  if curMapGroupId > 0 then
    _GLandfilterMap[curMapGroupId * 10] = ZhString.GLandStatusListView_Current
  end
  if self.myGuildGvgGroupServerID then
    _GLandfilterMap[self.myGuildGvgGroupServerID * 100] = ZhString.GLandStatusListView_Guild
  end
  for i = 1, #self.groupZoneList do
    _GLandfilterMap[self.groupZoneList[i].server_groupid * 1000] = self.groupZoneList[i]:GetGroupIdStr()
  end
  return _GLandfilterMap
end
function GvgProxy:_RecvPoint(points, isInit)
  if not points or #points <= 0 then
    return
  end
  if isInit then
    _TableClear(self.pointInfoMap)
    _ArrayClear(self.myGuildPoints)
  end
  local point
  for i = 1, #points do
    local serverPoint = points[i]
    point = self:GetPointData(serverPoint.pointid)
    if nil == point then
      point = self:_AddPoint(serverPoint)
    else
      point = self:_UpdatePoint(serverPoint)
    end
    if point:IsMyGuildPoint() then
      table.insert(self.myGuildPoints, point)
    end
  end
  self:UpdateGvgStrongHoldSymbolDatas()
  GameFacade.Instance:sendNotification(GVGEvent.GVG_PointUpdate)
  EventManager.Me():DispatchEvent(GVGEvent.GVG_PointUpdate)
end
function GvgProxy:_AddPoint(point)
  local pointData = GVGPointInfoData.new(point)
  self.pointInfoMap[pointData.pointid] = pointData
  return pointData
end
function GvgProxy:_UpdatePoint(point)
  local pointData = self.pointInfoMap[point.pointid]
  pointData:Update(point)
  return pointData
end
function GvgProxy:IHaveGuildPoint()
  return nil ~= self.myGuildPoints and nil ~= next(self.myGuildPoints)
end
function GvgProxy:GetPointData(point_id)
  return self.pointInfoMap[point_id]
end
function GvgProxy:RecvGvgPointUpdateFubenCmd(data)
  self:Debug("NewGVG 服务器更新据点信息")
  TableUtil.Print(data)
  self:_RecvPoint(data.info)
end
function GvgProxy:RecvGvgRaidStateUpdateFubenCmd(data)
  self:_UpdateRaidState(data.raidstate)
end
function GvgProxy:_UpdateRaidState(state)
  if not state then
    return
  end
  if state ~= self.gvgRaidState then
    self.gvgRaidState = state
    self:Debug("NewGVG 副本状态更新 state: ", _debugStateDesc[state])
    self:_RaidStatusChange(state)
  end
end
function GvgProxy:IsFireState()
  return self.gvgRaidState == EGvgState.Fire
end
function GvgProxy:IsCalmState()
  return self.gvgRaidState == EGvgState.Calm
end
function GvgProxy:IsPeaceState()
  return self.gvgRaidState == EGvgState.Peace
end
function GvgProxy:IsPerfectDefense()
  return self.gvgRaidState == EGvgState.PerfectDefense
end
function GvgProxy:_RaidStatusChange(state)
  local call = GvgProxy.RaidStatusDirtyCall[state]
  if call then
    call(self)
  end
end
function GvgProxy:ResetQueue()
  if not self.inQueue then
    return
  end
  self.inQueue = false
  self.queueType = EQueueEnter.NONE
  self.queueWaitNum = 0
  GameFacade.Instance:sendNotification(GVGEvent.GVG_QueueRemove)
end
function GvgProxy:GetQueueInfo()
  return self.inQueue, self.queueWaitNum, self.queueType
end
function GvgProxy:CancelQueue()
  if not self.queueType then
    return
  end
  ServiceQueueEnterCmdProxy.Instance:CallReqQueueEnterCmd(true, self.queueType)
end
function GvgProxy:RecvQueueUpdateCountCmd(data)
  if data.etype ~= self.queueType then
    redlog("服务器更新排队人数变化，排队类型与服务器类型不一致, 本地类型 | 服务器类型： ", self.queueType, data.etype)
    return
  end
  self:Debug("NewGVG  服务器更新排队队列。减少人数 | 总人数： ", data.dec_num, self.queueWaitNum - data.dec_num)
  self.queueWaitNum = self.queueWaitNum - data.dec_num
  GameFacade.Instance:sendNotification(GVGEvent.GVG_QueueUpdate)
end
function GvgProxy:RecvQueueEnterRetCmd(data)
  if data.stop then
    self:Debug("NewGVG  服务器通知取消排队")
    self:ResetQueue()
    return
  end
  self:Debug("NewGVG  服务器通知排队成功 排队类型 | 排队人数 : ", _debugQueueTypeDesc[data.etype], data.waitnum)
  self.queueType = data.etype
  self.inQueue = true
  self.queueWaitNum = data.waitnum
  GameFacade.Instance:sendNotification(GVGEvent.GVG_QueueAdd)
end
function GvgProxy:HandleNewGvgRankInfo(data)
  local page = data.page
  if not page or "number" ~= type(page) then
    return
  end
  local infos = data.infos
  if not infos then
    return
  end
  local ranklist_myGuildData
  for i = 1, #infos do
    local gvgRankData = NewGvgRankData.new(infos[i])
    _ArrayPushBack(self.currentSeaonRankList, gvgRankData)
    if gvgRankData.id == GuildProxy.Instance.guildId then
      ranklist_myGuildData = gvgRankData
    end
  end
  self:_TrySearchGuild()
  if data.selfinfo then
    self.myGuildGvgRankInfo = ranklist_myGuildData or NewGvgRankData.new(data.selfinfo)
  end
end
function GvgProxy:DoSearchGuildInRankList(keywords)
  self.rank_searchKeywords = keywords
  if not self:HasCurrentSeasonRank() then
    self:DoQueryGvgRank(0)
    TimeTickManager.Me():CreateOnceDelayTick(2000, function(owner, deltaTime)
      if nil ~= self.rank_searchKeywords then
        self.rank_searchKeywords = nil
        GameFacade.Instance:sendNotification(GVGEvent.GVG_SearchGuildTimeOut)
      end
    end, self, 1)
    return
  end
  self:_TrySearchGuild()
end
local searchResult = {}
local guild_name
function GvgProxy:_TrySearchGuild()
  if not self.rank_searchKeywords then
    return
  end
  _ArrayClear(searchResult)
  for i = 1, #self.currentSeaonRankList do
    guild_name = self.currentSeaonRankList[i]:GetGuildName()
    if nil ~= string.match(guild_name, self.rank_searchKeywords) then
      searchResult[#searchResult + 1] = self.currentSeaonRankList[i]
    end
  end
  GameFacade.Instance:sendNotification(GVGEvent.GVG_SearchGuild, searchResult)
  self.rank_searchKeywords = nil
end
function GvgProxy:GetMyGuildRank()
  return self.myGuildGvgRankInfo
end
function GvgProxy:HasCurrentSeasonRank()
  return nil ~= next(self.currentSeaonRankList)
end
function GvgProxy:DoQueryGvgRank(page)
  if nil == self.queryRankTime or UnityRealtimeSinceStartup - self.queryRankTime > _queryInterval then
    self.queryRankTime = UnityRealtimeSinceStartup
    _ArrayClear(self.currentSeaonRankList)
    ServiceGuildCmdProxy.Instance:CallGvgRankInfoQueryGuildCmd(page, GuildProxy.Instance.guildId)
    self:Debug("NewGVG 客户端请求GVG排行榜")
  end
end
function GvgProxy:DoQueryHistoryGvgRank()
  if self:HasHistoryGvgRank() then
    return
  end
  ServiceGuildCmdProxy.Instance:CallGvgRankHistroyQueryGuildCmd()
end
function GvgProxy:HasHistoryGvgRank()
  return nil ~= self.historyRankMap
end
function GvgProxy:ClearRank()
  if self.historyRankMap then
    _TableClear(self.historyRankMap)
    self.historyRankMap = nil
  end
  if self.historyRankList then
    _ArrayClear(self.historyRankList)
    self.historyRankList = nil
  end
  _ArrayClear(self.currentSeaonRankList)
end
function GvgProxy:HandleQueryHistoryGvgRank(data)
  local server_data = data.history_infos
  if not server_data then
    return
  end
  self.historyRankMap = {}
  local _tempRankData
  for i = 1, #server_data do
    local season = server_data[i].season
    local seasonRanks = {}
    local championCnt = 0
    for j = 1, #server_data[i].infos do
      _tempRankData = NewGvgRankData.new(server_data[i].infos[j])
      if _tempRankData:IsTop3() then
        seasonRanks[#seasonRanks + 1] = _tempRankData
      end
      if _tempRankData:IsChampion() then
        championCnt = championCnt + 1
      end
    end
    self.historyRankMap[season] = {seasonRanks, championCnt}
  end
end
function GvgProxy:GetGvgCurrentSeasonRankData()
  return self.currentSeaonRankList or _EmptyTable
end
function GvgProxy:GetGvgHistoryRankData()
  if nil == self.historyRankList then
    self.historyRankList = {}
    if self.historyRankMap then
      for season, datas in pairs(self.historyRankMap) do
        local singleSeasonData = {
          rankData = datas[1],
          championCnt = datas[2],
          season = season
        }
        table.insert(self.historyRankList, singleSeasonData)
      end
    end
  end
  return self.historyRankList
end
function GvgProxy:HandleSmallMetalCnt(guildid, count)
  if not guildid then
    return
  end
  self:Debug("NewGVG 服务器同步小华丽水晶占领数量. guildid count : ", guildid, count)
  self.guildSmallMetalCnt[guildid] = count
  if GuildProxy.Instance:IsMyGuildUnion(guildid) then
    self:Debug("NewGVG 我方公会占领小华丽水晶 ： ", count)
    GameFacade.Instance:sendNotification(GVGEvent.GVG_SmallMetalCntUpdate, count)
  end
end
function GvgProxy:GetSmallMetalCnt(id)
  return self.guildSmallMetalCnt[id] or 0
end
function GvgProxy:GetMyGuildSmallMetalCnt()
  local myguildId = GuildProxy.Instance:GetGuildID()
  return myguildId and self.guildSmallMetalCnt[myguildId] or 0
end
function GvgProxy:CanIGetMoreStrongHoldReward()
  local maxCount = GameConfig.GVGConfig and GameConfig.GVGConfig.occupy_smallmetal_maxcount
  local myCount = self:GetMyGuildSmallMetalCnt()
  if myCount and maxCount and maxCount <= myCount then
    return false
  else
    return true
  end
end
function GvgProxy:ClearFightInfo()
  _TableClear(self.pointInfoMap)
  self.curOccupingPointID = nil
  self.gvgRaidState = EGvgState.None
  self.showDiffGvgZoneMsg = nil
  self.isDefSide = nil
  self.expelTime = nil
end
function GvgProxy:ClearQuestInfo()
  _TableClear(self.questInfoData)
  self.cityType = nil
  self.groupTaskID = nil
  self.groupTaskProgress = nil
end
function GvgProxy:GetRuleGuildInfo(flagid, groupid)
  if groupid and self.glandstatus_map[groupid] and self.glandstatus_map[groupid][flagid] then
    return self.glandstatus_map[groupid][flagid], 2
  end
  if self.ruleGuild_Map[flagid] then
    return self.ruleGuild_Map[flagid], 1
  end
end
function GvgProxy:SetRuleGuildInfos(server_GuildCityInfos)
  if server_GuildCityInfos == nil then
    return
  end
  for i = 1, #server_GuildCityInfos do
    self:SetRuleGuildInfo(server_GuildCityInfos[i])
  end
end
function GvgProxy:SetRuleGuildInfo(server_GuildCityInfo)
  if server_GuildCityInfo == nil then
    return
  end
  local info = self.ruleGuild_Map[server_GuildCityInfo.cityid]
  if server_GuildCityInfo.guildid == 0 then
    self.ruleGuild_Map[server_GuildCityInfo.cityid] = nil
    return
  end
  if info == nil then
    info = {}
    self.ruleGuild_Map[server_GuildCityInfo.cityid] = info
  end
  info.id = server_GuildCityInfo.guildid
  info.flag = server_GuildCityInfo.cityid
  info.lv = server_GuildCityInfo.lv
  info.membercount = server_GuildCityInfo.membercount
  info.name = server_GuildCityInfo.name
  info.portrait = server_GuildCityInfo.portrait
  FunctionGuild.Me():SetGuildLandIcon(info.flag, info.portrait, info.id)
end
function GvgProxy:ClearRuleGuildInfos()
  _TableClear(self.ruleGuild_Map)
end
function GvgProxy:IsInFightingTime()
  return self.gvg_isopen
end
function GvgProxy:SetGvgOpenTime(isOpen, starttime)
  self.gvg_isopen = isOpen
  self.gvg_opentime = starttime
end
function GvgProxy:GetGvgOpenTime()
  return self.gvg_opentime
end
function GvgProxy:RecvGuildFireMetalHpFubenCmd(data)
  self.metal_hpper = data.hpper
end
function GvgProxy:RecvGvgDefNameChangeFubenCmd(data)
  self.def_guildname = data.newname
  self:Debug("NewGVGDebug防守方公会名 防守方公会名修改： ", data.newname)
end
function GvgProxy:IsNeutral()
  return self.def_guildid and self.def_guildid == 0
end
function GvgProxy:GetDefGuildName()
  if StringUtil.IsEmpty(self.def_guildname) then
    if self.def_guildid and self.def_guildid > 0 then
      redlog("-------------------------[NewGVG]后端未赋值防守公会名")
    end
    return ""
  end
  return self.def_guildname
end
function GvgProxy:IsDefSide()
  return self.isDefSide
end
function GvgProxy:GetExpelTime()
  return self.expelTime or 15
end
function GvgProxy:EnterDeathStatus()
  if not Game.MapManager:IsPVPMode_GVGDetailed() then
    return
  end
  if not self:IHaveGuildPoint() then
    return
  end
  local expelTime = self:GetExpelTime()
  UIUtil.SceneCountDownMsg(2225, {
    tostring(expelTime)
  }, true)
end
function GvgProxy:ExitDeathStatus()
  if not Game.MapManager:IsPVPMode_GVGDetailed() then
    return
  end
  UIUtil.EndSceenCountDown(2225)
end
function GvgProxy:RecvGuildFireNewDefFubenCmd(data)
  self.def_guildid = data.guildid
  self.isDefSide = GuildProxy.Instance:IsMyGuildUnion(self.def_guildid)
  self.expelTime = self.isDefSide and GameConfig.GVGConfig.def_expel_time or GameConfig.GVGConfig.att_expel_time
  self.def_guildname = data.guildname
  self.metal_hpper = 100
  self:Debug("NewGVG 切换攻守方，重置华丽水晶血量。新的防守方同步|防守方公会名： ", data.guildid, data.guildname)
end
function GvgProxy:RecvGvgDataSyncCmd(data)
  local datas = data.datas
  for i = 1, #datas do
    local single = datas[i]
    self.questInfoData[single.type] = single.value
  end
  self.cityType = data.citytype
end
function GvgProxy:RecvGvgDataUpdateCmd(data)
  local gvgData = data.data
  self:CheckIfAchieve(self.questInfoData[gvgData.type], gvgData)
  self.questInfoData[gvgData.type] = gvgData.value
end
function GvgProxy:GetHonor()
  return self.questInfoData[FuBenCmd_pb.EGVGDATA_HONOR] or 0
end
function GvgProxy:GetCoin()
  return self.questInfoData[FuBenCmd_pb.EGVGDATA_COIN] or 0
end
function GvgProxy:CheckIfAchieve(oldData, data)
  local key = data.type
  local value = data.value
  local configData = GameConfig.GVGConfig.reward[GvgProxy.GvgQuestMap[key]]
  if configData then
    local index = 1
    local dataInfo
    local maxRound = index < #configData and #configData or index
    if key == _fubenCmd.EGVGDATA_KILLUSER then
      return
    end
    if configData[index] and value < configData[index].times or index > maxRound then
      if value >= configData[maxRound].times then
        while oldData and oldData < configData[maxRound].times or not oldData do
          GameFacade.Instance:sendNotification(GVGEvent.ShowNewAchievemnetEffect)
          do break end
          if configData[index - 1] and (oldData and oldData < configData[index - 1].times or not oldData) then
            GameFacade.Instance:sendNotification(GVGEvent.ShowNewAchievemnetEffect)
          end
          do break end
          index = index + 1
        end
      end
    end
  end
end
function GvgProxy:_TryShowCDTime(calm_time)
  if calm_time and calm_time > 0 then
    if not self:IsCalmState() then
      redlog("NewGVG 非冷静期后端同步了冷静期截止时间")
      return
    end
    local curServerTime = ServerTime.CurServerTime() / 1000
    local cdtime = calm_time - curServerTime
    if cdtime > 0 then
      MsgManager.ShowMsgByIDTable(2220, {
        tostring(cdtime)
      })
    end
  end
end
function GvgProxy:RecvGuildFireInfoFubenCmd(data)
  self:Debug("NewGVG 玩家进入时同步公会战信息 ")
  TableUtil.Print(data)
  self:_UpdateRaidState(data.raidstate)
  self:_TryShowCDTime(data.calm_time)
  self.def_guildid = data.def_guildid
  redlog("Debug防守方公会id： ", data.def_guildid)
  self.isDefSide = GuildProxy.Instance:IsMyGuildUnion(self.def_guildid)
  self.expelTime = self.isDefSide and GameConfig.GVGConfig.def_expel_time or GameConfig.GVGConfig.att_expel_time
  self.endfire_time = data.endfire_time
  self.metal_hpper = data.metal_hpper
  self.def_guildname = data.def_guildname
  self:Debug("NewGVGDebug防守方公会名 进入副本防守公会名字 ", self.def_guildname)
  self.def_perfect = data.def_perfect
  self.danger = data.danger
  _TableClear(self.pointInfoMap)
  self:_RecvPoint(data.points, true)
  if data.my_smallmetal_cnt then
    self:HandleSmallMetalCnt(GuildProxy.Instance:GetGuildID(), data.my_smallmetal_cnt)
  end
  self:DoQueryGvgZoneGroup(true)
  self:_resetPerfectDefense(self:IsPerfectDefense())
  self:_resetPerfectDefensePause(data.perfect_time.pause)
  self.perfectTimeInfo = GgvPerfectTimeInfo.new(data.perfect_time)
  self:Debug("[NewGVG]进入副本 完美防守暂停|时间： ", self.perfectTimeInfo.pause, os.date("%Y-%m-%d-%H-%M-%S", self.perfectTimeInfo.time))
end
function GvgProxy:_resetPerfectDefensePause(pause)
  if not self.perfectTimeInfo then
    return
  end
  if nil == pause then
    return
  end
  if self.perfectTimeInfo.pause == pause then
    return
  end
  local event = pause and GVGEvent.GVG_PerfectDefensePause or GVGEvent.GVG_PerfectDefenseResume
  local _debugStr = pause and "[NewGVG] 主界面暂停完美防守" or "[NewGVG] 主界面重启完美防守"
  self:Debug(_debugStr)
  GameFacade.Instance:sendNotification(event)
end
function GvgProxy:_resetPerfectDefense(perfect)
  self:Debug("[NewGVG] 重置是否为完美防守 ", perfect)
  if nil == perfect then
    return
  end
  if self.isPerfectDefense == perfect then
    return
  end
  self.isPerfectDefense = perfect
  if perfect then
    GameFacade.Instance:sendNotification(GVGEvent.GVG_PerfectDefenseSuccess)
  end
end
function GvgProxy:ClearCurPerfectDefenseState()
  self.isPerfectDefense = nil
  self.perfectTimeInfo = nil
end
function GvgProxy:RecvPerfectStateUpdate(server_data)
  self:_resetPerfectDefense(server_data.perfect)
  self:_resetPerfectDefensePause(server_data.perfect_time.pause)
  self.perfectTimeInfo = GgvPerfectTimeInfo.new(server_data.perfect_time)
  self:Debug("[NewGVG] 完美防守状态更新 pause|perfect|time ", self.perfectTimeInfo.pause, server_data.perfect, os.date("%Y-%m-%d-%H-%M-%S", self.perfectTimeInfo.time))
end
function GvgProxy:GetPerfectTimeInfo()
  return self.perfectTimeInfo
end
function GvgProxy:HandleRecvGvgScoreInfoUpdateGuildCmd(server_data)
  local info = server_data.info
  if not info then
    return
  end
  self.scoreInfo = {}
  self.scoreInfo.defense = info.defense_score
  self.scoreInfo.attack = info.attack_score
  self.scoreInfo.perfect = info.perfect_score
  self:Debug("[NewGVG] 本场公会战积分信息 保卫城池得分|击破华丽金属得分|完美防守得分 ", info.defense_score, info.attack_score, info.perfect_score)
  self.scoreInfo.scoreDefenseCityMap = {}
  local defensecitys = info.defensecitys
  if not defensecitys then
    self:Debug("[NewGVG] no defensecitys")
    return
  end
  self:Debug("[NewGVG] server defensecitys length: ", #defensecitys)
  for i = 1, #defensecitys do
    self:_UpdateDefenseData(defensecitys[i])
  end
end
function GvgProxy:_UpdateDefenseData(server_data)
  local defenseData = GvgDefenseData.new(server_data)
  self.scoreInfo.scoreDefenseCityMap[defenseData.cityid] = defenseData
end
function GvgProxy:GetMaxOccupyCityScore()
  if not self.maxOccupy_city_score then
    self.maxOccupy_city_score = 0
    local config = GameConfig.GVGConfig and GameConfig.GVGConfig.citytype_data
    if config then
      local mathMax = math.max
      for _, v in pairs(config) do
        if v.occupy_city_score then
          self.maxOccupy_city_score = mathMax(v.occupy_city_score, self.maxOccupy_city_score)
        end
      end
    end
  end
  return self.maxOccupy_city_score
end
function GvgProxy:GetBattleEndInfo()
  if not self.battleEndConfig then
    self.battleEndConfig = GameConfig.GVGConfig.ScoreTip.battleEnd
  end
  return self.battleEndConfig
end
function GvgProxy:GetBattleInfo()
  if not self.battleScoreConfig then
    self.battleScoreConfig = GameConfig.GVGConfig.ScoreTip.battle
  end
  return self.battleScoreConfig
end
function GvgProxy:GetScorePerfectDefenseInfo()
  local mapData = self.scoreInfo and self.scoreInfo.scoreDefenseCityMap
  if not mapData then
    return
  end
  local defensePerfectData = {}
  for k, v in pairs(mapData) do
    defensePerfectData[#defensePerfectData + 1] = {
      v.cityName,
      v.time,
      v.perfect,
      v.pause
    }
  end
  return defensePerfectData
end
function GvgProxy:GetScoreInfoByKey(key)
  return self.scoreInfo and self.scoreInfo[key] or 0
end
function GvgProxy:HandleSettleInfo(info)
  if not info then
    return
  end
  self.settleInfo = GvgSettleInfo.new(info)
  if self.settleInfo.settleFinish then
    if not self.manualSettleReq then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.GLandStatusListView
      })
    end
  else
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.GvgLandPlanView
    })
  end
  self.manualSettleReq = nil
end
function GvgProxy:IsPlanConfirmed()
  return self.settleInfo and self.settleInfo:IsPlanConfirmed()
end
function GvgProxy:GetGLandSettleData()
  return self.settleInfo and self.settleInfo.settleCityList or _EmptyTable
end
function GvgProxy:GetLastWeekGuildName()
  return self.settleInfo and self.settleInfo:GetLastWeekGuildName()
end
function GvgProxy:GetLastWeekCityName()
  return self.settleInfo and self.settleInfo:GetLastWeekCityName()
end
function GvgProxy:HasSelectCitys()
  return self.settleInfo and self.settleInfo:HasSelectCitys()
end
function GvgProxy:InitCurRaidStrongHold()
  if not Game.MapManager:IsPVPMode_GVGDetailed() then
    return
  end
  local raidId = Game.MapManager:GetRaidID()
  self:Debug("NewGVG 当前raidId ： ", raidId)
  local staticData = Game.Config_GuildStrongHold_RaidMap[raidId]
  if not staticData then
    redlog("Table_Guild_StrongHold 配置未找到  raidId : ", raidId)
    return
  end
  self.curStrongHoldStaticData = staticData
end
function GvgProxy:GetCurRaidStrongHoldPointConfig()
  local staticData = self.curStrongHoldStaticData
  if not staticData or not staticData.Point then
    local point
  end
  return point
end
function GvgProxy:_UpdateHoldMetalNpc(point_id)
  self.metalNpc = self.metalNpc or {}
  local nnpcArray = NSceneNpcProxy.Instance:FindNpcByUniqueId(point_id)
  if nnpcArray and #nnpcArray > 0 then
    local miniMapGvgStrongHoldData = self.gvgStrongHoldDatas and self.gvgStrongHoldDatas[point_id]
    local active = miniMapGvgStrongHoldData and miniMapGvgStrongHoldData:IsActive()
    if active then
      nnpcArray[1]:Show()
    else
      nnpcArray[1]:Hide()
    end
    self.metalNpc[nnpcArray[1].data.id] = active
  end
end
function GvgProxy:CheckMetalNpcBornHide(id)
  return self.metalNpc and id and self.metalNpc[id] == false
end
function GvgProxy:ClearMetalNpcMap()
  _TableClear(self.metalNpc)
end
function GvgProxy:GetGvgStrongHoldDatas()
  return self.gvgStrongHoldDataArray
end
function GvgProxy:UpdateGvgStrongHoldSymbolDatas()
  if not self.gvgStrongHoldDatas then
    self.gvgStrongHoldDatas = {}
  end
  if not self.gvgStrongHoldDataArray then
    self.gvgStrongHoldDataArray = {}
  end
  TableUtility.ArrayClear(self.gvgStrongHoldDataArray)
  local configs = GvgProxy.Instance:GetCurRaidStrongHoldPointConfig()
  if not configs then
    TableUtility.TableClear(self.gvgStrongHoldDatas)
    return
  end
  for k, v in pairs(self.gvgStrongHoldDatas) do
    if not configs[v.id] then
      self.gvgStrongHoldDatas[k] = nil
    end
  end
  local proxy = GvgProxy.Instance
  for id, conf in pairs(configs) do
    if type(id) == "string" then
      id = tonumber(id)
    end
    local data = proxy:GetPointData(id)
    local cachedData = self.gvgStrongHoldDatas[id]
    if cachedData then
      cachedData:SetConfig(conf)
      cachedData:SetData(data)
    else
      cachedData = MiniMapGvgStrongHoldData.new(id, conf, data)
      self.gvgStrongHoldDatas[id] = cachedData
    end
    table.insert(self.gvgStrongHoldDataArray, cachedData)
    self:_UpdateHoldMetalNpc(id)
  end
  table.sort(self.gvgStrongHoldDataArray, function(a, b)
    return a and b and a:GetIndex() < b:GetIndex()
  end)
end
function GvgProxy:GetCurCityId()
  return self.curStrongHoldStaticData and self.curStrongHoldStaticData.id or -1
end
local _GLandStatusInfos_dirty = {}
function GvgProxy:Update_GLandStatusInfos(server_infos, groupid)
  self:Debug("[NewGVG] 更新战线城池界面信息groupid server_infos length ", groupid, #server_infos)
  if self.glandstatus_map[groupid] then
    _TableClear(self.glandstatus_map[groupid])
  else
    self.glandstatus_map[groupid] = {}
  end
  if not server_infos then
    return
  end
  for i = 1, #server_infos do
    local server_info = server_infos[i]
    local cityid = server_info.cityid
    local tdata = self.glandstatus_map[groupid][cityid]
    if tdata == nil then
      tdata = {cityid = cityid}
      self.glandstatus_map[groupid][tdata.cityid] = tdata
    end
    tdata.state = server_info.state
    tdata.guildid = server_info.guildid
    tdata.name = server_info.name
    tdata.portrait = server_info.portrait
    tdata.lv = server_info.lv
    tdata.groupid = groupid
    tdata.membercount = server_info.membercount
    tdata.leadername = server_info.leadername
    tdata.oldguildid = server_info.oldguild
  end
  _GLandStatusInfos_dirty[groupid] = true
end
function GvgProxy:Get_GLandStatusInfos(groupid)
  if not _GLandStatusInfos_dirty[groupid] then
    return self.gLandStatusGroupList[groupid]
  end
  _GLandStatusInfos_dirty[groupid] = false
  if self.gLandStatusGroupList[groupid] then
    _ArrayClear(self.gLandStatusGroupList[groupid])
  else
    self.gLandStatusGroupList[groupid] = {}
  end
  for k, v in pairs(self.glandstatus_map[groupid]) do
    _ArrayPushBack(self.gLandStatusGroupList[groupid], v)
  end
  table.sort(self.gLandStatusGroupList[groupid], function(a, b)
    return a.cityid < b.cityid
  end)
  return self.gLandStatusGroupList[groupid]
end
function GvgProxy:GetGuildInfos()
  local testDatas = {}
  for i = 1, 4 do
    local guildData = {
      id = 12312,
      customIconUpTime = 215456464,
      customicon = 1545
    }
    guildData.pieces = i
    guildData.metal = i
    guildData.occupationValue = 100
    testDatas[#testDatas + 1] = guildData
  end
  return testDatas
end
function GvgProxy:ShowGvgFinalFightTip(stick)
  TipManager.Instance:ShowGvgFinalFightTip(stick, NGUIUtil.AnchorSide.Right, {-450, 0})
end
function GvgProxy:SetGvgOpenFireState(b, settle_time)
  self.gvgOpenFireState = b
  self.gvgFireSettleTime = settle_time
  self:Debug("[NewGVG] GvgOpenFireGuildCmd fire | settleTime ", b, os.date("%Y-%m-%d-%H-%M-%S", settle_time))
  self:ManualQuerySettleInfo()
end
function GvgProxy:ManualQuerySettleInfo()
  if self.gvgOpenFireState == false and self:CheckInSettleTime() and GuildProxy.Instance:ImGuildChairman() then
    self.manualSettleReq = true
    ServiceGuildCmdProxy.Instance:CallGvgSettleReqGuildCmd()
  end
end
function GvgProxy:GetGvgOpenFireState()
  return self.gvgOpenFireState
end
function GvgProxy:CanPlanShow()
  if not GuildProxy.Instance:ImGuildChairman() then
    return false
  end
  local noFire = not self:GetGvgOpenFireState()
  local inSettleTime = self:CheckInSettleTime()
  return noFire and inSettleTime
end
function GvgProxy:CheckInSettleTime()
  return self.gvgFireSettleTime and self.gvgFireSettleTime > 0 and self.gvgFireSettleTime > ServerTime.CurServerTime() / 1000
end
function GvgProxy:GetSettleTime()
  return self.gvgFireSettleTime
end
function GvgProxy:IsGvgFlagShow()
  return not self:GetGvgOpenFireState() and self:CheckInSettleTime() and GuildProxy.Instance:IHaveGuild()
end
local _defaultTime = 1800
function GvgProxy:IsFPSOptimizeValid()
  local _mapMgr = Game.MapManager
  local isGVG = _mapMgr:IsPVPMode_GVGDetailed()
  local isGVGDroiyan = _mapMgr:IsGvgMode_Droiyan()
  local durationTime
  if isGVG then
    durationTime = GameConfig.GVGConfig.last_time
  elseif isGVGDroiyan then
    durationTime = GameConfig.GvgDroiyan.LastTime
  else
    durationTime = _defaultTime
  end
  if self.frameCheckTime and durationTime > UnityRealtimeSinceStartup - self.frameCheckTime then
    return true
  end
  return false
end
function GvgProxy:SetFPSOptimizeFlag()
  self.frameCheckTime = UnityRealtimeSinceStartup
end
function GvgProxy:IsFPSOptimizeSet()
  return nil ~= self.frameCheckTime
end
function GvgProxy:ClearFPSCheckTime()
  self.frameCheckTime = nil
end
function GvgProxy:FpsReEnterMap()
  if self:IsFPSOptimizeValid() and Game.GameHealthProtector then
    Game.GameHealthProtector:OptimizeGVGSettingOption()
  end
end
function GvgProxy:SetStatueInfo(data)
  if data.serverid ~= MyselfProxy.Instance:GetServerId() then
    return
  end
  self:SetStatueAppearance(data.appearance)
  self:SetStatuePose(data.pose)
  self:SetPrefire(data.prefire)
  self.statueInfo.season = data.season
end
function GvgProxy:SetStatueAppearance(info)
  local statueInfo = self.statueInfo
  if statueInfo == nil then
    statueInfo = {}
    self.statueInfo = statueInfo
  end
  local dirty
  for k, v in pairs(info) do
    if statueInfo[k] ~= info[k] then
      dirty = true
      statueInfo[k] = v
    end
  end
  local config = Table_Body[statueInfo.body]
  if config == nil then
    statueInfo.body = nil
  end
  if dirty then
    local npcs = NSceneNpcProxy.Instance:FindNpcs(GameConfig.GVGConfig.StatueNpcID)
    if npcs ~= nil and #npcs > 0 then
      npcs[1]:ReDress()
    end
  end
end
function GvgProxy:SetStatuePose(pose)
  local curPose = self.statueInfo.pose
  if pose == curPose then
    return
  end
  self.statueInfo.pose = pose
  self:UpdateStatuePose(pose)
end
function GvgProxy:UpdateStatuePose(pose, npc)
  if pose == nil then
    local info = self.statueInfo
    if info == nil then
      return
    end
    pose = info.pose
  end
  if npc == nil then
    local npcs = NSceneNpcProxy.Instance:FindNpcs(GameConfig.GVGConfig.StatueNpcID)
    if npcs == nil or #npcs == 0 then
      return
    end
    npc = npcs[1]
  end
  local config = Table_ActionAnime[pose]
  if config then
    npc:Server_PlayActionCmd(config.Name, nil, true)
  end
end
function GvgProxy:SetPrefire(prefire)
  local curPrefire = self.statueInfo.prefire
  if prefire == curPrefire then
    return
  end
  self.statueInfo.prefire = prefire
  local npcs = NSceneNpcProxy.Instance:FindNpcs(GameConfig.GVGConfig.StatuePedestalNpcID)
  if npcs == nil or #npcs == 0 then
    return
  end
  local pose = prefire and 200 or 0
  local config = Table_ActionAnime[pose]
  if config then
    npcs[1]:Server_PlayActionCmd(config.Name, nil, true)
  end
end
function GvgProxy:GetStatueInfo()
  return self.statueInfo
end
function GvgProxy:CanOptStatue()
  local statueInfo = self.statueInfo
  if statueInfo == nil then
    return false
  end
  if statueInfo.leaderid ~= Game.Myself.data.id then
    return false
  end
  return true
end
function GvgProxy:RecvGvgTaskUpdateGuildCmd(data)
  self.groupTaskID = data.task.taskid
  self.groupTaskProgress = data.task.progress
end
function GvgProxy:GetGroupTaskID()
  return self.groupTaskID
end
function GvgProxy:GetGroupTaskProgress()
  return self.groupTaskProgress
end
function GvgProxy:SetSandTableInfos(data)
  self.GvgSandTableInfo.group = data.gvg_group
  self.GvgSandTableInfo.starttime = data.starttime
  self.GvgSandTableInfo.endtime = data.endtime
  self.GvgSandTableInfo.noMoreMetal = data.nomore_smallmetal
  local tableInfos = data.info or {}
  local sandTableInfo = self.GvgSandTableInfo.sandTableInfo or {}
  for i = 1, #tableInfos do
    local singleTableInfo = GvgSandTableData.new(tableInfos[i])
    sandTableInfo[tableInfos[i].city] = singleTableInfo
  end
  self.GvgSandTableInfo.sandTableInfo = sandTableInfo
end
function GvgProxy:GetSandTableInfoByID(id)
  local sandTableInfo = self.GvgSandTableInfo.sandTableInfo
  if sandTableInfo[id] then
    return sandTableInfo[id]
  end
end
function GvgProxy:GetSandTableTimes()
  return self.GvgSandTableInfo.starttime, self.GvgSandTableInfo.endtime
end
function GvgProxy:noMoreMetal()
  return self.GvgSandTableInfo.noMoreMetal
end
function GvgProxy:updateCookingInfo(data)
  GVGCookingHelper.Me():updateCookingInfo(data)
end
function GvgProxy:RecvSetReliveMethodUserEvent(data)
  self.reviveMethod = data.relive_method
end
function GvgProxy:GetReviveMethod()
  return self.reviveMethod
end
function GvgProxy:SetReviveMethod(method)
  self.reviveMethod = method
end
