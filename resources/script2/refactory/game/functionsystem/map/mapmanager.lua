autoImport("EnviromentManager")
autoImport("AreaTriggerManager")
autoImport("DungeonManager")
autoImport("LockTargetEffectManager")
autoImport("FunctionScenicSpot")
autoImport("ClickGroundEffectManager")
autoImport("SkillWorkerManager")
autoImport("DynamicObjectManager")
autoImport("SceneSeatManager")
autoImport("QuestMiniMapEffectManager")
autoImport("PlotStoryManager")
autoImport("HandUpManager")
autoImport("PictureWallManager")
autoImport("WeddingWallPicManager")
autoImport("HomeManager")
autoImport("HomeWallPicManager")
autoImport("HotKeyManager")
autoImport("InteractNpcManager")
autoImport("PerformanceManager")
autoImport("RaidPuzzleManager")
autoImport("LightPuzzleManager")
autoImport("CookMasterManager")
autoImport("RunnerChallengeManager")
autoImport("RandomAIManager")
autoImport("TappingManager")
autoImport("FollowNpcAIManager")
autoImport("VisitNpcManager")
MapManager = class("MapManager")
MapManager.Mode = {
  PVE = 1,
  PVP = 2,
  Raid = 3
}
MapManager.EnumNoCat = {
  HideHead_Pet = 2,
  HideHead_Being = 4,
  ForbidMultiMount = 512
}
MapManager.MapRaidFeature = {
  IsRaidPuzzle = 4,
  IsLightPuzzle = 8,
  IsInPlacePuzzle = 16
}
local _RoleUGUIVisibleRange = LogicManager_MapCell.RoleUGUIVisibleRange
function MapManager:ctor()
  self.mapInfo = {
    0,
    nil,
    LuaVector3.Zero(),
    false,
    0,
    0
  }
  self.enviromentManager = EnviromentManager.new()
  self.areaTriggerManager = AreaTriggerManager.new()
  self.dungeonManager = DungeonManager.new()
  self.lockTargetEffectManager = LockTargetEffectManager.new()
  self.clickGroundManager = ClickGroundEffectManager.new()
  self.skillWorkerManager = SkillWorkerManager.new()
  self.dynamicObjectManager = DynamicObjectManager.new()
  self.sceneSeatManager = SceneSeatManager.new()
  self.questMiniMapEffectManager = QuestMiniMapEffectManager.new()
  self.plotStoryManager = PlotStoryManager.new()
  self.handUpManager = HandUpManager.new()
  self.pictureWallManager = PictureWallManager.new()
  self.weddingWallPicManager = WeddingWallPicManager.new()
  self.homeWallPicManager = HomeWallPicManager.new()
  self.scenicManager = FunctionScenicSpot.Me()
  self.hotKeyManager = HotKeyManager.new()
  self.interactNpcManager = InteractNpcManager.new()
  self.performanceManager = PerformanceManager.new()
  self.visitNpcManager = VisitNpcManager.new()
  Game.EnviromentManager = self.enviromentManager
  Game.AreaTriggerManager = self.areaTriggerManager
  Game.DungeonManager = self.dungeonManager
  Game.LockTargetEffectManager = self.lockTargetEffectManager
  Game.ClickGroundEffectManager = self.clickGroundManager
  Game.SkillWorkerManager = self.skillWorkerManager
  Game.DynamicObjectManager = self.dynamicObjectManager
  Game.SceneSeatManager = self.sceneSeatManager
  Game.QuestMiniMapEffectManager = self.questMiniMapEffectManager
  Game.PlotStoryManager = self.plotStoryManager
  Game.HandUpManager = self.handUpManager
  Game.PictureWallManager = self.pictureWallManager
  Game.WeddingWallPicManager = self.weddingWallPicManager
  Game.HomeWallPicManager = self.homeWallPicManager
  Game.HotKeyManager = self.hotKeyManager
  Game.InteractNpcManager = self.interactNpcManager
  Game.PerformanceManager = self.performanceManager
  Game.VisitNpcManager = self.visitNpcManager
  self.homeManager = HomeManager.Me()
  self.raidPuzzleManager = RaidPuzzleManager.Me()
  self:_Reset()
end
function MapManager:_Reset()
  self.sceneInfo = nil
  self.mode = nil
  self.sceneAnimation = nil
  self.sceneAnimationAnimator = nil
  self.sceneAnimationPlaying = false
  self.running = false
  self.diableInput = false
  self.sceneAnimationShutdownTime = -1
  self.afk = 0
  if self.enviromentManager then
    self.enviromentManager.ResetAmbientLight()
  end
end
function MapManager:SetInputDisable(disable)
  if self.diableInput == disable then
    return
  end
  self.diableInput = disable
  Game.InputManager.disable = disable
  LogUtility.InfoFormat("<color=yellow>SetInputDisable: </color>{0}", disable)
end
function MapManager:GetMapID()
  return self.mapInfo[1]
end
function MapManager:GetWorldID()
  local nowMapId = self.mapInfo[1]
  local staticData = Table_Map[nowMapId]
  if staticData and staticData.World then
    return staticData.World
  end
  return 1
end
function MapManager:GetRaidID()
  return self.mapInfo[6] or 0
end
function MapManager:GetMapName()
  return self.mapInfo[2]
end
function MapManager:GetPreviewed()
  return self.mapInfo[4]
end
function MapManager:GetNeedWaitCutScene()
  return self.mapInfo[9]
end
function MapManager:GetSceneID()
  return self.mapInfo[10]
end
function MapManager:SetMapName(serverData)
  if serverData.mapName and string.find(serverData.mapName, "&&") then
    local strsp = string.split(serverData.mapName, "&&")
    serverData.mapName = OverSea.LangManager.Instance():GetLangByKey(strsp[1]) .. strsp[2]
  else
    local lastNumbers = serverData.mapName and string.match(serverData.mapName, "%d+$")
    if lastNumbers then
      local mapName = serverData.mapName:gsub(lastNumbers, "")
      serverData.mapName = OverSea.LangManager.Instance():GetLangByKey(mapName) .. lastNumbers
    end
  end
  self.mapInfo[2] = serverData.mapName
end
function MapManager:SetSceneID(sceneid)
  self.mapInfo[10] = sceneid
end
function MapManager:GetCreatureMaskRange()
  return _RoleUGUIVisibleRange
end
function MapManager:GetSceneInfo()
  return self.sceneInfo
end
function MapManager:GetMode()
  return self.mode
end
function MapManager:IsPVEMode()
  return MapManager.Mode.PVE == self.mode
end
function MapManager:IsPVPMode()
  return MapManager.Mode.PVP == self.mode or self.dungeonManager:IsPVPRaidMode()
end
function MapManager:IsPVPRaidMode()
  return self.dungeonManager:IsPVPRaidMode()
end
function MapManager:CreatureHidePropInvalid()
  return self:IsPVPRaidMode() and not PvpObserveProxy.Instance:IsRunning()
end
function MapManager:IsPVPMode_GVGDetailed()
  return self.dungeonManager:IsGVG_Detailed()
end
function MapManager:IsInGVGRaid()
  return self:IsPVPMode_GVGDetailed() or self:IsGvgMode_Droiyan()
end
function MapManager:IsInGVG()
  return self:IsPVPMode_GVGDetailed() or self.dungeonManager:IsGVG_Lobby()
end
function MapManager:IsPVPMode_PoringFight()
  return self.dungeonManager:IsPVPMode_PoringFight()
end
function MapManager:IsPVPMode_MvpFight()
  return self.dungeonManager:IsPVPMode_MvpFight()
end
function MapManager:IsPVPMode_TeamPws()
  return self.dungeonManager:IsPVPMode_TeamPws()
end
function MapManager:IsPVPMode_TeamPwsExcludeOthello()
  return self.dungeonManager:IsPVPMode_TeamPwsExcludeOthello()
end
function MapManager:IsPVPMode_TeamPwsOthello()
  return self.dungeonManager:IsPVPMode_TeamPwsOthello()
end
function MapManager:IsPVPMode_TransferFight()
  return self.dungeonManager:IsPVPMode_TransferFight()
end
function MapManager:IsPveMode_PveCard()
  return self.dungeonManager:IsPveMode_PveCard()
end
function MapManager:IsPveMode_AltMan()
  return self.dungeonManager:IsPveMode_AltMan()
end
function MapManager:IsPveMode_Thanatos()
  return self.dungeonManager:IsPveMode_Thanatos()
end
function MapManager:IsGvgMode_Droiyan()
  return self.dungeonManager:IsGvgMode_Droiyan()
end
function MapManager:IsPVEMode_DemoRaid()
  return self.dungeonManager:IsPVEMode_DemoRaid()
end
function MapManager:IsTeamPwsFire()
  return self.dungeonManager:IsTeamPwsFire()
end
function MapManager:IsRaidMode(checkImageId)
  local inRaid = MapManager.Mode.Raid == self.mode
  if inRaid and checkImageId then
    local imgId = ServicePlayerProxy.Instance:GetCurMapImageId()
    local inMirrorRaid = imgId ~= nil and imgId > 0
    return not inMirrorRaid
  end
  return inRaid
end
function MapManager:IsInGuildMap()
  return self:GetMapID() == 10001
end
function MapManager:IsPVEMode_ExpRaid()
  return self.dungeonManager:IsPVEMode_ExpRaid()
end
function MapManager:IsPVEMode_HeadwearRaid()
  return self.dungeonManager:IsPVEMode_HeadwearRaid()
end
function MapManager:IsPVEMode_Roguelike()
  return self.dungeonManager:IsPVEMode_Roguelike()
end
function MapManager:IsPVEMode_MonsterShot()
  return self.dungeonManager:IsPVEMode_MonsterShot()
end
function MapManager:IsPVEMode_MonsterQA()
  return self.dungeonManager:IsPVEMode_MonsterQA()
end
function MapManager:IsPVEMode_DeadBoss()
  return self.dungeonManager:IsPVEMode_DeadBoss()
end
function MapManager:IsNoSelectTarget()
  return self.dungeonManager:IsNoSelectTarget()
end
function MapManager:IsEndlessTower()
  if self:IsRaidMode() then
    return self.dungeonManager:IsEndlessTower()
  end
  return false
end
function MapManager:IsPveMode_Arena()
  return self.dungeonManager:IsPveMode_Arena()
end
function MapManager:IsPvpMode_DesertWolf()
  return self.dungeonManager and self.dungeonManager:IsPvpMode_DesertWolf()
end
function MapManager:IsPveMode_IPRaid()
  return self.dungeonManager:IsPveMode_IPRaid()
end
function MapManager:IsPveMode_ThanksgivingRaid()
  return self.dungeonManager:IsPVEMode_ThanksgivingRaid()
end
function MapManager:IsPVeMode_EndlessTowerPrivate()
  return self.dungeonManager:IsPVEMode_EndlessTowerPrivate()
end
function MapManager:IsHomeMap(mapId)
  return (GameConfig.Home.MapDatas and GameConfig.Home.MapDatas[mapId]) ~= nil
end
function MapManager:IsNightmareMap(mapId)
  local nightmareMapCfg = GameConfig.Nightmare and GameConfig.Nightmare.EffLimitMap
  return nightmareMapCfg ~= nil and TableUtility.ArrayFindIndex(nightmareMapCfg, mapId) > 0
end
function MapManager:IsPvPMode_TeamTwelve()
  return self.dungeonManager:IsPvPMode_TeamTwelve()
end
function MapManager:IsPVEMode_ChasingScene()
  return self.dungeonManager:IsPVEMode_ChasingScene()
end
function MapManager:IsRaidPuzzle()
  return RaidPuzzleManager.Me():IsWorking()
end
function MapManager:IsPVEMode_ComodoRaid()
  return self.dungeonManager:IsPVEMode_ComodoRaid()
end
function MapManager:IsPVEMode_MultiBossRaid()
  return self.dungeonManager:IsPVEMode_MultiBossRaid()
end
function MapManager:IsPVEMode_HeartLockRaid()
  return self.dungeonManager:IsPVEMode_HeartLockRaid()
end
function MapManager:IsPVEMode_CrackRaid()
  return self.dungeonManager:IsPVEMode_CrackRaid()
end
function MapManager:MapIgnoreNoAutoAttack()
  return self:IsPVEMode_HeadwearRaid()
end
function MapManager:MapTeamNoNeedInPvpZone()
  return self:IsPVEMode_HeadwearRaid() or self:IsEndlessTower()
end
function MapManager:MapForbidLeaveButton()
  if GameConfig.School and not GameConfig.School.leave_button_forbid_raid_off then
    return self:IsMapForbid()
  end
end
function MapManager:MapForbidTeamButton()
  return self:IsMapForbid()
end
function MapManager:IsMapForbid()
  if GameConfig.School and GameConfig.School.forbid_raid then
    return TableUtility.ArrayFindIndex(GameConfig.School.forbid_raid, self:GetMapID()) > 0
  end
end
function MapManager:IsInGuildRaidMap()
  return self:GetMapID() == 7051
end
function MapManager:IsInSchoolMap()
  return self:GetMapID() == 113
end
function MapManager:IsMapRaidTypeForbid(config)
  if not config then
    return false
  end
  local mapid = self:GetMapID()
  if mapid then
    local mapRaid = Table_MapRaid[mapid]
    if mapRaid then
      for _, v in pairs(config) do
        if mapRaid.Type == v then
          return true
        end
      end
    end
  end
  return false
end
function MapManager:IsFpsCheckForbid()
  local mapid = self:GetMapID()
  if mapid then
    local mapRaid = Table_MapRaid[mapid]
    if mapRaid and (mapRaid.Type == FuBenCmd_pb.ERAIDTYPE_GUILDFIRE or mapRaid.Type == FuBenCmd_pb.ERAIDTYPE_SUPERGVG or mapRaid.Type == FuBenCmd_pb.ERAIDTYPE_MVPBATTLE) then
      return true
    end
  end
  return false
end
function MapManager:IsForbidMultiMount()
  local staticData = Table_Map[self:GetMapID()]
  local NoCat = staticData and staticData.NoCat
  return NoCat and NoCat & MapManager.EnumNoCat.ForbidMultiMount
end
function MapManager:GetBornPointArray()
  return self.sceneInfo and self.sceneInfo.bps or nil
end
function MapManager:GetExitPointArray(mapID)
  local sceneInfo = mapID and self:GetSceneInfoByMapID(mapID) or self.sceneInfo
  return sceneInfo and sceneInfo.eps or nil
end
function MapManager:GetNPCPointArray()
  return self.sceneInfo and self.sceneInfo.nps or nil
end
function MapManager:GetBornPointMap()
  return self.sceneInfo and self.sceneInfo.bpMap or nil
end
function MapManager:GetExitPointMap()
  return self.sceneInfo and self.sceneInfo.epMap or nil
end
function MapManager:GetNPCPointMap()
  return self.sceneInfo and self.sceneInfo.npMap or nil
end
function MapManager:FindBornPoint(ID)
  local map = self:GetBornPointMap()
  return map and map[ID] or nil
end
function MapManager:FindExitPoint(ID)
  local map = self:GetExitPointMap()
  return map and map[ID] or nil
end
function MapManager:FindNPCPoint(ID)
  local map = self:GetNPCPointMap()
  return map and map[ID] or nil
end
function MapManager:SetCurrentMap(serverData, force)
  local currentMapID = self.mapInfo[1]
  local currentRaidID = self.mapInfo[6]
  local mapID = serverData.mapID
  local raidID = serverData.dmapID
  if not force and currentMapID == mapID and currentRaidID == raidID then
    return
  end
  self:Shutdown()
  self.mapInfo[1] = mapID
  self.mapInfo[6] = raidID or 0
  self:ResetSceneInfo()
  if serverData.mapName and string.find(serverData.mapName, "&&") then
    local strsp = string.split(serverData.mapName, "&&")
    serverData.mapName = OverSea.LangManager.Instance():GetLangByKey(strsp[1]) .. strsp[2]
  else
    local lastNumbers = serverData.mapName and string.match(serverData.mapName, "%d+$")
    if lastNumbers then
      local mapName = serverData.mapName:gsub(lastNumbers, "")
      serverData.mapName = OverSea.LangManager.Instance():GetLangByKey(mapName) .. lastNumbers
    end
  end
  self.mapInfo[2] = serverData.mapName
  if serverData.pos ~= nil then
    ProtolUtility.Better_S2C_Vector3(serverData.pos, self.mapInfo[3])
    self.mapInfo[7] = nil
  else
    self.mapInfo[7] = true
  end
  self.mapInfo[4] = nil ~= serverData.preview and 0 ~= serverData.preview
  self.mapInfo[9] = nil ~= serverData.cutscene and false ~= serverData.cutscene
  self.mapInfo[10] = serverData.sceneid
  self.mapInfo[5] = _RoleUGUIVisibleRange
  LogUtility.InfoFormat("<color=yellow>Creature Mask Priority: </color>{0}", self.mapInfo[5])
  Game.AreaTrigger_ExitPoint:SetInvisibleEPs(serverData.invisiblexit)
  Game.Myself.data:ResetRandom()
  local curID = self:GetRaidID() or 0
  if curID == 0 then
    QuestProxy.Instance:clearFubenQuestData()
  end
  local raidInfo = Table_MapRaid[self.mapInfo[1]]
  if raidInfo and raidInfo.Feature and 0 < raidInfo.Feature & FeatureDefines_MapRaid.DefineAsCommonMap then
    self:SetInnerAreaTrigger(self.mapInfo[1])
  end
  self:RaidIDChanged()
  self:ShutdownAutoBattle(currentMapID)
end
function MapManager:SetMapIDs(serverData)
  self.mapInfo[1] = serverData.mapID
  self.mapInfo[6] = serverData.dmapID or 0
  self:RaidIDChanged()
end
function MapManager:RaidIDChanged()
  local raidID = self:GetRaidID()
  NCreature.SetForceVisible(raidID == 1900050 or raidID == 1003621)
  self:ResetSceneInfo()
end
function MapManager:ResetSceneInfo()
  local raidID = self:GetRaidID()
  local imageID = ServicePlayerProxy.Instance:GetCurMapImageId()
  local staticData
  local activeMapID = raidID
  self.isInImageMap = false
  if raidID and raidID ~= 0 then
    activeMapID = raidID
  elseif imageID and imageID ~= 0 then
    activeMapID = imageID
    self.isInImageMap = true
  else
    activeMapID = self:GetMapID()
  end
  if self.curActiveMapID == activeMapID then
    return
  end
  self.curActiveMapID = activeMapID
  staticData = Table_Map[activeMapID]
  if not staticData and self.isInImageMap then
    staticData = Table_Map[self:GetMapID()]
  end
  if not staticData then
    self.mode = MapManager.Mode.Raid
    self.sceneInfo = nil
    redlog("Map表中缺失地图ID", tostring(self.isInImageMap and self:GetMapID() or activeMapID))
    return
  end
  self.curActiveMapID = activeMapID
  local mode = staticData.Mode
  local sceneName = staticData.NameEn
  local sceneInfoName = "Scene_" .. sceneName
  local sceneInfo = autoImport(sceneInfoName)
  local scenePartInfo
  if MapManager.Mode.PVE == mode then
    LogUtility.InfoFormat("<color=yellow>Switch Map PVE: </color>{0}", mapID)
    scenePartInfo = sceneInfo.PVE
  elseif MapManager.Mode.PVP == mode then
    LogUtility.InfoFormat("<color=yellow>Switch Map PVP: </color>{0}", mapID)
    scenePartInfo = sceneInfo.PVP
  elseif MapManager.Mode.Raid == mode then
    LogUtility.InfoFormat("<color=yellow>Switch Map Raid: </color>{0}, {1}", mapID, activeMapID)
    scenePartInfo = sceneInfo.Raids[activeMapID]
  end
  if nil ~= scenePartInfo then
    Game.DoPreprocess_ScenePartInfo(scenePartInfo, sceneInfoName)
  end
  self.mode = mode
  self.sceneInfo = scenePartInfo
end
function MapManager:GetSceneInfoByMapID(mapID)
  local staticData = Table_Map[mapID]
  if not staticData then
    redlog("当前地图map表中缺失", mapID)
    return
  end
  local mode = staticData.Mode
  local sceneInfoName = "Scene_" .. staticData.NameEn
  local sceneInfo = autoImport(sceneInfoName)
  local scenePartInfo
  if MapManager.Mode.PVE == mode then
    scenePartInfo = sceneInfo.PVE
  elseif MapManager.Mode.PVP == mode then
    scenePartInfo = sceneInfo.PVP
  elseif MapManager.Mode.Raid == mode then
    local raidID, partInfo = next(sceneInfo.Raids)
    scenePartInfo = partInfo
  end
  if nil ~= scenePartInfo then
    Game.DoPreprocess_ScenePartInfo(scenePartInfo, sceneInfoName)
  end
  return scenePartInfo
end
function MapManager:SetEnviroment(enviromentID, duration)
  self.enviromentManager:SetBaseInfo(enviromentID, duration)
end
function MapManager:SetSceneAnimation(a)
  self.sceneAnimation = a
  if nil ~= a then
    self.sceneAnimationAnimator = a.animator
  else
    self.sceneAnimationAnimator = nil
  end
end
function MapManager:Previewing()
  return self.sceneAnimationPlaying
end
function MapManager:StartPreview()
  if nil ~= self.sceneAnimation and self.sceneAnimationShutdownTime < 0 then
    self.sceneAnimation:Play()
    return true
  end
  return false
end
function MapManager:StopPreview()
  if nil ~= self.sceneAnimation then
    self.sceneAnimation:Stop()
  end
end
function MapManager:SceneAnimationLaunch(animName, time)
  if self.sceneAnimationPlaying then
    return
  end
  if self.sceneAnimationAnimator == nil then
    return
  end
  if time > 0 then
    self.sceneAnimationShutdownTime = UnityTime + time
  else
    self.sceneAnimationShutdownTime = 0
  end
  local cameraController = CameraController.singletonInstance
  if cameraController ~= nil then
    GameObjectUtil.SetBehaviourEnabled(cameraController, false)
    cameraController.updateCameras = true
  end
  GameObjectUtil.SetBehaviourEnabled(self.sceneAnimationAnimator, true)
  self.sceneAnimationAnimator:Play(animName)
  Game.PerformanceManager:SkinWeightHigh(true)
end
function MapManager:SceneAnimationShutdown(noReset)
  if self.sceneAnimationShutdownTime < 0 then
    return
  end
  self.sceneAnimationShutdownTime = -1
  local cameraController = CameraController.singletonInstance
  if cameraController ~= nil then
    if not noReset then
      GameObjectUtil.SetBehaviourEnabled(cameraController, true)
    end
    cameraController.updateCameras = false
  end
  if self.sceneAnimationAnimator then
    GameObjectUtil.SetBehaviourEnabled(self.sceneAnimationAnimator, false)
  end
  Game.PerformanceManager:SkinWeightHigh(false)
end
function MapManager:OnPreviewStart()
  if self.sceneAnimationPlaying then
    return
  end
  self.sceneAnimationPlaying = true
  local cameraController = CameraController.singletonInstance
  if nil ~= cameraController then
    cameraController.updateCameras = true
  end
  FunctionCameraEffect.Me():ResetCameraPushOnStatus(false)
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
    viewname = "SceneAnimationPanel"
  })
end
function MapManager:OnPreviewStop()
  if not self.sceneAnimationPlaying then
    return
  end
  self.sceneAnimationPlaying = false
  local cameraController = CameraController.singletonInstance
  if nil ~= cameraController then
    cameraController.updateCameras = false
  end
  GameFacade.Instance:sendNotification(UIEvent.CloseUI, SceneAnimationPanel.ViewType)
  FunctionQuest.Me():CheckPlayQuestVideo()
  self:OnObSceneAnimationShutDown()
end
function MapManager:_CameraFocusMyself()
  self:UpdateCameraInstance(CameraController.singletonInstance)
  FunctionCameraEffect.Me():InitFreeCameraParam()
  Game.InputManager:SetPhotographCameraLock(SceneProxy.Instance:IsCurMapCameraLocked())
  EventManager.Me():PassEvent(PlayerEvent.CapturedCamera)
end
function MapManager:_HandleCameraEffect()
  Game.EnviromentManager:RefreshCurrentBloom()
end
function MapManager:UpdateCameraInstance(cameraController)
  if cameraController == nil then
    cameraController = CameraController.singletonInstance
  end
  if cameraController == nil then
    return
  end
  local cameraInfo = cameraController.defaultInfo
  local savedRotX, savedRotY = LocalSaveProxy.Instance:GetFreeCameraRotation()
  local freeCameraRotation = LuaGeometry.GetTempVector3(savedRotX, savedRotY, 0)
  if savedRotX == 0 and savedRotY == 0 then
    freeCameraRotation:Set(cameraInfo.rotation.x, cameraInfo.rotation.y, cameraInfo.rotation.z)
  end
  if FunctionPerformanceSetting.Me():GetCameraLocked() then
    freeCameraRotation.x = cameraInfo.rotation.x
    freeCameraRotation.y = cameraInfo.rotation.y
  elseif FunctionPerformanceSetting.Me():VerticalCameraLocked() then
    freeCameraRotation.x = FunctionCameraEffect.DefaultCameraVertAngle
  end
  local myselfTransform = Game.Myself.assetRole.completeTransform
  if nil ~= cameraInfo then
    cameraInfo.focus = myselfTransform
  end
  local freeDefaultInfo = cameraController.FreeDefaultInfo
  if nil ~= freeDefaultInfo then
    freeDefaultInfo.focus = myselfTransform
    freeDefaultInfo.rotation = freeCameraRotation
  end
  local photographInfo = cameraController.photographInfo
  if nil ~= photographInfo then
    photographInfo.focus = myselfTransform
  end
  self:UpdateCameraState(cameraController)
  local zoom = LocalSaveProxy.Instance:GetCameraZoom()
  if zoom then
    cameraController.zoom = zoom
  end
end
function MapManager:UpdateCameraState(cameraController)
  if cameraController == nil then
    return
  end
  FunctionCameraEffect.Me():ResetFreeCameraLocked(nil, true)
  FunctionCameraEffect.Me():ResetCameraPushOnStatus()
  FunctionCameraEffect.ResetFreeCameraFocusOffset(Game.Myself.assetRole, true)
  if not cameraController.IsPhotoMode and cameraController.enabled then
    cameraController:InterruptSmoothTo()
    cameraController:RestoreDefault(0, nil)
    cameraController:FieldOfViewTo(cameraController.cameraFieldOfView)
    if Game.CameraPointManager then
      Game.CameraPointManager:SendMessage("LateUpdate", SendMessageOptions.DontRequireReceiver)
      cameraController:InterruptSmoothTo()
    end
    cameraController:ForceUpdateCamera(true, false)
  end
end
function MapManager:_LaunchAfterPreview()
  self:_CameraFocusMyself()
  self:_HandleCameraEffect()
  SceneUIManager.Instance:ResetCanvasCamera()
  self:SetInputDisable(false)
  self.areaTriggerManager:Launch()
  local imgId = ServicePlayerProxy.Instance:GetCurMapImageId()
  if MapManager.Mode.Raid == self.mode or imgId and MirrorRaidConfig[imgId] then
    self.dungeonManager:Launch()
  end
  self.handUpManager:Launch()
  self.plotStoryManager:Launch(true)
  GameFacade.Instance:sendNotification(ItemEvent.ItemUpdate)
  GameFacade.Instance:sendNotification(LoadSceneEvent.SceneAnimEnd)
end
function MapManager:Launch()
  if self.running then
    helplog("MapManager:Launch : isrunning")
  end
  self.running = true
  Game.GameObjectManagers[Game.GameObjectType.Camera]:DeterminMainCamera()
  local cameraInfo = self.sceneInfo and self.sceneInfo.cameraInfo
  if nil ~= cameraInfo then
    local cameraController = CameraController.singletonInstance
    if nil ~= cameraController then
      local cameraDefaultInfo = cameraController.defaultInfo
      cameraDefaultInfo.focusOffset = cameraInfo.focusOffset
      cameraDefaultInfo.focusViewPort = cameraInfo.focusViewPort
      cameraDefaultInfo.rotation = cameraInfo.rotation
      cameraDefaultInfo.fieldOfView = cameraInfo.fieldOfView
    end
  end
  self:TrySetMirrorObjInScene()
  Game.Myself:EnterScene()
  if not self.mapInfo[7] then
    Game.Myself:Client_PlaceTo(self.mapInfo[3])
  end
  ServiceUserProxy.Instance:CheckRealInitialized()
  self.homeManager:Launch()
  self.sceneSeatManager:Launch()
  self.enviromentManager:Launch()
  self.skillWorkerManager:Launch()
  self.dynamicObjectManager:Launch()
  self.questMiniMapEffectManager:Launch()
  self.pictureWallManager:Launch()
  self.weddingWallPicManager:Launch()
  self.homeWallPicManager:Launch()
  self.hotKeyManager:Launch()
  self.interactNpcManager:Launch()
  self.performanceManager:Launch()
  self.clickGroundManager:Launch()
  Game.GameHealthProtector:EnterScene()
  BifrostProxy.Instance:LaunchBrokenCrystalTick()
  Game.LogicManager_MapCell:Launch()
  self.raidPuzzleManager:Launch()
  LightPuzzleManager.Me():Launch()
  FunctionSniperMode.Me():EnterScene()
  RunnerChallengeManager.Me():Launch()
  RandomAIManager.Me():Launch()
  TappingManager.Me():Launch()
  FollowNpcAIManager.Me():Launch()
  RunnerChallengeManager.Me():Launch()
  self.visitNpcManager:Launch()
  SgAIManager.Me():Launch()
  if MapManager.Mode.Raid == self.mode then
    self.dungeonManager:SetRaidID(self.curActiveMapID)
  end
  if self.mapInfo[4] and not self:GetNeedWaitCutScene() and self:StartPreview() then
    self:OnPreviewStart()
  else
    self:_LaunchAfterPreview()
  end
  self:ShowMapName()
  if self:IsPVPMode() then
    SkillInfo.SetMapMode(2)
  else
    SkillInfo.SetMapMode(1)
  end
end
function MapManager:ShowMapName()
  if self.mapInfo[8] and self.mapInfo[8] ~= 0 then
    return
  end
  local nowMapId = self.mapInfo[1]
  local homeMapConfig = GameConfig.Home and GameConfig.Home.MapDatas
  if homeMapConfig and homeMapConfig[nowMapId] then
    return
  end
  if self:IsPVEMode_Roguelike() or self:IsPveMode_IPRaid() then
    return
  end
  if 0 < ViewSequenceManager.Me():GetWorkingViewSequenceCount() then
    return
  end
  local mapdata = nowMapId and Table_Map[nowMapId]
  if mapdata ~= nil and mapdata.MapTips == 1 then
    FloatingPanel.Instance:ShowMapName(mapdata.NameZh, mapdata.Desc)
  end
end
function MapManager:TrySetMirrorObjInScene()
  local l_objLowLevel = GameObject.Find("Mirror_LowLevel")
  if not l_objLowLevel then
    redlog("Mirror: Cannot Find Low Level")
    return
  end
  local l_objHighLevel = GameObject.Find("Mirror_HighLevel")
  if not l_objHighLevel then
    redlog("Mirror: Cannot Find High Level")
    return
  end
  local isLowLevel = not BackwardCompatibilityUtil.CompatibilityMode_V54 or ApplicationInfo.IsIphone7P_or_Worse() or ApplicationInfo.IsIpad6_or_Worse()
  redlog("Mirror: Set Mirror Low Level", isLowLevel)
  l_objHighLevel:SetActive(isLowLevel ~= true)
  l_objLowLevel:SetActive(isLowLevel == true)
end
function MapManager:Shutdown()
  if Game.Myself then
    Game.Myself:RemoveObjsWhenLeaveScene()
  end
  if not self.running then
    return
  end
  self.running = false
  FunctionCameraEffect.Me():SaveCameraInfoToLocal()
  Game.GameObjectManagers[Game.GameObjectType.Camera]:ClearMainCamera()
  if nil ~= Camera.main then
    Camera.main.gameObject:SetActive(false)
  end
  self:SetInputDisable(true)
  Game.LogicManager_MapCell:Shutdown()
  self.homeManager:Shutdown()
  self.sceneSeatManager:Shutdown()
  self.enviromentManager:Shutdown()
  self.areaTriggerManager:Shutdown()
  self.dungeonManager:Shutdown()
  self.clickGroundManager:Shutdown()
  self.lockTargetEffectManager:ClearLockedTarget()
  self.skillWorkerManager:Shutdown()
  Game.EffectManager:ClearAllStat()
  self.dynamicObjectManager:Shutdown()
  self.questMiniMapEffectManager:Shutdown()
  self.plotStoryManager:Shutdown(nil, true)
  self.pictureWallManager:Shutdown()
  self.weddingWallPicManager:Shutdown()
  self.homeWallPicManager:Shutdown()
  self:SceneAnimationShutdown()
  self.hotKeyManager:Shutdown()
  self.interactNpcManager:Shutdown()
  self.performanceManager:Shutdown()
  FunctionSkillTargetPointLauncher.Me():Shutdown()
  Game.GameHealthProtector:LeaveScene()
  self.raidPuzzleManager:Shutdown()
  self.visitNpcManager:Shutdown()
  LightPuzzleManager.Me():Shutdown()
  FunctionSniperMode.Me():LeaveScene()
  RunnerChallengeManager.Me():Shutdown()
  RandomAIManager.Me():Shutdown()
  FunctionLocalActivity.Me():OnLeaveScene()
  FunctionShadowBricks.Me():ShutDown()
  FunctionPvpObserver.Me():OnLeaveScene()
  TappingManager.Me():Shutdown()
  FollowNpcAIManager.Me():Shutdown()
  FunctionSkill.Me():Shutdown()
  self:OnPreviewStop()
  self.sceneAnimation = nil
  self.sceneAnimationAnimator = nil
  self.sceneAnimationPlaying = false
end
function MapManager:Update(time, deltaTime)
  if not self.running then
    return
  end
  self.enviromentManager:Update(time, deltaTime)
  if self.sceneAnimationPlaying then
    if self.sceneAnimationAnimator.enabled then
      self:UpdateObClientPosition()
      return
    else
      self:OnPreviewStop()
      self:_LaunchAfterPreview()
    end
  end
  self.homeManager:Update(time, deltaTime)
  self.areaTriggerManager:Update(time, deltaTime)
  self.dungeonManager:Update(time, deltaTime)
  self.skillWorkerManager:Update(time, deltaTime)
  self.dynamicObjectManager:Update(time, deltaTime)
  self.sceneSeatManager:Update(time, deltaTime)
  self.questMiniMapEffectManager:Update(time, deltaTime)
  self.plotStoryManager:Update(time, deltaTime)
  self.handUpManager:Update(time, deltaTime)
  self.scenicManager:Update(time, deltaTime)
  self.interactNpcManager:Update(time, deltaTime)
  PaySignProxy.Instance:Update()
  self.raidPuzzleManager:Update(time, deltaTime)
  LightPuzzleManager.Me():Update(time, deltaTime)
  RunnerChallengeManager.Me():Update(time, deltaTime)
  RandomAIManager.Me():Update(time, deltaTime)
  TappingManager.Me():Update(time, deltaTime)
  self.visitNpcManager:Update(time, deltaTime)
  local btManager = Game.GameObjectManagers[Game.GameObjectType.BehaviourTree]
  if btManager then
    btManager:Update(time, deltaTime)
  end
  if self.sceneAnimationShutdownTime > 0 and time >= self.sceneAnimationShutdownTime then
    self:SceneAnimationShutdown()
  end
end
function MapManager:LateUpdate(time, deltaTime)
  if not self.running then
    return
  end
end
function MapManager:SetImageID(Imageid)
  self.mapInfo[8] = Imageid
  self:ResetSceneInfo()
  FunctionShadowBricks.Me():OnImageMapChanged()
  self.raidPuzzleManager:Launch()
  LightPuzzleManager.Me():Launch()
end
function MapManager:GetImageID()
  return self.mapInfo[8] or 0
end
function MapManager:SetInnerAreaTrigger(mapId)
  local config = Game.Config_TaskLimit
  if not config then
    return
  end
  local ids = config[mapId]
  if not ids then
    return
  end
  for i = 1, #ids do
    local single = Table_TaskLimit[ids[i]]
    if single then
      local triggerData = {}
      triggerData.id = single.id
      triggerData.type = AreaTrigger_Common_ClientType.Raid_AreaCheck
      local pos = single.pos
      local triggerPos = LuaVector3(pos[1], pos[2], pos[3])
      triggerData.pos = triggerPos
      triggerData.range = single.distance or 999
      triggerData.IO = single.type
      SceneTriggerProxy.Instance:Add(triggerData)
    end
  end
end
function MapManager:IsMapForbidInnerExitPoint(mapid)
  local config = GameConfig.ForbidMiniMapInnerEp
  if config then
    for i = 1, #config do
      if mapid == config[i] then
        return true
      end
    end
  end
  return false
end
function MapManager:NoOverStep()
  if self:IsRaidPuzzle() then
    return true
  end
  return false
end
local _roomShowObjType = Game.GameObjectType.RoomShowObject
function MapManager:LaunchObSceneAnimation()
  if self.obSceneAnimationPlaying then
    return
  end
  if nil == Camera.main then
    return
  end
  local p = Game.Myself:GetPosition()
  self.obInitPos = {
    p[1],
    p[2],
    p[3]
  }
  self.obSceneAnimationCameraTrans = Camera.main.transform
  local cameraController = CameraController.singletonInstance
  if nil ~= cameraController then
    GameObjectUtil.SetBehaviourEnabled(cameraController, false)
  end
  Game.AreaTriggerManager:SetIgnore(true)
  local manager = Game.GameObjectManagers[_roomShowObjType]
  manager:ShowAll()
  UIManagerProxy.Instance:ActiveLayer(UIViewType.FloatLayer, false)
  if self:StartPreview() then
    self:OnPreviewStart()
    self.obSceneAnimationPlaying = true
  end
end
function MapManager:UpdateObClientPosition()
  if not self.obSceneAnimationPlaying then
    return
  end
  local p = self.obSceneAnimationCameraTrans.position
  Game.Myself:Logic_NavMeshPlaceXYZTo(p.x, p.y, p.z)
end
function MapManager:OnObSceneAnimationShutDown()
  if not self.obSceneAnimationPlaying then
    return
  end
  self.obSceneAnimationPlaying = false
  local cameraController = CameraController.singletonInstance
  if nil ~= cameraController then
    GameObjectUtil.SetBehaviourEnabled(cameraController, true)
  end
  local manager = Game.GameObjectManagers[_roomShowObjType]
  manager:HideAll()
  UIManagerProxy.Instance:ActiveLayer(UIViewType.FloatLayer, true)
  Game.Myself:Logic_NavMeshPlaceTo(self.obInitPos)
  ServiceFuBenCmdProxy.Instance:CallObCameraMoveEndCmd()
  Game.AreaTriggerManager:SetIgnore(false)
end
function MapManager:ShutdownAutoBattle(lastMapId)
  local lastMapConfig = Table_MapRaid[lastMapId]
  if not lastMapConfig then
    return
  end
  local curMapId = self:GetMapID()
  local curMapConfig = Table_MapRaid[curMapId]
  if not curMapConfig then
    Game.AutoBattleManager:AutoBattleOff()
  end
end
function MapManager:IsInGVGDetailedRaid()
  if not self.dungeonManager:IsGVG_Detailed() then
    return false
  end
  local raidId = self:GetRaidID() or 0
  local staticData = Game.Config_GuildStrongHold_RaidMap[raidId]
  if not staticData then
    return false
  end
  return true
end
function MapManager:GetUniqueIdByNpc(npcId)
  local npcMap = self.sceneInfo and self.sceneInfo.npMap
  for k, v in pairs(npcMap) do
    if v.ID == npcId then
      return k
    end
  end
end
function MapManager:SetCurWorldQuestGroup()
  local id = self:GetMapID()
  if GameConfig and GameConfig.Quest and GameConfig.Quest and GameConfig.Quest.worldquestmap then
    local mapGroup = GameConfig.Quest.worldquestmap
    for k, v in pairs(mapGroup) do
      if TableUtility.ArrayFindIndex(v.map, id) > 0 then
        self.worldQuestMapGroup = k
        return
      end
    end
  end
  self.worldQuestMapGroup = nil
end
function MapManager:getCurWorldQuestGroup()
  return self.worldQuestMapGroup
end
