LotteryItemData = class("LotteryItemData")
function LotteryItemData:ctor(data)
  self:SetData(data)
end
function LotteryItemData:SetData(data)
  if data then
    self.id = data.id
    self.itemid = data.itemid
    self.female_itemid = data.female_itemid
    self.count = data.count
    self.timeShow = data.time_show
    self.recoverPrice = data.recover_price
    self.recoverItemid = data.recover_itemid
    self.rate = data.rate
    self.rarity = data.rarity
    if data.cur_batch then
      self.isCurBatch = 1
    else
      self.isCurBatch = 0
    end
    self.itemType = data.itemtype or 0
    self.safety_rate = data.safety_rate or 0
    if data.up_begin and 0 < data.up_begin then
      self.up_begin = data.up_begin
    else
      self.up_begin = nil
    end
    if data.up_end and 0 < data.up_end then
      self.up_end = data.up_end
    else
      self.up_end = nil
    end
  end
end
function LotteryItemData:HasConfigTime()
  return self.timeShow and self.timeShow > 0
end
function LotteryItemData:GetRealItemID()
  local itemData = self:GetItemData()
  return itemData and itemData.staticData and itemData.staticData.id
end
function LotteryItemData:GetItemData()
  if self.itemData == nil then
    local itemid = self.itemid
    if self.female_itemid and self.female_itemid ~= 0 then
      local sex = Game.Myself.data.userdata:Get(UDEnum.SEX) or 1
      if sex == 2 then
        itemid = self.female_itemid
      end
    end
    self.itemData = ItemData.new("LotteryItem", itemid)
    self.itemData.num = self.count
  end
  return self.itemData
end
function LotteryItemData:GetRate()
  if self.rate then
    if BranchMgr.IsJapan() then
      local tempRate = math.floor(self.rate / 100 + 0.5) / 100
      if tempRate < 0.01 then
        tempRate = 0.01
      end
      return tempRate
    else
      return self.rate / 10000
    end
  end
  return 0
end
function LotteryItemData:GetOriginRate()
  return self.rate - self.safety_rate, self.safety_rate
end
function LotteryItemData:GetDisplayRate()
  local baseRate, safetyRate = self:GetOriginRate()
  local tempRate, tempSafety = 0, 0
  if BranchMgr.IsJapan() then
    tempRate = math.floor(baseRate / 100 + 0.5) / 100
    tempSafety = math.floor(baseRate / 100 + 0.5) / 100
    if tempRate < 0.01 then
      tempRate = 0.01
    end
    if tempSafety < 0.01 then
      tempSafety = 0.01
    end
  else
    tempRate = baseRate / 10000
    tempSafety = safetyRate / 10000
  end
  return tempRate, tempSafety
end
function LotteryItemData:GetUpDuration()
  return self.up_begin, self.up_end
end
