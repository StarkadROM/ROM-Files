autoImport("ServiceItemAutoProxy")
ServiceItemProxy = class("ServiceItemProxy", ServiceItemAutoProxy)
ServiceItemProxy.Instance = nil
ServiceItemProxy.NAME = "ServiceItemProxy"
function ServiceItemProxy:ctor(proxyName)
  if ServiceItemProxy.Instance == nil then
    self.proxyName = proxyName or ServiceItemProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceItemProxy.Instance = self
  end
  NetProtocol.NeedCacheReceive(6, 1)
  NetProtocol.NeedCacheReceive(6, 2)
end
function ServiceItemProxy:CallItemUse(item, targetId, count, value, targetItemguids)
  if item.staticData.Type == 40 and Game.Myself:IsDead() then
    return
  end
  NewRechargeProxy.Instance:TryUseBatchItem(item.staticData and item.staticData.id)
  LogUtility.Info(string.format("CallItemUse itemid:%s name:%s targetId:%s count:%s value:%s targetItemguids:%sguids", tostring(item.id), tostring(item.staticData.NameZh), targetId, tostring(count), value and tostring(value), targetItemguids and tostring(#targetItemguids)))
  ServiceItemProxy.super.CallItemUse(self, item.id, {targetId}, count, value, targetItemguids)
end
function ServiceItemProxy:CallQueryEquipData(guid, data)
  printOrange(string.format("CallQueryEquipData guid:%s", guid))
  if data == nil then
    data = {}
  end
  ServiceItemProxy.super.CallQueryEquipData(self, guid, data)
end
function ServiceItemProxy:CallEquipDecompose(key)
  helplog("Call-->EquipDecompose", key)
  ServiceItemProxy.super.CallEquipDecompose(self, key)
end
function ServiceItemProxy:RecvEquipDecompose(data)
  helplog("Recv-->EquipDecompose!", data.result)
  self:Notify(ServiceEvent.ItemEquipDecompose, data)
  if not data.items then
    return
  end
  local list = self:_ParseItems(data.items)
  local modelShowList = {}
  local itemShowList = {}
  local coinShowList = {}
  for i = 1, #list do
    local single = list[i]
    if single.staticData.Share == 1 then
      table.insert(modelShowList, single)
    elseif BagProxy.CheckIsCoinTypeItem(single.staticData.Type) then
      table.insert(coinShowList, single)
    elseif BagProxy.CheckIs3DTypeItem(single.staticData.Type) or BagProxy.CheckIsCardTypeItem(single.staticData.Type) then
      table.insert(modelShowList, single)
    else
      table.insert(itemShowList, single)
    end
  end
  if #itemShowList > 0 or #coinShowList > 0 then
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
      viewname = "PopUp10View"
    })
    self:HandleShowItems(itemShowList, PopUp10View.ItemCoinShowType.Decompose, data.result)
    self:HandleShowCoins(coinShowList, PopUp10View.ItemCoinShowType.Decompose, data.result)
  end
end
function ServiceItemProxy:RecvQueryEquipData(data)
  ResolveEquipProxy.Instance:UpdateQueryEquipData(data)
  self:Notify(ServiceEvent.ItemQueryEquipData, data)
end
function ServiceItemProxy:CallBrowsePackage(type)
  ServiceItemProxy.super.CallBrowsePackage(self, type)
  BagProxy.Instance:SetIsNewFlag(type, false)
end
function ServiceItemProxy:RecvItemShow64(data)
  self:RecvItemShow({
    items = {
      {
        id = data.id,
        count = data.count
      }
    }
  })
end
function ServiceItemProxy:RecvItemShow(data)
  helplog("Recv-->ItemShow")
  local list = {}
  local split_unit = GameConfig.MoneyLimit and GameConfig.MoneyLimit.Limit or 1000000
  for i = 1, #data.items do
    local single = data.items[i]
    local itemData
    if single.base ~= nil and single.base.guid ~= nil and single.base.id ~= nil then
      helplog("Recv-->ItemShow", single.base.id)
      itemData = ItemData.new(single.base.guid, single.base.id)
      itemData:ParseFromServerData(single)
      itemData.num = single.base.count
    else
      helplog("Recv-->ItemShow", single.id)
      itemData = ItemData.new(single.guid, single.id)
      itemData.num = single.count
    end
    if itemData ~= nil and itemData.staticData then
      if single.source == ProtoCommon_pb.ESOURCE_CHAT then
        itemData.source = single.base.source
      end
      table.insert(list, itemData)
    end
  end
  local modelShowList = {}
  local itemShowList = {}
  local coinShowList = {}
  local foodShowList = {}
  for i = 1, #list do
    local single = list[i]
    if single.staticData.Share == 1 then
      table.insert(modelShowList, single)
    elseif BagProxy.CheckIsCoinTypeItem(single.staticData.Type) then
      table.insert(coinShowList, single)
    elseif BagProxy.CheckIs3DTypeItem(single.staticData.Type) or BagProxy.CheckIsCardTypeItem(single.staticData.Type) then
      table.insert(modelShowList, single)
    elseif BagProxy.CheckIsFoodTypeItem(single.staticData.Type) then
      table.insert(foodShowList, single)
    else
      table.insert(itemShowList, single)
    end
  end
  local count = (#coinShowList % 2 ~= 0 or not (#coinShowList / 2)) and math.floor(#coinShowList / 2) + 1
  local hasShow = false
  for i = 1, count do
    local tmpList = {}
    table.insert(tmpList, coinShowList[2 * i - 1])
    if 2 * i <= #coinShowList then
      table.insert(tmpList, coinShowList[2 * i])
    end
    if not hasShow then
      hasShow = true
      GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
        viewname = "PopUp10View"
      })
    end
    GameFacade.Instance:sendNotification(SystemMsgEvent.MenuCoinPop, tmpList)
  end
  if #itemShowList > 0 then
    if not hasShow then
      hasShow = true
      GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
        viewname = "PopUp10View"
      })
    end
    GameFacade.Instance:sendNotification(SystemMsgEvent.MenuItemPop, itemShowList)
  end
  if #modelShowList > 0 then
    FloatAwardView.addItemDatasToShow(modelShowList)
    FloatAwardView.ForceNewShare()
  end
  if #foodShowList > 0 then
    FoodProxy.Instance.foodGetCount = #foodShowList
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.FoodGetPopUp,
      viewdata = {items = foodShowList}
    })
  end
end
function ServiceItemProxy:_ParseItems(serverItemInfos)
  local list = {}
  for i = 1, #serverItemInfos do
    local single = serverItemInfos[i]
    local itemData = ItemData.new(single.guid, single.id)
    if itemData.staticData then
      itemData.num = single.count
      table.insert(list, itemData)
    end
  end
  return list
end
function ServiceItemProxy:HandleShowItems(itemShowList, showType, params)
  if #itemShowList > 0 then
    itemShowList.showType = showType
    itemShowList.params = params
    GameFacade.Instance:sendNotification(SystemMsgEvent.MenuItemPop, itemShowList)
  end
end
function ServiceItemProxy:HandleShowCoins(coinShowList, showType, params)
  local count = #coinShowList % 2 == 0 and #coinShowList / 2 or math.floor(#coinShowList / 2) + 1
  for i = 1, count do
    local tmpList = {}
    table.insert(tmpList, coinShowList[2 * i - 1])
    if 2 * i <= #coinShowList then
      table.insert(tmpList, coinShowList[2 * i])
    end
    tmpList.showType = showType
    tmpList.params = params
    GameFacade.Instance:sendNotification(SystemMsgEvent.MenuCoinPop, tmpList)
  end
end
function ServiceItemProxy:CallSellItem(npcid)
  local items = {}
  for k, v in pairs(ShopSaleProxy.Instance.waitSaleItemsDic) do
    local msg = NetConfig.PBC and {} or SceneItem_pb.SItem()
    msg.guid = k
    msg.count = v
    table.insert(items, msg)
  end
  ServiceItemProxy.super.CallSellItem(self, npcid, items)
end
function ServiceItemProxy:CallEquipCard(oper, cardguid, equipguid, pos)
  helplog(string.format("CallEquipCard-->oper:%d cardguid:%s equipguid:%s pos:%s", oper, cardguid, equipguid, pos))
  ServiceItemProxy.super.CallEquipCard(self, oper, cardguid, equipguid, pos)
end
function ServiceItemProxy:CallPreProduce(npcid, composeid)
  printGreen("Call-->PreProduce", npcid, composeid)
  ServiceItemProxy.super.CallPreProduce(self, npcid, composeid)
end
function ServiceItemProxy:CallReqQuotaLogCmd(page_index, log)
  printGreen("Call-->CallReqQuotaLogCmd", page_index)
  ServiceItemProxy.super.CallReqQuotaLogCmd(self, page_index, log)
end
function ServiceItemProxy:CallReqQuotaDetailCmd(page_index, detail)
  printGreen("Call-->CallReqQuotaDetailCmd", page_index)
  ServiceItemProxy.super.CallReqQuotaDetailCmd(self, page_index, detail)
end
function ServiceItemProxy:RecvReqQuotaLogCmd(data)
  QuotaCardProxy.Instance:UpdateLog(data.log)
  self:Notify(ServiceEvent.ItemReqQuotaLogCmd, data)
end
function ServiceItemProxy:RecvReqQuotaDetailCmd(data)
  QuotaCardProxy.Instance:UpdateDetail(data.detail)
  self:Notify(ServiceEvent.ItemReqQuotaDetailCmd, data)
end
function ServiceItemProxy:RecvPreProduce(data)
  printGreen("Recv-->PreProduce")
  self:Notify(ServiceEvent.ItemPreProduce, data)
end
function ServiceItemProxy:RecvProduce(data)
  printGreen("Recv-->Produce")
  self:Notify(ServiceEvent.ItemProduce, data)
end
function ServiceItemProxy:RecvProduceDone(data)
  printGreen("Recv-->ProduceDone")
  self:Notify(ServiceEvent.ItemProduceDone, data)
end
function ServiceItemProxy:RecvEnchantEquip(data)
  self:Notify(ServiceEvent.ItemEnchantEquip, data)
end
function ServiceItemProxy:RecvEquipExchangeItemCmd(data)
  if data.type == SceneItem_pb.EEXCHANGETYPE_LEVELUP then
    local npcguid = FunctionDialogEvent.Me().npcguid
    if npcguid then
      local target = SceneCreatureProxy.FindCreature(npcguid)
      if target then
        target:PlayEffect(nil, EffectMap.Maps.EquipUpgrade_Success, RoleDefines_EP.Top)
      end
    end
  end
  self:Notify(ServiceEvent.ItemEquipExchangeItemCmd, data)
end
function ServiceItemProxy:RecvPackSlotNtfItemCmd(data)
  BagProxy.Instance:ServerSetBagUpLimit(data.type, data.maxslot)
  self:Notify(ServiceEvent.ItemPackSlotNtfItemCmd, data)
end
function ServiceItemProxy:RecvUseCountItemCmd(data)
  EventManager.Me():DispatchEvent(ServiceEvent.ItemUseCountItemCmd, data)
end
function ServiceItemProxy:RecvGetCountItemCmd(data)
  helplog("Recv-->GetCountItemCmd", data.itemid, data.count)
  FunctionPet.Me():SetRewardItemCount(data.itemid, data.count, data.sources)
  HappyShopProxy.Instance:SetLimitCount(data.itemid, data.count)
  EventManager.Me():DispatchEvent(ServiceEvent.ItemGetCountItemCmd, data)
end
function ServiceItemProxy:RecvEquipUpgradeItemCmd(data)
  self:Notify(ServiceEvent.ItemEquipUpgradeItemCmd, data)
end
function ServiceItemProxy:CallExchangeCardItemCmd(type, npcid, material, charid, cardid, anim)
  local now = UnityUnscaledTime
  if self._callExchangeCardItem == nil or now - self._callExchangeCardItem >= 2 then
    self._callExchangeCardItem = now
    helplog("CallExchangeCardItemCmd")
    ServiceItemProxy.super.CallExchangeCardItemCmd(self, type, npcid, material, charid, cardid, anim)
  end
end
function ServiceItemProxy:RecvExchangeCardItemCmd(data)
  helplog("RecvExchangeCardItemCmd")
  self:Notify(ServiceEvent.ItemExchangeCardItemCmd, data)
  CardMakeProxy.Instance:RecvExchangeCardItemCmd(data)
end
function ServiceItemProxy:RecvItemDataShow(data)
  helplog("Recv-->ItemDataShow", #data.items)
  local Function_CheckIsFoodTypeItem = BagProxy.CheckIsFoodTypeItem
  local foodShowList = {}
  local server_itemes = data.items
  for i = 1, #server_itemes do
    local tempItem = ItemData.new()
    tempItem:ParseFromServerData(server_itemes[i])
    local type = tempItem.staticData.Type
    if Function_CheckIsFoodTypeItem(type) then
      table.insert(foodShowList, tempItem)
    end
  end
  if #foodShowList > 0 then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.FoodGetPopUp,
      viewdata = {items = foodShowList}
    })
  end
  self:Notify(ServiceEvent.ItemItemDataShow, data)
end
function ServiceItemProxy:RecvQueryLotteryInfo(data)
  LotteryProxy.Instance:RecvQueryLotteryInfo(data)
  self:Notify(ServiceEvent.ItemQueryLotteryInfo, data)
end
function ServiceItemProxy:CallLotteryCmd(year, month, npcid, skip_anim, price, ticket, type, count, items, charid, guid, today_cnt, today_extra_cnt, today_ten_cnt, free)
  local now = UnityUnscaledTime
  if self._callLottery ~= nil and self._receiveLottery == nil and now - self._callLottery < 5 then
    LogUtility.Warning("?????????????????? 5 ????????????????????????????????????????????????????????????????????????????????????")
    return
  end
  if self._callLottery == nil or now - self._callLottery >= 0.5 then
    self._callLottery = now
    helplog("CallLotteryCmd")
    LotteryProxy.Instance.lotteryAction = true
    ServiceItemProxy.super.CallLotteryCmd(self, year, month, npcid, skip_anim, price, ticket, type, count, items, charid, guid, today_cnt, today_extra_cnt, today_ten_cnt, free)
    self._receiveLottery = nil
  else
    LogUtility.Warning("?????????????????? 0.5 ?????????????????????????????????")
  end
end
function ServiceItemProxy:RecvLotterGivBuyCountCmd(data)
  LotteryProxy.Instance:SetLotteryBuyCnt(data.got_count, data.max_count)
end
function ServiceItemProxy:RecvLotteryCmd(data)
  if LotteryProxy.IsNewLottery(data.type) and data.charid ~= Game.Myself.data.id then
    return
  end
  helplog("RecvLotteryCmd", os.date("%H:%M:%S", ServerTime.CurServerTime() / 1000))
  self._receiveLottery = UnityUnscaledTime
  LotteryProxy.Instance:RecvLotteryCmd(data)
  self:Notify(ServiceEvent.ItemLotteryCmd, data)
end
function ServiceItemProxy:RecvNtfHighRefineDataCmd(data)
  helplog("Recv-->NtfHighRefineDataCmd")
  BlackSmithProxy.Instance:SetPlayerHRefineLevels(data.datas)
  self:Notify(ServiceEvent.ItemNtfHighRefineDataCmd, data)
end
function ServiceItemProxy:RecvUpdateHighRefineDataCmd(data)
  BlackSmithProxy.Instance:SetPlayerHRefineLevel(data.data)
  self:Notify(ServiceEvent.ItemUpdateHighRefineDataCmd, data)
end
function ServiceItemProxy:CallRestoreEquipItemCmd(equipid, strengthlv, cardids, enchant, upgrade, strengthlv2)
  local logStr = ""
  local cardStr = ""
  if cardids ~= nil then
    for i = 1, #cardids do
      cardStr = cardStr .. cardids[i] .. " | "
    end
  end
  logStr = "Call-->RestoreEquipItemCmd:"
  logStr = logStr .. string.format("equipid:%s || strengthlv:%s || cardids:%s || enchant:%s || upgrade:%s || strengthlv2:%s", equipid, strengthlv, cardStr, enchant, upgrade, strengthlv2)
  helplog(logStr)
  ServiceItemProxy.super.CallRestoreEquipItemCmd(self, equipid, strengthlv, cardids, enchant, upgrade, strengthlv2)
end
function ServiceItemProxy:RecvEquipPosDataUpdate(data)
  MyselfProxy.Instance:Server_SetEquipPos_StateTime(data.datas)
  self:Notify(ServiceEvent.ItemEquipPosDataUpdate, data)
end
function ServiceItemProxy:RecvQueryLotteryHeadItemCmd(data)
  LotteryProxy.Instance:HandleLotteryHeadItem(data.ids)
  self:Notify(ServiceEvent.ItemQueryLotteryHeadItemCmd, data)
end
function ServiceItemAutoProxy:RecvQueryDebtItemCmd(data)
  MyselfProxy.Instance:SetDebts(data)
  self:Notify(ServiceEvent.ItemQueryDebtItemCmd, data)
end
function ServiceItemProxy:RecvUseCodItemCmd(data)
  ItemUtil.HandleUseCodeCmd(data)
  self:Notify(ServiceEvent.ItemUseCodItemCmd, data)
  EventManager.Me():PassEvent(ServiceEvent.ItemUseCodItemCmd, data)
end
function ServiceItemProxy:RecvLotteryActivityNtfCmd(data)
  redlog("RecvLotteryActivityNtf")
  TableUtil.Print(data)
  LotteryProxy.Instance:RecvLotteryActivityNtf(data.infos)
  LotteryProxy.Instance:RecvLotteryBannerInfo(data.infos)
  self:Notify(ServiceEvent.ItemLotteryActivityNtfCmd, data)
end
function ServiceItemProxy:RecvQueryLotteryExtraBonusItemCmd(data)
  LotteryProxy.Instance:RecvQueryLotteryExtraBonusItemCmd(data)
  ServiceItemProxy.super.RecvQueryLotteryExtraBonusItemCmd(self, data)
end
function ServiceItemProxy:RecvQueryLotteryExtraBonusCfgCmd(data)
  LotteryProxy.Instance:RecvQueryLotteryExtraBonusCfgCmd(data)
  ServiceItemProxy.super.RecvQueryLotteryExtraBonusCfgCmd(self, data)
end
function ServiceItemProxy:RecvQueryRideLotteryInfo(data)
  MountLotteryProxy.Instance:RecvQueryRideLotteryInfo(data)
end
function ServiceItemProxy:CallLotteryDollQueryItemCmd(total_infos, my_infos)
  local now = UnityUnscaledTime
  if self.lastQueryDollInfoTime then
    local dTime = now - self.lastQueryDollInfoTime
    if dTime < 5 then
      redlog("[doll] ???????????????????????????5??????????????????????????????")
      return
    end
  end
  self.lastQueryLotteryDollTime = now
  ServiceItemProxy.super.CallLotteryDollQueryItemCmd(self, total_infos, my_infos)
end
function ServiceItemProxy:RecvLotteryDollQueryItemCmd(data)
  if data then
    LotteryDollProxy.Instance:UpdateLotteryDollInfo(data.total_infos, data.my_infos)
  end
  ServiceItemProxy.super.RecvLotteryDollQueryItemCmd(self, data)
end
local DefaultLotteryDollPayInfo = {
  item = {}
}
function ServiceItemProxy:CallLotteryDollPayItemCmd(info)
  local now = UnityUnscaledTime
  if self.lastBuyDollTime then
    local dTime = now - self.lastBuyDollTime
    if self.waitForBuyDollResult and dTime < 5 then
      redlog("[doll] ???????????????????????????????????????5??????????????????????????????")
      return
    elseif dTime < 0.5 then
      redlog("[doll] ????????????????????????0.5???????????????")
      return
    end
  end
  self.lastBuyDollTime = now
  self.waitForBuyDollResult = true
  ServiceItemProxy.super.CallLotteryDollPayItemCmd(self, info or DefaultLotteryDollPayInfo)
end
function ServiceItemProxy:CallArtifactFlagmentAdd(guid, flagment_guid, count, id)
  local msg = NetConfig.PBC and {} or SceneItem_pb.SItem()
  msg.guid = flagment_guid
  msg.count = count
  ServiceItemProxy.super.CallArtifactFlagmentAdd(self, guid, msg, id)
end
function ServiceItemProxy:RecvLotteryDollPayItemCmd(data)
  self.waitForBuyDollResult = nil
  if data then
    LotteryDollProxy.Instance:UpdateOwnedLotteryDollInfo(data.info)
  end
  ServiceItemProxy.super.RecvLotteryDollPayItemCmd(self, data)
end
function ServiceItemProxy:IsWaitForLotteryDollResult()
  local now = UnityUnscaledTime
  return self.waitForBuyDollResult and self.lastBuyDollTime and now - self.lastBuyDollTime < 20
end
function ServiceItemProxy:RecvPersonalArtifactAppraisalItemCmd(data)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.PersonalArtifactResultView
  })
  ServiceItemProxy.super.RecvPersonalArtifactAppraisalItemCmd(self, data)
end
function ServiceItemProxy:RecvEquipPosCDNtfItemCmd(data)
  MyselfProxy.Instance:SyncEquipPosOnCd(data.poscd)
  ServiceItemProxy.super.RecvEquipPosCDNtfItemCmd(self, data)
end
function ServiceItemProxy:RecvMixLotteryArchiveCmd(data)
  LotteryProxy.Instance:HandleRecvMixLotteryArchiveCmd(data)
  self:Notify(ServiceEvent.ItemMixLotteryArchiveCmd, data)
end
function ServiceItemProxy:RecvQueryPackMailItemCmd(data)
  PostProxy.Instance:AddUpdatePostDatas(data.mails, true)
  self:Notify(ServiceEvent.ItemQueryPackMailItemCmd, data)
end
function ServiceItemProxy:RecvPackMailUpdateItemCmd(data)
  PostProxy.Instance:HandlePostUpdate(data.mails, data.dels, true)
end
function ServiceItemProxy:RecvMagicSuitNtf(data)
  helplog("RecvMagicSuitNtf")
  if not data or not data.suits then
    return
  end
  TableUtil.Print(data)
  EquipBagPreviewProxy.Instance:HandleSuitNtf(data.suits)
  self:Notify(ServiceEvent.ItemMagicSuitNtf, data)
end
function ServiceItemProxy:RecvFavoriteQueryItemCmd(data)
  MidSummerActProxy.Instance:RecvDesire(data.activityid, data.data)
  ServiceItemProxy.super.RecvFavoriteQueryItemCmd(self, data)
end
function ServiceItemProxy:RecvFavoriteGiveItemCmd(data)
  MidSummerActProxy.Instance:RecvDesire(data.activityid, data.data)
  ServiceItemProxy.super.RecvFavoriteGiveItemCmd(self, data)
end
function ServiceItemProxy:RecvFavoriteRewardItemCmd(data)
  MidSummerActProxy.Instance:RecvDesire(data.activityid, data.data)
  ServiceItemProxy.super.RecvFavoriteRewardItemCmd(self, data)
end
function ServiceItemProxy:RecvFavoriteInteractItemCmd(data)
  MidSummerActProxy.Instance:RecvDesire(data.activityid, data.data)
  ServiceItemProxy.super.RecvFavoriteInteractItemCmd(self, data)
end
function ServiceItemProxy:RecvFavoriteDesireConditionItemCmd(data)
  MidSummerActProxy.Instance:RecvDesire(data.activityid, data.data)
  ServiceItemProxy.super.RecvFavoriteDesireConditionItemCmd(self, data)
end
function ServiceItemProxy:RecvColoringQueryItemCmd(data)
  ColorFillingProxy.Instance:SetColorFillingData(data)
  ServiceItemProxy.super.RecvColoringQueryItemCmd(self, data)
end
function ServiceItemProxy:RecvRandSelectRewardItemCmd(data)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.RewardSelectView,
    viewdata = data
  })
  self:Notify(ServiceEvent.ItemRandSelectRewardItemCmd, data)
end
function ServiceItemProxy:RecvPosStrengthSyncItemCmd(data)
  StrengthProxy.Instance:HandleSyncPosStrength(data.strength_data)
  self:Notify(ServiceEvent.ItemPosStrengthSyncItemCmd, data)
end
function ServiceItemProxy:RecvPosStrengthItemCmd(data)
  StrengthProxy.Instance:HandleUpdatePosStrength(data)
  self:Notify(ServiceEvent.ItemPosStrengthItemCmd, data)
end
function ServiceItemProxy:RecvEquipRecoveryQueryItemCmd(data)
  BlackSmithProxy.Instance:UpdateEquipRecovery(data.datas)
  ServiceItemProxy.super.RecvEquipRecoveryQueryItemCmd(self, data)
end
function ServiceItemProxy:RecvPotionStoreNtf(data)
  redlog("ServiceItemProxy:RecvPotionStoreNtf")
  AutoHealingProxy.Instance:UpdatePotionSetting(data)
  FunctionAutoHealing.Me():CheckAutoHealing()
  self:Notify(ServiceEvent.ItemPotionStoreNtf, data)
end
function ServiceItemProxy:RecvEnchantHighestBuffNotify(data)
  self:Notify(ServiceEvent.ItemEnchantHighestBuffNotify, data)
end
function ServiceItemProxy:RecvLotteryDataSyncItemCmd(data)
  redlog("RecvLotteryDataSyncItemCmd")
  LotteryProxy.Instance:RecvLotteryDataSyncItemCmd(data)
  self:Notify(ServiceEvent.ItemLotteryDataSyncItemCmd, data)
end
function ServiceItemProxy:RecvLotteryDailyRewardSyncItemCmd(data)
  LotteryProxy.Instance:RecvLotteryDailyRewardSyncItem(data)
  self:Notify(ServiceEvent.ItemLotteryDailyRewardSyncItemCmd, data)
end
function ServiceItemProxy:RecvQueryAfricanPoringItemCmd(data)
  AfricanPoringProxy.Instance:RecvQueryAfricanPoringItemCmd(data)
  self:Notify(ServiceEvent.ItemQueryAfricanPoringItemCmd, data)
end
function ServiceItemProxy:RecvAfricanPoringUpdateItemCmd(data)
  AfricanPoringProxy.Instance:RecvAfricanPoringUpdateItemCmd(data)
  self:Notify(ServiceEvent.ItemAfricanPoringUpdateItemCmd, data)
end
function ServiceItemProxy:RecvAfricanPoringLotteryItemCmd(data)
  AfricanPoringProxy.Instance:RecvBidResult(data)
  self:Notify(ServiceEvent.ItemAfricanPoringLotteryItemCmd, data)
end
