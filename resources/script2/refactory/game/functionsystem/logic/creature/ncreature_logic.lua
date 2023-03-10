local tempVector3 = LuaVector3.Zero()
RideActionReason = {BattleInRiding = 1, RideWolf = 2}
function NCreature:FreezeHold(b)
  self.freezeHold = b
end
function NCreature:CheckAction(action)
  action = action or self:GetIdleAction()
  if self.freezeHold then
    local isIdleHold = string.find(action or "", Asset_Role.ActionName.IdleHold) and true or false
    local isMoveHold = string.find(action or "", Asset_Role.ActionName.MoveHold) and true or false
    return isIdleHold or isMoveHold
  end
  return true
end
function NCreature:Logic_PlayAction(params, force)
  if not force and self.data and (self.data:Freeze() or self.data:NoAction()) then
    return false
  end
  if self.data:IsOb() then
    return false
  end
  if nil == params[3] then
    params[3] = 1
  end
  if nil == params[2] then
    params[2] = self:GetIdleAction()
  end
  if not force and not self:CheckAction(params[2]) then
    return false
  end
  if params[3] > 0 and not self:Client_IsMoving() then
    params[14] = true
  end
  self.assetRole:PlayAction(params)
  return true
end
function NCreature:Logic_PlayAction_Simple(name, defaultName, speed)
  if self.data and self.data:Freeze() then
    return false
  end
  if not self:CheckAction(name or defaultName) then
    return false
  end
  if nil == speed then
    speed = 1
  end
  if nil == defaultName then
    defaultName = self:GetIdleAction()
  end
  self.assetRole:PlayAction_Simple(name, defaultName, speed)
  return true
end
function NCreature:Logic_PlayAction_Idle()
  return self:Logic_PlayAction_Simple(self:GetIdleAction())
end
function NCreature:Logic_PlayAction_Move(customMoveActionName, force)
  local data = self.data
  if data and (data:Freeze() or data:NoMoveAction() or data:NoAct()) then
    return false
  end
  local name = customMoveActionName or self:GetMoveAction()
  local moveActionScale = 1
  local staticData = data.staticData
  if nil ~= staticData and nil ~= staticData.MoveSpdRate then
    moveActionScale = staticData.MoveSpdRate
  end
  local moveSpeed = data.props:GetPropByName("MoveSpd"):GetValue()
  local actionSpeed = self.moveActionSpd or moveActionScale * moveSpeed
  local params = Asset_Role.GetPlayActionParams(name, nil, actionSpeed)
  if force then
    params[6] = true
  end
  self.assetRole:PlayAction(params)
  return true
end
function NCreature:Logic_StopBaseAction()
  self.assetRole:StopBaseAction()
end
function NCreature:Logic_StopBlendAction()
  self.assetRole:StopBlendAction()
end
function NCreature:Logic_PlaceXYZTo(x, y, z)
  LuaVector3.Better_Set(tempVector3, x, y, z)
  self:Logic_PlaceTo(tempVector3)
end
function NCreature:Logic_PlaceTo(p)
  self.logicTransform:PlaceTo(p)
end
function NCreature:Logic_NavMeshPlaceXYZTo(x, y, z)
  LuaVector3.Better_Set(tempVector3, x, y, z)
  self:Logic_NavMeshPlaceTo(tempVector3)
end
function NCreature:Logic_NavMeshPlaceTo(p)
  self.logicTransform:NavMeshPlaceTo(p)
end
function NCreature:Logic_MoveTo(p)
  self.logicTransform:MoveTo(p)
end
function NCreature:Logic_NavMeshMoveTo(p)
  return self.logicTransform:NavMeshMoveTo(p)
end
function NCreature:Logic_StopMove()
  self.logicTransform:StopMove()
  self.assetRole:MoveActionStopped()
end
function NCreature:Logic_SamplePosition(time)
  self.logicTransform:SamplePosition()
end
function NCreature:Logic_SetAngleY(v, force)
  self.logicTransform:SetAngleY(v, force)
end
function NCreature:Logic_LockRotation(isLock)
  self.logicTransform:LockRotation(isLock)
end
function NCreature:Logic_Hit(action, stiff)
  self.ai:PushCommand(FactoryAICMD.GetHitCmd(false, action, stiff), self)
end
function NCreature:Logic_DeathBegin()
end
function NCreature:Logic_LookAtTargetPos()
  self.logicTransform:LookAtTargetPos()
end
function NCreature:Logic_CastBegin()
  EventManager.Me():DispatchEvent(SkillEvent.SkillCastBegin, self)
end
function NCreature:Logic_CastEnd()
  EventManager.Me():DispatchEvent(SkillEvent.SkillCastEnd, self)
end
function NCreature:Logic_FreeCastBegin()
  EventManager.Me():DispatchEvent(SkillEvent.SkillFreeCastBegin, self)
end
function NCreature:Logic_FreeCastEnd()
  EventManager.Me():DispatchEvent(SkillEvent.SkillFreeCastEnd, self)
end
function NCreature:Logic_Freeze(on)
  on = on or self.data:WeakFreeze()
  if on then
    self.assetRole:SetActionSpeed(0)
  else
    self.assetRole:SetActionSpeed(1)
  end
end
function NCreature:Logic_NoAct(on)
  if on and not self.data:Freeze() then
    self:Logic_StopBlendAction()
    self:Logic_PlayAction_Idle()
  end
end
function NCreature:Logic_LockRotation(isLock)
  self.logicTransform:LockRotation(isLock)
end
function NCreature:Logic_FearRun(on)
end
local CreatureFollowTarget = "CreatureFollowTarget"
function NCreature:Logic_GetFollowTarget()
  return self:GetWeakData(CreatureFollowTarget)
end
function NCreature:Logic_CanUseSkill()
  return true
end
function NCreature:Logic_RideAction(can, reason)
  local condition = self.rideActionCondition
  if condition == nil then
    condition = LogicalConditionCheckWithDirty.new(LogicalConditionCheckWithDirty.Or)
    self.rideActionCondition = condition
  end
  if can then
    condition:SetReason(reason)
  else
    condition:RemoveReason(reason)
  end
  if self.assetRole then
    self.assetRole:SetRideAction(condition:HasReason())
  end
end
function NCreature:Logic_AddSkillFreeCast(skillInfo)
  if self.skillFreeCast ~= nil then
    self.skillFreeCast:Destroy()
  end
  local args = SkillFreeCast.GetArgs(self, skillInfo)
  self.skillFreeCast = SkillFreeCast.Create(args)
  EventManager.Me():PassEvent(MyselfEvent.EnableUseSkillStateChange)
end
function NCreature:Logic_RemoveSkillFreeCast()
  if self.skillFreeCast ~= nil then
    self.skillFreeCast:Destroy()
    self.skillFreeCast = nil
    EventManager.Me():PassEvent(MyselfEvent.EnableUseSkillStateChange)
  end
end
function NCreature:Logic_IsFreeCast()
  return self.skillFreeCast ~= nil
end
function NCreature:Logic_PartnerVisible()
  if not self:HasPetPartner() then
    return
  end
  local profess = self.data:GetProfesstion()
  if profess == nil then
    return
  end
  local classData = Table_Class[profess]
  if classData == nil or classData.Feature == nil or classData.Feature & 1 == 0 then
    return
  end
  self:SetPartnerVisible(self:_IsPartnerVisible(), LayerChangeReason.Mount)
end
function NCreature:_IsPartnerVisible()
  local mount = self.data:GetMount()
  if mount ~= 0 then
    local data = Table_Item[mount]
    if data ~= nil and data.Feature ~= nil and 0 < data.Feature & 8 then
      return true
    end
  end
  return mount == 0
end
function NCreature:Logic_BeTaunt(open, fromID)
end
function NCreature:Logic_SetMoveActionSpeed(speed)
  if self.assetRole then
    self.moveActionSpd = speed
  end
end
function NCreature:Logic_SetAssetRoleMountForm(newForm)
  if self.assetRole then
    self.assetRole:SetMountForm(newForm)
  end
end
function NCreature:Logic_PlayMountTransformAction(callback, callbackArgs)
  if self.assetRole and self.data then
    return self.assetRole:Mount_PlayTransformAction(callback, callbackArgs)
  end
end
function NCreature:Logic_OnMountTransformActionFinished()
  if self.assetRole then
    self.assetRole:Mount_OnTransformActionFinished()
  end
end
function NCreature:Logic_Spin(duration, speed)
  redlog("Logic_Spin")
  self.ai:PushCommand(FactoryAICMD.GetSpinCmd(duration, speed), self)
end
function NCreature:Logic_SpinEnd()
  redlog("Logic_SpinEnd")
  self.ai:PushCommand(FactoryAICMD.GetSpinEndCmd(), self)
end
