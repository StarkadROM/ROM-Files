local SelfClass = class("SkillAttackWorker_Dash", ReusableObject)
SelfClass.PoolSize = 100
local FindCreature = SceneCreatureProxy.FindCreature
local tempVector3 = LuaVector3.Zero()
local tempVector3_1 = LuaVector3.Zero()
local tempVector3_2 = LuaVector3.Zero()
local AttackActionMaxLength = 3
local DefaultActionAttack = "attack"
local waitForActionWorkerArray = {}
local WorkerFindPredicate = function(worker, workerInstanceID)
  return worker.instanceID == workerInstanceID
end
local OnActionFinished = function(creatureGUID, workerInstanceID)
  local worker, i = TableUtility.ArrayFindByPredicate(waitForActionWorkerArray, WorkerFindPredicate, workerInstanceID)
  if nil ~= worker then
    worker.args[6] = 0
  end
end
function SelfClass.Create(args)
  return ReusableObject.Create(SelfClass, true, args)
end
function SelfClass:ctor()
  self.args = {}
end
function SelfClass:Start(skill, creature)
  local args = self.args
  local logicParams = args[1]
  if logicParams.fireHitWork == nil then
    skill:AddFireIndex()
  end
  local targetPosition = self:GetTargetPosition(skill, creature, true)
  if targetPosition == nil then
    return false
  end
  local assetRole = creature.assetRole
  local skillInfo = skill.info
  creature.logicTransform:LookAt(targetPosition)
  local action = logicParams.action
  if action ~= nil then
    local playActionParams = Asset_Role.GetPlayActionParams(action)
    playActionParams[6] = true
    creature:Logic_PlayAction(playActionParams)
  else
    self:PlayAttackAction(skill, creature)
  end
  local attackEP = skillInfo:GetAttackEP(creature)
  local effectPath, lodLevel, priority, effectType, scale = skillInfo:GetAttackEffectPath(creature)
  if nil ~= effectPath then
    local effect
    if skillInfo:AttackEffectOnRole(creature) then
      effect = assetRole:PlayEffectOneShotOn(effectPath, attackEP, nil, nil, nil, nil, nil, lodLevel, priority, effectType)
    else
      effect = assetRole:PlayEffectOneShotAt(effectPath, attackEP, nil, nil, nil, nil, nil, lodLevel, priority, effectType)
      effect:ResetLocalEulerAnglesXYZ(0, creature:GetAngleY(), 0)
    end
    if effect and scale and scale ~= 1 then
      effect:ResetLocalScaleXYZ(scale, scale, scale)
    end
  end
  effectPath, lodLevel, priority, effectType, scale = skillInfo:GetPreAttackEffectPath(creature)
  if nil ~= effectPath then
    local effect = assetRole:PlayEffectOn(effectPath, skillInfo:GetPreAttackEffectEP(creature), nil, nil, nil, nil, nil, lodLevel, priority, effectType)
    skill:AddEffect(effect)
    if effect and scale and scale ~= 1 then
      effect:ResetLocalScaleXYZ(scale, scale, scale)
    end
  end
  local sePath = skillInfo:GetAttackSEPath(creature)
  if nil ~= sePath then
    assetRole:PlaySEOneShotOn(sePath)
  end
  args[2] = targetGUID
  args[3] = logicParams.initSpeed
  args[4] = logicParams.acceleration
  args[5] = logicParams.speedLimit
  args[6] = -1
  return true
end
function SelfClass:End(skill, creature)
end
function SelfClass:Update(skill, time, deltaTime, creature)
  local args = self.args
  if 0 <= args[6] then
    return time < args[6]
  end
  local targetPosition = self:GetTargetPosition(skill, creature, false, args[2])
  if targetPosition == nil then
    return false
  end
  local logicParams = args[1]
  local currentPosition = creature:GetPosition()
  LuaVector3.Better_Sub(targetPosition, currentPosition, tempVector3)
  LuaVector3.Normalized(tempVector3)
  local keepDistance = logicParams.keepDistance
  if keepDistance ~= nil then
    local distance = LuaVector3.Distance(currentPosition, targetPosition)
    if keepDistance >= distance then
      args[6] = time + AttackActionMaxLength
    else
      LuaVector3.Better_Mul(tempVector3, -keepDistance, tempVector3_2)
      LuaVector3.Add(tempVector3_2, targetPosition)
      targetPosition = tempVector3_2
      self:UpdateDash(time, deltaTime, creature, currentPosition, targetPosition)
    end
  else
    self:UpdateDash(time, deltaTime, creature, currentPosition, targetPosition)
  end
  if 0 < args[6] then
    if logicParams.fireHitWork == nil then
      local hitWorker = SkillLogic_Base.CreateHitMultiTargetWorker(skill, creature, skill.phaseData, creature.assetRole, skill.info)
      hitWorker:Work(1, 1)
      hitWorker:Destroy()
    end
    if args[7] == nil then
      args[7] = false
      self:PlayAttackAction(skill, creature)
    end
    return args[7]
  else
    local minSpeed = args[3]
    local maxSpeed = args[5]
    if minSpeed > maxSpeed then
      local tempSpeed = minSpeed
      minSpeed = maxSpeed
      maxSpeed = tempSpeed
    end
    local newSpeed = args[3] + args[4] * deltaTime
    args[3] = NumberUtility.Clamp(newSpeed, minSpeed, maxSpeed)
  end
  return true
end
function SelfClass:GetTargetPosition(skill, creature, init, targetGUID)
  local phaseData = skill.phaseData
  if skill.info:GetTargetType(creature) == SkillTargetType.Point then
    return phaseData:GetPosition()
  end
  if phaseData:GetTargetCount() <= 0 then
    return nil
  end
  targetGUID = targetGUID or phaseData:GetTarget(1)
  local targetCreature = FindCreature(targetGUID)
  if targetCreature == nil then
    return nil
  end
  local targetPosition
  if self.args[1].no_track == 1 then
    targetPosition = phaseData:GetPosition()
    if nil == targetPosition then
      targetPosition = targetCreature:GetPosition()
      if init then
        phaseData:SetPosition(targetPosition)
      end
    end
  else
    targetPosition = targetCreature:GetPosition()
  end
  return targetPosition
end
function SelfClass:UpdateDash(time, deltaTime, creature, currentPosition, targetPosition)
  local args = self.args
  local deltaDistance = args[3] * deltaTime
  local distance = LuaVector3.Distance(currentPosition, targetPosition)
  if deltaDistance >= distance then
    args[6] = time + AttackActionMaxLength
    deltaDistance = distance
  end
  LuaVector3.Mul(tempVector3, deltaDistance)
  LuaVector3.Better_Add(currentPosition, tempVector3, tempVector3_1)
  creature.logicTransform:PlaceTo(tempVector3_1)
end
function SelfClass:PlayAttackAction(skill, creature)
  local args = self.args
  local assetRole = creature.assetRole
  local actionName = skill.info:GetAttackAction(creature)
  if actionName ~= nil then
    local hasOriginAction = true
    if not assetRole:HasActionIgnoreMount(actionName) then
      actionName = DefaultActionAttack
      hasOriginAction = false
    end
    if hasOriginAction or assetRole:HasActionRaw(actionName) then
      local playActionParams = Asset_Role.GetPlayActionParams(actionName)
      playActionParams[6] = true
      playActionParams[7] = OnActionFinished
      playActionParams[8] = self.instanceID
      args[7] = creature:Logic_PlayAction(playActionParams)
      if args[7] then
        skill.fireCount = skill.info:GetFireCount(creature)
        TableUtility.ArrayPushBack(waitForActionWorkerArray, self)
      end
      Asset_Role.ClearPlayActionParams(playActionParams)
    end
  end
end
function SelfClass:DoConstruct(asArray, args)
  self.args[1] = args
end
function SelfClass:DoDeconstruct(asArray)
  TableUtility.ArrayRemove(waitForActionWorkerArray, self)
  TableUtility.ArrayClearWithCount(self.args, 7)
end
return SelfClass
