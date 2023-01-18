SignIn21Proxy = class("SignIn21Proxy", pm.Proxy)
local tempTable = {}
function SignIn21Proxy:ctor(proxyName, data)
  self.proxyName = proxyName or "SignIn21Proxy"
  if SignIn21Proxy.Instance == nil then
    SignIn21Proxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end
function SignIn21Proxy:Init()
  self.today = 0
  self:InitStaticData()
end
local levelPointMap, dayTargetDataMap = {}, {}
local sortFunc = function(l, r)
  local ls, rs = r.Sort or l.Sort or math.huge, math.huge
  return ls < rs
end
function SignIn21Proxy:InitStaticData()
  local noviceTargetCFG = GameConfig.NoviceTargetPointCFG
  self.currentVersion = noviceTargetCFG.CurVersion or 0
  self.cfg = noviceTargetCFG.VersionCfg[self.currentVersion]
  self.cfg = self.cfg and self.cfg.LevelReward
  self.MaxDay = 0
  local dayData
  for _, d in pairs(Table_NoviceTarget) do
    if d.Version == self.currentVersion or self.currentVersion == 0 and not d.Version then
      dayData = dayTargetDataMap[d.Day] or {}
      TableUtility.ArrayPushBack(dayData, d)
      dayTargetDataMap[d.Day] = dayData
      if d.Day > self.MaxDay then
        self.MaxDay = d.Day
      end
    end
  end
  if self.cfg then
    for i = 1, #self.cfg do
      levelPointMap[i] = self.cfg[i].point
    end
  end
  levelPointMap[0] = 0
  for _, tData in pairs(dayTargetDataMap) do
    table.sort(tData, sortFunc)
  end
end
function SignIn21Proxy:GetLevelFromTargetPoint(point)
  if not next(levelPointMap) then
    return
  end
  point = math.max(point or 0, 0)
  for i = 0, self:GetMaxLevel() - 1 do
    if point >= levelPointMap[i] and point < levelPointMap[i + 1] then
      return i
    end
  end
  return self:GetMaxLevel()
end
function SignIn21Proxy:GetProgressFromTargetPoint(point, calculatedLevel)
  calculatedLevel = calculatedLevel or self:GetLevelFromTargetPoint(point)
  if not calculatedLevel or not point then
    return
  end
  local nextLevelPoint = levelPointMap[calculatedLevel + 1]
  return nextLevelPoint and (point - levelPointMap[calculatedLevel]) / (nextLevelPoint - levelPointMap[calculatedLevel]) or 1
end
function SignIn21Proxy:GetLevelAndProgressFromTargetPoint(point)
  point = point or self:GetMyTargetPoint()
  local level = self:GetLevelFromTargetPoint(point)
  return level, self:GetProgressFromTargetPoint(point, level)
end
function SignIn21Proxy:GetRewardItemIdsFromTargetLevel(level)
  local cfg = self.cfg and self.cfg[level]
  return cfg and ItemUtil.GetRewardItemIdsByTeamId(cfg.reward)
end
function SignIn21Proxy:GetMaxLevel()
  return #self.cfg
end
function SignIn21Proxy:GetTargetDataByDay(day)
  return dayTargetDataMap[day]
end
function SignIn21Proxy:GetTodayTargetData()
  return self:GetTargetDataByDay(self.today)
end
function SignIn21Proxy:RecvNoviceTargetUpdate(datas, dels, today)
  self.today = today
  self.targetProgressMap = self.targetProgressMap or {}
  self.targetStateMap = self.targetStateMap or {}
  local d
  for i = 1, #datas do
    d = datas[i]
    self.targetProgressMap[d.id] = d.progress
    self.targetStateMap[d.id] = d.state
  end
  if dels then
    for i = 1, #dels do
      d = dels[i]
      self.targetProgressMap[d] = nil
      self.targetStateMap[d] = nil
    end
  end
end
function SignIn21Proxy:GetTargetProgress(id)
  return self.targetProgressMap[id]
end
function SignIn21Proxy:GetTargetState(id)
  return self.targetStateMap[id]
end
function SignIn21Proxy:IsAllTargetOfDayComplete(day, finishAll)
  local datas = self:GetTargetDataByDay(day)
  if not datas or not next(datas) then
    return false
  end
  local completed, data = true, nil
  for i = 1, #datas do
    data = datas[i]
    if data.id < GameConfig.NoviceTargetPointCFG.UnlockFunctionId then
      completed = completed and self:GetTargetState(data.id) == SceneUser2_pb.ENOVICE_TARGET_REWARDED or not finishAll and completed and self:GetTargetState(data.id) == SceneUser2_pb.ENOVICE_TARGET_FINISH
    end
  end
  return completed
end
function SignIn21Proxy:IsAllTargetOfTodayComplete()
  return self:IsAllTargetOfDayComplete(self.today)
end
function SignIn21Proxy:IsAllTargetComplete()
  local complete = true
  for i = 1, self.MaxDay do
    complete = complete and self:IsAllTargetOfDayComplete(i, true)
  end
  return complete
end
function SignIn21Proxy:HasUnrewardedTarget()
  if not self.targetStateMap then
    return
  end
  local b = false
  for _, state in pairs(self.targetStateMap) do
    if state == SceneUser2_pb.ENOVICE_TARGET_FINISH then
      b = true
      break
    end
  end
  return b
end
function SignIn21Proxy:GetFirstDayWithUnrewardedTarget()
  if not self.targetStateMap then
    return
  end
  TableUtility.TableClear(tempTable)
  for id, state in pairs(self.targetStateMap) do
    if state == SceneUser2_pb.ENOVICE_TARGET_FINISH then
      TableUtility.ArrayPushBack(tempTable, id)
    end
  end
  table.sort(tempTable)
  if not tempTable[1] or not Table_NoviceTarget[tempTable[1]].Day then
    local day
  end
  day = day and math.clamp(day, 1, self.today)
  return day
end
function SignIn21Proxy:GetMyTargetPoint()
  return Game.Myself.data.userdata:Get(UDEnum.NOVICE_TARGET_POINT)
end
