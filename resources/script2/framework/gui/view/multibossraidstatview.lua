autoImport("RaidStatisticsView")
MultiBossRaidStatView = class("MultiBossRaidStatView", RaidStatisticsView)
MultiBossRaidStatView.ViewType = UIViewType.NormalLayer
function MultiBossRaidStatView:AddListenEvts()
  self:AddListenEvt(ServiceEvent.FuBenCmdQueryMultiBossRaidStat, self.HandleRecvQuery)
  self:AddListenEvt(PVEEvent.MultiBossRaid_Shutdown, self.CloseSelf)
end
function MultiBossRaidStatView:InitView()
  MultiBossRaidStatView.super.InitView(self)
  self.raidMapTog.gameObject:SetActive(false)
  self.raidInfoTog.gameObject:SetActive(false)
end
function MultiBossRaidStatView:OnEnter()
  MultiBossRaidStatView.super.super.OnEnter(self)
end
function MultiBossRaidStatView:HandleRecvQuery()
  MultiBossRaidStatView.super.HandleRecvQueryInfo(self)
end
local recordFilter = {}
function MultiBossRaidStatView:GetRecordFilter()
  return GroupRaidProxy.Instance:GetMultiBossRecordFilter()
end
function MultiBossRaidStatView:UpdatePlayerList(gridctl, filtervalue, recordtime)
  local datas = GroupRaidProxy.Instance:GeMultiBossDataByIndex(recordtime, filtervalue)
  local weights = GroupRaidProxy.Instance:GetMultiBossWeightMapByTime(recordtime)
  if datas then
    self:SortByFilter(filtervalue, datas)
    for i = 1, #datas do
      datas[i]:SetPercentage(weights, filtervalue)
    end
    gridctl:ResetDatas(datas)
  end
end
