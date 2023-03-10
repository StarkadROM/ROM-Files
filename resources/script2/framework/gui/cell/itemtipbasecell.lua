local BaseCell = autoImport("BaseCell")
ItemTipBaseCell = class("ItemTipBaseCell", BaseCell)
autoImport("TipLabelCell")
ItemTipAttriType = {
  NoPile = 0,
  Level = 1,
  EquipDecomposeTip = 2,
  MonsterLevel = 3,
  ItemType = 4,
  FurnitureInfo = 5,
  EquipCollectionLv = 6,
  UseLimit = 7,
  RecommendReason = 8,
  ConditionForbid = 9,
  MountSpeedUp = 15,
  EquipBaseAttri = 16,
  NextEquipLotteryAttri = 17,
  EquipStrengthRefine = 18,
  EquipSpecial = 19,
  Pvp_EquipBaseAttri = 20,
  EquipRandomAttri = 21,
  EquipEnchant = 22,
  EquipUpInfo = 23,
  EquipUpMaterial = 24,
  EquipCards = 25,
  EquipSuit = 26,
  EquipColor = 27,
  ComposeProductAttri = 28,
  ComposeInfo = 29,
  CardInfo = 30,
  SpecialTip = 31,
  UnLockInfo = 35,
  NoStorage = 36,
  NoMakeCard = 37,
  EquipCanInfo = 38,
  FoodInfo = 42,
  FoodAdvInfo = 43,
  FoodLvInfo = 44,
  PetEggInfo_Brief = 47,
  PetEggInfo_Skill = 48,
  PetEggInfo_Equip = 49,
  EquipJobs = 50,
  NoEffectTip = 51,
  ObsidianSoulCrystalTip = 52,
  Code = 53,
  UseTime = 54,
  Desc = 55,
  TradePrice = 56,
  SellPrice = 57,
  MAX_INDEX = 58
}
ItemTipPropIcon = {
  Atk = "tips_icon_07",
  Def = "tips_icon_08",
  MAtk = "tips_icon_10x",
  MDef = "tips_icon_09"
}
ItemTipDefaultUiIconPrefix = "{uiicon=new-com_icon_tips}"
ItemTipInactiveColorStr = "[717782]"
ItemTipEquipAttriActiveColorStr = "[4b7cff]"
ItemTipEquipAttriVStrColorStr = "2d2c47"
ItemTipEquipAttriVStrColorStr_OnlyGvgValid = "717782"
ItemTipMaterialEnoughColorStr = "[149b81]"
ItemTipMaterialNotEnoughColorStr = "[fb725f]"
ItemTipBanRedColorStr = "[ff6021]"
ItemTipProfessionPrefixColorStr = "[4a5a7d]"
ItemTipSpriteNormalColor = LuaColor.New(0.2901960784313726, 0.35294117647058826, 0.49019607843137253, 1)
ItemTipSpriteActivatedColor = LuaColor.New(0.984313725490196, 0.7098039215686275, 0.41568627450980394, 1)
ItemTipSpriteInvalidColor = LuaColor.New(0.6980392156862745, 0.7176470588235294, 0.7411764705882353, 1)
local AllTradeType = BoothProxy.TradeType.All
local MaxRefine = 15
local LimitCheckCfg = GameConfig.TechTree.LimitCheck
local SpeedUpBuff = 6788
function ItemTipBaseCell:Init()
  self.main = self:FindComponent("Main", UIWidget)
  self.cellContainer = self:FindGO("CellContainer")
  self:InitItemCell(self.cellContainer)
  self.typesprite = self:FindComponent("TypeSprite", UISprite)
  self.typeLabel = self:FindComponent("ItemType", UILabel)
  self.equipTip = self:FindGO("EquipEd")
  self.scrollview = self:FindComponent("ScrollView", UIScrollView)
  self.replaceInfo = self:FindGO("ReplaceInfo")
  self.replaceLab = self:FindComponent("Label", UILabel, self.replaceInfo)
  self.centerTop = self:FindGO("CenterTop")
  self.centerBottom = self:FindGO("CenterBottom")
  self.getPathBtn = self:FindGO("GetPathBtn")
  if self.getPathBtn then
    self:AddClickEvent(self.getPathBtn, function(go)
      self:PassEvent(ItemTipEvent.ShowGetPath, self)
    end)
  end
  self:InitAttriContext()
  self:InitEvent()
  self:InitCountChooseBord()
end
function ItemTipBaseCell:InitItemCell(container)
  self:TryInitItemCell(container, "ItemCell", ItemCell)
end
function ItemTipBaseCell:TryInitItemCell(container, pfbName, control)
  if container then
    local cellObj = self:LoadPreferb("cell/" .. pfbName, container)
    if not cellObj then
      return
    end
    cellObj.transform:SetParent(container.transform, true)
    cellObj.transform.localPosition = LuaGeometry.Const_V3_zero
    control = control or _G[pfbName]
    self.itemcell = control.new(container)
    self.itemcell:HideNum()
  end
end
function ItemTipBaseCell:AdjustTipPanelDepth()
  local upPanel = Game.GameObjectUtil:FindCompInParents(self.gameObject, UIPanel)
  local panels = self:FindComponents(UIPanel)
  for i = 1, #panels do
    panels[i].depth = upPanel.depth + panels[i].depth
  end
end
function ItemTipBaseCell:InitAttriContext()
  self:AdjustTipPanelDepth()
  self.table = self:FindComponent("AttriTable", UITable)
  self.attriCtl = UIGridListCtrl.new(self.table, TipLabelCell, "TipLabelCell")
  self.contextDatas = {}
end
function ItemTipBaseCell:HideItemIcon()
  if self.itemcell then
    self.itemcell:HideIcon()
    local sData = self.data and self.data.staticData
    if sData == nil then
      return
    end
    local lockDesc = Table_ItemAdvManual[sData.id] and Table_ItemAdvManual[sData.id].LockDesc
    if lockDesc then
      local desc = self.contextDatas[ItemTipAttriType.Desc] or {}
      desc.label = ZhString.ItemTip_Desc .. lockDesc
      self.contextDatas[ItemTipAttriType.Desc] = desc
    end
    self:ResetAttriDatas()
  end
end
function ItemTipBaseCell:InitCountChooseBord()
  self.countChooseBord = self:FindGO("CountChooseBord")
  if self.countChooseBord == nil then
    return
  end
  local countChoose_AddButton = self:FindGO("AddButton", self.countChooseBord)
  self.countChoose_AddButton_Sp = countChoose_AddButton:GetComponent(UISprite)
  self.countChoose_AddButton_Collider = countChoose_AddButton:GetComponent(BoxCollider)
  self:AddClickEvent(countChoose_AddButton, function(go)
    self:DoAddUseCount()
  end)
  local longPress = countChoose_AddButton:GetComponent(UILongPress)
  function longPress.pressEvent(obj, state)
    self:QuickDoAddUseCount(state)
  end
  local countChoose_MinusButton = self:FindGO("MinusButton", self.countChooseBord)
  self.countChoose_MinusButton_Sp = countChoose_MinusButton:GetComponent(UISprite)
  self.countChoose_MinusButton_Collider = countChoose_MinusButton:GetComponent(BoxCollider)
  self:AddClickEvent(countChoose_MinusButton, function(go)
    self:DoMinusUseCount()
  end)
  longPress = countChoose_MinusButton:GetComponent(UILongPress)
  function longPress.pressEvent(obj, state)
    self:QuickMinusAddUseCount(state)
  end
  self.countChoose_CountInput = self:FindComponent("CountInput", UIInput, self.countChooseBord)
  EventDelegate.Set(self.countChoose_CountInput.onChange, function()
    self.chooseCount = tonumber(self.countChoose_CountInput.value) or 0
    self:UpdateCountChooseBordButton()
  end)
  self.countChoose_Count = self:FindComponent("Count", UILabel, self.countChooseBord)
  self.chooseCount = 1
  self.countChoose_Title = self:FindComponent("Title", UILabel, self.countChooseBord)
end
function ItemTipBaseCell:DoAddUseCount()
  if self.data == nil then
    return
  end
  self.chooseCount = self.chooseCount + 1
  self.countChoose_CountInput.value = self.chooseCount
  self:UpdateCountChooseBordButton(true)
end
function ItemTipBaseCell:QuickDoAddUseCount(open)
  if open then
    TimeTickManager.Me():CreateTick(0, 100, self.DoAddUseCount, self, 11)
  else
    TimeTickManager.Me():ClearTick(self, 11)
  end
end
function ItemTipBaseCell:DoMinusUseCount()
  if self.data == nil then
    return
  end
  self.chooseCount = self.chooseCount - 1
  self.countChoose_CountInput.value = self.chooseCount
  self:UpdateCountChooseBordButton()
end
function ItemTipBaseCell:SetChooseCount(count)
  self.chooseCount = count
  if self.countChooseBord == nil then
    return
  end
  self.countChoose_CountInput.value = self.chooseCount
  self:UpdateCountChooseBordButton()
end
function ItemTipBaseCell:UpdateCountChooseBordButton(showMultipleMsg)
  if self.countChooseBord == nil then
    return
  end
  if self.data == nil then
    return
  end
  local sid = self.data.staticData.id
  if sid == nil then
    return
  end
  local useMax
  if self.countChoose_maxCount == nil then
    local typeData = Table_ItemType[self.data.staticData.Type]
    if typeData and typeData.UseNumber then
      useMax = typeData.UseNumber
    else
      useMax = self.data.staticData.MaxNum
    end
  else
    useMax = self.countChoose_maxCount
  end
  if useMax ~= nil then
    if not self.countChooseIgnoreItemNumLimit then
      useMax = math.min(self.data.num, useMax)
    end
  else
    useMax = self.data.num
  end
  if showMultipleMsg and self.countChoose_maxCount and self.chooseCount == self.countChoose_maxCount then
    MsgManager.ShowMsgByIDTable(1281)
  end
  if useMax < self.chooseCount or self.chooseCount < 1 then
    self.chooseCount = math.clamp(self.chooseCount, 1, useMax)
    self.countChoose_CountInput.value = self.chooseCount
  end
  if self.itemcell and not self.dontUpdateCellCount then
    self.itemcell:UpdateNumLabel(self.chooseCount)
  end
  self:_helpActiveButton(useMax > self.chooseCount, self.countChoose_AddButton_Sp, self.countChoose_AddButton_Collider)
  self:_helpActiveButton(self.chooseCount > 1, self.countChoose_MinusButton_Sp, self.countChoose_MinusButton_Collider)
end
function ItemTipBaseCell:QuickMinusAddUseCount(open)
  if open then
    TimeTickManager.Me():CreateTick(0, 100, self.DoMinusUseCount, self, 12)
  else
    TimeTickManager.Me():ClearTick(self, 12)
  end
end
function ItemTipBaseCell:_helpActiveButton(b, sp, collider)
  sp.alpha = b and 1 or 0.5
  collider.enabled = b and true or false
end
local _SHOWBTN_ = false
function ItemTipBaseCell:SetData(data)
  self.hasMonthVIP = ServiceUserEventProxy.Instance:AmIMonthlyVIP()
  self.showFullAttr = data and data.showFullAttr or false
  self.equipBuffUpSource = data and data.equipBuffUpSource or nil
  self.data = data
  self:UpdateTopInfo()
  self:UpdateAttriContext()
end
function ItemTipBaseCell:UpdateTopInfo(data)
  data = data or self.data
  if data then
    local typeConfig = Table_ItemType[data.staticData.Type]
    if self.typesprite then
      if typeConfig and typeConfig.icon and typeConfig.icon ~= "" then
        self.typesprite.gameObject:SetActive(true)
        IconManager:SetUIIcon(Table_ItemType[data.staticData.Type].icon, self.typesprite)
        self.typesprite:MakePixelPerfect()
      else
        self.typesprite.gameObject:SetActive(false)
      end
    end
    if self.typeLabel then
      self.typeLabel.text = typeConfig and ItemUtil.GetItemTypeName(data.staticData.Type) or ""
    end
    if self.equipTip then
      self.equipTip:SetActive(data.equiped == 1)
    end
    if self.itemcell then
      if data.staticData.Type == 610 and not self.dontUpdateCellCount then
        self.itemcell:ShowNum()
      end
      self.itemcell:SetData(data)
      if self.equipBuffUpSource then
        local withLimitBuffUpLv, withoutLimitBuffUpLv = data:GetStrengthBuffUpLevel(self.equipBuffUpSource)
        local player = self.equipBuffUpSource and SceneCreatureProxy.FindCreature(self.equipBuffUpSource) or Game.Myself
        local strengthLv = BlackSmithProxy.CalculateBuffUpLevel(data.equipInfo.strengthlv, player.data.userdata:Get(UDEnum.ROLELEVEL), withLimitBuffUpLv, withoutLimitBuffUpLv)
        self.itemcell:UpdateStrengthLevel(strengthLv, withLimitBuffUpLv + withoutLimitBuffUpLv > 0)
        withLimitBuffUpLv, withoutLimitBuffUpLv = data:GetRefineBuffUpLevel(self.equipBuffUpSource)
        local refineLv = BlackSmithProxy.CalculateBuffUpLevel(data.equipInfo.refinelv, BlackSmithProxy.Instance:MaxRefineLevelByData(data.staticData), withLimitBuffUpLv, withoutLimitBuffUpLv)
        self.itemcell:UpdateRefineLevel(refineLv, withLimitBuffUpLv + withoutLimitBuffUpLv > 0)
        if self.itemcell.nameLab then
          self.itemcell.nameLab.text = data:GetName(nil, nil, self.equipBuffUpSource)
        end
      end
    end
    if data.equipInfo then
      local replaceValue = data.equipInfo:GetReplaceValues()
      if replaceValue > 0 then
        self:SetReplaceInfo(ZhString.Itemtip_EquipScore .. replaceValue)
      else
        self:SetReplaceInfo()
      end
    else
      self:SetReplaceInfo()
    end
    if data.equiped == 1 and data.equipInfo and self.showFullAttr then
      local replaceEquipInfo = data:Clone().equipInfo
      replaceEquipInfo.refinelv = MaxRefine
      self.itemcell:UpdateEquipInfo(data, replaceEquipInfo)
    end
    self:UpdateGetPathBtn(data)
  end
end
function ItemTipBaseCell:UpdateGetPathBtn(data)
  if self.getPathBtn and data.staticData then
    local staticId = data.staticData.id
    local gainData = GainWayTipProxy.Instance:GetDataByStaticID(staticId)
    self.getPathBtn:SetActive(gainData ~= nil and #gainData.datas > 0 and GameConfig.MoneyId.Zeny ~= staticId)
  end
end
function ItemTipBaseCell:SetReplaceInfo(text)
  local y = 148
  if self.replaceInfo then
    local isEmpty = StringUtil.IsEmpty(text)
    self.replaceInfo:SetActive(not isEmpty)
    if not isEmpty then
      y = 125
      self.replaceLab.text = text
    end
  end
  if self.centerTop then
    self.centerTop.transform.localPosition = LuaGeometry.GetTempVector3(0, y, 0)
    if self.main then
      self.main:UpdateAnchors()
    end
  end
end
function ItemTipBaseCell:ActiveText(text, active)
  return active and text or string.format("[c]%s%s[-][/c]", ItemTipInactiveColorStr, text)
end
function ItemTipBaseCell:UpdateAttriContext()
  TableUtility.TableClear(self.contextDatas)
  _SHOWBTN_ = self.data and (self.data.showButton == "bag" or self.data.showButton == "equip")
  if self.data then
    self:UpdateNoPileItemInfo(self.data)
    self:UpdateNormalItemInfo(self.data)
    self:UpdateEquipAttriInfo(self.data)
    self:UpdateComposeInfo(self.data)
    self:UpdateCardAttriInfo(self.data)
    self:UpdateFoodInfo(self.data)
    self:UpdatePetEggInfo(self.data)
    self:UpdateRecommendReasonInfo(self.data)
    self:UpdateCodeInfo(self.data)
  end
  self:ResetAttriDatas()
end
function ItemTipBaseCell:_bHairType(type)
  local hairConfig = GameConfig.HairType
  if nil == hairConfig then
    return false
  end
  for _, v in pairs(hairConfig) do
    if type == v then
      return true
    end
  end
  return false
end
function ItemTipBaseCell:UpdateNoPileItemInfo(data)
  if not data then
    return
  end
  if data:IsNoPileSlot() then
    self.contextDatas[ItemTipAttriType.NoPile] = {
      label = ZhString.ItemTip_NoPile,
      hideline = false
    }
  end
end
local NOSHOW_GETLIMIT_IDMAP = {
  [5503] = 1
}
local bagTypeStorageTipMap
function ItemTipBaseCell:UpdateNormalItemInfo(data)
  local sData = data and data.staticData
  if not sData then
    return
  end
  local itemid = sData.id
  if sData.Level and sData.Level > 0 then
    local limitlevel, label = {hideline = true}, ZhString.ItemTip_LimitLv .. sData.Level
    if MyselfProxy.Instance:RoleLevel() < sData.Level then
      label = string.format("[c]%s%s[-][/c]", ItemTipBanRedColorStr, label)
    end
    limitlevel.label = label
    self.contextDatas[ItemTipAttriType.MonsterLevel] = limitlevel
  end
  local iscollection = AdventureDataProxy.Instance:CheckItemIsCollection(data)
  if iscollection then
    local tipMap = GameConfig.ItemQualityDesc
    if tipMap and tipMap[sData.Quality] then
      self.contextDatas[ItemTipAttriType.EquipCollectionLv] = {
        hideline = true,
        label = string.format(ZhString.ItemTip_EquipCollectionLv, tipMap[sData.Quality])
      }
    end
  end
  if nil == data.equipInfo and (sData.Type == 48 or sData.Type == 49) then
    local proInfo = {}
    local proban = true
    local prostr = ""
    local pros = Table_UseItem[sData.id] and Table_UseItem[sData.id].Class
    local myPro = MyselfProxy.Instance:GetMyProfession()
    local myTypeBranch = ProfessionProxy.GetTypeBranchFromProf(myPro)
    if nil == pros or #pros <= 0 then
      proban = false
      prostr = ZhString.ItemTip_AllPro
    else
      for i = 1, #pros do
        if myTypeBranch == ProfessionProxy.GetTypeBranchFromProf(pros[i]) and myPro >= pros[i] then
          proban = false
        end
        if Table_Class[pros[i]] then
          prostr = prostr .. ProfessionProxy.GetProfessionName(pros[i], MyselfProxy.Instance:GetMySex())
        end
        if i ~= #pros then
          prostr = prostr .. "/"
        end
      end
    end
    if proban then
      proInfo.label = string.format("[c]%s%s%s[-][/c]", ItemTipBanRedColorStr, ZhString.ItemTip_Profession, prostr)
    else
      proInfo.label = string.format("[c]%s%s[-][/c]%s", ItemTipProfessionPrefixColorStr, ZhString.ItemTip_Profession, prostr)
    end
    self.contextDatas[ItemTipAttriType.EquipJobs] = proInfo
  end
  local bHairType = self._bHairType(sData.Type)
  if not bHairType then
    local tradeSell = {hideline = true}
    if data.CanTrade and data:CanTrade() then
      local isOverTime = FunctionItemTrade.Me():IsRequireOverTime(self.data)
      if isOverTime then
        tradeSell.label = ZhString.ItemTip_TradePrice .. ZhString.ItemTip_TradePriceWait
        TimeTickManager.Me():CreateOnceDelayTick(1000, function(self)
          FunctionItemTrade.Me():GetTradePrice(self.data, nil, nil, AllTradeType)
        end, self, 100001)
      else
        local price = FunctionItemTrade.Me():GetTradePrice(self.data, nil, nil, AllTradeType)
        if price == 0 then
          tradeSell.label = ZhString.ItemTip_TradePrice .. ZhString.ItemTip_TradePriceWait
        else
          tradeSell.label = string.format("%s{priceicon=100,%s}", ZhString.ItemTip_TradePrice, price)
        end
      end
    else
      tradeSell.label = string.format("[c]%s%s%s[-][/c]", ItemTipInactiveColorStr, ZhString.ItemTip_TradePrice, ZhString.ItemTip_NoTradeTip)
    end
    self.contextDatas[ItemTipAttriType.TradePrice] = tradeSell
  end
  if not bHairType then
    local price = sData.SellPrice or 0
    if price > 0 and sData.NoSale ~= 1 then
      self.contextDatas[ItemTipAttriType.SellPrice] = {
        label = string.format("%s{priceicon=100,%s}", ZhString.ItemTip_SellPrice, price),
        hideline = true
      }
    end
  end
  if sData.Desc and sData.Desc ~= "" then
    local desc = {}
    local descStr = sData.Desc
    if data.IsLoveLetter and data:IsLoveLetter() then
      local time = os.date("*t", data.createtime)
      descStr = string.format(descStr, data.loveLetter.name, time.year, time.month, time.day)
    elseif data:IsMarryInviteLetter() then
      local weddingData = data.weddingData
      local timeStr = os.date(ZhString.ItemTip_WeddingCememony_TimeFormat, weddingData.starttime)
      descStr = string.format(descStr, weddingData.myname, weddingData.partnername, timeStr)
    elseif StringUtil.HasItemIdToClick(descStr) then
      descStr = StringUtil.AdaptItemIdClickUrl(descStr)
      function desc.clickurlcallback(url)
        if string.sub(url, 1, 6) ~= "itemid" then
          return
        end
        self:PassEvent(ItemTipEvent.ClickItemUrl, tonumber(string.sub(url, 8)))
      end
    elseif data.cup_name ~= nil then
      descStr = string.format(descStr, data.cup_name)
    end
    desc.label = ZhString.ItemTip_Desc .. descStr
    self.contextDatas[ItemTipAttriType.Desc] = desc
  end
  local itemRefConfig = Table_ItemRef[itemid]
  if itemRefConfig then
    local forbid = false
    if itemRefConfig.Menu_ID and not FunctionUnLockFunc.Me():CheckCanOpen(itemRefConfig.Menu_ID) then
      forbid = true
    end
    if itemRefConfig.Time_ID and not FunctionUnLockFunc.checkFuncTimeValid(itemRefConfig.Time_ID) then
      forbid = true
    end
    if forbid then
      local lockDesc = {hideline = true}
      lockDesc.label = string.format("[c]%s%s%s[-][/c]", ItemTipBanRedColorStr, ZhString.ItemTip_ConditionForbid, itemRefConfig.LockDesc)
      self.contextDatas[ItemTipAttriType.ConditionForbid] = lockDesc
    end
  end
  local limitCfg = sData.GetLimit
  if NOSHOW_GETLIMIT_IDMAP[sData.id] == nil and limitCfg and limitCfg.type ~= nil then
    local getLimitData = {}
    local limitCount = ItemData.Get_GetLimitCount(sData.id)
    if LimitCheckCfg and LimitCheckCfg[sData.id] then
      local lv, effectID = 0, nil
      local effectConfig = LimitCheckCfg[sData.id]
      for i = 1, #effectConfig do
        lv = TechTreeProxy.Instance:GetCurLevelOfLeaf(effectConfig[i].leafid)
        effectID = effectConfig[i].effectIDs[lv]
        if lv and effectID then
          local params = Table_TechTreeEffect[effectID] and Table_TechTreeEffect[effectID].Params or {}
          for j = 1, #params do
            if params[j].extra_count then
              limitCount = limitCount + params[j].extra_count
            end
          end
        end
      end
    end
    getLimitData.label = string.format("%s%s 0/%s", ItemData.GetLimitPrefixFromCfg(limitCfg), ZhString.ItemTip_GetLimit, limitCount)
    self.contextDatas[ItemTipAttriType.UseLimit] = getLimitData
    local source = limitCfg.source
    if limitCfg.uniform_source == 1 then
      source = {
        source[1]
      }
    end
    ServiceItemProxy.Instance:CallGetCountItemCmd(itemid, nil, source)
  end
  local needManualShow, inManualStr, inManualRefineStrs, unlockManualStr = false, nil, nil, nil
  local inManual, unlockManual = false, false
  if data:IsFashion() then
    local groupId = Table_Equip[sData.id] and Table_Equip[sData.id].GroupID
    if groupId then
      local fakeItemData = Table_Item[groupId]
      needManualShow = type(fakeItemData.AdventureValue) == "number" and fakeItemData.AdventureValue ~= 0 or false
      inManualStr = AdventureDataProxy.Instance:getIntoPackageRewardStr(fakeItemData, ZhString.ItemTip_ChAnd)
      unlockManualStr = AdventureDataProxy.Instance:getUnlockRewardStr(fakeItemData, ZhString.ItemTip_ChAnd)
      inManual = AdventureDataProxy.Instance:IsFashionStored(groupId)
      unlockManual = AdventureDataProxy.Instance:IsFashionUnlock(groupId)
    else
      needManualShow = type(sData.AdventureValue) == "number" and sData.AdventureValue ~= 0 or false
      inManualStr = AdventureDataProxy.Instance:getIntoPackageRewardStr(sData, ZhString.ItemTip_ChAnd)
      unlockManualStr = AdventureDataProxy.Instance:getUnlockRewardStr(sData, ZhString.ItemTip_ChAnd)
      inManual = AdventureDataProxy.Instance:IsFashionStored(sData.id)
      unlockManual = AdventureDataProxy.Instance:IsFashionUnlock(sData.id)
      local advData = AdventureDataProxy.Instance:GetItemByStaticIDFromBag(sData.id, SceneManual_pb.EMANUALTYPE_FASHION)
      local savedItem = advData and advData.savedItemDatas and advData.savedItemDatas[1]
      inManualRefineStrs = AdventureDataProxy.Instance:getIntoPackageRefineRewardStr(sData, ZhString.ItemTip_ChAnd, inManual, savedItem and savedItem.equipInfo.refinelv)
    end
  elseif data:IsPic() then
    local pCData = sData.ComposeID and Table_Compose[sData.ComposeID]
    if pCData then
      local picToId = pCData.Product.id
      local psData = Table_Item[picToId]
      local groupId = Table_Equip[psData.id] and Table_Equip[psData.id].GroupID
      if groupId then
        local fakeItemData = Table_Item[groupId]
        needManualShow = type(fakeItemData.AdventureValue) == "number" and fakeItemData.AdventureValue ~= 0 or false
        inManualStr = AdventureDataProxy.Instance:getIntoPackageRewardStr(fakeItemData, ZhString.ItemTip_ChAnd)
        unlockManualStr = AdventureDataProxy.Instance:getUnlockRewardStr(fakeItemData, ZhString.ItemTip_ChAnd)
        inManual = AdventureDataProxy.Instance:IsFashionStored(groupId)
        unlockManual = AdventureDataProxy.Instance:IsFashionUnlock(groupId)
      else
        needManualShow = type(psData.AdventureValue) == "number" and psData.AdventureValue ~= 0 or false
        inManualStr = AdventureDataProxy.Instance:getIntoPackageRewardStr(Table_Item[picToId], ZhString.ItemTip_ChAnd)
        unlockManualStr = AdventureDataProxy.Instance:getUnlockRewardStr(Table_Item[picToId], ZhString.ItemTip_ChAnd)
        inManual = AdventureDataProxy.Instance:IsFashionStored(picToId)
        unlockManual = AdventureDataProxy.Instance:IsFashionUnlock(picToId)
      end
    end
  elseif data:IsHomePic() then
    local pCData = sData.ComposeID and Table_Compose[sData.ComposeID]
    if pCData then
      local picToId = pCData.Product.id
      needManualShow = true
      inManualStr = AdventureDataProxy.Instance:getIntoPackageRewardStr(Table_Item[picToId], ZhString.ItemTip_ChAnd)
      unlockManualStr = AdventureDataProxy.Instance:getUnlockRewardStr(Table_Item[picToId], ZhString.ItemTip_ChAnd)
      inManual = AdventureDataProxy.Instance:IsFurnitureStored(picToId)
      unlockManual = AdventureDataProxy.Instance:IsFurnitureUnlock(picToId)
    end
  elseif data:IsCard() then
    needManualShow = true
    inManualStr = AdventureDataProxy.Instance:getIntoPackageRewardStr(sData, ZhString.ItemTip_ChAnd)
    unlockManualStr = AdventureDataProxy.Instance:getUnlockRewardStr(sData, ZhString.ItemTip_ChAnd)
    inManual = AdventureDataProxy.Instance:IsCardStored(sData.id)
    unlockManual = AdventureDataProxy.Instance:IsCardUnlock(sData.id)
  elseif data:IsFurniture() or data:IsHomeMatetial() then
    needManualShow = true
    inManualStr = AdventureDataProxy.Instance:getIntoPackageRewardStr(sData, ZhString.ItemTip_ChAnd)
    unlockManualStr = AdventureDataProxy.Instance:getUnlockRewardStr(sData, ZhString.ItemTip_ChAnd)
    inManual = AdventureDataProxy.Instance:IsFurnitureStored(sData.id)
    unlockManual = AdventureDataProxy.Instance:IsFurnitureUnlock(sData.id)
  elseif data:IsMount() or data:IsMountPet() then
    needManualShow = true
    local groupId = Table_Equip[sData.id] and Table_Equip[sData.id].GroupID
    local staticData = groupId and Table_Item[groupId] or sData
    inManualStr = AdventureDataProxy.Instance:getIntoPackageRewardStr(staticData, ZhString.ItemTip_ChAnd)
    unlockManualStr = AdventureDataProxy.Instance:getUnlockRewardStr(staticData, ZhString.ItemTip_ChAnd)
    inManual = AdventureDataProxy.Instance:IsMountStored(staticData.id)
    unlockManual = AdventureDataProxy.Instance:IsMountUnlock(staticData.id)
  end
  if needManualShow then
    local manual = {
      label = {}
    }
    if inManualStr == nil or inManualStr == "" then
      inManualStr = ZhString.ItemTip_None
    end
    if data:IsHomePic() or data:IsFurniture() or data:IsHomeMatetial() then
      if inManual then
        table.insert(manual.label, self:ActiveText(ZhString.ItemTip_ManualInTip .. inManualStr, inManual))
      end
    else
      table.insert(manual.label, self:ActiveText(ZhString.ItemTip_ManualInTip .. inManualStr, inManual))
    end
    if data:IsFashion() and inManualRefineStrs then
      for i = 1, #inManualRefineStrs do
        table.insert(manual.label, inManualRefineStrs[i])
      end
    end
    if unlockManualStr == nil or unlockManualStr == "" then
      unlockManualStr = ZhString.ItemTip_None
    end
    table.insert(manual.label, self:ActiveText(ZhString.ItemTip_ManualUnlockTip .. unlockManualStr, unlockManual))
    self.contextDatas[ItemTipAttriType.UnLockInfo] = manual
  end
  local weddingData = self.data.weddingData
  if (data:IsMarriageCertificate() or data:IsMarriageRing()) and weddingData then
    self.contextDatas[ItemTipAttriType.Desc] = {
      label = {
        sData.Desc,
        string.format(ZhString.ItemTip_WeddingTip, weddingData.myname, weddingData.partnername or "", os.date("%Y/%m/%d", weddingData.weddingtime or 0))
      }
    }
  end
  if sData.NoStorage and 0 < sData.NoStorage and (sData.NoStorage ~= 1 or not BranchMgr.IsJapan()) then
    if not bagTypeStorageTipMap then
      bagTypeStorageTipMap = {
        [BagProxy.BagType.Storage] = ZhString.ItemTip_CommonStorage,
        [BagProxy.BagType.PersonalStorage] = ZhString.ItemTip_PersonStorage,
        [BagProxy.BagType.Barrow] = ZhString.ItemTip_BarrowStorage,
        [BagProxy.BagType.Home] = ZhString.ItemTip_HomeStorage
      }
    end
    do
      local noStroage, sb, index = {}, LuaStringBuilder.CreateAsTable(), 0
      local addStorageDesc = function(d, bagType)
        if d:CanStorage(bagType) then
          return
        end
        if index > 0 then
          sb:Append("/")
        end
        sb:Append(bagTypeStorageTipMap[bagType])
        index = index + 1
      end
      addStorageDesc(data, BagProxy.BagType.Storage)
      addStorageDesc(data, BagProxy.BagType.PersonalStorage)
      addStorageDesc(data, BagProxy.BagType.Barrow)
      addStorageDesc(data, BagProxy.BagType.Home)
      noStroage.label = string.format(ZhString.ItemTip_NoStorage, sb:ToString())
      self.contextDatas[ItemTipAttriType.NoStorage] = noStroage
      sb:Destroy()
    end
  else
  end
  local useItemData = Table_UseItem[itemid]
  if useItemData then
    if useItemData.WeekLimit or useItemData.DailyLimit then
      local str
      if useItemData.WeekLimit then
        str = string.format(ZhString.ItemTip_UseTimeWeekLimit, 0, useItemData.WeekLimit)
      elseif useItemData.DailyLimit then
        str = string.format(ZhString.ItemTip_UseTimeDayLimit, 0, useItemData.DailyLimit)
      end
      self.contextDatas[ItemTipAttriType.UseLimit] = {label = str}
      ServiceItemProxy.Instance:CallUseCountItemCmd(self.data.staticData.id)
    end
    local tipInfo = useItemData.TipsInfo
    if tipInfo then
      for i = 1, #tipInfo do
        if tipInfo[i] == 1 then
          local catchMap = Game.Myself and Game.Myself.data.userdata:Get(UDEnum.SAVEMAP)
          local catchData = Table_Map[catchMap]
          if catchMap and catchData then
            self.contextDatas[ItemTipAttriType.SpecialTip] = {
              label = {
                ZhString.ItemTip_Position .. catchData.NameZh
              }
            }
          end
        end
      end
    end
    if useItemData.UseLimitTimes then
      self.contextDatas[ItemTipAttriType.UseTime] = {
        hideline = true,
        label = string.format(ZhString.ItemTip_UseTime, data.usedtimes or 0, useItemData.UseLimitTimes)
      }
    end
  end
  if itemid == 5650 then
    self.contextDatas[ItemTipAttriType.ObsidianSoulCrystalTip] = {
      label = {
        string.format(ZhString.ItemTip_DeadLv, Game.Myself.data.userdata:Get(UDEnum.DEADLV)),
        string.format(ZhString.ItemTip_DeadCoinNum, Game.Myself.data.userdata:Get(UDEnum.DEADCOIN), GameConfig.Dead.max_deadcoin),
        string.format(ZhString.ItemTip_TodayGet, MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_DEAD_COIN) or 0)
      }
    }
  end
  if data:IsFurniture() then
    local furnitureSData = Table_HomeFurniture[itemid]
    if furnitureSData then
      local limitStr = HomeProxy.Instance:GetAreaLimitStr(furnitureSData.AreaForceLimit or furnitureSData.AreaLimit)
      self.contextDatas[ItemTipAttriType.FurnitureInfo] = {
        label = {
          string.format(ZhString.HomeBuilding_Score, furnitureSData.HomeScore or 0),
          string.format(ZhString.HomeBuilding_GridSize, furnitureSData.Col or 0, furnitureSData.Row or 0),
          string.format(ZhString.HomeBuilding_PlaceLimit, limitStr)
        }
      }
    end
  elseif data:IsHomeMatetial() then
    local homeMatSData = Table_HomeFurnitureMaterial[itemid]
    if homeMatSData then
      local limitStr = HomeProxy.Instance:GetAreaLimitStr(homeMatSData.AreaForceLimit or homeMatSData.AreaLimit)
      self.contextDatas[ItemTipAttriType.FurnitureInfo] = {
        label = {
          string.format(ZhString.HomeBuilding_Score, homeMatSData.HomeScore or 0),
          string.format(ZhString.HomeBuilding_PlaceLimit, limitStr)
        }
      }
    end
  end
end
function ItemTipBaseCell.EffectSort(a, b)
  return a[1] < b[1]
end
function ItemTipBaseCell:UpdateEquipAttriInfo(data)
  local equipInfo = data.equipInfo
  local propMap = Game.Config_PropName
  if equipInfo then
    local singleData = ItemTipBaseCell.GetEquipDecomposeTip(equipInfo)
    if singleData then
      self.contextDatas[ItemTipAttriType.EquipDecomposeTip] = singleData
    end
    if data:IsMount() or data:IsMountPet() then
      local speed = ItemTipBaseCell.GetSpeedUp()
      if speed > 0 then
        self.contextDatas[ItemTipAttriType.MountSpeedUp] = {
          label = string.format(ZhString.ItemTip_MountSpeedUp, speed * 100)
        }
      end
    elseif data:IsFashion() then
    elseif data:IsRarePersonalArtifact() then
      singleData = ItemTipBaseCell.GetPersonalArtifactAttriByItemData(data)
      if singleData then
        self.contextDatas[ItemTipAttriType.EquipSpecial] = singleData
      end
    else
      singleData = ItemTipBaseCell.GetEquipBaseAttriByItemData(data, nil, ItemTipEquipAttriVStrColorStr)
      if singleData then
        self.contextDatas[ItemTipAttriType.EquipBaseAttri] = singleData
      end
      singleData = ItemTipBaseCell.GetEquipPvpBaseAttri(equipInfo, nil, ItemTipEquipAttriVStrColorStr)
      if singleData then
        self.contextDatas[ItemTipAttriType.Pvp_EquipBaseAttri] = singleData
      end
      local lotterData, nextlotteryData = LotteryProxy.Instance:GetEquipLotteryShowDatas(data.staticData.id)
      if nextlotteryData then
        local nlotteryEffect = {}
        for k, v in pairs(nextlotteryData.Attr) do
          if propMap[k] then
            local vstr = propMap[k].IsPercent == 1 and v * 100 .. "%" or v
            vstr = string.format("[c][%s]+%s[-][/c]", ItemTipEquipAttriVStrColorStr, vstr)
            local templab = string.format("%s%s%s", ItemTipDefaultUiIconPrefix, propMap[k].PropName, vstr)
            table.insert(nlotteryEffect, {
              propMap[k].id,
              templab
            })
          end
        end
        if #nlotteryEffect > 0 then
          table.sort(nlotteryEffect, ItemTipBaseCell.EffectSort)
          local nextlottery = {
            label = {
              string.format(ZhString.ItemTip_EquipLotteryTip, nextlotteryData.Level[1])
            }
          }
          local sb, effStr = LuaStringBuilder.CreateAsTable()
          for i = 1, #nlotteryEffect do
            effStr = nlotteryEffect[i][2]
            if i < #nlotteryEffect then
              sb:AppendLine(effStr)
            else
              sb:Append(effStr)
            end
          end
          if 0 < sb:GetCount() then
            nextlottery.label[2] = sb:ToString()
          end
          sb:Destroy()
          self.contextDatas[ItemTipAttriType.NextEquipLotteryAttri] = nextlottery
        end
      elseif lotterData then
        self.contextDatas[ItemTipAttriType.NextEquipLotteryAttri] = {
          label = ZhString.ItemTip_LotteryMaxTip
        }
      end
    end
    singleData = ItemTipBaseCell.GetEquipStrengthRefineByItemData(data, nil, self.equipBuffUpSource)
    if singleData then
      self.contextDatas[ItemTipAttriType.EquipStrengthRefine] = singleData
    end
    singleData = ItemTipBaseCell.GetEquipSpecial(equipInfo)
    if singleData then
      self.contextDatas[ItemTipAttriType.EquipSpecial] = singleData
    end
    singleData = ItemTipBaseCell.GetEquipRandomAttri(equipInfo)
    if singleData then
      self.contextDatas[ItemTipAttriType.EquipRandomAttri] = singleData
    end
    singleData = ItemTipBaseCell.GetEquipEnchant(data, self.showFullAttr, self.equipBuffUpSource)
    if singleData then
      self.contextDatas[ItemTipAttriType.EquipEnchant] = singleData
    end
    local cardSlotNum, replaceCount = data.replaceCount or data.cardSlotNum, 0
    if cardSlotNum and cardSlotNum > 0 or replaceCount and replaceCount > 0 then
      flag_InRoleEquip = data.equiped == 1
    else
    end
    singleData = ItemTipBaseCell.GetEquipProfession(equipInfo)
    if singleData then
      self.contextDatas[ItemTipAttriType.EquipJobs] = singleData
    end
    singleData = ItemTipBaseCell.GetEquipUpgrade(equipInfo, data, self)
    if singleData then
      self.contextDatas[ItemTipAttriType.EquipUpInfo] = singleData
    end
    local upgradeData = data.equipInfo.upgradeData
    if upgradeData then
      local equiplv, maxUplv = data.equipInfo.equiplv, data.equipInfo.upgrade_MaxLv
      if maxUplv > 0 and (equiplv < maxUplv or equiplv == maxUplv and upgradeData.Product) then
        local upgradeMaterial = {
          label = {}
        }
        local shortcutID = upgradeData.ShortcutID
        if shortcutID then
          local shortData = Table_ShortcutPower[shortcutID]
          local mapid, npcid = shortData.Event.mapid, shortData.Event.npcid
          local mapName = mapid and Table_Map[mapid] and Table_Map[mapid].CallZh
          local npcName = npcid and Table_Npc[npcid] and Table_Npc[npcid].NameZh
          table.insert(upgradeMaterial.label, string.format(ZhString.ItemTip_UpgradeNpcTip, mapName, npcName))
        end
        table.insert(upgradeMaterial.label, string.format(ZhString.ItemTip_UpMaterialTip))
        local bagtype = BagProxy.Instance:Get_PackageMaterialCheck_BagTypes(BagProxy.MaterialCheckBag_Type.Upgrade)
        local materials, material, msdata, nownum, neednum, celllab, colorStr = equipInfo:GetUpgradeMaterialsByEquipLv(equiplv + 1)
        for i = 1, #materials do
          material = materials[i]
          msdata = Table_Item[material.id]
          if material.id ~= 100 and msdata then
            nownum, neednum = BagProxy.Instance:GetItemNumByStaticID(material.id, bagtype), material.num
            colorStr = nownum < neednum and ItemTipMaterialNotEnoughColorStr or ItemTipMaterialEnoughColorStr
            celllab = string.format("[c]%s%s%s%s/%s[-][/c]", colorStr, msdata.NameZh, ZhString.ItemTip_CHSpace, nownum, neednum)
            table.insert(upgradeMaterial.label, celllab)
          end
        end
        self.contextDatas[ItemTipAttriType.EquipUpMaterial] = upgradeMaterial
      end
    end
    local canStrength, canRefine, canEnchant = equipInfo:CanStrength(), equipInfo:CanRefine(), equipInfo:CanEnchant()
    local sb = LuaStringBuilder.CreateAsTable()
    if not canStrength then
      sb:Append(ZhString.ItemTip_NoStrength)
    end
    if not canRefine then
      if 0 < sb:GetCount() then
        sb:Append("/")
      end
      sb:Append(ZhString.ItemTip_NoRefine)
    end
    if not canEnchant then
      if 0 < sb:GetCount() then
        sb:Append("/")
      end
      sb:Append(ZhString.ItemTip_NoEnchant)
    end
    if 0 < sb:GetCount() then
      table.insert(sb.content, 1, "[c]")
      table.insert(sb.content, 2, ItemTipBanRedColorStr)
      table.insert(sb.content, 3, ZhString.ItemTip_EquipCanTip)
      sb:Append("[-][/c]")
      self.contextDatas[ItemTipAttriType.EquipCanInfo] = {
        label = sb:ToString()
      }
    end
    sb:Destroy()
  end
  local suitInfo = data.suitInfo
  if suitInfo then
    local equipSuitDatas = suitInfo:GetEquipSuitDatas()
    if #equipSuitDatas > 0 then
      local suit, i, equipSuitData, buffIds = {
        label = {}
      }, 0, nil, nil
      for j = 1, #equipSuitDatas do
        equipSuitData = equipSuitDatas[j]
        buffIds = equipSuitData:GetSuitAddBuffIds()
        if next(buffIds) then
          i = i + 1
          table.insert(suit.label, string.format(ZhString.ItemTip_SuitInfo, i))
          table.insert(suit.label, string.format("[c]%s%s[-][/c]", ItemTipEquipAttriActiveColorStr, equipSuitData:GetSuitName()))
          local effectStr
          if data.equiped == 1 and equipSuitData:CheckIsActive() then
            effectStr = string.format(ZhString.ItemTip_SuitInfoTip, equipSuitData:GetSuitNum()) .. tostring(equipSuitData:GetEffectDesc())
          else
            effectStr = string.format("[c]%s%s%s[-][/c]", ItemTipInactiveColorStr, string.format(ZhString.ItemTip_SuitInfoTip, equipSuitData:GetSuitNum()), tostring(equipSuitData:GetEffectDesc()))
          end
          table.insert(suit.label, effectStr)
        end
      end
      self.contextDatas[ItemTipAttriType.EquipSuit] = suit
    end
  end
end
function ItemTipBaseCell:UpdateComposeInfo(data)
  local sData = data.staticData
  if not sData then
    return
  end
  local composeData = Table_Compose[sData.ComposeID]
  local productId = composeData and composeData.Product.id
  if productId then
    local isPic = data:IsPic()
    if isPic then
      local itemData = ItemData.new("Fashion", productId)
      local uniqueEffect = itemData.equipInfo:GetUniqueEffect()
      if uniqueEffect and #uniqueEffect > 0 then
        local picSpecial = {
          label = {}
        }
        local sb, id = LuaStringBuilder.CreateAsTable()
        for i = 1, #uniqueEffect do
          id = uniqueEffect[i].id
          sb:Append(ItemTipBaseCell.FormatBufferStr(id))
          if i < #uniqueEffect then
            sb:Append("\n")
          end
        end
        if 0 < sb:GetCount() then
          table.insert(picSpecial.label, sb:ToString())
          self.contextDatas[ItemTipAttriType.ComposeProductAttri] = picSpecial
        end
        sb:Destroy()
      end
    end
    if productId ~= sData.id then
      local compose = {
        label = {}
      }
      if isPic then
        compose.tiplabel = ZhString.ItemTip_PicMake
      else
        compose.tiplabel = string.format(ZhString.ItemTip_Compose, Table_Item[composeData.Product.id].NameZh)
      end
      local failIndexMap = {}
      if composeData.FailStayItem then
        for i = 1, #composeData.FailStayItem do
          local index = composeData.FailStayItem[i]
          if index then
            failIndexMap[index] = 1
          end
        end
      end
      local bagtype = BagProxy.Instance:Get_PackageMaterialCheck_BagTypes(BagProxy.MaterialCheckBag_Type.Produce)
      for i = 1, #composeData.BeCostItem do
        if not failIndexMap[i] then
          local material = composeData.BeCostItem[i]
          local msdata = Table_Item[material.id]
          if msdata then
            local nownum = BagProxy.Instance:GetItemNumByStaticID(material.id, bagtype)
            local neednum = material.num
            local colorStr = nownum < neednum and ItemTipMaterialNotEnoughColorStr or ItemTipMaterialEnoughColorStr
            local celllab = string.format("[c]%s%s    %d/%d[-][/c]", colorStr, msdata.NameZh, nownum, neednum)
            table.insert(compose.label, celllab)
          end
        end
      end
      self.contextDatas[ItemTipAttriType.ComposeInfo] = compose
    end
  end
end
function ItemTipBaseCell:UpdateCardAttriInfo(data)
  if data.cardInfo then
    local special = {
      label = {}
    }
    local bufferIds = data.cardInfo.BuffEffect.buff
    if bufferIds then
      for i = 1, #bufferIds do
        local str = ItemUtil.getBufferDescById(bufferIds[i])
        local bufferStrs = string.split(str, "\n")
        for j = 1, #bufferStrs do
          table.insert(special.label, ItemTipDefaultUiIconPrefix .. bufferStrs[j])
        end
      end
    end
    self.contextDatas[ItemTipAttriType.CardInfo] = special
    if data:CheckItemCardType(Item_CardType.Raffle) then
      self.contextDatas[ItemTipAttriType.NoMakeCard] = {
        label = ZhString.ItemTip_NoMakeCard,
        hideline = true
      }
    end
  end
end
function ItemTipBaseCell:UpdateFoodInfo(data)
  if data:IsFood() then
    local tipFoodInfo = {
      label = {}
    }
    local food_Sdata = data:GetFoodSData()
    local desc
    desc = data:GetFoodEffectDesc()
    if desc ~= nil then
      table.insert(tipFoodInfo.label, ZhString.ItemTip_Food_EffectTip .. desc)
    end
    if food_Sdata.Duration then
      desc = string.format(ZhString.ItemTip_Food_FullProgressTip, math.floor(food_Sdata.Duration / 60))
      table.insert(tipFoodInfo.label, desc)
    end
    local desc, hpStr, spStr
    if food_Sdata.SaveHP then
      hpStr = string.format(ZhString.ItemTip_SavePower_Desc, "Hp", food_Sdata.SaveHP)
    end
    if food_Sdata.SaveSP then
      spStr = string.format(ZhString.ItemTip_SavePower_Desc, "Sp", food_Sdata.SaveSP)
    end
    if hpStr and spStr then
      desc = hpStr .. ZhString.ItemTip_SavePower_And .. spStr
    else
      desc = hpStr and hpStr or spStr
    end
    if desc ~= nil then
      table.insert(tipFoodInfo.label, ZhString.Itemtip_SavePower .. ZhString.ItemTip_SavePower_Add .. desc)
    end
    local cookHard = food_Sdata.CookHard
    if cookHard then
      desc = ""
      local starNum = math.floor(cookHard / 2)
      for i = 1, starNum do
        desc = desc .. "{uiicon=food_icon_08}"
      end
      if cookHard % 2 == 1 then
        desc = desc .. "{uiicon=food_icon_09}"
      end
      if desc ~= "" then
        table.insert(tipFoodInfo.label, ZhString.ItemTip_Food_CookHardTip .. desc)
      end
    end
    local height = food_Sdata.Height
    if height then
      desc = nil
      if height > 0 then
        desc = ZhString.ItemTip_Food_HeightTip_Add
      elseif height < 0 then
        desc = ZhString.ItemTip_Food_HeightTip_Minus
      end
      if desc then
        for i = 1, math.abs(height) do
          desc = desc .. "{uiicon=food_icon_10}"
        end
      end
      table.insert(tipFoodInfo.label, desc)
    end
    local weight = food_Sdata.Weight
    if weight then
      desc = nil
      if weight > 0 then
        desc = ZhString.ItemTip_Food_WeightTip_Add
      elseif weight < 0 then
        desc = ZhString.ItemTip_Food_WeightTip_Minus
      end
      if desc then
        for i = 1, math.abs(weight) do
          desc = desc .. "{uiicon=food_icon_10}"
        end
      end
      table.insert(tipFoodInfo.label, desc)
    end
    self.contextDatas[ItemTipAttriType.FoodInfo] = tipFoodInfo
    local foodAdvInfo = {
      label = {}
    }
    local maxCooklv = GameConfig.Food.MaxCookFoodLv
    local cookInfo = FoodProxy.Instance:Get_FoodCookExpInfo(data.staticData.id)
    local cookerlv = cookInfo and cookInfo.level or 0
    local cooklvAttr, str = food_Sdata.CookLvAttr, nil
    for k, v in pairs(cooklvAttr) do
      str = string.format(ZhString.ItemTip_FoodCookTip, maxCooklv, Game.Config_PropName[k].PropName, v)
      table.insert(foodAdvInfo.label, self:ActiveText(str, maxCooklv <= cookerlv))
    end
    local tasterlvAttr = food_Sdata.TasteLvAttr
    local maxTasterlv = GameConfig.Food.MaxTasterFoodLv
    local tasteInfo = FoodProxy.Instance:Get_FoodEatExpInfo(data.staticData.id)
    local tasterlv = tasteInfo and tasteInfo.level or 0
    for k, v in pairs(tasterlvAttr) do
      str = string.format(ZhString.ItemTip_FoodTasteTip, maxTasterlv, Game.Config_PropName[k].PropName, v)
      table.insert(foodAdvInfo.label, self:ActiveText(str, maxTasterlv <= tasterlv))
    end
    self.contextDatas[ItemTipAttriType.FoodAdvInfo] = foodAdvInfo
    local recipeInfo = {
      label = {}
    }
    cookInfo = FoodProxy.Instance:Get_FoodCookExpInfo(data.staticData.id)
    if cookInfo and 0 < cookInfo.level and 0 < food_Sdata.CookerExp then
      local level, exp = cookInfo.level, ""
      if level < 10 then
        exp = cookInfo.exp * 10 .. "%"
      end
      table.insert(recipeInfo.label, string.format(ZhString.FoodRecipeTip_Cook_Proficiency, data.staticData.NameZh, level, exp))
    end
    tasteInfo = FoodProxy.Instance:Get_FoodEatExpInfo(data.staticData.id)
    if tasteInfo and 0 < tasteInfo.level and 0 < food_Sdata.TasterExp then
      local level = tasteInfo.level
      local exp = ""
      if level < 10 then
        exp = tasteInfo.exp * 10 .. "%"
      end
      table.insert(recipeInfo.label, string.format(ZhString.FoodRecipeTip_Eat_Proficiency, data.staticData.NameZh, level, exp))
    end
    if #recipeInfo.label == 0 then
      self.contextDatas[ItemTipAttriType.FoodAdvInfo] = nil
    else
      self.contextDatas[ItemTipAttriType.FoodAdvInfo] = recipeInfo
    end
  end
end
function ItemTipBaseCell:UpdatePetEggInfo(data)
  local petEggInfo, colorFormat = data.petEggInfo, "[c][514f7b]%s[-][/c]"
  if petEggInfo then
    local briefInfo = {
      label = {}
    }
    if petEggInfo.petid then
      local monsterName = Table_Monster[petEggInfo.petid] and Table_Monster[petEggInfo.petid].NameZh or "UnKnown"
      table.insert(briefInfo.label, string.format(ZhString.ItemTip_PetEgg_MonsterName, string.format(colorFormat, monsterName)))
    end
    if petEggInfo.lv then
      table.insert(briefInfo.label, string.format(ZhString.ItemTip_PetEgg_Level, string.format(colorFormat, petEggInfo.lv)))
    end
    if petEggInfo.friendlv then
      table.insert(briefInfo.label, string.format(ZhString.ItemTip_PetEgg_Friendly, string.format(colorFormat, petEggInfo.friendlv)))
    end
    local skillInfo
    local skillids = petEggInfo.skillids
    if skillids and #skillids > 0 then
      skillInfo = {
        label = {
          ZhString.ItemTip_PetEgg_Skill
        }
      }
      for i = 1, #skillids do
        local skillConfig = Table_Skill[skillids[i]]
        if skillConfig then
          table.insert(skillInfo.label, OverSea.LangManager.Instance():GetLangByKey(skillConfig.NameZh) .. "    " .. string.format(colorFormat, "Lv." .. skillConfig.Level))
        end
      end
    end
    local equipInfo
    local equips = petEggInfo.equips
    if equips and #equips > 0 then
      equipInfo = {
        label = {
          ZhString.ItemTip_PetEgg_Equip
        }
      }
      for i = 1, #equips do
        table.insert(equipInfo.label, equips[i].staticData.NameZh)
      end
    end
    local lastInfo = briefInfo
    self.contextDatas[ItemTipAttriType.PetEggInfo_Brief] = briefInfo
    if skillInfo ~= nil then
      briefInfo.hideline = true
      lastInfo = skillInfo
      self.contextDatas[ItemTipAttriType.PetEggInfo_Skill] = skillInfo
    end
    if equipInfo ~= nil then
      if skillInfo ~= nil then
        skillInfo.hideline = true
      elseif briefInfo ~= nil then
        briefInfo.hideline = true
      end
      lastInfo = equipInfo
      self.contextDatas[ItemTipAttriType.PetEggInfo_Equip] = equipInfo
    end
  end
end
function ItemTipBaseCell:UpdateCodeInfo(data)
  if not data then
    return
  end
  local codeData = data.CodeData
  if codeData and codeData.code and codeData.code ~= "" then
    self:UpdateGetCodItem(codeData)
  elseif ItemUtil.CheckIfNeedRequestUseCode(data) then
    ServiceItemProxy.Instance:CallUseCodItemCmd(data.id)
  end
end
function ItemTipBaseCell:UpdateRecommendReasonInfo(data)
  if nil == data then
    return
  end
  if not data.forceShowRecommendReason then
    if Game.Myself and Game.Myself.data:GetEquipedItemNum(data.staticData.id) > 0 then
      return
    end
    if Game.Myself and 0 < BagProxy.Instance:GetAllItemNumByStaticID(data.staticData.id) then
      return
    end
  end
  local recommendDesc = {}
  local recommendReasonData = Table_recommend_reason[data.staticData.id]
  if recommendReasonData then
    recommendDesc.label = string.format(ZhString.ItemTip_Recommend, recommendReasonData.reason)
    self.contextDatas[ItemTipAttriType.RecommendReason] = recommendDesc
  end
end
function ItemTipBaseCell:UpdateAttributeGemInfo(data)
  if not GemProxy.CheckContainsGemAttrData(data) then
    return
  end
  local attrData = data.gemAttrData
  local rslt1, rslt2 = self:UpdateAttrGemSpecialTip(attrData), self:UpdateAttributeGemExpSlider(attrData)
  return rslt1 or rslt2
end
function ItemTipBaseCell:UpdateSkillGemInfo(data)
  if not GemProxy.CheckContainsGemSkillData(data) then
    return
  end
  local skillData = data.gemSkillData
  local rslt1, rslt2, rslt3 = self:UpdateSkillGemSpecialTip(skillData), self:UpdateSkillGemProfession(skillData), self:UpdateSkillGemDesc(skillData)
  return rslt1 or rslt2 or rslt3
end
function ItemTipBaseCell:UpdateSkillGemStaticInfo(data)
  local effectStaticDatas = GemProxy.Instance:GetEffectStaticDatasOfSkillGem(tonumber(data.id))
  if effectStaticDatas and next(effectStaticDatas) then
    local rsltArr, paramArr = {}, ReusableTable.CreateArray()
    local sData, paramId, paramStaticData, paramDescFormat, paramDesc
    for i = 1, #effectStaticDatas do
      sData = effectStaticDatas[i]
      if next(sData.ParamsID) then
        TableUtility.ArrayClear(paramArr)
        for j = 1, #sData.ParamsID do
          paramId = sData.ParamsID[j]
          paramStaticData = GemProxy.Instance:GetStaticDataOfSkillGemParam(paramId)
          if paramStaticData then
            paramDescFormat = paramStaticData.isPercent and ZhString.Gem_SkillEffectParamWithPercentFormat or ZhString.Gem_SkillEffectParamFormat
            paramDesc = string.format(paramDescFormat, "", paramStaticData.min, paramStaticData.max)
          else
            paramDesc = nil
          end
          if paramDesc then
            paramDesc = string.gsub(paramDesc, "%]%%", "]")
            TableUtility.ArrayPushBack(paramArr, paramDesc)
          end
        end
        TableUtility.ArrayPushBack(rsltArr, ItemTipDefaultUiIconPrefix .. string.format(sData.Desc, unpack(paramArr)))
      else
        local probText = ""
        if sData.NormalRate < 100 then
          probText = string.format(ZhString.Gem_SkillEffectProbabilityFormat, sData.NormalRate)
        end
        TableUtility.ArrayPushBack(rsltArr, ItemTipDefaultUiIconPrefix .. sData.Desc .. probText)
      end
    end
    ReusableTable.DestroyAndClearArray(paramArr)
    self.contextDatas[ItemTipAttriType.SpecialTip] = {label = rsltArr}
    return true
  end
  return false
end
function ItemTipBaseCell:UpdateAttrGemSpecialTip(attrData)
  if not attrData then
    return false
  end
  return self:UpdateGemSpecialTip(attrData:GetExpInfoDescArray())
end
function ItemTipBaseCell:UpdateSkillGemSpecialTip(skillData)
  if not skillData then
    return false
  end
  return self:UpdateGemSpecialTip(skillData:GetEffectDescArray(true))
end
function ItemTipBaseCell:UpdateGemSpecialTip(descArray)
  if type(descArray) ~= "table" then
    return
  end
  for i = 1, #descArray do
    descArray[i] = ItemTipDefaultUiIconPrefix .. descArray[i]
  end
  self.contextDatas[ItemTipAttriType.SpecialTip] = {label = descArray}
  return true
end
function ItemTipBaseCell:UpdateAttributeGemExpSlider(attrData)
  self.contextDatas[ItemTipAttriType.Level] = attrData
  return true
end
function ItemTipBaseCell:UpdateSkillGemProfession(skillData)
  local profDesc = GemProxy.GetProfessionDescFromSkillGem(skillData.id)
  if not profDesc or profDesc == "" then
    return false
  end
  self.contextDatas[ItemTipAttriType.EquipJobs] = {label = profDesc}
  return true
end
function ItemTipBaseCell:UpdateSkillGemDesc(skillData)
  local types = skillData.needAttributeGemTypes
  if not types or not next(types) then
    return true
  end
  local typeDescs = ReusableTable.CreateArray()
  for i = 1, #types do
    typeDescs[i] = ZhString["Gem_SkillDescNeedGemType" .. types[i]]
  end
  if GemProxy.CheckSkillDataIsSculpted(skillData) then
    local sculptData = skillData:GetSculptData()
    typeDescs[sculptData[1].pos] = ZhString.Gem_SkillDescNeedGemTypeSculpted
  end
  self.contextDatas[ItemTipAttriType.Desc] = {
    label = string.format(ZhString.Gem_SkillDescFormat, unpack(typeDescs))
  }
  ReusableTable.DestroyAndClearArray(typeDescs)
  return true
end
function ItemTipBaseCell:ResetAttriDatas(resetPos)
  self.listDatas = self.listDatas or {}
  TableUtility.ArrayClear(self.listDatas)
  for i = 0, ItemTipAttriType.MAX_INDEX do
    if self.contextDatas[i] then
      table.insert(self.listDatas, self.contextDatas[i])
    end
  end
  if resetPos == nil then
    resetPos = true
  end
  self.attriCtl:ResetDatas(self.listDatas, true, resetPos)
  if self.main and resetPos then
    self.main:UpdateAnchors()
  end
end
function ItemTipBaseCell:UpdateTradePrice(evt)
  if Slua.IsNull(self.gameObject) then
    self:Exit()
    return
  end
  local data = evt.data
  if self.data then
    local key = FunctionItemTrade.Me():CombineItemKey(self.data)
    local id, price = data.id, data.price
    if id == key then
      local tradeData = self.contextDatas[ItemTipAttriType.TradePrice]
      if tradeData then
        if price == 0 then
          tradeData.label = ZhString.ItemTip_TradePrice .. ZhString.ItemTip_TradePriceWait
        else
          tradeData.label = string.format("%s{priceicon=100,%s}", ZhString.ItemTip_TradePrice, price)
        end
      end
      self:ResetAttriDatas(false)
    end
  end
end
function ItemTipBaseCell:HideEquipedSymbol()
  if not self.equipTip then
    return
  end
  self.equipTip:SetActive(false)
end
function ItemTipBaseCell:SetNoEffectTip(active)
  local noEffectTip = self.contextDatas[ItemTipAttriType.NoEffectTip]
  if active then
    if noEffectTip == nil then
      self.contextDatas[ItemTipAttriType.NoEffectTip] = {
        label = string.format("[c]%s%s[-][/c]", ItemTipBanRedColorStr, ZhString.ItemTip_NoEffectTip)
      }
      self:ResetAttriDatas()
    end
  else
    self.contextDatas[ItemTipAttriType.NoEffectTip] = nil
    self:ResetAttriDatas()
  end
end
function ItemTipBaseCell:AddOtherTip(index, labels, hideline, refresh)
  local otherTip = {}
  otherTip.label = labels
  otherTip.hideline = hideline
  self.contextDatas[index] = otherTip
  if refresh then
    self:ResetAttriDatas()
  end
end
local centerBottomAdaption = {ItemNewCellForTips = -139}
function ItemTipBaseCell:ActiveCountChooseBord(b, countChoose_maxCount)
  if self.countChooseBord == nil then
    return
  end
  local itemCellControlName = self.itemcell and self.itemcell.__cname
  local centerBottomLocalY = centerBottomAdaption[itemCellControlName] or -90
  if b then
    self.countChoose_maxCount = countChoose_maxCount
    self.countChooseBord:SetActive(true)
    self.countChoose_CountInput.value = self.chooseCount
  else
    self.countChooseBord:SetActive(false)
    centerBottomLocalY = centerBottomLocalY - 55
  end
  if self.centerBottom then
    self.centerBottom.transform.localPosition = LuaGeometry.GetTempVector3(0, centerBottomLocalY, 0)
  end
end
function ItemTipBaseCell:Exit()
  TimeTickManager.Me():ClearTick(self, 11)
  TimeTickManager.Me():ClearTick(self, 12)
end
function ItemTipBaseCell:InitEvent()
  self:AddGameObjectComp()
  if self.isEvent_Add == true then
    return
  end
  self.isEvent_Add = true
  EventManager.Me():AddEventListener(ItemTradeEvent.TradePriceChange, self.UpdateTradePrice, self)
  EventManager.Me():AddEventListener(ServiceEvent.ItemUseCountItemCmd, self.UpdateUseLimit, self)
  EventManager.Me():AddEventListener(ServiceEvent.ItemGetCountItemCmd, self.UpdateGetLimit, self)
  EventManager.Me():AddEventListener(ServiceEvent.ItemUseCodItemCmd, self.UpdateGetCodItem, self)
end
function ItemTipBaseCell:UpdateTradePrice(evt)
  if Slua.IsNull(self.gameObject) then
    self:Exit()
    return
  end
  local data = evt.data
  if self.data then
    local key = FunctionItemTrade.Me():CombineItemKey(self.data)
    local id, price = data.id, data.price
    if id == key then
      local tradeData = self.contextDatas[ItemTipAttriType.TradePrice]
      if tradeData then
        if price == 0 then
          tradeData.label = ZhString.ItemTip_TradePrice .. ZhString.ItemTip_TradePriceWait
        else
          tradeData.label = string.format("%s{priceicon=100,%s}", ZhString.ItemTip_TradePrice, price)
        end
      end
      self:ResetAttriDatas(false)
    end
  end
end
function ItemTipBaseCell:UpdateUseLimit(evt)
  local data = evt.data
  local itemid, count = data.itemid, data.count
  if self.data and self.data.staticData.id ~= itemid then
    return
  end
  local useData = Table_UseItem[itemid]
  local useLimitData = self.contextDatas[ItemTipAttriType.UseLimit]
  if useLimitData and useData and (useData.WeekLimit or useData.DailyLimit) then
    if useData.WeekLimit then
      useLimitData.label = self.hasMonthVIP and ZhString.ItemTip_MonthNoLimit or string.format(ZhString.ItemTip_UseTimeWeekLimit, count, useData.WeekLimit)
    elseif useData.DailyLimit then
      useLimitData.label = string.format(ZhString.ItemTip_UseTimeDayLimit, count, useData.DailyLimit)
    end
    self:ResetAttriDatas()
  end
end
function ItemTipBaseCell:UpdateGetLimit(evt)
  local data = evt.data
  local itemid, count = data.itemid, data.count
  if self.data == nil or self.data.staticData.id ~= itemid then
    return
  end
  local sData = self.data.staticData
  local getLimitData = self.contextDatas[ItemTipAttriType.UseLimit]
  if getLimitData then
    local limitCount = ItemData.Get_GetLimitCount(sData.id)
    if LimitCheckCfg and LimitCheckCfg[sData.id] then
      local lv, effectID = 0, nil
      local effectConfig = LimitCheckCfg[sData.id]
      for i = 1, #effectConfig do
        lv = TechTreeProxy.Instance:GetCurLevelOfLeaf(effectConfig[i].leafid)
        if lv then
          for j = 1, lv do
            effectID = effectConfig[i].effectIDs[j]
            local params = Table_TechTreeEffect[effectID].Params
            for k = 1, #params do
              if params[k].extra_count then
                limitCount = limitCount + params[k].extra_count
              end
            end
          end
        end
      end
    end
    getLimitData.label = string.format("%s%s %s/%s", ItemData.GetLimitPrefixFromCfg(sData.GetLimit), ZhString.ItemTip_GetLimit, count, limitCount)
    self:ResetAttriDatas()
  end
end
function ItemTipBaseCell:UpdateGetCodItem(data)
  if self.data == nil then
    return
  end
  self.contextDatas[ItemTipAttriType.Code] = {
    label = string.format(ZhString.ItemTip_Code_Desc, data.code)
  }
  self:ResetAttriDatas()
end
function ItemTipBaseCell:OnDestroy()
  self:RemoveEvent()
  TableUtility.TableClear(self)
end
function ItemTipBaseCell:RemoveEvent()
  if self.isEvent_Add ~= true then
    return
  end
  self.isEvent_Add = false
  EventManager.Me():RemoveEventListener(ItemTradeEvent.TradePriceChange, self.UpdateTradePrice, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.ItemUseCountItemCmd, self.UpdateUseLimit, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.ItemGetCountItemCmd, self.UpdateGetLimit, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.ItemUseCodItemCmd, self.UpdateGetCodItem, self)
end
function ItemTipBaseCell:OnDisable()
end
function ItemTipBaseCell:ShowMonsterlvTip()
  if self.data and self.data.staticData and self.data.staticData.MonsterLevel then
    local data = {}
    data.label = string.format(ZhString.ItemTip_MonsterLVTip, self.data.staticData.MonsterLevel)
    self.contextDatas[ItemTipAttriType.MonsterLevel] = data
    self:ResetAttriDatas()
  end
end
function ItemTipBaseCell.FormatBufferStr(bufferId, hideIcon)
  local str = ItemUtil.getBufferDescById(bufferId)
  if hideIcon then
    return str
  end
  local sb, result = LuaStringBuilder.CreateAsTable()
  local bufferStrs = string.split(str, "\n")
  for m = 1, #bufferStrs do
    sb:Append(ItemTipDefaultUiIconPrefix)
    sb:Append(" ")
    sb:Append(bufferStrs[m])
    if m < #bufferStrs then
      sb:Append("\n")
    end
  end
  if sb:GetCount() > 0 then
    result = sb:ToString()
  end
  sb:Destroy()
  return result
end
function ItemTipBaseCell.FormatRandomEffectStr(randomEffectId, value, hideIcon, showMaxAttrPrompt)
  local sData = Table_EquipEffect[randomEffectId]
  if not sData then
    return
  end
  local tAttrType, attrType = type(sData.AttrType)
  if tAttrType == "string" then
    attrType = sData.AttrType
  elseif tAttrType == "table" then
    attrType = tostring(sData.AttrType[1])
  end
  local attrConfig = Game.Config_PropName[attrType]
  if not attrConfig then
    LogUtility.WarningFormat("Cannot find prop data by name = {0} with id = {1}", attrType or "", randomEffectId)
    return
  end
  value = value and math.abs(value) or 0
  local str = string.format(OverSea.LangManager.Instance():GetLangByKey(sData.Dsc), attrConfig.IsPercent == 1 and value * 100 .. "%" or value)
  if showMaxAttrPrompt and sData.AttrRate and 0 < #sData.AttrRate then
    local maxValue = sData.AttrRate[#sData.AttrRate][1]
    str = str .. string.format(OverSea.LangManager.Instance():GetLangByKey(ZhString.ItemTip_MaxRandomAttrValue), attrConfig.IsPercent == 1 and maxValue * 100 .. "%" or maxValue)
  end
  return hideIcon and str or string.format("%s %s", ItemTipDefaultUiIconPrefix, str)
end
function ItemTipBaseCell.GetEquipDecomposeTip(equipInfo)
  if not equipInfo then
    return
  end
  local decomposeId = equipInfo.equipData.DecomposeID
  if decomposeId then
    return {
      label = string.format(ZhString.ItemTip_DecomposeLv, Table_EquipDecompose[decomposeId].NameZh)
    }
  end
end
function ItemTipBaseCell.GetItemType(itemStaticData)
  local typedata = Table_ItemType[itemStaticData.Type]
  if typedata and typedata.Name then
    local typeStr = {
      label = ItemUtil.GetItemTypeName(itemStaticData.Type)
    }
    if ItemTipBaseCell.ShowHelpInfoPredicate(itemStaticData.id) then
      typeStr.helpInfoItemId = itemStaticData.id
    end
    return typeStr
  end
end
function ItemTipBaseCell.ShowHelpInfoPredicate(id)
  return BranchMgr.IsJapan() and Table_Checkrate ~= nil and id ~= nil and Table_Checkrate[id] ~= nil
end
function ItemTipBaseCell.GetPersonalArtifactAttriByItemData(itemData)
  if not itemData:IsPersonalArtifact() then
    return
  end
  local data = itemData.personalArtifactData
  if not data then
    return
  end
  if data.isInited then
    local s = data:GetAttriDesc()
    if not StringUtil.IsEmpty(s) then
      return {label = s}
    end
  end
end
local Check_CAN_strength = function(itemData)
  local equipInfo = itemData.equipInfo
  if not equipInfo then
    return
  end
  local flag_InRoleEquip = itemData.equiped == 1
  if flag_InRoleEquip and equipInfo:CanStrength() then
    return true
  end
end
local miyin_refine_equiptype = {
  8,
  9,
  10,
  11,
  13
}
local should_miyin_refine = function(itemData)
  local equipInfo = itemData.equipInfo
  if not equipInfo then
    return
  end
  if TableUtility.ArrayFindIndex(miyin_refine_equiptype, equipInfo.equipData.EquipType) > 0 then
    return true
  end
end
local Check_CAN_refine = function(itemData)
  local equipInfo = itemData.equipInfo
  if not equipInfo then
    return
  end
  local flag_InRoleEquip = itemData.equiped == 1
  local flag_InMainBag = BagProxy.Instance:GetItemByGuid(itemData.id, BagProxy.BagType.MainBag) ~= nil
  if flag_InRoleEquip or flag_InMainBag then
    local typeMap = BlackSmithProxy.GetRefineEquipTypeMap()
    if typeMap[equipInfo.equipData.EquipType] ~= nil and equipInfo:CanRefine() then
      return true
    end
  end
end
local Check_CAN_miyinrefine = function(itemData)
  local equipInfo = itemData.equipInfo
  if not equipInfo then
    return
  end
  local flag_InRoleEquip = itemData.equiped == 1
  local flag_InMainBag = BagProxy.Instance:GetItemByGuid(itemData.id, BagProxy.BagType.MainBag) ~= nil
  if (flag_InRoleEquip or flag_InMainBag) and TableUtility.ArrayFindIndex(miyin_refine_equiptype, equipInfo.equipData.EquipType) > 0 and equipInfo:CanRefine() then
    return true
  end
end
local EquipTypeSite_miyinsewing = {}
local Check_CAN_miyinsewing = function(itemData)
  if #EquipTypeSite_miyinsewing == 0 then
    for _, v in pairs(Table_GuildBuilding) do
      if v.Type == GuildBuildingProxy.Type.EGUILDBUILDING_MAGIC_SEWING then
        TableUtility.TableShallowCopy(EquipTypeSite_miyinsewing, v.UnlockParam.equip.strength_pos)
        break
      end
    end
  end
  local equipInfo = itemData.equipInfo
  if not equipInfo then
    return
  end
  local flag_InRoleEquip = itemData.equiped == 1
  if not flag_InRoleEquip then
    return
  end
  local siteConfig = GameConfig.EquipType[equipInfo.equipData.EquipType]
  local pos = siteConfig and siteConfig.site[1]
  if TableUtility.ArrayFindIndex(EquipTypeSite_miyinsewing, pos) == 0 then
    return
  end
  local siteData = StrengthProxy.Instance:GetStrengthenData(SceneItem_pb.ESTRENGTHTYPE_GUILD, pos)
  return siteData ~= nil, siteData
end
local EquipTypeSite_hrefine = {}
local Check_CAN_hrefine = function(itemData)
  local equipInfo = itemData.equipInfo
  if not equipInfo then
    return
  end
  local flag_InRoleEquip = itemData.equiped == 1
  if not flag_InRoleEquip then
    return
  end
  local siteConfig = GameConfig.EquipType[equipInfo.equipData.EquipType]
  local pos = siteConfig and siteConfig.site[1]
  local data, showlvType = BlackSmithProxy.Instance:GetShowHRefineDatas(pos)
  if not data or not showlvType or showlvType == 0 then
    return
  end
  local lv = BlackSmithProxy.Instance:GetPlayerHRefineLevel(pos, showlvType)
  local max_lv = BlackSmithProxy.Instance:GetMaxHRefineTypeOrLevel(pos, showlvType)
  return true, lv, max_lv
end
function ItemTipBaseCell.GetEquipStrengthRefineByItemData(itemData, vstrColorStr, equipBuffUpSource)
  local equipInfo = itemData.equipInfo
  if not equipInfo then
    return
  end
  local strengRefine, newLineChar = {
    label = {}
  }, "; "
  local strengthInfo, strengthLv, maxLv = StrengthProxy.Instance:GetEquipStrengthInfoByPlayer(equipBuffUpSource, itemData, newLineChar)
  local UNLOCK_strength = FunctionNpcFunc.CheckLv_strengthen()
  local CAN_strength = Check_CAN_strength(itemData)
  local SHOWBTN_strength = false
  local label
  if not StringUtil.IsEmpty(strengthInfo) and strengthLv > 0 then
    SHOWBTN_strength = true
    if BagProxy.Instance:GetItemByGuid(itemData.id) ~= nil then
      label = string.format(ZhString.ItemTip_StrengthLv, strengthLv, maxLv, strengthInfo)
      SHOWBTN_strength = strengthLv < maxLv
    else
      label = string.format(ZhString.ItemTip_StrengthLv_NoMax, strengthLv, strengthInfo)
    end
  elseif not StringUtil.IsEmpty(strengthInfo) and UNLOCK_strength and CAN_strength then
    SHOWBTN_strength = true
    if BagProxy.Instance:GetItemByGuid(itemData.id) ~= nil then
      label = string.format(ZhString.ItemTip_StrengthLv, 0, maxLv, ZhString.ItemTip_NoAttrYet)
    else
      label = string.format(ZhString.ItemTip_StrengthLv_NoMax, 0, ZhString.ItemTip_NoAttrYet)
    end
  end
  if label then
    SHOWBTN_strength = _SHOWBTN_ and SHOWBTN_strength
    if SHOWBTN_strength then
      label = label .. "{inlinebutton=tab_icon_18_s,k_strength}"
    end
    TableUtility.ArrayPushBack(strengRefine.label, label)
  end
  local UNLOCK_miyinsewing = FunctionNpcFunc.CheckSewing()
  local CAN_miyinsewing, siteData = Check_CAN_miyinsewing(itemData)
  local SHOWBTN_miyinsewing = false
  local label
  if CAN_miyinsewing then
    local currentLv = siteData.lv
    local levelMax = StrengthProxy.Instance:MaxStrengthLevel(SceneItem_pb.ESTRENGTHTYPE_GUILD)
    local additionalAttrs = ItemFun.calcStrengthAttr(siteData.site, currentLv)
    if next(additionalAttrs) then
      local effects = {}
      for k, v in pairs(additionalAttrs) do
        local data = {}
        data.name = Table_RoleData[k].VarName
        data.value = v
        table.insert(effects, data)
      end
      label = string.format(ZhString.ItemTip_StrengthLv2, currentLv, PropUtil.FormatEffects(effects, 1, " +", vstrColorStr))
      SHOWBTN_miyinsewing = currentLv < levelMax
    elseif UNLOCK_miyinsewing then
      label = string.format(ZhString.ItemTip_StrengthLv2, 0, ZhString.ItemTip_NoAttrYet)
      SHOWBTN_miyinsewing = true
    end
  end
  if label then
    SHOWBTN_miyinsewing = _SHOWBTN_ and SHOWBTN_miyinsewing
    if SHOWBTN_miyinsewing then
      label = label .. "{inlinebutton=tab_icon_sewing_s,k_miyinsewing}"
    end
    TableUtility.ArrayPushBack(strengRefine.label, label)
  end
  local withLimitRefineUpLv, withoutLimitRefineUpLv = itemData:GetRefineBuffUpLevel(equipBuffUpSource)
  local refineLv, maxRefineLv = BlackSmithProxy.CalculateBuffUpLevel(equipInfo.refinelv, BlackSmithProxy.Instance:MaxRefineLevelByData(itemData.staticData), withLimitRefineUpLv, withoutLimitRefineUpLv)
  local should_miyin_refine = should_miyin_refine(itemData)
  local UNLOCK_refine = FunctionNpcFunc.CheckLv_Refine()
  local CAN_refine = Check_CAN_refine(itemData)
  local UNLOCK_miyinrefine = FunctionNpcFunc.CheckSewing()
  local CAN_miyinrefine = Check_CAN_miyinrefine(itemData)
  local SHOWBTN_miyinrefine = false
  local SHOWBTN_refine = false
  if should_miyin_refine then
    if refineLv > 0 or CAN_miyinrefine then
      refineLv = math.max(refineLv, 0)
      local refineEffect, refineTxt = equipInfo.equipData.RefineEffect, ""
      for propKey, v in pairs(refineEffect) do
        if not StringUtil.IsEmpty(refineTxt) then
          refineTxt = refineTxt .. "; "
        end
        local proName, proV = GameConfig.EquipEffect[propKey], v * refineLv
        local pro = RolePropsContainer.config[propKey]
        if pro and pro.isPercent then
          refineTxt = refineTxt .. EquipProps.MakeStr(proName, " +", string.format("%s%%", proV * 100), vstrColorStr)
        else
          refineTxt = refineTxt .. EquipProps.MakeStr(proName, " +", proV, vstrColorStr)
        end
      end
      local label
      if not StringUtil.IsEmpty(refineTxt) and refineLv > 0 then
        if ItemUtil.IsGVGSeasonEquip(equipInfo.equipData.id) then
          maxRefineLv = refineLv
          if Game.MapManager:IsInGVGRaid() then
            _zhstring = ZhString.ItemTip_RefineLv
          else
            _zhstring = ZhString.ItemTip_RefineLv_GVGSeasonEquip
          end
        else
          _zhstring = ZhString.ItemTip_RefineLv
        end
        label = string.format(_zhstring, refineLv, maxRefineLv, refineTxt)
      else
        label = string.format(ZhString.ItemTip_RefineLv, refineLv, maxRefineLv, ZhString.ItemTip_NoAttrYet)
      end
      SHOWBTN_refine = refineLv < maxRefineLv
      if label then
        SHOWBTN_miyinrefine = _SHOWBTN_ and SHOWBTN_refine
        if SHOWBTN_miyinrefine then
          label = label .. "{inlinebutton=tab_icon_86_s,k_miyinrefine}"
        end
        TableUtility.ArrayPushBack(strengRefine.label, label)
      end
    end
  elseif refineLv > 0 or CAN_refine then
    refineLv = math.max(refineLv, 0)
    local refineEffect, refineTxt = equipInfo.equipData.RefineEffect, ""
    for propKey, v in pairs(refineEffect) do
      if not StringUtil.IsEmpty(refineTxt) then
        refineTxt = refineTxt .. "; "
      end
      local proName, proV = GameConfig.EquipEffect[propKey], v * refineLv
      local pro = RolePropsContainer.config[propKey]
      if pro and pro.isPercent then
        refineTxt = refineTxt .. EquipProps.MakeStr(proName, " +", string.format("%s%%", proV * 100), vstrColorStr)
      else
        refineTxt = refineTxt .. EquipProps.MakeStr(proName, " +", proV, vstrColorStr)
      end
    end
    local label
    if not StringUtil.IsEmpty(refineTxt) and refineLv > 0 then
      if ItemUtil.IsGVGSeasonEquip(equipInfo.equipData.id) then
        maxRefineLv = refineLv
        if Game.MapManager:IsInGVGRaid() then
          _zhstring = ZhString.ItemTip_RefineLv
        else
          _zhstring = ZhString.ItemTip_RefineLv_GVGSeasonEquip
        end
      else
        _zhstring = ZhString.ItemTip_RefineLv
      end
      label = string.format(_zhstring, refineLv, maxRefineLv, refineTxt)
    else
      label = string.format(ZhString.ItemTip_RefineLv, refineLv, maxRefineLv, ZhString.ItemTip_NoAttrYet)
    end
    SHOWBTN_refine = refineLv < maxRefineLv
    if label then
      SHOWBTN_refine = _SHOWBTN_ and SHOWBTN_refine
      if SHOWBTN_refine then
        label = label .. "{inlinebutton=tab_icon_86_s,k_refine}"
      end
      TableUtility.ArrayPushBack(strengRefine.label, label)
    end
  end
  local hrefinesb = LuaStringBuilder.CreateAsTable()
  local UNLOCK_hrefine = FunctionNpcFunc.CheckHighRefine() == NpcFuncState.Active
  local CAN_hrefine, curLv, maxLv = Check_CAN_hrefine(itemData)
  local SHOWBTN_hrefine = false
  if itemData.equiped == 1 and CAN_hrefine then
    local siteConfig = GameConfig.EquipType[equipInfo.equipData.EquipType]
    local hrEffectMap = BlackSmithProxy.Instance:GetMyHRefineEffectMap(siteConfig and siteConfig.site[1], refineLv)
    local PropNameConfig = Game.Config_PropName
    for proKey, proV in pairs(hrEffectMap) do
      if proV ~= 0 then
        if 0 < hrefinesb:GetCount() then
          hrefinesb:Append("\n")
        end
        hrefinesb:Append(string.format(ZhString.ItemTip_HRefineAddEffect, EquipProps.MakeStr(GameConfig.EquipEffect[proKey] or "", " +", PropNameConfig[proKey].IsPercent == 1 and proV * 100 .. "%" or proV, vstrColorStr)))
      end
    end
    if 0 < hrefinesb:GetCount() then
      SHOWBTN_hrefine = curLv ~= nil and maxLv ~= nil and curLv < maxLv
    elseif UNLOCK_hrefine then
      hrefinesb:Append(string.format(ZhString.ItemTip_HRefineAddEffect, ZhString.ItemTip_NoAttrYet, vstrColorStr))
      SHOWBTN_hrefine = curLv ~= nil and maxLv ~= nil and curLv < maxLv
    end
  end
  if SHOWBTN_hrefine then
    SHOWBTN_hrefine = _SHOWBTN_ and SHOWBTN_hrefine
    if SHOWBTN_hrefine then
      hrefinesb:Append("{inlinebutton=tab_icon_149_s,k_hrefine}")
    end
  end
  if 0 < hrefinesb:GetCount() then
    TableUtility.ArrayPushBack(strengRefine.label, hrefinesb:ToString())
  end
  hrefinesb:Destroy()
  if SHOWBTN_strength or SHOWBTN_miyinsewing or SHOWBTN_refine or SHOWBTN_miyinrefine or SHOWBTN_hrefine then
    strengRefine.labelConfig = {
      iconWidth = 36,
      iconheight = 36,
      width = -36
    }
    strengRefine.inlineBtnExtraOffset = {0, 0}
    function strengRefine.inlineBtnCb(key)
      if key == "k_strength" then
        if not UNLOCK_strength then
          MsgManager.ShowMsgByID(43256)
        elseif not CAN_strength then
          MsgManager.FloatMsgTableParam(nil, "CAN_strength Check ERROR!")
        else
          FunctionNpcFunc.strengthen(nil, {
            OnClickChooseBordCell_index = itemData.index
          })
        end
      elseif key == "k_miyinsewing" then
        if not UNLOCK_miyinsewing then
          if not GuildProxy.Instance:IHaveGuild() then
            GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
              view = PanelConfig.GuildInfoView
            })
          else
            MsgManager.ShowMsgByID(43277)
          end
        elseif not CAN_miyinsewing then
          MsgManager.FloatMsgTableParam(nil, "CAN_miyinsewing Check ERROR!")
        else
          FuncShortCutFunc.Me():CallByID(GameConfig.EquipGreenWay.EquipmentReinforcement)
        end
      elseif key == "k_refine" then
        if not UNLOCK_refine then
          MsgManager.ShowMsgByID(43257)
        else
          if Game.MapManager:IsRaidMode(true) then
            local isSpecial = false
            local exceptRaid = GameConfig.EquipRefine.RefineRaidMap
            if exceptRaid then
              local raidID = Game.MapManager:GetRaidID()
              if 0 ~= TableUtility.ArrayFindIndex(exceptRaid, raidID) then
                isSpecial = true
              end
            end
            if not isSpecial then
              MsgManager.ShowMsgByIDTable(43193)
              return
            end
          end
          FunctionNpcFunc.Refine(nil, {OnClickChooseBordCell_data = itemData}, nil, true)
        end
      elseif key == "k_miyinrefine" then
        if not UNLOCK_miyinrefine then
          if not GuildProxy.Instance:IHaveGuild() then
            GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
              view = PanelConfig.GuildInfoView
            })
          else
            MsgManager.ShowMsgByID(43277)
          end
        elseif not CAN_miyinrefine then
          MsgManager.FloatMsgTableParam(nil, "CAN_miyinrefine Check ERROR!")
        else
          FuncShortCutFunc.Me():CallByID(GameConfig.EquipGreenWay.EquipmentReinforcement)
        end
      elseif key == "k_hrefine" then
        if not UNLOCK_hrefine then
          if not GuildProxy.Instance:IHaveGuild() then
            GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
              view = PanelConfig.GuildInfoView
            })
          else
            MsgManager.ShowMsgByID(43277)
          end
        elseif not CAN_hrefine then
          MsgManager.FloatMsgTableParam(nil, "CAN_hrefine Check ERROR!")
        else
          FuncShortCutFunc.Me():CallByID(GameConfig.EquipGreenWay.IntensiveRefining)
        end
      end
    end
  end
  if next(strengRefine.label) then
    return strengRefine
  end
end
local gvgSeasonEquipMap = GameConfig.GVGConfig and GameConfig.GVGConfig.season_equip
function ItemTipBaseCell.CheckGvgSeasonEquipInvalid(equip_id)
  return ItemUtil.IsGVGSeasonEquip(equip_id) and not Game.MapManager:IsInGVGRaid()
end
function ItemTipBaseCell.GetEquipBaseAttriByItemData(itemData, hideIcon, vstrColorStr)
  local equipInfo = itemData.equipInfo
  if not equipInfo then
    return
  end
  local propMap = Game.Config_PropName
  local effect, baseEffect = equipInfo.equipData.Effect, {}
  for k, v in pairs(effect) do
    if propMap[k] then
      local vstr = propMap[k].IsPercent == 1 and v * 100 .. "%" or v
      if vstrColorStr then
        vstr = string.format("[c][%s]+%s[-][/c]", vstrColorStr, vstr)
      else
        vstr = "+" .. vstr
      end
      local propicon = ItemTipPropIcon[propMap[k].VarName]
      local iconname = propicon and string.format("{uiicon=%s}", propicon)
      local templab = string.format("%s%s%s", iconname or ItemTipDefaultUiIconPrefix, OverSea.LangManager.Instance():GetLangByKey(propMap[k].PropName), vstr)
      table.insert(baseEffect, {
        propMap[k].id,
        templab
      })
    end
  end
  local lotterData = LotteryProxy.Instance:GetEquipLotteryShowDatas(itemData.staticData.id)
  if lotterData then
    for k, v in pairs(lotterData.Attr) do
      if propMap[k] then
        local vstr = propMap[k].IsPercent == 1 and v * 100 .. "%" or v
        if vstrColorStr then
          vstr = string.format("[c][%s]+%s[-][/c]", vstrColorStr, vstr)
        else
          vstr = "+" .. vstr
        end
        local templab = string.format("%s%s%s", hideIcon and "" or ItemTipDefaultUiIconPrefix, propMap[k].PropName, vstr)
        table.insert(baseEffect, {
          propMap[k].id,
          templab
        })
      end
    end
  end
  if #baseEffect > 0 then
    table.sort(baseEffect, ItemTipBaseCell.EffectSort)
    local sb, effStr = LuaStringBuilder.CreateAsTable()
    for i = 1, #baseEffect do
      effStr = baseEffect[i][2]
      if i < #baseEffect then
        sb:AppendLine(effStr)
      else
        sb:Append(effStr)
      end
    end
    if 0 < sb:GetCount() then
      local str = sb:ToString()
      sb:Destroy()
      return {label = str}
    end
    sb:Destroy()
  end
end
function ItemTipBaseCell.GetEquipPvpBaseAttri(equipInfo, hideIcon, vstrColorStr)
  if not equipInfo then
    return
  end
  local propMap = Game.Config_PropName
  local pvpeffect = equipInfo.equipData.PVPEffect
  if pvpeffect then
    local pvpBaseEffect = {}
    for k, v in pairs(pvpeffect) do
      if propMap[k] then
        local vstr = propMap[k].IsPercent == 1 and v * 100 .. "%" or v
        if vstrColorStr then
          vstr = string.format("[c][%s]+%s[-][/c]", vstrColorStr, vstr)
        else
          vstr = "+" .. vstr
        end
        local propicon = ItemTipPropIcon[propMap[k].VarName]
        local iconprefix = hideIcon and "" or propicon and string.format("{uiicon=%s}", propicon) or ItemTipDefaultUiIconPrefix
        local templab = string.format("%s%s%s", iconprefix, propMap[k].PropName, vstr)
        table.insert(pvpBaseEffect, {
          propMap[k].id,
          templab
        })
      end
    end
    local pvp_uniqueEffect = equipInfo:GetPvpUniqueEffect()
    if #pvpBaseEffect > 0 or pvp_uniqueEffect and #pvp_uniqueEffect > 0 then
      local isActive = Game.MapManager:IsPVPMode() or Game.MapManager:IsPVPMode_GVGDetailed()
      table.sort(pvpBaseEffect, ItemTipBaseCell.EffectSort)
      local pvpBase = {
        label = {
          ZhString.ItemTip_PvpEquipTip
        }
      }
      local sb, effStr, id = LuaStringBuilder.CreateAsTable()
      for i = 1, #pvpBaseEffect do
        effStr = isActive and pvpBaseEffect[i][2] or string.format("[c]%s%s[/c]", ItemTipInactiveColorStr, pvpBaseEffect[i][2])
        if i < #pvpBaseEffect then
          sb:AppendLine(effStr)
        else
          sb:Append(effStr)
        end
      end
      table.insert(pvpBase.label, sb:ToString())
      sb:Clear()
      if pvp_uniqueEffect and #pvp_uniqueEffect > 0 then
        for i = 1, #pvp_uniqueEffect do
          id = pvp_uniqueEffect[i].id
          effStr = isActive and ItemTipBaseCell.FormatBufferStr(id, hideIcon) or string.format("[c]%s%s[/c]", ItemTipInactiveColorStr, ItemTipBaseCell.FormatBufferStr(id, hideIcon))
          if i < #pvp_uniqueEffect then
            sb:AppendLine(effStr)
          else
            sb:Append(effStr)
          end
        end
        if 0 < sb:GetCount() then
          table.insert(pvpBase.label, sb:ToString())
        end
      end
      sb:Destroy()
      return pvpBase
    end
  end
end
function ItemTipBaseCell.GetEquipSpecial(equipInfo, hideIcon)
  if not equipInfo then
    return
  end
  local uniqueEffect = equipInfo:GetUniqueEffect()
  if uniqueEffect and #uniqueEffect > 0 then
    local special = {
      label = {}
    }
    local sb, id = LuaStringBuilder.CreateAsTable()
    for i = 1, #uniqueEffect do
      id = uniqueEffect[i].id
      sb:Append(ItemTipBaseCell.FormatBufferStr(id, hideIcon))
      if i < #uniqueEffect then
        sb:Append("\n")
      end
    end
    if 0 < sb:GetCount() then
      table.insert(special.label, sb:ToString())
      sb:Destroy()
      if ItemTipBaseCell.CheckGvgSeasonEquipInvalid(equipInfo.equipData.id) then
        special.color = ItemTipEquipAttriVStrColorStr_OnlyGvgValid
      end
      return special
    end
    sb:Destroy()
  end
end
function ItemTipBaseCell.GetEquipRandomAttri(equipInfo, hideIcon)
  if not equipInfo or not equipInfo:IsNextGen() then
    return
  end
  local data = {
    tiplabel = ZhString.ItemTip_RandomEffect,
    label = {}
  }
  if equipInfo.isFromShop then
    data.locked = true
    return data
  elseif equipInfo.isRandomPreview then
    data = ItemTipBaseCell.SetEquipRandomAttriPreview(data, equipInfo, hideIcon)
    return data
  end
  local list = equipInfo:GetRandomEffectList()
  if not list or not next(list) then
    return
  end
  local sb = LuaStringBuilder.CreateAsTable()
  for i = 1, #list do
    sb:Append(ItemTipBaseCell.FormatRandomEffectStr(list[i].id, list[i].value, hideIcon, true))
    if i < #list then
      sb:Append("\n")
    end
  end
  if sb:GetCount() > 0 then
    table.insert(data.label, sb:ToString())
    sb:Destroy()
    return data
  end
  sb:Destroy()
end
local selectAbsMaxRate = function(attrRate)
  local max, v = 0, nil
  if attrRate then
    for i = 1, #attrRate do
      v = math.abs(attrRate[i][1])
      if max < v then
        max = v
      end
    end
  end
  return max
end
function ItemTipBaseCell.SetEquipRandomAttriPreview(data, equipInfo, hideIcon)
  local effects = BagProxy.Instance:GetStaticEquipRandomEffectData(equipInfo.equipData.id)
  if not effects then
    return
  end
  local inevitableEffects, sb, eff, value, tAttrType, attrType, attrConfig = ReusableTable.CreateArray(), LuaStringBuilder.CreateAsTable()
  for i = 1, #effects do
    eff = effects[i]
    if eff.GroupID == 1 then
      sb:Append(ItemTipBaseCell.FormatRandomEffectStr(eff.id, selectAbsMaxRate(eff.AttrRate), hideIcon))
      sb:Append("\n")
    else
      table.insert(inevitableEffects, eff)
    end
  end
  if sb:GetCount() > 0 then
    if sb.content[sb:GetCount()] == "\n" then
      sb:RemoveLast()
    end
    table.insert(data.label, sb:ToString())
    sb:Destroy()
    table.insert(data.label, GameConfig.ItemRandomEntry.RandomEntry_1)
  end
  for i = 1, #inevitableEffects do
    eff = inevitableEffects[i]
    tAttrType = type(eff.AttrType)
    if tAttrType == "string" then
      attrType = eff.AttrType
    elseif tAttrType == "table" then
      attrType = tostring(eff.AttrType[1])
    end
    attrConfig = Game.Config_PropName[attrType]
    value = selectAbsMaxRate(eff.AttrRate)
    table.insert(data.label, string.format(GameConfig.ItemRandomEntry.RandomEntry_2, string.format(OverSea.LangManager.Instance():GetLangByKey(eff.Dsc), attrConfig.IsPercent == 1 and value * 100 .. "%" or value)))
  end
  ReusableTable.DestroyAndClearArray(inevitableEffects)
  return data
end
local Check_CAN_enchant = function(itemData)
  local equipInfo = itemData.equipInfo
  if not equipInfo then
    return
  end
  local flag_InRoleEquip = itemData.equiped == 1
  local flag_InMainBag = BagProxy.Instance:GetItemByGuid(itemData.id, BagProxy.BagType.MainBag) ~= nil
  if (flag_InRoleEquip or flag_InMainBag) and equipInfo:CanEnchant() then
    return true
  end
end
function ItemTipBaseCell.GetEquipEnchant(data, showFullAttr, equipBuffUpSource)
  local enchantInfo = data and data.enchantInfo
  if not enchantInfo then
    return
  end
  local attris, attriData = enchantInfo:GetEnchantAttrs()
  local UNLOCK_enchant = FunctionUnLockFunc.Me():CheckCanOpen(73)
  local CAN_enchant = Check_CAN_enchant(data)
  if #attris == 0 and (not UNLOCK_enchant or not CAN_enchant) then
    return
  end
  local enchant = {
    tiplabel = ZhString.ItemTip_Enchant,
    namevaluepair = {}
  }
  for i = 1, #attris do
    attriData = attris[i]
    table.insert(enchant.namevaluepair, {
      name = attriData.name,
      value = string.format(attriData.propVO.isPercent and "+%s%%" or "+%s", attriData.value)
    })
  end
  local combineEffects, sb, combineEffect, buffData, isWork = enchantInfo:GetCombineEffects(), LuaStringBuilder.CreateAsTable()
  for i = 1, #combineEffects do
    combineEffect = combineEffects[i]
    buffData = combineEffect and combineEffect.buffData
    if buffData then
      if 0 < sb:GetCount() then
        sb:Append("\n")
      end
      isWork = combineEffect.isWork or showFullAttr
      local canshowRefineBuffUpLv = equipBuffUpSource and BlackSmithProxy.CheckShowRefineBuffUpLevel(data, equipBuffUpSource)
      canshowRefineBuffUpLv = canshowRefineBuffUpLv or ItemUtil.IsGVGSeasonEquip(enchantInfo.itemId)
      if not isWork and canshowRefineBuffUpLv then
        local withLimitBuffUpLv, withoutLimitBuffUpLv = data:GetRefineBuffUpLevel(equipBuffUpSource)
        isWork = EnchantInfo.CombineEffectWorkPredicate(combineEffect, (BlackSmithProxy.CalculateBuffUpLevel(data.equipInfo.refinelv, BlackSmithProxy.Instance:MaxRefineLevelByData(data.staticData), withLimitBuffUpLv, withoutLimitBuffUpLv)))
      end
      if isWork then
        sb:Append(buffData.BuffName)
        sb:Append(":")
        sb:Append(buffData.BuffDesc)
      else
        sb:Append("[c]")
        sb:Append(ItemTipInactiveColorStr)
        sb:Append(buffData.BuffName)
        sb:Append(":")
        sb:Append(buffData.BuffDesc)
        sb:Append("(")
        sb:Append(combineEffect.WorkTip)
        sb:Append(")[-][/c]")
      end
    end
  end
  if 0 < sb:GetCount() then
    table.insert(enchant.namevaluepair, {
      name = sb:ToString()
    })
  end
  sb:Destroy()
  if #enchant.namevaluepair == 0 then
    table.insert(enchant.namevaluepair, {
      locked = ZhString.ItemTip_UnlockAfterEnchant
    })
  end
  if _SHOWBTN_ then
    enchant.aTipInlineButton = {
      sprite = "tab_icon_enchant_s",
      showSubMark = true,
      action = function()
        if not CAN_enchant then
          MsgManager.FloatMsgTableParam(nil, "CAN_enchant Check ERROR!")
          return
        end
        if UNLOCK_enchant then
          if Game.MapManager:IsRaidMode(true) then
            local isSpecial = false
            local exceptRaid = GameConfig.EquipRefine.RefineRaidMap
            if exceptRaid then
              local raidID = Game.MapManager:GetRaidID()
              if 0 ~= TableUtility.ArrayFindIndex(exceptRaid, raidID) then
                isSpecial = true
              end
            end
            if not isSpecial then
              MsgManager.ShowMsgByIDTable(43193)
              return
            end
          end
          FunctionNpcFunc.SeniorEnchant(nil, {OnClickChooseBordCell_data = data}, nil, true)
        elseif FunctionNpcFunc.CheckLv_SeniorEnchant() then
          FuncShortCutFunc.Me():CallByID(GameConfig.EquipGreenWay.EquipmentEnchantment)
        else
          MsgManager.ShowMsgByID(43258)
        end
      end
    }
  end
  return enchant
end
function ItemTipBaseCell.GetEquipUpgrade(equipInfo, itemData, theCell)
  if not equipInfo then
    return
  end
  local upgradeData = equipInfo.upgradeData
  if not upgradeData then
    return
  end
  local equiplv, maxUplv = equipInfo.equiplv, equipInfo.upgrade_MaxLv
  if maxUplv <= 0 then
    return
  end
  local myClass = MyselfProxy.Instance:GetMyProfession()
  local classDepth = ProfessionProxy.Instance:GetDepthByClassId(myClass)
  local upgradeInfo, hasUnlocklv, buffid, text, outputLevel = {
    tiplabel = ZhString.ItemTip_UpgradeTip,
    label = {}
  }, nil, nil, nil, nil
  local inactiveColorFormat = string.format("[c]%s%%s[-][/c]", ItemTipInactiveColorStr)
  local activeColorFormat = string.format("[c]%s%%s[-][/c]", ItemTipEquipAttriActiveColorStr)
  for i = 1, maxUplv do
    buffid = equipInfo:GetUpgradeBuffIdByEquipLv(i)
    if buffid then
      text = Table_Buffer[buffid] and Table_Buffer[buffid].Dsc or buffid .. " No Buff Dsc"
      outputLevel = i
      if i > equiplv then
        outputLevel = -outputLevel
        text = string.format(inactiveColorFormat, text)
        local canUpgrade, lv = equipInfo:CanUpgrade_ByClassDepth(classDepth, i)
        if not canUpgrade then
          hasUnlocklv = true
          table.insert(upgradeInfo.label, string.format(ZhString.ItemTip_NoUpgradeTip, ZhString.ChinaNumber[lv]))
          break
        end
      else
        if ItemTipBaseCell.CheckGvgSeasonEquipInvalid(equipInfo.equipData.id) then
          text = string.format(inactiveColorFormat, text)
        else
          text = string.format(activeColorFormat, text)
        end
        local isEffect, lv = equipInfo:CanUpgrade_ByClassDepth(classDepth, i)
        if not isEffect then
          text = text .. string.format(ZhString.ItemTip_NoUpgradeInfoEffectTip, ZhString.ChinaNumber[lv])
        end
      end
      table.insert(upgradeInfo.label, string.format("{equipupgradeicon=%s} %s", outputLevel, text))
    end
  end
  if not hasUnlocklv then
    local canUpgrade, lv = equipInfo:CanUpgrade_ByClassDepth(classDepth, maxUplv + 1)
    if not canUpgrade then
      hasUnlocklv = true
      table.insert(upgradeInfo.label, string.format(ZhString.ItemTip_NoUpgradeTip, ZhString.ChinaNumber[lv]))
    end
  end
  if not hasUnlocklv and upgradeData.Product then
    local productName = Table_Item[upgradeData.Product].NameZh
    table.insert(upgradeInfo.label, "{equipupgradeicon=end} " .. string.format(inactiveColorFormat, string.format(ZhString.ItemTip_UpgradeFinalTip, productName)))
    local endBuff = equipInfo:GetUpgradeBuffIdByEquipLv(maxUplv + 1)
    if endBuff then
      local endBuffDsc = Table_Buffer[endBuff] and Table_Buffer[endBuff].Dsc or endBuff .. ": No Buff Data"
      table.insert(upgradeInfo.label, string.format(inactiveColorFormat, string.format(ZhString.ItemTip_UpEndBuffTip, productName, tostring(endBuffDsc))))
    end
  end
  if _SHOWBTN_ then
    local flag_InRoleEquip = itemData and itemData.equiped == 1
    local flag_InMainBag = itemData and BagProxy.Instance:GetItemByGuid(itemData.id, BagProxy.BagType.MainBag) ~= nil
    local CAN_upgrade = (flag_InRoleEquip or flag_InMainBag) and equipInfo:CanUpgrade()
    if CAN_upgrade then
      upgradeInfo.aTipInlineButton = {
        sprite = "tips_icon_06",
        action = function()
          if theCell then
            local myProfId = MyselfProxy.Instance:GetMyProfession()
            if ProfessionProxy.GetJobDepth(myProfId) >= 2 then
              theCell:PassEvent(ItemTipEvent.ShowEquipUpgrade, theCell)
            else
              MsgManager.ShowMsgByID(43276)
            end
          end
        end
      }
    end
  end
  return upgradeInfo
end
local canEquipTypeMap, canEquipTypeBranchMap = {}, {}
local isProsAllCanUse = function(pros, equipInfo, needSelectProId)
  if type(pros) ~= "table" then
    return false
  end
  for _, data in pairs(pros) do
    if not equipInfo:CanUseByProfess(needSelectProId and data.id or data) then
      return false
    end
  end
  return true
end
local getTypeFromTypeBranch = function(b)
  return math.floor(b / 10)
end
function ItemTipBaseCell.GetEquipProfession(equipInfo)
  local proinfo, proban, prostrbuilder = {}, true, LuaStringBuilder.CreateAsTable()
  local canEquipPros, myPro, mySex = equipInfo.equipData.CanEquip, MyselfProxy.Instance:GetMyProfession(), MyselfProxy.Instance:GetMySex()
  if not canEquipPros or not next(canEquipPros) then
    LogUtility.Warning("CanEquip is nil or empty when id = {0}", equipInfo.equipData.id)
    return
  end
  if canEquipPros[1] == 0 then
    proban = false
    prostrbuilder:Append(ZhString.ItemTip_AllPro)
  elseif #canEquipPros == 1 then
    proban = myPro ~= canEquipPros[1]
    prostrbuilder:Append(ProfessionProxy.GetProfessionName(canEquipPros[1], mySex))
  else
    local prostrmodified, proproxy, skillproxy, bannedPros = false, ProfessionProxy.Instance, SkillProxy.Instance, ProfessionProxy.GetBannedProfessions()
    local isAllSameRace, isAllEvo2Plus, i, proSData, race = true, true, 0, nil, nil
    equipInfo:RefreshUseByProfess()
    for pid, _ in pairs(equipInfo.professCanUse) do
      proSData = Table_Class[pid]
      if proSData then
        i = i + 1
        if myPro == pid then
          proban = false
        end
        prostrbuilder:Append(ProfessionProxy.GetProfessionName(pid, mySex))
        prostrbuilder:Append("/")
        if not race then
          race = proSData.Race
        else
          isAllSameRace = isAllSameRace and proSData.Race == race
        end
        isAllEvo2Plus = isAllEvo2Plus and proproxy.GetJobDepth(proSData.id) >= 2
      end
    end
    for j = #prostrbuilder.content, 1, -1 do
      if prostrbuilder.content[j] == "/" then
        table.remove(prostrbuilder.content, j)
      else
        break
      end
    end
    if isAllSameRace and race ~= ECHARRACE.ECHARRACE_HUMAN then
      if isProsAllCanUse(proproxy:GetAllProfessionDatasOfRace(race), equipInfo, true) then
        if race == ECHARRACE.ECHARRACE_CAT then
          prostrbuilder:Clear()
          prostrbuilder:Append(ZhString.ItemTip_ProDoram)
        end
        prostrmodified = true
      end
    elseif isAllEvo2Plus then
      local allEvo2PlusPros = proproxy:GetAllDepth2PlusJobs()
      for j = #allEvo2PlusPros, 1, -1 do
        if 0 < TableUtility.ArrayFindIndex(bannedPros, allEvo2PlusPros[j]) then
          table.remove(allEvo2PlusPros, j)
        end
      end
      if isProsAllCanUse(allEvo2PlusPros, equipInfo) then
        prostrbuilder:Clear()
        prostrbuilder:Append(ZhString.ItemTip_ProAllEvo2Plus)
        prostrmodified = true
      end
    end
    if not prostrmodified then
      local prostrnewarr, isNoviceAdded = ReusableTable.CreateArray(), false
      TableUtility.TableClear(canEquipTypeMap)
      TableUtility.TableClear(canEquipTypeBranchMap)
      for pid, _ in pairs(equipInfo.professCanUse) do
        proSData = Table_Class[pid]
        if proSData then
          if 0 < proSData.Type then
            canEquipTypeMap[proSData.Type] = true
          end
          if 0 < proSData.TypeBranch then
            canEquipTypeBranchMap[proSData.TypeBranch] = true
          end
        end
      end
      local typeNameIdMap, hasAllOfOneType, nameId = GameConfig.NewClassEquip.typeNameIdMap, nil, nil
      local sameTypeProfessions = {}
      local classIdTypeMap = {}
      local classIdMatch = {}
      for type, classId in pairs(typeNameIdMap) do
        classIdTypeMap[classId] = classIdTypeMap[classId] or {}
        table.insert(classIdTypeMap[classId], type)
      end
      for t, _ in pairs(canEquipTypeMap) do
        local classId = typeNameIdMap[t]
        if not classIdMatch[classId] then
          sameTypeProfessions[t] = {}
          TableUtil.InsertArray(sameTypeProfessions[t], skillproxy.sameProfessionType[t])
          if #classIdTypeMap[classId] > 1 then
            for i = 1, #classIdTypeMap[classId] do
              local type = classIdTypeMap[classId][i]
              if type ~= t then
                TableUtil.InsertArray(sameTypeProfessions[t], skillproxy.sameProfessionType[type])
              end
            end
          end
          classIdMatch[classId] = true
          hasAllOfOneType = isProsAllCanUse(sameTypeProfessions[t], equipInfo, true)
          if t == 7 and not equipInfo:CanUseByProfess(1) then
            hasAllOfOneType = false
          end
          if hasAllOfOneType then
            nameId = typeNameIdMap[t]
            if nameId then
              local professionName = ProfessionProxy.GetProfessionName(nameId, mySex)
              if TableUtility.ArrayFindIndex(prostrnewarr, professionName) == 0 then
                table.insert(prostrnewarr, professionName)
                table.insert(prostrnewarr, ZhString.ItemTip_ProSeriesPrefix)
                table.insert(prostrnewarr, "/")
                prostrmodified = true
                if t == 7 then
                  isNoviceAdded = true
                end
                for b, _ in pairs(canEquipTypeBranchMap) do
                  local type = getTypeFromTypeBranch(b)
                  if 0 < TableUtility.ArrayFindIndex(classIdTypeMap[classId], type) then
                    canEquipTypeBranchMap[b] = nil
                  end
                end
              end
              canEquipTypeMap[t] = nil
              if #classIdTypeMap[classId] > 1 then
                for i = 1, #classIdTypeMap[classId] do
                  local type = classIdTypeMap[classId][i]
                  if type ~= t then
                    canEquipTypeMap[type] = nil
                  end
                end
              end
            end
          end
        end
      end
      local sameBranchProfessions = {}
      local classIdBranchMap = {}
      TableUtility.TableClear(classIdMatch)
      local tmpTypeBranchPros, typeBranchNameIdMap = ReusableTable.CreateArray(), GameConfig.NewClassEquip.typeBranchNameIdMap
      for branch, classId in pairs(typeBranchNameIdMap) do
        classIdBranchMap[classId] = classIdBranchMap[classId] or {}
        table.insert(classIdBranchMap[classId], branch)
      end
      for b, _ in pairs(canEquipTypeBranchMap) do
        local type = getTypeFromTypeBranch(b)
        if canEquipTypeMap[type] then
          local classId = typeBranchNameIdMap[b]
          if not classIdMatch[classId] then
            sameBranchProfessions[b] = {}
            TableUtil.InsertArray(sameBranchProfessions[b], skillproxy.sameProfessionTypeBranch[b])
            if #classIdBranchMap[classId] > 1 then
              for i = 1, #classIdBranchMap[classId] do
                local branch = classIdBranchMap[classId][i]
                if branch ~= b then
                  TableUtil.InsertArray(sameBranchProfessions[b], skillproxy.sameProfessionTypeBranch[branch])
                end
              end
            end
            classIdMatch[classId] = true
            TableUtility.ArrayClear(tmpTypeBranchPros)
            for _, data in pairs(sameBranchProfessions[b]) do
              if proproxy.GetJobDepth(data.id) >= 2 then
                table.insert(tmpTypeBranchPros, data.id)
              end
            end
            if isProsAllCanUse(tmpTypeBranchPros, equipInfo) then
              nameId = typeBranchNameIdMap[b]
              if nameId then
                local professionName = ProfessionProxy.GetProfessionName(nameId, mySex)
                if TableUtility.ArrayFindIndex(prostrnewarr, professionName) == 0 then
                  if proproxy.GetJobDepth(b) == 1 and equipInfo:CanUseByProfess(b) then
                    table.insert(prostrnewarr, ProfessionProxy.GetProfessionName(b, mySex))
                    table.insert(prostrnewarr, "/")
                  end
                  table.insert(prostrnewarr, professionName)
                  table.insert(prostrnewarr, ZhString.ItemTip_ProSeriesPrefix)
                  table.insert(prostrnewarr, "/")
                  prostrmodified = true
                end
                canEquipTypeBranchMap[b] = nil
                if #classIdBranchMap[classId] > 1 then
                  for i = 1, #classIdBranchMap[classId] do
                    local branch = classIdBranchMap[classId][i]
                    if branch ~= b and canEquipTypeBranchMap[branch] then
                      canEquipTypeBranchMap[branch] = nil
                    end
                  end
                end
              end
            end
          end
        end
      end
      ReusableTable.DestroyAndClearArray(tmpTypeBranchPros)
      if prostrmodified then
        if prostrnewarr[#prostrnewarr] == "/" then
          table.remove(prostrnewarr)
        end
        if not isNoviceAdded and equipInfo:CanUseByProfess(1) then
          table.insert(prostrnewarr, 1, Table_Class[1].NameZh)
          table.insert(prostrnewarr, 2, "/")
        end
        if next(canEquipTypeBranchMap) then
          for pid, _ in pairs(equipInfo.professCanUse) do
            if canEquipTypeBranchMap[Table_Class[pid].TypeBranch] then
              table.insert(prostrnewarr, "/")
              table.insert(prostrnewarr, ProfessionProxy.GetProfessionName(pid, mySex))
            end
          end
        end
        prostrbuilder:Clear()
        for j = 1, #prostrnewarr do
          prostrbuilder:Append(prostrnewarr[j])
        end
        ReusableTable.DestroyAndClearArray(prostrnewarr)
      end
    end
  end
  if proban then
    table.insert(prostrbuilder.content, 1, "[c]")
    table.insert(prostrbuilder.content, 2, ItemTipBanRedColorStr)
    table.insert(prostrbuilder.content, 3, ZhString.ItemTip_Profession)
  else
    table.insert(prostrbuilder.content, 1, "[c]")
    table.insert(prostrbuilder.content, 2, ItemTipProfessionPrefixColorStr)
    table.insert(prostrbuilder.content, 3, ZhString.ItemTip_Profession)
    table.insert(prostrbuilder.content, 4, "[-][/c]")
  end
  proinfo.label = prostrbuilder:ToString()
  prostrbuilder:Destroy()
  return proinfo
end
function ItemTipBaseCell.GetSpeedUp()
  if SpeedUpBuff and Table_Buffer[SpeedUpBuff] then
    local data = Table_Buffer[SpeedUpBuff]
    local speed = data and data.BuffEffect and data.BuffEffect.MoveSpdPer
    if type(speed) == "table" then
      return speed.a
    end
  end
  return 0
end
