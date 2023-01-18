autoImport("GeneralHelp")
autoImport("SettingViewHelp")
TipsView = class("TipsView", BaseView)
autoImport("SettingViewHelp")
TipsView.ViewType = UIViewType.TipLayer
function TipsView.Me()
  if TipsView.me == nil then
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, {viewname = "TipsView"})
  end
  return TipsView.me
end
function TipsView:Init()
  TipsView.me = self
  self.panel = self.gameObject:GetComponent(UIPanel)
  self.currentTip = nil
  self.currentTipType = nil
end
function TipsView:OnExit()
  TipsView.super.OnExit(self)
  TipsView.me = nil
  self:HideCurrent()
end
function TipsView:ShowStickTip(viewType, data, side, stick, offset, prefabName)
  self:GetTip(viewType, prefabName)
  self:ResetTipContentPanel()
  self.currentTip:SetData(data, true)
  if self.currentTip == nil then
    return
  end
  local pos = NGUIUtil.GetAnchorPoint(self.currentTip, stick, side, offset)
  self.currentTip:SetPos(pos)
  self:ConstrainCurrentTip()
  self.currentTip:OnEnter()
end
function TipsView:ShowStickTipWAbsPos(viewType, data, prefabName, absPos)
  self:GetTip(viewType, prefabName)
  self:ResetTipContentPanel()
  self.currentTip:SetData(data, true)
  if self.currentTip == nil then
    return
  end
  self.currentTip:SetPos(absPos)
  self:ConstrainCurrentTip()
  self.currentTip:OnEnter()
end
function TipsView:ConstrainCurrentTip()
  self.panel:ConstrainTargetToBounds(self.currentTip.gameObject.transform, true)
end
function TipsView:ShowTip(viewType, data, prefabName)
  self:GetTip(viewType, prefabName)
  self:ResetTipContentPanel()
  self.currentTip:SetData(data)
  self.currentTip:OnEnter()
end
function TipsView:ShowGeneralHelp(data, title)
  self:ShowTip(GeneralHelp, data, "GeneralHelp")
  self.currentTip:SetTitle(title)
end
function TipsView:ShowGeneralHelpByHelpId(id)
  if not id then
    redlog("HelpID 未赋值")
    return
  end
  local config = Table_Help[id]
  if not config then
    redlog("检查Help配置 id： ", id)
  end
  local desc = config and config.Desc or ""
  local title = config and config.Title or ""
  self:ShowGeneralHelp(desc, title)
end
function TipsView:ResetTipContentPanel()
  local panels = Game.GameObjectUtil:GetAllComponentsInChildren(self.currentTip.gameObject, UIPanel, false)
  if panels then
    table.sort(panels, function(a, b)
      return a.depth < b.depth
    end)
    for i = 1, #panels do
      panels[i].depth = self.panel.depth + i
    end
  end
end
function TipsView:GetTip(viewType, prefabName)
  prefabName = prefabName or viewType.__cname
  if self.currentTip == nil or Game.GameObjectUtil:ObjectIsNULL(self.currentTip.gameObject) then
    self.currentTip = nil
    self.currentTipType = nil
  end
  if self.currentTipType ~= viewType then
    self:HideCurrent()
    self.currentTip = viewType.new(prefabName, self.gameObject)
    self.currentTipType = viewType
  end
end
function TipsView:HideTip(viewType)
  if self.currentTipType == viewType then
    self:HideCurrent()
  end
end
function TipsView:HideCurrent()
  if self.currentTip ~= nil and self.currentTip:OnExit() then
    self.currentTip:DestroySelf()
  end
  self.currentTip = nil
  self.currentTipType = nil
end
function TipsView:IsCurrentTip(viewType)
  return self.currentTipType == viewType
end
function TipsView:HappyShopBuyItem(stick, offset, data)
  local cell = HappyShopBuyItemCell.CreateInstance(self.trans)
  local cellGO = cell.gameObject
  if not Slua.IsNull(stick) then
    local x, y, z = LuaGameObject.GetPositionGO(stick.gameObject)
    LuaGameObject.SetPositionGO(cellGO, x, y, z)
  end
  if offset then
    local lx, ly, lz = LuaGameObject.GetLocalPositionGO(cellGO)
    local ox, oy, oz = offset[3] or offset[1] or 0, offset[2] or 0, 0
    LuaGameObject.SetLocalPositionGO(cellGO, lx + ox, ly + oy, lz + oz)
  end
  cell:Show()
  cell:SetData(data)
  HappyShopProxy.Instance:SetSelectId(data.id)
  return cell
end
