autoImport("GemPageAttributeCell")
GemPageSkillCell = class("GemPageSkillCell", GemPageAttributeCell)
local tempTable = {}
GemAttributeIndicatorTypeColors = {
  LuaColor.New(1.0, 0.6588235294117647, 0.6588235294117647),
  LuaColor.New(0.6313725490196078, 0.9529411764705882, 0.9490196078431372),
  LuaColor.New(1.0, 0.984313725490196, 0.5411764705882353)
}
GemAttributeIndicatorEffectNames = {
  "Redlight",
  "Bluelight",
  "Yellowlight"
}
GemPageSkillCellFrameSpriteNames = {
  "Rune_frame_Big-rune_attack",
  "Rune_frame__Big-rune_defense",
  "Rune_frame_Big-rune_special",
  [0] = "Rune_frame_Big-rune_currency"
}
function GemPageSkillCell:Init()
  GemPageSkillCell.super.Init(self)
  self.indicatorParent = self:FindGO("Indicators")
  self.indicatorSps = {}
  self.indicatorEffectContainers = {}
  self.indicatorTypeSps = {}
  local indicator
  for i = 1, 3 do
    indicator = self:FindGO(tostring(i), self.indicatorParent)
    self.indicatorSps[i] = indicator:GetComponent(UISprite)
    self.indicatorEffectContainers[i] = self:FindGO("EffectContainer", indicator)
    self.indicatorTypeSps[i] = self:FindComponent("Type", UISprite, indicator)
  end
  self.neighborIds = GameConfig.Gem.Page[self.id]
  self.validIndicatorEffectMap = {}
end
function GemPageSkillCell:SetData(data)
  GemPageSkillCell.super.SetData(self, data)
  if not self:CheckIsDataValid(data) then
    self.indicatorParent:SetActive(false)
    if data then
      LogUtility.Error("You're trying to set data of GemPageSkillCell without GemSkillData!")
    end
    self:ClearAllValidIndicatorEffect()
    return
  end
  self.needAttributeGemTypes = data.gemSkillData.needAttributeGemTypes
  self.indicatorParent:SetActive(true)
  self:SetIndicatorBasics()
  self:SetIndicatorValid()
end
function GemPageSkillCell:SetIndicatorBasics()
  if type(self.needAttributeGemTypes) ~= "table" then
    return
  end
  for i = 1, 3 do
    self.indicatorSps[i].spriteName = "Rune_bg_dot00"
    self.indicatorTypeSps[i].spriteName = "com_icon_dot"
  end
  local sculptData, sculptPos = self.data.gemSkillData:GetSculptData()
  if next(sculptData) then
    sculptPos = sculptData[1].pos
    self.indicatorSps[sculptPos].spriteName = "Rune_bg_dot01"
    self.indicatorTypeSps[sculptPos].spriteName = "Rune_bg_dot_star"
  end
  for i = 1, 3 do
    self.indicatorSps[i]:MakePixelPerfect()
    self.indicatorTypeSps[i]:MakePixelPerfect()
  end
  local needType, color
  for i = 1, 3 do
    needType = self.needAttributeGemTypes[i]
    color = needType and GemAttributeIndicatorTypeColors[needType]
    if not color or sculptPos and sculptPos == i then
      color = LuaColor.White()
    end
    self.indicatorTypeSps[i].color = color
  end
end
function GemPageSkillCell:SetIndicatorValid()
  self:ClearAllValidIndicatorEffect()
  if not self.available then
    return
  end
  self.pageData:ForEachFitTypeNeighborOfGemPageSkillCell(self.id, function(self, needTypeIndex, fitTypeNeighborData)
    local effectName = GemAttributeIndicatorEffectNames[fitTypeNeighborData.gemAttrData.type]
    if not effectName then
      return
    end
    self:PlayUIEffect(effectName, self.indicatorEffectContainers[needTypeIndex], nil, function(handle, args, assetEffect)
      self.validIndicatorEffectMap[needTypeIndex] = assetEffect
      local widgets = Game.GameObjectUtil:GetAllComponentsInChildren(handle.gameObject, UIWidget, false)
      for _, w in pairs(widgets) do
        if w.depth < 10 then
          w.depth = w.depth + 10
        end
      end
    end)
  end, self)
end
function GemPageSkillCell:UpdateFrame()
  self:SetFrameActive(self.data ~= nil)
  if self.data then
    self:SetFrameSprite()
  end
end
function GemPageSkillCell:SetFrameSprite()
  if not self.frameSp then
    return
  end
  local types = self.data.gemSkillData.needAttributeGemTypes
  TableUtility.TableClear(tempTable)
  for i = 1, 3 do
    tempTable[i] = 0
  end
  for _, t in pairs(types) do
    if t > 0 then
      tempTable[t] = tempTable[t] + 1
    end
  end
  local maxCount, maxType = 0, nil
  for t, count in pairs(tempTable) do
    if count > maxCount then
      maxCount = count
      maxType = t
    end
  end
  if not maxType or maxCount == 1 then
    maxType = 0
  end
  self.frameSp.spriteName = GemPageSkillCellFrameSpriteNames[maxType]
  self.frameSp:MakePixelPerfect()
end
function GemPageSkillCell:UpdateAvailability()
  self:SetAvailable(self.data == nil or self.data.gemSkillData.available ~= false)
end
function GemPageSkillCell:ClearAllValidIndicatorEffect()
  self.validIndicatorEffectMap = self.validIndicatorEffectMap or {}
  for _, effect in pairs(self.validIndicatorEffectMap) do
    effect:Destroy()
  end
  TableUtility.TableClear(self.validIndicatorEffectMap)
end
function GemPageSkillCell:CheckIsDataValid(data)
  return GemProxy.CheckContainsGemSkillData(data)
end
function GemPageSkillCell:TryEmbed(newData)
  GemProxy.CallEmbed(SceneItem_pb.EGEMTYPE_SKILL, newData.id, self.id)
end
function GemPageSkillCell:TryRemoveSelf()
  if not self.data then
    return
  end
  GemProxy.CallRemove(SceneItem_pb.EGEMTYPE_SKILL, self.data.id)
end
function GemPageSkillCell:TryRemoveIncoming(data)
  if GemProxy.CheckContainsGemAttrData(data) then
    GemProxy.CallRemove(SceneItem_pb.EGEMTYPE_ATTR, data.id)
  end
end
function GemPageSkillCell:GetEmbedSuccessEffectId()
  return EffectMap.UI.GemSkillEmbed
end
function GemPageSkillCell:GetSkillValidEffectId()
  return EffectMap.UI.GemSkillSkillValid
end
function GemPageSkillCell.AttributeGemTypePredicate(k, v, needType)
  return v.type == needType
end
