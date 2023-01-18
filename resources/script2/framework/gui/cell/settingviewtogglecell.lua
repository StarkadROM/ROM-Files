local BaseCell = autoImport("BaseCell")
SettingViewToggleCell = class("SettingViewToggleCell", BaseCell)
function SettingViewToggleCell:Init()
  self.tog = self.gameObject:GetComponent(UIToggle)
  self.label = self.gameObject:GetComponent(UILabel)
  self.line = self:FindGO("Line")
  self:AddCellClickEvent()
end
function SettingViewToggleCell:SetData(data)
  self.label.text = data.Title
end
function SettingViewToggleCell:SetActive(b)
  if b then
    self.tog.value = true
    self.label.fontSize = 22
    self.label.color = LuaGeometry.GetTempColor(1, 1, 1, 1)
    self.line:SetActive(true)
  else
    self.tog.value = false
    self.label.fontSize = 20
    self.label.color = LuaGeometry.GetTempColor(0.7490196078431373, 0.7490196078431373, 0.7490196078431373, 1)
    self.line:SetActive(false)
  end
end
