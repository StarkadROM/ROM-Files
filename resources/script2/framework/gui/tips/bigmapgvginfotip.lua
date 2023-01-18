autoImport("BigMapGvgInfoTipCell")
BigMapGvgInfoTip = class("BigMapGvgInfoTip", CoreView)
function BigMapGvgInfoTip:ctor(go)
  BigMapGvgInfoTip.super.ctor(self, go)
  self:Init()
end
function BigMapGvgInfoTip:Init()
  self:FindObjs()
end
function BigMapGvgInfoTip:FindObjs()
  self.scrollView = self:FindComponent("StrongholdsView", UIScrollView)
  self.scrollCtl = ListCtrl.new(self:FindComponent("Grid", UIGrid, self.scrollView.gameObject), BigMapGvgInfoTipCell, "MiniMap/BigMapGvgInfoTipCell")
end
function BigMapGvgInfoTip:OnShow()
  self:SetPanelDepthByParent(self.scrollView, 1)
  self:UpdateView()
  EventManager.Me():AddEventListener(GVGEvent.GVG_PointUpdate, self.UpdateView, self)
end
function BigMapGvgInfoTip:OnHide()
  EventManager.Me():RemoveEventListener(GVGEvent.GVG_PointUpdate, self.UpdateView, self)
end
function BigMapGvgInfoTip:UpdateView()
  local datas = GvgProxy.Instance:GetGvgStrongHoldDatas() or {}
  self.scrollCtl:ResetDatas(datas)
end
