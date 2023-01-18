ProfessionNewPage = class("ProfessionNewPage", SubView)
ProfessionNewPage.ViewType = UIViewType.NormalLayer
local viewPath = ResourcePathHelper.UIView("ProfessionNewPage")
local picIns = PictureManager.Instance
local _ProfessionProxy = ProfessionProxy.Instance
local _ArrayPushBack = TableUtility.ArrayPushBack
local _GetTempVector3 = LuaGeometry.GetTempVector3
local _ProfessionProxy, _PictureManager
local _GetPosition = LuaGameObject.GetPosition
local _GetRotation = LuaGameObject.GetRotation
local _GetTempQuaternion = LuaGeometry.GetTempQuaternion
local _ObjectIsNull = LuaGameObject.ObjectIsNull
local _SetPositionGO = LuaGameObject.SetPositionGO
local _LuaDestroyObject = LuaGameObject.DestroyObject
local _MyGender, _MyRace
local _tmpPos = LuaVector3.Zero()
local _tweenDuration = 0.3
local classType = {Common = 1, Hero = 2}
if not GameConfig.Profession.hero_ticket_shop then
  local hero_ticket_shop = {
    812,
    1,
    56596
  }
end
local _SubClassColor = {
  Choose = LuaColor.New(0.2196078431372549, 0.38823529411764707, 0.5294117647058824, 1),
  UnChoose = LuaColor.New(0.8862745098039215, 0.9882352941176471, 1.0, 1),
  NotGain = LuaColor.New(0.48627450980392156, 0.5294117647058824, 0.6, 1)
}
local focusColor = {
  UnChoose = LuaColor.New(0.615686274509804, 0.6705882352941176, 0.8156862745098039, 1),
  Choose = LuaColor.New(0.9294117647058824, 0.9725490196078431, 1, 1)
}
autoImport("ProfessionAttrCell")
function ProfessionNewPage:LoadSubView()
  local obj = self:LoadPreferb_ByFullPath(viewPath, self.container.professionPageContainer, true)
  obj.name = "ProfessionNewPage"
end
function ProfessionNewPage:Init()
  _ProfessionProxy = ProfessionProxy.Instance
  _PictureManager = PictureManager.Instance
  _MyGender = MyselfProxy.Instance:GetMySex()
  _MyRace = MyselfProxy.Instance:GetMyRace()
  self:FindObjs()
  self:AddEvts()
  self:AddMapEvts()
end
function ProfessionNewPage:FindObjs()
  self:LoadSubView()
  self.gameObject = self:FindGO("ProfessionNewPage")
  self.anchor_left = self:FindGO("Anchor_Left")
  self.listScrollView = self:FindGO("ListScrollView", self.anchor_left):GetComponent(UIScrollView)
  local listContainer = self:FindGO("ListContainer", self.anchor_left)
  self.listCtrl = WrapInfiniteListCtrl.new(listContainer, ProfessionChooseCell, "ProfessionChooseCell", nil, nil, nil, 2)
  self.listCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickListCell, self)
  self.listCtrl:AddStoppedMovingCall(self.OnListCtrlStoppedMoving, self)
  self.listCells = self.listCtrl:GetCells()
  self.subClassSelectRoot = self:FindGO("SubClassSelectCtrl", self.anchor_left)
  self.subClassSelectBtns, self.subClassSps, self.subClassChooses, self.subClassStarSps = {}, {}, {}, {}
  for i = 1, 2 do
    self.subClassSelectBtns[i] = self:FindGO("SubClassSelectBtn" .. i, self.subClassSelectRoot)
    self.subClassSps[i] = self:FindComponent("SubClass" .. i, GradientUISprite, self.subClassSelectBtns[i])
    self.subClassChooses[i] = self:FindGO("SubClassChoose" .. i, self.subClassSelectBtns[i]):GetComponent(UIMultiSprite)
    self.subClassStarSps[i] = self:FindGO("SubClassStarSp" .. i, self.subClassSelectBtns[i])
    self:AddClickEvent(self.subClassSelectBtns[i], function()
      self:OnClickSubClassSelectBtn(i)
    end)
    break
  end
  self.classFocusRoot = self:FindGO("ClassFocus")
  self.classFocuses = {}
  for i = 1, 3 do
    self.classFocuses[i] = {
      sprite = self:FindGO("Focus" .. i):GetComponent(UISprite),
      mark = self:FindGO("Mark" .. i)
    }
  end
  self.jobTypeSwitch = self:FindGO("JobTypeSwitch")
  self.jobTypeLabel = self:FindGO("Label", self.jobTypeSwitch):GetComponent(UILabel)
  self.funcsPart = self:FindGO("Funcs")
  self.goToBtn = self:FindGO("GotoBtn")
  self.goToBtn_Label = self:FindGO("Label", self.goToBtn):GetComponent(UILabel)
  self.zeny_Icon = self:FindGO("ZenyIcon", self.goToBtn):GetComponent(UISprite)
  IconManager:SetItemIcon(Table_Item[100].Icon, self.zeny_Icon)
  self.conditionLabel = self:FindGO("ConditionLabel"):GetComponent(UILabel)
  self.preCondition = self:FindGO("PreCondition"):GetComponent(UILabel)
  self.purchaseBtn = self:FindGO("PurchaseBtn")
  self.purchaseBtn_Label = self:FindGO("PurchaseLabel", self.purchaseBtn):GetComponent(UILabel)
  self.purchaseBtn_BoxCollider = self.purchaseBtn:GetComponent(BoxCollider)
  self.questBtn = self:FindGO("QuestBtn")
  self.questBtn_Label = self:FindGO("Label", self.questBtn):GetComponent(UILabel)
  self.tryBtn = self:FindGO("TryBtn")
  if Game.Myself:IsDead() or self:CheckAmIInTransformState() then
    self:SetTextureGrey(self.goToBtn)
    self:SetTextureGrey(self.questBtn)
    self:SetTextureGrey(self.tryBtn)
  end
  self.priceGO = self:FindGO("Price", self.purchaseBtn)
  self.priceBG = self.priceGO:GetComponent(UISprite)
  self.price_Label = self:FindGO("PriceLabel", self.priceGO):GetComponent(UILabel)
  self.price_Icon = self:FindGO("PriceIcon", self.priceGO):GetComponent(UISprite)
  self.anchor_LeftBottom = self:FindGO("Anchor_LeftBottom", self.gameObject)
  self.jobBtn = self:FindGO("JobBtn", self.anchor_LeftBottom)
  self.jobSlider_Tween = self:FindGO("JobChooseSlider"):GetComponent(TweenPosition)
  function self.listScrollView.onDragStarted()
    self.switchByClick = false
  end
  self.share = self:FindGO("ShareBtn")
  self:AddClickEvent(self.share, function()
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.AllProfessionShareView,
      viewdata = {}
    })
  end)
  local rewardTips = self:FindGO("WeekRewardTips")
  local FirstRewardIcon = self:FindGO("FirstRewardIcon", rewardTips):GetComponent(UISprite)
  local data = ItemData.new("FirstRewardIcon", GameConfig.Share.ShareReward[1])
  IconManager:SetItemIcon(data.staticData.Icon, FirstRewardIcon)
  FirstRewardIcon:MakePixelPerfect()
  FirstRewardIcon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(0.4, 0.4, 0.4)
  local FirstRewardCountLbl = self:FindGO("FirstRewardCountLbl", rewardTips):GetComponent(UILabel)
  FirstRewardCountLbl.text = "x" .. GameConfig.Share.ShareReward[2]
  local weekReward = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_SHARE_WEEK_REWARD) or 0
  if weekReward == 1 then
    rewardTips:SetActive(false)
  else
    rewardTips:SetActive(true)
  end
end
function ProfessionNewPage:AddEvts()
  self:AddClickEvent(self.goToBtn, function()
    if Game.Myself:IsDead() then
      MsgManager.ShowMsgByID(2500)
      return
    end
    if self:CheckAmIInTransformState() then
      MsgManager.ShowMsgByID(27009)
      return
    end
    if not ProfessionProxy.CanChangeProfession(25437) then
      return
    end
    if MyselfProxy.Instance:GetROB() < GameConfig.Profession.switch_zeny then
      MsgManager.ShowMsgByID(25400, Table_Item[100].NameZh)
      return
    end
    local id = self.curChooseClassID
    local classConfig = Table_Class[id]
    local branch = self.curChooseTypeBranch
    if ProfessionProxy.Instance:Isjust1stJob(id) then
      if ProfessionProxy.IsDoramRace(id) then
        id = ProfessionProxy.doramNovice
      else
        id = ProfessionProxy.humanNovice
      end
    end
    if ProfessionProxy.NoviceC2S[id] then
      branch = ProfessionProxy.NoviceC2S[id]
    end
    xdlog("申请转职", id, branch)
    self:ResetAstrolabeConfirm(branch)
  end)
  self:AddClickEvent(self.purchaseBtn.gameObject, function()
    FunctionSecurity.Me():NormalOperation(function()
      local targetPurchaseID = self.curAdvanceJobID or self.curChooseClassID
      if not targetPurchaseID then
        redlog("没有选择购买职业")
        return
      end
      local collaborHero = GameConfig.Profession.collabor_hero
      local isCollabor = collaborHero and TableUtility.ArrayFindIndex(collaborHero, targetPurchaseID) > 0 or false
      local purchaseFunc = function()
        local shopData = ShopProxy.Instance:GetShopDataByTypeId(hero_ticket_shop[1], hero_ticket_shop[2])
        local shopItemData
        if shopData then
          local goods = shopData:GetGoods()
          for k, good in pairs(goods) do
            if good.id == hero_ticket_shop[3] then
              shopItemData = good
              break
            end
          end
        end
        if shopItemData then
          self.container:ShowShopPurchaseCell(shopItemData)
          HappyShopProxy.Instance:SetSelectId(shopItemData.id)
        end
      end
      local collaborFunc = function()
        MsgManager.ShowMsgByID(43288)
      end
      ProfessionProxy.Instance:PurchaseFunc(targetPurchaseID, isCollabor and collaborFunc or purchaseFunc)
    end)
  end)
  self:AddClickEvent(self.jobTypeSwitch, function()
    if self.classShowType == classType.Common then
      self.classShowType = classType.Hero
    else
      self.classShowType = classType.Common
    end
    self.curChooseClassID = nil
    self:RefreshJobType()
    self:InitProfessionList()
  end)
  self:AddClickEvent(self.jobBtn, function()
    if ProfessionProxy.Instance:IsMPOpen() then
      self:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.CheckAllProfessionPanel,
        viewdata = nil
      })
    else
      MsgManager.ShowMsgByID(25413)
    end
  end)
  self:AddClickEvent(self.tryBtn, function()
    if Game.Myself:IsDead() then
      MsgManager.ShowMsgByID(2500)
      return
    end
    if self:CheckAmIInTransformState() then
      MsgManager.ShowMsgByID(27009)
      return
    end
    local id = self.curChooseClassID
    if not id then
      return
    end
    if Game.MapManager:IsPVEMode_DemoRaid() then
      ServiceMessCCmdProxy.Instance:CallChooseNewProfessionMessCCmd(nil, id)
    else
      ProfessionProxy.Instance:SaveChooseClassID(id)
      ServiceNUserProxy.Instance:CallGoToFunctionMapUserCmd(SceneUser2_pb.EFUNCMAPTYPE_HEROPRO)
    end
    self.container:CloseSelf()
  end)
end
function ProfessionNewPage:ResetAstrolabeConfirm(branch)
  local saveInfoData = BranchInfoSaveProxy.Instance:GetUsersaveData(branch)
  local costTarget, targetContribute, targetGoldMedal
  if saveInfoData then
    costTarget = AstrolabeProxy.Instance:GetStorageActivePointsCost_BySaveInfo(saveInfoData)
    targetContribute, targetGoldMedal = costTarget[AstrolabeProxy.ContributeItemId], costTarget[AstrolabeProxy.GoldMedalItemId]
  end
  local confirmHandler = function()
    ServiceNUserProxy.Instance:CallProfessionChangeUserCmd(branch, true)
  end
  if costTarget then
    AstrolabeProxy.ConfirmAstrolMaterialOnChange(targetContribute, targetGoldMedal, confirmHandler)
  else
    confirmHandler()
  end
end
function ProfessionNewPage:RefreshJobChooseSlider(fadeIn)
  self.jobSlider_Tween.duration = 0.3
  if fadeIn then
    self.jobSlider_Tween:PlayReverse()
  else
    self.jobSlider_Tween:PlayForward()
  end
end
function ProfessionNewPage:CheckAmIInTransformState()
  local myselfData = Game.Myself.data
  if myselfData:GetBuffListByType("Transform") ~= nil or myselfData:GetBuffListByType("PartTransform") ~= nil then
    return true
  end
  if myselfData:IsTransformed() then
    return true
  end
  if myselfData:IsInMagicMachine() then
    return true
  end
  if myselfData:IsOnWolf() then
    return true
  end
  return false
end
function ProfessionNewPage:PlayPageNodeTween(obj)
  if not obj then
    return
  end
  local targetPos = obj.transform.localPosition
  LuaVector3.Better_SetPos(_tmpPos, targetPos)
  self.switchNode_TweenPos.to = _tmpPos
  local curPos = self.switchNode.transform.localPosition
  LuaVector3.Better_SetPos(_tmpPos, curPos)
  self.switchNode_TweenPos.from = _tmpPos
  self.switchNode_TweenPos:ResetToBeginning()
  self.switchNode_TweenPos:PlayForward()
end
function ProfessionNewPage:ResetClassIconTween()
  for i = 1, 2 do
    self.advancedJob[i].checkMark:SetActive(false)
  end
end
function ProfessionNewPage:PlayAdvancedClassTween(index)
  self.curClassCheckMark:SetActive(false)
  for i = 1, 2 do
    if i == index then
      self.advancedJob[i].checkMark:SetActive(true)
    else
      self.advancedJob[i].checkMark:SetActive(false)
    end
  end
end
function ProfessionNewPage:AddMapEvts()
  self:AddListenEvt(ServiceEvent.NUserProfessionQueryUserCmd, self.RecvProfessionQueryUserCmd)
  self:AddListenEvt(ServiceEvent.NUserProfessionBuyUserCmd, self.RecvProfessionBuyUserCmd)
  self:AddListenEvt(ServiceEvent.SceneUser3HeroBuyUserCmd, self.RecvProfessionBuyUserCmd)
  self:AddListenEvt(ServiceEvent.NUserProfessionChangeUserCmd, self.RecvProfessionChangeUserCmd)
  self:AddListenEvt(MultiProfessionEvent.ChooseProfession, self.HandleSwitchProfession)
  self:AddDispatcherEvt(MultiProfessionEvent.ClickCurClass, self.HandleClickCurJobPage)
  self:AddDispatcherEvt(MultiProfessionEvent.ClickAdvanceClass, self.HandleClickAdvanceClass)
end
function ProfessionNewPage:InitDatas()
  self.listSelectionIndexOnEnter = 1
  self.curListCell = nil
  self.professionInfoList = _ProfessionProxy:GetValidJobList()
  self.professionShowList = {}
  for k, v in pairs(self.professionInfoList) do
    local firstBranch = v.branchList and v.branchList[1]
    if firstBranch then
      local config = Table_Class[firstBranch.id]
      if config and config.FeatureSkill then
        if not self.professionShowList[classType.Hero] then
          self.professionShowList[classType.Hero] = {}
        end
        table.insert(self.professionShowList[classType.Hero], v)
      else
        if not self.professionShowList[classType.Common] then
          self.professionShowList[classType.Common] = {}
        end
        table.insert(self.professionShowList[classType.Common], v)
      end
    end
  end
  local curClassID = MyselfProxy.Instance:GetMyProfession()
  local savedBranchID = SaveInfoProxy.Instance:GetSavedLastBranchID()
  if savedBranchID and savedBranchID >= 0 then
    self.curTypeBranch = savedBranchID
    self.curType = math.modf(savedBranchID / 10)
  else
    self.curTypeBranch = ProfessionProxy.ProcessNoviceBranchValueS2C(MyselfProxy.Instance:GetMyProfessionTypeBranch())
    self.curType = math.modf(self.curTypeBranch / 10)
  end
  local sData = ProfessionProxy.Instance:GetProfessionQueryUserTable()
  if sData and sData[self.curTypeBranch] then
    self.curChooseClassID = sData[self.curTypeBranch].profession
  else
    local branchInfo = Table_Branch[self.curTypeBranch]
    self.curChooseClassID = branchInfo and branchInfo.base_id or curClassID
  end
  self.classShowType = ProfessionProxy.IsHero(self.curChooseClassID) and 2 or 1
  if self.viewdata.viewdata and self.viewdata.viewdata.classType then
    self.classShowType = self.viewdata.viewdata.classType
    self.viewdata.viewdata = nil
  end
  self.subBranchList = {}
  self.jobSwitchValid = self.professionShowList[classType.Hero] and #self.professionShowList[classType.Hero] > 0 or false
  self.jobTypeSwitch:SetActive(self.jobSwitchValid)
end
function ProfessionNewPage:InitShow()
  self:RefreshJobType()
  self:InitProfessionList()
end
function ProfessionNewPage:InitProfessionList()
  if self.curChooseClassID then
    local targetClassList = self.professionShowList[self.classShowType]
    for i = 1, #targetClassList do
      if targetClassList[i].Type == self.curType then
        self.listSelectionIndexOnEnter = i
      end
      if self.listSelectionIndexOnEnter == 0 then
        self.listSelectionIndexOnEnter = 1
      end
    end
  end
  local result = self.professionShowList[self.classShowType or 1]
  self.listCtrl:ResetDatas(result)
  self.listCtrl:SetStartPositionByIndex(self.listSelectionIndexOnEnter)
  self.classFocusRoot:SetActive(#result >= 6)
  self.focusGap = math.ceil(#result / 3)
  if self.curChooseClassID then
    for i = 1, #self.listCells do
      if self.listCells[i].type and self.listCells[i].type == self.curType then
        self:OnClickListCell(self.listCells[i])
        break
      end
    end
  else
    self:OnClickListCell(self.listCells[1])
  end
end
function ProfessionNewPage:RefreshJobType()
  if self.classShowType == 1 then
    self.jobTypeLabel.text = ZhString.ProfessionPage_Common
  else
    self.jobTypeLabel.text = ZhString.ProfessionPage_Hero
  end
end
function ProfessionNewPage:RefreshPage()
  if not self.dataInited then
    return
  end
  self:InitDatas()
  self:InitShow()
end
function ProfessionNewPage:RecvProfessionQueryUserCmd(data)
  self.dataInited = true
  self:InitDatas()
  if self.container.professionPageContainer.activeSelf then
    self:InitShow()
  end
  self.jobBtn:SetActive(true)
end
function ProfessionNewPage:RecvProfessionBuyUserCmd(data)
  if data ~= nil and data.body ~= nil and data.body.branch ~= nil and data.body.success ~= nil and data.body.success then
    local b = data.body.branch
    local boughtId = ProfessionProxy.GetBoughtProfessionIdThroughBranch(b)
    local realGetId = Table_Branch[b] and Table_Branch[b].base_id or 0
    b = ProfessionProxy.TypeBranchS2C(b)
    local SysmsgData = Table_Sysmsg[25412]
    local NameZh = ProfessionProxy.GetProfessionName(boughtId, MyselfProxy.Instance:GetMySex())
    MsgManager.FloatMsg(nil, string.format(SysmsgData.Text, NameZh))
    local S_ProfessionDatas = ProfessionProxy.Instance:GetProfessionQueryUserTable()
    S_ProfessionDatas[b] = {}
    S_ProfessionDatas[b].branch = b
    S_ProfessionDatas[b].profession = realGetId
    S_ProfessionDatas[b].joblv = 0
    S_ProfessionDatas[b].isbuy = true
    S_ProfessionDatas[b].iscurrent = false
    self:InitDatas()
    self:InitShow()
  end
end
function ProfessionNewPage:RecvProfessionChangeUserCmd(data)
  if data ~= nil and data.body ~= nil and data.body.branch ~= nil and data.body.success ~= nil and data.body.success then
    xdlog("切换职业成功，关闭")
    self.container:CloseSelf()
  end
end
function ProfessionNewPage:HandleClickAdvanceClass(note)
  local classid = note.data
  xdlog("点击进阶职业", classid)
  self:UpdateAdvClassPage(classid, true)
end
function ProfessionNewPage:UpdateAdvClassPage(classid, doTween)
  self.curAdvanceJobID = classid
  self.container:UpdateProps(classid)
  self.container:RefreshNodes(classid)
  FunctionMultiProfession.Me():UpdateRoleModelByClassID(classid)
  self.container:ShowSwitchEffect()
  self:ShowPreCondition(classid)
  self:UpdateStateFuncs(classid)
  if doTween then
    self.jobBtn:SetActive(false)
    if self.jobSwitchValid then
      self.jobTypeSwitch:SetActive(false)
    end
    self:RefreshJobChooseSlider(false)
    self.container:SwitchPageStatus(ProfessionPageBasePart.TweenGroup.AdvanceJob)
  end
end
function ProfessionNewPage:UpdateCurClassPage(classid)
  self:ShowPreCondition(classid)
  self:UpdateStateFuncs(classid)
  self:RefreshJobChooseSlider(true)
  self.container:RefreshNodes(classid)
  self.container:UpdateProps(classid)
  self.container:ResetClassIconTween()
  self.container:SwitchHeroStory(classid)
  self.container:SwitchPageStatus(ProfessionPageBasePart.TweenGroup.CurJob)
  self.container:UpdateNodeSwitch(1)
  FunctionMultiProfession.Me():UpdateRoleModelByClassID(classid)
  self.container:ShowSwitchEffect()
  if self.jobSwitchValid then
    self.jobTypeSwitch:SetActive(true)
  end
end
function ProfessionNewPage:UpdateEquips(branchid)
  local sdata = BranchInfoSaveProxy.Instance:GetUsersaveData(branchid)
  local dataToDetail = {}
  if ProfessionProxy.Instance:GetCurTypeBranch() == branchid then
    dataToDetail.showType = MPShowType.FromSelf
  elseif sdata then
    dataToDetail.showType = MPShowType.FromSave
    dataToDetail.userSaveInfoData = sdata
  else
    dataToDetail.showType = MPShowType.FromPurchasePreview
  end
  self.container:SetEquip(dataToDetail)
end
function ProfessionNewPage:UpdateJobTypeSwitch(bool)
end
function ProfessionNewPage:HandleClickCurJobPage()
  self.jobBtn:SetActive(true)
  if self.jobSwitchValid then
    self.jobTypeSwitch:SetActive(true)
  end
  self:UpdateCurClassPage(self.curChooseClassID)
end
function ProfessionNewPage:ShowPreCondition(classid)
  if not ProfessionProxy.IsHero(classid) then
    local conditionJob = ProfessionProxy.Instance:GetThisIdJiuZhiTiaoJianLevel(classid)
    local previouId = ProfessionProxy.Instance:GetThisIdPreviousId(classid)
    local conditionBase = ProfessionProxy.Instance:GetThisIdJiuZhiBaseLevel(classid)
    local str = ""
    if conditionJob then
      str = str .. string.format("%s Job Lv.%s", ProfessionProxy.GetProfessionName(previouId, _MyGender), conditionJob)
    end
    if conditionBase then
      str = str .. "\n" .. string.format("Base Lv.%s", conditionBase)
    end
    self.conditionLabel.text = str
  end
end
function ProfessionNewPage:UpdateStateFuncs(classid)
  local state = ProfessionProxy.Instance:GetClassState(classid)
  xdlog("当前职业深度", state)
  self.goToBtn:SetActive(false)
  self.purchaseBtn:SetActive(false)
  self.questBtn:SetActive(false)
  self.tryBtn:SetActive(false)
  self.conditionLabel.gameObject:SetActive(false)
  self.preCondition.gameObject:SetActive(false)
  local classConfig = Table_Class[classid]
  local typeBranch = ProfessionProxy.GetTypeBranchFromProf(classid)
  if ProfessionProxy.Instance:IsMPOpen() then
    if ProfessionProxy.GetJobDepth(classid) == 1 and ProfessionProxy.Instance:IsThisIdYiGouMai(classid) and (state == ProfessionProxy.ClassState.State1 or state == ProfessionProxy.ClassState.State3) then
      if ProfessionProxy.Instance:Isjust1stJob(classid) and typeBranch ~= MyselfProxy.Instance:GetMyProfessionTypeBranch() then
        self.goToBtn:SetActive(true)
        self.goToBtn_Label.text = ZhString.ProfessionPage_ChangeClass
      elseif classid == ProfessionProxy.doramTypical1st then
        self.conditionLabel.gameObject:SetActive(true)
        self.conditionLabel.text = ZhString.ProfessionPage_CurClass
        if classid == ProfessionProxy.humanNovice or classid == ProfessionProxy.doramNovice then
          local maxJobLevel = classConfig.MaxJobLevel or 10
          self.conditionLabel.text = ZhString.ProfessionPage_CurClass .. "\n" .. string.format(ZhString.ProfessionPage_NoviceJobLevelTip, maxJobLevel)
        else
          self.conditionLabel.text = ZhString.ProfessionPage_CurClass
        end
      else
        self.conditionLabel.gameObject:SetActive(true)
        self.conditionLabel.text = ZhString.ProfessionInfoViewMP_HintLabel
        self:UpdatePurchaseCost(classid)
      end
    elseif classid % 10 == 2 and ProfessionProxy.Instance:IsThisIdYiGouMai(classid) and not ProfessionProxy.Instance:IsThisIdYiJiuZhi(classid) and state == ProfessionProxy.ClassState.State7 then
      self.goToBtn:SetActive(true)
      self.goToBtn_Label.text = ZhString.ProfessionPage_ChangeClass
    elseif state == ProfessionProxy.ClassState.State3 then
      self.conditionLabel.gameObject:SetActive(true)
      self.conditionLabel.text = ZhString.ProfessionPage_CurClass
      if classid == ProfessionProxy.humanNovice or classid == ProfessionProxy.doramNovice then
        local maxJobLevel = classConfig.MaxJobLevel or 10
        self.conditionLabel.text = ZhString.ProfessionPage_CurClass .. "\n" .. string.format(ZhString.ProfessionPage_NoviceJobLevelTip, maxJobLevel)
      else
        self.conditionLabel.text = ZhString.ProfessionPage_CurClass
      end
    elseif state == ProfessionProxy.ClassState.State1 then
      self.goToBtn:SetActive(true)
      self.goToBtn_Label.text = ZhString.ProfessionPage_ChangeClass
    elseif state == ProfessionProxy.ClassState.State6 then
      self.purchaseBtn:SetActive(true)
      self:UpdatePurchaseCost(classid)
      if ProfessionProxy.IsHero(classid) then
        self.tryBtn:SetActive(true)
      end
    elseif state == ProfessionProxy.ClassState.State4 then
      self.questBtn:SetActive(true)
      self.questBtn_Label.text = ZhString.ProfessionInfoViewMP_JiuzhiBtnGo
      self:ShowExecuteQuestBtn(classid)
    elseif state == ProfessionProxy.ClassState.State2 then
      self.conditionLabel.gameObject:SetActive(true)
      self.conditionLabel.text = ZhString.ProfessionInfoViewMP_Havezhiye
    elseif state == ProfessionProxy.ClassState.State5 then
      self.conditionLabel.gameObject:SetActive(true)
    elseif state == ProfessionProxy.ClassState.State8 then
      self.conditionLabel.gameObject:SetActive(true)
      self.conditionLabel.text = ZhString.ProfessionInfoViewMP_Nozhiye
    end
  elseif state == ProfessionProxy.ClassState.State3 then
    self.conditionLabel.gameObject:SetActive(true)
    self.conditionLabel.text = ZhString.ProfessionPage_CurClass
    xdlog(self.curChooseTypeBranch, ProfessionProxy.Instance:GetCurTypeBranch())
    if classid == ProfessionProxy.humanNovice or classid == ProfessionProxy.doramNovice then
      local maxJobLevel = classConfig.MaxJobLevel or 10
      self.conditionLabel.text = ZhString.ProfessionPage_CurClass .. "\n" .. string.format(ZhString.ProfessionPage_NoviceJobLevelTip, maxJobLevel)
    elseif self.curChooseTypeBranch ~= ProfessionProxy.Instance:GetCurTypeBranch() then
      self.conditionLabel.text = Table_Sysmsg[25413].Text
    else
      self.conditionLabel.text = ZhString.ProfessionPage_CurClass
    end
  elseif state == ProfessionProxy.ClassState.State1 then
    self.goToBtn:SetActive(true)
    self.goToBtn_Label.text = ZhString.ProfessionPage_ChangeClass
  elseif state == ProfessionProxy.ClassState.State4 then
    self.questBtn:SetActive(true)
    self.questBtn_Label.text = ZhString.ProfessionInfoViewMP_JiuzhiBtnGo
    self.preCondition.gameObject:SetActive(true)
    self:ShowExecuteQuestBtn(classid)
  elseif state == ProfessionProxy.ClassState.State5 then
    self.conditionLabel.gameObject:SetActive(true)
  elseif state == ProfessionProxy.ClassState.State8 then
    self.conditionLabel.gameObject:SetActive(true)
    self.conditionLabel.text = Table_Sysmsg[25413].Text
  elseif state == ProfessionProxy.ClassState.State6 then
    self.purchaseBtn:SetActive(true)
    self:UpdatePurchaseCost(classid)
    if ProfessionProxy.IsHero(classid) then
      self.tryBtn:SetActive(true)
    end
  elseif state == ProfessionProxy.ClassState.State2 then
    if typeBranch == MyselfProxy.Instance:GetMyProfessionTypeBranch() then
      self.conditionLabel.gameObject:SetActive(true)
      self.conditionLabel.text = Table_Sysmsg[25413].Text
    else
      self.conditionLabel.gameObject:SetActive(true)
      self.conditionLabel.text = ZhString.ProfessionInfoViewMP_Havezhiye
    end
  end
  if state == 3 then
    self:UpdateCurProValue()
  elseif state == 1 then
    self:UpdateBranchProValue(typeBranch)
  else
    self.container:UpdatePolygon(classid)
  end
  return state
end
function ProfessionNewPage:ShowExecuteQuestBtn(classid)
  local btnValid = true
  if ProfessionProxy.GetJobDepth() == 4 and GameConfig.ForthTransfer then
    if QuestProxy.Instance:isQuestComplete(GameConfig.ForthTransfer.FirstCheckQuest) then
      if QuestProxy.Instance:checkQuestHasAccept(GameConfig.ForthTransfer.SecondCheckQuest) then
        questFinishStepId = GameConfig.ForthTransfer.SecondFollow[MyselfProxy.Instance:GetMyProfession()]
      else
        btnValid = false
      end
    else
      questFinishStepId = GameConfig.ForthTransfer.FirstCheckQuest
    end
  end
  self:AddClickEvent(self.questBtn.gameObject, function()
    if not btnValid then
      return
    end
    if Game.Myself:IsDead() then
      MsgManager.ShowMsgByID(2500)
      return
    end
    if self:CheckAmIInTransformState() then
      MsgManager.ShowMsgByID(27009)
      return
    end
    FuncShortCutFunc.Me():CallByQuestFinishID({
      questFinishStepId
    }, Table_Class[classid].AdvancedTeacher, nil, false)
    GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.NormalLayer)
  end)
end
function ProfessionNewPage:UpdatePurchaseCost(classid)
  local moneynumber, moneytype = ProfessionProxy.Instance:GetMoneyNumberAndMoneyTypeForPurchaseThisId(classid)
  self.price_Label.text = moneynumber and StringUtil.NumThousandFormat(moneynumber) or 1
  local printX = self.price_Label.printedSize.x
  printX = printX + 40 < 70 and 70 or printX + 40
  self.priceBG.width = printX
  self.price_Icon.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(-30 - (printX - 70) / 2, 2, 0)
  self.purchaseBtn_BoxCollider.enabled = true
  self:SetTextureWhite(self.purchaseBtn, LuaGeometry.GetTempVector4(0.7686274509803922, 0.5254901960784314, 0, 1))
  if moneytype then
    IconManager:SetItemIcon(moneytype.Icon, self.price_Icon)
    self.price_Icon:MakePixelPerfect()
    self.price_Icon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(0.5, 0.5, 0.5)
    if ProfessionProxy.IsHero(classid) then
      self.purchaseBtn:SetActive(true)
      local collaborHero = GameConfig.Profession.collabor_hero
      local isCollabor = collaborHero and 0 < TableUtility.ArrayFindIndex(collaborHero, classid) or false
      if isCollabor then
        local classConfig = Table_Class[classid]
        local unlockTip = classConfig and classConfig.UnlockTips
        if unlockTip then
          self.preCondition.gameObject:SetActive(true)
          self.preCondition.text = unlockTip
        end
      else
        local canBuy, previewClass = ProfessionProxy.Instance:CheckHeroCanBuy(classid)
        if not canBuy then
          self:SetTextureGrey(self.purchaseBtn)
          self.purchaseBtn_BoxCollider.enabled = false
          self.preCondition.gameObject:SetActive(true)
          local classConfig = Table_Class[classid]
          local originId = classConfig and classConfig.OriginId
          local rootBranchName = ProfessionProxy.GetProfessionName(originId, MyselfProxy.Instance:GetMySex()) .. ZhString.ItemTip_ProSeriesPrefix
          self.preCondition.text = string.format(ZhString.ProfessionPage_HeroAdvanceClass, rootBranchName, Table_Class[previewClass].NameZh)
        end
      end
    elseif not ProfessionProxy.Instance:IsThisIdYiGouMai(classid) then
      self.purchaseBtn:SetActive(true)
    else
      self.purchaseBtn:SetActive(false)
    end
  else
    self.purchaseBtn:SetActive(false)
  end
end
function ProfessionNewPage:UpdateClassProcess(classid)
  local result = {}
  local state = ProfessionProxy.Instance:GetClassState(classid)
  if classid == MyselfProxy.Instance:GetMyProfession() then
    local typeBranch = ProfessionProxy.GetTypeBranchFromProf(classid)
    local _BranchInfoSaveProxy = BranchInfoSaveProxy.Instance
    local saveInfoData = _BranchInfoSaveProxy:GetUsersaveData(typeBranch)
    local usedAstro = saveInfoData and AstrolabeProxy.Instance:GetPoints_CostGoldMedalCount(saveInfoData) or 0
    local totalAstro = GameConfig.Profession.maxAstro or 0
    local data = {
      order = 5,
      curValue = usedAstro,
      maxValue = totalAstro
    }
    data.clickFunc = self.ClickAstroBtn
    data.owner = self
    data.funcParams = {
      branchid = ProfessionProxy.GetTypeBranchFromProf(classid)
    }
    result[5] = data
    local usedSkill = SkillProxy.Instance:GetUsedPoints()
    local totalSkill = Game.Myself.data.userdata:Get(UDEnum.SKILL_POINT) + usedSkill
    data = {
      order = 1,
      curValue = usedSkill,
      maxValue = totalSkill
    }
    data.clickFunc = self.ClickSkillBtn
    data.owner = self
    data.funcParams = {
      branchid = ProfessionProxy.GetTypeBranchFromProf(classid)
    }
    result[1] = data
    local skillGem = 0
    local attrGem = 0
    local maxSkillGem = GameConfig.Profession.maxSkillGem or 0
    local maxAttrGem = GameConfig.Profession.maxAttrGem or 0
    local gemData = _BranchInfoSaveProxy:GetGemData(typeBranch)
    if gemData and #gemData > 0 then
      for i = 1, #gemData do
        local single = gemData[i]
        if single.gemSkillData and single.gemSkillData.available then
          skillGem = skillGem + 1
        elseif single.gemAttrData then
          attrGem = attrGem + 1
        end
      end
    end
    if ProfessionProxy.IsHero(classid) then
      data = {
        order = 2,
        curValue = _BranchInfoSaveProxy:GetHeroFeatureLv(typeBranch) or 1,
        maxValue = maxSkillGem + 1
      }
      data.clickFunc = self.ClickGemBtn
      data.owner = self
      data.funcParams = {
        branchid = ProfessionProxy.GetTypeBranchFromProf(classid),
        classid = classid
      }
      result[2] = data
    else
      data = {
        order = 3,
        curValue = skillGem,
        maxValue = maxSkillGem
      }
      data.clickFunc = self.ClickGemBtn
      data.owner = self
      data.funcParams = {
        branchid = ProfessionProxy.GetTypeBranchFromProf(classid),
        classid = classid
      }
      result[3] = data
    end
    data = {
      order = 4,
      curValue = attrGem,
      maxValue = maxAttrGem
    }
    data.clickFunc = self.ClickGemBtn
    data.owner = self
    data.funcParams = {
      branchid = ProfessionProxy.GetTypeBranchFromProf(classid)
    }
    result[4] = data
    local extractData = _BranchInfoSaveProxy:GetExtract(typeBranch)
    local activeCount = extractData and extractData:GetActiveCount() or 0
    local gridCount = extractData and extractData:GetGridCount() or 0
    local extractLimit = GameConfig.Profession.maxExtract or 2
    data = {
      order = 7,
      curValue = activeCount,
      maxValue = extractLimit
    }
    data.clickFunc = self.ClickExtractBtn
    data.owner = self
    data.funcParams = {
      branchid = ProfessionProxy.GetTypeBranchFromProf(classid)
    }
    result[7] = data
    local artifactProcess = PersonalArtifactProxy.Instance:GetPreviewProgress(SaveInfoEnum.Branch, typeBranch)
    data = {
      order = 6,
      curValue = math.ceil(artifactProcess * 100)
    }
    data.clickFunc = self.ClickArtifactBtn
    data.owner = self
    data.funcParams = {
      branchid = ProfessionProxy.GetTypeBranchFromProf(classid)
    }
    result[6] = data
  elseif state == 3 or state == 1 or state == 4 or state == 5 then
    local typeBranch = ProfessionProxy.GetTypeBranchFromProf(classid)
    local _BranchInfoSaveProxy = BranchInfoSaveProxy.Instance
    local saveProfession = _BranchInfoSaveProxy:GetProfession(typeBranch)
    if saveProfession then
      local saveInfoData = _BranchInfoSaveProxy:GetUsersaveData(typeBranch)
      local usedAstro = saveInfoData and AstrolabeProxy.Instance:GetPoints_CostGoldMedalCount(saveInfoData) or 0
      local totalAstro = GameConfig.Profession.maxAstro or 0
      local data = {
        order = 5,
        curValue = usedAstro,
        maxValue = totalAstro
      }
      data.clickFunc = self.ClickAstroBtn
      data.owner = self
      data.funcParams = {
        branchid = ProfessionProxy.GetTypeBranchFromProf(classid)
      }
      result[5] = data
      local usedSkill = _BranchInfoSaveProxy:GetUsedPoints(typeBranch)
      local totalSkill = usedSkill + _BranchInfoSaveProxy:GetUnusedSkillPoint(typeBranch)
      data = {
        order = 1,
        curValue = usedSkill,
        maxValue = totalSkill
      }
      data.clickFunc = self.ClickSkillBtn
      data.owner = self
      data.funcParams = {
        branchid = ProfessionProxy.GetTypeBranchFromProf(classid)
      }
      result[1] = data
      local skillGem = 0
      local attrGem = 0
      local maxSkillGem = GameConfig.Profession.maxSkillGem or 0
      local maxAttrGem = GameConfig.Profession.maxAttrGem or 0
      local gemData = _BranchInfoSaveProxy:GetGemData(typeBranch)
      if gemData and #gemData > 0 then
        for i = 1, #gemData do
          local single = gemData[i]
          if single.gemSkillData and single.gemSkillData.available then
            skillGem = skillGem + 1
          elseif single.gemAttrData then
            attrGem = attrGem + 1
          end
        end
      end
      if ProfessionProxy.IsHero(classid) then
        data = {
          order = 2,
          curValue = _BranchInfoSaveProxy:GetHeroFeatureLv(typeBranch) or 1,
          maxValue = maxSkillGem + 1
        }
        data.clickFunc = self.ClickGemBtn
        data.owner = self
        data.funcParams = {
          branchid = ProfessionProxy.GetTypeBranchFromProf(classid),
          classid = classid
        }
        result[2] = data
      else
        data = {
          order = 3,
          curValue = skillGem,
          maxValue = maxSkillGem
        }
        data.clickFunc = self.ClickGemBtn
        data.owner = self
        data.funcParams = {
          branchid = ProfessionProxy.GetTypeBranchFromProf(classid),
          classid = classid
        }
        result[3] = data
      end
      data = {
        order = 4,
        curValue = attrGem,
        maxValue = maxAttrGem
      }
      data.clickFunc = self.ClickGemBtn
      data.owner = self
      data.funcParams = {
        branchid = ProfessionProxy.GetTypeBranchFromProf(classid)
      }
      result[4] = data
      local extractData = _BranchInfoSaveProxy:GetExtract(typeBranch)
      local activeCount = extractData and extractData:GetActiveCount() or 0
      local gridCount = extractData and extractData:GetGridCount() or 0
      local extractLimit = GameConfig.Profession.maxExtract or 2
      data = {
        order = 7,
        curValue = activeCount,
        maxValue = extractLimit
      }
      data.clickFunc = self.ClickExtractBtn
      data.owner = self
      data.funcParams = {
        branchid = ProfessionProxy.GetTypeBranchFromProf(classid)
      }
      result[7] = data
      local artifactProcess = PersonalArtifactProxy.Instance:GetPreviewProgress(SaveInfoEnum.Branch, typeBranch)
      data = {
        order = 6,
        curValue = math.ceil(artifactProcess * 100)
      }
      data.clickFunc = self.ClickArtifactBtn
      data.owner = self
      data.funcParams = {
        branchid = ProfessionProxy.GetTypeBranchFromProf(classid)
      }
      result[6] = data
    end
  end
  self.container:UpdateClassProcess(result)
end
function ProfessionNewPage:ShowFuncPart(bool)
  self.funcsPart:SetActive(bool)
end
function ProfessionNewPage:UpdateCurProValue()
  self.container:SetAttrRootActive(true)
  local props = Game.Myself.data.props
  local SavePreviewAttrMain = GameConfig.SavePreviewAttrMain
  for i = 1, #SavePreviewAttrMain do
    local single = SavePreviewAttrMain[i]
    local prop = props:GetPropByName(single)
    local value = prop:GetValue()
    self.container:SetPolygonValue(i, value, false)
  end
  self.container:SetMaxJobTipActive(false)
end
function ProfessionNewPage:UpdateBranchProValue(typeBranch)
  self.container:SetAttrRootActive(true)
  local props = BranchInfoSaveProxy.Instance:GetProps(typeBranch)
  local SavePreviewAttrMain = GameConfig.SavePreviewAttrMain
  if props then
    for i = 1, #SavePreviewAttrMain do
      local single = SavePreviewAttrMain[i]
      local propData = props:GetPropByName(single)
      self.container:SetPolygonValue(i, propData.value, false)
    end
  end
  self.container:SetMaxJobTipActive(false)
end
function ProfessionNewPage:UpdateClassBranch(classid)
end
function ProfessionNewPage:CheckEquipCanShow()
  local classid = self.curChooseClassID
  local state = ProfessionProxy.Instance:GetClassState(classid)
  if state == 1 or state == 3 then
    return true
  else
    return false
  end
end
function ProfessionNewPage:UpdateSubClass(typeBranches)
  if typeBranches and #typeBranches > 0 then
    TableUtility.ArrayClear(self.subBranchList)
    TableUtility.ArrayShallowCopy(self.subBranchList, typeBranches)
    if #typeBranches == 1 then
      self.subClassSelectRoot:SetActive(false)
    else
      self.subClassSelectRoot:SetActive(true)
      for i = 1, 2 do
        if typeBranches[i] then
          self.subClassSelectBtns[i]:SetActive(true)
          local prof = typeBranches[i].id
          local icon_name = Table_Class[prof].icon
          IconManager:SetProfessionIcon(icon_name, self.subClassSps[i])
        else
          self.subClassSelectBtns[i]:SetActive(false)
        end
      end
    end
  end
end
function ProfessionNewPage:UpdatePageByClass(classid, typeBranch)
  self.curChooseClassID = classid
  self.curChooseTypeBranch = typeBranch
  local jobLv
  if classid == MyselfProxy.Instance:GetMyProfession() then
    jobLv = ProfessionProxy.Instance:GetThisJobLevelForClient(classid, MyselfProxy.Instance:JobLevel())
  else
    local _BranchInfoSaveProxy = BranchInfoSaveProxy.Instance
    local rawJoblv = _BranchInfoSaveProxy:GetJobLevel(typeBranch)
    jobLv = rawJoblv and ProfessionProxy.Instance:GetThisJobLevelForClient(classid, rawJoblv) or nil
  end
  local showAdvance = false
  if ProfessionProxy.IsHero(classid) then
    showAdvance = false
  elseif ProfessionProxy.Instance:IsMPOpen() then
    showAdvance = true
  elseif MyselfProxy.Instance:GetMyProfessionTypeBranch() == typeBranch then
    showAdvance = true
  end
  self.container:UpdateClassBranchByBranchType(typeBranch, showAdvance, jobLv ~= nil and true or false, jobLv)
  if ProfessionProxy.Instance:HasDepth2Class() then
    if ProfessionProxy.GetJobDepth(classid) == 1 and not ProfessionProxy.Instance:Isjust1stJob(classid) and classid ~= ProfessionProxy.doramTypical1st then
      local advList = self.container:GetAdvClassList()
      if advList and #advList > 0 then
        self:UpdateAdvClassPage(advList[1], false)
        self.container:PlayAdvancedClassTween(1)
        self:UpdateClassProcess(advList[1])
      else
        self:UpdateCurClassPage(classid)
        self:UpdateClassProcess(classid)
      end
    else
      self:UpdateCurClassPage(classid)
      self:UpdateClassProcess(classid)
    end
  else
    self:UpdateCurClassPage(classid)
    self:UpdateClassProcess(classid)
  end
  self:UpdateEquips(typeBranch)
end
function ProfessionNewPage:UpdateClassFocus()
  local targetClassList = self.professionShowList[self.classShowType]
  local targetQuarter
  for i = 1, #targetClassList do
    if targetClassList[i].Type == self.curType then
      targetQuarter = math.ceil(i / self.focusGap)
      break
    end
  end
  for i = 1, 3 do
    self.classFocuses[i].sprite.color = i == targetQuarter and focusColor.Choose or focusColor.UnChoose
    self.classFocuses[i].mark:SetActive(i == targetQuarter)
  end
end
function ProfessionNewPage:OnClickListCell(cellCtl)
  if self.isOnListCtrlStoppedMoving then
    self.isOnListCtrlStoppedMoving = nil
  else
    self.listCtrl:ScrollTowardsCell(cellCtl)
    self.switchByClick = true
  end
  for _, cell in pairs(self.listCells) do
    cell:SetChoose(cellCtl.type)
  end
  local branchInfo = cellCtl and cellCtl.data.branchList
  self:UpdateSubClass(branchInfo)
  self.curAdvanceJobID = nil
  if not self.curListCell or cellCtl.type ~= self.curType then
    self.curListCell = cellCtl
    local showIndex = 0
    for i = 1, #branchInfo do
      if branchInfo[i].isUnlock and (showIndex == 0 or branchInfo[i].branch == self.curTypeBranch) then
        showIndex = i
      end
    end
    if showIndex == 0 then
      showIndex = 1
    end
    self:OnClickSubClassSelectBtn(showIndex)
  end
  self.curType = cellCtl.type
  self:UpdateClassFocus()
end
function ProfessionNewPage:OnClickSubClassSelectBtn(choose_index)
  local branchInfo = self.subBranchList[choose_index]
  if branchInfo then
    local typeBranch = branchInfo.branch
    local S_data = ProfessionProxy.Instance:GetProfessionQueryUserTable()
    local group_classid
    if not S_data[typeBranch] then
      group_classid = branchInfo.baseid
    elseif ProfessionProxy.GetJobDepth(S_data[typeBranch].profession) == 1 then
      group_classid = branchInfo.baseid or branchInfo.id
    else
      group_classid = branchInfo.id
    end
    SaveInfoProxy.Instance:SetSavedLastBranchID(typeBranch)
    self:UpdatePageByClass(group_classid, typeBranch)
  end
  self:UpdateSubClassInfo(choose_index)
end
function ProfessionNewPage:UpdateSubClassInfo(choose_index)
  for i = 1, #self.subClassChooses do
    self.subClassChooses[i].CurrentState = i == choose_index and 1 or 0
  end
  for i = 1, #self.subClassStarSps do
    self.subClassStarSps[i]:SetActive(i == choose_index)
  end
  for i = 1, #self.subClassSps do
    local branchInfo = self.subBranchList[i]
    local isUnlock = branchInfo and branchInfo.isUnlock or false
    self.subClassSps[i].alpha = isUnlock and 1 or 0.4
    if i ~= choose_index or not LuaGeometry.GetTempVector3(0.45, 0.45, 0.45) then
    end
    self.subClassSps[i].gameObject.transform.localScale = LuaGeometry.GetTempVector3(0.35, 0.35, 0.35)
  end
end
function ProfessionNewPage:OnListCtrlStoppedMoving(currentCellCtl)
  if self.switchByClick then
    self.switchByClick = nil
    return
  end
  self.isOnListCtrlStoppedMoving = true
  self:OnClickListCell(currentCellCtl)
  self.switchByClick = nil
end
function ProfessionNewPage:ClickSkillBtn(params)
  local branchid = params.branchid
  if GameConfig.SystemForbid.MultiProfession then
    MsgManager.ShowMsgByID(25413)
    return
  end
  local jobLv = BranchInfoSaveProxy.Instance:GetJobLevel(branchid)
  if jobLv and jobLv > 0 then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.CharactorProfessSkill,
      viewdata = {
        saveId = branchid,
        saveType = SaveInfoEnum.Branch,
        allowedSkillTip = {
          SkillTip.FuncTipType.SubSkillsReadOnly,
          SkillTip.FuncTipType.ItemCost
        }
      }
    })
  else
    MsgManager.ShowMsgByID(25435)
  end
end
function ProfessionNewPage:ClickAstroBtn(params)
  local branchid = params.branchid
  if GameConfig.SystemForbid.MultiProfession then
    MsgManager.ShowMsgByID(25413)
    return
  end
  if MyselfProxy.Instance:IsUnlockAstrolabe() == false then
    MsgManager.ShowMsgByID(25433)
    return
  end
  local sdata = BranchInfoSaveProxy.Instance:GetUsersaveData(branchid)
  if branchid == ProfessionProxy.Instance:GetCurTypeBranch() then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.AstrolabeView,
      viewdata = {FromProfessionInfoViewMP = true}
    })
  elseif sdata then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.AstrolabeView,
      viewdata = {
        saveId = branchid,
        saveType = SaveInfoEnum.Branch
      }
    })
  else
    MsgManager.ShowMsgByID(25433)
  end
end
function ProfessionNewPage:ClickGemBtn(params)
  if GameConfig.SystemForbid.MultiProfession then
    MsgManager.ShowMsgByID(25413)
    return
  end
  local branchid = params.branchid
  local sdata = BranchInfoSaveProxy.Instance:GetUsersaveData(branchid)
  if GameConfig.SystemForbid.MultiProfession then
    MsgManager.ShowMsgByID(25413)
    return
  end
  if sdata then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.GemEmbedPreview,
      viewdata = {
        saveId = branchid,
        saveType = SaveInfoEnum.Branch
      }
    })
  else
    MsgManager.ShowMsgByID(40309)
  end
end
function ProfessionNewPage:ClickExtractBtn(params)
  xdlog("点击萃取预览")
  local branchid = params.branchid
  local extractData = BranchInfoSaveProxy.Instance:GetExtract(branchid)
  if extractData then
    local extractList = extractData:GetExtractData()
    if extractList then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.MagicBoxPanel,
        viewdata = {preview = true, slotdatas = extractList}
      })
    end
  end
end
function ProfessionNewPage:ClickArtifactBtn(params)
  local branchid = params.branchid
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.PersonalArtifactFunctionView,
    viewdata = {
      save_type = SaveInfoEnum.Branch,
      save_id = branchid
    }
  })
end
function ProfessionNewPage:HandleSwitchProfession(note)
  self.curListCell = nil
  local branch = note.body
  self.curTypeBranch = branch
  self.curType = math.modf(branch / 10)
  local sData = ProfessionProxy.Instance:GetProfessionQueryUserTable()
  if sData and sData[self.curTypeBranch] then
    self.curChooseClassID = sData[self.curTypeBranch].profession
  else
    local branchInfo = Table_Branch[self.curTypeBranch]
    self.curChooseClassID = branchInfo and branchInfo.base_id or curClassID
  end
  local targetClassShowType = ProfessionProxy.IsHero(self.curChooseClassID) and 2 or 1
  if targetClassShowType ~= self.classShowType then
    self.classShowType = targetClassShowType
    self:InitShow()
  else
    if self.curChooseClassID then
      local targetClassList = self.professionShowList[self.classShowType]
      for i = 1, #targetClassList do
        if targetClassList[i].Type == self.curType then
          self.listSelectionIndexOnEnter = i
        end
        if self.listSelectionIndexOnEnter == 0 then
          self.listSelectionIndexOnEnter = 1
        end
      end
    end
    self.listCtrl:SetStartPositionByIndex(self.listSelectionIndexOnEnter)
    for i = 1, #self.listCells do
      if self.listCells[i].type and self.listCells[i].type == self.curType then
        self:OnClickListCell(self.listCells[i])
        break
      end
    end
  end
end
function ProfessionNewPage:OnExit()
  ProfessionNewPage.super.OnExit(self)
end
