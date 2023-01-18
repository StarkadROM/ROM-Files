autoImport("ProfessionNewHeroIntroCell")
autoImport("ProfessionNewHeroTaskCell")
autoImport("ProfessionNewHeroStoryCell")
ProfessionNewHeroPage = class("ProfessionNewHeroPage", SubView)
ProfessionNewHeroPage.ViewType = UIViewType.NormalLayer
local inoutAnimDelay = 0.1
function ProfessionNewHeroPage:LoadView()
  local viewPath = ResourcePathHelper.UIView("ProfessionNewHeroPage")
  local obj = self:LoadPreferb_ByFullPath(viewPath, self.container, true)
  obj.name = "ProfessionNewHeroPage"
  self.gameObject = obj
end
function ProfessionNewHeroPage:Init()
  self:LoadView()
  self:FindObjs()
  self:AddEvts()
  self:AddMapEvts()
  self:SwitchToTab(1)
end
function ProfessionNewHeroPage:FindObjs()
  local anchorRight = self:FindGO("Anchor_Right")
  self.inoutTween = anchorRight:GetComponent(TweenAlpha)
  EventDelegate.Set(self.inoutTween.onFinished, function()
    self:OnInoutAnimFinished()
  end)
  local anchorBottom = self:FindGO("Anchor_Bottom")
  self.inoutTweenBottom = anchorBottom:GetComponent(TweenAlpha)
  self.heroIntroGO = self:FindGO("HeroIntro", anchorBottom)
  self.heroIntroCell = ProfessionNewHeroIntroCell.new(self.heroIntroGO)
  self.helpBtnGO = self:FindGO("HelpBtn")
  self:AddClickEvent(self.helpBtnGO, function()
    local helpData = Table_Help[PanelConfig.ProfessionNewHeroPage.id]
    if helpData then
      self:OpenHelpView(helpData)
    end
  end)
  self.tabs = {
    {
      go = self:FindGO("StoryTab")
    },
    {
      go = self:FindGO("TaskTab")
    }
  }
  for i, tab in ipairs(self.tabs) do
    tab.selectedGO = self:FindGO("Selected", tab.go)
    self:AddClickEvent(tab.go, function()
      self:SwitchToTab(i)
    end)
    break
  end
  local tabPanelGO = self:FindGO("TabPanels")
  self.taskPanel = self:FindGO("TaskPanel", tabPanelGO)
  self.storyPanel = self:FindGO("StoryPanel", tabPanelGO)
  self.tabPanels = {
    self.storyPanel,
    self.taskPanel
  }
  local taskTable = self:FindComponent("Container", UITable, self.taskPanel)
  self.taskListCtrl = ListCtrl.new(taskTable, ProfessionNewHeroTaskCell, "Profession/ProfessionNewHeroTaskCell")
  local storyScrollGO = self:FindGO("StoryScroll", self.storyPanel)
  local storyTable = self:FindComponent("Container", UITable, storyScrollGO)
  self.storyListCtrl = ListCtrl.new(storyTable, ProfessionNewHeroStoryCell, "Profession/ProfessionNewHeroStoryCell")
  self.listCtrls = {
    self.storyListCtrl,
    self.taskListCtrl
  }
  self.tabPanelUpdateFuncs = {
    self.UpdateStoryPanel,
    self.UpdateTaskPanel
  }
end
function ProfessionNewHeroPage:AddEvts()
end
function ProfessionNewHeroPage:AddMapEvts()
  self:AddListenEvt(ServiceEvent.SceneUser3HeroGrowthQuestInfo, self.UpdateView)
  self:AddListenEvt(ServiceEvent.SceneUser3HeroStoryQusetInfo, self.UpdateView)
  self:AddListenEvt(ServiceEvent.SceneUser3HeroStoryQuestAccept, self.UpdateView)
  self:AddListenEvt(ServiceEvent.SceneUser3HeroStoryQuestReward, self.UpdateView)
end
function ProfessionNewHeroPage:UpdateView()
  local lastSelectedTab = self.selectedTabIndex or 1
  self.selectedTabIndex = nil
  self:SwitchToTab(lastSelectedTab)
  self.heroIntroCell:SetData(HeroProfessionProxy.Instance:GetHeroIntro(self.selectedProfession))
end
function ProfessionNewHeroPage:SetProfession(newProfession)
  if not ProfessionProxy.IsHero(newProfession) then
    return
  end
  if self.selectedProfession == newProfession then
    return
  end
  self.selectedProfession = newProfession
  self.selectedTabIndex = nil
  self:SwitchToTab(1)
  HeroProfessionProxy.Instance:QueryHeroQuests(newProfession)
  HeroProfessionProxy.Instance:QueryHeroStories(newProfession)
end
function ProfessionNewHeroPage:SwitchToTab(tabIndex)
  if self.selectedTabIndex == tabIndex then
    return
  end
  if tabIndex == 2 and not ProfessionProxy.Instance:IsThisIdYiGouMai(self.selectedProfession) then
    MsgManager.ShowMsgByID(43247)
    return
  end
  if self.selectedTabIndex ~= nil then
    self:StopInoutAnim(true)
  end
  self.selectedTabIndex = tabIndex
  for i, tab in ipairs(self.tabs) do
    tab.selectedGO:SetActive(i == tabIndex)
  end
  for i, panel in ipairs(self.tabPanels) do
    panel:SetActive(i == tabIndex)
  end
  for i, func in ipairs(self.tabPanelUpdateFuncs) do
    if i == self.selectedTabIndex then
      func(self)
    end
  end
end
function ProfessionNewHeroPage:UpdateTaskPanel()
  local questDatas = HeroProfessionProxy.Instance:GetHeroQuestsByProfession(self.selectedProfession)
  self.taskListCtrl:ResetDatas(questDatas)
  local cells = self.taskListCtrl:GetCells()
  for i, cell in ipairs(cells) do
    cell:SetInoutAnimDelay((i - 1) * inoutAnimDelay)
  end
end
function ProfessionNewHeroPage:UpdateStoryPanel()
  local storyDatas = HeroProfessionProxy.Instance:GetHeroStories(self.selectedProfession)
  self.storyListCtrl:ResetDatas(storyDatas)
  local cells = self.storyListCtrl:GetCells()
  for i, cell in ipairs(cells) do
    cell:SetInoutAnimDelay((i - 1) * inoutAnimDelay)
  end
end
function ProfessionNewHeroPage:OnInoutAnimFinished()
  if self.inoutFinishCallback then
    self.inoutFinishCallback()
  end
end
function ProfessionNewHeroPage:StartInoutAnim(inOrOut, callback)
  local forward = inOrOut == 2 and true or false
  if not forward then
    self:UpdateView()
  end
  self.inoutFinishCallback = callback
  local ctl = self.listCtrls[self.selectedTabIndex]
  if ctl then
    local cells = ctl:GetCells()
    self.inoutAnimCount = #cells
    if self.inoutAnimCount == 0 then
      self:OnInoutAnimFinished()
    else
      for i, cell in ipairs(cells) do
        cell:PlayInoutAnim(inOrOut)
      end
      self.inoutTween:Play(forward)
      self.inoutTweenBottom:Play(forward)
    end
  end
end
function ProfessionNewHeroPage:StopInoutAnim(jumpToFinish)
  local ctl = self.listCtrls[self.selectedTabIndex]
  if ctl then
    local cells = ctl:GetCells()
    for i, cell in ipairs(cells) do
      cell:StopInoutAnim(jumpToFinish)
    end
  end
  if jumpToFinish then
    if self.inoutTween.enabled then
      self.inoutTween:Toggle()
      self.inoutTween:ResetToBeginning()
    end
    if self.inoutTweenBottom.enabled then
      self.inoutTweenBottom:Toggle()
      self.inoutTweenBottom:ResetToBeginning()
    end
  end
  self.inoutTween.enabled = false
  self.inoutTweenBottom.enabled = false
  self.inoutAnimCount = nil
  self.inoutFinishCallback = nil
end
