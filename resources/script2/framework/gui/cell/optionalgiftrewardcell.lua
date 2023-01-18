autoImport("TechTreeSandExchangeCell")
OptionalGiftRewardCell = class("OptionalGiftRewardCell", TechTreeSandExchangeCell)
OptionalGiftRewardCell.InputChange = "OptionalGiftRewardCell_InputChange"
OptionalGiftRewardCell.InputSubmit = "OptionalGiftRewardCell_InputSubmit"
function OptionalGiftRewardCell:InitItem()
  local itemCellObjName = "Common_ItemCell"
  local itemContainer = self:FindGO("ItemContainer")
  local itemCell = self:FindGO(itemCellObjName)
  if not itemCell then
    local go = self:LoadPreferb("cell/ItemCell", itemContainer)
    go.name = itemCellObjName
  end
  self:AddClickEvent(itemContainer, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self.adventureStoreStateSp = self:FindComponent("AdventureStoreState", UISprite)
  self.refineLabel = self:FindComponent("refineLV", UILabel)
end
function OptionalGiftRewardCell:SetData(data)
  self.gameObject:SetActive(data ~= nil)
  if not data then
    return
  end
  self.empty:SetActive(false)
  self.rewardId = data[1]
  self.rewardCount = data[2]
  self.refineLV = data.refine_lv
  self.countInput.value = 0
  if self.refineLV and self.refineLV > 0 then
    self.refineLabel.text = string.format("+%d", self.refineLV)
  else
    self.refineLabel.text = ""
  end
  local rewardData = Table_Item[self.rewardId]
  local ret = IconManager:SetItemIcon(rewardData and rewardData.Icon, self.icon)
  if ret then
    self.icon:MakePixelPerfect()
  end
  self:SetPic(rewardData.Type)
  self:UpdateNumLabel(self.rewardCount)
  self:UpdateAdventureStoreState()
end
function OptionalGiftRewardCell:UpdateAdventureStoreState()
  local advProxy = AdventureDataProxy.Instance
  if advProxy:IsFashionStored(self.rewardId) then
    self:Show(self.adventureStoreStateSp.gameObject)
    self.adventureStoreStateSp.spriteName = "Adventure_icon_02"
  elseif advProxy:IsFashionUnlock(self.rewardId) then
    self:Show(self.adventureStoreStateSp.gameObject)
    self.adventureStoreStateSp.spriteName = "Adventure_icon_01"
  else
    self:Hide(self.adventureStoreStateSp.gameObject)
  end
end
function OptionalGiftRewardCell:GetInputChangeEvtStr()
  return OptionalGiftRewardCell.InputChange
end
function OptionalGiftRewardCell:GetInputSubmitEvtStr()
  return OptionalGiftRewardCell.InputSubmit
end
