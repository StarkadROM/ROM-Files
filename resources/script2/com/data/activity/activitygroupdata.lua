ActivityGroupData = class("ActivityGroupData")
function ActivityGroupData:ctor(serverData)
  self:updateData(serverData)
end
function ActivityGroupData:updateData(serverData)
  self.id = serverData.id
  self.name = self:getMultLanContent(serverData, "name")
  self.iconurl = self:getMultLanContent(serverData, "iconurl")
  self.begintime = serverData.begintime
  self.endtime = serverData.endtime
  self.monthcard = serverData.data and serverData.data.monthcard
  self.url = self:getMultLanContent(serverData, "url")
  if BranchMgr.IsJapan() then
    if self.iconurl then
      self.iconurl = string.gsub(self.iconurl, "https", "http")
    else
      redlog("Wrong iconurl")
    end
    if self.url then
      self.url = string.gsub(self.url, "https", "http")
    else
      redlog("Wrong url")
    end
  end
  self.countdown = serverData.countdown
  local sub_activity = serverData.sub_activity
  if #sub_activity > 0 then
    local sub_activity_ = {}
    for i = 1, #sub_activity do
      local singleSub = sub_activity[i]
      local subData = ActivitySubData.new(singleSub)
      sub_activity_[#sub_activity_ + 1] = subData
    end
    self.sub_activity = sub_activity_
  end
end
function ActivityGroupData:getMultLanContent(serverData, key)
  if serverData[key] and serverData[key] ~= "" then
    return serverData[key]
  end
  local lanData = serverData.data.lang
  if not lanData then
    return ""
  end
  helplog("ActivityGroupData", #lanData)
  local language = ApplicationInfo.GetSystemLanguage()
  local val
  local englishVal = ""
  for i = 1, #lanData do
    local single = lanData[i]
    if single.language == language then
      val = single[key]
      break
    end
    if single.language == 10 then
      englishVal = single[key]
    end
  end
  if val ~= nil then
    helplog("return ActivityGroupData", key, val)
    return val
  end
  return englishVal
end
