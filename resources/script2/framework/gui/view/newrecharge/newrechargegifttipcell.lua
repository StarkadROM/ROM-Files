autoImport("NewHappyShopBuyItemCell")
autoImport("NewRechargeGiftTipItemView")
NewRechargeGiftTipCell = class("NewRechargeGiftTipCell", NewHappyShopBuyItemCell)
local bgTexName = "mall_bg_bottom_10"
function NewRechargeGiftTipCell:FindObjs()
  NewRechargeGiftTipCell.super.FindObjs(self)
  self.m_uiImgTipsMask = self:FindGO("uiImgTipsMask")
  self.m_uiImgTipsMask:SetActive(false)
  self.m_uiTexBg = self:FindComponent("uiTexBg", UITexture, self.gameObject)
  PictureManager.Instance:SetUI(bgTexName, self.m_uiTexBg)
  local scrollView = self:FindGO("uiScrollView")
  local scrollViewTips = self:FindGO("ScrollView")
  self.m_uiItemGrid = self:FindComponent("Grid", UIGrid, scrollView)
  self.helpBtn2 = self:FindGO("HelpInfoButton2")
  self:AddClickEvent(self.helpBtn2, function()
    self:ClickHelpBtn2()
  end)
  self.m_itemListCtrl = UIGridListCtrl.new(self.m_uiItemGrid, NewRechargeGiftTipItemView, "NewRechargeGiftTipItemView")
  self.m_itemListCtrl:AddEventListener(NewRechargeGiftTipItemView.Event.ClickItem, self.onShowGoodsItemTip, self)
  self.m_itemListCtrl:AddEventListener(NewRechargeGiftTipItemView.Event.ClickPreview, self.onShowFashionPreview, self)
  self.todayCanBuy.transform.localPosition = LuaGeometry.GetTempVector3(-218, -42)
  local panel = self.gameObject:GetComponent(UIPanel)
  if panel ~= nil then
    panel.depth = 262
  end
  panel = scrollView:GetComponent(UIPanel)
  if panel ~= nil then
    panel.depth = 264
  end
  panel = scrollViewTips:GetComponent(UIPanel)
  if panel ~= nil then
    panel.depth = 264
  end
  if self.closecomp ~= nil then
    function self.closecomp.callBack(go)
      self:Cancel()
    end
  end
  self.changeCostTipBtn = self:FindGO("ChangeCostTip", self.priceRoot)
end
function NewRechargeGiftTipCell:ClickHelpBtn2()
  self:OpenHelpView(Table_Help[1202])
end
function NewRechargeGiftTipCell:AddEvts()
  NewRechargeGiftTipCell.super.AddEvts(self)
  if self.m_uiImgTipsMask then
    self:AddClickEvent(self.m_uiImgTipsMask, function()
      self:onCloseFashionPreview()
      TipsView.Me():HideCurrent()
      self:setLocalPosition(0)
    end)
  end
end
function NewRechargeGiftTipCell:InputOnChange()
  local count = tonumber(self.countInput.value)
  if count == nil then
    return
  end
  if self.maxcount == 0 then
    count = 0
    self:SetCountPlus(0.5)
    self:SetCountSubtract(0.5)
  elseif self.maxcount == 1 then
    count = 1
    self:SetCountPlus(0.5)
    self:SetCountSubtract(0.5)
  elseif count <= 1 then
    count = 1
    self:SetCountPlus(1)
    self:SetCountSubtract(0.5)
  elseif count >= self.maxcount then
    count = self.maxcount
    self:SetCountPlus(0.5)
    self:SetCountSubtract(1)
  else
    self:SetCountPlus(1)
    self:SetCountSubtract(1)
  end
  self:UpdateTotalPrice(count)
end
function NewRechargeGiftTipCell:SetData(data, m_funcRmbBuy)
  if m_funcRmbBuy ~= nil then
    self.m_depositBuyFunc = m_funcRmbBuy
    self:shopDeposit(data)
  else
    self.m_depositBuyFunc = nil
    NewRechargeGiftTipCell.super.SetData(self, data)
    self:shopNormal(data)
  end
  self.helpBtn2:SetActive(data and data.batch_is_Batch == true or false)
end
function NewRechargeGiftTipCell:shopDeposit(data)
  self.priceTitle.transform.parent.gameObject:SetActive(false)
  self.countBg.transform.localPosition = LuaGeometry.GetTempVector3(-211, -105)
  self.totalPrice.transform.parent.localPosition = LuaGeometry.GetTempVector3(0, -183)
  self.hasMonthVIP = ServiceUserEventProxy.Instance:AmIMonthlyVIP()
  self.showFullAttr = data and data.showFullAttr or false
  self.equipBuffUpSource = data and data.equipBuffUpSource or nil
  self.shopdata = data
  self.data = data:GetItemData()
  if self.itemData == nil then
    self.itemData = {}
    self.itemData.itemData = self.data
  end
  local buyCount = data.purchaseTimes or 0
  local limitCount = data.purchaseLimit_N or 0
  local formatString = data.purchaseLimitStr
  self.todayCanBuy.text = string.format(formatString, buyCount, limitCount)
  self.todayCanBuy.gameObject:SetActive(true)
  self.limitCount.text = ""
  self.salePrice:SetActive(false)
  if data.purchaseState == 0 then
    self.todayCanBuy.text = string.format(formatString, limitCount, limitCount)
    self:UpdateConfirmBtn(false)
  else
    self:UpdateConfirmBtn(true)
  end
  self:UpdateTopInfo()
  self:UpdateShowFpButton()
  self:SetCountPlus(0.5)
  self:SetCountSubtract(0.5)
  self.countChangeRate = 1
  self.m_uiBtnMax.gameObject:SetActive(false)
  self.countPlusBg.gameObject:SetActive(false)
  self.countSubtractBg.gameObject:SetActive(false)
  self.totalPriceIcon.gameObject:SetActive(false)
  self.totalPrice.text = string.format("%s%s", self.shopdata.productConf.CurrencyType, StringUtil.NumThousandFormat(self:getRealPrice(), nil, true))
  self:UpdateAttriContext()
  if self.m_giftDataList == nil then
    self.m_giftDataList = {}
  end
  TableUtility.ArrayClear(self.m_giftDataList)
  local mainList, subList = NewRechargeProxy.Instance:findRmbShopInfo(data.id)
  if mainList or subList then
    for i = 1, #mainList do
      local v = mainList[i]
      table.insert(self.m_giftDataList, v)
    end
    local maxLine = math.ceil(#subList / 3)
    for i = 1, maxLine do
      local index = i - 1
      local tmp = {}
      for j = 1, 3 do
        local t = index * 3 + j
        if t <= #subList then
          local item = subList[t]
          table.insert(tmp, item)
        end
      end
      table.insert(self.m_giftDataList, tmp)
    end
  end
  self.m_itemListCtrl:ResetDatas(self.m_giftDataList)
  self.m_itemListCtrl:ResetPosition()
end
function NewRechargeGiftTipCell:shopNormal(data)
  NewRechargeGiftTipCell.super.shopNormal(self, data)
  self:setLocalPosition(0)
  self.priceTitle.transform.parent.gameObject:SetActive(false)
  self.countBg.transform.localPosition = LuaGeometry.GetTempVector3(-211, -105)
  self.totalPrice.transform.parent.localPosition = LuaGeometry.GetTempVector3(0, -183)
  self:UpdateAttriContext()
  if self.m_giftDataList == nil then
    self.m_giftDataList = {}
  end
  TableUtility.ArrayClear(self.m_giftDataList)
  local canBuyCount, limitType = HappyShopProxy.Instance:GetCanBuyCount(data)
  if data.showInfo ~= nil then
    local mainList, subList = data.showInfo[1], data.showInfo[2]
    for _, v in ipairs(mainList) do
      table.insert(self.m_giftDataList, v)
    end
    local maxLine = math.ceil(#subList / 3)
    for i = 1, maxLine do
      local index = i - 1
      local tmp = {}
      for j = 1, 3 do
        local t = index * 3 + j
        if t <= #subList then
          local item = subList[t]
          table.insert(tmp, item)
        end
      end
      table.insert(self.m_giftDataList, tmp)
    end
  end
  self.m_itemListCtrl:ResetDatas(self.m_giftDataList)
  self.m_itemListCtrl:ResetPosition()
end
function NewRechargeGiftTipCell:setLocalPosition(x)
  self.m_uiImgTipsMask:SetActive(x ~= 0)
  self.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(x, 0, 0)
  self.m_uiImgMask.transform.localPosition = LuaGeometry.GetTempVector3(x * -1, 0, 0)
end
local dotLineColor = LuaColor.New(0.8156862745098039, 0.7607843137254902, 0.6862745098039216, 1)
local txtBgColor = LuaColor.New(0.9647058823529412, 0.9333333333333333, 0.8392156862745098, 1)
local priceColor = LuaColor.New(0.43529411764705883, 0.34901960784313724, 0.24705882352941178, 1)
local descColor = LuaColor.New(0.5568627450980392, 0.42745098039215684, 0.2784313725490196, 1)
function NewRechargeGiftTipCell:UpdateAttriContext()
  TableUtility.TableClear(self.contextDatas)
  local shopdata = self.shopdata
  local ownNum = 0
  if shopdata then
    if shopdata.source == HappyShopProxy.SourceType.UserGuild then
      ownNum = GuildProxy.Instance:GetGuildPackItemNumByItemid(shopdata.goodsID)
    else
      ownNum = HappyShopProxy.Instance:GetItemNum(shopdata.goodsID, shopdata.source)
    end
  end
  local txt = "[c][8e6d47]" .. string.format("%s???%s", ZhString.HomeBP_HaveNum, "  " .. StringUtil.NumThousandFormat(ownNum)) .. "[-][/c]"
  local owerData = {}
  owerData.label = txt
  owerData.dotLineColor = dotLineColor
  self.contextDatas[ItemTipAttriType.ObsidianSoulCrystalTip] = owerData
  local moneyData = Table_Item[shopdata.ItemID]
  if moneyData ~= nil and moneyData.Icon ~= nil then
    txt = "[c][8e6d47]" .. string.format("%s???{priceicon=151,%s}", ZhString.HappyShop_PriceTitle, StringUtil.NumThousandFormat(self:getRealPrice())) .. "[-][/c]"
    local priceData = {}
    priceData.label = txt
    priceData.dotLineColor = dotLineColor
    priceData.color = priceColor
    priceData.txtBgColor = txtBgColor
    self.contextDatas[ItemTipAttriType.Code] = priceData
  end
  local sData = self.data and self.data.staticData
  if sData.Desc and sData.Desc ~= "" then
    local desc = {}
    local descStr = sData.Desc
    if self.data.IsLoveLetter and self.data:IsLoveLetter() then
      local time = os.date("*t", self.data.createtime)
      descStr = string.format(descStr, self.data.loveLetter.name, time.year, time.month, time.day)
    elseif self.data:IsMarryInviteLetter() then
      local weddingData = self.data.weddingData
      local timeStr = os.date(ZhString.ItemTip_WeddingCememony_TimeFormat, weddingData.starttime)
      descStr = string.format(descStr, weddingData.myname, weddingData.partnername, timeStr)
    elseif StringUtil.HasItemIdToClick(descStr) then
      descStr = StringUtil.AdaptItemIdClickUrl(descStr)
      function desc.clickurlcallback(url)
        if string.sub(url, 1, 6) ~= "itemid" then
          return
        end
        local itemId = tonumber(string.sub(url, 8))
        self:ShowGoodsItemTip(itemId)
      end
    elseif self.data.cup_name ~= nil then
      descStr = string.format(descStr, self.data.cup_name)
    end
    descStr = ZhString.ItemTip_Desc .. descStr
    desc.label = descStr
    desc.color = descColor
    desc.hideline = true
    self.contextDatas[ItemTipAttriType.Desc] = desc
  end
  self:ResetAttriDatas()
end
function NewRechargeGiftTipCell:Exit()
  self.m_itemListCtrl:Destroy()
  self:onCloseFashionPreview()
  TipsView.Me():HideCurrent()
  PictureManager.Instance:UnLoadUI(bgTexName, self.m_uiTexBg)
  NewRechargeGiftTipCell.super.Exit(self)
end
function NewRechargeGiftTipCell:Cancel()
  self:onCloseFashionPreview()
  TipsView.Me():HideCurrent()
  NewRechargeGiftTipCell.super.Cancel(self)
end
function NewRechargeGiftTipCell:onShowFashionPreview(value)
  TipsView.Me():HideCurrent()
  if null == self.m_fashionPreviewTip then
    local data = value.data
    if data ~= nil and data.staticData ~= nil then
      self.m_fashionPreviewTip = FashionPreviewTip.new(self.gpContainer)
      self.m_fashionPreviewTip:SetAnchorPos(true)
      if data:IsPic() then
        local cid = data.staticData.ComposeID
        local composeData = cid and Table_Compose[cid]
        if composeData then
          self.m_fashionPreviewTip:SetData(composeData.Product.id)
        end
      else
        local equipPreview = GameConfig.BattlePass.EquipPreview and GameConfig.BattlePass.EquipPreview[data.staticData.id]
        local equipInfo = data.equipInfo
        local fashionGroupEquip = equipInfo and equipInfo:GetMyGroupFashionEquip()
        if equipPreview then
          local field = MyselfProxy.Instance:GetMySex() == 2 and "female" or "male"
          self.m_fashionPreviewTip:SetData(equipPreview[field])
        elseif fashionGroupEquip then
          self.m_fashionPreviewTip:SetData(fashionGroupEquip.id)
        else
          self.m_fashionPreviewTip:SetData(data.staticData.id)
        end
      end
      self.m_fashionPreviewTip:AddEventListener(ItemEvent.GoTraceItem, function()
        self:CloseSelf()
      end, self)
      self.m_fashionPreviewTip:AddIgnoreBounds(self.gameObject)
      self.m_fashionPreviewTip:AddEventListener(FashionPreviewEvent.Close, self.onFashionPreViewCloseCall, self)
    end
    self:PassEvent(ItemTipEvent.ShowFashionPreview, self.m_fashionPreviewTip)
    self:setLocalPosition(-200)
  else
    self:onCloseFashionPreview()
  end
end
function NewRechargeGiftTipCell:onFashionPreViewCloseCall()
  self.m_fashionPreviewTip = nil
  self:PassEvent(FashionPreviewEvent.Close)
  self:setLocalPosition(0)
end
function NewRechargeGiftTipCell:onCloseFashionPreview()
  if self.m_fashionPreviewTip then
    self.m_fashionPreviewTip:OnExit()
    self.m_fashionPreviewTip = nil
  end
  self:setLocalPosition(0)
end
function NewRechargeGiftTipCell:onShowGoodsItemTip(cell)
  self:ShowGoodsItemTip(cell.data.staticData.id, cell.gameObject)
end
function NewRechargeGiftTipCell:ShowGoodsItemTip(itemId, go)
  self:onCloseFashionPreview()
  local itemData = ItemData.new(nil, itemId)
  if itemData ~= nil then
    self:setLocalPosition(-200)
    if self.m_tipWidget == nil then
      self.m_tipWidget = self.gpContainer:GetComponent(UIWidget)
    end
    local tipData, tipOffset = {}, {195, 0}
    tipData.itemdata = itemData
    tipData.ignoreBounds = {go}
    function tipData.callback()
      self:setLocalPosition(0)
    end
    function tipData.clickItemUrlCallback(tb, id)
      self:onShowUrlInfo(tb, id)
    end
    local currentTip = TipManager.Instance:ShowItemFloatTip(tipData, self.m_uiTexBg, NGUIUtil.AnchorSide.Right, tipOffset, false)
    self:AddIgnoreBounds(currentTip:GetCell(1).gameObject)
  end
end
function NewRechargeGiftTipCell:onShowUrlInfo(tb, id)
  if self.m_gwt ~= nil then
    self.m_gwt:OnExit()
    self.m_gwt = nil
  end
  if tb ~= nil then
    tb:DefaultClickItemUrl(id)
    if #tb.cells > 2 then
      tb.cells[2].gameObject.transform.localPosition = LuaGeometry.GetTempVector3(-405, 0, 0)
    end
  end
end
