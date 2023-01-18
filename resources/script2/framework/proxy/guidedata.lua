GuideData = class("GuideData")
autoImport("QuestData")
local Table_GuideID = Table_GuideID
function GuideData:ctor()
end
function GuideData:SetByQuestData(questData)
  self.guideID = questData.params.guideID
  self.staticData = Table_GuideID[self.guideID]
  self.guideType = questData.params.type
  self.showGirl = questData.params.showgirl
  self.autoComplete = questData.params.autocomplete
  self.closeOnClick = questData.params.closeonclick
  self.hideOnClick = questData.params.hideonclick
  if not self.questData then
    self.questData = {}
  else
    TableUtility.TableClear(self.questData)
  end
  Game._deepCopy(questData, self.questData)
  self.targetQuestID = self.questData.params.questID
end
function GuideData:SetByClientData(clientData, guideKey)
  self.clientKey = guideKey
  self.guideID = clientData.params.id
  self.staticData = Table_GuideID[self.guideID]
  self.guideType = clientData.params.type
  self.showGirl = clientData.params.showgirl
  self.autoComplete = clientData.params.autoComplete
  self.closeOnClick = clientData.params.closeOnClick
  self.hideOnClick = clientData.params.hideOnClick
  self.closeuijump = clientData.closeuijump
end
