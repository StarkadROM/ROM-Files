autoImport("BaseItemCell")
MaterialItemCell = class("MaterialItemCell", BaseItemCell)
MaterialItemCell.TextColor_Red = "[c][FF3B35]%s[-][/c]/%s"
MaterialItemCell.MaterialType = {
  Material = "Material",
  MaterialItem = "MaterialItem"
}
function MaterialItemCell:Init()
  self.super.Init(self)
  self:AddCellClickEvent()
  self.clickTipCt = self:FindGO("clickTip")
  if self.clickTipCt then
    self.clickTip = self:FindComponent("clickTipLabel", UILabel, self.clickTipCt)
    self.clickTip.text = ZhString.EquipRefinePage_ClickRefineTip
  end
  self.discountTip = self:FindGO("DiscountTip")
  if self.discountTip then
    self.discountTip_Sp = self.discountTip:GetComponent(UISprite)
    self.discountTip_Label = self:FindComponent("Label", UILabel, self.discountTip)
  end
end
function MaterialItemCell:SetData(data)
  self.data = data
  self.super.SetData(self, data)
  if data.neednum then
    local colorFormat = data.num >= data.neednum and "%s/%s" or self.TextColor_Red
    self:UpdateNumLabel(string.format(colorFormat, data.num, data.neednum))
  else
    self:UpdateNumLabel(data.num)
  end
  if self.clickTipCt then
    self:ActiveClickTip(data.id ~= MaterialItemCell.MaterialType.Material)
  end
  if data.discount and data.discount < 100 then
    self:SetDisCountTip(true, self.data.discount)
  else
    self:SetDisCountTip(false)
  end
end
function MaterialItemCell:ActiveClickTip(b)
  if self.clickTipCt then
    self.clickTipCt:SetActive(b)
  end
end
function MaterialItemCell:SetDisCountTip(b, pct)
  if self.discountTip then
    if b then
      pct = math.floor(pct + 0.01)
      self.discountTip:SetActive(true)
      self.discountTip_Label.text = pct .. "%"
      Game.convert2OffLbl(self.discountTip_Label)
    else
      self.discountTip:SetActive(false)
    end
  end
end
function MaterialItemCell:GetCellPartPrefix()
end
