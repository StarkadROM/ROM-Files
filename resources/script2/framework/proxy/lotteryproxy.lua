autoImport("HeadLotteryData")
autoImport("LotteryRecoverData")
autoImport("LotteryExtraBonusData")
autoImport("LotteryInfoData")
autoImport("LotteryDollData")
autoImport("MixLotteryItemData")
autoImport("LotteryActivityData")
LotteryProxy = class("LotteryProxy", pm.Proxy)
LotteryProxy.Instance = nil
LotteryProxy.NAME = "LotteryProxy"
LotteryType = {
  Head = SceneItem_pb.ELotteryType_Head,
  Equip = SceneItem_pb.ELotteryType_Equip,
  Card = SceneItem_pb.ELotteryType_Card,
  Magic = SceneItem_pb.ELotteryType_Magic,
  MagicSec = SceneItem_pb.ELotteryType_Magic_2,
  MagicThird = SceneItem_pb.ELotteryType_Magic_3,
  Mixed = SceneItem_pb.ELotteryType_MIX1,
  MixedSec = SceneItem_pb.ELotteryType_MIX2,
  MixedThird = SceneItem_pb.ELotteryType_MIX3,
  MixedFourth = SceneItem_pb.ELotteryType_MIX4,
  NewCard = SceneItem_pb.ELotteryType_Card_New,
  NewCard_Activity = SceneItem_pb.ELotteryType_Card_Activity
}
local EffectConfig = {}
local _MixLotteryMap = {
  [LotteryType.Mixed] = 1,
  [LotteryType.MixedSec] = 1,
  [LotteryType.MixedThird] = 1,
  [LotteryType.MixedFourth] = 1
}
local _NewCardMap = {
  [LotteryType.NewCard] = 1,
  [LotteryType.NewCard_Activity] = 1
}
local _MagicLottery = {
  [LotteryType.Magic] = 1,
  [LotteryType.MagicSec] = 1,
  [LotteryType.MagicThird] = 1
}
local _CardLottery = {
  [LotteryType.Card] = 1,
  [LotteryType.NewCard] = 1,
  [LotteryType.NewCard_Activity] = 1
}
local _MagicLottery = {
  [LotteryType.Magic] = 1,
  [LotteryType.MagicSec] = 1,
  [LotteryType.MagicThird] = 1
}
local _VarMap = {
  [LotteryType.NewCard] = Var_pb.EACCVARTYPE_LOTTERY_CNT_CARD_NEW,
  [LotteryType.NewCard_Activity] = Var_pb.EACCVARTYPE_LOTTERY_CNT_CARD_ACTIVITY
}
local _ArrayPushBack = TableUtility.ArrayPushBack
local _ArrayClear = TableUtility.ArrayClear
local _CreateTable = ReusableTable.CreateTable
local _DestroyAndClearTable = ReusableTable.DestroyAndClearTable
local _InsertArray = TableUtil.InsertArray
local _TEN = 10
function LotteryProxy.IsNewCardLottery(type)
  return nil ~= _NewCardMap[type]
end
function LotteryProxy.IsMixLottery(type)
  return nil ~= _MixLotteryMap[type]
end
function LotteryProxy.IsNewPocketCardLottery(t)
  return t == LotteryType.NewCard
end
function LotteryProxy.IsMagicLottery(t)
  return nil ~= _MagicLottery[t]
end
function LotteryProxy.IsRecoverType(t)
  return LotteryProxy.IsMagicLottery(t) or LotteryType.Head == t
end
function LotteryProxy.IsMagicLottery(t)
  return nil ~= _MagicLottery[t]
end
function LotteryProxy.IsCardLottery(t)
  return t == LotteryType.Card
end
function LotteryProxy.IsHeadLottery(t)
  return t == LotteryType.Head
end
function LotteryProxy.IsRecoverType(t)
  return LotteryProxy.IsMagicLottery(t) or LotteryType.Head == t
end
function LotteryProxy.IsNewLottery(t)
  return LotteryProxy.IsHeadLottery(t) or LotteryProxy.IsNewPocketCardLottery(t) or LotteryProxy.IsMixLottery(t) or LotteryProxy.IsMagicLottery(t)
end
function LotteryProxy.IsSSR(itemData)
  if itemData == nil then
    return false
  end
  local staticData = itemData.staticData
  if staticData.Type == 501 then
    return true
  end
  if staticData.Quality >= 4 then
    return true
  end
end
function LotteryProxy:ctor(proxyName, data)
  self.proxyName = proxyName or LotteryProxy.NAME
  if LotteryProxy.Instance == nil then
    LotteryProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end
function LotteryProxy:Init()
  self.lotteryActMap = {}
  self.lotteryOpenActs = {}
  self.lotteryActs = {}
  self.callTime = {}
  self.infoMap = {}
  self.recvInfo = {}
  self.recoverMap = {}
  self.headwearRecoverMap = {}
  self.filterCardList = {}
  self.filterMagicList = {}
  self.extraMap = {}
  self.extraCount = {}
  self.extraBonusProgressMap = {}
  self.mixLotteryStaticData = {}
  self.dressMap = {}
  self:InitEquipLottery()
  self.lotteryAlways = {}
  self:PreProcessLotteryActivity()
  self.freeTypes = {}
  self:ProcessNewCardLotteryDiscountCnt()
  self:InitDailyReward()
end
function LotteryProxy:PreProcessLotteryActivity()
  local config = GameConfig.Lottery.activity
  if not config then
    return
  end
  for k, v in pairs(config) do
    if v.always then
      self.lotteryAlways[k] = LotteryActivityData.new(k, true)
    end
  end
end
function LotteryProxy:GetAlwaysLottery()
  return self.lotteryAlways
end
function LotteryProxy:CallQueryLotteryInfo(type, force)
  local currentTime = UnityUnscaledTime
  local nextValidTime = self:_GetNextValidTime(type)
  if force or nextValidTime == nil or currentTime >= nextValidTime then
    self:SetNextValidTime(type, 5)
    helplog("CallQueryLotteryInfo: ", type)
    ServiceItemProxy.Instance:CallQueryLotteryInfo(nil, type)
  end
end
function LotteryProxy:CallLottery(lotteryType, year, month, npcId, price, costValue, skipValue, times, free)
  times = times or 1
  local discount
  price, discount = self:GetDiscountByCoinType(lotteryType, AELotteryDiscountData.CoinType.Coin, price * times, year, month)
  if price ~= costValue * times and discount and not discount:IsInActivity() then
    MsgManager.ConfirmMsgByID(25314, function()
      self:sendNotification(LotteryEvent.RefreshCost)
    end)
    return
  end
  if price > MyselfProxy.Instance:GetLottery() and not free then
    MsgManager.ConfirmMsgByID(3551, function()
      FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit)
    end)
    return
  end
  local msgID
  if not self:CheckTodayCanBuy(lotteryType, times) then
    if LotteryProxy.IsMixLottery(lotteryType) or LotteryProxy.IsNewCardLottery(lotteryType) then
      msgID = times > 1 and 41459 or 41460
    else
      msgID = 3641
    end
    MsgManager.ShowMsgByID(msgID)
    return
  end
  ServiceItemProxy.Instance:CallLotteryCmd(year, month, npcId, skipValue, price, nil, lotteryType, times, nil, nil, nil, nil, nil, nil, free)
end
function LotteryProxy:RecvQueryLotteryInfo(servicedata)
  local type = servicedata.type
  helplog("RecvQueryLotteryInfo type ", type)
  if type == LotteryType.Head then
    self:SetNextValidTime(type, 60)
    if self.infoMap[type] == nil then
      self.infoMap[type] = HeadLotteryData.new()
    end
    self.infoMap[type]:SetData(servicedata)
  end
  if LotteryProxy.IsMixLottery(type) then
    self:SetMixlotterycnts(servicedata.mixlotterycnts, servicedata.free_cnt)
  end
  local info
  for i = 1, #servicedata.infos do
    info = servicedata.infos[i]
    if type == LotteryType.Equip then
      local data = LotteryData.new(info)
      data:SortItemsByRate()
      self.infoMap[type] = data
    elseif LotteryProxy.IsMagicLottery(type) then
      local data = LotteryData.new(info)
      self.infoMap[type] = data
    elseif type == LotteryType.Card then
      local data = LotteryData.new(info)
      data:SortItemsByQuality()
      self.infoMap[type] = data
    end
  end
  if LotteryProxy.IsNewCardLottery(type) and servicedata.infos[1] then
    local data = LotteryData.new(servicedata.infos[1])
    for i = 2, #servicedata.infos do
      local info = servicedata.infos[i]
      if info then
        data:AddItems(info.subInfo)
      end
    end
    data:SortItemsByItemType()
    self.infoMap[type] = data
  end
  info = self.infoMap[type]
  if not info then
    return
  end
  info:SetTodayCount(servicedata.today_cnt, servicedata.max_cnt)
  info:SetTodayExtraCount(servicedata.today_extra_cnt, servicedata.max_extra_cnt)
  info:SetOnceMaxCount(servicedata.once_max_cnt)
  info:SetTodayTenCount(servicedata.today_ten_cnt, servicedata.max_ten_cnt)
  info:SetFreeCount(servicedata.free_cnt)
  if servicedata.safetyinfo and info.SetSafetyInfo then
    info:SetSafetyInfo(servicedata.safetyinfo)
  end
  helplog("RecvQueryLotteryInfo 单次抽取最大次数 | 今日十连次数 | 今日十连上限", servicedata.once_max_cnt, servicedata.today_ten_cnt, servicedata.max_ten_cnt)
end
function LotteryProxy:CheckTenLottery(t)
  if LotteryProxy.IsMixLottery(t) then
    return true
  end
  local data = self.infoMap[t]
  if data then
    return data.onceMaxCount == _TEN
  end
end
function LotteryProxy:RecvLotteryCmd(data)
  self.lotteryAction = false
  local lotteryType = data.type
  local npcRole = SceneCreatureProxy.FindCreature(data.npcid)
  local isSelf = data.charid == Game.Myself.data.id
  local effectConfig = EffectConfig[lotteryType]
  if isSelf then
    local infoData = LotteryInfoData.new(data)
    self.recvInfo[#self.recvInfo + 1] = infoData
    if infoData:IsCoin() then
      local info = self.infoMap[lotteryType]
      if info ~= nil then
        info:SetTodayCount(data.today_cnt)
        info:SetTodayExtraCount(data.today_extra_cnt)
        info:SetTodayTenCount(data.today_ten_cnt)
        if data.free then
          info:SetFreeCount(0)
        end
      end
      if LotteryProxy.IsMixLottery(lotteryType) and data.free then
        self.mixFreeCnt = 0
      end
    end
    if data.skip_anim then
      self:ShowFloatAward()
      return
    end
  elseif self.isOpenView then
    return
  end
  if LotteryProxy.IsNewLottery(lotteryType) then
    if not isSelf then
      return
    end
    self:sendNotification(LotteryEvent.NewLotteryAnimationStart)
    TimeTickManager.Me():CreateOnceDelayTick(GameConfig.Delay.lottery, function(owner, deltaTime)
      self:sendNotification(LotteryEvent.NewLotteryAnimationEnd)
      self:ShowFloatAward()
    end, self)
    return
  end
  if npcRole then
    if LotteryProxy.IsNewCardLottery(lotteryType) then
      self:sendNotification(LotteryEvent.RecvLotteryCardNewResult)
      TimeTickManager.Me():CreateOnceDelayTick(GameConfig.Delay.lottery, function(owner, deltaTime)
        self:ShowFloatAward()
      end, self)
    else
      local actionId = 200
      if effectConfig ~= nil and effectConfig.ActionId ~= nil then
        actionId = effectConfig.ActionId
      end
      self:PlayAction(npcRole, actionId)
      local effectName
      if effectConfig ~= nil and effectConfig.Effect ~= nil then
        effectName = effectConfig.Effect
      end
      if effectName ~= nil then
        if self.effect then
          self.effect:Destroy()
          self.effect = nil
        end
        self.effect = npcRole:PlayEffect(nil, effectName, 0, nil, nil, true)
        if self.effect ~= nil then
          self.effect:RegisterWeakObserver(self)
        end
      end
      local audioName
      if effectConfig ~= nil and effectConfig.Audio ~= nil then
        audioName = effectConfig.Audio
      end
      if audioName then
        npcRole:PlayAudio(audioName)
      end
      if isSelf then
        self:DelayedShowLotteryAward(npcRole, effectConfig)
      else
        self:RemoveOtherLT()
        self.otherLT = TimeTickManager.Me():CreateOnceDelayTick(GameConfig.Delay.lottery, function(owner, deltaTime)
          self:PlayIdleAction(npcRole, effectConfig)
          self:RemoveOtherLT()
        end, self)
      end
    end
  elseif isSelf then
    self:ShowFloatAward()
  end
end
function LotteryProxy:ObserverDestroyed(obj)
  if obj == self.effect then
    self.effect = nil
  end
end
function LotteryProxy:PlayAction(npc, actionId)
  if npc ~= nil and actionId ~= nil then
    local actionName
    local config = Table_ActionAnime[actionId]
    if config ~= nil then
      actionName = config.Name
    end
    if actionName ~= nil then
      npc:Client_PlayAction(actionName, nil, false)
    end
  end
end
function LotteryProxy:SetLotteryBuyCnt(c, t)
  self.today_cnt = c
  self.max_cnt = t
end
function LotteryProxy:GetLotteryBuyCnt()
  if not self.today_cnt then
    return 0, 0
  end
  return self.today_cnt, self.max_cnt
end
function LotteryProxy:PlayIdleAction(npcRole, effectConfig)
  local idleActionId
  if effectConfig ~= nil and effectConfig.IdleActionId ~= nil then
    idleActionId = effectConfig.IdleActionId
  end
  if idleActionId ~= nil then
    self:PlayAction(npcRole, idleActionId)
  end
end
function LotteryProxy:DelayedShowLotteryAward(npcRole, effectConfig)
  self:sendNotification(LotteryEvent.EffectStart)
  TimeTickManager.Me():CreateOnceDelayTick(GameConfig.Delay.lottery, function(owner, deltaTime)
    self:ShowFloatAward()
    if npcRole then
      self:PlayIdleAction(npcRole, effectConfig)
    end
    self:sendNotification(LotteryEvent.EffectEnd)
  end, self)
end
function LotteryProxy:HandleEscRecvinfo()
  if #self.recvInfo > 0 then
    table.remove(self.recvInfo, 1)
  end
end
function LotteryProxy:ShowFloatAward()
  if #self.recvInfo == 0 then
    return
  end
  local infoData = self.recvInfo[1]
  local list = infoData.itemList
  if #list == 0 then
    table.remove(self.recvInfo, 1)
    return
  end
  local count = infoData.count
  if count == 10 or count == 11 then
    table.remove(self.recvInfo, 1)
    local viewdata = {}
    viewdata.list = list
    viewdata.count = count
    if infoData:IsCoin() and not GameConfig.Lottery.ForbidLotteryAgain then
      do
        local price = math.floor(self:GetCost(infoData.lotteryType, 10, infoData.year, infoData.month))
        viewdata.btnText = string.format(ZhString.Lottery_LotteryAgain, price)
        function viewdata.btnCallback()
          local dont = LocalSaveProxy.Instance:GetDontShowAgain(43262)
          if dont == nil then
            MsgManager.DontAgainConfirmMsgByID(43262, function()
              self:LotteryAgain(infoData, 10)
            end, nil, nil, price)
          else
            self:LotteryAgain(infoData, 10)
          end
        end
      end
    else
    end
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.LotteryResultView,
      viewdata = viewdata
    })
    return
  end
  local item = list[1]
  if infoData:IsCoin() then
    table.remove(self.recvInfo, 1)
    local args = _CreateTable()
    args.disableMsg = true
    args.closeWhenClickOtherPlace = true
    if not GameConfig.Lottery.ForbidLotteryAgain then
      do
        local cost = self:GetCost(infoData.lotteryType, 1, infoData.year, infoData.month)
        args.leftBtnRichText = string.format(ZhString.Lottery_LotteryAgain, cost)
        args.quickCloseAnimation = true
        function args.leftBtnCallback()
          MsgManager.DontAgainConfirmMsgByID(43262, function()
            self:LotteryAgain(infoData, 1)
          end, nil, nil, cost)
        end
      end
    else
    end
    FloatAwardView.addItemDatasToShow(list, args)
    FloatAwardView.ForceNewShare()
    _DestroyAndClearTable(args)
  else
    self:ShowNormalAward(list)
  end
  self:ShowAwardCount(item)
end
function LotteryProxy:LotteryAgain(infoData, times)
  local lotteryType = infoData.lotteryType
  local price = self:GetCost(lotteryType, times, infoData.year, infoData.month) / times
  self:CallLottery(lotteryType, infoData.year, infoData.month, infoData.npcId, price, price, true, times)
end
function LotteryProxy:ShowNormalAward(list)
  local args = _CreateTable()
  args.disableMsg = true
  FloatAwardView.addItemDatasToShow(list, args)
  FloatAwardView.ForceNewShare()
  _DestroyAndClearTable(args)
  table.remove(self.recvInfo, 1)
end
function LotteryProxy:RemoveOtherLT()
  if self.otherLT ~= nil then
    self.otherLT:Destroy()
    self.otherLT = nil
  end
end
function LotteryProxy:SetNextValidTime(type, time)
  type = type or 1
  self.callTime[type] = UnityUnscaledTime + time
end
function LotteryProxy:_GetNextValidTime(type)
  type = type or 1
  return self.callTime[type]
end
function LotteryProxy:GetInfo(type)
  return self.infoMap[type]
end
function LotteryProxy:HasFreeCnt(type)
  if LotteryProxy.IsMixLottery(type) then
    return self:GetMixFreeCnt() > 0
  else
    local data = self:GetInfo(type)
    return data and data.freeCount and 0 < data.freeCount
  end
end
function LotteryProxy:GetMonthGroupId(year, month)
  if year and month then
    local id
    if month >= 1 and month <= 6 then
      id = 1
    elseif month >= 7 and month <= 12 then
      id = 2
    end
    return year * 10 + id
  end
  return nil
end
function LotteryProxy:GetHeadwearMonthGroupById(groupId)
  local info = self.infoMap[LotteryType.Head]
  if info ~= nil then
    return info:GetMonthGroupById()
  end
  return nil
end
function LotteryProxy:GetHeadLottery()
  return self.infoMap[LotteryType.Head]
end
function LotteryProxy:GetHeadLotteryFilter()
  local info = self:GetHeadLottery()
  if info then
    return info:GetYearFilter()
  end
end
function LotteryProxy:GetHeadLotteryMonthFilter(year)
  local info = self:GetHeadLottery()
  if info then
    return info:GetMonthFilter(year)
  end
end
function LotteryProxy:GetHeadLotteryFreeCount()
  local info = self:GetHeadLottery()
  if info then
    return info.freeCount or 0
  end
  return 0
end
function LotteryProxy:GetHeadLotteryData(year, month)
  local info = self:GetHeadLottery()
  if not info then
    return
  end
  return info:GetLotteryData(year, month)
end
function LotteryProxy:GetData(type, year, month)
  local info = self.infoMap[type]
  if info ~= nil then
    local groupId = self:GetMonthGroupId(year, month)
    local monthGroupData = info:GetMonthGroupById(groupId)
    if monthGroupData ~= nil then
      return monthGroupData:GetData(year, month)
    end
  end
end
function LotteryProxy:GetRecover(type, noReset)
  if self.recoverMap[type] == nil then
    self.recoverMap[type] = {}
  else
    _ArrayClear(self.recoverMap[type])
  end
  if type == LotteryType.Head then
    self.recoverMap[type] = self:GetFixedHeadwearRecover()
  elseif not noReset then
    local lotteryData = self.infoMap[type]
    if lotteryData ~= nil then
      local items = BagProxy.Instance:GetMainBag():GetItems()
      self:CheckAddItems(type, lotteryData, items)
      local walletsitems = BagProxy.Instance:GetwalletBagData(3, false, 1)
      self:CheckAddItems(type, lotteryData, walletsitems)
    end
  end
  return self.recoverMap[type]
end
function LotteryProxy:CheckAddItems(type, lotteryData, items)
  if not type or not lotteryData or not items then
    return
  end
  for i = 1, #items do
    local bagData = items[i]
    if BagProxy.Instance:CheckIfFavoriteCanBeMaterial(bagData) ~= false then
      local lotteryItemData
      if type == LotteryType.Head then
        lotteryItemData = self:GetLotteryItemDataFromHeadList(bagData.staticData.id, lotteryData:GetAllLotteryDataList())
      else
        lotteryItemData = lotteryData:GetLotteryItemData(bagData.staticData.id)
      end
      if lotteryItemData ~= nil and lotteryItemData.recoverPrice ~= 0 then
        local data = LotteryRecoverData.new(bagData:Clone())
        data:SetInfo(lotteryItemData, type)
        _ArrayPushBack(self.recoverMap[type], data)
      end
    end
  end
end
function LotteryProxy:GetFixedHeadwearRecover()
  if self.headwearRecoverMap == nil then
    self.headwearRecoverMap = {}
  else
    _ArrayClear(self.headwearRecoverMap)
  end
  local items = BagProxy.Instance:GetMainBag():GetItems()
  if not items then
    return
  end
  for i = 1, #items do
    local bagData = items[i]
    if BagProxy.Instance:CheckIfFavoriteCanBeMaterial(bagData) ~= false then
      local headwearRepairConfig = Table_HeadwearRepair[bagData.staticData.id]
      if headwearRepairConfig and headwearRepairConfig.IsHeadwear == 1 and headwearRepairConfig.Price and headwearRepairConfig.Price ~= _EmptyTable then
        local data = LotteryRecoverData.new(bagData:Clone())
        local lotteryItemData = {
          recoverItemid = headwearRepairConfig.Price[1],
          recoverPrice = headwearRepairConfig.Price[2]
        }
        data:SetInfo(lotteryItemData, LotteryType.Head)
        _ArrayPushBack(self.headwearRecoverMap, data)
      end
    end
  end
  return self.headwearRecoverMap
end
function LotteryProxy:GetLotteryItemDataFromHeadList(itemid, list)
  for i = 1, #list do
    local data = list[i]:GetLotteryItemData(itemid)
    if data ~= nil then
      return data
    end
  end
  return nil
end
function LotteryProxy:GetDiscountByCoinType(lotteryType, cointype, price, year, month)
  local discount = ActivityEventProxy.Instance:GetLotteryDiscountByCoinType(lotteryType, cointype, year, month)
  if discount ~= nil and price ~= nil then
    price = math.floor(price * (discount:GetDiscount() / 100))
  end
  return price, discount
end
function LotteryProxy:GetRecoverTotalPrice(selectList, type)
  local total = 0
  local recoverList = self.recoverMap[type]
  if recoverList then
    for i = 1, #selectList do
      for j = 1, #recoverList do
        local recover = recoverList[j]
        if selectList[i] == recover.itemData.id then
          total = total + recover:GetCost()
          break
        end
      end
    end
  end
  return total
end
function LotteryProxy:GetRecoverTotalCost(selectList, type)
  local total = 0
  local recoverDataList = self.recoverMap[type]
  if recoverDataList then
    for i = 1, #selectList do
      for j = 1, #recoverDataList do
        if selectList[i] == recoverDataList[j].itemData.id then
          total = total + recoverDataList[j]:GetTotalCost()
          break
        end
      end
    end
  end
  return total
end
function LotteryProxy:GetHeadwearRepairRecover(selectList)
  local recoverList = {}
  if self.headwearRecoverMap then
    for i = 1, #selectList do
      for j = 1, #self.headwearRecoverMap do
        local recover = self.headwearRecoverMap[j]
        if selectList[i] == recover.itemData.id then
          if not recoverList[recover.costItem] then
            recoverList[recover.costItem] = recover:GetTotalCost()
          else
            recoverList[recover.costItem] = recoverList[recover.costItem] + recover:GetTotalCost()
          end
        end
      end
    end
  end
  return recoverList
end
function LotteryProxy:GetHeadwearRecoverTotalPrice(selectList)
  local total = 0
  local recoverList = self.headwearRecoverMap
  if recoverList then
    for i = 1, #selectList do
      for j = 1, #recoverList do
        local recover = recoverList[j]
        if selectList[i] == recover.itemData.id then
          total = total + recover:GetCost()
          break
        end
      end
    end
  end
  return total
end
function LotteryProxy:GetRecoverData(type, id)
  local recoverList = self.recoverMap[type]
  if recoverList then
    for i = 1, #recoverList do
      if id == recoverList[i].itemData.id then
        return recoverList[i]
      end
    end
  end
end
function LotteryProxy:GetHeadwearRecoverData(id)
  local recoverList = self.headwearRecoverMap
  if recoverList then
    local recover
    for i = 1, #recoverList do
      recover = recoverList[i]
      if id == recover.itemData.id then
        xdlog("指定可回收头饰", id)
        return recover
      end
    end
  end
end
function LotteryProxy:FilterCard(quality)
  local info = self.infoMap[LotteryType.Card]
  if info == nil then
    return nil
  end
  _ArrayClear(self.filterCardList)
  local timecheck_func = ItemUtil.CheckCardCanLotteryByTime
  local items = info.items
  if quality == 0 then
    for i = 1, #items do
      local data = items[i]
      local item = data:GetItemData()
      if timecheck_func(item.staticData.id) then
        _ArrayPushBack(self.filterCardList, data)
      end
    end
  else
    for i = 1, #items do
      local data = info.items[i]
      local item = data:GetItemData()
      if item.staticData and item.staticData.Quality == quality and timecheck_func(item.staticData.id) then
        _ArrayPushBack(self.filterCardList, data)
      end
    end
  end
  table.sort(self.filterCardList, LotteryData.SortItemByQuality)
  return self.filterCardList
end
function LotteryProxy:GetSkipType(lotteryType)
  if lotteryType == LotteryType.Head then
    return SKIPTYPE.LotteryHeadwear
  elseif lotteryType == LotteryType.Equip then
    return SKIPTYPE.LotteryEquip
  elseif lotteryType == LotteryType.Card then
    return SKIPTYPE.LotteryCard
  elseif lotteryType == LotteryType.Magic then
    return SKIPTYPE.LotteryMagic
  elseif lotteryType == LotteryType.MagicSec then
    return SKIPTYPE.LotteryMagicSec
  elseif lotteryType == LotteryType.MagicThird then
    return SKIPTYPE.LotteryMagicThird
  elseif lotteryType == LotteryType.Mixed then
    return SKIPTYPE.LotteryMixed
  elseif lotteryType == LotteryType.MixedSec then
    return SKIPTYPE.LotteryMixedSec
  elseif lotteryType == LotteryType.MixedThird then
    return SKIPTYPE.LotteryMixedThird
  elseif lotteryType == LotteryType.MixedFourth then
    return SKIPTYPE.LotteryMixedFourth
  elseif LotteryProxy.IsNewCardLottery(lotteryType) then
    return SKIPTYPE.LotteryCard_New
  end
  return nil
end
function LotteryProxy:IsSkipGetEffect(type)
  if type ~= nil then
    return LocalSaveProxy.Instance:GetSkipAnimation(type)
  end
end
function LotteryProxy:ProcessNewCardLotteryDiscountCnt()
  self.newCardDisountCntMap = {}
  local card_config = GameConfig.Lottery.CardLottery
  if not card_config then
    return
  end
  local priceMap
  for t, v in pairs(card_config) do
    priceMap = v.CardNewPrice
    local discount_cnt = 0
    for cnt, _ in pairs(priceMap) do
      if cnt > discount_cnt then
        discount_cnt = cnt
      end
    end
    self.newCardDisountCntMap[t] = discount_cnt - 1
  end
end
local _AccMap = {
  [31] = Var_pb.EACCVARTYPE_LOTTERY_CNT_CARD_NEW,
  [32] = Var_pb.EACCVARTYPE_LOTTERY_CNT_CARD_ACTIVITY
}
function LotteryProxy:CheckNewCardDiscountValid(t)
  local todayCnt = MyselfProxy.Instance:GetAccVarValueByType(_AccMap[t]) or 0
  local maxDiscountCnt = self:GetNewCardDiscountCnt(t)
  return todayCnt < maxDiscountCnt
end
function LotteryProxy:GetNewCardDiscountCnt(t)
  return self.newCardDisountCntMap[t] or 0
end
function LotteryProxy:SetIsOpenView(isOpen)
  self.isOpenView = isOpen
end
function LotteryProxy:GetSpecialEquipCount(selectList, type)
  local isExist = false
  local totalTicket = 0
  local recoverList = self.recoverMap[type]
  if recoverList then
    for i = 1, #selectList do
      for j = 1, #recoverList do
        local recover = recoverList[j]
        if selectList[i] == recover.itemData.id and ShopMallProxy.Instance:JudgeSpecialEquip(recover.itemData) then
          isExist = true
          totalTicket = totalTicket + recover.specialCost
          break
        end
      end
    end
  end
  return isExist, totalTicket
end
function LotteryProxy:GetSpecialHeadwearEquipCount(selectList)
  local isExist = false
  local totalTicket = 0
  local recoverList = self.headwearRecoverMap
  if recoverList then
    for i = 1, #selectList do
      for j = 1, #recoverList do
        local recover = recoverList[j]
        if selectList[i] == recover.itemData.id and ShopMallProxy.Instance:JudgeSpecialEquip(recover.itemData) then
          isExist = true
          totalTicket = totalTicket + recover.specialCost * recover.selectCount
          break
        end
      end
    end
  end
  return isExist, totalTicket
end
function LotteryProxy:CheckTodayCanBuy(type, times)
  if BranchMgr.IsChina() and LotteryProxy.IsMixLottery(type) then
    if times == 1 then
      return self.mixTodayCount < self.mixMaxCount
    else
      return self.mixTodayTenCount < self.mixTenMaxCount
    end
  end
  local info = self.infoMap[type]
  if info ~= nil then
    if info.maxCount == 0 then
      return true
    end
    if times == 1 then
      return info.todayCount + times <= info.maxCount
    elseif times == 10 then
      if info.maxTenCount == 0 then
        return true
      end
      return info.todayTenCount + 1 <= info.maxTenCount
    end
  end
  return true
end
function LotteryProxy:DownloadMagicPicFromUrl(picUrl)
  local urlFileName = string.match(picUrl, ".+/([^/]*%.%w+)$")
  local sb = LuaStringBuilder.CreateAsTable()
  sb:Append(IOPathConfig.Paths.PUBLICPIC.LotteryPicture)
  sb:Append("/")
  sb:Append(urlFileName)
  local localPath = sb:ToString()
  if localPath then
    do
      local currentTime = math.floor(ServerTime.CurServerTime() / 1000)
      local bytes = DiskFileManager.Instance:LoadFile(localPath, currentTime)
      if bytes then
        local localMd5 = MyMD5.HashBytes(bytes)
        local urlMd5 = string.match(picUrl, ".+/([^/]*)%.%w+$")
        if urlMd5 == localMd5 then
          sb:Destroy()
          return bytes
        end
      end
      sb:Clear()
      sb:Append(ApplicationHelper.persistentDataPath)
      sb:Append("/TempDownloadLottery/")
      local tempPath = sb:ToString()
      FileHelper.CreateDirectory(tempPath)
      sb:Destroy()
      tempPath = tempPath .. urlFileName
      if tempPath then
        if FileHelper.ExistFile(tempPath) then
          FileHelper.DeleteFile(tempPath)
        end
        local funcOnProgress = function(progress)
        end
        local funcOnSuccess = function()
          local bytes = FileHelper.LoadFile(tempPath)
          local currentTime = math.floor(ServerTime.CurServerTime() / 1000)
          DiskFileManager.Instance:SaveFile(localPath, bytes, currentTime)
          FileHelper.DeleteFile(tempPath)
          self:sendNotification(LotteryEvent.MagicPictureComplete, {picUrl = picUrl, bytes = bytes})
          EventManager.Me():PassEvent(LotteryEvent.MagicPictureComplete, {picUrl = picUrl, bytes = bytes})
        end
        local funcOnFail = function(errorMessage)
          if FileHelper.ExistFile(tempPath) then
            FileHelper.DeleteFile(tempPath)
          end
        end
        if FunctionCloudFile.IsActive() then
          FunctionCloudFile.Me():Download(picUrl, tempPath, false, funcOnProgress, function(isSuccess, errorMessage)
            if isSuccess then
              funcOnSuccess()
            else
              funcOnFail(errorMessage)
            end
          end)
        else
          local taskRecordID = CloudFile.CloudFileManager.Ins:Download(picUrl, tempPath, false, funcOnProgress, funcOnSuccess, funcOnFail, nil)
        end
      else
      end
    end
  else
  end
end
function LotteryProxy:LoadFromLocal(picUrl)
  local urlFileName = string.match(picUrl, ".+/([^/]*%.%w+)$")
  local sb = LuaStringBuilder.CreateAsTable()
  sb:Append(IOPathConfig.Paths.PUBLICPIC.LotteryPicture)
  sb:Append("/")
  sb:Append(urlFileName)
  local localPath = sb:ToString()
  sb:Destroy()
  if localPath then
    local currentTime = math.floor(ServerTime.CurServerTime() / 1000)
    local bytes = DiskFileManager.Instance:LoadFile(localPath, currentTime)
    if bytes then
      local localMd5 = MyMD5.HashBytes(bytes)
      local urlMd5 = string.match(picUrl, ".+/([^/]*)%.%w+$")
      if urlMd5 == localMd5 then
        return bytes
      end
    end
  end
end
function LotteryProxy.SortEquipLottery(a, b)
  local alevel, blevel = a.Level, b.Level
  return alevel[1] < b.Level[1]
end
function LotteryProxy:InitEquipLottery()
  if not Table_EquipLottery then
    return
  end
  self.equipLottery_Map = {}
  for _, data in pairs(Table_EquipLottery) do
    local itemid = data.ItemId
    if not self.equipLottery_Map[itemid] then
      self.equipLottery_Map[itemid] = {}
    end
    table.insert(self.equipLottery_Map[itemid], data)
  end
  for _, datas in pairs(self.equipLottery_Map) do
    table.sort(datas, LotteryProxy.SortEquipLottery)
  end
end
function LotteryProxy:GetEquipLotteryShowDatas(itemid)
  if self.equipLottery_Map == nil then
    return
  end
  local config = self.equipLottery_Map[itemid]
  if config then
    local mylevel = MyselfProxy.Instance:RoleLevel()
    local index
    for i = 1, #config do
      local level_regin = config[i].Level
      if mylevel >= level_regin[1] and mylevel <= level_regin[2] then
        index = i
        break
      end
    end
    if index then
      return config[index], config[index + 1]
    end
  end
end
function LotteryProxy:IsLotteryEquip(itemid)
  if self.equipLottery_Map == nil then
    return false
  end
  return self.equipLottery_Map[itemid] ~= nil
end
function LotteryProxy:ShowAwardCount(itemData)
  local itemType = itemData.staticData.Type
  local isCountShow = itemType == 800 or itemType == 810 or itemType == 830 or itemType == 840 or itemType == 850 or itemType == 501
  if itemData and isCountShow then
    local itemId = itemData.staticData.id
    local itemFind = BagProxy.Instance:GetItemByGuid(itemData.id)
    local itemTotalCount = BagProxy.Instance:GetAllItemNumByStaticID(itemId)
    local carCount = BagProxy.Instance:GetItemNumByStaticID(itemId, BagProxy.BagType.Barrow)
    itemTotalCount = itemTotalCount + carCount
    local adventureCheckId = itemId
    local equipData = Table_Equip[itemId]
    if equipData and equipData.GroupID then
      adventureCheckId = equipData.GroupID
    end
    if AdventureDataProxy.Instance:IsFashionStored(adventureCheckId) then
      itemTotalCount = itemTotalCount + 1
    end
    if not itemFind then
      itemTotalCount = itemTotalCount + 1
    end
    if itemTotalCount > 1 then
      FloatAwardView.showHaveCount(itemTotalCount)
    else
      FloatAwardView.hideHaveCount()
    end
  else
    FloatAwardView.hideHaveCount()
  end
end
function LotteryProxy.CheckPocketLotteryEnabled()
  return GameConfig.Lottery.IsCarry == 1
end
function LotteryProxy:SetPocketLotteryViewShowing(isShowing)
  self.isPocketLotteryViewShowing = isShowing
end
function LotteryProxy:IsPocketLotteryViewShowing()
  return self.isPocketLotteryViewShowing or false
end
function LotteryProxy:GetPocketLotteryActivityInfo()
  if not LotteryProxy.CheckPocketLotteryEnabled() then
    return nil
  end
  return self.pocketLotteryActivityMap
end
function LotteryProxy:RecvQueryLotteryExtraBonusItemCmd(data)
  if not data.etype then
    return
  end
  self.extraCount[data.etype] = data.lotterycount or 0
  if data.extrabonus then
    local receivedbonus = self.extraBonusProgressMap[data.etype] or {}
    TableUtility.ArrayClear(receivedbonus)
    for i = 1, #data.extrabonus do
      table.insert(receivedbonus, data.extrabonus[i])
    end
    table.sort(receivedbonus)
    self.extraBonusProgressMap[data.etype] = receivedbonus
  end
end
function LotteryProxy:RecvQueryLotteryExtraBonusCfgCmd(data)
  if not data.etype then
    return
  end
  if data.extrabonus and #data.extrabonus > 0 then
    self.extraMap[data.etype] = LotteryExtraBonusData.new(data.extrabonus, data.etype)
  end
end
function LotteryProxy:GetCurrentExtraStageByType(lotteryType)
  local extradata = self.extraMap[lotteryType]
  if extradata then
    local receivedbonus = self.extraBonusProgressMap[lotteryType] or {}
    if #receivedbonus == 0 then
      return extradata:GetCurrentStage(0)
    else
      return extradata:GetCurrentStage(receivedbonus[#receivedbonus])
    end
  end
end
function LotteryProxy:GetCurrentExtraCount(lotteryType)
  return self.extraCount[lotteryType]
end
function LotteryProxy:FilterMagic(type, filterType)
  _ArrayClear(self.filterMagicList)
  local info = self.infoMap[type]
  if info ~= nil then
    local config = GameConfig.Lottery.MagicFilter[filterType]
    if config ~= nil then
      local data
      local types = config.types
      for i = 1, #info.items do
        data = info.items[i]
        if types[data.itemType] ~= nil and self:_CheckFilterCondition(config.condition, data.itemid) then
          _ArrayPushBack(self.filterMagicList, data)
        end
      end
    end
  end
  return self.filterMagicList
end
function LotteryProxy:_CheckFilterCondition(condition, itemid)
  if condition == nil then
    return true
  end
  if condition == "Unlock" then
    local id = itemid
    local equip = Table_Equip[id]
    if equip and equip.GroupID then
      id = equip.GroupID
    end
    if not AdventureDataProxy.Instance:IsFashionOrMountUnlock(id) then
      return true
    end
  end
  return false
end
function LotteryProxy:GetMaxExtraCount(lotteryType)
  local extradata = self.extraMap[lotteryType]
  return extradata and extradata:GetMaxCount() or 0
end
function LotteryProxy:CheckReceive(lotteryType, id)
  local receivedbonus = self.extraBonusProgressMap[lotteryType]
  if receivedbonus and id then
    for k, v in pairs(receivedbonus) do
      if id == v then
        return true
      end
    end
  end
  return false
end
function LotteryProxy:GetExtraBonusList(lotteryType)
  local extradata = self.extraMap[lotteryType]
  return extradata and extradata:GetDataList()
end
function LotteryProxy:GetKeyList(lotteryType)
  local extradata = self.extraMap[lotteryType]
  return extradata and extradata:GetKeyList() or _EmptyTable
end
function LotteryProxy:CheckCanUseTicket()
  local Ticket = GameConfig.Lottery.Ticket
  if not self.magicLotteryItemMap then
    self.magicLotteryItemMap = {}
    for ltype, v in pairs(Ticket) do
      if v.itemid == 5800 then
        self.magicLotteryItemMap[#self.magicLotteryItemMap + 1] = ltype
      end
    end
  end
  for i = 1, #self.magicLotteryItemMap do
    if self.lotteryActMap[self.magicLotteryItemMap[i]] then
      return true
    end
  end
  return false
end
function LotteryProxy:SetMixlotterycnts(serverCntData, free_cnt)
  self.mixFreeCnt = free_cnt or 0
  for i = 1, #serverCntData do
    if serverCntData[i].etype == SceneItem_pb.EMIXLOTTERY_USECOIN_ONCE then
      self.mixTodayCount = serverCntData[i].today_cnt
      self.mixMaxCount = serverCntData[i].max_cnt
    elseif serverCntData[i].etype == SceneItem_pb.ECOINLOTTERY_TYPE_TENCOMBOS then
      self.mixTodayTenCount = serverCntData[i].today_cnt
      self.mixTenMaxCount = serverCntData[i].max_cnt
    end
  end
  if self.mixLottery and nil ~= next(self.mixLottery) then
    TableUtility.TableClear(self.mixLotteryUngetCount)
    local _AdventureDataProxy = AdventureDataProxy.Instance
    local lotteryFilter = GameConfig.MixLottery and GameConfig.MixLottery.LotteryFilter
    for groupId, tabDataList in pairs(self.mixLottery) do
      local ungetCount = 0
      for i = 1, #tabDataList do
        if _AdventureDataProxy:IsFashionNeverDisplay(tabDataList[i].itemid, true) then
          ungetCount = ungetCount + 1
        end
      end
      self.mixLotteryUngetCount[groupId] = ungetCount
      local filterDescConfig = lotteryFilter and lotteryFilter[groupId]
      if filterDescConfig and 0 == self.mixLotteryUngetCount[groupId] then
        self.lotteryFilterData[groupId] = filterDescConfig
      end
    end
  end
end
function LotteryProxy:GetMixFreeCnt()
  return self.mixFreeCnt or 0
end
function LotteryProxy:GetMixCnts()
  return self.mixTodayCount, self.mixMaxCount, self.mixTodayTenCount, self.mixTenMaxCount
end
local _MixLotteryRewardTabGroup = 999
function LotteryProxy:HandleRecvMixLotteryArchiveCmd(serverData)
  if not serverData then
    return
  end
  if not LotteryProxy.IsMixLottery(serverData.type) then
    return
  end
  self.mixLotteryPrice = serverData.price or 0
  self.mixLotteryOnceMaxCount = serverData.once_max_cnt or 10
  self.mixLottery = {}
  self.mixLotteryUngetCount = {}
  self.mixGroupRate = {}
  local lotteryFilter = GameConfig.MixLottery and GameConfig.MixLottery.LotteryFilter
  local _AdventureDataProxy = AdventureDataProxy.Instance
  for i = 1, #serverData.groups do
    local group = serverData.groups[i]
    local groupId = group.groupid
    local serverItems = group.items
    local grouprate = group.grouprate
    self.mixGroupRate[groupId] = grouprate
    local itemData = {}
    local ungetCount = 0
    for j = 1, #serverItems do
      if _AdventureDataProxy:IsFashionNeverDisplay(serverItems[j].id, true) then
        ungetCount = ungetCount + 1
      end
      itemData[#itemData + 1] = MixLotteryItemData.new(serverItems[j].id, grouprate, groupId, serverItems[j].count)
    end
    table.sort(itemData, MixLotteryItemData.SortFunc)
    self.mixLotteryUngetCount[groupId] = ungetCount
    self.mixLottery[groupId] = itemData
  end
  self:UpdateMixLotteryFilterData()
  self:ResetMixLotteryList()
end
function LotteryProxy:UpdateMixLotteryFilterData()
  if not self.mixLotteryUngetCount then
    return
  end
  self.lotteryFilterData = {}
  local lotteryFilter = GameConfig.MixLottery and GameConfig.MixLottery.LotteryFilter
  if lotteryFilter then
    self.lotteryFilterData[0] = lotteryFilter[0]
    local allRate = 0
    for k, v in pairs(lotteryFilter) do
      if k ~= 0 and k ~= _MixLotteryRewardTabGroup then
        if 0 ~= self:GetUngetCount(k) then
          local tempRate = self.mixGroupRate[k] / 10000
          allRate = allRate + tempRate * 100
          self.lotteryFilterData[k] = v .. tempRate * 100 .. "%"
        else
          self.lotteryFilterData[k] = v
        end
      end
    end
    self.lotteryFilterData[_MixLotteryRewardTabGroup] = lotteryFilter[_MixLotteryRewardTabGroup] .. 100 - allRate .. "%"
  end
end
function LotteryProxy:SetDress(var)
  self.inDress = var
end
function LotteryProxy:ClearDressMap()
  TableUtility.TableClear(self.dressMap)
end
function LotteryProxy:UpdateDressMap(partIndex, id)
  local cacheID = self.dressMap[partIndex]
  if not cacheID or cacheID ~= id then
    self.dressMap[partIndex] = id
  else
    self.dressMap[partIndex] = nil
  end
end
function LotteryProxy:InLotteryDress()
  return self.inDress
end
function LotteryProxy:GetDressID(partIndex)
  return self.dressMap[partIndex]
end
function LotteryProxy:CheckEquipInPreview(itemid)
  local partIndex = ItemUtil.getItemRolePartIndex(itemid)
  if 0 ~= partIndex then
    if Asset_Role.PartIndex.Body == partIndex then
      local myRace = MyselfProxy.Instance:GetMyRace()
      itemid = Table_Equip[itemid].Body[myRace]
    end
    return self.dressMap[partIndex] == itemid
  end
end
function LotteryProxy:GetDressItemDesc(itemid)
  local partIndex = ItemUtil.getItemRolePartIndex(itemid)
  if 0 == partIndex then
    return ZhString.Lottery_NoDress
  elseif self:CheckEquipInPreview(itemid) then
    return ZhString.Lottery_InDress
  else
    return ZhString.Lottery_UnDress
  end
end
function LotteryProxy:OpenNewLottery(t)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.LotteryMainView,
    viewdata = {lotteryType = t}
  })
end
function LotteryProxy:GetMixLotteryFilter()
  return self.lotteryFilterData
end
function LotteryProxy:GetRateBuyGroup(g)
  return self.mixGroupRate[g] / 10000
end
function LotteryProxy:GetUngetCount(groupid)
  return self.mixLotteryUngetCount[groupid]
end
function LotteryProxy:ResetMixLotteryList()
  if nil == self.mixLotteryList then
    self.mixLotteryList = {}
  else
    _ArrayClear(self.mixLotteryList)
  end
  for _, datas in pairs(self.mixLottery) do
    _InsertArray(self.mixLotteryList, datas)
  end
  table.sort(self.mixLotteryList, MixLotteryItemData.SortFunc)
end
local previewItems = {}
function LotteryProxy:InitMixLotteryGameConfig(type, nnpc)
  self.mixLotteryType = type
  local cfg = GameConfig.MixLottery
  if not cfg then
    redlog("混合扭蛋未找到配置 GameConfig.MixLottery ")
    return
  end
  local mixConfig = cfg.MixLotteryShop and cfg.MixLotteryShop[type]
  if not mixConfig then
    redlog("混合扭蛋未找到配置 GameConfig.MixLottery.MixLotteryShop, error lotteryType: ", type)
    return
  end
  if nil == self.mixLotteryStaticData[type] then
    _ArrayClear(previewItems)
    local items = mixConfig.PreviewItems
    if nil ~= items then
      local itemdata
      for i = 1, #items do
        itemdata = ItemData.new("MixLotteryPreview", items[i])
        _ArrayPushBack(previewItems, itemdata)
      end
    end
    local staticData = {}
    staticData.Replaceid = cfg.Replaceid
    staticData.ShopType = cfg.ShopType
    staticData.PreviewItems = previewItems
    staticData.Texture = mixConfig.Texture
    staticData.ShopID = mixConfig.ShopID
    self.mixLotteryStaticData[type] = staticData
  end
  HappyShopProxy.Instance:InitShop(nnpc, mixConfig.ShopID, self.mixLotteryStaticData[type].ShopType)
end
function LotteryProxy:GetRecentMixLotteryType()
  return self.mixLotteryType
end
function LotteryProxy:GetMixStaticData(type)
  return self.mixLotteryStaticData[type]
end
local filter = {}
function LotteryProxy.GetLotteryFilter(config)
  _ArrayClear(filter)
  for k, v in pairs(config) do
    table.insert(filter, k)
  end
  table.sort(filter, function(l, r)
    return l < r
  end)
  return filter
end
local filterResult, filterData = {}, nil
function LotteryProxy:FilterMixLottery(group, onlyNoGet)
  if group == 0 then
    filterData = self.mixLotteryList
  else
    filterData = self.mixLottery and self.mixLottery[group]
  end
  if not filterData then
    return _EmptyTable
  end
  local _AdventureDataProxy = AdventureDataProxy.Instance
  local getLimited
  _ArrayClear(filterResult)
  for i = 1, #filterData do
    if onlyNoGet then
      local goodsID = filterData[i].itemid
      getLimited = not _AdventureDataProxy:IsFashionNeverDisplay(goodsID, true)
    else
      getLimited = false
    end
    if not getLimited then
      _ArrayPushBack(filterResult, filterData[i])
    end
  end
  return filterResult
end
function LotteryProxy:FilterMixLotteryShop(type, site, quality, onlyNoGet)
  local staticData = self:GetMixStaticData(type)
  if not staticData then
    return _EmptyTable
  end
  local shopConfig = ShopProxy.Instance:GetConfigByTypeId(staticData.ShopType, staticData.ShopID)
  _ArrayClear(filterResult)
  local _AdventureDataProxy = AdventureDataProxy.Instance
  local getLimited
  for k, v in pairs(shopConfig) do
    local itemStatic = v:GetItemData().staticData
    local siteLimited = site ~= 0 and itemStatic.Type ~= site
    local qualityLimited = quality ~= 0 and itemStatic.Quality ~= quality
    if onlyNoGet then
      getLimited = not _AdventureDataProxy:IsFashionNeverDisplay(v.goodsID)
    else
      getLimited = false
    end
    if not siteLimited and not qualityLimited and not getLimited then
      _ArrayPushBack(filterResult, v)
    end
  end
  table.sort(filterResult, function(l, r)
    local lsortId = _AdventureDataProxy:IsFashionNeverDisplay(l.goodsID) and 1 or 0
    local rsortId = _AdventureDataProxy:IsFashionNeverDisplay(r.goodsID) and 1 or 0
    if lsortId == rsortId then
      return l.ShopOrder < r.ShopOrder
    else
      return lsortId > rsortId
    end
  end)
  return filterResult
end
local _lotteryActivityDirty = false
function LotteryProxy:RecvLotteryActivityNtf(infoList)
  _lotteryActivityDirty = true
  TableUtility.TableClear(self.lotteryActMap)
  for i = 1, #infoList do
    local t = infoList[i].type
    if LotteryProxy.IsNewLottery(t) then
      self.lotteryActMap[t] = LotteryActivityData.new(infoList[i].type, infoList[i].open, infoList[i].starttime, infoList[i].endtime)
    end
  end
end
function LotteryProxy:GetActivityLottery()
  if _lotteryActivityDirty then
    _ArrayClear(self.lotteryActs)
    TableUtil.HashToArray(self.lotteryActMap, self.lotteryActs)
    TableUtil.HashToArray(self.lotteryAlways, self.lotteryActs)
    table.sort(self.lotteryActs, function(a, b)
      return a.lotteryType < b.lotteryType
    end)
    _lotteryActivityDirty = false
  end
  return self.lotteryActs
end
function LotteryProxy:GetOpenActivityLottery()
  local result = {}
  local activitys = self:GetActivityLottery()
  for i = 1, #activitys do
    if activitys[i].open and GameConfig.Lottery.activity[activitys[i].lotteryType] then
      result[#result + 1] = activitys[i]
    end
  end
  return result
end
function LotteryProxy:GetActivityLotteryData()
  return self.curLotteryActivityData
end
function LotteryProxy:SetCurNewLottery(t)
  self.curNewLotteryType = t
  if t then
    self.curLotteryActivityData = self.lotteryActMap[t] or self.lotteryAlways[t]
  else
    self.curLotteryActivityData = nil
  end
end
function LotteryProxy:CheckLotteryOpen(t)
  if not self.lotteryActMap and not self.lotteryAlways then
    return false
  end
  local data = self.lotteryActMap[t] or self.lotteryAlways[t]
  if not data then
    return false
  end
  return data.open == true
end
function LotteryProxy:BackToLottery()
  if not self.curNewLotteryType then
    return
  end
  self:OpenNewLottery(self.curNewLotteryType)
end
function LotteryProxy:GetNextLottery(forword)
  local list = self:GetOpenActivityLottery()
  if not next(list) or not self.curNewLotteryType then
    return
  end
  local index
  for i = 1, #list do
    if list[i].lotteryType == self.curNewLotteryType then
      index = i
      break
    end
  end
  if not index then
    return
  end
  if forword then
    if index >= #list then
      return list[1]
    else
      return list[index + 1]
    end
  elseif index <= 1 then
    return list[#list]
  else
    return list[index - 1]
  end
end
function LotteryProxy:GetLotteryHeadIds()
  return self.lotteryHeadIds
end
function LotteryProxy:HandleLotteryHeadItem(data)
  if not data then
    return
  end
  self.lotteryHeadIds = self.lotteryHeadIds or {}
  _ArrayClear(self.lotteryHeadIds)
  for i = 1, #data do
    _ArrayPushBack(self.lotteryHeadIds, data[i])
  end
end
local BannerConfig = GameConfig.LotteryBanner
function LotteryProxy:RecvLotteryBannerInfo(infoList)
  self.lotteryBanner = self.lotteryBanner or {}
  local open, ltype, starttime
  for i = 1, #infoList do
    open = infoList[i].open
    ltype = infoList[i].type
    starttime = infoList[i].starttime
    if ltype then
      if open then
        redlog("ltype", ltype, starttime)
        self.lotteryBanner[ltype] = starttime
      else
        self.lotteryBanner[ltype] = 0
      end
    end
  end
end
local DateStr = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
function LotteryProxy:GetBannerList()
  if not self.bannerList then
    self.bannerList = {}
  else
    TableUtility.ArrayClear(self.bannerList)
  end
  local validDate, validEnd = "", ""
  if self.lotteryBanner then
    for lotterytype, starttime in pairs(self.lotteryBanner) do
      if starttime > 0 then
        local typeConfig = BannerConfig[lotterytype]
        if typeConfig then
          for i = 1, #typeConfig do
            if EnvChannel.IsReleaseBranch() then
              validDate = typeConfig[i].ValidDate
              validEnd = typeConfig[i].EndDate
            elseif EnvChannel.IsTFBranch() then
              validDate = typeConfig[i].TFValidDate
              validEnd = typeConfig[i].TFEndDate
            end
            if not StringUtil.IsEmpty(validDate) and not StringUtil.IsEmpty(validEnd) and self.freeTypes[lotterytype] then
              local year, month, day, hour, min, sec = validDate:match(DateStr)
              local startDate = os.time({
                day = day,
                month = month,
                year = year,
                hour = hour,
                min = min,
                sec = sec
              })
              year, month, day, hour, min, sec = validEnd:match(DateStr)
              local endData = os.time({
                day = day,
                month = month,
                year = year,
                hour = hour,
                min = min,
                sec = sec
              })
              if starttime >= startDate and starttime < endData then
                local single = {}
                single.type = lotterytype
                single.styleID = typeConfig[i].styleID
                single.validDate = validDate
                single.validEnd = validEnd
                table.insert(self.bannerList, single)
              end
            end
          end
        end
      end
    end
  end
  table.sort(self.bannerList, function(a, b)
    return a.styleID > b.styleID
  end)
  return self.bannerList
end
function LotteryProxy:CanShow()
  if not self.lotteryBanner then
    redlog("CanShow false")
    return false
  end
  local bList = self:GetBannerList()
  if not bList or #bList == 0 then
    redlog("CanShow false")
    return false
  end
  local freeFlag = false
  for ltype, v in pairs(self.freeTypes) do
    local dont = LocalSaveProxy.Instance:GetBannerDontShowAgain(ltype)
    redlog("ltype", ltype, show)
    if not dont then
      redlog("CanShow false")
      return true
    end
  end
  redlog("CanShow false")
  return false
end
local deltaday = 86400
function LotteryProxy:IsSameDay(timestampOld, timestampNew)
  local offset = (5 - ServerTime.SERVER_TIMEZONE) * 60 * 60
  return timestampNew - offset - (timestampOld - offset) < deltaday
end
function LotteryProxy:GetCardByItemtype(lotterytype, itemtype)
  local info = self.infoMap[lotterytype]
  if info == nil then
    return nil
  end
  _ArrayClear(self.filterCardList)
  local timecheck_func = ItemUtil.CheckCardCanLotteryByTime
  local items = info.items
  if itemtype == 0 then
    for i = 1, #items do
      local data = items[i]
      local item = data:GetItemData()
      if timecheck_func(item.staticData.id) then
        _ArrayPushBack(self.filterCardList, data)
      else
        redlog("not in time")
      end
    end
  else
    for i = 1, #items do
      local data = info.items[i]
      local item = data:GetItemData()
      if data.itemType and data.itemType == itemtype then
        if timecheck_func(item.staticData.id) then
          _ArrayPushBack(self.filterCardList, data)
        else
          redlog("not in time")
        end
      end
    end
  end
  table.sort(self.filterCardList, LotteryData.SortItemByItemtype)
  return self.filterCardList
end
local CardConfig = GameConfig.Lottery.CardLottery
function LotteryProxy:CalculteCardCost(tp, count, times)
  if not tp or not CardConfig[tp] then
    return nil
  end
  local priceConfig = CardConfig[tp].CardNewPrice
  local priceList = {}
  for cnt, prc in pairs(priceConfig) do
    table.insert(priceList, {count = cnt, price = prc})
  end
  table.sort(priceList, function(l, r)
    return l.count < r.count
  end)
  local usedCount, amount = 1, 0
  for i = 1, times do
    amount = amount + self:GetCurrentCardCost(count + usedCount, times, priceList)
    usedCount = usedCount + 1
  end
  return amount
end
function LotteryProxy:GetCurrentCardCost(currentTime, times, priceList)
  local lastPrice = priceList[1].price
  for i = 1, #priceList do
    if currentTime < priceList[i].count then
      return lastPrice
    else
      lastPrice = priceList[i].price
    end
  end
  if times < currentTime then
    return lastPrice
  end
  return lastPrice
end
function LotteryProxy:GetUpDuration(lotterytype)
  local info = self.infoMap[lotterytype]
  if not info then
    return nil
  end
  return info:GetUpDuration()
end
function LotteryProxy:RecvLotteryDataSyncItemCmd(data)
  if data and data.free_types then
    TableUtility.TableClear(self.freeTypes)
    for i = 1, #data.free_types do
      self.freeTypes[data.free_types[i]] = true
      redlog("free_types", data.free_types[i])
    end
  end
end
local _sortDailyFunc = function(l, r)
  return l.Day < r.Day
end
function LotteryProxy:InitDailyReward()
  self.syncDailyRewardMap = {}
  self.curDailyRewardMap = {}
  self:InitStaticDailyReward()
end
function LotteryProxy:InitStaticDailyReward()
  self.staticDaily = {}
  self.staticActivityID2LotteryType = {}
  self.staticDailyBetterDay = {}
  local actID
  for _, cfg in pairs(Table_LotteryDailyReward) do
    actID = cfg.ActivityID
    if nil == self.staticDailyBetterDay[actID] then
      self.staticDailyBetterDay[actID] = {}
    end
    if not self.staticDaily[actID] then
      self.staticDaily[actID] = {}
      local lotteryTypeMap = {}
      for i = 1, #cfg.LotteryType do
        lotteryTypeMap[cfg.LotteryType[i]] = 1
      end
      self.staticActivityID2LotteryType[actID] = lotteryTypeMap
    end
    _ArrayPushBack(self.staticDaily[actID], cfg)
    if cfg.BetterDay and cfg.BetterDay == 1 then
      _ArrayPushBack(self.staticDailyBetterDay[actID], cfg)
    end
  end
  for _, configList in pairs(self.staticDaily) do
    table.sort(configList, _sortDailyFunc)
  end
  for _, list in pairs(self.staticDailyBetterDay) do
    table.sort(list, _sortDailyFunc)
  end
end
function LotteryProxy:GetStaticDailyReward(activityid, day)
  local list = self.staticDaily[activityid]
  if list then
    return list[day]
  end
end
function LotteryProxy:AddDailyReward(activityid, endtime)
  self.curDailyRewardMap[activityid] = endtime
end
function LotteryProxy:RemoveDailyReward(activityid)
  self.curDailyRewardMap[activityid] = nil
end
function LotteryProxy:GetDailyRewardEndTime(id)
  return self.curDailyRewardMap[id]
end
function LotteryProxy:GetCurDailyLotteryActID()
  return self.curDailyLotteryActID
end
function LotteryProxy:TryGetDailyReward(lottery_type)
  self.rewardDay, self.rewardTime = nil, nil
  TableUtil.Print(self.curDailyRewardMap)
  for actid, _ in pairs(self.curDailyRewardMap) do
    local typeMap = self.staticActivityID2LotteryType[actid]
    if nil ~= typeMap[lottery_type] then
      self.rewardDay, self.rewardTime = self:GetSyncDailyRewardData(actid)
      local day = self.rewardTime == 0 and 1 or self.rewardDay
      self:_SetDailyLotteryReward(actid, day)
      self.curDailyLotteryActID = actid
      break
    end
  end
  return self.rewardDay, self.rewardTime
end
function LotteryProxy:RecvLotteryDailyRewardSyncItem(data)
  local rewards = data.dailyrewards
  if not rewards then
    return
  end
  for i = 1, #rewards do
    self:_updateDailyReward(rewards[i])
  end
end
function LotteryProxy:GetDailyRewardDayLength(id)
  return #self.staticDaily[id]
end
function LotteryProxy:_updateDailyReward(reward)
  local id, rewardDay, rewardTime = reward.activityid, reward.rewardday, reward.rewardtime
  local intervalDay
  local maxDay = self:GetDailyRewardDayLength(id)
  rewardDay = rewardDay >= maxDay and 1 or rewardDay + 1
  local data = self.syncDailyRewardMap[id]
  if data then
    data[1] = rewardDay
    data[2] = rewardTime
  else
    self.syncDailyRewardMap[id] = {rewardDay, rewardTime}
  end
end
function LotteryProxy:GetSyncDailyRewardData(id)
  local data = self.syncDailyRewardMap[id]
  if data then
    return data[1], data[2]
  else
    return 1, 0
  end
end
function LotteryProxy:GetNearlyBetterDay(id)
  if not self.rewardDay then
    return
  end
  local list = self.staticDailyBetterDay[id]
  if not list or not next(list) then
    return
  end
  if list[#list].Day == self.rewardDay then
    return list[1], list[1].Day + 1
  else
    for i = 1, #list do
      if list[i].Day > self.rewardDay then
        return list[i], list[i].Day - self.rewardDay + 1
      end
    end
  end
end
function LotteryProxy:_SetDailyLotteryReward(id, day)
  local config = self:GetStaticDailyReward(id, day)
  if config then
    self.nextItemData = ItemData.new("nextDailyReward", config.ItemID)
    self.nextItemData:SetItemNum(config.ItemCount)
  end
  local bestRewardConfig
  bestRewardConfig, self.betteryIntervalDay = self:GetNearlyBetterDay(id)
  if bestRewardConfig then
    self.bestItemData = ItemData.new("bestDailyReward", bestRewardConfig.ItemID)
    self.bestItemData:SetItemNum(bestRewardConfig.ItemCount)
  end
end
function LotteryProxy:GetDailyRewardItemData()
  return self.nextItemData, self.bestItemData
end
function LotteryProxy:GetCost(lotteryType, times, year, month)
  if times == 1 then
    local hasFreeCnt = self:HasFreeCnt(lotteryType)
    if hasFreeCnt then
      return 0
    end
  end
  local cost = 0
  if LotteryProxy.IsMixLottery(lotteryType) then
    cost = self.mixLotteryPrice
  elseif LotteryProxy.IsNewPocketCardLottery(lotteryType) then
    local todayCount = MyselfProxy.Instance:GetAccVarValueByType(_VarMap[lotteryType]) or 0
    return self:CalculteCardCost(lotteryType, todayCount, times)
  end
  local data = self:GetInfo(lotteryType)
  if data then
    if LotteryProxy.IsHeadLottery(lotteryType) then
      local head = data:GetLotteryData(year, month)
      if head then
        cost = head.price
      end
    else
      cost = data.price
    end
  end
  cost = self:GetDiscountByCoinType(lotteryType, AELotteryDiscountData.CoinType.Coin, cost, year, month)
  return cost * times
end
