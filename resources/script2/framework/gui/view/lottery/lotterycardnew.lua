autoImport("PopupCombineCell")
autoImport("CardLotteryCell")
LotteryCardNew = class("LotteryCardNew", SubView)
local wrapConfig = {}
local LotteryConfig = GameConfig.Lottery
local _AgainConfirmMsgID = 295
local _Ten = 10
local _FreeCostStr = "0"
local _AccMap = {
  [31] = Var_pb.EACCVARTYPE_LOTTERY_CNT_CARD_NEW,
  [32] = Var_pb.EACCVARTYPE_LOTTERY_CNT_CARD_ACTIVITY
}
function LotteryCardNew:OnExit()
  LotteryCardNew.super.OnExit(self)
end
function LotteryCardNew:OnEnter()
  LotteryCardNew.super.OnEnter(self)
  self:ResetCard()
  self:UpdateSafety()
end
function LotteryCardNew:FindObjs()
  self.root = self:FindGO("NewCardRoot")
  self.popUp = self:FindGO("PopUp", self.root)
  self.popUpCtl = PopupCombineCell.new(self.popUp)
  self.popUpCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickFilter, self)
  self.safatyTip = self:FindGO("safatyTip"):GetComponent(UILabel)
  self.safetyButton = self:FindGO("SafetyButton")
  self:AddClickEvent(self.safetyButton, function()
    TipManager.Instance:SetLotterySafetyTip(self.lotteryType, self.safatyTip, nil, {100, 0})
  end)
end
function LotteryCardNew:UpdateSafety()
  local data = LotteryProxy.Instance:GetInfo(self.lotteryType)
  if data then
    if data:HasSafety() then
      self.safetyButton:SetActive(true)
      self.safatyTip.gameObject:SetActive(true)
      local itemtype, count = data:GetMostSafetyInfo()
      if count > 0 then
        self.safatyTip.text = string.format(ZhString.CardLottery_MostSafetyTip, count, self.cardConfig.filter[itemtype])
      else
        self.safatyTip.text = string.format(ZhString.CardLottery_InSafetyTip, self.cardConfig.filter[itemtype])
      end
    else
      self.safetyButton:SetActive(false)
      self.safatyTip.gameObject:SetActive(false)
    end
  end
end
function LotteryCardNew:InitShow()
  self.tipData = {
    funcConfig = {}
  }
  self.lotteryType = self.container.lotteryType
  self.cardConfig = LotteryConfig.CardLottery[self.lotteryType]
  self.popUpCtl:SetData(self.cardConfig.filter, nil, 1)
  self.goal = self.popUpCtl.goal
  local detailContainer = self:FindGO("DetailContainer", self.root)
  TableUtility.TableClear(wrapConfig)
  wrapConfig.wrapObj = detailContainer
  wrapConfig.pfbNum = 6
  wrapConfig.cellName = "CardLotteryCell"
  wrapConfig.control = CardLotteryCell
  wrapConfig.dir = 1
  self.detailHelper = WrapCellHelper.new(wrapConfig)
  self.detailHelper:AddEventListener(MouseEvent.MouseClick, self.ClickDetail, self)
end
function LotteryCardNew:Show()
  self.root:SetActive(true)
  self:UpdateLotterySaleIcon()
  self:ResetCard()
  self:UpdateSafety()
  self:SetDuration()
  self.container:ActiveLotteryTime(true)
end
function LotteryCardNew:Hide()
  self.root:SetActive(false)
end
function LotteryCardNew:Init()
  self:FindObjs()
  self:InitShow()
end
function LotteryCardNew:SetDuration()
  local time = ""
  local begin, endtime = LotteryProxy.Instance:GetUpDuration(self.lotteryType)
  if begin and endtime then
    local beginDate = os.date("%m/%d %H:%M", begin)
    local endDate = os.date("%m/%d %H:%M", endtime)
    time = string.format(ZhString.CardLottery_UPDuration, beginDate, endDate)
  end
  self.container:SetLotteryTime(time)
end
function LotteryCardNew:OnClickFilter()
  if self.goal == self.popUpCtl.goal then
    return
  end
  self.goal = self.popUpCtl.goal
  self:ResetCard()
end
function LotteryCardNew:UpdateCost()
  local data = LotteryProxy.Instance:GetInfo(self.lotteryType)
  if data then
    local hasFreeCnt = LotteryProxy.Instance:HasFreeCnt(self.lotteryType)
    local discountValid = BranchMgr.IsJapan() and LotteryProxy.Instance:CheckNewCardDiscountValid(self.lotteryType)
    local supportTen = data.onceMaxCount == _Ten and not hasFreeCnt and not discountValid
    self.container.tenToggle.gameObject:SetActive(supportTen)
    local todayCount = MyselfProxy.Instance:GetAccVarValueByType(_AccMap[self.lotteryType]) or 0
    local tenToggleEnabled = self.container:TenToggleEnabled()
    local times = tenToggleEnabled and _Ten or 1
    self.container.lotteryCostValue = LotteryProxy.Instance:CalculteCardCost(self.lotteryType, todayCount, times)
    if not tenToggleEnabled and LotteryProxy.Instance:HasFreeCnt(self.lotteryType) then
      self.container.lotteryCost.text = _FreeCostStr
    else
      self.container.lotteryCost.text = self.container.lotteryCostValue
    end
    self.container:UpdateOneTogglePos(supportTen)
  end
end
function LotteryCardNew:ResetCard()
  self:UpdateCard()
  self.detailHelper:ResetPosition()
end
function LotteryCardNew:UpdateCard()
  local list = LotteryProxy.Instance:GetCardByItemtype(self.lotteryType, self.goal)
  if list then
    self.detailHelper:UpdateInfo(list, true)
  end
end
function LotteryCardNew:Lottery()
  local data = LotteryProxy.Instance:GetInfo(self.lotteryType)
  if data then
    local freecnt = data.freeCount
    self:CallLottery(self.container.lotteryCostValue, 1, freecnt)
  end
end
function LotteryCardNew:LotteryTen()
  self:CallLottery(self.container.lotteryCostValue / _Ten, _Ten, 0)
end
function LotteryCardNew:CallLottery(price, times, freecnt)
  local dont = LocalSaveProxy.Instance:GetDontShowAgain(_AgainConfirmMsgID)
  if dont == nil and freecnt == 0 then
    MsgManager.DontAgainConfirmMsgByID(_AgainConfirmMsgID, function()
      self.container:CallLottery(price, nil, nil, times, freecnt)
    end, nil, nil, math.floor(price * times))
    return
  end
  self.container:CallLottery(price, nil, nil, times, freecnt)
end
function LotteryCardNew:UpdateLimit()
  self.container:BaseUpdateLimit()
  self:UpdateLotterySaleIcon()
end
function LotteryCardNew:UpdateLotterySaleIcon()
  local count = MyselfProxy.Instance:GetAccVarValueByType(_AccMap[self.lotteryType]) or 0
  local limit = LotteryConfig and LotteryConfig.ButtonShowSaleTimes or 0
  self.container.lotterySaleIcon:SetActive(GameConfig.Lottery.ButtonShowSale == true and count < limit)
end
function LotteryCardNew:ClickDetail(cell)
  local data = cell.data
  if data then
    self.tipData.itemdata = data:GetItemData()
    self:ShowItemTip(self.tipData, cell.icon, NGUIUtil.AnchorSide.Right, {230, 0})
  end
end
function LotteryCardNew:UpdateHelpBtn()
  self.container:ActiveHelpBtn(true)
end
function LotteryCardNew:OnClickLotteryHelp()
  if not self.cardConfig then
    return
  end
  TipsView.Me():ShowGeneralHelpByHelpId(self.cardConfig.helpID)
end
function LotteryCardNew:HandleQueryLotteryInfo()
  self:ResetCard()
  self:UpdateSafety()
  self:SetDuration()
end
