autoImport("QuickBuyCombineCell")
QuickBuyView = class("QuickBuyView", ContainerView)
QuickBuyView.ViewType = UIViewType.PopUpLayer
local BuyReason = {Money = 1, Buying = 2}
local NumThousandFormat = StringUtil.NumThousandFormat
local RED = "[c][FF3B0D]%s[-][/c]"
function QuickBuyView:OnExit()
  QuickBuyProxy.Instance:Clear()
  QuickBuyView.super.OnExit(self)
end
function QuickBuyView:Init()
  self:FindObj()
  self:AddBtnEvt()
  self:AddViewEvt()
  self.closeComp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  self.closeComp.enabled = false
  function self.closeComp.callBack()
    self:CloseSelf()
  end
  self:InitShow()
end
function QuickBuyView:FindObj()
  self.loadingRoot = self:FindGO("LoadingRoot")
  self.closeBtn = self:FindGO("CloseButton"):GetComponent(UIMultiSprite)
  self.closeBtnLabel = self:FindGO("Label", self.closeBtn.gameObject):GetComponent(UILabel)
  self.buyBtn = self:FindGO("BuyBtn"):GetComponent(UIMultiSprite)
  self.buyBtnLabel = self:FindGO("Label", self.buyBtn.gameObject):GetComponent(UILabel)
end
function QuickBuyView:AddBtnEvt()
  self:AddClickEvent(self.closeBtn.gameObject, function()
    if self.canClose then
      self:CloseSelf()
    end
  end)
  self:AddClickEvent(self.buyBtn.gameObject, function()
    if BranchMgr.IsChina() or OverseaHostHelper:GuestExchangeForbid() ~= 1 then
      self:Buy()
    end
  end)
end
function QuickBuyView:AddViewEvt()
  self:AddListenEvt(MyselfEvent.MyDataChange, self.HandleMyDataChange)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.HandleMyDataChange)
  self:AddListenEvt(QuickBuyEvent.Refresh, self.UpdateView)
  self:AddListenEvt(QuickBuyEvent.Close, self.CloseSelf)
  self:AddListenEvt(HomeEvent.ExitHome, self.CloseSelf)
  self:AddListenEvt(SecurityEvent.Close, self.HandleSecurityClose)
end
function QuickBuyView:HandleSecurityClose()
  self.canClose = true
  self.closeComp.enabled = false
  self:UpdateCloseBtn()
  self:UpdateBuyReason(BuyReason.Buying, nil)
  self:UpdateBuyBtn()
end
function QuickBuyView:InitShow()
  self.tipData = {}
  self.tipData.funcConfig = {}
  self.buyReasonMap = {}
  self.canClose = true
  self.closeComp.enabled = false
  local container = self:FindGO("Container")
  local wrapConfig = {
    wrapObj = container,
    pfbNum = 3,
    cellName = "QuickBuyCombineCell",
    control = QuickBuyCombineCell,
    dir = 1
  }
  self.itemWrapHelper = WrapCellHelper.new(wrapConfig)
  self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.ClickItem, self)
  self.itemWrapHelper:AddEventListener(QuickBuyEvent.Select, self.SelectItem, self)
  local totalCost = self:FindGO("TotalCost")
  self.totalCost = SpriteLabel.new(totalCost, nil, 32, 32, true)
  local money = self:FindGO("Money")
  self.money = SpriteLabel.new(money, nil, 32, 32, true)
  self:UpdateMoney()
  self:UpdateTotalCost()
  self:UpdateBuyBtn()
  self:UpdateCloseBtn()
  QuickBuyProxy.Instance:CallItemInfo()
end
function QuickBuyView:UpdateView()
  self.loadingRoot:SetActive(false)
  self:UpdateItem()
  self:UpdateTotalCost()
  self:UpdateBuyBtn()
end
function QuickBuyView:UpdateItem()
  local data = QuickBuyProxy.Instance:GetItemList()
  if data then
    local newData = self:ReUniteCellData(data, 3)
    self.itemWrapHelper:UpdateInfo(newData)
  end
end
function QuickBuyView:UpdateTotalCost()
  local zenyCost, happyCost, lotteryCost = QuickBuyProxy.Instance:GetTotalCost()
  local zenyCostStr, happyCostStr, lotteryCostStr
  local _MyselfProxy = MyselfProxy.Instance
  if zenyCost <= _MyselfProxy:GetROB() then
    zenyCostStr = NumThousandFormat(zenyCost)
  else
    zenyCostStr = string.format(RED, NumThousandFormat(zenyCost))
  end
  if happyCost <= _MyselfProxy:GetGarden() then
    happyCostStr = NumThousandFormat(happyCost)
  else
    happyCostStr = string.format(RED, NumThousandFormat(happyCost))
  end
  if lotteryCost <= _MyselfProxy:GetLottery() then
    lotteryCostStr = NumThousandFormat(lotteryCost)
  else
    lotteryCostStr = string.format(RED, NumThousandFormat(lotteryCost))
  end
  local info = string.format(ZhString.QuickBuy_TotalCost, zenyCostStr, happyCostStr, lotteryCostStr)
  self.totalCost:Reset()
  self.totalCost:SetText(info, true)
  self:UpdateBuyReason(BuyReason.Money, zenyCost > 0 or happyCost > 0 or lotteryCost > 0)
end
function QuickBuyView:UpdateMoney()
  local _MyselfProxy = MyselfProxy.Instance
  local info = string.format(ZhString.QuickBuy_Own, NumThousandFormat(_MyselfProxy:GetROB()), NumThousandFormat(_MyselfProxy:GetGarden()), NumThousandFormat(_MyselfProxy:GetLottery()))
  self.money:Reset()
  self.money:SetText(info, true)
end
function QuickBuyView:UpdateCloseBtn()
  if self.canClose then
    self.closeBtn.CurrentState = 0
    self.closeBtnLabel.effectStyle = UILabel.Effect.Outline
  else
    self.closeBtn.CurrentState = 1
    self.closeBtnLabel.effectStyle = UILabel.Effect.None
  end
end
function QuickBuyView:UpdateBuyBtn()
  if self:CanBuy() then
    self.buyBtn.CurrentState = 0
    self.buyBtnLabel.effectStyle = UILabel.Effect.Outline
  else
    self.buyBtn.CurrentState = 1
    self.buyBtnLabel.effectStyle = UILabel.Effect.None
  end
end
function QuickBuyView:ClickItem(cell)
  local data = cell.data
  if data then
    self.tipData.itemdata = data.itemData
    self:ShowItemTip(self.tipData, cell.icon, NGUIUtil.AnchorSide.Left, {-220, 0})
  end
end
function QuickBuyView:SelectItem(cell)
  local data = cell.data
  if data then
    cell:SetChoose()
    self:UpdateTotalCost()
    self:UpdateBuyBtn()
  end
end
function QuickBuyView:Buy()
  self.delayTime = now
  if self:CanBuy() then
    local zenyCost, happyCost, lotteryCost = QuickBuyProxy.Instance:GetTotalCost()
    local _MyselfProxy = MyselfProxy.Instance
    if zenyCost > _MyselfProxy:GetROB() or happyCost > _MyselfProxy:GetGarden() or lotteryCost > _MyselfProxy:GetLottery() then
      MsgManager.ShowMsgByID(2969)
      return
    end
    QuickBuyProxy.Instance:StartBuyItem()
    self:UpdateBuyReason(BuyReason.Buying, false)
    self.canClose = false
    self.closeComp.enabled = not self:CanBuy()
    self:UpdateBuyBtn()
    self:UpdateCloseBtn()
  end
end
function QuickBuyView:HandleMyDataChange()
  self:UpdateMoney()
  self:UpdateTotalCost()
end
function QuickBuyView:CloseSelf()
  QuickBuyView.super.CloseSelf(self)
  EventManager.Me():PassEvent(QuickBuyEvent.CloseUI, self)
end
function QuickBuyView:UpdateBuyReason(reason, value)
  self.buyReasonMap[reason] = value
end
function QuickBuyView:CanBuy()
  for k, v in pairs(self.buyReasonMap) do
    if v == false then
      return false
    end
  end
  return true
end
function QuickBuyView:ReUniteCellData(datas, perRowNum)
  local newData = {}
  if datas ~= nil and #datas > 0 then
    for i = 1, #datas do
      local i1 = math.floor((i - 1) / perRowNum) + 1
      local i2 = math.floor((i - 1) % perRowNum) + 1
      newData[i1] = newData[i1] or {}
      if datas[i] == nil then
        newData[i1][i2] = nil
      else
        newData[i1][i2] = datas[i]
      end
    end
  end
  return newData
end
