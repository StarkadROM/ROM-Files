NewRechargeTDepositData = class("NewRechargeTDepositData")
local table_Deposit
function NewRechargeTDepositData:ctor()
  if not table_Deposit then
    table_Deposit = Table_Deposit
  end
  self.ROBItemList = {}
  self.ZenyItemList = {}
end
NewRechargeTDepositData.ROBItemList = nil
local shopIdComparer = function(x, y)
  return x.ShopID < y.ShopID
end
function NewRechargeTDepositData:GetROBItemList(refresh)
  if refresh then
    TableUtility.ArrayClear(self.ROBItemList)
    for k, v in pairs(table_Deposit) do
      if v.Type == 3 and v.Switch == 1 then
        table.insert(self.ROBItemList, {ShopID = k, confType = 1})
      end
    end
    table.sort(self.ROBItemList, function(x, y)
      local xData, yData = table_Deposit[x.ShopID], table_Deposit[y.ShopID]
      local xOrder, yOrder = yData and yData.SortingOrder or xData and xData.SortingOrder or math.huge, math.huge
      if xOrder ~= yOrder then
        return xOrder < yOrder
      end
      return shopIdComparer(x, y)
    end)
  end
  return self.ROBItemList
end
NewRechargeTDepositData.ZenyItemList = nil
function NewRechargeTDepositData:GetZenyItemList(refresh)
  if refresh then
    TableUtility.ArrayClear(self.ZenyItemList)
    for k, v in pairs(table_Deposit) do
      if v.Type == 1 and v.Switch == 1 and v.ActivityDiscount ~= 1 then
        table.insert(self.ZenyItemList, {ShopID = k, confType = 1})
      end
    end
    table.sort(self.ZenyItemList, shopIdComparer)
  end
  return self.ZenyItemList
end
