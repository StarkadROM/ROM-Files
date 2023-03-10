autoImport("PaySignInfoData")
autoImport("PaySignGlobalActData")
PaySignProxy = class("PaySignProxy", pm.Proxy)
PaySignProxy.Instance = nil
PaySignProxy.NAME = "PaySignProxy"
PaySignProxy.RECEIVE_REWARD_STATUS = {
  CANRECEIVE = 1,
  WAIT = 2,
  FINISHED = 3
}
local CEIL = math.ceil
local _ArrayFindIndex = TableUtility.ArrayFindIndex
function PaySignProxy:ctor(proxyName, data)
  self.proxyName = proxyName or PaySignProxy.NAME
  if PaySignProxy.Instance == nil then
    PaySignProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:InitData()
end
function PaySignProxy:SetGlobalAct(data)
  local gd = PaySignGlobalActData.new(data)
  local infoData = self.infoMap[gd.id]
  if infoData and infoData.isNovice then
    gd:SetNoviceMode(infoData.startTime, infoData.buyTime)
  end
  self.globalActMap[data.id] = gd
end
function PaySignProxy:GetActTime(id)
  local gAct = self.globalActMap[id]
  if gAct then
    return ServantCalendarProxy.GetTimeDate(gAct.starttime, gAct.endtime, ZhString.PaySignRewardView_ReceiveTime)
  end
end
function PaySignProxy:GetLotteryTime(id)
  local gAct = self.globalActMap[id]
  if gAct then
    if gAct.configData:IsNoviceMode() then
      local day, hour, min, sec = ClientTimeUtil.GetFormatRefreshTimeStr(gAct.noviceBuyEndTime)
      if day and day > 0 then
        return string.format(ZhString.PaySignEntryView_PurchaseTime_NoviceMode, day)
      elseif hour and hour > 0 then
        return string.format(ZhString.PaySignEntryView_PurchaseTime_NoviceModeHour, hour)
      elseif min and min > 0 then
        return string.format(ZhString.PaySignEntryView_PurchaseTime_NoviceModeMin, min)
      elseif sec and sec > 0 then
        return string.format(ZhString.PaySignEntryView_PurchaseTime_NoviceModeMin, 1)
      end
    else
      local sm, sd, em, ed = os.date("%m", gAct.starttime), os.date("%d", gAct.starttime), os.date("%m", gAct.lotteryTime), os.date("%d", gAct.lotteryTime)
      return string.format(ZhString.PaySignEntryView_PurchaseTime, sm, sd, em, ed)
    end
  end
end
function PaySignProxy:IsLotteryTimeValid(id)
  local gAct = self.globalActMap[id]
  if gAct then
    return gAct:IsLotteryTimeValid()
  end
end
function PaySignProxy:IsActTimeValid(id)
  local gAct = self.globalActMap[id]
  if gAct then
    return gAct:IsActTimeValid()
  end
end
function PaySignProxy:PreprocessPaySign()
  if nil ~= next(self.config_paySign) then
    return
  end
  self._ntfInited = true
  local curServer = FunctionLogin.Me():getCurServerData()
  local serverID = curServer and curServer.linegroup or 1
  local itemdata
  for activityID, tableList in pairs(Game.Config_PaySign) do
    local act_itemdata_list = {}
    for i = 1, #tableList do
      if not next(tableList[i].ServerID) or _ArrayFindIndex(tableList[i].ServerID, serverID) > 0 then
        act_itemdata_list = self.config_paySign[activityID]
        if not act_itemdata_list then
          act_itemdata_list = {}
          self.config_paySign[activityID] = act_itemdata_list
        end
        local itemcfg = tableList[i].FemaleItemID and tableList[i].FemaleItemID ~= _EmptyTable and ProtoCommon_pb.EGENDER_FEMALE == Game.Myself.data.userdata:Get(UDEnum.SEX) and tableList[i].FemaleItemID or tableList[i].ItemID
        itemdata = ItemData.new("reward", itemcfg.id)
        itemdata:SetItemNum(itemcfg.num)
        itemdata.index = tableList[i].Day
        act_itemdata_list[#act_itemdata_list + 1] = itemdata
        self.config_paySign[activityID] = act_itemdata_list
      end
    end
  end
  for activityID, act_itemdata_list in pairs(self.config_paySign) do
    table.sort(act_itemdata_list, function(l, r)
      return l.index < r.index
    end)
  end
end
function PaySignProxy:GetConfig_PaySign(id)
  return self.config_paySign[id]
end
function PaySignProxy:RecvPaySignNtfUser(infos)
  if nil == next(self.config_paySign) then
    self:PreprocessPaySign()
  end
  for i = 1, #infos do
    self:UpdatePayInfo(infos[i].activityid, infos[i])
  end
end
function PaySignProxy:UpdatePayInfo(id, server_info)
  local data = PaySignInfoData.new(server_info)
  self.infoMap[id] = data
  if data.isNovice and self.globalActMap[id] then
    self.globalActMap[id]:SetNoviceMode(data.startTime, data.buyTime)
  end
end
function PaySignProxy:InitData()
  self.infoMap = {}
  self.globalActMap = {}
  self.lotteryTime = {}
  self.config_paySign = {}
  self.novicePurchased = false
  self._isUpdateFirst = true
  self.openedOnce = false
end
function PaySignProxy:IsNoviceModePurchased()
  return self.novicePurchased
end
function PaySignProxy:GetInfoMap(id)
  return self.infoMap[id]
end
function PaySignProxy:HasFreeReward(id)
  local data = self:GetInfoMap(id)
  return data and data:HasFreeReward()
end
function PaySignProxy:CheckPurchased(id)
  local info = self:GetInfoMap(id)
  if nil ~= info then
    return info:CheckPurchased()
  else
    return false
  end
end
function PaySignProxy:ActRealOpen(id)
  local purchased = self:CheckPurchased(id)
  if purchased then
    local info = self:GetInfoMap(id)
    return self:IsActTimeValid(id) and info.status ~= PaySignProxy.RECEIVE_REWARD_STATUS.FINISHED
  else
    return self:IsLotteryTimeValid(id)
  end
end
function PaySignProxy:GetCanReceiveActID()
  local cfg = GameConfig.PaySign
  for actid, tab in pairs(cfg) do
    if self:IsActTimeValid(actid) and self.infoMap[actid] and self.infoMap[actid].status == PaySignProxy.RECEIVE_REWARD_STATUS.CANRECEIVE then
      return actid
    end
  end
end
function PaySignProxy:CanLoginShow()
  if self.openedOnce then
    return
  end
  if not self._ntfInited then
    return
  end
  return self:GetCanReceiveActID()
end
function PaySignProxy:TryOpenRewardView()
  local actId = self:GetCanReceiveActID()
  if nil ~= actId then
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.EnterPaySignRewardView,
      viewdata = {id = actId}
    })
  end
end
function PaySignProxy:Update()
  if not self._ntfInited then
    return
  end
  if not self._isUpdateFirst then
    return
  end
  local curServerTime = ServerTime.CurServerTime() / 1000
  local curDay = os.date("*t", curServerTime)
  local curDayFiveClockDate = os.time({
    year = curDay.year,
    month = curDay.month,
    day = curDay.day,
    hour = 5,
    min = 5
  })
  if curDayFiveClockDate == CEIL(curServerTime) then
    GameFacade.Instance:sendNotification(MainViewEvent.InFiveClock)
    self._isUpdateFirst = false
  end
end
function PaySignProxy:GetActStatus(id)
  local actData = self:GetInfoMap(id)
  return actData and actData.status
end
