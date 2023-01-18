autoImport("GemDragCell")
autoImport("WrapListCtrl")
autoImport("GemEmbedPreviewPage")
autoImport("GemSkillProfitCell")
autoImport("GemAttributeProfitCell")
GemEmbedPage = class("GemEmbedPage", GemEmbedPreviewPage)
GemEmbedPage.DownCtrlMode = {
  DragTip = 0,
  EmbedBtn = 1,
  GemCtrl = 2
}
local pageZoomInScaleFactor, pageZoomOutScaleFactor = 1.5, 1
local isAttributeSortOrderDescending = true
local gemTipCellAsidePosX = -350
local draggingTipLocalPosX, draggingTipLocalPosY = 0, 75
local tickManager, posX, posY, isNull
function GemEmbedPage:Init()
  GemEmbedPage.super.Init(self)
  if not tickManager then
    tickManager = TimeTickManager.Me()
  end
  if not isNull then
    isNull = Slua.IsNull
  end
  self.uiScreenSizeX, self.uiScreenSizeY = UIManagerProxy.Instance:GetMyMobileScreenSize()
  self:AddEvents()
  self:InitDown()
  self:InitDownLeft()
  self:InitCollider()
  self:InitNewProfitBord()
  self:InitHelpButton()
  self:InitDraggingTip()
end
function GemEmbedPage:InitRight()
  GemEmbedPage.super.InitRight(self)
  self:InitSelectBord()
end
function GemEmbedPage:InitGemTipCell()
  GemEmbedPage.super.InitGemTipCell(self)
  self.gemTipCellForCompareGO = self:FindGO("GemTipCellForCompare")
  self.gemTipCellForCompare = ItemTipGemCell.new(self.gemTipCellForCompareGO)
end
function GemEmbedPage:AddEvents()
  self:AddListenEvt(ServiceEvent.ItemGemMountItemCmd, self.OnEmbed)
  self:AddListenEvt(ServiceEvent.ItemGemUnmountItemCmd, self.OnRemove)
  self:AddListenEvt(ItemEvent.GemUpdate, self.OnGemUpdate)
  self:AddListenEvt(ItemEvent.GemPageUpdate, self.OnGemPageUpdate)
  self:AddListenEvt(SkillEvent.SkillUpdate, self.UpdateHeroLv)
end
function GemEmbedPage:InitDown()
  self.downCtrlParent = self:FindGO("Down")
  self.embedBtn = self:FindGO("EmbedBtn")
  self:AddClickEvent(self.embedBtn, function()
    self:OpenSelectBord()
    self:SetDownCtrlMode(GemEmbedPage.DownCtrlMode.DragTip)
  end)
  self.gemCtrlParent = self:FindGO("GemCtrls")
  self:AddButtonEvent("RemoveBtn", function()
    if not self.choosePageCell then
      MsgManager.FloatMsg(nil, ZhString.Gem_PageSelectBtnInvalidTip)
      return
    end
    if not self.choosePageCell.data then
      return
    end
    local gemType = self:GetGemTypeOfChoosePageCell()
    GemProxy.CallRemove(gemType, self.choosePageCell.data.id)
    self:SetDownCtrlMode(GemEmbedPage.DownCtrlMode.DragTip)
    self:SetPageAside(false)
  end)
  self:AddButtonEvent("ChangeBtn", function()
    self:OpenSelectBord()
    self:SetDownCtrlMode(GemEmbedPage.DownCtrlMode.DragTip)
  end)
  self.dragTip = self:FindGO("DragTip")
end
function GemEmbedPage:InitDownLeft()
  local downLeftParent = self:FindGO("DownLeft")
  local zoomBtn = self:FindGO("ZoomBtn", downLeftParent)
  self:Show(zoomBtn)
  local showBtn = self:FindGO("ShowBtn", downLeftParent)
  self:Show(showBtn)
  self.zoomBtnSp = self:FindComponent("Sprite", UISprite, zoomBtn)
  self.showBtnSp = self:FindComponent("Sprite", UISprite, showBtn)
  downLeftParent:SetActive(true)
  self:AddClickEvent(zoomBtn, function()
    self:SetPageZoom()
  end)
  self:AddClickEvent(showBtn, function()
    self:SetNameTipShow()
  end)
  local profitBtn = self:FindGO("ProfitBtn")
  self.heroLvLab = self:FindComponent("HeroProLv", UILabel, profitBtn)
  self:Show(profitBtn)
  self:AddClickEvent(profitBtn, function()
    local isProfitBordActive = self.profitBord.activeInHierarchy
    if not isProfitBordActive then
      self:TryUpdateProfitBord()
    end
    self.profitBord:SetActive(not isProfitBordActive)
  end)
  local selectBordBtn = self:FindGO("SelectBordBtn")
  self:Show(selectBordBtn)
  self:AddClickEvent(selectBordBtn, function()
    if not self.selectBord.activeInHierarchy then
      self:ShowGemTipWith()
      self:SetDownCtrlMode(GemEmbedPage.DownCtrlMode.DragTip)
      self.selectBord:SetActive(true)
      self:TryUpdateSelectBord()
      self:SetPageAside(true)
    else
      self:SetPageAside(false)
    end
  end)
end
function GemEmbedPage:InitSelectBord()
  self.selectBord = self:FindGO("SelectBord")
  local closeBtn = self:FindGO("CloseBordBtn", self.selectBord)
  self:AddClickEvent(closeBtn, function()
    self:SetPageAside(false)
    self:OnClickCollider()
  end)
  local selectBtn = self:FindGO("SelectBtn", self.selectBord)
  self:AddClickEvent(selectBtn, function()
    self:TryEmbed()
  end)
  self.noneTip = self:FindGO("NoneTip", self.selectBord)
  self.noneTipLabel = self:FindComponent("NoneTipLabel", UILabel, self.selectBord)
  self:InitSelectBordItemCtrls()
  self:InitSelectBordTabs()
  self:InitSelectBordFilterCtrls()
end
function GemEmbedPage:InitSelectBordItemCtrls()
  self.selectBordContainer = self:FindGO("ItemContainer")
  self.listCtrl = WrapListCtrl.new(self.selectBordContainer, GemDragCell, "GemCell", WrapListCtrl_Dir.Vertical, 3, 102, true)
  self.listCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickListCell, self)
  self.listCtrl:AddEventListener(ItemEvent.GemDragStart, self.OnBordGemDragStart, self)
  self.listCtrl:AddEventListener(ItemEvent.GemDragEnd, self.OnBordGemDragEnd, self)
  self.listCells = self.listCtrl:GetCells()
end
function GemEmbedPage:InitSelectBordTabs()
  local tabParent = self:FindGO("Tabs", self.selectBord)
  local sps = UIUtil.GetAllComponentsInChildren(tabParent, UISprite)
  for i = 1, #sps do
    sps[i]:MakePixelPerfect()
  end
  local attributeTabGO = self:FindGO("AttributeTab", self.selectBord)
  self:AddClickEvent(attributeTabGO, function()
    self:TryUpdateSelectBord(SceneItem_pb.EGEMTYPE_ATTR)
  end)
  self.attributeToggle = attributeTabGO:GetComponent(UIToggle)
  local skillTabGO = self:FindGO("SkillTab", self.selectBord)
  self:AddClickEvent(skillTabGO, function()
    self:TryUpdateSelectBord(SceneItem_pb.EGEMTYPE_SKILL)
  end)
  self.skillToggle = skillTabGO:GetComponent(UIToggle)
end
local rotate180Func = function(angle)
  if not angle.z then
    return
  end
  angle.z = (angle.z + 180) % 360
end
function GemEmbedPage:InitSelectBordFilterCtrls()
  self.selectBordAttributeCtrl = self:FindGO("AttributeCtrl", self.selectBord)
  self.selectBordSkillCtrl = self:FindGO("SkillCtrl", self.selectBord)
  self.attributeLvSortOrderTrans = self:FindGO("SortOrder", self.selectBord).transform
  isAttributeSortOrderDescending = true
  self:AddButtonEvent("AttributeLvSort", function()
    isAttributeSortOrderDescending = not isAttributeSortOrderDescending
    self:ChangeLocalEulerAnglesOfTrans(self.attributeLvSortOrderTrans, rotate180Func)
    self:TryUpdateSelectBord(SceneItem_pb.EGEMTYPE_ATTR)
  end)
  GemProxy.TryInitFilterPopOfView(self, "AttributeFilterPop", function()
    self:TryUpdateSelectBord(SceneItem_pb.EGEMTYPE_ATTR)
  end, GemAttributeFilter)
  GemProxy.TryInitFilterPopOfView(self, "SkillClassFilterPop", function()
    self:TryUpdateSelectBord(SceneItem_pb.EGEMTYPE_SKILL)
  end, GemSkillQualityFilter, GemSkillQualityFilterData)
  GemProxy.TryAddFavoriteFilterToFilterPop(self.AttributeFilterPop)
  GemProxy.TryAddFavoriteFilterToFilterPop(self.SkillClassFilterPop)
end
function GemEmbedPage:InitGemPage()
  GemEmbedPage.super.InitGemPage(self)
  self.gemPage:AddEventListener(ItemEvent.GemDragStart, self.OnPageGemDragStart, self)
  self.gemPage:AddEventListener(ItemEvent.GemDragEnd, self.OnPageGemDragEnd, self)
end
function GemEmbedPage:InitCollider()
  local colliderGO = self:FindGO("Collider")
  self:AddClickEvent(colliderGO, function()
    self:OnBordGemDragEnd()
    self:OnClickCollider()
  end)
  local gestureComp = colliderGO:GetComponent(InputGesture)
  function gestureComp.zoomInAction()
    self:SetPageZoom(true)
  end
  function gestureComp.zoomOutAction()
    self:SetPageZoom(false)
  end
  local colliderLongPress = colliderGO:GetComponent(UILongPress)
  if colliderLongPress then
    colliderLongPress.pressTime = 0.05
    function colliderLongPress.pressEvent(comp, isPress)
      if not self.isPageZoomIn then
        return
      end
      if isPress then
        self.lastDragPosX, self.lastDragPosY = LuaGameObject.GetMousePosition()
        tickManager:CreateTick(0, 16, self.UpdateGemPagePos, self)
      else
        tickManager:ClearTick(self)
        self.lastDragPosX, self.lastDragPosY = nil, nil
      end
    end
  else
    LogUtility.Warning("Cannot get long press component of the Collider!")
  end
end
function GemEmbedPage:InitNewProfitBord()
  self.profitBord = self:FindGO("NewProfitBord")
  local closeBtn = self:FindGO("CloseBordBtn", self.profitBord)
  self:AddClickEvent(closeBtn, function()
    self.profitBord:SetActive(false)
  end)
  self.skillGemTable = self:FindComponent("SkillGemContainer", UITable, self.profitBord)
  self.attrGemTable = self:FindComponent("AttrGemContainer", UITable, self.profitBord)
  self:Hide(self.attrGemTable)
  self.profitLeftListCtrl = ListCtrl.new(self.skillGemTable, GemSkillProfitCell, "GemSkillPlayerDetailCell")
  self.profitRightListCtrl = ListCtrl.new(self.attrGemTable, GemAttributeProfitCell, "GemAttributePlayerDetailCell")
  self.gemTogRoot = self:FindGO("GemTogRoot")
  self.skillGemTog = self:FindGO("SkillGemTog", self.gemTogRoot)
  self.skillGemTogLab1 = self:FindComponent("Label1", UILabel, self.skillGemTog)
  self.skillGemTogLab2 = self:FindComponent("Label2", UILabel, self.skillGemTog)
  self.skillGemTogLab1.text = ZhString.Gem_SkillGemCountLabel
  self.skillGemTogLab2.text = ZhString.Gem_SkillGemCountLabel
  self:AddClickEvent(self.skillGemTog, function()
    self:Show(self.skillGemTable)
    self:Hide(self.attrGemTable)
    self.profitLeftListCtrl:ResetPosition()
  end)
  self.attrGemTog = self:FindGO("AttrGemTog", self.gemTogRoot)
  self.attrGemTogLab1 = self:FindComponent("Label1", UILabel, self.attrGemTog)
  self.attrGemTogLab2 = self:FindComponent("Label2", UILabel, self.attrGemTog)
  self.attrGemTogLab1.text = ZhString.Gem_AttributeGemCountLabel
  self.attrGemTogLab2.text = ZhString.Gem_AttributeGemCountLabel
  self:AddClickEvent(self.attrGemTog, function()
    self:Hide(self.skillGemTable)
    self:Show(self.attrGemTable)
    self.profitRightListCtrl:ResetPosition()
  end)
  self:InitHeroSkill()
end
function GemEmbedPage:InitHelpButton()
  local go = self:FindGO("HelpBtn")
  go:SetActive(true)
  self:AddClickEvent(go, function()
    self:OpenHelpView(Table_Help[1006])
  end)
end
function GemEmbedPage:InitDraggingTip()
  self.draggingTip = self:LoadPreferb("tip/GemEmbedOperationTip", self.gameObject)
  self.draggingTipTrans = self.draggingTip.transform
  self.draggingTipLabel = self.draggingTip:GetComponent(UILabel)
  self.draggingTip:SetActive(false)
end
function GemEmbedPage:_OnActivate()
  self.isPageZoomIn = false
  self.selectBord:SetActive(false)
  self.profitBord:SetActive(false)
  self.zoomBtnSp.spriteName = "com_icon_enlarge2"
  self:SetDownCtrlMode(GemEmbedPage.DownCtrlMode.DragTip)
  self:SetNameTipShow(true)
end
function GemEmbedPage:OnClickListCell(cellCtl)
  if not cellCtl or not cellCtl.data then
    return
  end
  self.chooseSelectBordCellData = cellCtl.data
  self:UpdateSelectBordCellChoose()
  if not self.gemTipCellGO.activeInHierarchy then
    self:ChangeLocalPositionOfTrans(self.gemTipCellGO.transform, function(pos)
      pos.x = gemTipCellAsidePosX
    end)
  end
  self:ShowGemTipWith(cellCtl.data, GemEmbedPage.GetSameNameEmbeddedSkillGem)
  cellCtl:TryClearNewTag()
end
function GemEmbedPage:_OnClickPageCell(cellCtl)
  self:SetDownCtrlMode(GemEmbedPage.DownCtrlMode.DragTip)
  local data = cellCtl.data
  if self.isPageAside then
    if data then
      if self.gemTipCellGO.activeInHierarchy then
        self:ShowGemTipWith(data)
        local isSelectBordActive = self.selectBord.activeInHierarchy
        self:SetDownCtrlMode(isSelectBordActive and GemEmbedPage.DownCtrlMode.DragTip or GemEmbedPage.DownCtrlMode.GemCtrl)
      elseif self.selectBord.activeInHierarchy then
        self:ChangeLocalPositionOfTrans(self.gemTipCellGO.transform, function(pos)
          pos.x = gemTipCellAsidePosX
        end)
        self:ShowGemTipWith(data)
      else
        self:OpenSelectBord()
      end
    elseif not self.selectBord.activeInHierarchy then
      self:SetPageAside(false)
      self:SetDownCtrlMode(GemEmbedPage.DownCtrlMode.EmbedBtn)
    else
      self:OpenSelectBord()
    end
    return
  end
  self:SetDownCtrlMode(data and GemEmbedPage.DownCtrlMode.GemCtrl or GemEmbedPage.DownCtrlMode.EmbedBtn)
  if data then
    self:ResetGemTipCellPos()
    self:ShowGemTipWith(data)
    self:SetPageAside(true)
  end
end
function GemEmbedPage:OnPageGemDragStart(cellCtl)
  self:OnBordGemDragStart(cellCtl)
  self.hoveredObject = UICamera.hoveredObject
  tickManager:CreateTick(0, 16, self.UpdatePageGemDrag, self)
end
function GemEmbedPage:OnPageGemDragEnd(cellCtl)
  self:OnBordGemDragEnd(cellCtl)
  tickManager:ClearTick(self)
  self.hoveredObject = nil
  self:ShowDraggingTip()
end
function GemEmbedPage:OnBordGemDragStart(cellCtl)
  self:ShowGemTipWith()
end
function GemEmbedPage:OnBordGemDragEnd(cellCtl)
  if not self.selectBord or not self.selectBord.activeInHierarchy then
    self:OnClickCollider()
    self:SetPageAside(false)
  end
end
function GemEmbedPage:OnPageGemHoverOver(cellCtl)
  local dragCell = DragCursorPanel.Instance:GetCell(GemCell)
  local data, dragData = dragCell and cellCtl.data, dragCell.data
  if data and dragData and data.id == dragData.id then
    self:ShowDraggingTip()
    return
  end
  local isSameType = GemProxy.CheckContainsGemSkillData(dragData) and cellCtl.__cname == "GemPageSkillCell" or GemProxy.CheckContainsGemAttrData(dragData) and cellCtl.__cname == "GemPageAttributeCell"
  if not isSameType then
    return
  end
  self:ShowDraggingTip(data and ZhString.Gem_PageDraggingTipTextSwitch or ZhString.Gem_PageDraggingTipTextMove)
end
function GemEmbedPage:OnPageGemHoverOut(cellCtl)
  self:ShowDraggingTip(ZhString.Gem_PageDraggingTipTextRemove)
end
function GemEmbedPage:OnGemUpdate()
  self.gemPage:Update()
  self:TryUpdateSelectBord()
end
function GemEmbedPage:OnGemPageUpdate()
  self.gemPage:Update()
  self.choosePageCell = nil
  self:ShowGemTipWith()
end
function GemEmbedPage:OnEmbed(note)
  local isSuccess = note and note.body and note.body.success
  if not isSuccess then
    return
  end
  self.gemPage:SetNewEmbedCellId(note.body.pos)
end
function GemEmbedPage:OnRemove(note)
  local isSuccess = note and note.body and note.body.success
  if not isSuccess then
    return
  end
  self:SetPageAside(false)
end
function GemEmbedPage:OnClickCollider()
  self:SetDownCtrlMode(GemEmbedPage.DownCtrlMode.DragTip)
  if self.choosePageCell then
    self.choosePageCell:SetChoose(false)
    self.choosePageCell = nil
  end
  if self.selectBord.activeInHierarchy and self.gemTipCellGO.activeInHierarchy then
    self:ShowGemTipWith()
  end
end
function GemEmbedPage:CloseGemTipCell()
  if self.selectBord.activeInHierarchy then
    self:ShowGemTipWith()
  else
    self:SetPageAside(false)
  end
end
function GemEmbedPage:ShowGemTipWith(tipData, dataToCompareGetter)
  GemEmbedPage.super.ShowGemTipWith(self, tipData)
  local dataToCompare = dataToCompareGetter and dataToCompareGetter(tipData)
  self.gemTipCellForCompareGO:SetActive(tipData and dataToCompare and true or false)
  if dataToCompare then
    self.gemTipCellForCompare:SetData(dataToCompare)
  end
end
local skillComparer = function(l, r)
  local comp = GemProxy.PredicateComparer(l, r, GemProxy.CheckIsFavorite)
  if comp ~= nil then
    return comp
  end
  return GemProxy.BasicComparer(l, r)
end
local attributeComparer = function(l, r)
  local comp1 = GemProxy.PredicateComparer(l, r, GemProxy.CheckIsFavorite)
  if comp1 ~= nil then
    return comp1
  end
  return GemProxy.GetAttributeItemDataLevelComparer(isAttributeSortOrderDescending)(l, r)
end
function GemEmbedPage:TryUpdateSelectBord(gemType)
  if not self.selectBord.activeInHierarchy then
    return
  end
  self.selectBordAttributeCtrl:SetActive(false)
  self.selectBordSkillCtrl:SetActive(false)
  self.currentSelectBordGemType = gemType or self:GetGemTypeOfChoosePageCell() or self.currentSelectBordGemType or SceneItem_pb.EGEMTYPE_SKILL
  local noneTipText, gems = "", nil
  if self.currentSelectBordGemType == SceneItem_pb.EGEMTYPE_SKILL then
    gems = GemProxy.GetSkillItemDataByFilterDatasOfView(self, MyselfProxy.Instance:GetMyProfession())
    table.sort(gems, skillComparer)
    self.selectBordSkillCtrl:SetActive(true)
    noneTipText = ZhString.Gem_PageNoSkillSelectBordCellTip
    self.skillToggle.value = true
  elseif self.currentSelectBordGemType == SceneItem_pb.EGEMTYPE_ATTR then
    gems = GemProxy.GetAttributeItemDataByFilterDatasOfView(self)
    table.sort(gems, attributeComparer)
    self.selectBordAttributeCtrl:SetActive(true)
    noneTipText = ZhString.Gem_PageNoSelectBordCellTip
    self.attributeToggle.value = true
  else
    LogUtility.Error("There's no way executing here nevertheless I leave the log to close an issue.")
    return
  end
  GemProxy.RemoveEmbedded(gems)
  self.selectBordContainer:SetActive(#gems > 0)
  self.noneTip:SetActive(#gems <= 0)
  self.noneTipLabel.text = noneTipText
  self.listCtrl:ResetDatas(gems, true)
  self:ClearSelectBordCellChoose()
end
function GemEmbedPage:TryUpdateProfitBord()
  self:TryUpdateHeroSkill()
  self.profitLeftListCtrl:ResetDatas(self.gemPage:GetPageSkillItemDatas())
  local cells = self.profitLeftListCtrl:GetCells()
  for _, c in pairs(cells) do
    c:UpdateInvalidByGemPageData(self.gemPage.pageData)
  end
  self.profitRightListCtrl:ResetDatas(GemProxy.GetDescNameValueDataFromAttributeItemDatas(self.gemPage:GetPageAttributeItemDatas()))
  tickManager:CreateOnceDelayTick(33, function()
    if not self or not self.profitLeftListCtrl then
      return
    end
    self.profitLeftListCtrl:ResetPosition()
    self.profitRightListCtrl:ResetPosition()
  end, self)
end
function GemEmbedPage:InitHeroSkill()
  self.heroSkillInfoRoot = self:FindGO("HeroSkillInfoRoot", self.skillGemTable.gameObject)
  self.heroTitleLab = self:FindComponent("TitleLab", UILabel, self.heroSkillInfoRoot)
  self.heroFeatureLvLab = self:FindComponent("LvLab", UILabel, self.heroTitleLab.gameObject)
  self.heroTitleBg = self:FindComponent("TitleBg", UISprite, self.heroTitleLab.gameObject)
  self.heroTitleBgHeight = self.heroTitleBg.height
  self.heroSkillNameLab = self:FindComponent("SkillNameLab", UILabel, self.heroSkillInfoRoot)
  self.heroDescLab = self:FindComponent("SkillDescLab", UILabel, self.heroSkillInfoRoot)
  local myPro = MyselfProxy.Instance:GetMyProfession()
  if not ProfessionProxy.IsHero(myPro) then
    self:Hide(self.heroLvLab)
    return
  end
  local familyId = Table_Class[myPro] and Table_Class[myPro].FeatureSkill
  if not familyId then
    self:Hide(self.heroLvLab)
    return
  end
  self.heroSkillFamilyId = familyId
  self.maxHeroFeatureLv = ProfessionProxy.Instance:GetMaxHeroFeatureLv()
  self:UpdateHeroLv()
end
function GemEmbedPage:TryUpdateHeroSkill()
  if self.heroSkillFamilyId then
    self:Show(self.heroSkillInfoRoot)
    self.heroFeatureLv = self.gemPage:GetHeroFeatureLv()
    local featureLv = self.heroSkillFamilyId * 1000 + self.heroFeatureLv
    self.heroSkillStaticData = Table_Skill[featureLv]
    self:Show(self.heroLvLab)
    self.heroLvLab.text = self.heroFeatureLv .. "/" .. self.maxHeroFeatureLv
    self.heroTitleLab.text = ZhString.Gem_HeroProfessionTitle
    self.heroFeatureLvLab.text = tostring(self.heroFeatureLv) .. "/" .. self.maxHeroFeatureLv
    self.heroSkillNameLab.text = string.format(ZhString.Gem_HeroSkillName, self.heroSkillStaticData.NameZh)
    self.heroDescLab.text = SkillTip:GetHeroDesc(self.heroSkillStaticData, self.heroFeatureLv)
    self.heroTitleBg.height = self.heroTitleBgHeight + self.heroDescLab.height
  else
    self:Hide(self.heroSkillInfoRoot)
  end
end
function GemEmbedPage:UpdateHeroLv()
  if not self.heroSkillFamilyId then
    return
  end
  self:Show(self.heroLvLab)
  self.heroFeatureLv = Game.Myself.data:GetLernedSkillLevel(self.heroSkillFamilyId)
  self.heroLvLab.text = self.heroFeatureLv .. "/" .. self.maxHeroFeatureLv
end
function GemEmbedPage:OpenSelectBord()
  self:ShowGemTipWith()
  self.selectBord:SetActive(true)
  self:TryUpdateSelectBord()
  self:SetPageAside(true)
end
function GemEmbedPage:UpdateGemPagePos()
  posX, posY = LuaGameObject.GetMousePosition()
  if posX == self.lastDragPosX and posY == self.lastDragPosY then
    return
  end
  local pageLocalPos = LuaGeometry.TempGetLocalPosition(self.gemPageTrans)
  pageLocalPos.x = pageLocalPos.x + (posX - self.lastDragPosX) / Screen.width * self.uiScreenSizeX
  pageLocalPos.y = pageLocalPos.y + (posY - self.lastDragPosY) / Screen.height * self.uiScreenSizeY
  self:ClampSet(pageLocalPos)
  self.gemPageTrans.localPosition = pageLocalPos
  self.lastDragPosX, self.lastDragPosY = posX, posY
end
function GemEmbedPage:UpdatePageGemDrag()
  local hoveredObject = UICamera.hoveredObject
  if not isNull(hoveredObject) then
    local hoverObjName, oldHoverObjName = hoveredObject.name, self.hoveredObject.name
    if hoverObjName ~= oldHoverObjName then
      local hoverCell, oldHoverCell = self.gemPage:GetCellById(hoverObjName), self.gemPage:GetCellById(oldHoverObjName)
      if not hoverCell and oldHoverCell then
        self:OnPageGemHoverOut(oldHoverCell)
      elseif hoverCell and not oldHoverCell then
        self:OnPageGemHoverOver(hoverCell)
      end
    end
    self.hoveredObject = hoveredObject
  end
end
function GemEmbedPage:SetNameTipShow(isShow)
  if isShow == nil then
    self.isNameTipShown = not self.isNameTipShown
  elseif self.isNameTipShown == isShow then
    return
  else
    self.isNameTipShown = isShow
  end
  if not self.gemPage then
    LogUtility.Warning("Cannot find GemPage")
    return
  end
  self.gemPage:SetShowNameTips(self.isNameTipShown)
  self.showBtnSp.spriteName = self.isNameTipShown and "com_icon_hide" or "com_icon_show"
end
function GemEmbedPage:SetPageAside(isAside)
  GemEmbedPage.super.SetPageAside(self, isAside)
  self:DoDefaultPositionTween(self.downCtrlParent.gameObject, LuaGeometry.GetTempVector3(self.newPageLocalPos.x))
  if not self.isPageAside then
    self.selectBord:SetActive(false)
    self:ClearSelectBordCellChoose()
  end
end
function GemEmbedPage:SetPageZoom(isZoomIn)
  if isZoomIn == nil then
    self.isPageZoomIn = not self.isPageZoomIn
  elseif self.isPageZoomIn == isZoomIn then
    return
  else
    self.isPageZoomIn = isZoomIn
  end
  if not self.gemPage then
    LogUtility.Warning("Cannot find GemPage")
    return
  end
  self.zoomBtnSp.spriteName = self.isPageZoomIn and "com_icon_narrow2" or "com_icon_enlarge2"
  local factor = self.isPageZoomIn and pageZoomInScaleFactor or pageZoomOutScaleFactor
  local t1 = TweenScale.Begin(self.gemPage.gameObject, GemEmbedPreviewPage.TweenDuration, LuaGeometry.GetTempVector3(factor, factor, factor))
  t1.method = 2
  if not self.isPageZoomIn then
    local t2 = TweenPosition.Begin(self.gemPage.gameObject, GemEmbedPreviewPage.TweenDuration, LuaGeometry.GetTempVector3(self.newPageLocalPos.x, 0, 0))
    t2.method = 2
  end
end
function GemEmbedPage:SetDownCtrlMode(mode)
  local _Mode = GemEmbedPage.DownCtrlMode
  self.dragTip:SetActive(mode == _Mode.DragTip)
  self.embedBtn:SetActive(mode == _Mode.EmbedBtn)
  self.gemCtrlParent:SetActive(mode == _Mode.GemCtrl)
end
function GemEmbedPage:UpdateSelectBordCellChoose()
  local chooseId = self.chooseSelectBordCellData and self.chooseSelectBordCellData.id or 0
  for _, cell in pairs(self.listCells) do
    cell:SetChoose(chooseId)
  end
end
function GemEmbedPage:ClearSelectBordCellChoose()
  self.chooseSelectBordCellData = nil
  self:UpdateSelectBordCellChoose()
end
function GemEmbedPage:ShowDraggingTip(text, localPosX, localPosY, localPosZ, localScale)
  if not text then
    self.draggingTipTrans:SetParent(self.trans)
    self.draggingTip:SetActive(false)
    return
  end
  local dragCell = DragCursorPanel.Instance:GetCell(GemCell)
  if not dragCell then
    LogUtility.Warning("Cannot get dragging GemCell. The dragging tip won't be showed.")
    return
  end
  self.draggingTipLabel.text = text
  self.draggingTipTrans:SetParent(dragCell.trans)
  self.draggingTipTrans.localPosition = LuaGeometry.GetTempVector3(localPosX or draggingTipLocalPosX, localPosY or draggingTipLocalPosY, localPosZ)
  localScale = localScale or 1
  self.draggingTipTrans.localScale = LuaGeometry.GetTempVector3(localScale, localScale, localScale)
  self.draggingTip:SetActive(true)
end
function GemEmbedPage:TryEmbed()
  if self.gemTipCellForCompareGO.activeInHierarchy then
    local dataToCompare = self.gemTipCellForCompare.data
    self.choosePageCell = self.gemPage.skillCellMap[dataToCompare and dataToCompare.gemSkillData.pos]
  end
  if not self.choosePageCell then
    MsgManager.FloatMsg(nil, ZhString.Gem_PageSelectBtnInvalidTip)
    return
  end
  if not self.choosePageCell.available then
    MsgManager.FloatMsg(nil, ZhString.Gem_PageCellUnavailableTip)
    return
  end
  local gemType = self:GetGemTypeOfChoosePageCell()
  if not gemType or not self.chooseSelectBordCellData or not self.chooseSelectBordCellData.id or self.chooseSelectBordCellData.id == 0 then
    MsgManager.FloatMsg(nil, ZhString.Gem_PageNoChooseBordCellTip)
    return
  end
  if self.currentSelectBordGemType and gemType ~= self.currentSelectBordGemType then
    MsgManager.FloatMsg(nil, gemType == SceneItem_pb.EGEMTYPE_ATTR and ZhString.Gem_PageSkillCellNotChooseTip or ZhString.Gem_PageAttrCellNotChooseTip)
    return
  end
  if not GemProxy.Instance:CheckIfCanReplaceSameName(self.chooseSelectBordCellData, self.choosePageCell.id) then
    MsgManager.ShowMsgByID(36006)
    return
  end
  GemProxy.CallEmbed(gemType, self.chooseSelectBordCellData.id, self.choosePageCell.id)
end
function GemEmbedPage:GetGemTypeOfChoosePageCell()
  if not self.choosePageCell then
    return
  end
  return self.choosePageCell.__cname == "GemPageSkillCell" and SceneItem_pb.EGEMTYPE_SKILL or SceneItem_pb.EGEMTYPE_ATTR
end
function GemEmbedPage:AddButtonEvent(name, event)
  GemEmbedPage.super.super.super.AddButtonEvent(self, name, event)
end
function GemEmbedPage.GetSameNameEmbeddedSkillGem(itemData)
  if not GemProxy.CheckContainsGemSkillData(itemData) then
    return
  end
  return GemProxy.Instance:GetSameNameEmbedded(itemData)
end
function GemEmbedPage.RecordManualEndDragTime()
  GemEmbedPage.ManualEndDragTime = ServerTime.CurClientTime()
end
function GemEmbedPage.ClearManualEndDragTime()
  GemEmbedPage.ManualEndDragTime = nil
end
function GemEmbedPage.GetNowManualEndDragInterval()
  return ServerTime.CurClientTime() - GemEmbedPage.ManualEndDragTime
end
