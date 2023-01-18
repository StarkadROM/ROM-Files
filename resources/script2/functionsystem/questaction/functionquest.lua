FunctionQuest = class("FunctionQuest", EventDispatcher)
autoImport("GuideMaskView")
autoImport("VideoPanel")
FunctionQuest.UpdateTraceInfo = "MAINVIEWTASKQUESTPAGE_UPDATETRACEINFO"
FunctionQuest.RemoveTraceInfo = "MAINVIEWTASKQUESTPAGE_REMOVETRACEINFO"
FunctionQuest.AddTraceInfo = "MAINVIEWTASKQUESTPAGE_ADDTRACEINFO"
FunctionQuest.DefaultTriggerInfinite = 99999
FunctionQuest.DefaultEffectTriggerInfinite = 20
local cmdArgs = {}
local tempPos = LuaVector3()
function FunctionQuest.Me()
  if nil == FunctionQuest.me then
    FunctionQuest.me = FunctionQuest.new()
  end
  return FunctionQuest.me
end
function FunctionQuest:ctor()
  self.triggerCheck = Game.AreaTrigger_Mission
  self.iconAtlas = {
    "itemIcon",
    "skillIcon",
    "uiIcon",
    "npcIcon",
    "interactiveIcon"
  }
end
function FunctionQuest:handleCameraQuestStart(pos)
  local temp = GameObject("Temp")
  temp.transform.position = pos
  self.go = temp
  if not FunctionCameraEffect.Me():Bussy() then
    self.cft = CameraEffectFocusTo.new(temp.transform, CameraConfig.NPC_Dialog_ViewPort, 0.6, function()
      TimeTickManager.Me():CreateOnceDelayTick(1000, function(owner, deltaTime)
        self:handleCameraquestEnd()
      end, self)
    end)
    FunctionCameraEffect.Me():Start(self.cft)
  end
end
function FunctionQuest:handleCameraquestEnd(msg)
  FunctionCameraEffect.Me():End(self.cft)
  self.cft = nil
  GameObject.Destroy(self.go)
  self.go = nil
end
function FunctionQuest:test()
  local datas = {}
  datas.items = {}
  local data = {}
  data = {}
  data.id = 40301
  data.count = 2
  table.insert(datas.items, data)
  ServiceItemProxy.Instance:RecvItemShow(datas)
end
local questStepOnFunc = function(callbackData)
  helplog("quest StepOn", questId)
  if callbackData.endfunc and callbackData.endfunc == 1 then
    Game.PlotStoryManager:AddUIView(Game.PlotStoryManager.PlotStoryUIId)
  end
  QuestProxy.Instance:notifyQuestState(callbackData.scope, callbackData.id)
end
local _clientStepTypeFunc = {
  brickShadow = function(questData)
    local imageRaidId = ServicePlayerProxy.Instance:GetCurMapImageId()
    FunctionShadowBricks.Me():Launch(imageRaidId, questData)
  end,
  brickShadowFinished = function(questData)
    local finishCall = function()
      QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
    end
    FunctionShadowBricks.Me():SetQuestFinishCallback(finishCall)
  end
}
function FunctionQuest:executeQuest(questData, clientClick)
  if questData then
    redlog("executeQuest content:", questData.id, questData.questDataStepType)
  end
  local isInHand, master = Game.Myself:IsHandInHand()
  if isInHand and not master then
    MsgManager.ShowMsgByID(824)
    return
  end
  local isDead = Game.Myself:IsDead()
  if isDead and not QuestProxy.Instance:checkCanExcuteWhenDead(questData) then
    MsgManager.ShowMsgByID(2500)
    return
  end
  if questData.questDataStepType == QuestDataStepType.QuestDataStepType_LEVEL then
    return
  elseif questData.questDataStepType == QuestDataStepType.QuestDataStepType_WAIT then
    return
  elseif questData.questDataStepType == QuestDataStepType.QuestDataStepType_SELFIE_SYS then
    return
  elseif questData.questDataStepType == QuestDataStepType.QuestDataStepType_GUIDE then
    local guideType = questData.params.type
    if guideType == QuestDataGuideType.QuestDataGuideType_explain then
      FunctionGuide.Me():stopGuide()
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.GuidePanel,
        viewdata = {questData = questData}
      })
    else
      FunctionGuide.Me():showGuideByQuestData(questData, clientClick)
    end
    return
  elseif questData.questDataStepType == QuestDataStepType.QuestDataStepType_Client then
    local t = questData.params.type
    local func = t and _clientStepTypeFunc[t]
    if func then
      func(questData)
    end
    return
  elseif questData.questDataStepType == QuestDataStepType.QuestDataStepType_CLIENT_PLOT then
    local plotid = questData.params.id
    local endfunc = questData.params.endfunc
    if plotid then
      Game.PlotStoryManager:ForceStart(plotid, questStepOnFunc, {
        id = questData.id,
        scope = questData.scope,
        endfunc = endfunc
      })
    end
    return
  elseif questData.questDataStepType == QuestDataStepType.QuestDataStepType_PLAY_CG then
    local id = questData.params.id
    local video = Table_Video[id]
    if video then
      helplog("此处应该播一段视频:", video.Name)
      FunctionVideoStorage.Me():CheckoutAndPlayVideo(id, nil, function()
        self:CGquestCallback(questData)
      end)
    else
      helplog("未找到该视频任务配置Table_View,id=", id)
    end
    return
  elseif questData.questDataStepType == QuestDataStepType.QuestDataStepType_CAMERA_FILTER then
    if questData and questData.params and questData.params.filtername and questData.params.filtername.on == 1 then
      local cfData = Table_CameraFilters[questData.params.filtername]
      if cfData then
        CameraFilterProxy.Instance:CFSetEffectAndSpEffect(cfData.FilterName, cfData.SpecialEffectsName)
      end
    else
      CameraFilterProxy.Instance:CFQuit()
    end
    return
  elseif questData.questDataStepType == "killorder" then
    if questData.params and questData.params.hideui ~= 1 then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.QuestMiniGame3Panel,
        viewdata = questData
      })
    end
  elseif questData.questDataStepType == "choose_branch" then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.ChooseProfessionBranchPopup,
      viewdata = questData
    })
  elseif questData.questDataStepType == "game" then
    local gameType = questData.params and questData.params.gameType or 0
    if gameType == 1 then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.QuestMiniGame2Panel,
        viewdata = questData
      })
    elseif gameType == 2 then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.QuestMiniGame1Panel,
        viewdata = questData
      })
    end
  elseif questData.questDataStepType == QuestDataStepType.QuestDataStepType_PICTURE then
    if questData.params and questData.params and questData.params.id then
      local path = questData.params.id
      local time = questData.params and questData.params.time or 2
      helplog("Picture任务类型路径为" .. path .. "时间长度为" .. time)
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.IllustrationShowView,
        viewdata = {
          questData = questData,
          time = time,
          path = path
        }
      })
    else
      redlog("Picture任务类型：ID为" .. questData.id .. "的任务未配置路径")
    end
    return
  elseif questData.questDataStepType == QuestDataStepType.QuestDataStepType_TRANSIT then
    local time = questData.params and questData.params.time or 2
    helplog("transit任务类型路径为时间长度为" .. time)
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.ChapterEditableView,
      viewdata = {questData = questData}
    })
    return
  elseif questData.questDataStepType == QuestDataStepType.QuestDataStepType_PLAYER_MOVE then
    if questData.params and questData.params and questData.params.pos then
      local pos = questData.params.pos
      if not pos then
        redlog("player_move未配置pos点")
        return
      end
      LuaVector3.Better_Set(tempPos, pos[1] or 0, pos[2] or 0, pos[3] or 0)
      local cmd = MissionCommandFactory.CreateCommand({targetPos = tempPos}, MissionCommandMove)
      if cmd then
        Game.Myself:Client_SetMissionCommand(cmd)
        QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
      end
    else
      redlog("PlayerMove任务类型：ID为" .. questData.id .. "的任务未配置Pos点")
    end
    return
  elseif questData.questDataStepType == QuestDataStepType.QuestDataStepType_PLAYER_DIR then
    if questData.params and questData.params and questData.params.dir then
      local dir = questData.params.dir
      if dir ~= nil then
        Game.Myself:Client_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, dir / 1000, true)
      end
    else
      redlog("PlayerDir任务类型：ID为" .. questData.id .. "的任务未配置Dir")
    end
    QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
    return
  elseif questData.questDataStepType == QuestDataStepType.QuestDataStepType_SHOWVIEW then
    if questData.params and questData.params and questData.params.panelid then
      local panelId = questData.params.panelid
      local showType = questData.params.showtype
      helplog("ShowView任务类型,打开目标面板ID为" .. panelId .. "showtype为" .. showType)
      if showType == PlotViewShowType.Enter then
        Game.PlotStoryManager:AddUIView(panelId)
      else
        Game.PlotStoryManager:CloseUIView(panelId)
      end
    else
      redlog("ShowView任务类型：ID为" .. questData.id .. "的任务未配置面板ID")
    end
    QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
    return
  elseif questData.questDataStepType == QuestDataStepType.QuestDataStepType_ADDBUTTON then
    local eventType = questData.params.eventtype
    helplog("Addbutton任务类型,eventtype为" .. eventType)
    if eventType then
      helplog("button_" .. eventType)
      local func = self["button_" .. eventType]
      if func then
        local buttonData = {}
        buttonData.id = questData.params.id or 1
        buttonData.clickEvent = func
        buttonData.text = questData.params.text
        buttonData.pos = questData.params.pos
        buttonData.questData = questData
        buttonData.removeWhenClick = true
        Game.PlotStoryManager:AddButton(self.plotid, questData.params.id, buttonData)
      end
    else
      redlog("Addbutton任务类型：ID为" .. questData.id .. "的任务未配置eventType")
    end
    return
  elseif questData.questDataStepType == QuestDataStepType.QuestDataStepType_STARTFILTER then
    if questData.params and questData.params and questData.params.filter then
      FunctionSceneFilter.Me():StartFilter(questData.params.filter)
    else
      redlog("StartFilter任务类型：ID为" .. questData.id .. "的任务未配置FilterID")
    end
    QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
    return
  elseif questData.questDataStepType == QuestDataStepType.QuestDataStepType_ENDFILTER then
    if questData.params and questData.params and questData.params.filter then
      FunctionSceneFilter.Me():EndFilter(questData.params.filter)
    else
      redlog("EndFilter任务类型：ID为" .. questData.id .. "的任务未配置FilterID")
    end
    QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
    return
  elseif questData.questDataStepType == "cutscene" then
    if questData and questData.staticData then
      local scope, id, FinishJump = questData.scope, questData.id, questData.staticData.FinishJump
      local ids = {}
      TableUtility.TableShallowCopy(ids, questData.params.ids)
      if VideoPanel.CheckLimit() then
        for i = #ids, 1, -1 do
          if 0 < TableUtility.ArrayFindIndex(GameConfig.LimitCutscene, ids[i]) then
            table.remove(ids, i)
          end
        end
      end
      local CGquestCallback = function()
        self:CGquestCallback2(scope, id, FinishJump)
      end
      local showSkip = true
      if questData.params.noskip then
        local checkTeamCutScene = math.floor(questData.params.noskip / 1000)
        local ori_noskip = questData.params.noskip - checkTeamCutScene * 1000
        showSkip = ori_noskip ~= 1
        if checkTeamCutScene ~= 0 then
          local cond1 = TeamProxy.Instance:CheckIHaveLeaderAuthority()
          local cond2 = TeamProxy.Instance:IHaveTeam() and TeamProxy.Instance:IsSameMapWithNowLeader()
          if cond2 and not cond1 then
            showSkip = false
          end
        end
      end
      local skipDelay = questData.params.skipDelay
      Game.PlotStoryManager:Launch()
      local result = Game.PlotStoryManager:Start_SEQ_PQTLP(ids, CGquestCallback, nil, nil, showSkip, nil, nil, nil, nil, function()
        TimeTickManager.Me():CreateOnceDelayTick(2000, function(owner, deltaTime)
          if SceneProxy.Instance:IsNeedWaitCutScene() then
            SceneProxy.Instance:ClearNeedWaitCutScene()
            GameFacade.Instance:sendNotification(LoadSceneEvent.CloseLoadView)
          end
        end, self)
      end, nil, skipDelay)
    else
    end
  elseif questData.questDataStepType == "simulation" then
    local simuType = questData.params and questData.params.action
    if simuType == "team_invite" then
      NewbieCollegeProxy.Instance:InviteFakeTeam(questData)
      GameFacade.Instance:sendNotification(NewbieCollegeEvent.RaidNpcFakeTeamInvite, {
        questData = questData,
        configid = questData.id
      })
    elseif simuType == "team_enter" then
      NewbieCollegeProxy.Instance:EnterFakeTeam(questData)
    end
  elseif questData.questDataStepType == QuestDataStepType.QuestDataStepType_WAITQTE then
    EventManager.Me():PassEvent(ChasingScene.StartQTE, {
      questData = questData,
      configid = questData.params.id
    })
  elseif questData.questDataStepType == "puzzle" then
    RaidPuzzleManager.Me():StartCheckPuzzleActionQuest(questData)
  elseif questData.questDataStepType == "puzzle_refresh" then
    RaidPuzzleManager.Me():StartRefreshPuzzleActionQuest(questData)
  elseif questData.questDataStepType == "puzzle_light" then
    RaidPuzzleManager.Me():StartPuzzleLightQuest(questData)
  elseif questData.questDataStepType == QuestDataStepType.QuestDataStepType_ShakeScreen then
    if questData.params then
      do
        local wait = questData.params.wait_msec and questData.params.wait_msec / 1000 or 1
        local range = questData.params.amplitude and questData.params.amplitude / 100 or 10
        local duration = questData.params.msec and questData.params.msec / 1000 or 1
        local curve = questData.params.shaketype or 1
        TimeTickManager.Me():CreateOnceDelayTick(wait * 1000, function(owner, deltaTime)
          QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
          CameraAdditiveEffectManager.Me():StartShake(range, duration, curve)
        end, self, 2)
      end
    else
    end
    return
  elseif questData.questDataStepType == "puzzle_npc_sync_move" then
    RaidPuzzleManager.Me():StartPuzzleNpcMoveQuest(questData)
  elseif questData.questDataStepType == "check_light_puzzle" then
    LightPuzzleManager.Me():StartLightPuzzleQuest(questData)
  elseif questData.questDataStepType == QuestDataStepType.QuestDataStepType_WAITCLIENT then
    local params = questData.params
    local type = params.type or 3521
    local param = params.param
    if type == 3521 and not param then
      param = 1
    end
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = type,
      viewdata = {params = param, questData = questData}
    })
    return
  elseif questData.questDataStepType == QuestDataStepType.QuestDataStepType_PARTNERMOVE then
    RandomAIManager.Me():OnEventInterruptByQuest(questData)
  elseif questData.questDataStepType == QuestDataStepType.QuestDataStepType_SHOWEVIDENCE then
    xdlog("showevidence")
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.EvidenceShowPanel,
      viewdata = {questData = questData}
    })
    return
  elseif questData.questDataStepType == QuestDataStepType.QuestDataStepType_JOINT_REASON then
    xdlog("joint_reason")
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.JointInferencePanel,
      viewdata = {questData = questData}
    })
    return
  elseif questData.questDataStepType == QuestDataStepType.QuestDataStepType_TAPPING then
    TappingManager.Me():StartTappingQuest(questData)
  elseif questData.questDataStepType == "waitui" then
    local callbackList = {
      {
        param = questData.id,
        func = function(npc, param)
          QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
        end
      }
    }
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = questData.staticData.Params.id,
      viewdata = {
        callbackList = callbackList,
        questId = questData.id,
        params = questData.params
      }
    })
  elseif questData.questDataStepType == "mind_enter" then
    FunctionMindLocker.Me():OnMindEnter(questData)
  elseif questData.questDataStepType == "mind_exit" then
    FunctionMindLocker.Me():OnMindExit(questData)
  elseif questData.questDataStepType == "mind_unlock_perform" then
    FunctionMindLocker.Me():PlayUnlockEffect(questData)
  elseif questData.questDataStepType == "mind_scene_anim" then
    FunctionMindLocker.Me():PlaySceneAnim(questData)
  elseif questData.questDataStepType == "mind_play_action" then
    local params = questData.params
    if params then
      FunctionMindLocker.Me():PlayRoleAction(params.actionId, params.expressionId, params.speed, params.isOnceAction)
    end
    QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
  elseif questData.questDataStepType == "mind_play_effect" then
    FunctionMindLocker.Me():PlayRaidEffect(questData)
    local params = questData.params
    if not params or not params.buttonSize then
      QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
    end
  elseif questData.questDataStepType == "follow_npc" then
    local params = questData.params
    if params then
      local type = params.type
      local result
      if type == 1 then
        result = FollowNpcAIManager.Me():CreateNpc(params.npcids, true)
      elseif type == 2 then
        result = FollowNpcAIManager.Me():RemoveNpc(params.npcids)
      end
      if result then
        QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
      end
    end
  elseif questData.questDataStepType == "ai_event" then
    local params = questData.params
    if params then
      local type = params.type
      local npcIds = params.npcids
      local eventId = params.eventid
      if type == 1 then
        FollowNpcAIManager.Me():AddNpcEvent(npcIds, eventId)
      elseif type == 2 then
        FollowNpcAIManager.Me():RemoveNpcEvent(npcIds, eventId)
      elseif type == 3 then
        FollowNpcAIManager.Me():ExecuteNpcEvent(npcIds, eventId)
      end
      QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
    end
  elseif questData.questDataStepType == "client_raid_pass" then
    SgAIManager.Me():addQuest(questData)
    return
  elseif questData.questDataStepType == QuestDataStepType.QuestDataStepType_MUSICGAME then
    xdlog("MusicGame")
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.MusicGamePanel,
      viewdata = {questData = questData}
    })
    return
  elseif questData.questDataStepType == QuestDataStepType.QuestDataStepType_EXCHANGE then
    local panelid = questData.params.ui
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = panelid,
      viewdata = {questData = questData}
    })
    return
  else
    if self.cmdData and self.cmdData.id == questData.id and self.cmdData.step == questData.step then
      return
    end
    local sameNpcVisit = self:handleVisitQuest(questData)
    if sameNpcVisit then
      return
    end
    TableUtility.TableClear(cmdArgs)
    cmdArgs.targetMapID = questData.map
    cmdArgs.targetPos = questData.pos
    cmdArgs.distance = questData.params.distance
    if questData.type ~= QuestDataType.QuestDataType_ACTIVITY_TRACEINFO then
      cmdArgs.customType = AccessCustomType.Quest
      cmdArgs.custom = questData.id
    end
    function cmdArgs.callback(cmd, event)
      self:missionCallback(cmd, event)
    end
    local cmdClass
    local questStepType = questData.questDataStepType
    if QuestDataStepType.QuestDataStepType_VISIT == questStepType then
      if self:HandleVisitNpcInHome(questData) then
        return
      end
      cmdArgs.npcUID = questData.params.uniqueid
      if nil == cmdArgs.npcUID then
        if type(questData.params.npc) == "table" then
          cmdArgs.npcID = questData.params.npc[1]
        else
          cmdArgs.npcID = questData.params.npc
        end
        local wantedNpcMap = GameConfig.Quest.wantedNpcConfig and GameConfig.Quest.wantedNpcConfig[cmdArgs.npcID]
        if wantedNpcMap then
          cmdArgs.targetPos = LuaVector3.Zero()
          local curMapID = Game.MapManager:GetMapID()
          if 0 < TableUtility.ArrayFindIndex(wantedNpcMap, curMapID) then
            cmdArgs.targetMapID = curMapID
            cmdArgs.npcUID = Game.MapManager:GetUniqueIdByNpc(cmdArgs.npcID)
          else
            local costMinMap, changeCount
            for i = 1, #wantedNpcMap do
              local redID, retCost, changeMapCount = MapTeleportUtil.FindNearlyMap(wantedNpcMap[i], function(nSID)
                return TransferTeleport[nSID] and TransferTeleport[nSID][1] ~= nil
              end)
              if not changeCount or changeCount > changeMapCount then
                changeCount = changeMapCount
                costMinMap = wantedNpcMap[i]
              end
            end
            cmdArgs.targetMapID = costMinMap
            local mapData = Table_Map[costMinMap]
            if mapData then
              local sceneName = mapData.NameEn
              sceneName = "Scene_" .. sceneName
              local sceneInfo = autoImport(sceneName)
              local scenePartInfo = {}
              if sceneInfo and sceneInfo.PVE then
                scenePartInfo = sceneInfo.PVE
                if scenePartInfo and scenePartInfo.nps and 0 < #scenePartInfo.nps then
                  local nps = scenePartInfo.nps
                  for i = 1, #nps do
                    if nps[i].ID == cmdArgs.npcID then
                      cmdArgs.npcUID = nps[i].uniqueID
                      local npcPos = nps[i].position
                      LuaVector3.Better_Set(tempPos, npcPos[1], npcPos[2], npcPos[3])
                      cmdArgs.targetPos = tempPos
                    end
                  end
                end
              end
            end
          end
        end
      end
      cmdClass = MissionCommandVisitNpc
    elseif QuestDataStepType.QuestDataStepType_KILL == questStepType then
      cmdArgs.groupID = questData.params.groupId
      cmdArgs.npcID = questData.params.monster
      cmdArgs.npcUID = questData.params.uniqueid
      cmdClass = MissionCommandSkill
    elseif QuestDataStepType.QuestDataStepType_COLLECT == questStepType then
      cmdArgs.groupID = questData.params.groupId
      cmdArgs.npcID = questData.params.monster
      cmdArgs.skillID = GameConfig.NewRole.riskskill[1]
      cmdArgs.npcUID = questData.params.uniqueid
      cmdClass = MissionCommandSkill
    elseif QuestDataStepType.QuestDataStepType_USE == questStepType then
      cmdClass = MissionCommandMove
    elseif QuestDataStepType.QuestDataStepType_SELFIE == questStepType then
      cmdClass = MissionCommandMove
    elseif QuestDataStepType.QuestDataStepType_GATHER == questStepType then
      cmdArgs.npcID = questData.params.monster
      cmdArgs.groupID = questData.params.groupId
      cmdArgs.npcUID = questData.params.uniqueid
      cmdClass = MissionCommandSkill
    elseif QuestDataStepType.QuestDataStepType_MOVE == questStepType then
      cmdClass = MissionCommandMove
    elseif questData.questDataStepType == QuestDataStepType.QuestDataStepType_TALK then
      if cmdArgs.targetMapID == nil and cmdArgs.targetPos == nil then
        self:executeTalkQuest(questData)
      else
        if questData.pos then
          cmdClass = MissionCommandMove
        end
        self:handleAutoTrigger(questData)
      end
    elseif questData.questDataStepType == QuestDataStepType.QuestDataStepType_RAID then
      if cmdArgs.targetMapID == nil and cmdArgs.targetPos == nil then
        ServiceQuestProxy.Instance:CallQuestRaidCmd(questData.id)
      else
        cmdClass = MissionCommandMove
        self:handleAutoTrigger(questData)
      end
    elseif questData.questDataStepType == QuestDataStepType.QuestDataStepType_PLAY_CAMERAPLOT then
      if cmdArgs.targetMapID == nil and cmdArgs.targetPos == nil then
        if questData.map == nil then
          QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
          return
        end
      else
        cmdClass = MissionCommandMove
        self:handleAutoTrigger(questData)
      end
    elseif questData.questDataStepType == QuestDataStepType.QuestDataStepType_RANDOM_BUFF then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.BlackCatFishingView,
        viewdata = {questData = questData}
      })
    elseif questData.questDataStepType == QuestDataStepType.QuestDataStepType_DAILY then
      if cmdArgs.targetMapID == nil and cmdArgs.targetPos == nil then
        return
      else
        cmdClass = MissionCommandMove
      end
    elseif questData.questDataStepType == QuestDataStepType.QuestDataStepType_ITEM then
      if cmdArgs.targetMapID == nil and cmdArgs.targetPos == nil then
        return
      else
        local creatureId = questData.params.monster
        cmdArgs.npcID = creatureId
        cmdArgs.npcUID = questData.params.uniqueid
        if creatureId and Table_Monster[creatureId] then
          cmdArgs.groupID = questData.params.groupId
          cmdClass = MissionCommandSkill
        elseif creatureId and Table_Npc[creatureId] then
          cmdClass = MissionCommandVisitNpc
        end
      end
    elseif questData.questDataStepType == QuestDataStepType.QuestDataStepType_SEAL then
      if cmdArgs.targetMapID == nil and cmdArgs.targetPos == nil then
        return
      else
        cmdArgs.npcUID = questData.params.uniqueid
        if nil == cmdArgs.npcUID then
          if type(questData.params.npc) == "table" then
            cmdArgs.npcID = questData.params.npc[1]
          else
            cmdArgs.npcID = questData.params.npc
          end
        end
        cmdClass = MissionCommandVisitNpc
      end
    elseif questData.questDataStepType == QuestDataStepType.QuestDataStepType_GUIDELOCKMONSTER then
      self:handleAutoTrigger(questData)
      cmdClass = MissionCommandMove
    end
    if nil ~= cmdClass then
      Game.Myself:TryUseQuickRide()
      local cmd = MissionCommandFactory.CreateCommand(cmdArgs, cmdClass)
      Game.Myself:Client_SetMissionCommand(cmd)
    end
    TableUtility.TableClear(cmdArgs)
  end
end
function FunctionQuest:HandleVisitNpcInHome(questData)
  if not HomeManager.Me():IsAtHome() then
    return false
  end
  local npcID = questData.params.uniqueid
  local creatures
  if npcID then
    creatures = NSceneNpcProxy.Instance:FindNpcByUniqueId(npcID)
  end
  if nil == creatures or 0 == #creatures then
    if type(questData.params.npc) == "table" then
      npcID = questData.params.npc[1]
    else
      npcID = questData.params.npc
    end
  end
  creatures = NSceneNpcProxy.Instance:FindNpcs(npcID)
  if nil == creatures or 0 == #creatures then
    return false
  end
  Game.Myself:Client_AccessTarget(creatures[1])
  return true
end
function FunctionQuest:getCurCmdData()
  return self.cmdData
end
function FunctionQuest:stopCurrentCmd(questData)
  if self.cmdData and self.cmdData.id == questData.id and self.cmdData.step == questData.step then
    self.cmdData = nil
  end
end
function FunctionQuest:CGquestCallback(questData)
  if questData and questData.scope and questData.id and questData.staticData and questData.staticData.FinishJump then
    QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
  else
    redlog("FunctionQuest CGquestCallback: questData is NULL")
  end
end
function FunctionQuest:CGquestCallback2(scope, id, FinishJump)
  if scope and id and FinishJump then
    QuestProxy.Instance:notifyQuestState(scope, id, FinishJump)
  else
    redlog("FunctionQuest CGquestCallback: questData is NULL")
  end
end
function FunctionQuest:button_goon(buttonData)
  if buttonData and buttonData.id then
    Game.PlotStoryManager:SetButtonState(self.plotid, buttonData.id, 2)
  end
end
function FunctionQuest:missionCallback(cmd, event)
end
function FunctionQuest:handleMissShutdown(questId)
  if not questId then
    return
  end
  local questData = QuestProxy.Instance:getQuestDataByIdAndType(questId)
  if questData and (questData.questDataStepType == QuestDataStepType.QuestDataStepType_KILL or questData.questDataStepType == QuestDataStepType.QuestDataStepType_GATHER) then
    FunctionSystem.InterruptMyselfAI()
  end
end
function FunctionQuest:executeTalkQuest(questData)
  if questData and QuestProxy.Instance.questDebug then
    QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
    return
  end
  if not questData then
    return
  end
  if questData.params.openui == 1 then
    local viewdata = {
      viewname = "ChooseRouteView",
      dialoglist = questData.params.dialog,
      iconlist = questData.params.Icon,
      callbackData = questData.id,
      questId = questData.id,
      callback = function(questId, optionid, state)
        if state then
          helplog("run to option dialog", questData.id, questData.scope, optionid)
          QuestProxy.Instance:notifyQuestState(questData.scope, questId, optionid)
        else
          local questData = QuestProxy.Instance:getQuestDataByIdAndType(questId)
          if questData then
            helplog("run FailJump", questData.id, questData.scope, questData.staticData.FailJump)
            QuestProxy.Instance:notifyQuestState(questData.scope, questId, questData.staticData.FailJump)
          end
        end
      end
    }
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
  elseif questData.params.isExtendDialog == 1 then
    local viewdata = {
      viewname = "ExtendDialogView",
      dialoglist = questData.params.dialog,
      callbackData = questData.id,
      questId = questData.id,
      forceNotify = true,
      keepOpen = questData.params.keepOpen == 1,
      viewdata = {
        reEntnerNotDestory = questData.params.reEnter == 1
      },
      callback = function(questId, optionid, state)
        if state then
          QuestProxy.Instance:notifyQuestState(questData.scope, questId, optionid)
        else
          local questData = QuestProxy.Instance:getQuestDataByIdAndType(questId)
          if questData then
            QuestProxy.Instance:notifyQuestState(questData.scope, questId, questData.staticData.FinishJump)
          end
        end
      end
    }
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
  elseif LinkCharacterProxy.Instance:CheckIsQuestIdOfLinkCharacter(questData.id) then
  else
    local specialMarks
    if questData.type == QuestDataType.QuestDataType_DAHUANG then
      specialMarks = questData.id
    end
    local viewdata = {
      viewname = "DialogView",
      dialoglist = questData.params.dialog,
      callbackData = questData.id,
      questId = questData.id,
      showPurikura = questData.params.showpurikura,
      specialMarks = specialMarks,
      forceNotify = true,
      callback = function(questId, optionid, state)
        if state then
          if not BranchMgr.IsChina() and (questId == 396520001 and optionid == 4 or questId == 396520001 and optionid == 8) then
            OverseaHostHelper:GachaUseComfirm(10, function()
              QuestProxy.Instance:notifyQuestState(questData.scope, questId, optionid)
            end, nil, function()
              QuestProxy.Instance:notifyQuestState(questData.scope, questId, optionid + 1)
            end)
          else
            QuestProxy.Instance:notifyQuestState(questData.scope, questId, optionid)
          end
        else
          local questData = QuestProxy.Instance:getQuestDataByIdAndType(questId)
          if questData then
            QuestProxy.Instance:notifyQuestState(questData.scope, questId, questData.staticData.FinishJump)
          end
        end
      end
    }
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
  end
end
function FunctionQuest:handleAutoTrigger(questData)
  local qData = questData
  if questData.questDataStepType == QuestDataStepType.QuestDataStepType_USE then
    local questParam
    for i = 1, #self.iconAtlas do
      questParam = questData.params[self.iconAtlas[i]]
      if questParam then
        local curImageId = ServicePlayerProxy.Instance:GetCurMapImageId() or 0
        self.triggerCheck:AddQuickUseCheck(questData.id, questData.map, questData.pos, questData.params.distance, self.iconAtlas[i], questParam, qData.params.name, questData.params.button, qData, curImageId, questData.params.distance2)
        break
      end
    end
  elseif questData.questDataStepType == QuestDataStepType.QuestDataStepType_SELFIE then
    if questData.params.itemIcon ~= nil then
      local curImageId = ServicePlayerProxy.Instance:GetCurMapImageId() or 0
      self.triggerCheck:AddQuickUseCheck(questData.id, questData.map, questData.pos, questData.params.distance, "itemIcon", questData.params.itemIcon, qData.params.name, questData.params.button, qData, curImageId, questData.params.distance2)
    end
  elseif questData.questDataStepType == QuestDataStepType.QuestDataStepType_MOVE then
    local func = function(owner, questData)
      if questData and questData.staticData then
        QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
      end
    end
    local curImageId = ServicePlayerProxy.Instance:GetCurMapImageId() or 0
    self.triggerCheck:AddCallBackCheck(questData.id, questData.map, questData.pos, questData.params.distance, qData, nil, func, nil, curImageId)
  elseif questData.questDataStepType == QuestDataStepType.QuestDataStepType_TALK then
    if questData.map == nil and questData.pos ~= nil then
    elseif questData.map == nil and questData.pos == nil then
    else
      if not questData.pos and questData.params.distance then
        errorLog("pos is nil but distance is:" .. questData.params.distance)
      end
      local func = function(owner, questData)
        if questData and questData.staticData then
          self:executeTalkQuest(questData)
        end
      end
      local curImageId = ServicePlayerProxy.Instance:GetCurMapImageId() or 0
      self.triggerCheck:AddCallBackCheck(questData.id, questData.map, questData.pos, questData.params.distance or FunctionQuest.DefaultTriggerInfinite, qData, nil, func, nil, curImageId)
    end
  elseif questData.questDataStepType == QuestDataStepType.QuestDataStepType_RAID then
    if questData.map == nil and questData.pos ~= nil then
    elseif questData.map == nil and questData.pos == nil then
    else
      if questData.pos or questData.params.distance then
      end
      local func = function(owner, questData)
        ServiceQuestProxy.Instance:CallQuestRaidCmd(questData.id)
      end
      local curImageId = ServicePlayerProxy.Instance:GetCurMapImageId() or 0
      self.triggerCheck:AddCallBackCheck(questData.id, questData.map, questData.pos, questData.params.distance or FunctionQuest.DefaultTriggerInfinite, qData, nil, func, nil, curImageId)
    end
  elseif questData.questDataStepType == QuestDataStepType.QuestDataStepType_PLAY_CAMERAPLOT then
    if questData.map == nil then
      errorLog("Camera_show步骤 缺少地图配置" .. questData.id)
    else
      local func = function(owner, questData)
        local groupid = questData.params.id
        redlog("后端推送cameraPlot. groupid: 到达地图  执行 ", groupid)
        TimeTickManager.Me():ClearTick(self, 1)
        FunctionCameraEffect.Me():ResetCameraPlotParams()
        TimeTickManager.Me():CreateTick(0, 20, function(self, deltatime)
          local result = FunctionCameraEffect.Me():PlayCameraPlot(groupid, function()
            self:CGquestCallback(questData)
          end)
          if result then
            TimeTickManager.Me():ClearTick(self, 1)
          end
        end, self, 1)
        return
      end
      local curImageId = ServicePlayerProxy.Instance:GetCurMapImageId() or 0
      self.triggerCheck:AddCallBackCheck(questData.id, questData.map, questData.pos, questData.params.distance or FunctionQuest.DefaultTriggerInfinite, qData, nil, func, nil, curImageId)
    end
  elseif questData.questDataStepType == QuestDataStepType.QuestDataStepType_GUIDELOCKMONSTER then
    local enter = function(owner, questData)
      if questData then
        local guideId = questData.params.guideID
        local guideData = Table_GuideID[guideId]
        local bubbleId = guideData.BubbleID
        if bubbleId and Table_BubbleID[bubbleId] then
          GameFacade.Instance:sendNotification(GuideEvent.ShowAutoFightBubble, {bubbleId = bubbleId, isShow = true})
        end
      end
    end
    local exsit = function(owner, questData)
      local guideId = questData.params.guideID
      local guideData = Table_GuideID[guideId]
      local bubbleId = guideData.BubbleID
      if bubbleId and Table_BubbleID[bubbleId] then
        GameFacade.Instance:sendNotification(GuideEvent.ShowAutoFightBubble, {bubbleId = bubbleId, isShow = false})
      end
    end
    local guideId = questData.params.guideID
    local guideData = Table_GuideID[guideId]
    local monsterId = guideData.guideLockMonster
    TableUtility.TableClear(cmdArgs)
    cmdArgs.questId = questData.id
    cmdArgs.monsterId = monsterId
    QuestProxy.Instance:addOrRemoveLockMonsterGuide(cmdArgs)
    self.triggerCheck:AddCallBackCheck(questData.id, questData.map, questData.pos, questData.params.distance or FunctionQuest.DefaultTriggerInfinite, qData, nil, enter, exsit)
  elseif questData.questDataStepType == "movetrigger" then
    local params = questData.params
    local func = function(owner, questData, id)
      for i = 1, #questData.params do
        if questData.id .. i == id then
          if questData.params[i].type == 1 then
            helplog("type == 1,dialog")
            local viewdata = {
              viewname = "DialogView",
              dialoglist = questData.params[i].dialog
            }
            GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
            self.triggerCheck:RemoveQuestCheck(id)
          elseif questData.params[i].type == 2 then
            helplog("type==2, notifyQuestState")
            local viewdata = {
              viewname = "DialogView",
              dialoglist = questData.params[i].dialog
            }
            GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
            if questData and questData.staticData then
              helplog("推进任务:", questData.id)
              QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
            end
          end
        end
      end
    end
    for i = 1, #params do
      local singleParams = params[i]
      local tempID = questData.id .. i
      local pos = LuaVector3(singleParams.pos[1], singleParams.pos[2], singleParams.pos[3])
      self.triggerCheck:AddCallBackCheck(tempID, questData.map, pos, singleParams.distance, qData, nil, func)
    end
  elseif questData.questDataStepType == "steptrigger" then
    local params = questData.params
    local func = function(owner, questData, id)
      for i = 1, #questData.params do
        if questData.id .. i == id then
          if questData.params[i].type == 1 then
            helplog("type == 1,dialog")
            local viewdata = {
              viewname = "DialogView",
              dialoglist = questData.params[i].dialog
            }
            GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
            self.triggerCheck:RemoveQuestCheck(id)
            if questData.params[i + 1] then
              table.remove(questData.params, 1)
              self:handleAutoTrigger(questData)
              return
            end
          elseif questData.params[i].type == 2 then
            helplog("type==2, notifyQuestState")
            local viewdata = {
              viewname = "DialogView",
              dialoglist = questData.params[i].dialog
            }
            GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
            if questData.staticData then
              helplog("推进任务:", questData.id)
              QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
            end
          end
        end
      end
    end
    for i = 1, #params do
      local singleParams = params[i]
      if singleParams then
        local tempID = questData.id .. i
        local pos = LuaVector3(singleParams.pos[1], singleParams.pos[2], singleParams.pos[3])
        self.triggerCheck:AddCallBackCheck(tempID, questData.map, pos, singleParams.distance, qData, nil, func)
        return
      end
    end
  elseif questData.questDataStepType == "shot" or questData.questDataStepType == "shot_advanced" then
    local questParam
    for i = 1, #self.iconAtlas do
      questParam = questData.params[self.iconAtlas[i]]
      if questParam then
        local curImageId = ServicePlayerProxy.Instance:GetCurMapImageId() or 0
        self.triggerCheck:AddQuickUseCheck(questData.id, questData.map, questData.pos, questData.params.distance, self.iconAtlas[i], questParam, qData.params.name, questData.params.button, qData, curImageId, questData.params.distance2)
        break
      end
    end
  elseif questData.questDataStepType == QuestDataStepType.QuestDataStepType_PICKING_SORT then
    local questParam
    for i = 1, #self.iconAtlas do
      questParam = questData.params[self.iconAtlas[i]]
      if questParam then
        local curImageId = ServicePlayerProxy.Instance:GetCurMapImageId() or 0
        self.triggerCheck:AddQuickUseCheck(questData.id, questData.map, questData.pos, questData.params.distance, self.iconAtlas[i], questParam, qData.params.name, questData.params.button, qData, curImageId, questData.params.distance2)
        break
      end
    end
  elseif questData.questDataStepType == QuestDataStepType.QuestDataStepType_SHARE then
    local func = function(owner, questData)
      if questData and questData.staticData then
        self:handleShareQuest(questData)
      end
    end
    local curImageId = ServicePlayerProxy.Instance:GetCurMapImageId() or 0
    self.triggerCheck:AddCallBackCheck(questData.id, questData.map, nil, questData.params.distance or FunctionQuest.DefaultTriggerInfinite, qData, nil, func, nil, curImageId)
  elseif questData.questDataStepType == QuestDataStepType.QuestDataStepType_GUIDE then
    local viewName = questData.params.viewName
    local exitExecute = questData.params.exitExecute
    if not StringUtil.IsEmpty(viewName) then
      local enterFunc = function(_, questId)
        local questData = QuestProxy.Instance:getQuestDataByIdAndType(questId)
        if questData and not StringUtil.IsEmpty(questData.params.viewName) and not exitExecute then
          self:executeQuest(questData)
        end
      end
      local exitFunc = function(viewName, questId)
        local questData = QuestProxy.Instance:getQuestDataByIdAndType(questId)
        if questData then
          if exitExecute then
            self:executeQuest(questData)
          else
            QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FailJump)
          end
        end
        FunctionQuestUIChecker.Me():RemoveCheck(viewName)
      end
      FunctionQuestUIChecker.Me():AddCheck(viewName, questData.id, enterFunc, exitFunc)
    else
    end
  elseif questData.questDataStepType == "race" then
    local func = function(owner, questData)
      if questData and questData.staticData then
        xdlog("玩家到达终点", questData.id)
        ServiceNUserProxy.Instance:CallRaceGameFinishUserCmd(true)
        QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
      end
    end
    local curImageId = ServicePlayerProxy.Instance:GetCurMapImageId() or 0
    self.triggerCheck:AddCallBackCheck(questData.id, questData.map, questData.pos, questData.params.distance, qData, nil, func, nil, curImageId)
  end
end
function FunctionQuest:handleEffectTrigger(questData)
  local qData = questData
  if questData.questDataStepType == QuestDataStepType.QuestDataStepType_USE or questData.questDataStepType == QuestDataStepType.QuestDataStepType_SELFIE or questData.questDataStepType == QuestDataStepType.QuestDataStepType_MOVE then
    local id = QuestProxy.Instance:getAreaTriggerIdByQuestId(questData.id)
    self.triggerCheck:AddShowAreaEffectCheck(id, questData.map, questData.pos, FunctionQuest.DefaultEffectTriggerInfinite, qData)
  elseif questData.questDataStepType == QuestDataStepType.QuestDataStepType_TALK and questData.map and questData.pos then
    local id = QuestProxy.Instance:getAreaTriggerIdByQuestId(questData.id)
    self.triggerCheck:AddShowAreaEffectCheck(id, questData.map, questData.pos, FunctionQuest.DefaultEffectTriggerInfinite, qData)
  end
end
function FunctionQuest:handleAutoExcute(questData)
  if questData.staticData and questData.staticData.Auto == 1 then
    self:executeQuest(questData)
  end
end
function FunctionQuest:handleAutoQuest(questData)
  self:handleAutoExcute(questData)
  self:handleAutoTrigger(questData)
end
function FunctionQuest:handleQuestInit(questData)
  if questData.questListType == SceneQuest_pb.EQUESTLIST_ACCEPT and QuestProxy.Instance:checkIfNeedAutoTrigger(questData) then
    self:handleAutoTrigger(questData)
  end
  if questData.questListType ~= SceneQuest_pb.EQUESTLIST_ACCEPT or QuestProxy.Instance:checkIfNeedEffectTrigger(questData) then
  end
  if questData.questListType == SceneQuest_pb.EQUESTLIST_ACCEPT and QuestProxy.Instance:checkIfNeedAutoExcuteAtInit(questData) then
    self:handleAutoExcute(questData)
  end
end
function FunctionQuest:handleVisitQuest(questData)
  if questData.questDataStepType == QuestDataStepType.QuestDataStepType_VISIT then
    local target = FunctionVisitNpc.Me():GetTarget()
    local npcId = questData.params.npc
    local uniqueid = questData.params.uniqueid
    if not target or not target.data then
      local targetData
    end
    if not targetData or not targetData.staticData then
      local staticData
    end
    if staticData then
      local isSameNpc = false
      local targetId = staticData.id
      if uniqueid == targetData.uniqueid then
        isSameNpc = true
      elseif type(npcId) == "table" then
        for i = 1, #npcId do
          local single = npcId[i]
          if single == targetId then
            isSameNpc = true
            break
          end
        end
      elseif targetId == npcId then
        isSameNpc = true
      end
      if isSameNpc then
        FunctionVisitNpc.Me():AccessTarget(target, questData.id, AccessCustomType.Quest)
        return true
      end
    end
  end
end
function FunctionQuest:handleShareQuest(questData)
  local stepData = questData:getCurrentStepData()
  local shareTips = stepData and stepData.shareTips
  if not shareTips then
    QuestProxy.Instance:notifyQuestState(questData.scope, questId)
    return
  end
  local viewdata = {
    viewname = "DialogView",
    dialoglist = shareTips,
    callbackData = questData.id,
    questId = questData.id,
    callback = function(questId, optionId, state)
      QuestProxy.Instance:notifyQuestState(questData.scope, questId, optionId)
    end
  }
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
end
function FunctionQuest:stopTrigger(questData)
  self:stopMisstionTrigger(questData)
  self:stopQuestCheck(questData)
  self:stopQuestMiniShow(questData.id)
  self:stopAutoFightGuideQuest(questData)
  self:stopGuideChecker(questData)
  self:stopGuildChecker(questData)
  self:stopCountDownChecker(questData)
  self:removeMonsterNamePre(questData)
  TappingManager.Me():EndTappingQuest(questData.id)
end
function FunctionQuest:stopCountDownChecker(questData)
  Game.QuestCountDownManager:RemoveQuestEffect(questData.id)
end
function FunctionQuest:stopGuildChecker(questData)
  Game.QuestGuildManager:RemoveQuestEffect(questData.id)
end
function FunctionQuest:stopQuestCheck(questData)
  if questData.questDataStepType == "steptrigger" then
    helplog("特殊处理trigger: steptrigger")
    for i = 1, #questData.params do
      local combineId = questData.id .. i
      helplog("删除trigger" .. combineId)
      FunctionQuestDisChecker.RemoveQuestCheck(combineId)
    end
  else
    FunctionQuestDisChecker.RemoveQuestCheck(questData.id)
  end
end
function FunctionQuest:stopGuideChecker(questData)
  FunctionGuideChecker.RemoveGuideCheck(questData.id)
end
function FunctionQuest:removeMonsterNamePre(questData)
  if self.currentShowQuest and self.currentShowQuest.id == questData.id and QuestProxy.Instance:checkIfShowMonsterNamePre(questData) then
    GameFacade.Instance:sendNotification(SceneUIEvent.RemoveMonsterNamePre, questData)
    self.currentShowQuest = nil
  end
end
function FunctionQuest:addMonsterNamePre(questData)
  if self.currentShowQuest then
    self:removeMonsterNamePre(self.currentShowQuest)
  end
  if QuestProxy.Instance:checkIfShowMonsterNamePre(questData) then
    GameFacade.Instance:sendNotification(SceneUIEvent.AddMonsterNamePre, questData)
    self.currentShowQuest = questData
  end
end
function FunctionQuest:checkShowMonsterNamePre(creature)
  if self.currentShowQuest then
    local groupID = self.currentShowQuest.params.groupId
    local npcID = self.currentShowQuest.params.monster
    local npcUID = self.currentShowQuest.params.uniqueid
    if npcID and creature.data.staticData.id == npcID then
      return true
    end
    if groupID and creature.data.GetGroupID and creature.data:GetGroupID() == groupID then
      return true
    end
    if npcUID and creature.data.uniqueid == npcUID then
      return true
    end
  end
end
function FunctionQuest:stopAutoFightGuideQuest(questData)
  if questData.questDataStepType == QuestDataStepType.QuestDataStepType_GUIDELOCKMONSTER then
    local guideId = questData.params.guideID
    local guideData = Table_GuideID[guideId]
    local bubbleId = guideData.BubbleID
    local monsterId = guideData.guideLockMonster
    if bubbleId and Table_BubbleID[bubbleId] then
      GameFacade.Instance:sendNotification(GuideEvent.ShowAutoFightBubble, {bubbleId = bubbleId, isShow = false})
    end
    TableUtility.TableClear(cmdArgs)
    cmdArgs.questId = questData.id
    QuestProxy.Instance:addOrRemoveLockMonsterGuide(cmdArgs)
  end
end
function FunctionQuest:stopQuestMiniShow(id)
  self.lastQuestData = nil
  Game.QuestMiniMapEffectManager:RemoveQuestEffect(id)
end
function FunctionQuest:addQuestMiniShow(questData)
  if questData then
    self.lastQuestData = questData
    if not questData.params.invisible then
      local showLight = true
      Game.QuestMiniMapEffectManager:AddQuestEffect(questData.id, showLight)
    end
  end
end
function FunctionQuest:refreshQuestMiniShow()
  local d = self.lastQuestData
  if d then
    self:stopQuestMiniShow(d.id)
    self:addQuestMiniShow(d)
  end
end
function FunctionQuest:stopMisstionTrigger(questData)
  if QuestProxy.Instance:checkIfNeedAutoTrigger(questData) then
    local triggerCheck = Game.AreaTrigger_Mission
    if triggerCheck ~= nil then
      if questData.questDataStepType == "steptrigger" then
        for i = 1, #questData.params do
          local combineId = questData.id .. i
          triggerCheck:RemoveQuestCheck(combineId)
        end
      else
        triggerCheck:RemoveQuestCheck(questData.id)
      end
    end
  end
end
function FunctionQuest:stopEffectTrigger(questData)
  if QuestProxy.Instance:checkIfNeedEffectTrigger(questData) then
    local id = QuestProxy.Instance:getAreaTriggerIdByQuestId(questData.id)
    local triggerCheck = Game.AreaTrigger_Mission
    if triggerCheck ~= nil then
      triggerCheck:RemoveQuestCheck(id)
    end
  end
end
function FunctionQuest:playMediaQuest(mapId)
  local quest, video = self:getMediaQuest(mapId)
  if quest then
    QuestProxy.Instance:notifyQuestState(quest.scope, quest.id, quest.staticData.FinishJump)
    helplog("此处应该播一段视频:", video.Name)
    if Game.MapManager:Previewing() then
      Game.MapManager:StopPreview()
      FunctionBGMCmd.Me():SetMute(true)
    end
    FunctionVideoStorage.Me():PlayVideoByID(video.id, nil, function()
      FunctionBGMCmd.Me():Reset()
      FunctionBGMCmd.Me():SetMute(false)
    end)
    return true
  end
  return false
end
function FunctionQuest:CheckPlayQuestVideo()
end
function FunctionQuest:getMediaQuest(mapId)
  local type = SceneQuest_pb.EQUESTLIST_ACCEPT
  local list = QuestProxy.Instance.questList[type]
  if list then
    for i = 1, #list do
      local single = list[i]
      if single.questDataStepType == QuestDataStepType.QuestDataStepType_MEDIA and single.map == mapId then
        local id = single.params.id
        local table = Table_Video[id]
        if table then
          return single, table
        end
      end
    end
  end
  return nil
end
function FunctionQuest:updateTraceView(traceData)
  EventManager.Me():PassEvent(FunctionQuest.UpdateTraceInfo, traceData)
end
function FunctionQuest:removeTraceView(traceData)
  EventManager.Me():PassEvent(FunctionQuest.RemoveTraceInfo, traceData)
end
function FunctionQuest:addTraceView(traceData)
  EventManager.Me():PassEvent(FunctionQuest.AddTraceInfo, traceData)
end
function FunctionQuest:getIllustrationQuest(mapId)
  local questData = QuestProxy.Instance:getIllustrationQuest(mapId)
  if questData then
    QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
    return questData.params.id
  else
    return nil
  end
end
function FunctionQuest:executeManualQuest(questData)
  if questData and questData.staticData then
    if self.onGoingQuestId then
      self:stopQuestMiniShow(self.onGoingQuestId)
    end
    self:ShowDirAndDis(questData)
    local symbol = questData.staticData.Params.symbol
    self:executeQuest(questData)
  end
end
function FunctionQuest:ShowDirAndDis(questData)
  self:addQuestMiniShow(questData)
  self:addMonsterNamePre(questData)
  Game.QuestMiniMapEffectManager:ShowMiniMapDirEffect(questData.id)
  GameFacade.Instance:sendNotification(QuestEvent.ShowManualGoEffect, {
    questid = questData.id
  })
  self.onGoingQuestId = questData.id
end
function FunctionQuest:TestEquip()
  for k, v in pairs(Table_GM_CMD) do
    local func = loadstring(v.Cmd .. "Func")
    if func then
      func()
    end
  end
end
function additemFunc()
  local cmd = v.Cmd .. " "
  local params = v.Param
  local symbol = "({(.-)})"
  for str, param in string.gmatch(params, symbol) do
    local split = string.split(param, ",")
    local input = ""
    local result = split[2] .. "=" .. input
    cmd = cmd .. result
  end
  ServiceGMProxy.Instance:Call(cmd)
end
