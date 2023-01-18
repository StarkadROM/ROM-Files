local BaseCell = autoImport("BaseCell")
autoImport("TipLabelNameValuePair")
TipLabelCell = class("TipLabelCell", BaseCell)
local Line_default_width = {340, 170}
local defaultLineColor, dottedLineColor = LuaColor.New(0.9019607843137255, 0.9137254901960784, 0.9647058823529412, 1), LuaColor.New(0.5411764705882353, 0.6, 0.7254901960784313, 1)
local defaultLabelColor, defaultTipLabelColor = LuaColor.New(0.17647058823529413, 0.17254901960784313, 0.2784313725490196, 1), LuaColor.New(0.2901960784313726, 0.35294117647058826, 0.49019607843137253, 1)
local defaultLabelFontSize, defaultTipLabelFontSize = 18, 20
function TipLabelCell:Init()
  self.labelMap, self.nvPairMap = {}, {}
  self.tiplabel = self:FindComponent("A_TipLabel", UILabel)
  self.tiplabelinlinebutton = self:FindComponent("A_TipLabel_InlineButton", UISprite)
  self.labelPfb = self:FindGO("Label")
  self.line = self:FindGO("Z_Line")
  self.lineTrans = self.line and self.line.transform
  self.table = self.gameObject:GetComponent(UITable)
  self.sliderCell = self:FindGO("TipLabelSliderCell")
end
function TipLabelCell:SetData(data)
  self.data = data
  if data then
    if Slua.IsNull(self.gameObject) then
      return
    end
    local labels
    if type(data.label) == "string" then
      labels = {
        data.label
      }
    elseif type(data.label) == "table" then
      labels = data.label
    end
    if not self:ObjIsNil(self.tiplabel) then
      if not StringUtil.IsEmpty(data.tiplabel) then
        self.tiplabel.gameObject:SetActive(true)
        self.tiplabel.text = data.tiplabel
        self:SetLabelColor(self.tiplabel, data.tipcolor or data.color or defaultTipLabelColor)
        self.tiplabel.fontSize = data.tipfontsize or data.fontsize or defaultTipLabelFontSize
        if self.tiplabelinlinebutton then
          if data.aTipInlineButton then
            if data.aTipInlineButton.sprite then
              IconManager:SetUIIcon(data.aTipInlineButton.sprite, self.tiplabelinlinebutton)
            end
            if data.aTipInlineButton.showSubMark then
              local m = self:FindGO("go", self.tiplabelinlinebutton.gameObject)
              if m then
                m:SetActive(true)
              end
            end
            local pos = self.tiplabelinlinebutton.transform.localPosition
            pos.x = self.tiplabel.width - self.tiplabelinlinebutton.width / 2
            pos.y = -(self.tiplabel.fontSize + self.tiplabel.spacingY) / 2 - self.tiplabelinlinebutton.height / 2
            self.tiplabelinlinebutton.transform.localPosition = pos
            if data.aTipInlineButton.action then
              self:SetEvent(self.tiplabelinlinebutton.gameObject, function()
                data.aTipInlineButton.action()
              end)
            end
            if data.aTipInlineButton.init_action then
              data.aTipInlineButton.init_action(self.tiplabelinlinebutton)
            end
            self.tiplabelinlinebutton.gameObject:SetActive(true)
          else
            self.tiplabelinlinebutton.gameObject:SetActive(false)
          end
        end
      else
        self.tiplabel.gameObject:SetActive(false)
      end
    end
    self:SetLabels(labels, data.labelConfig)
    if data.locked then
      self:SetLocked(data)
    elseif data.namevaluepair then
      self:SetNameValuePair(data.namevaluepair)
    elseif #self.nvPairMap > 0 then
      local go
      for i = 1, #self.nvPairMap do
        go = self.nvPairMap[i].gameObject
        if not Slua.IsNull(go) then
          GameObject.DestroyImmediate(go)
        end
      end
      TableUtility.TableClear(self.nvPairMap)
    end
    local hideline, usestripline, lineTab = data.lineTab or data.hideline, data.usestripline, Line_default_width
    if self.line then
      self.line:SetActive(not hideline)
      if not hideline then
        local lineImg = self.line:GetComponent("UISprite")
        lineImg.type = usestripline and E_UIBasicSprite_Type.Sliced or E_UIBasicSprite_Type.Tiled
        lineImg.spriteName = usestripline and "com_bg_line" or "calendar_bg_dotted-line"
        lineImg.color = usestripline and defaultLineColor or dottedLineColor
        lineImg.width = lineTab[1]
        local tempVector3 = LuaGeometry.GetTempVector3(LuaGameObject.GetLocalPosition(self.lineTrans))
        tempVector3.x = lineTab[2]
        self.lineTrans.localPosition = tempVector3
        if data.dotLineColor ~= nil then
          lineImg.color = data.dotLineColor
        end
      end
    end
    if GemProxy.CheckIsGemAttrData(data) then
      self:SetSlider(data.exp, data:GetExpForNextLevel(), data.lv)
      self:RePosition()
      return
    elseif self.sliderCell then
      GameObject.DestroyImmediate(self.sliderCell)
      self.sliderCell = nil
    end
    if BranchMgr.IsJapan() then
      local itemId = data.helpInfoItemId
      if itemId then
        local Label01 = self:FindGO("Label01")
        if Label01 ~= nil and self.helpButton == nil then
          self.helpButton = self:LoadPreferb("cell/HelpButtonCell", Label01)
          self.helpButton.transform.localPosition = LuaGeometry.GetTempVector3(316, -10, 0)
          self.helpButton.transform.localScale = LuaGeometry.GetTempVector3(0.8, 0.8, 1)
          self:AddClickEvent(self:FindGO("HelpButton", self.helpButton), function(go)
            OverseaHostHelper:ShowGiftProbability(itemId)
          end)
          helplog(self.helpButton)
        end
      elseif self.helpButton then
        GameObject.Destroy(self.helpButton)
        self.helpButton = nil
        else
          self:SetLabels()
        end
      end
    else
    end
  self:RePosition()
end
function TipLabelCell:SetLabels(labels, labelConfig)
  local num = labels and #labels or 0
  local width, labwidth, iconwidth, iconheight
  if labelConfig then
    width, labwidth, iconwidth, iconheight = labelConfig.width, labelConfig.labwidth, labelConfig.iconwidth, labelConfig.iconheight
    if width and width <= 0 then
      width = Line_default_width[1] + width
    end
  end
  for i = 1, num do
    local lab = self.labelMap[i]
    if not lab then
      lab = self:MakeSpriteLabel(width, labwidth, iconwidth, iconheight, i)
      self.labelMap[i] = lab
    else
      lab:ResetLineWidth(width)
      lab:Reset()
    end
    lab:SetText(labels[i])
    lab:SetLabelColor(self.data.color or defaultLabelColor)
    if self.data.txtBgColor then
      local sprites = lab.richLabel.gameObject:GetComponentsInChildren(UISprite)
      if sprites ~= nil then
        for i = 1, #sprites do
          sprites[i].color = self.data.txtBgColor
        end
      end
      local lbs = lab.richLabel.gameObject:GetComponentsInChildren(UILabel)
      if lbs ~= nil then
        for i = 1, #lbs do
          lbs[i].color = self.data.color
        end
      end
    end
    self:TryHandleClickUrl(lab.richLabel, labels[i])
    self:TryHandleInlineButton(lab)
  end
  for i = #self.labelMap, num + 1, -1 do
    local richLabel = self.labelMap[i].richLabel
    self.labelMap[i]:Destroy()
    if not Slua.IsNull(richLabel) then
      GameObject.DestroyImmediate(richLabel.gameObject)
    end
    table.remove(self.labelMap, i)
  end
end
function TipLabelCell:SetLocked(data)
  local go
  for _, pair in pairs(self.nvPairMap) do
    go = pair.gameObject
    if not Slua.IsNull(go) then
      GameObject.DestroyImmediate(go)
    end
  end
  TableUtility.TableClear(self.nvPairMap)
  self.nvPairMap[1] = self:MakeNameValuePair("Locked")
  self.nvPairMap[1]:SetData(data)
end
function TipLabelCell:SetNameValuePair(pairList)
  local num, go, pair, pairData = pairList and #pairList or 0, nil, nil, nil
  for i = 1, num do
    pair, pairData = self.nvPairMap[i], pairList[i]
    if not pair then
      pair = self:MakeNameValuePair("NameValuePair" .. i)
      self.nvPairMap[i] = pair
    end
    if pairData and not pairData.color then
      if not pairData.nameColor then
        pairData.nameColor = defaultLabelColor
      end
      if not pairData.valueColor then
        pairData.valueColor = defaultLabelColor
      end
    end
    pair:SetData(pairData)
  end
  for i = #self.nvPairMap, num + 1, -1 do
    go = self.nvPairMap[i].gameObject
    if not Slua.IsNull(go) then
      GameObject.DestroyImmediate(go)
    end
    table.remove(self.nvPairMap, i)
  end
  local sIndex = 3
  for i = 1, #self.nvPairMap do
    self.nvPairMap[i].gameObject.transform:SetSiblingIndex(sIndex)
    sIndex = sIndex + 1
  end
  for i = 1, #self.labelMap do
    self.labelMap[i].richLabel.gameObject.transform:SetSiblingIndex(sIndex)
    sIndex = sIndex + 1
  end
end
function TipLabelCell:SetSlider(val, maxVal, text, textColor)
  self.sliderCell = self.sliderCell or self:LoadPreferb("cell/TipLabelSliderCell", self.gameObject)
  local slider = self:FindComponent("Slider", UISlider, self.sliderCell)
  local lvLabel = self:FindComponent("LvLabel", UILabel, self.sliderCell)
  if not slider then
    return
  end
  slider.value = maxVal ~= 0 and math.clamp(val / maxVal, 0, 1) or 1
  lvLabel.text = string.format(ZhString.Gem_UpgradeLvLabelFormat, text or "")
  self:SetLabelColor(lvLabel, textColor)
end
function TipLabelCell:RePosition()
  if self.gameObject.activeInHierarchy then
    self.table:Reposition()
  else
    self.table.repositionNow = true
  end
end
function TipLabelCell:TryHandleClickUrl(label, text)
  local labObj, hasUrl = label.gameObject, string.match(text, "%[url=")
  if hasUrl then
    UIUtil.TryAddClickUrlCompToGameObject(labObj, self.data.clickurlcallback)
  else
    UIUtil.TryRemoveClickUrlCompFromGameObject(labObj)
  end
end
function TipLabelCell:TryHandleInlineButton(spriteLabel)
  if not spriteLabel.inlineBtns then
    return
  end
  local pendingrm = {}
  for k, v in pairs(spriteLabel.inlineBtns) do
    if Slua.IsNull(v) then
      pendingrm[#pendingrm + 1] = k
    else
      self:SetEvent(v.gameObject, function()
        self.data.inlineBtnCb(k)
      end)
      if self.data.inlineBtnExtraOffset then
        local pos = v.transform.localPosition
        pos.x = spriteLabel.richLabel.width - v.width / 2 + self.data.inlineBtnExtraOffset[1]
        pos.y = -(spriteLabel.richLabel.fontSize + spriteLabel.richLabel.spacingY) / 2 - v.height / 2 + self.data.inlineBtnExtraOffset[2]
        v.transform.localPosition = pos
      else
      end
    end
  end
  for i = 1, #pendingrm do
    spriteLabel.inlineBtns[pendingrm[i]] = nil
  end
end
function TipLabelCell:MakeSpriteLabel(width, labwidth, iconwidth, iconheight, number)
  local labObj, labComp = self:CopyGameObject(self.labelPfb)
  labObj:SetActive(true)
  labObj.name = string.format("Label%02d", number or 0)
  labComp = labObj:GetComponent(UILabel)
  if labwidth then
    labComp.width = labwidth
  end
  labComp.fontSize = self.data.fontsize or defaultLabelFontSize
  return SpriteLabel.new(labObj, width, iconwidth, iconheight, true)
end
function TipLabelCell:MakeNameValuePair(name, data)
  local p = TipLabelNameValuePair.new(self:LoadPreferb("cell/TipLabelNameValuePair", self.gameObject))
  if p then
    p.gameObject.name = name
    p:SetData(data)
  end
  return p
end
function TipLabelCell:SetLabelColor(label, color)
  if not label then
    LogUtility.Warning("SetLabelColor: ArgumentNilException")
    return
  end
  color = color or defaultLabelColor
  local tColor = type(color)
  if tColor == "table" then
    label.color = color
  elseif tColor == "string" then
    local succ, pColor = ColorUtil.TryParseHexString(color)
    if succ then
      label.color = pColor
    end
  end
end
function TipLabelCell:CheckIsNameValuePair(element)
  return type(element) == "table" and element.name ~= nil and element.value ~= nil
end
