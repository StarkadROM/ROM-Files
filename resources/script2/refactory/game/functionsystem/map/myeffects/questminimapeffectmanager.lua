QuestMiniMapEffectManager = class("QuestMiniMapEffectManager")
local tempVector3 = LuaVector3.Zero()
local tempVector3_2 = LuaVector3.Zero()
local GuideInterval = 3.5
local GuideMaxCount = 10
local GuideEffectPath = "Common/cfx_task_guide_prf"
function QuestMiniMapEffectManager:ctor()
  self.deltaTime = 0
  self.guideTime = 0
  self.questMap = {}
  self.guideEffects = {}
  self._effectPath = EffectMap.Maps.TaskAperture
  self._effectPath2 = "Common/113TaskAperture_map"
  self.myPos = LuaVector3.Zero()
end
function QuestMiniMapEffectManager:Launch()
  if self.running then
    return
  end
  self.running = true
end
local creatingMap = {}
local creatingLightMap = {}
local singleEffectObj
function QuestMiniMapEffectManager.OnEffectCreated(effectHandle, id)
  local map = creatingMap[id]
  creatingMap[id] = nil
  if not Game.QuestMiniMapEffectManager.questMap[id] then
    TableUtility.TableClear(map)
    return
  end
  map.creating = false
  singleEffectObj = effectHandle.gameObject
  if singleEffectObj and not Slua.IsNull(singleEffectObj) then
    singleEffectObj:SetActive(false)
  else
    singleEffectObj = nil
  end
end
function QuestMiniMapEffectManager:_CreateEffect(map)
  if creatingMap[map.id] then
    return
  end
  if not map.creating then
    map.creating = true
    creatingMap[map.id] = map
    if self.effect then
      self.effect:Destroy()
      self.effect = nil
    end
    self.effect = Asset_Effect.PlayAt(self._effectPath, LuaGeometry.GetTempVector3(-9999, -9999, -9999), function(obj, id, assetEffect)
      self.effect = assetEffect
      local map = creatingMap[id]
      if not map then
        return
      end
      creatingMap[id] = nil
      if not Game.QuestMiniMapEffectManager.questMap[id] then
        TableUtility.TableClear(map)
        return
      end
      map.creating = false
      singleEffectObj = obj.gameObject
      if singleEffectObj and not Slua.IsNull(singleEffectObj) then
        singleEffectObj:SetActive(false)
      else
        singleEffectObj = nil
      end
    end, map.id)
  end
end
function QuestMiniMapEffectManager.OnLightEffectCreated(effectHandle, id)
  local map = creatingLightMap[id]
  creatingLightMap[id] = nil
  if not Game.QuestMiniMapEffectManager.questMap[id] then
    TableUtility.TableClear(map)
    return
  end
  map.creatingLight = false
end
function QuestMiniMapEffectManager:_CreateLightEffect(map)
  if creatingLightMap[map.id] then
    return
  end
  if not map.creatingLight then
    map.creatingLight = true
    creatingLightMap[map.id] = map
    if self.lightEffect then
      self.lightEffect:Destroy()
    end
    self.lightEffect = Asset_Effect.PlayAt(self._effectPath2, LuaGeometry.GetTempVector3(-9999, -9999, -9999), self.OnLightEffectCreated, map.id)
    self.lightEffect:SetActive(false)
  end
end
function QuestMiniMapEffectManager:RemoveQuestEffect(id)
  local map = self.questMap[id]
  if map then
    WorldMapProxy.Instance:RemoveCurQuestPosData(id)
    GameFacade.Instance:sendNotification(MainViewEvent.RemoveQuestFocus, id)
    GameFacade.Instance:sendNotification(MiniMapEvent.RemoveCircleArea, id)
    self:HideEffect(id)
    TableUtility.TableClear(map)
    self.questMap[id] = nil
  end
end
function QuestMiniMapEffectManager:TryRemoveOtherQuest(excludeID)
  for k, v in pairs(self.questMap) do
    if k ~= excludeID then
      self:RemoveQuestEffect(k)
    end
  end
end
function QuestMiniMapEffectManager:AddQuestEffect(id, showLight)
  self:TryRemoveOtherQuest(id)
  local map = self.questMap[id]
  if map then
    map.hasNotifiy = false
  else
    map = {
      effect = nil,
      hasNotifiy = false,
      creating = false,
      creatingLight = false,
      isShow = false,
      id = id,
      showLight = showLight or false
    }
    self.questMap[id] = map
    if not singleEffectObj or Slua.IsNull(singleEffectObj) then
      self:_CreateEffect(map)
    else
      singleEffectObj:SetActive(false)
    end
    if showLight then
      if self.lightEffect == nil or Slua.IsNull(self.lightEffect:GetEffectHandle()) then
        self:_CreateLightEffect(map)
      else
        self.lightEffect:SetActive(false)
      end
    elseif self.lightEffect then
      self.lightEffect:SetActive(false)
    end
    self:Update(UnityTime)
  end
end
function QuestMiniMapEffectManager:Shutdown()
  if not self.running then
    return
  end
  if self.effect then
    self.effect:Destroy()
    self.effect = nil
  end
  if self.lightEffect then
    self.lightEffect:Destroy()
    self.lightEffect = nil
  end
  for i = #self.guideEffects, 1, -1 do
    self.guideEffects[i]:Destroy()
    self.guideEffects[i] = nil
  end
  helplog("QuestMiniMapEffectManager:Shutdown")
  singleEffectObj = nil
  TableUtility.TableClear(creatingMap)
  TableUtility.TableClear(creatingLightMap)
  self.running = false
  self:_DestroyEffect()
  self.guideWorkCount = 0
  self.guideTime = 0
  self.guideEffectHidingTime = nil
  self.lightEffectHidingTime = nil
  self.curGuideShow = nil
  self.curLightShow = nil
  self.corners = nil
  self.distance = nil
end
function QuestMiniMapEffectManager:Update(time, deltaTime)
  if not self.running or Game.EffectManager:IsFiltered() then
    return
  end
  if not next(self.questMap) then
    return
  end
  if self.guideEffectHidingTime and time > self.guideEffectHidingTime then
    self.guideEffectHidingTime = nil
    if self.curGuideShow then
      self:UpdateGuideEffect()
    else
      self:HideGuideEffect()
    end
  end
  if self.deltaTime < 1 and deltaTime then
    self.deltaTime = self.deltaTime + deltaTime
    return
  end
  self.deltaTime = 0
  for k, v in pairs(self.questMap) do
    if not v.hasNotifiy then
      local id = k
      local pos, epId = FunctionQuestDisChecker.Me():getTargetPos(id)
      if epId and pos then
        if not Game.AreaTrigger_ExitPoint:IsInvisible(epId) then
          self:ShowEffect(id, pos)
        else
          self:HideEffect(id)
        end
        self:HideCircleArea(id)
      elseif pos then
        self:ShowEffect(id, pos)
        self:ShowCircleArea(id, pos)
      else
        self:HideEffect(id)
        self:HideCircleArea(id)
        self:HideGuideEffect()
      end
    end
  end
  if self.guideEffectHidingTime == nil then
    if time < self.guideTime then
      local myself = Game.Myself
      if myself:IsMoving() then
        local distance = LuaVector3.Distance_Square(myself:GetPosition(), self.targetPos)
        if distance < self.distance then
          self:RefreshGuideEffect(distance)
        end
      elseif LuaVector3.Distance_Square(self.myPos, myself:GetPosition()) > 2 then
        self:SetShowGuideEffect(true)
      end
    elseif self.guideTime ~= 0 then
      self.guideTime = 0
      self:SetShowGuideEffect(false)
    end
  end
  if self.lightEffectHidingTime then
    if time > self.lightEffectHidingTime then
      self.lightEffectHidingTime = nil
      self.lightEffect:SetActive(self.curLightShow)
    end
  elseif self.targetPos then
    if LuaVector3.Distance_Square(self.targetPos, Game.Myself:GetPosition()) > 900 then
      self:SetShowLightEffect(true)
    else
      self:SetShowLightEffect(false)
    end
  end
end
function QuestMiniMapEffectManager:_DestroyEffect()
  for k, v in pairs(self.questMap) do
    self:RemoveQuestEffect(k)
  end
end
function QuestMiniMapEffectManager:ShowMiniMapDirEffect(id)
  local map = self.questMap[id]
  if map and map.isShow then
    GameFacade.Instance:sendNotification(MiniMapEvent.ShowMiniMapDirEffect, id)
  end
end
function QuestMiniMapEffectManager:HideEffect(id)
  local map = self.questMap[id]
  if map then
    if not Slua.IsNull(singleEffectObj) then
      singleEffectObj:SetActive(false)
    else
      singleEffectObj = nil
    end
    if self.lightEffect then
      self.curLightShow = false
      self.lightEffect:SetActive(false)
    end
    map.isShow = false
    map.hasNotifiy = false
    WorldMapProxy.Instance:RemoveCurQuestPosData(id)
    GameFacade.Instance:sendNotification(MainViewEvent.RemoveQuestFocus, id)
  end
end
function QuestMiniMapEffectManager:ShowEffect(id, pos)
  local map = self.questMap[id]
  if map then
    if not singleEffectObj or Slua.IsNull(singleEffectObj) then
      singleEffectObj = nil
      self:_CreateEffect(map)
      return
    end
    if map.showLight and self.lightEffect == nil then
      self:_CreateLightEffect(map)
      return
    end
    if pos then
      local questData = QuestProxy.Instance:getQuestDataByIdAndType(id)
      if not questData then
        return
      end
      if self.targetPos == nil then
        self.targetPos = LuaVector3.Zero()
      end
      LuaVector3.Better_Set(self.targetPos, pos[1], pos[2], pos[3])
      if not questData.params or questData.params.ignorenavmesh ~= 1 then
        NavMeshUtility.SelfSample(self.targetPos)
      end
      map.isShow = true
      singleEffectObj:SetActive(true)
      singleEffectObj.transform.localPosition = tempVector3
      if map.showLight then
        if questData.params.BeamPos then
          local beamPos = questData.params.BeamPos
          LuaVector3.Better_Set(self.targetPos, beamPos[1], beamPos[2], beamPos[3])
        end
        self.lightEffect:ResetLocalPosition(self.targetPos)
        self:CreateGuideEffect()
      end
      local hideSymbol
      if questData.params and questData.params.circle == 1 then
        singleEffectObj:SetActive(false)
        hideSymbol = true
      else
        singleEffectObj:SetActive(true)
        singleEffectObj.transform.localPosition = self.targetPos
      end
      local array = ReusableTable.CreateArray()
      array[1] = id
      array[2] = self.targetPos
      array[3] = hideSymbol
      WorldMapProxy.Instance:SetCurQuestPosData(id, self.targetPos)
      GameFacade.Instance:sendNotification(MainViewEvent.AddQuestFocus, array)
      ReusableTable.DestroyAndClearArray(array)
      map.hasNotifiy = true
      FunctionGuide.Me():AddMapGuide(questData)
    else
      self:HideEffect(id)
    end
  end
end
function QuestMiniMapEffectManager:ShowCircleArea(id, pos)
  local questData = QuestProxy.Instance:getQuestDataByIdAndType(id)
  if not questData then
    return
  end
  if questData.params.circle == 1 then
    local radius = questData.params.radius
    if radius then
      local array = ReusableTable.CreateArray()
      array[1] = id
      array[2] = pos
      array[3] = radius
      GameFacade.Instance:sendNotification(MiniMapEvent.AddCircleArea, array)
      ReusableTable.DestroyAndClearArray(array)
    else
      redlog("缺少radius字段！")
    end
  end
end
function QuestMiniMapEffectManager:HideCircleArea(id)
  GameFacade.Instance:sendNotification(MiniMapEvent.RemoveCircleArea, id)
end
function QuestMiniMapEffectManager:SetEffectVisible(isVisible, id)
  local map = self.questMap[id]
  if not map or Slua.IsNull(map.effectObj) then
  else
    map.effectObj:SetActive(isVisible)
  end
end
function QuestMiniMapEffectManager:CreateGuideEffect()
  self.guideTime = UnityTime + 30
  self:UpdateGuideEffect()
end
function QuestMiniMapEffectManager:UpdateGuideEffect()
  if self.targetPos == nil then
    return
  end
  self.myPos:SetPos(Game.Myself:GetPosition())
  tempVector3:SetPos(self.myPos)
  self.distance = LuaVector3.Distance_Square(self.myPos, self.targetPos)
  local canArrive, path = NavMeshUtils.CanArrived(tempVector3, self.targetPos, WorldTeleport.DESTINATION_VALID_RANGE, true, nil)
  if canArrive then
    self.guideWorkCount = 0
    self.corners = path.corners
    self.cornerIndex = 2
    for i = 2, self.corners.Length do
      LuaVector3.Better_Sub(self.corners[i], self.corners[i - 1], tempVector3_2)
      LuaVector3.Normalized(tempVector3_2)
      LuaVector3.Mul(tempVector3_2, GuideInterval)
      local angleY = VectorHelper.GetAngleByAxisY(self.corners[i - 1], self.corners[i])
      while LuaVector3.Distance(tempVector3, self.corners[i]) > GuideInterval and self.guideWorkCount < GuideMaxCount do
        self.guideWorkCount = self.guideWorkCount + 1
        tempVector3:Add(tempVector3_2)
        local effect = self.guideEffects[self.guideWorkCount]
        if effect == nil then
          effect = Asset_Effect.PlayAt(GuideEffectPath, tempVector3)
          self.guideEffects[self.guideWorkCount] = effect
        else
          effect:ResetLocalPosition(tempVector3)
          effect:SetActive(true)
        end
        effect:ResetLocalEulerAnglesXYZ(0, angleY, 0)
        self.cornerIndex = i
      end
    end
    self:ShowGuideEffect(true)
    for i = self.guideWorkCount + 1, #self.guideEffects do
      self.guideEffects[i]:SetActive(false)
    end
  end
end
function QuestMiniMapEffectManager:RefreshGuideEffect(distance)
  local dirtys = {}
  for i = 1, self.guideWorkCount do
    if distance < LuaVector3.Distance_Square(self.guideEffects[i]:GetLocalPosition(), self.targetPos) then
      dirtys[#dirtys + 1] = i
    end
  end
  if self.corners ~= nil then
    local index = 0
    for i = self.cornerIndex, self.corners.Length do
      LuaVector3.Better_Sub(self.corners[i], self.corners[i - 1], tempVector3_2)
      LuaVector3.Normalized(tempVector3_2)
      LuaVector3.Mul(tempVector3_2, GuideInterval)
      local angleY = VectorHelper.GetAngleByAxisY(self.corners[i - 1], self.corners[i])
      while LuaVector3.Distance(tempVector3, self.corners[i]) > GuideInterval and index < #dirtys do
        index = index + 1
        tempVector3:Add(tempVector3_2)
        local effect = self.guideEffects[dirtys[index]]
        if effect ~= nil then
          effect:ResetLocalPosition(tempVector3)
        end
        effect:ResetLocalEulerAnglesXYZ(0, angleY, 0)
        self.cornerIndex = i
      end
    end
  end
end
function QuestMiniMapEffectManager:SetShowGuideEffect(isShow)
  self.curGuideShow = isShow
  self.guideEffectHidingTime = UnityTime + 0.5
  self:ShowGuideEffect(false)
end
function QuestMiniMapEffectManager:ShowGuideEffect(isShow)
  local name = isShow and "cfx_task_guide_state1001" or "cfx_task_guide_state2001"
  for i = 1, self.guideWorkCount do
    self.guideEffects[i]:ResetAction(name, 0, true)
  end
end
function QuestMiniMapEffectManager:HideGuideEffect()
  if self.curGuideShow then
    for i = 1, self.guideWorkCount do
      self.guideEffects[i]:SetActive(false)
    end
  end
end
function QuestMiniMapEffectManager:SetShowLightEffect(isShow)
  if self.curLightShow == isShow then
    return
  end
  self.curLightShow = isShow
  self.lightEffectHidingTime = UnityTime + 0.5
  local name = isShow and "cfx_113tasck_map_stat001" or "cfx_113tasck_map_state2001"
  self.lightEffect:ResetAction(name, 0, true)
end
