autoImport("PvpObSubview")
autoImport("OthelloPVPObBord")
PvpObTeamPwsOthelloSubview = class("PvpObTeamPwsOthelloSubview", PvpObSubview)
function PvpObTeamPwsOthelloSubview:Init()
  PvpObTeamPwsOthelloSubview.super.Init(self)
  self.infoPanel = OthelloPVPObBord.new(self.infoPanelContainerGO)
end
function PvpObTeamPwsOthelloSubview:InitListenEvents()
  PvpObTeamPwsOthelloSubview.super.InitListenEvents(self)
  self:AddDispatcherEvt(ServiceEvent.FuBenCmdOthelloInfoSyncFubenCmd, self.UpdateOthelloInfo)
  self:AddDispatcherEvt(ServiceEvent.FuBenCmdRaidKillNumSyncCmd, self.UpdateOthelloInfo)
end
function PvpObTeamPwsOthelloSubview:UpdateOthelloInfo(data)
  if self.infoPanel then
    self.infoPanel:UpdateInfo()
  end
end
function PvpObTeamPwsOthelloSubview:OnExit()
  PvpObTeamPwsOthelloSubview.super.OnExit(self)
  if self.infoPanel then
    self.infoPanel:Hide()
  end
end
