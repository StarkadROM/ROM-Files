autoImport("ServiceMessCCmdAutoProxy")
ServiceMessCCmdProxy = class("ServiceMessCCmdProxy", ServiceMessCCmdAutoProxy)
ServiceMessCCmdProxy.Instance = nil
ServiceMessCCmdProxy.NAME = "ServiceMessCCmdProxy"
function ServiceMessCCmdProxy:ctor(proxyName)
  if ServiceMessCCmdProxy.Instance == nil then
    self.proxyName = proxyName or ServiceMessCCmdProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceMessCCmdProxy.Instance = self
  end
end
function ServiceMessCCmdProxy:RecvChooseNewProfessionMessCCmd(data)
  ProfessionProxy.Instance:HandleChooseNewProfessionMess(data.bornprofession)
  self:Notify(ServiceEvent.MessCCmdChooseNewProfessionMessCCmd, data)
end
