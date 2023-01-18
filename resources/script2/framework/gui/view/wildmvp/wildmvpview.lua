autoImport("WildMvpAffixSubview")
autoImport("WildMvpMonsterSubview")
autoImport("WildMvpBuffSubview")
WildMvpView = class("WildMvpView", ContainerView)
WildMvpView.ViewType = UIViewType.NormalLayer
function WildMvpView:Init()
  self:LoadSubviews()
  self:FindObjs()
  self:AddListenEvents()
  self:OnTabClicked(1)
end
function WildMvpView:LoadSubviews()
  self.subviewCtrls = {}
  self.subviewCtrls[1] = self:AddSubView("MonsterSubview", WildMvpMonsterSubview)
  self.subviewCtrls[2] = self:AddSubView("BuffSubview", WildMvpBuffSubview)
  self.subviewCtrls[3] = self:AddSubView("AffixSubview", WildMvpAffixSubview)
end
function WildMvpView:FindObjs()
  local closeBtn = self:FindGO("CloseBtn")
  self:AddClickEvent(closeBtn, function()
    self:OnCloseClicked()
  end)
  local menuGO = self:FindGO("Menu")
  local tabsGO = self:FindGO("Tabs", menuGO)
  self.tabs = {}
  self.tabs[1] = self:FindComponent("MonsterTab", UIToggle, tabsGO)
  self.tabs[2] = self:FindComponent("BuffTab", UIToggle, tabsGO)
  self.tabs[3] = self:FindComponent("AffixTab", UIToggle, tabsGO)
  self.monsterTimeLab = self:FindComponent("TimeLab", UILabel, self.tabs[1].gameObject)
  if self.monsterTimeLab then
    self.monsterTimeLab.text = WildMvpProxy.Instance:GetMonsterWorkTimeString()
  end
  for i, tab in ipairs(self.tabs) do
    self:AddClickEvent(tab.gameObject, function()
      self:OnTabClicked(i)
    end)
    break
  end
  self.bgTexture = self:FindComponent("Viewport", UITexture)
  PictureManager.ReFitFullScreen(self.bgTexture, 1)
  self.luckyPlayerActiveLab = self:FindComponent("LuckyPlayerActiveLab", UILabel)
  self.luckyPlayerActiveLab.text = ZhString.WildMvpLuckyPlayerActive
  self.luckyPlayerDeactiveLab = self:FindComponent("LuckyPlayerDeactiveLab", UILabel)
  self.luckyPlayerDeactiveLab.text = ZhString.WildMvpLuckyPlayerDeactive
  self.luckyPlayerToggle = self:FindComponent("LuckyPlayerToggle", UIToggle)
  self.luckyPlayerToggleTween = self.luckyPlayerToggle:GetComponent(UIPlayTween)
  self:AddOrRemoveGuideId(self.luckyPlayerToggle.gameObject, 523)
  self.isLuckyPlayer = Game.Myself.data:IsWildMvpLucky()
  self.luckyPlayerToggle.value = self.isLuckyPlayer
  self:UpdateLuckyPlayer()
  EventDelegate.Add(self.luckyPlayerToggle.onChange, function()
    local isLucky = Game.Myself.data:IsWildMvpLucky()
    if self.isLuckyPlayer ~= isLucky then
      MsgManager.ShowMsgByID(49)
      self.luckyPlayerToggle.value = self.isLuckyPlayer
      return
    end
    self.isLuckyPlayer = self.luckyPlayerToggle.value
    self.luckyPlayerToggleTween:Play(not self.isLuckyPlayer)
    self:UpdateLuckyPlayer()
    if type(SceneUser2_pb.EOPTIONTYPE_STORMBOSS_LUCKY) == "number" and self.isLuckyPlayer ~= isLucky then
      ServiceNUserProxy.Instance:CallNewSetOptionUserCmd(SceneUser2_pb.EOPTIONTYPE_STORMBOSS_LUCKY, self.isLuckyPlayer and 1 or 0)
    end
  end)
end
function WildMvpView:UpdateLuckyPlayer()
  if self.lastIndex ~= 1 then
    self.luckyPlayerToggle.gameObject:SetActive(false)
    self.luckyPlayerActiveLab.gameObject:SetActive(false)
    self.luckyPlayerDeactiveLab.gameObject:SetActive(false)
    return
  end
  self.luckyPlayerToggle.gameObject:SetActive(true)
  if self.isLuckyPlayer then
    self.luckyPlayerActiveLab.gameObject:SetActive(true)
    self.luckyPlayerDeactiveLab.gameObject:SetActive(false)
  else
    self.luckyPlayerActiveLab.gameObject:SetActive(false)
    self.luckyPlayerDeactiveLab.gameObject:SetActive(true)
  end
end
function WildMvpView:OnEnter()
  WildMvpView.super.OnEnter(self)
end
function WildMvpView:OnExit()
  WildMvpView.super.OnExit(self)
end
function WildMvpView:AddListenEvents()
end
function WildMvpView:OnCloseClicked()
  self:CloseSelf()
end
function WildMvpView:OnTabClicked(index)
  if self.lastIndex == index then
    return
  end
  local tab = self.tabs[index]
  if tab then
    tab.value = true
  end
  self:ShowSubView(index)
  self.lastIndex = index
  self:UpdateLuckyPlayer()
end
function WildMvpView:ShowSubView(index)
  for i, subview in ipairs(self.subviewCtrls) do
    local show = i == index
    if show then
      subview.gameObject:SetActive(true)
      if subview.OnShow then
        subview:OnShow()
      end
    else
      if subview.OnHide then
        subview:OnHide()
      end
      subview.gameObject:SetActive(false)
    end
  end
end
