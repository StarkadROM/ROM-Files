CameraFilterProxy = class("CameraFilterProxy", pm.Proxy)
CameraFilterProxy.Instance = nil
CameraFilterProxy.NAME = "CameraFilterProxy"
autoImport("PpLua")
function CameraFilterProxy:ctor(proxyName, data)
  self.proxyName = proxyName or CameraFilterProxy.NAME
  if CameraFilterProxy.Instance == nil then
    CameraFilterProxy.Instance = self
    self:Init()
    self:AddEvts()
  end
  if data ~= nil then
    self:setData(data)
  end
  self.HasInitCamera = false
  local eventManager = EventManager.Me()
  eventManager:AddEventListener(LoadEvent.StartLoadScene, self.StartLoadScene, self)
  eventManager:AddEventListener(ServiceEvent.PlayerMapChange, self.PlayerMapChange, self)
end
function CameraFilterProxy:StartLoadScene()
  self:CFQuit(true)
end
function CameraFilterProxy:PlayerMapChange()
  self:CFQuit(true)
end
function CameraFilterProxy:CFSetEffectAndSpEffect(nameOfEffect, nameOfSpEffect, highPriority, updateDepthOfField_duration, effect_duration)
  if self.highPriority and not highPriority then
    return
  end
  self.highPriority = highPriority
  self.gmCm = NGUIUtil:GetCameraByLayername("Default")
  local rootTrans = UIManagerProxy.Instance.UIRoot.transform
  if self.HasInitCamera ~= true then
    self.HasInitCamera = true
    PpLua:Init({
      self.gmCm
    })
    PpLua:SetEffect(nameOfEffect)
    if self.effect then
      self.effect:Destroy()
      self.effect = nil
    end
    if nameOfSpEffect ~= "" then
      self.effect = Asset_Effect.PlayOn("CameraEfc/" .. nameOfSpEffect, rootTrans, self._HandleMidEffectShow, self)
      self.effect:SetActive(true)
    end
    if effect_duration and effect_duration > 0 then
      self.timeCallDelete = TimeTickManager.Me():CreateOnceDelayTick(effect_duration, function(owner, deltaTime)
        self:CFQuit(true)
      end, self)
    end
  else
    PpLua:Destory()
    if self.effect then
      self.effect:Destroy()
      self.effect = nil
    end
    PpLua:Init({
      self.gmCm
    })
    PpLua:SetEffect(nameOfEffect)
    if nameOfSpEffect ~= "" then
      self.effect = Asset_Effect.PlayOn("CameraEfc/" .. nameOfSpEffect, rootTrans, self._HandleMidEffectShow, self)
      self.effect:SetActive(true)
    end
  end
  if updateDepthOfField_duration and updateDepthOfField_duration > 0 then
    if self.updateDepthOfField_ltId then
      LeanTween.cancel(LeanTween.tweenEmpty, self.updateDepthOfField_ltId)
    end
    self.updateDepthOfField_ltId = nil
  end
end
function CameraFilterProxy._HandleMidEffectShow(effectHandle, owner)
  if effectHandle == nil then
    helplog("if effectHandle == nil then")
    return
  end
end
function CameraFilterProxy:CFQuit(highPriority)
  if self.highPriority and not highPriority then
    return
  end
  self.highPriority = false
  if self.updateDepthOfField_ltId then
    LeanTween.cancel(LeanTween.tweenEmpty, self.updateDepthOfField_ltId)
  end
  self.updateDepthOfField_ltId = nil
  if self.HasInitCamera == true then
    PpLua:Destory()
    FunctionPerformanceSetting.Me():ApplyAntiRateSetting()
  end
  self.HasInitCamera = false
  if self.effect then
    self.effect:Destroy()
    self.effect = nil
  end
  if self.timeCallDelete then
    self.timeCallDelete:Destroy()
    self.timeCallDelete = nil
  end
end
function CameraFilterProxy:SetForbidPlayerOperation(reason, isForbid)
  if not reason then
    LogUtility.Error("CameraFilterProxy.SetForbidPlayerOperation param: reason cannot be nil!")
    return
  end
  self.forbidPlayerOperationReasons[reason] = isForbid and true or nil
end
function CameraFilterProxy:IsForbidPlayerOperation()
  local reason = next(self.forbidPlayerOperationReasons)
  return reason ~= nil
end
function CameraFilterProxy:Init()
  self.forbidPlayerOperationReasons = {}
end
function CameraFilterProxy:AddEvts()
end
function CameraFilterProxy:OnPause(note)
end
function CameraFilterProxy:SetTags(k, v)
end
function CameraFilterProxy.InitPushModule()
end
return CameraFilterProxy
