autoImport("NewRechargeInnerSelectCell")
NewRechargeCommonSubView = class("NewRechargeCommonSubView", SubView)
local selectorLen = 190
local tickInstance
function NewRechargeCommonSubView:OnEnter()
  if not tickInstance then
    tickInstance = TimeTickManager.Me()
  end
  EventManager.Me():AddEventListener(ServiceEvent.ItemGetCountItemCmd, self.UpdateGetLimit, self)
end
function NewRechargeCommonSubView:OnExit()
  if tickInstance then
    tickInstance:ClearTick(self)
    self.scrollUpdateTick = nil
  end
  EventManager.Me():RemoveEventListener(ServiceEvent.ItemGetCountItemCmd, self.UpdateGetLimit, self)
end
function NewRechargeCommonSubView:UpdateGetLimit(note)
  local buyCell = self.parentView and self.parentView.ctrlShopItemPurchaseDetail
  if buyCell then
    buyCell:SetItemGetCount(note.data)
  end
end
function NewRechargeCommonSubView:OnInnerSelectionChange(cell)
  self:RefreshView(cell.data.ID)
end
function NewRechargeCommonSubView:getSelectorLen()
  return selectorLen
end
function NewRechargeCommonSubView:RefreshView(selectInnerTab)
  if self.innerSelectTab == selectInnerTab then
    return
  end
  if selectInnerTab ~= nil then
    if self.innerSelect_validIndex and TableUtility.ArrayFindIndex(self.innerSelect_validIndex, selectInnerTab) == 0 then
      selectInnerTab = self.innerSelect_validIndex[1]
    end
    self.innerSelectTab = selectInnerTab
  end
end
function NewRechargeCommonSubView:LoadInnerSelector(list)
  if not self.innerSelect_validIndex then
    self.innerSelect_validIndex = {}
  else
    TableUtility.ArrayClear(self.innerSelect_validIndex)
  end
  local item
  for i = 1, #list do
    item = list[i]
    if item.Invalid ~= true then
      TableUtility.ArrayPushBack(self.innerSelect_validIndex, item.ID)
    end
  end
  if #list > 1 then
    self.innerSelectListCtrl:ResetDatas(list, nil, true)
    self.innerSelectLine.gameObject:SetActive(true)
    self.innerSelectLine.width = #self.innerSelect_validIndex * self:getSelectorLen()
  else
    self.innerSelectListCtrl:ResetDatas(_EmptyTable, nil, true)
    self.innerSelectLine.gameObject:SetActive(false)
  end
end
function NewRechargeCommonSubView:SelectInnerSelector()
  local cells = self.innerSelectListCtrl:GetCells()
  for i = 1, #cells do
    local cell = cells[i]
    cell:SetSelect(cell.data.ID == self.innerSelectTab)
  end
end
function NewRechargeCommonSubView:FindObjs()
  local innerSelect = self:FindGO("InnerSelector")
  local innerSelectContainer = self:FindComponent("Grid", UIGrid, innerSelect)
  self.innerSelectListCtrl = UIGridListCtrl.new(innerSelectContainer, NewRechargeInnerSelectCell, "NewRechargeInnerSelectCell")
  self.innerSelectListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnInnerSelectionChange, self)
  self.innerSelectLine = self:FindComponent("BGLine", UISprite, innerSelect)
  self:LoadInnerSelector(GameConfig.NewRecharge.Tabs[self.Tab].Inner)
end
function NewRechargeCommonSubView:ShowShopItemPurchaseDetail(data)
  local shop_item_data = data.info
  if self.parentView and shop_item_data then
    self.parentView:ShopItemPurchaseDetailCell_Load(shop_item_data, data.m_funcRmbBuy)
    HappyShopProxy.Instance:SetSelectId(shop_item_data.id)
  end
end
local tipData, tipOffset = {}, {0, -90}
function NewRechargeCommonSubView:ShowGoodsItemTip(itemConfID)
  if itemConfID ~= nil then
    tipData.itemdata = ItemData.new(nil, itemConfID)
    TipManager.Instance:ShowItemFloatTip(tipData, self.parentView.widgetTipRelative, NGUIUtil.AnchorSide.Center, tipOffset)
  end
end
local checkBoundTriggerFactor = 0.6
function NewRechargeCommonSubView:ResetScrollUpdateParams(scrollView, scrollBar, leftTriggerCB, leftTriggerCBP, rightTriggerCB, rightTriggerCBP)
  if self.imScrollView then
    self.imScrollView.onDragStarted = nil
    self.imScrollView.onStoppedMoving = nil
  end
  self.imScrollView = scrollView
  self.imScrollBar = scrollBar
  if self.imScrollView and self.imScrollBar then
    function self.imScrollView.onDragStarted()
      self:OnScrollStart()
    end
    function self.imScrollView.onStoppedMoving()
      self:OnScrollStop()
    end
    self.imScrollBarTriggerSize = scrollBar.barSize * checkBoundTriggerFactor
    self.imScrollBarLeftTriggerCB = leftTriggerCB
    self.imScrollBarLeftTriggerCBP = leftTriggerCBP
    self.imScrollBarRightTriggerCB = rightTriggerCB
    self.imScrollBarRightTriggerCBP = rightTriggerCBP
  end
  if self.m_springPanel == nil then
    self.m_springPanel = scrollView.gameObject:GetComponent(SpringPanel)
  end
end
function NewRechargeCommonSubView:ResetScrollBarTriggerSize()
  if self.imScrollView and self.imScrollBar then
    self.imScrollBarTriggerSize = self.imScrollBar.barSize * checkBoundTriggerFactor
  end
end
function NewRechargeCommonSubView:OnScrollStart()
  self.scrollUpdateTick = tickInstance:CreateTick(0, 200, self.CheckScrollProcess, self, 998)
end
function NewRechargeCommonSubView:OnScrollStop()
  tickInstance:ClearTick(self, 998)
  self.scrollUpdateTick = nil
  local sbSize = self.imScrollBar.barSize
  if sbSize > 0.992 then
    self.imScrollBar.value = 0
  end
end
function NewRechargeCommonSubView:CheckScrollProcess()
  local cells = self.innerSelectListCtrl:GetCells()
  if cells == nil or #cells <= 1 then
    return
  end
  if not self.imScrollBar then
    return
  end
  local sbValue = self.imScrollBar.value
  local sbSize = self.imScrollBar.barSize
  if sbSize <= self.imScrollBarTriggerSize then
    if sbValue <= 0 and self.imScrollBarLeftTriggerCB then
      self.imScrollBarLeftTriggerCB(self, self.imScrollBarLeftTriggerCBP)
    elseif sbValue >= 1 and self.imScrollBarRightTriggerCB then
      self.imScrollBarRightTriggerCB(self, self.imScrollBarRightTriggerCBP)
    end
  end
end
