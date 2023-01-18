autoImport("ShopItemData")
QuickBuyItemData = class("QuickBuyItemData")
function QuickBuyItemData:ctor(data)
  self:SetData(data)
end
function QuickBuyItemData:SetData(data)
  if data then
    self.id = data.id
    self.needCount = data.count
    self.price = 0
    self.totalCount = 0
    self.canChoose = false
    self.isChoose = false
  end
end
function QuickBuyItemData:SetNeedCount(needCount)
  self.needCount = needCount
end
function QuickBuyItemData:SetExchangeInfo(data)
  if data then
    if self.needCount <= data.count then
      self.origin = QuickBuyOrigin.Exchange
      self.moneyType = QuickBuyMoney.Zeny
    end
    self.price = data.price
    self.totalCount = data.count
    self.orderId = data.order_id
    self.publicityId = data.publicity_id
    local itemData = data.item_data
    if itemData and itemData.base and itemData.base.id ~= 0 then
      self.itemData = ItemData.new(itemData.base.guid, itemData.base.id)
      self.itemData:ParseFromServerData(itemData)
      self.itemData.num = 1
    end
  end
end
function QuickBuyItemData:SetShopInfo(data)
  if data then
    self.origin = QuickBuyOrigin.Shop
    self.shopItemData = ShopItemData.new(data)
    if self.shopItemData.LimitType == 0 then
      local goodsCount = self.shopItemData.goodsCount
      if goodsCount ~= nil and goodsCount > 1 then
        self.needCount = math.ceil(self.needCount / goodsCount) * goodsCount
      end
      self.totalCount = self.needCount
    else
      local boughtCount = 0
      local cachedHaveBoughtItemCount = HappyShopProxy.Instance:GetCachedHaveBoughtItemCount()
      if cachedHaveBoughtItemCount ~= nil then
        boughtCount = cachedHaveBoughtItemCount[self.shopItemData.id]
        boughtCount = boughtCount or 0
      else
        boughtCount = 0
      end
      local limitCount = self.shopItemData.LimitNum - boughtCount
      if limitCount < self.needCount then
        self.totalCount = 0
      else
        self.totalCount = self.needCount
      end
    end
    self.price = self.shopItemData:GetBuyFinalPrice(data.moneycount, 1)
    self.moneyType = data.moneyid
    self.haveShopBuyCount = 0
    self.publicityId = 0
    self.reason = nil
  end
end
function QuickBuyItemData:SetBuyResult(data)
  if data then
    self.buyResult = data
  end
end
function QuickBuyItemData:SetRecordId(recordId)
  self.recordId = recordId
end
function QuickBuyItemData:SetReason()
  if self.totalCount == 0 then
    self.reason = QuickBuyReason.NotExist
  elseif self.publicityId and self.publicityId ~= 0 then
    self.reason = QuickBuyReason.Publicity
  elseif self.needCount > self.totalCount then
    self.reason = QuickBuyReason.NotEnough
  elseif self.shopItemData ~= nil and self.shopItemData:GetLock() then
  else
    self.canChoose = true
    self.isChoose = true
  end
end
function QuickBuyItemData:SetChoose()
  self.isChoose = not self.isChoose
end
function QuickBuyItemData:SetCompareEquipPrice(price)
  if self.isCompareEquip then
    if price < self.price then
      self.reason = QuickBuyReason.PriceHigher
    elseif price > self.price then
      self.reason = QuickBuyReason.PriceLower
    end
  end
end
function QuickBuyItemData:SetShopBuyCount(count)
  if count ~= nil then
    self.haveShopBuyCount = self.haveShopBuyCount + count
  end
end
function QuickBuyItemData:GetItemData()
  if self.itemData == nil then
    self.itemData = ItemData.new("QuickBuy", self.id)
    self.itemData.num = self.needCount
  end
  return self.itemData
end
function QuickBuyItemData:GetTotalCost()
  return self.price * self:GetNeedCount()
end
function QuickBuyItemData:GetCompareEquipPrice()
  if self.canChoose and ItemData.CheckItemCanTrade(self.id) then
    local site = RoleEquipBagData.GetEquipSiteByItemid(self.id)
    local siteEquip = BagProxy.Instance.roleEquip:GetEquipBySite(site)
    if siteEquip ~= nil and siteEquip.staticData.id == self.id then
      self.isCompareEquip = true
      return siteEquip
    end
  end
  return nil
end
function QuickBuyItemData:GetNeedCount()
  if self.shopItemData ~= nil then
    local goodsCount = self.shopItemData.goodsCount
    if goodsCount ~= nil and goodsCount > 1 then
      return self.needCount / goodsCount
    end
  end
  return self.needCount
end
function QuickBuyItemData:GetShopBuyCount()
  local count = self:GetNeedCount() - self.haveShopBuyCount
  if count > 999 then
    count = 999
  end
  return count
end
function QuickBuyItemData:IsBuySuccess()
  return self.buyResult == true
end
function QuickBuyItemData:CheckExchangeAvailable()
  return self.orderId and self.reason == nil
end
function QuickBuyItemData:PreCheckShopAvailable(goods)
  local boughtCount = 0
  local cachedHaveBoughtItemCount = HappyShopProxy.Instance:GetCachedHaveBoughtItemCount()
  if cachedHaveBoughtItemCount ~= nil then
    boughtCount = cachedHaveBoughtItemCount[goods.id]
    boughtCount = boughtCount or 0
  else
    boughtCount = 0
  end
  if goods.maxcount == 0 then
    return true
  end
  local limitCount = goods.maxcount - boughtCount
  if limitCount < self.needCount then
    return false
  else
    return true
  end
end
