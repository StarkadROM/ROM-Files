local BaseCell = autoImport("BaseCell")
YmirTipCell = class("YmirTipCell", BaseCell)
function YmirTipCell:Init()
  self.icon = self:FindComponent("Icon", UISprite)
  self.name = self:FindComponent("SaveName", UILabel)
  self.charName = self:FindComponent("CharName", UILabel)
  self:AddClickEvent(self.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end
function YmirTipCell:SetData(data)
  self.data = data
  if data then
    local profConfig = Table_Class[data.profession]
    if profConfig then
      IconManager:SetProfessionIcon(profConfig.icon, self.icon)
      self.icon:MakePixelPerfect()
      self.icon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(0.45, 0.45, 1)
    end
    self.name.text = AppendSpace2Str(data.recordname) or ""
    self.charName.text = data.charname or ""
  end
end
