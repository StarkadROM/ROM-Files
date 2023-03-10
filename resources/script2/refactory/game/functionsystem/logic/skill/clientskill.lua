ClientSkill = class("ClientSkill", SkillBase)
local FindCreature = SceneCreatureProxy.FindCreature
function ClientSkill:ctor()
  ClientSkill.super.ctor(self)
  self.targetCreatureGUID = 0
  self.targetPosition = LuaVector3.Zero()
  self.allowInterrupted = false
  self.castTime = 0
  self.castTimeElapsed = 0
  self.random = 0
  self:_ResetAttackInfo()
end
function ClientSkill:IsClientSkill()
  return true
end
function ClientSkill:GetCastTime(creature)
  return self.castTime
end
function ClientSkill:Launch(targetCreature, targetPosition, creature, ignoreCast, invalid, isAttackSkill, autoInterrupt, isTrigger)
  if nil == creature.data.randomFunc then
    return false
  end
  self.isAttackSkill = isAttackSkill
  self.autoInterrupt = autoInterrupt
  if nil ~= targetCreature then
    self.targetCreatureGUID = targetCreature.data.id
  else
    self.targetCreatureGUID = 0
  end
  local p
  if nil ~= targetPosition then
    p = targetPosition
    self.phaseData:SetPosition(targetPosition)
    local angleY = VectorHelper.GetAngleByAxisY(creature:GetPosition(), targetPosition)
    self.phaseData:SetAngleY(angleY)
  else
    if nil ~= targetCreature and self.info:PlaceTarget(creature) then
      p = targetCreature:GetPosition()
    else
      p = creature:GetPosition()
    end
    self.phaseData:SetPosition(p)
    self.phaseData:SetAngleY(nil)
  end
  LuaVector3.Better_Set(self.targetPosition, p[1], p[2], p[3])
  if invalid then
    self:_SwitchToInvalid(creature)
  elseif ignoreCast or self.info:CheckInstantAttack() and creature:Client_IsMoving() then
    self:_SwitchToAttack(creature, ignoreCast)
  else
    self.castTime, self.allowInterrupted = self.info:GetCastInfo(creature)
    if self.castTime > 0.01 then
      if not ignoreCast and not self.info:IsIgnoreFreeCast() and creature.data:FreeCast() then
        self:_SwitchToFreeCast(creature)
      else
        self:_SwitchToCast(creature)
      end
    else
      self:_SwitchToAttack(creature)
    end
  end
  if self.info:AllowAttackInterrupted() then
    self.allowInterrupted = true
  end
  if self.running then
    Game.SkillComboManager:OnLaunch(self:GetSkillID())
    Game.SkillClickUseManager:SetWaitForCombo(self:GetSkillID())
  end
  return self.running, self.allowInterrupted
end
function ClientSkill:Interrupt(creature)
  if not self.running then
    return
  end
  if not self.info:CheckCanBeInterrupted() then
    return
  end
  ClientSkill.super.Interrupt(self, creature)
  Game.SkillComboManager:OnInterrupt(self:GetSkillID())
  if self.autoInterrupt and self.info:NoAttackSpeed() then
    self:End(creature)
  end
end
function ClientSkill:InterruptCast(creature)
  if self.running and self.phaseData:GetSkillPhase() == SkillPhase.Cast then
    self:End(creature)
  end
end
function ClientSkill:CheckTargetCreature(creature)
  local targetCreature = FindCreature(self.targetCreatureGUID)
  if nil == targetCreature then
    return false
  end
  if not self:CheckTargetPosition(creature, targetCreature:GetPosition()) then
    return false
  end
  return self.info:CheckTarget(creature, targetCreature)
end
function ClientSkill:CheckTargetPosition(creature, targetPosition)
  local launchRange = self.info:GetLaunchRange(creature)
  if launchRange > 0 then
    local testRange = launchRange * 1.5
    local currentPosition = creature:GetPosition()
    if VectorUtility.DistanceXZ_Square(currentPosition, targetPosition) > testRange * testRange then
      return false
    end
  end
  return true
end
function ClientSkill:_SetPhase(phase, creature)
  self:_Clear(creature)
  self.phaseData:SetSkillPhase(phase)
end
function ClientSkill:_NotifyServer(creature)
  local phaseData = self.phaseData
  if SkillPhase.Attack == phaseData:GetSkillPhase() then
    local targetCount = phaseData:GetTargetCount()
    for i = 1, targetCount do
      local guid, _, _ = phaseData:GetTarget(i)
      local targetCreature = SceneCreatureProxy.FindCreature(guid)
      if nil ~= targetCreature and nil ~= targetCreature.data then
        local targetCamp = targetCreature.data:GetCamp()
        if RoleDefines_Camp.ENEMY == targetCamp then
          creature:Logic_SetSkillState(guid)
          break
        end
      end
    end
  end
  local isTrigger = self:IsTriggerKickSkill()
  creature:Client_UseSkillHandler(self.random, phaseData, self.targetCreatureGUID, isTrigger)
end
function ClientSkill:_OnLaunch(creature)
  ClientSkill.super._OnLaunch(self, creature)
  creature:Logic_OnSkillLaunch(self.info:GetSkillID())
end
function ClientSkill:_OnAttack(creature)
  ClientSkill.super._OnAttack(self, creature)
  creature:Logic_OnSkillAttack(self.info:GetSkillID())
end
function ClientSkill:SetSkillID(skillID)
  self.phaseData:Reset(skillID)
  ClientSkill.super.SetSkillID(self, skillID)
end
function ClientSkill:IsAttackSkill(creature)
  return self.isAttackSkill
end
function ClientSkill:_SwitchToCast(creature)
  self.castTimeElapsed = 0
  self:_SetPhase(SkillPhase.Cast, creature)
  ClientSkill.super._SwitchToCast(self, creature)
  local phase = self.phaseData:GetSkillPhase()
  if SkillPhase.Cast == phase then
    self:_NotifyServer(creature)
  end
end
function ClientSkill:_SwitchToFreeCast(creature)
  self:_SetPhase(SkillPhase.FreeCast, creature)
  ClientSkill.super._SwitchToFreeCast(self, creature)
  local phase = self.phaseData:GetSkillPhase()
  if SkillPhase.FreeCast == phase then
    self:_NotifyServer(creature)
  end
end
function ClientSkill:_SwitchToLeadComplete(creature)
  self.info.LogicClass.Client_DeterminTargets(self, creature)
  self.info.LogicClass.CalSpeicalAttackMove(self, creature)
  self.info.LogicClass.CalSpeicalHitedMove(self, creature)
  self.info.LogicClass.CheckCombo(self, creature)
  self.allowInterrupted = true
  self:_SetPhase(SkillPhase.LeadComplete, creature)
  self:_OnPhaseChanged(creature)
  self:_NotifyServer(creature)
end
function ClientSkill:_SwitchToAttack(creature, ignoreCast, serverAttack)
  self.random = creature.data.randomFunc.index
  self.info.LogicClass.Client_DeterminTargets(self, creature)
  self.info.LogicClass.CalSpeicalAttackMove(self, creature)
  self.info.LogicClass.CalSpeicalHitedMove(self, creature)
  self.info.LogicClass.CheckCombo(self, creature)
  self.allowInterrupted = false
  self:_SetPhase(SkillPhase.Attack, creature)
  ClientSkill.super._SwitchToAttack(self, creature, ignoreCast)
  local phase = self.phaseData:GetSkillPhase()
  if SkillPhase.Attack == phase then
    local count = self:_GetFixAttackCount(creature)
    count = count and count + 1 or 1
    for i = 1, count do
      self:_NotifyServer(creature)
    end
  end
end
function ClientSkill:_SwitchToInvalid(creature)
  self.allowInterrupted = false
  self:_SetPhase(SkillPhase.Invalid, creature)
  ClientSkill.super._SwitchToInvalid(self, creature)
  local phase = self.phaseData:GetSkillPhase()
  if SkillPhase.Invalid == phase then
    self:_NotifyServer(creature)
  end
end
function ClientSkill:_End(creature, ignoreCast)
  local phase = self.phaseData:GetSkillPhase()
  self.phaseData:SetSkillPhase(SkillPhase.None)
  if SkillPhase.Cast == phase or ignoreCast then
    self:_NotifyServer(creature)
  end
  if self.info:GetAttackUIEffectPath() then
    GameFacade.Instance:sendNotification(UIEvent.RemoveFullScreenEffect)
  end
  Game.SkillComboManager:OnEnd(self:GetSkillID(), self.autoInterrupt)
  ClientSkill.super._End(self, creature)
end
function ClientSkill:_ResetAttackInfo()
  self.attackTime = 0
  self.attackEndTime = -1
  self.attackFrameCount = -1
end
function ClientSkill:UpdateAttackInfo(time)
  if not self.isAttackSkill then
    return
  end
  self.attackEndTime = time
  self.attackFrameCount = UnityFrameCount
end
function ClientSkill:_GetFixAttackCount(creature)
  local frameCount = self.attackFrameCount
  if frameCount == -1 then
    return
  end
  if not self.isAttackSkill then
    self:_ResetAttackInfo()
    return
  end
  if UnityFrameCount - frameCount > 1 then
    self:_ResetAttackInfo()
    return
  end
  local attackTime = self.attackTime
  attackTime = attackTime + (UnityTime - self.attackEndTime)
  local attackInterval = creature.data:GetAttackInterval()
  if attackTime >= attackInterval then
    self:_ResetAttackInfo()
    return 1
  end
  self.attackTime = attackTime
  return
end
function ClientSkill:SetAttackWorkerDir(dir)
  local attackWorker = self.attackWorker
  if attackWorker ~= nil and attackWorker.SetWorkerDir ~= nil then
    attackWorker:SetWorkerDir(dir)
  end
end
function ClientSkill:Update_Cast(time, deltaTime, creature)
  if not self.info.LogicClass.Client_PreUpdate_Cast(self, time, deltaTime, creature) then
    self:_End(creature)
    return false
  end
  if ClientSkill.super.Update_Cast(self, time, deltaTime, creature) then
    self.castTimeElapsed = self.castTimeElapsed + deltaTime
    if self.castTime > self.castTimeElapsed then
      return true
    elseif self.info:IsGuideCast(creature) or self.info:InfiniteCast(creature) then
      self:_SwitchToLeadComplete(creature)
      return true
    end
  end
  return false
end
function ClientSkill:Update_LeadComplete(time, deltaTime, creature)
  if self.info:IsGuideCast(creature) then
    return false
  end
  if not self.info.LogicClass.Client_PreUpdate_Cast(self, time, deltaTime, creature) then
    return false
  end
  return true
end
function ClientSkill:Update_Attack(time, deltaTime, creature)
  if not self.info.LogicClass.Client_PreUpdate_Attack(self, time, deltaTime, creature) then
    return false
  end
  return ClientSkill.super.Update_Attack(self, time, deltaTime, creature)
end
function ClientSkill:Update(time, deltaTime, creature)
  if not self.running then
    return
  end
  local skillPhase = self.phaseData:GetSkillPhase()
  if SkillPhase.LeadComplete == skillPhase then
    if not self:Update_LeadComplete(time, deltaTime, creature) then
      self:_End(creature)
    end
  else
    ClientSkill.super.Update(self, time, deltaTime, creature)
  end
end
function ClientSkill:GetCurChantTime()
  return self.castTimeElapsed * 1000
end
function ClientSkill:IsCastingMoveRunSkill()
  if not self.info or not self.info:CheckInstantAttack() then
    return false
  else
    local skillPhase = self.phaseData:GetSkillPhase()
    return SkillPhase.Cast == skillPhase
  end
end
function ClientSkill:IsCastingShiftPointSkill()
  if not self.info or not self.info:CanShiftPoint() then
    return false
  else
    local skillPhase = self.phaseData:GetSkillPhase()
    return SkillPhase.Cast == skillPhase
  end
end
local helpDisFunc = function(x1, y1, z1, x2, y2, z2)
  local x = x1 - x2
  local y = y1 - y2
  local z = z1 - z2
  return math.sqrt(x * x + y * y + z * z)
end
function ClientSkill:SyncDirMoveFromServer(creature, phaseData)
  local clientPhaseData = self.phaseData
  local attackSpeed = 1
  local sGopos = phaseData.gopos[1]
  if sGopos then
    if not clientPhaseData.gopos[1] then
      do
        local cGopos = {
          0,
          0,
          0
        }
        if 1 < helpDisFunc(cGopos[1], cGopos[2], cGopos[3], sGopos[1], sGopos[2], sGopos[3]) then
          redlog("???????????????attack??????", sGopos[1], sGopos[2], sGopos[3])
          local dirPoint = LuaVector3.New(sGopos[1], sGopos[2], sGopos[3])
          local dirMoveDistance = LuaVector3.Distance(creature:GetPosition(), dirPoint)
          if dirMoveDistance > 0.01 then
            local direction = sGopos[5]
            local dirAngleY = VectorHelper.GetAngleByAxisY(creature:GetPosition(), dirPoint)
            if "forward" == direction then
              dirAngleY = NumberUtility.Repeat(dirAngleY + 180, 360)
            end
            creature.logicTransform:ExtraDirMove(dirAngleY, dirMoveDistance, sGopos[4] * attackSpeed, function(logicTransform, arg)
              SkillLogic_Base.CheckExtraDirMove(logicTransform, arg)
              if effect and skillInfo:ManulDestroy() then
                effect:Destroy()
                creature.skill.attackTimeDuration = 0
              end
              dirPoint:Destroy()
            end, nil, dirPoint, self.info:IsIgnoreTerrain())
          end
        end
      end
    end
  else
  end
  local cHT_Goposes = clientPhaseData.hitedTarget_gopos
  local sHT_Goposes = phaseData.hitedTarget_gopos
  for targetID, sHT_Gopos in pairs(sHT_Goposes) do
    if not cHT_Goposes[targetID] then
      local cHT_Gopos = {
        0,
        0,
        0
      }
    end
    if sHT_Gopos and 1 < helpDisFunc(cHT_Gopos[1], cHT_Gopos[2], cHT_Gopos[3], sHT_Gopos[1], sHT_Gopos[2], sHT_Gopos[3]) then
      local targetCreature = FindCreature(targetID)
      local dirPoint = LuaVector3.New(sHT_Gopos[1], sHT_Gopos[2], sHT_Gopos[3])
      local dirMoveDistance = LuaVector3.Distance(creature:GetPosition(), dirPoint)
      if targetCreature then
        redlog("???????????????hit??????", targetCreature.data.name, sHT_Gopos[1], sHT_Gopos[2], sHT_Gopos[3])
        cHT_Gopos[1], cHT_Gopos[2], cHT_Gopos[3] = sHT_Gopos[1], sHT_Gopos[2], sHT_Gopos[3]
        local direction = sHT_Gopos[5]
        local dirAngleY = VectorHelper.GetAngleByAxisY(creature:GetPosition(), dirPoint)
        if "forward" == direction then
          dirAngleY = NumberUtility.Repeat(dirAngleY + 180, 360)
        end
        targetCreature.logicTransform:ExtraDirMove(dirAngleY, dirMoveDistance, sHT_Gopos[4] * attackSpeed, function(logicTransform, arg)
          SkillLogic_Base.CheckExtraDirMove(logicTransform, arg)
          dirPoint:Destroy()
        end, nil, dirPoint, self.info:IsIgnoreTerrain())
      end
    else
    end
  end
end
function ClientSkill:IsTriggerKickSkill()
  return self.isTrigger
end
function ClientSkill:SetIsTrigger(v)
  self.isTrigger = v
end
