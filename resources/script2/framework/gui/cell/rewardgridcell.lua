local BaseCell = autoImport("BaseCell")
RewardGridCell = class("RewardGridCell", BaseCell)
function RewardGridCell:Init()
  self:FindObjs()
end
function RewardGridCell:FindObjs()
  self.icon = self:FindGO("Icon"):GetComponent(UISprite)
  self.count = self:FindGO("Num"):GetComponent(UILabel)
  self:AddCellClickEvent()
end
function RewardGridCell:SetData(data)
  self.data = data
  local staticData = self.data.itemData.staticData
  if staticData then
    IconManager:SetItemIcon(staticData.Icon, self.icon)
  end
  local num = ""
  if self.data.num and self.data.num ~= 1 then
    num = self.data.num
  end
  self.count.text = num
end
