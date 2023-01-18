ServerTime = class("ServerTime")
ServerTime.CacheUnscaledTime = 0
ServerTime.SERVER_TIMEZONE = nil
ServerTime.Ori_OsDate = os.date
function os.date(fmt, time)
  if ServerTime.SERVER_TIMEZONE and time then
    time = time + 3600 * ServerTime.SERVER_TIMEZONE
    local date = ServerTime.Ori_OsDate("!" .. fmt, time)
    if date.isdst then
      date = ServerTime.Ori_OsDate("!" .. fmt, time - 3600)
      date.isdst = false
    end
    return date
  end
  local date = ServerTime.Ori_OsDate(fmt, time)
  if date.isdst and time then
    date = ServerTime.Ori_OsDate(fmt, time - 3600)
    date.isdst = false
  end
  return date
end
ServerTime.Ori_OsTime = os.time
function os.time(date)
  if date then
    date.isdst = false
  end
  local result = ServerTime.Ori_OsTime(date)
  if not date or not ServerTime.SERVER_TIMEZONE then
    return result
  end
  local localTimeZone = tonumber(ServerTime.Ori_OsDate("%z", 0)) / 100
  return result - (ServerTime.SERVER_TIMEZONE - localTimeZone) * 3600
end
function ServerTime.ClampClientTime()
  ServerTime.clamp = ServerTime.CurClientTime()
end
function ServerTime.InitTime(serverTime, timeZone)
  if type(timeZone) == "number" then
    if timeZone < -12 or timeZone > 12 then
      redlog("TimeZone Param Error：", timeZone)
    else
      ServerTime.SERVER_TIMEZONE = timeZone
    end
  end
  if not ServerTime.SERVER_TIMEZONE then
    redlog("没有设置服务器时区，临时使用系统时区")
    ServerTime.SERVER_TIMEZONE = tonumber(ServerTime.Ori_OsDate("%z", 0)) / 100
  end
  local dataFormat = "%Y-%m-%d %H:%M:%S"
  ServerTime.serverTimeStamp = serverTime
  ServerTime.clientTimeStamp = ServerTime.CurClientTime()
  ServerTime.deltaStamp = ServerTime.serverTimeStamp - ServerTime.clientTimeStamp
  if ServerTime.clamp then
    ServerTime.deltaStamp = ServerTime.deltaStamp + (ServerTime.CurClientTime() - ServerTime.clamp)
  end
  if ServerTime.timeTick == nil then
    ServerTime.timeTick = TimeTickManager.Me():CreateTick(0, 33, ServerTime.Update, ServerTime, 1, true)
  end
  ServerTime.Update()
end
function ServerTime.StampClientSend()
  ServerTime.clientStamp = ServerTime.CurServerTime()
end
function ServerTime.CurServerTime()
  return ServerTime.ServerTime
end
function ServerTime.CurServerWeek()
  return tonumber(os.date("%W", ServerTime.ServerTime / 1000))
end
function ServerTime.CurClientTime()
  return (UnityRealtimeSinceStartup or 0) * 1000
end
function ServerTime.ServerDeltaSecondTime(serverTime, curServerTime)
  return ServerTime.ServerDeltaMillTime(serverTime, curServerTime) / 1000
end
function ServerTime.ServerDeltaMillTime(serverTime, curServerTime)
  curServerTime = curServerTime or ServerTime.CurServerTime()
  return serverTime - curServerTime
end
function ServerTime.Update(owner, deltaTime)
  ServerTime.ServerTime = ServerTime.CurClientTime() + ServerTime.deltaStamp
  ServerTime.CacheUnscaledTime = UnityUnscaledTime
end
function ServerTime.GetDayStartTimestamp()
  local timetable = os.date("*t", ServerTime.ServerTime / 1000)
  local delta = timetable.hour * 3600 + timetable.min * 60 + timetable.sec
  return ServerTime.ServerTime / 1000 - delta
end
function ServerTime.GetAMPMString()
  local timetable = os.date("*t", ServerTime.ServerTime / 1000)
  local hour = timetable.hour
  if hour >= 0 and hour < 12 then
    return "AM"
  else
    return "PM"
  end
  ServerTime.CacheUnscaledTime = UnityUnscaledTime
end
function ServerTime.GetStartTimestamp(timestamp)
  local timetable = os.date("*t", timestamp)
  local delta = timetable.hour * 3600 + timetable.min * 60 + timetable.sec
  return timestamp - delta
end
function ServerTime.GetGameStartTimestamp(timestamp)
  local timetable = os.date("*t", timestamp)
  local delta = (timetable.hour - 5) * 3600 + timetable.min * 60 + timetable.sec
  return timestamp - delta
end
ServerTime.DayPhase = {
  Dawn = 1,
  Day = 2,
  Dusk = 3,
  Night = 4
}
function ServerTime.GetDayPhase()
  local timetable = os.date("*t", (ServerTime.ServerTime or 0) / 1000)
  local hour = timetable.hour % 6 * 6
  if hour >= 4 and hour < 6 then
    return ServerTime.DayPhase.Dawn
  elseif hour >= 6 and hour < 18 then
    return ServerTime.DayPhase.Day
  elseif hour >= 18 and hour < 20 then
    return ServerTime.DayPhase.Dusk
  else
    return ServerTime.DayPhase.Night
  end
end
