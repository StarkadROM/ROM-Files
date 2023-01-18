FuncShortCutFunc = class("FuncShortCutFunc")
FuncShortCutFunc.FuncType = {
  MoveToNpc = 1,
  MoveToPos = 2,
  JumpPanel = 3,
  OpenUrl = 4,
  NpcFunc = 5,
  OpenWebView = 6,
  RaidJump = 7,
  Quest_AccDailyWorld = 8,
  PveGuide = 9,
  ClientGuide = 10
}
function FuncShortCutFunc.Me()
  if nil == FuncShortCutFunc.me then
    FuncShortCutFunc.me = FuncShortCutFunc.new()
  end
  return FuncShortCutFunc.me
end
function FuncShortCutFunc:ctor()
  self.FuncMap = {}
  self.FuncMap[FuncShortCutFunc.FuncType.MoveToNpc] = self.MoveToNpc
  self.FuncMap[FuncShortCutFunc.FuncType.MoveToPos] = self.MoveToPos
  self.FuncMap[FuncShortCutFunc.FuncType.JumpPanel] = self.JumpPanel
  self.FuncMap[FuncShortCutFunc.FuncType.OpenUrl] = self.OpenUrl
  self.FuncMap[FuncShortCutFunc.FuncType.NpcFunc] = self.NpcFunc
  self.FuncMap[FuncShortCutFunc.FuncType.OpenWebView] = self.OpenWebView
  self.FuncMap[FuncShortCutFunc.FuncType.RaidJump] = self.RaidJump
  self.FuncMap[FuncShortCutFunc.FuncType.Quest_AccDailyWorld] = self.Quest_AccDailyWorld
  self.FuncMap[FuncShortCutFunc.FuncType.PveGuide] = self.PveGuide
  self.FuncMap[FuncShortCutFunc.FuncType.ClientGuide] = self.ClientGuide
  EventManager.Me():AddEventListener(LoadSceneEvent.FinishLoadScene, self.OnSceneLoadFinished, self)
end
function FuncShortCutFunc:CallByQuestFinishID(params, gotomode, singleQuestData, isShowGO, growthId)
  local inRaid = Game.MapManager:IsRaidMode()
  if params and #params > 1 then
    for i = 2, #params do
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.ShortCutOptionPopUp,
        viewdata = {
          data = params,
          gotomode = gotomode,
          functiontype = 2,
          showTraceInfo = true,
          growthid = growthId
        }
      })
      return
    end
  elseif params and #params == 1 then
    local staticData = Table_ServantQuestfinishStep[params[1]]
    for i = 1, #staticData.QuestStep do
      local questStep = staticData.QuestStep[i]
      local questData = QuestProxy.Instance:GetQuestDataBySameQuestID(questStep)
      if questData then
        local data = {}
        data.questData = questData
        data.type = questData.questListType
        helplog("questData.type", questData.questListType)
        EventManager.Me():DispatchEvent(ServantImproveEvent.BeforeGoClick, data)
        if not inRaid then
          FunctionQuest.Me():executeManualQuest(questData)
        end
        return
      end
    end
  elseif singleQuestData then
    local data = {}
    data.questData = singleQuestData
    data.type = singleQuestData.questListType
    EventManager.Me():DispatchEvent(ServantImproveEvent.BeforeGoClick, data)
    if not inRaid then
      FunctionQuest.Me():executeManualQuest(singleQuestData)
    end
    return
  end
  helplog("执行ShortCutPower")
  if isShowGO == nil then
    isShowGO = true
  end
  if isShowGO and gotomode then
    local data = {}
    data.gotomode = gotomode
    data.growthId = growthId
    EventManager.Me():DispatchEvent(ServantImproveEvent.GotomodeTrace, data)
  end
  self:CallByID(gotomode, nil, isShowGO)
end
function FuncShortCutFunc:CallByID(id, param, isShowGO, growthId, bundleQuest, cellCtl)
  if type(id) == "number" then
    local config = Table_ShortcutPower[id]
    if config then
      local checkmenu, failid = config.Event.checkmenu, config.Event.failid
      if checkmenu and failid and not FunctionUnLockFunc.Me():CheckCanOpen(checkmenu) then
        self:CallByID(failid, param)
        return
      end
      local func = self.FuncMap[config.Type]
      if func then
        if isShowGO then
          local data = {}
          data.gotomode = id
          data.growthId = growthId
          data.questId = bundleQuest
          EventManager.Me():DispatchEvent(ServantImproveEvent.GotomodeTrace, data)
        end
        local lastCellCtl = config.cellCtl
        config.cellCtl = cellCtl
        func(self, config, param)
        config.cellCtl = lastCellCtl
      else
        errorLog(string.format("FuncShortCutFunc 未支持Table_ShortcutPower Type为%s的处理", config.Type))
      end
    else
      errorLog(string.format("Table_ShortcutPower 未找到id为%s的配置", id))
    end
  elseif type(id) == "table" and #id == 1 then
    self:CallByID(id[1], param)
  else
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.ShortCutOptionPopUp,
      viewdata = {data = id}
    })
  end
end
function FuncShortCutFunc:CallByTable(t, data)
  if t == nil or data == nil then
    return
  end
  local func = self.FuncMap[t]
  if func then
    func(self, data)
  end
end
function FuncShortCutFunc:MoveToNpc(data, param)
  local npcid, mapid, uniqueid = data.Event.npcid, data.Event.mapid, data.Event.uniqueid
  local buildingCooperateData = Table_BuildingCooperate[npcid]
  if buildingCooperateData then
    mapid = buildingCooperateData.MapId
    uniqueid = 0
  end
  local cmdArgs = {
    targetMapID = mapid,
    npcID = npcid,
    npcUID = uniqueid
  }
  local cmd = MissionCommandFactory.CreateCommand(cmdArgs, MissionCommandVisitNpc)
  if cmd then
    Game.Myself:Client_SetMissionCommand(cmd)
  end
  GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.NormalLayer)
  TipsView.Me():HideCurrent()
end
function FuncShortCutFunc:MoveToPos(data, param)
  local cmdArgs = {
    targetMapID = data.Event.mapid,
    targetPos = data.Event.pos
  }
  if cmdArgs.targetPos ~= nil then
    cmdArgs.targetPos = LuaGeometry.GetTempVector3(cmdArgs.targetPos[1], cmdArgs.targetPos[2], cmdArgs.targetPos[3])
  end
  local cmd = MissionCommandFactory.CreateCommand(cmdArgs, MissionCommandMove)
  Game.Myself:Client_SetMissionCommand(cmd)
  GameFacade.Instance:sendNotification(ShortCut.MoveToPos, cmdArgs.targetMapID)
end
local RealNameCheckPanel_Map = {
  [500] = 1,
  [501] = 1,
  [502] = 1,
  [503] = 1,
  [504] = 1,
  [505] = 1,
  [506] = 1,
  [507] = 1,
  [508] = 1,
  [509] = 1,
  [510] = 1
}
local NewRechargePanel_Map = {
  [725] = 1,
  [726] = 1,
  [727] = 1
}
local Panel_PVE = {
  [4110] = 1
}
function FuncShortCutFunc:JumpPanel(data, param)
  local panelid = data.Event.panelid
  if panelid then
    local forbiddenAct = GameConfig.Activity.PvpzoneForbidden or {}
    local inPvp = Game.MapManager:IsPveMode_Arena() or MyselfProxy.Instance:IsInPvpZone()
    if inPvp and 0 ~= TableUtility.ArrayFindIndex(forbiddenAct, panelid) then
      MsgManager.ShowMsgByIDTable(41420)
      return
    end
    if Game.MapManager:IsPVPMode_TeamPws() then
      local panelData = PanelProxy.Instance:GetData(panelid)
      if panelData == PanelConfig.FoodMakeView then
        MsgManager.ShowMsgByIDTable(25524)
        return
      end
    end
    if Game.MapManager:IsPveMode_Arena() and (panelid == PanelConfig.ShopMallMainView.id or panelid == PanelConfig.BoothMainView.id) then
      MsgManager.ShowMsgByID(37010)
      return
    end
    if RealNameCheckPanel_Map[panelid] then
      FunctionSecurity.Me():TryDoRealNameCentify(function(go)
        GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = panelid, viewdata = param})
      end, callbackParam)
    elseif NewRechargePanel_Map[panelid] then
      FunctionNewRecharge.Instance():OpenUI(panelid)
    elseif Panel_PVE[panelid] then
      param = param or data.Event.param
      if not param then
        PveEntranceProxy.Instance:PreprocessTable()
        local myLv = MyselfProxy.Instance:RoleLevel()
        local minUnlockLv = PveEntranceProxy.Instance:GetMinUnlockLv()
        if myLv < minUnlockLv then
          MsgManager.ShowMsgByID(8107)
          return
        end
        GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = panelid})
      elseif param.groupid then
        PveEntranceProxy.Instance:OpenMultiTargetPveByGroupID(param.groupid)
      end
    else
      local cellCtl = data.cellCtl
      if cellCtl then
        GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
          view = panelid,
          viewdata = {
            offset = data.Event.offset,
            side = data.Event.side,
            cellCtl = cellCtl
          }
        })
      elseif data.Event.viewdata then
        GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
          view = panelid,
          viewdata = data.Event.viewdata
        })
      else
        GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = panelid, viewdata = param})
      end
    end
  end
  TipsView.Me():HideCurrent()
end
function FuncShortCutFunc:OpenUrl(data, param)
  Application.OpenURL(data.Event.url)
end
function FuncShortCutFunc:NpcFunc(data, param)
  local npcFunctionData = Table_NpcFunction[data.Event.npcfuncid]
  if npcFunctionData ~= nil then
    FunctionNpcFunc.Me():DoNpcFunc(npcFunctionData, Game.Myself, data.Event.param)
  end
end
function FuncShortCutFunc:OpenWebView(data)
  ApplicationInfo.OpenUrl(data.Event.url)
end
function FuncShortCutFunc:RaidJump(data, param)
  local mapid = data.Event.mapid
  local curMapId = Game.MapManager:GetMapID()
  if curMapId ~= mapid then
    if mapid == 1003523 then
      ServiceSceneManorProxy.Instance:CallReqEnterRaidManorCmd()
    elseif mapid == 10001 then
      if not GuildProxy.Instance:IHaveGuild() then
        GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.GuildInfoView
        })
      else
        ServiceGuildCmdProxy.Instance:CallEnterTerritoryGuildCmd()
      end
    else
      ServiceNUserProxy.Instance:ReturnToHomeCity()
    end
    self.RaidJumpData = data
    self.RaidJumpParam = param
  elseif data.Event.npcid then
    self:MoveToNpc(data, param)
  else
    self:MoveToPos(data, param)
  end
end
function FuncShortCutFunc:OnSceneLoadFinished(sceneInfo)
  if self.RaidJumpData then
    local data = self.RaidJumpData
    local param = self.RaidJumpParam
    if data.Event.npcid then
      self:MoveToNpc(data, param)
    else
      self:MoveToPos(data, param)
    end
    self.RaidJumpData = nil
    self.RaidJumpParam = nil
  end
end
local _Table_WorldQuest = Table_WorldQuest
function FuncShortCutFunc:DoQuest_AccDailyWorld(version)
  local questList = QuestProxy.Instance:getValidAcceptQuestList(true, false)
  for i = 1, #questList do
    local single = questList[i]
    if single.type == "acc_daily_world" and _Table_WorldQuest[single.id] and _Table_WorldQuest[single.id].Version == version then
      FunctionQuest.Me():executeQuest(single)
      return true
    end
  end
  MsgManager.ShowMsgByIDTable(43186)
  return false
end
function FuncShortCutFunc:DoQuest_AccDailyWorlds(versions)
  local questList = QuestProxy.Instance:getValidAcceptQuestList(true, false)
  for i = 1, #questList do
    local single = questList[i]
    if single.type == "acc_daily_world" and _Table_WorldQuest[single.id] and _Table_WorldQuest[single.id].Version == versions then
      FunctionQuest.Me():executeQuest(single)
      return true
    end
  end
  MsgManager.ShowMsgByIDTable(43186)
  return false
end
function FuncShortCutFunc:Quest_AccDailyWorld(config, param)
  if config and config.Event then
    self:DoQuest_AccDailyWorld(config.Event.version)
  else
    self:DoQuest_AccDailyWorld(1)
  end
end
function FuncShortCutFunc:PveGuide(config, param)
  if config and config.catalog then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.PveView,
      viewdata = {
        catalog = config.Event.catalog
      }
    })
    return
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.PveView
  })
end
function FuncShortCutFunc:ClientGuide(config, param)
  if config and config.Event.guide then
    FunctionClientGuide.Me():StartGuide(config.Event.guide)
  end
end
