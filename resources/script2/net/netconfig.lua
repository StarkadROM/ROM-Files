NetConfig = {}
NetConfig.PUBLIC_SPECIAL_SERVER_IP = "115.182.65.36"
NetConfig.PUBLIC_SPECIAL_SERVER_PORT = 10000
NetConfig.PRIVATE_GAME_SERVER_IP = "172.24.15.236"
NetConfig.PRIVATE_GAME_SERVER_PORT = 9000
NetConfig.PUBLIC_GAME_SERVER_IP = "223.202.22.30"
NetConfig.PUBLIC_GAME_SERVER_PORT = 5000
NetConfig.PrivateAuthServerUrl = "172.26.31.40"
NetConfig.PrivateAuthServerUrlPort = 5556
NetConfig.PrivateGameServerUrl = "172.24.15.238"
NetConfig.PrivateGameServerUrlPort = 8888
NetConfig.TrafficSDKAPPID = "TrafficSDKAPPID"
NetConfig.PriorityMessages = {
  {id1 = 5, id2 = 23}
}
NetConfig.NewInstallTipUrl = "https://ro.com/newserver?source=roclient"
NetConfig.SyncInstallDeviceIDUrl = "https://vc-m-ro-gf.xd.com:5003/pushkey?key=%s"
NetConfig.GetAccDataAddress = "/register?access_token="
NetConfig.AnnounceAddress = "game-notice.oss-cn-hangzhou.aliyuncs.com/ro"
NetConfig.NewAccessTokenAuthHost = {
  "auth-m-ro-gf.xd.com",
  "auth-m-ro.xd.com",
  "auth-m-ro-foreign.xd.com"
}
NetConfig.GateHost = {
  CN = {
    "gw-m-ro-gf.xd.com",
    "gw-m-ro.xd.com"
  },
  EN = {
    "gw-m-ro-foreign.xd.com"
  }
}
NetConfig.NewGateHost = {
  "gw-m-ro-gf.xd.com",
  "gw-m-ro.xd.com",
  "gw-m-ro-foreign.xd.com"
}
NetConfig.NewGateHost_NOTEST = {
  "gw-m-ro-gf.xd.com",
  "gw-m-ro.xd.com",
  "gw-m-ro-foreign.xd.com"
}
NetConfig.NewGateHostGf = NetConfig.NewGateHost[1]
NetConfig.NewGateHostFg = NetConfig.NewGateHost[3]
NetConfig.UCloud_Report = "https://cn.upm.xindong.com/api/v1/pushmessage"
NetConfig.AccessTokenRealNameCentifyUrl_Xd = "/authorize?access_token="
NetConfig.AccessTokenAuthUrl_Xd = "/login?access_token="
NetConfig.ActivateUrl_Xd = "/activate?access_token="
NetConfig.ActivateUrl_AnySdk = "/anyactivate?"
NetConfig.SyncDidUrl = "https://api.xd.com/v1/user/set_ro_did?did=%s&access_token=%s"
NetConfig.GetMobileVerifyCodeUrl = "https://api.xd.com/v1/authorizations/get_mobile_verify_code"
NetConfig.BindMobileUrl = "https://api.xd.com/v1/user/bind_mobile"
NetConfig.AliyunNetDelayDelta = 80
NetConfig.ResponseCodeOk = 200
NetConfig.HttpRequestTimeOut = 10
NetConfig.TcpRequestTimeOut = 5000
NetConfig.DnsResolveTimeOut = 5
NetConfig.SocketConnectTestTimeOut = 5
NetConfig.GetAliyunIpTimeOut = 5
NetConfig.PBC = false
NetConfig.IsOldNet = true
if not BackwardCompatibilityUtil.CompatibilityMode_V35 then
  NetConfig.PBC = true
end
local bOldNet
local suc, msg = pcall(function()
  bOldNet = NetConnectionManager.Instance.oldNet
end)
if suc then
  NetConfig.IsOldNet = bOldNet
end
function NetConfig.IsHeart(id1, id2)
  return id1 == 1 and id2 == 10
end
function NetConfig.IsCare(id1, id2)
  return false
end
NetConfig.NoPbUnpack = {}
function NetConfig.IsNoPbUnpack(id1, id2)
  for i = 1, #NetConfig.NoPbUnpack do
    local single = NetConfig.NoPbUnpack[i]
    if single.id1 == id1 and single.id2 == id2 then
      return true
    end
  end
  return false
end
if BranchMgr.IsJapan() then
  autoImport("NetConfig_Japan")
elseif BranchMgr.IsTW() then
  autoImport("NetConfig_TW")
elseif BranchMgr.IsKorea() then
  autoImport("NetConfig_Korea")
elseif BranchMgr.IsSEA() then
  autoImport("NetConfig_SEA")
elseif BranchMgr.IsNA() then
  autoImport("NetConfig_NA")
elseif BranchMgr.IsEU() then
  autoImport("NetConfig_EU")
end
