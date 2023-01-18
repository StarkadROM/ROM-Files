local BaseCell = autoImport("BaseCell")
EyeLensesCell = class("EyeLensesCell", BaseCell)
local _shopType, _shopID
function EyeLensesCell:Init()
  _shopType = ShopDressingProxy.Instance.shopType2
  _shopID = ShopDressingProxy.Instance.shopID2
  EyeLensesCell.super.Init(self)
  self:FindObjs()
  self:AddCellClickEvent()
end
function EyeLensesCell:FindObjs()
  self.empty = self:FindGO("empty")
  self.item = self:FindGO("Item")
  self.chooseImg = self:FindGO("chooseImg")
  self.icon = self:FindComponent("iconColor", UISprite)
  self.lockFlag = self:FindGO("lockFlag")
  self.equiped = self:FindGO("Equiped")
end
function EyeLensesCell:SetChoose(eyeid)
  self.chooseStyleID = eyeid and Table_Eye[eyeid] and Table_Eye[eyeid].StyleID or nil
  self:UpdateChoose()
end
function EyeLensesCell:UpdateChoose()
  self.chooseImg:SetActive(self.eyeID == self.chooseStyleID)
end
local eyeColor
function EyeLensesCell:SetData(data)
  self.data = data
  self.eyeID = nil
  if data and data.id then
    self:Show(self.item)
    self:Hide(self.empty)
    local eyeID = data.goodsID
    if eyeID then
      local csvData = Table_Eye[eyeID]
      if csvData and csvData.Icon then
        self.styleID = eyeID
        self.eyeID = eyeID
        IconManager:SetHairStyleIcon(csvData.Icon, self.icon)
        self.icon:MakePixelPerfect()
        local unlock = ShopDressingProxy.Instance:bActived(eyeID, ShopDressingProxy.DressingType.EYE)
        if unlock then
          self:Hide(self.lockFlag)
          self:SetTextureWhite(self.icon.gameObject)
          local csvColor = csvData.EyeColor
          if csvColor and #csvColor > 0 then
            local hasColor = false
            hasColor, eyeColor = ColorUtil.TryParseFromNumber(csvColor[1])
            self.icon.color = eyeColor
          end
        else
          self:Show(self.lockFlag)
          self:SetTextureGrey(self.icon.gameObject)
        end
      end
    end
  else
    self:Hide(self.item)
    self:Hide(self.empty)
  end
  self:UpdateChoose()
  self:SetEquiped()
end
function EyeLensesCell:SetEquiped()
  if self.equiped then
    if not self.eyeID or not Table_Eye[self.eyeID] or not Table_Eye[self.eyeID].StyleID then
      local styleId
    end
    local originalEye = ShopDressingProxy.Instance.originalEye
    local originalEyeStyleID = Table_Eye[originalEye].StyleID
    self.equiped:SetActive(styleId == originalEyeStyleID)
  end
end
