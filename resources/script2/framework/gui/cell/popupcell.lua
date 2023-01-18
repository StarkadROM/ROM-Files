local BaseCell = autoImport("BaseCell")
PopUpCell = class("PopUpCell", BaseCell)
function PopUpCell:Init()
  self.label = self:FindComponent("Label", UIRichLabel)
  self.labelSL = SpriteLabel.new(self.label, nil, 36, 36, false)
  self.Img = self:FindComponent("Img", UISprite)
  self:AddCellClickEvent()
end
function PopUpCell:SetData(data)
  self.data = data
  self.labelSL:SetText(data.Name, true)
  self.labelSL:SetLabelColor(PopupCombineCell.ChooseColorConfig.ChooseColor)
end
