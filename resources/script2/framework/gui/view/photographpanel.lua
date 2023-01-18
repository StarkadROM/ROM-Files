PhotographPanel = class("PhotographPanel", ContainerView)
autoImport("PhotographSingleFilterText")
autoImport("CarrierSubView")
autoImport("SceneRoleTopSymbol")
autoImport("FlyMessageView")
autoImport("LJCell")
autoImport("PpLua")
PhotographPanel.ViewType = UIViewType.FocusLayer
PhotographPanel.FOCUS_VIEW_PORT_RANGE = {
  x = {0.1, 0.9},
  y = {0.1, 0.9}
}
PhotographPanel.NEAR_FOCUS_DISTANCE = GameConfig.PhotographPanel and GameConfig.PhotographPanel.Near_Focus_Distance or 15
PhotographPanel.FAR_FOCUS_DISTANCE = GameConfig.PhotographPanel and GameConfig.PhotographPanel.Far_Focus_Distance or 40
PhotographPanel.FAR_FOCUS_SQUARE_DISTANCE = PhotographPanel.FAR_FOCUS_DISTANCE * PhotographPanel.FAR_FOCUS_DISTANCE
PhotographPanel.ChangeCompositionDuration = 0.3
PhotographPanel.taskCellRes = TaskCell
PhotographPanel.filterType = {
  Text = 1,
  Faction = 2,
  Team = 3,
  All = 4
}
PhotographPanel.TickType = {
  Zoom = 1,
  CheckFocus = 4,
  CheckIfHasFocusCreature = 3,
  CheckAnim = 5,
  UpdateAxis = 2,
  CheckMonsterShotFocus = 5
}
PhotographPanel.FocusStatus = {
  Fit = 1,
  Less = 2,
  FarMore = 3
}
PhotographPanel.filters = {
  {
    id = GameConfig.FilterType.PhotoFilter.Self
  },
  {
    id = GameConfig.FilterType.PhotoFilter.Team
  },
  {
    id = GameConfig.FilterType.PhotoFilter.Guild
  },
  {
    id = GameConfig.FilterType.PhotoFilter.PassBy
  },
  {
    id = GameConfig.FilterType.PhotoFilter.Monster
  },
  {
    id = GameConfig.FilterType.PhotoFilter.Npc
  },
  {
    id = GameConfig.FilterType.PhotoFilter.Text
  },
  {
    id = FunctionSceneFilter.AllEffectFilter,
    text = ZhString.PhotoFilter_Effect
  },
  {
    id = GameConfig.FilterType.PhotoFilter.PetTalk
  },
  {
    id = GameConfig.FilterType.PhotoFilter.HunterPet
  },
  {
    id = GameConfig.FilterType.PhotoFilter.Seat
  },
  {
    id = GameConfig.PhotographPanel.HideUI_ID,
    text = GameConfig.PhotographPanel.HideUI_Text
  }
}
local allServant = GameConfig.Servant.dialogID_Icon
local PHOTOGRAPHER_StickArea = Rect(0, 0, 1, 1)
function PhotographPanel:Init()
  self.compositionIndex = 1
  self:initView()
  self:initData()
  self:addEventListener()
  self:ImmerseInit()
end
function PhotographPanel:changeTakeTypeBtnView()
  if self.curPhotoMode == FunctionCameraEffect.PhotographMode.SELFIE and self.hasLearnTakePicSkill then
    self:Show(self.takeTypeBtn)
  else
    self:Hide(self.takeTypeBtn)
  end
end
function PhotographPanel:changeCameraDisView()
  if self.curPhotoMode == FunctionCameraEffect.PhotographMode.SELFIE and self.hasLearnChangeCameraSkill then
    self:Show(self.disScrollBar)
  else
    self:Hide(self.disScrollBar)
  end
end
function PhotographPanel:initView()
  self.debugRoot = GameObject.Find("DebugRoot(Clone)")
  self.uiRoot = GameObject.Find("UIRoot")
  self.monsterShotPage = GameObject.Find("MiniGameMonsterShotPage")
  self.carrierSubView = self:AddSubView("CarrierSubView", CarrierSubView)
  self.flyMessageView = self:AddSubView("FlyMessageView", FlyMessageView)
  local filtersBg = self:FindChild("filterContentBg"):GetComponent(UISprite)
  local langFilter = PhotographPanel.filters
  local filterCount = #langFilter
  local girdView = self:FindChild("Grid"):GetComponent(UIGrid)
  filtersBg.height = girdView.cellHeight * filterCount + 18
  self.filterGridList = UIGridListCtrl.new(girdView, PhotographSingleFilterText, "PhotographSingleFilterText")
  self.screenShotHelper = self.gameObject:GetComponent(ScreenShotHelper)
  self.filterGridList:AddEventListener(MouseEvent.MouseClick, self.filterCellClick, self)
  self.filterGridList:ResetDatas(langFilter)
  self.filterBtn = self:FindChild("filterBtn")
  self.quitBtn = self:FindChild("quitBtn")
  self.takePicBtn = self:FindChild("takePicBtn")
  self.fovScrollBar = self:FindChild("FovScrollBar")
  self.fovScrollBarCpt = self:FindGO("BackGround", self.fovScrollBar):GetComponent(UICustomScrollBar)
  self.disScrollBar = self:FindChild("DisScrollBar")
  self.disScrollBarCpt = self:FindGO("BackGround", self.disScrollBar):GetComponent(UICustomScrollBar)
  self:Hide(self.disScrollBar)
  self.turnRightBtn = self:FindChild("turnRightBtn")
  self.turnLeftBtn = self:FindChild("turnLeftBtn")
  self.focusFrame = self:FindGO("focusFrame")
  self.playRotating = self.focusFrame:GetComponent(BoxCollider)
  self.photographResult = self:FindChild("photographResult")
  self.whiteMask = self:FindChild("whiteMask")
  self.focalLen = self:FindGO("focalLen")
  self.focalLenLabel = self:FindGO("Label", self.focalLen):GetComponent(UILabel)
  self:Hide(self.focalLen)
  self.cameraDis = self:FindGO("Distance")
  self.cameraDisLabel = self:FindGO("Label", self.cameraDis):GetComponent(UILabel)
  self:Hide(self.cameraDis)
  self.boliSp = self:FindComponent("boli", UISprite)
  self:AddButtonEvent("filterBtn", nil)
  self.Anchor_LeftBottom = self:FindGO("Anchor_LeftBottom")
  self.emojiButton = self:FindGO("EmojiButton")
  FunctionUnLockFunc.Me():RegisteEnterBtnByPanelID(PanelConfig.ChatEmojiView.id, self.emojiButton)
  self.questPanel = self:FindGO("TaskQuestPanel")
  self.takeTypeBtn = self:FindGO("takeTypeBtn")
  self.callServentBtn = self:FindGO("callServentBtn")
  self.servantEmojiButton = self:FindGO("ServantEmojiButton")
  self:Hide(self.questPanel)
  self.NodeForLJ = self:FindGO("NodeForLJ")
  self.ScrollViewForLJ = self:FindGO("ScrollViewForLJ", self.NodeForLJ)
  self.ScrollViewForLJ_UIScrollView = self.ScrollViewForLJ:GetComponent(UIScrollView)
  self.CloseButtonForLJ = self:FindGO("CloseButtonForLJ", self.NodeForLJ)
  self.LJBtn = self:FindGO("LJBtn", self.NodeForLJ)
  self.LJTable = self:FindGO("LJTable", self.ScrollViewForLJ)
  self.LJTabl_UITable = self.LJTable:GetComponent(UITable)
  self.LJCtrl = UIGridListCtrl.new(self.LJTabl_UITable, LJCell, "LJCell")
  self.Background = self:FindGO("Background", self.NodeForLJ)
  self.BackgroundForClose = self:FindGO("BackgroundForClose", self.NodeForLJ)
  self.BackgroundForDrag = self:FindGO("BackgroundForDrag", self.NodeForLJ)
  self.oprForbidBg = self:FindGO("oprForbidBg")
  self.LJCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickLJCell, self)
  self:AddClickEvent(self.CloseButtonForLJ, function(go)
    self:SetLJOpen(false)
  end)
  self:AddClickEvent(self.LJBtn, function(go)
    self:SetLJOpen(not self.ScrollViewForLJ.gameObject.activeInHierarchy)
  end)
  self:AddClickEvent(self.BackgroundForClose, function(go)
    self:SetLJOpen(false)
  end)
  self:AddDragEvent(self.BackgroundForClose, function(go, delta)
    self:SetLJOpen(false)
  end)
  local groupList = Table_CameraFilters or {}
  local groupListForCamera = {}
  for k, v in pairs(groupList) do
    if v.IsInCamera == 1 then
      table.insert(groupListForCamera, v)
    end
  end
  self:SetLJOpen(true)
  self.LJTabl_UITable.columns = #groupListForCamera
  self.LJCtrl:ResetDatas(groupListForCamera)
  self.LJCtrl:Layout()
  self.LJTabl_UITable:Reposition()
  self.LJTabl_UITable.repositionNow = true
  self.ScrollViewForLJ_UIScrollView:ResetPosition()
  self:SetLJOpen(false)
  self.uiCamera = NGUIUtil:GetCameraByLayername("UI")
  self.gmCm = NGUIUtil:GetCameraByLayername("Default")
end
function PhotographPanel:ClickLJCell(cell)
  if CameraFilterProxy.Instance:IsForbidPlayerOperation() then
    MsgManager.ShowMsgByID(41458)
    return
  end
  if cell.data then
    if self.justcell ~= cell then
      if self.justcell ~= nil then
        self.justcell:SetSelect(false)
      end
      self.justcell = cell
      self.CameraForUIEffect_Camera = CameraFilterProxy.Instance:CFSetEffectAndSpEffect(cell.data.FilterName, cell.data.SpecialEffectsName)
      self.justcell:SetSelect(true)
      self.currentCameraFilterData = cell.data
    else
      local state = self.justcell:GetSelectState()
      if state then
        CameraFilterProxy.Instance:CFQuit()
        self.currentCameraFilterData = nil
      else
        self.CameraForUIEffect_Camera = CameraFilterProxy.Instance:CFSetEffectAndSpEffect(cell.data.FilterName, cell.data.SpecialEffectsName)
        self.currentCameraFilterData = cell.data
      end
      self.justcell:SetSelect(not state)
    end
  end
end
function PhotographPanel:TrySetMaunalLJ()
  local setting = FunctionCameraEffect.Me():GetManualSetting()
  local cameraFilterId = setting[4]
  if not cameraFilterId then
    return
  end
  local maunalClickCell
  local cells = self.LJCtrl:GetCells()
  for i = 1, #cells do
    if cells[i].data.id == cameraFilterId then
      maunalClickCell = cells[i]
      break
    end
  end
  if nil == maunalClickCell then
    return
  end
  self:ClickLJCell(maunalClickCell)
end
function PhotographPanel:SetLJOpen(b)
  if b and CameraFilterProxy.Instance:IsForbidPlayerOperation() then
    MsgManager.ShowMsgByID(41458)
    return
  end
  self.ScrollViewForLJ.gameObject:SetActive(b)
  self.Background.gameObject:SetActive(b)
  self.CloseButtonForLJ.gameObject:SetActive(b)
  self.BackgroundForClose.gameObject:SetActive(b)
  self.BackgroundForDrag.gameObject:SetActive(b)
end
function PhotographPanel:initData()
  FunctionCameraEffect.Me():Pause()
  self.cameraController = CameraController.Instance or CameraController.singletonInstance
  if not self.cameraController then
    if self.initTick then
      self.initTick:Destroy()
      self.initTick = nil
    end
    self.initTick = TimeTickManager.Me():CreateOnceDelayTick(100, function(owner, deltaTime)
      self:CloseSelf()
    end, self)
    return
  end
  local viewdata = self.viewdata.viewdata
  if viewdata then
    local id = viewdata.cameraId
    if id then
      printRed("PhotographPanel:from carrier cameraId:", id)
      self.cameraId = id
    end
    self.useCurCameraZAndFov = viewdata.useCurCameraZAndFov
    self.hideExitBtnTemp = viewdata.hideExitBtnTemp
    self.callback = viewdata.callback
    self.callbackParam = viewdata.callbackParam
  end
  self:checkQuest()
  local skillid = GameConfig.PhotographAdSkill.copSkill
  local skillData = Table_Skill[skillid]
  if skillData and SkillProxy.Instance:HasLearnedSkill(skillid) then
    self.hasLearnTakePicSkill = true
  end
  skillid = GameConfig.PhotographAdSkill.cgDisSkill
  skillData = Table_Skill[skillid]
  if skillData and SkillProxy.Instance:HasLearnedSkill(skillid) then
    self.hasLearnChangeCameraSkill = true
  end
  self.channelNames = ChatRoomProxy.Instance.channelNames
  Game.AreaTriggerManager:SetIgnore(true)
  self:changeTurnBtnState(false)
  self.focusSuccess = false
  self.isShowFocalLen = false
  self.hasNotifyServer = false
  self.charid = nil
  self.screenShotWidth = -1
  self.screenShotHeight = 1080
  self.textureFormat = TextureFormat.RGB24
  self.texDepth = 24
  self.antiAliasing = ScreenShot.AntiAliasing.None
  self.photoSkillId = GameConfig.NewRole.flashskill
  self.uiCm = NGUIUtil:GetCameraByLayername("UI")
  self.sceneUiCm = NGUIUtil:GetCameraByLayername("Default")
  self.takePicBtnEnabled = true
  self:Hide(self.callServentBtn)
  self:initCameraData()
  TimeTickManager.Me():CreateTick(0, 100, self.updateScrollBar, self, PhotographPanel.TickType.Zoom)
  TimeTickManager.Me():CreateTick(500, 3000, self.checkIfHasFocusCreature, self, PhotographPanel.TickType.CheckIfHasFocusCreature)
  TimeTickManager.Me():CreateTick(0, 100, self.setTargetPositionAndSymbol, self, PhotographPanel.TickType.CheckFocus)
  TimeTickManager.Me():CreateTick(0, 100, self.UpdateMonsterShotValidFocusSymbol, self, PhotographPanel.TickType.CheckMonsterShotFocus)
  self.myId = Game.Myself.data.id
  local sceneServant = NScenePetProxy.Instance.myservant
  if nil ~= sceneServant then
    self:LoadServant(sceneServant)
  end
  local _PerformanceManager = Game.PerformanceManager
  _PerformanceManager:HighLODEffect()
  _PerformanceManager:LODHigh()
  _PerformanceManager:SkinWeightHigh(true)
  self:AddOrRemoveGuideId(self.takePicBtn)
  self:AddOrRemoveGuideId(self.takePicBtn, 111)
end
function PhotographPanel:checkQuest()
  if self.viewdata.viewdata then
    self.questData = self.viewdata.viewdata.questData
    if self.questData then
      self.creatureId = self.questData.params.npc
      self.questScenicSpotID = self.questData.params.spotId
      self.oprForbid = self.questData.params.oprForbid == 1
      local tarpos = self.questData.params.tarpos
      if not self.creatureId and tarpos then
        self.questTargetPosition = LuaVector3.Zero()
        LuaVector3.Better_Set(self.questTargetPosition, tarpos[1], tarpos[2], tarpos[3])
      end
      local id = self.questData.params.cameraId
      if id then
        self.cameraId = id
      end
      if not self.oprForbid then
        self:showQuestTrace()
      else
        self:Show(self.oprForbidBg)
        TimeTickManager.Me():CreateOnceDelayTick(2000, function(self)
          self:questCellClick()
        end, self)
      end
    end
  else
    local stepType, datas, single, key = QuestDataStepType.QuestDataStepType_SELFIE_SYS, ReusableTable.CreateArray()
    if Game.MapManager:IsRaidMode() then
      local questMap = QuestProxy.Instance.fubenQuestMap
      for _, qData in pairs(questMap) do
        if qData.questDataStepType == stepType then
          TableUtility.ArrayPushBack(datas, qData)
        end
      end
    end
    local questList = QuestProxy.Instance:getQuestListByStepType(stepType)
    if questList then
      for i = 1, #questList do
        single = questList[i]
        if single.map == Game.MapManager:GetMapID() then
          TableUtility.ArrayPushBack(datas, single)
        end
      end
    end
    if #datas > 0 then
      self.specifiedTargetQuestParams, self.targetSpecifiedQuestMap = {}, {}
      for i = 1, #datas do
        single = datas[i]
        key = self:GetKeyFromSpecifiedTargetQuestData(single)
        if key then
          TableUtility.ArrayPushBack(self.specifiedTargetQuestParams, key)
          self.targetSpecifiedQuestMap[key] = single
        end
      end
      if not next(self.specifiedTargetQuestParams) then
        self.specifiedTargetQuestParams = nil
      end
      if not next(self.targetSpecifiedQuestMap) then
        self.targetSpecifiedQuestMap = nil
      end
    end
    ReusableTable.DestroyAndClearArray(datas)
  end
end
function PhotographPanel:showQuestTrace()
  self:Show(self.questPanel)
  local taskCell = self:FindGO("TaskCell")
  local taskCellObj = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("TaskQuestCell"), taskCell)
  taskCellObj.transform.localPosition = LuaGeometry.Const_V3_zero
  local questCell = TaskQuestCell.new(taskCellObj)
  questCell:AddEventListener(MouseEvent.MouseClick, self.questCellClick, self)
  questCell:SetData(self.questData)
end
function PhotographPanel:questCellClick()
  Game.InputManager.photograph:Exit()
  self:setForceRotation(true)
  if self.curPhotoMode == FunctionCameraEffect.PhotographMode.SELFIE then
    Game.InputManager.photograph:Enter(PhotographMode.SELFIE)
  else
    Game.InputManager.photograph:Enter(PhotographMode.PHOTOGRAPHER)
  end
end
function PhotographPanel:calFOVValue(zoom)
  local value = 2 * math.atan(21.635 / zoom) * 180 / math.pi
  return value
end
function PhotographPanel:calZoom(del)
  local value = 21.635 / math.tan(del / 2 / 180 * math.pi)
  return value
end
function PhotographPanel:SetCompositionIndex(index)
  self.compositionIndex = index
end
function PhotographPanel:MoveCompositionIndexToNext()
  local index = self.compositionIndex + 1
  if nil == self:GetComposition(index) then
    index = 1
  end
  MsgManager.ShowMsgByIDTable(853, tostring(index))
  self:SetCompositionIndex(index)
end
function PhotographPanel:GetComposition(index)
  index = index or self.compositionIndex
  if nil == self.cameraData or nil == self.cameraData.Composition then
    return nil
  end
  return self.cameraData.Composition[index]
end
function PhotographPanel:ApplyComposition()
  local composition = self:GetComposition()
  if nil == composition then
    return
  end
  if nil == self.cameraController then
    return
  end
  local fo = self.cameraController.targetFocusOffset
  local fvp = self.cameraController.targetFocusViewPort
  fvp.x = composition[1]
  fvp.y = composition[2]
  self.cameraController:FocusTo(fo, fvp, PhotographPanel.ChangeCompositionDuration, nil, false)
end
function PhotographPanel:initCameraData()
  self.originFovMin = nil
  self.originFovMax = nil
  self.forceRotation = LuaVector3.New()
  if not self.cameraId then
    local currentMap = SceneProxy.Instance.currentScene
    if currentMap then
      self.cameraId = Table_Map[currentMap.mapID].Camera
    end
  end
  if not self.cameraId then
    self.cameraId = 1
  end
  self.cameraData = Table_Camera[self.cameraId]
  if not self.cameraData or not self.cameraController then
    return
  end
  local manualSetting = FunctionCameraEffect.Me():GetManualSetting()
  local layer = LayerMask.NameToLayer("UI")
  if layer then
    self.uiCemera = UICamera.FindCameraForLayer(layer)
    if self.uiCemera then
      self.originUiCmTouchDragThreshold = self.uiCemera.touchDragThreshold
      self.uiCemera.touchDragThreshold = 1
    end
  end
  if not Game.UseNewVersionInput() then
    self.originInputTouchSenseInch = Game.InputManager.touchSenseInch
    Game.InputManager.touchSenseInch = 0
    Game.InputManager:ResetParams()
  end
  Game.InputManager.model = InputManager.Model.PHOTOGRAPH
  self.originNearClipPlane = self.cameraController.activeCamera.nearClipPlane
  self.originFarClipPlane = self.cameraController.activeCamera.farClipPlane
  self.cameraController.activeCamera.nearClipPlane = self.cameraData.ClippingPlanes[1]
  self.cameraController.activeCamera.farClipPlane = self.cameraData.ClippingPlanes[2]
  self.originFovMin = Game.InputManager.cameraFieldOfViewMin
  self.originFovMax = Game.InputManager.cameraFieldOfViewMax
  local minskillId = GameConfig.PhotographAdSkill.minViewPortSkill
  local maxskillId = GameConfig.PhotographAdSkill.maxViewPortSkill
  local skillData = Table_Skill[minskillId]
  if SkillProxy.Instance:HasLearnedSkill(minskillId) and skillData then
    self.fovMin = skillData.Logic_Param.minfov
    self.fovMin = self.fovMin and self.fovMin or self.cameraData.Zoom[1]
  else
    self.fovMin = self.cameraData.Zoom[1]
  end
  skillData = Table_Skill[maxskillId]
  if SkillProxy.Instance:HasLearnedSkill(maxskillId) and skillData then
    self.fovMax = skillData.Logic_Param.maxfov
    self.fovMax = self.fovMax and self.fovMax or self.cameraData.Zoom[2]
  else
    self.fovMax = self.cameraData.Zoom[2]
  end
  self.fovMinValue = self:calFOVValue(self.fovMax)
  self.fovMaxValue = self:calFOVValue(self.fovMin)
  Game.InputManager.cameraFieldOfViewMin = self.fovMinValue
  Game.InputManager.cameraFieldOfViewMax = self.fovMaxValue
  local danmaku = self.cameraData.Danmaku
  if danmaku == 1 and not GameConfig.SystemForbid.Barrage then
    self.flyMessageView:StartRecieveBarrage()
  else
    self.flyMessageView:CloseUIWidgets()
  end
  local close = self.cameraData.Close
  if close ~= 1 then
    self:Hide(self.quitBtn)
    self.forbiddenClose = true
  elseif self.hideExitBtnTemp then
    self:Hide(self.quitBtn)
  else
    self:Show(self.quitBtn)
  end
  local Emoji = self.cameraData.Emoji or 0
  local action = self.cameraData.Act or 0
  self.actEmoj = Emoji * 2 + action
  if self.actEmoj == 0 then
    self:Hide(self.emojiButton)
  end
  local switchMode = self.cameraData.SwitchMode
  local switchBtn = self:FindGO("modeSwitch")
  if switchMode ~= 1 or ApplicationInfo.IsRunOnWindowns() then
    self:Hide(switchBtn)
  else
    self:Show(switchBtn)
  end
  self:SetCompositionIndex(1)
  local pgInfo = self.cameraController.photographInfo
  if pgInfo then
    self.originFocusViewPort = pgInfo.focusViewPort
    self.originFieldOfView = pgInfo.fieldOfView
    local composition = self:GetComposition()
    local vp_z = self.cameraData.Radius
    local fieldOfView
    if self.useCurCameraZAndFov then
      vp_z = self.cameraController.focusViewPort.z
      fieldOfView = self.cameraController.activeCamera.fieldOfView
      pgInfo.fieldOfView = fieldOfView
    else
      local defaultZoom = manualSetting[3] or self.cameraData.DefaultZoom
      if defaultZoom then
        fieldOfView = self:calFOVValue(defaultZoom)
        pgInfo.fieldOfView = fieldOfView
      end
    end
    if nil ~= composition then
      pgInfo.focusViewPort = LuaGeometry.GetTempVector3(composition[1], composition[2], vp_z)
    else
      pgInfo.focusViewPort = LuaGeometry.GetTempVector3(self.originFocusViewPort.x, self.originFocusViewPort.y, vp_z)
    end
  end
  Asset_Role.ExpressionSwitch = true
  local defaultDir = manualSetting[1] or self.cameraData.DefaultDir
  if #defaultDir == 0 then
    if self.questData then
      self:setTargetPositionAndSymbol()
      self:calFOVByPos(true)
    end
  else
    LuaVector3.Better_Set(self.forceRotation, defaultDir[1], defaultDir[2], defaultDir[3])
  end
  local defaultRoleDir = self.cameraData.DefaultRoleDir
  if defaultRoleDir and #defaultRoleDir ~= 0 and not manualSetting[2] then
    local x, y, z = Game.Myself.assetRole:GetEulerAnglesXYZ()
    local cx = defaultRoleDir[1] or 0
    local cy = defaultRoleDir[2] or 0
    local cz = defaultRoleDir[3] or 0
    x = x + cx
    y = y + cy
    z = z + cz
    LuaVector3.Better_Set(self.forceRotation, 0, y, z)
  end
  if manualSetting[2] then
    Game.Myself:Client_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, manualSetting[2])
  end
  self.isNeedSaveSetting = self.cameraData.SaveSetting
  self.isNeedSaveSetting = self.isNeedSaveSetting and self.isNeedSaveSetting ~= 0 or false
  self.originStickArea = Game.InputManager.forceJoystickArea
  local StickArea = self.cameraData.StickArea
  if StickArea and #StickArea > 1 and StickArea[1] > 0 and 0 < StickArea[2] then
    self.selfieStickArea = Rect(0, 0, StickArea[1], StickArea[2])
  end
  self:TrySetMaunalLJ()
  self:TryDelayedInitCamera()
end
function PhotographPanel:TryDelayedInitCamera()
  TimeTickManager.Me():CreateOnceDelayTick(33, function(self)
    self:_InitCamera()
  end, self, 99999)
end
function PhotographPanel:_InitCamera()
  local cells = self.filterGridList:GetCells()
  local manualSetting = FunctionCameraEffect.Me():GetManualSetting()
  if self.isNeedSaveSetting and not manualSetting[5] then
    local filters = LocalSaveProxy.Instance:getPhotoFilterSetting(cells)
    for j = 1, #cells do
      local single = cells[j]
      local bFilter = filters[single.data.id]
      single:setIsSelect(bFilter)
      if not bFilter then
        self:filterCellClick(single)
      else
        self:HandleFilterClick(single)
      end
    end
  else
    self.defaultHide = manualSetting[5] or self.cameraData.DefaultHide
    if self.defaultHide and #self.defaultHide > 0 then
      for i = 1, #self.defaultHide do
        local fileterItem = self.defaultHide[i]
        for j = 1, #cells do
          local single = cells[j]
          if fileterItem == single.data.id then
            single:setIsSelect(false)
            self:filterCellClick(single)
          end
        end
      end
      for i = 1, #cells do
        self:HandleFilterClick(cells[i])
      end
    end
  end
  local defaultMode = self.cameraData.DefaultMode
  if defaultMode == FunctionCameraEffect.PhotographMode.PHOTOGRAPHER then
    self:changePhotoMode(FunctionCameraEffect.PhotographMode.PHOTOGRAPHER)
  else
    self:changePhotoMode(FunctionCameraEffect.PhotographMode.SELFIE)
    TimeTickManager.Me():CreateOnceDelayTick(1000, function(owner, deltaTime)
      self:updateDisScrollBar()
    end, self)
  end
  FunctionCameraEffect.Me():ResetCameraPushOnStatus()
end
local tempLuaQuaternion = LuaQuaternion.Identity()
function PhotographPanel:calFOVByPos(isQuest)
  local position
  if self.creatureGuid then
    local creatureObj = SceneCreatureProxy.FindCreature(self.creatureGuid)
    if creatureObj then
      local topFocusUI = creatureObj:GetSceneUI().roleTopUI.topFocusUI
      position = topFocusUI:getPosition()
    end
  elseif isQuest and self.symbol then
    position = self.symbol:getTarPosition()
  end
  if position then
    local tempVector3 = LuaGeometry.GetTempVector3(Game.Myself.assetRole:GetCPOrRootPosition(RoleDefines_CP.Hair))
    LuaVector3.Better_Sub(position, tempVector3, tempVector3)
    LuaQuaternion.Better_LookRotation(tempLuaQuaternion, tempVector3)
    LuaQuaternion.Better_GetEulerAngles(tempLuaQuaternion, tempVector3)
    LuaVector3.Better_Set(self.forceRotation, tempVector3[1], tempVector3[2], tempVector3[3])
  end
end
function PhotographPanel:resetCameraData()
  Game.InputManager.model = InputManager.Model.DEFAULT
  if nil ~= self.cameraController then
    if self.originNearClipPlane then
      self.cameraController.activeCamera.nearClipPlane = self.originNearClipPlane
      self.cameraController.activeCamera.farClipPlane = self.originFarClipPlane
    end
    if self.originFocusViewPort then
      self.cameraController.photographInfo.focusViewPort = self.originFocusViewPort
    end
    if self.originFieldOfView then
      self.cameraController.photographInfo.fieldOfView = self.originFieldOfView
    end
  end
  if self.originStickArea then
    Game.InputManager.forceJoystickArea = self.originStickArea
  end
  if self.originFovMax then
    Game.InputManager.cameraFieldOfViewMin = self.originFovMin
    Game.InputManager.cameraFieldOfViewMax = self.originFovMax
  end
  FunctionCameraEffect.Me():ResetCameraPushOnStatus()
  Asset_Role.ExpressionSwitch = false
end
function PhotographPanel:changeShowFocalLen(isShow)
  if Slua.IsNull(self.focalLen) then
    return
  end
  local value = self.fovScrollBarCpt.value
  local fieldOfView = (self.fovMax - self.fovMin) * value + self.fovMin
  fieldOfView = math.floor(fieldOfView + 0.5)
  self.focalLenLabel.text = fieldOfView .. "mm"
  if self.isShowFocalLen ~= isShow and self.focalLen then
    self.focalLen:SetActive(isShow)
    self.isShowFocalLen = isShow
    if isShow then
      if self.focalLenTick then
        self.focalLenTick:Destroy()
        self.focalLenTick = nil
      end
      self.focalLenTick = TimeTickManager.Me():CreateOnceDelayTick(1000, function(owner, deltaTime)
        self.isShowFocalLen = false
        self:Hide(self.focalLen)
      end, self)
    end
  end
end
function PhotographPanel:changeShowDisLen(isShow)
  local value = self.disScrollBarCpt.value
  local cameraDis = 7 * value + 3
  if self.currentCameraFilterData and self.currentCameraFilterData.SelfieRange and #self.currentCameraFilterData.SelfieRange == 2 then
    local min = self.currentCameraFilterData.SelfieRange[1]
    local max = self.currentCameraFilterData.SelfieRange[2]
    if cameraDis < min then
      cameraDis = min
    end
    if max < cameraDis then
      cameraDis = max
    end
    value = (cameraDis - 3) / 7
  end
  cameraDis = math.floor(cameraDis + 0.5)
  self.cameraDisLabel.text = string.format(ZhString.PhotoCameraDisTip, cameraDis)
  self.boliSp.height = 75 + value * 355
  if self.isShowcameraDisLabel ~= isShow then
    self.cameraDis:SetActive(isShow)
    self.isShowcameraDisLabel = isShow
    if isShow then
      if self.cameraDisTick then
        self.cameraDisTick:Destroy()
        self.cameraDisTick = nil
      end
      self.cameraDisTick = TimeTickManager.Me():CreateOnceDelayTick(1000, function(owner, deltaTime)
        self.isShowcameraDisLabel = false
        self:Hide(self.cameraDis)
      end, self)
    end
  end
end
function PhotographPanel:addEventListener()
  self:AddButtonEvent("quitBtn", function(go)
    self:CloseSelf()
  end)
  self:AddClickEvent(self.takePicBtn, function(go)
    if self.takePicBtnEnabled then
      self:takePic()
      self:PlayUISound(AudioMap.UI.Picture)
    else
      MsgManager.ShowMsgByID(43239)
    end
  end)
  self:AddButtonEvent("modeSwitch", function(go)
    local mode = self.curPhotoMode == FunctionCameraEffect.PhotographMode.SELFIE and FunctionCameraEffect.PhotographMode.PHOTOGRAPHER or FunctionCameraEffect.PhotographMode.SELFIE
    local isDead = Game.Myself:IsDead()
    if isDead then
      MsgManager.ShowMsgByID(2500)
      return
    end
    if mode == FunctionCameraEffect.PhotographMode.PHOTOGRAPHER and not SkillProxy.Instance:HasLearnedSkill(GameConfig.PhotographAdSkill.freeViewSkill) then
      MsgManager.ShowMsgByID(557)
      return
    end
    self:changePhotoMode(mode)
  end)
  self:AddClickEvent(self.emojiButton, function(go)
    if not self.isEmojiShow then
      self.isEmojiShow = true
      local forbidAction = self.actEmoj
      if self.actEmoj == 1 and self.curPhotoMode == FunctionCameraEffect.PhotographMode.PHOTOGRAPHER then
        forbidAction = 0
      elseif self.actEmoj == 3 and self.curPhotoMode == FunctionCameraEffect.PhotographMode.PHOTOGRAPHER then
        forbidAction = 1
      end
      self:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.ChatEmojiView,
        viewdata = {
          state = forbidAction,
          tabForbid = self.tabForbid
        }
      })
    else
      self.isEmojiShow = false
      self:sendNotification(UIEvent.CloseUI, UIViewType.ChatLayer)
    end
  end)
  self:AddClickEvent(self.takeTypeBtn, function(go)
    self:MoveCompositionIndexToNext()
    self:ApplyComposition()
  end)
  self:AddClickEvent(self.callServentBtn, function(go)
    self:TriggerServant()
  end)
  if not self.disableRotateMyself then
    self:AddPressEvent(self.focusFrame, function(obj, state)
      self:changeTurnBtnState(state)
    end)
    self:AddDragEvent(self.focusFrame, function(obj, delta)
      if Game.Myself.data:Client_GetProps(MyselfData.ClientProps.DisableRotateInPhotographMode) then
        return
      end
      local toY = Game.Myself:GetAngleY() - delta.x
      Game.Myself:Client_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, toY, true)
    end)
  end
  EventDelegate.Add(self.fovScrollBarCpt.onChange, function()
    if not self.fovScrollBarCpt or not self.fovScrollBarCpt.isDragging or self:ObjIsNil(self.cameraController) then
      return
    end
    local value = self.fovScrollBarCpt.value
    local zoom = (self.fovMax - self.fovMin) * value + self.fovMin
    local fieldOfView = self:calFOVValue(zoom)
    self.cameraController:ResetFieldOfView(fieldOfView)
    self:changeShowFocalLen(true)
  end)
  EventDelegate.Add(self.disScrollBarCpt.onChange, function()
    if self:ObjIsNil(self.cameraController) then
      return
    end
    local value = self.disScrollBarCpt.value
    local cameraDis = 7 * value + 3
    if self.currentCameraFilterData and self.currentCameraFilterData.SelfieRange and #self.currentCameraFilterData.SelfieRange == 2 then
      local min = self.currentCameraFilterData.SelfieRange[1]
      local max = self.currentCameraFilterData.SelfieRange[2]
      if cameraDis < min then
        cameraDis = min
      end
      if max < cameraDis then
        cameraDis = max
      end
      value = (cameraDis - 3) / 7
      self.disScrollBarCpt.value = value
    end
    local focusViewPort = self.cameraController.focusViewPort
    local zoom = 7 * value + 3
    local port = LuaGeometry.GetTempVector3(focusViewPort.x, focusViewPort.y, zoom)
    self.cameraController:ResetFocusViewPort(port)
    self:changeShowDisLen(true)
  end)
  self:AddClickEvent(self.servantEmojiButton, function(go)
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
      viewname = "ServantEmojiView",
      npc = self.servant,
      npcId = self.servantId
    })
  end)
  self:AddListenEvt(SceneUserEvent.SceneAddPets, self.HandleAddServant)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.HandleMapChange)
  self:AddListenEvt(MainViewEvent.EmojiViewShow, self.HandleEmojiShowSync)
end
function PhotographPanel:checkIfHasFocusCreature()
  local nearDis = GameConfig.PhotographPanel.Near_Focus_Distance_Monster or PhotographPanel.NEAR_FOCUS_DISTANCE
  local nearMonster = NSceneNpcProxy.Instance:FindNearNpcs(Game.Myself:GetPosition(), nearDis, function(npc)
    local pos = npc:GetPosition()
    local cmd = FunctionPhoto.Me():GetCmd(PhotoCommandShowGhost)
    if self:checkFocus(Game.Myself:GetPosition(), pos, nearDis) == PhotographPanel.FocusStatus.Fit then
      if cmd and SkillProxy.Instance:HasLearnedSkill(GameConfig.PhotographAdSkill.gostSkill) then
        cmd:GhostInSight(npc)
      end
      return true
    elseif cmd and SkillProxy.Instance:HasLearnedSkill(GameConfig.PhotographAdSkill.gostSkill) then
      cmd:GhostOutSight(npc)
    end
  end)
  local data = ReusableTable.CreateArray()
  for i = 1, #nearMonster do
    table.insert(data, nearMonster[i].data.id)
  end
  if #data > 0 then
    ServiceNUserProxy.Instance:CallCameraFocus(data)
    ReusableTable.DestroyArray(data)
  end
end
function PhotographPanel:getValidScenery(scenicSpotID)
  local scenicSpot
  if scenicSpotID then
    scenicSpot = FunctionScenicSpot.Me():GetScenicSpot(scenicSpotID)
    if scenicSpot then
      local camera = self.cameraController.activeCamera
      local viewport = camera:WorldToViewportPoint(scenicSpot.position)
      if not (0 < viewport.x) or not (viewport.x < 1) or not (0 < viewport.y) or not (1 > viewport.y) or not (camera.nearClipPlane < viewport.z) or not (camera.farClipPlane > viewport.z) then
      end
    end
  else
    local cameraPos = self.cameraController.activeCamera.transform.position
    scenicSpot = FunctionScenicSpot.Me():GetNearestScenicSpot(cameraPos, self.cameraController.activeCamera)
  end
  if scenicSpot then
    self.charid = scenicSpot.guid
    local result = self:checkFocus(Game.Myself:GetPosition(), scenicSpot.position)
    if result ~= PhotographPanel.FocusStatus.FarMore then
      return scenicSpot
    end
  end
end
function PhotographPanel:getValidCreature()
  local creatureObj = NSceneNpcProxy.Instance:FindNearestNpc(Game.Myself:GetPosition(), self.creatureId)
  if creatureObj then
    local result = self:checkFocus(Game.Myself:GetPosition(), creatureObj:GetPosition())
    if result ~= PhotographPanel.FocusStatus.FarMore then
      return creatureObj
    end
  end
end
function PhotographPanel:removeCreatureTopFocusUI()
  if self.creatureGuid then
    local creatureObj = SceneCreatureProxy.FindCreature(self.creatureGuid)
    if creatureObj then
      creatureObj:GetSceneUI().roleTopUI:DestroyTopFocusUI()
      self:ClearFocusStatus()
    end
  end
  self.creatureGuid = nil
end
function PhotographPanel:removeSceneFocusUI()
  if not self.symbol then
    return
  end
  if self.symbol:Alive() then
    ReusableObject.Destroy(self.symbol)
    self:ClearFocusStatus()
  end
  self.symbol = nil
end
function PhotographPanel:removeSpecifiedTargetFocusUI()
  if not self.specifiedTargetTopFocusUIMap then
    return
  end
  local creatureObj
  for param, focusUi in pairs(self.specifiedTargetTopFocusUIMap) do
    if type(param) == "number" then
      creatureObj = SceneCreatureProxy.FindCreature(param)
      if creatureObj then
        creatureObj:GetSceneUI().roleTopUI:DestroyTopFocusUI()
        self:ClearFocusStatus(param)
      end
    elseif focusUi:Alive() then
      ReusableObject.Destroy(focusUi)
      self:ClearFocusStatus(param)
    end
  end
  self.specifiedTargetTopFocusUIMap = nil
end
local topFocusUIData = {}
function PhotographPanel:setTargetPositionAndSymbol()
  local symbol
  if self.creatureId then
    local creatureObj
    if self.creatureGuid then
      creatureObj = SceneCreatureProxy.FindCreature(self.creatureGuid)
      if creatureObj then
        local result = self:checkFocus(Game.Myself:GetPosition(), creatureObj:GetPosition())
        if result == PhotographPanel.FocusStatus.FarMore then
          local validCreatureObj = self:getValidCreature()
          if validCreatureObj then
            self:removeCreatureTopFocusUI()
            self.creatureGuid = validCreatureObj.data.id
            symbol = validCreatureObj:GetSceneUI().roleTopUI:createOrGetTopFocusUI()
          else
            symbol = creatureObj:GetSceneUI().roleTopUI.topFocusUI
          end
        else
          symbol = creatureObj:GetSceneUI().roleTopUI.topFocusUI
        end
      else
        self:removeCreatureTopFocusUI()
        creatureObj = self:getValidCreature()
        if creatureObj then
          self.creatureGuid = creatureObj.data.id
          symbol = creatureObj:GetSceneUI().roleTopUI:createOrGetTopFocusUI()
        end
      end
    else
      creatureObj = self:getValidCreature()
      if creatureObj then
        self.creatureGuid = creatureObj.data.id
        symbol = creatureObj:GetSceneUI().roleTopUI:createOrGetTopFocusUI()
      end
    end
  elseif self.questTargetPosition then
    local result = self:checkFocus(Game.Myself:GetPosition(), self.questTargetPosition)
    if result ~= PhotographPanel.FocusStatus.FarMore then
      if not self.symbol then
        TableUtility.ArrayClear(topFocusUIData)
        topFocusUIData[1] = SceneTopFocusUI.FocusType.SceneObject
        self.symbol = SceneTopFocusUI.CreateAsArray(topFocusUIData)
      end
      self.symbol:reSetFollowPos(self.questTargetPosition)
    end
  elseif self.questScenicSpotID then
    local scenicSpot = self:getValidScenery(self.questScenicSpotID)
    if scenicSpot then
      local pos = scenicSpot.position
      if not self.symbol then
        TableUtility.ArrayClear(topFocusUIData)
        topFocusUIData[1] = SceneTopFocusUI.FocusType.SceneObject
        self.symbol = SceneTopFocusUI.CreateAsArray(topFocusUIData)
      end
      self.scenicSpotID = scenicSpot.ID
      self.symbol:reSetFollowPos(pos)
    end
  elseif self.specifiedTargetQuestParams then
    self:setSpecifiedTargetPositionAndSymbol()
    return
  end
  if not symbol then
    local scenicSpot = self:getValidScenery()
    if not self.symbol then
      if scenicSpot then
        local pos = scenicSpot.position
        TableUtility.ArrayClear(topFocusUIData)
        topFocusUIData[1] = SceneTopFocusUI.FocusType.SceneObject
        self.symbol = SceneTopFocusUI.CreateAsArray(topFocusUIData)
        self.symbol:reSetFollowPos(pos)
        self.scenicSpotID = scenicSpot.ID
        symbol = self.symbol
        LogUtility.InfoFormat("creat 1 x:{0},y:{1},z:{2}", pos.x, pos.y, pos.z)
      end
    else
      if not self.questScenicSpotID and not self.questTargetPosition then
        local pos = self.symbol:getPosition()
        if scenicSpot and not pos:Equal(scenicSpot.position) then
          local oldResult = self:checkFocus(Game.Myself:GetPosition(), pos)
          local newResult = self:checkFocus(Game.Myself:GetPosition(), scenicSpot.position)
          if oldResult == PhotographPanel.FocusStatus.FarMore then
            pos = scenicSpot.position
            self.symbol:reSetFollowPos(pos)
            self.scenicSpotID = scenicSpot.ID
          elseif oldResult ~= PhotographPanel.FocusStatus.Fit and newResult ~= PhotographPanel.FocusStatus.FarMore then
            pos = scenicSpot.position
            self.symbol:reSetFollowPos(pos)
            self.scenicSpotID = scenicSpot.ID
          elseif self.scenicSpotID == scenicSpot.ID then
            pos = scenicSpot.position
            self.symbol:reSetFollowPos(pos)
          end
        elseif not scenicSpot then
          self:removeSceneFocusUI()
          self.scenicSpotID = nil
        end
      end
      symbol = self.symbol
    end
  end
  if symbol then
    local status = self:changeFocusStatus(symbol)
    self.focusSuccess = status == PhotographPanel.FocusStatus.Fit
  end
end
function PhotographPanel:setSpecifiedTargetPositionAndSymbol()
  self.specifiedTargetTopFocusUIMap = self.specifiedTargetTopFocusUIMap or {}
  local nearDis = GameConfig.PhotographPanel.Near_Focus_Distance_Monster or PhotographPanel.NEAR_FOCUS_DISTANCE
  local obj, result, pos, objs, status
  for param, focusUi in pairs(self.specifiedTargetTopFocusUIMap) do
    if type(param) == "number" then
      obj = SceneCreatureProxy.FindCreature(param)
      if obj then
        result = self:checkFocus(Game.Myself:GetPosition(), obj:GetPosition())
        if result == PhotographPanel.FocusStatus.FarMore then
          obj:GetSceneUI().roleTopUI:DestroyTopFocusUI()
          self.specifiedTargetTopFocusUIMap[param] = nil
          self:ClearFocusStatus(param)
        end
      else
        self.specifiedTargetTopFocusUIMap[param] = nil
      end
    elseif type(param) == "table" then
      pos = LuaGeometry.GetTempVector3(param[1], param[2], param[3])
      result = self:checkFocus(Game.Myself:GetPosition(), pos)
      if result == PhotographPanel.FocusStatus.FarMore then
        if focusUi:Alive() then
          ReusableObject.Destroy(focusUi)
          self:ClearFocusStatus(param)
        end
        self.specifiedTargetTopFocusUIMap[param] = nil
      else
        focusUi:reSetFollowPos(pos)
      end
    end
  end
  for _, param in pairs(self.specifiedTargetQuestParams) do
    if type(param) == "number" then
      nearDis = GameConfig.PhotographPanel.Near_Focus_Distance_Monster or PhotographPanel.NEAR_FOCUS_DISTANCE
      objs = NSceneNpcProxy.Instance:FindNearNpcs(Game.Myself:GetPosition(), nearDis, function(npc)
        return npc.data.staticData.id == param and self:checkFocus_N(npc, nearDis) == PhotographPanel.FocusStatus.Fit
      end)
      for i = 1, #objs do
        self.specifiedTargetTopFocusUIMap[objs[i].data.id] = objs[i]:GetSceneUI().roleTopUI:createOrGetTopFocusUI()
      end
    else
      if type(param) == "table" and not self.specifiedTargetTopFocusUIMap[param] then
        pos = LuaGeometry.GetTempVector3(param[1], param[2], param[3])
        result = self:checkFocus(Game.Myself:GetPosition(), pos)
        if result ~= PhotographPanel.FocusStatus.FarMore then
          TableUtility.ArrayClear(topFocusUIData)
          topFocusUIData[1] = SceneTopFocusUI.FocusType.SceneObject
          self.specifiedTargetTopFocusUIMap[param] = SceneTopFocusUI.CreateAsArray(topFocusUIData)
          self.specifiedTargetTopFocusUIMap[param]:reSetFollowPos(pos)
        end
      else
      end
    end
  end
  self.focusSuccess = false
  for param, focusUi in pairs(self.specifiedTargetTopFocusUIMap) do
    status = self:changeFocusStatus(focusUi, param)
    self.focusSuccess = self.focusSuccess or status == PhotographPanel.FocusStatus.Fit
  end
end
local tempFocusUIs = {}
function PhotographPanel:getSceneFocusUIs()
  TableUtility.ArrayClear(tempFocusUIs)
  local creatureObj
  if self.creatureGuid then
    creatureObj = SceneCreatureProxy.FindCreature(self.creatureGuid)
    if creatureObj then
      TableUtility.ArrayPushBack(tempFocusUIs, creatureObj:GetSceneUI().roleTopUI.topFocusUI)
    end
  elseif self.symbol then
    TableUtility.ArrayPushBack(tempFocusUIs, self.symbol)
  elseif self.specifiedTargetTopFocusUIMap then
    for param, focusUi in pairs(self.specifiedTargetTopFocusUIMap) do
      if type(param) == "number" then
        creatureObj = SceneCreatureProxy.FindCreature(param)
        if creatureObj then
          TableUtility.ArrayPushBack(tempFocusUIs, creatureObj:GetSceneUI().roleTopUI.topFocusUI)
        end
      else
        TableUtility.ArrayPushBack(tempFocusUIs, focusUi)
      end
    end
  end
  return tempFocusUIs
end
function PhotographPanel:checkFocus_N(creature, nearFocus)
  local result
  local playerPos = Game.Myself:GetPosition()
  local targetPosition = creature:GetPosition()
  local distance = LuaVector3.Distance_Square(playerPos, targetPosition)
  local dis = nearFocus or PhotographPanel.NEAR_FOCUS_DISTANCE
  local isFit = distance <= dis * dis
  if isFit then
    local viewportRange = PhotographPanel.FOCUS_VIEW_PORT_RANGE
    local viewport = self.sceneUiCm:WorldToViewportPoint(targetPosition)
    local isVisible = viewport.x > viewportRange.x[1] and viewport.x < viewportRange.x[2] and viewport.y > viewportRange.y[1] and viewport.y < viewportRange.y[2] and viewport.z > self.sceneUiCm.nearClipPlane and viewport.z < self.sceneUiCm.farClipPlane
    if isVisible then
      return PhotographPanel.FocusStatus.Fit
    end
    if creature.assetRole then
      local posX, posY, posZ = creature.assetRole:GetEPPosition(RoleDefines_EP.Middle)
      if posX then
        viewport = self.sceneUiCm:WorldToViewportPoint(LuaGeometry.GetTempVector3(posX, posY, posZ))
        isVisible = viewport.x > viewportRange.x[1] and viewport.x < viewportRange.x[2] and viewport.y > viewportRange.y[1] and viewport.y < viewportRange.y[2] and viewport.z > self.sceneUiCm.nearClipPlane and viewport.z < self.sceneUiCm.farClipPlane
        if isVisible then
          return PhotographPanel.FocusStatus.Fit
        end
      end
      posX, posY, posZ = creature.assetRole:GetEPPosition(RoleDefines_EP.Top)
      if posX then
        viewport = self.sceneUiCm:WorldToViewportPoint(LuaGeometry.GetTempVector3(posX, posY, posZ))
        isVisible = viewport.x > viewportRange.x[1] and viewport.x < viewportRange.x[2] and viewport.y > viewportRange.y[1] and viewport.y < viewportRange.y[2] and viewport.z > self.sceneUiCm.nearClipPlane and viewport.z < self.sceneUiCm.farClipPlane
        if isVisible then
          return PhotographPanel.FocusStatus.Fit
        end
      end
    end
    return PhotographPanel.FocusStatus.Less
  elseif distance <= PhotographPanel.FAR_FOCUS_SQUARE_DISTANCE then
    result = PhotographPanel.FocusStatus.Less
  else
    result = PhotographPanel.FocusStatus.FarMore
  end
  return result
end
function PhotographPanel:checkFocus(playerPos, targetPosition, nearFocus)
  local result
  local distance = LuaVector3.Distance_Square(playerPos, targetPosition)
  local dis = nearFocus or PhotographPanel.NEAR_FOCUS_DISTANCE
  local isFit = distance <= dis * dis
  if isFit then
    local viewport = self.sceneUiCm:WorldToViewportPoint(targetPosition)
    local viewportRange = PhotographPanel.FOCUS_VIEW_PORT_RANGE
    local isVisible = viewport.x > viewportRange.x[1] and viewport.x < viewportRange.x[2] and viewport.y > viewportRange.y[1] and viewport.y < viewportRange.y[2] and viewport.z > self.sceneUiCm.nearClipPlane and viewport.z < self.sceneUiCm.farClipPlane
    if isVisible then
      result = PhotographPanel.FocusStatus.Fit
    else
      result = PhotographPanel.FocusStatus.Less
    end
  elseif distance <= PhotographPanel.FAR_FOCUS_SQUARE_DISTANCE then
    result = PhotographPanel.FocusStatus.Less
  else
    result = PhotographPanel.FocusStatus.FarMore
  end
  return result
end
function PhotographPanel:changeFocusStatus(symbol, key)
  if not symbol then
    return
  end
  symbol:setWithinImage(self.specifiedTargetQuestParams and "photo_icon_within2")
  local status = self:checkFocus(Game.Myself:GetPosition(), symbol:getPosition())
  self.focusStatusMap = self.focusStatusMap or {}
  key = key or 0
  if self.focusStatusMap[key] ~= status then
    if status == PhotographPanel.FocusStatus.Fit then
      symbol:Show()
      symbol:playFocusAnim()
      self:setTakePicEnable(true)
    elseif status == PhotographPanel.FocusStatus.Less then
      self:setTakePicEnable(false)
      symbol:Show()
      symbol:playLostFocusAnim()
    else
      self:setTakePicEnable(false)
      symbol:Hide()
    end
    self.focusStatusMap[key] = status
  end
  return status
end
function PhotographPanel:ClearFocusStatus(key)
  key = key or 0
  if self.focusStatusMap then
    self.focusStatusMap[key] = nil
  end
end
function PhotographPanel:setTakePicEnable(isEnabled)
  if self.questData then
    self.takePicBtnEnabled = isEnabled
  end
end
function PhotographPanel:updateScrollBar()
  if self.fovScrollBarCpt.isDragging or self:ObjIsNil(self.cameraController) then
    return
  end
  if Slua.IsNull(self.fovScrollBarCpt) then
    return
  end
  local fieldOfView = self.cameraController.cameraFieldOfView
  fieldOfView = Mathf.Clamp(fieldOfView, self.fovMinValue, self.fovMaxValue)
  local fov = self:calZoom(fieldOfView)
  local sclValue = (fov - self.fovMin) / (self.fovMax - self.fovMin)
  sclValue = math.floor(sclValue * 100 + 0.5) / 100
  local barCptValue = math.floor(self.fovScrollBarCpt.value * 100 + 0.5) / 100
  if sclValue ~= barCptValue then
    self.fovScrollBarCpt.value = sclValue
    self:changeShowFocalLen(true)
  end
end
function PhotographPanel:updateDisScrollBar()
  if self.disScrollBarCpt.isDragging or self:ObjIsNil(self.cameraController) then
    return
  end
  local dis = self.cameraController.focusViewPort.z
  local sclValue = (dis - 3) / 7
  sclValue = math.floor(sclValue * 100 + 0.5) / 100
  local barCptValue = math.floor(self.disScrollBarCpt.value * 100 + 0.5) / 100
  if sclValue ~= barCptValue then
    self.disScrollBarCpt.value = sclValue
    self:changeShowDisLen(true)
  end
end
function PhotographPanel:changeTurnBtnState(visible)
  self.turnRightBtn:SetActive(visible)
  self.turnLeftBtn:SetActive(visible)
end
function PhotographPanel:OnEnter()
  FunctionPhoto.Me():Launch()
  if Game.MS_TEST or Game.MapManager:IsPVEMode_MonsterShot() then
    GameFacade.Instance:sendNotification(PVEEvent.MiniGameMonsterShot_EnterPhotoGraph)
    self.NodeForLJ:SetActive(false)
    self.Anchor_LeftBottom:SetActive(false)
  end
  local manager = Game.GameObjectManagers[Game.GameObjectType.RoomShowObject]
  if manager then
    manager:ShowAll()
  end
  local args = ReusableTable.CreateArray()
  args[1] = RandomAIManager.TriggerConditionEnum.PHOTOGRAPH
  args[2] = Game.Myself.data.id
  EventManager.Me():PassEvent(PlayerBehaviourEvent.OnEnter, args)
  ReusableTable.DestroyAndClearArray(args)
end
function PhotographPanel:OnExit(self_super)
  if self.uivisible == false then
    self:SetUIVisible(true)
  end
  FunctionPhoto.Me():ShutDown()
  TimeTickManager.Me():ClearTick(self)
  self.needCheckReady = false
  self.focusSuccess = false
  FunctionSceneFilter.Me():EndFilter(GameConfig.FilterType.PhotoFilter)
  FunctionSceneFilter.Me():EndFilter(FunctionSceneFilter.AllEffectFilter)
  if self.defaultHide then
    for i = 1, #self.defaultHide do
      local fileterItem = self.defaultHide[i]
      FunctionSceneFilter.Me():EndFilter(fileterItem)
    end
  end
  self:removeSceneFocusUI()
  self:removeCreatureTopFocusUI()
  self:removeSpecifiedTargetFocusUI()
  self:ClearMonsterShotValidFocusSymbol()
  if self.cameraAxisY then
    Game.Myself:Client_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, self.cameraAxisY)
  end
  Game.AreaTriggerManager:SetIgnore(false)
  self:sendNotification(UIEvent.CloseUI, UIViewType.ChatLayer)
  ServiceNUserProxy.Instance:CallStateChange(ProtoCommon_pb.ECREATURESTATUS_MIN)
  if self_super then
    self_super.super.OnExit(self)
  else
    self.super.OnExit(self)
  end
  FunctionCameraEffect.Me():Resume()
  self:resetCameraData()
  FunctionBarrage.Me():ShutDown()
  local manualSetting = FunctionCameraEffect.Me():GetManualSetting()
  if self.isNeedSaveSetting and not manualSetting[5] then
    local cells = self.filterGridList:GetCells()
    local list = ReusableTable.CreateTable()
    for j = 1, #cells do
      local single = cells[j]
      local data = {}
      data.id = single.data.id
      data.isSelect = single:getIsSelect()
      table.insert(list, data)
    end
    LocalSaveProxy.Instance:savePhotoFilterSetting(list)
    ReusableTable.DestroyAndClearTable(list)
  end
  if self.questData and not self.hasNotifyServer then
    local cmd = Game.AreaTrigger_Mission
    if cmd then
      cmd:ForceReCheck(self.questData.id)
    end
    printRed("self.questData and not self.hasNotifyServe")
  end
  if self.specifiedTargetSuccessParamMap then
    local qData
    for param, _ in pairs(self.specifiedTargetSuccessParamMap) do
      qData = self.targetSpecifiedQuestMap[param]
      if qData then
        ServiceQuestProxy.Instance:CallRunQuestStep(qData.id)
      end
    end
  end
  if self.uiCemera then
    self.uiCemera.touchDragThreshold = self.originUiCmTouchDragThreshold
  end
  if not Game.UseNewVersionInput() and self.originInputTouchSenseInch then
    Game.InputManager.touchSenseInch = self.originInputTouchSenseInch
    Game.InputManager:ResetParams()
  end
  if self.servantEffect then
    self.servantEffect:Destroy()
    self.servantEffect = nil
  end
  self:CancelLeanTween()
  self.fovScrollBarCpt = nil
  self.disScrollBarCpt = nil
  CameraFilterProxy.Instance:CFQuit()
  local _PerformanceManager = Game.PerformanceManager
  _PerformanceManager:ResetLODEffect()
  _PerformanceManager:ResetLOD()
  _PerformanceManager:SkinWeightHigh(false)
  local manager = Game.GameObjectManagers[Game.GameObjectType.RoomShowObject]
  if manager then
    manager:HideAll()
  end
  local args = ReusableTable.CreateArray()
  args[1] = RandomAIManager.TriggerConditionEnum.PHOTOGRAPH
  args[2] = Game.Myself.data.id
  EventManager.Me():PassEvent(PlayerBehaviourEvent.OnExit, args)
  ReusableTable.DestroyAndClearArray(args)
  self:ImmerseDispose()
  if self.callback then
    self.callback(self.callbackParam)
    self.callback = nil
  end
end
function PhotographPanel:filterCellClick(obj)
  local isSelect = obj:getIsSelect()
  local id = obj.data.id
  if id == GameConfig.PhotographPanel.HideUI_ID then
    self:ImmerseToggle(isSelect)
    return
  end
  if not isSelect then
    FunctionSceneFilter.Me():StartFilter(id)
    if (id == GameConfig.FilterType.PhotoFilter.Guild or id == GameConfig.FilterType.PhotoFilter.Team) and FunctionSceneFilter.Me():IsFilterBy(GameConfig.FilterType.PhotoFilter.Guild) and FunctionSceneFilter.Me():IsFilterBy(GameConfig.FilterType.PhotoFilter.Team) then
      FunctionSceneFilter.Me():StartFilter(GameConfig.FilterType.PhotoFilter.TeamAndGuild)
    end
  else
    self:HandleFilterClick(obj)
    FunctionSceneFilter.Me():EndFilter(id)
    if id == GameConfig.FilterType.PhotoFilter.Guild or id == GameConfig.FilterType.PhotoFilter.Team then
      FunctionSceneFilter.Me():EndFilter(GameConfig.FilterType.PhotoFilter.TeamAndGuild)
    end
  end
end
local DisplayDuration = 60
function PhotographPanel:HandleFilterClick(cell)
  local isSelect = cell:getIsSelect()
  if isSelect then
    local id = cell.data.id
    if id == GameConfig.FilterType.PhotoFilter.Seat and not Game.Myself:IsOnSceneSeat() and not Game.InteractNpcManager:IsMyselfOnNpc() then
      local skillid = SceneSeatManager.SkillID
      if SkillProxy.Instance:HasLearnedSkill(skillid) then
        Game.SceneSeatManager:Display(DisplayDuration)
      end
    end
  end
end
function PhotographPanel:setPhotoResultVisible(state)
  self.photographResult:SetActive(state)
end
function PhotographPanel:preTakePic()
  local symbols = self:getSceneFocusUIs()
  for _, symbol in pairs(symbols) do
    symbol:Hide()
  end
  local nearDis = GameConfig.PhotographPanel.Near_Focus_Distance_Monster or PhotographPanel.NEAR_FOCUS_DISTANCE
  local nearMonster_ref = NSceneNpcProxy.Instance:FindNearNpcs(Game.Myself:GetPosition(), nearDis, function(npc)
    return self:checkFocus_N(npc, nearDis) == PhotographPanel.FocusStatus.Fit
  end)
  local nearMonster = {}
  for i = 1, #nearMonster_ref do
    nearMonster[i] = nearMonster_ref[i]
    table.insert(nearMonster, nearMonster_ref[i])
  end
  local nearPlayers = NSceneUserProxy.Instance:FindNearUsers(Game.Myself:GetPosition(), nearDis, function(npc)
    if self:checkFocus_N(npc, nearDis) == PhotographPanel.FocusStatus.Fit then
      return true
    end
  end)
  if self:checkFocus_N(Game.Myself, nearDis) == PhotographPanel.FocusStatus.Fit then
    nearPlayers[#nearPlayers + 1] = Game.Myself
  end
  local phaseData = SkillPhaseData.Create(self.photoSkillId)
  for i = 1, #nearMonster do
    phaseData:AddTarget(nearMonster[i].data.id, 1, 1)
  end
  for i = 1, #nearPlayers do
    phaseData:AddTarget(nearPlayers[i].data.id, 1, 1)
  end
  self.sceneries = self:checkCombineScenery(nearPlayers)
  phaseData:SetSkillPhase(SkillPhase.Attack)
  Game.Myself:Client_UseSkillHandler(0, phaseData)
  phaseData:Destroy()
  phaseData = nil
  if self.curPhotoMode == FunctionCameraEffect.PhotographMode.PHOTOGRAPHER then
    ServiceNUserProxy.Instance:CallPhoto(Game.Myself.data.id)
  end
  if self.focusSuccess and self.questData and not self.hasNotifyServer then
    local questData = self.questData
    QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
    self.hasNotifyServer = true
  end
  if self.specifiedTargetQuestParams then
    local obj, v3, result
    for _, param in pairs(self.specifiedTargetQuestParams) do
      if type(param) == "number" then
        if TableUtility.ArrayFindByPredicate(nearMonster, function(npc)
          return npc.data.staticData.id == param
        end) then
          self.specifiedTargetSuccessParamMap = self.specifiedTargetSuccessParamMap or {}
          self.specifiedTargetSuccessParamMap[param] = true
        end
      else
        v3 = LuaGeometry.GetTempVector3(param[1], param[2], param[3])
        result = self:checkFocus(Game.Myself:GetPosition(), v3)
        if result ~= PhotographPanel.FocusStatus.FarMore then
          self.specifiedTargetSuccessParamMap = self.specifiedTargetSuccessParamMap or {}
          self.specifiedTargetSuccessParamMap[param] = true
        else
        end
      end
    end
  end
  self.isMiniGameMonsterShot = self:TryMiniGameMonsterShot(nearMonster)
  ResourceManager.Instance:GC()
  MyLuaSrv.Instance:LuaManualGC()
end
function PhotographPanel:TryMiniGameMonsterShot(nearMonster)
  if (Game.MS_TEST or Game.MapManager:IsPVEMode_MonsterShot()) and MiniGameProxy.Instance:IsMonsterShotRound() then
    MiniGameProxy.Instance:CheckMonsterShotResult(self.ms_nearMonster)
    GameFacade.Instance:sendNotification(PVEEvent.MiniGameMonsterShot_TakePhotoGraph)
    return true
  end
  return false
end
local nearDis = GameConfig.PhotographPanel.MiniGameMonsterShot_Distance or GameConfig.PhotographPanel.Near_Focus_Distance_Monster
function PhotographPanel:checkNsetFunc(npc)
  local symbol = npc:GetSceneUI().roleTopUI:createOrGetTopFocusUI()
  if self:checkFocus_N(npc, nearDis) == PhotographPanel.FocusStatus.Fit and NpcMonsterUtility.IsMonsterByData(npc.data.staticData) then
    symbol:Show()
    symbol:PlayFocusAnimOnceLite()
    return true
  else
    symbol:Hide()
  end
end
function PhotographPanel:UpdateMonsterShotValidFocusSymbol()
  if (Game.MS_TEST or Game.MapManager:IsPVEMode_MonsterShot()) and MiniGameProxy.Instance:IsMonsterShotRound() then
    if self.ms_nearMonster then
      for i = 1, #self.ms_nearMonster do
        self:checkNsetFunc(self.ms_nearMonster[i])
      end
    end
    self.ms_nearMonster = NSceneNpcProxy.Instance:FindNearNpcs(Game.Myself:GetPosition(), nearDis, function(npc)
      return self:checkNsetFunc(npc)
    end)
  else
    self:ClearMonsterShotValidFocusSymbol()
  end
end
function PhotographPanel:ClearMonsterShotValidFocusSymbol()
  if self.ms_nearMonster then
    local nsui
    for i = 1, #self.ms_nearMonster do
      nsui = self.ms_nearMonster[i]:GetSceneUI()
      nsui = nsui and nsui.roleTopUI
      nsui = nsui and nsui:createOrGetTopFocusUI()
      if nsui then
        nsui:Hide()
      end
    end
  end
  self.ms_nearMonster = nil
end
function PhotographPanel:checkCombineScenery(creatures)
  if not creatures then
    return
  end
  local user_extra = GameConfig.Scenery.user_extra
  if not user_extra then
    return
  end
  local tempArray = {}
  for k, v in pairs(user_extra) do
    local bFindScenery = true
    for j = 1, #v do
      local single = v[j]
      local bFindBuff = false
      for i = 1, #creatures do
        local creature = creatures[i]
        if creature.data:HasBuffID(single) then
          bFindBuff = true
          break
        end
      end
      if not bFindBuff then
        bFindScenery = false
        break
      end
    end
    if bFindScenery then
      tempArray[#tempArray + 1] = k
    end
  end
  return tempArray
end
function PhotographPanel:doneTakePic()
  local symbols = self:getSceneFocusUIs()
  for _, symbol in pairs(symbols) do
    symbol:Show()
    if self.focusSuccess then
      symbol:playStopFocusAnim()
    end
  end
end
function PhotographPanel:takePic()
  self:preTakePic()
  local _, _, anglez = LuaGameObject.GetEulerAngles(self.gmCm.transform)
  anglez = GeometryUtils.UniformAngle(anglez)
  self.screenShotHelper:Setting(self.screenShotWidth, self.screenShotHeight, self.textureFormat, self.texDepth, self.antiAliasing)
  local viewdata = {
    charid = self.charid,
    forbiddenClose = self.forbiddenClose,
    viewname = "PhotographResultPanel",
    anglez = anglez,
    cameraData = self.cameraData,
    arg = self.focalLenLabel.text,
    scenicSpotIDs = self.sceneries,
    isMiniGameMonsterShot = self.isMiniGameMonsterShot,
    mapID = Game.MapManager:GetMapID()
  }
  self:SetUIVisible(false)
  local screenShotCallback = function(texture)
    self:SetUIVisible(true)
    viewdata.texture = texture
    if self.focusSuccess then
      viewdata.questData = self.questData
      viewdata.scenicSpotID = self.scenicSpotID
    end
    self:sendNotification(UIEvent.ShowUI, viewdata)
    self:doneTakePic()
    if self.hideExitBtnTemp then
      self:Show(self.quitBtn)
    end
  end
  if BackwardCompatibilityUtil.CompatibilityMode(64) then
    if CameraFilterProxy.Instance.HasInitCamera == true then
      self.screenShotHelper:GetScreenShot(screenShotCallback, self.gmCm, self.uiCm, PpLua.m_PpCamera, self.CameraForUIEffect_Camera)
    else
      self.screenShotHelper:GetScreenShot(screenShotCallback, self.gmCm, self.uiCm)
    end
  elseif CameraFilterProxy.Instance.HasInitCamera == true then
    self.screenShotHelper:GetScreenShotByScreenSize(screenShotCallback, self.gmCm, self.uiCm, PpLua.m_PpCamera, self.CameraForUIEffect_Camera)
  else
    self.screenShotHelper:GetScreenShotByScreenSize(screenShotCallback, self.gmCm, self.uiCm)
  end
end
function PhotographPanel:SetUIVisible(isShow)
  self.uivisible = isShow
  if self.debugRoot then
    self.debugRoot:SetActive(isShow)
  end
  local panels = self.uiRoot.transform:GetComponentsInChildren(UIPanel, true)
  for i = 1, #panels do
    panels[i].alpha = isShow and 1 or 0
  end
  if self.monsterShotPage and not Game.GameObjectUtil:ObjectIsNULL(self.monsterShotPage) then
    self.monsterShotPage:SetActive(isShow)
  end
end
function PhotographPanel:setForceRotation(isQuest)
  self:calFOVByPos(isQuest)
  if nil ~= self.forceRotation then
    Game.InputManager.photograph.useForceRotation = true
    Game.InputManager.photograph.forceRotation = self.forceRotation
  else
    Game.InputManager.photograph.useForceRotation = false
  end
end
function PhotographPanel:changePhotoMode(mode)
  if self.curPhotoMode ~= mode then
    self.curPhotoMode = mode
    self:setForceRotation()
    if self.curPhotoMode == FunctionCameraEffect.PhotographMode.SELFIE then
      if self.selfieStickArea then
        Game.InputManager.forceJoystickArea = self.selfieStickArea
      end
      Game.InputManager.photographMode = PhotographMode.SELFIE
      self.curPhotoMode = FunctionCameraEffect.PhotographMode.SELFIE
      self.playRotating.enabled = true
      TimeTickManager.Me():ClearTick(self, PhotographPanel.TickType.UpdateAxis)
      ServiceNUserProxy.Instance:CallStateChange(ProtoCommon_pb.ECREATURESTATUS_SELF_PHOTO)
      if self.cameraAxisY then
        Game.Myself:Client_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, self.cameraAxisY, true)
        self.cameraAxisY = nil
      end
      self.needCheckReady = false
      self:endFilterInSelfieMode()
      self:sendNotification(PhotographModeChangeEvent.ModeChangeEvent, self.actEmoj)
    else
      if self.selfieStickArea then
        Game.InputManager.forceJoystickArea = PHOTOGRAPHER_StickArea
      end
      Game.InputManager.photographMode = PhotographMode.PHOTOGRAPHER
      self.curPhotoMode = FunctionCameraEffect.PhotographMode.PHOTOGRAPHER
      self.playRotating.enabled = false
      self.needCheckReady = true
      ServiceNUserProxy.Instance:CallStateChange(ProtoCommon_pb.ECREATURESTATUS_PHOTO)
      local forbidAction = self.actEmoj
      if self.actEmoj == 1 and self.curPhotoMode == FunctionCameraEffect.PhotographMode.PHOTOGRAPHER then
        forbidAction = 0
      elseif self.actEmoj == 3 and self.curPhotoMode == FunctionCameraEffect.PhotographMode.PHOTOGRAPHER then
        forbidAction = 1
      end
      self:sendNotification(PhotographModeChangeEvent.ModeChangeEvent, forbidAction)
      TimeTickManager.Me():CreateTick(500, 100, self.updateCameraAxis, self, PhotographPanel.TickType.UpdateAxis)
    end
    self:changeTakeTypeBtnView()
    self:changeCameraDisView()
  end
  FunctionCameraEffect.Me():ResetCameraPushOnStatus()
end
function PhotographPanel:endFilterInSelfieMode()
  local cells = self.filterGridList:GetCells()
  for i = 1, #cells do
    local single = cells[i]
    if GameConfig.FilterType.PhotoFilter.Self == single.data.id and single:getIsSelect() then
      FunctionSceneFilter.Me():EndFilter(GameConfig.FilterType.PhotoFilter.Self)
    end
  end
end
function PhotographPanel:updateCameraAxis()
  local axisY = self.uiCm.transform.rotation.eulerAngles.y % 360
  self.cameraAxisY = self.cameraAxisY or 0
  local diff = math.abs(self.cameraAxisY - axisY)
  if diff > 5 then
    ServiceNUserProxy.Instance:CallStateChange(ProtoCommon_pb.ECREATURESTATUS_PHOTO)
    self.cameraAxisY = axisY
    Game.Myself:Client_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, self.cameraAxisY, true)
  end
  if self.needCheckReady and Game.InputManager.photograph.ready then
    self.needCheckReady = false
    FunctionSceneFilter.Me():StartFilter(GameConfig.FilterType.PhotoFilter.Self)
  end
end
function PhotographPanel:LoadServant(npc)
  self.servant = npc.assetRole
  self.servantId = npc.data.id
  self.isServantCalled = true
  self.servantEmojiButton:SetActive(true)
  self:CancelLeanTween()
  self.delayShowEffectTween = TimeTickManager.Me():CreateOnceDelayTick(200, function(owner, deltaTime)
    self:ShowServantEffect()
  end, self)
end
function PhotographPanel:TriggerServant()
  if self.isServantCalled then
    local animParams = Asset_Role.GetPlayActionParams("disappear", nil, 1)
    animParams[6] = true
    animParams[7] = function()
      ServiceNUserProxy.Instance:CallShowServantUserCmd(false)
      self:ShowServantEffect()
    end
    if self.servant then
      self.servant:PlayActionRaw(animParams, true)
    end
    self.isServantCalled = false
    self.servantEmojiButton:SetActive(false)
  else
    ServiceNUserProxy.Instance:CallShowServantUserCmd(true)
  end
end
function PhotographPanel:HandleAddServant(note)
  local npcs = note.body
  if not npcs then
    return
  end
  for _, npc in pairs(npcs) do
    if npc.data and npc.data.ownerID == self.myId and nil ~= allServant[npc.data.staticData.id] then
      self:LoadServant(npc)
      break
    end
  end
end
function PhotographPanel:ShowServantEffect()
  if self.servant then
    local servantPos = self.servant.completeTransform.localPosition
    Asset_Effect.PlayOneShotAt(EffectMap.Maps.ServantShow, LuaGeometry.GetTempVector3(servantPos.x, servantPos.y + 0.5, servantPos.z))
  end
end
function PhotographPanel:CancelLeanTween()
  if self.delayShowEffectTween then
    self.delayShowEffectTween:Destroy()
  end
  self.delayShowEffectTween = nil
  if self.delayHideNpcTween then
    self.delayHideNpcTween:Destroy()
  end
  self.delayHideNpcTween = nil
end
function PhotographPanel:HandleMapChange()
  if self.specifiedTargetQuestParams then
    self:CloseSelf()
  end
end
function PhotographPanel:CloseSelf()
  self.super.CloseSelf(self)
  if Game.MS_TEST or Game.MapManager:IsPVEMode_MonsterShot() then
    GameFacade.Instance:sendNotification(PVEEvent.MiniGameMonsterShot_ExitPhotoGraph)
  end
end
function PhotographPanel:GetKeyFromSpecifiedTargetQuestData(questData)
  return questData and (questData.params.npcid or questData.params.uniqueid or questData.params.tarpos)
end
function PhotographPanel:HandleEmojiShowSync(note)
  PhotographPanel.ImmerseModeLogicLock("UIEmojiView", note.body)
end
PhotographPanel.logicLockIM = {}
PhotographPanel.toggleIM = nil
PhotographPanel.stateIM = 0
PhotographPanel.stateDirIM = 0
PhotographPanel.waitTimeIM = 0
function PhotographPanel:ImmerseInit()
  Game.GUISystemManager:AddMonoUpdateFunction(self.ImmerseUpdate, self)
  if self.ImmerseTween == nil then
    self.ImmerseTween = {}
  end
  local tween = self.gameObject:GetComponentsInChildren(TweenAlpha, true)
  for _, v in pairs(tween) do
    v.duration = GameConfig.PhotographPanel.HideUI_AnimDuration
    v:ResetToBeginning()
    v.enabled = false
    TableUtility.ArrayPushBack(self.ImmerseTween, v)
  end
  tween = self.gameObject:GetComponentsInChildren(TweenPosition, true)
  for _, v in pairs(tween) do
    v.duration = GameConfig.PhotographPanel.HideUI_AnimDuration
    v:ResetToBeginning()
    v.enabled = false
    TableUtility.ArrayPushBack(self.ImmerseTween, v)
  end
end
function PhotographPanel:ImmerseDispose()
  Game.GUISystemManager:ClearMonoUpdateFunction(self)
  InputJoystickProcesser.ForceInivisble = false
end
function PhotographPanel:ImmerseToggle(isSelect)
  self.toggleIM = isSelect
  if self.toggleIM then
    self:ImmerseHideUI()
  end
end
function PhotographPanel:ImmerseModeCheckEnable()
  return self.toggleIM == true and #PhotographPanel.logicLockIM == 0
end
function PhotographPanel.ImmerseModeLogicLock(reason, enable)
  if enable then
    if TableUtility.ArrayFindIndex(PhotographPanel.logicLockIM, reason) == 0 then
      TableUtility.ArrayPushBack(PhotographPanel.logicLockIM, reason)
    end
  else
    TableUtility.ArrayRemove(PhotographPanel.logicLockIM, reason)
  end
end
function PhotographPanel:ImmerseHideUI()
  if not Slua.IsNull(self.gameObject) then
    LeanTween.cancel(self.gameObject)
  end
  for i = 1, #self.ImmerseTween do
    self.ImmerseTween[i].enabled = true
    self.ImmerseTween[i]:PlayForward()
  end
  local target = 1
  local duration = (target - self.stateIM) * GameConfig.PhotographPanel.HideUI_AnimDuration
  if duration > 0 then
    self.stateDirIM = 1
    LeanTween.value(self.gameObject, function(v)
      self.stateIM = v
    end, self.stateIM, target, duration):setOnComplete(function()
      self.stateIM = target
      self.stateDirIM = 0
      self:ImmerseFirstTimeHint()
    end)
  end
  InputJoystickProcesser.ForceInivisble = true
end
function PhotographPanel:ImmerseShowUI()
  if not Slua.IsNull(self.gameObject) then
    LeanTween.cancel(self.gameObject)
  end
  for i = 1, #self.ImmerseTween do
    self.ImmerseTween[i].enabled = true
    self.ImmerseTween[i]:PlayReverse()
  end
  local target = 0
  local duration = (self.stateIM - target) * GameConfig.PhotographPanel.HideUI_AnimDuration
  if duration > 0 then
    self.stateDirIM = -1
    LeanTween.value(self.gameObject, function(v)
      self.stateIM = v
    end, self.stateIM, target, duration):setOnComplete(function()
      self.stateIM = target
      self.stateDirIM = 0
    end)
  end
  InputJoystickProcesser.ForceInivisble = false
end
function PhotographPanel:ImmerseFirstTimeHint()
  if not LocalSaveProxy.Instance:GetDontShowAgain(GameConfig.PhotographPanel.HideUI_Hint_ID) then
    self.hintGO = self:FindChild("GuideRoot")
    local hintTextLb = self:FindChild("labContent"):GetComponent(UILabel)
    hintTextLb.text = Table_Sysmsg[GameConfig.PhotographPanel.HideUI_Hint_ID].Text
    self.hintGO.gameObject:SetActive(true)
    self.hintOnShow = 1
    LocalSaveProxy.Instance:AddDontShowAgain(GameConfig.PhotographPanel.HideUI_Hint_ID, 0)
  end
end
local isRunOnEditor = ApplicationInfo.IsRunOnEditor()
local isRunOnStandalone = Application.platform == RuntimePlatform.WindowsPlayer or Application.platform == RuntimePlatform.OSXPlayer
local CheckFingerOn = function()
  if isRunOnStandalone or isRunOnEditor then
    if Input.GetMouseButtonDown(0) or Input.GetMouseButton(0) or Input.GetMouseButtonUp(0) then
      return true
    end
  elseif 0 < Input.touchCount then
    return true
  end
end
local CheckFingerClick = function()
  if isRunOnStandalone or isRunOnEditor then
    if Input.GetMouseButtonDown(0) then
      return true
    end
  elseif 0 < Input.touchCount and Input.GetTouch(0).phase == TouchPhase.Began then
    return true
  end
end
PhotographPanel.lastFingerOn = nil
function PhotographPanel:CheckDoubleClick(time)
  if CheckFingerClick() then
    if self.lastFingerOn ~= nil and time <= self.lastFingerOn + GameConfig.PhotographPanel.HideUI_DoubleClickInterval then
      self.lastFingerOn = time
      return true
    end
    self.lastFingerOn = time
  end
end
function PhotographPanel:ImmerseUpdate(time, deltaTime)
  if not self:ImmerseModeCheckEnable() or self:CheckDoubleClick(time) then
    if self.hintOnShow ~= nil and self:ImmerseModeCheckEnable() then
      self.hintOnShow = nil
      self.hintGO.gameObject:SetActive(false)
    end
    if (self.stateIM ~= 0 or self.stateDirIM ~= 0) and self.stateDirIM ~= -1 then
      self.waitTimeIM = 0
      self:ImmerseShowUI()
    end
  elseif self.stateIM == 0 and self.stateDirIM == 0 then
    if CheckFingerOn() then
      self.waitTimeIM = 0
    else
      self.waitTimeIM = self.waitTimeIM + deltaTime
    end
    if self.waitTimeIM >= GameConfig.PhotographPanel.HideUI_WaitDuration then
      self:ImmerseHideUI()
    end
  end
end
