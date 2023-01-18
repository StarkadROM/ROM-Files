MiniMapTransmitterButton = class("MiniMapTransmitterButton", BaseCell)
MiniMapTransmitterButton.E_State = {
  Activated = 0,
  Unactivated = 1,
  Disable = 2
}
function MiniMapTransmitterButton:Init()
  self.sprIcon = self:FindComponent("Icon", UISprite)
  self.objSelect = self:FindGO("HighLight")
  self.boxCollider = self.gameObject:GetComponent(BoxCollider)
  self:AddCellClickEvent()
end
function MiniMapTransmitterButton:SetData(data)
  self.data = data
  self.id = data.staticdata.id
  self.isMain = data.staticdata.NpcType == 0
  self.isCurrent = data.isCurrent
  self.state = data.state
  self.npcName = Table_Npc[data.staticdata.NpcID].NameZh
  local config = GameConfig.Transmitter[data.staticdata.MapGroup]
  if config then
    IconManager:SetMapIcon(self.isMain and config.IconBig or config.IconSmall, self.sprIcon)
  end
  if self.state == MiniMapTransmitterButton.E_State.Unactivated then
    self:SetTextureGrey(self.sprIcon)
    self.boxCollider.enabled = false
  else
    self:SetTextureWhite(self.sprIcon)
    self.boxCollider.enabled = true
  end
end
function MiniMapTransmitterButton:Select(isSelect)
  self.objSelect:SetActive(isSelect)
end
