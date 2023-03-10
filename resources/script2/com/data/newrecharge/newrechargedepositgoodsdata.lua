NewRechargeDepositGoodsData = class("NewRechargeDepositGoodsData")
NewRechargeDepositGoodsData.ActivityTypeEnum = {
  discount = 1,
  gainMore = 2,
  moreTimes = 3
}
function NewRechargeDepositGoodsData:ctor()
  NewRechargeDepositGoodsData.GetLimitStr()
end
function NewRechargeDepositGoodsData.GetLimitStr()
  if not NewRechargeDepositGoodsData.LimitStr then
    NewRechargeDepositGoodsData.LimitStr = {
      [1] = ZhString.NewRecharge_BuyLimit_Char_Ever,
      [2] = ZhString.NewRecharge_BuyLimit_Acc_Monthly,
      [3] = ZhString.NewRecharge_BuyLimit_Acc_Ever,
      [4] = nil,
      [5] = nil,
      [6] = nil,
      [7] = ZhString.NewRecharge_BuyLimit_Acc_Ever,
      [8] = ZhString.NewRecharge_BuyLimit_Acc_Daily
    }
  end
  return NewRechargeDepositGoodsData.LimitStr
end
function NewRechargeDepositGoodsData:ResetData(id)
  TableUtility.TableClear(self)
  self.id = id
  self.isDeposit = true
  self.productConf = Table_Deposit[id]
  self.isOnSale = self.productConf.Switch == 1
  if self.isOnSale then
    self.itemID = self.productConf.ItemId
    self.itemConf = Table_Item[self.itemID]
    self.purchaseTimes = NewRechargeDepositItemCtrl.Ins():GetLuckyBagPurchaseTimes(id)
  end
  self.activity = NewRechargeDepositItemCtrl.Ins():GetProductActivity(self.id)
  if self.activity ~= nil then
    self.discountActivity = self.activity[1]
    if self.discountActivity ~= nil then
      local dActivityEndTime = self.discountActivity[5]
      local serverTime = ServerTime.CurServerTime() / 1000
      if dActivityEndTime > serverTime then
        local activityTimes = self.discountActivity[1]
        local activityUsedTimes = self.discountActivity[3]
        if activityTimes > activityUsedTimes then
          self.activityProductID = self.discountActivity[2]
          self.ori_productConf = self.productConf
          self.productConf = Table_Deposit[self.activityProductID]
        end
      end
    end
    self.gainMoreActivity = self.activity[2]
    self.moreTimesActivity = self.activity[3]
  end
  self:UpdatePurchaseLimit()
  self:UpdateBatchInfo()
end
function NewRechargeDepositGoodsData:UpdatePurchaseLimit()
  if self.productConf then
    local id = self.productConf.id
    local limit = NewRechargeDepositItemCtrl.Ins():GetLuckyBagPurchaseLimit(id)
    self.purchaseLimit_N = limit ~= 0 and limit or self.productConf.MonthLimit
    self.purchaseLimit_N = self.purchaseLimit_N or 0
    self.purchaseLimitStr = self.LimitStr[self.productConf.LimitType]
  end
end
function NewRechargeDepositGoodsData:GetFreeBonusCount()
  local zenyAdditionCount
  if NewRechargeProxy.CDeposit:IsFPR(self.id) then
    zenyAdditionCount = self.productConf and self.productConf.VirginCount or 0
  else
    zenyAdditionCount = self.productConf and self.productConf.Count2 or 0
  end
  return zenyAdditionCount
end
function NewRechargeDepositGoodsData:UpdateBatchInfo()
  local originToBatchProduct = NewRechargeDepositItemCtrl.Ins():GetBatchProductByOrigin(self.id)
  local batchToOriginProduct = NewRechargeDepositItemCtrl.Ins():GetOriginProductByBatch(self.id)
  local originConf, batchConf
  if originToBatchProduct then
    self.batch_is_Origin = true
    originConf = Table_Deposit[self.id]
    batchConf = Table_Deposit[originToBatchProduct]
  elseif batchToOriginProduct then
    self.batch_is_Batch = true
    originConf = Table_Deposit[batchToOriginProduct]
    batchConf = Table_Deposit[self.id]
  end
  if not originConf or not batchConf then
    return
  end
  local origin_purchaseTimes = NewRechargeDepositItemCtrl.Ins():GetLuckyBagPurchaseTimes(originConf.id)
  local origin_purchaseLimit_N = NewRechargeDepositItemCtrl.Ins():GetLuckyBagPurchaseLimit(originConf.id)
  if origin_purchaseLimit_N == 0 or not origin_purchaseLimit_N then
    origin_purchaseLimit_N = originConf.MonthLimit
  end
  self.origin_alreadyBought = origin_purchaseTimes ~= nil and origin_purchaseLimit_N > 0 and origin_purchaseTimes >= origin_purchaseLimit_N
  local batchDailyCount = NewRechargeDepositItemCtrl.Ins():GetLuckyBagBatchDailyCount(originConf.id)
  self.batch_alreadyBought = batchDailyCount and batchDailyCount > 0
  self.batch_DailyCount = batchDailyCount or 0
  if self.origin_alreadyBought or self.batch_alreadyBought then
    if self.batch_is_Batch and self.batch_DailyCount == 1 then
      self.purchaseState = 1
    else
      self.purchaseState = 0
    end
  else
    self.purchaseState = 1
  end
end
function NewRechargeDepositGoodsData:GetItemData()
  if self.itemID and self.itemData == nil then
    self.itemData = ItemData.new("shop", self.itemID)
  end
  return self.itemData
end
