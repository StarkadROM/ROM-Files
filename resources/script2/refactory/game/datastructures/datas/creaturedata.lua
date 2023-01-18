autoImport("BehaviourData")
autoImport("AttrEffect")
CreatureData = class("CreatureData", ReusableObject)
CreatureData.MoveSpeedFactor = 3.5
CreatureData.RotateSpeedFactor = 720
CreatureData.ScaleSpeedFactor = 1
CreatureData.ShapeIndex = {
  [1] = "S",
  [2] = "M",
  [3] = "L"
}
local CompatibilityMode_V9 = BackwardCompatibilityUtil.CompatibilityMode_V9
local CullingIDUtility = CullingIDUtility
local ArrayRemove = TableUtility.ArrayRemove
local DestroyArray = ReusableTable.DestroyArray
local MaxStateEffect = 0
for k, v in pairs(CommonFun.StateEffect) do
  if v > MaxStateEffect then
    MaxStateEffect = v
  end
end
local ExtraAttackSkill = {}
for k, v in pairs(GameConfig.NormalSerialSkills.skills) do
  for i = 1, #v do
    ExtraAttackSkill[v[i]] = 1
  end
end
function CreatureData:ctor()
  CreatureData.super.ctor(self)
  self.id = nil
  self:SetCamp(RoleDefines_Camp.NEUTRAL)
  self.bodyScale = nil
  self.KickSkills = 0
end
function CreatureData:GetHoldScale()
  return 1
end
function CreatureData:GetHoldDir()
  return 0
end
local defaultOffest = {}
function CreatureData:GetHoldOffset()
  return defaultOffest
end
function CreatureData:GetDefaultGear()
  return nil
end
function CreatureData:GetName()
  return nil
end
function CreatureData:SetCamp(camp)
  self.camp = camp
end
function CreatureData:GetCamp()
  return self.camp
end
function CreatureData:NoAccessable()
  return true
end
function CreatureData:NoPlayIdle()
  return false
end
function CreatureData:NoPlayShow()
  return false
end
function CreatureData:NoAutoAttack()
  return false
end
function CreatureData:GetGuid()
  return self.id
end
function CreatureData:GetFollowEP()
  return 0
end
function CreatureData:GetFollowType()
  return 0
end
function CreatureData:GetInnerRange()
  return 0
end
function CreatureData:GetOutterRange()
  return 0
end
function CreatureData:GetOutterHeight()
  return 0
end
function CreatureData:GetDampDuration()
  return 0
end
function CreatureData:ReturnMoveSpeedWithFactor(moveSpeed)
  return (moveSpeed or 1) * CreatureData.MoveSpeedFactor
end
function CreatureData:ReturnRotateSpeedWithFactor(rotateSpeed)
  return (rotateSpeed or 1) * CreatureData.RotateSpeedFactor
end
function CreatureData:ReturnScaleSpeedWithFactor(scaleSpeed)
  return (scaleSpeed or 1) * CreatureData.ScaleSpeedFactor
end
function CreatureData:GetClickPriority()
  local camp = self:GetCamp()
  if camp == RoleDefines_Camp.ENEMY then
    return 0
  elseif camp == RoleDefines_Camp.NEUTRAL then
    return 1
  elseif camp == RoleDefines_Camp.FRIEND then
    return 2
  end
  return 0
end
function CreatureData:SetDressEnable(v)
  self.dressEnable = v
end
function CreatureData:IsDressEnable()
  return self.dressEnable
end
function CreatureData:SetBaseLv(value)
  self.BaseLv = value
end
function CreatureData:AddPetID(petID)
  if self.petIDs == nil then
    self.petIDs = ReusableTable.CreateArray()
  end
  if TableUtility.ArrayFindIndex(self.petIDs, petID) < 1 then
    self.petIDs[#self.petIDs + 1] = petID
  end
end
function CreatureData:RemovePetID(petID)
  if self.petIDs ~= nil then
    TableUtility.ArrayRemove(self.petIDs, petID)
  end
end
function CreatureData:GetPetCount(type)
  if self.petIDs == nil then
    return 0
  end
  local count = 0
  local _NScenePetProxy = NScenePetProxy.Instance
  for i = 1, #self.petIDs do
    local pet = _NScenePetProxy:Find(self.petIDs[i])
    if pet ~= nil and pet.data:GetDetailedType() == type then
      count = count + 1
    end
  end
  return count
end
function CreatureData:SpawnCullingID()
  self.cullingID = self.id
end
function CreatureData:ClearCullingID()
  self.cullingID = nil
end
function CreatureData:GetDefaultScale()
  return 1
end
function CreatureData:GetClassID()
  return 0
end
function CreatureData:IsOb()
  return false
end
function CreatureData:IsBeingPresent(beingID)
  local being = PetProxy.Instance:GetMyBeingNpcInfo(beingID)
  if being then
    return being:IsSummoned()
  end
  return false
end
function CreatureData:InGuildZone()
  return false
end
function CreatureData:InGvgZone()
  return false
end
function CreatureData:NoAttackMetal()
  return false
end
function CreatureData:GetFeature(bit)
  return false
end
function CreatureData:GetFeature_ChangeLinePunish()
  return false
end
function CreatureData:GetFeature_BeHold()
  return false
end
function CreatureData:DoConstruct(asArray, parts)
  self.dressEnable = false
end
function CreatureData:DoDeconstruct(asArray)
  if self.petIDs ~= nil then
    ReusableTable.DestroyArray(self.petIDs)
    self.petIDs = nil
  end
  self:ClearCullingID()
end
CreatureDataWithPropUserdata = class("CreatureDataWithPropUserdata", CreatureData)
function CreatureDataWithPropUserdata:ctor()
  CreatureDataWithPropUserdata.super.ctor(self)
  self.props = RolePropsContainer.CreateAsTable()
  self.clientProps = ClientProps.new(self.props.config)
  self.userdata = UserData.CreateAsTable()
  self.attrEffect = AttrEffect.new()
  self.attrEffect2 = AttrEffectB.new()
  self.attrEffect3 = AttrEffectC.new()
  self:Reset()
end
function CreatureDataWithPropUserdata:Reset()
  self.idleAction = nil
  self.moveAction = nil
  self.normalAtkID = nil
  self.noStiff = 0
  self.noAttack = 0
  self.noSkill = 0
  self.noPicked = 0
  self.noAccessable = 0
  self.noMove = 0
  self.noAction = 0
  self.noAttacked = 0
  self.noRelive = 0
  self.noMoveAction = 0
  self.shape = nil
  self.race = nil
  self.bodyScale = nil
  self.buffhp = nil
  self.buffmaxhp = nil
end
function CreatureDataWithPropUserdata:GetProperty(name)
  local prop = self.props:GetPropByName(name)
  if nil == prop then
    return 0
  end
  return prop:GetValue()
end
function CreatureDataWithPropUserdata:GetJobLv()
  if nil ~= self.userdata then
    return self.userdata:Get(UDEnum.JOBLEVEL)
  end
  return 1
end
function CreatureDataWithPropUserdata:GetBaseLv()
  if nil ~= self.userdata then
    return self.userdata:Get(UDEnum.ROLELEVEL)
  end
  return 1
end
function CreatureDataWithPropUserdata:GetLernedSkillLevel(skillID)
  return 0
end
function CreatureDataWithPropUserdata:GetDynamicSkillInfo(skillID)
  return nil
end
function CreatureDataWithPropUserdata:GetSkillExtraCD()
  return 0
end
function CreatureDataWithPropUserdata:GetSkillOptByOption(opt)
  return 0
end
function CreatureDataWithPropUserdata:IsEnemy(creatureData)
  return creatureData:GetCamp() == RoleDefines_Camp.ENEMY
end
function CreatureDataWithPropUserdata:IsImmuneSkill(skillID)
  return false
end
function CreatureDataWithPropUserdata:IgnoreJinzhanDamage()
  return nil ~= self.attrEffect and self.attrEffect:IgnoreJinzhanDamage()
end
function CreatureDataWithPropUserdata:IsFly()
  return false
end
function CreatureDataWithPropUserdata:SelfBuffChangeSkill(skillIDAndLevel_0)
  if nil == self.skillBuffs then
    return nil
  end
  local buff = self.skillBuffs:GetOwner(BuffConfig.SelfBuff)
  if nil == buff then
    return nil
  end
  return buff:GetParamsByType(BuffConfig.changeskill)[skillIDAndLevel_0]
end
function CreatureDataWithPropUserdata:GetProfressionID()
  return nil ~= self.userdata and self.userdata:Get(UDEnum.PROFESSION) or 0
end
function CreatureDataWithPropUserdata:DefiniteHitAndCritical()
  return nil ~= self.attrEffect and self.attrEffect:DefiniteHitAndCritical()
end
function CreatureDataWithPropUserdata:NextPointTargetSkillLargeLaunchRange()
  return nil ~= self.attrEffect2 and self.attrEffect2:NextPointTargetSkillLargeLaunchRange()
end
function CreatureDataWithPropUserdata:NextSkillNoReady()
  return nil ~= self.attrEffect2 and self.attrEffect2:NextSkillNoReady()
end
function CreatureDataWithPropUserdata:CanNotBeSkillTargetByEnemy()
  return nil ~= self.attrEffect2 and self.attrEffect2:CanNotBeSkillTargetByEnemy()
end
function CreatureDataWithPropUserdata:IsInMagicMachine()
  return nil ~= self.attrEffect2 and self.attrEffect2:IsInMagicMachine()
end
function CreatureDataWithPropUserdata:IsOnWolf()
  return nil ~= self.attrEffect2 and self.attrEffect2:IsOnWolf()
end
function CreatureDataWithPropUserdata:IsHideCancelTransformBtn()
  return self.attrEffect2 ~= nil and self.attrEffect2:IsHideCancelTransformBtn()
end
function CreatureDataWithPropUserdata:IsEatBeing()
  return self.attrEffect2 ~= nil and self.attrEffect2:IsEatBeing()
end
function CreatureDataWithPropUserdata:HideMyself()
  return nil ~= self.attrEffect3 and self.attrEffect3:HideMyself()
end
function CreatureDataWithPropUserdata:GetAttackSkillIDAndLevel()
  return self.normalAtkID or 0
end
function CreatureDataWithPropUserdata:IsAttackSkill(id)
  return self.normalAtkID == id or ExtraAttackSkill[id] == 1 or self:IsTriggerKickSkill(id) == true
end
function CreatureDataWithPropUserdata:DamageAlways1()
  return false
end
function CreatureDataWithPropUserdata:GetRandom()
  return nil
end
function CreatureDataWithPropUserdata:RemoveInvalidHatred()
end
function CreatureDataWithPropUserdata:RefreshHatred(id)
end
function CreatureDataWithPropUserdata:CheckHatred(id, time)
  return false
end
function CreatureDataWithPropUserdata:GetArrowID()
  return 0
end
function CreatureDataWithPropUserdata:GetEquipedRefineLv(site)
  return 0
end
function CreatureDataWithPropUserdata:GetEquipedStrengthLv(site)
  return 0
end
function CreatureDataWithPropUserdata:GetEquipedItemNum(itemid)
  return 0
end
function CreatureDataWithPropUserdata:GetEquipedWeaponType()
  return 0
end
function CreatureDataWithPropUserdata:GetEquipedType(site)
  return 0
end
function CreatureDataWithPropUserdata:GetEquipedID(site)
  return 0
end
function CreatureDataWithPropUserdata:getEquipLv()
  return 0
end
function CreatureDataWithPropUserdata:GetCartNums()
  return 0, 0
end
function CreatureDataWithPropUserdata:GetPackageItemNum(itemid)
  return 0
end
function CreatureDataWithPropUserdata:GetEnchantAttrsBySite(site)
  return nil
end
function CreatureDataWithPropUserdata:GetCombineEffectsBySite(site)
  return nil
end
function CreatureDataWithPropUserdata:GetCurrentSkill()
  return self.currentSkill
end
function CreatureDataWithPropUserdata:SetCurrentSkill(skillLogic)
  self.currentSkill = skillLogic
end
function CreatureDataWithPropUserdata:ClearCurrentSkill(skillLogic)
  if self.currentSkill == skillLogic then
    self.currentSkill = nil
  end
end
function CreatureDataWithPropUserdata:GetAccessRange()
  return 2
end
function CreatureDataWithPropUserdata:SetAttackSpeed(s)
  self.attackSpeed = s
  self.attackSpeedAdjusted = 1 / (1 / s + 0.1) * 1.05
end
function CreatureDataWithPropUserdata:GetAttackSpeed()
  return self.attackSpeed
end
function CreatureDataWithPropUserdata:GetAttackSpeed_Adjusted()
  return self.attackSpeedAdjusted
end
function CreatureDataWithPropUserdata:GetAttackInterval()
  local attackSpeed = self:GetAttackSpeed_Adjusted() or 1
  return 1 / attackSpeed
end
function CreatureDataWithPropUserdata:NoStiff()
  return 0 < self.noStiff
end
function CreatureDataWithPropUserdata:NoAttack()
  return 0 < self.noAttack
end
function CreatureDataWithPropUserdata:NoSkill()
  return 0 < self.noSkill
end
function CreatureDataWithPropUserdata:NoMagicSkill()
  return self.props:GetPropByName("NoMagicSkill"):GetValue() > 0
end
function CreatureDataWithPropUserdata:NoHitEffectMove()
  return self.props:GetPropByName("NoEffectMove"):GetValue() & 1 > 0
end
function CreatureDataWithPropUserdata:NoAttackEffectMove()
  return self.props:GetPropByName("NoEffectMove"):GetValue() & 2 > 0
end
function CreatureDataWithPropUserdata:NoPicked()
  return 0 < self.noPicked
end
function CreatureDataWithPropUserdata:NoAccessable()
  if self.forceSelect then
    return false
  end
  return 0 < self.noAccessable or 0 < self.noPicked
end
function CreatureDataWithPropUserdata:NoMove()
  return 0 < self.noMove
end
function CreatureDataWithPropUserdata:NoAttacked()
  return 0 < self.noAttacked
end
function CreatureDataWithPropUserdata:NoRelive()
  return 0 < self.noRelive
end
function CreatureDataWithPropUserdata:NoAction()
  return 0 < self.noAction
end
function CreatureDataWithPropUserdata:NoMoveAction()
  return self.noMoveAction > 0
end
function CreatureDataWithPropUserdata:NoAct()
  return 0 < self.props:GetPropByName("NoAct"):GetValue()
end
function CreatureDataWithPropUserdata:Freeze()
  if self:WeakFreeze() then
    return true
  end
  return 0 < self.props:GetPropByName("Freeze"):GetValue()
end
function CreatureDataWithPropUserdata:WeakFreeze()
  if self.weakFreezeBuffs and self.weakFreezeBuffs.count > 0 then
    return true
  end
  return false
end
function CreatureDataWithPropUserdata:FearRun()
  return 0 < self.props:GetPropByName("FearRun"):GetValue()
end
function CreatureDataWithPropUserdata:FreeCast()
  return self.props:GetPropByName("MoveChant"):GetValue() > 0
end
function CreatureDataWithPropUserdata:PlusClientProp(prop)
  return prop:GetValue() + self.clientProps:GetValueByName(prop.propVO.name)
end
function CreatureDataWithPropUserdata:IsTransformed()
  local prop = self.props:GetPropByName("TransformID"):GetValue()
  return prop ~= 0
end
function CreatureDataWithPropUserdata:IsSolo()
  return self.props:GetPropByName("Solo"):GetValue() > 0
end
function CreatureDataWithPropUserdata:IsEnsemble()
  return self.props:GetPropByName("Ensemble"):GetValue() > 0
end
function CreatureDataWithPropUserdata:NoNormalAttack()
  return self.props:GetPropByName("NoNormalAttack"):GetValue() > 0
end
function CreatureDataWithPropUserdata:GetNpcID()
  return 0
end
function CreatureDataWithPropUserdata:GetClassID()
  if self.userdata then
    return self.userdata:Get(UDEnum.PROFESSION) or 0
  end
  return 0
end
function CreatureDataWithPropUserdata:HasBuffID(buffID)
  if self.buffIDs == nil then
    return false
  end
  return self.buffIDs[buffID] ~= nil
end
function CreatureDataWithPropUserdata:GetEquipCardNum(site, cardID)
  return 0
end
function CreatureDataWithPropUserdata:GetRunePoint(specialEffectID)
  return 0
end
function CreatureDataWithPropUserdata:GetActiveAstrolabePoints()
  return 0
end
function CreatureDataWithPropUserdata:GetAdventureSavedHeadWear(quality)
  return 0
end
function CreatureDataWithPropUserdata:GetAdventureSavedCard(quality)
  return 0
end
function CreatureDataWithPropUserdata:GetAdventureTitle()
  return 0
end
function CreatureDataWithPropUserdata:GetBuffListByType(typeParam)
  if typeParam == nil or self.buffIDs == nil then
    return nil
  end
  local buff, result
  local configs = Table_Buffer
  for k, v in pairs(self.buffIDs) do
    buff = configs[k]
    if buff ~= nil and buff.BuffEffect ~= nil and buff.BuffEffect.type == typeParam then
      result = result or {}
      result[#result + 1] = k
    end
  end
  return result
end
function CreatureDataWithPropUserdata:GetBuffActiveListByType(typeParam)
  if typeParam == nil or self.buffIDActives == nil then
    return nil
  end
  local buff, result
  local configs = Table_Buffer
  for k, v in pairs(self.buffIDActives) do
    buff = configs[k]
    if v and buff ~= nil and buff.BuffEffect ~= nil and buff.BuffEffect.type == typeParam then
      result = result or {}
      result[#result + 1] = k
    end
  end
  return result
end
function CreatureDataWithPropUserdata:GetBuffEffectByType(typeParam)
  if typeParam == nil or self.buffIDs == nil then
    return nil
  end
  local buff
  local configs = Table_Buffer
  for k, v in pairs(self.buffIDs) do
    buff = configs[k]
    if buff ~= nil and buff.BuffEffect ~= nil and buff.BuffEffect.type == typeParam then
      return buff.BuffEffect
    end
  end
  return nil
end
function CreatureDataWithPropUserdata:GetBuffFromID(buffID)
  return self:_GetBuffRelate(self.buffIDs, buffID, 0)
end
function CreatureDataWithPropUserdata:GetBuffLayer(buffID)
  return self:_GetBuffRelate(self.buffIDLayers, buffID, 0)
end
function CreatureDataWithPropUserdata:GetBuffLevel(buffID)
  return self:_GetBuffRelate(self.buffIDLevels, buffID, 0)
end
function CreatureDataWithPropUserdata:GetBuffActive(buffID)
  if self.buffIDActives == nil then
    return false
  end
  local active = self.buffIDActives[buffID]
  if active == nil then
    return false
  end
  return active
end
function CreatureDataWithPropUserdata:_GetBuffRelate(t, buffID, defaultValue)
  if t == nil then
    return defaultValue or 0
  end
  return t[buffID] or defaultValue
end
function CreatureDataWithPropUserdata:GetDistance(buffFromGuid)
  local proxy = SceneCreatureProxy
  local me = proxy.FindCreature(self.id)
  if me then
    local fromCreature = proxy.FindCreature(buffFromGuid)
    if fromCreature then
      return VectorUtility.DistanceXZ(me:GetPosition(), fromCreature:GetPosition())
    end
  end
  return 999999
end
function CreatureDataWithPropUserdata:GetRangeEnemy(range)
  return 0
end
function CreatureDataWithPropUserdata:GetMapInfo()
  return 0, 0
end
function CreatureDataWithPropUserdata:GetHighHpBeingGUID()
  return 0
end
function CreatureDataWithPropUserdata:IsRide(id)
  if self.userdata ~= nil then
    return self.userdata:Get(UDEnum.MOUNT) == id
  end
  return false
end
function CreatureDataWithPropUserdata:IsPartner(id)
  local me = SceneCreatureProxy.FindCreature(self.id)
  if me ~= nil then
    return me:GetPartnerID() == id
  end
  return false
end
function CreatureDataWithPropUserdata:getCurElementElfID()
  return 0
end
function CreatureDataWithPropUserdata:GetEnsemblePartner()
  return nil
end
function CreatureDataWithPropUserdata:GetGemValue(paramId)
  return 0
end
function CreatureDataWithPropUserdata:GetSpotter(id)
  local dynamicInfo = self:GetDynamicSkillInfo(id)
  if dynamicInfo ~= nil then
    return dynamicInfo:GetSpotter()
  end
  return 0
end
function CreatureDataWithPropUserdata:GetTypeBranchNumInTeam(branchs)
  return 0
end
function CreatureDataWithPropUserdata:GetCatNumInTeam()
  return 0
end
function CreatureDataWithPropUserdata:HasEquipFeature(feature)
  return false
end
function CreatureDataWithPropUserdata:GetMasterUser()
  return nil
end
function CreatureDataWithPropUserdata:GetTempSkillSlaveID()
  return 0
end
function CreatureDataWithPropUserdata:GetStatusNum()
  local stateEffect = self.props:GetPropByName("StateEffect"):GetValue()
  if stateEffect ~= 0 then
    local count = 0
    for i = 0, MaxStateEffect do
      if stateEffect >> i & 1 ~= 0 then
        count = count + 1
      end
    end
    return count
  end
  return 0
end
function CreatureDataWithPropUserdata:GetChantBeDamage()
  return 0
end
function CreatureDataWithPropUserdata:InMoveStatus()
  local me = SceneCreatureProxy.FindCreature(self.id)
  if me ~= nil then
    return me:IsMoving()
  end
  return false
end
function CreatureDataWithPropUserdata:GetSpareBattleTime()
  return 0
end
function CreatureDataWithPropUserdata:HasLimitSkill()
  return false
end
function CreatureDataWithPropUserdata:HasLimitNotSkill()
  return false
end
function CreatureDataWithPropUserdata:GetLimitSkillTarget(skillID)
  return nil
end
function CreatureDataWithPropUserdata:GetLimitNotSkill(skillID)
  return nil
end
function CreatureDataWithPropUserdata:GetLimitSkillTargetBySortID(sortID)
  return nil
end
function CreatureDataWithPropUserdata:AddBuff(buffID, fromID, layer, level, active)
  if buffID == nil then
    return
  end
  if self.buffIDs == nil then
    self.buffIDs = ReusableTable.CreateTable()
  end
  if self.buffIDLayers == nil then
    self.buffIDLayers = ReusableTable.CreateTable()
  end
  if level ~= nil and level > 0 then
    if self.buffIDLevels == nil then
      self.buffIDLevels = ReusableTable.CreateTable()
    end
    self.buffIDLevels[buffID] = level
  end
  if active ~= nil then
    if self.buffIDActives == nil then
      self.buffIDActives = ReusableTable.CreateTable()
    end
    self.buffIDActives[buffID] = active
  end
  self.buffIDs[buffID] = fromID
  self.buffIDLayers[buffID] = layer
end
function CreatureDataWithPropUserdata:_AddBuffRelate(t, buffID, value)
end
function CreatureDataWithPropUserdata:RemoveBuff(buffID)
  if buffID == nil then
    return
  end
  self:_RemoveBuffRelate(self.buffIDs, buffID)
  self:_RemoveBuffRelate(self.buffIDLayers, buffID)
  self:_RemoveBuffRelate(self.buffIDLevels, buffID)
  self:_RemoveBuffRelate(self.buffIDActives, buffID)
end
function CreatureDataWithPropUserdata:_RemoveBuffRelate(t, buffID)
  if t ~= nil then
    t[buffID] = nil
  end
end
function CreatureDataWithPropUserdata:IsBuffStateValid(buffInfo)
  if buffInfo == nil then
    return false
  end
  local buffEffect = buffInfo.BuffEffect
  if buffEffect and buffEffect.BuffState_Self == 1 then
    return false
  end
  return true
end
function CreatureDataWithPropUserdata:_AddWeakFreezeSkillBuff(buffInfo, skillIDs)
  if self.weakFreezeBuffs == nil then
    self.weakFreezeBuffs = {}
    self.weakFreezeBuffs.count = 0
    self.weakFreezeBuffs.relateBuffs = {}
  end
  local buffID = buffInfo.id
  if self.weakFreezeBuffs.relateBuffs[buffID] == nil then
    self.weakFreezeBuffs.count = self.weakFreezeBuffs.count + 1
    self.weakFreezeBuffs.relateBuffs[buffID] = 1
    local skillBuff
    for i = 1, #skillIDs do
      skillBuff = self.weakFreezeBuffs[skillIDs[i]]
      if skillBuff == nil then
        skillBuff = ReusableTable.CreateArray()
        self.weakFreezeBuffs[skillIDs[i]] = skillBuff
      end
      skillBuff[#skillBuff + 1] = buffID
    end
  end
end
function CreatureDataWithPropUserdata:_RemoveWeakFreezeSkillBuff(buffInfo, skillIDs)
  if self.weakFreezeBuffs then
    local buffID = buffInfo.id
    if self.weakFreezeBuffs.relateBuffs[buffID] then
      self.weakFreezeBuffs.relateBuffs[buffID] = nil
      self.weakFreezeBuffs.count = self.weakFreezeBuffs.count - 1
      local skillBuff
      for i = 1, #skillIDs do
        skillBuff = self.weakFreezeBuffs[skillIDs[i]]
        ArrayRemove(skillBuff, buffID)
        if #skillBuff == 0 then
          self.weakFreezeBuffs[skillIDs[i]] = nil
          DestroyArray(skillBuff)
        end
      end
    end
  end
end
function CreatureDataWithPropUserdata:_DynamicSkillConfigAdd(buffeffect)
  local _SkillDynamicManager = Game.SkillDynamicManager
  for i = 1, #buffeffect.ids do
    _SkillDynamicManager:AddDynamicConfig(self.id, buffeffect.ids[i], buffeffect.configType, buffeffect.value)
  end
end
function CreatureDataWithPropUserdata:_DynamicSkillConfigRemove(buffeffect)
  local _SkillDynamicManager = Game.SkillDynamicManager
  for i = 1, #buffeffect.ids do
    _SkillDynamicManager:RemoveDynamicConfig(self.id, buffeffect.ids[i], buffeffect.configType, buffeffect.value)
  end
end
function CreatureDataWithPropUserdata:_ClearBuffs()
  if self.buffIDs ~= nil then
    ReusableTable.DestroyAndClearTable(self.buffIDs)
    self.buffIDs = nil
  end
  if self.buffIDLayers ~= nil then
    ReusableTable.DestroyAndClearTable(self.buffIDLayers)
    self.buffIDLayers = nil
  end
  if self.buffIDLevels ~= nil then
    ReusableTable.DestroyAndClearTable(self.buffIDLevels)
    self.buffIDLevels = nil
  end
  if self.buffIDActives ~= nil then
    ReusableTable.DestroyAndClearTable(self.buffIDActives)
    self.buffIDActives = nil
  end
end
function CreatureDataWithPropUserdata:AddClientProp(propName, value)
  local p = self.clientProps:GetPropByName(propName)
  local old, clientp = self.clientProps:SetValueByName(propName, p.value + value)
  return p, clientp
end
local PartIndex, PartIndexEx
function CreatureDataWithPropUserdata:GetDressParts()
  if PartIndex == nil then
    PartIndex = Asset_Role.PartIndex
  end
  if PartIndexEx == nil then
    PartIndexEx = Asset_Role.PartIndexEx
  end
  local parts = Asset_Role.CreatePartArray()
  if self.userdata then
    local userData = self.userdata
    parts[PartIndex.Body] = userData:Get(UDEnum.BODY) or 0
    parts[PartIndex.Hair] = userData:Get(UDEnum.HAIR) or 0
    parts[PartIndex.LeftWeapon] = userData:Get(UDEnum.LEFTHAND) or 0
    parts[PartIndex.RightWeapon] = userData:Get(UDEnum.RIGHTHAND) or 0
    parts[PartIndex.Head] = userData:Get(UDEnum.HEAD) or 0
    parts[PartIndex.Wing] = userData:Get(UDEnum.BACK) or 0
    parts[PartIndex.Face] = userData:Get(UDEnum.FACE) or 0
    parts[PartIndex.Tail] = userData:Get(UDEnum.TAIL) or 0
    parts[PartIndex.Eye] = userData:Get(UDEnum.EYE) or 0
    parts[PartIndex.Mouth] = userData:Get(UDEnum.MOUTH) or 0
    parts[PartIndex.Mount] = userData:Get(UDEnum.MOUNT) or 0
    parts[PartIndexEx.Gender] = userData:Get(UDEnum.SEX) or 0
    parts[PartIndexEx.HairColorIndex] = userData:Get(UDEnum.HAIRCOLOR) or 0
    parts[PartIndexEx.EyeColorIndex] = userData:Get(UDEnum.EYECOLOR) or 0
    parts[PartIndexEx.BodyColorIndex] = userData:Get(UDEnum.CLOTHCOLOR) or 0
  else
    for i = 1, 12 do
      parts[i] = 0
    end
  end
  self:SpecialProcessParts(parts)
  return parts
end
autoImport("SimpleGuildData")
function CreatureDataWithPropUserdata:SetGuildData(data)
  if data and data[1] and data[1] ~= 0 then
    if not self.guildData then
      self.guildData = SimpleGuildData.CreateAsTable()
    end
    self.guildData:SetData(data)
  else
    self:DestroyGuildData()
  end
end
function CreatureDataWithPropUserdata:DestroyGuildData()
  if self.guildData then
    self.guildData:Destroy()
    self.guildData = nil
  end
end
function CreatureDataWithPropUserdata:GetGuildData()
  return self.guildData
end
function CreatureDataWithPropUserdata:SetMercenaryGuildData(data)
  if data and data[1] and data[1] ~= 0 then
    if not self.mercenaryGuildData then
      self.mercenaryGuildData = SimpleGuildData.CreateAsTable()
    end
    self.mercenaryGuildData:SetData(data)
  else
    self:DestroyMercenaryGuildData()
  end
end
function CreatureDataWithPropUserdata:DestroyMercenaryGuildData()
  if self.mercenaryGuildData then
    self.mercenaryGuildData:Destroy()
    self.mercenaryGuildData = nil
  end
end
function CreatureDataWithPropUserdata:GetMercenaryGuildData()
  return self.mercenaryGuildData
end
function CreatureDataWithPropUserdata:IsMercenary()
  if self.mercenaryGuildData and self.mercenaryGuildData.id > 0 then
    return true
  end
  return false
end
function CreatureDataWithPropUserdata:GetMercenaryGuildName()
  return self.mercenaryGuildData and self.mercenaryGuildData.mercenaryName or nil
end
function CreatureDataWithPropUserdata:GetUserDataStatus()
  return self.userdata:Get(UDEnum.STATUS)
end
function CreatureDataWithPropUserdata:GetRaidType()
  if Game.MapManager:IsRaidMode() then
    local raidData = Table_MapRaid[Game.MapManager:GetRaidID()]
    return raidData and raidData.Type or 0
  end
  return 0
end
function CreatureDataWithPropUserdata:GetMount()
  return self.userdata:Get(UDEnum.MOUNT)
end
function CreatureDataWithPropUserdata:SetClientForceDressPart(partIndex, partID)
  if not self.forceParts then
    self.forceParts = ReusableTable.CreateTable()
  end
  self.forceParts[partIndex] = partID
end
function CreatureDataWithPropUserdata:GetClientForceDressPart(partIndex)
  return self.forceParts and self.forceParts[partIndex] or 0
end
function CreatureDataWithPropUserdata:ClearClientForceDressParts()
  if self.forceParts then
    ReusableTable.DestroyAndClearTable(self.forceParts)
    self.forceParts = nil
  end
end
function CreatureDataWithPropUserdata:SpecialProcessParts(parts)
  if self.forceParts then
    for partIndex, partID in pairs(self.forceParts) do
      if partID ~= 0 then
        parts[partIndex] = partID
      end
    end
  end
  self:SpecialProcessPart_Sheath(parts)
end
function CreatureDataWithPropUserdata:SpecialProcessPart_Sheath(parts)
  local userdata = self.userdata
  if userdata ~= nil then
    local profess = userdata:Get(UDEnum.PROFESSION)
    if profess ~= nil and profess ~= 0 then
      local classData = Table_Class[profess]
      if classData ~= nil then
        parts[Asset_Role.PartIndexEx.SheathDisplay] = classData.Feature and 0 < classData.Feature & FeatureDefines_Class.Sheath
      end
    end
  end
end
function CreatureDataWithPropUserdata:GetFeature_IgnoreAutoBattle()
  return false
end
function CreatureDataWithPropUserdata:GetHP()
  local hp = Game.SkillDynamicManager:GetDynamicProps(self:GetCamp(), SkillDynamicManager.Props.HP)
  if hp ~= nil then
    return hp
  end
  return self.props:GetPropByName("Hp"):GetValue()
end
function CreatureDataWithPropUserdata:GetMP()
  return self.props:GetPropByName("Sp"):GetValue()
end
function CreatureDataWithPropUserdata:NoFCT()
  return self:GetBuffEffectByType(BuffType.NoFCT)
end
function CreatureDataWithPropUserdata:GetCurChantTime()
  return 0
end
function CreatureDataWithPropUserdata:NoPhySkill()
  return self.props:GetPropByName("NoPhySkill"):GetValue() > 0
end
function CreatureDataWithPropUserdata:GetFeature_ForceSelect()
  return false
end
function CreatureDataWithPropUserdata:SetKickSkill(skillid)
  self.KickSkill = skillid
end
function CreatureDataWithPropUserdata:IsTriggerKickSkill(skilid)
  return self.KickSkill and self.KickSkill == skillid
end
function CreatureDataWithPropUserdata:IsPlayer()
  return false
end
function CreatureDataWithPropUserdata:IsNpc()
  return false
end
function CreatureDataWithPropUserdata:IsMonster()
  return false
end
function CreatureDataWithPropUserdata:GetMapTeammateNum()
  return 0
end
function CreatureDataWithPropUserdata:GetSunMark()
  return 0
end
function CreatureDataWithPropUserdata:GetMoonMark()
  return 0
end
function CreatureDataWithPropUserdata:GetTimeDiskGrid()
  return 0
end
function CreatureDataWithPropUserdata:GetBuffLayerByIDAndFromID(buffID, guid)
  return self:GetBuffLayer(buffID)
end
function CreatureDataWithPropUserdata:GetMountForm()
  return self.userdata and self.userdata:Get(UDEnum.RIDE_REFORM) or 1
end
function CreatureDataWithPropUserdata:GetPrevMountForm()
  local curMountForm = self:GetMountForm()
  local prevMountForm = curMountForm - 1
  if prevMountForm < 1 then
    prevMountForm = 2
  end
  return prevMountForm
end
function CreatureDataWithPropUserdata:GetNextMountForm()
  local curMountForm = self:GetMountForm()
  local nextMountForm = curMountForm + 1
  if nextMountForm > 2 then
    nextMountForm = 1
  end
  return nextMountForm
end
function CreatureDataWithPropUserdata:IsDressPartOfFeature(part, feature)
  local key = Asset_Role.PartIndexUserDataMap[part]
  if key and self.userdata then
    local equipId = self.userdata:Get(key)
    if EquipInfo.IsEquipOfFeature(equipId, feature) then
      return true
    end
  end
  return false
end
function CreatureDataWithPropUserdata:IsWildMvpLucky()
  if type(SceneUser2_pb.EOPTIONTYPE_STORMBOSS_LUCKY) ~= "number" then
    return false
  end
  local opt = self.userdata and self.userdata:Get(UDEnum.OPTION) or 0
  return 0 < BitUtil.band(opt, SceneUser2_pb.EOPTIONTYPE_STORMBOSS_LUCKY)
end
function CreatureDataWithPropUserdata:UpdateBuffHpVals(buffhp, buffmaxhp)
  self.buffhp = buffhp
  self.buffmaxhp = buffmaxhp
end
function CreatureDataWithPropUserdata:GetBuffHpVals()
  return self.buffhp, self.buffmaxhp
end
function CreatureDataWithPropUserdata:DoConstruct(asArray, parts)
  self:SetAttackSpeed(1)
  self.bodyScale = self:GetDefaultScale()
  CreatureDataWithPropUserdata.super.DoConstruct(self, asArray, parts)
end
function CreatureDataWithPropUserdata:DoDeconstruct(asArray)
  CreatureDataWithPropUserdata.super.DoDeconstruct(self, asArray)
  self:ClearClientForceDressParts()
  self:Reset()
  self.userdata:Reset()
  self.props:Reset()
  self.clientProps:Reset()
  self.attrEffect:Set(0)
  self.attrEffect2:Reset()
  self.attrEffect3:Reset()
  self:_ClearBuffs()
  self:DestroyGuildData()
  self:DestroyMercenaryGuildData()
end
