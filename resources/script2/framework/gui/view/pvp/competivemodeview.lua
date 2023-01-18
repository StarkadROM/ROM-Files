CompetiveModeView = class("CompetiveModeView", SubView)
local CompetiveModeViewPath = ResourcePathHelper.UIView("CompetiveModeView")
local ViewName = "CompetiveModeView"
local TeamPwsViewName = "TeamPwsSubView"
local CupModeViewName = "CupModeView"
if not GameConfig.CompetiveMode or not GameConfig.CompetiveMode.TabTextures then
  local TabTextures = {
    "12pvp_bg_pic4",
    "12pvp_bg_pic5"
  }
end
local TabNames = GameConfig.CompetiveMode and GameConfig.CompetiveMode.TabNames or ZhString.CompetiveModeTabNames
local tickInterval = 5000
function CompetiveModeView:OnEnter()
  CompetiveModeView.super.OnEnter(self)
  self:StartTick()
end
function CompetiveModeView:OnExit()
  CompetiveModeView.super.OnExit(self)
  self:StopTick()
end
function CompetiveModeView:OnDestroy()
  local picManager = PictureManager.Instance
  picManager:UnLoadPVP(TabTextures[1], self.teamPwsTex)
  picManager:UnLoadPVP(TabTextures[2], self.cupModeTex)
  self:StopTick()
  CompetiveModeView.super.OnDestroy(self)
end
function CompetiveModeView:Init()
  self:FindObjs()
  self:AddBtnEvts()
  self:AddViewEvts()
  self:InitShow()
end
function CompetiveModeView:LoadSubViews()
  self.rootGO = self:FindGO("TeamPwsView")
  local go = self:LoadPreferb_ByFullPath(CompetiveModeViewPath, self.rootGO, true)
  go.name = ViewName
  self.teamPwsView = self:AddSubView(TeamPwsViewName, TeamPwsView)
  self.cupModeView = self:AddSubView(CupModeViewName, CupModeView)
end
function CompetiveModeView:FindObjs()
  self:LoadSubViews()
  self.teamPwsTabGO = self:FindGO("TeamPwsTab", self.rootGO)
  self.teamPwsViewGO = self:FindGO(TeamPwsViewName, self.rootGO)
  self.teamPwsTex = self:FindComponent("Tex", UITexture, self.teamPwsTabGO)
  self.teamPwsName = self:FindComponent("Name", UILabel, self.teamPwsTabGO)
  self.teamPwsRuleGO = self:FindGO("RuleBtn", self.teamPwsTabGO)
  self.weekLabel = self:FindComponent("Desc", UILabel, self.teamPwsTabGO)
  self.teamPwsDescBG = self:FindGO("DescBG", self.teamPwsTabGO)
  self.weekLabel.gameObject:SetActive(false)
  self.teamPwsDescBG:SetActive(false)
  self.cupModeTabGO = self:FindGO("CupModeTab", self.rootGO)
  self.cupModeViewGO = self:FindGO(CupModeViewName, self.rootGO)
  self.cupModeTex = self:FindComponent("Tex", UITexture, self.cupModeTabGO)
  self.cupModeName = self:FindComponent("Name", UILabel, self.cupModeTabGO)
  self.cupModeDesc = self:FindComponent("Desc", UILabel, self.cupModeTabGO)
  self.cupModeRuleGO = self:FindGO("RuleBtn", self.cupModeTabGO)
  self.cupModeDescBG = self:FindGO("DescBG", self.cupModeTabGO)
end
function CompetiveModeView:InitShow()
  local picManager = PictureManager.Instance
  picManager:SetPVP(TabTextures[1], self.teamPwsTex)
  picManager:SetPVP(TabTextures[2], self.cupModeTex)
  if TabNames then
    self.teamPwsName.text = TabNames[1]
    self.cupModeName.text = TabNames[2]
  end
  self:TabChangeHandler(self.teamPwsTabGO.name)
end
local ShowHelpDesc = function(id)
  local desc = Table_Help[id] and Table_Help[id].Desc or ZhString.Help_RuleDes
  TipsView.Me():ShowGeneralHelp(desc)
end
function CompetiveModeView:AddBtnEvts()
  self:AddTabChangeEvent(self.teamPwsTabGO, self.teamPwsViewGO, self.teamPwsView)
  self:AddTabChangeEvent(self.cupModeTabGO, self.cupModeViewGO, self.cupModeView)
  if self.teamPwsRuleGO then
    self:AddClickEvent(self.teamPwsRuleGO, function(go)
      ShowHelpDesc(PanelConfig.TeamPwsView.id)
    end)
  end
  if self.cupModeRuleGO then
    self:AddClickEvent(self.cupModeRuleGO, function(go)
      ShowHelpDesc(PanelConfig.CupModeView.id)
    end)
  end
end
function CompetiveModeView:AddViewEvts()
  self:AddListenEvt(CupModeEvent.ScheduleChanged_6v6, self.RefreshScheduleStatus)
  self:AddListenEvt(CupModeEvent.SeasonInfo_6v6, self.RefreshScheduleStatus)
  self:AddListenEvt(CupModeEvent.SeasonFinish_6v6, self.OnSeasonFinish)
  self:AddListenEvt(ServiceEvent.MatchCCmdQueryTeamPwsTeamInfoMatchCCmd, self.HandleQueryTeamPwsTeamInfo)
end
function CompetiveModeView:OnSeasonFinish()
  self:StopTick()
end
function CompetiveModeView:UpdateView()
  self:UpdateCurrentTabView()
  self:RestartTick()
  self:UpdateTabDesc()
end
function CompetiveModeView:StartTick()
  if not self.timeTicker then
    self.tickId = self.tickId or 101
    self.timeTicker = TimeTickManager.Me():CreateTick(0, tickInterval, self.Tick, self, self.tickId)
  end
end
function CompetiveModeView:StopTick()
  if self.timeTicker then
    self.timeTicker:Destroy()
    self.timeTicker = nil
    self.tickId = self.tickId + 1
  end
end
function CompetiveModeView:RestartTick()
  self:StopTick()
  self:StartTick()
end
function CompetiveModeView:Tick()
  local proxy = CupMode6v6Proxy.Instance
  proxy:TryUpdateScheduleStatus()
end
function CompetiveModeView:RefreshScheduleStatus()
  self:UpdateTabDesc()
end
function CompetiveModeView:UpdateTabDesc()
  local curServerTime = ServerTime.CurServerTime() / 1000
  local proxy = CupMode6v6Proxy.Instance
  if proxy:IsSeasonNoOpen() or proxy:IsSeasonEnd() then
    self.cupModeDescBG:SetActive(false)
    self.cupModeDesc.text = ""
  else
    self.cupModeDescBG:SetActive(true)
    if curServerTime < proxy.warbandStartTime then
      self.cupModeDesc.text = CupModeProxy.CupModeStartTimeLeft(proxy.warbandStartTime)
    elseif proxy:IsInSignupTime() then
      self.cupModeDesc.text = ZhString.Warband_Tab_TimeSignup
    else
      self.cupModeDesc.text = ZhString.Warband_Tab_TimeToday
    end
  end
end
function CompetiveModeView:HandleQueryTeamPwsTeamInfo(note)
  local serverData = note.body
  local _, pwsConfig = next(GameConfig.PvpTeamRaid)
  local nextOpenTime = serverData.opentime
  local curTime = ServerTime.CurServerTime() / 1000
  if not nextOpenTime or nextOpenTime < curTime then
    self.weekLabel.gameObject:SetActive(false)
    self.teamPwsDescBG:SetActive(false)
    return
  end
  self.weekLabel.gameObject:SetActive(true)
  self.teamPwsDescBG:SetActive(true)
  local weekCount = math.ceil(serverData.count / (pwsConfig.EventCountPerWeek or 1))
  local strWeek
  if weekCount > 10 then
    local first, second = math.modf(weekCount / 10)
    if second > 0 then
      strWeek = string.format("%s%s", ZhString.ChinaNumber[10], ZhString.ChinaNumber[math.floor(second * 10 + 0.5)])
    else
      strWeek = ZhString.ChinaNumber[10]
    end
    if first > 1 then
      strWeek = string.format("%s%s", ZhString.ChinaNumber[math.clamp(first, 1, 9)], strWeek)
    end
  else
    strWeek = weekCount > 0 and ZhString.ChinaNumber[weekCount] or weekCount
  end
  self.weekLabel.text = string.format(ZhString.TeamPws_Week, strWeek)
end
