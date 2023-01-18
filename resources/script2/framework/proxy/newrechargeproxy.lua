autoImport("UIModelZenyShop")
autoImport("UIModelMonthlyVIP")
autoImport("NewRechargeTShopData")
autoImport("NewRechargeTCardData")
autoImport("NewRechargeTDepositData")
autoImport("NewRechargeTHotData")
autoImport("NewRechargeShopItemCtrl")
autoImport("NewRechargeCardItemCtrl")
autoImport("NewRechargeDepositItemCtrl")
autoImport("NewRechargeDepositGoodsData")
autoImport("NewRechargeShopGoodsData")
autoImport("PurchaseDeltaTimeLimit")
autoImport("FunctionNewRecharge")
autoImport("FuncPurchase")
autoImport("MonthlyVIPTip")
autoImport("Table_ShopShow")
NewRechargeProxy = class("NewRechargeProxy", pm.Proxy)
NewRechargeProxy.Instance = nil
NewRechargeProxy.NAME = "NewRechargeProxy"
NewRechargeProxy.UseCompatVer = false
function NewRechargeProxy:ctor(proxyName, data)
  self.proxyName = proxyName or NewRechargeProxy.NAME
  if NewRechargeProxy.Instance == nil then
    NewRechargeProxy.Instance = self
  end
  if NewRechargeProxy.Ins == nil then
    NewRechargeProxy.Ins = self
  end
  if not self.ShopItemCtrl then
    self.ShopItemCtrl = NewRechargeShopItemCtrl.Ins()
  end
  if not self.CardItemCtrl then
    self.CardItemCtrl = NewRechargeCardItemCtrl.Ins()
  end
  if not self.DepositItemCtrl then
    self.DepositItemCtrl = NewRechargeDepositItemCtrl.Ins()
  end
  if not self.TShopData then
    self.TShopData = NewRechargeTShopData.new()
  end
  if not self.TCardData then
    self.TCardData = NewRechargeTCardData.new()
  end
  if not self.TDepositData then
    self.TDepositData = NewRechargeTDepositData.new()
  end
  if not self.m_tHotData then
    self.m_tHotData = NewRechargeTHotData.new()
  end
  NewRechargeProxy.UseCompatVer = not GameConfig.NewRecharge or not GameConfig.NewRecharge.Cfg.UseNewVersion
  NewRechargeProxy.TDeposit = NewRechargeProxy.Ins.TDepositData
  NewRechargeProxy.TCard = NewRechargeProxy.Ins.TCardData
  NewRechargeProxy.TShop = NewRechargeProxy.Ins.TShopData
  NewRechargeProxy.THot = NewRechargeProxy.Ins.m_tHotData
  NewRechargeProxy.CDeposit = NewRechargeProxy.Ins.DepositItemCtrl
  NewRechargeProxy.CCard = NewRechargeProxy.Ins.CardItemCtrl
  NewRechargeProxy.CShop = NewRechargeProxy.Ins.ShopItemCtrl
end
function NewRechargeProxy:GetTabConfig(tab)
  if not GameConfig.NewRecharge or not GameConfig.NewRecharge.Tabs then
    return
  end
  return GameConfig.NewRecharge.Tabs[tab]
end
function NewRechargeProxy:GetSubSelectListData()
  if self.subSelectListData then
    ReusableTable.DestroyAndClearArray(self.subSelectListData)
    self.subSelectListData = nil
  end
  self.subSelectListData = ReusableTable.CreateArray()
  local tab, data
  tab = GameConfig.NewRecharge.TabDef.Hot
  data = GameConfig.NewRecharge.Tabs[tab]
  TableUtility.ArrayPushBack(self.subSelectListData, {
    tab = tab,
    Name = data.Title,
    Icon = data.Icon
  })
  if not GameConfig.SystemForbid.GoldPurchase then
    tab = GameConfig.NewRecharge.TabDef.Shop
    data = GameConfig.NewRecharge.Tabs[tab]
    TableUtility.ArrayPushBack(self.subSelectListData, {
      tab = tab,
      Name = data.Title,
      Icon = data.Icon
    })
  end
  if not GameConfig.SystemForbid.CardPurchase then
    tab = GameConfig.NewRecharge.TabDef.Card
    data = GameConfig.NewRecharge.Tabs[tab]
    TableUtility.ArrayPushBack(self.subSelectListData, {
      tab = tab,
      Name = data.Title,
      Icon = data.Icon
    })
  end
  if not GameConfig.SystemForbid.ZenyPurchase then
    tab = GameConfig.NewRecharge.TabDef.Deposit
    data = GameConfig.NewRecharge.Tabs[tab]
    TableUtility.ArrayPushBack(self.subSelectListData, {
      tab = tab,
      Name = data.Title,
      Icon = data.Icon
    })
  end
  if not GameConfig.SystemForbid.DanatuosiForbid then
    tab = GameConfig.NewRecharge.TabDef.Hero or 5
    data = GameConfig.NewRecharge.Tabs[tab]
    if data then
      TableUtility.ArrayPushBack(self.subSelectListData, {
        tab = tab,
        Name = data.Title,
        Icon = data.Icon
      })
    end
  end
  return self.subSelectListData
end
function NewRechargeProxy:GetInnerSelectListData(tab)
  return GameConfig.NewRecharge.Tabs[tab].Inner
end
function NewRechargeProxy:Deposit_RecvChargeQueryCmd(data)
  if not data then
    return
  end
  local cl = self.CDeposit
  local depositId = data.data_id
  local productConf = Table_Deposit[depositId]
  if productConf then
    cl:SetChargeCnt({
      depositId = depositId,
      count = charged_count,
      limit = productConf.MonthLimit,
      canCharge = data.ret
    })
  end
end
function NewRechargeProxy:Deposit_UpdateChargeCntInfo(info)
  local cl = self.CDeposit
  if self.UseCompatVer then
    cl = UIModelZenyShop.Ins()
  end
  for i = 1, #info do
    local purchaseInfo = info[i]
    local productConfID = purchaseInfo.dataid
    local purchaseTimes = purchaseInfo.count
    local purchaseLimit = purchaseInfo.limit
    local purchaseBatchDailyCount = purchaseInfo.dailycount
    local productConf = Table_Deposit[productConfID]
    if productConf then
      if productConf.LimitType ~= 6 and productConf.Type == 4 and productConf.Switch == 1 then
        cl:SetLuckyBagPurchaseTimes(productConfID, purchaseTimes)
        cl:SetLuckyBagPurchaseLimit(productConfID, purchaseLimit)
      end
      if cl.originToBatchProduct and cl.originToBatchProduct[productConfID] then
        cl:SetLuckyBagBatchDailyCount(productConfID, purchaseBatchDailyCount)
      end
      cl:SetChargeCnt({
        depositId = productConfID,
        count = purchaseTimes,
        limit = purchaseLimit
      })
    else
      helplog("RecvQueryChargeCnt", "not exist in Table_Deposit", productConfID)
    end
  end
end
function NewRechargeProxy:Deposit_SetActivityUsedTimes(purchaseActivityInfo)
  local cl = self.CDeposit
  if self.UseCompatVer then
    cl = UIModelZenyShop.Ins()
  end
  local activityID = purchaseActivityInfo.activityid
  local activityUsedTimes = purchaseActivityInfo.count
  cl:SetActivityUsedTimes(activityID, activityUsedTimes)
end
function NewRechargeProxy:Deposit_SetProductActivity_Discount(isOpen, rawData)
  local cl = self.CDeposit
  if self.UseCompatVer then
    cl = UIModelZenyShop.Ins()
  end
  if isOpen then
    local activityID = rawData.id
    local productConfID = rawData.params[1]
    local newProductConfID = rawData.params[2]
    local times = rawData.count
    local startTime = rawData.starttime
    local endTime = rawData.endtime
    local activityParamsD = {
      [1] = productConfID,
      [2] = times,
      [3] = newProductConfID,
      [4] = startTime,
      [5] = endTime,
      [6] = activityID
    }
    cl:SetActivityParams_Discount(productConfID, activityParamsD)
    cl:SetActivityUsedTimes(activityID, 0)
  else
    local productConfID = rawData.params[1]
    cl:SetActivityParams_Discount(productConfID, nil)
  end
end
function NewRechargeProxy:Deposit_SetProductActivity_GainMore(isOpen, rawData)
  local cl = self.CDeposit
  if self.UseCompatVer then
    cl = UIModelZenyShop.Ins()
  end
  if isOpen then
    local activityID = rawData.id
    local productConfID = rawData.params[1]
    local multipleNumber = rawData.params[2]
    local times = rawData.count
    local startTime = rawData.starttime
    local endTime = rawData.endtime
    local activityParamsG = {
      [1] = productConfID,
      [2] = times,
      [3] = multipleNumber,
      [4] = startTime,
      [5] = endTime,
      [6] = activityID
    }
    cl:SetActivityParams_GainMore(productConfID, activityParamsG)
    cl:SetActivityUsedTimes(activityID, 0)
  else
    local productConfID = rawData.params[1]
    cl:SetActivityParams_GainMore(productConfID, nil)
  end
end
function NewRechargeProxy:Deposit_SetProductActivity_MoreTimes(isOpen, rawData)
  local cl = self.CDeposit
  if self.UseCompatVer then
    cl = UIModelZenyShop.Ins()
  end
  if isOpen then
    local activityID = rawData.id
    local productConfID = rawData.params[1]
    local times = rawData.count
    local startTime = rawData.starttime
    local endTime = rawData.endtime
    local activityParamsM = {
      [1] = productConfID,
      [2] = times,
      [3] = startTime,
      [4] = endTime,
      [5] = activityID
    }
    cl:SetActivityParams_MoreTimes(productConfID, activityParamsM)
    cl:SetActivityUsedTimes(activityID, 0)
  else
    local productConfID = rawData.params[1]
    cl:SetActivityParams_MoreTimes(productConfID, nil)
  end
end
function NewRechargeProxy:Shop_UpdateOneZenyGoodsBuyInfo(data)
  local cl = self.CShop
  if self.UseCompatVer then
    cl = UIModelZenyShop.Ins()
  end
  cl:UpdateOneZenyGoodsBuyInfo(data)
end
function NewRechargeProxy:Deposit_SetFPRInfo(rawData)
  local cl = self.CDeposit
  if self.UseCompatVer then
    cl = UIModelZenyShop.Ins()
  end
  if rawData.del > 0 then
    cl:RemoveFPRFlag(rawData.del)
  else
    cl:SetFPRFlag(rawData.datas)
  end
end
function NewRechargeProxy:Deposit_GetProductActivity(p_conf_id)
  local cl = self.CDeposit
  if self.UseCompatVer then
    cl = UIModelZenyShop.Ins()
  end
  return cl:GetProductActivity(p_conf_id)
end
function NewRechargeProxy:Deposit_GetProductActivity_Discount(activity_p_conf_id)
  local cl = self.CDeposit
  if self.UseCompatVer then
    cl = UIModelZenyShop.Ins()
  end
  return cl:GetProductActivity_Discount(activity_p_conf_id)
end
function NewRechargeProxy:Deposit_GetLuckyBagPurchaseTimes(lucky_bag_conf_id)
  local cl = self.CDeposit
  if self.UseCompatVer then
    cl = UIModelZenyShop.Ins()
  end
  return cl:GetLuckyBagPurchaseTimes(lucky_bag_conf_id)
end
function NewRechargeProxy:Deposit_AddLuckyBagPurchaseTimes(lucky_bag_conf_id)
  local cl = self.CDeposit
  if self.UseCompatVer then
    cl = UIModelZenyShop.Ins()
  end
  return cl:AddLuckyBagPurchaseTimes(lucky_bag_conf_id)
end
function NewRechargeProxy:Card_SetVersionCardInfo(info)
  if self.UseCompatVer then
    UIModelZenyShop.Ins():SetEPVIPCards(info)
  end
  self.TCard:SetEPCards(info)
end
function NewRechargeProxy:Card_SetMonthlyVIPInfo(rawInfo)
  local monthCardData
  local cardDatas = rawInfo.card_datas
  for _, v in ipairs(cardDatas) do
    if v.type == ProtoCommon_pb.ETITLE_TYPE_MONTH then
      monthCardData = v
      break
    end
  end
  if monthCardData ~= nil then
    if self.UseCompatVer then
      UIModelMonthlyVIP.Instance():Set_TimeOfLatestPurchaseMonthlyVIP(monthCardData.starttime)
      UIModelMonthlyVIP.Instance():Set_TimeOfExpirationMonthlyVIP(monthCardData.expiretime)
    end
    self.CCard:Set_TimeOfLatestPurchaseMonthlyVIP(monthCardData.starttime)
    self.CCard:Set_TimeOfExpirationMonthlyVIP(monthCardData.expiretime)
  end
end
function NewRechargeProxy:Card_HandleMonthCardEnd(data)
  MonthlyVIPTip.Ins():ShowTip()
end
NewRechargeProxy.TShopData = nil
NewRechargeProxy.ShopType = 650
NewRechargeProxy.ShopID = 1
function NewRechargeProxy:SetShopID(ShopID)
  self.ShopID = ShopID
end
function NewRechargeProxy:InitRechargeShop()
  if not GameConfig.Profession.hero_ticket_shop then
    local hero_ticket_shop = {
      812,
      1,
      56597
    }
  end
  HappyShopProxy.Instance:InitShop(nil, hero_ticket_shop[2], hero_ticket_shop[1])
  if self.shopDirty then
    self.shopDirty = false
    local shopData = ShopProxy.Instance:GetShopDataByTypeId(self.ShopType, self.ShopID)
    if shopData then
      shopData:SetNextValidTime(0)
    end
  end
  HappyShopProxy.Instance:InitShop(nil, self.ShopID, self.ShopType)
end
function NewRechargeProxy:RequestQueryShopItem()
  ShopProxy.Instance:CallQueryShopConfig(self.ShopType, self.ShopID)
end
function NewRechargeProxy:GetShopConf()
  return ShopProxy.Instance:GetConfigByTypeId(self.ShopType, self.ShopID)
end
function NewRechargeProxy:GetShopItemData(shopGoodsId)
  return ShopProxy.Instance:GetShopItemDataByTypeId(self.ShopType, self.ShopID, shopGoodsId)
end
function NewRechargeProxy:TShop_GetShopItemList(innerSelectType)
  return self.TShopData:GetShopItemList(innerSelectType)
end
function NewRechargeProxy:THot_GetHotItemList(innerSelectType)
  return self.m_tHotData:GetShopItemList(innerSelectType)
end
function NewRechargeProxy:THero_GetClasstickGoods()
  if not GameConfig.Profession.hero_ticket_shop then
    local hero_ticket_shop = {
      812,
      1,
      56597
    }
  end
  HappyShopProxy.Instance:InitShop(nil, hero_ticket_shop[2], hero_ticket_shop[1])
end
NewRechargeProxy.TCardData = nil
NewRechargeProxy.TDepositData = nil
function NewRechargeProxy:TDeposit_GetDepositROBItemList()
  return self.TDepositData:GetROBItemList(true)
end
function NewRechargeProxy:TDeposit_GetDepositZenyItemList()
  return self.TDepositData:GetZenyItemList(true)
end
NewRechargeProxy.depositGoodsInfo = {}
function NewRechargeProxy:GenerateDepositGoodsInfo(depositID)
  if not self.depositGoodsInfo[depositID] then
    self.depositGoodsInfo[depositID] = NewRechargeDepositGoodsData.new()
  end
  local info = self.depositGoodsInfo[depositID]
  info:ResetData(depositID)
  return info
end
NewRechargeProxy.shopGoodsInfo = {}
function NewRechargeProxy:GenerateShopGoodsInfo(shopGoodsId)
  local shopItemData = self:GetShopItemData(shopGoodsId)
  if not self.shopGoodsInfo[shopGoodsId] then
    self.shopGoodsInfo[shopGoodsId] = NewRechargeShopGoodsData.new()
  end
  local info = self.shopGoodsInfo[shopGoodsId]
  info:ResetData(shopItemData)
  return info
end
function NewRechargeProxy:AmIMonthlyVIP()
  return self.CCard:AmIMonthlyVIP()
end
function NewRechargeProxy:GetMonthCardLeftDays()
  return self.CCard:GetMonthCardLeftDays()
end
function NewRechargeProxy:SetTimeLimitIcon(show_items, show_deposits)
  if not self.InverseShop2Sort_ShopShow then
    self.InverseShop2Sort_ShopShow = {}
    for k, v in pairs(Table_ShopShow) do
      self.InverseShop2Sort_ShopShow[v.ShopID] = v.Sort
    end
  end
  self.timeLimitIcon = nil
  if show_items and #show_items > 0 then
    local tabId
    for i = 1, #show_items do
      local newTabId = self.InverseShop2Sort_ShopShow[show_items[i]]
      if newTabId and (not tabId or tabId > newTabId) then
        tabId = newTabId
      end
    end
    if tabId then
      self.timeLimitIcon = tabId
    end
  end
  if show_deposits and #show_deposits > 0 then
    local tabId
    for i = 1, #show_deposits do
      local newTabId = self.InverseShop2Sort_ShopShow[show_deposits[i]]
      if newTabId and (not tabId or tabId > newTabId) then
        tabId = newTabId
      end
    end
    if tabId and (not self.timeLimitIcon or tabId < self.timeLimitIcon) then
      self.timeLimitIcon = tabId
    end
  end
end
function NewRechargeProxy:GetShowTimeLimitIcon()
  return self.timeLimitIcon
end
function NewRechargeProxy:CallClientPayLog(eventId, value)
  redlog("send event id = " .. eventId == nil and 0 or eventId)
  ServiceSceneUser3Proxy.Instance:CallClientPayLog(eventId, value)
end
function NewRechargeProxy:setIsRecordEvent(value)
  self.m_isRecordEvent = value
end
function NewRechargeProxy:isRecordEvent()
  return self.m_isRecordEvent
end
function NewRechargeProxy:readyTriggerEventId(value)
  self.m_readyTriggerEventId = value
end
function NewRechargeProxy:successTriggerEventId()
  if self.m_readyTriggerEventId == 0 then
    return
  end
  self:CallClientPayLog(self.m_readyTriggerEventId)
  self:readyTriggerEventId(0)
end
local ItemTypeSort = {
  90,
  501,
  810,
  800,
  830,
  840,
  850,
  71,
  81,
  82,
  83,
  84,
  85,
  86,
  87,
  88,
  89,
  111,
  112,
  4200,
  59,
  30
}
local f_getItemSort = function(iType)
  for i = 1, #ItemTypeSort do
    if iType == ItemTypeSort[i] then
      return i
    end
  end
  return 10000
end
local FSort_ItemShowInfo = function(a, b)
  if a.probability ~= b.probability then
    return b.probability
  end
  local aTypeSort = f_getItemSort(a.sItemData.Type)
  local bTypeSort = f_getItemSort(b.sItemData.Type)
  if aTypeSort ~= bTypeSort then
    return aTypeSort < bTypeSort
  end
  if a.sItemData.Quality ~= b.sItemData.Quality then
    if a.sItemData.Quality and b.sItemData.Quality then
      return a.sItemData.Quality > b.sItemData.Quality
    end
    return b.sItemData.Quality ~= nil
  end
  if a.itemid == b.itemid and a.num ~= b.num then
    return a.num < b.num
  end
  return a.itemid < b.itemid
end
function NewRechargeProxy.ParseItemShowInfo(server_ItemShowInfo)
  local retLists = {
    {},
    {}
  }
  local itemShowInfo, guaranteed
  for i = 1, #server_ItemShowInfo do
    itemShowInfo = server_ItemShowInfo[i]
    local giftInfo = {}
    giftInfo.show = itemShowInfo.show
    local itemid = itemShowInfo.itemid
    if not Table_Item[itemid] then
      LogUtility.Error(string.format("商店礼包没找到Item. Id：%s", itemid))
    elseif giftInfo.show and giftInfo.show > 0 then
      table.insert(retLists[1], giftInfo)
    else
      table.insert(retLists[2], giftInfo)
    end
    giftInfo.itemid = itemid
    giftInfo.sItemData = Table_Item[itemid]
    giftInfo.sEquipData = Table_Equip[itemid]
    giftInfo.num = itemShowInfo.num
    giftInfo.guaranteed = itemShowInfo.guaranteed
    giftInfo.probability = itemShowInfo.probability
    giftInfo.showgrey = itemShowInfo.showgrey
    giftInfo.safety = itemShowInfo.safety
    giftInfo.showcount = itemShowInfo.showcount
    if not guaranteed and 0 < giftInfo.guaranteed then
      guaranteed = true
    end
  end
  table.sort(retLists[1], FSort_ItemShowInfo)
  table.sort(retLists[2], FSort_ItemShowInfo)
  return retLists, guaranteed
end
function NewRechargeProxy.ParseItemShowInfo_Shop(server_ItemShowInfo, goodsId)
  local retLists, guaranteed = NewRechargeProxy.ParseItemShowInfo(server_ItemShowInfo)
  if guaranteed and goodsId then
    NewRechargeProxy.Instance:SetBatchItemShopInfo(goodsId)
  end
  return retLists, guaranteed
end
function NewRechargeProxy:setRmbShopInfo(serverData_ShowRMBGiftEvent)
  self.shopGifts = {}
  local serverShows = serverData_ShowRMBGiftEvent.show
  for i = 1, #serverShows do
    self.shopGifts[serverShows[i].product] = NewRechargeProxy.ParseItemShowInfo(serverShows[i].info)
  end
end
function NewRechargeProxy:findRmbShopInfo(id)
  local d = self.shopGifts[id]
  if d then
    return d[1], d[2]
  end
  return nil
end
function NewRechargeProxy:SetBatchItemShopInfo(itemId)
  if not self.batchItemMap then
    self.batchItemMap = {}
  end
  self.batchItemMap[itemId] = 1
end
function NewRechargeProxy:TryUseBatchItem(itemId)
  if self.batchItemMap and self.batchItemMap[itemId] then
    self.shopDirty = true
  end
end
function NewRechargeProxy:GetRedTipsPageByHotPage()
  local showRedTipsArr = {}
  if GameConfig.ShopRed and GameConfig.ShopRed.Shopid then
    local func = function(page)
      local list = self:THot_GetHotItemList(page)
      for _, v in pairs(list) do
        if 0 ~= TableUtility.ArrayFindIndex(GameConfig.ShopRed.Shopid, v.ShopID) then
          local buyCount = HappyShopProxy.Instance:GetCachedHaveBoughtItemCount(v.ShopID) or 0
          if buyCount == 0 then
            buyCount = HappyShopProxy.Instance:GetDiscountItemCount(v.ShopID) or 0
          end
          if buyCount == 0 then
            return true
          end
        end
      end
      return false
    end
    local flag = func(1)
    if flag == true then
      table.insert(showRedTipsArr, 1)
    end
    flag = func(2)
    if flag == true then
      table.insert(showRedTipsArr, 2)
    end
    flag = func(3)
    if flag == true then
      table.insert(showRedTipsArr, 3)
    end
  end
  return showRedTipsArr
end
function NewRechargeProxy:GetRedTipsPageByShopPage()
  local showRedTipsArr = {}
  if GameConfig.ShopRed and GameConfig.ShopRed.Shopid then
    local func = function(page)
      local list = self:TShop_GetShopItemList(page)
      for _, v in pairs(list) do
        if 0 ~= TableUtility.ArrayFindIndex(GameConfig.ShopRed.Shopid, v.ShopID) then
          local buyCount = HappyShopProxy.Instance:GetCachedHaveBoughtItemCount(v.ShopID) or 0
          if buyCount == 0 then
            buyCount = HappyShopProxy.Instance:GetDiscountItemCount(v.ShopID) or 0
          end
          if buyCount == 0 then
            return true
          end
        end
      end
      return false
    end
    local flag = func(1)
    if flag == true then
      table.insert(showRedTipsArr, 1)
    end
    flag = func(2)
    if flag == true then
      table.insert(showRedTipsArr, 2)
    end
    flag = func(3)
    if flag == true then
      table.insert(showRedTipsArr, 3)
    end
  end
  return showRedTipsArr
end
function NewRechargeProxy:SetDailyRewardInfo(serverData)
  if not self.dailyRewardInfoSyncMap then
    self.dailyRewardInfoSyncMap = {}
  end
  local infos = serverData.infos
  local info, deposit_id, rest_day
  for i = 1, #infos do
    info = infos[i]
    deposit_id = info.deposit_id
    rest_day = info.rest_day
    if not self.dailyRewardInfoSyncMap[deposit_id] or rest_day == 0 then
      self.dailyRewardInfoSyncMap[deposit_id] = rest_day
    else
      self.dailyRewardInfoSyncMap[deposit_id] = rest_day + self.dailyRewardInfoSyncMap[deposit_id]
    end
  end
end
function NewRechargeProxy:GetDailyRewardInfo(deposit_id)
  if not self.dailyRewardInfoSyncMap then
    return nil
  end
  return deposit_id and self.dailyRewardInfoSyncMap[deposit_id]
end
function NewRechargeProxy:GetHeroRedTip()
  local heroNewTime = ProfessionProxy.Instance:RechargeHeroNewDate()
  if heroNewTime then
    local lastChecktime = LocalSaveProxy.Instance:GetRechargeHero_New()
    local t = ServerTime.CurServerTime() / 1000
    local t1 = StringUtil.FormatTime2TimeStamp2(heroNewTime[1])
    local t2 = StringUtil.FormatTime2TimeStamp2(heroNewTime[2])
    if t >= t1 and t <= t2 then
      if lastChecktime >= t1 and lastChecktime <= t2 then
        return false
      else
        return true
      end
    else
      return fasle
    end
  end
  return nil
end
