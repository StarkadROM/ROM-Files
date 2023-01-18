autoImport("BaseItemCell")
MaterialNCell = class("MaterialNCell", BaseItemCell)
MaterialNCell.NotFull = "[ff2a00]"
MaterialNCell.Full = "[7e5018]"
function MaterialNCell:Init()
  self.super.Init(self)
  self:AddCellClickEvent()
end
function MaterialNCell:SetData(data)
  self.data = data
  self.super.SetData(self, data)
  local colorStr = data.num >= data.neednum and MaterialNCell.Full or MaterialNCell.NotFull
  self:UpdateNumLabel(colorStr .. data.num .. "/" .. data.neednum .. "[-]", 0, -60, 0)
end
