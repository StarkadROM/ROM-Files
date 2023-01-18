MultiProfessionNewView = class("MultiProfessionNewView", ContainerView)
MultiProfessionNewView.ViewType = UIViewType.NormalLayer
local _ArrayClear = TableUtility.ArrayClear
local _ArrayShallowCopy = TableUtility.ArrayShallowCopy
local _ArrayPushBack = TableUtility.ArrayPushBack
local _GetTempVector3 = LuaGeometry.GetTempVector3
local _ProfessionProxy, _PictureManager
local _GetPosition = LuaGameObject.GetPosition
local _GetRotation = LuaGameObject.GetRotation
local _GetTempQuaternion = LuaGeometry.GetTempQuaternion
local _ObjectIsNull = LuaGameObject.ObjectIsNull
local _SetPositionGO = LuaGameObject.SetPositionGO
local _LuaDestroyObject = LuaGameObject.DestroyObject
local _Const_V3_zero = LuaGeometry.Const_V3_zero
local _PartIndex = Asset_Role.PartIndex
local _PartIndexEX = Asset_Role.PartIndexEx
local _MyGender, _MyRace
local _SceneName = "Scenesc_chuangjue"
local _EnviromentID = 231
local tempVector3 = LuaVector3.Zero()
local cameraConfig = {
  position = LuaVector3.New(1.28, 1.47, -2.34),
  rotation = LuaQuaternion.Euler(7.12, -27.5, 0),
  fieldOfView = 66,
  backScale = Vector3(16, 9, 1)
}
autoImport("WrapInfiniteListCtrl")
autoImport("ProfessionNewPage")
autoImport("ProfessionChooseCell")
autoImport("FunctionMultiProfession")
autoImport("ProfessionPageBasePart")
autoImport("ProfessionNewHeroPage")
autoImport("ProfessionSaveLoadNewPage")
autoImport("NewHappyShopBuyItemCell")
local _PictureManager = PictureManager.Instance
function MultiProfessionNewView:Init()
  FunctionCameraEffect.Me():ResetEffect(nil, true)
  _MyGender = MyselfProxy.Instance:GetMySex()
  _MyRace = MyselfProxy.Instance:GetMyRace()
  _ProfessionProxy = ProfessionProxy.Instance
  _PictureManager = PictureManager.Instance
  self:FindObjs()
  self:AddListenerEvts()
  self:AddCloseButtonEvent()
end
function MultiProfessionNewView:FindObjs()
  self.anchor_top = self:FindGO("Anchor_Top")
  self.professionPageTog = self:FindGO("ProfessionPageTog")
  self.professionPageCheck = self:FindGO("CheckMark", self.professionPageTog)
  self.saveAndLoadPageTog = self:FindGO("SaveAndLoadPageTog")
  self.saveAndLoadPageCheck = self:FindGO("CheckMark", self.saveAndLoadPageTog)
  self.professionPageContainer = self:FindGO("ProfessionPageContainer")
  self.ymirPageContainer = self:FindGO("YmirPageContainer")
  self.basePartContainer = self:FindGO("BasePartContainer")
  self.roleTexture = self:FindGO("RoleTexture"):GetComponent(UITexture)
  self.effectContainer = self:FindGO("EffectContainer")
  self.meterorContainer = self:FindGO("meterorContainer", self.effectContainer)
  self.butterflyContainer = self:FindGO("butterflyContainer", self.effectContainer)
  self.switchEffectContainer = self:FindGO("switchEffectContainer", self.effectContainer)
  if not self.basePart then
    self.basePart = self:AddSubView("ProfessionPageBasePart", ProfessionPageBasePart)
  end
  if not self.professionPage then
    self.professionPage = self:AddSubView("ProfessionNewPage", ProfessionNewPage)
    self.professionPageContainer:SetActive(false)
  end
  self.professionHeroPage = self:AddSubView("ProfessionNewHeroPage", ProfessionNewHeroPage)
  self.professionHeroPage.gameObject:SetActive(false)
  self:AddTabChangeEvent(self.professionPageTog, self.professionPageContainer, 1)
  self:AddTabChangeEvent(self.saveAndLoadPageTog, self.ymirPageContainer, 2)
  if self.viewdata then
    if self.viewdata.viewdata and self.viewdata.viewdata.tab then
      self:TabChangeHandler(self.viewdata.viewdata.tab)
    else
      local savedTab = SaveInfoProxy.Instance:GetSavedTabIndex()
      if savedTab then
        self:TabChangeHandler(savedTab)
      else
        self:TabChangeHandler(PanelConfig.ProfessionNewPage.tab)
      end
    end
  else
    local savedTab = SaveInfoProxy.Instance:GetSavedTabIndex()
    if savedTab then
      self:TabChangeHandler(savedTab)
    else
      self:TabChangeHandler(PanelConfig.ProfessionNewPage.tab)
    end
  end
  self:CreateShopItemCell()
end
function MultiProfessionNewView:AddListenerEvts()
  self:AddListenEvt(ServiceEvent.NUserProfessionQueryUserCmd, self.RecvProfessionQueryUserCmd)
  self:AddListenEvt(ServiceEvent.NUserProfessionBuyUserCmd)
  self:AddListenEvt(ServiceEvent.NUserProfessionChangeUserCmd)
  self:AddListenEvt(ServiceEvent.NUserLoadRecordUserCmd, self.CloseSelf)
  self:AddListenEvt(ServiceEvent.NUserUpdateRecordInfoUserCmd, self.HandleRecvUpdateRecordInfoUserCmd)
  self:AddListenEvt(SaveNewCell.StatusChange, self.OnStatusChange)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
end
function MultiProfessionNewView:TabChangeHandler(key)
  if self.curTab == key then
    return
  end
  if key == PanelConfig.ProfessionNewPage.tab then
    if self.professionSaveLoadNewPage then
      self.professionSaveLoadNewPage:Hide()
    end
    self.curTab = key
    if not self.professionPage then
      self.professionPage = self:AddSubView("ProfessionNewPage", ProfessionNewPage)
    end
    self.professionPage:RefreshJobChooseSlider(true)
    self.professionPage:RefreshPage()
    self:SwitchPageStatus(ProfessionPageBasePart.TweenGroup.CurJob)
    FunctionMultiProfession.Me():TargetMoveTween(1, 0.5)
    self:SetSwitchEffectPos(1)
    self:SetEquipPartPos(1)
  elseif key == 2 then
    if not FunctionUnLockFunc.Me():CheckCanOpen(9005, true) then
      return
    end
    self.curTab = key
    if self.professionPage then
      self.professionPage:RefreshJobChooseSlider(false)
    end
    FunctionMultiProfession.Me():TargetMoveTween(2, 0.5)
    if not self.professionSaveLoadNewPage then
      self.professionSaveLoadNewPage = self:AddSubView("ProfessionSaveLoadNewPage", ProfessionSaveLoadNewPage)
    else
      self.professionSaveLoadNewPage:Show()
    end
    self.basePart:ResetClassIconTween()
    self:SetSwitchEffectPos(2)
    self:SetEquipPartPos(2)
  end
  if not MultiProfessionNewView.super.TabChangeHandler(self, key) then
    return
  end
  SaveInfoProxy.Instance:SetSavedTabIndex(key)
  self.basePart:SetCurTabIndex(key)
  self.professionPageCheck:SetActive(key == PanelConfig.ProfessionNewPage.tab)
  self.saveAndLoadPageCheck:SetActive(key == 2)
end
function MultiProfessionNewView:SwitchPageStatus(TweenGroup)
  self.basePart:UpdatePageTween(TweenGroup)
end
function MultiProfessionNewView:ResetClassIconTween()
  self.basePart:ResetClassIconTween()
end
function MultiProfessionNewView:PlayAdvancedClassTween(index)
  self.basePart:PlayAdvancedClassTween(index)
end
function MultiProfessionNewView:UpdateProps(classid)
  self.basePart:UpdateProps(classid)
end
function MultiProfessionNewView:SetProps(props)
  self.basePart:SetProps(props)
end
function MultiProfessionNewView:UpdatePolygon(classid)
  self.basePart:UpdatePolygon(classid)
end
function MultiProfessionNewView:SetPolygonValue(index, value, showPlus)
  self.basePart:SetPolyonValue(index, value, showPlus)
end
function MultiProfessionNewView:SetAttrRootActive(bool)
  self.basePart:SetAttrRootActive(bool)
end
function MultiProfessionNewView:SetMaxJobTipActive(bool)
  self.basePart:SetMaxJobTipActive(bool)
end
function MultiProfessionNewView:UpdateCurClassBranch(classid, showAdvance, showLevel, jobLevel)
  self.basePart:UpdateCurClassBranch(classid, showAdvance, showLevel, jobLevel)
end
function MultiProfessionNewView:UpdateClassBranchByBranchType(classid, showAdvance, showLevel, jobLevel)
  self.basePart:UpdateClassBranchByBranchType(classid, showAdvance, showLevel, jobLevel)
end
function MultiProfessionNewView:GetAdvClassList()
  return self.basePart:GetAdvClassList()
end
function MultiProfessionNewView:SetEquip(equipData)
  self.basePart:UpdateEquip(equipData)
end
function MultiProfessionNewView:ShowEquip(bool)
  self.basePart:ShowEquip(bool)
end
function MultiProfessionNewView:UpdateNodeSwitch(index)
  self.basePart:UpdateSwitchNode(index)
end
function MultiProfessionNewView:UpdateClassProcess(list)
  self.basePart:UpdateClassProcess(list)
end
function MultiProfessionNewView:RefreshNodes(classid)
  self.basePart:RefreshNodes(classid)
end
function MultiProfessionNewView:SetFateBtnState(state)
  self.basePart:SetFateBtnState(state)
end
function MultiProfessionNewView:SetClassGOClickState(state)
  self.basePart:SetClassGOClickState(state)
end
function MultiProfessionNewView:SetEquipPartPos(index)
  self.basePart:SetEquipPartPos(index)
end
function MultiProfessionNewView:OnProfessionSaveLoadPageShow()
  self:SetFateBtnState(false)
  self:SetClassGOClickState(false)
end
function MultiProfessionNewView:OnProfessionSaveLoadPageHide()
  self:SetFateBtnState(true)
  self:SetClassGOClickState(true)
  self:SetSwitchNodeActive(true)
end
function MultiProfessionNewView:SwitchHeroStory(classid)
  self.professionHeroPage:SetProfession(classid)
end
function MultiProfessionNewView:UpdateRoleModelByClassID(classid)
  local classStaticData = Table_Class[classid]
  if not classStaticData then
    return
  end
  local parts = Asset_Role.CreatePartArray()
  local classBody = _MyGender == ProtoCommon_pb.EGENDER_MALE and classStaticData.MaleBody or classStaticData.FemaleBody
  parts[_PartIndex.Body] = classBody
  local userData = Game.Myself.data.userdata
  local self_race = ProfessionProxy.GetRaceByProfession(userData:Get(UDEnum.PROFESSION))
  local classRace = ProfessionProxy.GetRaceByProfession(classid)
  if self_race ~= classRace then
    local hair, eye = _ProfessionProxy:GetProfessionRaceFaceInfo(classRace)
    parts[_PartIndex.Hair] = hair
    parts[_PartIndex.Eye] = eye
  else
    parts[_PartIndex.Hair] = userData:Get(UDEnum.HAIR)
    parts[_PartIndex.Eye] = userData:Get(UDEnum.EYE)
  end
  local weapon = classStaticData.DefaultWeapon
  parts[_PartIndex.RightWeapon] = weapon or 0
  parts[_PartIndexEX.HairColorIndex] = Game.Myself.data.userdata:Get(UDEnum.HAIRCOLOR)
  parts[_PartIndexEX.EyeColorIndex] = Game.Myself.data.userdata:Get(UDEnum.EYECOLOR)
  self:UpdateRoleModel(parts)
  Asset_Role.DestroyPartArray(parts)
end
function MultiProfessionNewView:UpdateRoleModel(parts)
  self.model = UIModelUtil.Instance:SetRoleModelTexture(self.roleTexture, parts, cameraConfig, nil, nil, nil, nil, function(obj)
    self.model = obj
    LuaVector3.Better_Set(tempVector3, 0, -18, 0)
    self.model:SetEulerAngles(tempVector3)
  end)
  UIModelUtil.Instance:ChangeBGMeshRenderer("Reloading_BG_duozhiye", self.roleTexture)
end
function MultiProfessionNewView:SwitchToNode(index)
  if self.curTab == 1 then
    if index == 1 then
      if self.professionHeroPage.gameObject.activeSelf then
        self.professionHeroPage:StartInoutAnim(2, function()
          self.professionHeroPage.gameObject:SetActive(false)
        end)
      end
      FunctionMultiProfession.Me():TargetMoveTween(1, 0.4)
      self.professionPage:ShowFuncPart(true)
    elseif index == 2 then
      if not self.professionPage:CheckEquipCanShow() then
        MsgManager.ShowMsgByID(40312)
        return false
      end
      if self.professionHeroPage.gameObject.activeSelf then
        self.professionHeroPage:StartInoutAnim(2, function()
          self.professionHeroPage.gameObject:SetActive(false)
        end)
      end
      FunctionMultiProfession.Me():TargetMoveTween(1, 0.4)
      self.professionPage:ShowFuncPart(false)
    elseif index == 3 then
      if GameConfig.Profession.HeroStoryForbid then
        local curProfession = self.professionHeroPage.selectedProfession
        if TableUtility.ArrayFindIndex(GameConfig.Profession.HeroStoryForbid, curProfession) > 0 then
          MsgManager.ShowMsgByID(43010)
          return false
        end
      end
      self.professionHeroPage.gameObject:SetActive(true)
      self.professionHeroPage:StartInoutAnim(1)
      FunctionMultiProfession.Me():TargetMoveTween(3, 0.5)
      self.professionPage:ShowFuncPart(false)
    end
  elseif self.curTab == 2 then
    if self.professionHeroPage.gameObject.activeSelf then
      self.professionHeroPage:StartInoutAnim(2, function()
        self.professionHeroPage.gameObject:SetActive(false)
      end)
    end
    FunctionMultiProfession.Me():TargetMoveTween(2, 0.4, index)
    if self.professionSaveLoadNewPage then
      self.professionSaveLoadNewPage:OnNodeSwitch(index)
    end
  end
  return true
end
function MultiProfessionNewView:SetSwitchNodeActive(active)
  self.basePart:SetSwitchNodeActive(active)
end
function MultiProfessionNewView:CreateShopItemCell()
  self.shopItemCellGO = self:LoadPreferb("cell/NewHappyShopBuyItemCell", self.gameObject, true)
  self.shopItemCellGO.transform.localPosition = LuaGeometry.GetTempVector3(100, 22)
  self.shopItemCellGO:SetActive(false)
end
function MultiProfessionNewView:ShowShopPurchaseCell(shopItemData)
  local itemData = Table_Item[shopItemData.goodsID]
  if shopItemData.isDeposit then
    itemData = Table_Item[shopItemData.itemID]
  end
  if itemData then
    if not self.shopItemCell then
      self.shopItemCell = NewHappyShopBuyItemCell.new(self.shopItemCellGO)
    end
    self.shopItemCell:SetData(shopItemData)
  end
end
function MultiProfessionNewView:ShowSwitchEffect()
  self:PlayUIEffect(EffectMap.UI.ProfessionPageJobSwitch, self.switchEffectContainer, true)
end
function MultiProfessionNewView:SetSwitchEffectPos(index)
  if index == 1 then
    self.switchEffectContainer.transform.localPosition = LuaGeometry.GetTempVector3(40, 0, 0)
  elseif index == 2 then
    self.switchEffectContainer.transform.localPosition = LuaGeometry.GetTempVector3(100, 0, 0)
  end
end
function MultiProfessionNewView:OnClickListCell(cellCtl)
  local group_classid = cellCtl and cellCtl.data
  for _, cell in pairs(self.listCells) do
    cell:SetChoose(group_classid)
  end
  if self.isOnListCtrlStoppedMoving then
    self.isOnListCtrlStoppedMoving = nil
  else
    self.listCtrl:ScrollTowardsCell(cellCtl)
  end
end
function MultiProfessionNewView:RecvProfessionQueryUserCmd(data)
  local S_ProfessionDatas = ProfessionProxy.Instance:GetProfessionQueryUserTable()
  for k, v in pairs(S_ProfessionDatas) do
    if v.iscurrent then
      ProfessionProxy.Instance:SetCurTypeBranch(v.branch)
    end
  end
end
function MultiProfessionNewView:CallHeroTicketShop()
  if not GameConfig.Profession.hero_ticket_shop then
    local hero_ticket_shop = {
      812,
      1,
      56597
    }
  end
  HappyShopProxy.Instance:InitShop(nil, hero_ticket_shop[2], hero_ticket_shop[1])
end
function MultiProfessionNewView:OnEnter()
  self.super.OnEnter(self)
  ServiceNUserProxy.Instance:CallProfessionQueryUserCmd(nil)
  FunctionMultiProfession.Me():Launch()
  self:CallHeroTicketShop()
  self:PlayUIEffect(EffectMap.UI.ProfessionPageMeteror, self.meterorContainer)
  self:PlayUIEffect(EffectMap.UI.ProfessionPageButterfly, self.butterflyContainer)
  FunctionBGMCmd.Me():PlayUIBgm("Title_SevenRoyal", 0)
  EventManager.Me():AddEventListener(AppStateEvent.BackToLogo, self.OnExit, self)
  UIManagerProxy.Instance:ActiveLayer(UIViewType.ReviveLayer, false)
end
function MultiProfessionNewView:OnExit()
  FunctionMultiProfession.Me():Shutdown()
  local mount = BagProxy.Instance.roleEquip:GetMount()
  local vp = nil ~= mount and CameraConfig.UI_WithMount_ViewPort or CameraConfig.UI_ViewPort
  self:CameraRotateToMe(false, vp, nil, nil, 0)
  self:CameraReset()
  FunctionBGMCmd.Me():StopUIBgm()
  EventManager.Me():RemoveEventListener(AppStateEvent.BackToLogo, self.OnExit, self)
  UIManagerProxy.Instance:ActiveLayer(UIViewType.ReviveLayer, true)
  MultiProfessionNewView.super.OnExit(self)
end
function MultiProfessionNewView:HandleRecvUpdateRecordInfoUserCmd(note)
  self.professionSaveLoadNewPage:HandleRecvUpdateRecordInfoUserCmd()
  self:SwitchToNode(1)
end
function MultiProfessionNewView:OnStatusChange()
  if self.professionSaveLoadNewPage then
    self.professionSaveLoadNewPage:OnStatusChange()
  end
end
function MultiProfessionNewView:CloseSelf()
  MultiProfessionNewView.super.CloseSelf(self)
end
