SkillLogic_Base = {}
local DefaultActionCast = "reading"
local DefaultActionAttack = "attack"
local DefaultDynamicActionAttack = {"use_skill"}
local DamageType = CommonFun.DamageType
local FindCreature = SceneCreatureProxy.FindCreature
local ArrayPushBack = TableUtility.ArrayPushBack
local ArrayClear = TableUtility.ArrayClear
local ArrayUnique = TableUtility.ArrayUnique
local TableClear = TableUtility.TableClear
local _RoleDefines_Camp = RoleDefines_Camp
local tempVector3 = LuaVector3.Zero()
local dirVector3 = LuaVector3.Zero()
local tempCreatureArray = {}
local tempTable = {}
local tempCalcDamageParams = {
  skillIDAndLevel = 0,
  hitedIndex = 0,
  hitedCount = 0,
  pvpMap = false
}
local KickSkills = GameConfig.KickSkill.Skills
local KickSkillsMap = {}
for i = 1, #KickSkills do
  KickSkillsMap[KickSkills[i]] = true
end
local tempComboEmitParams = {
  [1] = 0,
  [2] = 0,
  [3] = nil,
  [4] = nil,
  [5] = nil,
  [6] = 0
}
SkillLogic_Base.DefaultSearchRange = 40
function SkillLogic_Base.error(...)
  errorLog(...)
end
local CreateSearchTargetInfo = ReusableTable.CreateSearchTargetInfo
local DestroySearchTargetInfo = ReusableTable.DestroySearchTargetInfo
local CreateArray = ReusableTable.CreateArray
local DestroyArray = ReusableTable.DestroyArray
local tempSearchTargetArgs = {
  [1] = {},
  [2] = LuaVector3.Zero(),
  [3] = nil,
  [4] = nil,
  [5] = nil,
  [6] = 0,
  [7] = nil,
  [8] = nil
}
local CheckDistanceInRange = function(targetCreature, args, distance)
  return distance <= args[6]
end
local CheckDistanceInRect = function(targetCreature, args, distance)
  return args[7]:Contains(targetCreature:GetPosition())
end
local AddTarget = function(targetCreature, args)
  if targetCreature.data:NoAccessable() and not args[3]:TargetIncludeHide() then
    return
  end
  local distance = VectorUtility.DistanceXZ(args[2], targetCreature:GetPosition())
  if not args[8](targetCreature, args, distance) then
    return
  end
  if not args[3]:CheckTarget(args[4], targetCreature) then
    return
  end
  if nil ~= args[5] and not args[5](targetCreature, args) then
    return
  end
  local targetInfo = CreateSearchTargetInfo()
  targetInfo[1] = targetCreature
  targetInfo[2] = distance
  ArrayPushBack(args[1], targetInfo)
end
local SearchTarget = function(targets, sortComparator)
  local args = tempSearchTargetArgs
  SceneCreatureProxy.ForEachCreature(AddTarget, args)
  local targetInfos = args[1]
  local targetCount = #targetInfos
  if targetCount > 0 then
    if nil ~= sortComparator then
      table.sort(targetInfos, sortComparator)
    end
    local j = #targets + 1
    for i = targetCount, 1, -1 do
      local targetInfo = targetInfos[i]
      targets[j] = targetInfo[1]
      DestroySearchTargetInfo(targetInfo)
      targetInfos[i] = nil
      j = j + 1
    end
  end
  args[3] = nil
  args[4] = nil
  args[5] = nil
  args[10] = nil
  return targetCount
end
local CheckTarget = function(targetCreature, args)
  return args[1]:CheckTarget(args[2], targetCreature)
end
local SortComparator_PriorityNpc = function(targetInfo1, targetInfo2)
  if targetInfo1:GetCreatureType() == Creature_Type.Npc and tempTable[targetInfo1.data.staticData.id] ~= nil then
    return true
  end
  if targetInfo2:GetCreatureType() == Creature_Type.Npc and tempTable[targetInfo2.data.staticData.id] ~= nil then
    return false
  end
end
function SkillLogic_Base.SortComparator_Distance(targetInfo1, targetInfo2)
  return targetInfo1[2] > targetInfo2[2]
end
function SkillLogic_Base.SortComparator_TeamFirstDistance(targetInfo1, targetInfo2)
  local inMyTeam1 = targetInfo1[1]:IsInMyTeam()
  local inMyTeam2 = targetInfo2[1]:IsInMyTeam()
  if inMyTeam1 == inMyTeam2 then
    return targetInfo1[2] > targetInfo2[2]
  end
  return inMyTeam2
end
function SkillLogic_Base.SortComparator_HatredFirstDistance(targetInfo1, targetInfo2)
  local hatred1 = targetInfo1[1]:IsHatred()
  local hatred2 = targetInfo2[1]:IsHatred()
  if hatred1 == hatred2 then
    return targetInfo1[2] > targetInfo2[2]
  end
  return hatred2
end
function SkillLogic_Base.SearchTargetInRange(targets, p, range, skillInfo, creature, filter, sortComparator)
  local args = tempSearchTargetArgs
  LuaVector3.Better_Set(args[2], p[1], p[2], p[3])
  args[3] = skillInfo
  args[4] = creature
  args[5] = filter
  args[6] = range
  args[8] = CheckDistanceInRange
  return SearchTarget(targets, sortComparator)
end
function SkillLogic_Base.SearchTargetInRect(targets, p, offset, size, angleY, skillInfo, creature, filter, sortComparator)
  local args = tempSearchTargetArgs
  LuaVector3.Better_Set(args[2], p[1], p[2], p[3])
  args[3] = skillInfo
  args[4] = creature
  args[5] = filter
  local rectObject = Game.Object_Rect
  rectObject:PlaceTo(p, angleY or 0)
  if nil ~= offset then
    rectObject.offset = offset
  else
    rectObject.offset = LuaGeometry.Const_V2_zero
  end
  rectObject.size = size
  rectObject:PlaceTo(p, angleY or 0)
  if nil ~= offset then
    rectObject.offset = offset
  else
    rectObject.offset = LuaGeometry.Const_V2_zero
  end
  rectObject.size = size
  args[7] = rectObject
  args[8] = CheckDistanceInRect
  return SearchTarget(targets, sortComparator)
end
function SkillLogic_Base.CalcDamageLabelParams(sourcePosition, targetPosition, damageType, targetCreature)
  local labelType
  if DamageType.Miss == damageType or DamageType.Barrier == damageType then
    labelType = HurtNumType.Miss
  else
    labelType = HurtNumType.DamageNum_L
    local atRight = ROUtils.IsAtRightOnScreen(sourcePosition, targetPosition)
    if atRight then
      labelType = HurtNumType.DamageNum_R
    end
  end
  local labelColorType
  if DamageType.Normal_Sp == damageType then
    labelColorType = HurtNumColorType.Normal_Sp
  else
    labelColorType = HurtNumColorType.Normal
    if nil ~= targetCreature then
      if Game.Myself == targetCreature then
        labelColorType = HurtNumColorType.Player
      else
        local myTeam = TeamProxy.Instance.myTeam
        if nil ~= myTeam then
          local teamMember = myTeam:GetMemberByGuid(targetCreature.data.id)
          if nil ~= teamMember then
            labelColorType = HurtNumColorType.Player
          end
        end
      end
    end
  end
  return labelType, labelColorType
end
function SkillLogic_Base.AllowSelfEffect(creature)
  if nil == creature then
    return false
  end
  if not creature:IsDressed() then
    return false
  end
  if (not creature:IsCullingVisible() or 0 < creature:GetCullingDistanceLevel()) and not creature.data:GetFeature_IgnoreEffectCulling() then
    return false
  end
  return true
end
function SkillLogic_Base.AllowTargetEffect(creature, targetCreature)
  if nil == targetCreature then
    return false
  end
  if targetCreature == Game.Myself then
    return true
  end
  if not targetCreature:IsDressed() then
    return false
  end
  if not targetCreature:IsCullingVisible() or 0 < targetCreature:GetCullingDistanceLevel() then
    return false
  end
  return true
end
function SkillLogic_Base.AllowTargetHurtNum(creature, targetCreature, skillInfo, damageType)
  if not targetCreature then
    return false
  end
  if targetCreature:GetCreatureType() == Creature_Type.Npc then
    local tarUserdata = targetCreature.data and targetCreature.data.userdata
    local opt = tarUserdata and tarUserdata:Get(UDEnum.OPTION)
    if opt == 1 then
      return false
    end
  end
  if targetCreature:IsUIMask(MaskPlayerUIType.HurtNum) then
    return false
  end
  local showHurtNum = FunctionPerformanceSetting.Me():ShowHurtNum()
  if showHurtNum == ShowHurtNum.Team or showHurtNum == ShowHurtNum.Self then
    local _ObMrg = PvpObserveProxy.Instance
    if showHurtNum == ShowHurtNum.Self and _ObMrg:IsRunning() then
      if _ObMrg:IsGhost() then
        return false
      end
      if _ObMrg:IsAttaching() then
        local attachId = _ObMrg:GetAttachPlayer()
        local fromAttachPlayer = creature and creature.data.id == attachId
        return targetCreature.data.id == attachId or fromAttachPlayer
      end
    end
    if creature and creature.IsMyPet and creature:IsMyPet() or targetCreature.IsMyPet and targetCreature:IsMyPet() then
      return true
    end
    if showHurtNum == ShowHurtNum.Team and (creature ~= nil and (creature:IsInMyTeam() or creature:IsInMyGroup()) or targetCreature:IsInMyTeam() or targetCreature:IsInMyGroup()) then
      return true
    end
    local myself = Game.Myself
    if creature == myself or targetCreature == myself then
      return true
    end
    local myID = myself.data.id
    if creature and creature.data.ownerID and creature.data.ownerID == myID or targetCreature.data.ownerID and targetCreature.data.ownerID == myID then
      return true
    end
    if creature and creature.data.skillOwner == myID then
      return true
    end
    return false
  end
  if skillInfo and skillInfo:CheckHideTargetDamgeNum(targetCreature) then
    return false
  end
  return true
end
function SkillLogic_Base.ShowDamage_Single(damageType, damage, position, labelType, labelColorType, targetCreature, skillInfo, creature)
  if not SkillLogic_Base.AllowTargetEffect(creature, targetCreature) then
    return
  end
  if not SkillLogic_Base.AllowTargetHurtNum(creature, targetCreature, skillInfo, damageType) then
    return
  end
  if DamageType.None == damageType or DamageType.Block == damageType or DamageType.AutoBlock == damageType or DamageType.WeaponBlock == damageType then
    return
  end
  local damageStr
  local crit = HurtNum_CritType.None
  if DamageType.Miss == damageType or CommonFun.DamageType.Barrier == damageType then
    damageStr = "Miss"
  elseif DamageType.Treatment == damageType then
    if damage <= 0 then
      return
    end
    labelType = HurtNumType.HealNum
    labelColorType = HurtNumColorType.Treatment
    damageStr = tostring(damage)
  elseif DamageType.Treatment_Sp == damageType then
    if damage <= 0 then
      return
    end
    labelType = HurtNumType.HealNum
    labelColorType = HurtNumColorType.Treatment_Sp
    damageStr = tostring(damage)
  elseif DamageType.Crit == damageType then
    if damage <= 0 then
      return
    end
    labelColorType = HurtNumColorType.Combo
    damageStr = tostring(damage)
    if nil ~= skillInfo and skillInfo:ShowMagicCrit(targetCreature) then
      crit = HurtNum_CritType.MAtk
    else
      crit = HurtNum_CritType.PAtk
    end
  else
    if damage <= 0 then
      return
    end
    damageStr = tostring(damage)
  end
  SceneUIManager.Instance:ShowDynamicHurtNum(position, damageStr, labelType, labelColorType, crit, creature == Game.Myself, targetCreature == Game.Myself)
  if damageType ~= DamageType.Miss and damageType ~= DamageType.Barrier and damageType ~= DamageType.Treatment and damageType ~= DamageType.Treatment_Sp and creature then
    local args = ReusableTable.CreateArray()
    args[1] = RandomAIManager.TriggerConditionEnum.DAMAGE
    args[2] = creature.data.id
    EventManager.Me():PassEvent(PlayerBehaviourEvent.OnTrigger, args)
    ReusableTable.DestroyAndClearArray(args)
  end
end
function SkillLogic_Base.CalcDamage(skillID, creature, targetCreature, targetIndex, targetCount)
  tempCalcDamageParams.skillIDAndLevel = skillID
  tempCalcDamageParams.hitedIndex = targetIndex
  tempCalcDamageParams.hitedCount = targetCount
  tempCalcDamageParams.pvpMap = Game.MapManager:IsPVPMode()
  local damage, damageType, shareDamageInfos = CommonFun.CalcDamage(creature.data, targetCreature.data, tempCalcDamageParams, SkillLogic_Base)
  damage = math.abs(damage)
  return damageType, damage, shareDamageInfos
end
local tempDamageArray = {}
function SkillLogic_Base.SplitDamage(damage, damageCount, damageArray)
  if damage > 1 and damageCount > 1 then
    local partDamage = math.max(math.floor(damage / damageCount), 1)
    for i = 1, damageCount - 1 do
      damageArray[i] = partDamage
    end
    damageArray[damageCount] = math.max(damage - partDamage * (damageCount - 1), 1)
    return damageCount
  else
    damageArray[1] = damage
    return 1
  end
end
function SkillLogic_Base.GetSplitDamage(damage, damageIndex, damageCount)
  damageCount = SkillLogic_Base.SplitDamage(damage, damageCount, tempDamageArray)
  if damageIndex > damageCount then
    damageIndex = damageCount
  end
  return tempDamageArray[damageIndex]
end
function SkillLogic_Base.GetComboEmitParams()
  return tempComboEmitParams
end
function SkillLogic_Base.HitTargetByPhaseData(phaseData, sourceCreatureGUID)
  local targetCount = phaseData:GetTargetCount()
  if targetCount <= 0 then
    return
  end
  local fromPosition
  local skillInfo = Game.LogicManager_Skill:GetSkillInfo(phaseData:GetSkillID())
  if nil ~= sourceCreatureGUID and 0 ~= sourceCreatureGUID then
    local sourceCreature = FindCreature(sourceCreatureGUID)
    if nil ~= sourceCreature then
      sourceCreature.skill:OnDelayHit(sourceCreature, phaseData)
      if skillInfo:IsSkillDirectionRect(sourceCreature) then
        fromPosition = sourceCreature:GetPosition()
      end
      if skillInfo:NeedPassiveFire() then
        SkillLogic_Base.PassiveFire(sourceCreature, phaseData, skillInfo)
        return
      end
    end
  end
  local noHitEffect
  noHitEffect = skillInfo:IsLastHitOnly() and not phaseData:GetIsLastHit()
  local hitWorker = SkillHitWorker.Create()
  hitWorker:Init(skillInfo, fromPosition or phaseData:GetPosition(), sourceCreatureGUID, 0, noHitEffect)
  for i = 1, targetCount do
    hitWorker:AddTarget(phaseData:GetTarget(i))
  end
  hitWorker:SetHitedTargetGoPos(phaseData:GetHitedTargetPos())
  mylog("HitTargetByPhaseData", phaseData:GetSkillID(), UnityFrameCount)
  hitWorker:Work(1, 1)
  hitWorker:Destroy()
end
function SkillLogic_Base.EmitFire(creature, targetCreature, targetPosition, fireEP, emitParams, hitWorker, forceSingleDamage, emitIndex, emitCount, fireEPWeapon, skillInfo)
  if fireEPWeapon then
    LuaVector3.Better_Set(tempVector3, creature.assetRole:GetWeaponFireEP(fireEPWeapon))
  else
    LuaVector3.Better_Set(tempVector3, creature.assetRole:GetEPOrRootPosition(fireEP))
  end
  if skillInfo and skillInfo:IsSkillDirectionRect() then
    local angleY = math.rad(creature:GetAngleY())
    local pos = creature:GetPosition()
    local distance = skillInfo:GetDistance()
    targetPosition = LuaVector3(distance * math.sin(angleY) + pos[1], pos[2], distance * math.cos(angleY) + pos[3])
  end
  local args
  if emitParams.reverse then
    args = SubSkillProjectile.GetArgs(emitParams, hitWorker, forceSingleDamage, targetPosition, tempVector3, emitIndex, emitCount)
  else
    args = SubSkillProjectile.GetArgs(emitParams, hitWorker, forceSingleDamage, tempVector3, targetPosition, emitIndex, emitCount)
  end
  mylog("CreateWorker_SubSkillProjectile", UnityFrameCount)
  Game.SkillWorkerManager:CreateWorker_SubSkillProjectile(args)
  SubSkillProjectile.ClearArgs(args)
end
function SkillLogic_Base:Cast(creature)
  local assetRole = creature.assetRole
  local skillInfo = self.info
  SkillLogic_Base.CastPlayAction(self, creature)
  local effectPath, lodLevel, priority, effectType, scale = skillInfo:GetCastEffectPath(creature)
  if nil ~= effectPath then
    local effect = assetRole:PlayEffectOn(effectPath, 0, nil, nil, nil, nil, nil, lodLevel, priority, effectType)
    self:AddEffect(effect)
    if effect and scale and scale ~= 1 then
      effect:ResetLocalScaleXYZ(scale, scale, scale)
    end
  end
  local sePath = skillInfo:GetCastSEPath(creature)
  if nil ~= sePath then
    local se = assetRole:PlaySEOn(sePath, AudioSourceType.SKILL_Cast)
    self:AddSE(se)
  end
  return true
end
function SkillLogic_Base:CastPlayAction(creature)
  local skillInfo = self.info
  local actionName = skillInfo:GetCastAction(creature)
  local replaceActionName = skillInfo:GetFashionCastAct(creature)
  if replaceActionName and replaceActionName ~= "" then
    actionName = replaceActionName
  end
  if not creature.assetRole:HasActionRaw(actionName) and creature:GetChantSkillTime() <= 0 then
    actionName = DefaultActionCast
  end
  local playActionParams = Asset_Role.GetPlayActionParams(actionName, nil, 1)
  playActionParams[6] = true
  playActionParams[13] = skillInfo:AllowConcurrent(creature) and 1 or 0
  creature:Logic_PlayAction(playActionParams)
  Asset_Role.ClearPlayActionParams(playActionParams)
end
function SkillLogic_Base:FreeCast(creature)
  return SkillLogic_Base.Cast(self, creature)
end
function SkillLogic_Base:Attack(creature, isAttackSkill, isTriggerSkill, noAttackCallback)
  local logicTransform = creature.logicTransform
  local assetRole = creature.assetRole
  local skillInfo = self.info
  local attackSpeed = 1
  local actionPlayed = false
  local effect, lefteffect, righteffect
  if not skillInfo:NoAction(creature) then
    local hasOriginAction = true
    local actionName = skillInfo:GetAttackAction(creature)
    local replaceActionName = skillInfo:GetFashionAttackAct(creature)
    if replaceActionName and replaceActionName ~= "" then
      actionName = replaceActionName
    end
    local dynamicAction
    for i = 1, #DefaultDynamicActionAttack do
      dynamicAction = DefaultDynamicActionAttack[i]
      if string.find(actionName, dynamicAction) and not assetRole:HasActionRaw(actionName) then
        actionName = dynamicAction
        break
      end
    end
    if not assetRole:HasAction(actionName) and not assetRole:HasActionIgnoreMount(actionName) and not assetRole:HasActionRaw(actionName) then
      actionName = DefaultActionAttack
      hasOriginAction = false
    end
    if hasOriginAction or assetRole:HasActionRaw(actionName) then
      local kickSpeedUp = false
      local phaseData = self.phaseData
      if isTriggerSkill == true and creature == Game.Myself then
        kickSpeedUp = KickSkillsMap[skillInfo:GetSkillID() // 1000] and Game.Myself.data.KickSkillSpeedUp == true
      end
      if isAttackSkill and not skillInfo:NoAttackSpeed() then
        if not isTriggerSkill or isTriggerSkill and kickSpeedUp then
          attackSpeed = creature.data:GetAttackSpeed_Adjusted() * logicTransform:GetFastForwardSpeed()
          local attackDuration = 1 / attackSpeed
          attackSpeed = attackSpeed * ((attackDuration + 3.3 / ApplicationInfo.GetTargetFrameRate()) / attackDuration)
        else
          attackSpeed = logicTransform:GetFastForwardSpeed()
        end
      else
        attackSpeed = logicTransform:GetFastForwardSpeed()
      end
      local playActionParams = Asset_Role.GetPlayActionParams(actionName, nil, attackSpeed)
      playActionParams[6] = true
      if noAttackCallback then
        playActionParams[7] = nil
      else
        playActionParams[7] = SkillLogic_Base.OnAttackFinished
      end
      playActionParams[8] = self.instanceID
      playActionParams[13] = skillInfo:AllowConcurrent(creature) and 1 or 0
      actionPlayed = creature:Logic_PlayAction(playActionParams)
      Asset_Role.ClearPlayActionParams(playActionParams)
      local attackEP = skillInfo:GetAttackEP(creature)
      local fireEPWeapon = skillInfo:GetFireEPWeapon()
      local effectPath, lodLevel, priority, effectType, scale = skillInfo:GetAttackEffectPath(creature)
      if nil ~= effectPath then
        if fireEPWeapon then
          local lefteffect, righeffect = assetRole:FireEffectOnWeaponEP(effectPath, fireEPWeapon, nil, lodLevel, priority, effectType)
          if lefteffect then
            lefteffect:ResetLocalEulerAnglesXYZ(0, creature:GetAngleY(), 0)
            lefteffect:SetPlaybackSpeed(attackSpeed)
            if scale and scale ~= 1 then
              lefteffect:ResetLocalScaleXYZ(scale, scale, scale)
            end
          end
          if righteffect then
            righteffect:ResetLocalEulerAnglesXYZ(0, creature:GetAngleY(), 0)
            righteffect:SetPlaybackSpeed(attackSpeed)
            if scale and scale ~= 1 then
              righteffect:ResetLocalScaleXYZ(scale, scale, scale)
            end
          end
        else
          if skillInfo:AttackEffectOnRole(creature) then
            effect = assetRole:PlayEffectOneShotOn(effectPath, attackEP, nil, nil, nil, nil, nil, lodLevel, priority, effectType)
          else
            effect = assetRole:PlayEffectOneShotAt(effectPath, attackEP, nil, nil, nil, nil, nil, lodLevel, priority, effectType)
            if effect ~= nil then
              effect:ResetLocalEulerAnglesXYZ(0, creature:GetAngleY(), 0)
            end
          end
          if effect ~= nil then
            effect:SetPlaybackSpeed(attackSpeed)
            if scale and scale ~= 1 then
              effect:ResetLocalScaleXYZ(scale, scale, scale)
            end
          end
        end
      end
      local attack_uieffectpath = skillInfo:GetAttackUIEffectPath()
      if attack_uieffectpath then
        local data = {}
        data.effect = ResourcePathHelper.UIEffect(attack_uieffectpath)
        GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.FullScreenEffectView,
          viewdata = data
        })
      end
      local sePath = skillInfo:GetAttackSEPath(creature)
      if nil ~= sePath then
        assetRole:PlaySEOneShotOn(sePath, AudioSourceType.SKILL_Attack)
      end
    end
  end
  if not skillInfo:NoAttackEffectMove(creature) then
    local phaseData = self.phaseData
    local goPos = phaseData:GetGoPos()[1]
    if goPos then
      do
        local dirPoint = LuaVector3.New(goPos[1], goPos[2], goPos[3])
        local dirMoveDistance = LuaVector3.Distance(creature:GetPosition(), dirPoint)
        if dirMoveDistance > 0.01 then
          local direction = goPos[5]
          local dirAngleY = VectorHelper.GetAngleByAxisY(creature:GetPosition(), dirPoint)
          if "forward" == direction then
            dirAngleY = NumberUtility.Repeat(dirAngleY + 180, 360)
          end
          logicTransform:ExtraDirMove(dirAngleY, dirMoveDistance, goPos[4] * attackSpeed, function(logicTransform, arg)
            SkillLogic_Base.CheckExtraDirMove(logicTransform, arg)
            if effect and skillInfo:ManulDestroy() then
              effect:Destroy()
              creature.skill.attackTimeDuration = 0
            end
            dirPoint:Destroy()
          end, nil, dirPoint, skillInfo:IsIgnoreTerrain())
        end
      end
    else
    end
    local specialEffects = skillInfo:GetSpecialAttackEffects(creature)
    if specialEffects then
      for i = 1, #specialEffects do
        local specialEffect = specialEffects[i]
        if 2 == specialEffect.type then
          CameraAdditiveEffectManager.Me():StartShake(specialEffect.range, specialEffect.time, specialEffect.curve)
        end
      end
    end
  end
  if actionPlayed then
    self.fireCount = skillInfo:GetFireCount(creature)
  else
    self.fireCount = 1
  end
  return true, actionPlayed, attackSpeed
end
function SkillLogic_Base.CheckExtraDirMove(logicTransform, arg)
  if logicTransform ~= nil then
    ServiceSkillProxy.Instance:CallSyncDestPosSkillCmd(arg, logicTransform.currentPosition)
  end
end
function SkillLogic_Base:CreateHitTargetWorker(creature, phaseData, assetRole, skillInfo, targetIndex)
  local hitWorker = SkillHitWorker.Create()
  hitWorker:Init(skillInfo, creature:GetPosition(), creature.data and creature.data.id or 0, assetRole:GetWeaponID())
  hitWorker:SetForceEffectPath(skillInfo:GetMainHitEffectPath(creature))
  hitWorker:SetHitedTargetGoPos(phaseData:GetHitedTargetPos())
  local targetGUID, damageType, damage, shareDamageInfos, damageCount = phaseData:GetTarget(targetIndex)
  hitWorker:AddTarget(targetGUID, damageType, damage, shareDamageInfos, self:GetComboDamageLabel(targetIndex), damageCount)
  return hitWorker
end
function SkillLogic_Base:CreateHitMultiTargetWorker(creature, phaseData, assetRole, skillInfo, hideDamage)
  local hitWorker = SkillHitWorker.Create()
  hitWorker:Init(skillInfo, creature:GetPosition(), creature.data and creature.data.id or 0, assetRole:GetWeaponID())
  hitWorker:SetForceEffectPath(skillInfo:GetMainHitEffectPath(creature))
  hitWorker:SetHitedTargetGoPos(phaseData:GetHitedTargetPos())
  local targetCount = phaseData:GetTargetCount()
  if targetCount > 0 then
    for i = 1, targetCount do
      local targetGUID, damageType, damage, shareDamageInfos, damageCount = phaseData:GetTarget(i)
      if hideDamage then
        damageCount = 0
      end
      hitWorker:AddTarget(targetGUID, damageType, damage, shareDamageInfos, self:GetComboDamageLabel(i), damageCount)
    end
  end
  return hitWorker
end
local DoEmit = function(self, creature, targetCreature, damageType, damage, fireEP, emitParams, hitWorker, fireEPWeapon, skillInfo)
  if emitParams.single_fire then
    SkillLogic_Base.EmitFire(creature, targetCreature, nil, fireEP, emitParams, hitWorker, false, 1, 1, fireEPWeapon, skillInfo)
  else
    local skillInfo = hitWorker:GetSkillInfo()
    local emitCount = skillInfo:GetDamageCount(creature, targetCreature, damageType, damage)
    if emitCount > 1 then
      local targetCount = hitWorker:GetTargetCount()
      for i = 1, targetCount do
        hitWorker:SetTargetComboDamageLabel(i, self:CreateComboDamageLabel(i))
      end
      local comboEmitArgs = SkillComboEmitWorker.GetArgs()
      comboEmitArgs[1] = creature.data.id
      comboEmitArgs[2] = fireEP
      comboEmitArgs[3] = targetCreature
      comboEmitArgs[4] = emitParams
      comboEmitArgs[5] = hitWorker
      comboEmitArgs[6] = emitCount
      Game.SkillWorkerManager:CreateWorker_ComboEmit(comboEmitArgs)
      SkillComboEmitWorker.ClearArgs(comboEmitArgs)
    else
      SkillLogic_Base.EmitFire(creature, targetCreature, nil, fireEP, emitParams, hitWorker, true, 1, 1, fireEPWeapon, skillInfo)
    end
  end
end
local Emit = function(self, creature, phaseData, assetRole, skillInfo, fireEP, emitParams)
  local targetCount = phaseData:GetTargetCount()
  if targetCount <= 0 then
    return
  end
  local targetGUID, damageType, damage = phaseData:GetTarget(1)
  local targetCreature = FindCreature(targetGUID)
  if nil == targetCreature then
    return
  end
  local fireEPWeapon = skillInfo:GetFireEPWeapon()
  if emitParams.multi_target then
    for i = 1, targetCount do
      targetGUID, damageType, damage = phaseData:GetTarget(i)
      targetCreature = FindCreature(targetGUID)
      if targetCreature ~= nil then
        local hitWorker = SkillLogic_Base.CreateHitTargetWorker(self, creature, phaseData, assetRole, skillInfo, i)
        hitWorker:AddRef()
        DoEmit(self, creature, targetCreature, damageType, damage, fireEP, emitParams, hitWorker, fireEPWeapon, skillInfo)
        hitWorker:SubRef()
      end
    end
  else
    local hitWorker = SkillLogic_Base.CreateHitMultiTargetWorker(self, creature, phaseData, assetRole, skillInfo)
    hitWorker:AddRef()
    DoEmit(self, creature, targetCreature, damageType, damage, fireEP, emitParams, hitWorker, fireEPWeapon, skillInfo)
    hitWorker:SubRef()
  end
end
function SkillLogic_Base:Fire(creature)
  local phaseData = self.phaseData
  local skillInfo = self.info
  if skillInfo:NeedPassiveFire() then
    return
  end
  local targetCount = phaseData:GetTargetCount()
  if targetCount > 0 then
    local assetRole = creature.assetRole
    local fireIndex = self.fireIndex
    local fireCount = self.fireCount
    local fireEP = skillInfo:GetFireEP(creature)
    local fireEPWeapon = skillInfo:GetFireEPWeapon()
    local effectPath, lodLevel, priority, effectType = skillInfo:GetFireEffectPath(creature)
    if nil ~= effectPath then
      local effect
      if fireEPWeapon then
        local isfollow = skillInfo:GetFollowWeaponEp()
        local lefteffect, righteffect = assetRole:FireEffectOnWeaponEP(effectPath, fireEPWeapon, isfollow, lodLevel, priority, effectType)
        if lefteffect then
          lefteffect:ResetLocalEulerAnglesXYZ(0, creature:GetAngleY(), 0)
        end
        if righteffect then
          righteffect:ResetLocalEulerAnglesXYZ(0, creature:GetAngleY(), 0)
        end
      else
        effect = assetRole:PlayEffectOneShotAt(effectPath, fireEP, nil, nil, nil, nil, nil, lodLevel, priority, effectType)
        if effect ~= nil then
          effect:ResetLocalEulerAnglesXYZ(0, creature:GetAngleY(), 0)
        end
      end
    end
    local sePath = skillInfo:GetFireSEPath(creature)
    if nil ~= sePath then
      assetRole:PlaySEOneShotOn(sePath, AudioSourceType.SKILL_Fire)
    end
    local emitParams = skillInfo:GetEmitParams(creature)
    if nil ~= emitParams then
      Emit(self, creature, phaseData, assetRole, skillInfo, fireEP, emitParams)
    else
      local hideDamage = skillInfo:GetHideDamage()
      if not hideDamage then
        local hitWorker = SkillLogic_Base.CreateHitMultiTargetWorker(self, creature, phaseData, assetRole, skillInfo, hideDamage)
        hitWorker:Work(fireIndex, fireCount)
        hitWorker:Destroy()
      end
    end
  end
  local specialEffects = skillInfo:GetSpecialFireEffects(creature)
  if specialEffects ~= nil then
    for i = 1, #specialEffects do
      local specialEffect = specialEffects[i]
      if specialEffect.type == 1 then
        if specialEffect.myself == nil or creature == Game.Myself then
          CameraAdditiveEffectManager.Me():StartShake(specialEffect.range, specialEffect.time, specialEffect.curve)
        end
      elseif specialEffect.type == 2 and targetCount > 0 then
        local mainTargetGUID = phaseData:GetTarget(1)
        if creature == Game.Myself or mainTargetGUID == Game.Myself.data.id then
          CameraAdditiveEffectManager.Me():StartShake(specialEffect.range, specialEffect.time, specialEffect.curve)
        end
      end
    end
  end
end
function SkillLogic_Base.PassiveFire(creature, phaseData, skillInfo)
  if not creature or not phaseData or not skillInfo then
    return
  end
  local skillID = phaseData:GetSkillID()
  local targetCount = phaseData:GetTargetCount()
  if targetCount > 0 then
    local assetRole = creature.assetRole
    local fireIndex = 1
    local fireCount = skillInfo:GetFireCount(creature)
    local fireEP = skillInfo:GetFireEP(creature)
    local fireEPWeapon = skillInfo:GetFireEPWeapon()
    local effectPath, lodLevel, priority, effectType = skillInfo:GetFireEffectPath(creature)
    if nil ~= effectPath then
      local effect
      if fireEPWeapon then
        local lefteffect, righteffect = assetRole:FireEffectOnWeaponEP(effectPath, fireEPWeapon, nil, lodLevel, priority, effectType)
        if lefteffect then
          lefteffect:ResetLocalEulerAnglesXYZ(0, creature:GetAngleY(), 0)
        end
        if righteffect then
          righteffect:ResetLocalEulerAnglesXYZ(0, creature:GetAngleY(), 0)
        end
      else
        effect = assetRole:PlayEffectOneShotAt(effectPath, fireEP, nil, nil, nil, nil, nil, lodLevel, priority, effectType)
        if effect ~= nil then
          effect:ResetLocalEulerAnglesXYZ(0, creature:GetAngleY(), 0)
        end
      end
    end
    local sePath = skillInfo:GetFireSEPath(creature)
    if nil ~= sePath then
      assetRole:PlaySEOneShotOn(sePath, AudioSourceType.SKILL_Fire)
    end
    local emitParams = skillInfo:GetEmitParams(creature)
    if nil ~= emitParams then
      Emit(creature.skill, creature, phaseData, assetRole, skillInfo, fireEP, emitParams)
      creature.skill:_DestroyComboDamageLabels(creature)
    else
      local hitWorker = SkillLogic_Base.CreateHitMultiTargetWorker(creature.skill, creature, phaseData, assetRole, skillInfo)
      hitWorker:Work(fireIndex, fireCount)
      hitWorker:Destroy()
    end
  end
  local specialEffects = skillInfo:GetSpecialFireEffects(creature)
  if specialEffects ~= nil then
    for i = 1, #specialEffects do
      local specialEffect = specialEffects[i]
      if specialEffect.type == 1 then
        if specialEffect.myself == nil or creature == Game.Myself then
          CameraAdditiveEffectManager.Me():StartShake(specialEffect.range, specialEffect.time, specialEffect.curve)
        end
      elseif specialEffect.type == 2 and targetCount > 0 then
        local mainTargetGUID = phaseData:GetTarget(1)
        if creature == Game.Myself or mainTargetGUID == Game.Myself.data.id then
          CameraAdditiveEffectManager.Me():StartShake(specialEffect.range, specialEffect.time, specialEffect.curve)
        end
      end
    end
  end
end
function SkillLogic_Base:Update_Cast(time, deltaTime, creature)
  return true
end
function SkillLogic_Base:Update_Attack(time, deltaTime, creature)
  return true
end
function SkillLogic_Base.OnAttackFinished(creatureGUID, skillInstanceID)
  local creature = FindCreature(creatureGUID)
  if nil == creature then
    return
  end
  if creature.skill.instanceID ~= skillInstanceID then
    return
  end
  creature.skill:End(creature)
end
function SkillLogic_Base:Client_PreUpdate_Cast(time, deltaTime, creature)
  return true
end
function SkillLogic_Base:Client_PreUpdate_FreeCast(time, deltaTime, creature)
  return true
end
function SkillLogic_Base:Client_PreUpdate_Attack(time, deltaTime, creature)
  return true
end
function SkillLogic_Base:Client_DeterminTargets(creature)
  self.phaseData:ClearTargets()
  if self.info:NoSelect(creature) then
    return
  end
  local maxCount = self.info:GetTargetsMaxCount(creature)
  if maxCount <= 0 then
    return
  end
  local skillInfo = self.info
  if skillInfo:TargetIncludeSelf(creature) then
    ArrayPushBack(tempCreatureArray, creature)
  end
  local sortFunc
  local teamRange = 0
  if skillInfo:CheckTeamPriority() then
    teamRange = skillInfo:GetTargetRange(creature)
  else
    teamRange = skillInfo:TargetIncludeTeamRange(creature)
    sortFunc = SkillLogic_Base.SortComparator_TeamFirstDistance
  end
  skillInfo.LogicClass.Client_DoDeterminTargets(self, creature, tempCreatureArray, maxCount, sortFunc)
  if skillInfo:IsRandomSelect() then
    SkillLogic_Base.ShuffleTargets(tempCreatureArray, #tempCreatureArray)
  end
  if teamRange > 0 then
    local _TeamProxy = TeamProxy.Instance
    if nil ~= _TeamProxy.myTeam then
      local args = CreateArray()
      ArrayPushBack(args, skillInfo)
      ArrayPushBack(args, creature)
      _TeamProxy:GetMemberCreatureArrayInRange(teamRange, tempCreatureArray, CheckTarget, args)
      DestroyArray(args)
    end
    local boki = BokiProxy.Instance:GetSceneBoki()
    if boki ~= nil and skillInfo:CheckTarget(creature, boki) and VectorUtility.DistanceXZ_Square(boki:GetPosition(), Game.Myself:GetPosition()) < teamRange * teamRange then
      TableUtility.ArrayPushBack(tempCreatureArray, boki)
    end
  end
  local targetCount = #tempCreatureArray
  if targetCount > 0 then
    ArrayUnique(tempCreatureArray)
    targetCount = #tempCreatureArray
    if maxCount < targetCount then
      targetCount = maxCount
    end
    local removedCount = 0
    for i = targetCount, 1, -1 do
      local targetCreature = tempCreatureArray[i]
      if targetCreature.data:NoPicked() or targetCreature.data:NoAttacked() or targetCreature:NoAttackedByTarget(Game.Myself) then
        table.remove(tempCreatureArray, i)
        removedCount = removedCount + 1
      elseif targetCreature.data:CanNotBeSkillTargetByEnemy() and targetCreature.data:GetCamp() == _RoleDefines_Camp.ENEMY then
        table.remove(tempCreatureArray, i)
        removedCount = removedCount + 1
      elseif skillInfo:TargetExcludeSelf(creature) and targetCreature == creature then
        table.remove(tempCreatureArray, i)
        removedCount = removedCount + 1
      end
    end
    targetCount = targetCount - removedCount
    if targetCount > 0 then
      local priorityNpcIDs = skillInfo:GetPriorityNpcIDs()
      if priorityNpcIDs ~= nil then
        for i = 1, #priorityNpcIDs do
          tempTable[priorityNpcIDs[i]] = 1
        end
        table.sort(tempCreatureArray, SortComparator_PriorityNpc)
        TableClear(tempTable)
      end
      local skillID = skillInfo:GetSkillID()
      local phaseData = self.phaseData
      for i = 1, targetCount do
        local targetCreature = tempCreatureArray[i]
        local damageType, damage, shareDamageInfos = SkillLogic_Base.CalcDamage(skillID, creature, targetCreature, i, targetCount)
        local damageCount = skillInfo:GetDamageCount(creature, targetCreature, damageType, damage)
        phaseData:AddTarget(targetCreature.data.id, damageType, damage, shareDamageInfos, damageCount)
      end
    end
    ArrayClear(tempCreatureArray)
  end
end
function SkillLogic_Base:Client_DoDeterminTargets(creature, creatureArray, maxCount, sortFunc)
  return 0
end
function SkillLogic_Base.ShuffleTargets(creatureArray, maxCount)
  math.randomseed(tostring(os.time()):reverse():sub(1, 7))
  for i, v in pairs(creatureArray) do
    local r = math.random(maxCount)
    local temp = creatureArray[i]
    creatureArray[i] = creatureArray[r]
    creatureArray[r] = temp
  end
end
function SkillLogic_Base:CalSpeicalAttackMove(creature)
  local phaseData = self.phaseData
  phaseData:ClearGoPos()
  local skillInfo = self.info
  if skillInfo:NoAttackEffectMove(creature) then
    return
  end
  local specialEffects = skillInfo:GetSpecialAttackEffects(creature)
  if not specialEffects then
    return
  end
  for i = 1, #specialEffects do
    local specialEffect = specialEffects[i]
    if 1 == specialEffect.type then
      local dirMoveAngleY
      local dirMoveDistance = 0
      if specialEffect.keepDistance ~= nil then
        local pos
        if skillInfo:GetTargetType(creature) == SkillTargetType.Point then
          pos = phaseData:GetPosition()
        elseif 0 < phaseData:GetTargetCount() then
          local target = phaseData:GetTarget(1)
          if target ~= nil then
            target = SceneCreatureProxy.FindCreature(target)
            if target ~= nil then
              pos = phaseData:GetPosition()
            end
          end
        end
        if pos ~= nil then
          local distance = VectorUtility.DistanceXZ(creature:GetPosition(), pos)
          if distance > specialEffect.keepDistance then
            dirMoveDistance = distance - specialEffect.keepDistance
          end
        end
      elseif specialEffect.pointSprint then
        local pos
        if skillInfo:GetTargetType(creature) == SkillTargetType.Point then
          pos = phaseData:GetPosition()
        end
        if pos then
          local distance = VectorUtility.DistanceXZ(creature:GetPosition(), pos)
          local launchRange = skillInfo:GetLaunchRange(creature)
          dirMoveDistance = distance > launchRange and launchRange or distance
          dirMoveAngleY = phaseData:GetAngleY()
        end
      elseif specialEffect.target_behind ~= nil then
        local pos
        if 0 < phaseData:GetTargetCount() then
          local target = phaseData:GetTarget(1)
          if target ~= nil then
            target = SceneCreatureProxy.FindCreature(target)
            if target ~= nil then
              pos = phaseData:GetPosition()
            end
          end
        end
        if pos ~= nil then
          local distance = VectorUtility.DistanceXZ(creature:GetPosition(), pos)
          dirMoveDistance = distance + specialEffect.target_behind
        end
      else
        local dynamic = skillInfo:GetSkillType(creature) == SkillType.DirectSpurt and 0 < phaseData:GetTargetCount()
        local sprint = specialEffect.pointSprint and specialEffect.pointSprint == 1
        dirMoveDistance = dynamic and VectorUtility.DistanceXZ(creature:GetPosition(), phaseData:GetPosition()) or sprint and skillInfo:GetLaunchRange(creature) or specialEffect.distance
      end
      local skillAngleY = phaseData:GetAngleY()
      if nil == skillAngleY then
        skillAngleY = creature.logicTransform.currentAngleY
      end
      if "back" == specialEffect.direction then
        dirMoveAngleY = NumberUtility.Repeat(skillAngleY + 180, 360)
      elseif "forward" == specialEffect.direction then
        dirMoveAngleY = skillAngleY
      end
      if dirMoveDistance > 0 then
        local currentPosition = creature:GetPosition()
        LuaVector3.Better_Set(dirVector3, 0, 0, 1)
        VectorUtility.SelfAngleYToVector3(dirVector3, dirMoveAngleY)
        local x = currentPosition[1] + dirVector3[1] * dirMoveDistance
        local y = currentPosition[2] + dirVector3[2] * dirMoveDistance
        local z = currentPosition[3] + dirVector3[3] * dirMoveDistance
        LuaVector3.Better_Set(tempVector3, x, y, z)
        NavMeshUtility.SelfSample(tempVector3, 0.1)
        local ret, x, y, z = NavMeshUtils.RaycastDirection(currentPosition, dirVector3, dirMoveDistance)
        if ret and not specialEffect.ignoreTerrain then
          LuaVector3.Better_Set(tempVector3, x, y, z)
          NavMeshUtility.SelfSample(tempVector3, 0.1)
        end
        phaseData:AddGoPos(tempVector3[1], tempVector3[2], tempVector3[3], specialEffect.speed, specialEffect.direction)
      end
    end
  end
end
function SkillLogic_Base:CalSpeicalHitedMove(creature)
  local phaseData = self.phaseData
  phaseData:ClearHitedTarget_GoPos()
  local skillInfo = self.info
  local specialEffects = skillInfo:GetSpecialHitEffects(creature)
  if nil == specialEffects or #specialEffects <= 0 then
    return
  end
  if skillInfo:NoRepelMajor(creature) then
    return
  end
  local targetCount = phaseData:GetTargetCount()
  if targetCount == 0 then
    return
  end
  local pvpMap = Game.MapManager:IsPVPMode()
  local isGVG = Game.MapManager:IsPVPMode_GVGDetailed()
  local creaturePosition = creature:GetPosition()
  local guid, damageType, damage, shareDamageInfos, damageCount, skipHitEffect, targetCreature
  for i = 1, targetCount do
    guid, damageType, damage, shareDamageInfos, damageCount = phaseData:GetTarget(i)
    targetCreature = FindCreature(guid)
    skipHitEffect = false
    if i ~= 1 and skillInfo:OnlyRepelMajor() then
      skipHitEffect = true
    end
    for j = 1, #specialEffects do
      local specialEffect = specialEffects[j]
      if 1 == specialEffect.type and (not skillInfo:NoHitEffectMove(targetCreature, damageType, damage) or skillInfo:IgnoreNoHit()) and (not pvpMap or 1 ~= specialEffect.no_pvp) and (not isGVG or "back" ~= specialEffect.direction) and not skipHitEffect then
        local targetCreaturePosition = targetCreature:GetPosition()
        local dirMoveAngleY, dirMoveDistance, specialEffectDistance
        if type(specialEffect.distance) == "table" then
          local distanceParams = specialEffect.distance
          specialEffectDistance = CommonFun.calcBuffValue(creature.data, targetCreature.data, distanceParams.type, distanceParams.a, distanceParams.b, distanceParams.c, distanceParams.d, level, 0)
        else
          specialEffectDistance = specialEffect.distance
        end
        local lockTargetPos
        if "back" == specialEffect.direction then
          dirMoveAngleY = VectorHelper.GetAngleByAxisY(creaturePosition, targetCreaturePosition)
          dirMoveDistance = specialEffectDistance
        elseif "forward" == specialEffect.direction then
          dirMoveAngleY = VectorHelper.GetAngleByAxisY(targetCreaturePosition, creaturePosition)
          dirMoveDistance = math.min(specialEffectDistance, VectorUtility.DistanceXZ(creaturePosition, targetCreaturePosition))
        elseif "back_locktarget" == specialEffect.direction then
          local lockTarget = Game.Myself:GetLockTarget()
          if lockTarget and lockTarget ~= targetCreature then
            lockTargetPos = lockTarget:GetPosition()
            dirMoveAngleY = VectorHelper.GetAngleByAxisY(targetCreaturePosition, lockTarget:GetPosition())
            dirMoveDistance = specialEffectDistance
          else
            dirMoveAngleY, dirMoveDistance = nil, nil
          end
        elseif "forward_locktarget" == specialEffect.direction then
          local lockTarget = Game.Myself:GetLockTarget()
          if lockTarget and lockTarget ~= targetCreature then
            lockTargetPos = lockTarget:GetPosition()
            dirMoveAngleY = VectorHelper.GetAngleByAxisY(targetCreaturePosition, lockTarget:GetPosition())
            dirMoveDistance = math.min(specialEffectDistance, VectorUtility.DistanceXZ(lockTarget:GetPosition(), targetCreaturePosition))
          else
            dirMoveAngleY, dirMoveDistance = nil, nil
          end
        end
        if dirMoveDistance then
          local keepDistance = specialEffect.keepDistance
          if not keepDistance and specialEffect.randomDistance then
            keepDistance = math.random() * specialEffect.randomDistance
          end
          if keepDistance ~= nil then
            if lockTargetPos then
              local distance = VectorUtility.DistanceXZ(targetCreature:GetPosition(), lockTargetPos)
              if keepDistance < distance then
                dirMoveDistance = math.max(0, distance - keepDistance)
              end
            else
              local pos
              if skillInfo:GetTargetType(creature) == SkillTargetType.Point then
                pos = phaseData:GetPosition()
              elseif 0 < phaseData:GetTargetCount() then
                local target = phaseData:GetTarget(1)
                if target ~= nil then
                  target = SceneCreatureProxy.FindCreature(target)
                  if target ~= nil then
                    pos = phaseData:GetPosition()
                  end
                end
              end
              if pos ~= nil then
                local distance = VectorUtility.DistanceXZ(creature:GetPosition(), pos)
                if keepDistance < distance then
                  dirMoveDistance = distance - keepDistance
                end
              end
            end
          end
        end
        if dirMoveDistance and dirMoveAngleY then
          LuaVector3.Better_Set(dirVector3, 0, 0, 1)
          VectorUtility.SelfAngleYToVector3(dirVector3, dirMoveAngleY)
          local currentPosition = targetCreaturePosition
          local x = currentPosition[1] + dirVector3[1] * dirMoveDistance
          local y = currentPosition[2] + dirVector3[2] * dirMoveDistance
          local z = currentPosition[3] + dirVector3[3] * dirMoveDistance
          LuaVector3.Better_Set(tempVector3, x, y, z)
          NavMeshUtility.SelfSample(tempVector3, 0.1)
          local ret, x, y, z = NavMeshUtils.RaycastDirection(currentPosition, dirVector3, dirMoveDistance)
          if ret then
            LuaVector3.Better_Set(tempVector3, x, y, z)
            NavMeshUtility.SelfSample(tempVector3, 0.1)
          end
          phaseData:AddHitedTargetPos(tempVector3[1], tempVector3[2], tempVector3[3], specialEffect.speed, specialEffect.direction, guid)
        end
      end
    end
  end
end
function SkillLogic_Base:CheckCombo(creature)
  local skillInfo = self.info
  local resetID = skillInfo:GetResetComboID()
  if resetID then
    local skill = SkillProxy.Instance:GetLearnedSkillBySortID(resetID)
    if skill then
      Game.SkillComboManager:OnEnd(skill:GetRollbackComboID())
      Game.SkillClickUseManager:_CancelWaitForCombo()
    end
  end
end
