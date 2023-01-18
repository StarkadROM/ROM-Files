autoImport("GemCell")
GemContainerView = class("GemContainerView", ContainerView)
GemContainerView.ViewType = UIViewType.NormalLayer
GemContainerView.TogglePageNameMap = {
  EmbedTab = "GemEmbedPage",
  UpgradeTab = "GemUpgradePage",
  AppraiseTab = "GemAppraisePage",
  FunctionTab = "GemFunctionPage"
}
local _TabNamePrefix = "GemContainer_TabName_"
function GemContainerView:Init()
  GemProxy.Instance:InitSkillProfessionFilter()
  self.pageContainer = self:FindGO("PageContainer")
  if not self.pageContainer then
    LogUtility.Error("Cannot find PageContainer!")
    return
  end
  for toggleName, pageName in pairs(self.TogglePageNameMap) do
    autoImport(pageName)
    self:AddSubView(pageName, _G[pageName])
    self:FindAndAddToggle(toggleName, pageName)
  end
  self:AddEvents()
end
function GemContainerView:FindAndAddToggle(toggleName, pageName)
  local toggleGO = self:FindGO(toggleName)
  local togName1 = self:FindComponent("Label1", UILabel, toggleGO)
  if togName1 and ZhString[_TabNamePrefix .. toggleName] then
    togName1.text = ZhString[_TabNamePrefix .. toggleName]
  end
  local togName2 = self:FindComponent("Label2", UILabel, toggleGO)
  if togName2 and ZhString[_TabNamePrefix .. toggleName] then
    togName2.text = ZhString[_TabNamePrefix .. toggleName]
  end
  self:AddClickEvent(toggleGO, function(go)
    self:SwitchToPage(self.TogglePageNameMap[go.name])
  end)
  self.toggleMap = self.toggleMap or {}
  local toggle = toggleGO:GetComponent(UIToggle)
  if toggle then
    self.toggleMap[pageName] = toggle
  end
  return toggle
end
function GemContainerView:SwitchToPage(targetPageName)
  local toggle = self.toggleMap[targetPageName]
  if toggle then
    toggle.value = true
  end
  local isActive
  for pageName, pageClass in pairs(self.viewMap) do
    isActive = pageName == targetPageName
    pageClass.gameObject:SetActive(isActive)
    if isActive then
      self.activePageName = pageName
      if pageClass.OnActivate then
        pageClass:OnActivate()
      end
    end
    if not isActive and pageClass.OnDeactivate then
      pageClass:OnDeactivate()
    end
  end
end
function GemContainerView:OnEnter()
  GemContainerView.super.OnEnter(self)
  local targetPageName = self.viewdata.viewdata and self.viewdata.viewdata.page
  targetPageName = targetPageName or self:GetDefaultPageName()
  self:SwitchToPage(targetPageName)
end
function GemContainerView:GetDefaultPageName()
  return self.TogglePageNameMap.EmbedTab
end
function GemContainerView:AddEvents()
end
