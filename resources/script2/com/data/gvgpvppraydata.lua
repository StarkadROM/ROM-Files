local singlePray = class("singlePray")
function singlePray:_setSinglePrayData(serviceData)
  self.id = serviceData.prayid
  self.staticData = Table_Guild_Faith[self.id]
  self.lv = serviceData.praylv
  self.type = serviceData.type
  local serviceAttr = serviceData.attrs
  if serviceAttr and #serviceAttr > 0 then
    local attrId = serviceAttr[1].type
    self.attrStaticData = Table_RoleData[attrId]
    self.attrValue = serviceAttr[1].value
    if #serviceAttr > 1 then
      local attrId2 = serviceAttr[2].type
      self.attrStaticData2 = Table_RoleData[attrId2]
      self.attrValue2 = serviceAttr[2].value
    end
  else
    self.attrValue = 0
  end
  local itemInfo = serviceData.costs
  if itemInfo and #itemInfo > 0 then
    local item = ItemData.new(itemInfo[1].guid, itemInfo[1].id)
    item.num = itemInfo[1].count
    self.itemCost = item
    if #itemInfo > 1 then
      local item2 = ItemData.new(itemInfo[2].guid, itemInfo[2].id)
      item2.num = itemInfo[2].count
      self.itemCost2 = item2
    end
  end
end
GvGPvpPrayData = class("GvGPvpPrayData")
function GvGPvpPrayData:ctor(data)
  self.staticId = data.pray
  self.staticData = Table_Guild_Faith[self.staticId]
  self.lv = data.lv
  self.curPray = singlePray.new()
  self.curPray:_setSinglePrayData(data.cur)
  if #data.next > 0 then
    self.nextPray = singlePray.new()
    self.nextPray:_setSinglePrayData(data.next[1])
    self:SetNextPrayArray(data.next)
  end
  self:_SetPrayType()
  if self.type then
    self.id = 0 == self.curPray.lv and self.nextPray.id or self.curPray.id
  end
  self:SetCostName()
end
function GvGPvpPrayData:SetCostName()
  self.costName = ""
  if self.nextPray and self.nextPray.itemCost then
    self.costName = self.nextPray.itemCost.staticData.NameZh
  elseif self.curPray and self.curPray.itemCost then
    self.costName = self.curPray.itemCost.staticData.NameZh
  end
end
function GvGPvpPrayData:_SetPrayType()
  if 0 == self.curPray.lv then
    if self.nextPray then
      self.type = self.nextPray.type
    end
  else
    self.type = self.curPray.type
  end
end
local args = {}
function GvGPvpPrayData:GetAddAttrValue()
  if not self.nextPray or 0 == self.nextPray.lv then
    args[1] = false
    args[2] = self.curPray.staticData.AttrName
    local cur = self.curPray.attrValue
    args[3] = self.curPray.attrStaticData.IsPercent == 1 and string.format("%s%%", cur / 100) or cur / 10000
  else
    args[1] = true
    args[2] = self.nextPray.staticData.AttrName
    local curAttrValue = self.curPray.attrValue
    local nextAttrVal = self.nextPray.attrValue
    local IsPercent = self.nextPray.attrStaticData and self.nextPray.attrStaticData.IsPercent or self.curPray.attrStaticData.IsPercent
    args[3] = IsPercent == 1 and string.format("%s%%", curAttrValue / 100) or curAttrValue / 10000
    local deltaValue = nextAttrVal - curAttrValue
    args[4] = IsPercent == 1 and string.format("%s%%", deltaValue / 100) or deltaValue / 10000
    if self.nextPray.itemCost then
      args[5] = self.nextPray.itemCost.num
      args[6] = self.nextPray.itemCost.staticData.NameZh
    end
    if self.nextPray.itemCost2 then
      args[8] = self.nextPray.itemCost2.num
      args[9] = self.nextPray.itemCost2.staticData.NameZh
    end
  end
  args[7] = self.type
  return args
end
function GvGPvpPrayData:SetNextPrayArray(nexts)
  self.nextPrays = {}
  for i = 1, #nexts do
    local data = singlePray.new()
    data:_setSinglePrayData(nexts[i])
    self.nextPrays[#self.nextPrays + 1] = data
  end
end
function GvGPvpPrayData:CalcMaxPrayCount()
  if not self.nextPray then
    return 0
  end
  local own = BagProxy.Instance:GetItemNumByStaticID(self.nextPray.itemCost.staticData.id)
  local c = 0
  for i = 1, #self.nextPrays do
    c = c + self.nextPrays[i].itemCost.num
    if own < c then
      return i - 1
    elseif i == #self.nextPrays then
      return i
    end
  end
  return 0
end
