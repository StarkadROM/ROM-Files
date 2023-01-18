EquipUtil = {}
local ZENY = GameConfig.MoneyId.Zeny
local _Prefix = "Material_"
local InsertOrAddNum = function(array, item, idKey, numKey)
  if type(array) ~= "table" or type(item) ~= "table" then
    return
  end
  idKey = idKey or "id"
  numKey = numKey or "num"
  for _, i in pairs(array) do
    if i[idKey] == item[idKey] then
      i[numKey] = i[numKey] + item[numKey]
      return
    end
  end
  local copy = {}
  TableUtility.TableShallowCopy(copy, item)
  TableUtility.ArrayPushBack(array, copy)
end
function EquipUtil.CalcEquipUpgradeCost(id, count)
  local num = count or 0
  local upgradeData = Table_EquipUpgrade[id]
  if not upgradeData and num ~= 0 then
    redlog("Func CalcEquipUpgradeCost()--> Table_EquipUpgrade staticData is nil ,error EquipID: ", id)
    return
  end
  local result = {}
  local selfcost = {id = id, num = 1}
  InsertOrAddNum(result, selfcost)
  local costZeny = 0
  local cost, tempId
  local costTab = {}
  for i = 1, count do
    cost = upgradeData[_Prefix .. i]
    if cost then
      for i = 1, #cost do
        tempId = cost[i].id
        if tempId ~= ZENY then
          InsertOrAddNum(result, cost[i])
        else
          costZeny = costZeny + cost[i].num
        end
      end
    end
  end
  redlog("EquipUtil.CalcEquipUpgradeCost result: ", result, costZeny)
  return result, costZeny
end
function EquipUtil.GetRecoverCost(itemData, card_rv, upgrade_rv, strength_rv, enchant_rv, strength_rv2)
  if itemData == nil then
    return 0
  end
  local recoverConfig = GameConfig.EquipRecover
  local resultCost = 0
  if card_rv then
    local equipCards = itemData.equipedCardInfo
    if equipCards and #equipCards > 0 then
      local maxIndex = #recoverConfig.Card
      for k, v in pairs(equipCards) do
        local q = v.cardInfo.Quality
        q = math.clamp(q, 1, maxIndex)
        resultCost = resultCost + recoverConfig.Card[q]
      end
    end
  end
  if upgrade_rv then
    local equiplv = itemData.equipInfo.equiplv
    if equiplv > 0 then
      equiplv = math.clamp(equiplv, 1, #recoverConfig.Upgrade)
      resultCost = resultCost + recoverConfig.Upgrade[equiplv]
    end
  end
  local strength_addCost = false
  if strength_rv and 0 < itemData.equipInfo.strengthlv then
    strength_addCost = true
    resultCost = resultCost + recoverConfig.Strength
  end
  if strength_rv2 and strength_addCost == false and 0 < itemData.equipInfo.strengthlv2 then
    resultCost = resultCost + recoverConfig.Strength
  end
  if enchant_rv and itemData.enchantInfo and itemData.enchantInfo:HasAttri() then
    resultCost = resultCost + recoverConfig.Enchant
  end
  return resultCost
end
