local baseCell = autoImport("BaseCell")
ShopMultiplePriceCell = class("ShopMultiplePriceCell", baseCell)
function ShopMultiplePriceCell:Init()
  self:FindObjs()
end
function ShopMultiplePriceCell:FindObjs()
  self.title = self:FindGO("Title"):GetComponent(UILabel)
  self.totalPrice = self:FindGO("TotalPrice"):GetComponent(UILabel)
  self.totalPriceIcon = self:FindGO("TotalPriceIcon"):GetComponent(UISprite)
end
function ShopMultiplePriceCell:SetData(data)
  self.data = data
  if data ~= nil then
    local staticData = Table_Item[data]
    if staticData ~= nil then
      self.title.text = staticData.NameZh
      local icon = staticData.Icon
      IconManager:SetItemIcon(icon, self.totalPriceIcon)
    end
  end
end
function ShopMultiplePriceCell:SetPrice(price)
end
function ShopMultiplePriceCell:SetTotalPrice(price)
  if price ~= nil then
    self.totalPrice.text = StringUtil.NumThousandFormat(price)
  end
end
