autoImport("AfricanPoringData")
autoImport("ItemData")
AfricanPoringProxy = class("AfricanPoringProxy", pm.Proxy)
AfricanPoringProxy.Instance = nil
AfricanPoringProxy.NAME = "AfricanPoringProxy"
AfricanPoringProxy.RedTipID = 10736
function AfricanPoringProxy:ctor(proxyName, data)
  self.proxyName = proxyName or AfricanPoringProxy.NAME
  if AfricanPoringProxy.Instance == nil then
    AfricanPoringProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end
function AfricanPoringProxy:Init(activityData)
  if GameConfig.SystemForbid.AfricanPoring then
    return
  end
  if not activityData then
    return
  end
  self.actData = AfricanPoringData.new(activityData)
  self.isAnimOn = not LocalSaveProxy.Instance:GetSkipAnimation(SKIPTYPE.AfricanPoring)
  if self.actData:IsActive() then
    self:CallQueryAfricanPoringItemCmd()
  end
  EventManager.Me():DispatchEvent(AfricanPoring.OnAcvitityStart)
end
function AfricanPoringProxy:Destroy()
  self.actData = nil
  EventManager.Me():DispatchEvent(AfricanPoring.OnAcvitityEnd)
end
function AfricanPoringProxy:GetActivityType()
  return GameConfig.AfricanPoring and GameConfig.AfricanPoring.ActivityType
end
function AfricanPoringProxy:IsActive()
  if self.actData then
    return self.actData:IsActive()
  end
  return false
end
function AfricanPoringProxy:GetActData()
  return self.actData
end
function AfricanPoringProxy:GetConfig()
  return self.actData and self.actData:GetConfig()
end
function AfricanPoringProxy:GetGroupId()
  return self.actData and self.actData:GetGroupId()
end
function AfricanPoringProxy:ShouldRemoveRedTip()
  if self.actData then
    return not self.actData:HasFreeBids()
  end
  return true
end
function AfricanPoringProxy:UpdateRedTip()
  if self:ShouldRemoveRedTip() then
    RedTipProxy.Instance:RemoveWholeTip(AfricanPoringProxy.RedTipID)
  else
    RedTipProxy.Instance:UpdateRedTip(AfricanPoringProxy.RedTipID)
  end
end
function AfricanPoringProxy:GetRewardItems()
  return self.actData and self.actData:GetRewardItems() or {}
end
function AfricanPoringProxy:GetRewardPoolDatas()
  return self.actData and self.actData:GetPoolDatas() or {}
end
function AfricanPoringProxy:GetShopItems()
  return self.actData and self.actData:GetShopItems() or {}
end
function AfricanPoringProxy:IsAnimOn()
  return self.isAnimOn
end
function AfricanPoringProxy:SetAnimOn(on)
  if on ~= self.isAnimOn then
    self.isAnimOn = on
    LocalSaveProxy.Instance:SetSkipAnimation(SKIPTYPE.AfricanPoring, not on)
  end
end
function AfricanPoringProxy:CallAfricanPoringLotteryItemCmd(action)
  local groupId = self:GetGroupId()
  if not groupId then
    return
  end
  if action == SceneItem_pb.EAFRICANPORING_RESET then
    local actData = self:GetActData()
    if actData then
      self.actData:OnReset()
    end
  end
  ServiceItemProxy.Instance:CallAfricanPoringLotteryItemCmd(groupId, action)
end
function AfricanPoringProxy:CallQueryAfricanPoringItemCmd()
  ServiceItemProxy.Instance:CallQueryAfricanPoringItemCmd()
end
function AfricanPoringProxy:RecvQueryAfricanPoringItemCmd(serverData)
  if self.actData then
    self.actData:SetRewardItems(serverData)
    self:UpdateRedTip()
  end
end
function AfricanPoringProxy:RecvAfricanPoringUpdateItemCmd(serverData)
  if self.actData then
    self.actData:UpdateRewardItems(serverData)
    self:UpdateRedTip()
  end
end
function AfricanPoringProxy:CallQueryShopConfigCmd()
  local config = self:GetConfig()
  if not config then
    return
  end
  ServiceSessionShopProxy.Instance:CallQueryShopConfigCmd(config.ShopType, config.ShopId)
end
function AfricanPoringProxy:RecvQueryShopConfigCmd(serverData)
  if not self.actData or not serverData then
    return
  end
  self.actData:SetShopItems(serverData)
  EventManager.Me():DispatchEvent(AfricanPoring.OnShopItemUpdated)
end
function AfricanPoringProxy:RecvUpdateShopGotItem(serverData)
  if self.actData then
    self.actData:SortShopItems()
  end
end
function AfricanPoringProxy:RecvBidResult(serverData)
  if self.actData then
    self.actData:RecvBidResult(serverData)
  end
end
function AfricanPoringProxy:ShowRewardItems()
  local actData = self:GetActData()
  if not actData then
    return
  end
  if actData.status ~= SceneItem_pb.EAFRICANPORINGSTATUS_INIT and actData.status ~= SceneItem_pb.EAFRICANPORINGSTATUS_FINISH then
    return
  end
  local showRewardItemData = actData.showRewardItemData
  if not showRewardItemData then
    return
  end
  if actData.duplicatedSafeBid then
    MsgManager.ShowMsgByID(43269)
    return
  end
  local args = ReusableTable.CreateTable()
  args.isHideAllBtn = true
  args.closeWhenClickOtherPlace = true
  local rewardData = showRewardItemData.rewardData
  args.audioEffect = rewardData and rewardData:IsSsr() and AudioMap.Maps.AfricanPoringRewardSsr or AudioMap.Maps.AfricanPoringRewardNormal
  FloatAwardView.addItemDatasToShow(showRewardItemData.items, args)
  ReusableTable.DestroyAndClearTable(args)
  actData:ClearShowRewardItemQueue()
end
