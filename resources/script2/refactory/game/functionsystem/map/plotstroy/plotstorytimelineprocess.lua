autoImport("PlotStoryProcess")
PlotStoryTimelineProcess = class("PlotStoryTimelineProcess", PlotStoryProcess)
local ResultState = {WAIT = 1, SUCCESS = 2}
function PlotStoryTimelineProcess:ctor(fake_plotid, pqtl_name, isFreePlot, fixedDuration, extraParams, loopPlay, plotStartCall, plotStartCallParam, needRestore, plotStoryShowSkip)
  self.plotid = fake_plotid
  self.pqtl = pqtl_name
  self.running = false
  self.parallelStep = {}
  self.isFreePlot = isFreePlot
  self.fixedDuration = fixedDuration
  self.extraParams = extraParams
  self.keep = keep
  self.isBlockToLoop = loopPlay
  self.needRestore = needRestore
  self.plotStartCalled = false
  self.plotStartCall = plotStartCall
  self.plotStartCallParam = plotStartCallParam
  self.plotStoryShowSkip = plotStoryShowSkip
  self.dialogState = 0
  self.sceneObjectEffectMap = {}
  self.sceneObjectAudioIds = {}
  self.typeFuncResult = {}
  self.specificFilterMap = {}
  self.curveEffects = {}
  self.curveMoveTargets = {}
end
function PlotStoryTimelineProcess:ResetTimer()
  self.time = 0
  self.rts = UnityRealtimeSinceStartup + self.time
  self.time_2 = 0
end
function PlotStoryTimelineProcess:RefreshTimer(deltaTime)
  self.time = UnityRealtimeSinceStartup - self.rts
  if deltaTime then
    self.time_2 = self.time_2 + deltaTime
  end
  self.time = math.max(self.time, self.time_2)
end
function PlotStoryTimelineProcess:Launch(useless_param1)
  if self.running then
    return
  end
  self.running = true
  self.elapsed = 0
  self:ResetTimer()
  if not self.isFreePlot then
    Game.PlotStoryManager:PS_SetCameraPlotStyle(true)
    if Game.PerformanceManager then
      Game.PerformanceManager:SkinWeightHigh(true)
    end
  end
  if self.needRestore or not self.isFreePlot or not self.keep then
    self.processRecorder = PlotStoryProcessRecorder.new()
    self.processRecorder:Launch(self)
  end
end
function PlotStoryTimelineProcess:Update(time, deltaTime)
  self:RefreshTimer(deltaTime)
  if not self.running then
    return
  end
  local step
  for i = 1, #self.parallelStep do
    step = self.parallelStep[i]
    if not step.type or not step.param or not self[step.type] then
      self:ErrorLog_Plot(step.type)
      step.result = false
    end
    if step.result == nil then
      step.resultRaw = {
        self[step.type](self, step.param, time, deltaTime)
      }
      step.result = step.resultRaw[1]
      if step.result == false then
        step.result = nil
      end
    end
  end
  for i = #self.parallelStep, 1, -1 do
    step = self.parallelStep[i]
    if step.result ~= nil then
      if step.sendback_result then
        PQTL_Manager.Instance:ReceiveLuaActionResult(self.plotid, self.pqtl, step.caster, step.trigger_type, step.result)
      end
      if self.processRecorder and self.processRecorder["Post_" .. step.type] then
        self.processRecorder["Post_" .. step.type](self.processRecorder, step.param, select(2, unpack(step.resultRaw)))
      end
      ReusableTable.DestroyTable(self.parallelStep[i])
      table.remove(self.parallelStep, i)
    end
  end
  if self.fixedDuration and self.fixedDuration > 0 then
    self.elapsed = self.elapsed + deltaTime
    if self.elapsed >= self.fixedDuration then
      if PQTL_Manager.Instance:LuaCtrl_PQTL_ContainsCoda(self.plotid) then
        self.fixedDuration = nil
        PQTL_Manager.Instance:LuaCtrl_PQTL_BreakRepetition(self.plotid, true)
      else
        self:ShutDown(true)
      end
    end
  end
end
function PlotStoryTimelineProcess:ShutDown(isDurationEnd, doNotRestore)
  if not self.running then
    return
  end
  self.running = false
  if self.processRecorder then
    if self.needRestore or not doNotRestore then
      self.processRecorder:Restore()
    end
    self.processRecorder:ShutDown()
    self.processRecorder = nil
  end
  self.isBreakShutdown = not isDurationEnd
  PQTL_Manager.Instance:LuaNotifyShutDown_PQTL(self.plotid)
  if not self.isFreePlot then
    if Game.PlotStoryManager:IsSeqPlotProgressEnd() then
      Game.PlotStoryManager:PS_SetCameraPlotStyle(false)
    end
    if Game.PerformanceManager then
      Game.PerformanceManager:SkinWeightHigh(false)
    end
  end
  if self.random_talk_runstate then
    ReusableTable.DestroyTable(self.random_talk_runstate)
    self.random_talk_runstate = nil
  end
  if self.pqtl_object_map then
    TableUtility.TableClearByDeleter(self.pqtl_object_map, function(go)
      if not LuaGameObject.ObjectIsNull(go) then
        local rets = StringUtil.Split(go.name, "_")
        GameObject.Destroy(go)
        Game.AssetManager:UnloadAsset(ResourcePathHelper.RoleBody(rets[1]))
      end
    end)
  end
  if self.sceneObjectEffectMap then
    TableUtility.TableClearByDeleter(self.sceneObjectEffectMap, function(effect)
      effect:Destroy()
    end)
  end
  if self.sceneObjectAudioIds then
    TableUtility.ArrayClearByDeleter(self.sceneObjectAudioIds, function(audioId)
      NSceneEffectProxy.Instance:RemoveAudio(audioId)
    end)
  end
  if self.curveMoveTargets then
    TableUtility.TableClearByDeleter(self.curveMoveTargets, function(targets)
      for i = 1, #targets do
        local target = targets[i]
        target:Client_SetIsMoveToWorking(false)
        target:Logic_PlayAction_Idle()
      end
    end)
  end
  if self.curveEffects then
    TableUtility.TableClearByDeleter(self.curveEffects, function(effect)
      effect:Destroy()
    end)
  end
  if self.specificFilterMap then
    for id, data in pairs(self.specificFilterMap) do
      local targets = self:_getTargetByParams(data)
      local contents = ReusableTable.CreateArray()
      self:_getFilterContentsByParams(data, contents)
      if #contents > 0 then
        for i = 1, #targets do
          local creature = targets[i]
          if creature then
            SceneFilterProxy.Instance:SceneFilterUnCheckWithContents(id, contents, creature)
          end
        end
      end
      ReusableTable.DestroyAndClearArray(contents)
      self.specificFilterMap[id] = nil
    end
  end
  self:PassEvent(PlotStoryEvent.ShutDown, self)
end
function PlotStoryTimelineProcess:IsPlayEnd()
  return not self.isBreakShutdown and not self.st_BreakRepetition
end
function PlotStoryTimelineProcess:PlotEnd()
  self.super.PlotEnd(self)
  TableUtility.ArrayClearByDeleter(self.parallelStep, function(step)
    ReusableTable.DestroyTable(step)
  end)
end
function PlotStoryTimelineProcess:AddStep(caster, trigger_type, action_type, action_param, need_result)
  local step = ReusableTable.CreateTable()
  step.caster = caster
  step.trigger_type = trigger_type
  step.type = action_type
  step.param = action_param
  step.sendback_result = need_result
  step.param.pqtl_id = caster
  table.insert(self.parallelStep, step)
  if self.processRecorder and self.processRecorder["Pre_" .. step.type] then
    self.processRecorder["Pre_" .. step.type](self.processRecorder, step.param)
  end
  if not self.plotStartCalled then
    self.plotStartCalled = true
    if self.plotStartCall then
      self.plotStartCall(self.plotStartCallParam, self)
    end
  end
end
function PlotStoryTimelineProcess:_getTargetByParams(params, refIndex)
  local tempTargets = PlotStoryTimelineProcess.super._getTargetByParams(self, params)
  if #tempTargets == 0 and params._refParam and 0 < #params._refParam then
    refIndex = refIndex or 1
    local refTarget = self:_getTargetByExParams(params._refParam[refIndex])
    if type(refTarget) == "number" then
      refTarget = SceneCreatureProxy.FindCreature(refTarget)
    end
    if refTarget then
      table.insert(tempTargets, refTarget)
    end
  end
  return tempTargets
end
function PlotStoryTimelineProcess:_getTargetByExParams(key_enum)
  return self.extraParams and self.extraParams[key_enum]
end
function PlotStoryTimelineProcess:summon(params)
  if params.waitaction_loop == nil then
    params.waitaction_loop = false
  end
  return self.super.summon(self, params)
end
function PlotStoryTimelineProcess:play_effect(params)
  params.id = params.uid
  params.onshot = params.loop ~= true
  return self.super.play_effect(self, params)
end
function PlotStoryTimelineProcess:play_effect_scene(params)
  params.id = params.uid
  params.onshot = params.loop ~= true
  return self.super.play_effect_scene(self, params)
end
function PlotStoryTimelineProcess:remove_effect_scene(params)
  params.id = params.uid
  return self.super.remove_effect_scene(self, params)
end
function PlotStoryTimelineProcess:playCurveMotionEffect(params)
  local path = params.path
  local pos = params.pos
  Asset_Effect.PlayAt(path, pos, function(effectHandle, args, assetEffect)
    self.curveEffects[params.pqtl_id] = assetEffect
  end)
  return true
end
function PlotStoryTimelineProcess:removeCurveMotionEffect(params)
  local effect = self.curveEffects[params.pqtl_id]
  if effect then
    effect:Destroy()
    self.curveEffects[params.pqtl_id] = nil
  end
  return true
end
function PlotStoryTimelineProcess:shakescreen(params)
  params.time = (CameraAdditiveEffectShake.INFINITE_DURATION - 1) * 1000
  return self.super.shakescreen(self, params)
end
function PlotStoryTimelineProcess:addbutton(params)
  local state = Game.PlotStoryManager:GetButtonState(self.plotid, params.id)
  if not state then
    params.eventtype = "goon"
    local cr = self.super.addbutton(self, params)
  elseif state == 2 then
    Game.PlotStoryManager:SetButtonState(self.plotid, params.id)
    return true
  end
  return false
end
function PlotStoryTimelineProcess:client_ai_patrol(params, time, deltaTime)
  local targets = self:_getTargetByParams(params)
  for i = 1, #targets do
    local target = targets[i]
    target.ai:PushCommand(FactoryAICMD.GetClientPatrolCmd(params.randomRange, params.randomSeed, params.duration, params.pause_duration, params.ignoreNavMesh), target)
  end
  return true
end
function PlotStoryTimelineProcess:client_ai_chase_target(params, time, deltaTime)
  local ref_myself = self:_getTargetByParams(params)
  local ref_target = self:_getTargetByParams(params, 2)
  if #ref_myself > 0 and #ref_target > 0 then
    for i = 1, #ref_myself do
      local target = ref_myself[i]
      target.ai:PushCommand(FactoryAICMD.GetClientChaseTargetCmd(ref_target[1], params.duration, params.range, params.moveSpeed), target)
    end
  end
  return true
end
function PlotStoryTimelineProcess:client_ai_avoid_target(params, time, deltaTime)
  local ref_myself = self:_getTargetByParams(params)
  local ref_target = self:_getTargetByParams(params, 2)
  if #ref_myself > 0 and #ref_target > 0 then
    for i = 1, #ref_myself do
      local target = ref_myself[i]
      target.ai:PushCommand(FactoryAICMD.GetClientAvoidTargetCmd(ref_target[1], params.duration, params.range, params.moveSpeed), target)
    end
  end
  return true
end
function PlotStoryTimelineProcess:block(params)
  if self.isBlockToLoop then
    PQTL_Manager.Instance:LuaCtrl_PQTL_JumpTo(self.plotid, 0)
    return true
  end
  return false
end
function PlotStoryTimelineProcess:noaction(params)
  return true
end
function PlotStoryProcess:random_talk(params, time, deltaTime)
  if not self.random_talk_runstate then
    if params._refParam and #params._refParam > 0 then
      local cfg = self:_getTargetByExParams(params._refParam[2])
      if not cfg then
        redlog("random_talk", "refParam not set")
        return true
      end
      self.random_talk_runstate = ReusableTable.CreateTable()
      self.random_talk_runstate.cur = 0
      self.random_talk_runstate.curT = 0
      self.random_talk_runstate.interval = cfg[1]
      self.random_talk_runstate.times = #cfg - 1
      self.random_talk_runstate.infinite = params.infinite
      local talk = {}
      for i = 2, #cfg do
        table.insert(talk, cfg[i])
      end
      self.random_talk_runstate.talk = {}
      while #talk > 0 do
        local n = math.random(#talk)
        table.insert(self.random_talk_runstate.talk, talk[n])
        table.remove(talk, n)
      end
    else
      redlog("random_talk", "refParam not set")
      return true
    end
  end
  self.random_talk_runstate.cur = self.random_talk_runstate.cur + deltaTime
  if self.random_talk_runstate.cur >= self.random_talk_runstate.interval then
    self.random_talk_runstate.curT = self.random_talk_runstate.curT + 1
    self.random_talk_runstate.cur = 0
    local dialogId = self.random_talk_runstate.talk[self.random_talk_runstate.curT]
    local msg = DialogUtil.GetDialogData(dialogId) and DialogUtil.GetDialogData(dialogId).Text
    local targets = self:_getTargetByParams(params)
    for i = 1, #targets do
      local target = targets[i]
      local sceneUI = target:GetSceneUI()
      if sceneUI then
        sceneUI.roleTopUI:Speak(msg, target, true)
      end
    end
    if self.random_talk_runstate.curT >= self.random_talk_runstate.times then
      if self.random_talk_runstate.infinite then
        self.random_talk_runstate.curT = 0
      else
        if self.random_talk_runstate then
          ReusableTable.DestroyTable(self.random_talk_runstate)
          self.random_talk_runstate = nil
        end
        return true
      end
    end
  end
end
function PlotStoryTimelineProcess:start_manual_move(params)
  local pos = params.pos
  if not pos then
    self:ErrorLog_Plot()
    return true
  end
  local move_action_name = params.custom_move_action and Table_ActionAnime[params.custom_move_action]
  move_action_name = move_action_name and move_action_name.Name
  local idle_action_name = params.custom_idle_action and Table_ActionAnime[params.custom_idle_action]
  idle_action_name = idle_action_name and idle_action_name.Name
  local targets = self:_getTargetByParams(params)
  local target = targets[1]
  if params.spd or params.spdFactor then
    local roleData = target and target.data
    if roleData then
      local moveSpdProp = roleData.props:GetPropByName("MoveSpd")
      local newSpd = (params.spd or moveSpdProp:GetValue()) * (params.spdFactor or 1)
      target:Client_SetMoveSpeed(newSpd)
    end
  end
  if params.actionSpd then
    target:Logic_SetMoveActionSpeed(params.actionSpd)
  end
  Game.PlotStoryManager:StartManualMove(target, pos, move_action_name, idle_action_name, params.showGuide)
  return true
end
function PlotStoryTimelineProcess:end_manual_move(params)
  local targets = self:_getTargetByParams(params)
  local target = targets[1]
  Game.PlotStoryManager:EndManualMove(target)
  return true
end
function PlotStoryTimelineProcess:start_curve_move(params)
  local move_action_name = params.custom_move_action and Table_ActionAnime[params.custom_move_action]
  move_action_name = move_action_name and move_action_name.Name
  local targets = self:_getTargetByParams(params)
  for i = 1, #targets do
    local target = targets[i]
    if Game.PlotStoryManager.inPQTL then
      if params.actionSpd then
        target:Logic_SetMoveActionSpeed(params.actionSpd)
      end
    elseif params.actionSpd then
      Game.PlotStoryManager:SetRoleMoveActionSpd(target, params.actionSpd)
    end
    target:Client_SetIsMoveToWorking(true, move_action_name)
    target:Client_PlayActionMove(move_action_name, nil, true)
  end
  self.curveMoveTargets[params.pqtl_id] = targets
  return true
end
function PlotStoryTimelineProcess:end_curve_move(params)
  local targets = self.curveMoveTargets[params.pqtl_id]
  if targets then
    for i = 1, #targets do
      local target = targets[i]
      target:Client_SetIsMoveToWorking(false)
      target:Client_PlayActionIdle()
    end
    self.curveMoveTargets[params.pqtl_id] = nil
  end
  return true
end
function PlotStoryTimelineProcess:add_credits(params)
  GameFacade.Instance:sendNotification(PlotStoryViewEvent.AddCredits, params)
  return true
end
function PlotStoryTimelineProcess:add_image(params)
  GameFacade.Instance:sendNotification(PlotStoryViewEvent.AddEDImage, params)
  return true
end
function PlotStoryTimelineProcess:play_ed_video(params)
  GameFacade.Instance:sendNotification(PlotStoryViewEvent.PlayEDVideo, params)
  return true
end
function PlotStoryTimelineProcess:move(params)
  local pos = params.pos
  if not pos then
    self:ErrorLog_Plot()
    return true
  end
  if self.typeFuncResult[params.pqtl_id] == ResultState.WAIT then
    return false
  end
  if self.typeFuncResult[params.pqtl_id] == ResultState.SUCCESS then
    self.typeFuncResult[params.pqtl_id] = nil
    return true
  end
  self.typeFuncResult[params.pqtl_id] = ResultState.WAIT
  local moveEndCall = function(owner)
    self.typeFuncResult[params.pqtl_id] = ResultState.SUCCESS
  end
  params.moveEndCall = moveEndCall
  PlotStoryTimelineProcess.super.move(self, params)
  return false
end
function PlotStoryTimelineProcess:start_continually_dialog(params)
  self.typeFuncResult[params.pqtl_id] = ResultState.WAIT
  local viewName = "DialogView"
  if params.isExtendDialog then
    viewName = "ExtendDialogView"
  end
  local viewdata = {
    viewname = viewName,
    dialoglist = params.dialog,
    keepOpen = params.keepOpen,
    viewdata = {
      reEntnerNotDestory = params.reEnter
    }
  }
  function viewdata.callback(owner)
    owner.typeFuncResult[params.pqtl_id] = ResultState.SUCCESS
  end
  viewdata.callbackData = self
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
  if params.roleSpeak then
    self:_dialog_roleSpeak(params)
  end
  return true
end
function PlotStoryTimelineProcess:end_contiunally_dialog(params)
  if self.typeFuncResult[params.pqtl_id] == ResultState.WAIT then
    return false
  end
  if self.typeFuncResult[params.pqtl_id] == ResultState.SUCCESS then
    self.typeFuncResult[params.pqtl_id] = nil
  end
  return true
end
function PlotStoryTimelineProcess:BreakRepetition(toCoda)
  if PQTL_Manager.Instance:LuaCtrl_PQTL_ContainsCoda(self.plotid) then
    self.fixedDuration = nil
    self.st_BreakRepetition = true
    PQTL_Manager.Instance:LuaCtrl_PQTL_BreakRepetition(self.plotid, toCoda or false)
  end
end
function PlotStoryTimelineProcess:StopFreeProgress()
  if PQTL_Manager.Instance:LuaCtrl_PQTL_ContainsCoda(self.plotid) then
    self:BreakRepetition(true)
  else
    self:ShutDown()
  end
end
function PlotStoryTimelineProcess:ProcessPreload(caster, trigger_type, action_type, param)
  if self["PRELOAD_" .. action_type] then
    self["PRELOAD_" .. action_type](self, param)
  end
end
function PlotStoryTimelineProcess:PRELOAD_play_effect(params)
  Asset_Effect.PreloadToPool(params.path)
end
function PlotStoryTimelineProcess:PRELOAD_play_effect_scene(params)
  Asset_Effect.PreloadToPool(params.path)
end
function PlotStoryTimelineProcess:PRELOAD_start_qte(params)
  FunctionQTE.Me():ResetQteOrderInfo()
end
function PlotStoryTimelineProcess:PRELOAD_qte_step(params)
  FunctionQTE.Me():AddQteOrderInfo(params)
end
function PlotStoryTimelineProcess:PRELOAD_qte_permanent_start(params)
  FunctionQTE.Me():AddQteOrderInfo(params)
end
local CurveMoveTargetType = {EFFECT = 1, ROLE = 2}
function PlotStoryTimelineProcess:UpdateCurvePos(caster, curvePos, targetType)
  if targetType == CurveMoveTargetType.EFFECT then
    local assetEffect = self.curveEffects[caster]
    if assetEffect and assetEffect.effectTrans then
      assetEffect.effectTrans.position = curvePos
    end
  elseif targetType == CurveMoveTargetType.ROLE then
    self:UpdateCurveMoveRole(caster, curvePos)
  end
end
function PlotStoryTimelineProcess:UpdateCurveMoveRole(caster, curvePos)
  local targets = self.curveMoveTargets[caster]
  if targets then
    for i = 1, #targets do
      local target = targets[i]
      target:Logic_NavMeshPlaceTo(curvePos)
      target.assetRole:RotateTo(curvePos)
    end
  end
end
function PlotStoryTimelineProcess:enter_photograph(params)
  if self.typeFuncResult[params.pqtl_id] == ResultState.WAIT then
    return false
  end
  if self.typeFuncResult[params.pqtl_id] == ResultState.SUCCESS then
    self.typeFuncResult[params.pqtl_id] = nil
    return true
  end
  self.typeFuncResult[params.pqtl_id] = ResultState.WAIT
  local cameraId = params.cameraId
  local useCurCameraZAndFov = params.useCurCameraFov
  local hideExitBtn = params.hideExitButton
  local callback = function(owner)
    owner.typeFuncResult[params.pqtl_id] = ResultState.SUCCESS
  end
  local callbackParam = self
  local cameraController = CameraController.singletonInstance
  local currentInfo = cameraController.currentInfo
  currentInfo.fieldOfView = cameraController.activeCamera.fieldOfView
  cameraController:PlotAct_RestoreDefault(0)
  cameraController:SetInfo(currentInfo)
  Game.PlotStoryManager:CloseUIView(PlotStoryManager.PlotStoryUIId)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.PhotographPanel,
    force = true,
    viewdata = {
      cameraId = cameraId,
      useCurCameraZAndFov = useCurCameraZAndFov,
      hideExitBtnTemp = hideExitBtn,
      callback = callback,
      callbackParam = callbackParam
    }
  })
  Game.PlotStoryManager:AddToUIMap(PanelConfig.PhotographPanel)
  return false
end
function PlotStoryTimelineProcess:quest_step(params)
  local questId = params.questId
  local questData = QuestProxy.Instance:getQuestDataByIdAndType(questId)
  if questData then
    QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
  end
  return true
end
function PlotStoryTimelineProcess:start_specific_filter(params)
  local id = params.id
  local checkContents = ReusableTable.CreateArray()
  self:_getFilterContentsByParams(params, checkContents)
  local targets = self:_getTargetByParams(params)
  for i = 1, #targets do
    local creature = targets[i]
    SceneFilterProxy.Instance:SceneFilterCheckWithContents(id, checkContents, creature)
  end
  ReusableTable.DestroyAndClearArray(checkContents)
  if not self.specificFilterMap[id] then
    self.specificFilterMap[id] = params
  end
  return true
end
function PlotStoryTimelineProcess:end_specific_filter(params)
  local id = params.id
  if self.specificFilterMap[id] then
    local checkContents = ReusableTable.CreateArray()
    self:_getFilterContentsByParams(self.specificFilterMap[id], checkContents)
    local targets = self:_getTargetByParams(self.specificFilterMap[id])
    if #checkContents > 0 then
      for i = 1, #targets do
        local creature = targets[i]
        if creature then
          SceneFilterProxy.Instance:SceneFilterUnCheckWithContents(id, checkContents, creature)
        end
      end
    end
    ReusableTable.DestroyAndClearArray(checkContents)
    self.specificFilterMap[id] = nil
  end
  return true
end
function PlotStoryTimelineProcess:_getFilterContentsByParams(params, checkContents)
  if params.bloodBar then
    checkContents[#checkContents + 1] = SceneFilterDefine.Content.BloodBar
  end
  if params.nameTitle then
    checkContents[#checkContents + 1] = SceneFilterDefine.Content.UINameTitleGuild
  end
  if params.speak then
    checkContents[#checkContents + 1] = SceneFilterDefine.Content.UIChatSkill
  end
  if params.model then
    checkContents[#checkContents + 1] = SceneFilterDefine.Content.Model
  end
  if params.emoji then
    checkContents[#checkContents + 1] = SceneFilterDefine.Content.Emoji
  end
  if params.topFrame then
    checkContents[#checkContents + 1] = SceneFilterDefine.Content.TopFrame
  end
  if params.questUI then
    checkContents[#checkContents + 1] = SceneFilterDefine.Content.QuestUI
  end
  if params.hurtNum then
    checkContents[#checkContents + 1] = SceneFilterDefine.Content.HurtNum
  end
  if params.floatRoleTop then
    checkContents[#checkContents + 1] = SceneFilterDefine.Content.FloatRoleTop
  end
  if params.petPartner then
    checkContents[#checkContents + 1] = SceneFilterDefine.Content.PetPartner
  end
  if params.peakEffect then
    checkContents[#checkContents + 1] = SceneFilterDefine.Content.PeakEffect
  end
  if params.seat then
    checkContents[#checkContents + 1] = SceneFilterDefine.Content.Seat
  end
  if params.giftSymbol then
    checkContents[#checkContents + 1] = SceneFilterDefine.Content.GiftSymbol
  end
  if params.skillEffect then
    checkContents[#checkContents + 1] = SceneFilterDefine.Content.SkillEffect
  end
  if params.luaGameObject then
    checkContents[#checkContents + 1] = SceneFilterDefine.Content.LuaGameObject
  end
end
function PlotStoryTimelineProcess:OnPlotEndCheckClaimCrossScene()
  if not self.crossSceneParams then
    return
  end
  local inTime = self.crossSceneParams.inTime or 0.1
  local mask_color = self.crossSceneParams.mask_color or 1
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.CrossSceneMaskView,
    viewdata = {inTime = inTime, color = mask_color}
  })
  FunctionChangeScene.Me():SetSceneLoadFinishActionForOnce(function()
    GameFacade.Instance:sendNotification(PlotStoryViewEvent.HideMask)
  end)
  self.crossSceneParams = nil
  if self.endCall then
    self.endCall(self.endCallParam, self:IsPlayEnd(), self)
  end
  self.endCall = nil
  self.endCallParam = nil
  return true
end
function PlotStoryTimelineProcess:dialog_branch(params)
  if self.typeFuncResult[params.pqtl_id] == ResultState.WAIT then
    return false
  end
  if self.typeFuncResult[params.pqtl_id] == ResultState.SUCCESS then
    self.typeFuncResult[params.pqtl_id] = nil
    return true
  end
  self.typeFuncResult[params.pqtl_id] = ResultState.WAIT
  Game.PlotStoryManager:EnterBranch(self.plotid)
  local viewName = "DialogView"
  if params.isExtendDialog then
    viewName = "ExtendDialogView"
  end
  local viewdata = {
    viewname = viewName,
    dialoglist = params.dialog
  }
  function viewdata.callback(questId, optionId)
    local questData = QuestProxy.Instance:getQuestDataByIdAndType(questId)
    if questData then
      QuestProxy.Instance:notifyQuestState(questData.scope, questId, optionId)
    end
  end
  viewdata.callbackData = params.questId
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
  return false
end
function PlotStoryTimelineProcess:dialog_branch_end(params)
  Game.PlotStoryManager:ExitBranch()
  return true
end
