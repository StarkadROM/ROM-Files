GuildFaithPage = class("GuildFaithPage", SubView)
autoImport("GFaithTypeCell")
autoImport("GAstrolabeAttriCell")
autoImport("GvGPvpAttrCell")
autoImport("GvGPvpPrayData")
local eToggleType = {
  eNone = 0,
  eFaith = 1,
  eAstro = 2,
  eAttribute = 3
}
GuildFaithPage.TabName = {
  faithTitle = ZhString.GuildFaithPage_FaithTabName,
  astroTitle = ZhString.GuildFaithPage_AstroTabName
}
local titleDeepColor = Color(0.2627450980392157, 0.30196078431372547, 0.5529411764705883, 1)
local titleNormalColor = Color(0.5450980392156862, 0.5450980392156862, 0.5450980392156862, 1)
local tabNameTipOffset = {133, -58}
function GuildFaithPage:Init()
  self:InitUI()
  self:MapEvent()
end
function GuildFaithPage:InitUI()
  self.goPrayButton = self:FindGO("GoPrayButton")
  self:AddClickEvent(self.goPrayButton, function(go)
    self:TraceNpc(2)
  end)
  local goAstrolabeButton = self:FindGO("GoAstrolabeButton")
  goAstrolabeButton:SetActive(false)
  self.m_uiTxtAstrolabeButtonName = self:FindGO("GoAstrolabeButton/Label"):GetComponent(UILabel)
  local faithGrid = self:FindComponent("FaithTypeGrid", UIGrid)
  self.faithAttriCtl = UIGridListCtrl.new(faithGrid, GFaithTypeCell, "GFaithTypeCell")
  local astrolabeGrid = self:FindComponent("AstrolabeGrid", UIGrid)
  self.astrolabeCtl = UIGridListCtrl.new(astrolabeGrid, GAstrolabeAttriCell, "GAstrolabeAttriCell")
  local gvgPvpAttrGrid1 = self:FindComponent("gvgPvpAttrGrid1", UIGrid)
  local gvgPvpAttrGrid2 = self:FindComponent("gvgPvpAttrGrid2", UIGrid)
  local gvgPvpAttrGrid3 = self:FindComponent("gvgPvpAttrGrid3", UIGrid)
  self.gvgPvpAttrCtl1 = UIGridListCtrl.new(gvgPvpAttrGrid1, GvGPvpAttrCell, "GvGPvpAttrCell")
  self.gvgPvpAttrCtl2 = UIGridListCtrl.new(gvgPvpAttrGrid2, GvGPvpAttrCell, "GvGPvpAttrCell")
  self.gvgPvpAttrCtl3 = UIGridListCtrl.new(gvgPvpAttrGrid3, GvGPvpAttrCell, "GvGPvpAttrCell")
  self.gvgPvpAttrBord = self:FindGO("gvgPvpAttrBord")
  self.astrolabeBord = self:FindGO("AstrolabeBord")
  self.lockTip = self:FindGO("LockTip")
  self.gvgPvpLockTip = self:FindGO("gvgPvpLockTip")
  self.faithRoot = self:FindGO("faithRoot")
  self.m_uiTxtAstrolabeBordTitle = self:FindGO("AstrolabeBord/AstrolabeTitle/Label"):GetComponent(UILabel)
  local titleLab = self:FindGO("title1", self.faithRoot)
  titleLab = self:FindComponent("Label", UILabel, titleLab)
  titleLab.text = ZhString.GFaith_pray
  titleLab = self:FindGO("title2", self.faithRoot)
  titleLab = self:FindComponent("Label", UILabel, titleLab)
  titleLab.text = ZhString.GFaith_guildpray
  self.astroRoot = self:FindGO("astroRoot")
  self.faithTitle = self:FindGO("faithTitle")
  self.faithTitleLabel = self:FindComponent("Label", UILabel, self.faithTitle)
  self.faithTitleImg = self:FindGO("ChooseImg", self.faithTitle)
  self.faithTitleIcon = self:FindComponent("Icon", UISprite, self.faithTitle)
  self:AddClickEvent(self.faithTitle, function()
    self:UpdateFaithGrid()
  end)
  self.astroTitle = self:FindGO("astroTitle")
  self.astroTitleLabel = self:FindComponent("Label", UILabel, self.astroTitle)
  self.astroTitleImg = self:FindGO("ChooseImg", self.astroTitle)
  self.astroTitleIcon = self:FindComponent("Icon", UISprite, self.astroTitle)
  self:AddClickEvent(self.astroTitle, function()
    self:UpdateAstrolabeGrid()
  end)
  self.attributeTitle = self:FindGO("attributeTitle")
  self.attributeTitleLabel = self:FindComponent("Label", UILabel, self.attributeTitle)
  self.attributeTitleImg = self:FindGO("ChooseImg", self.attributeTitle)
  self.attributeTitleIcon = self:FindComponent("Icon", UISprite, self.attributeTitle)
  self:AddClickEvent(self.attributeTitle, function()
    self:UpdateAttributeGrid()
  end)
  self:InitFaithGrid()
  local tabList = {
    self.faithTitle,
    self.astroTitle
  }
  for i, v in ipairs(tabList) do
    local longPress = v:GetComponent(UILongPress)
    function longPress.pressEvent(obj, state)
      self:PassEvent(TipLongPressEvent.GuildFaithPage, {
        state,
        obj.gameObject
      })
    end
  end
  self:AddEventListener(TipLongPressEvent.GuildFaithPage, self.HandleLongPress, self)
  TabNameTip.SwitchShowTabIconOrLabel(self.faithTitleIcon.gameObject, self.faithTitleLabel.gameObject)
  TabNameTip.SwitchShowTabIconOrLabel(self.astroTitleIcon.gameObject, self.astroTitleLabel.gameObject)
  TabNameTip.SwitchShowTabIconOrLabel(self.attributeTitleIcon.gameObject, self.attributeTitleLabel.gameObject)
end
local tempArgs = {}
function GuildFaithPage:TraceNpc(uniqueid)
  if Game.Myself:IsDead() then
    MsgManager.ShowMsgByIDTable(2500)
  elseif Game.MapManager:IsInGuildMap() then
    FuncShortCutFunc.Me():CallByID(self.gotoMode)
  elseif Game.Myself:IsDead() then
    MsgManager.ShowMsgByIDTable(2500)
  elseif not GuildProxy.Instance:IHaveGuild() then
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.GuildInfoView
    })
    return
  else
    xdlog("申请进入公会")
    ServiceGuildCmdProxy.Instance:CallEnterTerritoryGuildCmd()
    FunctionChangeScene.Me():SetSceneLoadFinishActionForOnce(function()
      FuncShortCutFunc.Me():CallByID(500)
    end)
    GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.NormalLayer)
  end
end
function GuildFaithPage:_setTitleToggleState(eToggle)
  if eToggle == eToggleType.eFaith then
    self.faithTitleLabel.color = titleDeepColor
    self.astroTitleLabel.color = titleNormalColor
    self.attributeTitleLabel.color = titleNormalColor
    self.faithTitleIcon.color = titleDeepColor
    self.astroTitleIcon.color = titleNormalColor
    self.attributeTitleIcon.color = titleNormalColor
    self:Show(self.faithTitleImg)
    self:Hide(self.astroTitleImg)
    self:Hide(self.attributeTitleImg)
    self:Show(self.faithRoot)
    self:Hide(self.astroRoot)
    self.goPrayButton:SetActive(true)
  elseif eToggle == eToggleType.eAstro then
    self.faithTitleLabel.color = titleNormalColor
    self.astroTitleLabel.color = titleDeepColor
    self.attributeTitleLabel.color = titleNormalColor
    self.faithTitleIcon.color = titleNormalColor
    self.astroTitleIcon.color = titleDeepColor
    self.attributeTitleIcon.color = titleNormalColor
    self:Hide(self.faithTitleImg)
    self:Show(self.astroTitleImg)
    self:Hide(self.attributeTitleImg)
    self:Show(self.astroRoot)
    self:Hide(self.faithRoot)
    self.m_uiTxtAstrolabeButtonName.text = ZhString.GuildFailthPage_AstroBtnName
    self.m_uiTxtAstrolabeBordTitle.text = ZhString.GuildFailthPage_AstroTitle
    self.goPrayButton:SetActive(false)
  elseif eToggle == eToggleType.eAttribute then
    self.faithTitleLabel.color = titleNormalColor
    self.astroTitleLabel.color = titleNormalColor
    self.attributeTitleLabel.color = titleDeepColor
    self.faithTitleIcon.color = titleNormalColor
    self.astroTitleIcon.color = titleNormalColor
    self.attributeTitleIcon.color = titleDeepColor
    self:Hide(self.faithTitleImg)
    self:Hide(self.astroTitleImg)
    self:Show(self.attributeTitleImg)
    self:Show(self.astroRoot)
    self:Hide(self.faithRoot)
    self.m_uiTxtAstrolabeButtonName.text = ZhString.GuildFailthPage_AttributeBtnName
    self.m_uiTxtAstrolabeBordTitle.text = ZhString.GuildFailthPage_AttributeTitle
    self.goPrayButton:SetActive(true)
  end
  self.m_curToggle = eToggle
end
function GuildFaithPage:InitFaithGrid()
  self.faithDatas = GuildPrayProxy.Instance:GetPrayListByType(GuildCmd_pb.EPRAYTYPE_GODDESS)
end
function GuildFaithPage:UpdateFaithGrid()
  self:_setTitleToggleState(eToggleType.eFaith)
  self.faithAttriCtl:ResetDatas(self.faithDatas)
  if not GameConfig.SystemForbid.GvGPvP_Pray then
    self:UpdateGvgPvpGrid()
    self:Hide(self.gvgPvpLockTip)
  else
    self:Show(self.gvgPvpLockTip)
  end
end
function GuildFaithPage.SortRule(a, b)
  return a[1] < b[1]
end
function GuildFaithPage:UpdateGvgPvpGrid()
  local datas = {
    [1] = {},
    [2] = {},
    [3] = {}
  }
  for i = 1, 3 do
    local typeData = GuildPrayProxy.Instance:GetPrayListByType(i)
    for j = 1, #typeData do
      local attr = typeData[j]:GetAddAttrValue()
      local cellData = {
        attr[2],
        attr[3],
        attr[7]
      }
      table.insert(datas[i], cellData)
    end
  end
  self.gvgPvpAttrCtl1:ResetDatas(datas[1])
  self.gvgPvpAttrCtl2:ResetDatas(datas[2])
  self.gvgPvpAttrCtl3:ResetDatas(datas[3])
end
function GuildFaithPage:UpdateAstrolabeGrid()
  self:_setTitleToggleState(eToggleType.eAstro)
  local attriMap = AstrolabeProxy.Instance:GetEffectMap()
  local datas = {}
  for key, value in pairs(attriMap) do
    local cdata = {key, value}
    table.insert(datas, cdata)
  end
  if #datas > 0 then
    self.astrolabeBord:SetActive(true)
    self.lockTip:SetActive(false)
    self.astrolabeBord:SetActive(#datas > 0)
    table.sort(datas, GuildFaithPage.SortRule)
    self.astrolabeCtl:ResetDatas(datas)
  else
    self.astrolabeBord:SetActive(false)
    self.lockTip:SetActive(true)
  end
end
function GuildFaithPage:UpdateAttributeGrid()
  self:_setTitleToggleState(eToggleType.eAttribute)
  local attributes = GuildPrayProxy.Instance:GetPrayListByType(GuildCmd_pb.EPRAYTYPE_HOLYBLESS)
  local datas = {}
  for key, value in pairs(attributes) do
    local newData = {}
    newData.m_isAttribute = true
    newData.m_data = value
    table.insert(datas, newData)
  end
  local hasData = #datas > 0
  self.astrolabeBord:SetActive(hasData)
  self.lockTip:SetActive(not hasData)
  if hasData then
    self.astrolabeCtl:ResetDatas(datas)
  end
end
function GuildFaithPage:MapEvent()
  self:AddListenEvt(ServiceEvent.GuildCmdGuildMemberDataUpdateGuildCmd, self.HandleGuildMemberDataUpdate)
end
function GuildFaithPage:OnEnter()
  GuildFaithPage.super.OnEnter(self)
  local tab = self.viewdata.viewdata and self.viewdata.viewdata.prayTab
  if tab == 3 then
    self:UpdateAstrolabeGrid()
  elseif tab == 2 then
    self:UpdateAttributeGrid()
  else
    self:UpdateFaithGrid()
  end
end
function GuildFaithPage:OnExit()
  GuildFaithPage.super.OnExit(self)
end
function GuildFaithPage:HandleLongPress(param)
  local isPressing, go = param[1], param[2]
  TabNameTip.OnLongPress(isPressing, GuildFaithPage.TabName[go.name], true, self:FindComponent("ChooseImg", UISprite, go), nil, tabNameTipOffset)
end
function GuildFaithPage:HandleGuildMemberDataUpdate()
  if self.m_curToggle == eToggleType.eFaith then
    self:UpdateFaithGrid()
  end
end
