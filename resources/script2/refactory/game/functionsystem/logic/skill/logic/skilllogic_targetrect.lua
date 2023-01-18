local SelfClass = {}
setmetatable(SelfClass, {
  __index = SkillLogic_TargetCreature
})
local SuperClass = SkillLogic_TargetCreature
local FindCreature = SceneCreatureProxy.FindCreature
local tempVector2 = LuaVector2.Zero()
local tempVector2_1 = LuaVector2.Zero()
function SelfClass:Client_DoDeterminTargets(creature, creatureArray, maxCount, sortFunc)
  SuperClass.Client_DoDeterminTargets(self, creature, creatureArray, maxCount)
  local targetCreature = FindCreature(self.targetCreatureGUID)
  if targetCreature == nil then
    return
  end
  local skillInfo = self.info
  skillInfo:GetTargetForwardRect(creature, tempVector2, tempVector2_1)
  local p = creature:GetPosition()
  local angleY = VectorHelper.GetAngleByAxisY(p, targetCreature:GetPosition())
  SkillLogic_Base.SearchTargetInRect(creatureArray, p, tempVector2, tempVector2_1, angleY, skillInfo, creature, nil, sortFunc)
end
function SelfClass.GetShowLength(skillinfo, creature)
  skillinfo:GetTargetForwardRect(creature, tempVector2, tempVector2_1)
  return tempVector2_1[1], tempVector2_1[2]
end
return SelfClass
