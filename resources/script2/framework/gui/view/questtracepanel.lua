QuestTracePanel = class("QuestTracePanel", BaseView)
autoImport("PopupGridList")
autoImport("QuestTypeTabCell")
autoImport("QuestTraceTogCell")
autoImport("QuestTableRewardCell")
autoImport("QuestTraceCombineCell")
QuestTracePanel.ViewType = UIViewType.NormalLayer
local questTypeTog = GameConfig.Quest.QuestTraceGroup
function QuestTracePanel:Init()
  self:FindObjs()
  self:InitDatas()
  self:AddEvts()
  self:AddMapEvts()
  self:InitShow()
  self:AddCloseButtonEvent()
end
function QuestTracePanel:FindObjs()
  QuestTracePanel.instance = self
  local questTypeTog = self:FindGO("QuestTypeTog")
  self.questTypeScrollView = self:FindGO("QuestTypeScrollView", questTypeTog):GetComponent(UIScrollView)
  self.questTypeGrid = self:FindGO("QuestTypeGrid", questTypeTog):GetComponent(UITable)
  self.questTypeTogCtrl = UIGridListCtrl.new(self.questTypeGrid, QuestTypeTabCell, "QuestTypeTabCell")
  self.questTypeTogCtrl:AddEventListener(QuestEvent.QuestTraceSwitchPage, self.ClickTypeTog, self)
  local questList = self:FindGO("QuestList")
  self.questScrollView = self:FindGO("QuestScrollView"):GetComponent(UIScrollView)
  self.questTable = self:FindGO("QuestTable", questList):GetComponent(UITable)
  self.questListCtrl = UIGridListCtrl.new(self.questTable, QuestTraceCombineCell, "QuestTraceCombineCell")
  self.questListCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickGoal, self)
  self.questListCtrl:AddEventListener(QuestEvent.QuestTraceClickQuest, self.ClickQuestCell, self)
  self.questListCtrl:AddEventListener(QuestEvent.QuestTraceChange, self.HandleTraceStatusUpdate, self)
  self.hideToggle = self:FindGO("HideToggle"):GetComponent(UIToggle)
  self.hideToggleGO = self.hideToggle.gameObject
  self.noneTip = self:FindGO("NoneTip")
  local questInfo = self:FindGO("QuestInfo")
  self.questInfoDetail = self:FindGO("QuestInfoDetail", questInfo)
  self.noQuestTip = self:FindGO("NoQuestInfoTip", questInfo)
  self.questTitle = self:FindGO("QuestTitle"):GetComponent(UILabel)
  self.traceInfoGO = self:FindGO("TraceInfo")
  self.traceInfo = self:FindComponent("TraceInfo", UIRichLabel)
  self.traceInfo = SpriteLabel.new(self.traceInfo, nil, 20, 20)
  self.mapIcon = self:FindGO("MapIcon"):GetComponent(UISprite)
  self.mapLabel = self:FindGO("MapLabel"):GetComponent(UILabel)
  self.traceBtn = self:FindGO("TraceBtn")
  self.repairBtn = self:FindGO("RepairBtn")
  self.rewardPart = self:FindGO("RewardPart")
  self.rewardTip = self:FindGO("RewardTip", self.rewardPart):GetComponent(UILabel)
  self.rewardScrollView = self:FindGO("RewardScrollView"):GetComponent(UIScrollView)
  self.rewardGrid = self:FindGO("RewardGrid"):GetComponent(UIGrid)
  self.rewardListCtrl = UIGridListCtrl.new(self.rewardGrid, BagItemCell, "BagItemCell")
  self.rewardListCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickRewardCell, self)
  self.scenicSpotCell = self:FindGO("ScenicSpotCell")
  self.sceneSpotList = self:FindGO("ScenicSpotList")
  local sceneSpotTipLabel = self:FindGO("SceneSpotTip", self.sceneSpotList):GetComponent(UILabel)
  sceneSpotTipLabel.text = ZhString.QuestDetailTip_UnlockInfo
  self.sceneSpotScrollView = self:FindGO("ScenicSpotScrollView"):GetComponent(UIScrollView)
  self.sceneSpotGrid = self:FindGO("ScenicSpotGrid"):GetComponent(UITable)
  self.sceneSpotGridCtrl = UIGridListCtrl.new(self.sceneSpotGrid, QuestTableRewardCell, "QuestTableRewardCellType2")
  self.traceCount = self:FindGO("TraceCount"):GetComponent(UILabel)
  self.stick = self:FindGO("Stick"):GetComponent(UISprite)
  self.questManualBtn = self:FindGO("QuestManual")
  self:RegisterRedTipCheck(310, self.questManualBtn, 42)
  self:RegisterRedTipCheck(10100, self.questManualBtn, 42)
  if not FunctionUnLockFunc.Me():CheckCanOpen(6300) then
    self.questManualBtn:SetActive(false)
  end
end
function QuestTracePanel:InitDatas()
  self.levelHide = false
  self.hideToggle.value = self.levelHide
  self.validAcceptQuestList = QuestProxy.Instance:getValidAcceptQuestList(nil)
  self.questList = {}
  self.myLevel = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
  self:InitChapterFilter()
  self:SetTraceCount()
  self:InitQuestList()
end
function QuestTracePanel:InitQuestList()
  local groupConfig = {}
  for k, v in pairs(questTypeTog) do
    local areaRange = v.area
    if areaRange and #areaRange > 0 then
      for i = 1, #areaRange do
        groupConfig[areaRange[i]] = k
      end
    elseif v.other then
      groupConfig.other = k
    end
  end
  for i = 1, #self.validAcceptQuestList do
    local single = self.validAcceptQuestList[i]
    local colorFromServer = single.staticData.ColorFromServer
    if groupConfig[colorFromServer] then
      if not self.questList[groupConfig[colorFromServer]] then
        self.questList[groupConfig[colorFromServer]] = {}
      end
      table.insert(self.questList[groupConfig[colorFromServer]], single)
    else
      if not self.questList[groupConfig.other] then
        self.questList[groupConfig.other] = {}
      end
      table.insert(self.questList[groupConfig.other], single)
    end
  end
end
function QuestTracePanel:InitShow()
  self:InitQuestTypeTog()
  local typeTogs = self.questTypeTogCtrl:GetCells()
  self:ClickTypeTog(typeTogs and typeTogs[1])
  if typeTogs and typeTogs[1] then
    typeTogs[1].toggle.value = true
  end
  self:RefreshNewTag()
  self:RefreshTraceCount()
  self:RefreshQuestManualRedtip()
end
function QuestTracePanel:RefreshNewTag()
  local typeTogs = self.questTypeTogCtrl:GetCells()
  for i = 1, #typeTogs do
    local index = typeTogs[i].indexInList
    local areaQuest = self.questList[index]
    if areaQuest and #areaQuest > 0 then
      for j = 1, #areaQuest do
        local single = areaQuest[j]
        if single.newstatus == 1 then
          typeTogs[i]:SetNewSymbol(true)
          break
        end
        typeTogs[i]:SetNewSymbol(false)
      end
    end
  end
end
function QuestTracePanel:SwitchTag()
  local cells = self.questListCtrl:GetCells()
  for i = 1, #cells do
    cells[i]:CancelNewTag()
  end
  self:RefreshNewTag()
end
function QuestTracePanel:InitQuestClickShow()
  local cells = self.questListCtrl:GetCells()
  local isShow = false
  local curTraceID = LocalSaveProxy.Instance:getLastTraceQuestId()
  local firstValidCell
  local switched = false
  for i = 1, #cells do
    if #cells[i].data.childGoals > 0 then
      firstValidCell = cells[i]
      isShow = true
      break
    end
  end
  if isShow then
    self.questInfoDetail:SetActive(true)
    self.noQuestTip:SetActive(false)
    if curTraceID then
      for i = 1, #cells do
        if cells[i]:SwitchToTargetQuest(curTraceID) then
          switched = true
          break
        end
      end
      if not switched then
        firstValidCell:SetDefaultChoose()
      end
    end
  else
    self.questInfoDetail:SetActive(false)
    self.noQuestTip:SetActive(true)
  end
end
function QuestTracePanel:AddEvts()
  self:AddClickEvent(self.scenicSpotCell, function()
    self:ShowScenicSpotList()
  end)
  self:AddClickEvent(self.hideToggleGO, function()
    self:InitShow()
  end)
  self:AddClickEvent(self.traceBtn, function()
    xdlog("追踪任务", self.curChooseQuestCell.id)
    if self.curChooseQuestCell.toggle.value == false then
      self.curChooseQuestCell.toggle.value = true
      self:HandleTraceStatusUpdate(self.curChooseQuestCell)
    end
    GameFacade.Instance:sendNotification(QuestEvent.QuestTraceSwitch, self.curChooseQuestCell.data)
    self:CloseSelf()
  end)
  self:AddClickEvent(self.repairBtn, function()
    local questData = self.curChooseQuestCell.data
    if questData then
      TipManager.Instance:ShowQuestRepairTip(questData, self.stick, nil, {0, 0})
    end
  end)
  self:AddClickEvent(self.questManualBtn, function()
    self:SetPushToStack(true)
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.QuestManualView
    })
  end)
end
function QuestTracePanel:AddMapEvts()
  self:AddListenEvt(QuestEvent.QuestTraceChange, self.HandleTraceStatusUpdate, self)
  self:AddListenEvt(ServiceEvent.QuestQuestUpdate, self.SetTraceCount, self)
end
function QuestTracePanel:InitQuestTypeTog()
  local result = {}
  for k, v in pairs(questTypeTog) do
    table.insert(result, v)
  end
  self.questTypeTogCtrl:ResetDatas(result)
end
local listPopUpItems = {}
function QuestTracePanel:InitChapterFilter()
  TableUtility.ArrayClear(listPopUpItems)
  local data = {
    name = ZhString.Card_All,
    version = 0,
    tab = 1
  }
  table.insert(listPopUpItems, data)
  for k, v in pairs(Table_QuestVersion) do
    local hasQuest = false
    for i = 1, #self.validAcceptQuestList do
      local single = self.validAcceptQuestList[i]
      if single.staticData.Version and single.staticData.Version == v.version then
        hasQuest = true
        break
      end
    end
    if hasQuest then
      local data = {}
      data.name = v.StoryName
      data.version = v.version
      data.tab = v.Tab or 1
      table.insert(listPopUpItems, data)
    end
  end
end
function QuestTracePanel:tabClick(selectTabData)
  local targetVersion = selectTabData.version or 0
  local result = {}
  if not self.validAcceptQuestList then
    return
  end
  local areaRange = questTypeTog[2].area
  if areaRange and #areaRange > 0 then
    local result = {}
    for i = 1, #areaRange do
      local areaData = {}
      areaData.fatherGoal = {
        area = areaRange[i],
        isHide = true
      }
      areaData.childGoals = {}
      for j = 1, #self.validAcceptQuestList do
        local single = self.validAcceptQuestList[j]
        local colorFromServer = single.staticData.ColorFromServer
        local version = single.staticData.Version
        if areaRange[i] == colorFromServer and (targetVersion == 0 or version and version == targetVersion) then
          if self.levelHide then
            if QuestProxy.Instance:CheckQuestShow(single, self.myLevel) then
              table.insert(areaData.childGoals, single)
            end
          else
            table.insert(areaData.childGoals, single)
          end
        end
      end
      local tempData = self:questReunit(areaData.childGoals)
      areaData.childGoals = tempData
      table.insert(result, areaData)
    end
    self.questListCtrl:ResetDatas(result)
    self.questScrollView:ResetPosition()
    local cells = self.questListCtrl:GetCells()
    local isShow = false
    for i = 1, #cells do
      if 0 < #cells[i].data.childGoals then
        isShow = true
        break
      end
    end
    self.noneTip:SetActive(not isShow)
  end
end
function QuestTracePanel:ClickTypeTog(cellCtrl)
  self.curChooseQuestCell = nil
  if self.curType and self.curType ~= cellCtrl.indexInList then
    self:SwitchTag()
  end
  self.curType = cellCtrl.indexInList
  local curWorldQuestGroup = Game.MapManager:getCurWorldQuestGroup()
  local result = {}
  if cellCtrl.indexInList == 3 then
    local worldQuest = {}
    local worldQuestMap = GameConfig.Quest.worldquestmap
    for k, v in pairs(worldQuestMap) do
      worldQuest[k] = {}
    end
    local areaQuest = self.questList[3]
    if areaQuest and #areaQuest > 0 then
      for i = 1, #areaQuest do
        local single = areaQuest[i]
        if Table_WorldQuest[single.id] then
          local version = Table_WorldQuest[single.id].Version
          if not worldQuest[version] then
            worldQuest[version] = {}
          end
          table.insert(worldQuest[version], single)
        else
          if not worldQuest.Common then
            worldQuest.Common = {}
          end
          table.insert(worldQuest.Common, single)
        end
      end
      for k, v in pairs(worldQuest) do
        local areaData = {}
        local isHide = true
        if GameConfig.Quest.worldquestmap[k] and (#v > 0 or 0 < QuestProxy.Instance:GetWorldCount(k)) then
          isHide = false
        end
        areaData.fatherGoal = {
          isWorldQuest = true,
          version = k,
          isHide = isHide
        }
        areaData.childGoals = v
        local tempData = self:questReunit(areaData.childGoals)
        areaData.childGoals = tempData
        table.insert(result, areaData)
      end
    end
  elseif cellCtrl.indexInList == 1 then
    local tracingQuest = {}
    local areaData = {}
    for k, v in pairs(self.questList) do
      for i = 1, #v do
        local single = v[i]
        local status = QuestProxy.Instance:CheckQuestIsTrace(single.id)
        local isTrace = false
        if curWorldQuestGroup then
          if status and status == 3 then
            local version = Table_WorldQuest[single.id] and Table_WorldQuest[single.id].Version
            if version == curWorldQuestGroup then
              isTrace = true
            end
          elseif status and status == 1 then
            isTrace = true
          end
        elseif status and status == 1 then
          isTrace = true
        end
        if isTrace then
          table.insert(tracingQuest, single)
        end
      end
    end
    if tracingQuest and #tracingQuest > 0 then
      local areaData = {}
      areaData.fatherGoal = {
        isWorldQuest = false,
        title = "追踪中",
        isHide = true
      }
      areaData.childGoals = {}
      TableUtility.ArrayShallowCopy(areaData.childGoals, tracingQuest)
      local tempData = self:questReunit(areaData.childGoals)
      areaData.childGoals = tempData
      table.insert(result, areaData)
    end
  else
    local areaQuest = self.questList[cellCtrl.indexInList]
    local areaData = {}
    areaData.fatherGoal = {isHide = true}
    areaData.childGoals = {}
    if areaQuest and #areaQuest > 0 then
      for i = 1, #areaQuest do
        local single = areaQuest[i]
        if self.levelHide then
          if QuestProxy.Instance:CheckQuestShow(single, self.myLevel) then
            table.insert(areaData.childGoals, single)
          end
        else
          table.insert(areaData.childGoals, single)
        end
      end
    end
    local tempData = self:questReunit(areaData.childGoals)
    areaData.childGoals = tempData
    table.insert(result, areaData)
  end
  table.sort(result, function(l, r)
    local lHide = l.fatherGoal.isHide
    local rHide = r.fatherGoal.isHide
    if lHide ~= rHide then
      return lHide == false
    end
  end)
  self.questListCtrl:ResetDatas(result)
  self:InitQuestClickShow()
  self.questScrollView:ResetPosition()
  local cells = self.questListCtrl:GetCells()
  local isShow = false
  for i = 1, #cells do
    if 0 < #cells[i].data.childGoals then
      isShow = true
      break
    end
  end
  self.noneTip:SetActive(not isShow)
end
local tipData = {}
tipData.funcConfig = {}
function QuestTracePanel:ClickRewardCell(cellCtrl)
  if cellCtrl.data then
    tipData.itemdata = cellCtrl.data
    self:ShowItemTip(tipData, cellCtrl.icon, NGUIUtil.AnchorSide.Center, {-250, -37})
  end
end
function QuestTracePanel:ClickQuestCell(cellCtrl, noSwitch)
  if cellCtrl.questList and #cellCtrl.questList > 0 and self.curChooseQuestCell and cellCtrl.curChoose.id == self.curChooseQuestCell.id and not noSwitch then
    cellCtrl:SwitchTracedQuestInCombinedGroup()
  end
  if self.curChooseQuestCell ~= cellCtrl then
    if self.curChooseQuestCell then
      self.curChooseQuestCell:SetChooseStatus(false)
    end
    self.curChooseQuestCell = cellCtrl
    self.curChooseQuestCell:SetChooseStatus(true)
  else
    self.curChooseQuestCell = cellCtrl
  end
  self:UpdateQuestInfo()
  self:UpdateRewardPart(cellCtrl.data)
  self:UpdateRepairBtn()
  if self:RemoveNewSymbol(cellCtrl) then
    self:RefreshNewTag()
  end
end
function QuestTracePanel:RemoveNewSymbol(cellCtrl)
  if cellCtrl.newSymbol.activeSelf then
    cellCtrl:SetNewSymbol(false)
    QuestProxy.Instance:RemoveClientNewQuest(cellCtrl.data.id)
    return true
  end
end
function QuestTracePanel:ClickGoal(params)
  if params.type == "Father" then
    local cells = self.questListCtrl:GetCells()
    local index = params.index
    if index then
      local nextCell = cells[index + 1]
      if nextCell and not nextCell.folderState then
        nextCell:ClickFather(nextCell)
      end
    end
  elseif params.child and params.child.data then
    self:ClickQuestCell(params.child)
  end
end
function QuestTracePanel:UpdateQuestInfo()
  if not self.curChooseQuestCell then
    return
  end
  local desStr = ""
  if self.curChooseQuestCell.isCombined then
    local questList = self.curChooseQuestCell.questList
    for i = 1, #questList do
      local single = questList[i]
      local traceInfo = single:parseTranceInfo()
      if not single.isFinish then
        desStr = desStr .. "{taskuiicon=tips_icon_01}" .. traceInfo
      else
        local finishTraceInfo = OverSea.LangManager.Instance():GetLangByKey(Table_FinishTraceInfo[single.id].FinishTraceInfo)
        desStr = desStr .. "{taskuiicon=pet_icon_finish}" .. "[c][A2A2A2]" .. finishTraceInfo .. "[-][/c]"
      end
      if i < #questList then
        desStr = desStr .. "\n"
      end
    end
    desStr = desStr or ""
    desStr = string.gsub(desStr, "ffff00", "FF7D13")
    self.traceInfo:SetText(desStr)
    local questData = self.curChooseQuestCell.curChoose
    self.questTitle.text = questData.traceTitle or ""
    local map = self.curChooseQuestCell.curChoose.map
    if not map then
      self.mapIcon.gameObject:SetActive(false)
      self.traceInfoGO.transform.localPosition = LuaGeometry.GetTempVector3(-274, 229, 0)
    else
      self.mapIcon.gameObject:SetActive(true)
      local mapData = Table_Map[map]
      self.mapLabel.text = mapData.CallZh
      self.traceInfoGO.transform.localPosition = LuaGeometry.GetTempVector3(-274, 186, 0)
    end
  else
    local questData = self.curChooseQuestCell.data
    self.questTitle.text = questData.traceTitle or ""
    local map = questData.map
    if not map then
      self.mapIcon.gameObject:SetActive(false)
      self.traceInfoGO.transform.localPosition = LuaGeometry.GetTempVector3(-274, 229, 0)
    else
      self.mapIcon.gameObject:SetActive(true)
      local mapData = Table_Map[map]
      self.mapLabel.text = mapData.CallZh
      self.traceInfoGO.transform.localPosition = LuaGeometry.GetTempVector3(-274, 186, 0)
    end
    local desStr = questData:parseTranceInfo() or ""
    desStr = string.gsub(desStr, "ffff00", "FF7D13")
    self.traceInfo:SetText(desStr)
  end
end
local RewardType = {
  Common = 1,
  RewardChooseType = 2,
  RewardGroupType = 3,
  None = 4
}
function QuestTracePanel:UpdateRewardPart(data)
  if not data then
    return
  end
  local rewardList = {}
  local rewards = data.allrewardid
  local rewardType = 0
  if data.rewards then
    for i = 1, #data.rewards do
      local single = data.rewards[i]
      if single and Table_Item[single.id] then
        local itemData = ItemData.new("reward", single.id)
        itemData:SetItemNum(single.count)
        table.insert(rewardList, itemData)
      end
    end
    self.rewardTip.text = ZhString.QuestDetailTip_CommonReward
    rewardType = RewardType.Common
  elseif rewards and #rewards > 1 then
    self.rewardTip.text = ZhString.QuestDetailTip_MultReward
    xdlog("多组奖励")
    rewardType = RewardType.RewardChooseType
  elseif rewards and #rewards > 0 then
    local rewardId = rewards[1]
    local isRandom = false
    if rewardId then
      local items = ItemUtil.GetRewardItemIdsByTeamId(rewardId)
      if items and #items > 0 then
        for i = 1, #items do
          local item = items[i]
          if item.type == 2 then
            isRandom = true
          end
          if Table_Item[item.id] then
            local itemData = ItemData.new("reward", item.id)
            itemData:SetItemNum(item.num)
            table.insert(rewardList, itemData)
          end
        end
      end
    end
    self.rewardTip.text = isRandom and ZhString.QuestDetailTip_RandomReward or ZhString.QuestDetailTip_CommonReward
    rewardType = RewardType.RewardGroupType
  else
    rewardType = RewardType.None
  end
  local menuRewards = QuestProxy.Instance:getValidReward(data)
  self.scenicSpotCell:SetActive(menuRewards ~= nil)
  self.rewardListCtrl:ResetDatas(rewardList)
  if rewardType == RewardType.None then
    if not self.scenicSpotCell.activeSelf then
      self.rewardPart:SetActive(false)
    end
  else
    self.rewardPart:SetActive(true)
  end
  self.rewardGrid:Reposition()
  self.rewardScrollView:ResetPosition()
end
function QuestTracePanel:ShowScenicSpotList()
  if not self.curChooseQuestCell then
    return
  end
  local data = self.curChooseQuestCell.data
  self.sceneSpotList:SetActive(true)
  local rewards = QuestProxy.Instance:getValidReward(data) or {}
  self.sceneSpotGridCtrl:ResetDatas(rewards)
  self.sceneSpotGrid:Reposition()
end
function QuestTracePanel:SetTraceCount()
  if not self.validAcceptQuestList then
    return
  end
  local count = 0
  for i = 1, #self.validAcceptQuestList do
    local single = self.validAcceptQuestList[i]
    if single.trace then
      count = count + 1
    end
  end
  local maxTraceCount = 3
  local str = count .. "/" .. maxTraceCount
  self.traceCount.text = string.format(ZhString.QuestTraceCell_TraceCount, str)
end
function QuestTracePanel:questReunit(list)
  local tempResult = ReusableTable.CreateTable()
  local Result = ReusableTable.CreateTable()
  if #list > 0 then
    for i = 1, #list do
      local single = list[i]
      local questid = single.id
      if tempResult and tempResult[questid] then
        redlog("重复ID", questid)
      end
      if Table_FinishTraceInfo and Table_FinishTraceInfo[questid] then
        local traceGroupID = Table_FinishTraceInfo[questid].QuestKey
        if not tempResult[traceGroupID] then
          tempResult[traceGroupID] = {
            isCombined = true,
            groupid = traceGroupID,
            type = single.type,
            orderId = questid,
            id = questid
          }
          tempResult[traceGroupID].questList = {}
        end
        single.isFinish = false
        table.insert(tempResult[traceGroupID].questList, single)
      else
        tempResult[questid] = single
        tempResult[questid].isCombined = false
      end
    end
  end
  local finishList = QuestProxy.Instance:getQuestListInOrder(SceneQuest_pb.EQUESTLIST_SUBMIT)
  for i = 1, #finishList do
    local single = finishList[i]
    if Table_FinishTraceInfo and Table_FinishTraceInfo[single.id] then
      local traceGroupID = Table_FinishTraceInfo[single.id].QuestKey
      if tempResult[traceGroupID] then
        single.isFinish = true
        table.insert(tempResult[traceGroupID].questList, single)
      end
    end
  end
  for _, temp in pairs(tempResult) do
    table.insert(Result, temp)
  end
  table.sort(Result, function(l, r)
    if l.isCombined ~= r.isCombined then
      return l.isCombined == true
    end
    if l.newstatus ~= r.newstatus then
      return l.newstatus < r.newstatus
    end
    local lTrace = QuestProxy.Instance:CheckQuestIsTrace(l.id)
    local rTrace = QuestProxy.Instance:CheckQuestIsTrace(r.id)
    if lTrace and rTrace then
      return lTrace < rTrace
    else
      return lTrace ~= nil
    end
  end)
  return Result
end
function QuestTracePanel:HandleTraceStatusUpdate(cellCtrl)
  xdlog("HandleTraceStatusUpdate -- todo")
  if cellCtrl then
    local questids = {}
    if cellCtrl.questList then
      for i = 1, #cellCtrl.questList do
        local single = cellCtrl.questList[i]
        table.insert(questids, single.id)
      end
      if questids and #questids > 0 then
        if cellCtrl.toggle.value then
          QuestProxy.Instance:AddQuestsToTraceList(questids)
        else
          QuestProxy.Instance:RemoveTraceListByIDs(questids)
        end
      end
    else
      xdlog(cellCtrl.data.id)
      if cellCtrl.toggle.value then
        QuestProxy.Instance:AddTraceList(cellCtrl.data.id)
      else
        QuestProxy.Instance:RemoveTraceList(cellCtrl.data.id)
      end
    end
  end
  self:RefreshTraceCount()
end
function QuestTracePanel:RefreshTraceCount()
  local maxCount = GameConfig.Quest.max_trace_count or 4
  local traceList = QuestProxy.Instance.clientTraceList
  local curCount = traceList and #traceList or 0
  if traceList and #traceList > 0 then
    local str = ""
    for i = 1, #traceList do
      str = str .. traceList[i] .. ","
    end
    xdlog("追踪中", str)
  end
  self.questTypeScrollView:ResetPosition()
end
function QuestTracePanel:UpdateRepairBtn()
  if MyselfProxy.Instance.questRepairModeOn then
    self.repairBtn:SetActive(true)
  else
    self.repairBtn:SetActive(false)
  end
end
function QuestTracePanel:RefreshQuestManualRedtip()
  local active = self:CheckPuzzleRedtipValid()
  if active then
    self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_QUESTPUZZLE_CANLOCK, self.questManualBtn, 42)
  end
end
function QuestTracePanel:CheckPuzzleRedtipValid()
  local redTip = RedTipProxy.Instance:GetRedTip(SceneTip_pb.EREDSYS_QUESTPUZZLE_CANLOCK)
  if not redTip then
    return true
  end
  local redTipParams = redTip.params
  local count = 0
  for k, v in pairs(redTipParams) do
    count = count + 1
  end
  if count == 1 then
    local myPro = Game.Myself.data.userdata:Get(UDEnum.PROFESSION)
    local myRace = Table_Class[myPro].Race
    if not myRace or myRace == 1 then
      if RedTipProxy.Instance:IsNew(SceneTip_pb.EREDSYS_QUESTPUZZLE_CANLOCK, 20) then
        return false
      else
        return true
      end
    elseif RedTipProxy.Instance:IsNew(SceneTip_pb.EREDSYS_QUESTPUZZLE_CANLOCK, 10) then
      return false
    else
      return true
    end
  else
    return true
  end
end
function QuestTracePanel:OnExit()
  QuestTracePanel.super:OnExit(self)
  GameFacade.Instance:sendNotification(QuestEvent.QuestTracePanelOff)
end
