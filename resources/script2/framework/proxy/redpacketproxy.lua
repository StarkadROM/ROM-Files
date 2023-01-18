RedPacketProxy = class("RedPacketProxy", pm.Proxy)
RedPacketProxy.Instance = nil
RedPacketProxy.NAME = "RedPacketProxy"
function RedPacketProxy:ctor(proxyName, data)
  self.proxyName = proxyName or RedPacketProxy.NAME
  if RedPacketProxy.Instance == nil then
    RedPacketProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end
function RedPacketProxy:Init()
  self.contents = {}
  self.receiveInfo = {}
end
function RedPacketProxy:RecvRedPacketInfo(data)
  if data.bRedPacketExist then
    local guid = data.strRedPacketID
    local serverContent = data.content
    self:UpdateRedPacketContent(guid, serverContent)
    if data.bRedPacketUsable then
      self.receiveInfo[guid] = data.thisReceiveMoney
    end
  end
end
function RedPacketProxy:UpdateRedPacketContent(guid, serverContent)
  local content = self.contents[guid]
  if not content then
    content = {}
    self.contents[guid] = content
  end
  content.redPacketCFGID = serverContent.redPacketCFGID
  content.overtime = serverContent.overtime
  content.restMoney = serverContent.restMoney
  content.restNum = serverContent.restNum
  content.totalMoney = serverContent.totalMoney
  content.totalNum = serverContent.totalNum
  content.receivedInfos = serverContent.receivedInfos
end
function RedPacketProxy:CheckIfReceived(redPacketGUID)
  return self.receiveInfo[redPacketGUID] ~= nil
end
function RedPacketProxy:IsRedPacketContentExist(redPacketGUID)
  return self:GetRedPacketContent(redPacketGUID) ~= nil
end
function RedPacketProxy:GetRedPacketContent(redPacketGUID)
  return self.contents[redPacketGUID]
end
function RedPacketProxy:GetReceivedItemNum(redPacketGUID)
  return self.receiveInfo[redPacketGUID]
end
