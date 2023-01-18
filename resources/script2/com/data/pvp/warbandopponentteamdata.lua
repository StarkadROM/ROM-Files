autoImport("WarbandTeamData")
WarbandOpponentTeamData = class("WarbandOpponentTeamData", WarbandTeamData)
function WarbandOpponentTeamData:ctor(data, proxy)
  self.index = data.index
  self.wintimes = data.wintimes
  WarbandOpponentTeamData.super.ctor(self, data.team, proxy)
end
function WarbandOpponentTeamData:IsChampionship()
  local chamption = self.proxy.champtionBand
  if nil ~= chamption and chamption.id == self.id then
    return true
  end
  return false
end
