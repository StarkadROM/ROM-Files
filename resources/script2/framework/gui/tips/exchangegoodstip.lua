autoImport("BaseTip")
autoImport("ExchangeCombineItemCell")
ExchangeGoodsTip = class("ExchangeGoodsTip", BaseTip)
local FORMAT = string.format
local MULTI_FLAG = "Contribution"
ExchangeGoodsTip.TYPE = {PROGRESS = 1, NO_PROGRESS = 2}
function ExchangeGoodsTip:Init()
  self:FindObj()
  self:AddEvts()
  self:InitView()
  ExchangeShopProxy.Instance:InitStaticData()
end
function ExchangeGoodsTip:InitView()
  local container = self:FindGO("Container")
  local wrapConfig = {
    wrapObj = container,
    pfbNum = 5,
    cellName = "ExchangeCombineItemCell",
    control = ExchangeCombineItemCell,
    dir = 1
  }
  self.itemWrapHelper = WrapCellHelper.new(wrapConfig)
  self.itemWrapHelper:AddEventListener(ExchangeItemCellEvent.LongPress, self.OnClickCell, self)
  self.itemWrapHelper:AddEventListener(ExchangeItemCellEvent.LongPressSubtract, self.OnMinusItem, self)
  self.lackItems = {}
  self:UpdateGoods()
end
function ExchangeGoodsTip:FindObj()
  local rewardLab = self:FindComponent("RewardLab", UILabel)
  local matLab = self:FindComponent("MatLab", UILabel)
  matLab.text = ZhString.ExchangeShop_MatLab
  rewardLab.text = ZhString.ExchangeShop_RewardLab
  self.targetNumLab = self:FindComponent("TargetNumLab", UILabel)
  self.contributionNumLab = self:FindComponent("ContributionNumLab", UILabel)
  self.exchangeRewardIcon = self:FindComponent("ExchangeTarget", UISprite)
  self.nameLab = self:FindComponent("Name", UILabel)
  self.limitedLab = self:FindComponent("LimitedLab", UILabel)
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  self.scrollview = self:FindComponent("ScrollView", UIScrollView)
  self.confirmBtn = self:FindGO("ConfirmBtn")
  self.confirmLab = self:FindComponent("Label", UILabel, self.confirmBtn)
  self.confirmImg = self.confirmBtn:GetComponent(UISprite)
  self:SetConfirmState(false)
  self.quickBuyBtn = self:FindGO("QuickBuyBtn")
  self.cancelBtn = self:FindGO("CancelBtn")
  self.contributionPos = self:FindGO("Contribution")
  function self.closecomp.callBack(go)
    self:CloseSelf()
  end
  self.curPos = self.scrollview.gameObject.transform.localPosition.y
  ExchangeGoodsTip.super.Init(self)
end
function ExchangeGoodsTip:AddEvts()
  self:AddClickEvent(self.confirmBtn, function(go)
    self:OnClickConfirm()
  end)
  self:AddClickEvent(self.quickBuyBtn, function(go)
    self:OnQuickBuy()
  end)
  self:AddClickEvent(self.cancelBtn, function(go)
    self:CloseSelf()
  end)
  function self.scrollview.onStoppedMoving()
    self.curPos = self.scrollview.gameObject.transform.localPosition.y
  end
end
local ReUniteCellData = function(datas, perRowNum)
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
function ExchangeGoodsTip:SetData(data)
  self.isNormal = false
  local rewardId
  self.data = data
  if not self.data then
    return
  end
  self:Hide(self.limitedLab)
  local goods = {}
  if "number" == type(data) then
    self.isNormal = true
    self.id = data
    rewardId = 162
    self.nameLab.text = Table_Item[rewardId].Name
    self.contributionPos:SetActive(false)
    goods = ExchangeShopProxy.Instance.goodsMap[300400]
  else
    self.id = data.goodsId
    self.nameLab.text = data.staticData.Name
    rewardId = ExchangeShopProxy.Instance:GetRewardByGoods(self.id)
    self.contributionPos:SetActive(data.staticData.Source == 1)
    goods = ExchangeShopProxy.Instance.goodsMap[self.id]
    if self:GetLimitedNum() then
      self:Show(self.limitedLab)
      self.limitedLab.text = string.format(ZhString.ExchangeShopGoodsTip, self:GetLimitedNum())
    end
  end
  if rewardId then
    IconManager:SetItemIcon(Table_Item[rewardId].Icon, self.exchangeRewardIcon)
  end
  self:UpdateExchange(ExchangeShopProxy.Instance:GetChooseNum())
  if not goods then
    return
  end
  goods = ReUniteCellData(goods, 5)
  self.itemWrapHelper:ResetDatas(goods)
end
function ExchangeGoodsTip:UpdateExchange(goodsNum, rewardNum, extraNum)
  self.targetNumLab.text = FORMAT(ZhString.ExchangeShop_RewardNum, rewardNum)
  self.contributionNumLab.text = FORMAT(ZhString.ExchangeShop_RewardNum, extraNum)
end
function ExchangeGoodsTip:UpdateGoods(chooseid)
  TableUtility.ArrayClear(self.lackItems)
  local chooseitems = ExchangeShopProxy.Instance:_getChooseItem()
  self:UpdateExchange(ExchangeShopProxy.Instance:GetChooseNum())
  for i = 1, #chooseitems do
    local lackNum = chooseitems[i].num - ExchangeShopProxy.Instance:GetOwnCount(chooseitems[i].id)
    if lackNum > 0 then
      local lackItem = {
        id = chooseitems[i].id,
        count = lackNum
      }
      table.insert(self.lackItems, lackItem)
    end
  end
  self:UpdateOwn(chooseid)
  self.quickBuyBtn:SetActive(#self.lackItems > 0)
  self.confirmBtn:SetActive(#self.lackItems <= 0)
  self:SetConfirmState(#chooseitems > 0)
end
function ExchangeGoodsTip:UpdateOwn(chooseid)
  local cells = self.itemWrapHelper:GetCellCtls()
  for c = 1, #cells do
    local single = cells[c]:GetCells()
    for j = 1, #single do
      if chooseid then
        if single[j].data and single[j].data.staticData.id == chooseid then
          single[j]:UpdateOwn()
          return
        end
      else
        single[j]:UpdateOwn()
      end
    end
  end
end
function ExchangeGoodsTip:SetConfirmState(ligth)
  if ligth then
    ColorUtil.WhiteUIWidget(self.confirmImg)
    self.confirmLab.effectStyle = UILabel.Effect.Outline
  else
    ColorUtil.ShaderGrayUIWidget(self.confirmImg)
    self.confirmLab.effectStyle = UILabel.Effect.None
  end
end
function ExchangeGoodsTip:OnClickCell(cellCtl)
  if self.curPos ~= self.scrollview.gameObject.transform.localPosition.y then
    return
  end
  local data = cellCtl and cellCtl.data
  if not data then
    return
  end
  local ownCount = ExchangeShopProxy.Instance:GetOwnCount(data.staticData.id)
  self.islack = not ownCount or 0 == ownCount
  if self.islack and self.isNormal then
    local name = Table_Item[data.staticData.id].NameZh
    MsgManager.ShowMsgByID(3554, name)
    return
  end
  local worth_cfg = ExchangeShopProxy.Instance.goodsWorth[data.staticData.id].Worth
  if not self.isNormal then
    local worthNum = worth_cfg and worth_cfg[2] or 1
    local progressLimit = self.data.staticData.ExchangeLimit
    local _, chooseNum = ExchangeShopProxy.Instance:GetChooseNum()
    if nil == progressLimit or #progressLimit <= 0 then
      redlog("Table_ExchangeShop ExchangeLimit ???????????????")
    end
    local limit = self:GetLimitedNum()
    if limit and worthNum > limit - chooseNum then
      MsgManager.ShowMsgByID(2710)
      return
    end
  end
  ExchangeShopProxy.Instance:AddChooseItems(data.staticData.id, self.isNormal)
  self:UpdateGoods(data.staticData.id)
end
function ExchangeGoodsTip:GetLimitedNum()
  if self.isNormal then
    return
  end
  local exchangeType = self.data.staticData.ExchangeType
  local needLimit = exchangeType == ExchangeShopProxy.EnchangeType.PROGRESS or exchangeType == ExchangeShopProxy.EnchangeType.Limited_PROGRESS or exchangeType == ExchangeShopProxy.EnchangeType.MEDAL_PROGRESS
  if needLimit then
    local progressLimit = self.data.staticData.ExchangeLimit
    local isMedal = exchangeType == ExchangeShopProxy.EnchangeType.MEDAL_PROGRESS or self.data.isKapulaExchangeType == true
    local userMedalCount = Game.Myself.data.userdata:Get(UDEnum.TOTAL_MEDALCOUNT) or 0
    local c = isMedal and userMedalCount or self.data.exchangeCount
    return progressLimit[self.data.progress] - c
  end
end
function ExchangeGoodsTip:OnMinusItem(cellCtl)
  if self.curPos ~= self.scrollview.gameObject.transform.localPosition.y then
    return
  end
  local data = cellCtl and cellCtl.data
  if not data then
    return
  end
  ExchangeShopProxy.Instance:MinusChooseItem(data.staticData.id)
  self:UpdateGoods(data.staticData.id)
end
function ExchangeGoodsTip:OnClickConfirm()
  ExchangeShopProxy.Instance:CallExchange(self.id)
end
function ExchangeGoodsTip:OnQuickBuy()
  if #self.lackItems > 0 then
    self:CloseSelf()
    if QuickBuyProxy.Instance:TryOpenView(self.lackItems) then
      return
    end
  end
end
function ExchangeGoodsTip:OnEnter()
  EventManager.Me():AddEventListener(ItemEvent.ItemUpdate, self.UpdateGoods, self)
end
function ExchangeGoodsTip:CloseSelf()
  if self.callback then
    self.callback(self.callbackParam)
  end
  TipsView.Me():HideCurrent()
end
function ExchangeGoodsTip:DestroySelf()
  EventManager.Me():RemoveEventListener(ItemEvent.ItemUpdate, self.UpdateGoods, self)
  if not Slua.IsNull(self.gameObject) then
    GameObject.Destroy(self.gameObject)
  end
end
