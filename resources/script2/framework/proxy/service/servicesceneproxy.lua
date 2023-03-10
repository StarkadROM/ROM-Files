local ServiceSceneProxy = class("ServiceSceneProxy", ServiceProxy)
ServiceSceneProxy.Instance = nil
ServiceSceneProxy.NAME = "ServiceSceneProxy"
function ServiceSceneProxy:ctor(proxyName)
  if ServiceSceneProxy.Instance == nil then
    self.proxyName = proxyName or ServiceSceneProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceSceneProxy.Instance = self
  end
end
function ServiceSceneProxy:Init()
end
function ServiceSceneProxy:onRegister()
  self:Listen(5, 33, function(data)
    self:RecvUserActionNtf(data)
  end)
  self:Listen(5, 42, function(data)
    self:RecvGoToUserCmd(data)
  end)
end
function ServiceSceneProxy:CallReliveUserCmd(type)
  if NetConfig.PBC then
    local msgId = ProtoReqInfoList.ReliveUserCmd.id
    local msgParam = {}
    msgParam.type = type
    self:SendProto2(msgId, msgParam)
  else
    local msg = SceneUser_pb.ReliveUserCmd()
    msg.type = type
    self:SendProto(msg)
  end
end
function ServiceSceneProxy:RecvUserActionNtf(data)
  self:Notify(ServiceEvent.SceneUserActionNtf, data)
end
function ServiceSceneProxy:RecvGoToUserCmd(data)
  SceneCreatureProxy.ResetPos(data.charid, data.pos, data.isgomap)
  self:Notify(ServiceEvent.SceneGoToUserCmd, data)
  EventManager.Me():DispatchEvent(ServiceEvent.SceneGoToUserCmd, data)
end
return ServiceSceneProxy
