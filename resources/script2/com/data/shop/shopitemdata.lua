ShopItemData = class("ShopItemData")
ShopItemData.LockType = {
  Quest = SessionShop_pb.ESHOPLOCKTYPE_QUEST,
  GuildBuilding = SessionShop_pb.ESHOPLOCKTYPE_GUILDBUILDING,
  Manual = SessionShop_pb.ESHOPLOCKTYPE_MANUAL
}
ShopItemData.PresentType = {
  Normal = SessionShop_pb.EPRESENTTYPE_NORMAL,
  Lock = SessionShop_pb.EPRESENTTYPE_LOCK
}
function ShopItemData:ctor(data)
  self:SetData(data)
end
function ShopItemData:SetData(data)
  self.id = data.id
  self.ShopOrder = data.shoporder
  if data.itemid ~= 0 then
    self.goodsID = data.itemid
  end
  if data.num ~= 0 then
    self.goodsCount = data.num
  end
  if data.skillid ~= 0 then
    self.SkillID = data.skillid
  end
  if data.haircolorid ~= 0 then
    self.hairColorID = data.haircolorid
  end
  if data.clothcolorid ~= 0 then
    self.clothColorID = data.clothcolorid
  end
  self.PreCost = data.precost
  self.ItemID = data.moneyid
  self.ItemCount = data.moneycount
  if data.moneyid2 ~= 0 then
    self.ItemID2 = data.moneyid2
    self.ItemCount2 = data.moneycount2
  end
  self.business = data.business
  self.des = data.des
  if string.find(self.des, "%s") then
    self.des = string.format(self.des, data.des_option[1])
  end
  self.LevelDes = data.levdes
  self.BaseLv = data.lv
  self.Discount = data.discount
  self.discountMax = data.discountmax
  self.actDiscount = data.actdiscount
  self.LimitType = data.limittype
  self.LimitNum = data.maxcount
  if data.ifmsg ~= 0 then
    self.IfMsg = data.ifmsg
  end
  if data.removedate ~= 0 then
    self.RemoveDate = data.removedate
  end
  if data.adddate ~= 0 then
    self.AddDate = data.adddate
  end
  self.extraDes = data.extrades
  self.lockType = data.locktype
  self.lockArg = data.lockarg
  self.produceNum = data.producenum
  self.MenuID = data.menuid
  self.source = data.source
  self.itemtype = data.itemtype
  self.secDiscount = data.secondiscount or 0
  self.noticedate = data.noticedate
  local presentation = data.presentation
  if presentation.presenttype == ShopItemData.PresentType.Normal then
    self.presentType = nil
    self.presentMsgid = nil
    self.presentMenuids = nil
  else
    self.presentType = presentation.presenttype
    if presentation.msgid ~= 0 then
      self.presentMsgid = presentation.msgid
    end
    if 0 < #presentation.menuid then
      local presentMenuids = self.presentMenuids
      if presentMenuids == nil then
        presentMenuids = {}
        self.presentMenuids = presentMenuids
      else
        TableUtility.ArrayClear(presentMenuids)
      end
      for i = 1, #presentation.menuid do
        presentMenuids[#presentMenuids + 1] = presentation.menuid[i]
      end
    end
  end
  self:_SetMenu(data.shoptype)
  self.menuHide = self.lock and nil ~= data.menushow and data.menushow ~= 0
  self.tabid = data.tabid
  self.maxlimitnum = data.maxlimitnum
  self.isGoodData = true
  if self.goodsID and Table_Item[self.goodsID] then
    self.nameZh = Table_Item[self.goodsID].NameZh or ""
  else
    self.nameZh = ""
  end
  self.unlocknextid = data.unlocknextid
  self.unlocknextcount = data.unlocknextcount
  self.unlockpreid = data.unlockpreid
  self.next_buy_time = data.next_buy_time
  self.quality = data.quality
  if data.showinfo and 0 < #data.showinfo then
    self.showInfo = NewRechargeProxy.ParseItemShowInfo_Shop(data.showinfo, self.goodsID)
  end
  if data.acclimitshow ~= nil and 1 < #data.acclimitshow then
    self.accAreadyBuyCount = data.acclimitshow[1]
    self.accMaxBuyLimitNum = data.acclimitshow[2]
  else
    self.accAreadyBuyCount = 0
    self.accMaxBuyLimitNum = 0
  end
  local changeCost = data.change_cost
  if changeCost and #changeCost > 0 then
    self.changeCost = {}
    for i = 1, #changeCost do
      local stepCost = {}
      TableUtility.TableShallowCopy(stepCost, changeCost[i])
      table.insert(self.changeCost, stepCost)
    end
  end
  self.sum_count = data.sum_count or 0
  self.cycleGiftGroup = data.cyclegiftgroup
  self.cycleGiftType = data.cyclegifttype
  self.cycleGiftCycle = data.cyclegiftcycle
end
function ShopItemData:_SetMenu(shoptype)
  self.menuLockDesc = nil
  self.lockReasonDesc = nil
  if self.lockType == ShopItemData.LockType.GuildBuilding then
    self.lock = GuildBuildingProxy.Instance:ShopGoodsLocked(shoptype, self.id)
    if self.lock then
      self.lockReasonDesc = self.lockArg
    end
  elseif self.MenuID ~= 0 and not FunctionUnLockFunc.Me():CheckCanOpen(self.MenuID) then
    self.lock = true
    local data = Table_MenuUnclock[self.goodsID]
    if data ~= nil and 0 < #data.MenuDes then
      self.menuLockDesc = data.MenuDes
    end
    if self.lockType == ShopItemData.LockType.Quest then
      self.lockReasonDesc = string.format(ZhString.HappyShop_Lock, self.lockArg)
    elseif self.lockArg ~= "" then
      self.menuLockDesc = self.lockArg
    end
  elseif self.lockType == ShopItemData.LockType.Manual then
    self.lock = not AdventureDataProxy.Instance:IsFurnitureUnlock(self.goodsID)
    if self.lock then
      self.menuLockDesc = ZhString.HappyShop_ManulLock
    end
  elseif self.noticedate ~= 0 then
    self.lock = self.AddDate > ServerTime.CurServerTime() / 1000
    if self.lock then
      local validTime = os.date("*t", self.AddDate)
      self.menuLockDesc = string.format(ZhString.HappyShop_NoticeTime, validTime.month, validTime.day, validTime.hour)
    end
  else
    self.lock = false
  end
end
function ShopItemData:SetCurProduceNum(num)
  if num and self.produceNum and self.produceNum > 0 then
    local curNum = self.produceNum - num
    if curNum < 0 then
      curNum = 0
    end
    self.curProduceNum = curNum
  end
end
function ShopItemData:CheckCanRemove()
  if self.RemoveDate and ServerTime.CurServerTime() / 1000 >= self.RemoveDate then
    return true
  end
  return false
end
function ShopItemData:CheckIsNewAdd()
  if self.AddDate then
    local newItemRange = GameConfig.ZenyShop and GameConfig.ZenyShop.NewItemTimeRange
    if newItemRange and ServerTime.CurServerTime() / 1000 < self.AddDate + newItemRange * 3600 then
      return true
    end
  end
  return false
end
function ShopItemData:CheckLimitType(index)
  if self.LimitType then
    return self.LimitType & index > 0
  end
  return false
end
function ShopItemData:GetItemData()
  if self.goodsID and self.itemData == nil then
    self.itemData = ItemData.new("shop", self.goodsID)
  end
  return self.itemData
end
function ShopItemData:GetLock()
  return self.lock
end
function ShopItemData:GetMenuDes()
  local desc = self:GetLockDesc()
  if desc == nil then
    return self.lockReasonDesc
  end
  return desc
end
function ShopItemData:GetQuestLockDes()
  if self.lockType == ShopItemData.LockType.Quest then
    return self.lockReasonDesc
  end
  return nil
end
function ShopItemData:GetLockDesc()
  return self.menuLockDesc
end
function ShopItemData:GetLockType()
  return self.lockType
end
function ShopItemData:GetActDiscountCanBuyCount()
  if self.actDiscount ~= 0 and self.discountMax then
    local canBuyCount = self.discountMax - HappyShopProxy.Instance:GetDiscountItemCount(self.id)
    if canBuyCount < 0 then
      canBuyCount = 0
    end
    return canBuyCount
  end
end
function ShopItemData:GetBuyDiscountPrice(price, count)
  local discount = self.Discount
  local actDiscount = self.actDiscount
  local leftCount = 0
  local discountPrice = 0
  if 0 < self.secDiscount then
    price = price * self.secDiscount / 100
  end
  if self.changeCost and 0 < #self.changeCost then
    local canBuyCount = self.discountMax
    if actDiscount ~= 0 then
      canBuyCount = self.discountMax - HappyShopProxy.Instance:GetDiscountItemCount(self.id)
    end
    if canBuyCount < 0 then
      canBuyCount = 0
    end
    local curCount = self.sum_count or 0
    local targetCount = curCount + count
    local curStep = 1
    for i = curCount + 1, targetCount do
      for j = curStep, #self.changeCost do
        local costStep = self.changeCost[j]
        if i >= costStep.mincount and i <= costStep.maxcount or costStep.maxcount == 0 then
          curStep = j
          if canBuyCount > 0 then
            discountPrice = discountPrice + self:_GetPrice(costStep.moneycount, actDiscount, 1)
            canBuyCount = canBuyCount - 1
          else
            discountPrice = discountPrice + self:_GetPrice(costStep.moneycount, discount, 1)
          end
        end
      end
    end
    return discountPrice, canBuyCount > 0 and actDiscount or discount
  end
  if actDiscount ~= 0 then
    local canBuyCount = self.discountMax - HappyShopProxy.Instance:GetDiscountItemCount(self.id)
    if canBuyCount < 0 then
      canBuyCount = 0
    end
    leftCount = count - canBuyCount
    if leftCount > 0 then
      discountPrice = self:_GetPrice(price, actDiscount, canBuyCount)
    else
      return self:_GetPrice(price, actDiscount, count), actDiscount
    end
  end
  if leftCount > 0 then
    return discountPrice + self:_GetPrice(price, discount, leftCount), discount
  else
    return self:_GetPrice(price, discount, count), discount
  end
end
function ShopItemData:_GetPrice(price, discount, count)
  return math.floor(price * discount / 100) * count
end
function ShopItemData:GetTotalBuyDiscount(totalCost)
  if self.business == 1 then
    local buyDiscount = Game.Myself.data.props:GetPropByName("BuyDiscount"):GetValue() / 1000
    local discount = math.floor(totalCost * buyDiscount)
    return buyDiscount, discount, totalCost - discount
  else
    return 0, 0, totalCost
  end
end
function ShopItemData:GetBuyFinalPrice(price, count)
  local totalPrice = self:GetBuyDiscountPrice(price, count)
  local discount, discountCount
  discount, discountCount, totalPrice = self:GetTotalBuyDiscount(totalPrice)
  return totalPrice
end
function ShopItemData:SetSoldCount(server_soldCount)
  self.soldCount = server_soldCount
end
function ShopItemData:CheckPresentMenu()
  if self.presentMenuids ~= nil then
    local _FunctionUnLockFunc = FunctionUnLockFunc.Me()
    for i = 1, #self.presentMenuids do
      if _FunctionUnLockFunc:CheckCanOpen(self.presentMenuids[i]) then
        return true
      end
    end
  end
  return false
end
function ShopItemData:GetNextBuyTime()
  return self.next_buy_time
end
function ShopItemData:GetChangeCost(index)
  local curIndex = index or self.sum_count + 1
  if self.changeCost and #self.changeCost > 0 then
    for i = 1, #self.changeCost do
      local stepCost = self.changeCost[i]
      if curIndex >= stepCost.mincount and curIndex <= stepCost.maxcount then
        return stepCost.moneycount
      end
    end
    return self.changeCost[#self.changeCost].moneycount
  end
end
function ShopItemData:IsCycleGift()
  return self.cycleGiftGroup and self.cycleGiftGroup > 0
end
function ShopItemData:HasPreUnlockId()
  return self.unlockpreid and self.unlockpreid > 0
end
function ShopItemData:HasNextUnlockId()
  return self.unlocknextid and self.unlocknextid > 0
end
function ShopItemData:GetRemoveDate()
  if self:IsCycleGift() and self.cycleGiftCycle == 1 then
    return ClientTimeUtil.GetWeeklyRefreshTime()
  end
  return self.RemoveDate
end
