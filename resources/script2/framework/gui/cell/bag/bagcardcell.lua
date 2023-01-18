local BaseCell = autoImport("BaseCell")
BagCardCell = class("BagCardCell", BaseCell)
autoImport("ItemCardCell")
function BagCardCell:Init()
  self.emptyCard = self:FindGO("EmptyCard")
  self:AddCellClickEvent()
end
function BagCardCell:GetItemCardCell()
  if self.cardCell == nil then
    local cardGO = self:LoadPreferb("cell/ItemCardCell", self.gameObject)
    self.cardCell = ItemCardCell.new(cardGO)
  end
  return self.cardCell
end
function BagCardCell:SetData(data)
  self.data = data
  self.emptyCard:SetActive(data == nil)
  self:GetItemCardCell():SetData(data)
end
