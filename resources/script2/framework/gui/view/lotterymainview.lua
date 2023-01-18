autoImport("LotteryRecoverCombineCell")
autoImport("LotteryRecoverReadyCell")
autoImport("LotteryMixed")
autoImport("LotteryMagic")
autoImport("LotteryCardNew")
autoImport("LotteryCard")
autoImport("LotteryHeadwear")
autoImport("LotteryDailyRewardBord")
autoImport("UIAutoScrollCtrl")
LotteryMainView = class("LotteryMainView", ContainerView)
LotteryMainView.ViewType = UIViewType.BuildingLayer
local _Ten = 10
local _Eleven = 11
local _AEDiscountCoinTypeCoin = AELotteryDiscountData.CoinType.Coin
local _AEDiscountCoinTypeTicket = AELotteryDiscountData.CoinType.Ticket
local serverItems = {}
local _PictureMgr, _LotteryProxy
local bgTextureName = "mall_twistedegg_bg_bottom"
local dressPreviewTexturenName = "mall_twistedegg_bg_01"
local SkipStatus = {
  noSkip = {
    color = Color(0.5529411764705883, 0.49411764705882355, 0.3803921568627451, 1),
    sprite = "mall_twistedegg_bg_10"
  },
  skip = {
    color = ColorUtil.NGUIWhite,
    sprite = "mall_twistedegg_bg_04"
  }
}
local _FreeCostStr = "0"
local _ReUniteCellData = function(datas, perRowNum)
  local newData = {}
  if datas ~= nil and #datas > 0 then
    for i = 1, #datas do
      local i1 = math.floor((i - 1) / perRowNum) + 1
      local i2 = math.floor((i - 1) % perRowNum) + 1
      newData[i1] = newData[i1] or {}
      if datas[i] == nil then
        newData[i1][i2] = nil
      else
        newData[i1][i2] = datas[i]
      end
    end
  end
  return newData
end
local LoadCellPfb = function(cName, obj)
  local pfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(cName))
  if nil == pfb then
    error("can not find pfb" .. cName)
  end
  pfb.transform:SetParent(obj.transform, false)
  pfb.transform.localPosition = LuaGeometry.Const_V3_zero
  return pfb
end
local _SetLocalPositionGO = LuaGameObject.SetLocalPositionGO
function LotteryMainView:IsRecoverType()
  if not self.lotteryType then
    return
  end
  return LotteryProxy.IsRecoverType(self.lotteryType)
end
function LotteryMainView:LoadTexture()
  _PictureMgr:SetUI(bgTextureName, self.bgTexture)
  _PictureMgr:SetUI(dressPreviewTexturenName, self.dressPreviewTexture)
end
function LotteryMainView:UnloadTexture()
  _PictureMgr:UnLoadUI(bgTextureName, self.bgTexture)
  _PictureMgr:UnLoadUI(dressPreviewTexturenName, self.dressPreviewTexture)
  self:unLoadLotteryTexture()
end
function LotteryMainView:loadLotteryTexture()
  if self.lotteryTextureName then
    _PictureMgr:SetUI(self.lotteryTextureName, self.lotteryTexture)
  end
end
function LotteryMainView:unLoadLotteryTexture()
  if self.lotteryTextureName then
    _PictureMgr:UnLoadUI(self.lotteryTextureName, self.lotteryTexture)
  end
end
function LotteryMainView:OnEnter()
  self:LoadTexture()
  LotteryMainView.super.OnEnter(self)
  _LotteryProxy:CallQueryLotteryInfo(self.lotteryType)
  _LotteryProxy:SetIsOpenView(true)
  self:QueryLotteryExtraBonus()
  self:sendNotification(LotteryEvent.LotteryViewEnter)
  self.curSubView:Show()
  self:UpdateHelpBtn()
  self:UpdatePreviewBtn()
  self:UpdateSkip()
  self.toRecoverBtn:SetActive(self:IsRecoverType() and not self.isShowRecover)
end
function LotteryMainView:OnShow()
  Game.Myself:UpdateEpNodeDisplay(true)
end
function LotteryMainView:OnExit()
  self:UnloadTexture()
  LotteryProxy.Instance:SetIsOpenView(false)
  self.recoverHelper:Destroy()
  self:DeInitDress()
  LotteryMainView.super.OnExit(self)
  TimeLimitShopProxy.Instance:viewPopUp()
  _LotteryProxy:SetDress(false)
  UIModelUtil.Instance:ResetTexture(self.roleTexture)
  self.buyCell:Exit()
end
function LotteryMainView:SetBuyItemCell(cell)
  local shopItemData = cell.data
  if shopItemData then
    local id = shopItemData.id
    HappyShopProxy.Instance:SetSelectId(id)
    local itemType = shopItemData.itemtype
    if itemType and itemType ~= 2 then
      self.buyCell:SetData(shopItemData)
      self.buyCell.gameObject:SetActive(true)
      TipsView.Me():HideCurrent()
    else
      self.buyCell.gameObject:SetActive(false)
    end
  end
end
function LotteryMainView:Init()
  _PictureMgr = PictureManager.Instance
  _LotteryProxy = LotteryProxy.Instance
  self.recoverSelectItemIDs = {}
  self.readyRecoverSelect = {}
  self:FindObjs()
  self:InitLotteryType()
  self:InitMoney()
  self:AddEvts()
  self:AddViewEvts()
  self:InitShow()
end
function LotteryMainView:SetLotterySubView()
  if not self.lotteryType then
    return
  end
  if LotteryProxy.IsMixLottery(self.lotteryType) then
    if not self.mixLottery then
      self.mixLottery = self:AddSubView("LotteryMixed", LotteryMixed)
    end
    self.curSubView = self.mixLottery
  elseif LotteryProxy.IsMagicLottery(self.lotteryType) then
    if not self.magicLottery then
      self.magicLottery = self:AddSubView("LotteryMagic", LotteryMagic)
    end
    self.curSubView = self.magicLottery
  elseif LotteryProxy.IsNewPocketCardLottery(self.lotteryType) then
    if not self.cardLottery then
      self.cardLottery = self:AddSubView("LotteryCardNew", LotteryCardNew)
    end
    self.curSubView = self.cardLottery
  elseif LotteryProxy.IsCardLottery(self.lotteryType) then
    if not self.cardLottery then
      self.cardLottery = self:AddSubView("LotteryCard", LotteryCard)
    end
    self.curSubView = self.cardLottery
  elseif LotteryProxy.IsHeadLottery(self.lotteryType) then
    if not self.headwearLottery then
      self.headwearLottery = self:AddSubView("LotteryHeadwear", LotteryHeadwear)
    end
    self.curSubView = self.headwearLottery
  end
  self.skipType = LotteryProxy.Instance:GetSkipType(self.lotteryType)
end
function LotteryMainView:InitLotteryType()
  local t = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.lotteryType
  if not t then
    redlog("未指定新版扭蛋机扭蛋类型")
    return
  end
  self:SetLotteryType(t)
  _LotteryProxy:SetCurNewLottery(t)
  self:UpdateInfo()
  self:ShowRandomNpcModel()
  self:SetLotterySubView()
end
function LotteryMainView:SetLotteryType(t)
  self.lotteryType = t
  self.dailyRewardBord:UpdateByLotteryType(t)
end
function LotteryMainView:UpdateSkip()
  local skip = self:getSkip()
  local skipconfig = skip and SkipStatus.skip or SkipStatus.noSkip
  self.skipBtn.spriteName = skipconfig.sprite
  self.skipBtnSp.color = skipconfig.color
  self.skipedLab.gameObject:SetActive(skip)
  self.skipValue = skip
end
function LotteryMainView:FindObjs()
  self.colliderMaskObj = self:FindGO("ColliderMaskObj")
  self.colliderMaskObj:SetActive(false)
  self.helpBtn = self:FindGO("LotteryHelpButton")
  self.bgTexture = self:FindComponent("BgTexture", UITexture)
  self.dressPreviewTexture = self:FindComponent("PreviewTexture", UITexture, self.bgTexture.gameObject)
  self.successEffectContainer = self:FindGO("SuccessEffectContainer")
  self.dressRoot = self:FindGO("DressRoot")
  self.roleTexture = self:FindComponent("RoleTexture", UITexture, self.dressRoot)
  local objRotateRole = self:FindGO("RotateRoleCollider", self.dressRoot)
  self.objRotateRoleArrows = self:FindGO("RotateRoleArrows", self.dressRoot)
  self:AddDragEvent(objRotateRole, function(go, delta)
    self:RotateRoleEvt(go, delta)
  end)
  self:AddPressEvent(objRotateRole, function(go, isPress)
    self:PressRoleEvt(go, isPress)
  end)
  self.resetDressBtn = self:FindGO("ResetDressBtn", self.dressRoot)
  local resetDressLab = self:FindComponent("Label", UILabel, self.resetDressBtn)
  resetDressLab.text = ZhString.Lottery_ResetDress
  self.emojiBtn = self:FindGO("EmojiBtn", self.dressRoot)
  self.returnLotteryInfoBtn = self:FindGO("ReturnLotteryInfoBtn", self.dressRoot)
  self.hideSelfDressToggle = self:FindComponent("HideSelfDressBtn", UIToggle, self.dressRoot)
  self.hideSelfDressToggle.value = false
  EventDelegate.Add(self.hideSelfDressToggle.onChange, function()
    self:_LoadModel()
  end)
  local hideSelfDressLab = self:FindComponent("Label", UILabel, self.hideSelfDressToggle.gameObject)
  hideSelfDressLab.text = ZhString.Lottery_HideSelfDressing
  self.lotteryInfoRoot = self:FindGO("LotteryInfoRoot")
  self.skipBtn = self:FindComponent("SkipBtn", UISprite, self.lotteryInfoRoot)
  self.skipBtnSp = self:FindComponent("Sprite", UISprite, self.skipBtn.gameObject)
  self.skipedLab = self:FindComponent("SkipedLab", UILabel, self.skipBtn.gameObject)
  self.skipedLab.text = ZhString.Lottery_Skiped
  self.npcTexRoot = self:FindGO("NpcTexRoot", self.lotteryInfoRoot)
  self.lotteryNpcTexture = self:FindComponent("LotteryNPCTexture", UITexture, self.npcTexRoot)
  self.lotteryTexture = self:FindComponent("LotteryTexture", UITexture, self.lotteryInfoRoot)
  self.lotteryName = self:FindComponent("LotteryName", UILabel, self.lotteryInfoRoot)
  self.lotteryTime = self:FindComponent("LotteryTime", UILabel, self.lotteryInfoRoot)
  self.toggleGird = self:FindComponent("ToggleGrid", UIGrid, self.lotteryInfoRoot)
  self.lotteryAD = self:FindComponent("LotteryAD", UILabel, self.lotteryInfoRoot)
  self.adScroll = self:FindComponent("ADPanel", UIScrollView)
  self.adScrollCtrl = UIAutoScrollCtrl.new(self.adScroll, self.lotteryAD)
  self.oneToggle = self:FindComponent("LotteryOneToggle", UISprite, self.toggleGird.gameObject)
  self.oneToggleSp = self:FindGO("Sp", self.oneToggle.gameObject)
  self.isOneTime = true
  self:AddClickEvent(self.oneToggle.gameObject, function()
    if self.isOneTime then
      return
    end
    self.isOneTime = true
    self:UpdateLimit()
    self:UpdateCost()
    self:UpdateTicketCost()
    self:Show(self.oneToggleSp)
    self:Hide(self.tenToggleSp)
  end)
  self.oneToggleDesc = self:FindComponent("OneToggleDesc", UILabel, self.oneToggle.gameObject)
  self.oneToggleDesc.text = ZhString.Lottery_One
  self.tenToggle = self:FindComponent("LotteryTenToggle", UISprite, self.toggleGird.gameObject)
  self.tenToggleSp = self:FindGO("Sp", self.tenToggle.gameObject)
  self:Hide(self.tenToggleSp)
  self:AddClickEvent(self.tenToggle.gameObject, function()
    if BranchMgr.IsJapan() then
      if not self.isOneTime then
        return
      end
      self.isOneTime = false
      self:Hide(self.oneToggleSp)
      self:Show(self.tenToggleSp)
    else
      self.isOneTime = not self.isOneTime
      self.tenToggleSp:SetActive(not self.isOneTime)
    end
    self:UpdateLimit()
    self:UpdateCost()
    self:UpdateTicketCost()
  end)
  self.tenToggleDesc = self:FindComponent("TenToggleDesc", UILabel, self.tenToggle.gameObject)
  self.tenToggleDesc.text = ZhString.Lottery_Ten
  self.btnGrid = self:FindComponent("BtnGrid", UIGrid, self.lotteryInfoRoot)
  self.lotteryBtn = self:FindGO("LotteryBtn", self.btnGrid.gameObject)
  self.lotteryBtn_Icon = self:FindComponent("LotteryIcon", UISprite, self.lotteryBtn)
  self.lotteryCost = self:FindComponent("Cost", UILabel, self.lotteryBtn)
  self.lotterySaleIcon = self:FindGO("saleIcon", self.lotteryBtn)
  self.lotterySaleIcon:SetActive(false)
  self.lotteryDiscountLab = self:FindComponent("LotteryDiscount", UILabel, self.lotteryBtn)
  self.lotteryLimit = self:FindComponent("LotteryLimitedLab", UILabel)
  self.lotteryLimitBg = self:FindGO("Bg1", self.lotteryLimit.gameObject):GetComponent(UISprite)
  self.ticketBtn = self:FindGO("TicketBtn", self.btnGrid.gameObject)
  self.ticketBtn_Icon = self:FindComponent("TicketIcon", UISprite, self.ticketBtn)
  self.ticketCost = self:FindComponent("Cost", UILabel, self.ticketBtn)
  self.ticketDiscountLab = self:FindComponent("TicketDiscount", UILabel, self.ticketBtn)
  self.ticketLimitLab = self:FindComponent("TicketLimit", UILabel, self.ticketBtn)
  self.changeLotteryRoot = self:FindGO("ChangeLotteryRoot", self.lotteryInfoRoot)
  self.preLotteryBtn = self:FindGO("PreBtn", self.changeLotteryRoot)
  self.nextLotteryBtn = self:FindGO("NextBtn", self.changeLotteryRoot)
  self.dressPreviewBtn = self:FindGO("DressPreviewBtn")
  self.recoverRoot = self:FindGO("RecoverRoot")
  self.toRecoverBtn = self:FindGO("ToRecoverBtn")
  self.toRecoverBtnLab = self:FindComponent("Lab", UILabel, self.toRecoverBtn)
  self.toRecoverBtnLab.text = ZhString.Lottery_Recover
  self.recoverReturnBtn = self:FindGO("RecoverReturnBtn", self.recoverRoot)
  self.recoverEmpty = self:FindGO("RecoverEmpty", self.recoverRoot)
  local recoverEmptyLab = self:FindComponent("EmptyLabel", UILabel, self.recoverEmpty)
  recoverEmptyLab.text = ZhString.Lottery_RecoverEmptyLab
  self.recoverTotalLabel = self:FindComponent("RecoverTotalLabel", UILabel, self.recoverRoot)
  local recoverFixedLab = self:FindComponent("RecoverFixedLab", UILabel, self.recoverTotalLabel.gameObject)
  recoverFixedLab.text = ZhString.Lottery_RecoverFixed
  self.recoverIcon = self:FindComponent("RecoverIcon", UISprite, self.recoverTotalLabel.gameObject)
  self.recoverBtn = self:FindComponent("RecoverBtn", UIMultiSprite, self.recoverRoot)
  self.recoverLabel = self:FindComponent("RecoverLabel", UILabel, self.recoverBtn.gameObject)
  self.recoverLabel.text = ZhString.UniqueConfirmView_Confirm
  self.recoverTipDesc = self:FindComponent("RecoverTipDesc", UILabel, self.recoverRoot)
  self.recoverTipDesc.text = ZhString.Lottery_RecoverTipDesc
  local container = self:FindGO("RecoverContainer", self.recoverRoot)
  local wrapConfig = {}
  wrapConfig.wrapObj = container
  wrapConfig.pfbNum = 3
  wrapConfig.cellName = "LotteryRecoverCombineCell"
  wrapConfig.control = LotteryRecoverCombineCell
  self.recoverHelper = WrapCellHelper.new(wrapConfig)
  self.recoverHelper:AddEventListener(MouseEvent.MouseClick, self.ClickPlusRecover, self)
  local readyContainer = self:FindGO("ReadyContainer", self.recoverRoot)
  self.readyRecoverHelper = WrapListCtrl.new(readyContainer, LotteryRecoverReadyCell, "LotteryRecoverReadyCell", 2, 1)
  self.readyRecoverHelper:AddEventListener(LotteryEvent.Select, self.ClickMinusRecover, self)
  self:ShowRecover(false)
  self.extraBonusRoot = self:FindGO("ExtraBonusRoot")
  if self.extraBonusRoot then
    self.bonusTitle = self:FindComponent("bonusTitle", UILabel, self.extraBonusRoot)
    self.bonusTitle.text = ZhString.Lottery_Bonus
    self.progressSlider = self:FindComponent("ProgressSlider", UISlider, self.extraBonusRoot)
    self.progressSliderSp = self:FindComponent("ProgressSlider", UISprite, self.extraBonusRoot)
    self.progressBackground = self:FindComponent("ProgressBackground", UISprite, self.progressSlider.gameObject)
    self.progressGrid = self:FindComponent("progressGrid", UIGrid, self.extraBonusRoot)
  end
  self.rewardTip = self:FindGO("RewardTip")
  if self.rewardTip then
    self.rewardTipLabel = self:FindComponent("TipLabel", UILabel, self.rewardTip)
    self.rewardTipGrid = self:FindComponent("RewardGrid", UIGrid, self.rewardTip)
  end
  self.rewardDetailBoard = self:FindGO("RewardDetailBoard")
  if self.rewardDetailBoard then
    self.rewardDetailGrid = self:FindComponent("RewardDetailGrid", UIGrid, self.rewardDetailBoard)
    self.rewardDetailBgCollider = self:FindGO("BgCollider", self.rewardDetailBoard)
    self.rewardDetailConfirmBtn = self:FindGO("RewardDetailConfirmBtn", self.rewardDetailBoard)
    self.rewardDetailFakeConfirmBtn = self:FindGO("RewardDetailFakeConfirmBtn", self.rewardDetailBoard)
    self.rewardDetailFakeConfirmLabel = self:FindComponent("Label", UILabel, self.rewardDetailFakeConfirmBtn)
    self.rewardDetailCancelBtn = self:FindGO("RewardDetailCancelBtn", self.rewardDetailBoard)
  end
  local go = LoadCellPfb("HappyShopBuyItemCell", self.gameObject)
  self.buyCell = HappyShopBuyItemCell.new(go)
  self.buyCell.gameObject:SetActive(false)
  local extrahelp = self:FindGO("ExtraHelpButton")
  self:AddClickEvent(extrahelp, function()
    local extraHelpid = GameConfig.Lottery.activity[self.lotteryType].extraHelpID
    if not extraHelpid then
      redlog("GameConfig.Lottery.activity 未配置扭蛋额外奖励HelpID，扭蛋类型： ", self.lotteryType)
      if LotteryProxy.IsMagicLottery(self.lotteryType) then
        extraHelpid = 35021
      elseif LotteryProxy.IsHeadLottery(self.lotteryType) then
        extraHelpid = 35211
      end
    end
    TipsView.Me():ShowGeneralHelpByHelpId(extraHelpid)
  end)
  self.dailyRewardRoot = self:FindGO("DailyRewardRoot")
  self.dailyRewardBord = LotteryDailyRewardBord.new(self.dailyRewardRoot)
end
function LotteryMainView:ShowRandomNpcModel()
  local id = self:_GetRandomNpcId()
  self.npcLoadSuccess = self:_LoadNpcTexture(id)
  self.npcTexRoot:SetActive(self.npcLoadSuccess)
  self.lotteryTexture.gameObject:SetActive(not self.npcLoadSuccess)
end
local _sexField = {
  [1] = "male",
  [2] = "female"
}
local _raceField = {
  [1] = "Human",
  [2] = "Cat"
}
function LotteryMainView:_GetRandomNpcId()
  if not GameConfig.Lottery.RaceNpc then
    return
  end
  if not self.lotteryType then
    return
  end
  local sex = Game.Myself.data.userdata:Get(UDEnum.SEX)
  sex = _sexField[sex]
  local profession = Game.Myself.data.userdata:Get(UDEnum.PROFESSION)
  local race = ProfessionProxy.GetRaceByProfession(profession)
  race = _raceField[race]
  local lotteryRaceNpc = GameConfig.Lottery.RaceNpc[self.lotteryType]
  if not lotteryRaceNpc then
    return
  end
  local npcConfig = lotteryRaceNpc[race] and lotteryRaceNpc[race][sex]
  if not npcConfig or #npcConfig == 0 then
    return
  end
  local index = math.random(1, #npcConfig)
  return npcConfig[index]
end
function LotteryMainView:_LoadNpcTexture(npcid)
  local sdata = npcid and Table_Npc[npcid]
  if not sdata then
    return false
  end
  UIModelUtil.Instance:ResetTexture(self.lotteryNpcTexture)
  if self.npcModel and self.npcModel:Alive() then
    local npcParts = Asset_RoleUtility.CreateNpcRoleParts(sdata.id)
    self.npcModel:Redress(npcParts)
    Asset_Role.DestroyPartArray(npcParts)
  else
    self.npcModel = UIModelUtil.Instance:SetNpcModelTexture(self.lotteryNpcTexture, sdata.id, nil, function(obj)
      self.npcModel = obj
      self.npcModel:PlayAction_PlayShow()
      local pss = self.npcModel.complete.gameObject:GetComponentsInChildren(ParticleSystem)
      for i = 1, #pss do
        pss[i].transform.parent.gameObject:SetActive(false)
      end
    end)
  end
  local showPos = sdata.LoadShowPose
  if showPos and #showPos == 3 then
    self.npcModel:SetPosition(LuaGeometry.GetTempVector3(showPos[1] or 0, showPos[2] or 0, showPos[3] or 0))
  end
  if sdata.LoadShowRotate then
    self.npcModel:SetEulerAngleY(sdata.LoadShowRotate)
  end
  local otherScale = sdata.LoadShowSize or sdata.Scale or sdata.Shape and GameConfig.UIModelScale[sdata.Shape] or 1
  self.npcModel:SetScale(otherScale)
  UIModelUtil.Instance:SetCellTransparent(self.lotteryNpcTexture)
  return true
end
function LotteryMainView:UpdateHelpBtn()
  if self.curSubView and self.curSubView.UpdateHelpBtn then
    self.curSubView:UpdateHelpBtn()
  end
end
function LotteryMainView:HandleItemUpdate()
  if self.curSubView and self.curSubView.HandleItemUpdate then
    self.curSubView:HandleItemUpdate()
  end
end
function LotteryMainView:ActiveHelpBtn(var)
  self.helpBtn:SetActive(var)
end
function LotteryMainView:TenToggleEnabled()
  return self.tenToggle.gameObject.activeSelf == true and not self.isOneTime and LotteryProxy.Instance:CheckTenLottery(self.lotteryType)
end
function LotteryMainView:OnClickResetDress()
  _LotteryProxy:ClearDressMap()
  self:_LoadModel()
  if self.curSubView and self.curSubView.EnterDress then
    self.curSubView:EnterDress(false)
  end
end
function LotteryMainView:ToDress(enterDress)
  if enterDress then
    self.lotteryInfoRoot:SetActive(false)
    self:EnterDress()
  else
    self.lotteryInfoRoot:SetActive(true)
    self:ExitDress()
  end
end
local _DefaultDoramTail = 400214
function LotteryMainView:GetRolePart(part)
  local userdata = Game.Myself.data.userdata
  if self:CheckHideSelf() then
    if part == UDEnum.TAIL and userdata:Get(UDEnum.TAIL) == _DefaultDoramTail then
      return _DefaultDoramTail
    elseif part == UDEnum.BODY then
      return self:GetClassBody()
    else
      return 0
    end
  end
  return userdata:Get(part) or 0
end
function LotteryMainView:GetClassBody()
  local class = Game.Myself.data.userdata:Get(UDEnum.PROFESSION)
  local gender = Game.Myself.data.userdata:Get(UDEnum.SEX)
  if gender == ProtoCommon_pb.EGENDER_MALE then
    return Table_Class[class].MaleBody
  else
    return Table_Class[class].FemaleBody
  end
end
local partIndex = Asset_Role.PartIndex
local partIndexEx = Asset_Role.PartIndexEx
function LotteryMainView:_LoadModel()
  if nil == self.roleParts then
    self.roleParts = Asset_Role.CreatePartArray()
  end
  local userdata = Game.Myself.data.userdata
  local gender = userdata:Get(UDEnum.SEX)
  local originalBody = self.roleParts[partIndex.Body]
  self.roleParts[partIndex.Body] = _LotteryProxy:GetDressID(partIndex.Body) or self:GetRolePart(UDEnum.BODY)
  self.roleParts[partIndex.LeftWeapon] = 0
  self.roleParts[partIndex.RightWeapon] = 0
  self.roleParts[partIndex.Mount] = 0
  self.roleParts[partIndex.Eye] = userdata:Get(UDEnum.EYE)
  self.roleParts[partIndex.Hair] = userdata:Get(UDEnum.HAIR)
  self.roleParts[partIndex.Head] = _LotteryProxy:GetDressID(partIndex.Head) or self:GetRolePart(UDEnum.HEAD)
  self.roleParts[partIndex.Face] = _LotteryProxy:GetDressID(partIndex.Face) or self:GetRolePart(UDEnum.FACE)
  self.roleParts[partIndex.Tail] = _LotteryProxy:GetDressID(partIndex.Tail) or self:GetRolePart(UDEnum.TAIL)
  self.roleParts[partIndex.Wing] = _LotteryProxy:GetDressID(partIndex.Wing) or self:GetRolePart(UDEnum.BACK)
  self.roleParts[partIndex.Mouth] = _LotteryProxy:GetDressID(partIndex.Mouth) or self:GetRolePart(UDEnum.MOUTH)
  self.roleParts[partIndexEx.Gender] = gender
  self.roleParts[partIndexEx.HairColorIndex] = _LotteryProxy:GetDressID(partIndexEx.HairColorIndex) or self.originalHairColor
  self.roleParts[partIndexEx.EyeColorIndex] = _LotteryProxy:GetDressID(partIndexEx.EyeColorIndex) or self:GetRolePart(UDEnum.EYECOLOR)
  self.roleParts[partIndexEx.BodyColorIndex] = _LotteryProxy:GetDressID(partIndexEx.BodyColorIndex) or self:GetRolePart(UDEnum.CLOTHCOLOR)
  if not self.assetRole then
    UIModelUtil.Instance:ChangeBGMeshRenderer(bgTextureName, self.modelTexture)
    self.assetRole = UIModelUtil.Instance:SetRoleModelTexture(self.roleTexture, self.roleParts, UIModelCameraTrans.Lottery, nil, nil, nil, nil, function(obj)
      self.assetRole = obj
    end)
  else
    self.assetRole:Redress(self.roleParts)
  end
  local nowBody = self.roleParts[partIndex.Body]
  if originalBody ~= nowBody and nowBody ~= self:GetClassBody() then
    self.assetRole:PlayAction_PlayShow()
  end
end
function LotteryMainView:ClearRole()
  if self.assetRole and self.assetRole:Alive() then
    self.assetRole:Destroy()
    self.assetRole = nil
  end
end
function LotteryMainView:CheckHideSelf()
  return self.hideSelfDressToggle.value == true
end
function LotteryMainView:ClickCell(cell)
  if not _LotteryProxy.inDress then
    return
  end
  local itemData = cell.data:GetItemData()
  local dressID = itemData.staticData.id
  local partIndex = ItemUtil.getItemRolePartIndex(dressID)
  if 0 == partIndex then
    return
  end
  if Asset_Role.PartIndex.Body == partIndex then
    local myRace = MyselfProxy.Instance:GetMyRace()
    dressID = Table_Equip[dressID].Body[myRace]
  end
  _LotteryProxy:UpdateDressMap(partIndex, dressID)
  self:_LoadModel()
end
function LotteryMainView:EnterDress()
  _LotteryProxy:SetDress(true)
  self.dressRoot:SetActive(true)
  self.originalHairColor = Game.Myself.data.userdata:Get(UDEnum.HAIRCOLOR)
  self:_LoadModel()
  if self.curSubView and self.curSubView.EnterDress then
    self.curSubView:EnterDress(false)
  end
end
function LotteryMainView:PressRoleEvt(go, isPress)
  if self.assetRole then
    self.objRotateRoleArrows:SetActive(isPress)
  end
end
function LotteryMainView:RotateRoleEvt(go, delta)
  if self.assetRole then
    self.assetRole:RotateDelta(-delta.x * 360 / 400)
  end
end
function LotteryMainView:_DestroyPart()
  if self.roleParts then
    Asset_Role.DestroyPartArray(self.roleParts)
    self.roleParts = nil
  end
end
function LotteryMainView:DeInitDress()
  self:_DestroyPart()
  self:ClearRole()
  _LotteryProxy:ClearDressMap()
end
function LotteryMainView:ExitDress()
  _LotteryProxy:SetDress(false)
  self.dressRoot:SetActive(false)
  self:DeInitDress()
  if self.curSubView and self.curSubView.EnterDress then
    self.curSubView:EnterDress(true)
  end
end
function LotteryMainView:UpdateInfo()
  self.activityData = LotteryProxy.Instance:GetActivityLotteryData()
  if not self.activityData then
    return
  end
  self.lotteryName.text = self.activityData.name
  self.lotteryTextureName = self.activityData.texture
  self:loadLotteryTexture()
  self:SetLotteryTime(self.activityData.time)
  local adText = GameConfig.Lottery.activity[self.lotteryType].ADText or ""
  self.lotteryAD.text = adText
  if adText ~= "" then
    self.adScrollCtrl:Start(true, true)
  else
    self.adScrollCtrl:Stop()
  end
end
function LotteryMainView:ActiveLotteryTime(var)
  self.lotteryTime.gameObject:SetActive(var)
end
function LotteryMainView:SetLotteryTime(t)
  self.lotteryTime.text = t
end
function LotteryMainView:UpdatePreviewBtn(forceHide)
  if forceHide then
    self.dressPreviewBtn:SetActive(false)
    self.dressPreviewTexture.gameObject:SetActive(false)
  else
    local isCard = LotteryProxy.IsNewPocketCardLottery(self.lotteryType) or LotteryProxy.IsCardLottery(self.lotteryType)
    local isMixShop = LotteryProxy.IsMixLottery(self.lotteryType) and self.curSubView.viewIndex == LotteryMixed.ViewIndex.Shop
    self.dressPreviewBtn:SetActive(not isCard and not isMixShop)
    self.dressPreviewTexture.gameObject:SetActive(not isCard and not isMixShop)
  end
end
function LotteryMainView:ChangeLottery(isPre)
  local actData = _LotteryProxy:GetNextLottery(isPre)
  if actData then
    self.isUpdateRecover = true
    self:ShowRecover(false)
    self.curSubView:Hide()
    self:SetLotteryType(actData.lotteryType)
    self.extraBonusShown = nil
    _LotteryProxy:SetCurNewLottery(self.lotteryType)
    self:unLoadLotteryTexture()
    self:UpdateInfo()
    self:ShowRandomNpcModel()
    self:SetLotterySubView()
    self:InitMoney()
    _LotteryProxy:CallQueryLotteryInfo(self.lotteryType)
    self:QueryLotteryExtraBonus()
    self.curSubView:Show()
    self:UpdateHelpBtn()
    self:UpdatePreviewBtn()
    self.toRecoverBtn:SetActive(self:IsRecoverType())
    self:UpdateSkip()
    self:UpdateDiscount()
    self:UpdateLimit()
    self.isOneTime = true
    self:Hide(self.tenToggleSp)
    self:UpdateCost()
  end
end
function LotteryMainView:OnClickLotteryHelp()
  if self.curSubView and self.curSubView.OnClickLotteryHelp then
    self.curSubView:OnClickLotteryHelp()
  end
end
function LotteryMainView:AddEvts()
  self:AddClickEvent(self.helpBtn, function()
    self:OnClickLotteryHelp()
  end)
  self:AddClickEvent(self.addMoneyBtn, function()
    self:JumpZenyShop()
  end)
  self:AddClickEvent(self.skipBtn.gameObject, function()
    self:Skip()
  end)
  self:AddClickEvent(self.lotteryBtn, function()
    local hasFreeCnt = LotteryProxy.Instance:HasFreeCnt(self.lotteryType)
    if self:TenToggleEnabled() then
      if hasFreeCnt then
        self:LotteryTen()
      else
        OverseaHostHelper:GachaUseComfirm(self.lotteryCostValue * 10, function()
          self:LotteryTen()
        end)
      end
    elseif hasFreeCnt then
      self:Lottery()
    else
      OverseaHostHelper:GachaUseComfirm(self.lotteryCostValue, function()
        self:Lottery()
      end)
    end
  end)
  self:AddClickEvent(self.ticketBtn, function()
    if self:TenToggleEnabled() then
      self:TicketTen()
    else
      self:Ticket()
    end
  end)
  self:AddClickEvent(self.toRecoverBtn, function()
    self:ToRecover()
  end)
  if self.rewardDetailConfirmBtn then
    self:AddClickEvent(self.rewardDetailConfirmBtn, function()
      local stage = LotteryProxy.Instance:GetCurrentExtraStageByType(self.lotteryType)
      if not stage then
        return
      end
      ServiceItemProxy.Instance:CallGetLotteryExtraBonusItemCmd(self.lotteryType, stage, nil, self.rewardDetailRewardIndex)
    end)
  end
  if self.rewardDetailCancelBtn then
    self:AddClickEvent(self.rewardDetailCancelBtn, function()
      self.rewardDetailBoard:SetActive(false)
    end)
  end
  if self.rewardDetailBgCollider then
    self:AddClickEvent(self.rewardDetailBgCollider, function()
      self.rewardDetailBoard:SetActive(false)
    end)
  end
  self:AddClickEvent(self.preLotteryBtn, function()
    self:ChangeLottery(false)
  end)
  self:AddClickEvent(self.nextLotteryBtn, function()
    self:ChangeLottery(true)
  end)
  self:AddClickEvent(self.dressPreviewBtn, function()
    self:ToDress(true)
  end)
  self:AddClickEvent(self.recoverReturnBtn, function()
    self:ShowRecover(false)
  end)
  self:AddClickEvent(self.resetDressBtn, function()
    self:OnClickResetDress()
  end)
  self:AddClickEvent(self.returnLotteryInfoBtn, function()
    self:ToDress(false)
  end)
  self:AddClickEvent(self.emojiBtn, function()
  end)
  self:AddClickEvent(self.recoverBtn.gameObject, function()
    self:Recover()
  end)
end
function LotteryMainView:AddViewEvts()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.HandleItemUpdate)
  self:AddListenEvt(ServiceEvent.ItemLotteryRateQueryCmd, self.HandleLotteryRateQuery)
  self:AddListenEvt(MyselfEvent.LotteryChange, self.UpdateLottery)
  self:AddListenEvt(ServiceEvent.ItemQueryLotteryInfo, self.UpdateViewByLotteryType)
  self:AddListenEvt(LotteryEvent.NewLotteryAnimationStart, self.HandleEffectStart)
  self:AddListenEvt(LotteryEvent.NewLotteryAnimationEnd, self.HandleEffectEnd)
  self:AddListenEvt(LotteryEvent.RefreshCost, self.HandleRefreshCost)
  self:AddListenEvt(ServiceEvent.ItemLotteryCmd, self.UpdateLimit)
  self:AddListenEvt(ServiceEvent.ActivityEventActivityEventNtf, self.HandleActivityEventNtf)
  self:AddListenEvt(ServiceEvent.ActivityEventActivityEventNtfEventCntCmd, self.HandleActivityEventNtfEventCnt)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
  self:AddListenEvt(XDEUIEvent.LotteryAnimationEnd, self.lotteryAnimationEnd)
  self:AddListenEvt(ServiceEvent.ItemQueryLotteryExtraBonusItemCmd, self.OnRecvExtraBonusItemCmd)
  self:AddListenEvt(ServiceEvent.ItemQueryLotteryExtraBonusCfgCmd, self.OnRecvExtraBonusCfgCmd)
  self:AddListenEvt(ServiceEvent.ItemMixLotteryArchiveCmd, self.HandleMixLotteryArchive)
  self:AddListenEvt(ServiceEvent.ItemLotteryDailyRewardSyncItemCmd, self.HandleLotteryDailyRewardSyncItemCmd)
end
function LotteryMainView:HandleLotteryDailyRewardSyncItemCmd()
  self.dailyRewardBord:HandleSyncDailyItem()
end
function LotteryMainView:HandleLotteryRateQuery(note)
  local data = note.body
  if not data then
    return
  end
  if self.curSubView and self.curSubView.HandleLotteryRateQuery and self.curSubView.lotteryType == data.type then
    self.curSubView:HandleLotteryRateQuery(data)
  end
end
function LotteryMainView:HandleMixLotteryArchive()
  if self.curSubView.HandleMixLotteryArchive then
    self.curSubView:HandleMixLotteryArchive()
  end
end
function LotteryMainView:CloseSelf()
  LotteryProxy.Instance:SetCurNewLottery(nil)
  LotteryMainView.super.CloseSelf(self)
end
function LotteryMainView:PlaySuccessUIEffect()
  self:PlayUIEffect(EffectMap.UI.LotteryCard_New, self.successEffectContainer, true)
end
function LotteryMainView:InitShow()
  if self.extraBonusRoot then
    self.extraBonusRoot:SetActive(false)
    autoImport("ExtraBonusCell")
    self.progressCtrl = UIGridListCtrl.new(self.progressGrid, ExtraBonusCell, "ExtraBonusCell")
    self.progressCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickExtraBonus, self)
  end
  if self.rewardTip then
    autoImport("MaterialItemCell")
    self.rewardTipItemCtrl = UIGridListCtrl.new(self.rewardTipGrid, MaterialItemCell, "MaterialItemCell")
    self.rewardTipItemCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickRewardTipCell, self)
  end
  if self.rewardDetailBoard then
    autoImport("MaterialSelectItemCell")
    self.rewardDetailItemCtrl = UIGridListCtrl.new(self.rewardDetailGrid, MaterialSelectItemCell, "MaterialSelectItemCell")
    self.rewardDetailItemCtrl:AddEventListener(MouseEvent.LongPress, self.OnLongPressRewardDetailItem, self)
  end
  if BranchMgr.IsJapan() then
    self:Show(self.oneToggle)
    self.tenToggleDesc.text = ZhString.Lottery_Eleven
    local bg = self:FindGO("Bg1", self.tenToggle.gameObject)
    bg:SetActive(false)
  end
  self:UpdateDiscount()
  self:UpdateLimit()
end
function LotteryMainView:UpdateViewByLotteryType()
  if self.curSubView and self.curSubView.HandleQueryLotteryInfo then
    self.curSubView:HandleQueryLotteryInfo()
  end
  self.toRecoverBtn:SetActive(self:IsRecoverType() and not self.isShowRecover)
  self:UpdateHelpBtn()
  self:UpdateSkip()
  self:UpdatePreviewBtn()
  self:UpdateDiscount()
  self:UpdateLimit()
  self:UpdateCost()
  self:UpdateTicketCost()
end
function LotteryMainView:JumpZenyShop()
  FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit)
end
function LotteryMainView:Skip()
  LocalSaveProxy.Instance:SetSkipAnimation(self.skipType, not self:getSkip())
  self:UpdateSkip()
end
function LotteryMainView:Lottery()
  if self.curSubView and self.curSubView.Lottery then
    self.curSubView:Lottery()
    return
  end
  local data = LotteryProxy.Instance:GetInfo(self.lotteryType)
  if data then
    self:CallLottery(data.price, nil, nil, 1, data.freeCount)
  end
end
function LotteryMainView:LotteryTen()
  if self.curSubView and self.curSubView.LotteryTen then
    self.curSubView:LotteryTen()
    return
  end
  local data = LotteryProxy.Instance:GetInfo(self.lotteryType)
  if data then
    self:CallLottery(data.price, nil, nil, _Ten, 0)
  end
end
function LotteryMainView:Ticket()
  if self.curSubView and self.curSubView.Ticket then
    self.curSubView:Ticket()
  end
end
function LotteryMainView:TicketTen()
  if self.curSubView and self.curSubView.TicketTen then
    self.curSubView:TicketTen()
  end
end
function LotteryMainView:ToRecover()
  self:ShowRecover(true)
  if self.isUpdateRecover then
    self:UpdateRecover()
    self.isUpdateRecover = false
  end
end
function LotteryMainView:Recover()
  local ticketName = self.ticketName
  local Ticket = GameConfig.Lottery.Ticket[self.lotteryType]
  local rItemId = Ticket.recoverItemId ~= nil and Ticket.recoverItemId or Ticket.itemid
  ticketName = Table_Item[rItemId].NameZh
  if self.canRecover then
    if self.lotteryType == LotteryType.Head then
      local isExist, ticketCount = LotteryProxy.Instance:GetSpecialHeadwearEquipCount(self.recoverSelectItemIDs)
      if isExist then
        MsgManager.DontAgainConfirmMsgByID(3556, function()
          self:CheckRecover()
          helplog("CallLotteryHeadwearExchange")
          ServiceItemProxy.Instance:CallLotteryHeadwearExchange(self:_GetRecoverList())
        end, nil, nil, LotteryProxy.Instance:GetHeadwearRecoverTotalPrice(self.recoverSelectItemIDs, self.lotteryType), ticketName, ticketCount, ticketName)
      else
        MsgManager.ConfirmMsgByID(3552, function()
          self:CheckRecover()
          helplog("CallLotteryHeadwearExchange")
          ServiceItemProxy.Instance:CallLotteryHeadwearExchange(self:_GetRecoverList())
        end, nil, nil, LotteryProxy.Instance:GetHeadwearRecoverTotalPrice(self.recoverSelectItemIDs, self.lotteryType), ticketName)
      end
    else
      local isExist, ticketCount = LotteryProxy.Instance:GetSpecialEquipCount(self.recoverSelectItemIDs, self.lotteryType)
      if isExist then
        MsgManager.DontAgainConfirmMsgByID(3556, function()
          self:CheckRecover()
          helplog("CallLotteryRecoveryCmd")
          ServiceItemProxy.Instance:CallLotteryRecoveryCmd(self:_GetRecoverList(), nil, self.lotteryType)
        end, nil, nil, LotteryProxy.Instance:GetRecoverTotalPrice(self.recoverSelectItemIDs, self.lotteryType), ticketName, ticketCount, ticketName)
      else
        MsgManager.ConfirmMsgByID(3552, function()
          self:CheckRecover()
          helplog("CallLotteryRecoveryCmd")
          ServiceItemProxy.Instance:CallLotteryRecoveryCmd(self:_GetRecoverList(), nil, self.lotteryType)
        end, nil, nil, LotteryProxy.Instance:GetRecoverTotalPrice(self.recoverSelectItemIDs, self.lotteryType), ticketName)
      end
    end
  end
end
function LotteryMainView:CheckRecover()
  local bagData = BagProxy.Instance.bagData
  if not bagData:IsFull() then
    self.isRecover = true
  end
end
function LotteryMainView:_GetRecoverList()
  TableUtility.ArrayClear(serverItems)
  local id, data
  for i = 1, #self.recoverSelectItemIDs do
    id = self.recoverSelectItemIDs[i]
    data = _LotteryProxy:GetRecoverData(self.lotteryType, id)
    if data ~= nil then
      local sitem = NetConfig.PBC and {} or SceneItem_pb.SItem()
      sitem.guid = id
      sitem.lotteryType = self.lotteryType
      sitem.id = data.itemData.staticData.id
      sitem.count = data.selectCount
      serverItems[#serverItems + 1] = sitem
    end
  end
  return serverItems
end
function LotteryMainView:CallLottery(price, year, month, times, free_count)
  FunctionSecurity.Me():OpenLottery(function()
    self:_CallLottery(price, year, month, times, free_count)
  end, arg)
end
function LotteryMainView:_CallLottery(price, year, month, times, free_count)
  local isfree = free_count and free_count > 0
  _LotteryProxy:CallLottery(self.lotteryType, year, month, nil, price, self.lotteryCostValue, self.skipValue, times, isfree)
end
function LotteryMainView:CallTicket(year, month, times)
  FunctionSecurity.Me():OpenLottery(function()
    self:_CallTicket(year, month, times)
  end, arg)
end
function LotteryMainView:_CallTicket(year, month, times)
  times = times or 1
  local Ticket = GameConfig.Lottery.Ticket[self.lotteryType]
  if Ticket then
    local cost, discount = self:GetDiscountByCoinType(_AEDiscountCoinTypeTicket, Ticket.count * times)
    if cost ~= self.ticketCostValue * times and not discount:IsInActivity() then
      MsgManager.ConfirmMsgByID(25314, function()
        self:UpdateTicketCost()
        self:UpdateDiscount()
        self:UpdateLimit()
      end)
      return
    end
    if cost > BagProxy.Instance:GetItemNumByStaticID(Ticket.itemid) then
      MsgManager.ShowMsgByID(3554, self.ticketName)
      return
    end
    ServiceItemProxy.Instance:CallLotteryCmd(year, month, nil, self.skipValue, nil, Ticket.itemid, self.lotteryType, times)
  end
end
function LotteryMainView:InitMoney()
  self:_InitMoneyLottery()
  self:_InitMoneyTicket()
  self:_InitMoneyReplace()
  self:_InitRecover()
  self.moneyGrid:Reposition()
end
function LotteryMainView:_InitMoneyLottery()
  self.moneyGrid = self:FindComponent("MoneyGrid", UIGrid)
  local moneyRoot = self:FindGO("MoneyRoot", self.moneyGrid.gameObject)
  local staticLottery = Table_Item[GameConfig.MoneyId.Lottery]
  if staticLottery then
    local moneyLotteryIcon = self:FindComponent("Money_LotteryIcon", UISprite, moneyRoot)
    local icon = staticLottery.Icon
    if icon then
      IconManager:SetItemIcon(icon, moneyLotteryIcon)
      IconManager:SetItemIcon(icon, self.lotteryBtn_Icon)
    end
  end
  self.money = self:FindComponent("Money", UILabel, moneyRoot)
  self.addMoneyBtn = self:FindGO("AddMoney", moneyRoot)
  self:UpdateLottery()
  self:UpdateCost()
end
function LotteryMainView:_InitMoneyTicket()
  local ticketRoot = self:FindGO("TicketRoot", self.moneyGrid.gameObject)
  self.ticket = self:FindComponent("Money", UILabel, ticketRoot)
  local Ticket = GameConfig.Lottery.Ticket[self.lotteryType]
  if Ticket then
    ticketRoot:SetActive(true)
    self.ticketBtn:SetActive(true)
    local moneyTicketIcon = self:FindComponent("Money_TicketIcon", UISprite, moneyRoot)
    local ticket = Table_Item[Ticket.itemid]
    if ticket then
      IconManager:SetItemIcon(ticket.Icon, moneyTicketIcon)
      IconManager:SetItemIcon(ticket.Icon, self.ticketBtn_Icon)
      self.ticketName = ticket.NameZh
    end
    self:UpdateTicket()
    self:UpdateTicketCost()
  else
    self.ticketBtn:SetActive(false)
    ticketRoot:SetActive(false)
  end
  self.btnGrid:Reposition()
end
function LotteryMainView:_InitMoneyReplace()
  local replaceRoot = self:FindGO("ReplaceRoot", self.moneyGrid.gameObject)
  if not LotteryProxy.IsMixLottery(self.lotteryType) then
    replaceRoot:SetActive(false)
    return
  end
  replaceRoot:SetActive(true)
  local mixLotteryStaticData = GameConfig.MixLottery
  self.replaceId = mixLotteryStaticData and mixLotteryStaticData.Replaceid
  if not self.replaceId then
    return
  end
  local replaceIcon = self:FindGO("Money_ReplaceIcon"):GetComponent(UISprite)
  self.replaceNum = self:FindComponent("Money", UILabel, replaceRoot)
  local item = Table_Item[self.replaceId]
  if item then
    IconManager:SetItemIcon(item.Icon, replaceIcon)
  end
end
function LotteryMainView:_InitRecover()
  local Ticket = GameConfig.Lottery.Ticket[self.lotteryType]
  if Ticket then
    local recoverTitle = self:FindGO("RecoverTitle"):GetComponent(UILabel)
    local rItemId = Ticket.itemid
    rItemId = Ticket.recoverItemId ~= nil and Ticket.recoverItemId or Ticket.itemid
    local ticket = Table_Item[rItemId]
    if ticket then
      IconManager:SetItemIcon(ticket.Icon, self.recoverIcon)
      recoverTitle.text = string.format(ZhString.Lottery_RecoverTitle, ticket.NameZh)
    end
  end
end
function LotteryMainView:ShowRecover(isShow)
  self.isShowRecover = isShow
  self.toRecoverBtn:SetActive(not isShow)
  if self.recoverRoot then
    self.recoverRoot:SetActive(isShow)
  end
  self:UpdatePreviewBtn(isShow)
  if self.curSubView then
    if isShow then
      self.curSubView:Hide()
    else
      self.curSubView:Show()
    end
  end
end
function LotteryMainView:UpdateLottery()
  if self.money ~= nil then
    self.money.text = StringUtil.NumThousandFormat(MyselfProxy.Instance:GetLottery())
  end
end
function LotteryMainView:UpdateTicket()
  local TicketConfig = GameConfig.Lottery.Ticket[self.lotteryType]
  if TicketConfig then
    self.ticket.text = StringUtil.NumThousandFormat(BagProxy.Instance:GetItemNumByStaticID(TicketConfig.itemid))
  end
end
function LotteryMainView:UpdateReplaceMoney()
  if self.replaceId and self.replaceNum then
    self.replaceNum.text = StringUtil.NumThousandFormat(BagProxy.Instance:GetItemNumByStaticID(self.replaceId))
  end
end
function LotteryMainView:ReUniteCellData(datas, perRowNum)
  local newData = {}
  if datas ~= nil and #datas > 0 then
    for i = 1, #datas do
      local i1 = math.floor((i - 1) / perRowNum) + 1
      local i2 = math.floor((i - 1) % perRowNum) + 1
      newData[i1] = newData[i1] or {}
      if datas[i] == nil then
        newData[i1][i2] = nil
      else
        newData[i1][i2] = datas[i]
      end
    end
  end
  return newData
end
function LotteryMainView:UpdateCost()
  if self.curSubView and self.curSubView.UpdateCost then
    self.curSubView:UpdateCost()
    return
  end
  local data = LotteryProxy.Instance:GetInfo(self.lotteryType)
  if data then
    self:UpdateCostValue(data.price, data.onceMaxCount)
  end
end
function LotteryMainView:UpdateCostValue(cost, onceMaxCount)
  self.lotteryCostValue = self:GetDiscountByCoinType(_AEDiscountCoinTypeCoin, cost)
  local hasFreeCnt = LotteryProxy.Instance:HasFreeCnt(self.lotteryType)
  if onceMaxCount == _Ten then
    self.tenToggle.gameObject:SetActive(not hasFreeCnt)
    if self:TenToggleEnabled() then
      self.lotteryCost.text = self.lotteryCostValue * _Ten
      self.isOneTime = false
    elseif hasFreeCnt then
      self.lotteryCost.text = _FreeCostStr
      self.isOneTime = true
    else
      self.lotteryCost.text = self.lotteryCostValue
      self.isOneTime = true
    end
  else
    self:Hide(self.tenToggle)
    self:Show(self.oneToggleSp)
    self:Hide(self.tenToggleSp)
    self.isOneTime = true
    self.lotteryCost.text = hasFreeCnt and _FreeCostStr or self.lotteryCostValue
  end
  self:UpdateOneTogglePos(onceMaxCount == _Ten and not hasFreeCnt)
end
function LotteryMainView:UpdateOneTogglePos(var)
  self.toggleGird:Reposition()
end
function LotteryMainView:UpdateTicketCost()
  if self.curSubView and self.curSubView.UpdateTicketCost then
    self.curSubView:UpdateTicketCost()
    return
  end
  local data = LotteryProxy.Instance:GetInfo(self.lotteryType)
  if data then
    self:UpdateTicketCostValue(data.onceMaxCount)
  end
end
function LotteryMainView:UpdateTicketCostValue(onceMaxCount)
  local Ticket = GameConfig.Lottery.Ticket[self.lotteryType]
  if Ticket then
    self.ticketCostValue = self:GetDiscountByCoinType(_AEDiscountCoinTypeTicket, Ticket.count)
    if onceMaxCount == _Ten and self:TenToggleEnabled() then
      self.ticketCost.text = self.ticketCostValue * _Eleven
      self.isOneTime = false
      return
    end
    self.ticketCost.text = self.ticketCostValue
    self.isOneTime = true
  end
end
function LotteryMainView:getSkip()
  return _LotteryProxy:IsSkipGetEffect(self.skipType)
end
function LotteryMainView:lotteryAnimationEnd()
  if self.isShowRecover and self:getSkip() == false then
    self:TryUpdateRecover(true)
  end
end
function LotteryMainView:TryUpdateRecover(animationEnd)
  if self.isRecover then
    self:UpdateRecover()
    self.isRecover = false
  elseif self:getSkip() == true or animationEnd or not _LotteryProxy.lotteryAction then
    self:UpdateRecover()
  end
end
function LotteryMainView:UpdateRecover()
  local recoverDataList = LotteryProxy.Instance:GetRecover(self.lotteryType)
  if recoverDataList then
    local newData = _ReUniteCellData(recoverDataList, 3)
    self.recoverHelper:UpdateInfo(newData)
    self.recoverHelper:ResetPosition()
    self.recoverEmpty:SetActive(#recoverDataList == 0)
    self.recoverTipDesc.gameObject:SetActive(#recoverDataList > 0)
  end
  TableUtility.ArrayClear(self.recoverSelectItemIDs)
  self:UpdateRecoverBtn()
  self:UpdateReadyRecover()
end
function LotteryMainView:UpdateRecoverBtn()
  local total = LotteryProxy.Instance:GetRecoverTotalCost(self.recoverSelectItemIDs, self.lotteryType)
  self.recoverTotalLabel.text = total
  self.canRecover = #self.recoverSelectItemIDs > 0
  if self.canRecover then
    self.recoverBtn.CurrentState = 0
    self.recoverLabel.effectColor = LuaGeometry.GetTempColor(0.7686274509803922, 0.5254901960784314, 0, 1)
  else
    self.recoverBtn.CurrentState = 1
    self.recoverLabel.effectColor = LuaGeometry.GetTempColor(0.39215686274509803, 0.40784313725490196, 0.4627450980392157, 1)
  end
end
function LotteryMainView:UpdateDiscount()
  if self.curSubView and self.curSubView.UpdateDiscount then
    self.curSubView:UpdateDiscount()
    return
  end
  local price, coinDiscount, ticketDiscount
  price, coinDiscount = self:GetDiscountByCoinType(_AEDiscountCoinTypeCoin)
  if coinDiscount ~= nil then
    local discountValue = coinDiscount:GetDiscount()
    local isShow = discountValue ~= 100
    self.lotteryDiscountLab.gameObject:SetActive(isShow)
    if isShow then
      self.lotteryDiscountLab.text = string.format(ZhString.Lottery_Discount, 100 - discountValue)
    end
  elseif self.lotteryDiscountLab ~= nil then
    self.lotteryDiscountLab.gameObject:SetActive(false)
  end
  if self.ticketDiscountLab then
    price, ticketDiscount = self:GetDiscountByCoinType(_AEDiscountCoinTypeTicket)
    if ticketDiscount ~= nil then
      local discountValue = ticketDiscount:GetDiscount()
      local isShow = discountValue ~= 100
      self.ticketDiscountLab.gameObject:SetActive(isShow)
      if isShow then
        self.ticketDiscountLab.text = string.format(ZhString.Lottery_Discount, 100 - discountValue)
      end
    else
      self.ticketDiscountLab.gameObject:SetActive(false)
    end
  end
end
function LotteryMainView:BaseUpdateLimit()
  local sb = LuaStringBuilder.CreateAsTable()
  local data = LotteryProxy.Instance:GetInfo(self.lotteryType)
  if data ~= nil then
    if data.maxCount ~= 0 then
      if self:TenToggleEnabled() then
        sb:Append(string.format(ZhString.Lottery_TodayTenLimit, data.todayTenCount, data.maxTenCount))
      else
        sb:Append(string.format(ZhString.Lottery_TodayLimit, data.todayCount, data.maxCount))
      end
    end
    if self.lotteryType == LotteryType.Card or self.lotteryType == LotteryType.NewCard or self.lotteryType == LotteryType.NewCard_Activity then
      local funcStateCFG = Table_FuncState[9]
      local serverTime = ServerTime.CurServerTime() / 1000
      local validtime = Table_FuncTime[funcStateCFG.TimeID]
      if not self:CheckServerID(funcStateCFG.ServerID) or serverTime < validtime.StartTimeStamp or serverTime > validtime.EndTimeStamp then
        if 0 < #sb.content then
          sb:Append("  ")
        end
        sb:Append(string.format(ZhString.Lottery_CardLimit, data.todayExtraCount, data.maxExtraCount))
      end
    end
  end
  local price, coinDiscount, ticketDiscount
  price, coinDiscount = self:GetDiscountByCoinType(_AEDiscountCoinTypeCoin)
  if coinDiscount ~= nil then
    local isShow = coinDiscount:IsInActivity() and coinDiscount.count ~= 0
    if isShow then
      if 0 < #sb.content then
        sb:Append("  ")
      end
      sb:Append(string.format(ZhString.Lottery_DiscountLimit, coinDiscount.usedCount, coinDiscount.count))
    end
  end
  if self.ticketLimitLab then
    price, ticketDiscount = self:GetDiscountByCoinType(_AEDiscountCoinTypeTicket)
    local hidelimit = GameConfig.Lottery.ShowTicketLimit == false
    if ticketDiscount ~= nil and not hidelimit then
      local isShow = ticketDiscount:IsInActivity() and ticketDiscount.count ~= 0
      self.ticketLimitLab.gameObject:SetActive(isShow)
      if isShow then
        self.ticketLimitLab.text = string.format(ZhString.Lottery_DiscountLimit, ticketDiscount.usedCount, ticketDiscount.count)
      end
    else
      self.ticketLimitLab.gameObject:SetActive(false)
    end
  end
  local isShow = 0 < #sb.content
  if self.lotteryLimit and self.lotteryLimitBg then
    self.lotteryLimit.gameObject:SetActive(isShow)
    if isShow then
      self:SetLotteryLimitLab(sb:ToString())
      self.lotteryLimitBg.width = self.lotteryLimit.localSize.x + 70
    end
  end
  sb:Destroy()
end
function LotteryMainView:UpdateLimit()
  if self.curSubView and self.curSubView.UpdateLimit then
    self.curSubView:UpdateLimit()
    return
  end
  self:BaseUpdateLimit()
end
function LotteryMainView:SetLotteryLimitLab(var)
  if BranchMgr.IsChina() then
    self:Show(self.lotteryLimit)
    self.lotteryLimit.text = var
  else
    self:Hide(self.lotteryLimit)
  end
end
function LotteryMainView:GetDiscountByCoinType(cointype, price)
  if self.curSubView and self.curSubView.GetDiscountByCoinType then
    return self.curSubView:GetDiscountByCoinType(cointype, price)
  end
  return LotteryProxy.Instance:GetDiscountByCoinType(self.lotteryType, cointype, price)
end
function LotteryMainView:ClickPlusRecover(cell)
  local data = cell.data
  if data then
    self:_SelectCount(cell, 1)
  end
end
function LotteryMainView:ClickMinusRecover(cell)
  local data = cell.data
  if data then
    self:_SelectCount(cell, -1)
  end
end
function LotteryMainView:_SelectCount(cell, offset)
  local data = cell.data
  local originalCount = data.selectCount
  cell:SelectCount(offset)
  if offset == -1 then
    local cellCtls = self.recoverHelper:GetCellCtls()
    for i = 1, #cellCtls do
      local cells = cellCtls[i]:GetCells()
      for k = 1, #cells do
        if cells[k].data and cells[k].data.itemData.id == data.itemData.id then
          cells[k]:UpdateInfo()
          break
        end
      end
    end
  end
  if originalCount == 0 and data.selectCount > 0 then
    TableUtility.ArrayPushBack(self.recoverSelectItemIDs, data.itemData.id)
  elseif originalCount > 0 and data.selectCount == 0 then
    TableUtility.ArrayRemove(self.recoverSelectItemIDs, data.itemData.id)
  end
  self:UpdateReadyRecover()
  self:UpdateRecoverBtn()
end
function LotteryMainView:UpdateReadyRecover()
  self.readyRecoverHelper:ResetDatas(self:_GetRecoverList())
  local scrollView = self.readyRecoverHelper.scrollView
  scrollView:InvalidateBounds()
  scrollView:RestrictWithinBounds(true)
end
function LotteryMainView:HandleEffectStart()
  UIManagerProxy.Instance:NeedEnableAndroidKey(false)
  self:PlaySuccessUIEffect()
  self:SetActionBtnsActive(false)
  if self.npcLoadSuccess then
    self:Hide(self.npcTexRoot)
    self:Show(self.lotteryTexture)
  end
  self:sendNotification(SystemMsgEvent.NoticeMsgHide, false)
end
function LotteryMainView:HandleEffectEnd()
  UIManagerProxy.Instance:NeedEnableAndroidKey(true, UIManagerProxy.GetDefaultNeedEnableAndroidKeyCallback())
  self:SetActionBtnsActive(true)
  if self.npcLoadSuccess then
    self:Show(self.npcTexRoot)
    self:Hide(self.lotteryTexture)
  end
  self:sendNotification(SystemMsgEvent.NoticeMsgHide, true)
end
function LotteryMainView:HandleRefreshCost()
  self:UpdateCost()
  self:UpdateDiscount()
  self:UpdateLimit()
end
function LotteryMainView:HandleActivityEventNtf(note)
  local data = note.body
  if data then
    self:UpdateDiscount()
    self:UpdateLimit()
    self:UpdateCost()
    self:UpdateTicketCost()
  end
end
function LotteryMainView:HandleActivityEventNtfEventCnt(note)
  local data = note.body
  if data then
    self:UpdateDiscount()
    self:UpdateLimit()
    self:UpdateCost()
    self:UpdateTicketCost()
  end
end
function LotteryMainView:SetActionBtnsActive(isActive)
  self.btnGrid.gameObject:SetActive(isActive)
  self.skipBtn.gameObject:SetActive(isActive)
  self.toggleGird.gameObject:SetActive(isActive)
  self.colliderMaskObj:SetActive(not isActive)
end
function LotteryMainView:CheckServerID(ServerIDs)
  if not ServerIDs or #ServerIDs == 0 then
    return false
  end
  local server = FunctionLogin.Me():getCurServerData()
  local linegroup = 0
  linegroup = server and (server.linegroup or 1)
  if ServerIDs then
    for n, m in pairs(ServerIDs) do
      if m == linegroup then
        return true
      end
    end
  end
  return false
end
function LotteryMainView:QueryLotteryExtraBonus()
  ServiceItemProxy.Instance:CallQueryLotteryExtraBonusCfgCmd(self.lotteryType)
  ServiceItemProxy.Instance:CallQueryLotteryExtraBonusItemCmd(self.lotteryType)
end
function LotteryMainView:OnRecvExtraBonusItemCmd()
  if self.extraBonusShown then
    self:UpdateExtraBonus()
  else
    self:DeActiveExtraBonus()
  end
end
function LotteryMainView:OnRecvExtraBonusCfgCmd()
  if self.extraBonusShown then
    self:UpdateExtraBonus()
  else
    self:ShowExtraBonus()
    self.extraBonusShown = true
  end
end
local extraBonusProgressGridMap = {
  [3] = {
    cellHeight = 181,
    sliderHeight = 418,
    progressNode = {
      0.164,
      0.583,
      1
    }
  },
  [4] = {
    cellHeight = 123,
    sliderHeight = 418,
    progressNode = {
      0.138,
      0.423,
      0.71,
      1
    }
  },
  [5] = {
    cellHeight = 90,
    sliderHeight = 418,
    progressNode = {
      0.136,
      0.349,
      0.569,
      0.783,
      1
    }
  },
  [6] = {
    cellHeight = 90,
    sliderHeight = 510,
    progressNode = {
      0.136,
      0.2,
      0.349,
      0.569,
      0.783,
      1
    }
  }
}
function LotteryMainView:GetExtraBonusProgressGridCfg(index)
  return extraBonusProgressGridMap[index]
end
function LotteryMainView:ShowExtraBonus()
  local extraDatas = LotteryProxy.Instance:GetExtraBonusList(self.lotteryType)
  if not extraDatas or not next(extraDatas) then
    return
  end
  local gridconfig = self:GetExtraBonusProgressGridCfg(#extraDatas)
  if not gridconfig then
    redlog("未配置额外奖励 extraBonusProgressGridMap")
    return
  end
  if self.progressGrid then
    self.progressGrid.cellHeight = gridconfig.cellHeight or 0
  end
  if self.progressSliderSp then
    self.progressSliderSp.height = gridconfig.sliderHeight
  end
  if self.progressBackground then
    self.progressBackground.height = gridconfig.sliderHeight
  end
  self.stepMap = self.stepMap or {}
  TableUtility.TableClear(self.stepMap)
  local keylist = LotteryProxy.Instance:GetKeyList(self.lotteryType)
  local max = LotteryProxy.Instance:GetMaxExtraCount(self.lotteryType)
  for i = 1, #keylist do
    if not gridconfig.progressNode then
      self.stepMap[keylist[i]] = 1 / max
    else
      self.stepMap[keylist[i]] = (gridconfig.progressNode[i] - (gridconfig.progressNode[i - 1] or 0)) / (keylist[i] - (keylist[i - 1] or 0))
    end
  end
  self:UpdateExtraBonus()
end
function LotteryMainView:UpdateExtraBonus()
  if not self.extraBonusRoot then
    return
  end
  local current = LotteryProxy.Instance:GetCurrentExtraCount(self.lotteryType)
  if not current then
    return
  end
  if self.progressSlider then
    local keylist = LotteryProxy.Instance:GetKeyList(self.lotteryType)
    local currentAmount = 0
    for i = 1, #keylist do
      if current >= keylist[i] then
        currentAmount = currentAmount + self.stepMap[keylist[i]] * (keylist[i] - (keylist[i - 1] or 0))
      else
        local temp = current - (keylist[i - 1] or 0)
        if temp < 0 then
          temp = 0
        end
        currentAmount = currentAmount + (self.stepMap[keylist[i]] or 0) * temp
      end
    end
    self.progressSlider.value = currentAmount
  end
  local extraDatas = LotteryProxy.Instance:GetExtraBonusList(self.lotteryType)
  if extraDatas and self.progressCtrl then
    self.progressCtrl:ResetDatas(extraDatas)
    local cells = self.progressCtrl:GetCells()
    for i = 1, #cells do
      cells[i]:UpdateStatus(current)
    end
    self.extraBonusRoot:SetActive(true)
  else
    self.extraBonusRoot:SetActive(false)
  end
  if self.rewardTip then
    self.rewardTip:SetActive(false)
  end
  if self.rewardDetailBoard then
    self.rewardDetailBoard:SetActive(false)
  end
end
function LotteryMainView:DeActiveExtraBonus()
  if self.extraBonusRoot then
    self:Hide(self.extraBonusRoot)
  end
  if self.rewardTip then
    self:Hide(self.rewardTip)
  end
  if self.rewardDetailBoard then
    self:Hide(self.rewardDetailBoard)
  end
end
function LotteryMainView:OnClickExtraBonus(cell)
  if not cell or not cell.data then
    return
  end
  local ins = LotteryProxy.Instance
  local list = cell.data.itemids
  if not list or #list < 1 then
    return
  end
  if #list == 1 then
    local stage = ins:GetCurrentExtraStageByType(self.lotteryType)
    if stage and stage <= ins:GetCurrentExtraCount(self.lotteryType) then
      ServiceItemProxy.Instance:CallGetLotteryExtraBonusItemCmd(self.lotteryType, stage, nil, 1)
    else
      self:ShowRewardItemTip(cell.itemid, cell.itemIcon)
    end
  else
    self:ShowExtraRewardTip(cell.key, list)
  end
end
function LotteryMainView:OnClickRewardTipCell(cell)
  if not cell or not cell.data then
    return
  end
  self.rewardDetailRewardIndex = cell.data.rewardIndex or 0
  if self.rewardDetailRewardIndex < 1 then
    return
  end
  self.rewardDetailBoard:SetActive(true)
  self.rewardDetailItemDatas = self.rewardDetailItemDatas or {}
  self.rewardDetailItemDatas[1] = cell.data
  self.rewardDetailItemCtrl:ResetDatas(self.rewardDetailItemDatas)
  local ins = LotteryProxy.Instance
  local stage = ins:GetCurrentExtraStageByType(self.lotteryType)
  local canGet = stage and stage <= ins:GetCurrentExtraCount(self.lotteryType)
  local isReceived = ins:CheckReceive(self.lotteryType, self.rewardTipKey)
  local isShow = canGet and not isReceived
  self.rewardDetailConfirmBtn:SetActive(isShow)
  self.rewardDetailFakeConfirmBtn:SetActive(not isShow)
  self.rewardDetailFakeConfirmLabel.text = isReceived and ZhString.Tutor_TaskTake or ZhString.Tutor_ReceiveReward
end
function LotteryMainView:OnLongPressRewardDetailItem(param)
  local isPressing, cell = param[1], param[2]
  self:ShowRewardItemTip(cell.data.staticData.id, cell.icon)
end
function LotteryMainView:ShowExtraRewardTip(key, datas)
  if not datas or #datas <= 1 then
    return
  end
  self.rewardTip:SetActive(true)
  self.rewardTipKey = key
  self.rewardTipItemDatas = self.rewardTipItemDatas or {}
  local rData
  for i = 1, #datas do
    rData = datas[i]
    if rData then
      self.rewardTipItemDatas[i] = self.rewardTipItemDatas[i] or ItemData.new()
      self.rewardTipItemDatas[i]:ResetData(MaterialItemCell.MaterialType.Material, rData.itemid)
      self.rewardTipItemDatas[i].num = rData.count
      self.rewardTipItemDatas[i].rewardIndex = i
    end
  end
  for i = #datas + 1, #self.rewardTipItemDatas do
    self.rewardTipItemDatas[i] = nil
  end
  self.rewardTipLabel.text = string.format(ZhString.Lottery_ExtraRewardTipFormat, ZhString.ChinaNumber[#datas])
  self.rewardTipItemCtrl:ResetDatas(self.rewardTipItemDatas)
end
local rewardTipData, rewardTipOffset = {
  funcConfig = _EmptyTable,
  noSelfClose = false
}, {210, -220}
function LotteryMainView:ShowRewardItemTip(itemId, stick)
  if not rewardTipData.itemdata then
    rewardTipData.itemdata = ItemData.new()
  end
  rewardTipData.itemdata:ResetData("Reward", itemId)
  self:ShowItemTip(rewardTipData, stick, NGUIUtil.AnchorSide.Right, rewardTipOffset)
end
