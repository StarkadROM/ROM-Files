autoImport("FuncUnlockManulData")
QuestManualProxy = class("QuestManualProxy", pm.Proxy)
QuestManualProxy.Instance = nil
QuestManualProxy.NAME = "QuestManualProxy"
function QuestManualProxy:ctor(proxyName, data)
  self.proxyName = proxyName or QuestManualProxy.NAME
  if QuestManualProxy.Instance == nil then
    QuestManualProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:InitProxy()
end
function QuestManualProxy:InitProxy()
  self.manualDataVersionMap = {}
  self.lastVersion = 1
  self.lastTab = 0
  self.lastGenTab = 1
  self.currentStoryAudioIndex = 0
  self.continueQuestMap = {}
  self:InitContinueQuest()
  self:PreprocessPlotVoice()
  self.setEnd = false
  self.manualVersionGoal = {}
  self.versionGoalReward = {}
end
function QuestManualProxy:InitProxyData()
  if self.manualDataVersionMap then
    TableUtility.TableClear(self.manualDataVersionMap)
  end
  if self.funcOpenMap then
    TableUtility.TableClear(self.funcOpenMap)
  end
  if self.funcOpenList then
    TableUtility.ArrayClear(self.funcOpenList)
  end
end
function QuestManualProxy:GetManualQuestDatas(version)
  self.recentVersion = version
  return self.manualDataVersionMap[version]
end
function QuestManualProxy:GetQuestNameDataById(questId)
  local questName = ""
  if self.recentVersion then
    local versionData = self.manualDataVersionMap[self.recentVersion]
    if versionData then
      questName = versionData.prequest[questId]
    end
  end
  return questName
end
function QuestManualProxy:HandleRecvQueryManualQuestCmd(data)
  local version = data.version
  local manual = data.manual
  if manual then
    local oldData = self.manualDataVersionMap[version]
    if not oldData then
      manualData = ManualData.new(manual, version)
      self.manualDataVersionMap[version] = manualData
    end
  end
end
function QuestManualProxy:OpenPuzzle(version, index)
  local versionData = self.manualDataVersionMap[version]
  if versionData then
    local openPuzzles = versionData.main.puzzle.open_puzzles
    openPuzzles[#openPuzzles + 1] = index
    local curentPuzzleCount = #openPuzzles
    local colectAwardList = self:GetQuestPuzzleCollectListByVersion(version)
    local unlockPuzzles = versionData.main.puzzle.unlock_puzzles
    for i = 1, #colectAwardList do
      if curentPuzzleCount == colectAwardList[i].indexss then
        unlockPuzzles[#unlockPuzzles + 1] = curentPuzzleCount
      end
    end
  end
end
function QuestManualProxy:CheckPuzzleAwardLock(version, index)
  local versionData = self.manualDataVersionMap[version]
  if versionData then
    local unlockPuzzles = versionData.main.puzzle.unlock_puzzles
    for i = 1, #unlockPuzzles do
      if unlockPuzzles[i] == index then
        return false
      end
    end
  end
  return true
end
function QuestManualProxy:GetQuestPuzzleCollectListByVersion(version)
  local puzzleList = {}
  for k, v in pairs(Table_QuestPuzzle) do
    if v.version == version and v.type == "collect" then
      puzzleList[#puzzleList + 1] = v
    end
  end
  return puzzleList
end
function QuestManualProxy:SetCurrentStoryAudioIndex(value)
  self.currentStoryAudioIndex = value
end
function QuestManualProxy:GetCurrentStoryAudioIndex()
  return self.currentStoryAudioIndex
end
function QuestManualProxy:CheckContinueNeed(versionId, tabId)
  local continueQuestId = 0
  if self.continueQuestMap[versionId] then
    continueQuestId = self.continueQuestMap[versionId][tabId]
  end
  local versionDatas = self:GetManualQuestDatas(versionId)
  if versionDatas and versionDatas.main.questList and 0 < #versionDatas.main.questList then
    for i = 1, #versionDatas.main.questList do
      local single = versionDatas.main.questList[i]
      if (single.type == SceneQuest_pb.EQUESTLIST_COMPLETE or single.type == SceneQuest_pb.EQUESTLIST_SUBMIT) and single.questData and single.questData.id == continueQuestId then
        xdlog("相同任务", tabId)
        return true
      end
    end
  end
  return false
end
QuestName = class("QuestName")
function QuestName:ctor(serverdata)
  if serverdata then
    self.id = serverdata.id
    self.name = serverdata.name
    self.questlisttype = serverdata.type
  end
end
function QuestName:GetQuestName()
  return self.name
end
function QuestName:isComplete()
  return self.questlisttype == SceneQuest_pb.EQUESTLIST_COMPLETE or self.questlisttype == SceneQuest_pb.EQUESTLIST_SUBMIT
end
ManualData = class("ManualData")
function ManualData:ctor(data, version)
  self.version = version
  self:updata(data)
end
function ManualData:updata(data)
  self.prequest = {}
  if data.prequest and #data.prequest > 0 then
    for i = 1, #data.prequest do
      local quest = data.prequest[i]
      local qdata = QuestName.new(quest)
      self.prequest[quest.id] = qdata
    end
  end
  if data.main then
    self.main = {}
    self.main.questList = {}
    local mainItems = data.main.items
    if mainItems and #mainItems > 0 then
      helplog("主线手动数据总长度", #mainItems)
      for i = 1, #mainItems do
        self.main.questList[#self.main.questList + 1] = QuestManualItem.new(mainItems[i], self.prequest)
      end
    end
    if data.main.puzzle then
      self.main.puzzle = QuestPuzzle.new(data.main.puzzle)
    end
    local mainStoryids = data.main.mainstoryid
    if type(mainStoryids) == "table" then
      if mainStoryids and #mainStoryids > 0 then
        self.main.mainstoryid = {}
        for i = 1, #mainStoryids do
          self.main.mainstoryid[#self.main.mainstoryid + 1] = mainStoryids[i]
        end
      end
    else
      self.main.mainstoryid = mainStoryids
    end
    if data.main.previews then
      self.main.questPreviewList = {}
      local previewItems = data.main.previews
      if previewItems and #previewItems > 0 then
        for i = 1, #previewItems do
          self.main.questPreviewList[#self.main.questPreviewList + 1] = QuestPreviewItem.new(previewItems[i])
        end
        table.sort(self.main.questPreviewList, function(l, r)
          return l.index < r.index
        end)
      end
    end
  end
  if data.branch then
    self.branch = {}
    local questShops = data.branch.shops
    for i = 1, #questShops do
      self.branch[#self.branch + 1] = BranchQuestManualItem.new(questShops[i], self.prequest)
    end
  end
  if data.story and data.story.previews then
    self.storyQuestList = {}
    local storyItems = data.story.previews
    if storyItems and #storyItems > 0 then
      for i = 1, #storyItems do
        self.storyQuestList[#self.storyQuestList + 1] = QuestPreviewItem.new(storyItems[i])
      end
    end
    self.poemCompleteList = {}
    local completelist = data.story.submit_ids
    local len = #completelist
    local k = 0
    for i = 1, len do
      k = completelist[i]
      self.poemCompleteList[k] = k
    end
  end
  if data.plotvoice then
    self.plotVoiceQuestList = {}
    for i = 1, #data.plotvoice do
      table.insert(self.plotVoiceQuestList, data.plotvoice[i])
    end
  end
end
function ManualData:CheckContinueNeed()
  return self.needContinue
end
function QuestManualProxy:InitFunctionOpening()
  if not self.funcOpenMap then
    self.funcOpenMap = {}
  else
    TableUtility.TableClear(self.funcOpenMap)
  end
  if not self.funcOpenList then
    self.funcOpenList = {}
  else
    TableUtility.TableClear(self.funcOpenList)
  end
end
function QuestManualProxy:GetFunctionOpeningData(categoryIndex)
  if self.funcOpenMap then
    return self.funcOpenMap[categoryIndex]
  end
  return nil
end
function QuestManualProxy:GetCategoryList()
  return self.funcOpenList
end
function QuestManualProxy:RecvManualFunctionQuestCmd(serverdata)
  if serverdata.items then
    local displayRace = MyselfProxy.Instance:GetMyRace()
    self:InitFunctionOpening()
    local datas = serverdata.items
    for i = 1, #datas do
      local single = datas[i]
      local key = Table_FunctionOpening[single.id].Type
      local configRace = Table_FunctionOpening[single.id].Race
      local funcState
      if Table_FunctionOpening[single.id].FuncState and not FunctionUnLockFunc.checkFuncStateValid(Table_FunctionOpening[single.id].FuncState) then
        funcState = false
      else
        funcState = true
      end
      if configRace == displayRace and funcState then
        if not self.funcOpenMap[key] then
          self.funcOpenMap[key] = {}
          table.insert(self.funcOpenList, key)
        end
        local fdata = FuncUnlockManulData.new(single)
        table.insert(self.funcOpenMap[key], fdata)
      end
    end
    if self.funcOpenList and #self.funcOpenList > 0 then
      table.sort(self.funcOpenList, function(l, r)
        return l < r
      end)
    end
  end
end
function QuestManualProxy:CheckProgress(categoryIndex)
  if self.funcOpenMap then
    local tempC = self.funcOpenMap[categoryIndex]
    local total = #tempC
    local current = 0
    local stop = 0
    for i = 1, total do
      if FunctionUnLockFunc.Me():CheckCanOpen(tempC[i].menuid) then
        current = current + 1
      elseif not tempC[i]:GetCurrentTraceQuest() then
        stop = stop + 1
      end
    end
    return current, total, total - current == stop
  end
end
function QuestManualProxy:GetVersionlist()
  local questversion = ReusableTable.CreateArray()
  local myPro = Game.Myself.data.userdata:Get(UDEnum.PROFESSION)
  for k, v in pairs(Table_QuestVersion) do
    local copy = {}
    if v.ClassID and #v.ClassID ~= 0 then
      local findFlag = false
      for i = 1, #v.ClassID do
        if myPro == v.ClassID[i] then
          findFlag = true
          break
        end
      end
      if findFlag then
        TableUtility.TableShallowCopy(copy, v)
        TableUtility.ArrayPushBack(questversion, copy)
      end
    else
      TableUtility.TableShallowCopy(copy, v)
      TableUtility.ArrayPushBack(questversion, copy)
    end
  end
  table.sort(questversion, function(l, r)
    return l.id < r.id
  end)
  return questversion
end
function QuestManualProxy:InitContinueQuest()
  for k, v in pairs(Table_MainStory) do
    if v.ToBeContinued and v.ToBeContinued == 1 then
      redlog("tonumber(v.version)", v.version, v.QuestID[1])
      if not self.continueQuestMap[v.version] then
        self.continueQuestMap[v.version] = {}
      end
      local tab = v.Tab or 1
      self.continueQuestMap[v.version][tab] = v.QuestID[1]
    end
  end
end
function QuestManualProxy:GetContinueQuest(version)
  if self.continueQuestMap[version] then
    return self.continueQuestMap[version]
  end
end
function QuestManualProxy:GetPlotQuestList(version)
  return self.manualDataVersionMap[version] and self.manualDataVersionMap[version].plotVoiceQuestList
end
function QuestManualProxy:PreprocessPlotVoice()
  if not self.plotVoiceMap then
    self.plotVoiceMap = {}
  else
    TableUtility.TableClear(self.plotVoiceMap)
  end
  local versionid
  for k, v in pairs(Table_PlotVoice) do
    versionid = v.Version
    if not self.plotVoiceMap[versionid] then
      self.plotVoiceMap[versionid] = {}
      self.plotVoiceMap[versionid] = PlotVoiceData.new(versionid, v.Map, k)
    else
      self.plotVoiceMap[versionid]:Update(versionid, v.Map, k)
    end
  end
end
function QuestManualProxy:GetPlotVoiceData(versionid)
  return self.plotVoiceMap[versionid]
end
local pData, mapquestIndex
local pQuestID = 1
local pQuestlist
function QuestManualProxy:CheckPlotQuestComplete(version, mapID)
  pData = self.plotVoiceMap[version]
  mapquestIndex = pData:GetMapQuestList(mapID)
  pQuestlist = self:GetPlotQuestList(version)
  local completeCount = 0
  for i = 1, #mapquestIndex do
    pQuestID = Table_PlotVoice[mapquestIndex[i]].QuestID
    for j = 1, #pQuestlist do
      if pQuestID == pQuestlist[j] then
        completeCount = completeCount + 1
      end
    end
  end
  return completeCount == #mapquestIndex
end
function QuestManualProxy:CheckPlotCompleteByQuestID(version, questid)
  pData = self.plotVoiceMap[version]
  pQuestlist = self:GetPlotQuestList(version)
  for j = 1, #pQuestlist do
    if questid == pQuestlist[j] then
      return true
    end
  end
  return false
end
function QuestManualProxy:RecvQueryGoalListGoalCmd(data)
  helplog("版本目标消息", data.version)
  local versionData = self.manualVersionGoal[data.version]
  if not versionData then
    self.manualVersionGoal[data.version] = {}
  end
  local sdata = {}
  sdata.version = data.version
  local score = {}
  score.score = data.score.score
  score.version = data.score.version
  if data.score.rewards then
    local rewards = {}
    for i = 1, #data.score.rewards do
      rewards[#rewards + 1] = data.score.rewards[i]
    end
    score.rewards = rewards
  end
  helplog("当前版本分数", score.score, score.version)
  sdata.score = score
  if data.items then
    local items = {}
    helplog("items长度", #data.items)
    for i = 1, #data.items do
      local single = data.items[i]
      helplog(string.format("item参数内容id:%s,process%s,status%s,领取情况%s", single.id, single.process, single.status, single.point))
      items[single.id] = {
        id = single.id,
        process = single.process,
        status = single.status,
        point = single.point
      }
    end
    sdata.items = items
  end
  self.manualVersionGoal[data.version] = sdata
  if data.groups then
    helplog("Groups长度", #data.groups)
    for i = 1, #data.groups do
      local single = data.groups[i]
      self.versionGoalReward[single.group] = single.rewardcount
      xdlog("奖励列表", single.group, single.rewardcount)
    end
  end
end
function QuestManualProxy:RecvNewGoalItemUpdateGoalCmd(data)
  local item = data.item
  if not item then
    redlog("GoalItem更新，无item")
    return
  end
  local id = item.id
  local staticData
  for k, v in pairs(Table_VersionGoal) do
    if v.group * 10000 + v.step == id then
      staticData = Table_VersionGoal[k]
    end
  end
  if staticData then
    local single = self.manualVersionGoal[staticData.Version]
    if single then
      if single.items and single.items[id] then
        helplog("表内存在相同数据")
        single.items[id].process = item.process
        single.items[id].status = item.status
        single.items[id].point = item.point
        return
      end
      helplog("未检索到内容，新增GoalItem")
      single.items[id] = {
        id = item.id,
        process = item.process,
        status = item.status,
        point = single.point
      }
    end
  end
end
function QuestManualProxy:RecvNewGroupUpdateGoalCmd(data)
  local groupData = data.group
  if groupData then
    local groupid = groupData.group
    if groupid and groupid ~= 0 then
      self.versionGoalReward[groupid] = groupData.rewardcount
      xdlog("单独更新奖励进度", groupid, groupData.rewardcount)
    end
  end
end
function QuestManualProxy:RecvNewGoalScoreUpdateGoalCmd(data)
  local score = data.score
  local version = score.version
  helplog("分数刷新，所属version为" .. version)
  local single = self.manualVersionGoal[version]
  if single then
    local scorePart = {}
    helplog("更新表内version分数", score.score)
    scorePart.score = score.score
    scorePart.version = score.version
    if score.rewards then
      local rewards = {}
      for i = 1, #score.rewards do
        rewards[#rewards + 1] = score.rewards[i]
      end
      scorePart.rewards = rewards
    end
    single.score = scorePart
  end
  helplog("当前版本分数", score.score, score.version)
end
function QuestManualProxy:GetVersionGoalList(version)
  if self.manualVersionGoal[version] then
    return self.manualVersionGoal[version]
  end
end
PlotVoiceData = class("PlotVoiceData")
function PlotVoiceData:ctor(version, mapID, index)
  self.mapQuest = {}
  self.mapID = mapID
  self.version = version
  self.maplist = {}
  self:Update(version, mapID, index)
end
function PlotVoiceData:Update(version, mapID, index)
  local single = {}
  single.mapID = mapID
  single.version = version
  if not self.mapQuest[mapID] then
    self.mapQuest[mapID] = {}
    table.insert(self.maplist, single)
  end
  table.insert(self.mapQuest[mapID], index)
end
function PlotVoiceData:GetMapList()
  return self.maplist
end
function PlotVoiceData:GetMapQuestList(mapID)
  return self.mapQuest[mapID]
end
QuestManualItem = class("QuestManualItem")
function QuestManualItem:ctor(data, questNames)
  self:updata(data, questNames)
end
function QuestManualItem:updata(data, questNames)
  self.type = data.type
  if data.data then
    local questData = QuestData.new()
    questData:DoConstruct(false, QuestDataScopeType.QuestDataScopeType_CITY)
    questData:setQuestData(data.data)
    questData:setQuestListType(data.type)
    self.questData = questData
    local qdata = questNames and questNames[data.data.id]
    if qdata then
      self.questPreName = qdata:GetQuestName()
    end
  end
  local questSubs = data.subs
  if questSubs and #questSubs > 0 then
    helplog("questsubs's num", #questSubs)
    self.questSubs = {}
    for i = 1, #questSubs do
      self.questSubs[#self.questSubs + 1] = QuestManualItem.new(questSubs[i], questNames)
    end
  end
end
QuestPuzzle = class("QuestPuzzle")
function QuestPuzzle:ctor(data)
  self:updata(data)
end
function QuestPuzzle:updata(data)
  self.version = data.version
  self.open_puzzles = {}
  local openedPuzzles = data.open_puzzles
  if openedPuzzles and #openedPuzzles > 0 then
    for i = 1, #openedPuzzles do
      self.open_puzzles[#self.open_puzzles + 1] = openedPuzzles[i]
    end
  end
  self.unlock_puzzles = {}
  local unlockPuzzles = data.unlock_puzzles
  if unlockPuzzles and #unlockPuzzles > 0 then
    for i = 1, #unlockPuzzles do
      self.unlock_puzzles[#self.unlock_puzzles + 1] = unlockPuzzles[i]
    end
  end
end
BranchQuestManualItem = class("BranchQuestManualItem")
function BranchQuestManualItem:ctor(data, prequest)
  self:updata(data, prequest)
end
function BranchQuestManualItem:updata(data, prequest)
  self.itemid = data.itemid
  local questList = data.quests
  if questList and #questList > 0 then
    self.questList = {}
    for i = 1, #questList do
      self.questList[#self.questList + 1] = QuestManualItem.new(questList[i], prequest)
    end
  end
end
QuestPreviewItem = class("QuestPreviewItem")
function QuestPreviewItem:ctor(data)
  self:updata(data)
end
function QuestPreviewItem:updata(data)
  self.questid = data.questid
  self.name = data.name
  self.complete = data.complete
  self.RewardGroup = data.RewardGroup
  local rewardIds = data.allrewardid
  self.allrewardid = {}
  if rewardIds and #rewardIds > 0 then
    for i = 1, #rewardIds do
      self.allrewardid[#self.allrewardid + 1] = rewardIds[i]
    end
  end
  self.index = data.index or 0
end
