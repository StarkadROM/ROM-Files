ACTIVITYTYPE = {EACTIVITYTYPE_BCAT = 1, EACTIVITYTYPE_CRAZYGHOST = 2}
Custom_ActivityConfig = {
  [ACTIVITYTYPE.EACTIVITYTYPE_BCAT] = {
    TraceInfo = {
      traceTitle = ZhString.ActivityData_BCAT_TraceTitle,
      icon = "bigcat_icon_06",
      stateStyle = {
        [ActivityCmd_pb.EACTPROGRESS_1] = {
          thumbBg = nil,
          thumb = "bigcat_icon_01",
          traceInfo = ZhString.ActivityData_BCAT_EACTPROGRESS_1
        },
        [ActivityCmd_pb.EACTPROGRESS_2] = {
          thumbBg = "bigcat_icon_03",
          thumb = "bigcat_icon_02",
          traceInfo = ZhString.ActivityData_BCAT_EACTPROGRESS_2
        },
        [ActivityCmd_pb.EACTPROGRESS_3] = {
          thumbBg = "bigcat_icon_03",
          thumb = nil,
          traceInfo = ZhString.ActivityData_BCAT_EACTPROGRESS_3
        },
        [ActivityCmd_pb.EACTPROGRESS_SUCCESS] = {
          thumbBg = "bigcat_icon_03",
          thumb = "bigcat_icon_04",
          traceInfo = ZhString.ActivityData_BCAT_EACTPROGRESS_SUCCESS,
          process = 1
        },
        [ActivityCmd_pb.EACTPROGRESS_FAIL] = {
          thumbBg = "bigcat_icon_03",
          thumb = "bigcat_icon_05",
          traceInfo = ZhString.ActivityData_BCAT_EACTPROGRESS_FAIL,
          process = 1
        }
      }
    },
    MapSymbol = {
      SpriteName = "bigcat_icon_06",
      Size = {42, 40}
    },
    MapInfo = {
      icon = "bigcat_icon_06",
      label = ZhString.ActivityData_BCAT_MapInfo,
      iconScale = 0.8
    },
    EndStay = 600
  },
  [ACTIVITYTYPE.EACTIVITYTYPE_CRAZYGHOST] = {
    TraceInfo = {
      traceTitle = ZhString.ActivityData_CRAZYGHOST_TraceTitle,
      icon = "bigcat_icon_08",
      stateStyle = {
        [ActivityCmd_pb.EACTPROGRESS_1] = {
          thumbBg = nil,
          thumb = "bigcat_icon_01",
          traceInfo = ZhString.ActivityData_CRAZYGHOST_EACTPROGRESS_1
        },
        [ActivityCmd_pb.EACTPROGRESS_2] = {
          thumbBg = "bigcat_icon_07",
          thumb = nil,
          traceInfo = ZhString.ActivityData_CRAZYGHOST_EACTPROGRESS_2
        },
        [ActivityCmd_pb.EACTPROGRESS_SUCCESS] = {
          thumbBg = "bigcat_icon_07",
          thumb = "bigcat_icon_04",
          traceInfo = ActivityData_CRAZYGHOST_EACTPROGRESS_SUCCESS,
          process = 1
        },
        [ActivityCmd_pb.EACTPROGRESS_FAIL] = {
          thumbBg = "bigcat_icon_07",
          thumb = "bigcat_icon_05",
          traceInfo = ZhString.ActivityData_CRAZYGHOST_EACTPROGRESS_FAIL,
          process = 1
        }
      }
    },
    MapSymbol = {
      SpriteName = "bigcat_icon_08",
      Size = {37, 40}
    },
    MapInfo = {
      icon = "bigcat_icon_08",
      text = ZhString.ActivityData_CRAZYGHOST_MapInfo,
      iconScale = 0.7
    },
    EndStay = 600
  }
}
local _sCurServerTime
local _GetNowServerTime = function()
  if _sCurServerTime == nil then
    _sCurServerTime = ServerTime.CurServerTime
  end
  return _sCurServerTime() / 1000
end
ActivityData = class("ActivityData")
function ActivityData.CreateIdByType(type)
  if type then
    return "Activity_" .. tostring(type)
  end
end
function ActivityData.GetTraceQuestDataType(type)
  if Custom_ActivityConfig[type] then
    return QuestDataType.QuestDataType_INVADE
  end
  return QuestDataType.QuestDataType_ACTIVITY_TRACEINFO
end
function ActivityData:ctor(type, mapid, whole_starttime, whole_endtime)
  if type == nil then
    return
  end
  self.type = type
  self.id = ActivityData.CreateIdByType(type)
  self:SetState(0)
  self:UpdateInfo(mapid, whole_starttime, whole_endtime)
  self.customConfig = Custom_ActivityConfig[type]
  if self.customConfig then
    self.traceInfo_update = true
    self.endStaySec = self.customConfig.EndStay ~= nil and self.customConfig.EndStay or 0
  else
    self.endStaySec = 0
  end
  self.showConfig = Table_OperationActivity[self.type]
  self.traceData = {}
  self.state_timemap = {}
end
function ActivityData:UpdateInfo(mapid, whole_starttime, whole_endtime)
  if mapid ~= nil then
    self.mapid = mapid
  end
  self.whole_starttime = whole_starttime
  self.whole_endtime = whole_endtime
end
function ActivityData:SetState(state, state_starttime, state_endtime)
  self.state = state
  local traceConfigId = self.type * 10000 + state
  self.configData = Table_ActivityStepShow[traceConfigId]
  if state_starttime and state_endtime and state_starttime ~= 0 and state_endtime ~= 0 then
    local state_timecache = self.state_timemap[state]
    if state_timecache == nil then
      state_timecache = {}
      self.state_timemap[state] = state_timecache
    end
    state_timecache[1] = state_starttime
    state_timecache[2] = state_endtime
  end
end
function ActivityData:GetDuringTime()
  if not self.state or not self.state_timemap[self.state] then
    local state_timecache
  end
  local starttime, endtime
  if state_timecache then
    starttime = state_timecache[1]
    endtime = state_timecache[2]
  elseif self.whole_endtime and self.whole_starttime then
    starttime = self.whole_starttime
    endtime = self.whole_endtime
  end
  return starttime, endtime
end
function ActivityData:InRunningTime(ignoreEndStay)
  local st, et = self:GetDuringTime()
  if st == et and st ~= nil then
    return true
  end
  local nt = _GetNowServerTime()
  if st ~= nil and st > nt then
    return false
  end
  if et ~= nil then
    if ignoreEndStay then
      if et < nt then
        return false
      end
    elseif nt > et + self.endStaySec then
      return false
    end
  end
  return true
end
function ActivityData:IsShowInMenu()
  if self.showConfig then
    return self.showConfig.Type == 1
  end
  return false
end
function ActivityData:IsTraceInfo_NeedUpdate()
  return self.traceInfo_update == true
end
function ActivityData:GetProgress()
  local starttime, endtime = self:GetDuringTime()
  local curServerTime = ServerTime.CurServerTime() / 1000
  if endtime == nil then
    return
  end
  if endtime < curServerTime then
    return 1
  end
  local timepct = (curServerTime - starttime) / (endtime - starttime)
  local pctage = self.configData and self.configData.Percentage
  if pctage == nil or pctage == _EmptyTable then
    return timepct
  end
  timepct = timepct * 100
  local realPct
  for i = 1, #pctage do
    local curPctage = pctage[i]
    if timepct <= curPctage[2] then
      local prePctage = pctage[i - 1]
      if prePctage == nil then
        prePctage = {0, 0}
      end
      local leftPct = timepct - prePctage[2]
      local pct = 0
      if curPctage[2] ~= prePctage[2] then
        pct = (curPctage[1] - prePctage[1]) / (curPctage[2] - prePctage[2])
      end
      leftPct = leftPct * pct
      if realPct == nil then
        realPct = leftPct
        break
      end
      realPct = realPct + leftPct
      break
    else
      realPct = curPctage[1]
    end
  end
  return math.floor(realPct) / 100
end
function ActivityData:IsNeedTrace(nowMapId)
  if self.customConfig == nil and self.configData == nil then
    return false
  end
  if self:GetConfigTraceInfo() ~= nil then
    return true
  end
  if self.customConfig then
    if self.mapid == 0 or self.mapid == nil then
      return true
    end
    return self.mapid == nowMapId
  end
  return false
end
function ActivityData:GetTraceInfo(nowMapId)
  if not self:IsNeedTrace(nowMapId) then
    return nil
  end
  local traceInfo = self:GetConfigTraceInfo(nowMapId)
  if traceInfo ~= nil then
    return traceInfo
  end
  return self:GetCustomTraceInfo(nowMapId)
end
function ActivityData:GetCustomTraceInfo(nowMapId)
  local traceInfo = self.customConfig and self.customConfig.TraceInfo
  if not traceInfo then
    return nil
  end
  local traceData = self.traceData
  TableUtility.TableClear(traceData)
  traceData.type = ActivityData.GetTraceQuestDataType(self.type)
  traceData.questDataStepType = QuestDataStepType.QuestDataStepType_INVADE
  traceData.id = ActivityData.CreateIdByType(self.type)
  traceData.traceTitle = traceInfo.traceTitle
  traceData.icon = traceInfo.icon
  local starttime1 = os.clock()
  local state = self.state or 1
  local stateConfig = traceInfo.stateStyle and traceInfo.stateStyle[state]
  if stateConfig then
    traceData.traceInfo = stateConfig.traceInfo
    traceData.thumbBg = stateConfig.thumbBg
    traceData.thumb = stateConfig.thumb
    traceData.process = stateConfig.process or self:GetProgress()
    starttime2 = os.clock()
  else
    errorLog(string.format("State:%s not config", state))
  end
  return traceData
end
function ActivityData:GetConfigTraceInfo(nowMapId)
  local configData = self.configData
  if configData == nil then
    return
  end
  if configData.Trace_Text == nil or configData.Trace_Text == "" then
    return
  end
  if nowMapId and configData.UnShowMaps ~= _EmptyTable and TableUtility.ArrayFindIndex(configData.UnShowMaps, nowMapId) ~= 0 then
    return
  end
  if configData.LimitLevel then
    local rolelv = MyselfProxy.Instance:RoleLevel()
    if rolelv < configData.LimitLevel then
      return
    end
  end
  local traceData = self.traceData
  TableUtility.TableClear(traceData)
  traceData.type = ActivityData.GetTraceQuestDataType(self.type)
  traceData.questDataStepType = QuestDataStepType.QuestDataStepType_WAIT
  traceData.id = ActivityData.CreateIdByType(self.type)
  traceData.traceTitle = configData.Trace_Title
  traceData.icon = configData.Trace_Icon
  traceData.titleBg = true
  local trace_Text = configData.Trace_Text
  if string.find(trace_Text, "%[HappyValue%]") then
    traceData.traceInfo = string.gsub(trace_Text or "", "%[HappyValue%]", ActivityData.GetHappyValue())
    self.traceInfo_update = true
  else
    traceData.traceInfo = trace_Text
  end
  if configData.TraceId then
    self.traceId = configData.TraceId
    local shortCutData = Table_ShortcutPower[configData.TraceId]
    if shortCutData then
      local mapid = shortCutData.Event.mapid
      if configData.HideMapName ~= 1 then
        local mapName = Table_Map[mapid] and Table_Map[mapid].CallZh or ""
        if mapName then
          traceData.traceInfo = traceData.traceInfo .. "\n" .. ZhString.ActivityData_PositionTip .. mapName
        end
      end
      traceData.map = mapid
      traceData.questDataStepType = QuestDataStepType.QuestDataStepType_MOVE
      local pos = shortCutData.Event.pos
      if shortCutData.Event.npcid then
        traceData.questDataStepType = QuestDataStepType.QuestDataStepType_VISIT
        traceData.params = {}
        traceData.params.npc = shortCutData.Event.npcid
        traceData.params.uniqueid = shortCutData.Event.uniqueid
      elseif pos then
        local tempV3 = LuaVector3()
        LuaVector3.Better_Set(tempV3, pos[1], pos[2], pos[3])
        traceData.pos = tempV3
      end
    end
  end
  local cfg_progress = configData.Trace_Progress
  if cfg_progress ~= _EmptyTable and cfg_progress.show == 1 then
    traceData.process = self:GetProgress()
    traceData.thumb = cfg_progress.thumb
    traceData.thumbBg = cfg_progress.thumbBg
    traceData.foreBg = cfg_progress.foreBg
    traceData.progressBg = cfg_progress.progressBg
    self.traceInfo_update = true
  end
  return traceData
end
function ActivityData.GetHappyValue()
  return Game.Myself.data.userdata:Get(UDEnum.JOY) or ""
end
function ActivityData:GetMapSymbol()
  if self.customConfig then
    return self.customConfig.MapSymbol
  end
  if self.configData then
    return self.configData.MapInfo
  end
  return nil
end
function ActivityData:GetMapInfo()
  if self.customConfig then
    return self.customConfig.MapInfo
  end
  if self.configData then
    return self.configData.MapInfo
  end
  return nil
end
function ActivityData:GetEndStaySec()
  return self.endStaySec
end
function ActivityData:GetEndTime()
  return self.whole_endtime
end
function ActivityData:SetParams(params)
  if not self.params then
    self.params = {}
  end
  TableUtility.ArrayShallowCopy(self.params, params)
end
function ActivityData:GetParams()
  return self.params
end
function ActivityData:Destroy()
  self.traceData = nil
  self.mapInfo = nil
  if self.params then
    self.params = nil
  end
end
