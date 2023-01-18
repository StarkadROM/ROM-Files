local baseCell = autoImport("BaseCell")
TechTreeRewardCell = class("TechTreeRewardCell", baseCell)
function TechTreeRewardCell:Init()
  self.icon = self:FindComponent("Icon", UISprite)
  self.numLab = self:FindComponent("NumLabel", UILabel)
  self.first = self:FindGO("First")
  self.got = self:FindGO("Got")
  self:AddCellClickEvent()
end
function TechTreeRewardCell:SetData(data)
  self.id = data and data.id or nil
  self.gameObject:SetActive(self.id ~= nil)
  if self.id then
    IconManager:SetItemIcon(Table_Item[self.id].Icon, self.icon)
    self.numLab.text = data.num and data.num > 1 and tostring(data.num) or ""
    self:SetFirst(data.isFirst)
    self:SetGot(data.isGot)
  end
end
function TechTreeRewardCell:SetFirst(isFirst)
  self.first:SetActive(isFirst and true or false)
end
function TechTreeRewardCell:SetGot(got)
  self.got:SetActive(got and true or false)
end
function TechTreeRewardCell:HandleDragScroll(dragComp)
  UIUtil.HandleDragScrollForObj(self.gameObject, dragComp)
end
