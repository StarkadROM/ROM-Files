SuperGvgRankData = class("SuperGvgRankData")
function SuperGvgRankData:ctor(data)
  self.id = data.guildid
  self.grade = data.grade
  self.guildName = data.guildname
  self.zoneid = data.zoneid
  self.portrait = data.portrait
end
function SuperGvgRankData:GetGuildName()
  return self.guildName
end
function SuperGvgRankData:GetZoneId()
  return self.zoneid
end
