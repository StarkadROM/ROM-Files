ShopItemCell = class("ShopItemCell", ItemCell)
function ShopItemCell:Init()
  self.cellContainer = self:FindGO("CellContainer")
  if self.cellContainer then
    local obj = self:LoadPreferb("cell/ItemCell", self.cellContainer)
    obj.transform.localPosition = LuaGeometry.Const_V3_zero
    self.cellContainer:AddComponent(UIDragScrollView)
  end
  ShopItemCell.super.Init(self)
  self:FindObjs()
  self:AddEvts()
  self.NormalColor = "[ffffff]"
  self.WarnColor = "[FF3B0D]"
end
function ShopItemCell:FindObjs()
  self.itemName = self:FindGO("itemName"):GetComponent(UILabel)
  self.costGrid = self:FindGO("CostGrid"):GetComponent(UIGrid)
  self.costMoneySprite = {}
  self.costMoneySprite[1] = self:FindGO("costMoneySprite"):GetComponent(UISprite)
  self.costMoneySprite[2] = self:FindGO("costMoneySprite1"):GetComponent(UISprite)
  self.costMoneyNums = {}
  self.costMoneyNums[1] = self:FindGO("costMoneyNums"):GetComponent(UILabel)
  self.costMoneyNums[2] = self:FindGO("costMoneyNums1"):GetComponent(UILabel)
  self.buyCondition = self:FindComponent("buyCondition", UILabel)
  self.sellDiscount = self:FindComponent("sellDiscount", UILabel)
  self.sellDiscountSp = self:FindComponent("sellDiscountBg", UIMultiSprite)
  self.primeCost = self:FindComponent("primeCost", UILabel)
  self.choose = self:FindGO("Choose")
  self.lock = self:FindGO("Lock")
  self.soldout = self:FindGO("Soldout")
  self.exchangeButton = self:FindGO("ExchangeButton")
  self.fashionUnlock = self:FindGO("FashionUnlock")
end
function ShopItemCell:AddEvts()
  self:AddCellClickEvent()
  if self.cellContainer then
    self:SetEvent(self.cellContainer, function()
      self:PassEvent(HappyShopEvent.SelectIconSprite, self)
    end)
  end
  if self.exchangeButton then
    self:SetEvent(self.exchangeButton, function()
      self:PassEvent(HappyShopEvent.ExchangeBtnClick, self)
    end)
  end
end
function ShopItemCell:GetShopItemData(id)
  return HappyShopProxy.Instance:GetShopItemDataByTypeId(id)
end
function ShopItemCell:SetData(data)
  local id = data
  local _HappyShopProxy = HappyShopProxy.Instance
  data = self:GetShopItemData(id)
  self.gameObject:SetActive(data ~= nil)
  if data then
    local itemData = data:GetItemData()
    local goodsCount = data.goodsCount
    if goodsCount and goodsCount > 1 then
      itemData.num = goodsCount
    end
    ShopItemCell.super.SetData(self, itemData)
    self.choose:SetActive(false)
    self:AddOrRemoveGuideId(self.gameObject)
    local itemId = data.goodsID
    if itemId ~= nil then
      self:Show(self.itemName.gameObject)
      if itemId == 12001 then
        self:AddOrRemoveGuideId(self.gameObject, 11)
      end
      if itemId == 14076 then
        self:AddOrRemoveGuideId(self.gameObject, 19)
      end
      local goodsData = Table_Item[itemId]
      if goodsData then
        self.itemName.text = goodsData.NameZh
      end
    else
      errorLog("ShopItemCell data.goodsID = nil")
    end
    if data.Discount ~= nil and data.ItemCount ~= nil and data.ItemID ~= nil then
      local totalPrice, discount = data:GetBuyDiscountPrice(data.ItemCount, 1)
      if discount < 100 then
        self:Show(self.sellDiscount.gameObject)
        self.sellDiscount.text = string.format(ZhString.HappyShop_discount, 100 - discount)
        self:Show(self.primeCost.gameObject)
        self.primeCost.text = ZhString.HappyShop_originalCost .. StringUtil.NumThousandFormat(data.ItemCount)
      else
        self:Hide(self.sellDiscount.gameObject)
        self:Hide(self.primeCost.gameObject)
      end
      for i = 1, #self.costMoneySprite do
        local temp = i
        if temp == 1 then
          temp = ""
        end
        local moneyId = data["ItemID" .. temp]
        local icon = Table_Item[moneyId] and Table_Item[moneyId].Icon
        local isGuildMat = data.LimitType == HappyShopProxy.LimitType.GuildMaterialWeek and moneyId == GameConfig.MoneyId.Quota
        if icon and not isGuildMat then
          self.costMoneySprite[i].gameObject:SetActive(true)
          IconManager:SetItemIcon(icon, self.costMoneySprite[i])
          self.costMoneyNums[i].text = StringUtil.NumThousandFormat((data:GetBuyDiscountPrice(data["ItemCount" .. temp], 1)))
        else
          self.costMoneySprite[i].gameObject:SetActive(false)
        end
      end
      self.costGrid:Reposition()
    else
      errorLog(string.format("ShopItemCell data.Discount = %s , data.ItemCount = %s , data.ItemID = %s", tostring(data.Discount), tostring(data.ItemCount), tostring(data.ItemID)))
    end
    if data:GetLock() then
      self:SetIconGrey(true)
      self.lock:SetActive(true)
      local menuDes = data:GetMenuDes()
      if menuDes and #menuDes > 0 then
        self.buyCondition.text = menuDes
      end
    else
      self:SetIconGrey(false)
      self.lock:SetActive(false)
      self:RefreshBuyCondition(data)
    end
    self:SetActive(self.invalid, self:IsInvalid(data, itemData))
    local canBuyCount, limitType = _HappyShopProxy:GetCanBuyCount(data)
    self.soldout:SetActive(canBuyCount == 0)
    self.itemtype = data.itemtype
    if data.itemtype == 2 then
      self.costGrid.gameObject:SetActive(false)
      self.exchangeButton:SetActive(true)
    else
      self.costGrid.gameObject:SetActive(true)
      self.exchangeButton:SetActive(false)
    end
    if data.presentType == ShopItemData.PresentType.Lock then
      self.fashionUnlock:SetActive(data:CheckPresentMenu())
    else
      self.fashionUnlock:SetActive(false)
    end
    self:TrySetGemData(itemData)
  end
  self.data = id
end
function ShopItemCell:RefreshBuyCondition(data)
  if data == nil then
    data = self:GetShopItemData(self.data)
  end
  if data == nil or self.buyCondition == nil then
    return
  end
  local str = data.des
  local levelDes = data.LevelDes
  local produceNum = data.produceNum
  if #str > 0 then
    self.buyCondition.text = str
  elseif #levelDes > 0 then
    local temp = levelDes
    local useLv = 1
    if itemId ~= nil and Table_Item[itemId] then
      useLv = Table_Item[itemId].Level or 1
    else
      errorLog("ShopItemCell data.goodsID = nil")
    end
    levelDes = OverSea.LangManager.Instance():GetLangByKey(levelDes)
    local lvEnough = useLv <= MyselfProxy.Instance:RoleLevel()
    if lvEnough then
      temp = self.NormalColor .. levelDes .. "[-]"
    else
      temp = self.WarnColor .. levelDes .. "[-]"
    end
    self.buyCondition.text = temp
  elseif produceNum ~= nil and produceNum > 0 then
    local soldCount = data.soldCount or 0
    self.buyCondition.text = string.format(ZhString.HappyShop_ProduceNum, produceNum - soldCount, produceNum)
  else
    self.buyCondition.text = ""
  end
end
function ShopItemCell:SetChoose(isChoose)
  if isChoose then
    self.choose:SetActive(true)
  else
    self.choose:SetActive(false)
  end
end
function ShopItemCell:GetDiscountColor(discount)
  if discount >= 0 and discount <= 20 then
    return 0, ColorUtil.DiscountLabel_Green
  elseif discount > 20 and discount <= 30 then
    return 1, ColorUtil.DiscountLabel_Blue
  elseif discount > 30 and discount <= 50 then
    return 2, ColorUtil.DiscountLabel_Purple
  elseif discount > 50 and discount <= 100 then
    return 3, ColorUtil.DiscountLabel_Yellow
  end
end
function ShopItemCell:IsInvalid(data, itemData)
  if not HappyShopProxy.Instance:JudgeCanBuy(data) then
    return true
  end
  if itemData:IsJobLimit() then
    return true
  end
  if itemData:IsPetEgg() then
    return false
  end
  if itemData.equipInfo and not itemData:CanEquip() then
    return true
  end
  return false
end
function ShopItemCell:TrySetGemData(itemData)
  if GemProxy.CheckIsGemStaticData(itemData.staticData) then
    if not self.gemCell then
      local gemCellGO = self:LoadPreferb("cell/GemCell", self.cellContainer)
      gemCellGO.transform.localPosition = LuaGeometry.Const_V3_zero
      self.gemCell = GemCell.new(gemCellGO)
    end
    GemProxy.TrySetFakeGemDataToGemCell(itemData, self.gemCell)
    self.gemCell:TryDestroyCollider()
  elseif self.gemCell then
    GameObject.Destroy(self.gemCell.gameObject)
    self.gemCell = nil
  end
end
