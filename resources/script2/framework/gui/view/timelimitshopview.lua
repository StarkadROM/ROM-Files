TimeLimitShopView = class("TimeLimitShopView", BaseView)
TimeLimitShopView.ViewType = UIViewType.NormalLayer
function TimeLimitShopView:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddMapEvts()
  self:InitData()
  self:InitShow()
end
function TimeLimitShopView:FindObjs()
  self.titleLabel = self:FindGO("TitleLabel"):GetComponent(UILabel)
  self.titleOutline = self:FindGO("TitleOutline"):GetComponent(UILabel)
  self.timeLabel = self:FindGO("TimeLabel"):GetComponent(UILabel)
  self.discount = self:FindGO("Discount")
  self.discountLabel_GO = self:FindGO("DiscountLabel")
  self.discountLabel = self.discountLabel_GO:GetComponent(UILabel)
  self.discount_TweenAlpha = self.discountLabel_GO:GetComponent(TweenAlpha)
  self.tipLabel = self:FindGO("TipLabel"):GetComponent(UILabel)
  self.originalPrice = self:FindGO("OriginalPrice"):GetComponent(UILabel)
  self.deleteLine = self:FindGO("DeleteLine")
  self.deleteLine_TweenScale = self.deleteLine:GetComponent(TweenScale)
  local currentPrice = self:FindGO("CurrentPrice")
  self.costIcon = self:FindGO("Icon", currentPrice):GetComponent(UISprite)
  self.costNum_GO = self:FindGO("CurrentPriceLabel", currentPrice)
  self.costNum = self.costNum_GO:GetComponent(UILabel)
  self.costNum_TweenAlpha = self.costNum_GO:GetComponent(TweenAlpha)
  local itemId = 151
  local itemData = Table_Item[itemId]
  if not itemData then
    redlog("Item表缺少配置", itemId)
  end
  IconManager:SetItemIcon(itemData.Icon, self.costIcon)
  local goodsList = self:FindGO("GoodsList")
  self.shopItems = {}
  for i = 1, 3 do
    self.shopItems[i] = {}
    self.shopItems[i].go = self:FindGO("Item" .. i)
    self.shopItems[i].num = self:FindGO("Count", self.shopItems[i].go):GetComponent(UILabel)
    self.shopItems[i].icon = self:FindGO("Icon", self.shopItems[i].go):GetComponent(UISprite)
    self:AddClickEvent(self.shopItems[i].go, function()
      if self.shopItems[i].itemId then
        local itemData = ItemData.new("Reward", self.shopItems[i].itemId)
        self.tipData.itemdata = itemData
        self:ShowItemTip(self.tipData, self.shopItems[i].icon, NGUIUtil.AnchorSide.Center, {200, -150})
      end
    end)
    break
  end
  self.bgTexture = self:FindGO("BGTexture"):GetComponent(UITexture)
  PictureManager.Instance:SetUI("Gift_bg_01", self.bgTexture)
  self.buyBtn = self:FindGO("BuyBtn")
  self.helpBtn = self:FindGO("HelpBtn")
  self.leftIndicator = self:FindGO("LeftIndicator")
  self.rightIndicator = self:FindGO("RightIndicator")
  self.effectContainer = self:FindGO("EffectContainer")
end
function TimeLimitShopView:AddEvts()
  self:AddClickEvent(self.buyBtn, function()
    local bCatGold = MyselfProxy.Instance:GetLottery()
    local cost = tonumber(self.costNum.text)
    local title = self.titleLabel.text
    if bCatGold < cost then
      MsgManager.ShowMsgByID(3634)
      return
    end
    local costStr = string.format(ZhString.Friend_RecallRewardItem, cost, Table_Item[151].NameZh)
    MsgManager.ConfirmMsgByID(9630, function()
      TimeLimitShopProxy.Instance:CallGiftTimeLimitBuyUserEvent(self.initId)
    end, nil, nil, costStr, title)
  end)
  self:AddClickEvent(self.helpBtn, function()
    local helpID = 35082
    if helpID and Table_Help[helpID] then
      local helpData = Table_Help[helpID]
      self:OpenHelpView(helpData)
    end
  end)
  self:AddClickEvent(self.leftIndicator, function()
    self:GoLeft()
  end)
  self:AddClickEvent(self.rightIndicator, function()
    self:GoRight()
  end)
end
function TimeLimitShopView:AddMapEvts()
  self:AddListenEvt(ServiceEvent.UserEventGiftTimeLimitBuyUserEvent, self.InitShow)
end
function TimeLimitShopView:InitData()
  self.tipData = {}
  self.tipData.funcConfig = {}
end
function TimeLimitShopView:GoLeft()
  self.curPage = self.curPage - 1
  if self.curPage < 1 then
    self.curPage = 1
  end
  self.initId = self.shopInfos[self.curPage] and self.shopInfos[self.curPage].id
  self.curGoodInfo = self.shopInfos[self.curPage]
  self:RefreshGoodPage(self.curGoodInfo)
  self:UpdateIndicator()
end
function TimeLimitShopView:GoRight()
  self.curPage = self.curPage + 1
  if self.curPage > self.maxPage then
    self.curPage = self.maxPage
  end
  self.initId = self.shopInfos[self.curPage] and self.shopInfos[self.curPage].id
  self.curGoodInfo = self.shopInfos[self.curPage]
  self:RefreshGoodPage(self.curGoodInfo)
  self:UpdateIndicator()
end
function TimeLimitShopView:UpdateIndicator()
  if self.curPage == 1 then
    self.leftIndicator:SetActive(false)
  else
    self.leftIndicator:SetActive(true)
  end
  if self.curPage >= self.maxPage then
    self.rightIndicator:SetActive(false)
  else
    self.rightIndicator:SetActive(true)
  end
end
function TimeLimitShopView:InitShow()
  self.shopInfos = TimeLimitShopProxy.Instance:GetShopInfos()
  if not self.shopInfos or #self.shopInfos == 0 then
    self:CloseSelf()
    return
  end
  self.maxPage = #self.shopInfos
  local initPage = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.initPage or false
  self.curPage = 1
  if not initPage then
    local newStock = TimeLimitShopProxy.Instance.newInstock
    if newStock then
      for i = 1, #self.shopInfos do
        if self.shopInfos[i].id == newStock then
          self.curPage = i
          break
        end
      end
    end
  end
  self.initId = self.shopInfos[self.curPage] and self.shopInfos[self.curPage].id
  self.curGoodInfo = self.shopInfos[self.curPage]
  self:RefreshGoodPage(self.curGoodInfo)
  self:UpdateIndicator()
end
function TimeLimitShopView:RefreshGoodPage(info)
  local id = info.id
  xdlog("刷新界面", id)
  local config = Table_GiftTimeLimit[id]
  if not config then
    return
  end
  self.titleLabel.text = config.Name
  self.titleOutline.text = config.Name
  self.originalPrice.text = ZhString.HappyShop_originalCost .. config.FullCost
  self.costNum.text = config.ItemCost
  self.discountLabel.text = math.ceil((1 - config.ItemCost / config.FullCost) * 100) .. "%"
  local itemReward = config.ItemReward
  if itemReward and #itemReward > 0 then
    for i = 1, 3 do
      if itemReward[i] then
        self.shopItems[i].go:SetActive(true)
        local single = itemReward[i]
        local itemId = single[1]
        local itemData = Table_Item[itemId]
        if not itemData then
          redlog("Item表缺少配置", itemId)
        end
        IconManager:SetItemIcon(itemData.Icon, self.shopItems[i].icon)
        local count = StringUtil.NumThousandFormat(single[2])
        self.shopItems[i].num.text = "x" .. count
        self.shopItems[i].itemId = itemId
      else
        self.shopItems[i].go:SetActive(false)
        self.shopItems[i].itemId = nil
      end
    end
  else
    for i = 1, 3 do
      self.shopItems[i].go:SetActive(false)
      self.shopItems[i].itemId = nil
    end
  end
  local startTimeStamp = info.time
  local endTimeStamp, endTime
  if EnvChannel.IsTFBranch() then
    endTime = config.EndTimeTF
  else
    endTime = config.EndTime
  end
  local st_year, st_month, st_day, st_hour, st_min, st_sec = StringUtil.GetDateData(endTime)
  local goodEndTimeStamp = os.time({
    day = st_day,
    month = st_month,
    year = st_year,
    hour = st_hour,
    min = st_min,
    sec = st_sec
  })
  endTimeStamp = startTimeStamp + config.LiveTime
  self.endTimeStamp = endTimeStamp
  TimeTickManager.Me():ClearTick(self, 1)
  if info.state ~= 1 then
    self.timeLabel.text = ZhString.BattlePassUpgradeView_bought
    self.buyBtn:SetActive(false)
  else
    TimeTickManager.Me():CreateTick(0, 1000, self.RefreshShopEndTime, self, 1)
  end
  self:RefreshTweenShow()
end
function TimeLimitShopView:RefreshShopEndTime()
  local curServerTime = ServerTime.CurServerTime() / 1000
  if curServerTime > self.endTimeStamp then
    redlog("活动时间结束")
    TimeTickManager.Me():ClearTick(self, 1)
    self.buyBtn:SetActive(false)
    return
  elseif not self.buyBtn.activeSelf then
    self.buyBtn:SetActive(true)
  end
  local leftDay, leftHour, leftMin, leftSec = ClientTimeUtil.GetFormatRefreshTimeStr(self.endTimeStamp)
  if leftDay > 0 then
    self.timeLabel.text = string.format("%02d:%02d:%02d", leftDay, leftHour, leftMin)
  else
    self.timeLabel.text = string.format("%02d:%02d:%02d", leftHour, leftMin, leftSec)
  end
end
function TimeLimitShopView:RefreshTweenShow()
  self.discount_TweenAlpha:ResetToBeginning()
  self.costNum_TweenAlpha:ResetToBeginning()
  self.deleteLine_TweenScale:ResetToBeginning()
  self.discount_TweenAlpha:PlayForward()
  self.costNum_TweenAlpha:PlayForward()
  self.deleteLine_TweenScale:PlayForward()
end
function TimeLimitShopView:OnEnter()
  TimeLimitShopView.super.OnEnter(self)
  TimeLimitShopProxy.Instance.showView = false
end
function TimeLimitShopView:OnExit()
  PictureManager.Instance:UnLoadUI("Gift_bg_01", self.bgTexture)
  TimeLimitShopView.super.OnExit(self)
  TimeTickManager.Me():ClearTick(self)
end
