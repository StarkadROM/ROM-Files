EnchantNewCell = class("EnchantNewCell", CoreView)
function EnchantNewCell:ctor(obj)
  EnchantNewCell.super.ctor(self, obj)
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self.grid = self:FindComponent("Grid", UIGrid)
  self.gridTrans = self.grid.transform
  self.gridPosX = LuaGameObject.GetLocalPosition(self.gridTrans)
  self.attrGOs, self.attrNames, self.attrValues, self.attrIndicators, self.attrMaxTips = {}, {}, {}, {}, {}
  local go
  for i = 1, 3 do
    go = self:FindGO("Attr" .. i)
    self.attrGOs[i] = go
    self.attrNames[i] = self:FindComponent("AttrName", UILabel, go)
    self.attrValues[i] = self:FindComponent("AttrValue", UILabel, go)
    self.attrIndicators[i] = self:FindComponent("AttrIndicator", UISprite, go)
    self.attrMaxTips[i] = self:FindGO("MaxTip", go)
  end
  self.combineAttr = self:FindGO("CombineAttr")
  self.combineAttrName = self:FindComponent("CombineAttrName", UILabel)
  self:AddClickEvent(self.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end
function EnchantNewCell:SetData(data)
  local flag = data ~= nil and data.enchantAttrList ~= nil and #data.enchantAttrList > 0
  self.gameObject:SetActive(flag)
  self.index = flag and data.index or nil
  if flag then
    self:UpdateAttrs(data.enchantAttrList)
    self:UpdateCombine(data.combineEffectList)
  end
  self:UpdateChoose()
end
function EnchantNewCell:UpdateAttrs(attrs)
  local data, quality, indicator
  for i = 1, #self.attrGOs do
    data = attrs and attrs[i]
    self.attrGOs[i]:SetActive(data ~= nil)
    if data then
      self.attrNames[i].text = data.name
      self.attrValues[i].text = string.format(data.propVO.isPercent and "+%s%%" or "+%s", data.value)
      quality, indicator = data.Quality, self.attrIndicators[i]
      if quality == EnchantAttriQuality.Good then
        indicator.gameObject:SetActive(true)
        indicator.spriteName = "enchant_success"
      elseif quality == EnchantAttriQuality.Bad then
        indicator.gameObject:SetActive(true)
        indicator.spriteName = "enchant_fail"
      else
        indicator.gameObject:SetActive(false)
      end
      self.attrMaxTips[i]:SetActive(data.isMax)
    end
  end
end
function EnchantNewCell:UpdateCombine(combineEffs)
  local hasCombine, buffData = false, nil
  if combineEffs then
    for i = 1, #combineEffs do
      buffData = combineEffs[i] and combineEffs[i].buffData
      if buffData then
        hasCombine = true
        self.combineAttrName.text = combineEffs[i].isWork and string.format("%s:%s", buffData.BuffName, buffData.BuffDesc) or string.format("[c][9C9C9C]%s:%s(%s)[-][/c]", buffData.BuffName, buffData.BuffDesc, combineEffs[i].WorkTip)
      end
    end
  end
  self.gridTrans.localPosition = LuaGeometry.GetTempVector3(self.gridPosX, hasCombine and 52 or 41)
  self.grid.cellHeight = hasCombine and 31 or 42
  self.grid:Reposition()
  self.combineAttr:SetActive(hasCombine)
end
function EnchantNewCell:SetChooseId(chooseId)
  self.chooseId = chooseId
  self:UpdateChoose()
end
function EnchantNewCell:UpdateChoose()
  if not self.chooseSymbol then
    return
  end
  self.chooseSymbol:SetActive(self.chooseId ~= nil and self.index ~= nil and self.chooseId == self.index)
end
