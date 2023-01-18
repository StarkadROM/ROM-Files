EquipInfo = class("EquipInfo")
EquipTypeEnum = {
  Weapon = 1,
  Cloth = 2,
  Shield = 3,
  Cloak = 4,
  Shoes = 5,
  Ring = 6,
  Necklace = 7,
  Accessory = 8,
  Back = 9,
  Mount = 12
}
local forbitFun = {
  Enchant = 1,
  Strength = 2,
  Refine = 4
}
local EquipFeatures = {Dragon = 1, Transformable = 4}
EquipInfo.EquipFeature = EquipFeatures
function EquipInfo.IsMountTransformable(mountId)
  local config = Table_Equip[mountId]
  if config then
    return config.Feature and config.Feature & EquipFeatures.Transformable == EquipFeatures.Transformable
  end
end
function EquipInfo.IsEquipOfFeature(equipId, feature)
  local config = Table_Equip[equipId]
  if config and feature then
    return config.Feature and config.Feature & feature == feature
  end
end
function EquipInfo:ctor(staticData)
  self.equiped = 0
  self.equipData = nil
  self.upgradeData = nil
  self.upgrade_MaxLv = 0
  self.professCanUse = nil
  self:ResetData(staticData)
end
function EquipInfo:ResetData(staticData)
  self.equipData = staticData
  self.upgradeData = staticData and Table_EquipUpgrade[staticData.id]
  if self.upgradeData then
    self.upgrade_MaxLv = 0
    while self:GetUpgradeMaterialsByEquipLv(self.upgrade_MaxLv + 1) ~= nil do
      self.upgrade_MaxLv = self.upgrade_MaxLv + 1
    end
    if self.upgrade_MaxLv ~= 0 and self.upgradeData.Product then
      self.upgrade_MaxLv = self.upgrade_MaxLv - 1
    end
  end
  self:Set()
  self:InitEquipCanUse()
  if Table_Artifact and Table_Artifact[staticData.id] then
    self.artifact_lv = Table_Artifact[staticData.id].Level
  end
end
function EquipInfo:Set(serverData)
  self.strengthlv = serverData and serverData.strengthlv or 0
  self.strengthlv2 = serverData and serverData.strengthlv2 or 0
  self.refinelv = serverData and serverData.refinelv or 0
  self.refineexp = serverData and serverData.refineexp or 0
  self.damage = serverData and serverData.damage or false
  self.equiplv = serverData and serverData.lv or 0
  self.color = serverData and serverData.color
  self.maxCardSlot = nil
  self.cardslot = serverData and serverData.cardslot or 0
  self.breakstarttime = serverData and serverData.breakstarttime
  self.breakendtime = serverData and serverData.breakendtime
  if self.breakstarttime and self.breakendtime then
    self.breakduration = self.breakendtime - self.breakstarttime
  else
    self.breakduration = nil
  end
  if not self.uniqueEffect then
    local eudata = self.equipData.UniqueEffect
    self.uniqueEffect = {}
    if eudata then
      for k, v in pairs(eudata) do
        for vk, vv in pairs(v) do
          if vk ~= "type" then
            self.uniqueEffect = TableUtil.InsertArray(self.uniqueEffect, vv)
          end
        end
      end
    end
    if 0 < #self.uniqueEffect then
      self.activeUniqueEffect = {}
    end
  end
  if not self.pvp_uniqueEffect then
    self.pvp_uniqueEffect = {}
    local epvpudata = self.equipData.PVPUniqueEffect
    if epvpudata and epvpudata ~= _EmptyTable then
      for k, v in pairs(epvpudata) do
        for vk, vv in pairs(v) do
          if vk ~= "type" then
            self.pvp_uniqueEffect = TableUtil.InsertArray(self.pvp_uniqueEffect, vv)
          end
        end
      end
    end
  end
  if self.activeUniqueEffect and serverData and serverData.buffid then
    for i = 1, #serverData.buffid do
      self.activeUniqueEffect[serverData.buffid[i]] = true
    end
  end
  self.randomEffect = self.randomEffect or {}
  TableUtility.TableClear(self.randomEffect)
  if serverData and serverData.attrs then
    local attr
    for i = 1, #serverData.attrs do
      attr = serverData.attrs[i]
      self.randomEffect[attr.id] = attr.value / 1000
    end
  end
end
function EquipInfo:GetReplaceValues()
  if self.equipData then
    return self.equipData.ReplaceValues or 0
  end
  return 0
end
function EquipInfo:GetEffect()
  if self.equipData then
    return next(self.equipData.Effect)
  end
  return nil, nil
end
function EquipInfo:InitEquipCanUse()
  local equpType = GameConfig.EquipType
  if self.equipData ~= nil and self.equipData.EquipType then
    self.site = equpType[self.equipData.EquipType] and equpType[self.equipData.EquipType].site
    self:RefreshUseByProfess(true)
  else
    self.site = {}
  end
end
function EquipInfo:RefreshUseByProfess(ignoreBannedProfs)
  self.professCanUse = self.professCanUse or {}
  TableUtility.TableClear(self.professCanUse)
  for i = 1, #self.equipData.CanEquip do
    self.professCanUse[self.equipData.CanEquip[i]] = self.equipData.CanEquip[i]
  end
  if not ignoreBannedProfs then
    local bannedPros = ProfessionProxy.GetBannedProfessions()
    if bannedPros then
      for p, _ in pairs(self.professCanUse) do
        if TableUtility.ArrayFindIndex(bannedPros, p) > 0 then
          self.professCanUse[p] = nil
        end
      end
    end
  end
end
function EquipInfo:CanUseByProfess(pro)
  self:RefreshUseByProfess()
  return self.professCanUse[0] ~= nil or self.professCanUse[pro] ~= nil
end
function EquipInfo:GetEquipType()
  if self.equipData ~= nil then
    return self.equipData.EquipType
  else
    return nil
  end
end
function EquipInfo:GetEquipSite()
  return self.site
end
function EquipInfo:GetUniqueEffect()
  if not self.activeUniqueEffect then
    return
  end
  local result, eff, temp = {}, nil, nil
  for i = 1, #self.uniqueEffect do
    eff = self.uniqueEffect[i]
    temp = {}
    temp.id = eff
    temp.active = self.activeUniqueEffect[eff]
    table.insert(result, temp)
  end
  return result
end
function EquipInfo:GetPvpUniqueEffect()
  if not self.activeUniqueEffect then
    return
  end
  local result, eff, temp = {}, nil, nil
  for i = 1, #self.pvp_uniqueEffect do
    eff = self.pvp_uniqueEffect[i]
    temp = {}
    temp.id = eff
    temp.active = self.activeUniqueEffect[eff]
    table.insert(result, temp)
  end
  return result
end
function EquipInfo:GetRandomEffectMap()
  if not self.randomEffect or not next(self.randomEffect) then
    return
  end
  return self.randomEffect
end
local randomEffectListSortFunc = function(l, r)
  return l.id < r.id
end
function EquipInfo:GetRandomEffectList()
  local map = self:GetRandomEffectMap()
  if not map then
    return
  end
  local result = {}
  for k, v in pairs(map) do
    table.insert(result, {id = k, value = v})
  end
  table.sort(result, randomEffectListSortFunc)
  return result
end
function EquipInfo:GetRandomEffectById(id)
  local map = self:GetRandomEffectMap()
  if not map then
    return
  end
  return map[id]
end
function EquipInfo:IsWeapon()
  return self.equipData.EquipType == EquipTypeEnum.Weapon
end
function EquipInfo:BasePropStr()
  local effects = {
    {
      effect = self.equipData.Effect,
      name = "normal",
      lv = 1
    }
  }
  return PropUtil.FormatEffectsByProp(effects, false, " +")
end
function EquipInfo:RefineAndStrInfo(refinelv, strengthlv)
  refinelv = refinelv or self.refinelv
  strengthlv = strengthlv or self.strengthlv
  if whole == nil then
    whole = true
  end
  if same == nil then
    same = true
  end
  local effects = {
    {
      effect = self.equipData.Effect,
      name = "normal",
      lv = 1
    },
    {
      effect = self.equipData.EffectAdd,
      name = "str",
      lv = strengthlv
    },
    {
      effect = self.equipData.RefineEffect,
      name = "refine",
      lv = refinelv
    }
  }
  return PropUtil.FormatEffectsByProp(effects, false, " +")
end
function EquipInfo:StrengthInfo(level, whole, valueColorStr)
  level = level or self.strengthlv
  if whole == nil then
    whole = true
  end
  if whole then
    local effects = {
      {
        effect = self.equipData.Effect,
        name = "normal",
        lv = 1
      },
      {
        effect = self.equipData.EffectAdd,
        name = "str",
        lv = level
      }
    }
    return PropUtil.FormatEffectsByProp(effects, true, " +", nil, valueColorStr)
  else
    local effectAdd = self.equipData.EffectAdd
    local effects = {}
    for k, v in pairs(effectAdd) do
      local data = {}
      data.name = k
      data.value = v
      table.insert(effects, data)
    end
    return PropUtil.FormatEffects(effects, level, " +", nil, valueColorStr)
  end
end
function EquipInfo:RefineInfo(level, whole, same, sperator)
  level = level or self.refinelv
  sperator = sperator or " +"
  if whole == nil then
    whole = false
  end
  if same == nil then
    same = true
  end
  if whole then
    local effects = {
      {
        effect = self.equipData.Effect,
        name = "normal",
        lv = 1
      },
      {
        effect = self.equipData.RefineEffect,
        name = "refine",
        lv = level
      }
    }
    return PropUtil.FormatEffectsByProp(effects, same, sperator)
  else
    local effectAdd = self.equipData.RefineEffect
    local effects = {}
    for k, v in pairs(effectAdd) do
      local data = {}
      data.name = k
      data.value = v
      table.insert(effects, data)
    end
    return PropUtil.FormatEffects(effects, level, sperator)
  end
end
function EquipInfo:SetRefine(refinelv)
  self.refinelv = refinelv
end
function EquipInfo:SetEquipStrengthLv(lv)
  self.strengthlv = lv
end
function EquipInfo:SetEquipGuildStrengthLv(lv)
  self.strengthlv2 = lv
end
function EquipInfo:GetUpgradeMaterialsByEquipLv(equiplv)
  if nil == self.upgradeData then
    return nil
  end
  equiplv = equiplv or self.equiplv
  local materialsKey = "Material_" .. tostring(equiplv)
  local materials = self.upgradeData[materialsKey]
  if materials and #materials > 0 then
    return materials
  end
  return nil
end
function EquipInfo:CanUpgrade()
  if self.upgradeData ~= nil then
    return self:GetUpgradeMaterialsByEquipLv(self.equiplv + 1) ~= nil
  end
  return false
end
function EquipInfo:CanUpgrade_ByClassDepth(classdepth, equiplv)
  if not self.upgradeData then
    return false
  end
  local classDepthLimit_2 = self.upgradeData.ClassDepthLimit_2
  if classDepthLimit_2 and classdepth < 2 and equiplv >= classDepthLimit_2 then
    return false, 2
  end
  return true
end
function EquipInfo:CanUpgradeInfoBeEffect_ByClassDepth(classdepth, equiplv)
  if not self.upgradeData then
    return false
  end
  local classDepthLimit_2 = self.upgradeData.ClassDepthLimit_2
  if classDepthLimit_2 and classdepth < 2 and equiplv and equiplv >= classDepthLimit_2 then
    return false, 2
  end
  return true
end
function EquipInfo:GetUpgradeBuffIdByEquipLv(equiplv)
  if nil == self.upgradeData then
    return nil
  end
  equiplv = equiplv or self.equiplv
  local buffKey = "BuffID_" .. tostring(equiplv)
  return self.upgradeData[buffKey]
end
function EquipInfo:CanStrength()
  return self:CanStrength_ByStaticData()
end
function EquipInfo:CanStrength_ByStaticData()
  if self.equipData.ForbidFuncBit ~= nil and self.equipData.ForbidFuncBit & forbitFun.Strength > 0 then
    return false
  end
  if self.equipData and self.equipData.EquipType then
    local config = GameConfig.EquipType[self.equipData.EquipType]
    local sites = config and config.site
    if type(sites) ~= "table" or not sites then
      sites = {}
    end
    return type(sites[1]) == "number" and sites[1] ~= 0
  end
  return false
end
function EquipInfo:CanRefine()
  return self:CanRefine_ByStaticData()
end
function EquipInfo:CanRefine_ByStaticData()
  if self.equipData.EquipType == 12 then
    return false
  end
  if self.equipData.ForbidFuncBit == nil then
    return true
  end
  return self.equipData.ForbidFuncBit & forbitFun.Refine <= 0
end
function EquipInfo:CanEnchant()
  if GameConfig.SystemForbid.FashionEquipEnchant then
    return false
  end
  return self:CanEnchant_ByStaticData()
end
function EquipInfo:CanEnchant_ByStaticData()
  if self.equipData.ForbidFuncBit == nil then
    return true
  end
  return self.equipData.ForbidFuncBit & forbitFun.Enchant <= 0
end
function EquipInfo:Clone(other)
  self:Set(other)
  self.equiplv = other.equiplv
  self.site = other.site
  if other.randomEffect then
    self.randomEffect = {}
    for k, v in pairs(other.randomEffect) do
      self.randomEffect[k] = v
    end
  end
end
function EquipInfo:SetUpgradeCheckDirty()
  self.upgrade_checkdirty = true
end
function EquipInfo.GetEquipCheckTypes()
  local pacakgeCheck = GameConfig.PackageMaterialCheck
  local upgradeCheckTypes
  if pacakgeCheck then
    upgradeCheckTypes = pacakgeCheck.upgrade or pacakgeCheck.default
  else
    upgradeCheckTypes = {1, 9}
  end
  return upgradeCheckTypes
end
function EquipInfo:CheckCanUpgradeSuccess(isMyEquip, item_guid)
  if self.upgradeData == nil then
    return false
  end
  if not self:CanUpgrade() then
    return false
  end
  if self.upgrade_checkdirty == false then
    return self.canUpgrade_success
  end
  self.upgrade_checkdirty = false
  self.canUpgrade_success = false
  local equiplv = self.equiplv
  if isMyEquip then
    local myClass = Game.Myself.data.userdata:Get(UDEnum.PROFESSION)
    local classDepth = ProfessionProxy.Instance:GetDepthByClassId(myClass)
    if not self:CanUpgrade_ByClassDepth(classDepth, equiplv + 1) then
      return false
    end
  end
  local materialsKey = "Material_" .. equiplv + 1
  local cost = self.upgradeData[materialsKey]
  local _BlackSmithProxy, _BagProxy, searchItems = BlackSmithProxy.Instance, BagProxy.Instance, nil
  for i = 1, #cost do
    local sc = cost[i]
    local searchNum = 0
    if sc.id ~= 100 then
      if ItemData.CheckIsEquip(sc.id) then
        searchItems = _BlackSmithProxy:GetMaterialEquips_ByEquipId(sc.id, nil, true, nil, self:GetEquipCheckTypes(), function(param, itemData)
          if itemData.equipInfo ~= self then
            searchNum = searchNum + itemData.num
          end
        end)
      else
        searchItems = _BagProxy:GetMaterialItems_ByItemId(sc.id, self.GetEquipCheckTypes())
        for j = 1, #searchItems do
          if _BagProxy:CheckIfFavoriteCanBeMaterial(searchItems[i]) ~= false then
            searchNum = searchNum + searchItems[j].num
          end
        end
      end
    else
      searchNum = Game.Myself.data.userdata:Get(UDEnum.SILVER)
    end
    if searchNum < sc.num then
      self.canUpgrade_success = false
      return false
    else
    end
  end
  self.canUpgrade_success = true
  return true
end
function EquipInfo:IsMount()
  return self.equipData.EquipType == EquipTypeEnum.Mount
end
function EquipInfo:IsArtifact()
  local etype = self.equipData.EquipType
  local cfg = GameConfig.EquipType[etype]
  if cfg == nil then
    return false
  end
  return cfg.equipBodyIndex == "Artifact"
end
function EquipInfo:IsRelics()
  local etype = self.equipData.EquipType
  local cfg = GameConfig.EquipType[etype]
  if cfg == nil then
    return false
  end
  return cfg.equipBodyIndex == "PersonalArtifact"
end
function EquipInfo:GetMyGroupFashionEquip()
  local equipSData = self.equipData
  if equipSData.id ~= equipSData.GroupID then
    return
  end
  local sDatas = AdventureDataProxy.Instance:GetFashionGroupEquipsByGroupId(equipSData.GroupID)
  local mySex = MyselfProxy.Instance:GetMySex()
  local d = sDatas[1]
  for i = 1, #sDatas do
    if sDatas[i].SexEquip == mySex then
      d = sDatas[i]
      break
    end
  end
  return d
end
function EquipInfo:IsMyDisplayForbid()
  if not Game.Myself.data:IsHuman() then
    return self.equipData.DisplayForbid and self.equipData.DisplayForbid > 0
  end
  return false
end
function EquipInfo:HasFeature(f)
  local feature = self.equipData.Feature
  return feature ~= nil and feature & f == f
end
function EquipInfo:IsBarrow()
  return self.equipData.Type == "Barrow"
end
function EquipInfo:IsNextGen()
  return self.equipData.IsNew ~= nil and self.equipData.IsNew > 0
end
function EquipInfo:GetCardSlot()
  if self.equipData.CardSlot and self.equipData.CardSlot > 0 then
    return self.equipData.CardSlot
  end
  return self.cardslot
end
