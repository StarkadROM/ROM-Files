autoImport("LotteryMonthGroupData")
LotteryMonthData = class("LotteryMonthData")
local _ArrayClear = TableUtility.ArrayClear
function LotteryMonthData:ctor()
  self.monthGroupList = {}
end
function LotteryMonthData:SetData(data)
  if data then
    _ArrayClear(self.monthGroupList)
    local _LotteryProxy = LotteryProxy.Instance
    for i = 1, #data.infos do
      local info = data.infos[i]
      local groupId = _LotteryProxy:GetMonthGroupId(info.year, info.month)
      if groupId ~= nil then
        local group = self:GetMonthGroupById(groupId)
        if group == nil then
          group = LotteryMonthGroupData.new(groupId)
          TableUtility.ArrayPushBack(self.monthGroupList, group)
        end
        group:AddMonth(info)
      end
    end
    table.sort(self.monthGroupList, LotteryMonthData._SortMonthGroup)
    self.todayCount = data.today_cnt
    self.maxCount = data.max_cnt
    self.todayExtraCount = data.today_extra_cnt
    self.maxExtraCount = data.max_extra_cnt
  end
end
function LotteryMonthData:SetTodayCount(count)
  self.todayCount = count
end
function LotteryMonthData:SetOnceMaxCount(onceMaxCount)
  self.onceMaxCount = onceMaxCount
end
function LotteryMonthData:GetMonthGroupList()
  return self.monthGroupList
end
function LotteryMonthData:GetMonthGroupById(groupId)
  for i = 1, #self.monthGroupList do
    local group = self.monthGroupList[i]
    if group.id == groupId then
      return group
    end
  end
  return nil
end
function LotteryMonthData._SortMonthGroup(l, r)
  return l.id > r.id
end
function LotteryMonthData:SetTodayExtraCount(count)
  self.todayExtraCount = count
end
function LotteryMonthData:SetTodayTenCount(todayTenCount, maxTenCount)
  self.todayTenCount = todayTenCount
  if maxTenCount ~= nil then
    self.maxTenCount = maxTenCount
  end
end
function LotteryMonthData:SetSafetyInfo(sInfos)
end
