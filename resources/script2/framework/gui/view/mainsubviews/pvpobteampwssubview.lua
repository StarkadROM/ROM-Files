autoImport("PvpObSubview")
autoImport("TeamPwsObBord")
PvpObTeamPwsSubview = class("PvpObTeamPwsSubview", PvpObSubview)
function PvpObTeamPwsSubview:Init()
  PvpObTeamPwsSubview.super.Init(self)
  self.infoPanel = TeamPwsObBord.new(self.infoPanelContainerGO)
end
function PvpObTeamPwsSubview:InitListenEvents()
  PvpObTeamPwsSubview.super.InitListenEvents(self)
  self:AddDispatcherEvt(ServiceEvent.FuBenCmdTeamPwsInfoSyncFubenCmd, self.UpdateTeamPwsInfo)
  self:AddDispatcherEvt(ServiceEvent.FuBenCmdUpdateTeamPwsInfoFubenCmd, self.UpdateTeamPwsInfo)
  self:AddDispatcherEvt(ServiceEvent.FuBenCmdRaidKillNumSyncCmd, self.UpdateTeamPwsInfo)
end
function PvpObTeamPwsSubview:UpdateTeamPwsInfo(data)
  if self.infoPanel then
    self.infoPanel:UpdateInfo()
  end
end
function PvpObTeamPwsSubview:OnExit()
  PvpObTeamPwsSubview.super.OnExit(self)
  if self.infoPanel then
    self.infoPanel:Hide()
  end
end
