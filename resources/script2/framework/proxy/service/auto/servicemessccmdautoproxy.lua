ServiceMessCCmdAutoProxy = class("ServiceMessCCmdAutoProxy", ServiceProxy)
ServiceMessCCmdAutoProxy.Instance = nil
ServiceMessCCmdAutoProxy.NAME = "ServiceMessCCmdAutoProxy"
function ServiceMessCCmdAutoProxy:ctor(proxyName)
  if ServiceMessCCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceMessCCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceMessCCmdAutoProxy.Instance = self
  end
end
function ServiceMessCCmdAutoProxy:Init()
end
function ServiceMessCCmdAutoProxy:onRegister()
  self:Listen(83, 1, function(data)
    self:RecvChooseNewProfessionMessCCmd(data)
  end)
end
function ServiceMessCCmdAutoProxy:CallChooseNewProfessionMessCCmd(bornprofession, chooseprofession)
  if not NetConfig.PBC then
    local msg = MessCCmd_pb.ChooseNewProfessionMessCCmd()
    if bornprofession ~= nil then
      msg.bornprofession = bornprofession
    end
    if chooseprofession ~= nil then
      msg.chooseprofession = chooseprofession
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ChooseNewProfessionMessCCmd.id
    local msgParam = {}
    if bornprofession ~= nil then
      msgParam.bornprofession = bornprofession
    end
    if chooseprofession ~= nil then
      msgParam.chooseprofession = chooseprofession
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceMessCCmdAutoProxy:RecvChooseNewProfessionMessCCmd(data)
  self:Notify(ServiceEvent.MessCCmdChooseNewProfessionMessCCmd, data)
end
ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.MessCCmdChooseNewProfessionMessCCmd = "ServiceEvent_MessCCmdChooseNewProfessionMessCCmd"
