autoImport("PaySignRewardCell")
autoImport("PaySignConfig")
PaySignRewardView = class("PaySignRewardView", ContainerView)
PaySignRewardView.ViewType = UIViewType.NormalLayer
local _STATUS_BTN = {
  [1] = {
    ZhString.PaySignRewardView_Receive,
    "new-com_btn_02",
    UILabel.Effect.Outline
  },
  [2] = {
    ZhString.PaySignRewardView_Wait,
    "new-com_btn_03",
    UILabel.Effect.None
  },
  [3] = {
    ZhString.PaySignRewardView_Finished,
    "new-com_btn_03",
    UILabel.Effect.None
  }
}
function PaySignRewardView:Init()
  self.actID = self.viewdata.viewdata.id
  self.actConfigData = PaySignConfig.new(self.actID)
  self:FindObjs()
  self:AddEvts()
  self:InitView()
end
function PaySignRewardView:OnEnter()
  GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.PopUpLayer)
  self.super.OnEnter(self)
end
function PaySignRewardView:OnExit()
  self.super.OnExit(self)
  TipsView.Me():HideCurrent()
  self:_DestroyEffect()
  PictureManager.Instance:UnLoadPaySignIn()
end
function PaySignRewardView:_DestroyEffect()
  if not self.effect then
    return
  end
  local cacheEffect
  for i = #self.effect, 1, -1 do
    cacheEffect = self.effect[i]
    if cacheEffect then
      if cacheEffect:Alive() then
        cacheEffect:Destroy()
      end
      self.effect[i] = nil
    end
  end
  self.effect = nil
end
function PaySignRewardView:FindObjs()
  self.descLab1 = self:FindComponent("DescLab1", UILabel)
  self.descLab3 = self:FindComponent("DescLab3", UILabel)
  self.timeLab = self:FindComponent("TimeLab", UILabel)
  self.rewardBtn = self:FindGO("RewardButton")
  self.rewardSpr = self.rewardBtn:GetComponent(UISprite)
  self.rewardLab = self:FindComponent("Lab", UILabel, self.rewardBtn)
  self:AddClickEvent(self.rewardBtn, function()
    self:OnRewardButton()
  end)
  self.effectParent = self:FindGO("Effect")
  self:PlayUIEffect(EffectMap.UI.PaySignRewardView, self.effectParent)
end
function PaySignRewardView:AddEvts()
  self:AddListenEvt(ServiceEvent.NUserPaySignRewardUserCmd, self.HandleSign)
end
function PaySignRewardView:InitView()
  self.actData = PaySignProxy.Instance:GetInfoMap(self.actID)
  if self.actConfigData:IsNoviceMode() then
    self:Hide(self.timeLab)
  else
    self:Show(self.timeLab)
    self.timeLab.text = PaySignProxy.Instance:GetActTime(self.actID)
  end
  self.descLab1.text = self.actConfigData:GetEntryDesc()
  self.descLab3.text = self.actConfigData:GetEntryRechargeDesc()
  self.effect = {}
  self.effectContainer = {}
  self.reward = {}
  self:Refresh()
end
function PaySignRewardView:RefreshReward()
  local prepTab = PaySignProxy.Instance:GetConfig_PaySign(self.actID)
  for i = 1, #prepTab do
    if not self.reward[i] then
      local cell = self:LoadPreferb("cell/PaySignRewardCell", self:FindGO("RewardRoot" .. i))
      self.reward[i] = PaySignRewardCell.new(cell)
      self.reward[i]:SetData(prepTab[i])
      self.effectContainer[i] = self:FindGO("EffContainer" .. i)
    end
    self.reward[i]:SetFinishFlag(self.actData.rewardDay and i <= self.actData.rewardDay)
    if i <= self.actData.rewardDay then
      if self.effect[i] then
        self.effect[i]:SetActive(false)
      end
    elseif i <= self.actData.unrewardDay + self.actData.rewardDay and i > self.actData.rewardDay then
      if nil == self.effect[i] then
        self:PlayUIEffect(EffectMap.UI.PaidCheckln_ui_remind, self.effectContainer[i], false, function(obj, args, assetEffect)
          self.effect[i] = assetEffect
          self.effect[i]:SetActive(true)
        end)
      else
        self.effect[i]:SetActive(true)
      end
    else
      if self.effect[i] then
        self.effect[i]:SetActive(false)
      else
      end
    end
  end
end
function PaySignRewardView:Refresh()
  redlog("PaySignRewardView:", self.actData.status)
  local statuscfg = _STATUS_BTN[self.actData.status]
  self.rewardLab.text = statuscfg[1]
  self.rewardSpr.spriteName = statuscfg[2]
  self.rewardLab.effectStyle = statuscfg[3]
  self:RefreshReward()
end
function PaySignRewardView:OnRewardButton()
  if not PaySignProxy.Instance:IsActTimeValid(self.actID) then
    MsgManager.ShowMsgByID(41104)
    return
  end
  if PaySignProxy.RECEIVE_REWARD_STATUS.CANRECEIVE ~= PaySignProxy.Instance:GetActStatus(self.actID) then
    return
  end
  ServiceNUserProxy.Instance:CallPaySignRewardUserCmd(self.actID)
end
function PaySignRewardView:HandleSign()
  self.actData = PaySignProxy.Instance:GetInfoMap(self.actID)
  self:Refresh()
end
