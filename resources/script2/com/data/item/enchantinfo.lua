EnchantAttri = class("EnchantAttri")
EnchantAttriQuality = {
  Good = "EnchantAttriQuality_Good",
  Normal = "EnchantAttriQuality_Normal",
  Bad = "EnchantAttriQuality_Bad"
}
function EnchantAttri:ctor(enchantType, attri, itemId)
  self.itemId = itemId
  self.itemType = Table_Item[itemId].Type
  self.enchantType = enchantType
  self.type = attri.type
  local attriValue = attri.serverValue or attri.value
  self.serverValue = attriValue
  self.propVO = EnchantEquipUtil.Instance:GetAttriPropVO(attri.type)
  self.value = self.propVO.isPercent and attriValue / 10 or attriValue
  self.name = self.propVO and self.propVO.displayName
  self.typekey = self.propVO.name
  local enchantData = EnchantEquipUtil.Instance:GetEnchantData(self.enchantType, self.typekey, self.itemType)
  if not enchantData then
    redlog(string.format("(%s %s) not Find EnchantData", self.typekey, self.propVO.displayName))
    return
  end
  self.staticData = enchantData
  local attriBound = self.staticData.AttrBound[1]
  if self.propVO.isPercent then
    self.isMax = self.value >= attriBound[2] * 100
  else
    self.isMax = self.value >= attriBound[2]
  end
  self.Quality = EnchantAttriQuality.Normal
  if self.staticData.ExpressionOfMaxUp then
    local maxJudge = self.staticData.ExpressionOfMaxUp * attriBound[2]
    if self.propVO.isPercent then
      maxJudge = maxJudge * 100
    end
    if self:IsValuable() and maxJudge <= self.value then
      self.Quality = EnchantAttriQuality.Good
    end
  end
  if self.staticData.ExpressionOfMaxDown then
    local minJudge = self.staticData.ExpressionOfMaxDown * attriBound[2]
    if self.propVO.isPercent then
      minJudge = minJudge * 100
    end
    if minJudge >= self.value then
      self.Quality = EnchantAttriQuality.Bad
    end
  end
end
function EnchantAttri:IsValuable()
  local compareValue = GameConfig.Exchange.GoodRate or 1.3
  local value = EnchantEquipUtil.Instance:GetPriceRate(self.typekey, self.itemType)
  return compareValue <= value
end
EnchantInfo = class("EnchantInfo")
EnchantType = {
  Primary = SceneItem_pb.EENCHANTTYPE_PRIMARY,
  Medium = SceneItem_pb.EENCHANTTYPE_MEDIUM,
  Senior = SceneItem_pb.EENCHANTTYPE_SENIOR
}
function EnchantInfo:ctor(itemId)
  self.itemId = itemId
  self.enchantAttrs = {}
  self.combineEffectlist = {}
  self.cacheEnchantAttrs = {}
  self.cacheCombineEffectlist = {}
end
function EnchantInfo:SetMyServerData(serverData)
  self.enchantType = serverData.type
  return EnchantInfo.SetServerData(serverData, self.enchantAttrs, self.combineEffectlist, self.itemId)
end
function EnchantInfo:SetMyCacheServerData(serverData)
  self.cacheEnchantType = serverData.type
  return EnchantInfo.SetServerData(serverData, self.cacheEnchantAttrs, self.cacheCombineEffectlist, self.itemId)
end
function EnchantInfo:SetMyServerAttri(enchantType, attri)
  return EnchantInfo.SetServerAttri(enchantType, attri, self.itemId)
end
function EnchantInfo:Clone()
  local retInfo = EnchantInfo.new(self.itemId)
  retInfo.enchantType = self.enchantType
  for i = 1, #self.enchantAttrs do
    retInfo.enchantAttrs[i] = EnchantInfo.SetServerAttri(self.enchantAttrs[i].enchantType, self.enchantAttrs[i], self.itemId)
  end
  for i = 1, #self.combineEffectlist do
    retInfo.combineEffectlist[i] = EnchantInfo.SetCombineEffect(self.combineEffectlist[i].buffid, self.combineEffectlist[i].configid)
  end
  return retInfo
end
function EnchantInfo.SetCombineEffect(buffid, configid)
  if buffid then
    local cbeData = {}
    cbeData.buffid = buffid
    cbeData.configid = configid
    cbeData.buffData = Table_Buffer[buffid]
    if not cbeData.buffData then
      redlog(string.format("Not Have Buff(%s)", tostring(buffid)))
      return nil
    end
    cbeData.isWork = false
    cbeData.Condition = {}
    local sdata = EnchantEquipUtil.Instance:GetCombineEffect(configid)
    if sdata then
      cbeData.Condition = sdata.Condition
      if sdata.Condition.type == 1 then
        cbeData.WorkTip = string.format(ZhString.EnchantInfo_RefineCondition, sdata.Condition.refinelv)
      end
    end
    cbeData.enchantData = sdata
    return cbeData
  end
end
function EnchantInfo:UpdateCombineEffectWork(refinelv)
  for i = 1, #self.combineEffectlist do
    EnchantInfo._UpdateCombineEffectWork(self.combineEffectlist[i], refinelv)
  end
  for i = 1, #self.cacheCombineEffectlist do
    EnchantInfo._UpdateCombineEffectWork(self.cacheCombineEffectlist[i], refinelv)
  end
end
function EnchantInfo._UpdateCombineEffectWork(combineEffect, refinelv)
  if combineEffect and combineEffect.Condition and combineEffect.Condition.type == 1 then
    combineEffect.isWork = EnchantInfo.CombineEffectWorkPredicate(combineEffect, refinelv)
  end
end
function EnchantInfo.CombineEffectWorkPredicate(combineEffect, refinelv)
  return refinelv >= combineEffect.Condition.refinelv
end
function EnchantInfo:GetEnchantAttrs()
  return self.enchantAttrs
end
function EnchantInfo:GetCombineEffects()
  return self.combineEffectlist
end
function EnchantInfo:GetCacheEnchantAttrs()
  return self.cacheEnchantAttrs
end
function EnchantInfo:GetCacheCombineEffects()
  return self.cacheCombineEffectlist
end
function EnchantInfo:HasAttri()
  return #self.enchantAttrs > 0
end
function EnchantInfo:HasUnSaveAttri()
  return #self.cacheEnchantAttrs > 0
end
function EnchantInfo:HasNewGoodAttri()
  local hasGood = false
  for i = 1, #self.cacheEnchantAttrs do
    local attir = self.cacheEnchantAttrs[i]
    if attir.Quality == EnchantAttriQuality.Good then
      hasGood = true
      break
    end
  end
  hasGood = hasGood or #self.cacheCombineEffectlist > 0
  return hasGood
end
local TradeBanBuffIdMap = {
  500061,
  500062,
  500063,
  500064,
  500001,
  500002,
  500003,
  500004
}
function EnchantInfo:IsShowWhenTrade()
  local itemType = Table_Item[self.itemId].Type
  local rateKey = GameConfig.NewClassEquip.EnchantEquipTypeRateMap[itemType]
  if rateKey and #self.combineEffectlist > 0 then
    for i = 1, #self.combineEffectlist do
      local combineEffect = self.combineEffectlist[i]
      if combineEffect.enchantData.NoExchangeEnchant[rateKey] == 1 then
        return false
      end
      local buffid = combineEffect.buffid
      if buffid and TradeBanBuffIdMap[buffid] == 1 then
        return false
      end
    end
    return true
  end
  return false
end
function EnchantInfo.SetServerAttri(enchantType, attri, itemId)
  return EnchantAttri.new(enchantType, attri, itemId)
end
function EnchantInfo.SetServerData(serverData, enchantAttrList, combineEffectList, itemId)
  if not serverData or not enchantAttrList or not combineEffectList then
    return
  end
  TableUtility.ArrayClear(enchantAttrList)
  TableUtility.ArrayClear(combineEffectList)
  local attrs = serverData.attrs
  if attrs then
    for i = 1, #attrs do
      table.insert(enchantAttrList, EnchantInfo.SetServerAttri(serverData.type, attrs[i], itemId))
    end
    local ebuffids = serverData.extras
    if ebuffids then
      local ebuff, cbeData
      for i = 1, #ebuffids do
        ebuff = ebuffids[i]
        cbeData = EnchantInfo.SetCombineEffect(ebuff.buffid, ebuff.configid, enchantAttrList)
        if cbeData then
          table.insert(combineEffectList, cbeData)
        end
      end
    end
  end
end
