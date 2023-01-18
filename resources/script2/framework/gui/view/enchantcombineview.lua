autoImport("CommonNewTabListCell")
EnchantCombineView = class("EnchantCombineView", BaseView)
EnchantCombineView.ViewType = UIViewType.NormalLayer
function EnchantCombineView:InitConfig()
  self.TabGOName = {
    "EnchantTab",
    "EnchantTransferTab"
  }
  self.TabIconMap = {
    EnchantTab = "tab_icon_enchant",
    EnchantTransferTab = "tab_icon_enchantment-transfer"
  }
  self.TabName = {
    ZhString.EnchantCombineView_EnchantTab,
    ZhString.EnchantCombineView_EnchantTransferTab
  }
  self.TabViewList = {
    PanelConfig.EnchantNewView,
    PanelConfig.EnchantTransferView
  }
end
function EnchantCombineView:Init()
  self:InitConfig()
  self:InitData()
  self:InitView()
end
function EnchantCombineView:InitData()
  local viewdata = self.viewdata.viewdata
  if viewdata then
    self.npcData = viewdata.npcdata
    self.index = viewdata.index or 1
    self.OnClickChooseBordCell_data = viewdata.OnClickChooseBordCell_data
    self.isFromBag = viewdata.isFromBag
  end
end
function EnchantCombineView:SetStackViewIndex(index)
  local viewdata = self.viewdata.viewdata
  if viewdata then
    viewdata.index = index
  end
end
function EnchantCombineView:InitView()
  self.grid = self:FindComponent("Grid", UIGrid)
  self.cells = {}
  local tabName, longPress
  for i = 1, #self.TabGOName do
    tabName = self.TabGOName[i]
    self.cells[i] = CommonNewTabListCell.new(self:FindGO(tabName))
    self.cells[i]:SetIcon(self.TabIconMap[tabName])
    do
      local check = {
        tab = i,
        id = self.TabViewList[i].id
      }
      self:AddTabChangeEvent(self.cells[i].gameObject, nil, check)
      longPress = self.cells[i].gameObject:GetComponent(UILongPress)
      function longPress.pressEvent(obj, state)
        self:PassEvent(TipLongPressEvent.EnchantCombineView, {state, i})
      end
    end
    break
  end
  self.shopEnterBtn = self:FindGO("ShopEnter")
  self:AddClickEvent(self.shopEnterBtn, function()
    self:JumpPanel(3)
  end)
  self:AddEventListener(TipLongPressEvent.EnchantCombineView, self.HandleLongPress, self)
end
function EnchantCombineView:HandleLongPress(param)
  local isPressing, index = param[1], param[2]
  TabNameTip.OnLongPress(isPressing, self.TabName[index], false, self.cells[index].sp)
end
function EnchantCombineView:TabChangeHandler(key)
  if not EnchantCombineView.super.TabChangeHandler(self, key) then
    return
  end
  self:JumpPanel(key)
  self.cells[key].toggle.value = true
end
local ReOpen = function(viewdata)
  FunctionNpcFunc.JumpPanel(PanelConfig.EnchantCombineView, viewdata)
end
function EnchantCombineView:JumpPanel(tabIndex)
  if tabIndex == 1 then
    self:SetStackViewIndex(1)
    self:_JumpPanel("EnchantNewView", {
      isFromHomeWorkbench = true,
      isCombine = true,
      OnClickChooseBordCell_data = self.OnClickChooseBordCell_data
    })
  elseif tabIndex == 2 then
    self:SetStackViewIndex(2)
    self:_JumpPanel("EnchantTransferView", {
      npcdata = self.npcData,
      isCombine = true,
      isnew = true
    })
  elseif tabIndex == 3 then
    FunctionNpcFunc.TypeFunc_Shop(self.npcData, 1, Table_NpcFunction[850], ReOpen, self.viewdata.viewdata)
  end
end
function EnchantCombineView:_JumpPanel(panelKey, viewData)
  if not panelKey or not PanelConfig[panelKey] then
    return
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig[panelKey],
    viewdata = viewData
  })
end
function EnchantCombineView:OnEnter()
  EnchantCombineView.super.OnEnter(self)
  self:TabChangeHandler(self.index)
  self:SetPushToStack(true)
end
function EnchantCombineView:CloseSelf()
  self:SetPushToStack(false)
  EnchantCombineView.super.CloseSelf(self)
end
function EnchantCombineView:OnExit()
  EnchantCombineView.super.OnExit(self)
  self:sendNotification(UIEvent.CloseUI, {
    className = "EnchantNewView",
    needRollBack = false
  })
  self:sendNotification(UIEvent.CloseUI, {
    className = "EnchantTransferView",
    needRollBack = false
  })
end
