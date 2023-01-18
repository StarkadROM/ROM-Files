autoImport("ServantRecommendItemData")
ServantRecommendProxy = class("ServantRecommendProxy", pm.Proxy)
ServantRecommendProxy.Instance = nil
ServantRecommendProxy.NAME = "ServantRecommendProxy"
ServantRecommendProxy.TSHORTCUT = 5
ServantRecommendProxy.STATUS = {
  GO = SceneUser2_pb.ERECOMMEND_STATUS_GO,
  RECEIVE = SceneUser2_pb.ERECOMMEND_STATUS_RECEIVE,
  FINISHED = SceneUser2_pb.ERECOMMEND_STATUS_FINISH,
  EVERPASS = SceneUser2_pb.ERECOMMEND_STATUS_EVER_PASS
}
local MATCH_FORMAT = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
function ServantRecommendProxy:ctor(proxyName, data)
  self.proxyName = proxyName or ServantRecommendProxy.NAME
  if ServantRecommendProxy.Instance == nil then
    ServantRecommendProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end
function ServantRecommendProxy:Init()
  self.rewardStatusMap = {}
  self.classifiedData = {}
  self.staticRecommendInited = false
  self.recommendMap = {}
  self.servantImproveDataMap = {}
  self.servantImproveUnlockFunctionList = {}
  self.servantImproveUnlockMap = {}
  self.modelShow = {}
end
function ServantRecommendProxy:SetServantModelShow(id)
  if not self.modelShow[id] then
    self.modelShow[id] = true
  end
end
function ServantRecommendProxy:SetFatherTable(fatherTableId, fatherTable)
  if not self.grandfather then
    self.grandfather = {}
  end
  if self.grandfather and fatherTableId and fatherTable then
    self.grandfather[fatherTableId] = fatherTable
  end
end
function ServantRecommendProxy:GetFatherTable(fatherTableId)
  if not self.grandfather then
    self.grandfather = {}
  end
  if fatherTableId and self.grandfather[fatherTableId] then
    return self.grandfather[fatherTableId]
  else
    return nil
  end
end
function ServantRecommendProxy:GetModelShow(id)
  return self.modelShow[id]
end
function ServantRecommendProxy:SetCurrentChengZhangId(id)
  self.chengzhangid = id
end
function ServantRecommendProxy:GetCurrentChengZhangId()
  return self.chengzhangid or 1
end
function ServantRecommendProxy:SetCurrentEPId(id)
  self.epid = id
end
function ServantRecommendProxy:GetCurrentEPId()
  return self.epid or 1
end
function ServantRecommendProxy:SetCurrentShowJieMianId(id)
  self.jiemianid = id
end
function ServantRecommendProxy:GetCurrentShowJieMianId()
  return self.jiemianid or 1
end
function ServantRecommendProxy:GetCurrentJinDuId()
  if self.jiemianid == 1 then
    return self:GetCurrentChengZhangId()
  else
    if self.jiemianid == 2 then
      return self:GetCurrentEPId()
    else
    end
  end
  return 0
end
function ServantRecommendProxy:GetCurrentBigCardTable()
  local currentType = self:GetCurrentShowJieMianId()
  if self.bigCardTable and self.bigCardTable[currentType] then
  else
    self.bigCardTable = self.bigCardTable or {}
    self.bigCardTable[currentType] = {}
    for k, v in pairs(Table_ServantImproveGroup) do
      if v.type == currentType then
        table.insert(self.bigCardTable[currentType], v)
      end
    end
    table.sort(self.bigCardTable[currentType], function(a, b)
      return a.id < b.id
    end)
  end
  return self.bigCardTable[currentType]
end
local tempTable = {}
function ServantRecommendProxy:_InitStaticData()
  if self.staticRecommendInited then
    return
  end
  if not self.classifiedData[ServantRecommendProxy.TSHORTCUT] then
    self.classifiedData[ServantRecommendProxy.TSHORTCUT] = {}
  end
  for k, v in pairs(Table_Recommend) do
    if (nil == v.FuncState or FunctionUnLockFunc.checkFuncStateValid(v.FuncState)) and v.Recycle == ServantRecommendProxy.TSHORTCUT then
      TableUtility.TableClear(tempTable)
      tempTable.dwid = v.id
      tempTable.status = SceneUser2_pb.ERECOMMEND_STATUS_GO
      local data = ServantRecommendItemData.new(tempTable)
      TableUtility.ArrayPushBack(self.classifiedData[ServantRecommendProxy.TSHORTCUT], data)
    end
  end
  table.sort(self.classifiedData[ServantRecommendProxy.TSHORTCUT], function(l, r)
    return self:_sortData(l, r)
  end)
  self.staticRecommendInited = true
end
function ServantRecommendProxy:HandleRecommendData(data)
  local items = data.items
  if #items > 1 then
    TableUtility.TableClear(self.recommendMap)
  end
  for k, v in pairs(self.classifiedData) do
    if k ~= ServantRecommendProxy.TSHORTCUT then
      self.classifiedData[k] = nil
    end
  end
  local dailyDoubleID = data.day_double_item
  local weeklyDoubleID = data.week_double_item
  local finished = SceneUser2_pb.ERECOMMEND_STATUS_FINISH
  for i = 1, #items do
    local cell_data = ServantRecommendItemData.new(items[i])
    if nil ~= cell_data.staticData then
      if nil == cell_data.staticData.FuncState or FunctionUnLockFunc.checkFuncStateValid(cell_data.staticData.FuncState) then
        local needDel = cell_data.staticData.NeedDel
        if cell_data.status == finished and needDel and needDel == 1 then
          self.recommendMap[cell_data.id] = nil
        else
          if cell_data.id == dailyDoubleID or cell_data.id == weeklyDoubleID then
            cell_data:SetDouble(true)
          end
          self.recommendMap[cell_data.id] = cell_data
        end
      end
    else
      redlog("女仆---> 服务器发的ID未在recommend表中找到，错误id： ", cell_data.id)
    end
  end
  self.classifiedData[0] = {}
  for _, data in pairs(self.recommendMap) do
    TableUtility.ArrayPushBack(self.classifiedData[0], data)
  end
  table.sort(self.classifiedData[0], function(l, r)
    return self:_sortData(l, r)
  end)
  self:_InitStaticData()
  for id, data in pairs(self.recommendMap) do
    local Recycle = data.staticData and data.staticData.Recycle
    if Recycle and Recycle ~= ServantRecommendProxy.TSHORTCUT then
      if nil == self.classifiedData[Recycle] then
        self.classifiedData[Recycle] = {}
      end
      TableUtility.ArrayPushBack(self.classifiedData[Recycle], data)
    end
    table.sort(self.classifiedData[Recycle], function(l, r)
      return self:_sortData(l, r)
    end)
  end
  self:UpdateWholeRedTip()
end
function ServantRecommendProxy:RecommendIsFull()
  for _, v in pairs(self.recommendMap) do
    if v.status == ServantRecommendProxy.STATUS.GO then
      return false
    end
  end
  return true
end
function ServantRecommendProxy:HandleRewardStatus(data)
  for i = 1, #data do
    local serviceItem = data[i]
    self.rewardStatusMap[serviceItem.favorability] = serviceItem.status
  end
end
function ServantRecommendProxy:GetRecommendData()
  return self.classifiedData[0]
end
function ServantRecommendProxy:GetRecommendMap()
  return self.recommendMap
end
function ServantRecommendProxy:GetRecommendById(id)
  return self.recommendMap[id]
end
function ServantRecommendProxy:GetRewardStatusMap()
  return self.rewardStatusMap
end
local rewardCfg = GameConfig.Servant.reward
function ServantRecommendProxy:GetFavorRewardID()
  for i = 1, #rewardCfg do
    local cell = rewardCfg[i]
    if cell and cell.value and self.rewardStatusMap[cell.value] == 1 then
      return cell.rewardid
    end
  end
  return nil
end
function ServantRecommendProxy:GetRecommendDataByType(t, sort)
  local typeData = self.classifiedData[t]
  if typeData and sort then
    table.sort(typeData, function(l, r)
      return self:_sortData(l, r)
    end)
  end
  return typeData
end
function ServantRecommendProxy:_sortData(left, right)
  if left == nil or right == nil then
    return false
  end
  local lReceive = left.status == ServantRecommendProxy.STATUS.RECEIVE
  local rReceive = right.status == ServantRecommendProxy.STATUS.RECEIVE
  local lFinished = left.status == ServantRecommendProxy.STATUS.FINISHED
  local rFinished = right.status == ServantRecommendProxy.STATUS.FINISHED
  local lGo = left.status == ServantRecommendProxy.STATUS.GO
  local rGo = right.status == ServantRecommendProxy.STATUS.GO
  local lData = left.staticData
  local rData = right.staticData
  local sameRecycle = lData.Recycle == rData.Recycle
  if lReceive and rReceive then
    if sameRecycle then
      return lData.id < rData.id
    else
      return lData.Recycle < rData.Recycle
    end
  end
  if lReceive or rReceive then
    return lReceive == true
  end
  if lGo and rGo then
    if sameRecycle then
      return lData.id < rData.id
    else
      return lData.Recycle < rData.Recycle
    end
  end
  if lGo or rGo then
    return lGo == true
  end
  return lData.id < rData.id
end
function ServantRecommendProxy:GetImproveGroupList()
  local groupList = {}
  for k, v in pairs(self.servantImproveDataMap) do
    local staticData = v.groupid and Table_ServantImproveGroup[v.groupid]
    local valid = ServantRecommendProxy.CheckDateValid(staticData)
    if valid then
      groupList[#groupList + 1] = v
    end
  end
  return groupList
end
function ServantRecommendProxy:GetImproveGroup(groupId)
  return self.servantImproveDataMap[groupId]
end
function ServantRecommendProxy:GetImproveFunctionList()
  return self.servantImproveUnlockFunctionList
end
function ServantRecommendProxy.CheckDateValid(staticData)
  if not staticData or staticData.type ~= SceneUser2_pb.EGROWTH_TYPE_TIME_LIMIT then
    return true
  end
  local validDateArray = {}
  if EnvChannel.IsReleaseBranch() or not BranchMgr.IsChina() then
    validDateArray = {
      staticData.BeginTime,
      staticData.EndTime
    }
  elseif EnvChannel.IsTFBranch() then
    validDateArray = {
      staticData.TFBeginTime,
      staticData.TFEndTime
    }
  end
  if #validDateArray ~= 2 or not validDateArray[1] or not validDateArray[2] then
    return true
  end
  if StringUtil.IsEmpty(validDateArray[1]) or StringUtil.IsEmpty(validDateArray[2]) then
    return true
  end
  local year1, month1, day1, hour1, min1, sec1 = validDateArray[1]:match(MATCH_FORMAT)
  local year2, month2, day2, hour2, min2, sec2 = validDateArray[2]:match(MATCH_FORMAT)
  local startDate = os.time({
    day = day1,
    month = month1,
    year = year1,
    hour = hour1,
    min = min1,
    sec = sec1
  })
  local endDate = os.time({
    day = day2,
    month = month2,
    year = year2,
    hour = hour2,
    min = min2,
    sec = sec2
  })
  local curServerTime = ServerTime.CurServerTime() / 1000
  if curServerTime and (startDate > curServerTime or endDate < curServerTime) then
    return false
  end
  return true
end
function ServantRecommendProxy:CheckDailyDoubleReward(id)
  local config = GameConfig.Servant.day_pool and GameConfig.Servant.day_pool.pool
  if not config then
    return false
  end
  for version, info in pairs(config) do
    local poolList = info.pool_items
    if TableUtility.ArrayFindIndex(poolList, id) > 0 then
      return true
    end
  end
  return false
end
function ServantRecommendProxy:CheckWeeklyDoubleReward(id)
  local config = GameConfig.Servant.week_pool and GameConfig.Servant.week_pool.pool
  if not config then
    return false
  end
  for version, info in pairs(config) do
    local poolList = info.pool_items
    if TableUtility.ArrayFindIndex(poolList, id) > 0 then
      return true
    end
  end
  return false
end
function ServantRecommendProxy:HandleServantImproveData(severdata)
  local isGroupChanged = false
  local isProgressChanged = false
  if severdata.datas and #severdata.datas > 0 then
    for i = 1, #severdata.datas do
      local groupdata = severdata.datas[i]
      local newGroupId
      local groupItems = groupdata.items
      if groupItems and #groupItems > 0 then
        newGroupId = math.floor(groupItems[1].dwid / 1000)
        helplog("groupId对应item长度", newGroupId, #groupItems)
        isGroupChanged = true
      end
      local valueitems = groupdata.valueitems
      if valueitems then
        if valueitems.groupid and valueitems.groupid ~= 0 then
          newGroupId = valueitems.groupid
        end
        if valueitems.growth and valueitems.growth ~= 0 then
          isProgressChanged = true
        end
      end
      if newGroupId and Table_ServantImproveGroup[newGroupId] then
        local sameTypeGroup
        for k, v in pairs(self.servantImproveDataMap) do
          if v.groupid == newGroupId then
            sameTypeGroup = v
            break
          end
        end
        if sameTypeGroup then
          self.servantImproveDataMap[newGroupId]:updata(newGroupId, groupItems, valueitems)
        else
          local newGroup = ServantImproveData.new(newGroupId, groupItems, valueitems)
          self.servantImproveDataMap[newGroupId] = newGroup
        end
      end
    end
  end
  if isGroupChanged then
    GameFacade.Instance:sendNotification(ServantImproveEvent.ItemListUpdate, groupdata)
  end
  if isProgressChanged then
    GameFacade.Instance:sendNotification(ServantImproveEvent.GiftProgressUpdate, groupdata)
  end
  local unlockitems = severdata.unlockitems
  if unlockitems and #unlockitems > 0 then
    for i = 1, #unlockitems do
      local oldItem = self.servantImproveUnlockMap[unlockitems[i]]
      if oldItem == nil then
        self.servantImproveUnlockMap[unlockitems[i]] = unlockitems[i]
        self.servantImproveUnlockFunctionList[#self.servantImproveUnlockFunctionList + 1] = unlockitems[i]
      end
    end
    GameFacade.Instance:sendNotification(ServantImproveEvent.FunctionListUpdate, severdata)
  end
end
ServantRecommendProxy.WholeRedTipID = 10406
function ServantRecommendProxy:UpdateWholeRedTip()
  for _, v in pairs(self.recommendMap) do
    if v.status == 2 then
      RedTipProxy.Instance:UpdateRedTip(self.WholeRedTipID)
      return
    end
  end
  local questData = QuestProxy.Instance:GetQuestDataBySameQuestID(305000001)
  if questData and questData.params.canSubmit then
    RedTipProxy.Instance:UpdateRedTip(self.WholeRedTipID)
    return
  end
  RedTipProxy.Instance:RemoveWholeTip(self.WholeRedTipID)
end
ServantImproveData = class("ServantImproveData")
function ServantImproveData:ctor(newGroupId, itemsData, valueData)
  self:updata(newGroupId, itemsData, valueData)
end
function ServantImproveData:updata(newGroupId, itemsData, valueData)
  self.groupid = newGroupId
  if itemsData then
    if not self.itemList then
      self.itemList = {}
      self.finishList = {}
      self.itemMap = {}
      self.finishMap = {}
    end
    for i = 1, #itemsData do
      local newItemInfo = itemsData[i]
      local oldItem = self.itemMap[newItemInfo.dwid]
      if oldItem then
        local isDelete = Table_Growth[oldItem.dwid].NeedDel or 0
        if isDelete == 1 and newItemInfo.status == SceneUser2_pb.EGROWTH_STATUS_FINISH then
          local removeIndex
          local itemListRef = self.itemList
          for j = 1, #itemListRef do
            if itemListRef[j] == oldItem then
              removeIndex = j
            end
          end
          if removeIndex then
            local removeItem = self.itemList[removeIndex]
            if self.finishMap[removeItem.dwid] == nil then
              self.finishMap[removeItem.dwid] = removeItem
              self.finishList[#self.finishList + 1] = removeItem
            end
            table.remove(self.itemList, removeIndex)
            self.itemMap[oldItem.dwid] = nil
          end
        else
          oldItem:updata(newItemInfo)
        end
      else
        local isDelete = Table_Growth[newItemInfo.dwid].NeedDel or 0
        local newItem = GrowthItemData.new(newItemInfo)
        if isDelete == 1 and newItemInfo.status == SceneUser2_pb.EGROWTH_STATUS_FINISH then
          if self.finishMap[newItem.dwid] == nil then
            self.finishMap[newItem.dwid] = newItem
            self.finishList[#self.finishList + 1] = newItem
          end
        else
          self.itemList[#self.itemList + 1] = newItem
          self.itemMap[newItemInfo.dwid] = newItem
        end
      end
    end
  end
  if valueData then
    if valueData.growth and valueData.growth ~= 0 then
      self.growth = valueData.growth
    end
    local everRewardList = valueData.everreward
    if everRewardList and #everRewardList > 0 then
      self.everReward = {}
      for i = 1, #everRewardList do
        self.everReward[#self.everReward + 1] = everRewardList[i]
      end
    end
  end
end
GrowthItemData = class("GrowthItemData")
function GrowthItemData:ctor(data)
  self:updata(data)
end
function GrowthItemData:updata(data)
  self.dwid = data.dwid
  self.finishtimes = data.finishtimes
  self.status = data.status
  self.staticData = Table_Growth[self.dwid]
end
