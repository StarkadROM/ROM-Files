local _AllPrayType = {
  [GuildCmd_pb.EPRAYTYPE_GODDESS] = 0,
  [GuildCmd_pb.EPRAYTYPE_GVG_ATK] = 1,
  [GuildCmd_pb.EPRAYTYPE_GVG_DEF] = 2,
  [GuildCmd_pb.EPRAYTYPE_GVG_ELE] = 3,
  [GuildCmd_pb.EPRAYTYPE_HOLYBLESS] = 4
}
local _TableClear = TableUtility.TableClear
local _ArrayClear = TableUtility.ArrayClear
local _ArrayPushBack = TableUtility.ArrayPushBack
local _updateGoddess = function(guildMemberPray)
  local id = guildMemberPray.pray
  local lv = guildMemberPray.lv
  local goddessMap = GuildPrayProxy.Instance:_GetGoddessPray()
  if goddessMap[id] then
    goddessMap[id]:UpdateLv(lv)
  end
end
local _updateGvgHoly = function(guildMemberPray)
  local t = Table_Guild_Faith[guildMemberPray.pray] and Table_Guild_Faith[guildMemberPray.pray].Type
  if t then
    GuildPrayProxy.Instance:_updateGvgPray(t, guildMemberPray)
  end
end
local _sortFunc = function(a, b)
  if a.type == b.type then
    return a.staticData.Index < b.staticData.Index
  else
    return a.type < b.type
  end
end
local _updateCalls = {
  [GuildCmd_pb.EPRAYTYPE_GODDESS] = _updateGoddess,
  [GuildCmd_pb.EPRAYTYPE_HOLYBLESS] = _updateGvgHoly,
  [GuildCmd_pb.EPRAYTYPE_GVG_ATK] = _updateGvgHoly,
  [GuildCmd_pb.EPRAYTYPE_GVG_DEF] = _updateGvgHoly,
  [GuildCmd_pb.EPRAYTYPE_GVG_ELE] = _updateGvgHoly
}
autoImport("GvGPvpPrayData")
GuildPrayProxy = class("GuildPrayProxy", pm.Proxy)
GuildPrayProxy.Instance = nil
GuildPrayProxy.NAME = "GuildPrayProxy"
function GuildPrayProxy:ctor(proxyName, data)
  self.proxyName = proxyName or GuildPrayProxy.NAME
  if GuildPrayProxy.Instance == nil then
    GuildPrayProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end
function GuildPrayProxy:Init()
  self.prayMap = {}
  self.prayList = {}
  for t, _ in pairs(_AllPrayType) do
    self.prayMap[t] = {}
    self.prayList[t] = {}
  end
  self.typeDirty = {}
  self:_InitStatic()
end
function GuildPrayProxy:_InitStatic()
  for _, v in pairs(Table_Guild_Faith) do
    if v.Type == GuildCmd_pb.EPRAYTYPE_GODDESS then
      local simplePray = SimplePrayData.new(v)
      self.prayMap[v.Type][simplePray.id] = simplePray
    end
  end
end
function GuildPrayProxy:_updateGvgPray(t, guildMemberPray)
  local cellData = GvGPvpPrayData.new(guildMemberPray)
  self.prayMap[t][cellData.staticId] = cellData
end
function GuildPrayProxy:GetHolyPrayById(id)
  local map = self:_GetHolyPray()
  if map then
    return map[id]
  end
end
function GuildPrayProxy:HandleServerNtf(prays)
  for i = 1, #prays do
    self:UpdatePray(prays[i])
  end
end
function GuildPrayProxy:UpdateGuildPraySchedule(pray_schedule)
  if not pray_schedule then
    self.mGPray = 0
    self.mGBless = 0
    self.gBless = 0
  else
    self.mGPray = pray_schedule[1] or 0
    self.mGBless = pray_schedule[2] or 0
    self.gBless = pray_schedule[3] or 0
  end
end
function GuildPrayProxy:GetSchedule_MGBless()
  return self.mGBless or 0
end
function GuildPrayProxy:GetSchedule_MGPray()
  return self.mGPray
end
function GuildPrayProxy:GetSchedule_GBless()
  return self.gBless
end
function GuildPrayProxy:CheckGVGPrayed(t)
  local mapData = self.prayMap[t]
  if not mapData then
    return false
  end
  for _, v in pairs(mapData) do
    if v.curPray.lv > 0 then
      return true
    end
  end
  return false
end
function GuildPrayProxy:CheckGoddessPrayReachedLevel(prayId, targetLv)
  local guildPray = self:_GetGoddessPray()
  if not guildPray then
    return false
  end
  local data = guildPray[prayId]
  if not data or not data.level then
    return false
  end
  targetLv = targetLv or 0
  return targetLv <= data.level
end
function GuildPrayProxy:TryGoddessPrayAddLevel(prayId, targetLv, maxLv)
  local guildPray = self:_GetGoddessPray()
  if not guildPray then
    return false
  end
  local data = guildPray[prayId]
  if not data or not data.level then
    return false
  end
  local nextLv = data.level + targetLv
  local result = {}
  result.flag = maxLv <= data.level
  if maxLv < nextLv then
    result.msg = data.staticData.Name
  end
  return result
end
function GuildPrayProxy:UpdatePray(guildMemberPray)
  local id = guildMemberPray.pray
  local lv = guildMemberPray.lv
  local tb = Table_Guild_Faith[id]
  if tb ~= nil then
    local updateFunc = _updateCalls[tb.Type]
    if updateFunc then
      updateFunc(guildMemberPray)
      self.typeDirty[tb.Type] = true
    end
  else
    redlog("Table_Guild_Faith 表id配置有误")
  end
end
function GuildPrayProxy:GetPrayListByType(t)
  if not self.prayMap[t] then
    return
  end
  if self.typeDirty[t] then
    self.typeDirty[t] = false
    _ArrayClear(self.prayList[t])
    for _, v in pairs(self.prayMap[t]) do
      _ArrayPushBack(self.prayList[t], v)
    end
    table.sort(self.prayList[t], function(l, r)
      return _sortFunc(l, r)
    end)
  end
  return self.prayList[t]
end
function GuildPrayProxy:_GetGoddessPray()
  return self.prayMap[GuildCmd_pb.EPRAYTYPE_GODDESS]
end
function GuildPrayProxy:_GetHolyPray()
  return self.prayMap[GuildCmd_pb.EPRAYTYPE_HOLYBLESS]
end
SimplePrayData = class("SimplePrayData")
function SimplePrayData:ctor(staticData)
  self.staticData = staticData
  self.id = staticData.id
  self.type = staticData.Type
  self.level = 0
end
function SimplePrayData:UpdateLv(v)
  self.level = v
end
