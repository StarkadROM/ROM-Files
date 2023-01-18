FunctionPermission = class("FunctionPermission")
local PermissionEnum = {}
local GrantResult = {}
local PermissionMsgID
if not BackwardCompatibilityUtil.CompatibilityMode_V42 then
  PermissionEnum.Camera = AndroidPermissionUtil.PermissionName.Camera
  PermissionEnum.ReadWriteExternalStorage = AndroidPermissionUtil.PermissionName.ReadWriteExternalStorage
  PermissionEnum.RecordAudio = AndroidPermissionUtil.PermissionName.RecordAudio
  PermissionEnum.FineLocation = AndroidPermissionUtil.PermissionName.FineLocation
  PermissionEnum.CoarseLocation = AndroidPermissionUtil.PermissionName.CoarseLocation
  GrantResult.Granted = AndroidPermissionUtil.PERMISSION_GRANTED
  GrantResult.Denied = AndroidPermissionUtil.PERMISSION_DENIED
  PermissionMsgID = {
    {
      _type = PermissionEnum.Camera,
      msgId = 28082,
      PlayerPrefsKey = "PrefsCamera"
    },
    {
      _type = PermissionEnum.ReadWriteExternalStorage,
      msgId = 28083,
      PlayerPrefsKey = "PrefsReadWriteExternalStorage"
    },
    {
      _type = PermissionEnum.RecordAudio,
      msgId = 28084,
      PlayerPrefsKey = "PrefsRecordAudio"
    },
    {
      _type = PermissionEnum.FineLocation,
      msgId = 28085,
      PlayerPrefsKey = "PrefsFineLocation"
    },
    {
      _type = PermissionEnum.CoarseLocation,
      msgId = 28085,
      PlayerPrefsKey = "PrefsCoarseLocation"
    }
  }
end
local AllowCode = 0
local PlatformAndroid = ApplicationInfo.GetRunPlatform() == RuntimePlatform.Android
local RequestCallback = function(requestCode, permissions, grantResult)
  FunctionPermission.Me():SetRequestCallbackPPrefs(requestCode, grantResult)
  if grantResult == GrantResult.Granted then
    EventManager.Me():PassEvent(PermissionEvent.RequestSuccess, requestCode)
  elseif grantResult == GrantResult.Denied then
    EventManager.Me():PassEvent(PermissionEvent.RequestFail, requestCode)
  end
end
function FunctionPermission.Me()
  if FunctionPermission.me == nil then
    FunctionPermission.me = FunctionPermission.new()
  end
  return FunctionPermission.me
end
function FunctionPermission:ctor()
end
function FunctionPermission:RequestCameraPermission()
  if not BackwardCompatibilityUtil.CompatibilityMode_V42 then
    return self:RequestPermission(PermissionEnum.Camera)
  end
  return AllowCode
end
function FunctionPermission:RequestReadWriteExternalStoragePermission()
  if not BackwardCompatibilityUtil.CompatibilityMode_V42 then
    return self:RequestPermission(PermissionEnum.ReadWriteExternalStorage)
  end
  return AllowCode
end
function FunctionPermission:RequestFineLocationPermission()
  if not BackwardCompatibilityUtil.CompatibilityMode_V42 then
    return self:RequestPermission(PermissionEnum.FineLocation)
  end
  return AllowCode
end
function FunctionPermission:RequestCoarseLocationPermission()
  if not BackwardCompatibilityUtil.CompatibilityMode_V42 then
    return self:RequestPermission(PermissionEnum.CoarseLocation)
  end
  return AllowCode
end
function FunctionPermission:RequestRecordAudioPermission()
  if not BackwardCompatibilityUtil.CompatibilityMode_V42 then
    return self:RequestPermission(PermissionEnum.RecordAudio)
  end
  return AllowCode
end
function FunctionPermission:RequestPermission(permission)
  return self:AndroidRequestPermission(permission)
end
function FunctionPermission:AndroidRequestPermission(permission)
  if not PlatformAndroid then
    return AllowCode
  end
  if BackwardCompatibilityUtil.CompatibilityMode_V42 then
    return AllowCode
  end
  local requestCode = AndroidPermissionUtil.NextRequestCode
  if not BackwardCompatibilityUtil.CompatibilityMode_V56 then
    if self:GetPermissionIsOpen(permission) then
      return AllowCode
    elseif self:GetPermissionIsNeedShow(permission) or self:GetPermissionIsFirst(permission) then
      local config = self:GetPermissionMsgConfig(permission)
      MsgManager.AndroidPerissonMsg(config.msgId, function()
        AndroidPermissionUtil.Instance:RequestPermission(permission, requestCode, RequestCallback)
        self:SetPlayerPrefsPermission(permission)
      end)
      config.requestCode = requestCode
    else
      AndroidPermissionUtil.Instance:RequestPermission(permission, requestCode, RequestCallback)
    end
    return requestCode
  end
end
function FunctionPermission:SetRequestCallbackPPrefs(requestCode, grantResult)
  if not BackwardCompatibilityUtil.CompatibilityMode_V56 then
    local msgId = self:GetPermissionMsgIdByRequestCode(requestCode)
    if grantResult == GrantResult.Granted then
      LocalSaveProxy.Instance:RemoveDontShowAgain(msgId)
    elseif grantResult == GrantResult.Denied then
      LocalSaveProxy.Instance:AddDontShowAgain(msgId, 2)
    end
  end
end
function FunctionPermission:GetPermissionMsgConfig(permission)
  if PermissionMsgID == nil then
    return nil
  end
  for _, v in pairs(PermissionMsgID) do
    if v._type == permission then
      return v
    end
  end
  return nil
end
function FunctionPermission:GetPermissionMsgIdByRequestCode(_requestCode)
  if PermissionMsgID == nil then
    return nil
  end
  for _, v in pairs(PermissionMsgID) do
    if v.requestCode and v.requestCode == _requestCode then
      return v.msgId
    end
  end
  return nil
end
function FunctionPermission:GetPermissionIsOpen(permission)
  return AndroidPermissionUtil.Instance:GetPermissionState(permission) == GrantResult.Granted
end
function FunctionPermission:GetPermissionIsNeedShow(permission)
  return AndroidPermissionUtil.Instance:GetPermissionIsNeedPrompt(permission)
end
function FunctionPermission:GetPermissionIsFirst(permission)
  if PermissionMsgID == nil then
    return false
  end
  for _, v in pairs(PermissionMsgID) do
    if v._type == permission then
      return PlayerPrefs.GetInt(v.PlayerPrefsKey, 0) ~= 1
    end
  end
end
function FunctionPermission:SetPlayerPrefsPermission(permission)
  if PermissionMsgID == nil then
    return nil
  end
  for _, v in pairs(PermissionMsgID) do
    if v._type == permission then
      PlayerPrefs.SetInt(v.PlayerPrefsKey, 1)
    end
  end
end
