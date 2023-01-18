local BaseCell = autoImport("BaseCell")
ReturnActivityShopCell = class("ReturnActivityShopCell", BaseCell)
function ReturnActivityShopCell:Init()
  ReturnActivityShopCell.super.Init(self)
  self:FindObjs()
  self:AddCellClickEvent()
end
function ReturnActivityShopCell:FindObjs()
  self.name = self:FindGO("Name"):GetComponent(UILabel)
  self.icon = self:FindGO("Icon"):GetComponent(UISprite)
  self.num = self:FindGO("Num"):GetComponent(UILabel)
  self.cost = self:FindGO("Cost")
  self.costLabel = self:FindGO("CostLabel", self.cost):GetComponent(UILabel)
  self.costIcon = self:FindGO("CostIcon", self.cost):GetComponent(UISprite)
  self.soldOut = self:FindGO("SoldOut")
  self.boxCollider = self.gameObject:GetComponent(BoxCollider)
end
function ReturnActivityShopCell:SetData(data)
  self.data = data
  self.goodsID = data
  local shopID = ReturnActivityProxy.Instance.shopID
  local shopType = ReturnActivityProxy.Instance.shopType
  self.shopItemData = ShopProxy.Instance:GetShopItemDataByTypeId(shopType, shopID, self.goodsID)
  self.itemID = self.shopItemData.goodsID
  self.itemConf = Table_Item[self.itemID]
  IconManager:SetItemIcon(self.itemConf.Icon, self.icon)
  self.name.text = self.itemConf.NameZh
  self.num.text = self.shopItemData
  local totalPrice = self.shopItemData:GetBuyDiscountPrice(self.shopItemData.ItemCount, shopID)
  self.costLabel.text = StringUtil.NumThousandFormat(totalPrice)
  local moneyId = self.shopItemData.ItemID or 3005457
  local icon = Table_Item[moneyId] and Table_Item[moneyId].Icon
  IconManager:SetItemIcon(icon, self.costIcon)
  local canBuyCount = HappyShopProxy.Instance:GetCanBuyCount(self.shopItemData)
  if canBuyCount and canBuyCount <= 0 then
    self.icon.alpha = 0.6
    self.soldOut:SetActive(true)
    self.cost:SetActive(false)
    self.boxCollider.enabled = false
  else
    self.icon.alpha = 1
    self.soldOut:SetActive(false)
    self.cost:SetActive(true)
    self.boxCollider.enabled = true
  end
end
