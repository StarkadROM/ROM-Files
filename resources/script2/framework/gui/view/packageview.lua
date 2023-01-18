PackageView = class("PackageView", ContainerView)
autoImport("PackageMainPage")
autoImport("PackageEquipPage")
autoImport("PackageSetQuickPage")
autoImport("PackageBarrowBagPage")
autoImport("BaseAttributeView")
autoImport("EquipStrengthen")
autoImport("PackageFashionPage")
autoImport("DynamicSkillEffView")
autoImport("PackageWalletPage")
PackageView.ViewType = UIViewType.NormalLayer
PackageView.LeftViewState = {
  Default = "PackageView_LeftViewState_Default",
  Fashion = "PackageView_LeftViewState_Fashion",
  RoleInfo = "PackageView_LeftViewState_RoleInfo",
  BarrowBag = "PackageView_LeftViewState_BarrowBag"
}
PackageView.TabName = {
  [1] = ZhString.PackageView_BagTabName,
  [2] = ZhString.PackageView_StrengthTabName,
  [3] = ZhString.PackageView_WalletTabName
}
function PackageView:GetShowHideMode()
  return PanelShowHideMode.MoveOutAndMoveIn
end
function PackageView:Init()
  self.normalStick = self:FindComponent("NormalStick", UISprite)
  self.mainPage = self:AddSubView("PackageMainPage", PackageMainPage)
  self.equipPage = self:AddSubView("PackageEquipPage", PackageEquipPage)
  self.equipStrengthenViewController = self:AddSubView("EquipStrengthen", EquipStrengthen)
  self.walletPage = self:AddSubView("PackageWalletPage", PackageWalletPage)
  self.BarrowBagPage = self:AddSubView("PackageBarrowBagPage", PackageBarrowBagPage)
  self.fashionPage = self:AddSubView("PackageFashionPage", PackageFashionPage)
  self.DynamicSkillEffView = self:AddSubView("DynamicSkillEffView", DynamicSkillEffView)
  self.shortCutIsSetting = false
  self:InitUI()
  self:MapEvent()
end
function PackageView:OnShow()
  if not self.isPreload then
    Game.Myself:UpdateEpNodeDisplay(true)
    self:UpdateCameraViewPort()
  end
  PackageView.super.OnShow(self)
end
function PackageView:OnEnter()
  PackageView.super.OnEnter(self)
  self:UpdateCameraViewPort()
  self.isPreload = self.viewdata.viewdata and self.viewdata.viewdata.isPreload
  if self.isPreload then
    return
  end
  FunctionCameraEffect.Me():ResetFreeCameraScreenSplitPercent(1)
  self:SetLeftViewState(PackageView.LeftViewState.Default)
  self:ActiveSetShortCut(false)
  self.mainPage:SetItemDragEnabled(true)
  EventManager.Me():AddEventListener(PackageEvent.ActivateSetShortCut, self.ActivateSetShortCut, self)
  self.tabGrid.gameObject:SetActive(true)
  if self.viewdata.viewdata and self.viewdata.viewdata.tab then
    self:TabChangeHandler(self.viewdata.viewdata.tab)
  elseif self.viewdata.view and self.viewdata.view.tab then
    self:TabChangeHandler(self.viewdata.view.tab)
  end
  local hideTab = self.viewdata.viewdata and self.viewdata.viewdata.hideTab
  self.tabGrid.gameObject:SetActive(not hideTab)
  self.onFashionBtn:SetActive(not hideTab)
  self.onInfoBtn:SetActive(not hideTab)
  Game.PerformanceManager:LODHigh()
  self.equipPage:CheckShowShareBtn()
  StrengthProxy.Instance:ResetStrengthType(SceneItem_pb.ESTRENGTHTYPE_NORMAL)
end
function PackageView:InitUI()
  self.objLeft = self:FindGO("Left")
  self.objRight = self:FindGO("Right")
  self.objBeforePanel = self:FindGO("BeforePanel")
  self.onFashionBtn = self:FindGO("OnFashionBtn")
  self.onInfoBtn = self:FindGO("OnInfoBtn")
  self.equipBord = self:FindGO("EquipBord", self.objLeft)
  self.fashionBord = self:FindGO("FashionEquipBord", self.objLeft)
  self.infoBord = self:FindGO("attrViewHolder", self.objLeft)
  self.barrowBagBord = self:FindGO("BarrowBagHolder", self.objLeft)
  self.topCoins = self:FindGO("TopCoins", self.objLeft)
  self.tabGrid = self:FindComponent("Grid", UIGrid)
  self.itemBord = self:FindGO("ItemNormalList", self.objRight)
  self:AddClickEvent(self.onFashionBtn, function(go)
    local myselfData = Game.Myself.data
    if myselfData:IsInMagicMachine() then
      MsgManager.ShowMsgByID(27008)
      return
    end
    if myselfData:IsEatBeing() then
      MsgManager.ShowMsgByID(27009)
      return
    end
    if self.markingFavoriteMode then
      return
    end
    if self.viewState == PackageView.LeftViewState.Fashion then
      self:SetLeftViewState(PackageView.LeftViewState.Default)
    else
      self:SetLeftViewState(PackageView.LeftViewState.Fashion)
    end
  end)
  self:AddClickEvent(self.onInfoBtn, function(go)
    if self.markingFavoriteMode then
      return
    end
    if self.viewState == PackageView.LeftViewState.RoleInfo then
      self:SetLeftViewState(PackageView.LeftViewState.Default)
    else
      self:SetLeftViewState(PackageView.LeftViewState.RoleInfo)
    end
  end)
  self.quickUseTween = self:FindComponent("QuickUseTweenButton", UIPlayTween)
  self:AddButtonEvent("QuickUseTweenButton", function(go)
    if self.markingFavoriteMode then
      return
    end
    self:ActiveSetShortCut(not self.shortCutIsSetting)
  end)
  self.goQuickUseTweenButton = self:FindGO("QuickUseTweenButton")
  self.objBagTab = self:FindGO("BagTab")
  self:AddTabChangeEvent(self.objBagTab, self.itemBord, PanelConfig.Bag)
  RedTipProxy.Instance:RegisterUI(SceneTip_pb.EREDSYS_PET_ADVENTURE, self.objBagTab)
  local strengthTab = self:FindGO("StrengthTab")
  self:RegisterGuideTarget(ClientGuide.TargetType.packageview_strengthtab, strengthTab)
  self:AddOrRemoveGuideId(strengthTab, 35)
  self:AddTabChangeEvent(strengthTab, self.goEquipStrengthen, PanelConfig.EquipStrengthen)
  self.walletTab = self:FindGO("WalletTab")
  self:AddTabChangeEvent(self.walletTab, self.walletPage, PanelConfig.PackageWalletPage)
  RedTipProxy.Instance:RegisterUIByGroupID(21, self.walletTab, 30, {-20, -20})
  local tabList, longPress, icon = {
    self.objBagTab,
    strengthTab,
    self.walletTab
  }, nil, nil
  self.tabIconSpList = {}
  for i, v in ipairs(tabList) do
    longPress = v:GetComponent(UILongPress)
    function longPress.pressEvent(obj, state)
      self:PassEvent(TipLongPressEvent.PackageView, {state, i})
    end
    icon = Game.GameObjectUtil:DeepFindChild(v, "Icon")
    self.tabIconSpList[#self.tabIconSpList + 1] = icon:GetComponent(UISprite)
    TabNameTip.SwitchShowTabIconOrLabel(icon, Game.GameObjectUtil:DeepFindChild(v, "Label"))
    break
  end
  self:AddEventListener(TipLongPressEvent.PackageView, self.HandleLongPress, self)
  self:AddEventListener(PackageEvent.SwitchMarkingFavoriteMode, self.HandleSwitchMarkingFavoriteMode, self)
end
function PackageView:TabChangeHandler(key)
  if self.markingFavoriteMode then
    return
  end
  if PackageView.super.TabChangeHandler(self, key) then
    StrengthProxy.Instance:SetPackageStrengthenShow(key == PanelConfig.EquipStrengthen.tab)
    if key == PanelConfig.Bag.tab then
      self.itemBord:SetActive(true)
      self.goQuickUseTweenButton:SetActive(true)
      self.walletPage:Hide()
      self.equipPage:RemoveMaskOnItems()
      self.equipPage:ShowPureSite(false)
      self.equipPage:ActiveSuitPreview(true)
      self.equipStrengthenViewController:Hide()
      self.equipStrengthenIsShow = false
    elseif key == PanelConfig.EquipStrengthen.tab then
      self.itemBord:SetActive(false)
      self.walletPage:Hide()
      self.equipPage:AddMaskOnItems()
      self.equipPage:ShowPureSite(true)
      self.equipPage:ActiveSuitPreview(false)
      self.goQuickUseTweenButton:SetActive(false)
      self:ActiveSetShortCut(false)
      self.equipStrengthenViewController:Show()
      local chooseSite = self.equipPage.chooseSite
      if chooseSite then
        local isCouldStrengthen = StrengthProxy.Instance:IsCouldStrengthen(chooseSite)
        if isCouldStrengthen then
          self.equipStrengthenViewController:Refresh(chooseSite)
        else
          self.equipPage:SetChoosenSite()
          self.equipStrengthenViewController:SetNormalOrEmpty(false)
        end
      else
        self.equipPage:SetChoosenSite()
        self.equipStrengthenViewController:SetNormalOrEmpty(false)
      end
      self.equipStrengthenIsShow = true
      self.equipStrengthenViewController:AfterContainerTabChangeHandler()
    elseif key == PanelConfig.PackageWalletPage.tab then
      self.itemBord:SetActive(false)
      self.goQuickUseTweenButton:SetActive(true)
      self.equipPage:RemoveMaskOnItems()
      self.equipPage:ShowPureSite(false)
      self.equipPage:ActiveSuitPreview(false)
      self.equipStrengthenViewController:Hide()
      self.walletPage:Show()
      self.equipStrengthenIsShow = false
      if not BranchMgr.IsJapan() then
        local dont = LocalSaveProxy.Instance:GetDontShowAgain(41138)
        if nil == dont then
          MsgManager.DontAgainConfirmMsgByID(41138)
        end
      end
    end
    self:SetCurrentTabIconColor(self.coreTabMap[key].go)
  end
end
function PackageView:GetBaseAttriView()
  if not self.baseAttributeView then
    self.baseAttributeView = self:AddSubView("BaseAttributeView", BaseAttributeView)
    self.baseAttributeView:OnEnter()
    self.baseAttributeView:HideHelpBtn()
  end
  return self.baseAttributeView
end
function PackageView:ActiveSetShortCut(active)
  if self.shortCutIsSetting ~= active then
    if active and not self.packageSetQuickPage then
      self.packageSetQuickPage = self:AddSubView("PackageSetQuickPage", PackageSetQuickPage)
      self.packageSetQuickPage:OnEnter()
    end
    self.quickUseTween:Play(active)
    self.equipPage:SetItemDragEnabled(active)
    self.shortCutIsSetting = active
  end
end
function PackageView:SetLeftViewState(viewState)
  if self.viewState == viewState then
    return
  end
  local onRotation, offRotation = Quaternion.Euler(0, 180, 0), Quaternion.identity
  if self.viewState == PackageView.LeftViewState.BarrowBag then
    self.BarrowBagPage:Close()
  end
  self.barrowBagBord:SetActive(viewState == PackageView.LeftViewState.BarrowBag)
  self.objLeft:SetActive(viewState ~= PackageView.LeftViewState.Fashion)
  self.objRight:SetActive(viewState ~= PackageView.LeftViewState.Fashion)
  self.objBeforePanel:SetActive(viewState ~= PackageView.LeftViewState.Fashion)
  self.tabGrid.gameObject:SetActive(viewState ~= PackageView.LeftViewState.Fashion)
  self.fashionPage:Switch(false)
  self.DynamicSkillEffView:Switch(false)
  local rotation1, rotation2 = offRotation, offRotation
  if viewState == PackageView.LeftViewState.Default then
  elseif viewState == PackageView.LeftViewState.Fashion then
    self.fashionPage:Switch(true)
    rotation1 = onRotation
  elseif viewState == PackageView.LeftViewState.RoleInfo then
    rotation2 = onRotation
    self:GetBaseAttriView():showMySelf()
  elseif viewState == PackageView.LeftViewState.Strength then
  elseif viewState == PackageView.LeftViewState.BarrowBag then
    self.BarrowBagPage:Open()
  end
  self.onFashionBtn.transform.localRotation = rotation1
  self.onInfoBtn.transform.localRotation = rotation2
  self.equipBord:SetActive(viewState == PackageView.LeftViewState.Default)
  self.fashionBord:SetActive(viewState == PackageView.LeftViewState.Fashion)
  self.infoBord:SetActive(viewState == PackageView.LeftViewState.RoleInfo)
  self.topCoins:SetActive(viewState ~= PackageView.LeftViewState.RoleInfo and viewState ~= PackageView.LeftViewState.BarrowBag)
  self.viewState = viewState
end
function PackageView:GetDataFuncs(data, source)
  local result = {}
  if data then
    if self.viewState == PackageView.LeftViewState.BarrowBag then
      result = {37}
    else
      result = FunctionItemFunc.GetItemFuncIds(data.staticData.id, source, self.viewState == PackageView.LeftViewState.Fashion)
    end
  end
  return result
end
function PackageView:GetItemDefaultFunc(data, source)
  source = source or FunctionItemFunc_Source.MainBag
  return FunctionItemFunc.Me():GetItemDefaultFunc(data, source, self.viewState == PackageView.LeftViewState.Fashion)
end
function PackageView:MapEvent()
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.HandleMapChange)
  self:AddListenEvt(LoadSceneEvent.SceneAnimEnd, self.HandleSceneAnimEnd)
  self:AddListenEvt(PackageEvent.OpenBarrowBag, self.HandleOpenBarrowBag)
  self:AddListenEvt(MyselfEvent.ChangeDress, self.EventUpdateCameraViewPort)
end
function PackageView:SetRefineEquip(equip)
  if self.tabType ~= PackageView.TabType.Refine then
    return
  end
end
function PackageView:IsRefinePage()
  return self.tabType == PackageView.TabType.Refine
end
function PackageView:SetChooseEquip(cell)
  self.equipPage:SetChoose(cell)
end
function PackageView:GetChooseEquip()
  return self.equipPage.chooseEquip
end
function PackageView:HandleMapChange(note)
  self:CloseSelf()
end
function PackageView:HandleSceneAnimEnd(note)
  self:CloseSelf()
end
function PackageView:HandleOpenBarrowBag(note)
  self:SetLeftViewState(PackageView.LeftViewState.BarrowBag)
end
function PackageView:ActivateSetShortCut()
  if self.markingFavoriteMode then
    return
  end
  self:ActiveSetShortCut(true)
end
function PackageView:HandleSwitchMarkingFavoriteMode(on)
  self.markingFavoriteMode = on
  if on then
    self:ActiveSetShortCut(false)
  end
end
function PackageView:OnExit()
  EventManager.Me():RemoveEventListener(PackageEvent.ActivateSetShortCut, self.ActivateSetShortCut, self)
  UIUtil.StopEightTypeMsg()
  ServiceItemProxy.Instance:CallBrowsePackage(SceneItem_pb.EPACKTYPE_MAIN)
  Game.PerformanceManager:ResetLOD()
  FunctionCameraEffect.Me():ResetFreeCameraScreenSplitPercent()
  PackageView.super.OnExit(self)
  self:CameraReset()
end
function PackageView:AddCloseButtonEvent()
  self:AddButtonEvent("CloseButton", function()
    self.mainPage:CheckFavoriteModeOnExit(function()
      self:CloseSelf()
    end)
  end)
end
function PackageView:HandleLongPress(param)
  local isPressing, index = param[1], param[2]
  TabNameTip.OnLongPress(isPressing, PackageView.TabName[index], false, self.coreTabMap[index].go:GetComponent(UISprite))
end
function PackageView:SetCurrentTabIconColor(currentTabGo)
  TabNameTip.ResetColorOfTabIconList(self.tabIconSpList)
  TabNameTip.SetupIconColorOfCurrentTabObj(currentTabGo)
end
function PackageView:EventUpdateCameraViewPort(note)
  self:UpdateCameraViewPort()
end
function PackageView:UpdateCameraViewPort(duration)
  self:CameraFocusToMe(duration)
end
function PackageView:OnDestroy()
  RedTipProxy.Instance:UnRegisterUI(SceneTip_pb.EREDSYS_PET_ADVENTURE, self.objBagTab)
  PackageView.super.OnDestroy(self)
end
