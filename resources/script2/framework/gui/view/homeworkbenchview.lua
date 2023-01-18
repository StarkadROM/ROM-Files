autoImport("CommonNewTabListCell")
HomeWorkbenchView = class("HomeWorkbenchView", BaseView)
HomeWorkbenchView.ViewType = UIViewType.Lv4PopUpLayer
HomeWorkbenchTabNameArray = {
  "StrengthTab",
  "RefineTab",
  "OneClickRefineTab",
  "EnchantTab"
}
HomeWorkbenchTabNameIconMap = {
  StrengthTab = "tab_icon_38",
  RefineTab = "tab_icon_86",
  OneClickRefineTab = "tab_icon_87",
  EnchantTab = "tab_icon_18"
}
HomeWorkbenchViewTabNameMap = {
  StrengthTab = ZhString.PackageView_StrengthTabName,
  RefineTab = ZhString.ShopMall_ExchangeRefine,
  OneClickRefineTab = ZhString.NpcRefinePanel_OneClickTabName,
  EnchantTab = ZhString.EnchantView_Enchant
}
local manager
function HomeWorkbenchView:Init()
  if not manager then
    manager = HomeManager.Me()
  end
  self:AddListenEvts()
  self:InitData()
  self:InitView()
end
function HomeWorkbenchView:AddListenEvts()
  self:AddListenEvt(UIEvent.CloseUI, self.OnCloseUI)
  self:AddListenEvt(HomeEvent.WorkbenchStartWork, self.OnStartWork)
  self:AddListenEvt(HomeEvent.WorkbenchHideHelpBtn, self.HideHelpButton)
  self:AddListenEvt(HomeEvent.WorkbenchShowHelpBtn, self.ShowHelpButton)
  self:AddListenEvt(HomeEvent.ExitHome, self.OnExitHome)
end
function HomeWorkbenchView:InitData()
  local viewData = self.viewdata.viewdata
  self.furniture = viewData and viewData.furniture
  self.actionName = viewData and viewData.actionName
end
function HomeWorkbenchView:InitView()
  self.grid = self:FindComponent("Grid", UIGrid)
  self.cells = {}
  local tabName, longPress
  for i = 1, #HomeWorkbenchTabNameArray do
    tabName = HomeWorkbenchTabNameArray[i]
    self.cells[i] = CommonNewTabListCell.new(self:FindGO(tabName))
    self.cells[i]:SetIcon(HomeWorkbenchTabNameIconMap[tabName])
    self:AddTabChangeEvent(self.cells[i].gameObject, nil, i)
    longPress = self.cells[i].gameObject:GetComponent(UILongPress)
    function longPress.pressEvent(obj, state)
      self:PassEvent(TipLongPressEvent.HomeWorkbenchView, {state, i})
    end
    break
  end
  self:AddEventListener(TipLongPressEvent.HomeWorkbenchView, self.HandleLongPress, self)
  self:InitShopEnter()
end
function HomeWorkbenchView:InitShopEnter()
  self.shopEnterBtn = self:FindGO("ShopEnter")
  self:AddClickEvent(self.shopEnterBtn, function()
    HappyShopProxy.Instance:InitShop(self.npcData, 1, 850)
    FunctionNpcFunc.JumpPanel(PanelConfig.HappyShop, self.viewdata.viewdata)
    self.noCloseNormal = true
    self:CloseSelf()
    manager.curWorkbenchTab = nil
    self.noCloseNormal = nil
  end)
end
function HomeWorkbenchView:OnEnter()
  HomeWorkbenchView.super.OnEnter(self)
  local isRefineOpen = self:_CheckCanOpen(4)
  self.cells[2].gameObject:SetActive(isRefineOpen)
  self.cells[3].gameObject:SetActive(isRefineOpen)
  local isEnchantOpen = self:_CheckCanOpen(73)
  self.cells[4].gameObject:SetActive(isEnchantOpen)
  self.grid:Reposition()
  local firstKey = manager.curWorkbenchTab or 1
  self:TabChangeHandler(firstKey)
end
function HomeWorkbenchView:OnExit()
  TimeTickManager.Me():ClearTick(self)
  if not self.noCloseNormal then
    self:sendNotification(UIEvent.CloseUI, UIViewType.NormalLayer)
  end
  HomeWorkbenchView.super.OnExit(self)
end
function HomeWorkbenchView:OnCloseUI(note)
  if self.notToClose then
    return
  end
  if not note or not note.body then
    return
  end
  local depth = not note.body.depth and note.body.ViewType and note.body.ViewType.depth
  if depth and depth > UIViewType.NormalLayer.depth then
    return
  end
  self:OnExitHome()
end
function HomeWorkbenchView:OnExitHome()
  manager.curWorkbenchTab = nil
  self:CloseSelf()
end
function HomeWorkbenchView:OnStartWork()
  if not self.furniture then
    return
  end
  self.furniture:PlayAction(self.actionName, nil, nil, nil, true)
end
function HomeWorkbenchView:TabChangeHandler(key)
  if not HomeWorkbenchView.super.TabChangeHandler(self, key) then
    return
  end
  if key == manager.curWorkbenchTab then
    return
  end
  self.notToClose = true
  TimeTickManager.Me():CreateOnceDelayTick(200, function(self)
    self.notToClose = nil
  end, self)
  self:JumpPanel(key)
  manager.curWorkbenchTab = key
  self.cells[key].toggle.value = true
end
function HomeWorkbenchView:JumpPanel(tabIndex)
  if tabIndex == 1 then
    self:_JumpPanel("EquipStrengthen", {hideTab = true})
  elseif tabIndex == 2 then
    self:_JumpPanel("NpcRefinePanel")
  elseif tabIndex == 3 then
    self:_JumpPanel("NpcRefinePanel", {isOneClick = true})
  elseif tabIndex == 4 then
    self:_JumpPanel("EnchantNewView", {isFromHomeWorkbench = true})
  end
end
function HomeWorkbenchView:_JumpPanel(panelKey, viewData)
  if not panelKey or not PanelConfig[panelKey] then
    return
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig[panelKey],
    viewdata = viewData
  })
end
function HomeWorkbenchView:_CheckCanOpen(menuId, withTip)
  return FunctionUnLockFunc.Me():CheckCanOpen(menuId, withTip)
end
function HomeWorkbenchView:AddHelpButtonEvent()
  self.helpButton = self:FindGO("HelpButton")
  if self.helpButton then
    self:AddClickEvent(self.helpButton, function()
      self:OpenHelpView(Table_Help[3000001])
    end)
  end
end
function HomeWorkbenchView:ShowHelpButton()
  if not self.helpButton then
    return
  end
  self.helpButton:SetActive(true)
end
function HomeWorkbenchView:HideHelpButton()
  if not self.helpButton then
    return
  end
  self.helpButton:SetActive(false)
end
function HomeWorkbenchView:HandleLongPress(param)
  local isPressing, index = param[1], param[2]
  TabNameTip.OnLongPress(isPressing, HomeWorkbenchViewTabNameMap[HomeWorkbenchTabNameArray[index]], false, self.cells[index].sp)
end
