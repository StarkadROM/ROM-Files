CreateTipPanel = class("CreateTipPanel", BaseView)
CreateTipPanel.ViewType = UIViewType.PopUpLayer
function CreateTipPanel:Init()
  self.labTips = self:FindComponent("labTips", UILabel)
  self:AddListenEvt(XDEUIEvent.CloseCreateRoleTip, function()
    self:CloseSelf()
  end)
  self:AddButtonEvent("BGCollider", function(go)
    self:CloseSelf()
  end)
end
function CreateTipPanel:OnEnter()
  CreateTipPanel.super.OnEnter(self)
  local helpData = Table_Help[50000]
  self.labTips.text = helpData and helpData.Desc
  TimeTickManager.Me():CreateOnceDelayTick(50, function(owner, deltaTime)
    self.Scroll = self:FindGO("Scroll"):GetComponent(UITable)
    self.Scroll:Reposition()
  end, self)
end
function CreateTipPanel:OnExit()
  CreateTipPanel.super.OnExit(self)
end
