autoImport("BagItemCell")
autoImport("DragDropCell")
BagDragItemCell = class("BagDragItemCell", BagItemCell)
function BagDragItemCell:Init()
  BagDragItemCell.super.Init(self)
  self:InitDragEvent()
end
function BagDragItemCell:InitDragEvent()
  self.dragDrop = DragDropCell.new(self.gameObject:GetComponent(UIDragItem))
  self.dragDrop.dragDropComponent.OnCursor = self.OnCursor
end
function BagDragItemCell:SetData(data)
  BagDragItemCell.super.SetData(self, data)
  if data and data ~= "Grey" and data ~= "Empty" then
    self.dragDrop.dragDropComponent.data = {itemdata = data}
  else
    self.dragDrop.dragDropComponent.data = nil
  end
  if data and data.CodeData and data.CodeData.staticData.id then
    if data.CodeData.staticData.id == 5400 then
      self:AddOrRemoveGuideId(self.gameObject, 201)
    elseif data.CodeData.staticData.id == 5501 then
      self:AddOrRemoveGuideId(self.gameObject, 1011)
    elseif data.CodeData.staticData.id == 5670 then
      self:AddOrRemoveGuideId(self.gameObject, 1031)
    elseif data.CodeData.staticData.id == 14175 then
      self:AddOrRemoveGuideId(self.gameObject, 490)
    elseif data.CodeData.staticData.id == 14176 then
      self:AddOrRemoveGuideId(self.gameObject, 491)
    end
  end
end
function BagDragItemCell:CanDrag(value)
  self.dragDrop:SetDragEnable(value)
end
function BagDragItemCell:OnCellDestroy()
  TableUtility.TableClear(self.dragDrop)
end
function BagDragItemCell.OnCursor(dragItem)
  DragCursorPanel.Instance.ShowItemCell(dragItem)
  EventManager.Me():PassEvent(PackageEvent.ActivateSetShortCut)
end
