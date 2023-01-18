local BaseCell = autoImport("BaseCell")
NpcVisitCell = class("NpcVisitCell", BaseCell)
function NpcVisitCell:Init()
  self:FindObjs()
  self:AddCellClickEvent()
end
function NpcVisitCell:FindObjs()
  self.npcName = self:FindGO("NpcName"):GetComponent(UILabel)
  self.actionIcon = self:FindGO("ActionIcon"):GetComponent(UIMultiSprite)
end
function NpcVisitCell:SetData(data)
  self.target = data.target
  self.staticData = self.target.data and self.target.data.staticData
  self.npcid = self.staticData and self.staticData.id
  local count = data.count
  local extendStr = count and count > 1 and "x" .. count or ""
  self.npcName.text = self.staticData and self.staticData.NameZh .. extendStr
  self.actionIcon.CurrentState = data.state - 1
  self.actionIcon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(0.6, 0.6, 0.6)
end
