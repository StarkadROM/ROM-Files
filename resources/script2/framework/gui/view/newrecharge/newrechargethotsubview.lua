autoImport("NewRechargeCommonSubView")
autoImport("NewRechargeTShopData")
autoImport("NewRechargeRecommendTShopGoodsCell")
autoImport("NewRechargeNormalTShopGoodsCell")
autoImport("HappyShopBuyItemCell")
NewRechargeTHotSubView = class("NewRechargeTHotSubView", NewRechargeCommonSubView)
NewRechargeTHotSubView.manuallyInit = true
NewRechargeTHotSubView.Tab = GameConfig.NewRecharge.TabDef.Hot
NewRechargeTHotSubView.innerTab = {
  Recommend = 1,
  Normal1 = 2,
  Normal2 = 3
}
function NewRechargeTHotSubView:OnExit()
  NewRechargeTHotSubView.super.OnExit(self)
  self:Func_RemoveListenEvent()
  self.type1CellListCtrl:Destroy()
  self.type2CellListCtrl:Destroy()
end
function NewRechargeTHotSubView:RequestQueryChargeCnt()
  ServiceUserEventProxy.Instance:CallQueryChargeCnt()
end
function NewRechargeTHotSubView:RequestQueryChargeVirgin()
  ServiceSessionSocialityProxy.Instance:CallQueryChargeVirginCmd()
end
function NewRechargeTHotSubView:Func_AddListenEvent()
  EventManager.Me():AddEventListener(ServiceEvent.UserEventQueryChargeCnt, self.OnReceiveQueryChargeCnt, self)
  EventManager.Me():AddEventListener(ServiceEvent.SessionShopBuyShopItem, self.OnReceiveBuyLuckyBag, self)
  EventManager.Me():AddEventListener(ServiceEvent.SessionShopQueryShopConfigCmd, self.OnReceiveQueryShopConfigCmd, self)
  EventManager.Me():AddEventListener(ServiceEvent.NUserUpdateShopGotItem, self.OnReceiveUpdateShopGotItem, self)
  EventManager.Me():AddEventListener(ServiceEvent.NUserUpdateShopGotItem, self.OnReceiveUpdateShopGotItem, self)
end
function NewRechargeTHotSubView:Func_RemoveListenEvent()
  EventManager.Me():RemoveEventListener(ServiceEvent.UserEventQueryChargeCnt, self.OnReceiveQueryChargeCnt, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.SessionShopBuyShopItem, self.OnReceiveBuyLuckyBag, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.SessionShopQueryShopConfigCmd, self.OnReceiveQueryShopConfigCmd, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.NUserUpdateShopGotItem, self.OnReceiveUpdateShopGotItem, self)
end
function NewRechargeTHotSubView:OnReceiveQueryChargeCnt(data)
  self:InitData()
  self:UpdateViewGoods(false)
  self:UpdateRedTips()
end
function NewRechargeTHotSubView:OnReceiveBuyLuckyBag(message)
  if self.Tab == GameConfig.NewRecharge.TabDef.Hot then
    if self.innerSelectTab == self.innerTab.Recommend then
      NewRechargeProxy.Instance:CallClientPayLog(104)
    elseif self.innerSelectTab == self.innerTab.Normal1 then
      NewRechargeProxy.Instance:CallClientPayLog(105)
    elseif self.innerSelectTab == self.innerTab.Normal2 then
      NewRechargeProxy.Instance:CallClientPayLog(106)
    end
  end
  self:InitData()
  self:UpdateViewGoods(false)
  self:UpdateRedTips()
end
function NewRechargeTHotSubView:OnReceiveQueryShopConfigCmd(message)
  self:InitData()
  self:UpdateViewGoods(false)
  self:UpdateRedTips()
end
function NewRechargeTHotSubView:OnReceiveUpdateShopGotItem(data)
  self:InitData()
  self:UpdateViewGoods(false)
  self:UpdateRedTips()
end
function NewRechargeTHotSubView:Init(manually)
  if self.inited then
    return
  end
  if self.manuallyInit and not manually then
    return
  end
  self:FindObjs()
  self:Func_AddListenEvent()
  self:InitView()
  self.inited = true
end
function NewRechargeTHotSubView:InitView()
  local recommendItemList_r = NewRechargeProxy.Instance:THot_GetHotItemList(self.innerTab.Recommend)
  local hasRecommendItem = recommendItemList_r and #recommendItemList_r > 0
  if hasRecommendItem then
    GameConfig.NewRecharge.Tabs[self.Tab].Inner[self.innerTab.Recommend].Invalid = nil
  else
    GameConfig.NewRecharge.Tabs[self.Tab].Inner[self.innerTab.Recommend].Invalid = true
  end
  self:LoadInnerSelector(GameConfig.NewRecharge.Tabs[self.Tab].Inner)
  self:UpdateRedTips()
  self:RefreshView(self.innerSelect_validIndex[1])
end
function NewRechargeTHotSubView:LoadInnerSelector(list)
  if not self.innerSelect_validIndex then
    self.innerSelect_validIndex = {}
  else
    TableUtility.ArrayClear(self.innerSelect_validIndex)
  end
  local item
  for i = 1, #list do
    item = list[i]
    local dataList = NewRechargeProxy.Instance:THot_GetHotItemList(item.ID)
    if item.Invalid ~= true and dataList ~= nil and #dataList > 0 then
      TableUtility.ArrayPushBack(self.innerSelect_validIndex, item.ID)
    end
  end
  self.innerSelectListCtrl:ResetDatas(list, nil, true)
  self.innerSelectLine.width = #self.innerSelect_validIndex * self:getSelectorLen()
end
function NewRechargeTHotSubView:RefreshView(selectInnerTab)
  NewRechargeTHotSubView.super.RefreshView(self, selectInnerTab)
  self:InitData()
  self:LoadView()
  self:SelectInnerSelector()
end
function NewRechargeTHotSubView:InitData()
  self.itemList_r = NewRechargeProxy.Instance:THot_GetHotItemList(self.innerSelectTab)
  self.shopItemDatas = NewRechargeProxy.Instance:GetShopConf()
  if self.arrShopItemData == nil then
    self.arrShopItemData = {}
  end
  TableUtility.ArrayClear(self.arrShopItemData)
  for k, v in pairs(self.shopItemDatas) do
    table.insert(self.arrShopItemData, v)
  end
  table.sort(self.arrShopItemData, function(x, y)
    return x.ShopOrder < y.ShopOrder
  end)
end
function NewRechargeTHotSubView:FindObjs()
  self.gameObject = self:FindGO("NewRechargeTHotSubView")
  NewRechargeTHotSubView.super.FindObjs(self)
  local goodsList = self:FindGO("GoodsList", self.gameObject)
  self.type1CellListContainer = self:FindComponent("Table1", UIGrid, goodsList)
  self.type1CellListCtrl = UIGridListCtrl.new(self.type1CellListContainer, NewRechargeRecommendTShopGoodsCell, "NewRechargeCommonGoodsCellType1")
  self.type1CellListCtrl:AddEventListener(NewRechargeEvent.GoodsCell_ShowTip, self.ShowGoodsItemTip, self)
  self.type1CellListCtrl:AddEventListener(NewRechargeEvent.GoodsCell_ShowShopItemPurchaseDetail, self.ShowShopItemPurchaseDetail, self)
  self.type1CellListCtrl:AddEventListener(NewRechargeEvent.RemoveTimeEnd, self.LoadView, self)
  self.type2CellListContainer = self:FindComponent("Table2", UIGrid, goodsList)
  self.type2CellListCtrl = UIGridListCtrl.new(self.type2CellListContainer, NewRechargeNormalTShopGoodsCell, "NewRechargeCommonGoodsCellType2")
  self.type2CellListCtrl:AddEventListener(NewRechargeEvent.GoodsCell_ShowTip, self.ShowGoodsItemTip, self)
  self.type2CellListCtrl:AddEventListener(NewRechargeEvent.GoodsCell_ShowShopItemPurchaseDetail, self.ShowShopItemPurchaseDetail, self)
  local cellTableScrollView = goodsList:GetComponent(UIScrollView)
  local cellTableScrollBar = cellTableScrollView.horizontalScrollBar
  local leftTriggerAction = function(invoker, switchIndex)
    local newIndex = (switchIndex + self.innerSelectTab - 1) % #self.innerSelect_validIndex + 1
    newIndex = self.innerSelect_validIndex[newIndex]
    self:RefreshView(newIndex)
  end
  self:ResetScrollUpdateParams(cellTableScrollView, cellTableScrollBar, leftTriggerAction, -1, leftTriggerAction, 1)
end
function NewRechargeTHotSubView:LoadView()
  self:UpdateViewGoods(true)
end
function NewRechargeTHotSubView:UpdateViewGoods(retPos)
  local isRecommendTab = self.innerSelectTab == self.innerTab.Recommend
  isRecommendTab = true
  self.type1CellListContainer.gameObject:SetActive(isRecommendTab)
  self.type2CellListContainer.gameObject:SetActive(not isRecommendTab)
  if isRecommendTab then
    self.type1CellListCtrl:ResetDatas(self.itemList_r)
    if retPos then
      self.type1CellListCtrl:ResetPosition()
    end
  else
    self.type2CellListCtrl:ResetDatas(self.itemList_r)
    if retPos then
      self.type2CellListCtrl:ResetPosition()
    end
  end
  self:ResetScrollBarTriggerSize()
end
function NewRechargeTHotSubView:UpdateRedTips()
  local cells = self.innerSelectListCtrl:GetCells()
  for i = 1, #cells do
    self:UnRegisterSingleRedTipCheck(NewRechargeShopItemCtrl.DailyOneZenyRedTipID, cells[i].gameObject)
  end
  local redTipsArr = NewRechargeProxy.Instance:GetRedTipsPageByHotPage()
  for _, v in pairs(redTipsArr) do
    for i = 1, #cells do
      if cells[i].data.ID == v then
        self:RegisterRedTipCheck(NewRechargeShopItemCtrl.DailyOneZenyRedTipID, cells[i].gameObject, 9, {-55, -16})
      end
    end
  end
end
