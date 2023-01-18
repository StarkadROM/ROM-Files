local baseCell = autoImport("BaseCell")
AdventureCollectionAchShowCell = class("AdventureCollectionAchShowCell", baseCell)
local ConfigValidCountTypeMap = {
  [SceneManual_pb.EMANUALTYPE_FASHION] = true,
  [SceneManual_pb.EMANUALTYPE_COLLECTION] = true
}
function AdventureCollectionAchShowCell:Init()
  self.name = self:FindComponent("name", UILabel)
end
function AdventureCollectionAchShowCell:SetData(data)
  local type, count, totalCount = data.type, data:GetUnlockNum(), data.totalCount
  if type == SceneManual_pb.EMANUALTYPE_ACHIEVE then
    count, totalCount = AdventureAchieveProxy.Instance:getTotalAchieveProgress()
  elseif ConfigValidCountTypeMap[type] then
    totalCount = data:GetValidItemNum()
  end
  self.name.text = string.format("%s: %s/%s", Table_ItemTypeAdventureLog[type].Name, count, totalCount)
end
