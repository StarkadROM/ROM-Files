autoImport("NewRechargePrototypeGoodsCell")
NewRechargeTDepositGoodsCell = class("NewRechargeTDepositGoodsCell", NewRechargePrototypeGoodsCell)
function NewRechargeTDepositGoodsCell:FindObjs()
  self.u_labProductName = self:FindGO("Title", self.gameObject):GetComponent(UILabel)
  self.u_labProductNum = self:FindGO("Count", self.gameObject):GetComponent(UILabel)
  self.u_spItemIcon = self:FindGO("Icon", self.gameObject):GetComponent(UISprite)
  self.u_itemPriceBtnBg = self:FindComponent("PriceBtn", UISprite)
  self.u_itemPriceBtnBc = self.gameObject:GetComponent(BoxCollider)
  self.u_itemPricePH = self:FindGO("PricePosHolder", self.u_itemPriceBtnBg.gameObject)
  self.u_itemPriceIcon = self:FindComponent("PriceIcon", UISprite)
  self.u_itemPrice = self:FindComponent("Price", UILabel)
  self.u_itemOriPrice = self:FindComponent("OriPrice", UILabel)
  self.u_desMark = self:FindGO("DesMark", self.gameObject)
  self.u_desMarkText = self:FindComponent("Des", UILabel, self.u_desMark)
  self.u_soldOutMark = self:FindGO("SoldOutMark", self.gameObject)
  self.u_discountMark = self:FindGO("DiscountMark", self.gameObject)
  self.u_discountValue = self:FindComponent("Value1", UILabel, self.u_discountMark)
  self.u_discountSymbol = self:FindComponent("Value2", UILabel, self.u_discountMark)
  self.u_discountBG = self:FindComponent("BG", UIMultiSprite, self.u_discountMark)
  self.u_freeBonusMark = self:FindGO("FreeBonusMark", self.gameObject)
  self.u_freeBonus = self:FindComponent("FreeBonus", UILabel, self.u_freeBonusMark)
  self.u_gainMoreMark = self:FindGO("GainMoreMark", self.gameObject)
  self.u_gainMore = self:FindComponent("GainMore", UILabel, self.u_gainMoreMark)
  self.u_firstDoubleMark = self:FindGO("FirstDoubleMark", self.gameObject)
  self.u_leftTimeMark = self:FindGO("LeftTimeMark", self.gameObject)
  self.u_leftTime = self:FindComponent("LeftTime", UILabel, self.u_leftTimeMark)
  self.u_content = self:FindGO("Content", self.gameObject)
  self.u_contentPH = self:FindGO("PosHolder", self.u_content)
  self.u_contentIcon = self:FindComponent("contentIcon", UISprite, self.u_content)
  self.u_contentNum = self:FindComponent("contentNum", UILabel, self.u_content)
  self.u_buyTimes = self:FindComponent("BuyTimes", UILabel)
  self.u_instBtn = self:FindGO("InstBtn", self.gameObject)
  self.u_buyBtn = self:FindGO("PriceBtn", self.gameObject)
end
function NewRechargeTDepositGoodsCell:RegisterClickEvent()
  self:AddClickEvent(self.gameObject, function()
    self:Pre_Purchase()
  end)
  self:AddClickEvent(self.u_instBtn, function()
    local data = Table_Help[1202]
    if data then
      TipsView.Me():ShowGeneralHelp(data.Desc)
    end
  end)
end
function NewRechargeTDepositGoodsCell:GetGoodsType()
  return NewRechargeTDepositGoodsCell.super.GetGoodsType(self)
end
function NewRechargeTDepositGoodsCell:SetData(data)
  NewRechargeTDepositGoodsCell.super.SetData(self, data)
  FunctionNewRecharge.Instance():AddProductPurchase(self.info.productConf.ProductID, function()
    self:OnClickForButtonPurchase()
  end)
end
function NewRechargeTDepositGoodsCell:Func_AddListenEvent()
  EventManager.Me():AddEventListener(ServiceEvent.UserEventUpdateActivityCnt, self.OnReceiveUpdateActivityCnt, self)
  EventManager.Me():AddEventListener(ServiceEvent.SessionSocialityQueryChargeVirginCmd, self.OnReceiveQueryChargeVirgin, self)
  if BranchMgr.IsJapan() then
    EventManager.Me():AddEventListener(ChargeLimitPanel.RefreshZenyCell, self.RefreshZenyCell, self)
  end
end
function NewRechargeTDepositGoodsCell:Func_RemoveListenEvent()
  EventManager.Me():RemoveEventListener(ServiceEvent.UserEventUpdateActivityCnt, self.OnReceiveUpdateActivityCnt, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.SessionSocialityQueryChargeVirginCmd, self.OnReceiveQueryChargeVirgin, self)
  if BranchMgr.IsJapan() then
    EventManager.Me():RemoveEventListener(ChargeLimitPanel.RefreshZenyCell, self.RefreshZenyCell, self)
  end
end
function NewRechargeTDepositGoodsCell:SetData_Deposit()
  self.info = NewRechargeProxy.Ins:GenerateDepositGoodsInfo(self.data.ShopID)
  self.depositGoodsInfo = self.info
end
function NewRechargeTDepositGoodsCell:SetCell_Deposit()
  self:Set_FirstDoubleMark(false)
  self:Set_SoldOutMark(false)
  self:Set_InstMark(false)
  self:Set_GainMoreMark(false)
  self:Set_BuyTimesMark(false)
  self:Set_LeftTimeMark(false)
  self:Set_DescMark(false)
  local info = self.info
  local productConf = self.info.productConf
  self:Set_ContentMark(true, productConf.ItemId, productConf.Count)
  local currency = productConf.Rmb or 0
  self.u_itemPriceIcon.gameObject:SetActive(false)
  self.u_itemPrice.text = productConf.priceStr or productConf.CurrencyType .. " " .. FunctionNewRecharge.FormatMilComma(currency)
  self:Set_DiscountMark(false)
  local zenyAdditionCount = self.info:GetFreeBonusCount()
  if zenyAdditionCount > 0 then
    self:Set_FreeBonusMark(true, zenyAdditionCount)
  else
    self:Set_FreeBonusMark(false)
  end
  self.u_labProductName.text = productConf and productConf.Desc or ""
  UIUtil.WrapLabel(self.u_labProductName)
  IconManager:SetZenyShopItem(productConf and productConf.Picture or "", self.u_spItemIcon)
  self.u_spItemIcon:MakePixelPerfect()
  self.u_spItemIcon.transform.localScale = LuaGeometry.GetTempVector3(0.8, 0.8, 0.8)
  self.u_labProductNum.text = ""
  if info.discountActivity ~= nil then
    local dActivityEndTime = info.discountActivity[5]
    local serverTime = ServerTime.CurServerTime() / 1000
    if dActivityEndTime > serverTime then
      local activityTimes = info.discountActivity[1]
      local activityUsedTimes = info.discountActivity[3]
      if activityTimes > activityUsedTimes then
        self:Set_DiscountMark(true, currency, activityPrice, true)
        self:Set_ContentMark(false)
        local buyTimes = string.format(ZhString.LuckyBag_PurchaseTimesMonth, activityUsedTimes, activityTimes)
        self:Set_BuyTimesMark(true, buyTimes)
      end
    end
  end
  if info.gainMoreActivity ~= nil then
    local gActivityEndTime = info.gainMoreActivity[5]
    local serverTime = ServerTime.CurServerTime() / 1000
    if gActivityEndTime > serverTime then
      local activityTimes = info.gainMoreActivity[1]
      local activityUsedTimes = info.gainMoreActivity[3]
      if activityTimes > activityUsedTimes then
        self:Set_GainMoreMark(true, info.gainMoreActivity[2])
        local buyTimes = string.format(ZhString.LuckyBag_PurchaseTimesMonth, activityUsedTimes, activityTimes)
        self:Set_BuyTimesMark(true, buyTimes)
      end
    end
  end
  local b = NewRechargeProxy.CDeposit:IsFPR(info.id) == true
  self:Set_FirstDoubleMark(b)
  if self.m_uiTxtNoIconPrice == nil then
    self.m_uiTxtNoIconPrice = self:FindGO("PriceNoIcon", self.gameObject):GetComponent(UILabel)
    self.m_uiTxtNoIconPrice.gameObject:SetActive(true)
    self.m_uiTxtNoIconPrice.text = self.u_itemPrice.text
    self.u_itemPrice.gameObject:SetActive(false)
  end
  if self.info.productConf ~= nil and not StringUtil.IsEmpty(self.info.productConf.ExtraDes) then
    self:Set_DescMark(true, self.info.productConf.ExtraDes)
  end
end
function NewRechargeTDepositGoodsCell:Pre_Purchase()
  if BranchMgr.IsJapan() or BranchMgr.IsKorea() then
    self:Invoke_DepositConfirmPanel(function()
      self:Purchase()
    end)
  else
    self:Purchase()
  end
end
function NewRechargeTDepositGoodsCell:Invoke_DepositConfirmPanel(cb)
  local productConf = self.info.productConf
  local productID = productConf.ProductID
  if productID then
    local productName = OverSea.LangManager.Instance():GetLangByKey(Table_Item[productConf.ItemId].NameZh)
    local productPrice = productConf.Rmb
    local productCount = productConf.Count
    local productDesc = OverSea.LangManager.Instance():GetLangByKey(Table_Deposit[productConf.id].Desc)
    local productD = " [0075BCFF]" .. productDesc .. "[-] "
    if not BranchMgr.IsKorea() then
      local zenyAdditionCount = self.info:GetFreeBonusCount()
      if zenyAdditionCount > 0 then
        productCount = tostring(productCount + zenyAdditionCount)
      end
      productD = " [0075BCFF]" .. productCount .. "[-] " .. productName
    end
    local currencyType = productConf.CurrencyType
    if self.startPurchaseFlow then
      Debug.LogError("支付流程中，不响应充值按钮点击事件")
      return
    end
    Debug.LogWarning("打开充值确认界面")
    OverseaHostHelper:FeedXDConfirm(string.format("[262626FF]" .. ZhString.ShopConfirmTitle .. "[-]", productD, currencyType, FunctionNewRecharge.FormatMilComma(productPrice)), ZhString.ShopConfirmDes, productName, productPrice, function()
      if cb then
        cb()
      end
    end)
  end
end
function NewRechargeTDepositGoodsCell:Purchase_Deposit()
  self:RequestQueryChargeVirgin()
  local couldPurchaseWithActivity = self:CouldPurchaseWithActivity()
  if self:Exec_Deposit_Purchase() then
    self.isActivity = couldPurchaseWithActivity
  end
end
function NewRechargeTDepositGoodsCell:Exec_Deposit_Purchase()
  if not self:IsDepositGoods() then
    return
  end
  local productConf = self.info.productConf
  local productID = productConf.ProductID
  if PurchaseDeltaTimeLimit.Instance():IsEnd(productID) then
    local callbacks = {}
    callbacks[1] = function(str_result)
      local str_result = str_result or "nil"
      LogUtility.Info("NewRechargeRecommendTShopGoodsCell:OnPaySuccess, " .. str_result)
      if BranchMgr.IsJapan() then
        local currency = productConf and productConf.Rmb or 0
        ChargeComfirmPanel:ReduceLeft(tonumber(currency))
        EventManager.Me():PassEvent(ChargeLimitPanel.RefreshZenyCell)
        LogUtility.Warning("OnPaySuccess")
        NewRechargeProxy.CDeposit:SetFPRFlag2(productID)
        xdlog(NewRechargeProxy.CDeposit:IsFPR(productID))
      end
      EventManager.Me():PassEvent(ChargeLimitPanel.RefreshZenyCell)
    end
    callbacks[2] = function(str_result)
      local strResult = str_result or "nil"
      LogUtility.Info("NewRechargeRecommendTShopGoodsCell:OnPayFail, " .. strResult)
      PurchaseDeltaTimeLimit.Instance():End(productID)
    end
    callbacks[3] = function(str_result)
      local strResult = str_result or "nil"
      LogUtility.Info("NewRechargeRecommendTShopGoodsCell:OnPayTimeout, " .. strResult)
      PurchaseDeltaTimeLimit.Instance():End(productID)
    end
    callbacks[4] = function(str_result)
      local strResult = str_result or "nil"
      LogUtility.Info("NewRechargeRecommendTShopGoodsCell:OnPayCancel, " .. strResult)
      PurchaseDeltaTimeLimit.Instance():End(productID)
    end
    callbacks[5] = function(str_result)
      local strResult = str_result or "nil"
      LogUtility.Info("NewRechargeRecommendTShopGoodsCell:OnPayProductIllegal, " .. strResult)
      PurchaseDeltaTimeLimit.Instance():End(productID)
    end
    callbacks[6] = function(str_result)
      local strResult = str_result or "nil"
      LogUtility.Info("NewRechargeRecommendTShopGoodsCell:OnPayPaying, " .. strResult)
    end
    FuncPurchase.Instance():Purchase(productConf.id, callbacks)
    local interval = GameConfig.PurchaseMonthlyVIP.interval / 1000
    PurchaseDeltaTimeLimit.Instance():Start(productID, interval)
    return true
  else
    MsgManager.ShowMsgByID(49)
  end
end
function NewRechargeTDepositGoodsCell:CouldPurchaseWithActivity()
  local info = self.info
  if info.discountActivity ~= nil then
    local dActivityEndTime = info.discountActivity[5]
    local serverTime = ServerTime.CurServerTime() / 1000
    if dActivityEndTime > serverTime then
      local activityTimes = info.discountActivity[1]
      local activityUsedTimes = info.discountActivity[3]
      if activityTimes > activityUsedTimes and activityTimes > 0 then
        return true
      end
    end
  end
  if info.gainMoreActivity ~= nil then
    local gActivityEndTime = info.gainMoreActivity[5]
    local serverTime = ServerTime.CurServerTime() / 1000
    if gActivityEndTime > serverTime then
      local activityTimes = info.gainMoreActivity[1]
      local activityUsedTimes = info.gainMoreActivity[3]
      if activityTimes > activityUsedTimes and activityTimes > 0 then
        return true
      end
    end
  end
  return false
end
function NewRechargeTDepositGoodsCell:RequestQueryChargeVirgin()
  ServiceSessionSocialityProxy.Instance:CallQueryChargeVirginCmd()
end
function NewRechargeTDepositGoodsCell:OnReceiveQueryChargeVirgin(message)
  self:SetCell()
end
function NewRechargeTDepositGoodsCell:OnReceiveUpdateActivityCnt(data)
  self:SetData()
  self:SetCell()
end
function NewRechargeTDepositGoodsCell:RefreshZenyCell()
  if not BranchMgr.IsJapan() then
    return
  end
  local left = ChargeComfirmPanel.left
  if left ~= nil then
    local currency = self.info.productConf and self.info.productConf.Rmb or 0
    helplog(currency, left)
    if left < currency then
      self:SetEnable(false)
    else
      self:SetEnable(true)
    end
  else
    helplog("unlimit")
    self:SetEnable(true)
  end
end
function NewRechargeTDepositGoodsCell:SetEnable(enable)
  if enable then
    self.u_itemPriceBtnBg.color = LuaGeometry.GetTempColor()
  else
    ColorUtil.ShaderGrayUIWidget(self.u_itemPriceBtnBg)
  end
  self.u_itemPriceBtnBc.enabled = enable
end
