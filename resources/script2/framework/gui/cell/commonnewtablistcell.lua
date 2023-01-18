CommonNewTabListCell = class("CommonNewTabListCell", CoreView)
function CommonNewTabListCell:ctor(obj)
  CommonNewTabListCell.super.ctor(self, obj)
  self:Init()
end
function CommonNewTabListCell:Init()
  self.toggle = self:FindGO("Sprite"):GetComponent(UIToggle)
  if not self.toggle then
    self.toggle = self.gameObject:GetComponent(UIToggle)
  end
  self.longPress = self.gameObject:GetComponent(UILongPress)
  self.sp = self:FindComponent("Sprite", UISprite)
  self.checkmarkSp = self:FindComponent("Checkmark", UISprite)
  self.shadowSp = self:FindComponent("Shadow", UISprite)
  self:AddClickEvent(self.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end
function CommonNewTabListCell:SetData(data)
  self.gameObject:SetActive(data ~= nil)
  if not data then
    return
  end
  self:SetIndex(data.index)
  self:SetName(data.name)
  self:SetIcon(data.icon or data.iconName or data.iconname)
end
function CommonNewTabListCell:SetIndex(index)
  self.index = tonumber(index) or -1
end
function CommonNewTabListCell:SetName(name)
  if StringUtil.IsEmpty(name) then
    return
  end
  self.gameObject.name = tostring(name) or self.__cname
end
function CommonNewTabListCell:SetIcon(iconName)
  IconManager:SetUIIcon(iconName, self.sp)
  IconManager:SetUIIcon(iconName, self.checkmarkSp)
  IconManager:SetUIIcon(iconName, self.shadowSp)
end
