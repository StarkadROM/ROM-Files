local baseCell = autoImport("BaseCell")
DoujinshiButtonCell = class("DoujinshiButtonCell", baseCell)
local ArrayFindIndex = TableUtility.ArrayFindIndex
function DoujinshiButtonCell:Init()
  self:initView()
end
function DoujinshiButtonCell:initView()
  self.activity_texture = self:FindComponent("activity_texture", UITexture)
  self.activity_label = self:FindComponent("activity_label", UILabel)
  self.holderSp = self:FindComponent("holderSp", GradientUISprite)
  self:ResetDepth()
end
function DoujinshiButtonCell:ResetDepth()
  local sp = self.gameObject:GetComponent(UISprite)
  sp.depth = sp.depth + 30
  self.activity_texture.depth = self.activity_texture.depth + 30
  self.activity_label.depth = self.activity_label.depth + 30
  self.holderSp.depth = self.holderSp.depth + 30
end
function DoujinshiButtonCell:SetData(data)
  self.data = data
  self:Show(self.holderSp)
  self.activity_texture.gameObject:SetActive(false)
  self.activity_label.text = data.name
  IconManager:SetUIIcon(data.icon, self.holderSp)
end
function DoujinshiButtonCell:UpdateLabel(text)
  if self.activity_label then
    self.activity_label.text = text
  end
end
function DoujinshiButtonCell:UpdateAuction(totalSec, hour, min, sec)
  if self.data and totalSec ~= nil and hour ~= nil then
    if hour >= 24 then
      self.activity_label.text = string.format(ZhString.Auction_CountdownDayName, hour / 24)
    else
      self.activity_label.text = string.format(ZhString.Auction_CountdownName, hour, min, sec)
    end
  end
end
local LogMap = {}
local _defaultOrder = 1000
local DefaultOrder = function()
  _defaultOrder = _defaultOrder + 1
  return _defaultOrder
end
local HotEntranceOrder = GameConfig.HotEntrance and GameConfig.HotEntrance.Order
function DoujinshiButtonCell:GetOrder()
  if self.customOrder then
    return self.customOrder
  end
  local icon, name, order
  if self.data then
    icon, name = self.data.icon, self.data.name
    if HotEntranceOrder then
      local index = ArrayFindIndex(HotEntranceOrder, icon)
      if index > 0 then
        order = index
      end
    end
  end
  order = order or DefaultOrder()
  if icon and not LogMap[icon] then
    LogMap[icon] = 1
    redlog("??????????????????", name, icon, order)
  end
  return order
end
function DoujinshiButtonCell:SetCustomOrder(val)
  self.customOrder = val
end
function DoujinshiButtonCell:UpdateOrder()
  self.trans:SetSiblingIndex(self:GetOrder())
end
