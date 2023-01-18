autoImport("GPrayTypeCell")
autoImport("BaseGuildPrayDialog")
GuildPrayDialog = class("GuildPrayDialog", BaseGuildPrayDialog)
GuildPrayDialog.ViewType = UIViewType.DialogLayer
local _GuildCertificateId = GameConfig.Guild.praydeduction[1]
local _GuildCertificateZenyRate = GameConfig.Guild.praydeduction[2]
function GuildPrayDialog:InitUI()
  GuildPrayDialog.super.InitUI(self)
  self.title = self:FindComponent("Title", UILabel)
  self.title.text = ZhString.GuildPrayDialog_Title
  local sliverGo = self:FindGO("Silver")
  self.sliver = self:FindComponent("Label", UILabel, sliverGo)
  self.sliverIcon = self:FindComponent("symbol", UISprite, sliverGo)
  IconManager:SetItemIcon("item_100", self.sliverIcon)
  self.silverGetPathContainer = self:FindGO("GetPathContainer", sliverGo)
  local contributeGo = self:FindGO("Contribute")
  self.contributeIcon = self:FindComponent("symbol", UISprite, contributeGo)
  IconManager:SetItemIcon("item_140", self.contributeIcon)
  self.contributeGetPathContainer = self:FindGO("GetPathContainer", contributeGo)
  self.contribute = self:FindComponent("Label", UILabel, contributeGo)
  self.bindContributeGo = self:FindGO("BindContribute")
  self.bindContributeIcon = self:FindComponent("symbol", UISprite, self.bindContributeGo)
  IconManager:SetItemIcon("item_141", self.bindContributeIcon)
  self.bindContributeGetPathContainer = self:FindGO("GetPathContainer", self.bindContributeGo)
  self.bindContribute = self:FindComponent("Label", UILabel, self.bindContributeGo)
  self.certificateGO = self:FindGO("Certificate")
  self.certificate = self:FindComponent("Label", UILabel, self.certificateGO)
  self.certificateIcon = self:FindComponent("symbol", UISprite, self.certificateGO)
  IconManager:SetItemIcon(Table_Item[_GuildCertificateId].Icon, self.certificateIcon)
  self.certificateGetPathContainer = self:FindGO("GetPathContainer", self.certificateGO)
  self:AddClickEvent(sliverGo, function()
    self:ShowGetPathOfCost(GameConfig.MoneyId.Zeny, self.silverGetPathContainer)
  end)
  self:AddClickEvent(contributeGo, function()
    self:ShowGetPathOfCost(GameConfig.MoneyId.Contribute, self.contributeGetPathContainer)
  end)
  self:AddClickEvent(self.bindContributeGo, function()
    self:ShowGetPathOfCost(GameConfig.MoneyId.Bind_Contribute, self.bindContributeGetPathContainer)
  end)
  self:AddClickEvent(self.certificateGO, function()
    self:ShowGetPathOfCost(_GuildCertificateId, self.certificateGetPathContainer)
  end)
  local costRoot = self:FindGO("CostRoot")
  self.useTog = self:FindComponent("UseTog", UIToggle, costRoot)
  self.useTog.value = true
  self.fixedLab = self:FindComponent("FixedLab", UILabel, costRoot)
  self.fixedLab.text = ZhString.GuildPrayDialog_Cost
  self.costIcon = self:FindComponent("CostIcon", UISprite, costRoot)
  IconManager:SetItemIcon(Table_Item[_GuildCertificateId].Icon, self.costIcon)
  self.ownLab = self:FindComponent("OwnLab", UILabel, costRoot)
  local prayGrid = self:FindComponent("PrayGrid", UIGrid)
  self.prayCtl = UIGridListCtrl.new(prayGrid, GPrayTypeCell, "GPrayTypeCell")
  self.prayCtl:AddEventListener(MouseEvent.MouseClick, self.ChoosePray, self)
  self:InitPray()
  self:ChoosePray(self.prayCtl:GetCells()[1])
  self:_updateCoins()
end
function GuildPrayDialog:AddMapEvent()
  GuildPrayDialog.super.AddMapEvent(self)
  self:AddListenEvt(MyselfEvent.ContributeChange, self._updateContribution)
end
function GuildPrayDialog:OnClickPray()
  local chooseData = self.chooseData
  if not chooseData then
    return
  end
  local costMoney = chooseData.cost.Money
  local costContri = chooseData.cost.Contribution
  local level = chooseData.level or 1
  local uplv = GuildProxy.Instance.myGuildData.staticData and GuildProxy.Instance.myGuildData.staticData.BeliefUL
  if uplv and level >= uplv then
    MsgManager.ShowMsgByIDTable(2625)
    return
  end
  if self:UseCertificate() then
    local useCertificateCost = costMoney - _GuildCertificateZenyRate * self.useCostNum
    if useCertificateCost > self.nowSliver then
      MsgManager.ShowMsgByIDTable(1)
      return
    end
  elseif costMoney > self.nowSliver then
    MsgManager.ShowMsgByIDTable(1)
    return
  end
  if costContri > self.nowContribute + self.nowBindContribute then
    MsgManager.ShowMsgByIDTable(2820)
    return
  end
  self:ActiveLock(true)
  TimeTickManager.Me():ClearTick(self)
  TimeTickManager.Me():CreateOnceDelayTick(1500, function(owner, deltaTime)
    self:PlayPrayResultAnim()
    self:ActiveLock(false)
    self:_updatePrayGrid()
    self:_updateCoins()
    self:_updateDialogContent()
  end, self)
  local npcInfo = self:GetCurNpc()
  if npcInfo then
    ServiceGuildCmdProxy.Instance:CallPrayGuildCmd(GuildCmd_pb.EPRAYACTION_PRAY, chooseData.staticData.id, 1, self:UseCertificate())
  end
end
function GuildPrayDialog:UpdateCostLab()
  if not self.chooseData then
    return
  end
  local own = BagProxy.Instance:GetItemNumByStaticID(_GuildCertificateId, GameConfig.PackageMaterialCheck.guilddonate)
  local costMoney = self.chooseData.cost.Money
  costMoney = math.floor(costMoney / _GuildCertificateZenyRate)
  costMoney = math.min(costMoney, own)
  self.useCostNum = costMoney
  self.ownLab.text = costMoney .. "/" .. own
end
function GuildPrayDialog:UseCertificate()
  return self.useCostNum and self.useCostNum > 0 and self.useTog.value == true
end
function GuildPrayDialog:PlayPrayResultAnim()
  if self.lastChoose then
    self.lastChoose:PlayPrayEffect()
  end
end
function GuildPrayDialog:ChoosePray(cellCtl)
  if self.lastChoose then
    self.lastChoose:SetChoose(false)
  end
  cellCtl:SetChoose(true)
  self.chooseData = cellCtl.data
  self:_updateDialogContent()
  self:UpdateCostLab()
  if not self.lockState then
    self.lastChoose = cellCtl
  end
end
function GuildPrayDialog:_updateDialogContent()
  if self.lockState then
    return
  end
  local npcInfo = self:GetCurNpc()
  if not npcInfo then
    return
  end
  local prayDlgData = {
    Speaker = npcInfo.data.staticData.id,
    NoSpeak = true
  }
  local level, sData = self.chooseData.level, self.chooseData.staticData
  local attriID, nowValue = next(GuildFun.calcGuildPrayAttr(sData.id, level))
  local _, nextValue = next(GuildFun.calcGuildPrayAttr(sData.id, level + 1))
  if nextValue then
    local attrikey = Table_RoleData[attriID].VarName
    local attriPro = UserProxy.Instance:GetPropVO(attrikey)
    local isAttriPct = attriPro.isPercent
    local costMoney = self.chooseData.cost.Money
    costMoney = math.floor(costMoney)
    local costContri = self.chooseData.cost.Contribution
    local certificateName = Table_Item[_GuildCertificateId].NameZh
    local addvalue = nextValue - nowValue
    if isAttriPct then
      addvalue = string.format("%s%%", addvalue * 100)
    end
    prayDlgData.Text = string.format(ZhString.GuildPrayDialog_PrayTip, sData.Name, sData.Attr, addvalue, costMoney, certificateName, costContri)
  else
    prayDlgData.Text = string.format(ZhString.GuildPrayDialog_Pray_FullTip, sData.Name)
  end
  self.prayDialog:SetData(prayDlgData)
end
function GuildPrayDialog:InitPray()
  self:_updatePrayGrid()
end
function GuildPrayDialog:_updatePrayGrid()
  if self.lockState then
    return
  end
  self.faithDatas = GuildPrayProxy.Instance:GetPrayListByType(GuildCmd_pb.EPRAYTYPE_GODDESS)
  self.prayCtl:ResetDatas(self.faithDatas)
end
function GuildPrayDialog:_updateCoins()
  local rob = MyselfProxy.Instance:GetROB()
  self.nowSliver = rob
  self.sliver.text = StringUtil.NumThousandFormat(rob)
  self:_updateContribution()
  local certificateNum = BagProxy.Instance:GetItemNumByStaticID(_GuildCertificateId) or 0
  self.certificate.text = tostring(certificateNum)
  self:UpdateCostLab()
end
function GuildPrayDialog:_updateContribution()
  local contribution = MyselfProxy.Instance:GetContribution()
  self.contribute.text = StringUtil.NumThousandFormat(contribution)
  self.nowContribute = contribution
  local bindContribute = MyselfProxy.Instance:GetBindContribution()
  self.bindContribute.text = StringUtil.NumThousandFormat(bindContribute)
  self.nowBindContribute = bindContribute
end
function GuildPrayDialog:ShowGetPathOfCost(itemID, parent)
  if self.bdt then
    self.bdt:OnExit()
  elseif itemID then
    self.bdt = GainWayTip.new(parent)
    self.bdt:SetAnchorPos(false)
    self.bdt:SetData(itemID)
    self.bdt:AddEventListener(ItemEvent.GoTraceItem, function()
      self:CloseSelf()
    end, self)
    self.bdt:AddEventListener(GainWayTip.CloseGainWay, self.GetPathCloseCall, self)
  end
end
function GuildPrayDialog:GetPathCloseCall()
  self.bdt = nil
end
