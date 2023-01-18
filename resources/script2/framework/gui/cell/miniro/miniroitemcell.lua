local BaseCell = autoImport("BaseCell")
MiniROItemCell = class("MiniROItemCell", BaseCell)
local itemCellPos = {
  [1] = -97.9,
  [2] = -0.9,
  [3] = 96.5
}
local itemCellCount = 3
local tempCellVector3 = LuaVector3.Zero()
function MiniROItemCell:Init()
  self:FindObjs()
  self:AddEvents()
end
function MiniROItemCell:OnDisable()
  ReusableTable.DestroyAndClearArray(self.listItem)
  ReusableTable.DestroyAndClearTable(self.tipData)
end
function MiniROItemCell:FindObjs()
  self.txtTitle = self:FindComponent("txtTitle", UILabel)
  self.listItem = ReusableTable.CreateArray()
  self.tipData = ReusableTable.CreateTable()
  local itemCell
  for i = 1, itemCellCount do
    local obj = self:LoadPreferb("cell/ItemCell", self.gameObject)
    tempCellVector3[1] = itemCellPos[i]
    obj.transform.localPosition = tempCellVector3
    itemCell = ItemCell.new(obj)
    itemCell:Hide()
    self.listItem[#self.listItem + 1] = itemCell
  end
  self.objReceived = self:FindGO("objReceived")
  self.objSelect = self:FindGO("objSelect")
end
function MiniROItemCell:AddEvents()
  local itemCellData
  for i = 1, itemCellCount do
    self:AddButtonEvent("btn" .. i, function(go)
      itemCellData = self.listItem[i].data
      if itemCellData then
        self.tipData.itemdata = itemCellData
        self:ShowItemTip(self.tipData, self.tipStick, NGUIUtil.AnchorSide.Up)
      end
    end)
    break
  end
end
function MiniROItemCell:SetData(data)
  if not data then
    return
  end
  self.tipStick = data.tipStick
  for k, rewardId in pairs(data.listRewardId) do
    local listItemId = ItemUtil.GetRewardItemIdsByTeamId(rewardId)
    if not listItemId or TableUtil.TableIsEmpty(listItemId) then
      return
    end
    local itemCell
    for k, v in pairs(listItemId) do
      local item = ItemData.new("Reward", v.id)
      if k <= #self.listItem then
        itemCell = self.listItem[k]
        itemCell:Show()
        item.num = v.num
        itemCell:SetData(item)
      end
    end
  end
  self.txtTitle.text = data.title
  self.objReceived:SetActive(data.index <= MiniROProxy.Instance:GetCurCompleteTurns())
end
function MiniROItemCell:SetView(parentView)
  self.parentView = parentView
end
