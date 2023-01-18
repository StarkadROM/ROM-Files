NewGvgRank_GuildShowInfo = class("NewGvgRank_GuildShowInfo")
function NewGvgRank_GuildShowInfo:ctor(gid, data)
  self.id = gid
  if self.id == GuildProxy.Instance.guildId then
    local myGuildData = GuildProxy.Instance.myGuildData
    self.guildName = myGuildData.name
    self.portrait = myGuildData.portrait or 1
    local leaderMD = myGuildData:GetChairMan()
    self.leaderid = leaderMD.id
    self.leaderName = AppendSpace2Str(leaderMD.name)
    self.zoneid = myGuildData.zoneid
  else
    self.guildName = data.name
    self.portrait = data.portrait
    self.leaderid = data.leaderid
    self.leaderName = data.leadername
    self.zoneid = data.zoneid
  end
end
