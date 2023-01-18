MixLotteryItemData = class("MixLotteryItemData")
function MixLotteryItemData:ctor(itemid, grouprate, groupId, count)
  self:SetData(itemid, grouprate, groupId, count)
end
function MixLotteryItemData:SetData(itemid, grouprate, groupId, count)
  if itemid then
    self.itemid = itemid
    self.rate = grouprate
    self.groupId = groupId
    self.neverDisplay = AdventureDataProxy.Instance:IsFashionNeverDisplay(itemid, true)
    self.sortid = self.neverDisplay and 1 or 0
    self.count = count or 1
  end
end
function MixLotteryItemData:GetItemData()
  if self.itemData == nil then
    local itemid = self.itemid
    self.itemData = ItemData.new("MixLotteryItem", itemid)
    self.itemData:SetItemNum(self.count)
  end
  return self.itemData
end
function MixLotteryItemData:GetRate()
  if self.rate then
    local ungetCount = LotteryProxy.Instance:GetUngetCount(self.groupId)
    if ungetCount and 0 ~= ungetCount then
      local tempRate = self.rate / 100
      return string.format("%.3f", math.floor(tempRate + 0.5) / 100 / ungetCount)
    end
  end
  return 0
end
function MixLotteryItemData.SortFunc(l, r)
  if l.sortid == r.sortid then
    if l.groupId == r.groupId then
      if l.itemid == r.itemid then
        return l.count < r.count
      else
        return l.itemid < r.itemid
      end
    else
      return l.groupId < r.groupId
    end
  else
    return l.sortid > r.sortid
  end
end
