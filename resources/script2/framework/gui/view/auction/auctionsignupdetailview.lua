AuctionSignUpDetailView = class("AuctionSignUpDetailView", ContainerView)
AuctionSignUpDetailView.ViewType = UIViewType.PopUpLayer
local iteminfo = {}
function AuctionSignUpDetailView:OnExit()
  if self.itemTipCell then
    self.itemTipCell:Exit()
  end
  if self.timeTick then
    TimeTickManager.Me():ClearTick(self)
    self.timeTick = nil
  end
  AuctionSignUpDetailView.super.OnExit(self)
end
function AuctionSignUpDetailView:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self:InitShow()
end
function AuctionSignUpDetailView:FindObjs()
  self.ownInfo = self:FindGO("OwnInfo"):GetComponent(UILabel)
  self.money = self:FindGO("Money"):GetComponent(UILabel)
  self.table = self:FindGO("Table"):GetComponent(UITable)
  self.countdown = self:FindGO("Countdown"):GetComponent(UILabel)
  self.rate = self:FindGO("Rate"):GetComponent(UILabel)
  local tableGO = self:FindGO("Table")
  self.tip = self:FindGO("Tip", tableGO):GetComponent(UILabel)
end
function AuctionSignUpDetailView:AddEvts()
  local confirmBtn = self:FindGO("ConfirmBtn")
  self:AddClickEvent(confirmBtn, function()
    self:Confirm()
  end)
end
function AuctionSignUpDetailView:AddViewEvts()
  self:AddListenEvt(ServiceEvent.RecordTradeReqServerPriceRecordTradeCmd, self.HandlePrice)
end
function AuctionSignUpDetailView:InitShow()
  local data = self.viewdata.viewdata
  if data then
    self.itemTipCell = ItemTipBaseCell.new(self.gameObject)
    self.itemTipCell:SetData(data.itemdata)
    self.itemid = data.itemdata.staticData.id
    local own = BagProxy.Instance:GetItemNumByStaticID(self.itemid)
    self.ownInfo.text = own or 0
    if data.price ~= nil then
      self:UpdatePrice(data.price)
    else
      FunctionItemTrade.Me():GetTradePrice(data.itemdata, true, false)
    end
    self.rate.text = string.format(ZhString.Auction_Rate, GameConfig.Auction.Rate * 100)
    self.tip.text = ZhString.Auction_SignUpDetailTip
    if self.timeTick == nil then
      self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateCountdown, self)
    end
    self.table:Reposition()
  end
  self:SetIgnoreClickEventInterval(true)
end
function AuctionSignUpDetailView:Confirm()
  local data = self.viewdata.viewdata
  if data then
    MsgManager.ConfirmMsgByID(9501, function()
      local equipInfo = data.itemdata.equipInfo
      if equipInfo and equipInfo.equiplv > 0 then
        local cost = GameConfig.EquipRecover.Upgrade[equipInfo.equiplv] or 0
        MsgManager.ConfirmMsgByID(10302, function()
          ServiceItemProxy.Instance:CallRestoreEquipItemCmd(data.itemdata.id, false, nil, false, true)
        end, nil, nil, cost)
      else
        TableUtility.TableClear(iteminfo)
        iteminfo.itemid = self.itemid
        helplog("CallSignUpItemCCmd", self.itemid, data.itemdata.id)
        ServiceAuctionCCmdProxy.Instance:CallSignUpItemCCmd(iteminfo, nil, data.itemdata.id)
      end
      self:CloseSelf()
    end)
  end
end
function AuctionSignUpDetailView:UpdatePrice(price)
  if price ~= nil then
    self.money.text = StringUtil.NumThousandFormat(price)
  end
end
function AuctionSignUpDetailView:UpdateCountdown()
  local auctionTime = AuctionProxy.Instance:GetAuctionTime()
  if auctionTime then
    local totalSec = auctionTime - ServerTime.CurServerTime() / 1000
    if totalSec > 0 then
      local day, hour, min, sec = ClientTimeUtil.FormatTimeBySec(totalSec)
      self.countdown.text = string.format(ZhString.Auction_Countdown, day, hour, min, sec)
      return
    end
  end
  self.countdown.gameObject:SetActive(false)
end
function AuctionSignUpDetailView:HandlePrice(note)
  local data = note.body
  if data ~= nil and data.itemData.base.id == self.itemid then
    local price = data.price * GameConfig.Auction.TradePriceDiscount / 100
    self:UpdatePrice(price)
  end
end
