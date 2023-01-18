autoImport("EnchantTransferView")
autoImport("MaterialItemNewCell")
RefineTransferView = class("RefineTransferView", EnchantTransferView)
RefineTransferView.ViewType = UIViewType.NormalLayer
autoImport("RefineCombineView")
RefineTransferView.BrotherView = RefineCombineView
RefineTransferView.ViewMaskAdaption = {all = 1}
RefineTransferView.PreviewPartName = "RefinePreview"
RefineTransferView.PreviewPartCellName = "RefineTransferAttributeCell"
RefineTransferView.PreviewPartLocalPosY = -153
RefineTransferView.CostItemIds = {
  GameConfig.MoneyId.Zeny,
  GameConfig.MoneyId.Lottery
}
local BagTypes_RefineCheck = GameConfig.PackageMaterialCheck.refine
local mReverse_Table_RefineTransfer
local mFInitTransferCostConfig = function()
  if mReverse_Table_RefineTransfer then
    return
  end
  mReverse_Table_RefineTransfer = {}
  for id, data in pairs(Table_RefineTransfer) do
    if not mReverse_Table_RefineTransfer[data.Type] then
      mReverse_Table_RefineTransfer[data.Type] = {}
    end
    mReverse_Table_RefineTransfer[data.Type][data.Lv] = data
  end
end
local CostParamName = {
  [4] = {
    [3] = "FirstToSecond",
    [2] = "FirstToThird",
    [1] = "FirstToThird"
  },
  [3] = {
    [2] = "SecondToThird",
    [1] = "SecondToThird"
  }
}
local mFSameRefine = function(inRefine, outRefine)
  if inRefine == outRefine then
    return true
  end
  return (inRefine == 1 or inRefine == 2) and (outRefine == 1 or outRefine == 2)
end
function mFGetTransferCost(targetOutData, targetInData)
  if not targetOutData or not targetInData then
    return nil
  end
  local retCost
  local outRefine = targetOutData.equipInfo and targetOutData.equipInfo.equipData.NewEquipRefine
  local inRefine = targetInData.equipInfo and targetInData.equipInfo.equipData.NewEquipRefine
  if mFSameRefine(inRefine, outRefine) then
    retCost = GameConfig.Equip.RefineTransferItemCost[outRefine]
  end
  if retCost then
    return retCost
  end
  local costParam = CostParamName[inRefine] and CostParamName[inRefine][outRefine]
  if costParam then
    local refinelv = targetInData.equipInfo.refinelv
    local rtype = GameConfig.Equip.EquipTransferType[targetInData.staticData.Type]
    if rtype and refinelv then
      if not mReverse_Table_RefineTransfer then
        mFInitTransferCostConfig()
      end
      retCost = mReverse_Table_RefineTransfer[rtype][refinelv] and mReverse_Table_RefineTransfer[rtype][refinelv][costParam]
    end
  end
  return retCost
end
function RefineTransferView:InitView()
  RefineTransferView.super.InitView(self)
  self.title.text = ZhString.RefineTransferView_Title
end
function RefineTransferView:FindObjs()
  EnchantTransferView.FindObjs(self)
  self.bg = self:FindComponent("Content/MainBoardBg", UISprite)
  self.refineCost2 = self:FindGO("refinecost2", self.previewPart)
  local refineCost2Grid = self:FindComponent("matgrid", UIGrid, self.refineCost2)
  self.refineCost2Ctrl = UIGridListCtrl.new(refineCost2Grid, MaterialItemNewCell, "MaterialItemNewCell")
  self.refineCost2Ctrl:AddEventListener(MouseEvent.MouseClick, self.OnClickOneClickRefineTab, self)
end
local tipOffset = {-180, 0}
function RefineTransferView:OnClickOneClickRefineTab(cellCtl)
  if not self.tipData then
    self.tipData = {}
  end
  self.tipData.itemdata = cellCtl.data
  self.tipData.ignoreBounds = cellCtl.gameObject
  TipManager.Instance:ShowItemFloatTip(self.tipData, self.bg, NGUIUtil.AnchorSide.Left, tipOffset)
end
function RefineTransferView:AddListenEvts()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.OnItemUpdate)
  self:AddListenEvt(MyselfEvent.ZenyChange, self.OnZenyChange)
  self:AddListenEvt(ServiceEvent.ItemEquipRefineTransferItemCmd, self.OnRefineTransfer)
end
function RefineTransferView:OnRefineTransfer(note)
  if note.body.success then
    self:SetTransferSuccess()
  end
end
function RefineTransferView:GetAttrPreviewData(name, value1, value2, compare)
  local t = ReusableTable.CreateTable()
  t.name = name
  t.value1 = value1
  t.value2 = value2
  if compare ~= nil then
    t.compare = compare
  elseif value1 ~= value2 then
    t.compare = value1 < value2
  end
  return t
end
function RefineTransferView:_UpdatePreview()
  self.previewTitleLabel.text = self.targetOutData.staticData.NameZh
  local datas = ReusableTable.CreateArray()
  local leftLv, rightLv = self.targetOutData.equipInfo.refinelv, self.targetInData.equipInfo.refinelv
  TableUtility.ArrayPushBack(datas, self:GetAttrPreviewData(ZhString.RefineTransferView_CurrentRefineLabel, string.format(" +%s", leftLv), string.format(" +%s", rightLv), leftLv < rightLv))
  local proName, currentStr, nextStr = ItemUtil.GetRefineAttrPreview(self.targetOutData.equipInfo, rightLv)
  if not StringUtil.IsEmpty(proName) then
    TableUtility.ArrayPushBack(datas, self:GetAttrPreviewData(proName, currentStr, nextStr, leftLv < rightLv))
  end
  self.previewAttriCtl:ResetDatas(datas)
  for _, t in pairs(datas) do
    ReusableTable.DestroyAndClearTable(t)
  end
  ReusableTable.DestroyAndClearArray(datas)
end
function RefineTransferView:UpdateFakePreviewTitle()
end
function RefineTransferView:GetTargetAttrText(data)
  return data and string.format("+%s", data.equipInfo.refinelv) or ""
end
local forEachRefineEquipItemsByPredicate = function(func, predicate, ...)
  if not func then
    return
  end
  local result = BlackSmithProxy.Instance:GetRefineEquips(BlackSmithProxy.GetRefineEquipTypeMap())
  for i = 1, #result do
    if not predicate or predicate(result[i], ...) then
      func(result[i])
    end
  end
end
local newEquipRefineBan = GameConfig.BanRefineTransfer and GameConfig.BanRefineTransfer.NewEquipRefine
local targetInPredicate = function(equip)
  local equipInfo = equip.equipInfo
  return equipInfo:IsNextGen() and equipInfo.refinelv > 0 and not equipInfo.damage and (not newEquipRefineBan or TableUtility.ArrayFindIndex(newEquipRefineBan, equipInfo.equipData.NewEquipRefine) == 0)
end
function RefineTransferView:GetEnchantInChooseDatas()
  self.enchantInDatas = self.enchantInDatas or {}
  TableUtility.ArrayClear(self.enchantInDatas)
  forEachRefineEquipItemsByPredicate(function(equip)
    TableUtility.ArrayPushBack(self.enchantInDatas, equip)
  end, targetInPredicate)
  return self.enchantInDatas
end
local targetOutPredicate = function(equip, compareTarget)
  local equipInfo = equip.equipInfo
  if not mFGetTransferCost(equip, compareTarget) then
    return false
  end
  return equipInfo:IsNextGen() and equipInfo.refinelv < compareTarget.equipInfo.refinelv and not equipInfo.damage and EnchantTransferView.CheckIsSameType(equip, compareTarget) and equip.id ~= compareTarget.id and (not newEquipRefineBan or TableUtility.ArrayFindIndex(newEquipRefineBan, equipInfo.equipData.NewEquipRefine) == 0)
end
function RefineTransferView:GetEnchantOutChooseDatas()
  self.enchantOutDatas = self.enchantOutDatas or {}
  TableUtility.ArrayClear(self.enchantOutDatas)
  forEachRefineEquipItemsByPredicate(function(equip)
    TableUtility.ArrayPushBack(self.enchantOutDatas, equip)
  end, targetOutPredicate, self.targetInData)
  return self.enchantOutDatas
end
function RefineTransferView:DoTransfer()
  ServiceItemProxy.Instance:CallEquipRefineTransferItemCmd(self.targetInData.id, self.targetOutData.id)
  self.clickDisabled = true
end
function RefineTransferView:GetNextGen()
  return true
end
function RefineTransferView:GetTargetInTipText()
  return ZhString.RefineTransferView_ChooseTargetInFirst
end
function RefineTransferView:GetTargetOutTipText()
  return ZhString.RefineTransferView_ChooseTargetOutFirst
end
local _checkCost = function(itemid, num)
  local hasNum = BagProxy.Instance:GetItemNumByStaticID(itemid, BagTypes_RefineCheck) or 0
  return num <= hasNum
end
function RefineTransferView:CheckCost()
  local costs = self:GetTransferCost()
  if costs then
    for i = 1, #costs do
      if not _checkCost(costs[i][1], costs[i][2]) then
        return false
      end
    end
  end
  return true
end
function RefineTransferView:ClickTransfer()
  if not self.targetInData then
    return
  end
  if not self.targetOutData then
    return
  end
  if self.clickDisabled then
    return
  end
  if not self:CheckCost() then
    MsgManager.ShowMsgByIDTable(25418, "Zeny")
    return
  end
  self:TryPlayEffectThenCall(self.DoTransfer)
end
function RefineTransferView:UpdateTransferCost()
  self:UpdatePrice()
end
function RefineTransferView:UpdatePrice()
  local costs = self:GetTransferCost()
  if not costs then
    self.priceIndicator:SetActive(false)
    self.refineCost2:SetActive(false)
    return
  end
  local matDatas = {}
  for i = 1, #costs do
    local cost = costs[i]
    if cost[1] == 100 then
      self.needZenyType = cost[1]
      self.needZeny = cost[2]
    else
      local matItem
      for i = 1, #BagTypes_RefineCheck do
        matItem = BagProxy.Instance:GetItemByStaticID(cost[1], BagTypes_RefineCheck[i])
        if not matItem then
        end
      end
      if not matItem then
        matItem = ItemData.new("RefineTransferCost", cost[1])
        matItem.num = 0
      else
        matItem = matItem:Clone()
      end
      matItem.neednum = cost[2]
      table.insert(matDatas, matItem)
    end
  end
  if #matDatas > 0 then
    self.refineCost2:SetActive(true)
    self.PreviewPartLocalPosY = -70
    LuaGameObject.SetLocalPositionGO(self.previewPart, 0, self.PreviewPartLocalPosY, 0)
  else
    self.refineCost2:SetActive(false)
    self.PreviewPartLocalPosY = -153
    LuaGameObject.SetLocalPositionGO(self.previewPart, 0, self.PreviewPartLocalPosY, 0)
  end
  self.refineCost2Ctrl:ResetDatas(matDatas)
  local cells = self.refineCost2Ctrl:GetCells()
  for i = 1, #cells do
    cells[i]:ActiveClickTip(false)
  end
  if self.needZenyType then
    self.priceIndicator:SetActive(true)
    local iconName = Table_Item[self.needZenyType] and Table_Item[self.needZenyType].Icon or ""
    IconManager:SetItemIcon(iconName, self.priceSp)
    self.priceNum = self.needZeny or 0
    if _checkCost(self.needZenyType, self.needZeny) then
      self.priceNumLabel.text = self.priceNum
    else
      self.priceNumLabel.text = string.format("[c][fb725f]%s[-][/c]", self.priceNum)
    end
    TimeTickManager.Me():CreateOnceDelayTick(16, function(self)
      self.priceTable:Reposition()
    end, self)
  else
    self.priceIndicator:SetActive(false)
  end
end
function RefineTransferView:GetTransferCost()
  return mFGetTransferCost(self.targetOutData, self.targetInData)
end
function RefineTransferView:SuccessUpdate()
  RefineTransferView.super.SuccessUpdate(self)
  self:UpdatePrice()
end
