local lastAttackTime = 0
local lastSkillTime = 0
local SkillInterval = 1
local SpeicalComboHandler = {
  [2400] = 1,
  [2503] = 2,
  [2515] = 2,
  [2516] = 2,
  [2517] = 2,
  [2523] = 2,
  [2524] = 2,
  [2525] = 2,
  [2526] = 2
}
AI_CMD_Myself_Skill_Run = {}
function AI_CMD_Myself_Skill_Run:Start(time, deltaTime, creature, targetCreature, targetPosition, noLimit, ignoreCast, isAttackSkill, autoInterrupt)
  local skillCanUse
  local skill = creature.skill
  if not noLimit and creature.data:NoAttack() and not isAttackSkil then
    skillCanUse = creature:Logic_CheckSkillCanUseByID(skill:GetSkillID())
    if not skillCanUse then
      return false
    end
  end
  if not noLimit and creature.data:NoSkill() and not isAttackSkill then
    if nil == skillCanUse then
      skillCanUse = creature:Logic_CheckSkillCanUseByID(skill:GetSkillID())
    end
    if not skillCanUse then
      return false
    end
  end
  if not SkillProxy.Instance:SkillCanBeUsedByID(skill:GetSkillID(), true, isAttackSkill) then
    return false
  end
  if self.args[5] and nil ~= targetCreature then
    creature.logicTransform:LookAt(targetCreature:GetPosition())
  end
  local invalid = not isAttackSkill and creature.data:Client_GetProps(MyselfData.ClientProps.DisableSkill)
  local isTrigger = self.args[15]
  local ret, allowInterrupt = skill:Launch(targetCreature, targetPosition, creature, ignoreCast, invalid, isAttackSkill, autoInterrupt, isTrigger)
  if ret then
    if isAttackSkill then
      lastAttackTime = time
    elseif not noLimit and not isTrigger and not creature:IsNoSkillDelay() then
      lastSkillTime = time
    end
    SkillProxy.Instance:SetLastSkillTime(time)
    if allowInterrupt then
      self:SetInterruptLevel(2)
    else
      self:SetInterruptLevel(1)
    end
    return true
  end
  return false
end
function AI_CMD_Myself_Skill_Run:End(time, deltaTime, creature)
  local skill = creature.skill
  skill:UpdateAttackInfo(time)
  skill:End(creature)
  if skill.info:NoWait(creature) then
    creature.ai:SetNoIdleAction()
  elseif not skill.info:NoAttackWait(creature) then
    local endAction = skill.info:GetEndAction(creature)
    if nil ~= endAction and "" ~= endAction then
      creature.ai:SetIdleAction(endAction)
    elseif skill.info:IsMountTransform() then
      creature.ai:SetIdleAction(Asset_Role.ActionName.Idle)
    else
      creature.ai:SetIdleAction(Asset_Role.ActionName.AttackIdle)
      creature:SetAuto_SkillOverAction()
    end
  end
end
function AI_CMD_Myself_Skill_Run:Update(time, deltaTime, creature)
  local skill = creature.skill
  skill:Update(time, deltaTime, creature)
  if skill.interrupt then
    self:SetInterruptLevel(2)
  end
  if not skill.running then
    self:End(time, deltaTime, creature)
  end
end
AI_CMD_Myself_Skill = {}
local SkillCMD = {
  [SkillTargetType.None] = autoImport("AI_CMD_Myself_Skill_TargetNone"),
  [SkillTargetType.Creature] = autoImport("AI_CMD_Myself_Skill_TargetCreature"),
  [SkillTargetType.Point] = autoImport("AI_CMD_Myself_Skill_TargetPoint")
}
local skillCMD
function AI_CMD_Myself_Skill:Construct(args)
  self.args[1] = args[2]
  local targetCreature = args[3]
  if nil ~= targetCreature then
    self.args[2] = targetCreature.data.id
  else
    self.args[2] = 0
  end
  local p = args[4]
  if nil ~= p then
    self.args[3] = LuaVector3.Better_Clone(p)
  else
    self.args[3] = nil
  end
  self.args[4] = args[5]
  self.args[5] = args[6]
  self.args[6] = args[7]
  self.args[7] = args[8]
  self.args[8] = nil
  self.args[9] = args[9]
  self.args[10] = args[10]
  self.args[11] = args[11]
  self.args[12] = args[12]
  self.args[15] = args[15]
  if args[12] then
    self:SetConcurrent(true)
  end
  self.args[14] = args[14]
  return 14
end
function AI_CMD_Myself_Skill:Deconstruct()
  if nil ~= self.args[3] then
    LuaVector3.Destroy(self.args[3])
    self.args[3] = nil
  end
end
function AI_CMD_Myself_Skill:FromServer()
  return self.args[7] or false
end
function AI_CMD_Myself_Skill:AllowInterrupt(other, time, deltaTime, creature)
  if AI_CMD_Myself_Skill ~= other.AIClass then
    return false
  end
  if self.targetType == SkillTargetType.Point and not self.running and not self.isComboSkill then
    return true
  end
  return false
end
function AI_CMD_Myself_Skill:Start(time, deltaTime, creature)
  local args = self.args
  self.targetType = nil
  self.isComboSkill = false
  local info = Game.LogicManager_Skill:GetSkillInfo(args[1])
  local skill = creature.skill
  local isAttackSkill = args[10]
  if isAttackSkill and not info:NoAttackSpeed() then
    local attackInterval = creature.data:GetAttackInterval()
    local interval = time - lastAttackTime
    if attackInterval > interval then
      if not skill.info or not skill.info:NoAttackWait(creature) then
        creature.ai:SetIdleAction(Asset_Role.ActionName.AttackIdle)
      end
      return false
    end
  end
  local interval = time - lastSkillTime
  if not creature:IsNoSkillDelay() and interval < SkillInterval then
    if not skill.info or not skill.info:NoAttackWait(creature) then
      creature.ai:SetIdleAction(Asset_Role.ActionName.AttackIdle)
    end
    return false
  end
  creature:SetNoSkillDelay(info:NoSkillDelay())
  local limitSkill = creature.data:GetLimitSkill(args[1])
  if nil ~= limitSkill and not limitSkill:IsIgnoreTarget() then
    args[2] = limitSkill:GetFromID()
    args[6] = false
    args[8] = true
  end
  if args[9] then
    args[8] = true
  end
  local _waitForComboID, skillIDAndLevel = Game.SkillClickUseManager:GetWaitForCombo()
  local sortid = args[1] // 1000
  if SpeicalComboHandler[sortid] == 1 then
    local triggerskill = Game.SkillComboManager:GetTriggerKickSkillID()
    local skillCanUse = creature:Logic_CheckSkillCanUseByID(triggerskill)
    if skillCanUse and triggerskill then
      skill:SetSkillID(triggerskill)
      skill:SetIsTrigger(true)
    else
      skill:SetSkillID(args[1])
      skill:SetIsTrigger(false)
    end
    args[5] = true
  elseif SpeicalComboHandler[sortid] == 2 then
    self.isComboSkill = true
    if _waitForComboID and skillIDAndLevel then
      skill:SetSkillID(skillIDAndLevel)
    else
      skill:SetSkillID(args[1])
    end
    skill:SetIsTrigger(false)
  else
    skill:SetSkillID(args[1])
    skill:SetIsTrigger(false)
  end
  local targetType
  if args[5] then
    targetType = SkillTargetType.Creature
  else
    targetType = skill.info:GetTargetType(creature)
  end
  self.targetType = targetType
  skillCMD = SkillCMD[targetType]
  if skillCMD.Start(self, time, deltaTime, creature) then
    local targetCreature
    if 0 ~= args[2] then
      creature:Logic_SetSkillState(args[2])
      targetCreature = SceneCreatureProxy.FindCreature(args[2])
    end
    if isAttackSkill then
      if not skill.info:NoIdleAttack(creature) then
      else
      end
      creature:Logic_SetAttackTarget(targetCreature or nil)
    else
      local attackTarget = creature:Logic_GetAttackTarget()
      if SkillTargetType.None ~= targetType and attackTarget ~= targetCreature then
        creature:Logic_SetAttackTarget(nil)
      end
    end
    return true
  end
  return false
end
function AI_CMD_Myself_Skill:End(time, deltaTime, creature)
  skillCMD.End(self, time, deltaTime, creature)
end
function AI_CMD_Myself_Skill:Update(time, deltaTime, creature)
  skillCMD.Update(self, time, deltaTime, creature)
end
function AI_CMD_Myself_Skill.ToString()
  return "AI_CMD_Myself_Skill", AI_CMD_Myself_Skill
end
function AI_CMD_Myself_Skill:IsComboSkill()
  return self.isComboSkill == true
end
