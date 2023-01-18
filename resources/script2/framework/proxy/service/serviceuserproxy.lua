autoImport("DiskFileHandler")
autoImport("BeautifulAreaPhotoHandler")
autoImport("BeautifulAreaPhotoNetIngManager")
local ServiceUserProxy = class("ServiceUserProxy", ServiceProxy)
ServiceUserProxy.Instance = nil
ServiceUserProxy.NAME = "ServiceUserProxy"
ServiceUserProxy.RecvLogin = "ServiceUserProxy.RecvLogin"
function ServiceUserProxy:ctor(proxyName)
  if ServiceUserProxy.Instance == nil then
    self.proxyName = proxyName or ServiceUserProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    self:InitMediator({
      [ServiceEvent.PlayerSAttrSyncData] = self.SelectSuccess
    })
    ServiceUserProxy.Instance = self
  end
end
function ServiceUserProxy:Init()
  self.roleInfo = nil
  self.roleInfos = nil
  self.newRoleInfo = nil
  self.isSelecting = false
  self.isReSelecting = false
  self.isReConnect = false
end
function ServiceUserProxy:IsReConnect(value)
  self.isReConnect = value
end
function ServiceUserProxy:RecvRoleInfo(data)
  Buglylog("ServiceUserProxy:RecvRoleInfo")
  if data.data and #data.data > 0 then
    local tempArray = {}
    for i = 1, #data.data do
      local single = data.data[i]
      local roleData = {}
      roleData.id = single.id
      roleData.baselv = single.baselv
      roleData.hair = single.hair
      roleData.haircolor = single.haircolor
      roleData.lefthand = single.lefthand
      roleData.righthand = single.righthand
      roleData.body = single.body
      roleData.head = single.head
      roleData.back = single.back
      roleData.face = single.face
      roleData.tail = single.tail
      roleData.mount = single.mount
      roleData.eye = single.eye or 0
      roleData.partnerid = single.partnerid
      roleData.portrait = single.portrait
      roleData.mouth = single.mouth
      roleData.eyecolor = single.eyecolor
      roleData.gender = single.gender
      roleData.profession = single.profession
      roleData.name = single.name
      roleData.sequence = single.sequence
      roleData.isopen = single.isopen
      roleData.deletetime = single.deletetime
      roleData.clothcolor = single.clothcolor == 0 and 1 or single.clothcolor
      roleData.isban = single.isban
      roleData.delete_marks = single.delete_marks
      table.insert(tempArray, roleData)
      local oldRole = self:GetRoleInfoById(single.id)
      if self.roleInfos and not oldRole then
        self.newRoleInfo = roleData
      end
    end
    self.roleInfos = tempArray
    self:checkReConnect()
  else
    self.roleInfos = {}
  end
  self:Notify(ServiceEvent.UserRecvRoleInfo)
end
function ServiceUserProxy:GetRoleInfoById(id)
  if self.roleInfos and #self.roleInfos > 0 then
    for i = 1, #self.roleInfos do
      local roleInfo = self.roleInfos[i]
      if roleInfo.id == id then
        return roleInfo
      end
    end
  end
end
function ServiceUserProxy:GetRoleInfo()
  return self.roleInfo
end
function ServiceUserProxy:GetNewRoleInfo()
  return self.newRoleInfo
end
function ServiceUserProxy:GetAllRoleInfos()
  return self.roleInfos
end
function ServiceUserProxy:ClearRoleInfos()
  self.roleInfos = nil
  self.newRoleInfo = nil
  self.roleInfo = nil
end
function ServiceUserProxy:CallSelect(id)
  if not id and not self.roleInfo then
    LogUtility.Info("<color=red>CallSelect id is nil!!!!</color>")
    return
  end
  if not self.id and self.roleInfo then
    id = self.roleInfo.id
  end
  if self.roleInfo and self.roleInfo.id ~= id then
    self.roleInfo = nil
  end
  if not self.roleInfo and self.roleInfos and #self.roleInfos > 0 then
    for i = 1, #self.roleInfos do
      local roleInfo = self.roleInfos[i]
      if roleInfo.id == id then
        self.roleInfo = roleInfo
        break
      end
    end
  end
  if not self.roleInfo then
    LogUtility.Info("<color=red>CallSelect can't not find roleInfo!!!!</color>")
    return
  end
  MyselfProxy.Instance:SetMySelfCurRole(self.roleInfo)
  if not self.deviceInfo then
    self.deviceInfo = DeviceInfo.GetID()
  end
  if not self.isReSelecting then
    self.isSelecting = true
  end
  LogUtility.InfoFormat("CallSelect id:{0}", id)
  local JPushId = "000"
  if ROPush.hasInit then
    JPushId = ROPush.GetRegistrationId() or "000"
    LogUtility.InfoFormat("CallSelect JPushId:{0}", JPushId)
  end
  local clickPos = AAAManager.Me():GetLpc("ButtonStartGame")
  if not clickPos or clickPos == 0 then
    clickPos = nil
  end
  local extraData = {}
  local selectdataforsystem = SystemInfo.operatingSystem
  if string.find(selectdataforsystem, "Mac") then
    extraData.system = "Mac"
  elseif string.find(selectdataforsystem, "IOS") then
    extraData.system = "IOS"
  elseif string.find(selectdataforsystem, "iOS") then
    extraData.system = "IOS"
  elseif string.find(selectdataforsystem, "Android") then
    extraData.system = "Android"
  else
    extraData.system = SystemInfo.operatingSystem
  end
  extraData.model = SystemInfo.deviceModel
  extraData.version = SystemInfo.operatingSystem
  local lang = BranchMgr.GetLanguage()
  ServiceLoginUserCmdProxy.Instance:CallSelectRoleUserCmd(id, nil, nil, self.deviceInfo, nil, nil, extraData, nil, nil, nil, lang, nil, nil, JPushId, clickPos)
  local roleID = id or 0
  DiskFileHandler.Ins():SetRole(roleID)
  AAAManager.Me():ClearLpc("ButtonStartGame")
  if ApplicationInfo.IsRunOnEditor() then
    if Client_Record then
      Game.NetConnectionManager.Record = true
      Game.InputManager.Record = true
    end
    if Client_PlayRecord then
      Game.NetConnectionManager.PlayRecord = true
      Game.InputManager.PlayRecord = true
    end
  end
end
function ServiceUserProxy:CallReSelect()
  self.isReSelecting = true
  if self.roleInfo then
    self:CallSelect(self.roleInfo.id)
  else
    printRed("function ServiceUserProxy:CallReSelect(func) null id")
  end
end
function ServiceUserProxy:checkReConnect()
  if self.isReConnect then
    self:CallReSelect()
  end
end
function ServiceUserProxy:PrepareToReloadDatas()
  self.isReloadDatas = true
end
function ServiceUserProxy:SelectSuccess(data)
  if self.isReSelecting then
    self.isReSelecting = false
    self.isReloadDatas = false
    ServiceConnProxy.Instance:NotifyReconnect()
    return
  end
  if self.isSelecting then
    self.isReloadDatas = false
    self:Notify(ServiceEvent.LoginInit, data)
  end
  if self.isReloadDatas then
    self.isReloadDatas = false
    self:Notify(ServiceEvent.ReloadDatas, data)
  end
end
function ServiceUserProxy:CheckRealInitialized()
  if self.isSelecting then
    redlog("2.0新老地图，服务器在玩家第一次上线就触发了切图导致客户端发完消息后服务器在场景中找不到玩家，请求初始化消息未回给客户端（详情咨询胜杰）")
    self:Notify(ServiceEvent.LoginInit, {reInit = true})
  end
end
function ServiceUserProxy:SetInited()
  if self.isSelecting then
    self.isSelecting = false
  end
end
return ServiceUserProxy
