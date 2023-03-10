ShopDressingView = class("ShopDressingView", ContainerView)
ShopDressingView.ViewType = UIViewType.NormalLayer
local UI_FLITER = GameConfig.DressingFilter and GameConfig.DressingFilter.UIFilter
function ShopDressingView:Init()
  self:FindObjs()
  self:InitUIView()
  self:AddEvts()
  self:AddServiceEvts()
end
function ShopDressingView:FindObjs()
  self.chargeTitle = self:FindGO("chargeTitle"):GetComponent(UILabel)
  self.chargeNum = self:FindGO("chargeNum"):GetComponent(UILabel)
  self.chargeWidget = self:FindGO("chargeNum"):GetComponent(UIWidget)
  self.itemIcon = self:FindGO("itemIcon"):GetComponent(UISprite)
  self.earningLabel = self:FindGO("earningLabel"):GetComponent(UILabel)
  self.earningIcon = self:FindGO("earningIcon"):GetComponent(UISprite)
  IconManager:SetItemIcon("item_100", self.earningIcon)
  self.replaceBtnLabel = self:FindGO("replaceBtnLabel"):GetComponent(UILabel)
  self.replaceBtn = self:FindGO("replaceBtn")
  self.replaceBtnSprite = self.replaceBtn:GetComponent(UISprite)
  self.touchZone = self:FindGO("touchZone")
end
function ShopDressingView:InitUIView()
  self.replaceBtnLabelColor = self.replaceBtnLabel.effectColor
  self.replaceBtnLabel.text = ZhString.HairDressingView_Replace
  self.chargeTitle.text = ZhString.HairDressingView_consume
  self.useUIModel = false
end
function ShopDressingView:AddEvts()
  self:AddClickEvent(self.replaceBtn, function(g)
    self:ClickReplaceBtn()
  end)
  self:AddDragEvent(self.touchZone, function(obj, delta)
    local fakeRole = ShopDressingProxy.Instance:GetFakeRole()
    if fakeRole then
      fakeRole:RotateDelta(-delta.x)
    end
  end)
end
function ShopDressingView:AddServiceEvts()
  self:AddListenEvt(MyselfEvent.MyDataChange, self.RefreshMoney)
  self:AddListenEvt(ServiceEvent.NUserUseDressing, self.RecvUseDressing)
end
function ShopDressingView:TabChangeHandler(key)
  ShopDressingView.super.TabChangeHandler(self, key)
end
function ShopDressingView:DisableState()
  self:Hide(self.itemIcon)
  self:Hide(self.chargeNum)
  self:Hide(self.chargeTitle)
  self:SetReplaceBtnState(false)
end
function ShopDressingView:RefreshMoney()
  local rob = MyselfProxy.Instance:GetROB()
  self.earningLabel.text = StringUtil.NumThousandFormat(rob)
end
function ShopDressingView:ClickReplaceBtn()
end
function ShopDressingView:SetReplaceBtnState(onoff)
  if onoff then
    self:SetTextureWhite(self.replaceBtnSprite.gameObject)
    self.replaceBtnLabel.effectColor = self.replaceBtnLabelColor
  else
    self:SetTextureGrey(self.replaceBtnSprite.gameObject)
    self.replaceBtnLabel.effectColor = ColorUtil.NGUIGray
  end
end
function ShopDressingView:RefreshModel()
  local args = ReusableTable.CreateArray()
  local _shopDressingProxy = ShopDressingProxy.Instance
  local queryArgs = ShopDressingProxy.Instance:GetQueryArgs()
  if nil ~= next(queryArgs) then
    args[1] = queryArgs[1] or _shopDressingProxy.originalHair
    args[2] = queryArgs[4] or _shopDressingProxy.originalHairColor
    args[3] = queryArgs[6] or _shopDressingProxy.originalEye
    args[6] = queryArgs[8] or _shopDressingProxy.originalBodyColor
    args[7] = nil ~= queryArgs[8] and ShopDressingProxy.Instance:getBodyID() or _shopDressingProxy.originalBody
  else
    args[1] = ShopDressingProxy.Instance.originalHair
    args[2] = ShopDressingProxy.Instance.originalHairColor
    args[3] = ShopDressingProxy.Instance.originalEye
    args[6] = ShopDressingProxy.Instance.originalBodyColor
    args[7] = ShopDressingProxy.Instance.originalBody
  end
  args[8] = ShopDressingProxy.Instance.originalHead
  args[9] = ShopDressingProxy.Instance.originalFace
  args[4] = nil == self.headgearToggle and true or self.headgearToggle.value
  args[5] = nil == self.facegearToggle and true or self.facegearToggle.value
  ShopDressingProxy.Instance:FakeDressingPreview(args)
  ReusableTable.DestroyAndClearArray(args)
end
function ShopDressingView:RecvUseDressing(note)
  self:SetReplaceBtnState(false)
end
function ShopDressingView:OnEnter()
  self:RefreshMoney()
  self:SetReplaceBtnState(false)
  ShopDressingView.super.OnEnter(self)
  if self.useUIModel then
    return
  end
  FunctionSceneFilter.Me():StartFilter(UI_FLITER)
  ShopDressingProxy.Instance:RedressModel(true)
end
function ShopDressingView:OnExit()
  ShopDressingProxy.Instance:Clear()
  Game.PerformanceManager:ResetLOD()
  ShopDressingView.super.OnExit(self)
  if self.useUIModel then
    return
  end
  FunctionSceneFilter.Me():EndFilter(UI_FLITER)
  ShopDressingProxy.Instance:RedressModel(false)
  self:CameraReset()
end
function ShopDressingView:OnShow()
  ShopDressingView.super.OnShow(self)
  Game.PerformanceManager:LODHigh()
end
