autoImport("DeComposeView")
DeComposeNewView = class("DeComposeNewView", DeComposeView)
autoImport("ItemData")
autoImport("EquipNewChooseBord_Simple")
autoImport("BagItemNewCell")
autoImport("DecomposeItemNewCell")
DeComposeNewView.ViewType = UIViewType.NormalLayer
DeComposeNewView.BrotherView = EquipRecoverCombinedView
function DeComposeNewView:OnEnter()
  if self.npcdata then
    local npcRootTrans = self.npcdata.assetRole.completeTransform
    if npcRootTrans then
      self:CameraFocusOnNpc(npcRootTrans)
    end
  end
  if self.isCombine then
    self.content.transform.localPosition = LuaGeometry.GetTempVector3(-72, 0, 0)
    self.closeButton:SetActive(false)
  else
    self.content.transform.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
    self.closeButton:SetActive(true)
  end
  self:UpdateCoins()
  self:UpdateChooseBord()
end
function DeComposeNewView:Init()
  local viewdata = self.viewdata.viewdata
  self.npcdata = viewdata and viewdata.npcdata
  self.isCombine = viewdata and viewdata.isCombine
  self:InitUI()
  self:MapEvent()
end
function DeComposeNewView:InitUI()
  self.content = self:FindGO("Content")
  self.closeButton = self:FindGO("CloseButton")
  self.title = self:FindComponent("Title", UILabel)
  self.decomposeBord = self:FindGO("RecoverPreview")
  self.resultGrid = self:FindComponent("ResultGrid", UIGrid)
  self.resultCtl = UIGridListCtrl.new(self.resultGrid, DecomposeItemNewCell, "ItemNewCell")
  self.resultCtl:AddEventListener(MouseEvent.MouseClick, self.clickResultCell, self)
  self.businessTip = self:FindGO("BusinessTip")
  self.businessTip_1 = self:FindComponent("Tip1", UILabel)
  self.businessTip_2 = self:FindComponent("Tip2", UILabel)
  self.cost = self:FindComponent("Cost", UILabel)
  self.cost.text = 0
  local l_zenyIcon = self:FindComponent("Sprite", UISprite, self.cost.gameObject)
  IconManager:SetItemIcon("item_100", l_zenyIcon)
  local coins = self:FindChild("TopCoins")
  self.userRob = self:FindChild("Silver", coins)
  self.robLabel = self:FindComponent("Label", UILabel, self.userRob)
  local symbol = self:FindComponent("symbol", UISprite, self.userRob)
  IconManager:SetItemIcon(Table_Item[GameConfig.MoneyId.Zeny].Icon, symbol)
  self.bg = self:FindComponent("Bg", UISprite)
  self.waittingSymbol = self:FindGO("WaittingSymbol")
  self.chooseBord = EquipNewChooseBord_Simple.new(self:FindGO("ChooseContainer"), function()
    return self:GetDecomposeEquips()
  end)
  self.chooseBord:SetFilterPopData(GameConfig.EquipChooseFilter)
  self.chooseBord:AddEventListener(EquipChooseBord.ChooseItem, self.ChooseItem, self)
  self.chooseBord:Hide()
  self.addbord = self:FindGO("EmptyTip")
  self.colliderMask = self:FindGO("ColliderMask")
  self:AddButtonEvent("StartButton", function(go)
    return self:StartDeCompose()
  end)
  self.decomposeBord:SetActive(false)
  self.chooseEquips = {}
  self.choosenPanel = self:FindGO("ChoosenPanel")
  local chosenEquipWrapGO = self:FindGO("ChoosenEquipWrap")
  self.choosenEquipWrap = chosenEquipWrapGO:GetComponent(UIWrapContent)
  self.choosenEquipWrap.itemSize = 83
  self.chooseCtl = WrapListCtrl.new(chosenEquipWrapGO, BagItemNewCell, "BagItemNewCell", nil, 6, 83, true)
  self.chooseCtl:AddEventListener(MouseEvent.MouseClick, self.HandleRemoveChoose, self)
  self.emptyTip = self:FindGO("EmptyTip"):GetComponent(UILabel)
  self.emptyTip.text = ZhString.DeComposeView_AddTip
  self.helpBtn = self:FindGO("HelpButton")
  self.helpBtn:SetActive(false)
end
function DeComposeNewView:InitTipLabels()
end
local ONE_THOUSAND = 1000
local TEN_THOUSAND = 10000
local getmetalrate = function(itemData)
  if itemData.equipInfo:IsNextGen() then
    return
  end
  local decomposeID = itemData.equipInfo.equipData.DecomposeID
  local decomposeData = decomposeID and Table_EquipDecompose[decomposeID]
  if decomposeData and decomposeData.Material then
    local myselfData = Game.Myself and Game.Myself.data
    if not myselfData then
      return
    end
    if not GameConfig.Decompose or not GameConfig.Decompose.price or not calcDecomposeFloatParam or not CommonFun.calcDecomposeCount1 then
      return
    end
    for i = 1, #decomposeData.Material do
      local decomposenum = Table_Equip[itemData.staticData.id].DecomposeNum
      local metalrate = decomposeData.Material[i].rate / TEN_THOUSAND
      local metalid = decomposeData.Material[i].id
      local metalprice = GameConfig.Decompose.price[metalid] or 0
      local refinelv = itemData.equipInfo.refinelv
      local fminparam = calcDecomposeFloatParam(1)
      local fmaxparam = calcDecomposeFloatParam(2)
      local fmin = CommonFun.calcDecomposeCount1(myselfData, decomposenum, nil, nil, metalrate, metalprice, refinelv, fminparam)
      local fmax = CommonFun.calcDecomposeCount1(myselfData, decomposenum, nil, nil, metalrate, metalprice, refinelv, fmaxparam)
      local data = ReusableTable.CreateTable()
      data.min_count = fmin * ONE_THOUSAND * itemData.num
      data.max_count = fmax * ONE_THOUSAND * itemData.num
      data.id = metalid
      return data
    end
  end
end
local MATH_MODF = math.modf
function DeComposeNewView:DecomposePreview()
  self.waittingSymbol:SetActive(false)
  local results, cfg, data = ReusableTable.CreateArray()
  for _, item in pairs(self.chooseEquips) do
    if item.equipInfo:IsNextGen() then
      cfg = item.equipInfo.equipData.NewEquipDecompose
      for i = 1, #cfg do
        data = ReusableTable.CreateTable()
        data.id, data.num = cfg[i][1], cfg[i][2] * item.num
        TableUtility.ArrayPushBack(results, data)
      end
    else
      TableUtility.ArrayPushBack(results, getmetalrate(item))
    end
  end
  self.resultMap = self.resultMap or {}
  TableUtility.TableClear(self.resultMap)
  local itemData, id, num, minrate, maxrate
  for i = 1, #results do
    id, num, minrate, maxrate = results[i].id, results[i].num, results[i].min_count, results[i].max_count
    itemData = self.resultMap[id] or ItemData.new("Decompose", id)
    if num then
      itemData.num = itemData.num + num
    elseif minrate and maxrate then
      itemData.minrate = (itemData.minrate or 0) + MATH_MODF(minrate / ONE_THOUSAND)
      itemData.maxrate = (itemData.maxrate or 0) + MATH_MODF(maxrate / ONE_THOUSAND)
    end
    self.resultMap[id] = itemData
    ReusableTable.DestroyAndClearTable(results[i])
  end
  TableUtility.ArrayClear(results)
  for _, item in pairs(self.resultMap) do
    TableUtility.ArrayPushBack(results, item)
  end
  table.sort(results, function(l, r)
    return l.staticData.id < r.staticData.id
  end)
  self.resultCtl:ResetDatas(results)
  ReusableTable.DestroyAndClearArray(results)
  self:UpdateBusinessTip()
  local chooseData, totalCost = self:GetChooseEquips()
  self.decomposeBord:SetActive(#chooseData > 0)
  self.addbord:SetActive(#chooseData <= 0)
  self.choosenPanel:SetActive(#chooseData > 0)
  chooseData = self:SpreadData(chooseData)
  self.chooseCtl:ResetDatas(chooseData)
  local cells = self.chooseCtl:GetCells()
  for i = 1, #cells do
    if cells[i].data then
      cells[i]:SetCancelTip(true)
    else
      cells[i]:SetCancelTip(false)
    end
  end
  self:UpdateChooseBord()
  if totalCost > 0 then
    if totalCost > MyselfProxy.Instance:GetROB() then
      self.cost.text = string.format("[c]%s%s[-][/c]", CustomStrColor.BanRed, totalCost)
    else
      self.cost.text = tostring(totalCost)
    end
  else
    self.cost.text = 0
  end
  local count = 0
  for k, item in pairs(self.chooseEquips) do
    count = count + item.num
  end
  if count > 50 then
    redlog("超出50上限！")
  end
  self.chooseBord:SetCountLimit(50 - count)
end
local _isEquipClean
function DeComposeNewView:GetDecomposeEquips()
  local equips = {}
  local bagEquips = BagProxy.Instance:GetBagEquipItems()
  TableUtil.InsertArray(equips, bagEquips)
  local result, equip, equipInfo, equipData = {}, nil, nil, nil
  for i = 1, #bagEquips do
    equip = bagEquips[i]
    equipInfo = equip.equipInfo
    if not equipInfo then
      LogUtility.ErrorFormat("EquipInfo is nil: {0}", equip.staticData.NameZh)
    end
    equipData = equipInfo.equipData
    if (equipData.DecomposeID ~= nil or next(equipData.NewEquipDecompose) ~= nil) and BagProxy.Instance:CheckIfFavoriteCanBeMaterial(equip) ~= false and equipInfo.refinelv <= GameConfig.Item.material_max_refine then
      if not self.chooseEquips[equip.id] then
        table.insert(result, equip)
      elseif equip.num > self.chooseEquips[equip.id].num then
        local cloneData = equip:Clone()
        cloneData.num = equip.num - self.chooseEquips[equip.id].num
        table.insert(result, cloneData)
      end
    end
  end
  if _isEquipClean == nil then
    _isEquipClean = BagProxy.CheckEquipIsClean
  end
  table.sort(result, function(a, b)
    local aNeedRecover = not _isEquipClean(a, true)
    local bNeedRecover = not _isEquipClean(b, true)
    if aNeedRecover == bNeedRecover then
      return a.staticData.id < b.staticData.id
    end
    return not aNeedRecover
  end)
  return result
end
function DeComposeNewView.checkValidEquipFunc(param, data)
  if not _isEquipClean(data, true) then
    return false, ZhString.DeComposeView_InvalidTip
  end
  return true
end
function DeComposeNewView:SpreadData(datas)
  local result = {}
  for i = 1, #datas do
    local itemData = datas[i]
    local count = itemData.num
    for j = 1, count do
      local cloneData = itemData:Clone()
      cloneData.num = 1
      table.insert(result, cloneData)
    end
  end
  return result
end
function DeComposeNewView:HandleEquipCompose(note)
  TableUtility.TableClear(self.chooseEquips)
  self.resultCtl:ResetDatas({})
  self.chooseCtl:ResetDatas({})
  local cells = self.chooseCtl:GetCells()
  for i = 1, #cells do
    if cells[i].data then
      cells[i]:SetCancelTip(true)
    else
      cells[i]:SetCancelTip(false)
    end
  end
  self.cost.text = 0
  self.decomposeBord:SetActive(false)
  self.addbord:SetActive(true)
  self.choosenPanel:SetActive(false)
end
function DeComposeNewView:ChooseItem(data)
  local itemData = data.itemData
  if not itemData then
    return
  end
  if not _isEquipClean(itemData, true) then
    MsgManager.FloatMsg(nil, ZhString.DeComposeView_InvalidTip)
    return
  end
  local count = data.count or 1
  local chooseData = self:GetChooseEquips()
  self.waittingSymbol:SetActive(true)
  xdlog("添加道具", itemData.id, count)
  local cloneData = itemData:Clone()
  local curCount = 0
  for k, item in pairs(self.chooseEquips) do
    curCount = curCount + item.num
  end
  if count + curCount > 50 then
    MsgManager.ShowMsgByID(244)
    self.waittingSymbol:SetActive(false)
    return
  end
  if nil == self.chooseEquips[cloneData.id] then
    cloneData.num = count
    self.chooseEquips[itemData.id] = cloneData
  else
    self.chooseEquips[cloneData.id].num = self.chooseEquips[cloneData.id].num + count
  end
  self:DecomposePreview()
end
function DeComposeNewView:HandleRemoveChoose(cellCtrl)
  if cellCtrl then
    self:RemoveItem(cellCtrl.data)
  end
end
function DeComposeNewView:RemoveItem(itemData)
  if not itemData then
    return
  end
  local cloneData = itemData:Clone()
  if not self.chooseEquips[cloneData.id] then
    redlog("不应存在的情况， review code")
    return
  end
  if self.chooseEquips[cloneData.id].num > 1 then
    self.chooseEquips[cloneData.id].num = self.chooseEquips[cloneData.id].num - 1
  else
    self.chooseEquips[cloneData.id] = nil
  end
  self:DecomposePreview()
end
