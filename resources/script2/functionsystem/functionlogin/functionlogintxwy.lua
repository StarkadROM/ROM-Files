autoImport("FunctionLoginBase")
FunctionLoginTXWY = class("FunctionLoginTXWY", FunctionLoginBase)
function FunctionLoginTXWY.Me()
  if nil == FunctionLoginTXWY.me then
    FunctionLoginTXWY.me = FunctionLoginTXWY.new()
  end
  return FunctionLoginTXWY.me
end
function FunctionLoginTXWY:startSdkGameLogin(callback)
  LogUtility.InfoFormat("startSdkGameLogin:isLogined:{0}", self:isLogined())
  local isLogined = self:isLogined()
  if not isLogined then
    self:startSdkLogin(function(code, msg)
      self:SdkLoginHandler(code, msg, function()
        self:startAuthAccessToken(function()
          if callback then
            callback()
          end
        end)
      end)
    end)
  elseif not self.loginData then
    self:startAuthAccessToken(function()
      if callback then
        callback()
      end
    end)
  elseif callback then
    callback()
  end
end
function FunctionLoginTXWY:startAuthAccessToken(callback)
  GameFacade.Instance:sendNotification(NewLoginEvent.StartShowWaitingView)
  self.callback = callback
  self:RequestAuthAccToken()
end
function FunctionLoginTXWY:requestRegistUrlHost(url, callback, address, privateMode)
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
    ip = string.format("%s%s%s", ip, url, timestamp)
    LogUtility.InfoFormat("FunctionLogin:requestGetUrlHost address url:{0}", ip)
    local order = HttpWWWRequestOrder(ip, NetConfig.HttpRequestTimeOut, nil, false, true)
  else
    local ips = FunctionGetIpStrategy.Me():getRequestAddresss()
    for i = 1, #ips do
      local ip = ips[i]
      ip = string.format("%s%s%s", ip, url, timestamp)
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
function FunctionLoginTXWY:GetRegistUrl(token, serverData)
  local authUrl = NetConfig.GetAccDataAddress
  local version = self:getServerVersion()
  local plat = self:GetPlat()
  local sid = serverData.sid
  local clientCode = CompatibilityVersion.version
  local vd = self:getvd()
  local debug = FunctionLogin.Me():isDebug()
  if debug then
    clientCode = FunctionLogin.Me().debugClientCode
  end
  local url = string.format("%s%s&plat=%s&version=%s&clientCode=%s&vd=%s&sid=%s", authUrl, token, plat, version, clientCode, vd, sid)
  return url
end
function FunctionLoginTXWY:RequestAuthAccToken()
  OverseaHostHelper:RefreshPriceInfo()
  local phoneplat = ApplicationInfo.GetRunPlatformStr()
  local appPreVersion = CompatibilityVersion.appPreVersion
  local sid = self:getToken()
  local appPreVersion = CompatibilityVersion.appPreVersion
  local phoneplat = ApplicationInfo.GetRunPlatformStr()
  if sid then
    local version = self:getServerVersion()
    local plat = self:GetPlat()
    local clientCode = CompatibilityVersion.version
    local clientV2Code = 0
    local resVersion = VersionUpdateManager.CurrentVersion
    if resVersion == nil then
      resVersion = "Unknown"
    end
    pcall(function()
      if not BranchMgr.IsChina() then
        clientV2Code = OverseaHostHelper:GetClientV2Code()
      end
    end)
    local url
    if BranchMgr.IsSEA() or BranchMgr.IsNA() then
      url = string.format("%s/auth?sid=%s&p=%s&sver=%s&cver=%s&lang=%s&blueberry=%s&v=%s", NetConfig.NewAccessTokenAuthHost[1], sid, plat, version, clientCode, ApplicationInfo.GetSystemLanguage(), clientV2Code, resVersion)
    elseif BranchMgr.IsEU() then
      url = string.format("%s/auth?sid=%s&p=%s&sver=%s&cver=%s&lang=%s&blueberry=%s&v=%s&iv=%s", NetConfig.NewAccessTokenAuthHost[1], sid, plat, version, clientCode, ApplicationInfo.GetSystemLanguage(), clientV2Code, resVersion, CompatibilityVersion.version)
    else
      url = string.format("%s/auth?sid=%s&p=%s&sver=%s&cver=%s&blueberry=%s&v=%s", NetConfig.NewAccessTokenAuthHost[1], sid, plat, version, clientCode, clientV2Code, resVersion)
    end
    url = string.format("%s&appPreVersion=%s&phoneplat=%s", url, appPreVersion, phoneplat)
    OverseaHostHelper.lastAuthUrl = url
    Debug.LogFormat("txwy RequestAuthAccToken url : {0}", url)
    local order = HttpWWWRequestOrder(url, NetConfig.HttpRequestTimeOut, nil, false, true)
    if order then
      order:SetCallBacks(function(response)
        GameFacade.Instance:sendNotification(NewLoginEvent.StopShowWaitingView)
        self:LoginDataHandler(NetConfig.ResponseCodeOk, response.resString, self.callback)
      end, function(order)
        GameFacade.Instance:sendNotification(NewLoginEvent.StopShowWaitingView)
        self:LoginDataHandler(FunctionLogin.AuthStatus.OherError, "", self.callback)
      end, function(order)
        GameFacade.Instance:sendNotification(NewLoginEvent.StopShowWaitingView)
        self:LoginDataHandler(FunctionLogin.AuthStatus.OherError, "", self.callback)
      end)
      Game.HttpWWWRequest:RequestByOrder(order)
    else
    end
  else
    MsgManager.ShowMsgByIDTable(1017, {
      FunctionLogin.ErrorCode.RequestAuthAccToken_NoneToken
    })
    GameFacade.Instance:sendNotification(NewLoginEvent.LoginFailure)
  end
end
