autoImport("NewRechargePrototypeGoodsCell")
NewRechargeNormalTShopGoodsCell = class("NewRechargeNormalTShopGoodsCell", NewRechargePrototypeGoodsCell)
function NewRechargeNormalTShopGoodsCell:FindObjs()
  self.u_labProductName = self:FindGO("Title", self.gameObject):GetComponent(UILabel)
  self.u_labProductNum = self:FindGO("Count", self.gameObject):GetComponent(UILabel)
  self.u_spItemIcon = self:FindGO("Icon", self.gameObject):GetComponent(UISprite)
  self.u_itemPriceBtnBg = self:FindComponent("PriceBtn", UISprite)
  self.u_itemPriceBtnBc = self:FindComponent("PriceBtn", BoxCollider)
  self.u_itemPricePH = self:FindGO("PricePosHolder", self.u_itemPriceBtnBg.gameObject)
  self.u_itemPriceIcon = self:FindComponent("PriceIcon", UISprite)
  self.u_itemPrice = self:FindComponent("Price", UILabel)
  self.u_itemOriPrice = self:FindComponent("OriPrice", UILabel)
  self.u_desMark = self:FindGO("DesMark", self.gameObject)
  self.u_desMarkText = self:FindComponent("Des", UILabel, self.u_desMark)
  self.u_soldOutMark = self:FindGO("SoldOutMark", self.gameObject)
  self.u_discountMark = self:FindGO("DiscountMark", self.gameObject)
  self.u_discountValue = self:FindComponent("Value1", UILabel, self.u_discountMark)
  self.u_discountBG = self:FindComponent("BG", UISprite, self.u_discountMark)
  self.u_newMark = self:FindGO("NewMark", self.gameObject)
  local u_newMarkText = self:FindComponent("markLab", UILabel, self.u_newMark)
  if u_newMarkText then
    u_newMarkText.text = ZhString.HappyShop_NewMark
  end
  self.u_fxxk_redtip = self:FindGO("RedTipCell", self.gameObject)
  self.u_buyBtn = self:FindGO("PriceBtn", self.gameObject)
end
function NewRechargeNormalTShopGoodsCell:RegisterClickEvent()
  self:AddClickEvent(self.gameObject, function()
    self:Purchase()
  end)
  self:AddClickEvent(self.u_spItemIcon.gameObject, function()
    self:OnClickForViewGoodsItem()
  end)
end
function NewRechargeNormalTShopGoodsCell:SetData(data)
  NewRechargeNormalTShopGoodsCell.super.SetData(self, data)
end
function NewRechargeNormalTShopGoodsCell:SetData_Shop()
  self.info = NewRechargeProxy.Ins:GenerateShopGoodsInfo(self.data.ShopID)
  self.shopGoodsInfo = self.info
end
function NewRechargeNormalTShopGoodsCell:SetCell()
  NewRechargeNormalTShopGoodsCell.super.SetCell(self)
  if self.data.Icon then
  end
  if self.data.Picture then
    if not IconManager:SetZenyShopItem(self.data.Picture, self.u_spItemIcon) then
      IconManager:SetItemIcon(self.data.Picture, self.u_spItemIcon)
    end
    self.u_spItemIcon:MakePixelPerfect()
    self.u_spItemIcon.transform.localScale = LuaGeometry.GetTempVector3(0.8, 0.8, 0.8)
  end
end
function NewRechargeNormalTShopGoodsCell:SetCell_Shop()
  if self.info.itemConf == nil then
    redlog("Good Is Nil:", self.info.itemID)
    return
  end
  IconManager:SetItemIcon(self.info.itemConf.Icon, self.u_spItemIcon)
  self.u_labProductNum.text = self.info.shopItemData.goodsCount
  self.u_labProductName.text = self.info.itemConf.NameZh
  self.u_itemPrice.text = FunctionNewRecharge.FormatMilComma(self.info:GetCurPrice())
  self.u_itemPriceIcon:ResetAndUpdateAnchors()
  local limitCanBuyCount = self.info:GetLimitCanBuyCount()
  local isSaleOut = limitCanBuyCount and limitCanBuyCount <= 0 or false
  self:Set_SoldOutMark(isSaleOut)
  self:Set_NewMark(self.info:IsNewAdd())
  local desc = self.info.shopItemData.extraDes
  self:Set_DescMark(not StringUtil.IsEmpty(desc), desc)
  local moneyItem = Table_Item[self.info.shopItemData.ItemID]
  if moneyItem and moneyItem.Icon and not isSaleOut then
    IconManager:SetItemIcon(moneyItem.Icon, self.u_itemPriceIcon)
  end
  self.u_itemPrice.gameObject:SetActive(not isSaleOut)
  self.u_itemPriceIcon.gameObject:SetActive(not isSaleOut)
  local actDiscountLeftCount = not limitCanBuyCount and self.info.shopItemData:GetActDiscountCanBuyCount()
  local hasDisCount = self.info:GetDisCount() < 100 and (not actDiscountLeftCount or actDiscountLeftCount ~= 0)
  local oriPrice = self.info:GetOriPrice()
  if hasDisCount then
    self:Set_DiscountMark(true, oriPrice, self.info:GetCurPrice(), true)
  else
    self:Set_DiscountMark(false, oriPrice)
  end
  if self.u_fxxk_redtip then
    self.u_fxxk_redtip:SetActive(false)
    if GameConfig.ShopRed and GameConfig.ShopRed.Shopid and 0 ~= TableUtility.ArrayFindIndex(GameConfig.ShopRed.Shopid, self.info.shopItemData.id) then
      local pre_buyCount = HappyShopProxy.Instance:GetCachedHaveBoughtItemCount(self.info.shopItemData.id) or 0
      self.u_fxxk_redtip:SetActive(pre_buyCount == 0)
    end
  end
end
function NewRechargeNormalTShopGoodsCell:Purchase_Shop()
  self.info.shopItemData.m_checkFunc = nil
  self.info.shopItemData.m_checkTable = nil
  self:PassEvent(NewRechargeEvent.GoodsCell_ShowShopItemPurchaseDetail, {
    info = self.info.shopItemData
  })
end
function NewRechargeNormalTShopGoodsCell:OnClickForViewGoodsItem()
  local itemConfID = self.info.itemID
  if itemConfID ~= nil then
    self:PassEvent(NewRechargeEvent.GoodsCell_ShowTip, itemConfID)
  end
end
function NewRechargeNormalTShopGoodsCell:IsHaveEnoughCostForBuy()
  local bCatGold = MyselfProxy.Instance:GetLottery()
  if bCatGold < self.info:GetCurPrice() then
    MsgManager.ShowMsgByID(3634)
    return false
  else
    return true
  end
end
