local baseCell = autoImport("BaseCell")
AchievementQuestCell = class("AchievementQuestCell", baseCell)
function AchievementQuestCell:Init()
  self:initView()
end
function AchievementQuestCell:initView()
  self.more = self:FindGO("more")
  self.achieveDesc = self:FindComponent("achieveDesc", UILabel)
  self:AddCellClickEvent()
  self.preQuestCt = self:FindGO("preQuestCt")
  self.questStatus = self:FindComponent("questStatus", UILabel)
  self.statusBtn = self:FindGO("statusBtn")
  self.statusBtnSp = self:FindComponent("statusBtn", UISprite)
  self:Hide(self.preQuestCt)
  self:AddClickEvent(self.statusBtn, function()
    TipManager.Instance:ShowPreQuestTip(self.data.preQuestS, self.statusBtnSp, NGUIUtil.AnchorSide.Right, {270, 0})
  end)
  local grid = self:FindComponent("grid", UIGrid)
  self.preQuestGrid = UIGridListCtrl.new(grid, AchievementPreQuestCell, "AchievementPreQuestCell")
end
function AchievementQuestCell:SetData(data)
  self.data = data
  local type = data.type
  local content = data.content
  local questListType = data.questListType
  self:Hide(self.preQuestCt)
  if type == AchievementDescriptionCell.SubAchieve.Achieve then
    self:Show(self.more)
    self:Hide(self.questStatus.gameObject)
    self:Hide(self.statusBtn)
    self.achieveDesc.text = string.format(ZhString.AdventureAchievePage_SubAchieveText, content)
  elseif AchievementDescriptionCell.SubAchieve.Quest then
    self:Hide(self.more)
    self:Show(self.questStatus.gameObject)
    self.achieveDesc.text = string.format(ZhString.AdventureAchievePage_SubQuestText, content)
    if questListType == SceneQuest_pb.EQUESTLIST_SUBMIT then
      self:Hide(self.statusBtn)
      self.questStatus.text = ZhString.AdventureAchievePage_Finish
    elseif questListType == SceneQuest_pb.EQUESTLIST_ACCEPT then
      self.questStatus.text = ZhString.AdventureAchievePage_Accept
      self:Hide(self.statusBtn)
    else
      self.questStatus.text = ZhString.AdventureAchievePage_UnAccept
      if data.preQuestS and #data.preQuestS > 0 then
        self:Show(self.statusBtn)
        return
      else
        self:Hide(self.statusBtn)
      end
    end
  end
end
