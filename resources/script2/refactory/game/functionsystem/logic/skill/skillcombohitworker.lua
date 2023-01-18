autoImport("NPartner")
SkillComboHitWorker = class("SkillComboHitWorker", ReusableObject)
if not SkillComboHitWorker.SkillComboHitWorker_Inited then
  SkillComboHitWorker.SkillComboHitWorker_Inited = true
  SkillComboHitWorker.PoolSize = 200
end
local DamageType = CommonFun.DamageType
local _FindCreature = SceneCreatureProxy.FindCreature
local FindCreature = function(guid)
  local c = _FindCreature(guid)
  if c then
    return c
  end
  if NPartnerMap[guid] then
    return NPartnerMap[guid]
  end
end
local ComboInterval = 0.2
local tempComboHitArgs = {
  [1] = nil,
  [2] = DamageType.None,
  [3] = 0,
  [4] = 0,
  [5] = 0,
  [6] = false,
  [7] = nil,
  [8] = HurtNumType.DamageNum,
  [9] = HurtNumColorType.Normal,
  [10] = nil,
  [11] = nil,
  [12] = true,
  [13] = nil,
  [14] = true
}
function SkillComboHitWorker.GetArgs()
  return tempComboHitArgs
end
function SkillComboHitWorker.ClearArgs(args)
  args[1] = nil
  args[10] = nil
  args[11] = nil
  args[12] = true
  args[13] = nil
  args[14] = true
end
function SkillComboHitWorker.Create(args)
  return ReusableObject.Create(SkillComboHitWorker, true, args)
end
function SkillComboHitWorker:ctor()
  self.args = {}
  local args = self.args
  args[17] = LuaVector3.Zero()
end
function SkillComboHitWorker:Update(time, deltaTime)
  local args = self.args
  if time < args[15] then
    return
  end
  args[15] = time + ComboInterval
  local targetCreature = FindCreature(args[1])
  if nil ~= targetCreature then
    if not args[6] then
      targetCreature:Logic_Hit()
    end
    if self.args[12] and nil ~= args[7] then
      targetCreature.assetRole:PlaySEOneShotOn(args[7])
    end
  end
  if nil ~= args[10] then
    local damage = SkillLogic_Base.GetSplitDamage(args[3], args[14], args[4])
    local creature = FindCreature(args[11])
    if SkillLogic_Base.AllowTargetHurtNum(creature, targetCreature, self.args[13], self.args[2]) then
      self.args[10]:Show(damage, args[17], creature == Game.Myself, self.args[18], targetCreature == Game.Myself)
    end
  end
  if args[14] >= args[4] then
    self:Destroy()
  else
    self.args[14] = self.args[14] + 1
  end
end
function SkillComboHitWorker:DoConstruct(asArray, args)
  local creature = args[11]
  local targetCreature = args[1]
  targetCreature.ai:SetDieBlocker(self)
  TableUtility.ArrayShallowCopyWithCount(self.args, args, 13)
  self.args[1] = targetCreature.data.id
  self.args[11] = creature and creature.data.id or 0
  if args[14] then
    if nil == self.args[10] then
      self.args[18] = HurtNum_CritType.None
      if DamageType.Crit == args[2] then
        if args[13] ~= nil and args[13]:ShowMagicCrit(targetCreature) then
          self.args[18] = HurtNum_CritType.MAtk
        else
          self.args[18] = HurtNum_CritType.PAtk
        end
      end
      self.args[10] = SceneUIManager.Instance:GetStaticHurtLabelWorker()
    end
    self.args[10]:AddRef()
  else
    self.args[10] = nil
  end
  self.args[14] = 1
  self.args[15] = 0
  local targetAssetRole = targetCreature.assetRole
  local posx, posy, posz = targetAssetRole:GetEPOrRootPosition(RoleDefines_EP.Top)
  LuaVector3.Better_Set(self.args[17], posx, posy + math.random(0, 20) / 100, posz)
end
function SkillComboHitWorker:DoDeconstruct(asArray)
  local args = self.args
  local targetCreature = FindCreature(args[1])
  if nil ~= targetCreature then
    targetCreature.ai:ClearDieBlocker(self)
  end
  if nil ~= args[10] then
    args[10]:SubRef()
  end
  args[10] = nil
  args[13] = nil
  args[18] = nil
end
