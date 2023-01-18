autoImport("UIListItemViewControllerZenyShopItem")
autoImport("UIModelZenyShop")
UISubViewControllerGachaCoin = class("UISubViewControllerGachaCoin", SubView)
local reusableArray = {}
function UISubViewControllerGachaCoin:Init()
end
function UISubViewControllerGachaCoin:OnExit()
  if self.gachaCoinsController ~= nil then
    for i = 1, #self.gachaCoinsController do
      self.gachaCoinsController[i]:OnExit()
    end
  end
  if self.luckyBagItemsController_InGachaCoinsList then
    for _, v in pairs(self.luckyBagItemsController_InGachaCoinsList) do
      local itemController = v
      itemController:OnExit()
    end
  end
  self:CancelListenServerResponse()
end
function UISubViewControllerGachaCoin:MyInit()
  self.gameObject = self:LoadPreferb("view/UISubViewGachaCoin", nil, true)
  self.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(-400, -70, 0)
  self:GetGameObjects()
  self:ListenServerResponse()
  self:OnReceiveQueryChargeCnt(nil)
  self.isInit = true
end
function UISubViewControllerGachaCoin:GetGameObjects()
  self.goGachaCoinsList = self:FindGO("GachaCoinsList", self.gameObject)
  self.goGachaCoinsRoot = self:FindGO("GachaCoinsRoot", self.goGachaCoinsList)
  self.goLuckyBagItemsRoot_InGachaCoinsList = self:FindGO("LuckyBagsRoot", self.goGachaCoinsList)
  self.uiGridOfLuckyBagItems_InGachaCoinsList = self.goLuckyBagItemsRoot_InGachaCoinsList:GetComponent(UIGrid)
end
function UISubViewControllerGachaCoin:GetModelSet()
  self.sLuckyBagShopConf = UIModelZenyShop.Ins():GetLuckyBagShopConf()
end
function UISubViewControllerGachaCoin:LoadView()
  self.uiGridOfGachaCoins = self.goGachaCoinsRoot:GetComponent(UIGrid)
  if self.listControllerOfGachaCoins == nil then
    self.listControllerOfGachaCoins = UIGridListCtrl.new(self.uiGridOfGachaCoins, UIListItemViewControllerZenyShopItem, "UIListItemZenyShopItem")
  end
  TableUtility.ArrayClear(reusableArray)
  for k, v in pairs(Table_Deposit) do
    if v.Type == 3 and v.Switch == 1 then
      table.insert(reusableArray, k)
    end
  end
  table.sort(reusableArray, function(x, y)
    if x ~= nil and y ~= nil then
      return x < y
    end
    return false
  end)
  self.listControllerOfGachaCoins:ResetDatas(reusableArray)
  self.gachaCoinsController = self.listControllerOfGachaCoins:GetCells()
  if self.luckyBagItemsController_InGachaCoinsList == nil then
    TableUtility.ArrayClear(reusableArray)
    if BranchMgr.IsChina() or BranchMgr.IsTW() then
      for k, v in pairs(self.sLuckyBagShopConf) do
        local shopItemData = v
        table.insert(reusableArray, {
          confType = UIModelZenyShop.luckyBagConfType.Shop,
          shopItemData = shopItemData
        })
      end
    end
    local canAdd = true
    for k, v in pairs(Table_Deposit) do
      canAdd = v.Type == 4 and v.ActivityDiscount ~= 1 and ShopProxy.Instance:IsThisItemCanBuyNow(v.id)
      if BattlePassProxy.Instance:CheckBattlePassUpgradeDepositForbidShow(v.id) then
        canAdd = false
      end
      if UIModelZenyShop.Ins().batchToOriginProduct and UIModelZenyShop.Ins().batchToOriginProduct[k] then
        canAdd = false
      end
      if canAdd then
        table.insert(reusableArray, {
          confType = UIModelZenyShop.luckyBagConfType.Deposit,
          productID = k,
          SortingOrder = v.SortingOrder,
          id = v.id
        })
      end
    end
    table.sort(reusableArray, function(x, y)
      if x.productID ~= nil and y.productID ~= nil then
        return x.productID < y.productID
      end
    end)
    table.sort(reusableArray, function(x, y)
      if x.SortingOrder and y.SortingOrder then
        return x.SortingOrder < y.SortingOrder
      else
        return false
      end
    end)
    for i = 1, #reusableArray do
      local cellViewModel = reusableArray[i]
      local uiListItemCtrlLuckyBag = UIListItemCtrlLuckyBag.new()
      local goView = uiListItemCtrlLuckyBag:CreateView(self.goLuckyBagItemsRoot_InGachaCoinsList)
      uiListItemCtrlLuckyBag.gameObject = goView
      uiListItemCtrlLuckyBag:Init()
      uiListItemCtrlLuckyBag:SetData(cellViewModel)
      if self.luckyBagItemsController_InGachaCoinsList == nil then
        self.luckyBagItemsController_InGachaCoinsList = {}
      end
      table.insert(self.luckyBagItemsController_InGachaCoinsList, uiListItemCtrlLuckyBag)
    end
    self.uiGridOfLuckyBagItems_InGachaCoinsList.repositionNow = true
    local gachaCoinsRootWidget = self.goGachaCoinsRoot:GetComponent(UIWidget)
    local luckyBagRootWidget = self.goLuckyBagItemsRoot_InGachaCoinsList:GetComponent(UIWidget)
    local luckyBagItemsWidth = #reusableArray * self.uiGridOfLuckyBagItems_InGachaCoinsList.cellWidth
    gachaCoinsRootWidget.leftAnchor.absolute = luckyBagRootWidget.leftAnchor.absolute + luckyBagItemsWidth
    gachaCoinsRootWidget.rightAnchor.absolute = luckyBagRootWidget.rightAnchor.absolute + luckyBagItemsWidth
  else
    for i = 1, #self.luckyBagItemsController_InGachaCoinsList do
      self.luckyBagItemsController_InGachaCoinsList[i]:GetModelSet()
      self.luckyBagItemsController_InGachaCoinsList[i]:LoadView()
    end
  end
end
function UISubViewControllerGachaCoin:ListenServerResponse()
  EventManager.Me():AddEventListener(ServiceEvent.UserEventQueryChargeCnt, self.OnReceiveQueryChargeCnt, self)
  EventManager.Me():AddEventListener(ServiceEvent.SessionShopBuyShopItem, self.OnReceiveBuyLuckyBag, self)
  EventManager.Me():AddEventListener(ServiceEvent.SessionShopQueryShopConfigCmd, self.OnReceiveQueryShopConfigCmd, self)
end
function UISubViewControllerGachaCoin:CancelListenServerResponse()
  EventManager.Me():RemoveEventListener(ServiceEvent.UserEventQueryChargeCnt, self.OnReceiveQueryChargeCnt, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.SessionShopBuyShopItem, self.OnReceiveBuyLuckyBag, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.SessionShopQueryShopConfigCmd, self.OnReceiveQueryShopConfigCmd, self)
  if self.gachaCoinsController ~= nil then
    for i = 1, #self.gachaCoinsController do
      local cell = self.gachaCoinsController[i]
      cell:OnExit()
    end
  end
end
function UISubViewControllerGachaCoin:RequestQueryChargeCnt()
  ServiceUserEventProxy.Instance:CallQueryChargeCnt()
end
function UISubViewControllerGachaCoin:RequestQueryChargeVirgin()
  ServiceSessionSocialityProxy.Instance:CallQueryChargeVirginCmd()
end
function UISubViewControllerGachaCoin:OnReceiveQueryChargeCnt(data)
  self:GetModelSet()
  self:LoadView()
  self:RequestQueryChargeVirgin()
end
function UISubViewControllerGachaCoin:OnReceiveBuyLuckyBag(message)
  self:GetModelSet()
  self:LoadView()
end
function UISubViewControllerGachaCoin:OnReceiveQueryShopConfigCmd(message)
  self:GetModelSet()
  self:LoadView()
end
