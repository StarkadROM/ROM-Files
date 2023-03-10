MiniMapGuideAnim = class("MiniMapGuideAnim")
local tempV3 = LuaVector3()
function MiniMapGuideAnim:ctor(mapWindow, miniMap)
  self.mapWindow = mapWindow
  self.miniMap = miniMap
end
function MiniMapGuideAnim:SetShutDownCall(shutDownCall, param)
  self.shutDownCall = shutDownCall
  self.shutDownCallParam = param
end
function MiniMapGuideAnim:SetEndCall(endCall, param)
  self.endCall = endCall
  self.endCallParam = param
end
function MiniMapGuideAnim:Launch(questData, bubbleId, bubbleStick)
  self.questId = questData.id
  local questParam = questData.staticData.Params
  if questParam then
    if questParam.mapid ~= nil and questParam.mapid ~= Game.MapManager:GetMapID() then
      self:ShutDown()
      return
    end
    if questParam.guide_quest_symbol then
      self.animType = "visit"
      local effectPath = ResourcePathHelper.EffectUI(questParam.guide_quest_symbol)
      self.focusTempObj = Game.AssetManager_UI:CreateAsset(effectPath, self.mapWindow.s_symbolParent)
      if Slua.IsNull(self.focusTempObj) then
        local effectPath = ResourcePathHelper.EffectUI("44map_icon_talk")
        self.focusTempObj = Game.AssetManager_UI:CreateAsset(effectPath, self.mapWindow.s_symbolParent)
        errorLog(string.format("No Effect(%s)", tostring(questParam.guide_quest_symbol)))
      end
    else
      self.animType = "move"
      self.focusTempObj = GameObject()
    end
    self.focusTempObj.transform:SetParent(self.mapWindow.s_symbolParent, false)
    self.focusTempObj:SetActive(false)
    local configPos = questParam.pos
    if not configPos then
      local npcPoint = Game.MapManager:FindNPCPoint(questParam.uniqueid)
      if npcPoint then
        configPos = npcPoint.position
      else
        configPos = {
          0,
          0,
          0
        }
      end
    end
    LuaVector3.Better_Set(tempV3, configPos[1], configPos[2], configPos[3])
    local mapPos = self.mapWindow:ScenePosToMap(tempV3)
    local worldPos = self.mapWindow.s_symbolParent:TransformPoint(mapPos)
    LuaVector3.Better_Set(tempV3, worldPos.x, worldPos.y, worldPos.z)
    helplog(tempV3[1], tempV3[2], tempV3[3])
    self.focusTempObj.transform.position = tempV3
  end
  if not self.focusTempObj then
    errorLog("no Find focus")
    self:ShutDown()
    return
  end
  self.bubbleId = bubbleId
  self.bubbleStick = bubbleStick
  self.mapWindow:ActiveSymbols(false)
  self:TweenLargetMap()
  self.running = true
  self.isEnd = false
  self.mapWindow:SetLock(true)
end
function MiniMapGuideAnim:CancelLT()
  if self.lt then
    self.lt:Destroy()
  end
  self.lt = nil
end
function MiniMapGuideAnim:TweenLargetMap()
  TimeTickManager.Me():ClearTick(self)
  self.tickTweenSize = TimeTickManager.Me():CreateTickFromTo(500, 1, 2.3, 1000, function(owner, deltaTime, curValue)
    if self.miniMap then
      self.miniMap:ShowSettingAndWorldLine(false)
    end
    self:EnlargeMap(curValue)
  end, self)
  self.tickTweenSize:SetCompleteFunc(function(owner, id)
    self.tickTweenSize = nil
    self:PlayFocusAnim()
  end)
end
function MiniMapGuideAnim:EnlargeMap(f)
  self.mapWindow:SetMapScale(f)
  self.mapWindow:CenterOnTrans(self.focusTempObj.transform, true)
end
local focusTable = {}
function MiniMapGuideAnim:PlayFocusAnim()
  TableUtility.TableClear(focusTable)
  local parent = self.mapWindow.mapTexture.transform
  local effectPath = ResourcePathHelper.EffectUI(EffectMap.UI.MapIndicates)
  self.focusEffect = Game.AssetManager_UI:CreateAsset(effectPath, parent)
  tempV3[1], tempV3[2], tempV3[3] = LuaGameObject.GetPosition(self.focusTempObj.transform)
  self.focusEffect.transform.position = tempV3
  self:CancelLT()
  self.lt = TimeTickManager.Me():CreateOnceDelayTick(500, function(owner, deltaTime)
    self:ShowQuestSymbol()
  end, self)
end
function MiniMapGuideAnim:ShowQuestSymbol()
  if self.animType == "visit" then
    self.focusTempObj.transform:SetParent(self.mapWindow.mapTexture.transform, false)
    self.focusTempObj:SetActive(true)
    self:CancelLT()
    self.lt = TimeTickManager.Me():CreateOnceDelayTick(1000, function(owner, deltaTime)
      self:ShowBubble()
    end, self)
  elseif self.animType == "move" then
    self:ShowBubble()
  end
end
function MiniMapGuideAnim:ShowBubble()
  self:EndAnim()
  if self.bubbleStick and self.bubbleId then
    tempV3[1], tempV3[2], tempV3[3] = LuaGameObject.GetPosition(self.focusTempObj.transform)
    self.bubbleStick.transform.position = tempV3
    self.mapWindow:SetLock(false)
    self.mapWindow:ActiveSymbols(true)
    TipManager.Instance:ShowBubbleTipById(self.bubbleId, self.bubbleStick, NGUIUtil.AnchorSide.Top, {0, 10}, function()
      self:ShutDown()
    end, false)
  else
    self:ShutDown()
  end
end
function MiniMapGuideAnim:CloseBubbleTip()
  TipManager.Instance:CloseBubbleTip(self.bubbleId)
  self:ShutDown()
end
function MiniMapGuideAnim:ShutDown()
  self:CancelLT()
  self.running = false
  self.questId = nil
  self.tickTweenSize = nil
  TimeTickManager.Me():ClearTick(self)
  if not Slua.IsNull(self.cpyObj) then
    GameObject.Destroy(self.cpyObj)
  end
  self.cpyObj = nil
  if self.focusEffect then
    GameObject.Destroy(self.focusEffect)
  end
  self.focusEffect = nil
  if not Slua.IsNull(self.focusTempObj) then
    GameObject.Destroy(self.focusTempObj)
    self.focusTempObj = nil
  end
  self.mapWindow:SetLock(false)
  self.mapWindow:ActiveSymbols(true)
  if self.shutDownCall then
    self.shutDownCall(self.shutDownCallParam, self)
  end
end
function MiniMapGuideAnim:EndAnim()
  self:CancelLT()
  self.isEnd = true
  if self.endCall then
    self.endCall(self.endCallParam, self)
  end
end
function MiniMapGuideAnim:Pause()
  if self.lt then
    self.lt:StopTick()
  end
  if self.tickTweenSize then
    self.tickTweenSize:StopTick()
  end
end
function MiniMapGuideAnim:Continue()
  if self.lt then
    self.lt:ContinueTick()
  end
  if self.tickTweenSize then
    self.tickTweenSize:ContinueTick()
  end
end
