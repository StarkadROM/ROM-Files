autoImport("NewRechargeCommonSubView")
autoImport("NewRechargeTShopData")
autoImport("NewRechargeRecommendTShopGoodsCell")
autoImport("NewRechargeNormalTShopGoodsCell")
autoImport("HappyShopBuyItemCell")
NewRechargeTShopSubView = class("NewRechargeTShopSubView", NewRechargeCommonSubView)
NewRechargeTShopSubView.manuallyInit = true
NewRechargeTShopSubView.Tab = GameConfig.NewRecharge.TabDef.Shop
NewRechargeTShopSubView.innerTab = {
  Recommend = 1,
  Normal1 = 2,
  Normal2 = 3
}
function NewRechargeTShopSubView:OnEnter()
  NewRechargeCommonSubView.OnEnter(self)
end
function NewRechargeTShopSubView:OnExit()
  NewRechargeTShopSubView.super.OnExit(self)
  self:Func_RemoveListenEvent()
  self.type1CellListCtrl:Destroy()
  self.type2CellListCtrl:Destroy()
end
function NewRechargeTShopSubView:OnShow()
  NewRechargeTShopSubView.super.OnShow()
  self.isShowing = true
end
function NewRechargeTShopSubView:OnHide()
  NewRechargeTShopSubView.super.OnHide()
  self.isShowing = true
end
function NewRechargeTShopSubView:SelectGood(note)
  if not note.data then
    return
  end
  local retCell
  local cells = self.type2CellListCtrl:GetCells()
  for i = 1, #cells do
    if cells[i].info and cells[i].info.itemID == note.data then
      retCell = cells[i]
    end
  end
  if retCell then
    retCell:Purchase_Shop()
  end
end
function NewRechargeTShopSubView:RequestQueryChargeCnt()
  ServiceUserEventProxy.Instance:CallQueryChargeCnt()
end
function NewRechargeTShopSubView:RequestQueryChargeVirgin()
  ServiceSessionSocialityProxy.Instance:CallQueryChargeVirginCmd()
end
function NewRechargeTShopSubView:Func_AddListenEvent()
  EventManager.Me():AddEventListener(ServiceEvent.UserEventQueryChargeCnt, self.OnReceiveQueryChargeCnt, self)
  EventManager.Me():AddEventListener(ServiceEvent.SessionShopBuyShopItem, self.OnReceiveBuyLuckyBag, self)
  EventManager.Me():AddEventListener(ServiceEvent.SessionShopQueryShopConfigCmd, self.OnReceiveQueryShopConfigCmd, self)
  EventManager.Me():AddEventListener(ServiceEvent.NUserUpdateShopGotItem, self.OnReceiveUpdateShopGotItem, self)
  EventManager.Me():AddEventListener(NewRechargeEvent.SelectGood, self.SelectGood, self)
end
function NewRechargeTShopSubView:Func_RemoveListenEvent()
  EventManager.Me():RemoveEventListener(ServiceEvent.UserEventQueryChargeCnt, self.OnReceiveQueryChargeCnt, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.SessionShopBuyShopItem, self.OnReceiveBuyLuckyBag, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.SessionShopQueryShopConfigCmd, self.OnReceiveQueryShopConfigCmd, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.NUserUpdateShopGotItem, self.OnReceiveUpdateShopGotItem, self)
  EventManager.Me():RemoveEventListener(NewRechargeEvent.SelectGood, self.SelectGood, self)
end
function NewRechargeTShopSubView:OnReceiveQueryChargeCnt(data)
  self:InitData()
  self:UpdateViewGoods()
  self:UpdateRedTips()
end
function NewRechargeTShopSubView:OnReceiveBuyLuckyBag(message)
  if self.Tab == GameConfig.NewRecharge.TabDef.Shop then
    if self.innerSelectTab == self.innerTab.Recommend then
      NewRechargeProxy.Instance:CallClientPayLog(107)
    elseif self.innerSelectTab == self.innerTab.Normal1 then
      NewRechargeProxy.Instance:CallClientPayLog(108)
    elseif self.innerSelectTab == self.innerTab.Normal2 then
      NewRechargeProxy.Instance:CallClientPayLog(109)
    end
  end
  self:InitData()
  self:UpdateViewGoods()
  self:UpdateRedTips()
end
function NewRechargeTShopSubView:OnReceiveQueryShopConfigCmd(message)
  self:InitData()
  self:UpdateViewGoods()
  self:UpdateRedTips()
end
function NewRechargeTShopSubView:OnReceiveUpdateShopGotItem(data)
  self:InitData()
  self:UpdateViewGoods()
  self:UpdateRedTips()
end
function NewRechargeTShopSubView:Init(manually)
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
function NewRechargeTShopSubView:InitView()
  local recommendItemList_r = NewRechargeProxy.Instance:TShop_GetShopItemList(self.innerTab.Recommend)
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
function NewRechargeTShopSubView:RefreshView(selectInnerTab)
  NewRechargeTShopSubView.super.RefreshView(self, selectInnerTab)
  self:InitData()
  self:LoadView()
  self:SelectInnerSelector()
end
function NewRechargeTShopSubView:InitData()
  self.itemList_r = NewRechargeProxy.Instance:TShop_GetShopItemList(self.innerSelectTab)
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
function NewRechargeTShopSubView:FindObjs()
  self.gameObject = self:FindGO("NewRechargeTShopSubView")
  NewRechargeTShopSubView.super.FindObjs(self)
  local goodsList = self:FindGO("GoodsList", self.gameObject)
  self.type1CellListContainer = self:FindComponent("Table1", UIGrid, goodsList)
  self.type2CellListContainer = self:FindComponent("Table2", UIGrid, goodsList)
  self.type1CellListCtrl = UIGridListCtrl.new(self.type1CellListContainer, NewRechargeRecommendTShopGoodsCell, "NewRechargeCommonGoodsCellType1")
  self.type1CellListCtrl:AddEventListener(NewRechargeEvent.GoodsCell_ShowTip, self.ShowGoodsItemTip, self)
  self.type1CellListCtrl:AddEventListener(NewRechargeEvent.GoodsCell_ShowShopItemPurchaseDetail, self.ShowShopItemPurchaseDetail, self)
  self.type1CellListCtrl:AddEventListener(NewRechargeEvent.RemoveTimeEnd, self.LoadView, self)
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
function NewRechargeTShopSubView:LoadView()
  self:UpdateViewGoods(true)
end
function NewRechargeTShopSubView:UpdateViewGoods(retPos)
  local isRecommendTab = self.innerSelectTab == self.innerTab.Recommend
  isRecommendTab = false
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
function NewRechargeTShopSubView:UpdateRedTips()
  local cells = self.innerSelectListCtrl:GetCells()
  for i = 1, #cells do
    self:UnRegisterSingleRedTipCheck(NewRechargeShopItemCtrl.DailyOneZenyRedTipID, cells[i].gameObject)
  end
  local redTipsArr = NewRechargeProxy.Instance:GetRedTipsPageByShopPage()
  for _, v in pairs(redTipsArr) do
    for i = 1, #cells do
      if cells[i].data.ID == v then
        self:RegisterRedTipCheck(NewRechargeShopItemCtrl.DailyOneZenyRedTipID, cells[i].gameObject, 9, {-55, -16})
      end
    end
  end
end
