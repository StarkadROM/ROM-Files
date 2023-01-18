GgvPerfectTimeInfo = class("GgvPerfectTimeInfo")
function GgvPerfectTimeInfo:ctor(data)
  self.pause = data.pause
  if self.pause then
    self.time = data.time + ServerTime.CurServerTime() / 1000
  else
    self.time = data.time
  end
end
GvgDefenseData = class("GvgDefenseData")
function GvgDefenseData:ctor(data)
  self.cityid = data.cityid
  self.cityName = Table_Guild_StrongHold[self.cityid] and Table_Guild_StrongHold[self.cityid].Name or ""
  self:Reset(data)
end
function GvgDefenseData:Reset(data)
  if nil ~= data.perfect then
    self.perfect = data.perfect
  end
  local timeInfo = GgvPerfectTimeInfo.new(data.perfect_time)
  self.pause = timeInfo.pause
  self.time = timeInfo.time
  GvgProxy.Instance:Debug("[NewGVG 本场公会战积分信息完美防守信息] 是否暂停 是否达成完美防守 时间 ", self.pause, self.perfect, os.date("%Y-%m-%d-%H-%M-%S", self.time))
end
