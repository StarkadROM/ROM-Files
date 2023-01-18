autoImport("ItemCell")
LotteryCell = class("LotteryCell", ItemCell)
LotteryCell.ClickEvent = "LotteryCell_ClickEvent"
function LotteryCell:Init()
  self.itemContainer = self:FindGO("ItemContainer")
  local obj = self:LoadPreferb("cell/ItemCell", self.itemContainer)
  obj.transform.localPosition = LuaVector3.Zero()
  LotteryCell.super.Init(self)
  self:FindObjs()
  self:AddEvts()
end
function LotteryCell:FindObjs()
end
function LotteryCell:AddEvts()
  self:AddClickEvent(self.itemContainer, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self:AddClickEvent(self.gameObject, function()
    self:PassEvent(LotteryCell.ClickEvent, self)
  end)
end
function LotteryCell:SetData(data)
  self.gameObject:SetActive(data ~= nil)
  self.data = data
  if not data then
    return
  end
  LotteryCell.super.SetData(self, data:GetItemData())
  self:HideBgSp()
end
