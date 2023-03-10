AdventurePanel = class("AdventurePanel", ContainerView)
AdventurePanel.ViewType = UIViewType.NormalLayer
autoImport("AdventureCategoryCell")
autoImport("AdventureHomePage")
autoImport("AdventureResearchPage")
autoImport("AdventureItemNormalListPage")
autoImport("BeautifulAreaPhotoNetIngManager")
autoImport("AdventureAchievementPage")
autoImport("AdventureFoodPage")
autoImport("AdventureNpcListPage")
autoImport("AdventureTabItemListPage")
autoImport("PopupGridList")
AdventurePanel.Category = GameConfig.AdventureCategoryConfig
AdventurePanel.ClosePanel = "AdventurePanel_ClosePanel"
AdventurePanel.NoItemStage = "AdventurePanel_NoItemStage"
function AdventurePanel:GetShowHideMode()
  return PanelShowHideMode.MoveOutAndMoveIn
end
function AdventurePanel:Init()
  AdventurePanel.super.Init(self)
  self:initView()
  self:AddListenEvt(AdventurePanel.ClosePanel, self.CloseSelf)
  self:AddListenEvt(AdventurePanel.NoItemStage, self.noItemStage)
end
function AdventurePanel:OnEnter()
  Game.PerformanceManager:SkinWeightHigh(true)
  self.super.OnEnter(self)
  self:initData()
  BeautifulAreaPhotoNetIngManager.Ins():OnSwitchOn()
  self:RegistRedTip()
  self:resetCategory()
  self.bgTex = self:FindComponent("bgTexture", UITexture)
  self.bgTexName = "bg_view_1"
  if self.bgTex then
    PictureManager.Instance:SetUI(self.bgTexName, self.bgTex)
    PictureManager.ReFitFullScreen(self.bgTex, 1)
  end
  Game.PerformanceManager:LODHigh()
end
function AdventurePanel:RegistRedTip()
  if self.redData then
    for i = 1, #self.redData do
      local single = self.redData[i]
      self:RegisterRedTipCheck(single.id, single.obj, single.depth, single.offset)
    end
  end
end
function AdventurePanel:OnExit()
  Game.PerformanceManager:SkinWeightHigh(false)
  BeautifulAreaPhotoNetIngManager.Ins():OnSwitchOff()
  self.currentKey = nil
  if self.bgTex then
    PictureManager.Instance:UnLoadUI(self.bgTexName, self.bgTex)
  end
  Game.PerformanceManager:ResetLOD()
  if self.redData then
    self:UnRegisterRedTipChecks()
  end
  AdventurePanel.super.OnExit(self)
end
function AdventurePanel:OnDestroy()
  self.categoryList:Destroy()
  AdventurePanel.super.OnDestroy(self)
end
function AdventurePanel:handleRegistRedTip(data)
end
function AdventurePanel:initView()
  self.tsfPageParent = self:FindGO("rightContent").transform
  self.adventureHomePage = self:AddSubView("AdventureHomePage", AdventureHomePage)
  self.itemListPage = self:AddSubView("SceneryNormalListPage", AdventureItemNormalListPage)
  self.researchPage = self:AddSubView("AdventureResearchPage", AdventureResearchPage)
  self.achievePage = self:AddSubView("AdventureAchievementPage", AdventureAchievementPage)
  self.adventureFoodPage = self:AddSubView("AdventureFoodPage", AdventureFoodPage)
  self.npcListPage = self:AddSubView("AdventureNpcListPage", AdventureNpcListPage)
  self.tabItemListPage = self:AddSubView("AdventureTabItemListPage", AdventureTabItemListPage)
  local CategoryListTable = self:FindGO("categoryList"):GetComponent(UIGrid)
  self.categoryList = UIGridListCtrl.new(CategoryListTable, AdventureCategoryCell, "AdventureCategoryCell")
  self.categorSv = self:FindComponent("ScrollView", UIScrollView, self:FindGO("toggles"))
  local noItemTip = self:FindGO("NoItemTips")
  self.leftNoItemTip = self:FindGO("leftTip", noItemTip)
  local leftNoItemTipLable = self:FindComponent("Label", UILabel, self.leftNoItemTip)
  leftNoItemTipLable.text = ZhString.AdventurePanel_NoItemLabel
  self.rightNoItemTip = self:FindGO("rightTip", noItemTip)
  local rightNoItemTipLable = self:FindComponent("Label", UILabel, self.rightNoItemTip)
  rightNoItemTipLable.text = ZhString.AdventurePanel_NoItemLabel
  self.leftNoItemTip.gameObject:SetActive(false)
  self.rightNoItemTip.gameObject:SetActive(false)
  self.share = self:FindGO("ShareButton")
  self:AddClickEvent(self.share, function()
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.AdventureShareView,
      viewdata = {}
    })
  end)
  self:Hide(self.share)
end
function AdventurePanel:noItemStage(data)
  local _stage = data.body
  local _noItemTipStageType = AdventureDataProxy.NoItemTipStageType
  if _stage == _noItemTipStageType.ShowLeft then
    self.leftNoItemTip.gameObject:SetActive(true)
    self.rightNoItemTip.gameObject:SetActive(false)
  elseif _stage == _noItemTipStageType.ShowRight then
    self.leftNoItemTip.gameObject:SetActive(false)
    self.rightNoItemTip.gameObject:SetActive(true)
  elseif _stage == _noItemTipStageType.ShowAll then
    self.leftNoItemTip.gameObject:SetActive(true)
    self.rightNoItemTip.gameObject:SetActive(true)
  else
    self.leftNoItemTip.gameObject:SetActive(false)
    self.rightNoItemTip.gameObject:SetActive(false)
  end
end
function AdventurePanel:initData()
  local list = {}
  for k, v in pairs(AdventureDataProxy.Instance.categoryDatas) do
    if v.staticData then
      local menuId = v.staticData.MenuID
      if v.staticData.Position and v.staticData.Position > 1 and (menuId and FunctionUnLockFunc.Me():CheckCanOpen(menuId) or not menuId) then
        table.insert(list, v)
      end
    end
  end
  table.sort(list, function(l, r)
    return l.staticData.Order < r.staticData.Order
  end)
  self.categoryList:ResetDatas(list)
  local cells = self.categoryList:GetCells()
  self.redData = {}
  for i = 1, #cells do
    local singleCell = cells[i]
    self:AddTabChangeEvent(singleCell.gameObject, nil, singleCell)
    local redTipIds = AdventureDataProxy.Instance:getRidTipsByCategoryId(singleCell.data.staticData.id)
    for j = 1, #redTipIds do
      local single = redTipIds[j]
      local data = {}
      data.id = single
      data.obj = singleCell.icon
      data.offset = {-5, -5}
      data.depth = singleCell.icon.depth + 60
      table.insert(self.redData, data)
    end
  end
end
function AdventurePanel:resetCategory()
  local cells = self.categoryList:GetCells()
  if cells and #cells > 0 then
    if self.viewdata.viewdata.achieveData then
      for i = 1, #cells do
        if cells[i].data.staticData.id == SceneManual_pb.EMANUALTYPE_ACHIEVE then
          self:TabChangeHandler(cells[i])
          break
        end
      end
    elseif self.tabId then
      for i = 1, #cells do
        if cells[i].data.staticData.id == self.tabId then
          self:TabChangeHandler(cells[i])
          break
        end
      end
    else
      self:TabChangeHandler(cells[1])
    end
    for i = 1, #cells do
      if cells[i].data.staticData.id == SceneManual_pb.EMANUALTYPE_ACHIEVE then
        local exist = self:CheckCatagoryJump()
        if exist then
          local panel = self.categorSv.panel
          local bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform, cells[i].gameObject.transform)
          local offset = panel:CalculateConstrainOffset(bound.min, bound.max)
          offset = Vector3(0, offset.y, 0)
          self.categorSv:MoveRelative(offset)
          return
        end
      end
    end
  end
  self:adjustItemPos()
end
function AdventurePanel:CheckCatagoryJump()
  local questData = QuestProxy.Instance:GetQuestDataBySameQuestID(99070002)
  if questData then
    return true
  end
  return false
end
function AdventurePanel:TabChangeHandler(cell)
  if self.currentKey ~= cell then
    AdventurePanel.super.TabChangeHandler(self, cell)
    self:handleCategoryClick(cell)
    self.currentKey = cell
  elseif self.curActivePage and self.curActivePage.JumpToFirstClickableItem and not BackwardCompatibilityUtil.CompatibilityMode_V40 then
    self.curActivePage:JumpToFirstClickableItem(true)
  end
end
function AdventurePanel:addListEventListener()
end
function AdventurePanel:handleCategorySelect(data)
  self.leftNoItemTip.gameObject:SetActive(false)
  self.rightNoItemTip.gameObject:SetActive(false)
  self:Hide(self.share)
  if data.staticData.id == SceneManual_pb.EMANUALTYPE_HOMEPAGE then
    self.adventureHomePage:Show()
    self:Show(self.share)
    self.adventureFoodPage:Hide()
    self.itemListPage:Hide()
    self.tabItemListPage:Hide()
    self.researchPage:Hide()
    self.achievePage:Hide()
    self.npcListPage:Hide()
    self.curActivePage = self.adventureHomePage
  elseif data.staticData.id == SceneManual_pb.EMANUALTYPE_ACHIEVE then
    self.researchPage:Hide()
    self.adventureFoodPage:Hide()
    self.adventureHomePage:Hide()
    self.itemListPage:Hide()
    self.npcListPage:Hide()
    self.tabItemListPage:Hide()
    self.achievePage:ShowSelf(self.viewdata.viewdata.achieveData)
    self.viewdata.viewdata.achieveData = nil
    self.curActivePage = self.achievePage
  elseif data.staticData.id == SceneManual_pb.EMANUALTYPE_RESEARCH then
    self.adventureFoodPage:Hide()
    self.adventureHomePage:Hide()
    self.itemListPage:Hide()
    self.tabItemListPage:Hide()
    self.achievePage:Hide()
    self.npcListPage:Hide()
    self.researchPage:ShowSelf()
    self.curActivePage = self.researchPage
  elseif data.staticData.id == 18 then
    self.adventureFoodPage:ShowSelf()
    self.adventureHomePage:Hide()
    self.itemListPage:Hide()
    self.tabItemListPage:Hide()
    self.achievePage:Hide()
    self.researchPage:Hide()
    self.npcListPage:Hide()
    self.curActivePage = self.adventureFoodPage
  elseif data.staticData.id == SceneManual_pb.EMANUALTYPE_NPC or data.staticData.id == SceneManual_pb.EMANUALTYPE_MONSTER then
    self.adventureFoodPage:Hide()
    self.adventureHomePage:Hide()
    self.itemListPage:Hide()
    self.achievePage:Hide()
    self.researchPage:Hide()
    self.tabItemListPage:Hide()
    self.npcListPage:Show()
    self.npcListPage:setCategoryData(data)
    self.curActivePage = self.npcListPage
  elseif data.staticData.id == SceneManual_pb.EMANUALTYPE_PET then
    self.adventureFoodPage:Hide()
    self.itemListPage:Hide()
    self.researchPage:Hide()
    self.adventureHomePage:Hide()
    self.achievePage:Hide()
    self.npcListPage:Hide()
    self.tabItemListPage:Show()
    self.tabItemListPage:setCategoryData(data)
    self.curActivePage = self.tabItemListPage
  else
    self.adventureFoodPage:Hide()
    self.tabItemListPage:Hide()
    self.researchPage:Hide()
    self.adventureHomePage:Hide()
    self.achievePage:Hide()
    self.npcListPage:Hide()
    self.itemListPage:Show()
    self.itemListPage:setCategoryData(data)
    self.curActivePage = self.itemListPage
  end
  if self.curActivePage and self.curActivePage.JumpToFirstClickableItem and not BackwardCompatibilityUtil.CompatibilityMode_V40 then
    self.curActivePage:JumpToFirstClickableItem()
  end
end
function AdventurePanel:handleCategoryClick(child)
  self:handleCategorySelect(child.data)
  local cells = self.categoryList:GetCells()
  for i = 1, #cells do
    local single = cells[i]
    if single == child then
      single:setIsSelected(true)
    else
      single:setIsSelected(false)
    end
  end
end
function AdventurePanel:adjustItemPos()
  self.categorSv:ResetPosition()
end
function AdventurePanel:getSubPageParent()
  return self.tsfPageParent
end
function AdventurePanel.OpenAchievePageById(achieveId)
  local type = AdventureAchieveProxy.Instance:getTopCategoryIdByAchiveId(achieveId)
  if type then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.AdventurePanel,
      viewdata = {
        achieveData = {type = type, id = achieveId}
      }
    })
  else
    helplog("can't find type:", achieveId)
  end
end
function AdventurePanel.OpenAchievePage(type, achieveId)
  if Table_Achievement[type] and Table_Achievement[achieveId] then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.AdventurePanel,
      viewdata = {
        achieveData = {type = type, id = achieveId}
      }
    })
  end
end
