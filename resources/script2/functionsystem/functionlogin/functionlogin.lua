FunctionLogin = class("FunctionLogin")
autoImport("FunctionLoginXd")
autoImport("FunctionLoginAny")
autoImport("FunctionGetIpStrategy")
autoImport("ScenicSpotPhotoNew")
autoImport("GamePhoto")
autoImport("FunctionLoginAnnounce")
autoImport("SelectServerPanel")
FunctionLogin.AuthStatus = {
  Ok = 0,
  OherError = 1,
  GetServerListFailure = 2,
  CreateRoleFailure = 3,
  OverTime = 4,
  NoActive = 9
}
FunctionLogin.LoginCode = {
  SdkLoginCancel = 1,
  SdkLoginSuc = 2,
  SdkLoginFailure = 3,
  SdkLoginNoneSdkType = 4
}
FunctionLogin.AccountState = {
  New = 0,
  InActivate = 1,
  Activate = 2
}
FunctionLogin.ErrorCode = {
  RequestAuthAccToken_NoneToken = 2001,
  StartActive_NoneToken = 2002,
  CheckAccTokenValid_Failure_GetServerListFailure = 2005,
  CheckAccTokenValid_Failure_CreateRoleFailure = 2006,
  Login_TokenInValid = 2010,
  LoginDataHandler_ServerListEmpty = 2011,
  Login_SDKLoginFailure = 2008,
  Login_SDKLaunchFailure = 2009,
  Login_SDKLoginCancel = 2012,
  StartGameLogin_NoneSdkType = 2013,
  AuthHostHandler_Failure = 10000,
  LoginDataHandler_Failure = 30000,
  HandleConnectServer = 40000,
  InvalidServerIP = 50000,
  RequestCreateAccNetError = 60000,
  RequestCreateAccParseError = 70000,
  LoginAnnounceError = 900000,
  LoginAnnounceFormatError = 900001
}
FunctionLogin.PlatformEnum = {
  [RuntimePlatform.IPhonePlayer] = ProtoCommon_pb.PHONE_PLAT_IOS,
  [RuntimePlatform.Android] = ProtoCommon_pb.PHONE_PLAT_ANDROID
}
function FunctionLogin.Me()
  if not BranchMgr.IsChina() then
    autoImport("OverseaHostHelper")
    local sdkType = FunctionSDK.Instance.CurrentType
    if sdkType == FunctionSDK.E_SDKType.TXWY then
      autoImport("FunctionLoginTXWY")
    elseif sdkType == FunctionSDK.E_SDKType.TDSG then
      autoImport("FunctionLoginTDSG")
    end
  end
  if nil == FunctionLogin.me then
    FunctionLogin.me = FunctionLogin.new()
  end
  return FunctionLogin.me
end
function FunctionLogin:ctor()
  self.gatePort = nil
  self.connectTime = 0
  self.trafficFailureTime = 0
  self.reconnectTimes = 0
  self.delayTime = 0
  self.privateMode = false
  self.PrivatePlat = 1
  self.ShowWeChat = not Game.inAppStoreReview
  self.Debug = false
  self.debugServerVersion = "1.3.14"
  self.debugPlat = 3
  self.debugServerPort = 5999
  self.debugAuthPort = 5002
  self.debugClientCode = 13
  local tokens = {
    LXY = "1ec43da401cc32a3ac49a9174e8b5610",
    ZGB = "9e20c4ff0c64b1ff820f549f48404690",
    STB = "cada1fbebab105edc9f2e7a087daaa9f",
    HJY = "fa72c04c7993917886766c87255e6c4e",
    KM = "5396f64b0d8207d8eaea75d9c6848af0",
    WSKC = "b67c8c4ea1b8fa2c097adc424b171f41",
    ZXZSF = "8004f18b47ceb1147e0b4a8368f620ac",
    KMMM = "88a1dab6d2e930a9ed1e19f5f865185b"
  }
  self.debugToken = tokens.ZXZSF
  self:initTrafficSDK()
end
function FunctionLogin:initTrafficSDK()
  helplog("FunctionLogin:initTrafficSDK( )")
  local compatible = BackwardCompatibilityUtil.CompatibilityMode_V33
  if compatible then
    return
  end
  if not BranchMgr.IsChina() then
    return
  end
  FunctionTrafficSdk.GetInstance():init()
  FunctionTrafficSdk.GetInstance():SetCallback(function()
    self:TrafficCheckFinish()
  end, function(failureMsg)
    self:TrafficCheckFailure(failureMsg)
  end, function()
    self:TrafficCheckCancel()
  end)
end
function FunctionLogin:TrafficCheckFinish()
  helplog("FunctionLogin:TrafficCheckFinish( )")
  self.trafficFailureTime = 0
  EventManager.Me():PassEvent(NewLoginEvent.TrafficCheckFinish, nil)
end
function FunctionLogin:TrafficCheckFailure(failureMsg)
  helplog("FunctionLogin:TrafficCheckFailure( )", failureMsg)
  EventManager.Me():PassEvent(NewLoginEvent.EnableLoginCollider, nil)
  self.trafficFailureTime = self.trafficFailureTime + 1
  MsgManager.ShowMsgByIDTable(33500)
end
function FunctionLogin:TrafficCheckCancel()
  helplog("FunctionLogin:TrafficCheckCancel( )")
  EventManager.Me():PassEvent(NewLoginEvent.EnableLoginCollider, nil)
  self.trafficFailureTime = 0
end
function FunctionLogin:StartActive(cdKey, callback)
  local fucntionSdk = self:getFunctionSdk()
  if fucntionSdk then
    fucntionSdk:StartActive(cdKey, callback)
  end
end
function FunctionLogin:requestGetUrlHost(url, callback, address, privateMode)
  local phoneplat = ApplicationInfo.GetRunPlatformStr()
  local timestamp = os.time()
  timestamp = string.format("&timestamp=%s&phoneplat=%s", timestamp, phoneplat)
  local requests = HttpWWWSeveralRequests()
  if privateMode or self.privateMode then
    local ip = NetConfig.PrivateAuthServerUrl
    ip = string.format("http://%s%s%s", ip, url, timestamp)
    LogUtility.InfoFormat("FunctionLogin:requestGetUrlHost address url:{0}", ip)
    local order = HttpWWWRequestOrder(ip, NetConfig.HttpRequestTimeOut, nil, false, true)
    requests:AddOrder(order)
  elseif address and "" ~= address then
    local ip = address
    ip = string.format("https://%s%s%s", ip, url, timestamp)
    LogUtility.InfoFormat("FunctionLogin:requestGetUrlHost address url:{0}", ip)
    local order = HttpWWWRequestOrder(ip, NetConfig.HttpRequestTimeOut, nil, false, true)
    requests:AddOrder(order)
  else
    local ips = FunctionGetIpStrategy.Me():getRequestAddresss()
    for i = 1, #ips do
      local ip = ips[i]
      ip = string.format("https://%s%s%s", ip, url, timestamp)
      LogUtility.InfoFormat("FunctionLogin:requestGetUrlHost url:{0}", ip)
      local order = HttpWWWRequestOrder(ip, NetConfig.HttpRequestTimeOut, nil, false, true)
      requests:AddOrder(order)
    end
  end
  requests:SetCallBacks(function(response)
    callback(NetConfig.ResponseCodeOk, response.resString)
  end, function(order)
    local IsOverTime = order.IsOverTime
    LogUtility.InfoFormat("FunctionLogin:requestGetUrlHost IsOverTime:{0}", IsOverTime)
    LogUtility.InfoFormat("FunctionLogin:requestGetUrlHost occur error,url:{0},address:{1},errorMsg:{2}", url, address, order.orderError)
    callback(FunctionLogin.AuthStatus.OherError, order)
  end)
  requests:StartRequest()
end
function FunctionLogin:LoginDataHandler(status, content, callback)
  local functionSdk = self:getFunctionSdk()
  if functionSdk then
    functionSdk:LoginDataHandler(status, content, callback)
  end
end
function FunctionLogin:connectGameServer(callback, isRestart)
  Buglylog("FunctionLogin:connectGameServer")
  local port = self:getServerPort()
  if self.privateMode then
    local serverHost = NetConfig.PrivateGameServerUrl
    LogUtility.InfoFormat("getServerSync,serverHost:{0} port:{1}", serverHost, port)
    NetManager.ConnGameServer(serverHost, port, function(state, netDelay)
      self.netDelay = netDelay
      self:handleConnectServer(state, callback, isRestart)
    end)
  else
    if not BackwardCompatibilityUtil.CompatibilityMode_V60 or not BranchMgr.IsChina() then
      FunctionTyrantdb.Instance:trackEvent("#ConnectSocketStart", nil)
    end
    FunctionGetIpStrategy.Me():getServerIpSync(function(result)
      if result and result ~= "" then
        local serverHost = result.ip and result.ip or result
        LogUtility.InfoFormat("getServerIpAsync,serverHost:{0} port:{1}", serverHost, port)
        if result.socket and not Slua.IsNull(result.socket) then
          Game.NetConnectionManager:setSocket(result.socket)
          self.netDelay = result.delay
          self:handleConnectServer(NetState.Connect, callback, isRestart)
        else
          NetManager.ConnGameServer(serverHost, port, function(state, netDelay)
            self.netDelay = netDelay
            self:handleConnectServer(state, callback, isRestart)
          end)
        end
      else
        if not BranchMgr.IsChina() then
          FunctionLoginAnnounce.Me():showCDNAnnounce()
        else
          MsgManager.ShowMsgByIDTable(1017, {
            FunctionLogin.ErrorCode.InvalidServerIP
          })
        end
        GameFacade.Instance:sendNotification(NewLoginEvent.LoginFailure)
      end
    end)
  end
end
function FunctionLogin:connectLanGameServer(accid, callback, isRestart)
  local ips = self:getServerIp()
  local ip = ips[1]
  local port = self:getServerPort()
  LogUtility.InfoFormat("FunctionLogin:connectLanGameServer(  )ip:{0},port:{1} accid:{2}", ip, port, tostring(accid))
  GameFacade.Instance:sendNotification(NewLoginEvent.StartLogin)
  NetManager.ConnGameServer(ip, port, function(state, netDelay)
    self.netDelay = netDelay
    self:handleConnectLanServerSuccess(state, accid, callback, isRestart)
  end)
end
function FunctionLogin:handleConnectLanServerSuccess(state, accid, callback, isRestart)
  self.recvReqLoginParamCallback = callback
  LogUtility.InfoFormat("handleConnectLanServerSuccess:state:{0}", state)
  if state ~= NetState.Connect then
    FunctionGetIpStrategy.Me():setHasConnFailure(true)
    if not isRestart and state ~= 10051 and self:startTryReconnectLan(accid, callback, isRestart) then
      return
    end
    self:clearReconnectRelated()
    if isRestart then
    else
      UIWarning.Instance:HideBord()
      if state == NetState.Timeout or state == 10051 then
        FunctionNetError.Me():ShowErrorById(11)
      else
        MsgManager.ShowMsgByIDTable(1017, {
          FunctionLogin.ErrorCode.HandleConnectServer + state
        })
      end
    end
    GameFacade.Instance:sendNotification(NewLoginEvent.LoginFailure)
  else
    FunctionGetIpStrategy.Me():setHasConnFailure(false)
    local accid = tonumber(accid)
    LogUtility.InfoFormat("CallReqLoginParamUserCmd:accid:{0}", accid)
    GameFacade.Instance:sendNotification(NewLoginEvent.ReqLoginUserCmd)
    local linegroup = 1
    if self.serverData then
      linegroup = tonumber(self.serverData.linegroup or 1)
    end
    ServiceLoginUserCmdProxy.Instance:CallReqLoginParamUserCmd(accid, nil, nil, nil, nil, linegroup)
    self:HandleConnectSus()
  end
end
function FunctionLogin:RecvReqLoginParamUserCmd(data)
  local loginData = {}
  loginData.sha1 = data.sha1
  loginData.accid = data.accid
  loginData.timestamp = data.timestamp
  if not BranchMgr.IsChina() then
    loginData.zoneid = self.ServerZone
  end
  GamePhoto.SetPlayerAccount(data.accid)
  self:setLoginData(loginData)
  self:LoginUserCmd()
  if self.recvReqLoginParamCallback then
    self.recvReqLoginParamCallback()
  end
end
function FunctionLogin:clearConnectTime()
  self.connectTime = 0
end
function FunctionLogin:handleConnectServer(state, callback, isRestart)
  LogUtility.InfoFormat("handleConnectServer:state:{0}", state)
  Buglylog("FunctionLogin:handleConnectServer state:" .. tostring(state))
  if state ~= NetState.Connect then
    FunctionGetIpStrategy.Me():setHasConnFailure(true)
    if not isRestart and state ~= 10051 and self:startTryReconnect(callback, isRestart) then
      return
    end
    self:clearReconnectRelated()
    if isRestart then
    else
      UIWarning.Instance:HideBord()
      if state == NetState.Timeout or state == 10051 then
        FunctionNetError.Me():ShowErrorById(11)
      else
        MsgManager.ShowMsgByIDTable(1017, {
          FunctionLogin.ErrorCode.HandleConnectServer + state
        })
      end
    end
    GameFacade.Instance:sendNotification(NewLoginEvent.LoginFailure)
  else
    FunctionGetIpStrategy.Me():setHasConnFailure(false)
    self:clearReconnectRelated()
    self:HandleConnectSus()
    self:LoginUserCmd()
    if callback then
      callback()
    end
  end
end
function FunctionLogin:startTryReconnect(callback, isRestart)
  if self.reconnectTimes < 5 then
    local port = self:getServerPort()
    if self.reconnectTimes == 0 then
      GameFacade.Instance:sendNotification(NewLoginEvent.StartReconnect)
    end
    if self.delayTime and 0 < self.delayTime then
      TimeTickManager.Me():CreateOnceDelayTick(self.delayTime * 1000, function(owner, deltaTime)
        self:connectGameServer(callback, isRestart)
      end, self)
    else
      self:connectGameServer(callback, isRestart)
    end
    self.reconnectTimes = self.reconnectTimes + 1
    self.delayTime = self.delayTime + self.reconnectTimes + math.random() * self.reconnectTimes
    return true
  end
  return false
end
function FunctionLogin:clearReconnectRelated()
  self.reconnectTimes = 0
  self.delayTime = 0
  GameFacade.Instance:sendNotification(NewLoginEvent.StopReconnect)
end
function FunctionLogin:startTryReconnectLan(accid, callback, isRestart)
  if self.reconnectTimes < 5 then
    local port = self:getServerPort()
    if self.reconnectTimes == 0 then
      GameFacade.Instance:sendNotification(NewLoginEvent.StartReconnect)
    end
    if self.delayTime and 0 < self.delayTime then
      TimeTickManager.Me():CreateOnceDelayTick(self.delayTime * 1000, function(owner, deltaTime)
        self:connectLanGameServer(accid, callback, isRestart)
      end, self)
    else
      self:connectLanGameServer(accid, callback, isRestart)
    end
    self.reconnectTimes = self.reconnectTimes + 1
    self.delayTime = self.delayTime + self.reconnectTimes + math.random() * self.reconnectTimes
    return true
  end
  return false
end
function FunctionLogin:stopTryReconnect()
  self:clearReconnectRelated()
  ServiceConnProxy.Instance:StopHeart()
end
function FunctionLogin:HandleConnectSus()
  ServiceConnProxy.Instance:HandleConnect()
  if not BackwardCompatibilityUtil.CompatibilityMode_V60 or not BranchMgr.IsChina() then
    FunctionTyrantdb.Instance:trackEvent("#ConnectSocketSus", nil)
  end
end
function FunctionLogin:getServerVersion()
  local version = VersionUpdateManager.CurrentServerVersion
  if version == nil then
    version = self.debugServerVersion or version
  end
  if AppEnvConfig.IsTestApp then
    version = self.debugServerVersion
  end
  version = tostring(version)
  return version
end
function FunctionLogin:LoginUserCmd()
  Buglylog("FunctionLogin:LoginUserCmd")
  local loginData = self:getLoginData()
  if not loginData then
    GameFacade.Instance:sendNotification(NewLoginEvent.LoginFailure)
    return
  end
  local accid = loginData.accid
  if not BranchMgr.IsChina() then
    OverseaHostHelper.accId = accid
  end
  local sha1 = tostring(loginData.sha1)
  local timestamp = tonumber(loginData.timestamp)
  local version = self:getServerVersion()
  local socketInfo = FunctionGetIpStrategy.Me():getCurrentSocketInfo()
  local domain, ip
  if socketInfo then
    ip = socketInfo.ip
    domain = socketInfo.domain
  end
  local device = "editor"
  local runtimePlatform = ApplicationInfo.GetRunPlatform()
  if runtimePlatform == RuntimePlatform.Android then
    device = "android"
  elseif runtimePlatform == RuntimePlatform.IPhonePlayer then
    device = "ios"
  elseif runtimePlatform == RuntimePlatform.WindowsPlayer then
    device = "Windows"
  elseif runtimePlatform == RuntimePlatform.WindowsEditor then
    device = "Windows"
  end
  local phone = self:getPhoneNum()
  local param = self:getSecurityParam()
  local loginVersion = self:getLoginVersion()
  local zone = ApplicationInfo.GetSystemLanguage()
  local langzone = 0
  local site = self:getLoginSite() or 0
  site = tonumber(site)
  local authoriz = self:getLogin_authoriz_state()
  authoriz = tostring(authoriz)
  local linegroup
  linegroup = self.serverData and (self.serverData.linegroup or 1)
  local zoneid
  if self.serverData then
    zoneid = tonumber(self.serverData.serverid)
  end
  if BranchMgr.IsSEA() or BranchMgr.IsNA() or BranchMgr.IsEU() then
    langzone = OverseaHostHelper.langZone
    OverseaHostHelper:ResetSectors(zoneid)
    helplog("send to server langzong:" .. langzone)
  end
  local did = DeviceInfo.GetID()
  local appPreVersion = CompatibilityVersion.appPreVersion
  local smDeviceID = ""
  if not BackwardCompatibilityUtil.CompatibilityMode_V60 then
    smDeviceID = ExternalInterfaces.GetSmDeviceID()
  end
  LogUtility.InfoFormat("FunctionLogin:LoginUserCmd CallReqLoginUserCmd:zoneid:{0},version:{1}", zoneid, version)
  LogUtility.InfoFormat("accid:{0},sha1:{1}", accid, sha1)
  LogUtility.InfoFormat("netDelay:{0},userIp:{1}", self.netDelay, userIp)
  LogUtility.InfoFormat("ip:{0},domain:{1}", ip, domain)
  LogUtility.InfoFormat("param:{0},zone:{1}", param, zone)
  LogUtility.InfoFormat("zoneid:{0},timestamp:{1}", zoneid, timestamp)
  LogUtility.InfoFormat("device:{0},phone:{1}", device, phone)
  LogUtility.InfoFormat("linegroup:{0},did:{1},smDeviceID:{2}", linegroup, did, smDeviceID)
  ServiceLoginUserCmdProxy.Instance:CallServerTimeUserCmd()
  ServiceLoginUserCmdProxy.Instance:CallReqLoginUserCmd(accid, sha1, zoneid, timestamp, version, domain, ip, device, phone, param, zone, site, authoriz, linegroup, did, appPreVersion, langzone, smDeviceID)
  self.netDelay = 0 < self.netDelay and self.netDelay or 0
  GameFacade.Instance:sendNotification(NewLoginEvent.ReqLoginUserCmd)
end
function FunctionLogin:reStartGameLogin(callback)
  local sdkEnable = self:getSdkEnable()
  local loginData = self:getLoginData()
  FunctionGetIpStrategy.Me():setReConnectState(true)
  if sdkEnable then
    LogUtility.InfoFormat("reStartGameLogin sdkEnable:{0} ", sdkEnable)
    local functionSdk = self:getFunctionSdk()
    if functionSdk then
      functionSdk:startSdkGameLogin(function()
        self:connectGameServer(callback, true)
      end)
    end
  else
    self:connectLanGameServer(loginData.accid, callback, true)
  end
end
function FunctionLogin:LaunchSdk(callback)
  LogUtility.Info("FunctionLogin:LaunchSdk(  )")
  local fucntionSdk = self:getFunctionSdk()
  if fucntionSdk then
    fucntionSdk:LaunchSdk(callback)
  end
end
function FunctionLogin:startSdkLogin(callback)
  local fucntionSdk = self:getFunctionSdk()
  if fucntionSdk then
    fucntionSdk:startSdkLogin(callback)
  end
end
function FunctionLogin:startAuthAccessToken(callback)
  LogUtility.Info("FunctionLogin:startAuthAccessToken(  )")
  local fucntionSdk = self:getFunctionSdk()
  if fucntionSdk then
    fucntionSdk:startAuthAccessToken(callback)
  end
end
function FunctionLogin:HasLoginSucess()
  return self:getLoginData() and self:isLogined()
end
function FunctionLogin:startGameLogin(serverData, accid, callback)
  ServiceConnProxy.Instance:StopHeart()
  LogUtility.InfoFormat("FunctionLogin:startGameLogin(  ) loginData and accid:{0}", accid)
  local SDKEnable = self:getSdkEnable()
  if accid and not SDKEnable then
    self.serverData = serverData
    self.ServerZone = serverData.serverid
    self:connectLanGameServer(accid, callback)
  else
    local loginData = self:getLoginData()
    local isLogined = self:isLogined()
    if not isLogined or not loginData then
      local functionSdk = self:getFunctionSdk()
      if functionSdk then
        functionSdk:setLoginData(nil)
        functionSdk:startSdkGameLogin(callback)
      end
    else
      if serverData and not self:isOldServerversion(serverData) then
        local functionSdk = self:getFunctionSdk()
        if functionSdk then
          functionSdk:setLoginDataByServerRegion(serverData)
        end
      end
      self.serverData = serverData
      if not self:isOldServerversion(serverData) and StringUtil.IsEmpty(serverData.accid) or serverData.accid == 0 then
        self:tryGetAccDataFromRemote(serverData, function(code, msg)
          if code == NetConfig.ResponseCodeOk then
            self.serverData.accid = tonumber(msg.accid)
            self.serverData.sha1 = msg.sha1
            self.serverData.timestamp = msg.timestamp
            self:startGameLogin(self.serverData, accid, callback)
          else
            MsgManager.ShowMsgByIDTable(1017, {code})
            GameFacade.Instance:sendNotification(NewLoginEvent.LoginFailure)
          end
        end)
      else
        self:tryGetAccDataFromRemote(serverData)
        self:connectGameServer(callback)
      end
    end
  end
end
function FunctionLogin:isOldServerversion(serverData)
  if StringUtil.IsEmpty(serverData.accid) then
    return true
  end
end
function FunctionLogin:tryGetAccDataFromRemote(serverData, callback)
  local functionSdk = self:getFunctionSdk()
  if functionSdk then
    functionSdk:StartRequestRegist(serverData, callback)
  else
    MsgManager.ShowMsgByIDTable(1017, {
      FunctionLogin.ErrorCode.StartGameLogin_NoneSdkType
    })
    GameFacade.Instance:sendNotification(NewLoginEvent.LoginFailure)
  end
end
function FunctionLogin:createRole(name, role_sex, profession, hair, haircolor, clothcolor, index, eye)
  haircolor = haircolor or 0
  bodycolor = bodycolor or 0
  name = tostring(name)
  role_sex = tonumber(role_sex) or 0
  profession = tonumber(profession) or 0
  hair = tonumber(hair) or 1
  haircolor = tonumber(haircolor) or 0
  clothcolor = tonumber(clothcolor) or 0
  index = index or 0
  eye = tonumber(eye) or 0
  ServiceLoginUserCmdProxy.Instance:CallCreateCharUserCmd(name, role_sex, profession, hair, haircolor, clothcolor, nil, index, nil, nil, nil, nil, nil, eye)
end
function FunctionLogin:getSdkEnable()
  if self.Debug then
    return true
  else
    local SDKEnable = EnvChannel.SDKEnable()
    return SDKEnable
  end
end
function FunctionLogin:getSdkType()
  if self.Debug then
    if not BranchMgr.IsChina() then
      return FunctionSDK.E_SDKType.TXWY
    else
      return FunctionSDK.E_SDKType.XD
    end
  else
    return FunctionSDK.Instance.CurrentType
  end
end
function FunctionLogin:isLogined()
  local functionSdk = self:getFunctionSdk()
  if functionSdk then
    return functionSdk:isLogined()
  end
end
function FunctionLogin:isDebug()
  return self.Debug
end
function FunctionLogin:isPrivateMode()
  return self.privateMode
end
function FunctionLogin:getServerDatas()
  local functionSdk = self:getFunctionSdk()
  if functionSdk then
    return functionSdk:getServerDatas()
  end
end
function FunctionLogin:getCurServerData()
  return self.serverData
end
function FunctionLogin:setCurServerData(serverData)
  self.serverData = serverData
end
function FunctionLogin:replaceBracket(arg)
  local str = string.gsub(arg, "{", "(")
  str = string.gsub(str, "}", ")")
  return str
end
function FunctionLogin:getDefaultServerData()
  local functionSdk = self:getFunctionSdk()
  if functionSdk then
    return functionSdk:getDefaultServerData()
  end
end
function FunctionLogin:getServerIp()
  local ips
  if self:getSdkEnable() then
    ips = EnvChannel.GetPublicIP()
  else
    ips = self.serverData.type == 2 and self.serverData.serverip or {
      NetConfig.PrivateGameServerUrl
    }
  end
  return ips
end
function FunctionLogin:setLoginData(data)
  self.loginData = data
  LogUtility.InfoFormat("setLoginData:accid:{0}", self.loginData.accid)
  local accid = tonumber(self.loginData.accid)
  self.loginData.accid = accid
  FunctionGetIpStrategy.Me():setAccId(accid)
end
function FunctionLogin:getLoginData()
  local sdkEnable = self:getSdkEnable()
  if sdkEnable then
    local functionSdk = self:getFunctionSdk()
    if functionSdk then
      return functionSdk:getLoginData()
    end
  else
    return self.loginData
  end
end
function FunctionLogin:isNeedCheckTrafficFromServer()
  if VersionUpdateManager then
    helplog("isNeedCheckTrafficFromServer:", VersionUpdateManager.isNeedCheckTraffic)
    return VersionUpdateManager.isNeedCheckTraffic
  end
end
function FunctionLogin:checkIsNeedCheck()
  if ApplicationInfo.IsWindows() then
    return false
  end
  local sdkEnable = self:getSdkEnable()
  local compatible = BackwardCompatibilityUtil.CompatibilityMode_V33
  if not sdkEnable or compatible then
    return false
  end
  if not self:getLoginData() then
    return false
  end
  if self.trafficFailureTime > 2 then
    return false
  end
  return self:isNeedCheckTrafficFromServer()
end
function FunctionLogin:getFunctionSdk()
  local sdkEnable = self:getSdkEnable()
  if not sdkEnable then
    return
  end
  local sdkType = self:getSdkType()
  if sdkType == FunctionSDK.E_SDKType.Any then
    return FunctionLoginAny.Me()
  elseif sdkType == FunctionSDK.E_SDKType.XD then
    return FunctionLoginXd.Me()
  elseif sdkType == FunctionSDK.E_SDKType.TXWY then
    return FunctionLoginTXWY.Me()
  elseif sdkType == FunctionSDK.E_SDKType.TDSG then
    return FunctionLoginTDSG.Me()
  else
    MsgManager.ShowMsgByIDTable(1017, {
      FunctionLogin.ErrorCode.StartGameLogin_NoneSdkType
    })
    GameFacade.Instance:sendNotification(NewLoginEvent.LoginFailure)
  end
end
function FunctionLogin:setServerPort(port)
  self.gatePort = port
end
function FunctionLogin:getServerPort()
  local port = self.serverData.port
  if self.Debug then
    port = self.debugServerPort
  end
  if self.privateMode then
    port = NetConfig.PrivateGameServerUrlPort
  end
  if self:getSdkEnable() then
    local verStr = VersionUpdateManager.serverResJsonString
    LogUtility.InfoFormat("FunctionLogin:getServerPort() verStr:{0}", verStr)
    local result = StringUtil.Json2Lua(verStr)
    if result and result.data then
      local data = result.data
      local tmp = tonumber(data.gateport)
      port = tmp and tmp or port
      local gateway_port = self:GetGatewayPort()
      port = not gateway_port or gateway_port or port
    end
  elseif self.serverData.type ~= 2 then
    port = NetConfig.PrivateGameServerUrlPort
  end
  self.gatePort = port
  LogUtility.InfoFormat("FunctionLogin:getServerPort() gatePort:{0}", port)
  return self.gatePort
end
function FunctionLogin:GetGatewayPort()
  local serverId = PlayerPrefs.GetInt("PlayerPrefsMyServerId")
  if serverId ~= nil then
    helplog("serverId :", serverId)
    for _, serverInfo in pairs(self:getServerDatas()) do
      helplog("===== :", serverInfo.serverid)
      if tostring(serverId) == tostring(serverInfo.serverid) then
        helplog("way ports :", serverInfo.gateway_ports)
        if serverInfo.gateway_ports ~= nil and #serverInfo.gateway_ports > 0 then
          helplog("result :", serverInfo.gateway_ports[1])
          self.gateway_port = tonumber(serverInfo.gateway_ports[1])
          PlayerPrefs.SetInt("PlayerPrefsMYServerPort", self.gateway_port)
          return self.gateway_port
        end
      end
    end
  end
  local cacheport = PlayerPrefs.GetInt("PlayerPrefsMYServerPort")
  if cacheport ~= nil and cacheport ~= "" then
    return cacheport
  end
  return self.gateway_port
end
function FunctionLogin:setSecurityParam(param)
  self.securityParam = param
end
function FunctionLogin:getSecurityParam()
  return self.securityParam
end
function FunctionLogin:getPhoneNum()
  return self.phoneNum
end
function FunctionLogin:setPhoneNum(phoneNum)
  self.phoneNum = phoneNum
end
function FunctionLogin:getLoginSite()
  return self.site
end
function FunctionLogin:setLoginSite(site)
  helplog("setLoginSite:", site)
  self.site = site
end
function FunctionLogin:getLoginVersion()
  return self.loginVersion
end
function FunctionLogin:setLoginVersion(loginVersion)
  self.loginVersion = loginVersion
end
function FunctionLogin:isCurrentNewServer()
  local serverData = self.serverData
  if not serverData then
    return false
  end
  return serverData.state == SelectServerPanel.ServerConfig.ComingSoon or serverData.state == SelectServerPanel.ServerConfig.New
end
function FunctionLogin:setLogin_authoriz_state(login_authoriz_state)
  helplog("setLogin_authoriz_state:", login_authoriz_state)
  self.login_authoriz_state = login_authoriz_state
end
function FunctionLogin:getLogin_authoriz_state(login_authoriz_state)
  return self.login_authoriz_state
end
function FunctionLogin:set_realName_Centified(b)
  self.realName_Centified = b
end
function FunctionLogin:get_realName_Centified()
  return self.realName_Centified
end
function FunctionLogin:set_IsTmp(is_tmp)
  self.is_tmp = is_tmp
end
function FunctionLogin:get_IsTmp()
  return self.is_tmp
end
function FunctionLogin:setAgreeStatus(isAgree)
  self.agreed = isAgree
end
function FunctionLogin:getAgreeStatus()
  return self.agreed
end
function FunctionLogin:launchAndLoginSdk(callback)
  EventManager.Me():PassEvent(NewLoginEvent.DisableLoginCollider, nil)
  local runtimePlatform = ApplicationInfo.GetRunPlatform()
  if runtimePlatform == RuntimePlatform.Android then
    self:LaunchSdk(function(state, msg)
      if state then
        self:startSdkLogin(function(code, msg)
          if code == FunctionLogin.LoginCode.SdkLoginSuc then
            self:startAuthAccessToken(callback)
          else
            GameFacade.Instance:sendNotification(NewLoginEvent.SDKLoginFailure)
          end
        end)
      else
        GameFacade.Instance:sendNotification(NewLoginEvent.LaunchFailure)
      end
    end)
    return
  end
  self:LaunchSdk(function(state, msg)
    local sdkType = FunctionLogin.Me():getSdkType()
    if state then
      self:startSdkLogin(function(code, msg)
        if ApplicationInfo.IsWindows() then
          EventManager.Me():PassEvent(NewLoginEvent.EnableLoginCollider, nil)
        end
        if code == FunctionLogin.LoginCode.SdkLoginSuc then
          if sdkType == FunctionSDK.E_SDKType.XD or sdkType == FunctionSDK.E_SDKType.TXWY or sdkType == FunctionSDK.E_SDKType.TDSG then
            self:startAuthAccessToken(callback)
          else
            self:LoginDataHandler(NetConfig.ResponseCodeOk, msg, callback)
          end
        else
          GameFacade.Instance:sendNotification(NewLoginEvent.SDKLoginFailure)
        end
      end)
    else
      GameFacade.Instance:sendNotification(NewLoginEvent.LaunchFailure)
    end
  end)
end
function FunctionLogin:GetRealNameCentifyUrl(realname, realid)
  local authUrl = NetConfig.AccessTokenRealNameCentifyUrl_Xd
  local sdkEnable = self:getSdkEnable()
  local port, token
  if not sdkEnable then
    token = FunctionLogin.Me().debugToken
    port = 5556
  else
    local login = self:getFunctionSdk()
    if login then
      token = login:getToken()
      port = login:GetAuthPort()
    end
  end
  return string.format(":%s%s%s&is_tmp=%s&realname=%s&realid=%s", port, authUrl, token, self.is_tmp or 0, realname, realid)
end
function FunctionLogin:GetLocalSavedDID()
  local customVersion = GameConfig.DidVersion or 1
  local pfKey = string.format("RO_DeviceID_%s", customVersion)
  return PlayerPrefs.GetString(pfKey)
end
function FunctionLogin:SyncLocalSavedDID()
  if ApplicationInfo.IsRunOnEditor() then
    LogUtility.Info("编辑器模式 无法使用jpush")
    return
  end
  local value = ROPush.GetRegistrationId() or "000"
  helplog("Jpush registID:", value)
end
function FunctionLogin:SyncServerDID()
  local url = NetConfig.SyncDidUrl
  local customVersion = GameConfig.DidVersion or 1
  local pfKey = string.format("RO_DeviceID_%s", customVersion)
  local value = PlayerPrefs.GetString(pfKey)
  local timestamp = os.time()
  local token
  local login = self:getFunctionSdk()
  if login then
    token = login:getToken()
  end
  if not token or not token then
    token = ""
  end
  if not value or value == "" then
    local did = DeviceInfo.GetID()
    value = string.format("%s:%s:%s", did, timestamp, customVersion)
    PlayerPrefs.SetString(pfKey, value)
    PlayerPrefs.Save()
    helplog("保存设备DID:", value)
  else
    helplog("获取设备DID:", value)
  end
  url = string.format(url, value, token)
  FunctionLoginAnnounce.Me():doRequest(url, function(status, content)
    helplog("同步设备DID完成！", status, content)
  end)
end
function FunctionLogin:GetMobileVerifyCode(mobile, area_code, callback)
  local baseurl = NetConfig.GetMobileVerifyCodeUrl
  local token
  local login = self:getFunctionSdk()
  if login then
    token = login:getToken()
  end
  token = token or FunctionLogin.Me().debugToken
  local request = HttpWWWSeveralRequests()
  local form = WWWForm()
  form:AddField("mobile", mobile)
  form:AddField("area_code", tostring(area_code))
  form:AddField("type", "bind_mobile")
  form:AddField("access_token", token)
  local timeoutSec = 30
  local order = HttpWWWRequestOrder(baseurl, timeoutSec, form, false, true)
  request:AddOrder(order)
  request:SetCallBacks(function(response)
    helplog("收到请求手机验证码resp:", response.resString)
    if callback then
      callback(NetConfig.ResponseCodeOk, response.resString)
    end
  end, function(order)
    local responseCode = order.request.responseCode
    local errorMsg = order.request.downloadHandler.text
    helplog("手机验证码request失败:", responseCode, errorMsg)
    if callback then
      callback(responseCode, errorMsg)
    end
  end)
  request:StartRequest()
end
function FunctionLogin:BindMobile(mobile, area_code, code, callback)
  local baseurl = NetConfig.BindMobileUrl
  local token
  local login = self:getFunctionSdk()
  if login then
    token = login:getToken()
  end
  token = token or FunctionLogin.Me().debugToken
  local request = HttpWWWSeveralRequests()
  local form = WWWForm()
  form:AddField("mobile", mobile)
  form:AddField("area_code", tostring(area_code))
  form:AddField("code", code)
  form:AddField("access_token", token)
  local timeoutSec = 30
  local order = HttpWWWRequestOrder(baseurl, timeoutSec, form, false, true)
  request:AddOrder(order)
  request:SetCallBacks(function(response)
    helplog("收到绑定手机resp:", response.resString)
    if callback then
      callback(NetConfig.ResponseCodeOk, response.resString)
    end
  end, function(order)
    local responseCode = order.request.responseCode
    local errorMsg = order.request.downloadHandler.text
    helplog("绑定手机request失败:", responseCode, errorMsg)
    if callback then
      callback(responseCode, errorMsg)
    end
  end)
  request:StartRequest()
end
function FunctionLogin:HasNewServer()
  local serverDatas = self:getServerDatas()
  if not serverDatas or #serverDatas == 0 then
    return 0
  end
  for i = 1, #serverDatas do
    local serverData = serverDatas[i]
    if serverData.state == 5 then
      return true
    end
  end
end
function FunctionLogin.GetStateText(state)
  if state == 4 then
    return "new"
  elseif state == 5 then
    return "coming soon"
  else
    return ""
  end
end
function FunctionLogin.GetStateColor(state)
  if state == 4 then
    return LuaColor(0.9882352941176471, 0.8666666666666667, 0.30980392156862746, 1)
  elseif state == 5 then
    return LuaColor(0.7647058823529411, 0.8901960784313725, 1, 1)
  else
    return LuaColor.White()
  end
end
function FunctionLogin.GetServerNameColor(state)
  if state == 5 then
    return LuaColor.White()
  else
    return LuaColor.White()
  end
end
function FunctionLogin.GetStateTextSize(state)
  if state == 5 then
    return 16
  else
    return 18
  end
end
function FunctionLogin.GetStateIcon(state)
  if state == 4 then
    return "login_icon_new"
  elseif state == 5 then
    if BranchMgr.IsChina() then
      return "login_icon_yzc"
    else
      return "login_icon_yzc2"
    end
  else
    return ""
  end
end
function FunctionLogin:GetLineGroup()
  if not self.serverData or StringUtil.IsEmpty(self.serverData.linegroup) then
    return
  end
  return self.serverData.linegroup
end
local uncompleteOrders = {}
function FunctionLogin.clearRestorePay()
  helplog("clearstoredPayInfos:")
  TableUtility.TableClear(uncompleteOrders)
end
function FunctionLogin.getRestorePays()
  return uncompleteOrders
end
function FunctionLogin.onRestoredPayment(OrderId, Product_Id, Product_Num)
  helplog("onRestoredPayment:", OrderId, Product_Id, Product_Num)
  uncompleteOrders[OrderId] = {
    OrderId = OrderId,
    Product_Id = Product_Id,
    Product_Num = Product_Num
  }
end
function FunctionLogin.delRestoredPayment(OrderId)
  helplog("delRestoredPayment:", OrderId, Product_Id, Product_Num)
  uncompleteOrders[OrderId] = nil
end
local currentSendIndex = 1
function FunctionLogin.requestRandomTwServer()
  if not BranchMgr.IsTW() or currentSendIndex > 5 then
    return
  end
  local loginData = FunctionLogin.Me():getLoginData()
  if not loginData then
    return
  end
  local accid = loginData.accid
  local needSend = math.fmod(accid, 10) > 4
  if not needSend then
    return
  end
  LogUtility.Info("FunctionLogin:requestRandomTwServer")
  local serverurl = {
    "https://tnq-00.ro.com/ping",
    "https://tnq-wj.ro.com/ping",
    "https://tnq-wh.ro.com/ping",
    "https://tnq-lp.ro.com/ping",
    "https://tnq-lk.ro.com/ping"
  }
  helplog("WWWRequestManager url:", serverurl[currentSendIndex])
  Game.WWWRequestManager:SimpleRequest(serverurl[currentSendIndex], 5, function(www)
    LogUtility.Info("FunctionLogin:requestRandomTwServer success:")
    FunctionLogin.requestRandomTwServer()
  end, function(www, error)
    LogUtility.Info("FunctionLogin:requestRandomTwServer error:")
    FunctionLogin.requestRandomTwServer()
  end, function(www)
    LogUtility.Info("FunctionLogin:requestRandomTwServer OverTime")
    FunctionLogin.requestRandomTwServer()
  end)
  currentSendIndex = currentSendIndex + 1
end
local RepeatInterval = {
  [1] = 600,
  [2] = 300,
  [3] = 180,
  [4] = 60
}
function FunctionLogin:RecvKickCharUserCmd(data)
  self.patchDeadline = data.force
  self.updateTime = ServerTime.CurServerTime() / 1000 + self.patchDeadline
  local platform = ApplicationInfo.GetRunPlatform()
  redlog("RecvKickCharUserCmd", self.patchDeadline, platform)
  if platform then
    local curP = FunctionLogin.PlatformEnum[platform]
    local versions = data.versions
    redlog("#versions", #versions, curP)
    local resVersion = VersionUpdateManager.CurrentVersion
    local flag = ApplicationInfo.IsRunOnEditor()
    for i = 1, #versions do
      local single = versions[i]
      redlog("curP == single.phoneplat", curP, single.phoneplat)
      if curP == single.phoneplat then
        redlog("resVersion ~= single.version", resVersion, single.version)
        if resVersion ~= single.version then
          flag = true
          break
        end
      end
    end
    if flag then
      if self.patchDeadline > 0 then
        local counttime = self.patchDeadline + ServerTime.CurServerTime() / 1000
        local params = {
          self.patchDeadline
        }
        MsgManager.ShowMsgByIDTable(41470, params, data.id)
        self:PostponeHotfix()
      else
        self.updateTime = ServerTime.CurServerTime() / 1000 + 900
        MsgManager.ConfirmMsgByID(41454, function()
          if self.timeTick then
            TimeTickManager.Me():ClearTick(self, 41454)
            self.timeTick = nil
          end
          Game.Me():BackToLogo()
        end)
        self:PostponeHotfix()
      end
    end
  else
    redlog("no platform")
  end
end
function FunctionLogin:PostponeHotfix()
  if not self.timeTick then
    self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateCountDown, self, 41454)
  end
end
function FunctionLogin:UpdateCountDown()
  local deltatime = 0
  local delta = 0
  for i = 1, #RepeatInterval do
    deltatime = self.updateTime - ServerTime.CurServerTime() / 1000
    if deltatime <= 0 then
      if self.timeTick then
        TimeTickManager.Me():ClearTick(self, 41454)
        self.timeTick = nil
        Game.Me():BackToLogo()
      end
    else
      delta = deltatime - RepeatInterval[i]
      if delta > 0 and delta < 1 then
        MsgManager.ShowMsgByIDTable(41455, {
          math.floor(deltatime / 60)
        })
      end
    end
  end
end
function FunctionLogin:ClearLoginOutListen()
  LogUtility.Info("FunctionLogin:ClearLoginOutListen(  )")
  local fucntionSdk = self:getFunctionSdk()
  if fucntionSdk then
    fucntionSdk:ClearLoginOutListen()
  end
end
