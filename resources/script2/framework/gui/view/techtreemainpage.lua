autoImport("TechTreeLeafCell")
TechTreeMainPage = class("TechTreeMainPage", SubView)
TechTreeMainPage.TreeIdTexObjTexNameMap = {
  [1] = {
    PageBg = "tree_bg_bottom",
    Root = "tree_bg_root",
    Branch1 = "tree_bg_01",
    Branch2 = "tree_bg_02",
    Branch3 = "tree_bg_03",
    Branch4 = "tree_bg_04",
    Branch5 = "tree_bg_05",
    Branch6 = "tree_bg_06",
    RootEffectContainer = "tree_bg_vortex01"
  },
  [2] = {
    PageBg = "tree_bg_bottom",
    Root = "tree_bg_root_b",
    Branch1 = "tree_bg_01_b",
    Branch2 = "tree_bg_02_b",
    Branch3 = "tree_bg_03_b",
    Branch4 = "tree_bg_04_b",
    Branch5 = "tree_bg_05_b",
    Branch6 = "tree_bg_06_b",
    RootEffectContainer = "tree_bg_vortex01_b"
  },
  [3] = {
    PageBg = "tree_bg_bottom",
    Root = "tree_bg_root",
    Branch11 = "tree_bg_01",
    Branch21 = "tree_bg_02",
    Branch12 = "tree_bg_03",
    Branch22 = "tree_bg_04",
    Branch13 = "tree_bg_05",
    Branch23 = "tree_bg_06",
    RootEffectContainer = "tree_bg_vortex01"
  }
}
TechTreeMainPage.BranchAlphas = {
  0.25,
  0.35,
  0.45,
  0.6,
  0.8,
  1,
  [0] = 0.15
}
TechTreeMainPage.EffectMap = {
  [1] = {
    BtnEffect = EffectMap.UI.TreeCSM_Violet,
    SwitchEffect = EffectMap.UI.TreeTransformation_blue
  },
  [2] = {
    BtnEffect = EffectMap.UI.TreeCSM_yellow,
    SwitchEffect = EffectMap.UI.TreeTransformation_Violet
  }
}
TechTreeMainPage.UpgradeItems = {12902, 12900}
local proxyIns
function TechTreeMainPage:Init()
  if not proxyIns then
    proxyIns = TechTreeProxy.Instance
  end
  self:ReLoadPerferb("view/TechTreeMainPage")
  self.trans:SetParent(self.container.pageContainer.transform, false)
  self.trans.localPosition = LuaGeometry.GetTempVector3(0, -30, 0)
  self.switchBtn = self:FindGO("SwitchBtn")
  self.effectContainer = self:FindGO("EffectContainer")
  self.btnEffectContainer = self:FindGO("BtnEffectContainer")
  self.techTreeProduce = self:FindGO("TechTreeProduce")
  self.produceRoot = self:FindGO("ProduceRoot")
  self.produceRootBG = self:FindGO("bg", self.produceRoot)
  self.produceRootBG_TweenScale = self.produceRootBG:GetComponent(TweenScale)
  self.produceRootBG_TweenAlpha = self.produceRootBG:GetComponent(TweenAlpha)
  self.processLabel = self:FindGO("ProcessLabel", self.produceRoot):GetComponent(UILabel)
  self.produceIcon = self:FindGO("ProduceIcon", self.produceRoot):GetComponent(UISprite)
  self.produceTipBtn = self:FindGO("ProduceTipBtn")
  self.invalidRoot = self:FindGO("InvalidRoot")
  RedTipProxy.Instance:RegisterUI(SceneTip_pb.EREDSYS_TECHTREE_PRODUCE, self.produceIcon, 20)
  self.tipsContainer = self:FindGO("TipsContainer")
  self.tips_TweenAlpha = self.tipsContainer:GetComponent(TweenAlpha)
  self.tips_TweenAlpha:ResetToBeginning()
  self.tipsLabel = self:FindGO("TipsLabel"):GetComponent(UILabel)
  self.tipsLabel_BG = self:FindGO("TipsBG"):GetComponent(UISprite)
  self.tipData = {
    funcConfig = _EmptyTable
  }
  self.costCtrl1 = self:FindGO("CostCtrl1")
  self.cost1Sp = self.costCtrl1:GetComponent(UISprite)
  self.cost1Label = self:FindGO("CostLabel", self.costCtrl1):GetComponent(UILabel)
  self.cost1AddBtn = self:FindGO("CostAddBtn", self.costCtrl1)
  self.cost1GetPathContainer = self:FindGO("GetPathContainer", self.costCtrl1)
  IconManager:SetItemIcon(Table_Item[TechTreeMainPage.UpgradeItems[1]].Icon, self.cost1Sp)
  self:AddClickEvent(self.cost1Sp.gameObject, function()
    self.tipData.itemdata = ItemData.new("cost", TechTreeMainPage.UpgradeItems[1])
    self:ShowItemTip(self.tipData, self.cost1Sp, NGUIUtil.AnchorSide.Down, costTipOffset)
  end)
  self:AddClickEvent(self.cost1AddBtn, function()
    self:ShowGetPathOfCost(TechTreeMainPage.UpgradeItems[1], self.cost1GetPathContainer)
  end)
  self.costCtrl2 = self:FindGO("CostCtrl2")
  self.cost2Sp = self.costCtrl2:GetComponent(UISprite)
  self.cost2Label = self:FindGO("CostLabel", self.costCtrl2):GetComponent(UILabel)
  self.cost2AddBtn = self:FindGO("CostAddBtn", self.costCtrl2)
  self.cost2GetPathContainer = self:FindGO("GetPathContainer", self.costCtrl1)
  IconManager:SetItemIcon(Table_Item[TechTreeMainPage.UpgradeItems[2]].Icon, self.cost2Sp)
  self:AddClickEvent(self.cost2Sp.gameObject, function()
    self.tipData.itemdata = ItemData.new("cost", TechTreeMainPage.UpgradeItems[2])
    self:ShowItemTip(self.tipData, self.cost2Sp, NGUIUtil.AnchorSide.Down, costTipOffset)
  end)
  self:AddClickEvent(self.cost2AddBtn, function()
    self:ShowGetPathOfCost(TechTreeMainPage.UpgradeItems[2], self.cost2GetPathContainer)
  end)
  self:UpdateCostCtrls()
  self.treeId = self.container.treeId
  self.effectInitialMap = {}
  self.treeEffect = {}
  self:AddClickEvent(self.switchBtn, function()
    if self.call_lock then
      return
    end
    if self.treeEffect[self.treeId] then
      self.treeEffect[self.treeId]:SetActive(false)
    end
    self.treeId = 3 - self.treeId
    self:LockCall()
    if not self.treeEffect[self.treeId] then
      self:PlayUIEffect(TechTreeMainPage.EffectMap[self.treeId].SwitchEffect, self.effectContainer, false, self.CancelLockCall)
    else
      self.treeEffect[self.treeId]:SetActive(true)
      self:CancelLockCall()
    end
    self:InitPage()
    self:UpdateTree()
  end)
  self:AddClickEvent(self.produceRootBG, function()
    TechTreeProxy.CallTechTreeProduceCollectCmd()
    self.produceRootBG_TweenScale:ResetToBeginning()
    self.produceRootBG_TweenScale:PlayForward()
    self.produceRootBG_TweenAlpha:ResetToBeginning()
    self.produceRootBG_TweenAlpha:PlayForward()
  end)
  self:AddClickEvent(self.produceTipBtn, function()
    self:ShowProduceInfo()
  end)
  self:AddClickEvent(self.invalidRoot, function()
    self:ShowInvalidTip()
  end)
  self:InitPage()
  self:AddEvents()
  self:RegisterGuide()
end
function TechTreeMainPage:InitPage()
  self.texNameMap = TechTreeMainPage.TreeIdTexObjTexNameMap[self.treeId]
  if not self.texNameMap then
    LogUtility.WarningFormat("Cannot find TexObjTexNameMap of treeId:{0}", self.treeId)
    return
  end
  for obj, _ in pairs(self.texNameMap) do
    self[obj] = self:FindComponent(obj, UITexture)
  end
  self:SetBranchText()
  self.leafSelectedTrans = self:FindGO("LeafSelected").transform
  if not self.effectInitialMap[self.treeId] then
    if TechTreeMainPage.EffectMap[self.treeId] then
      local effectPath = ResourcePathHelper.EffectUI(TechTreeMainPage.EffectMap[self.treeId].BtnEffect)
      local go = self:LoadPreferb_ByFullPath(effectPath, self.btnEffectContainer.transform)
      self.effectInitialMap[self.treeId] = go
      self.switchBtn:SetActive(FunctionUnLockFunc.checkFuncStateValid(118))
    else
      self.switchBtn:SetActive(false)
    end
  end
  for k, v in pairs(self.effectInitialMap) do
    v:SetActive(k == self.treeId)
  end
  self:InitBranches()
  self:InitLeaves()
  self:InitTechTreeProducePart()
end
function TechTreeMainPage:InitBranches()
  self.branchTexs = {}
  local branchesTrans = self:FindGO("Branches").transform
  for i = 1, branchesTrans.childCount do
    branchTrans = branchesTrans:GetChild(i - 1)
    branchID = branchTrans and string.sub(branchTrans.gameObject.name, 7)
    self.branchTexs[tonumber(branchID)] = self["Branch" .. branchID]
  end
end
function TechTreeMainPage:InitLeaves()
  self.branchLeafMap = {}
  local leavesParentTrans, leafTrans, leafId, subLeafid = self:FindGO("NewLeaves").transform, nil, nil, nil
  for j = 1, leavesParentTrans.childCount do
    leafTrans = leavesParentTrans:GetChild(j - 1)
    leafId = leafTrans and tonumber(leafTrans.gameObject.name)
    subLeafid = math.fmod(leafId, 1000) + self.treeId * 1000
    if proxyIns:CheckLeafIdValid(subLeafid) then
      leafId = subLeafid
    end
    if leafId then
      local branch = proxyIns:GetBranchIdOfLeaf(leafId)
      local leafMap = self.branchLeafMap[branch] or ReusableTable.CreateTable()
      leafMap[leafId] = TechTreeLeafCell.new(leafTrans.gameObject, leafId, self.treeId)
      leafMap[leafId]:AddEventListener(MouseEvent.MouseClick, self.OnLeafClick, self)
      self.branchLeafMap[branch] = leafMap
    else
      redlog("Table_TechTreeLeaf[leafId] nil", leafId)
    end
  end
end
function TechTreeMainPage:InitTechTreeProducePart()
  local menuid = GameConfig.TechTree.producespeedmenu or 18198
  local valid = FunctionUnLockFunc.Me():CheckCanOpen(menuid) or false
  self.produceRoot:SetActive(valid)
  self.invalidRoot:SetActive(not valid)
  local invalidItemIcon = self:FindGO("Icon", self.invalidRoot):GetComponent(UISprite)
  local produceItem = GameConfig.TechTree.produceItem or 12903
  local itemData = Table_Item[produceItem]
  IconManager:SetItemIcon(itemData.Icon, invalidItemIcon)
  invalidItemIcon:MakePixelPerfect()
  IconManager:SetItemIcon(itemData.Icon, self.produceIcon)
  self.produceIcon:MakePixelPerfect()
  if valid then
  else
    local effectContainer = self:FindGO("EffectContainer", self.invalidRoot)
    self:PlayUIEffect(EffectMap.UI.TechTreeProduceInvalid, effectContainer, false)
  end
end
function TechTreeMainPage:AddEvents()
  self:AddListenEvt(ServiceEvent.TechTreeCmdTechTreeUnlockLeafCmd, self.OnLeafUnlock)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.OnItemUpdate)
  self:AddListenEvt(ServiceEvent.TechTreeCmdTechTreeProdecInfoCmd, self.OnTechTreeProduceInfo)
  self:AddListenEvt(ServiceEvent.TechTreeCmdTechTreeProduceCollectCmd, self.OnTechTreeProduceCollect)
end
function TechTreeMainPage:UpdateTree(isFirstCall)
  local unlockedCount
  for branch, leafMap in pairs(self.branchLeafMap) do
    unlockedCount = 0
    local branchValid = proxyIns:IsBranchValid(branch)
    if not branchValid then
      for leafId, leafCell in pairs(leafMap) do
        local trees = proxyIns:GetStaticTreeIdsOfLeaf(leafId) or {}
        leafCell:SwitchToState(TechTreeLeafCellState.Hide, #trees > 1)
      end
    else
      for leafId, leafCell in pairs(leafMap) do
        local trees = proxyIns:GetStaticTreeIdsOfLeaf(leafId) or {}
        if proxyIns:IsLeafUnlocked(leafId, self.treeId) then
          leafCell:SwitchToState(TechTreeLeafCellState.Unlocked, #trees > 1)
          unlockedCount = unlockedCount + 1
        else
          leafCell:SwitchToState(proxyIns:IsLeafAvailable(leafId, self.treeId) and TechTreeLeafCellState.Available or TechTreeLeafCellState.Locked, #trees > 1)
        end
        leafCell:UpdateLevel()
      end
    end
    local toAlpha = 1
    if isFirstCall then
      if branchValid then
        self.branchTexs[branch].color = LuaGeometry.GetTempColor(1, 1, 1, toAlpha)
      else
        self.branchTexs[branch].color = LuaGeometry.GetTempColor(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, toAlpha)
      end
    elseif branchValid then
      TweenAlpha.Begin(self.branchTexs[branch].gameObject, 0.9, toAlpha)
    end
  end
end
function TechTreeMainPage:OnLeafClick(cellCtl)
  if not cellCtl.id then
    return
  end
  self.chooseId = self.chooseId ~= cellCtl.id and cellCtl.id or nil
  self.leafSelectedTrans.gameObject:SetActive(self.chooseId ~= nil)
  if self.chooseId then
    self.leafSelectedTrans:SetParent(cellCtl.bgTrans, false)
    self.leafSelectedTrans.localPosition = LuaGeometry.GetTempVector3(cellCtl:GetBgFlip() > 0 and -1 or 2, -2, 0)
  end
  self.container:ShowLeafTip(self.chooseId, self.treeId)
end
function TechTreeMainPage:OnBgClick()
  self.chooseId = nil
  self.leafSelectedTrans.gameObject:SetActive(false)
end
function TechTreeMainPage:OnLeafUnlock()
  self:UpdateTree()
end
function TechTreeMainPage:OnItemUpdate()
  self:UpdateTree()
  self:UpdateCostCtrls()
end
function TechTreeMainPage:OnTechTreeProduceInfo()
  local produceInfo = TechTreeProxy.Instance.techTreeProduceInfo
  local producenum = produceInfo.producenum or 0
  local produceupperlimit = produceInfo.produceupperlimit or 0
  self.processLabel.text = producenum .. "/" .. produceupperlimit
  local isfirstopen = TechTreeProxy.Instance.isFirstOpen
  xdlog("是否播放特效", isfirstopen)
  if isfirstopen then
    self:PlayUIEffect(TechTreeMainPage.EffectMap[1].SwitchEffect, self.effectContainer, false, self.CancelLockCall)
  end
end
function TechTreeMainPage:OnTechTreeProduceCollect(note)
  local data = note.body
  local success = data and data.success or false
  if success then
    local produceInfo = TechTreeProxy.Instance.techTreeProduceInfo
    local produceupperlimit = produceInfo.produceupperlimit or 0
    self.processLabel.text = "0/" .. produceupperlimit
  end
end
function TechTreeMainPage:OnEnter()
  TechTreeMainPage.super.OnEnter(self)
  TechTreeProxy.CallTechTreeProdecInfoCmd()
end
function TechTreeMainPage:SetBranchText()
  for obj, texName in pairs(self.texNameMap) do
    if self[obj] then
      PictureManager.Instance:SetUI(texName, self[obj])
    end
  end
end
function TechTreeMainPage:OnActivate()
  self:UpdateTree(true)
  self.leafSelectedTrans.gameObject:SetActive(false)
end
function TechTreeMainPage:OnExit()
  for obj, texName in pairs(self.texNameMap) do
    if self[obj] then
      PictureManager.Instance:UnLoadUI(texName, self[obj])
    end
  end
  for _, leafMap in pairs(self.branchLeafMap) do
    ReusableTable.DestroyAndClearTable(leafMap)
  end
  TableUtility.TableClear(self.branchLeafMap)
  TechTreeMainPage.super.OnExit(self)
end
function TechTreeMainPage:AddButtonEvent(name, event)
  TechTreeMainPage.super.super.AddButtonEvent(self, name, event)
end
function TechTreeMainPage:LockCall()
  if TechTreeMainPage.call_lock then
    return
  end
  TechTreeMainPage.call_lock = true
end
function TechTreeMainPage:CancelLockCall(obj, args, assetEffect)
  if obj ~= nil then
    self.treeEffect[self.treeId] = assetEffect
  end
  if not TechTreeMainPage.call_lock then
    return
  end
  TechTreeMainPage.call_lock = false
end
function TechTreeMainPage:ShowProduceInfo()
  local produceInfo = TechTreeProxy.Instance.techTreeProduceInfo
  local producenum = produceInfo.producenum or 0
  local produceupperlimit = produceInfo.produceupperlimit or 0
  local prodecespeed = produceInfo.prodecespeed or 0
  self.tipsLabel.text = string.format(ZhString.TechTree_ProduceSpeedTip, prodecespeed)
  self.tipsLabel_BG.height = self.tipsLabel.printedSize.y + 58
  self.tipsLabel_BG.width = self.tipsLabel.printedSize.x + 73
  self.tips_TweenAlpha:ResetToBeginning()
  self.tips_TweenAlpha:PlayForward()
end
function TechTreeMainPage:ShowInvalidTip()
  self.tipsLabel.text = ZhString.TechTree_ProduceInvalidTip
  self.tipsLabel_BG.height = self.tipsLabel.printedSize.y + 58
  self.tipsLabel_BG.width = self.tipsLabel.printedSize.x + 73
  self.tips_TweenAlpha:ResetToBeginning()
  self.tips_TweenAlpha:PlayForward()
end
function TechTreeMainPage:UpdateCostCtrls()
  self.cost1Label.text = StringUtil.NumThousandFormat(HappyShopProxy.Instance:GetItemNum(TechTreeMainPage.UpgradeItems[1])) or 0
  self.cost2Label.text = StringUtil.NumThousandFormat(HappyShopProxy.Instance:GetItemNum(TechTreeMainPage.UpgradeItems[2])) or 0
end
function TechTreeMainPage:ShowGetPathOfCost(itemID, parent)
  if self.bdt then
    self.bdt:OnExit()
  elseif itemID then
    self.bdt = GainWayTip.new(parent)
    self.bdt:SetAnchorPos(true)
    self.bdt:SetData(itemID)
    self.bdt:AddEventListener(ItemEvent.GoTraceItem, function()
      self:CloseSelf()
    end, self)
    self.bdt:AddEventListener(GainWayTip.CloseGainWay, self.GetPathCloseCall, self)
  end
end
function TechTreeMainPage:GetPathCloseCall()
  self.bdt = nil
end
function TechTreeMainPage:RegisterGuide()
  local firstLeaf = self:FindGO("3111")
  self:AddOrRemoveGuideId(firstLeaf, 505)
end
