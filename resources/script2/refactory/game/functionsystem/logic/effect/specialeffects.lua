ViewRangeEffect = reusableClass("ViewRangeEffect")
ViewRangeEffect.PoolSize = 10
function ViewRangeEffect:ShowRange(range)
  self[4] = range
  if Slua.IsNull(self[3]) == false then
    local smooth = self[3]
    smooth.radius = self[4]
    smooth:SmoothSet()
  end
end
function ViewRangeEffect:SetEffectGO(go)
  local smooth = go:GetComponent(CircleDrawerSmooth)
  self[3] = smooth
  if self[4] and Slua.IsNull(smooth) == false then
    smooth.radius = self[4]
    smooth:SmoothSet()
  end
end
function ViewRangeEffect.OnEffectCreated(eObj, instance, assetEffect)
  if not instance then
    return
  end
  instance[2] = assetEffect
  instance:SetEffectGO(eObj)
  local followCreature = SceneCreatureProxy.FindCreature(instance[1])
  if followCreature then
    followCreature:Client_RegisterFollow(eObj.transform, nil, nil, ViewRangeEffect.OnEffectLostFollow, instance)
  end
end
function ViewRangeEffect.OnEffectLostFollow(transform, instance)
  if Slua.IsNull(instance[3]) == false then
    Game.RoleFollowManager:UnregisterFollow(instance[3].transform)
  end
end
function ViewRangeEffect:DoConstruct(asArray, creatureID)
  self[1] = creatureID
  self[2] = Asset_Effect.PlayAtXYZ(EffectMap.Maps.VisionScope, 0, 0, 0, self.OnEffectCreated, self)
end
function ViewRangeEffect:DoDeconstruct(asArray)
  self[1] = nil
  if self[2] then
    self[2]:Destroy()
  end
  self[2] = nil
  self[3] = nil
  self[4] = nil
end
TrackEffect = reusableClass("TrackEffect")
TrackEffect.PoolSize = 10
function TrackEffect:Spawn(path, pos, isStatic, callBack)
  self[1] = Asset_Effect.PlayAtXYZ(path, pos[1], pos[2], pos[3])
end
function TrackEffect:GetLocalPosition()
  if self[1] then
    return self[1]:GetLocalPosition()
  end
end
function TrackEffect:ResetLocalPosition(p)
  if self[1] then
    self[1]:ResetLocalPosition(p)
  end
end
function TrackEffect:SetHitCall(call, arg1, arg2)
  self[2] = call
  self[3] = arg1
  self[4] = arg2
end
function TrackEffect:SetSpeed(s)
  self[5] = s
end
function TrackEffect:GetSpeed()
  return self[5]
end
function TrackEffect:Hit()
  if self[2] then
    self[2](self, self[3], self[4])
  end
end
function TrackEffect:SetEndPostion(pos)
  self[6] = pos
end
function TrackEffect:GetEndPostion()
  return self[6]
end
function TrackEffect:DoConstruct(asArray, effectPath)
  self[5] = 0
end
function TrackEffect:DoDeconstruct(asArray)
  if self[1] then
    self[1]:Destroy()
    self[1] = nil
  end
  self[2] = nil
  self[3] = nil
  self[4] = nil
end
