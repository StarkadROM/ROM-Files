autoImport("EquipRefineBord")
autoImport("EquipNewChooseBord")
autoImport("CommonNewTabListCell")
autoImport("BagItemNewCell")
autoImport("DecomposeItemCell")
NpcRefinePanel = class("NpcRefinePanel", ContainerView)
autoImport("RefineCombineView")
NpcRefinePanel.BrotherView = RefineCombineView
NpcRefinePanel.ViewType = UIViewType.NormalLayer
NpcRefinePanel.RefineBordControl = EquipRefineBord
NpcRefinePanel.PfbPath = "part/EquipRefineBord"
NpcRefinePanel.TabName = {
  RefineTab = ZhString.NpcRefinePanel_RefineTabName,
  OneClickTab = ZhString.NpcRefinePanel_OneClickTabName
}
local npcRefineAction = "functional_action"
local oneClickRefineTargetBagTypeList = {
  BagProxy.BagType.RoleEquip,
  BagProxy.BagType.MainBag
}
local blackSmith
local tempVector3 = LuaVector3()
local CHOOSECOLOR = LuaColor(0.3607843137254902, 0.3843137254901961, 0.5647058823529412, 1)
local UNCHOOSECOLOR = LuaColor.White()
function NpcRefinePanel:Init()
  if not blackSmith then
    blackSmith = BlackSmithProxy.Instance
  end
  self.isCombine = self.viewdata.viewdata and self.viewdata.viewdata.isCombine
  self.isfashion = self.viewdata.viewdata and self.viewdata.viewdata.isfashion
  self:InitView()
  self:MapEvent()
end
function NpcRefinePanel:InitView()
  self.leftSideBar = self:FindGO("LeftSideBar")
  self.leftSideBar:SetActive(self.isCombine ~= true)
  self.bg = self:FindComponent("PanelBg", UISprite)
  self.colliderMask = self:FindGO("ColliderMask")
  self.chooseContainer = self:FindGO("ChooseContainer")
  self.chooseBord = EquipNewChooseBord.new(self.chooseContainer)
  self.chooseBord:SetFilterPopData(self.isfashion and GameConfig.SewingRefineFilter or GameConfig.EquipRefineFilter)
  self.chooseBord:Hide()
  self.countChooseBord = EquipNewCountChooseBord.new(self.chooseContainer)
  self.countChooseBord:AddEventListener(EquipChooseCellEvent.CountChooseChange, self.OnCountChooseChange, self)
  self.countChooseBord:Hide()
  local cells = self.chooseBord.chooseCtl:GetCells()
  for _, c in pairs(cells) do
    c:SetShowStrengthLvOfItem(false)
  end
  self.tabGrid = self:FindGO("TabGrid")
  self.refineBord = self:FindGO("RefineParent")
  self.oneClickRefineBord = self:FindGO("OneClickParent")
  self.refineTab = self:FindGO("RefineTab")
  self.refineTabCell = CommonNewTabListCell.new(self.refineTab)
  self.refineTabCell:SetIcon("tab_icon_86")
  self.refineTabCell:AddEventListener(MouseEvent.MouseClick, self.OnClickRefineTab, self)
  self.oneClickRefineTab = self:FindGO("OneClickTab")
  self.oneClickRefineTabCell = CommonNewTabListCell.new(self.oneClickRefineTab)
  self.oneClickRefineTabCell:SetIcon("tab_icon_87")
  self.oneClickRefineTabCell:AddEventListener(MouseEvent.MouseClick, self.OnClickOneClickRefineTab, self)
  self.combineTab = self:FindGO("CombineRefineTab")
  self.combineTab_BgTrans = self:FindComponent("FBg", Transform, self.combineTab)
  self.combineTab_icon = self:FindComponent("Icon", UISprite, self.combineTab)
  self.combineTab_icon_1 = self:FindComponent("Icon_1", UISprite, self.combineTab)
  self.combineChoose = false
  self:AddClickEvent(self.combineTab, function(go)
    self.combineChoose = not self.combineChoose
    if self.combineChoose then
      tempVector3:Set(24, 0, 0)
      self.combineTab_BgTrans.localPosition = tempVector3
      self.combineTab_icon.color = UNCHOOSECOLOR
      self.combineTab_icon_1.color = CHOOSECOLOR
    else
      tempVector3:Set(-24, 0, 0)
      self.combineTab_BgTrans.localPosition = tempVector3
      self.combineTab_icon.color = CHOOSECOLOR
      self.combineTab_icon_1.color = UNCHOOSECOLOR
    end
    self:UpdateCombineBord()
  end)
  local userRob = self:FindGO("Silver")
  local symbol = self:FindComponent("symbol", UISprite, userRob)
  IconManager:SetItemIcon(Table_Item[GameConfig.MoneyId.Zeny].Icon, symbol)
  self.robLabel = self:FindComponent("Label", UILabel, userRob)
  self:AddButtonEvent("SilverAddBtn", function()
    FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit, FunctionNewRecharge.InnerTab.Deposit_Zeny)
  end)
  self:LoadPreferb(self.PfbPath, self.refineBord, true)
  self.bord_Control = self.RefineBordControl.new(self.refineBord, self.isfashion)
  self.bord_Control:AddEventListener(EquipRefineBord_Event.ClickTargetCell, self.ClickAddEquipButtonCall, self)
  self.bord_Control:AddEventListener(EquipRefineBord_Event.DoRefine, self.DoRefineCall, self)
  self.bord_Control:AddEventListener(EquipRefineBord_Event.DoRepair, self.DoRepairCall, self)
  self.leftTipBord = self:FindGO("LeftTipBord")
  self.leftTipBord_tip = self:FindComponent("RefineTip", UILabel, self.leftTipBord)
  self.leftTipBord_ShareBtn = self:FindGO("ShareBtn", self.leftTipBord)
  self.leftTipBord_ShareBtn:SetActive(false)
  self:AddClickEvent(self.leftTipBord_ShareBtn, function()
    local nowData = self.bord_Control:GetNowItemData()
    FloatAwardView.ShowRefineShareViewNew(nowData)
    self.leftTipBord_ShareBtn:SetActive(false)
  end)
  local tabList, longPress = {
    self.refineTab,
    self.oneClickRefineTab
  }, nil
  for _, v in ipairs(tabList) do
    longPress = v:GetComponent(UILongPress)
    function longPress.pressEvent(obj, state)
      self:PassEvent(TipLongPressEvent.NpcRefinePanel, {
        state,
        obj.gameObject
      })
    end
  end
  self:AddEventListener(TipLongPressEvent.NpcRefinePanel, self.HandleLongPress, self)
  self:InitOneClickRefine()
  self:InitShopEnter()
end
function NpcRefinePanel:InitShopEnter()
  self.shopEnterBtn = self:FindGO("LeftSideBar/ShopEnter")
  self:AddClickEvent(self.shopEnterBtn, function()
    self:SetPushToStack(true)
    HappyShopProxy.Instance:InitShop(self.npcData, 1, 850)
    FunctionNpcFunc.JumpPanel(PanelConfig.HappyShop, {
      npcdata = self.npcInfo,
      viewPort = CameraConfig.SwingMachine_ViewPort,
      rotation = CameraConfig.SwingMachine_Rotation
    })
  end)
end
function NpcRefinePanel:UpdateCombineBord()
  if self.combineChoose then
    self:OnClickOneClickRefineTab()
  else
    self:OnClickRefineTab()
  end
end
function NpcRefinePanel:OnClickRefineTab()
  self.refineBord:SetActive(true)
  self.oneClickRefineBord:SetActive(false)
  self.bord_Control:HideAllChooseBord()
  self:SetTargetItem(nil)
  self.chooseBord:Hide()
  self:ClickAddEquipButtonCall()
end
function NpcRefinePanel:OnClickOneClickRefineTab()
  self.refineBord:SetActive(false)
  self.oneClickRefineBord:SetActive(true)
  self.bord_Control:HideAllChooseBord()
  self:ResetOneClickRefine(true)
  TipManager.CloseTip()
end
function NpcRefinePanel:InitOneClickRefine()
  self.oneClickTipLabel = self:FindComponent("OneClickTipLabel", UILabel)
  self.oneClickBeforePanel = self:FindGO("OneClickBeforePanel")
  self:AddButtonEvent("OneClickRefineBtn", function()
    local matEnough, robEnough = self:CheckOneClickMat()
    if not matEnough then
      QuickBuyProxy.Instance:TryOpenView(self.lackItems, QuickBuyProxy.QueryType.NoDamage)
      return
    end
    if not robEnough then
      MsgManager.ShowMsgByID(40803)
      return
    end
    if not self.oneClickServerMats then
      self.oneClickServerMats = {}
    else
      TableUtility.ArrayClear(self.oneClickServerMats)
    end
    for i = 1, #self.oneClickChooseEquips do
      table.insert(self.oneClickServerMats, self.oneClickChooseEquips[i]:ExportServerItemInfo())
    end
    if #self.oneClickServerMats > 0 then
      self:DoOneClickRefine()
    end
  end)
  self.oneClickMatCtl = ListCtrl.new(self:FindComponent("OneClickMatGrid", UIGrid), MaterialItemNewCell, "MaterialItemNewCell")
  self.oneClickMatCtl:AddEventListener(MouseEvent.MouseClick, self.HandleClickOneClickMatCell, self)
  self.oneClickChooseCtl = WrapListCtrl.new(self:FindGO("ChoosenEquipWrap"), BagItemNewCell, "BagItemNewCell", WrapListCtrl_Dir.Vertical, 6, 84)
  self.oneClickChooseCtl:AddEventListener(MouseEvent.MouseClick, self.HandleChooseOneClickItem, self)
  local cells = self.oneClickChooseCtl:GetCells()
  for _, c in pairs(cells) do
    c.forbidShowStrengthLv = true
  end
  self.oneClickChooseEquips = {}
  self.oneClickPriceTable = self:FindComponent("OneClickPriceIndicator", UITable)
  self.oneClickCoinIcon = self:FindComponent("CoinIcon", UISprite, self.oneClickBeforePanel)
  self.oneClickCoinNumLabel = self:FindComponent("CoinNum", UILabel, self.oneClickBeforePanel)
  self.oneClickOriginalCoinNumLabel = self:FindComponent("OriginalCoinNum", UILabel, self.oneClickBeforePanel)
  IconManager:SetItemIcon("item_100", self.oneClickCoinIcon)
  self:ResetOneClickRefine()
  self.oneClickRefineBord:SetActive(false)
end
local tipOffset = {-180, 0}
function NpcRefinePanel:HandleClickOneClickMatCell(cellCtl)
  if not self.tipData then
    self.tipData = {}
  end
  self.tipData.itemdata = cellCtl.data
  self.tipData.ignoreBounds = cellCtl.gameObject
  TipManager.Instance:ShowItemFloatTip(self.tipData, self.bg, NGUIUtil.AnchorSide.Left, tipOffset)
end
function NpcRefinePanel:HandleChooseOneClickItem(cellCtl)
  if type(cellCtl.data) ~= "table" then
    return
  end
  for i = 1, #self.oneClickChooseEquips do
    if self.oneClickChooseEquips[i].id == cellCtl.data.id then
      table.remove(self.oneClickChooseEquips, i)
      break
    end
  end
  self:UpdateOneClickChooseEquip()
  if not self.chooseBord.gameObject.activeInHierarchy then
    self:ShowOneClickRefineChooseBord()
  else
    self:UpdateCountChooseBord()
  end
end
function NpcRefinePanel:DoOneClickRefine()
  FunctionSecurity.Me():TryVerifySecurity(function(mats)
    ServiceItemProxy.Instance:CallBatchRefineItemCmd(mats, nil, self.npcguid or 0)
  end, self.oneClickServerMats)
end
local addOneClickMat = function(mats, sId, needNum)
  local matData = TableUtility.ArrayFindByPredicate(mats, function(mat, id)
    return mat.staticData.id == id
  end, sId)
  if matData then
    matData.neednum = matData.neednum + needNum
  else
    matData = ItemData.new(MaterialItemCell.MaterialType.Material, sId)
    matData.num = BagProxy.Instance:GetItemNumByStaticID(sId, GameConfig.PackageMaterialCheck.refine)
    matData.neednum = needNum
    table.insert(mats, matData)
  end
end
local tempOneClickMatData
function NpcRefinePanel:CheckOneClickMat()
  self.lackItems = self.lackItems or {}
  TableUtility.TableClear(self.lackItems)
  if not tempOneClickMatData then
    tempOneClickMatData = ItemData.new()
  end
  local discount = blackSmith:GetEquipOptDiscounts(ActivityCmd_pb.GACTIVITY_NORMAL_REFINE)
  discount = discount and discount[1]
  local homeWorkbenchDiscount = HomeManager.Me():TryGetHomeWorkbenchDiscount("Refine")
  local mats, matEnough, zeny, origZeny = ReusableTable.CreateArray(), true, 0, 0
  local sId, initialRefineLv, isLottery, composeIds, composeId, composeSData, bcItems, bcd, num, neednum, realDiscount, equipnum
  for i = 1, #self.oneClickChooseEquips do
    sId = self.oneClickChooseEquips[i].staticData.id
    tempOneClickMatData:ResetData("TempMat", sId)
    initialRefineLv = self.oneClickChooseEquips[i].equipInfo.refinelv
    isLottery = LotteryProxy.Instance:IsLotteryEquip(sId)
    if not isLottery then
    else
      realDiscount = discount or homeWorkbenchDiscount
    end
    equipnum = self.oneClickChooseEquips[i].num or 1
    for j = initialRefineLv, 3 do
      tempOneClickMatData.equipInfo.refinelv = j
      composeIds = blackSmith:GetComposeIDsByItemData(tempOneClickMatData)
      composeId = composeIds and composeIds[1]
      composeSData = composeId and Table_Compose[composeId]
      if composeSData then
        bcItems = composeSData.BeCostItem
        for m = 1, equipnum do
          for k = 1, #bcItems do
            bcd = bcItems[k]
            addOneClickMat(mats, bcd.id, bcd.num)
          end
          origZeny = origZeny + composeSData.ROB
          zeny = zeny + math.floor(composeSData.ROB * realDiscount / 100 + 0.01)
        end
      end
    end
  end
  for _, mat in pairs(mats) do
    num, neednum = mat.num, mat.neednum
    if neednum and num < neednum then
      table.insert(self.lackItems, {
        id = mat.staticData.id,
        count = neednum - num
      })
      matEnough = false
    end
  end
  self.oneClickMatCtl:ResetDatas(mats)
  local robEnough = zeny <= MyselfProxy.Instance:GetROB()
  if robEnough then
    self.oneClickCoinNumLabel.text = zeny
  else
    self.oneClickCoinNumLabel.text = string.format("[c][fb725f]%s[-][/c]", zeny)
  end
  self.oneClickOriginalCoinNumLabel.text = origZeny
  self.oneClickOriginalCoinNumLabel.gameObject:SetActive(not math.Approximately(zeny, origZeny))
  TimeTickManager.Me():CreateOnceDelayTick(16, function(self)
    self.oneClickPriceTable:Reposition()
  end, self)
  ReusableTable.DestroyAndClearArray(mats)
  return matEnough, robEnough
end
function NpcRefinePanel:RecvOneClickRefineResult(note)
  local b = note and note.body
  if b and b.result then
    TableUtility.TableClear(self.oneClickChooseEquips)
    self:UpdateOneClickChooseEquip()
    self:UpdateCountChooseBord()
    MsgManager.ShowMsgByID(229)
  else
    MsgManager.FloatMsg(nil, ZhString.NpcRefinePanel_Failed)
  end
end
function NpcRefinePanel:ClickAddEquipButtonCall(control)
  self.countChooseBord:Hide()
  local datas = self:GetChooseBordDatas()
  self.chooseBord:ResetDatas(datas, true)
  self.chooseBord:Show(nil, function(self, data)
    self:SetTargetItem(data)
    self.chooseBord:Hide()
  end, self)
  local nowData = self.bord_Control:GetNowItemData()
  if nowData then
    self.chooseBord:SetChoose(nowData)
  end
  self.chooseBord:SetBordTitle(ZhString.NpcRefinePanel_ChooseEquip)
end
function NpcRefinePanel:SetTargetItem(data)
  self.bord_Control:SetTargetItem(data)
  self:UpdateLeftTipBord(data)
end
function NpcRefinePanel:UpdateLeftTipBord(data)
  if data and data.equipInfo then
    self.leftTipBord:SetActive(true)
    if data.equipInfo.damage then
      self.leftTipBord_tip.text = ZhString.NpcRefinePanel_RepairTip
    else
      local maxRefineLv = blackSmith:MaxRefineLevelByData(data.staticData)
      if self.isfashion then
        self.leftTipBord_tip.text = string.format(ZhString.NpcRefinePanel_FashionRefineTip)
      else
        self.leftTipBord_tip.text = string.format(ZhString.NpcRefinePanel_RefineTip, maxRefineLv)
      end
    end
  else
    self.leftTipBord:SetActive(false)
  end
end
function NpcRefinePanel:UpdateOneClickChooseEquip()
  self.oneClickChooseCtl:ResetDatas(self.oneClickChooseEquips, false)
  local hasChoose = #self.oneClickChooseEquips > 0
  self.oneClickTipLabel.gameObject:SetActive(not hasChoose)
  self.oneClickBeforePanel:SetActive(hasChoose)
  self:CheckOneClickMat()
end
function NpcRefinePanel:ResetOneClickRefine(isShowChooseBord)
  TableUtility.TableClear(self.oneClickChooseEquips)
  self:UpdateOneClickChooseEquip()
  self:UpdateLeftTipBord()
  if isShowChooseBord then
    self:ShowOneClickRefineChooseBord()
  else
    self.chooseBord:Hide()
    self.countChooseBord:Hide()
  end
end
function NpcRefinePanel:RefreshOneClickEquipDatas()
  self.oneClickEquipDatas = self.oneClickEquipDatas or {}
  TableUtility.TableClear(self.oneClickEquipDatas)
  local bagIns, arrayFind = BagProxy.Instance, TableUtility.ArrayFindIndex
  local bagItems, item, equipInfo, refineLv
  for i = 1, #oneClickRefineTargetBagTypeList do
    bagItems = bagIns:GetBagByType(oneClickRefineTargetBagTypeList[i]):GetItems()
    if bagItems then
      for j = 1, #bagItems do
        item = bagItems[j]
        equipInfo = item.equipInfo
        refineLv = equipInfo and self.refine_equiptype_map[equipInfo.equipData.EquipType] and equipInfo:CanRefine() and equipInfo.refinelv
        if refineLv and refineLv < 4 and not equipInfo.damage and not bagIns:CheckIsFavorite(item) then
          table.insert(self.oneClickEquipDatas, item)
        end
      end
    end
  end
  BlackSmithProxy.SortEquips(self.oneClickEquipDatas)
end
function NpcRefinePanel:ShowOneClickRefineChooseBord()
  self.chooseBord:Hide()
  self.countChooseBord:Show()
  self:RefreshOneClickEquipDatas()
  self:UpdateCountChooseBord()
end
function NpcRefinePanel:OnCountChooseChange(cell)
  local config = GameConfig.FastRefineLimit
  local data, chooseCount = cell.data, cell.chooseCount
  if chooseCount > config.EquipNumPerGrid then
    cell:SetChooseCount(config.EquipNumPerGrid)
    chooseCount = config.EquipNumPerGrid
    MsgManager.ShowMsgByID(244)
  end
  local chooseData, index
  for i = #self.oneClickChooseEquips, 1, -1 do
    if self.oneClickChooseEquips[i].id == data.id then
      chooseData = self.oneClickChooseEquips[i]
      index = i
      break
    end
  end
  if index == nil and #self.oneClickChooseEquips >= config.MaxGrid then
    cell:SetChooseCount(0)
    chooseCount = 0
    MsgManager.ShowMsgByID(244)
  end
  if chooseCount == 0 then
    if index then
      table.remove(self.oneClickChooseEquips, index)
    end
  elseif chooseData then
    chooseData.num = chooseCount
  else
    local newData = data:Clone()
    newData.num = chooseCount
    table.insert(self.oneClickChooseEquips, newData)
  end
  self:UpdateOneClickChooseEquip()
  self:UpdateCountChooseBord()
end
function NpcRefinePanel:UpdateCountChooseBord()
  self.countChooseBord:ResetDatas(self.oneClickEquipDatas)
  self.countChooseBord:SetUseItemNum(true)
  self.countChooseBord:SetChoose()
  self.countChooseBord:SetChooseReference(self.oneClickChooseEquips)
end
function NpcRefinePanel:RemoveLeanTween()
  if self.lt then
    self.lt:Destroy()
  end
  self.lt = nil
end
function NpcRefinePanel:DoRefineCall(control)
  self:RemoveLeanTween()
  self:ActiveLock(true)
  self.wait_refresh = true
  local delayTime = GameConfig.EquipRefine.delay_time
  self.lt = TimeTickManager.Me():CreateOnceDelayTick(delayTime, function(owner, deltaTime)
    self.wait_refresh = false
    self:RefineEnd()
  end, self)
  local ncpinfo = self:GetCurNpc()
  if ncpinfo then
    ncpinfo:Client_PlayAction(npcRefineAction, nil, false)
  end
  self.chooseBord:Hide()
end
function NpcRefinePanel:DoRepairCall(control)
  self:ActiveLock(true)
  self:RemoveLeanTween()
  self.wait_refresh = true
  self.lt = TimeTickManager.Me():CreateOnceDelayTick(2000, function(owner, deltaTime)
    self.wait_refresh = false
    self:RepairEnd()
  end, self)
  local ncpinfo = self:GetCurNpc()
  if ncpinfo then
    ncpinfo:Client_PlayAction(npcRefineAction, nil, false)
  end
  self.chooseBord:Hide()
end
function NpcRefinePanel:UpdateCoins()
  self.robLabel.text = StringUtil.NumThousandFormat(MyselfProxy.Instance:GetROB())
end
function NpcRefinePanel:ActiveLock(b)
  self.colliderMask:SetActive(b)
end
function NpcRefinePanel:RefineEnd()
  local needShare = false
  if self.result == SceneItem_pb.EREFINERESULT_SUCCESS then
    needShare = true
    AudioUtil.Play2DRandomSound(AudioMap.Maps.Refinesuccess)
  else
    AudioUtil.Play2DRandomSound(AudioMap.Maps.Refinefail)
  end
  self.bord_Control:ShowTempResult(self.result)
  if AppBundleConfig.GetSocialShareInfo() == nil then
    needShare = false
  end
  self.result = nil
  self:RemoveLeanTween()
  self.lt = TimeTickManager.Me():CreateOnceDelayTick(1000, function(self)
    self:ActiveLock(false)
    self.bord_Control:Refresh()
    self:UpdateLeftTipBord(self.bord_Control:GetNowItemData())
    local nowData = self.bord_Control:GetNowItemData()
    if nowData and nowData.equipInfo.damage then
      MsgManager.ShowMsgByIDTable(230)
    end
    local refineMaxLevel2 = 15
    local equipData = Table_Equip[nowData.staticData.id]
    if equipData then
      refineMaxLevel2 = equipData.RefineMaxlv
    end
    if needShare then
      local refinelv = nowData.equipInfo.refinelv
      if refinelv == refineMaxLevel2 then
        FloatAwardView.ShowRefineShareViewNew(nowData)
        self.leftTipBord_ShareBtn:SetActive(false)
      elseif refinelv >= 9 then
        self.leftTipBord_ShareBtn:SetActive(true)
      else
        self.leftTipBord_ShareBtn:SetActive(false)
      end
    else
      self.leftTipBord_ShareBtn:SetActive(false)
    end
  end, self)
end
function NpcRefinePanel:RepairEnd()
  local nowData = self.bord_Control:GetNowItemData()
  MsgManager.ShowMsgByIDTable(221, {
    nowData.staticData.NameZh
  })
  self.bord_Control:PlayEffect()
  local assetRole = Game.Myself.assetRole
  assetRole:PlayEffectOneShotOn(EffectMap.Maps.ForgingSuccess, RoleDefines_EP.Top)
  self:RemoveLeanTween()
  self.lt = TimeTickManager.Me():CreateOnceDelayTick(1000, function(owner, deltaTime)
    self:ActiveLock(false)
    self.bord_Control:Refresh()
    self:UpdateLeftTipBord(self.bord_Control:GetNowItemData())
  end, self)
  AudioUtil.Play2DRandomSound(AudioMap.Maps.Refinesuccess)
end
function NpcRefinePanel:MapEvent()
  self:AddListenEvt(MyselfEvent.ZenyChange, self.UpdateCoins)
  self:AddListenEvt(ServiceEvent.ItemEquipRefine, self.RecvRefineResult)
  self:AddListenEvt(ServiceEvent.ItemEquipRepair, self.RecvUpdateRefineInfo)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.RecvUpdateRefineInfo)
  self:AddListenEvt(ItemEvent.EquipUpdate, self.RecvUpdateRefineInfo)
  self:AddListenEvt(ServiceEvent.ActivityCmdStartGlobalActCmd, self.RecvUpdateRefineInfo)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
  self:AddListenEvt(LoadSceneEvent.BeginLoadScene, self.CloseSelf)
  self:AddListenEvt(ServiceEvent.ItemBatchRefineItemCmd, self.RecvOneClickRefineResult)
end
function NpcRefinePanel:RecvUpdateRefineInfo(note)
  if self.wait_refresh == true then
    return
  end
  self.bord_Control:Refresh()
  if self.oneClickRefineBord.activeSelf then
    self:CheckOneClickMat()
    self:ShowOneClickRefineChooseBord()
  end
end
function NpcRefinePanel:RecvRefineResult(note)
  if self.bord_Control == nil then
    return
  end
  local nowItem = self.bord_Control:GetNowItemData()
  if nowItem == nil then
    return
  end
  self.result = note.body.eresult
end
function NpcRefinePanel:GetCurNpc()
  if self.npcguid then
    return NSceneNpcProxy.Instance:Find(self.npcguid)
  end
  return nil
end
function NpcRefinePanel:GetChooseBordDatas()
  return blackSmith:GetRefineEquips(self.refine_equiptype_map, self.isfashion)
end
function NpcRefinePanel:InitValidRefineEquipType()
  self.refine_equiptype_map = {}
  if self.isfashion then
    local buildingData = GuildBuildingProxy.Instance:GetBuildingDataByType(GuildBuildingProxy.Type.EGUILDBUILDING_MAGIC_SEWING)
    if buildingData then
      local unlockParam = buildingData.staticData and buildingData.staticData.UnlockParam
      local equipConfig = unlockParam.equip
      if equipConfig and equipConfig.refine_type then
        for i = 1, #equipConfig.refine_type do
          self.refine_equiptype_map[equipConfig.refine_type[i]] = 1
        end
        self.bord_Control:SetMaxRefineLv(equipConfig.refinemaxlv)
      end
    end
    self.leftTipBord_tip.text = string.format(ZhString.NpcRefinePanel_FashionRefineTip)
  else
    TableUtility.TableShallowCopy(self.refine_equiptype_map, BlackSmithProxy.GetRefineEquipTypeMap())
  end
end
function NpcRefinePanel:HandleLongPress(param)
  local isPressing, go = param[1], param[2]
  TabNameTip.OnLongPress(isPressing, NpcRefinePanel.TabName[go.name], false, self:FindComponent("Sprite", UISprite, go))
end
function NpcRefinePanel:OnEnter()
  NpcRefinePanel.super.OnEnter(self)
  self:InitValidRefineEquipType()
  self.npcInfo = self.viewdata.viewdata and self.viewdata.viewdata.npcdata
  self.npcguid = self.npcInfo and self.npcInfo.data.id
  self.bord_Control:SetNpcguid(self.npcguid)
  if self.npcInfo then
    local rootTrans = self.npcInfo.assetRole.completeTransform
    if self.isfashion then
      self:CameraFocusAndRotateTo(rootTrans, CameraConfig.SwingMachine_ViewPort, CameraConfig.SwingMachine_Rotation)
    else
      self:CameraFocusAndRotateTo(rootTrans, CameraConfig.GuildMaterial_Choose_ViewPort, CameraConfig.GuildMaterial_Choose_Rotation)
    end
  else
    self:CameraFocusToMe()
  end
  self:UpdateCoins()
  self:SetTargetItem(nil)
  self:ClickAddEquipButtonCall()
  local useItemId = self.viewdata.viewdata and self.viewdata.viewdata.useItemId
  self.combineTab:SetActive(useItemId == nil)
  local isOneClick = self.viewdata.viewdata and self.viewdata.viewdata.isOneClick
  if isOneClick then
    self:OnClickOneClickRefineTab()
  else
    local OnClickChooseBordCell_data = self.viewdata.viewdata and self.viewdata.viewdata.OnClickChooseBordCell_data
    if OnClickChooseBordCell_data then
      self:SetTargetItem(OnClickChooseBordCell_data)
      self.chooseBord:Hide()
    end
  end
end
function NpcRefinePanel:OnShow()
  Game.Myself:UpdateEpNodeDisplay(true)
end
function NpcRefinePanel:OnExit()
  NpcRefinePanel.super.OnExit(self)
  self.wait_refresh = false
  self:RemoveLeanTween()
  self.bord_Control:OnExit()
  self:CameraReset()
end
