FunctionMultiProfession = class("FunctionMultiProfession")
local _ArrayClear = TableUtility.ArrayClear
local _ArrayShallowCopy = TableUtility.ArrayShallowCopy
local _ArrayPushBack = TableUtility.ArrayPushBack
local _GetTempVector3 = LuaGeometry.GetTempVector3
local _ProfessionProxy = ProfessionProxy.Instance
local _PictureManager = PictureManager.Instance
local _GetPosition = LuaGameObject.GetPosition
local _GetRotation = LuaGameObject.GetRotation
local _GetTempQuaternion = LuaGeometry.GetTempQuaternion
local _ObjectIsNull = LuaGameObject.ObjectIsNull
local _SetPositionGO = LuaGameObject.SetPositionGO
local _LuaDestroyObject = LuaGameObject.DestroyObject
local _Const_V3_zero = LuaGeometry.Const_V3_zero
local _PartIndex = Asset_Role.PartIndex
local _PartIndexEX = Asset_Role.PartIndexEx
local _MyGender, _MyRace
local _SceneName = "Scenesc_chuangjue"
local _EnviromentID = 231
local _BgTexture = "Reloading_BG_duozhiye"
local defaultSpawnPosition = LuaVector3.New(0, 999, -2.3)
local defaultSpawnRotation = LuaQuaternion.Euler(0, 0, 0)
local defaultCameraBgZ = -7.5
local defaultCameraBgRot = LuaQuaternion.Euler(0, 180, 0)
local cameraBgPos = LuaVector3.Zero()
local cameraSettings = {}
cameraSettings[1] = {
  focusPosition = LuaVector3.New(0.1, 1000, 0),
  focusRotation = LuaQuaternion.Euler(0, 180, 0),
  viewports = {
    LuaVector3.New(0, 0, 0),
    LuaVector3.New(0, 0, 0)
  }
}
cameraSettings[2] = {
  focusPosition = LuaVector3.New(0.35, 1000, 0),
  focusRotation = LuaQuaternion.Euler(0, 180, 0),
  viewports = {
    LuaVector3.New(30, 0, 0.01),
    LuaVector3.New(0, 0, 0.01)
  }
}
cameraSettings[3] = {
  focusPosition = LuaVector3.New(-0.6, 1000, 0),
  focusRotation = LuaQuaternion.Euler(0, 180, 0),
  viewports = {
    LuaVector3.New(-40, 0, 0.01),
    LuaVector3.New(-40, 0, 0.01)
  }
}
local cameraFocusDuration = 0.3
local camerFieldOfView = 55
function FunctionMultiProfession.Me()
  if nil == FunctionMultiProfession.me then
    FunctionMultiProfession.me = FunctionMultiProfession.new()
  end
  return FunctionMultiProfession.me
end
function FunctionMultiProfession:Launch()
  _MyGender = MyselfProxy.Instance:GetMySex()
  _MyRace = MyselfProxy.Instance:GetMyRace()
  self.vecCameraPosRecord = LuaVector3()
  self.quaCameraRotRecord = LuaQuaternion()
  self.initRetryCount = 0
  self:InitCamera()
  self:InitCameraBG()
end
function FunctionMultiProfession:Shutdown()
  self:UnloadModel()
  self:ResetCamera()
end
function FunctionMultiProfession:InitCameraBG()
  local go = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("CameraBackground"))
  if go == nil then
    error("can not find cellpfb  CameraBackground")
  end
  self.backgroundGO = go
  self.backgroundTsf = go.transform
  local index = SaveInfoProxy.Instance:GetSavedTabIndex() or 1
  local cameraSetting = cameraSettings[index]
  local focusPos = cameraSetting and cameraSetting.focusPosition
  LuaVector3.Better_SetPos(cameraBgPos, focusPos)
  local width, height = UIManagerProxy.Instance:GetMyMobileScreenSize()
  local z = 640 / (width * 0.5 / defaultCameraBgZ)
  cameraBgPos[3] = z
  go.transform.position = cameraBgPos
  go.transform.rotation = defaultCameraBgRot
  local renderer = go:GetComponent(MeshRenderer)
  if renderer and renderer.materials and next(renderer.materials) then
    local targetMat = renderer.materials[1]
    PictureManager.Instance:SetPetRenderTexture(_BgTexture, targetMat)
  end
end
function FunctionMultiProfession:InitCamera()
  if self.ltInitCamera then
    return
  end
  local index = SaveInfoProxy.Instance:GetSavedTabIndex() or 1
  local cameraSetting = cameraSettings[index]
  self.cameraCtrl = CameraController.Instance or CameraController.singletonInstance
  if not self.cameraCtrl then
    self.initRetryCount = self.initRetryCount + 1
    self.ltInitCamera = TimeTickManager.Me():CreateOnceDelayTick(self.initRetryCount * 100, function(owner, deltaTime)
      self.ltInitCamera = nil
      self:InitCamera()
    end)
    return
  end
  self.cameraCtrl.applyCurrentInfoPause = true
  self.cameraCtrl.enabled = false
  self.cameraCtrl:SetDefault()
  self.cameraCtrl.activeCamera.transform.rotation = LuaQuaternion.Identity()
  self.cameraWorld = self.cameraCtrl.activeCamera
  self.cameraWorld.transform.position = cameraSetting.focusPosition
  self.cameraWorld.transform.rotation = cameraSetting.focusRotation
  LuaVector3.Better_Set(self.vecCameraPosRecord, LuaGameObject.GetPosition(self.cameraWorld.transform))
  LuaQuaternion.Better_Set(self.quaCameraRotRecord, LuaGameObject.GetRotation(self.cameraWorld.transform))
  self.fovRecord = self.cameraWorld.fieldOfView
  self.cameraWorld.fieldOfView = camerFieldOfView
end
function FunctionMultiProfession:UpdateCameraFocus(index, duration, tabIndex)
  duration = duration or 0
  local cameraSetting = cameraSettings[index]
  if not cameraSetting or not cameraSetting.viewports then
    return
  end
  local focusOffset = cameraSetting.focusOffset
  if self.cameraCtrl then
    self.cameraCtrl.applyCurrentInfoPause = true
    self.cameraCtrl.enabled = false
  end
end
function FunctionMultiProfession:TargetMoveTween(index, duration)
  duration = duration or 0
  local cameraSetting = cameraSettings[index]
  if not cameraSetting then
    return
  end
  local targetPos = cameraSetting.focusPosition
  if self.cameraCtrl then
    TweenPosition.Begin(self.cameraCtrl.gameObject, duration, targetPos, true)
    local bgDeltaVec = targetPos - cameraBgPos
    bgDeltaVec[3] = 0
    TweenPosition.Begin(self.backgroundGO, duration, cameraBgPos + bgDeltaVec, true)
  end
end
function FunctionMultiProfession:ResetCamera()
  if self.cameraWorld and not LuaGameObject.ObjectIsNull(self.cameraWorld) then
    self.cameraCtrl.applyCurrentInfoPause = false
    self.cameraCtrl:InterruptSmoothTo()
    self.cameraCtrl.enabled = true
    self.cameraCtrl:RestoreDefault(0, nil)
    self.cameraWorld.transform.position = self.vecCameraPosRecord
    self.cameraWorld.transform.rotation = self.quaCameraRotRecord
    if self.fovRecord then
      self.cameraWorld.fieldOfView = self.fovRecord
      self.fovRecord = nil
    end
    FunctionCameraEffect.Me():ResetEffect(nil, true)
  end
  self.cameraCtrl = nil
  if self.backgroundGO and not LuaGameObject.ObjectIsNull(self.backgroundGO) then
    LuaGameObject.DestroyGameObject(self.backgroundGO.transform)
  end
  if self.ltInitCamera then
    self.ltInitCamera = nil
  end
end
function FunctionMultiProfession:UnloadModel()
  if self.assetRole then
    self.assetRole:IgnoreTerrainLightColor(false)
    self.assetRole:DeactiveMulColor()
    self.assetRole:Destroy()
  end
end
function FunctionMultiProfession:UpdateRoleModelByClassID(classid)
  local classStaticData = Table_Class[classid]
  if not classStaticData then
    return
  end
  local parts = Asset_Role.CreatePartArray()
  local classBody = _MyGender == ProtoCommon_pb.EGENDER_MALE and classStaticData.MaleBody or classStaticData.FemaleBody
  parts[_PartIndex.Body] = classBody
  local userData = Game.Myself.data.userdata
  local self_race = ProfessionProxy.GetRaceByProfession(userData:Get(UDEnum.PROFESSION))
  local classRace = ProfessionProxy.GetRaceByProfession(classid)
  if self_race ~= classRace then
    local hair, eye = _ProfessionProxy:GetProfessionRaceFaceInfo(classRace)
    parts[_PartIndex.Hair] = hair
    parts[_PartIndex.Eye] = eye
  else
    parts[_PartIndex.Hair] = userData:Get(UDEnum.HAIR)
    parts[_PartIndex.Eye] = ProfessionProxy.GetOriginalEye(userData:Get(UDEnum.EYE), classBody)
  end
  local weapon = classStaticData.DefaultWeapon
  parts[_PartIndex.RightWeapon] = weapon or 0
  if ProfessionProxy.IsHero(classid) then
    if classStaticData.Head then
      parts[_PartIndex.Head] = classStaticData.Head
    end
    if classStaticData.Eye then
      parts[_PartIndex.Eye] = classStaticData.Eye
    end
  end
  parts[_PartIndexEX.Gender] = _MyGender
  parts[_PartIndexEX.HairColorIndex] = userData:Get(UDEnum.HAIRCOLOR)
  parts[_PartIndexEX.EyeColorIndex] = userData:Get(UDEnum.EYECOLOR)
  self:UpdateRoleModel(parts)
  Asset_Role.DestroyPartArray(parts)
  self:SetRoleModelActive(true)
  AudioUtility.PlayOneShot2D_Path(AudioMap.UI.ProfessionSwitch, AudioSourceType.UI)
end
function FunctionMultiProfession:UpdateRoleModel(parts)
  if self.assetRole == nil then
    parts[Asset_Role.PartIndexEx.SkinQuality] = Asset_RolePart.SkinQuality.Bone4
    self.assetRole = Asset_Role_UI.Create(parts)
    self.assetRole:SetLayer(Game.ELayer.Outline)
    self.assetRole:SetPosition(defaultSpawnPosition)
    self.assetRole:SetEulerAngleY(0)
    self.assetRole:SetScale(1)
    self.assetRole:SetShadowEnable(false)
    self.assetRole:RegisterWeakObserver(self)
    self.assetRole:IgnoreTerrainLightColor(true)
    self.assetRole:ActiveMulColor(LuaColor.New(1, 1, 1, 1))
    self.assetRole:RefreshLightMapColor()
  end
  self.assetRole:Redress(parts, true)
  self.assetRole:SetEpNodesDisplay(true)
  self.assetRole:SetPosition(defaultSpawnPosition)
  self.assetRole:PlayAction_Idle()
end
function FunctionMultiProfession:ObserverEvent(asset_role, param)
  if asset_role ~= self.assetRole then
    return
  end
  if type(param) ~= "table" then
    return
  end
  local evt, obj, part = param[1], param[2], param[3]
  if part == Asset_Role.PartIndex.Body and self.assetRole and evt == Asset_Role_UI_Event.PartCreated then
    self.assetRole:IgnoreTerrainLightColor(true)
    self.assetRole:ActiveMulColor(LuaColor.New(1, 1, 1, 1))
    self.assetRole:RefreshLightMapColor()
  end
end
function FunctionMultiProfession:ObserverDestroyed(obj)
  if obj ~= nil and obj == self.assetRole then
    self.assetRole:UnregisterWeakObserver(self)
    self.assetRole:IgnoreTerrainLightColor(false)
    self.assetRole:DeactiveMulColor()
    self.assetRole = nil
  end
end
function FunctionMultiProfession:SetRoleModelActive(active)
  if self.assetRole then
    self.assetRole.complete.gameObject:SetActive(active)
  end
end
