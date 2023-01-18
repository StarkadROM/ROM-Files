FunctionSkillTargetPointLauncher = class("FunctionSkillTargetPointLauncher")
FunctionSkillTargetPointLauncherEvent = {
  StateChanged = "E_FunctionSkillTargetPointLauncher_StateChanged"
}
local tempVector3 = LuaVector3.Zero()
local tempVector3_1 = LuaVector3.Zero()
local Skill_Indicator_Effect = EffectMap.Maps.Skill_Indicator
local OriginColor = LuaColor.New(0.8, 0.9764705882352941, 1, 0.5882352941176471)
local Transparent = LuaColor.New(0.8, 0.9764705882352941, 1, 0.29411764705882354)
local AdjustPointEffectSize = function(effectHandle, size)
  ModelUtils.AdjustSize(effectHandle.gameObject, size)
end
function FunctionSkillTargetPointLauncher.Me()
  if nil == FunctionSkillTargetPointLauncher.me then
    FunctionSkillTargetPointLauncher.me = FunctionSkillTargetPointLauncher.new()
  end
  return FunctionSkillTargetPointLauncher.me
end
function FunctionSkillTargetPointLauncher:ctor()
  self.point = LuaVector3.Zero()
  self:Reset()
end
function FunctionSkillTargetPointLauncher:Reset()
  self.running = false
  self.skillIDAndLevel = nil
  if nil ~= self.position then
    LuaVector3.Destroy(self.position)
    self.position = nil
  end
  self.active = false
  self:ResetEffect(nil)
  if self.indicatorEffect then
    self.indicatorEffect:Destroy()
    self.indicatorEffect = nil
  end
end
function FunctionSkillTargetPointLauncher:ResetEffect(newEffect)
  local oldEffect = self.effect
  if nil ~= oldEffect then
    oldEffect:Destroy()
  end
  self.effect = newEffect
end
function FunctionSkillTargetPointLauncher:Launch(skillIDAndLevel)
  if self.running then
    return
  end
  local creature = Game.Myself
  local assetRole = creature.assetRole
  local skillInfo = Game.LogicManager_Skill:GetSkillInfo(skillIDAndLevel)
  self.running = true
  self.skillIDAndLevel = skillIDAndLevel
  self.active = false
  local effectPath, lodLevel, priority, effectType = skillInfo:GetPointEffectPath(creature)
  local effectSize = skillInfo:GetPointEffectSize(creature)
  local effect
  if skillInfo:IsPointEffectTrack() then
    local completeTransform = assetRole.completeTransform
    effect = Asset_Effect.PlayOn(effectPath, completeTransform, AdjustPointEffectSize, effectSize, nil, lodLevel, priority, effectType)
    local pos = completeTransform.forward * effectSize
    effect:ResetLocalPositionXYZ(pos.x, pos.y, pos.z)
  else
    LuaVector3.Better_Set(tempVector3, LuaGameObject.GetForwardPosition(assetRole.completeTransform, effectSize))
    effect = Asset_Effect.PlayAt(effectPath, tempVector3, AdjustPointEffectSize, effectSize, nil, lodLevel, priority, effectType)
  end
  self:ResetEffect(effect)
  if skillInfo:IsPointEffectTrack() then
    self.pointAction = skillInfo:GetPointAction(creature)
    creature:Client_SetAutoSkillTargetPoint(true)
  end
  self.distance = skillInfo:GetIndicatorRange(creature)
  local completeTransform = assetRole.completeTransform
  if skillInfo:CheckShowIndicator() and self.distance and self.distance > 0 then
    if not self.indicatorEffect then
      self.indicatorEffect = Asset_Effect.PlayOn(Skill_Indicator_Effect, completeTransform, AdjustPointEffectSize, self.distance, self.distance)
    else
      self.indicatorEffect:ResetLocalScaleXYZ(self.distance, self.distance, self.distance)
    end
  elseif self.indicatorEffect then
    self.indicatorEffect:Destroy()
    self.indicatorEffect = nil
  end
  if nil == self.inputListener then
    function self.inputListener(inputInfo)
      self:OnInputEvent(inputInfo)
    end
  end
  FunctionSystem.SetExtraInputListener(self, self.inputListener, function()
    self:Shutdown()
  end, false)
  local eventManager = EventManager.Me()
  eventManager:DispatchEvent(FunctionSkillTargetPointLauncherEvent.StateChanged, self)
end
function FunctionSkillTargetPointLauncher:Shutdown()
  if not self.running then
    return
  end
  FunctionSniperMode.Me():SetExtraInputPosition()
  Game.Myself:Client_SetAutoSkillTargetPoint(false)
  FunctionSystem.ClearExtraInputListener(self, self.inputListener)
  self:Reset()
  local eventManager = EventManager.Me()
  eventManager:DispatchEvent(FunctionSkillTargetPointLauncherEvent.StateChanged, self)
end
function FunctionSkillTargetPointLauncher:OnInputEvent(inputInfo)
  if not self.running then
    return
  end
  if not self.active and (not inputInfo.overUI or FunctionSniperMode.Me():IsWorking()) then
    self.active = true
  end
  if self.active then
    FunctionSniperMode.Me():SetExtraInputPosition(inputInfo.touchPoint)
    self:TrackTargetPosition(inputInfo.touchPoint)
    if TouchEventType.END == inputInfo.touchEventType then
      self:LaunchSkill()
    end
  end
  if TouchEventType.END == inputInfo.touchEventType then
    self:Shutdown()
  end
end
function FunctionSkillTargetPointLauncher:TrackTargetPosition(touchPoint)
  local onTerrain, x, y, z = LuaUtils.RaycastTerrain(touchPoint)
  if not onTerrain then
    return
  end
  local creature = Game.Myself
  local position = creature:GetPosition()
  if not RaidPuzzleManager.Me():IsPositionUnlocked(x, z) then
    LuaVector3.Better_Set(self.point, x, y, z)
    if not NavMeshUtils.CanArrived(position, self.point, 1, false) then
      LuaVector3.Better_Sub(self.point, position, tempVector3)
      LuaVector3.Normalized(tempVector3)
      local ret = NavMeshUtility.Better_RaycastDirection(position, tempVector3_1, tempVector3)
      if not VectorUtility.AlmostEqual_3(self.point, tempVector3_1) then
        x, y, z = tempVector3_1[1], tempVector3_1[2], tempVector3_1[3]
      end
    end
  end
  LuaVector3.Better_Set(self.point, x, y, z)
  NavMeshUtility.SelfSample(self.point)
  self.position = VectorUtility.Asign_3(self.position, self.point)
  if nil ~= self.effect then
    local skillInfo = Game.LogicManager_Skill:GetSkillInfo(self.skillIDAndLevel)
    if not skillInfo:PointEffectTrack(Game.Myself, self.effect, self.point) then
      self.effect:ResetLocalPosition(self.point)
    end
    local distance = skillInfo:GetLaunchRange(creature)
    local effectHandle = self.effect:GetEffectHandle()
    local assetGO = effectHandle and effectHandle.gameObject
    local mesh, meshGO
    if assetGO then
      meshGO = GameObjectUtil.Instance:DeepFindChild(assetGO, "magic_target_over")
      if meshGO then
        mesh = meshGO:GetComponent(SpriteRenderer)
      end
      if mesh then
        if VectorUtility.DistanceXZ_Square(position, self.point) > distance * distance then
          mesh.color = Transparent
        else
          mesh.color = OriginColor
        end
      end
    else
      redlog("not assetGO")
    end
  end
end
function FunctionSkillTargetPointLauncher:LaunchSkill()
  if nil == self.position then
    return
  end
  if self.indicatorEffect then
    self.indicatorEffect:Destroy()
    self.indicatorEffect = nil
  end
  local skillInfo = Game.LogicManager_Skill:GetSkillInfo(self.skillIDAndLevel)
  local creature = Game.Myself
  local pos = creature:GetPosition()
  local distance = skillInfo:GetLaunchRange(creature)
  local outOfRange = VectorUtility.DistanceXZ_Square(pos, self.position) > distance * distance
  if skillInfo:IsPointEffectTrack() then
    if outOfRange then
      LuaVector3.Better_Sub(self.position, pos, tempVector3)
      LuaVector3.Normalized(tempVector3)
      LuaVector3.Mul(tempVector3, distance - 0.001)
      if self.position == nil then
        self.position = LuaVector3()
      end
      LuaVector3.Better_Add(pos, tempVector3, self.position)
      NavMeshUtility.SelfSample(self.position)
    end
  elseif outOfRange and FunctionSniperMode.Me():IsWorking() then
    return
  end
  Game.SkillClickUseManager:TryLaunchPointTargetTypeSkill(self.skillIDAndLevel, self.position)
end
function FunctionSkillTargetPointLauncher:AutoLaunch(skillIDAndLevel)
  local creature = Game.Myself
  local position = creature:GetPosition()
  local skillInfo = Game.LogicManager_Skill:GetSkillInfo(skillIDAndLevel)
  local distance = skillInfo:GetLaunchRange(creature)
  LuaVector3.Better_Set(tempVector3, 0, 0, 1)
  VectorUtility.SelfAngleYToVector3(tempVector3, creature:GetAngleY())
  local ret = NavMeshUtility.Better_RaycastDirection(position, tempVector3_1, tempVector3, distance)
  if not ret then
    LuaVector3.Mul(tempVector3, distance - 0.001)
    LuaVector3.Better_Add(position, tempVector3, tempVector3_1)
    NavMeshUtility.SelfSample(tempVector3_1)
  end
  Game.SkillClickUseManager:TryLaunchPointTargetTypeSkill(skillIDAndLevel, tempVector3_1)
end
function FunctionSkillTargetPointLauncher:GetPoint()
  return self.point
end
function FunctionSkillTargetPointLauncher:GetPointAction()
  return self.pointAction
end
function FunctionSkillTargetPointLauncher:TryChangeColor()
end
