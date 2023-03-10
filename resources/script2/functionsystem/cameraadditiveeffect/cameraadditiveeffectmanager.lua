CameraAdditiveEffectManager = class("CameraAdditiveEffectManager")
function CameraAdditiveEffectManager.Me()
  if nil == CameraAdditiveEffectManager.me then
    CameraAdditiveEffectManager.me = CameraAdditiveEffectManager.new()
  end
  return CameraAdditiveEffectManager.me
end
function CameraAdditiveEffectManager.CheckPriority(effect, priority)
  local manager = FunctionCameraAdditiveEffect.Me()
  local currentEffect = manager:GetEffect(effect.type)
  return nil == currentEffect or not currentEffect.running or nil == currentEffect.priority or not (priority < currentEffect.priority)
end
function CameraAdditiveEffectManager.CheckToken(effect, token)
  return effect.running and effect.token == token
end
function CameraAdditiveEffectManager.StartEffect(effect, priority)
  local manager = FunctionCameraAdditiveEffect.Me()
  manager:EndEffectByType(effect.type)
  manager:StartEffect(effect)
  effect.priority = priority
  if nil == effect.token then
    effect.token = 1
  else
    effect.token = effect.token + 1
  end
end
function CameraAdditiveEffectManager.EndEffect(effect)
  local manager = FunctionCameraAdditiveEffect.Me()
  manager:EndEffect(effect)
end
function CameraAdditiveEffectManager:ctor()
  self.effectShake = CameraAdditiveEffectShake.new()
end
function CameraAdditiveEffectManager:StartShake(range, duration, curve, priority)
  priority = priority or 1
  if not CameraAdditiveEffectManager.CheckPriority(self.effectShake, priority) then
    return nil
  end
  CameraAdditiveEffectManager.EndEffect(self.effectShake)
  self.effectShake:SetParams(range, duration, curve)
  CameraAdditiveEffectManager.StartEffect(self.effectShake, priority)
  return self.effectShake.token
end
function CameraAdditiveEffectManager:EndShake(token)
  if not CameraAdditiveEffectManager.CheckToken(self.effectShake, token) then
    return
  end
  CameraAdditiveEffectManager.EndEffect(self.effectShake)
end
function CameraAdditiveEffectManager:ForceEndShake()
  if self.effectShake then
    CameraAdditiveEffectManager.EndEffect(self.effectShake)
  end
end
