autoImport("NewRechargeTShopData")
autoImport("NewRechargeTCardData")
autoImport("NewRechargeTShopSubView")
autoImport("NewRechargeTCardSubView")
autoImport("NewRechargeTDepositSubView")
autoImport("NewRechargeTHotSubView")
autoImport("NewRechargeHeroSubView")
autoImport("NewRechargeSubSelectCell")
autoImport("FunctionNewRecharge")
autoImport("NewHappyShopBuyItemCell")
autoImport("NewRechargeGiftTipCell")
NewRechargeView = class("NewRechargeView", ContainerView)
NewRechargeView.ViewType = UIViewType.NormalLayer
NewRechargeView.instance = nil
local HeroShopTip = SceneTip_pb.EREDSYS_HEROSHOP
function NewRechargeView:Func_AddListenEvent()
  self:AddListenEvt(MyselfEvent.MyDataChange, self.OnReceiveEventMyDataChange)
  self:AddListenEvt(ServiceEvent.SessionShopQueryShopConfigCmd, self.UpdateRedTips)
  self:AddListenEvt(ServiceEvent.NUserUpdateShopGotItem, self.UpdateRedTips)
  self:AddListenEvt(ServiceEvent.UserEventQueryChargeCnt, self.OnReceiveQueryChargeCnt)
  self:AddListenEvt(ServiceEvent.QuestCompleteAvailableQueryQuestCmd, self.RecvQuestCompleteQuery)
  self:AddListenEvt(ServiceEvent.QuestCompleteAvailableQueryQuestCmd, self.RecvQuestCompleteQuery)
  self:AddListenEvt(ServiceEvent.SceneUser3FirstDepositInfo, self.UpdateNoviceShopTip)
end
function NewRechargeView:RequestQueryChargeCnt()
  ServiceUserEventProxy.Instance:CallQueryChargeCnt()
end
function NewRechargeView:RequestQueryChargeVirgin()
  ServiceSessionSocialityProxy.Instance:CallQueryChargeVirginCmd()
end
function NewRechargeView:RequestChargeQuery(shop_item_conf_id)
  ServiceUserEventProxy.Instance:CallChargeQueryCmd(shop_item_conf_id)
end
function NewRechargeView:OnReceiveEventMyDataChange(data)
  self:LoadZenyBalanceView()
end
function NewRechargeView:OnReceiveQueryChargeCnt(data)
  self:RequestQueryChargeVirgin()
  self:UpdateRedTips()
end
function NewRechargeView:OnEnter()
  NewRechargeView.super.OnEnter(self)
  NewRechargeProxy.Instance:InitRechargeShop()
  ServiceNUserProxy.Instance:CallProfessionQueryUserCmd(nil)
  if not GameConfig.SystemForbid.DanatuosiForbid and GameConfig.NewRecharge.TabDef.Hero then
    ServiceSceneUser3Proxy.Instance:CallHeroShowUserCmd()
  end
end
function NewRechargeView:OnExit()
  NewRechargeView.super.OnExit(self)
  if self.bgTexName then
    PictureManager.Instance:UnLoadUI(self.bgTexName, self.u_bgTex)
  end
  if self.bgTexName_b then
    PictureManager.Instance:UnLoadUI(self.bgTexName_b, self.u_bgTex_b)
  end
  EventManager.Me():RemoveEventListener(ServiceEvent.ItemGetCountItemCmd, self.OnReceiveItemGetCount, self)
  EventManager.Me():RemoveEventListener(ChargeLimitPanel.CloseZeny, self.OnClickForButtonBack, self)
  EventManager.Me():RemoveEventListener(ChargeLimitPanel.SelectEvent, self.ChargeLimitSelect, self)
  OverseaHostHelper.hasShowAge = false
  NewRechargeProxy.Instance:CallClientPayLog(102, os.time() - self.m_statyTime)
end
function NewRechargeView:Init()
  NewRechargeView.instance = self
  self:FindObjs()
  self:RegisterClickEvent()
  self:LoadView()
  self:Func_AddListenEvent()
  self:RequestQueryChargeCnt()
  self.m_statyTime = os.time()
end
function NewRechargeView:FindObjs()
  self.u_bgTex = self:FindComponent("bbg", UITexture, self.gameObject)
  self.bgTexName = "mall_twistedegg_bg_bottom"
  PictureManager.Instance:SetUI(self.bgTexName, self.u_bgTex)
  PictureManager.ReFitFullScreen(self.u_bgTex, 1)
  self.u_bgTex_b = self:FindComponent("bbg2", UITexture, self.gameObject)
  self.bgTexName_b = "new_recharge_pic_bottom_b"
  PictureManager.Instance:SetUI(self.bgTexName_b, self.u_bgTex_b)
  local width, height = UIManagerProxy.Instance:GetMyMobileScreenSize(2)
  self.u_bgTex_b.transform.localPosition = LuaGeometry.GetTempVector3(-width / 2, height / 2)
  self.u_bgTex_b.gameObject:SetActive(false)
  self.goBTNBack = self:FindGO("BTN_Back", self.gameObject)
  self.goZenyBalance = self:FindGO("ZenyBalance", self.gameObject)
  self.goLabZenyBalance = self:FindGO("Lab", self.goZenyBalance)
  self.labZenyBalance = self.goLabZenyBalance:GetComponent(UILabel)
  self.spZeny = self:FindGO("Icon", self.goZenyBalance):GetComponent(UISprite)
  IconManager:SetItemIcon("item_100", self.spZeny)
  self.u_ZenyBalance_ChargeBtn = self:FindGO("ChargeBtn", self.goZenyBalance)
  self.goGachaCoinBalance = self:FindGO("GachaCoinBalance", self.gameObject)
  self.goLabGachaCoinBalance = self:FindGO("Lab", self.goGachaCoinBalance)
  self.labGachaCoinBalance = self.goLabGachaCoinBalance:GetComponent(UILabel)
  self.spGachaCoin = self:FindGO("Icon", self.goGachaCoinBalance):GetComponent(UISprite)
  IconManager:SetItemIcon("item_151", self.spGachaCoin)
  self.u_GachaCoinBalance_ChargeBtn = self:FindGO("ChargeBtn", self.goGachaCoinBalance)
  self.widgetTipRelative = self:FindGO("TipRelative", self.gameObject):GetComponent(UIWidget)
  self.texBG = self:FindComponent("BG", UITexture, self.gameObject)
  self.helpButton = self:FindGO("HelpBtn", self.gameObject)
  self.StopAll = self:FindGO("StopAll", self.gameObject)
  self:CloseBoxCollider()
  self.subSelectContainer = self:FindComponent("Grid", UIGrid, self:FindGO("SubSelector", self.gameObject))
  self.subSelectListCtrl = UIGridListCtrl.new(self.subSelectContainer, NewRechargeSubSelectCell, "NewRechargeSubSelectCell")
  self:ShopItemPurchaseDetailCell_Create()
  self:onLoadGiftTipView()
  if BranchMgr.IsJapan() then
    self.helpButton.gameObject:SetActive(false)
    local overSeaRoot = self:FindGO("overseaRoot")
    local moneybillBtn = self:FindGO("moneybillBtn", overSeaRoot)
    local shopbillBtn = self:FindGO("shopbillBtn", overSeaRoot)
    self:AddClickEvent(moneybillBtn, function(go)
      OverseaHostHelper:OpenWebView("https://mobile.gungho.jp/reg/shikin")
    end)
    self:AddClickEvent(shopbillBtn, function(go)
      OverseaHostHelper:OpenWebView("https://mobile.gungho.jp/reg/trade")
    end)
    overSeaRoot:SetActive(true)
  end
  if BranchMgr.IsJapan() or BranchMgr.IsKorea() then
    self.goZenyBalance:SetActive(false)
  end
  self:InitNoviceShopTip()
end
function NewRechargeView:InitNoviceShopTip()
  self.noviceShopTip = self:FindGO("NoviceShopTip")
  if self.noviceShopTip then
    self.tipLabel = self:FindGO("tipLabel"):GetComponent(UILabel)
    self.tipLabel.text = ZhString.NoviceShop_MallTip
    self.noviceShopBtn = self:FindGO("NoviceShopBtn")
    self.noviceShopBtnLabel = self:FindGO("Label", self.noviceShopBtn):GetComponent(UILabel)
    self.noviceShopBtnLabel.text = ZhString.NoviceShop_GOTOBtn
    self:AddClickEvent(self.noviceShopBtn, function()
      local stype, sid = NoviceShopProxy.Instance:GetShopConfig()
      redlog("stype,sid", stype, sid)
      if stype and sid then
        NoviceShopProxy.Instance:CallQueryShopConfig()
      elseif NoviceShopProxy.Instance:CheckValidTime() then
        MsgManager.ShowMsgByID(40973)
      end
    end)
    self:UpdateNoviceShopTip()
  end
end
function NewRechargeView:UpdateNoviceShopTip()
  if self.noviceShopTip then
    local stype, sid = NoviceShopProxy.Instance:GetShopConfig()
    redlog("stype,sid", stype, sid)
    local endDate = NoviceShopProxy.Instance:GetEndDate()
    if not endDate then
      self.noviceShopTip:SetActive(false)
      return
    end
    local CurServerTime = ServerTime.CurServerTime() / 1000
    if endDate > 0 and endDate - CurServerTime > 0 and stype and sid then
      self.noviceShopTip:SetActive(true)
      return
    end
    self.noviceShopTip:SetActive(false)
  end
end
function NewRechargeView:LoadView()
  self:LoadZenyBalanceView()
  self:LoadSubView()
  local subSelect = self.viewdata.view.tab
  local innerSelect = self.viewdata.viewdata and self.viewdata.viewdata.innerTab or 1
  local ssData = NewRechargeProxy.Instance:GetSubSelectListData()
  self.subSelectListCtrl:ResetDatas(ssData)
  self:BindSubSelectorChangeEvent()
  self:TabChangeHandler(subSelect, innerSelect)
end
function NewRechargeView:ReloadView()
  local subSelect = self.viewdata.view.tab
  local innerSelect = self.viewdata.viewdata and self.viewdata.viewdata.innerTab or 1
  self:TabChangeHandler(subSelect, innerSelect)
end
function NewRechargeView:BindSubSelectorChangeEvent()
  local ssCells = self.subSelectListCtrl:GetCells()
  local ssCell
  for i = 1, #ssCells do
    ssCell = ssCells[i]
    self:AddTabChangeEvent(ssCell.gameObject, nil, ssCell.data.tab)
  end
  self:UpdateRedTips()
end
function NewRechargeView:UpdateRedTips()
  local ssCells = self.subSelectListCtrl:GetCells()
  local ssCell
  for i = 1, #ssCells do
    ssCell = ssCells[i]
    if ssCell.data.tab == GameConfig.NewRecharge.TabDef.Shop then
      local arr = NewRechargeProxy.Instance:GetRedTipsPageByShopPage()
      if #arr > 0 then
        self:RegisterRedTipCheck(NewRechargeShopItemCtrl.DailyOneZenyRedTipID, ssCell.gameObject, 9, {-50, -8})
      else
        self:UnRegisterSingleRedTipCheck(NewRechargeShopItemCtrl.DailyOneZenyRedTipID, ssCell.gameObject)
      end
    elseif ssCell.data.tab == GameConfig.NewRecharge.TabDef.Hot then
      local arr = NewRechargeProxy.Instance:GetRedTipsPageByHotPage()
      if #arr > 0 then
        self:RegisterRedTipCheck(NewRechargeShopItemCtrl.DailyOneZenyRedTipID, ssCell.gameObject, 9, {-50, -8})
      else
        self:UnRegisterSingleRedTipCheck(NewRechargeShopItemCtrl.DailyOneZenyRedTipID, ssCell.gameObject)
      end
    elseif ssCell.data.tab == GameConfig.NewRecharge.TabDef.Hero then
      self:RegisterRedTipCheck(HeroShopTip, ssCell.gameObject, 9, {-50, -8})
      local tip = NewRechargeProxy.Instance:GetHeroRedTip()
      if tip then
        RedTipProxy.Instance:UpdateRedTip(HeroShopTip)
      else
        RedTipProxy.Instance:RemoveWholeTip(HeroShopTip)
      end
    end
  end
end
function NewRechargeView:LoadZenyBalanceView()
  local milCommaBalance = FunctionNewRecharge.FormatMilComma(MyselfProxy.Instance:GetROB())
  if milCommaBalance then
    self.labZenyBalance.text = milCommaBalance
  end
  milCommaBalance = FunctionNewRecharge.FormatMilComma(MyselfProxy.Instance:GetLottery())
  if milCommaBalance then
    self.labGachaCoinBalance.text = milCommaBalance
  end
end
function NewRechargeView:LoadSubView()
  local tHotSubViewGetter = function()
    if not self.m_hotSubView then
      self.m_hotSubView = self:AddSubView("NewRechargeTHotSubView", NewRechargeTHotSubView)
      self.m_hotSubView.parentView = self
    end
    return self.m_hotSubView
  end
  local tShopSubViewGetter = function()
    if not self.tShopSubView then
      self.tShopSubView = self:AddSubView("NewRechargeTShopSubView", NewRechargeTShopSubView)
      self.tShopSubView.parentView = self
    end
    return self.tShopSubView
  end
  local tCardSubViewGetter = function()
    if not self.tCardSubView then
      self.tCardSubView = self:AddSubView("NewRechargeTCardSubView", NewRechargeTCardSubView)
      self.tCardSubView.parentView = self
    end
    return self.tCardSubView
  end
  local tDepositSubViewGetter = function()
    if not self.tDepositSubView then
      self.tDepositSubView = self:AddSubView("NewRechargeTDepositSubView", NewRechargeTDepositSubView)
      self.tDepositSubView.parentView = self
    end
    return self.tDepositSubView
  end
  self.subViews = {}
  self.subViews[GameConfig.NewRecharge.TabDef.Shop] = tShopSubViewGetter
  self.subViews[GameConfig.NewRecharge.TabDef.Card] = tCardSubViewGetter
  self.subViews[GameConfig.NewRecharge.TabDef.Deposit] = tDepositSubViewGetter
  self.subViews[GameConfig.NewRecharge.TabDef.Hot] = tHotSubViewGetter
  if not GameConfig.SystemForbid.DanatuosiForbid and GameConfig.NewRecharge.TabDef.Hero then
    local tHeroSubViewGetter = function()
      if not self.m_heroSubView then
        self.m_heroSubView = self:AddSubView("NewRechargeHeroSubView", NewRechargeHeroSubView)
        self.m_heroSubView.parentView = self
      end
      return self.m_heroSubView
    end
    self.subViews[GameConfig.NewRecharge.TabDef.Hero] = tHeroSubViewGetter
  end
  for _, v in pairs(self.subViews) do
    local subView = v()
    subView:Init(true)
    subView.gameObject:SetActive(false)
  end
end
function NewRechargeView:TabChangeHandler(tab, inner)
  local subView = self.subViews[tab]()
  subView:Init(true)
  if self.currentTab then
    local curSubView = self.subViews[self.currentTab]()
    curSubView.gameObject:SetActive(false)
    curSubView:OnHide()
  end
  self.currentTab = tab
  subView.gameObject:SetActive(true)
  subView:OnShow()
  subView:OnEnter()
  subView:RefreshView(inner)
  self:ChangeSubSelectorOnSelect(tab)
  self:ShowAgeSelect()
  if NewRechargeProxy.Instance:isRecordEvent() and tab == GameConfig.NewRecharge.TabDef.Hot then
    NewRechargeProxy.Instance:successTriggerEventId()
  end
end
function NewRechargeView:ChangeSubSelectorOnSelect(id)
  local ssCells = self.subSelectListCtrl:GetCells()
  for i = 1, #ssCells do
    local sstab = ssCells[i].data.tab
    ssCells[i]:SetSelect(sstab == id)
  end
end
function NewRechargeView:ShowAgeSelect()
  if not BranchMgr.IsJapan() then
    return
  end
  helplog("NewRechargeView:ShowAgeSelect")
  if not OverseaHostHelper.hasShowAge then
    OverseaHostHelper.hasShowAge = true
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
      viewname = "ChargeLimitPanel"
    })
  end
end
function NewRechargeView:RegisterClickEvent()
  self:AddClickEvent(self.goBTNBack, function()
    self:OnClickForButtonBack()
  end)
  self:AddClickEvent(self.helpButton, function()
    self:OpenHelpTips()
  end)
  self:AddClickEvent(self.u_ZenyBalance_ChargeBtn, function()
    FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TShop, FunctionNewRecharge.InnerTab.Shop_Normal2)
    EventManager.Me():DispatchEvent(NewRechargeEvent.SelectGood, 5054)
  end)
  self:AddClickEvent(self.u_GachaCoinBalance_ChargeBtn, function()
    FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit, FunctionNewRecharge.InnerTab.Deposit_ROB)
  end)
  EventManager.Me():AddEventListener(NewRechargeEvent.OpenBoxCollider, self.OpenBoxCollider, self)
  EventManager.Me():AddEventListener(NewRechargeEvent.CloseBoxCollider, self.CloseBoxCollider, self)
  EventManager.Me():AddEventListener(ServiceEvent.ItemGetCountItemCmd, self.OnReceiveItemGetCount, self)
  EventManager.Me():AddEventListener(ChargeLimitPanel.CloseZeny, self.OnClickForButtonBack, self)
  EventManager.Me():AddEventListener(ChargeLimitPanel.SelectEvent, self.ChargeLimitSelect, self)
end
function NewRechargeView:OnClickForButtonBack()
  self:CloseSelf()
end
function NewRechargeView:OpenHelpTips()
  local helpID = 40000
  local data = Table_Help[helpID]
  self:OpenHelpView(data)
end
function NewRechargeView:OpenBoxCollider()
  if self.StopAll and ApplicationInfo.IsWindows() then
    self.StopAll.gameObject:SetActive(true)
  end
end
function NewRechargeView:CloseBoxCollider()
  if self.StopAll then
    self.StopAll.gameObject:SetActive(false)
  end
end
function NewRechargeView:ShowAnimationConfirmView()
  MsgManager.ConfirmMsgByID(201, function()
    self:OnAnimationConfirm()
  end, function()
    self:OnAnimationCancel()
  end)
end
function NewRechargeView:ShopItemPurchaseDetailCell_Create()
  self.goShopItemPurchaseDetail = self:LoadPreferb("cell/NewHappyShopBuyItemCell", self.gameObject)
  self.goShopItemPurchaseDetail.transform.localPosition = LuaGeometry.GetTempVector3(0, 22)
  self:ShopItemPurchaseDetailCell_SetActive(false)
end
function NewRechargeView:ShopItemPurchaseDetailCell_Load(shop_item_data, m_funcRmbBuy)
  local tbItem = Table_Item[shop_item_data.goodsID]
  if shop_item_data.isDeposit then
    tbItem = Table_Item[shop_item_data.itemID]
  end
  if tbItem ~= nil and tbItem.ItemShow ~= nil and tbItem.ItemShow > 0 then
    self:onShowGiftTipView(true)
    if self.m_giftCell == nil then
      self.m_giftCell = NewRechargeGiftTipCell.new(self.m_goGiftTipView)
    end
    self.m_giftCell:SetData(shop_item_data, m_funcRmbBuy)
  else
    self:ShopItemPurchaseDetailCell_SetActive(true)
    if self.ctrlShopItemPurchaseDetail == nil then
      self.ctrlShopItemPurchaseDetail = NewHappyShopBuyItemCell.new(self.goShopItemPurchaseDetail)
      self.ctrlShopItemPurchaseDetail:AddEventListener(ItemTipEvent.ClickItemUrl, self.ShopItemPurchaseDetailCell_ClickDetailCtrlItemUrl, self)
      self.ctrlShopItemPurchaseDetail_CloseComp = self.ctrlShopItemPurchaseDetail.gameObject:GetComponent(CloseWhenClickOtherPlace)
    end
    self.ctrlShopItemPurchaseDetail:SetData(shop_item_data, m_funcRmbBuy)
  end
end
function NewRechargeView:ShopItemPurchaseDetailCell_SetActive(active)
  self.goShopItemPurchaseDetail:SetActive(active)
end
function NewRechargeView:onLoadGiftTipView()
  self.m_goGiftTipView = self:LoadPreferb("cell/NewRechargeGiftTipCell", self.gameObject, true)
  self:onShowGiftTipView(false)
end
function NewRechargeView:onShowGiftTipView(value)
  self.m_goGiftTipView:SetActive(value)
end
local itemClickUrlTipData = {}
function NewRechargeView:ShopItemPurchaseDetailCell_ClickDetailCtrlItemUrl(id)
  if not next(itemClickUrlTipData) then
    itemClickUrlTipData.itemdata = ItemData.new()
  end
  itemClickUrlTipData.itemdata:ResetData("itemClickUrl", id)
  function itemClickUrlTipData.clickItemUrlCallback(tip, itemid)
    itemClickUrlTipData.itemdata:ResetData("itemClickUrl", itemid)
    if self.ctrlShopItemPurchaseDetail ~= nil then
      self.ctrlShopItemPurchaseDetail:onShowClickItemUrlTip(itemClickUrlTipData)
    end
  end
  if self.ctrlShopItemPurchaseDetail ~= nil then
    self.ctrlShopItemPurchaseDetail:onShowClickItemUrlTip(itemClickUrlTipData)
  end
end
local clickItemUrlTipOffset = {270, 0}
function NewRechargeView:ShopItemPurchaseDetailCell_ShowClickItemUrlTip(data)
  local tip = self:ShowItemTip(data, self.widgetTipRelative, NGUIUtil.AnchorSide.Right, clickItemUrlTipOffset)
  if tip and self.ctrlShopItemPurchaseDetail_CloseComp then
    tip:AddIgnoreBounds(self.ctrlShopItemPurchaseDetail_CloseComp.gameObject)
    self.ctrlShopItemPurchaseDetail_CloseComp:AddTarget(tip.gameObject.transform)
  end
end
function NewRechargeView:OnReceiveItemGetCount(data)
  if data and self.ctrlShopItemPurchaseDetail ~= nil then
    self.ctrlShopItemPurchaseDetail:SetItemGetCount(data.data)
  end
end
function NewRechargeView:ChargeLimitSelect(id)
  helplog("UIViewControllerZenyShop:ChargeLimitSelect")
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
    viewname = "ChargeComfirmPanel",
    cid = id
  })
end
function NewRechargeView:RecvQuestCompleteQuery(data)
  if self.ctrlShopItemPurchaseDetail then
    self.ctrlShopItemPurchaseDetail:RecvQuestCompleteQuery(data.body)
  end
end
