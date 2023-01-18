autoImport("EquipNewChooseBord")
autoImport("EnchantNewCell")
autoImport("EnchantAttrInfoCell")
autoImport("MaterialItemNewCell")
EnchantNewView = class("EnchantNewView", BaseView)
EnchantNewView.ViewType = UIViewType.NormalLayer
autoImport("EnchantCombineView")
EnchantNewView.BrotherView = EnchantCombineView
EnchantNewView.ViewMaskAdaption = {all = 1}
local bg3TexName, enchantTargetPackageCheck, enchantType = "Equipmentopen_bg_bottom_16", {2, 1}, SceneItem_pb.EENCHANTTYPE_SENIOR
local bagIns, blackSmith, enchantUtil, zenyId, enchantMatPackageCheck, tickManager, arrayPushBack, tableClear
function EnchantNewView:Init()
  if not bagIns then
    bagIns = BagProxy.Instance
    blackSmith = BlackSmithProxy.Instance
    enchantUtil = EnchantEquipUtil.Instance
    zenyId = GameConfig.MoneyId.Zeny
    enchantMatPackageCheck = GameConfig.PackageMaterialCheck.enchant
    tickManager = TimeTickManager.Me()
    arrayPushBack = TableUtility.ArrayPushBack
    tableClear = TableUtility.TableClear
  end
  self.isFromHomeWorkbench = self.viewdata.viewdata and self.viewdata.viewdata.isFromHomeWorkbench
  self:FindObjs()
  self:InitView()
  self:AddListenEvts()
  self:InitData()
end
function EnchantNewView:FindObjs()
  self.mainBoardTrans = self:FindGO("MainBoard").transform
  self.closeButton = self:FindGO("CloseButton")
  self.bg3Tex = self:FindComponent("Bg3", UITexture)
  self.targetCellParentTrans = self:FindGO("TargetCell").transform
  self.targetCellAddIcon = self:FindGO("TargetCellAddIcon")
  self.targetCellContent = self:FindGO("TargetCellContent")
  self.targetIcon = self:FindComponent("Icon", UISprite, self.targetCellContent)
  self.effContainer = self:FindGO("EffectContainer")
  local actionBtn = self:FindGO("ActionBtn")
  self.actionBgSp = actionBtn:GetComponent(UIMultiSprite)
  self.actionLabel = self:FindComponent("ActionLabel", UILabel, actionBtn)
  self.emptyTip = self:FindGO("EmptyTip")
  self.actionBoard = self:FindGO("ActionBoard")
  self.targetName = self:FindComponent("ItemName", UILabel, self.actionBoard)
  self.enchantNoneTip = self:FindGO("EnchantNoneTip", self.actionBoard)
  self.enchantCellParent = self:FindGO("EnchantCellParent", self.actionBoard)
  self.fixedCostGrid = self:FindComponent("FixedCostGrid", UIGrid, self.actionBoard)
  self.advancedCostAddIcon = self:FindGO("AdvancedAddIcon")
  self.advancedCostContent = self:FindGO("AdvancedCostContent")
  self.enchantResult = self:FindGO("EnchantResult")
  self.enchantResultGrid = self:FindComponent("ResultGrid", UIGrid)
  self.resultNoneTip = self:FindGO("ResultNoneTip")
  self.giveUpBtn = self:FindGO("GiveUpBtn")
  self.chooseContainer = self:FindGO("ChooseContainer")
  self.enchantInfoBord = self:FindGO("EnchantInfoBoard")
  self.enchantInfoTable = self:FindComponent("EnchantInfoTable", UITable)
  self.collider = self:FindGO("Collider")
  self.tenPullsTog = self:FindGO("TenPullsTog"):GetComponent(UIToggle)
  self.tenPullsTog.value = false
end
function EnchantNewView:InitView()
  self.mainBoardTrans.localPosition = LuaGeometry.GetTempVector3(self.isFromHomeWorkbench and 295 or 369)
  self.closeButton:SetActive(not self.isFromHomeWorkbench)
  self.targetChooseBord = EquipNewChooseBord.new(self.chooseContainer)
  self.targetChooseBord:SetTweenActive(false)
  self.targetChooseBord:SetFilterPopData(GameConfig.EquipChooseFilter)
  self.targetChooseBord:AddEventListener(EquipChooseBord.ChooseItem, self.OnClickChooseBordCell, self)
  self.fixedCostCtl = ListCtrl.new(self.fixedCostGrid, MaterialItemNewCell, "MaterialItemNewCell")
  self.fixedCostCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickFixed, self)
  self.enchantResultCtl = ListCtrl.new(self.enchantResultGrid, EnchantNewCell, "EnchantNewCell")
  self.enchantResultCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickResult, self)
  self.enchantCell = EnchantNewCell.new(self:LoadPreferb("cell/EnchantNewCell", self.enchantCellParent))
  self.advancedCostCell = MaterialItemNewCell.new(self:LoadPreferb("cell/MaterialItemNewCell", self.advancedCostContent))
  self.advancedCostCell:AddEventListener(MouseEvent.MouseClick, self.OnClickAdvancedCost, self)
  self.enchantInfoCtl = ListCtrl.new(self.enchantInfoTable, EnchantAttrInfoNewCell, "EnchantAttrInfoNewCell")
  self:AddButtonEvent("TargetCell", function()
    self:OnClickTargetCell()
  end)
  self:AddButtonEvent("ActionBtn", function()
    if not self.actionBtnActive then
      return
    end
    if not self:HasTarget() then
      return
    end
    if not self:CheckFixedCost() then
      MsgManager.ShowMsgByID(8)
      return
    end
    if not self:CheckAdvancedCost() then
      MsgManager.ConfirmMsgByID(43140, function()
        tableClear(self.selectedAdvancedCosts)
        self:UpdateAdvancedCost()
        self:Enchant()
      end)
    else
      self:Enchant()
    end
  end)
  self:AddButtonEvent("SaveBtn", function()
    local targetID = self.curChooseResultID and self.curChooseResultID - 1
    ServiceItemProxy.Instance:CallProcessEnchantItemCmd(true, self.targetData.id, targetID)
    self.showServerResult = false
  end)
  self:AddButtonEvent("EnchantInfoBtn", function()
    self.enchantInfoBord:SetActive(true)
  end)
  self:AddButtonEvent("EnchantInfoCloseBtn", function()
    self:OnClickEnchantInfoCloseBtn()
  end)
  self:AddClickEvent(self.advancedCostAddIcon, function()
    self:OnClickAdvancedCost()
  end)
  self:AddClickEvent(self.giveUpBtn, function()
    self:OnClickGiveUp()
  end)
  self:AddTabEvent(self.tenPullsTog.gameObject, function()
    self:UpdateFixedCost()
    self:UpdateAdvancedCost()
    self:SetActionBtnActive(self:CheckFixedCost())
  end)
end
function EnchantNewView:AddListenEvts()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.OnItemUpdate)
  self:AddListenEvt(ItemEvent.EquipUpdate, self.OnItemUpdate)
  self:AddListenEvt(MyselfEvent.MyDataChange, self.OnItemUpdate)
  self:AddListenEvt(ServiceEvent.ItemEnchantEquip, self.OnEnchant)
  self:AddListenEvt(ServiceEvent.ItemEnchantRes, self.OnEnchantRes)
  self:AddListenEvt(ServiceEvent.ItemEnchantHighestBuffNotify, self.OnShowShare)
end
function EnchantNewView:InitData()
  self.tipData = {
    funcConfig = _EmptyTable,
    ignoreBounds = {
      self.fixedCostGrid.gameObject
    }
  }
  self.selectedAdvancedCosts = {}
  self.enchantInfoDatas = {}
  self.fixedCostItemDatas = {}
end
function EnchantNewView:OnEnter()
  EnchantNewView.super.OnEnter(self)
  PictureManager.Instance:SetUI(bg3TexName, self.bg3Tex)
  local npcData = self.viewdata.viewdata and self.viewdata.viewdata.npcdata
  if npcData then
    self:CameraFocusOnNpc(npcData.assetRole.completeTransform)
  else
    self:CameraRotateToMe()
  end
  self:OnClickTargetCell()
  if self.viewdata.viewdata.OnClickChooseBordCell_data then
    self:OnClickChooseBordCell(self.viewdata.viewdata.OnClickChooseBordCell_data)
  end
end
function EnchantNewView:OnShowShare(data)
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.EnchantNewShareView,
    viewdata = {
      enchantAttrList = self.targetData.enchantInfo.enchantAttrs,
      combineEffectList = self.targetData.enchantInfo.combineEffectlist,
      itemdata = self.targetData
    }
  })
end
function EnchantNewView:OnExit()
  if self.arr then
    for i = 1, #self.arr do
      ReusableTable.DestroyAndClearTable(self.arr[i])
    end
    ReusableTable.DestroyAndClearArray(self.arr)
  end
  PictureManager.Instance:UnLoadUI(bg3TexName, self.bg3Tex)
  self:CameraReset()
  tickManager:ClearTick(self)
  EnchantNewView.super.OnExit(self)
end
function EnchantNewView:OnItemUpdate()
  if self.enchantComplete then
    self.enchantComplete = nil
    tickManager:CreateOnceDelayTick(33, function(self)
      self:UpdateTargetCell()
    end, self)
  else
    self:UpdateTargetCell()
  end
end
function EnchantNewView:OnEnchant(data)
  self.enchantComplete = true
end
function EnchantNewView:OnEnchantRes(note)
  local data = note and note.body and note.body.results
  if not data or not self:HasTarget() then
    return
  end
  self:UpdateEnchantResult(data)
end
function EnchantNewView:OnClickTargetCell()
  self:OnClickGiveUp()
  self:OnClickEnchantInfoCloseBtn()
  self.enchantResult:SetActive(false)
  self.targetChooseBord:ResetDatas(self:GetTargetChooseBordDatas(), true)
  self.targetChooseBord:Show()
  self.targetChooseBord:SetChoose()
  tableClear(self.selectedAdvancedCosts)
  self:SetTargetCell()
end
function EnchantNewView:OnClickChooseBordCell(data)
  self:SetTargetCell(data)
end
function EnchantNewView:OnClickAdvancedChooseBordChoose(data)
  self.selectedAdvancedCosts[1] = data
  self:UpdateAdvancedCost()
  self:OnClickGiveUp()
  self:TryShowEnchantResult()
end
function EnchantNewView:OnClickAdvancedChooseBordCancel(data)
  self.selectedAdvancedCosts[1] = nil
  self:UpdateAdvancedCost()
  self:OnClickAdvancedCost()
end
function EnchantNewView:OnClickFixed(cell)
  self:ShowItemTip(cell)
end
function EnchantNewView:OnClickResult(cell)
  self.curChooseResultID = cell.index
  local cells = self.enchantResultCtl:GetCells()
  for i = 1, #cells do
    cells[i]:SetChooseId(cell.index)
  end
end
function EnchantNewView:OnClickEnchantInfoCloseBtn()
  self.enchantInfoBord:SetActive(false)
end
local advancedChooseBordTypeLabelTextGetter = function(data)
  return data and data.staticData and data.staticData.Desc
end
function EnchantNewView:OnClickAdvancedCost()
  self.enchantResult:SetActive(false)
  self.giveUpBtn:SetActive(true)
  self:OnClickEnchantInfoCloseBtn()
  if not self.advancedChooseBord then
    self.advancedChooseBord = EquipNewMultiChooseBord.new(self.chooseContainer)
    self.advancedChooseBord:SetBordTitle(ZhString.EnchantView_AdvancedChooseBordTitle)
    self.advancedChooseBord:SetNoneTip(ZhString.EnchantView_AdvancedChooseBordNoneTip)
    self.advancedChooseBord:SetTypeLabelTextGetter(advancedChooseBordTypeLabelTextGetter)
    self.advancedChooseBord:SetTweenActive(false)
    self.advancedChooseBord:AddEventListener(EquipChooseBord.ChooseItem, self.OnClickAdvancedChooseBordChoose, self)
    self.advancedChooseBord:AddEventListener(EquipChooseCellEvent.ClickCancel, self.OnClickAdvancedChooseBordCancel, self)
    self.advancedChooseBord:SetChooseReference(self.selectedAdvancedCosts)
  end
  if self.advancedChooseBord.gameObject.activeSelf then
    self.advancedChooseBord:ResetDatas(self:GetAdvancedChooseBordDatas())
  else
    self.advancedChooseBord:ResetDatas(self:GetAdvancedChooseBordDatas(), true)
    self.advancedChooseBord:Show()
  end
end
function EnchantNewView:OnClickGiveUp()
  if self.advancedChooseBord then
    self.advancedChooseBord:Hide()
  end
  self.giveUpBtn:SetActive(false)
  self:TryShowEnchantResult()
end
function EnchantNewView:SetTargetCell(data)
  if not BagItemCell.CheckData(data) or data.staticData == nil then
    data = nil
  end
  self.showServerResult = false
  self.targetData = data
  self:UpdateTargetCell()
end
function EnchantNewView:UpdateTargetCell()
  local hasData = self:HasTarget()
  self.targetCellParentTrans.localPosition = LuaGeometry.GetTempVector3(self.targetCellParentTrans.localPosition.x, hasData and 140 or 96)
  self.targetCellContent:SetActive(hasData)
  self.targetCellAddIcon:SetActive(not hasData)
  self.emptyTip:SetActive(not hasData)
  self.actionBoard:SetActive(hasData)
  self.actionLabel.text = ZhString.EnchantView_Enchant
  self:OnClickGiveUp()
  self.hasUnsavedAttri = false
  self.hasNewGoodAttri = false
  if hasData then
    IconManager:SetItemIcon(self.targetData.staticData.Icon, self.targetIcon)
    self.targetIcon:MakePixelPerfect()
    local scale = 0.8
    self.targetIcon.transform.localScale = LuaGeometry.GetTempVector3(scale, scale, scale)
    self.targetName.text = self.targetData:GetName()
    self.targetChooseBord:Hide()
    self:UpdateEnchantResult()
    self:UpdateCurrentEnchant()
    self:UpdateFixedCost()
    self:UpdateAdvancedCost()
    self:UpdateEnchantInfo()
  end
  self:SetActionBtnActive(hasData and self:CheckFixedCost())
  self:TryShowEnchantResult()
end
function EnchantNewView:GetTargetChooseBordDatas()
  self.targetChooseDatas = self.targetChooseDatas or {}
  tableClear(self.targetChooseDatas)
  local items, equipInfo
  for i = 1, #enchantTargetPackageCheck do
    items = bagIns.bagMap[enchantTargetPackageCheck[i]]:GetItems()
    if items then
      for j = 1, #items do
        equipInfo = items[j] and items[j].equipInfo
        if equipInfo and equipInfo:CanEnchant() then
          arrayPushBack(self.targetChooseDatas, items[j])
        end
      end
    end
  end
  return self.targetChooseDatas
end
function EnchantNewView:GetAdvancedChooseBordDatas()
  self.advancedChooseDatas = self.advancedChooseDatas or {}
  tableClear(self.advancedChooseDatas)
  if self:HasTarget() then
    local costCfg, itemId, item = self:GetTargetAdvancedEnchantCostConfig()
    for i = 1, #costCfg do
      itemId = costCfg[i].itemid
      for j = 1, #enchantMatPackageCheck do
        item = bagIns:GetItemByStaticID(itemId, enchantMatPackageCheck[j])
        if item then
          arrayPushBack(self.advancedChooseDatas, item)
          break
        end
      end
    end
    table.sort(self.advancedChooseDatas, function(l, r)
      return l.staticData.id < r.staticData.id
    end)
  end
  return self.advancedChooseDatas
end
function EnchantNewView:GetTargetAdvancedEnchantCostConfig()
  return self:HasTarget() and blackSmith:GetAdvancedEnchantCostConfig(self.targetData.equipInfo.equipData.Type) or _EmptyTable
end
function EnchantNewView:GetTargetAdvancedEnchantCostNeedNum(itemId)
  local neednum = 0
  for _, d in pairs(self:GetTargetAdvancedEnchantCostConfig()) do
    if d.itemid == itemId then
      neednum = d.num
      break
    end
  end
  return neednum
end
function EnchantNewView:GetEnchantInfoDatas()
  tableClear(self.enchantInfoDatas)
  if self:HasTarget() then
    local type = self.targetData.staticData.Type
    local enchantDatas = enchantUtil:GetEnchantDatasByEnchantType(enchantType)
    local attriMenuType, pos, infoData, cbdata
    for attriType, data in pairs(enchantDatas) do
      attriMenuType, pos = enchantUtil:GetMenuType(attriType)
      infoData = self.enchantInfoDatas[attriMenuType]
      if not infoData then
        infoData = {}
        infoData.attriMenuType = attriMenuType
        infoData.attris = {}
        self.enchantInfoDatas[attriMenuType] = infoData
      end
      cbdata = {}
      cbdata.attriMenuType = attriMenuType
      cbdata.equipType = type
      cbdata.enchantData, cbdata.canGet = data:Get(type)
      cbdata.pos = pos
      arrayPushBack(infoData.attris, cbdata)
    end
    local combineEffects = enchantUtil:GetCombineEffects(enchantType)
    if next(combineEffects) then
      infoData = {}
      infoData.attriMenuType = EnchantMenuType.CombineAttri
      infoData.attris = {}
      arrayPushBack(self.enchantInfoDatas, infoData)
      local nameKeysMap, canGet = {}, nil
      for _, data in pairs(combineEffects) do
        if nameKeysMap[data.Name] == nil then
          cbdata = {}
          cbdata.attriMenuType = EnchantMenuType.CombineAttri
          cbdata.equipType = type
          cbdata.enchantData = data
          cbdata.pos = data.id
          cbdata.canGet = enchantUtil:CanGetCombineEffect(data, type)
          arrayPushBack(infoData.attris, cbdata)
          nameKeysMap[data.Name] = #infoData.attris
        else
          canGet = enchantUtil:CanGetCombineEffect(data, type)
          if canGet then
            cbdata = infoData.attris[nameKeysMap[data.Name]]
            cbdata.enchantData = data
            cbdata.pos = data.id
            cbdata.canGet = true
          end
        end
      end
    end
  end
  return self.enchantInfoDatas
end
function EnchantNewView:GetCellDataFromServerData(serverData, index, isReusable)
  if serverData and self:HasTarget() then
    local cellData = self:_GetCellData(index, isReusable)
    cellData.enchantAttrList = {}
    cellData.combineEffectList = {}
    EnchantInfo.SetServerData(serverData, cellData.enchantAttrList, cellData.combineEffectList, self.targetData.staticData.id)
    return cellData
  end
end
function EnchantNewView:GetCellDataFromEnchantInfo(enchantInfo, index, isCache, isReusable)
  if enchantInfo and self:HasTarget() then
    local attrs = isCache and enchantInfo.cacheEnchantAttrs or enchantInfo.enchantAttrs
    if attrs and #attrs > 0 then
      local cellData = self:_GetCellData(index, isReusable)
      cellData.enchantAttrList = attrs
      cellData.combineEffectList = isCache and enchantInfo.cacheCombineEffectlist or enchantInfo.combineEffectlist
      return cellData
    end
  end
end
function EnchantNewView:_GetCellData(index, isReusable)
  local cellData = isReusable and ReusableTable.CreateTable() or {}
  cellData.index = index
  return cellData
end
function EnchantNewView:UpdateEnchantResult(serverDatas)
  if self.showServerResult and not serverDatas then
    return
  end
  self.arr = ReusableTable.CreateArray()
  if serverDatas then
    self.showServerResult = true
    for i = 1, #serverDatas do
      arrayPushBack(self.arr, self:GetCellDataFromServerData(serverDatas[i], i, true))
    end
  else
    arrayPushBack(self.arr, self:GetCellDataFromEnchantInfo(self.targetData.enchantInfo, 1, true, true))
  end
  local hasElement = #self.arr > 0
  self.enchantResult:SetActive(hasElement)
  self.enchantResultCtl:ResetDatas(self.arr)
  local cells = self.enchantResultCtl:GetCells()
  if cells and cells[1] then
    self:OnClickResult(cells[1])
  end
  self.enchantResultGrid:Reposition()
  self.enchantResultCtl:ResetPosition()
  self.resultNoneTip:SetActive(not hasElement)
  if hasElement and self.enchantInfoBord.activeSelf then
    self:OnClickEnchantInfoCloseBtn()
  end
  self.collider:SetActive(false)
end
function EnchantNewView:UpdateCurrentEnchant()
  local flag = self.targetData:HasEnchant()
  self.enchantNoneTip:SetActive(not flag)
  if flag then
    local data = self:GetCellDataFromEnchantInfo(self.targetData.enchantInfo, nil, false, true)
    self.enchantCell:SetData(data)
    ReusableTable.DestroyAndClearTable(data)
    self.hasUnsavedAttri = self.targetData.enchantInfo:HasUnSaveAttri()
    self.hasNewGoodAttri = self.targetData.enchantInfo:HasNewGoodAttri()
    self.actionLabel.text = self.hasUnsavedAttri and ZhString.EnchantView_Re_Enchant or ZhString.EnchantView_Enchant
  else
    self.enchantCell:SetData(nil)
  end
end
function EnchantNewView:UpdateFixedCost()
  if not self:HasTarget() then
    return
  end
  tableClear(self.fixedCostItemDatas)
  local itemCost, zenyCost, actDiscount, homeDiscount = blackSmith:GetEnchantCost(enchantType, self.targetData.staticData.Type)
  itemCost = itemCost and itemCost[1]
  local isTenPulls = self.tenPullsTog.value
  if itemCost and itemCost.num and itemCost.num > 0 then
    local itemCostData = ItemData.new(MaterialItemCell.MaterialType.Material, itemCost.itemid)
    itemCostData.num = bagIns:GetItemNumByStaticID(itemCost.itemid, enchantMatPackageCheck)
    itemCostData.discount = actDiscount or 100
    itemCostData.neednum = math.floor(itemCost.num * (isTenPulls and 10 or 1) * itemCostData.discount / 100 + 0.01)
    arrayPushBack(self.fixedCostItemDatas, itemCostData)
  end
  if zenyCost and zenyCost > 0 then
    local zenyData = ItemData.new(MaterialItemCell.MaterialType.Material, zenyId)
    zenyData.num = MyselfProxy.Instance:GetROB()
    zenyData.discount = actDiscount or homeDiscount or 100
    zenyData.neednum = math.floor(zenyCost * (isTenPulls and 10 or 1) * zenyData.discount / 100 + 0.01)
    arrayPushBack(self.fixedCostItemDatas, zenyData)
  end
  self.fixedCostCtl:ResetDatas(self.fixedCostItemDatas)
end
function EnchantNewView:UpdateAdvancedCost()
  local hasAdvanced = self:HasAdvancedCostSelected()
  self.advancedCostAddIcon:SetActive(not hasAdvanced)
  self.advancedCostContent:SetActive(hasAdvanced)
  if hasAdvanced then
    local isTenPulls = self.tenPullsTog.value
    local sId = self.selectedAdvancedCosts[1].staticData.id
    self.selectedAdvancedItemData = self.selectedAdvancedItemData or ItemData.new()
    self.selectedAdvancedItemData:ResetData(MaterialItemCell.MaterialType.Material, sId)
    self.selectedAdvancedItemData.num = bagIns:GetItemNumByStaticID(sId, enchantMatPackageCheck)
    self.selectedAdvancedItemData.neednum = self:GetTargetAdvancedEnchantCostNeedNum(sId) * (isTenPulls and 10 or 1)
    self.advancedCostCell:SetData(self.selectedAdvancedItemData)
  end
end
function EnchantNewView:UpdateEnchantInfo()
  if not self:HasTarget() then
    return
  end
  self.enchantInfoCtl:ResetDatas(self:GetEnchantInfoDatas())
end
function EnchantNewView:CheckFixedCost()
  if not self:HasTarget() then
    return false
  end
  local costEnough = true
  for _, item in pairs(self.fixedCostItemDatas) do
    if item.num < item.neednum then
      costEnough = false
      break
    end
  end
  return costEnough
end
function EnchantNewView:CheckAdvancedCost()
  if not self:HasTarget() then
    return false
  end
  if not self:HasAdvancedCostSelected() then
    return true
  end
  local item = self.selectedAdvancedItemData
  return item.num >= item.neednum
end
function EnchantNewView:CheckHasGoodAttr(data)
  local attrList = data.enchantAttrList
  local combineEffectList = data.combineEffectList
  local hasGoodAttr = false
  for i = 1, #attrList do
    if attrList[i].Quality == EnchantAttriQuality.Good then
      hasGoodAttr = true
      break
    end
  end
  hasGoodAttr = hasGoodAttr or #combineEffectList > 0
  return hasGoodAttr
end
function EnchantNewView:Enchant()
  if self.arr then
    for i = 1, #self.arr do
      if self:CheckHasGoodAttr(self.arr[i]) then
        MsgManager.ConfirmMsgByID(3060, function()
          self:_Enchant()
        end)
        return
      end
    end
  end
  if self.targetData.enchantInfo:HasNewGoodAttri() then
    MsgManager.ConfirmMsgByID(3060, function()
      self:_Enchant()
    end)
    return
  end
  self:_Enchant()
end
function EnchantNewView:_Enchant()
  FunctionSecurity.Me():EnchantingEquip(function(self)
    self.collider:SetActive(true)
    self:SetActionBtnActive(false)
    self:PlayUIEffect(EffectMap.UI.EquipReplaceNew, self.effContainer, true)
    tickManager:CreateOnceDelayTick(800, self.CallEnchant, self)
    self.showServerResult = false
  end, self)
  self.showServerResult = false
end
function EnchantNewView:TryShowEnchantResult()
  if self.showServerResult then
    self.enchantResult:SetActive(true)
  else
    self.enchantResult:SetActive(self.hasUnsavedAttri or false)
  end
  self:OnClickEnchantInfoCloseBtn()
end
function EnchantNewView:CallEnchant()
  if self:HasTarget() then
    if self.clickTimeStamp and self.clickTimeStamp + 1 > ServerTime.CurServerTime() / 1000 then
      redlog("点太快！")
      return
    end
    local isImprove, mustBuffItem = false, nil
    if self:HasAdvancedCostSelected() then
      for _, d in pairs(self:GetTargetAdvancedEnchantCostConfig()) do
        if d.itemid == self.selectedAdvancedCosts[1].staticData.id then
          if d.isMustBuff then
            mustBuffItem = d.itemid
            break
          end
          isImprove = true
          break
        end
      end
    end
    local isTenPulls = self.tenPullsTog.value
    self.clickTimeStamp = ServerTime.CurServerTime() / 1000
    ServiceItemProxy.Instance:CallEnchantEquip(enchantType, self.targetData.id, isImprove, mustBuffItem, isTenPulls and 10 or 1)
  end
end
function EnchantNewView:SetActionBtnActive(isActive)
  self.actionBtnActive = isActive and true or false
  self:UpdateActionBtnActive()
end
local inactiveLabelColor, activeLabelEffectColor, inactiveLabelEffectColor = LuaColor.New(0.9372549019607843, 0.9372549019607843, 0.9372549019607843), LuaColor.New(0.7686274509803922, 0.5254901960784314, 0), LuaColor.New(0.39215686274509803, 0.40784313725490196, 0.4627450980392157)
function EnchantNewView:UpdateActionBtnActive()
  local isActive = self.actionBtnActive
  self.actionBgSp.CurrentState = isActive and 1 or 0
  self.actionLabel.color = isActive and ColorUtil.NGUIWhite or inactiveLabelColor
  self.actionLabel.effectColor = isActive and activeLabelEffectColor or inactiveLabelEffectColor
end
function EnchantNewView:HasTarget()
  return self.targetData ~= nil and self.targetData.staticData ~= nil
end
function EnchantNewView:HasAdvancedCostSelected()
  return #self.selectedAdvancedCosts > 0
end
local tipOffset = {-210, 180}
function EnchantNewView:ShowItemTip(cell)
  local data = cell.data
  if not BagItemCell.CheckData(data) then
    return
  end
  self.tipData.itemdata = data
  EnchantNewView.super.ShowItemTip(self, self.tipData, cell.icon, NGUIUtil.AnchorSide.Left, tipOffset)
end
function EnchantNewView:OpenHelpView()
  local data = Table_Help[35236]
  if data then
    TipsView.Me():ShowGeneralHelp(data.Desc, data.Title)
  end
end
