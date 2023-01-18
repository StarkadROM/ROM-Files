if not BranchMgr.IsChina() then
  autoImport("GoogleStorageConfig")
end
XDCDNInfo = {}
local FILE_SERVER_URL_S = "https://ro.xdcdn.net"
local FILE_SERVER_URL = "http://ro.xdcdn.net"
function XDCDNInfo.GetFileServerURL()
  if not BranchMgr.IsChina() then
    return GoogleStorageConfig.googleStorageDownLoad
  end
  local url = FILE_SERVER_URL_S
  local runtimePlatform = ApplicationInfo.GetRunPlatform()
  if runtimePlatform == RuntimePlatform.Android or runtimePlatform == RuntimePlatform.WindowsEditor then
    url = FILE_SERVER_URL
  end
  return url
end
function XDCDNInfo.GetAudioServerURL()
  if BranchMgr.IsJapan() then
    return RO.Config.BuildBundleEnvInfo.ResCDN .. "assets"
  end
  return FILE_SERVER_URL_S
end
