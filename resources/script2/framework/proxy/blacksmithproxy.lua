autoImport("RefineTypeData")
BlackSmithProxy = class("BlackSmithProxy", pm.Proxy)
BlackSmithProxy.Instance = nil
BlackSmithProxy.NAME = "BlackSmithProxy"
BlackSmithProxy.RefineLimitQuality = 3
BlackSmithProxy.HRefinePropValueMap = {Refine = 1, MRefine = 0}
function BlackSmithProxy:ctor(proxyName, data)
  self.proxyName = proxyName or BlackSmithProxy.NAME
  if BlackSmithProxy.Instance == nil then
    BlackSmithProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:ParseRefineConfig()
  self:InitAdvancedEnchant()
  self:InitHighRefineCompose()
  self:IntiHighRefine()
end
function BlackSmithProxy:onRegister()
end
function BlackSmithProxy:onRemove()
end
function BlackSmithProxy:ParseRefineConfig()
  self.refineDataMap = {}
  local data, t, refineTypeData
  for k, v in pairs(Table_EquipRefine) do
    data = v
    for j = 1, #data.EuqipType do
      t = data.EuqipType[j]
      refineTypeData = self.refineDataMap[t]
      if not refineTypeData then
        refineTypeData = RefineTypeData.new(t)
        self.refineDataMap[t] = refineTypeData
      end
      refineTypeData:AddData(data)
    end
  end
end
function BlackSmithProxy:SearchMasterByLv(array, lv)
  for i = 1, #array do
    if array[i].Needlv == lv then
      return array[i]
    end
  end
  return nil
end
function BlackSmithProxy:GetNextStrengthMaster(data)
  return self.strengthMaster[(data and data.dynamicIndex or 0) + 1]
end
function BlackSmithProxy:GetNextRefineMaster(data)
  return self.refineMaster[(data and data.dynamicIndex or 0) + 1]
end
function BlackSmithProxy:GetStrengthMaster(lv)
  return self:SearchMasterByLv(self.strengthMaster, lv)
end
function BlackSmithProxy:GetRefineEquips(valid_equiptype_map, includeFashion)
  local result = {}
  if includeFashion then
    local fashionEquips = BagProxy.Instance.fashionBag:GetItems()
    local equipInfo
    for i = 1, #fashionEquips do
      equipInfo = fashionEquips[i].equipInfo
      if equipInfo then
        if valid_equiptype_map then
          if valid_equiptype_map[equipInfo.equipData.EquipType] and equipInfo:CanRefine() then
            table.insert(result, fashionEquips[i])
          end
        elseif equipInfo:CanRefine() then
          table.insert(result, fashionEquips[i])
        end
      end
    end
  end
  local roleEquips = BagProxy.Instance.roleEquip:GetItems()
  local equipInfo
  for i = 1, #roleEquips do
    equipInfo = roleEquips[i].equipInfo
    if equipInfo then
      if valid_equiptype_map then
        if valid_equiptype_map[equipInfo.equipData.EquipType] and equipInfo:CanRefine() then
          table.insert(result, roleEquips[i])
        end
      elseif equipInfo:CanRefine() then
        table.insert(result, roleEquips[i])
      end
    end
  end
  local items = BagProxy.Instance:GetBagEquipTab():GetItems()
  for i = 1, #items do
    equipInfo = items[i].equipInfo
    if equipInfo then
      if valid_equiptype_map then
        if valid_equiptype_map[equipInfo.equipData.EquipType] and equipInfo:CanRefine() then
          table.insert(result, items[i])
        end
      elseif equipInfo:CanRefine() then
        table.insert(result, items[i])
      end
    end
  end
  BlackSmithProxy.SortEquips(result)
  return result
end
function BlackSmithProxy:GetRefineMaster(lv)
  return self:SearchMasterByLv(self.refineMaster, lv)
end
function BlackSmithProxy:SetEquipOptDiscounts(etype, params)
  if etype == nil then
    redlog("etype cannot be nil.")
    return
  end
  self.equipOptDiscount_Map = self.equipOptDiscount_Map or {}
  local discounts = self.equipOptDiscount_Map[etype]
  if discounts == nil then
    discounts = {}
    self.equipOptDiscount_Map[etype] = discounts
  else
    TableUtility.ArrayClear(discounts)
  end
  if params and params[1] then
    for i = 1, #params do
      discounts[i] = params[i]
    end
  end
end
function BlackSmithProxy:GetEquipOptDiscounts(etype)
  if self.equipOptDiscount_Map == nil then
    return _EmptyTable
  end
  return self.equipOptDiscount_Map[etype]
end
function BlackSmithProxy.GetSafeRefineCostConfigName(islottery, isnewequip)
  return islottery and "SafeRefineEquipCostLottery" or isnewequip and "SafeRefineNewEquipCost" or "SafeRefineEquipCost"
end
function BlackSmithProxy.GetSafeRefineCostConfig(islottery, isnewequip, equipData)
  local name = BlackSmithProxy.GetSafeRefineCostConfigName(islottery, isnewequip)
  local cfg = GameConfig[name]
  if name == "SafeRefineNewEquipCost" then
    local index = equipData and equipData.NewEquipRefine
    cfg = cfg and index and cfg[index] or nil
  end
  return cfg, name
end
local safeRefineEquipCostItemIdGetter = {
  SafeRefineEquipCostLottery = function(equip)
    return BlackSmithProxy.GetMinCostMaterialID(equip.staticData.id)
  end,
  SafeRefineNewEquipCost = function(equip, refinelv)
    local cfg = BlackSmithProxy.GetSafeRefineCostConfig(nil, true, equip.equipInfo and equip.equipInfo.equipData)
    if cfg and cfg[refinelv] then
      return cfg[refinelv][1][1]
    end
  end,
  SafeRefineEquipCost = function(equip)
    return BlackSmithProxy.GetMinCostMaterialID(equip.staticData.id)
  end
}
local safeRefineEquipCostNumGetter = {
  SafeRefineEquipCostLottery = function(v)
    return v
  end,
  SafeRefineNewEquipCost = function(v, indiscount)
    return indiscount and v[1][3] or v[1][2]
  end,
  SafeRefineEquipCost = function(v, indiscount)
    return indiscount and v[2] or v[1]
  end
}
function BlackSmithProxy:GetSafeRefineClamp(islottery, targetequipinfo)
  if targetequipinfo then
    local cfg, name = BlackSmithProxy.GetSafeRefineCostConfig(islottery, targetequipinfo:IsNextGen(), targetequipinfo.equipData)
    if cfg then
      local min, max, s
      for lv, data in pairs(cfg) do
        s = safeRefineEquipCostNumGetter[name](data)
        if s ~= 0 then
          if not min then
          else
            min = lv or math.min(min, lv)
          end
          if not max then
          else
            max = lv or math.max(max, lv)
          end
        end
      end
      return min, max
    end
  end
  return 0, 0
end
function BlackSmithProxy:GetSafeRefineCostEquip(equip, refinelv, islottery)
  if not equip or not refinelv then
    return
  end
  local cfg, name = BlackSmithProxy.GetSafeRefineCostConfig(islottery, equip.equipInfo:IsNextGen(), equip.equipInfo.equipData)
  cfg = cfg and cfg[refinelv]
  if not cfg then
    return
  end
  local indiscount = self:GetEquipOptDiscounts(ActivityCmd_pb.GACTIVITY_SAFE_REFINE_DISCOUNT)
  indiscount = indiscount and indiscount[1] or false
  return safeRefineEquipCostItemIdGetter[name](equip, refinelv), safeRefineEquipCostNumGetter[name](cfg, indiscount)
end
local getEquipMinVID = function(itemid)
  local lackEquipId
  local vidCache = EquipRepairProxy.Instance:GetEquipVIDCache(itemid)
  if vidCache then
    local minSlot
    for k, v in pairs(vidCache) do
      if minSlot == nil or k < minSlot then
        minSlot = k
        lackEquipId = v.id
      end
    end
  else
    lackEquipId = itemid
  end
  return lackEquipId
end
function BlackSmithProxy.GetMinCostMaterialID(itemid)
  local composeData = Table_EquipCompose[itemid]
  if composeData then
    itemid = composeData.Material[1].id
  end
  local equipType = Table_Equip[itemid] and Table_Equip[itemid].EquipType
  if equipType ~= 8 then
    itemid = getEquipMinVID(itemid)
  end
  return itemid
end
function BlackSmithProxy.SortMaterialEquips(equipA, equipB)
  local slotA, slotB = equipA.cardSlotNum, equipB.cardSlotNum
  if slotA ~= slotB then
    return slotA < slotB
  end
  local equipInfoA, equipInfoB = equipA.equipInfo, equipB.equipInfo
  if equipInfoA.equiplv ~= equipInfoB.equiplv then
    return equipInfoA.equiplv < equipInfoB.equiplv
  end
  if equipInfoA.refinelv ~= equipInfoB.refinelv then
    return equipInfoA.refinelv < equipInfoB.refinelv
  end
  local equipA_hasEnchant = equipA.enchantInfo and equipA.enchantInfo:HasAttri() or false
  local equipB_hasEnchant = equipB.enchantInfo and equipB.enchantInfo:HasAttri() or false
  if equipA_hasEnchant ~= equipB_hasEnchant then
    return not equipA_hasEnchant
  end
  local equipA_CardNum = equipA:GetEquipedCardNum()
  local equipB_CardNum = equipB:GetEquipedCardNum()
  if equipA_CardNum ~= equipB_CardNum then
    return equipA_CardNum < equipB_CardNum
  end
  if equipInfoA.strengthlv2 ~= equipInfoB.strengthlv2 then
    return equipInfoA.strengthlv2 < equipInfoB.strengthlv2
  end
  if equipInfoA.strengthlv ~= equipInfoB.strengthlv then
    return equipInfoA.strengthlv < equipInfoB.strengthlv
  end
  return equipA.staticData.id < equipB.staticData.id
end
function BlackSmithProxy:GetMaterialEquips_ByEquipId(equipid, count, filterDamage, filterFunc, bagTypes, matchCall, matchCallParam, noCheckFavoriteMaterial)
  local equips
  if bagTypes == nil then
    equips = BagProxy.Instance:GetItemsByStaticID(equipid, BagProxy.BagType.MainBag)
  else
    equips = {}
    local bagData, items
    for i = 1, #bagTypes do
      bagData = BagProxy.Instance:GetBagByType(bagTypes[i])
      items = bagData:GetItems()
      for j = 1, #items do
        if items[j].staticData.id == equipid then
          table.insert(equips, items[j])
        end
      end
    end
  end
  if equips == nil or #equips == 0 then
    return _EmptyTable
  end
  table.sort(equips, BlackSmithProxy.SortMaterialEquips)
  local result = {}
  for i = 1, #equips do
    if equips[i].equipInfo.refinelv <= GameConfig.Item.material_max_refine then
      local valid
      if noCheckFavoriteMaterial then
        valid = true
      else
        valid = BagProxy.Instance:CheckIfFavoriteCanBeMaterial(equips[i]) ~= false
      end
      if filterFunc and valid then
        valid = filterFunc(equips[i])
      end
      if valid then
        if filterDamage then
          if not equips[i].equipInfo.damage then
            if matchCall then
              matchCall(matchCallParam, equips[i])
            end
            table.insert(result, equips[i])
          end
        else
          if matchCall then
            matchCall(matchCallParam, equips[i])
          end
          table.insert(result, equips[i])
        end
      end
    end
    if not count or #result ~= count then
    end
  end
  return result
end
local Func_CheckEquip_SameVID = function(itemA, itemB, includeSelf)
  if itemA == nil or itemB == nil then
    return false
  end
  if itemA.id == itemB.id then
    return includeSelf == true
  end
  if itemA.equipInfo == nil or itemB.equipInfo == nil then
    return false
  end
  local vid_a = itemA.equipInfo.equipData.VID
  local vid_b = itemB.equipInfo.equipData.VID
  if vid_a and vid_b then
    return math.floor(vid_a / 10000) == math.floor(vid_b / 10000) and vid_a % 1000 == vid_b % 1000
  end
  return false
end
local Func_CheckEquip_IsComposeMaterial = function(item, checkItem, includeSelf)
  local sid = item.staticData.id
  local sData = sid and Table_EquipCompose[sid]
  if sData == nil then
    return false
  end
  local mainEquipId = sData.Material[1].id
  local mainItem = ItemData.new("Temp", mainEquipId)
  return Func_CheckEquip_SameVID(mainItem, checkItem, includeSelf)
end
local materialEquipsResult = {}
function BlackSmithProxy:GetMaterialEquips_ByVID(itemData, bagTypes, matchCall, matchCallParam, noCheckFavoriteMaterial, includeSelf)
  TableUtility.ArrayClear(materialEquipsResult)
  if itemData == nil or itemData.equipInfo == nil then
    return materialEquipsResult
  end
  local isComposeEquip = Table_EquipCompose[itemData.staticData.id] ~= nil
  local bagProxy = BagProxy.Instance
  local material_max_refine = GameConfig.Item.material_max_refine
  local item, valid
  if bagTypes == nil then
    local bagItems = bagProxy.bagData:GetItems()
    for i = 1, #bagItems do
      item = bagItems[i]
      if noCheckFavoriteMaterial then
        valid = true
      else
        valid = BagProxy.Instance:CheckIfFavoriteCanBeMaterial(item) ~= false
      end
      if isComposeEquip then
        valid = valid and Func_CheckEquip_IsComposeMaterial(itemData, item, includeSelf)
      else
        valid = valid and Func_CheckEquip_SameVID(itemData, item, includeSelf)
      end
      if valid and material_max_refine >= item.equipInfo.refinelv then
        if matchCall then
          matchCall(matchCallParam, item)
        end
        table.insert(materialEquipsResult, item)
      end
    end
  else
    local bagData, bagItems
    for i = 1, #bagTypes do
      bagData = bagProxy:GetBagByType(bagTypes[i])
      bagItems = bagData:GetItems()
      for j = 1, #bagItems do
        item = bagItems[j]
        if noCheckFavoriteMaterial then
          valid = true
        else
          valid = BagProxy.Instance:CheckIfFavoriteCanBeMaterial(item) ~= false
        end
        if isComposeEquip then
          valid = valid and Func_CheckEquip_IsComposeMaterial(itemData, item, includeSelf)
        else
          valid = valid and Func_CheckEquip_SameVID(itemData, item, includeSelf)
        end
        if valid and material_max_refine >= item.equipInfo.refinelv then
          if matchCall then
            matchCall(matchCallParam, item)
          end
          table.insert(materialEquipsResult, item)
        end
      end
    end
  end
  table.sort(materialEquipsResult, BlackSmithProxy.SortMaterialEquips)
  return materialEquipsResult
end
function BlackSmithProxy:MaxRefineLevelByData(staticData)
  if staticData == nil then
    return 0
  end
  local refineMaxLevel1
  local refineType = self.refineDataMap[staticData.Type]
  if refineType then
    refineMaxLevel1 = refineType:GetRefineMaxLevel(staticData.Quality)
  end
  local refineMaxLevel2
  local equipData = Table_Equip[staticData.id]
  if equipData then
    refineMaxLevel2 = equipData.RefineMaxlv
  end
  if refineMaxLevel1 then
    if refineMaxLevel2 then
      return math.min(refineMaxLevel1, refineMaxLevel2)
    end
    return refineMaxLevel1
  end
  return 0
end
function BlackSmithProxy:GetRefineData(itemType, quality, refineLevel)
  local refineType = self.refineDataMap[itemType]
  if refineType then
    if refineLevel == 0 then
      refineLevel = 1
    end
    return refineType:GetData(quality, refineLevel)
  end
  return nil
end
function BlackSmithProxy:GetComposeIDsByItemData(itemData, isSafe)
  local refineType = self.refineDataMap[itemData.staticData.Type]
  if refineType then
    local refinelv = itemData.equipInfo.refinelv
    refinelv = refinelv + 1
    local maxRefineLv = self:MaxRefineLevelByData(itemData.staticData)
    if refinelv > maxRefineLv then
      refinelv = maxRefineLv
    end
    local data = refineType:GetData(itemData.staticData.Quality, refinelv)
    if data then
      if isSafe then
        for i = 1, #data.SafeRefineCost do
          if data.SafeRefineCost[i].color == itemData.staticData.Quality then
            return data.SafeRefineCost[i].id
          end
        end
      else
        for i = 1, #data.RefineCost do
          if data.RefineCost[i].color == itemData.staticData.Quality then
            return data.RefineCost[i].id
          end
        end
      end
    end
  end
  return nil
end
function BlackSmithProxy:GetExtraSuccesssByStaicID(staticID)
  for i = 1, #GameConfig.EquipRefineRate do
    if staticID == GameConfig.EquipRefineRate[i].itemid then
      return GameConfig.EquipRefineRate[i].rate
    end
  end
  return 0
end
function BlackSmithProxy:InitHighRefineCompose()
  if Table_HighRefineMatCompose == nil then
    return
  end
  self.highRefineCompose_GroupMap = {}
  for id, data in pairs(Table_HighRefineMatCompose) do
    local groupId = data.GroupId
    local cache = self.highRefineCompose_GroupMap[groupId]
    if cache == nil then
      cache = {}
      self.highRefineCompose_GroupMap[groupId] = cache
    end
    table.insert(cache, data)
  end
end
function BlackSmithProxy:GetHighRefineComposeData(groupId)
  if self.highRefineCompose_GroupMap then
    return self.highRefineCompose_GroupMap[groupId]
  end
  return _EmptyTable
end
function BlackSmithProxy:IntiHighRefine()
  if Table_HighRefine == nil then
    return
  end
  self.highRefineData_Map = {}
  for id, data in pairs(Table_HighRefine) do
    local t = self.highRefineData_Map[data.PosType]
    if t == nil then
      t = {}
      self.highRefineData_Map[data.PosType] = t
    end
    local level = data.Level
    local levelType = math.floor(level / 1000)
    local tt = t[levelType]
    if tt == nil then
      tt = {}
      t[levelType] = tt
    end
    local singlelevel = level % 1000
    tt[singlelevel] = data
    local equalPos = data.EqualPos
    for i = 1, #equalPos do
      local t = self.highRefineData_Map[equalPos[i]]
      if t == nil then
        t = {}
        self.highRefineData_Map[equalPos[i]] = t
      end
      local level = data.Level
      local levelType = math.floor(level / 1000)
      local tt = t[levelType]
      if tt == nil then
        tt = {}
        t[levelType] = tt
      end
      local singlelevel = level % 1000
      tt[singlelevel] = data
    end
  end
end
function BlackSmithProxy:GetHighRefineData(posType, levelType, level)
  if self.highRefineData_Map == nil then
    return
  end
  if posType == nil then
    return
  end
  local t = self.highRefineData_Map[posType]
  if levelType == nil then
    return t
  end
  if t == nil then
    return nil
  end
  t = t[levelType]
  if level == nil then
    return t
  end
  if t == nil then
    return nil
  end
  return t[level]
end
function BlackSmithProxy:GetMaxHRefineTypeOrLevel(pos, ttype)
  if ttype == nil then
    local _, unlockTypes = self:GetHighRefinePoses()
    local types = unlockTypes and unlockTypes[pos]
    if types then
      local maxType = 0
      for i = 1, #types do
        maxType = math.max(types[i], maxType)
      end
      return maxType
    end
  end
  local ds = self:GetHighRefineData(pos, ttype)
  if ds then
    return #ds
  end
  return 0
end
function BlackSmithProxy:GetShowHRefineDatas(pos)
  local maxType = self:GetMaxHRefineTypeOrLevel(pos)
  local showlvType = maxType
  for i = 1, maxType do
    local nowlv = self:GetPlayerHRefineLevel(pos, i)
    if nowlv < 10 then
      showlvType = i
      break
    end
  end
  return self:GetHighRefineData(pos, showlvType), showlvType
end
function BlackSmithProxy:SetPlayerHRefineLevels(server_highRefineDatas)
  if server_highRefineDatas == nil then
    return
  end
  self.playerHRefineLevelMap = {}
  for i = 1, #server_highRefineDatas do
    self:SetPlayerHRefineLevel(server_highRefineDatas[i])
  end
end
function BlackSmithProxy:SetPlayerHRefineLevel(server_highRefineData)
  if server_highRefineData == nil then
    return
  end
  local t = self.playerHRefineLevelMap[server_highRefineData.pos]
  if t == nil then
    t = {}
    self.playerHRefineLevelMap[server_highRefineData.pos] = t
  end
  for j = 1, #server_highRefineData.level do
    local lv = server_highRefineData.level[j]
    local levelType = math.floor(lv / 1000)
    local reallevel = lv % 1000
    t[levelType] = reallevel
  end
end
function BlackSmithProxy:GetPlayerHRefineLevel(pos, levelType)
  if self.playerHRefineLevelMap == nil then
    return 0
  end
  local poslvs = self.playerHRefineLevelMap[pos]
  return poslvs and poslvs[levelType] or 0
end
local tempTotalEffectMap = {}
function BlackSmithProxy:Get_TotalHRefineEffect_Map(equipPos, typelevel, hrlevel, class, limitRefinelv)
  local datas = self:GetHighRefineData(equipPos, typelevel)
  TableUtility.TableClear(tempTotalEffectMap)
  local resuleEffectMap = tempTotalEffectMap
  for i = 1, hrlevel do
    local s_effectmap = self:get_SingleHRefineEffects_Map(datas[i], class, limitRefinelv)
    if s_effectmap then
      for ek, ev in pairs(s_effectmap) do
        if ek ~= "Job" then
          local ov = resuleEffectMap[ek] or 0
          resuleEffectMap[ek] = ov + ev
        end
      end
    end
  end
  return resuleEffectMap
end
function BlackSmithProxy:get_SingleHRefineEffects_Map(config_data, class, refinelv)
  if refinelv and refinelv < config_data.RefineLv then
    return
  end
  local effect = config_data.Effect
  for i = 1, #effect do
    local jobs = effect[i].Job
    for j = 1, #jobs do
      if jobs[j] == class then
        return effect[i]
      end
    end
  end
  return nil
end
local tempEffectMap = {}
function BlackSmithProxy:GetMyHRefineEffectMap(pos, refinelv)
  TableUtility.TableClear(tempEffectMap)
  if pos == nil then
    return tempEffectMap
  end
  local resultEffectMap = tempEffectMap
  local myclass = MyselfProxy.Instance:GetMyProfession()
  local hrData = self:GetHighRefineData(pos)
  local maxType = hrData and #hrData or 0
  local attr, bit, singleEffectMap, val
  for k = 1, maxType do
    local level = self:GetPlayerHRefineLevel(pos, k)
    local effectmap = self:Get_TotalHRefineEffect_Map(pos, k, level, myclass, refinelv)
    for ek, ev in pairs(effectmap) do
      attr = self:GetHighRefineAttr(pos, k)
      if (ek == "Refine" or ek == "MRefine") and attr then
        for i = 1, self:GetPlayerHRefineLevel(pos, k) do
          bit = BitUtil.bandOneZero(attr, i - 1)
          singleEffectMap = self:get_SingleHRefineEffects_Map(self:GetHighRefineData(pos, k, i), myclass, refinelv)
          val = singleEffectMap and singleEffectMap[ek] or 0
          if bit == BlackSmithProxy.HRefinePropValueMap.Refine then
            resultEffectMap.Refine = (resultEffectMap.Refine or 0) + val
          elseif bit == BlackSmithProxy.HRefinePropValueMap.MRefine then
            resultEffectMap.MRefine = (resultEffectMap.MRefine or 0) + val
          end
        end
      else
        local v = resultEffectMap[ek] or 0
        resultEffectMap[ek] = v + ev
      end
    end
  end
  return resultEffectMap
end
function BlackSmithProxy:IsHighRefineUnlock()
  if EnvChannel.Channel.Name == EnvChannel.ChannelConfig.Alpha.Name or EnvChannel.Channel.Name == EnvChannel.ChannelConfig.Release.Name then
    return false
  end
  return true
end
function BlackSmithProxy:GetHighRefinePoses()
  local gbData = GuildBuildingProxy.Instance:GetBuildingDataByType(GuildBuildingProxy.Type.EGUILDBUILDING_HIGH_REFINE)
  if gbData == nil then
    return
  end
  local unlockParam = gbData.staticData.UnlockParam
  local result = {}
  if unlockParam and unlockParam.hrefine_part then
    for site, _ in pairs(unlockParam.hrefine_part) do
      table.insert(result, site)
    end
    table.sort(result, function(a, b)
      return a < b
    end)
  end
  return result, unlockParam.hrefine_part
end
function BlackSmithProxy:InitAdvancedEnchant()
  self.advancedEnchantCostMap = {}
  local posArr, cfg
  for _, d in pairs(Table_EnchantMustBuff) do
    posArr = d.Position
    for i = 1, #posArr do
      cfg = self.advancedEnchantCostMap[posArr[i]] or {}
      TableUtility.ArrayPushBack(cfg, {
        itemid = d.ItemID,
        num = 1,
        isMustBuff = true
      })
      self.advancedEnchantCostMap[posArr[i]] = cfg
    end
  end
  for _, d in pairs(Table_EnchantMinAttrImprove) do
    posArr = d.Position
    for i = 1, #posArr do
      cfg = self.advancedEnchantCostMap[posArr[i]] or {}
      TableUtility.ArrayPushBack(cfg, d.Cost)
      self.advancedEnchantCostMap[posArr[i]] = cfg
    end
  end
end
function BlackSmithProxy:GetAdvancedEnchantCostConfig(t)
  return t and self.advancedEnchantCostMap[t] or _EmptyTable
end
local errorEnchantCheckTemplate = {
  MaxSpPer = 0,
  MAtk = 0,
  EquipASPD = 0,
  DamIncrease = 0
}
function BlackSmithProxy.HasErrorEnchantInfo(itemData)
  local enchantInfo = itemData.enchantInfo
  if enchantInfo then
    local attris = enchantInfo:GetEnchantAttrs()
    local combineEffect = enchantInfo:GetCombineEffects()
    if #combineEffect == 0 then
      local temp = ReusableTable.CreateTable()
      TableUtility.TableShallowCopy(temp, errorEnchantCheckTemplate)
      for i = 1, #attris do
        if temp[attris[i].type] == 0 then
          temp[attris[i].type] = 1
        end
      end
      local result = temp.MaxSpPer == 1 and temp.MAtk == 1 or temp.DamIncrease or temp.EquipASPD == 1
      ReusableTable.DestroyAndClearTable(temp)
      if result then
        return true
      end
    end
  end
  return false
end
local _EnchantCost = {}
function BlackSmithProxy:GetEnchantCost(enchantType, itemType)
  TableUtility.ArrayClear(_EnchantCost)
  local actDiscount = self:GetEquipOptDiscounts(ActivityCmd_pb.GACTIVITY_ENCHATN_DISCOUNT)
  actDiscount = actDiscount and actDiscount[1]
  if actDiscount or not HomeManager.Me():TryGetHomeWorkbenchDiscount("Enchant") then
    local homeDiscount
  end
  if math.Approximately(homeDiscount or 0, 100) then
    homeDiscount = nil
  end
  local costConfig = GameConfig.EquipEnchant and GameConfig.EquipEnchant.SpecialCost
  if costConfig then
    local config = costConfig[enchantType][itemType]
    if config ~= nil then
      local zenyCost
      for i = #config, 1, -1 do
        if config[i].itemid == 100 then
          zenyCost = config[i].num
        else
          table.insert(_EnchantCost, config[i])
        end
      end
      return _EnchantCost, zenyCost or 0, actDiscount, homeDiscount
    end
  end
  local cost = EnchantEquipUtil.Instance:GetEnchantCost(enchantType)
  if cost then
    table.insert(_EnchantCost, cost.ItemCost)
    return _EnchantCost, cost.ZenyCost or 0, actDiscount, homeDiscount
  end
end
local Enchant_UnlockMenuId = {
  [SceneItem_pb.EENCHANTTYPE_PRIMARY] = 71,
  [SceneItem_pb.EENCHANTTYPE_MEDIUM] = 72,
  [SceneItem_pb.EENCHANTTYPE_SENIOR] = 73
}
function BlackSmithProxy:CanBetter_EquipEnchantInfo()
  local unlockFunc = FunctionUnLockFunc.Me()
  local maxEnchantType
  for enchantType, menuId in pairs(Enchant_UnlockMenuId) do
    if unlockFunc:CheckCanOpen(menuId) and (maxEnchantType == nil or enchantType > maxEnchantType) then
      maxEnchantType = enchantType
    end
  end
  local roleEquipBag = BagProxy.Instance:GetRoleEquipBag()
  local items = roleEquipBag:GetItems()
  if #items == 0 then
    return false
  end
  if maxEnchantType == nil then
    return false
  end
  local item
  for i = 1, #items do
    item = items[i]
    if self:CheckItemEnchant_CanBetter(item, maxEnchantType) then
      return true
    end
  end
  return false
end
function BlackSmithProxy:CheckItemEnchant_CanBetter(item, maxEnchantType)
  local equipInfo = item and item.equipInfo
  if equipInfo == nil or not equipInfo:CanEnchant() then
    return false
  end
  local enchantInfo = item.enchantInfo
  local lcondition_enchantType = enchantInfo == nil and SceneItem_pb.EENCHANTTYPE_PRIMARY or enchantInfo.enchantType + 1
  if maxEnchantType and maxEnchantType < lcondition_enchantType then
    return false
  end
  local itemType = item.staticData.Type
  local enchantCost, zenyCost, actDiscount, homeDiscount = self:GetEnchantCost(lcondition_enchantType, itemType)
  if MyselfProxy.Instance:GetROB() < math.floor(zenyCost * (actDiscount or homeDiscount or 100) / 100 + 0.01) then
    return false
  end
  if enchantCost ~= nil then
    local bagProxy = BagProxy.Instance
    local search_bagtypes = bagProxy:Get_PackageMaterialCheck_BagTypes(BagProxy.MaterialCheckBag_Type.Enchant)
    for _, cost in pairs(enchantCost) do
      for itemid, needNum in pairs(cost) do
        local items = bagProxy:GetMaterialItems_ByItemId(itemid, search_bagtypes)
        local haveNum = 0
        for i = 1, #items do
          haveNum = haveNum + items[i].num
        end
        if haveNum < math.floor(needNum * (actDiscount or 100) / 100 + 0.01) then
          return false
        end
      end
    end
  end
  return true
end
function BlackSmithProxy:RecvHighRefineAttr(data)
  self.highRefineAttrMap = self.highRefineAttrMap or {}
  self.highRefineAttrMap[data.epos] = self.highRefineAttrMap[data.epos] or {}
  self.highRefineAttrMap[data.epos][data.type + 1] = data.value
end
function BlackSmithProxy:GetHighRefineAttr(posType, levelType, level)
  if not self.highRefineAttrMap then
    return
  end
  if not self.highRefineAttrMap[posType] then
    return
  end
  local value = self.highRefineAttrMap[posType][levelType]
  if not value or level == nil then
    return value
  end
  if level <= 0 or level > self:GetMaxHRefineTypeOrLevel(posType, levelType) then
    return
  end
  return BitUtil.bandOneZero(value, level - 1)
end
function BlackSmithProxy:UpdateEquipRecovery(datas)
  if not self.recoveryTimesMap then
    self.recoveryTimesMap = {}
    for k, _ in pairs(GameConfig.EquipRecovery) do
      if type(k) == "number" then
        self.recoveryTimesMap[k] = {
          pos = k,
          times = 0,
          timesPlus = 0
        }
      end
    end
  end
  local pos, timesPlus, times
  for i = 1, #datas do
    pos, timesPlus, times = datas[i].pos, datas[i].super_recovery_times or 0, datas[i].recovery_times or 0
    self.recoveryTimesMap[pos] = self.recoveryTimesMap[pos] or {}
    self.recoveryTimesMap[pos].times = times
    self.recoveryTimesMap[pos].timesPlus = timesPlus
  end
end
function BlackSmithProxy:GetEquipRecoveryTimes(pos, isPlus)
  if not self.recoveryTimesMap or not pos then
    return -1
  end
  local key = isPlus and "timesPlus" or "times"
  return self.recoveryTimesMap[pos] and self.recoveryTimesMap[pos][key] or -1
end
function BlackSmithProxy.GetStaticEquipRecoveryEndTimeString()
  return GameConfig.EquipRecovery[EnvChannel.IsTFBranch() and "TfEndTime" or "EndTime"]
end
function BlackSmithProxy.GetStaticEquipRecoveryEndTime()
  local endTimeStr = BlackSmithProxy.GetStaticEquipRecoveryEndTimeString()
  if endTimeStr then
    local year, month, day, hour, min, sec = endTimeStr:match("(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)")
    return os.time({
      day = day,
      month = month,
      year = year,
      hour = hour,
      min = min,
      sec = sec
    })
  end
end
function BlackSmithProxy.CheckEquipRecoveryTime()
  local endTime = BlackSmithProxy.GetStaticEquipRecoveryEndTime()
  return endTime ~= nil and endTime >= ServerTime.CurServerTime() / 1000
end
local refineEquipTypeMap = {}
function BlackSmithProxy.GetRefineEquipTypeMap()
  if not next(refineEquipTypeMap) then
    for k, _ in pairs(GameConfig.EquipType) do
      if k ~= 8 and k ~= 9 and k ~= 10 and k ~= 11 and k ~= 13 then
        refineEquipTypeMap[k] = 1
      end
    end
  end
  return refineEquipTypeMap
end
function BlackSmithProxy.GetEquipBuffUpLevel(site, playerId, buffUpType, limit)
  playerId = playerId or Game.Myself.data.id
  local t = type(site)
  if t == "number" then
    return BlackSmithProxy._GetEquipBuffUpLevel(site, playerId, buffUpType, limit)
  else
    local result = {}
    if t == "table" and next(site) then
      for _, s in pairs(site) do
        result[s] = BlackSmithProxy._GetEquipBuffUpLevel(s, playerId, buffUpType, limit)
      end
    elseif t == "nil" or t == "table" and not next(site) then
      for _, data in pairs(GameConfig.EquipType) do
        for _, s in pairs(data.site) do
          result[s] = BlackSmithProxy._GetEquipBuffUpLevel(s, playerId, buffUpType, limit)
        end
      end
    end
    if next(result) then
      return result
    end
  end
  return 0
end
function BlackSmithProxy.GetStrengthBuffUpLevel(site, playerId, limit)
  return BlackSmithProxy.GetEquipBuffUpLevel(site, playerId, "Strength", limit)
end
function BlackSmithProxy.GetRefineBuffUpLevel(site, playerId, limit)
  return BlackSmithProxy.GetEquipBuffUpLevel(site, playerId, "Refine", limit)
end
function BlackSmithProxy.CalculateBuffUpLevel(initLv, maxLv, withLimitUpLevel, withoutLimitUpLevel)
  withLimitUpLevel = withLimitUpLevel or 0
  withoutLimitUpLevel = withoutLimitUpLevel or 0
  maxLv = maxLv + withoutLimitUpLevel
  return math.min(initLv + withLimitUpLevel + withoutLimitUpLevel, maxLv), maxLv
end
local equipBuffUpTypeMap = {
  Strength = "UpgradeStrengthLv",
  Refine = "UpgradeRefineLv"
}
local equipBuffUpPredicateName = {
  Strength = "CanStrength",
  Refine = "CanRefine"
}
local buffTable
local tryGetEquipBuffUpEffectData = function(buffId, buffUpType)
  if not buffTable then
    buffTable = Table_Buffer
  end
  local eff = buffTable[buffId] and buffTable[buffId].BuffEffect
  if eff and eff.type == equipBuffUpTypeMap[buffUpType] then
    return eff
  end
end
local equipBuffUpLastUpdateTimeMap, equipBuffUpUpdateLevelMap = {}, {}
local equipBuffUpUpdateCdTime = 200
local withLimitKey, withoutLimitKey = 1, 0
function BlackSmithProxy._GetEquipBuffUpLevel(site, playerId, buffUpType, limit)
  if not buffUpType then
    return 0
  end
  if not equipBuffUpLastUpdateTimeMap[playerId] or not equipBuffUpLastUpdateTimeMap[playerId][buffUpType] or ServerTime.CurClientTime() - equipBuffUpLastUpdateTimeMap[playerId][buffUpType] > equipBuffUpUpdateCdTime then
    equipBuffUpUpdateLevelMap[playerId] = equipBuffUpUpdateLevelMap[playerId] or {}
    local typeLevelMap = equipBuffUpUpdateLevelMap[playerId][buffUpType] or {}
    TableUtility.TableClear(typeLevelMap)
    local hasBuff, player, eff, limitKey = BlackSmithProxy.CheckHasEquipBuffUp(playerId, buffUpType)
    if hasBuff then
      for buffId, _ in pairs(player.buffs) do
        eff = tryGetEquipBuffUpEffectData(buffId, buffUpType)
        if eff then
          for _, pos in pairs(eff.equipPos) do
            typeLevelMap[pos] = typeLevelMap[pos] or {}
            limitKey = eff.limit and withLimitKey or withoutLimitKey
            typeLevelMap[pos][limitKey] = (typeLevelMap[pos][limitKey] or 0) + eff.upLevel
          end
        end
      end
    end
    equipBuffUpUpdateLevelMap[playerId][buffUpType] = typeLevelMap
    local typeTimeMap = equipBuffUpLastUpdateTimeMap[playerId] or {}
    typeTimeMap[buffUpType] = ServerTime.CurClientTime()
    equipBuffUpLastUpdateTimeMap[playerId] = typeTimeMap
  end
  local map = equipBuffUpUpdateLevelMap[playerId][buffUpType][site]
  if map then
    local withLimitUpLevel, withoutLimitUpLevel = map[withoutLimitKey] or map[withLimitKey] or 0, 0
    if limit == 0 or limit == false then
      return withoutLimitUpLevel
    elseif limit then
      return withLimitUpLevel
    else
      return withLimitUpLevel + withoutLimitUpLevel
    end
  end
  return 0
end
function BlackSmithProxy.CheckHasEquipBuffUp(playerId, buffUpType)
  if playerId then
    local player, eff = SceneCreatureProxy.FindCreature(playerId)
    if player and player.buffs then
      for buffId, _ in pairs(player.buffs) do
        eff = tryGetEquipBuffUpEffectData(buffId, buffUpType)
        if eff then
          return true, player
        end
      end
    end
  end
  return false
end
function BlackSmithProxy.CheckShowEquipBuffUpLevel(itemData, playerId, buffUpType)
  if not Game.Myself then
    return false
  end
  local equipInfo = itemData and itemData.equipInfo
  local predicateName = buffUpType and equipBuffUpPredicateName[buffUpType]
  local predicate = predicateName and EquipInfo[predicateName]
  if equipInfo and predicate and predicate(equipInfo) then
    local hasBuff, player = BlackSmithProxy.CheckHasEquipBuffUp(playerId or Game.Myself.data.id, buffUpType)
    if hasBuff then
      if player == Game.Myself then
        local bagData = BagProxy.Instance:GetBagByType(BagProxy.BagType.RoleEquip)
        local myItem = bagData:GetItemByGuid(itemData.id)
        if myItem then
          return true
        end
      else
        return true
      end
    end
  end
  return false
end
function BlackSmithProxy.CheckShowStrengthBuffUpLevel(itemData, playerId)
  return BlackSmithProxy.CheckShowEquipBuffUpLevel(itemData, playerId, "Strength")
end
function BlackSmithProxy.CheckShowRefineBuffUpLevel(itemData, playerId)
  return BlackSmithProxy.CheckShowEquipBuffUpLevel(itemData, playerId, "Refine")
end
function BlackSmithProxy.SortEquips(datas)
  table.sort(datas, function(a, b)
    if a.equiped and b.equiped and a.equiped ~= b.equiped then
      return a.equiped > b.equiped
    end
    if a.equipInfo and b.equipInfo then
      local a_site = a.equipInfo.site and a.equipInfo.site[1] or 1
      local b_site = b.equipInfo.site and b.equipInfo.site[1] or 1
      if a_site ~= b_site then
        return a_site < b_site
      end
      if a.staticData.Quality ~= b.staticData.Quality then
        return a.staticData.Quality > b.staticData.Quality
      end
      local a_slotnum = a.equipInfo:GetCardSlot()
      local b_slotnum = b.equipInfo:GetCardSlot()
      if a_slotnum ~= b_slotnum then
        return a_slotnum > b_slotnum
      end
      if a.staticData.id ~= b.staticData.id then
        return a.staticData.id > b.staticData.id
      end
      local arefinelv = a.equipInfo.refinelv or 0
      local brefinelv = b.equipInfo.refinelv or 0
      if arefinelv ~= brefinelv then
        return arefinelv > brefinelv
      end
      local a_enchantInfo = a.enchantInfo
      local b_enchantInfo = b.enchantInfo
      if a_enchantInfo or b_enchantInfo then
        if a_enchantInfo and b_enchantInfo then
          local a_isgood = a_enchantInfo:HasNewGoodAttri() and 1 or 0
          local b_isgood = b_enchantInfo:HasNewGoodAttri() and 1 or 0
          return a_isgood > b_isgood
        end
        a_enchantInfo = a_enchantInfo and 1 or 0
        b_enchantInfo = b_enchantInfo and 1 or 0
        return a_enchantInfo > b_enchantInfo
      end
      return a.staticData.id > b.staticData.id
    end
    return a.staticData.id > b.staticData.id
  end)
end
