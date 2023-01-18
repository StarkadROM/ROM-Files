autoImport("LotteryMixCell")
autoImport("LotteryMixShopCombineCell")
autoImport("PopupCombineCell")
LotteryMixed = class("LotteryMixed", SubView)
LotteryMixed.ViewIndex = {Lottery = 1, Shop = 2}
local _Index_Lottery = LotteryMixed.ViewIndex.Lottery
local _Index_Shop = LotteryMixed.ViewIndex.Shop
local _AgainConfirmMsgID = 295
local _fashionType = 501
local _Eleven = 11
local LoadCellPfb = function(cName, obj)
  local pfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(cName))
  if nil == pfb then
    error("can not find pfb" .. cName)
  end
  pfb.transform:SetParent(obj.transform, false)
  pfb.transform.localPosition = LuaGeometry.Const_V3_zero
  return pfb
end
function LotteryMixed:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self:InitShow()
end
function LotteryMixed:FindObjs()
  self.root = self:FindGO("MixRoot")
  self.extra = self:FindGO("Extra", self.root)
  self.lotteryRoot = self:FindGO("LotteryRoot", self.root)
  self.lotteryRoot:SetActive(true)
  self.toShopBtn = self:FindGO("ToShopBtn", self.lotteryRoot)
  self.shopDetailLab = self:FindGO("Lab", self.toShopBtn):GetComponent(UILabel)
  self.shopDetailLab.text = ZhString.LotteryMixed_ShopBtn
  self.singleGroupFinish = self:FindGO("SingleGroupFinish", self.extra):GetComponent(UILabel)
  self.shopRoot = self:FindGO("ShopRoot", self.root)
  self.shopRoot:SetActive(false)
  self.shopBuyRoot = self:FindGO("ShopBuyRoot", self.shopRoot)
  self.toLotteryBtn = self:FindGO("ToLotteryBtn", self.shopRoot)
  self.onlyGotToggle = self:FindComponent("OnlyGotToggle", UIToggle, self.extra)
  self.onlyGotToggleLab = self:FindComponent("Label", UILabel, self.onlyGotToggle.gameObject)
  self.onlyGotToggleLab.text = ZhString.LotteryMixed_filterGotItem
  self.lotteryPanel = self:FindGO("MixLotteryPanel", self.root)
  self.lotteryPopUp = self:FindGO("MixLotteryPopUp", self.lotteryPanel)
  self.lotteryPopUpCtl = PopupCombineCell.new(self.lotteryPopUp)
  self.lotteryPopUpCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickLotteryFilter, self)
  self.shopPanel = self:FindGO("MixShopPanel", self.root)
  self.shopSitePopUp = self:FindGO("MixShopSitePopUp", self.shopPanel)
  self.shopSitePopUpCtrl = PopupCombineCell.new(self.shopSitePopUp)
  self.shopSitePopUpCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickSiteFilter, self)
  self.shopQualityPopUp = self:FindGO("MixShopQualityPopUp", self.shopPanel)
  self.shopQualityPopUpCtl = PopupCombineCell.new(self.shopQualityPopUp)
  self.shopQualityPopUpCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickQualityFilter, self)
end
function LotteryMixed:OnClickLotteryFilter()
  if self.lotteryGoal == self.lotteryPopUpCtl.goal then
    return
  end
  self.onlyGotToggle.value = false
  self.lotteryGoal = self.lotteryPopUpCtl.goal
  self:UpdateLotteryInfo(true)
end
function LotteryMixed:OnClickSiteFilter()
  if self.siteGoal == self.shopSitePopUpCtrl.goal then
    return
  end
  self.siteGoal = self.shopSitePopUpCtrl.goal
  if self.siteGoal == _fashionType then
    self.shopQualityPopUpCtl:SetInvalidMsgID(41412)
    self.shopQualityPopUpCtl:Reset()
    self.qualityGoal = self.shopQualityPopUpCtl.goal
  else
    self.shopQualityPopUpCtl:SetInvalidMsgID(nil)
  end
  self:UpdateShopInfo(true)
end
function LotteryMixed:OnClickQualityFilter(parama)
  if self.qualityGoal == self.shopQualityPopUpCtl.goal then
    return
  end
  self.qualityGoal = self.shopQualityPopUpCtl.goal
  self:UpdateShopInfo(true)
end
function LotteryMixed:AddEvts()
  EventDelegate.Add(self.onlyGotToggle.onChange, function()
    self:UpdateHelperByIndex(false, true)
  end)
  self:AddClickEvent(self.toLotteryBtn, function()
    self:ToLottery()
  end)
  self:AddClickEvent(self.toShopBtn, function()
    self:ToShop()
  end)
end
function LotteryMixed:ToLottery()
  self:SetViewIndex(_Index_Lottery)
end
function LotteryMixed:ToShop()
  self:_initShopSiteFilter()
  self:SetViewIndex(_Index_Shop)
  if not self.staticData then
    return
  end
  ShopProxy.Instance:CallQueryShopConfig(self.staticData.ShopType, self.staticData.ShopID)
end
function LotteryMixed:AddViewEvts()
  self:AddListenEvt(ServiceEvent.SessionShopQueryShopConfigCmd, self.HandleItemUpdate)
end
function LotteryMixed:HandleItemUpdate()
  LotteryProxy.Instance:UpdateMixLotteryFilterData()
  self:UpdateHelperByIndex(false, false)
end
function LotteryMixed:HandleMixLotteryArchive()
  self:SetViewIndex(_Index_Lottery)
  self:HandleItemUpdate()
end
function LotteryMixed:InitShow()
  self.tipData = {
    funcConfig = {}
  }
  self.lotteryType = self.container.lotteryType
  LotteryProxy.Instance:InitMixLotteryGameConfig(self.lotteryType, nil)
  ServiceItemProxy.Instance:CallMixLotteryArchiveCmd(self.lotteryType)
  self:InitStaticData()
  self.onlyGotToggle.value = false
  self:InitHelper()
end
local wrapConfig = {}
function LotteryMixed:InitHelper()
  local container = self:FindGO("LotteryContainer", self.root)
  TableUtility.TableClear(wrapConfig)
  wrapConfig.wrapObj = container
  wrapConfig.pfbNum = 7
  wrapConfig.cellName = "LotteryMixCell"
  wrapConfig.control = LotteryMixCell
  self.lotteryHelper = WrapCellHelper.new(wrapConfig)
  self.lotteryHelper:AddEventListener(MouseEvent.MouseClick, self.ClickDetail, self)
  self.lotteryHelper:AddEventListener(LotteryCell.ClickEvent, self.ClickCell, self)
  container = self:FindGO("ShopContainer", self.root)
  TableUtility.TableClear(wrapConfig)
  wrapConfig.wrapObj = container
  wrapConfig.pfbNum = 6
  wrapConfig.cellName = "LotteryMixShopCombineCell"
  wrapConfig.control = LotteryMixShopCombineCell
  self.shopHelper = WrapCellHelper.new(wrapConfig)
  self.shopHelper:AddEventListener(MouseEvent.MouseClick, self.container.SetBuyItemCell, self.container)
end
function LotteryMixed:ClickDetail(cell)
  local data = cell.data
  if data then
    self.tipData.itemdata = data:GetItemData()
    self:ShowItemTip(self.tipData, cell.icon, NGUIUtil.AnchorSide.Right, {230, 0})
  end
end
function LotteryMixed:_initLotteryFilter()
  local cfg = LotteryProxy.Instance:GetMixLotteryFilter()
  if not cfg then
    return
  end
  self.lotteryPopUpCtl:SetData(cfg, true)
  self.lotteryGoal = self.lotteryPopUpCtl.goal
end
function LotteryMixed:_initShopSiteFilter()
  local cfg = GameConfig.MixLottery.EquipFilter
  if cfg then
    self.shopSitePopUpCtrl:SetData(cfg, true)
    self.siteGoal = self.shopSitePopUpCtrl.goal
  end
  cfg = GameConfig.MixLottery.QualityFilter
  if cfg then
    self.shopQualityPopUpCtl:SetData(cfg, true)
    self.qualityGoal = self.shopQualityPopUpCtl.goal
  end
end
function LotteryMixed:UpdateLotteryInfo(resetPosition)
  self:_updateLotteryHelper()
  if resetPosition then
    self.lotteryHelper:ResetPosition()
  end
end
function LotteryMixed:UpdateShopInfo(resetPosition)
  self:_updateShopHelper()
  if resetPosition then
    self.shopHelper:ResetPosition()
  end
end
function LotteryMixed:_updateLotteryHelper()
  if not LotteryProxy.Instance.mixLotteryUngetCount then
    return
  end
  local helperData = LotteryProxy.Instance:FilterMixLottery(self.lotteryGoal, self.onlyGotToggle.value)
  if 0 == LotteryProxy.Instance:GetUngetCount(self.lotteryGoal) then
    local rate = LotteryProxy.Instance:GetRateBuyGroup(self.lotteryGoal)
    self.singleGroupFinish.gameObject:SetActive(true)
    self.singleGroupFinish.text = string.format(ZhString.LotteryMixed_singleGroupFinish, rate * 100)
    self.onlyGotToggle.gameObject:SetActive(false)
  else
    self.singleGroupFinish.gameObject:SetActive(false)
    self.onlyGotToggle.gameObject:SetActive(true)
  end
  self.lotteryHelper:UpdateInfo(helperData)
end
function LotteryMixed:_updateShopHelper()
  self.singleGroupFinish.gameObject:SetActive(false)
  local helperData = LotteryProxy.Instance:FilterMixLotteryShop(self.lotteryType, self.siteGoal, self.qualityGoal, self.onlyGotToggle.value)
  local newData = self.container:ReUniteCellData(helperData, 3)
  self.shopHelper:UpdateInfo(newData)
end
function LotteryMixed:CallLottery(price, times, freecnt)
  local dont = LocalSaveProxy.Instance:GetDontShowAgain(_AgainConfirmMsgID)
  if dont == nil and freecnt == 0 then
    MsgManager.DontAgainConfirmMsgByID(_AgainConfirmMsgID, function()
      self.container:CallLottery(price, nil, nil, times, freecnt)
    end, nil, nil, math.floor(price * times))
    return
  end
  self.container:CallLottery(price, nil, nil, times, freecnt)
end
function LotteryMixed:SetViewIndex(index)
  if self.viewIndex ~= index then
    self.viewIndex = index
    self.lotteryRoot:SetActive(index == _Index_Lottery)
    self.lotteryPanel:SetActive(index == _Index_Lottery)
    self.shopRoot:SetActive(index == _Index_Shop)
    self.shopPanel:SetActive(index == _Index_Shop)
    self.onlyGotToggle:Set(false)
    self:UpdateHelperByIndex(true)
    self.container:UpdatePreviewBtn(index == _Index_Shop)
  end
end
function LotteryMixed:UpdateHelperByIndex(init, forceReposition)
  self.container:UpdateReplaceMoney()
  self.container:UpdateTicket()
  local index = self.viewIndex
  if index == _Index_Lottery then
    self:_initLotteryFilter()
    self:UpdateLotteryInfo(init or forceReposition)
  elseif index == _Index_Shop then
    self:UpdateShopInfo(init or forceReposition)
  end
end
function LotteryMixed:OnClickLotteryHelp()
  TipsView.Me():ShowGeneralHelpByHelpId(35051)
end
function LotteryMixed:SetMixedLotteryType()
  self.lotteryType = LotteryProxy.Instance:GetRecentMixLotteryType()
end
function LotteryMixed:InitStaticData()
  self.staticData = LotteryProxy.Instance:GetMixStaticData(self.lotteryType)
  if nil == self.staticData then
    redlog("混合扭蛋未初始化 检查GameConfig.MixLottery.MixLotteryShop : ", self.lotteryType)
  end
end
function LotteryMixed:Show()
  self.lotteryType = self.container.lotteryType
  self.root:SetActive(true)
  self.container.lotterySaleIcon:SetActive(false)
  self:UpdateHelperByIndex(true)
  self.container:ActiveLotteryTime(true)
end
function LotteryMixed:Hide()
  self:ToLottery()
  self.root:SetActive(false)
end
function LotteryMixed:OnExit()
  LotteryMixed.super.OnExit(self)
  TimeLimitShopProxy.Instance:viewPopUp()
end
function LotteryMixed:OnEnter()
  LotteryMixed.super.OnEnter(self)
  self.container.lotterySaleIcon:SetActive(false)
end
function LotteryMixed:UpdateCost()
  local price = LotteryProxy.Instance.mixLotteryPrice
  local onceMaxCount = LotteryProxy.Instance.mixLotteryOnceMaxCount
  self.container:UpdateCostValue(price, onceMaxCount)
end
function LotteryMixed:UpdateTicketCost()
  self.container:UpdateTicketCostValue(LotteryProxy.Instance.mixLotteryOnceMaxCount)
end
function LotteryMixed:Lottery()
  local price = LotteryProxy.Instance.mixLotteryPrice
  local freecnt = LotteryProxy.Instance:GetMixFreeCnt()
  self:CallLottery(price, 1, freecnt)
end
function LotteryMixed:LotteryTen()
  local price = LotteryProxy.Instance.mixLotteryPrice
  local count = LotteryProxy.Instance.mixLotteryOnceMaxCount or 10
  self:CallLottery(price, count, 0)
end
function LotteryMixed:Ticket()
  self.container:CallTicket()
end
function LotteryMixed:TicketTen()
  self.container:CallTicket(nil, nil, _Eleven)
end
function LotteryMixed:UpdateLimit()
  local cnt, maxCnt, tencnt, tenMaxcnt = LotteryProxy.Instance:GetMixCnts()
  if not cnt or not maxCnt or not tencnt or not tenMaxcnt then
    return
  end
  local limitStr
  if self.container:TenToggleEnabled() then
    limitStr = string.format(ZhString.LotteryMixed_todayTenLimited, tencnt, tenMaxcnt)
  else
    limitStr = string.format(ZhString.LotteryMixed_todayLimited, cnt, maxCnt)
  end
  self.container:SetLotteryLimitLab(limitStr)
end
function LotteryMixed:EnterDress(hide)
  if self.viewIndex == _Index_Lottery then
    self.toShopBtn:SetActive(hide)
    self:UpdateLotteryInfo()
  else
    self.toLotteryBtn:SetActive(hide)
    self:UpdateShopInfo()
  end
  self.extra:SetActive(hide)
end
function LotteryMixed:ClickCell(cell)
  self.container:ClickCell(cell)
  if self.viewIndex == _Index_Lottery then
    self:UpdateLotteryInfo()
  else
    self:UpdateShopInfo()
  end
end
function LotteryMixed:UpdateHelpBtn()
  self.container:ActiveHelpBtn(true)
end
