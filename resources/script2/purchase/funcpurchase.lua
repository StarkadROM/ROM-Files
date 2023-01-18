FuncPurchase = class("FuncPurchase")
local gReusableTable = {}
function FuncPurchase.Instance()
  if FuncPurchase.instance == nil then
    FuncPurchase.instance = FuncPurchase.new()
  end
  return FuncPurchase.instance
end
function FuncPurchase:ctor()
  self.callbacks = {}
  self.purchaseFlags = {}
end
function FuncPurchase:OnPaySuccess(product_conf, str_result)
  ServiceUserEventProxy.Instance:CallChargeSdkReplyUserEvent(product_conf.id, ServerTime.CurServerTime(), true)
  if not BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V6) then
    if BranchMgr.IsChina() or BranchMgr.IsKorea() then
      local runtimePlatform = ApplicationInfo.GetRunPlatform()
      if runtimePlatform == RuntimePlatform.IPhonePlayer then
        if self.orderIDOfXDSDKPay ~= nil then
          FunctionADBuiltInTyrantdb.Instance():ChargeTo3rd(self.orderIDOfXDSDKPay, product_conf.Rmb)
        end
      elseif runtimePlatform == RuntimePlatform.Android then
        FunctionADBuiltInTyrantdb.Instance():ChargeTo3rd("", product_conf.Rmb)
      else
        local orderID = FunctionSDK.Instance:GetOrderID()
        FunctionADBuiltInTyrantdb.Instance():ChargeTo3rd(orderID, product_conf.Rmb)
      end
    else
      FunctionADBuiltInTyrantdb.Instance():ChargeTo3rd(OverseaHostHelper:GetRoleIde(), product_conf.Rmb)
    end
  end
  local overseasManager = OverSeas_TW.OverSeasManager.GetInstance()
  overseasManager:TrackEvent(AppBundleConfig.GetAdjustByName("appPurchase"))
  local callbackSuccess = self.callbacks[product_conf.id][1]
  if callbackSuccess ~= nil then
    callbackSuccess(str_result)
    self.callbacks[product_conf.id] = nil
  end
  self.purchaseFlags[product_conf.id] = nil
end
function FuncPurchase:OnPayFail(product_conf, str_result)
  ServiceUserEventProxy.Instance:CallChargeSdkReplyUserEvent(product_conf.id, ServerTime.CurServerTime(), false)
  local callbackFail = self.callbacks[product_conf.id][2]
  if callbackFail ~= nil then
    callbackFail(str_result)
    self.callbacks[product_conf.id] = nil
  end
  self.purchaseFlags[product_conf.id] = nil
end
function FuncPurchase:OnPayTimeout(product_conf, str_result)
  local callbackTimeout = self.callbacks[product_conf.id][3]
  if callbackTimeout ~= nil then
    callbackTimeout(str_result)
    self.callbacks[product_conf.id] = nil
  end
  self.purchaseFlags[product_conf.id] = nil
end
function FuncPurchase:OnPayCancel(product_conf, str_result)
  local callbackCancel = self.callbacks[product_conf.id][4]
  if callbackCancel ~= nil then
    callbackCancel(str_result)
    self.callbacks[product_conf.id] = nil
  end
  self.purchaseFlags[product_conf.id] = nil
end
function FuncPurchase:OnPayProductIllegal(product_conf, str_result)
  local callbackProductIllegal = self.callbacks[product_conf.id][5]
  if callbackProductIllegal ~= nil then
    callbackProductIllegal(str_result)
    self.callbacks[product_conf.id] = nil
  end
  self.purchaseFlags[product_conf.id] = nil
end
function FuncPurchase:OnPayPaying(product_conf, str_result)
  local callbackPaying = self.callbacks[product_conf.id][6]
  if callbackPaying ~= nil then
    callbackPaying(str_result)
  end
end
function FuncPurchase:InPurchaseFlow(product_conf_id)
  return self.purchaseFlags and self.purchaseFlags[product_conf_id]
end
function FuncPurchase:PurchaseWithConf(productConf, callbacks)
  if not ServiceConnProxy.Instance:IsConnect() then
    MsgManager.ShowMsgByID(1056)
    return
  end
  self.orderIDOfXDSDKPay = nil
  LogUtility.InfoFormat("PurchaseWithConf id:{0}", productConf and productConf.id)
  if productConf then
    local product_conf_id = productConf.id
    local productID = productConf.ProductID
    if productID then
      ServiceUserEventProxy.Instance:CallChargeSdkRequestUserEvent(product_conf_id, ServerTime.CurServerTime())
      local productName = productConf.Desc
      local productPrice = productConf.Rmb
      local productCount = 1
      if not Game.Myself or not Game.Myself.data or not Game.Myself.data.id then
        local roleID
      end
      if roleID then
        local roleGrade = MyselfProxy.Instance:RoleLevel() or 0
        local server = FunctionLogin.Me():getCurServerData()
        if server == nil or not server.serverid then
          local serverID
        end
        if serverID then
          local currentServerTime = ServerTime.CurServerTime() / 1000
          self.purchaseFlags[product_conf_id] = true
          self.callbacks[product_conf_id] = callbacks
          if not BranchMgr.IsChina() then
            if FunctionSDK.Instance.CurrentType == FunctionSDK.E_SDKType.TDSG then
              local orderID = MyMD5.HashString(roleID .. "_" .. currentServerTime)
              local ext = serverID .. "|" .. orderID
              Debug.Log("=============TDSGPay===============")
              FunctionSDK.Instance:TDSGPay(orderID, productID, roleID, serverID, ext, function(x)
                self:OnPaySuccess(productConf, x)
              end, function(x)
                self:OnPayCancel(productConf, x)
              end)
            elseif FunctionSDK.Instance.CurrentType == FunctionSDK.E_SDKType.TXWY then
              FunctionSDK.Instance:TXWYPay(productID, productCount, serverID, "{\"charid\":" .. roleID .. "}", roleGrade, function(x)
                self:OnPaySuccess(productConf, x)
              end, function(x)
                self:OnPayCancel(productConf, x)
              end)
            else
              self:OnPaySuccess(productConf, x)
            end
            return
          end
          local runtimePlatform = ApplicationInfo.GetRunPlatform()
          if runtimePlatform == RuntimePlatform.Android then
            TableUtility.TableClear(gReusableTable)
            gReusableTable.productGameID = tostring(productConf.id)
            gReusableTable.serverID = tostring(serverID)
            gReusableTable.payCallbackCode = 1
            LogUtility.Info("Android Pay starting.")
            local ext = json.encode(gReusableTable)
            FunctionXDSDK.Ins:Pay(productName, productID, productPrice * 100, serverID, tostring(roleID), "", ext, function(x)
              self:OnPaySuccess(productConf, x)
            end, function(x)
              self:OnPayFail(productConf, x)
            end, function(x)
              self:OnPayCancel(productConf, x)
            end)
          elseif FunctionSDK.Instance.CurrentType == FunctionSDK.E_SDKType.XD then
            TableUtility.TableClear(gReusableTable)
            gReusableTable.productGameID = tostring(productConf.id)
            gReusableTable.serverID = tostring(serverID)
            if BranchMgr.IsChina() and ApplicationInfo.GetRunPlatform() == RuntimePlatform.IPhonePlayer then
              local accid = FunctionLogin.Me():getLoginData().accid
              if accid == nil or accid == 0 or not ServiceConnProxy.Instance:IsConnect() then
                MsgManager.ShowMsgByID(1056)
                self.purchaseFlags[product_conf_id] = nil
                self.callbacks[product_conf_id] = nil
                return
              end
              gReusableTable.accid = tostring(accid)
              helplog("ios pay: accid: ", gReusableTable.accid)
              if PlayerPrefs.HasKey("PlayerPrefsMYServer") then
                gReusableTable.sid = tostring(PlayerPrefs.GetInt("PlayerPrefsMYServer"))
                helplog("ios pay: sid: ", gReusableTable.sid)
              end
            end
            local ext = json.encode(gReusableTable)
            local roleAndServerTime = roleID .. "_" .. currentServerTime
            self.orderIDOfXDSDKPay = MyMD5.HashString(roleAndServerTime)
            LogUtility.Info("iOS Pay starting.")
            ShopProxy.Instance:XDSDKPay(productPrice * 100, tostring(serverID), productID, productName, tostring(roleID), ext, productCount, self.orderIDOfXDSDKPay, function(x)
              self:OnPaySuccess(productConf, x)
            end, function(x)
              self:OnPayFail(productConf, x)
            end, function(x)
              self:OnPayTimeout(productConf, x)
            end, function(x)
              self:OnPayCancel(productConf, x)
            end, function(x)
              self:OnPayProductIllegal(productConf, x)
            end)
          end
        end
      end
    end
  end
end
function FuncPurchase:Purchase(product_conf_id, callbacks)
  local productConf = Table_Deposit[product_conf_id]
  self:PurchaseWithConf(productConf, callbacks)
end
