autoImport("ItemTipBaseCell")
autoImport("ItemNewCellForTips")
EquipTipCell = class("EquipTipCell", ItemTipBaseCell)
function EquipTipCell:InitItemCell(container)
  self:TryInitItemCell(container, "ItemNewCellForTips", ItemNewCellForTips)
end
function EquipTipCell:InitEvent()
  EquipTipCell.super.InitEvent(self)
  self:AddButtonEvent("CardUseButton", function(go)
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end
function EquipTipCell:SetData(data)
  EquipTipCell.super.SetData(self, data)
  self.gameObject:SetActive(data ~= nil)
end
