autoImport("HeadwearRefineBord")
autoImport("NpcRefinePanel")
HeadwearRefinePanel = class("HeadwearRefinePanel", NpcRefinePanel)
HeadwearRefinePanel.ViewType = UIViewType.NormalLayer
HeadwearRefinePanel.RefineBordControl = HeadwearRefineBord
local tempArr, matPriorityArr = {}, {}
function HeadwearRefinePanel:InitView()
  HeadwearRefinePanel.super.InitView(self)
  self.gameObject.name = self.__cname
  self.bord_Control:AddEventListener(EquipRefineBord_Event.ClickMatCell, self.ClickMatCell, self)
  self.chooseBord.needSetCheckValidFuncOnShow = false
  self.chooseBord:Set_CheckValidFunc(self.CheckItemCanRefine, self, ZhString.HeadwearRefinePanel_ChooseCellInvalidTip, true)
  self:TryInitMatPriorityArr()
  self.tabGrid:SetActive(false)
  self:FindGO("HelpButton"):SetActive(false)
  if self.viewdata.viewdata then
    self:SetTargetItem(nil)
    self:RefreshStaticDatas(self.viewdata.viewdata.useItemId)
    self:TryRefreshMaterial()
  else
    LogUtility.Error("Cannot do headwear refine without viewdata!")
  end
end
function HeadwearRefinePanel:TryInitMatPriorityArr()
  if next(matPriorityArr) then
    return
  end
  for _, data in pairs(Table_UseItem) do
    if data.UseEffect.type == "refine" then
      TableUtility.ArrayPushBack(matPriorityArr, data)
    end
  end
  table.sort(matPriorityArr, function(l, r)
    local lLevel = l.UseEffect.refine_level or 0
    local rLevel = r.UseEffect.refine_level or 0
    return lLevel > rLevel
  end)
end
function HeadwearRefinePanel:InitValidRefineEquipType()
end
function HeadwearRefinePanel:InitOneClickRefine()
end
function HeadwearRefinePanel:ResetOneClickRefine()
end
function HeadwearRefinePanel:ClickAddEquipButtonCall(control)
  HeadwearRefinePanel.super.ClickAddEquipButtonCall(self, control)
  self.chooseBord:SetBordTitle(ZhString.HeadwearRefinePanel_ChooseEquip)
end
function HeadwearRefinePanel:ClickMatCell(materialBord)
  TableUtility.ArrayClear(tempArr)
  local items
  for i = 1, #matPriorityArr do
    items = BagProxy.Instance:GetItemsByStaticID(matPriorityArr[i].id)
    if items then
      for j = 1, #items do
        TableUtility.ArrayPushBack(tempArr, items[j])
      end
    end
  end
  materialBord:ResetDatas(tempArr, true)
  materialBord:Show(nil, self.OnMaterialChoose, self)
  materialBord.noneTipLabel.text = ZhString.HeadwearRefinePanel_LongPressForDetail
end
function HeadwearRefinePanel:GetChooseBordDatas()
  TableUtility.ArrayClear(tempArr)
  local items = BagProxy.Instance:GetBagItemsByTypes(self.targetItemTypes)
  if items then
    for i = 1, #items do
      table.insert(tempArr, items[i])
    end
  end
  local roleEquips = BagProxy.Instance:GetBagItemsByTypes(self.targetItemTypes, BagProxy.BagType.RoleEquip)
  if roleEquips then
    for i = 1, #roleEquips do
      table.insert(tempArr, roleEquips[i])
    end
  end
  table.sort(tempArr, function(l, r)
    if l.equiped ~= r.equiped then
      return l.equiped > r.equiped
    end
    local lRefine, rRefine = self:CheckItemCanRefine(r) and 1 or self:CheckItemCanRefine(l) and 1 or 0, 0
    return lRefine > rRefine
  end)
  return tempArr
end
function HeadwearRefinePanel:OnMaterialChoose(datas)
  if next(datas) then
    self:RefreshStaticDatas(datas[1].staticData.id)
    self:TryRefreshMaterial()
    self:UpdateLeftTipBord(self.bord_Control.itemData)
  end
  self.bord_Control.materialChooseBord:Hide()
end
function HeadwearRefinePanel:RefineEnd()
  HeadwearRefinePanel.super.RefineEnd(self)
  self:TryRefreshMaterial()
end
function HeadwearRefinePanel:UpdateLeftTipBord(data)
  if data and data.equipInfo then
    self.leftTipBord:SetActive(true)
    self.leftTipBord_tip.text = string.format(ZhString.NpcRefinePanel_RefineTip, self.useEffect.refine_level)
  else
    self.leftTipBord:SetActive(false)
  end
end
function HeadwearRefinePanel:CheckItemCanRefine(item)
  local equipInfo = item.equipInfo
  return equipInfo and equipInfo:CanRefine() and not equipInfo.damage and (self.includeTradeItem or not ItemData.CheckItemCanTrade(item.staticData.id))
end
function HeadwearRefinePanel:RefreshStaticDatas(useItemId)
  self.useItemId = useItemId
  self.useEffect = Table_UseItem[useItemId] and Table_UseItem[useItemId].UseEffect
  if not self.useEffect then
    LogUtility.Error("Cannot find UseEffect of item with id = {0}!", useItemId)
    self:CloseSelf()
    return
  end
  self.targetItemTypes = self.useEffect.item_types
  self.includeTradeItem = self.useEffect.only_no_exchange == 0
  self.bord_Control:SetMaxRefineLv(self.useEffect.refine_level)
  self.bord_Control:SetIncludeTradeItem(self.includeTradeItem)
end
function HeadwearRefinePanel:TryRefreshMaterial()
  if self.bord_Control:SetMaterial(self.useItemId) then
    return true
  end
  for i = 1, #matPriorityArr do
    if self.bord_Control:SetMaterial(matPriorityArr[i].id) then
      self:RefreshStaticDatas(matPriorityArr[i].id)
      return true
    end
  end
  return false
end
