autoImport("EnchantCombineView")
RefineCombineView = class("RefineCombineView", EnchantCombineView)
RefineCombineView.ViewType = UIViewType.NormalLayer
function RefineCombineView:InitConfig()
  self.TabGOName = {
    "EnchantTab",
    "EnchantTransferTab"
  }
  self.TabIconMap = {
    EnchantTab = "tab_icon_86",
    EnchantTransferTab = "tab_icon_Refinery-transfer"
  }
  self.TabName = {
    ZhString.RefineCombineView_RefineTab,
    ZhString.RefineCombineView_RefineTransferTab
  }
  self.TabViewList = {
    PanelConfig.NpcRefinePanel,
    PanelConfig.RefineTransferView
  }
end
function RefineCombineView:InitView()
  RefineCombineView.super.InitView(self)
end
function RefineCombineView:JumpPanel(tabIndex)
  if tabIndex == 1 then
    self:SetStackViewIndex(1)
    self:_JumpPanel("NpcRefinePanel", {
      npcdata = self.npcData,
      isCombine = true,
      OnClickChooseBordCell_data = self.viewdata.viewdata and self.viewdata.viewdata.OnClickChooseBordCell_data
    })
  elseif tabIndex == 2 then
    self:SetStackViewIndex(2)
    self:_JumpPanel("RefineTransferView", {
      npcdata = self.npcData,
      isnew = true,
      isCombine = true
    })
  elseif tabIndex == 3 then
    HappyShopProxy.Instance:InitShop(self.npcData, 1, 850)
    FunctionNpcFunc.JumpPanel(PanelConfig.HappyShop, {
      npcdata = self.npcData
    })
  end
end
function RefineCombineView:OnExit()
  RefineCombineView.super.OnExit(self)
  self:sendNotification(UIEvent.CloseUI, {
    className = "NpcRefinePanel",
    needRollBack = false
  })
  self:sendNotification(UIEvent.CloseUI, {
    className = "RefineTransferView",
    needRollBack = false
  })
end
