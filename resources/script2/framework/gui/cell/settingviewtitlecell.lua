local BaseCell = autoImport("BaseCell")
SettingViewTitleCell = class("SettingViewTitleCell", BaseCell)
function SettingViewTitleCell:Init()
  self.label = self:FindComponent("Label", UILabel)
  self.icon = self:FindComponent("Icon", UISprite)
  self.line = self:FindGO("Line")
end
function SettingViewTitleCell:SetData(data)
  self.label.text = data.label
  local atlas = RO.AtlasMap.GetAtlas(data.atlas)
  self.icon.atlas = atlas
  self.icon.spriteName = data.spriteName
  self.line:SetActive(data.line == true)
end
