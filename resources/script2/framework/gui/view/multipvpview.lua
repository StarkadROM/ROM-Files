autoImport("LeisureModelView")
autoImport("WarbandModelView")
MultiPvpView = class("MultiPvpView", SubView)
local TEXTURE = {
  "12pvp_bg_pic2",
  "12pvp_bg_pic5",
  "12pvp_bg"
}
local tick_interval = 5000
function MultiPvpView:Init()
  self.coreTabMap = ReusableTable.CreateTable()
  self:FindObjs()
  self:InitShow()
  self:InitTex()
  self:AddEvts()
  self:ForbidWarband()
end
function MultiPvpView:AddEvts()
  self:AddListenEvt(PVPEvent.TwelveChamption_ScheduleChanged, self.RefreshScheduleStatus)
  self:AddListenEvt(ServiceEvent.MatchCCmdQueryTwelveSeasonInfoMatchCCmd, self.RefreshScheduleStatus)
  self:AddListenEvt(ServiceEvent.MatchCCmdQueryTwelveSeasonFinishMatchCCmd, self.clearTimeTick)
  self:AddListenEvt(PVPEvent.TwelveChamption_Fighting, self.UpdateFightingTime)
end
function MultiPvpView:ForbidWarband()
  local warbandOpen = not GameConfig.SystemForbid.WarbandForbid
  self.warbandModelBtn:SetActive(warbandOpen)
  self.warbandCommingSoonBtn:SetActive(not warbandOpen)
  self.MultiPvpGrid:Reposition()
end
local ShowHelpDesc = function(id)
  local desc = Table_Help[id] and Table_Help[id].Desc or ZhString.Help_RuleDes
  TipsView.Me():ShowGeneralHelp(desc)
end
function MultiPvpView:FindObjs()
  self.leisureModelBtn = self:FindGO("LeisureModelBtn")
  self.leisureModelObj = self:FindGO("LeisureModelView")
  self.leisureTex = self:FindComponent("LeisureTex", UITexture)
  self.battleName = self:FindComponent("Name", UILabel, self.leisureModelBtn)
  self.battleName.text = ZhString.TwelvePVP_RelaxTabName
  self.twelvePVP_RuleBtn = self:FindGO("RuleBtn", self.leisureModelBtn)
  self:AddClickEvent(self.twelvePVP_RuleBtn, function(g)
    ShowHelpDesc(PanelConfig.LeisureModelView.id)
  end)
  self.MultiPvpGrid = self:FindComponent("MultiPvpGrid", UIGrid)
  self.warbandModelBtn = self:FindGO("WarbandModelBtn")
  self.warbandModelObj = self:FindGO("WarbandModelView")
  self.warbandTex = self:FindComponent("WarbandTex", UITexture)
  self.warbandDesc = self:FindComponent("WarTabDesc", UILabel)
  self.warbandRuleBtn = self:FindGO("RuleBtn", self.warbandModelBtn)
  self:AddClickEvent(self.warbandRuleBtn, function(g)
    ShowHelpDesc(PanelConfig.WarbandModelView.id)
  end)
  self.warbandTabName = self:FindComponent("Name", UILabel, self.warbandModelBtn)
  self.warbandTabName.text = ZhString.Warband_TabName
  self.warbandCommingSoonBtn = self:FindGO("WarbandCommingSoonBtn", self.gameObject)
  self.commingSoonTex = self:FindComponent("CommingSoonTex", UITexture, self.warbandCommingSoonBtn)
  self.commingSoonLab = self:FindComponent("CommingSoonLab", UILabel, self.warbandCommingSoonBtn)
  self.commingSoonLab.text = ZhString.TwelvePVP_ComingSoon
end
function MultiPvpView:InitTex()
  PictureManager.Instance:SetPVP(TEXTURE[1], self.leisureTex)
  PictureManager.Instance:SetPVP(TEXTURE[2], self.warbandTex)
  PictureManager.Instance:SetPVP(TEXTURE[3], self.commingSoonTex)
end
function MultiPvpView:InitShow()
  self.leisureModelView = self:AddSubView("LeisureModelView", LeisureModelView)
  self.warbandModelView = self:AddSubView("WarbandModelView", WarbandModelView)
  self:AddTabChangeEvent(self.leisureModelBtn, self.leisureModelObj, self.leisureModelView)
  self:AddTabChangeEvent(self.warbandModelBtn, self.warbandModelObj, self.warbandModelView)
  if self.viewdata.view and self.viewdata.view.tab then
    self:TabChangeHandlerWithPanelID(self.viewdata.view.tab)
  else
    self:TabChangeHandler(self.leisureModelBtn.name)
  end
  self:UpdateTabDesc()
end
function MultiPvpView:AddTabChangeEvent(toggleObj, targetObj, script)
  local key = toggleObj.name
  if not self.coreTabMap[key] then
    local table = ReusableTable.CreateTable()
    table.obj = targetObj
    table.script = script
    self.coreTabMap[key] = table
    self:AddClickEvent(toggleObj, function(go)
      self:TabChangeHandler(go.name)
    end)
  end
end
function MultiPvpView:TabChangeHandlerWithPanelID(tabID)
  if tabID == PanelConfig.LeisureModelView.tab then
    self:TabChangeHandler(self.leisureModelBtn.name)
  elseif tabID == PanelConfig.WarbandModelView.tab then
    self:TabChangeHandler(self.warbandModelBtn.name)
  end
end
local WarbandStartTimeLeft = function(t)
  local day, hour, min = ClientTimeUtil.GetFormatRefreshTimeStr(t)
  if day > 0 then
    return string.format(ZhString.Warband_Tab_DayTimeLeft, day)
  elseif hour > 0 then
    return string.format(ZhString.Warband_Tab_HourTimeLeft, hour)
  elseif min > 0 then
    return string.format(ZhString.Warband_Tab_MinTimeLeft, min)
  else
    return ZhString.Warband_Tab_SecTimeLeft
  end
end
function MultiPvpView:RefreshScheduleStatus()
  self:UpdateTabDesc()
  self.warbandModelView:UpdateScheduleStatus()
end
function MultiPvpView:UpdateTabDesc()
  local curServerTime = ServerTime.CurServerTime() / 1000
  if WarbandProxy.Instance:IsSeasonNoOpen() or WarbandProxy.Instance:IsSeasonEnd() then
    self.warbandDesc.text = ""
  elseif curServerTime < WarbandProxy.Instance.warbandStartTime then
    self.warbandDesc.text = WarbandStartTimeLeft(WarbandProxy.Instance.warbandStartTime)
  elseif WarbandProxy.Instance:IsInSignupTime() then
    self.warbandDesc.text = ZhString.Warband_Tab_TimeSignup
  else
    self.warbandDesc.text = ZhString.Warband_Tab_TimeToday
  end
end
function MultiPvpView:TabChangeHandler(key)
  if self.currentKey ~= key then
    if self.currentKey then
      self.coreTabMap[self.currentKey].obj:SetActive(false)
    end
    self.coreTabMap[key].obj:SetActive(true)
    self.coreTabMap[key].script:UpdateView()
    self.currentKey = key
  end
end
function MultiPvpView:UpdateView()
  self.coreTabMap[self.currentKey].script:UpdateView()
  self:clearTimeTick()
  self.timeTick = TimeTickManager.Me():CreateTick(0, tick_interval, self._tick, self)
end
function MultiPvpView:OnExit()
  self:clearTimeTick()
  MultiPvpView.super.OnExit(self)
end
function MultiPvpView:OnDestroy()
  for k, v in pairs(self.coreTabMap) do
    ReusableTable.DestroyAndClearTable(v)
  end
  ReusableTable.DestroyAndClearTable(self.coreTabMap)
  PictureManager.Instance:UnLoadPVP(TEXTURE[1], self.leisureTex)
  PictureManager.Instance:UnLoadPVP(TEXTURE[2], self.warbandTex)
  PictureManager.Instance:UnLoadPVP(TEXTURE[3], self.commingSoonTex)
  self:clearTimeTick()
  MultiPvpView.super.OnDestroy(self)
end
function MultiPvpView:clearTimeTick()
  if self.timeTick then
    self.timeTick:Destroy()
    self.timeTick = nil
  end
end
function MultiPvpView:_tick()
  WarbandProxy.Instance:TryUpdateScheduleStatus()
end
function MultiPvpView:UpdateFightingTime()
  if self.warbandModelView then
    self.warbandModelView:UpdateFightingTime()
  end
end
