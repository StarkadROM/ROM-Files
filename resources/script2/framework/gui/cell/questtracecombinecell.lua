local BaseCell = autoImport("BaseCell")
QuestTraceCombineCell = class("QuestTraceCombineCell", BaseCell)
autoImport("QuestTraceTogCell")
function QuestTraceCombineCell:Init()
  self.gameObject:SetActive(true)
  self.fatherObj = self:FindGO("FatherGoal")
  self.tweenScale = self:FindComponent("ChildContainer", TweenScale)
  self.groupLabel = self:FindGO("GroupLabel", self.fatherObj):GetComponent(UILabel)
  self.groupLabel_BG = self:FindGO("GroupLabelBG", self.fatherObj):GetComponent(UISprite)
  self.processPart = self:FindGO("ProcessPart", self.fatherObj)
  self.processCell = {}
  for i = 1, 4 do
    self.processCell[i] = {}
    local go = self:FindGO("Process" .. i, self.processPart)
    self.processCell[i].mark = self:FindGO("Mark", go)
  end
  self.rewardStatus = self:FindGO("RewardStatus", self.processPart):GetComponent(UIMultiSprite)
  self.rewardLight = self:FindGO("RewardLight")
  self.rewardLight:SetActive(false)
  self.finishSymbol = self:FindGO("FinishSymbol", self.processPart)
  self.arrowBG = self:FindGO("ArrowBg")
  self.arrow = self:FindGO("Arrow", self.arrowBG):GetComponent(UISprite)
  self.arrowBG_TweenScale = self.arrowBG:GetComponent(TweenScale)
  self.father_TweenPos = self.fatherObj:GetComponent(TweenPosition)
  self.father_TweenAlpha = self.fatherObj:GetComponent(TweenAlpha)
  self.ChildContainer = self:FindGO("ChildContainer")
  self.ChildGoals = self:FindGO("ChildGoals", self.ChildContainer)
  self.ChildGoals_UIGrid = self.ChildGoals:GetComponent(UIGrid)
  self.childSpace = self.ChildGoals_UIGrid.cellHeight
  self:AddClickEvent(self.fatherObj, function()
    self:ClickFather()
  end)
  self:AddClickEvent(self.rewardStatus.gameObject, function()
    local curVersion = self.data.fatherGoal.version
    if curVersion then
      local config = GameConfig.Quest.worldquestmap and GameConfig.Quest.worldquestmap[curVersion]
      if config and config.reward[4] then
        local data = {
          rewardid = config.reward[4],
          name = config.Title
        }
        TipManager.Instance:ShowRewardListLargeTip(data, self.rewardStatus, NGUIUtil.AnchorSide.Top, {0, 75})
      end
    end
  end)
  self.childCtl = UIGridListCtrl.new(self.ChildGoals_UIGrid, QuestTraceTogCell, "QuestTraceTogCell")
  self.childCtl:AddEventListener(MouseEvent.MouseClick, self.ClickChild, self)
  self.childCtl:AddEventListener(QuestEvent.QuestTraceChange, self.HandleTraceUpdate, self)
  self.tweenScale:SetOnFinished(function()
    self:OnTweenScaleOnFinished()
  end)
  self.folderState = true
end
function QuestTraceCombineCell:ClickFather(cellCtrl)
  self.folderState = not self.folderState
  self:SetFolderState(self.folderState)
  self:PassEvent(MouseEvent.MouseClick, {
    type = "Father",
    combine = self,
    index = self.indexInList
  })
  self:RefreshArrow()
  self.arrowBG_TweenScale:ResetToBeginning()
  self.arrowBG_TweenScale:PlayForward()
end
function QuestTraceCombineCell:RefreshArrow()
  self.arrow.gameObject.transform.localPosition = self.folderState and LuaGeometry.GetTempVector3(0, -20, 0) or LuaGeometry.GetTempVector3(0, -11, 0)
  self.arrow.flip = self.folderState and 2 or 0
end
function QuestTraceCombineCell:ClickChild(cellCtrl)
  if cellCtrl ~= self.nowChild then
    cellCtrl:SetChooseStatus(true)
    self.nowChild = cellCtrl
  end
  self:PassEvent(MouseEvent.MouseClick, {
    type = "Child",
    combine = self,
    child = self.nowChild
  })
end
function QuestTraceCombineCell:SetData(data)
  self.data = data
  if data.fatherGoal then
    self.fatherObj:SetActive(not data.fatherGoal.isHide)
    if data.fatherGoal.isWorldQuest then
      if not data.fatherGoal.isHide then
        self.groupLabel.text = GameConfig.Quest.worldquestmap and GameConfig.Quest.worldquestmap[data.fatherGoal.version].Title or "???"
      end
    elseif data.fatherGoal.title then
      self.groupLabel.text = data.fatherGoal.title
    else
      local nameConfig = GameConfig.Quest.QuestSort[data.fatherGoal.area]
      self.groupLabel.text = nameConfig and nameConfig.name or data.fatherGoal.area
    end
    local curProcess = QuestProxy.Instance:GetWorldCount(data.fatherGoal.version)
    for i = 1, 4 do
      self.processCell[i].mark:SetActive(i <= curProcess)
    end
    self.rewardStatus.CurrentState = curProcess >= 4 and 1 or 0
    self.groupLabel_BG.width = self.groupLabel.printedSize.x + 30
    self.finishSymbol:SetActive(curProcess >= 4)
    self.childCtl:ResetDatas(data.childGoals)
    self.ChildGoals.transform.localPosition = self.fatherObj.activeSelf and LuaGeometry.GetTempVector3(0, -115, 0) or LuaGeometry.GetTempVector3(0, 0, 0)
    if self.indexInList == 1 then
      self.folderState = true
      self.tweenScale.duration = 0
      self.tweenScale:PlayForward()
      self.tweenScale.enabled = false
      self:PlayChildTween()
    else
      self.folderState = false
      self.tweenScale.duration = 0
      self:PlayChildTweenReverse()
      self.tweenScale:ResetToBeginning()
      self.tweenScale.enabled = false
    end
    self:PlayFatherTween()
    self:RefreshArrow()
  end
end
function QuestTraceCombineCell:SwitchToTargetQuest(questid)
  local cells = self.childCtl:GetCells()
  for i = 1, #cells do
    if cells[i].data.id == questid then
      self:ClickChild(cells[i])
      return true
    end
  end
  return false
end
function QuestTraceCombineCell:SetDefaultChoose()
  local cells = self.childCtl:GetCells()
  if cells and #cells > 0 then
    self:ClickChild(cells[1])
  end
end
function QuestTraceCombineCell:OnTweenScaleOnFinished()
  if self.folderState then
  else
  end
end
function QuestTraceCombineCell:SetFolderState(bool)
  if bool then
    self.tweenScale.duration = 0
    self.tweenScale.delay = 0
    self.tweenScale:PlayForward()
    self:PlayChildTween()
  else
    self.tweenScale.duration = 0
    self.tweenScale.delay = 0
    self:PlayChildTweenReverse()
    self.tweenScale:PlayReverse()
  end
end
function QuestTraceCombineCell:HandleTraceUpdate(cellCtrl)
  self:PassEvent(QuestEvent.QuestTraceChange, cellCtrl)
end
function QuestTraceCombineCell:SetNewTag(bool)
  local cells = self.childCtl:GetCells()
  for i = 1, #cells do
    cells[i]:SetNewSymbol(bool)
  end
end
function QuestTraceCombineCell:CancelNewTag()
  local newUpdateList = {}
  local cells = self.childCtl:GetCells()
  for i = 1, #cells do
    local cell = cells[i]
    if cell.newSymbol.activeSelf then
      cell:SetNewSymbol(false)
      if cell.questList then
        for j = 1, #cell.questList do
          table.insert(newUpdateList, cell.questList[j].id)
        end
      else
        table.insert(newUpdateList, cell.data.id)
      end
    end
  end
  if #newUpdateList > 0 then
    QuestProxy.Instance:RemoveClientNewQuestByQuesIds(newUpdateList)
  end
end
function QuestTraceCombineCell:PlayChildTween()
  local cells = self.childCtl:GetCells()
  if cells and #cells > 0 then
    for i = 1, #cells do
      cells[i]:PlayTween()
    end
  end
end
function QuestTraceCombineCell:PlayChildTweenReverse()
  local cells = self.childCtl:GetCells()
  if cells and #cells > 0 then
    for i = 1, #cells do
      cells[i]:PlayReverse()
    end
  end
end
function QuestTraceCombineCell:PlayFatherTween()
  self.father_TweenPos:ResetToBeginning()
  self.father_TweenPos:PlayForward()
  self.father_TweenAlpha:ResetToBeginning()
  self.father_TweenAlpha:PlayForward()
end
function QuestTraceCombineCell:OnCellDestroy()
  QuestTraceCombineCell.super.OnCellDestroy(self)
  local cells = self.childCtl:GetCells()
  if cells and #cells > 0 then
    for i = 1, #cells do
      cells[i]:OnCellDestroy()
    end
  end
  TimeTickManager.Me():ClearTick(self)
end
