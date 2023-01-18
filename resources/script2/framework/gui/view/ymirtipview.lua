autoImport("YmirTipCell")
YmirTipView = class("YmirTipView", BaseView)
YmirTipView.ViewType = UIViewType.PopUpLayer
local bookIconName = "tab_icon_yimier"
local offset
function YmirTipView:Init()
  self.mainPanel = self:FindGO("MainPanel")
  self.closecomp = self.mainPanel:GetComponent(CloseWhenClickOtherPlace)
  function self.closecomp.callBack(go)
    self:CloseSelf()
  end
  local bookGO = self:FindGO("BookBg")
  self:AddClickEvent(bookGO, function()
    self:OnBookClicked()
  end)
  local bookIcon = self:FindComponent("BookIcon", UISprite, bookGO)
  IconManager:SetUIIcon(bookIconName, bookIcon)
  local itemPanel = self:FindGO("ItemPanel")
  self.itemCtrl = ListCtrl.new(self:FindComponent("Grid", UIGrid, itemPanel), YmirTipCell, "YmirTipCell")
  self.itemCtrl:AddEventListener(MouseEvent.MouseClick, self.OnCellClicked, self)
  self.emptyGO = self:FindGO("Empty")
  self:UpdateTip()
end
function YmirTipView:OnCellClicked(cell)
  local myselfData = Game.Myself.data
  if myselfData:IsTransformed() then
    MsgManager.ShowMsgByID(27009)
    return
  end
  if myselfData:IsInMagicMachine() then
    MsgManager.ShowMsgByID(27008)
    return
  end
  if myselfData:IsOnWolf() then
    MsgManager.ShowMsgByID(27007)
    return
  end
  if myselfData:GetBuffListByType("Transform") ~= nil then
    MsgManager.ShowMsgByID(27009)
    return
  end
  if Game.Myself:IsInBooth() then
    MsgManager.ShowMsgByID(25708)
    return
  end
  local recordId = cell.data.id
  ServiceNUserProxy.Instance:CallLoadRecordUserCmd(recordId)
end
function YmirTipView:UpdateTip()
  local datas = MultiProfessionSaveProxy.Instance:GetProfessionRecordSimpleData()
  if datas then
    self.itemCtrl:ResetDatas(datas)
  end
  if datas and #datas > 0 then
    self.emptyGO:SetActive(false)
  else
    self.emptyGO:SetActive(true)
  end
end
function YmirTipView:OnEnter()
  YmirTipView.super.OnEnter(self)
  self:UpdateTipPosition()
  ServiceSceneUser3Proxy.Instance:CallQueryProfessionRecordSimpleData()
  EventManager.Me():AddEventListener(YmirEvent.OnSimpleRecordDataUpdated, self.UpdateTip, self)
end
function YmirTipView:OnExit()
  self.itemCtrl:RemoveAll()
  EventManager.Me():RemoveEventListener(YmirEvent.OnSimpleRecordDataUpdated, self.UpdateTip, self)
  YmirTipView.super.OnExit(self)
end
function YmirTipView:OnBookClicked()
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.MultiProfessionNewView,
    viewdata = {tab = 2}
  })
  self:CloseSelf()
end
function YmirTipView:UpdateTipPosition()
  local viewdata = self.viewdata and self.viewdata.viewdata
  if viewdata then
    local cellCtl = viewdata.cellCtl
    local stick = cellCtl and cellCtl.gameObject:GetComponentInChildren(UIWidget)
    if stick then
      local side = viewdata.side or NGUIUtil.AnchorSide.TopLeft
      offset = offset or LuaVector3.Zero()
      if viewdata.offset then
        LuaVector3.Better_SetPos(offset, viewdata.offset)
      else
        LuaVector3.Better_Set(offset, 0, 0, 0)
      end
      local newPos = NGUIUtil.GetAnchorPoint(self.mainPanel, stick, side, offset)
      self.mainPanel.transform.position = newPos
      local panel = self.gameObject:GetComponent(UIPanel)
      if panel then
        panel.gameObject:SetActive(false)
        panel.gameObject:SetActive(true)
        panel:ConstrainTargetToBounds(self.mainPanel.transform, true)
      end
    end
  end
end
