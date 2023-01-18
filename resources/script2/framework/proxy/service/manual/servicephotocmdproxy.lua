autoImport("ServicePhotoCmdAutoProxy")
autoImport("GamePhoto")
ServicePhotoCmdProxy = class("ServicePhotoCmdProxy", ServicePhotoCmdAutoProxy)
ServicePhotoCmdProxy.Instance = nil
ServicePhotoCmdProxy.NAME = "ServicePhotoCmdProxy"
function ServicePhotoCmdProxy:ctor(proxyName)
  if ServicePhotoCmdProxy.Instance == nil then
    self.proxyName = proxyName or ServicePhotoCmdProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServicePhotoCmdProxy.Instance = self
  end
end
function ServicePhotoCmdProxy:RecvPhotoQueryListCmd(data)
  PhotoDataProxy.Instance:RecvPhotoQueryListCmd(data)
  self:Notify(ServiceEvent.PhotoCmdPhotoQueryListCmd, data)
end
function ServicePhotoCmdProxy:RecvPhotoOptCmd(data)
  PhotoDataProxy.Instance:RecvPhotoOptCmd(data)
  self:Notify(ServiceEvent.PhotoCmdPhotoOptCmd, data)
end
function ServicePhotoCmdProxy:RecvPhotoUpdateNtf(data)
  PhotoDataProxy.Instance:RecvPhotoUpdateNtf(data)
  self:Notify(ServiceEvent.PhotoCmdPhotoUpdateNtf, data)
end
function ServicePhotoCmdProxy:RecvQueryFramePhotoListPhotoCmd(data)
  PhotoDataProxy.Instance:currentFramePhotoList(data)
  self:Notify(ServiceEvent.PhotoCmdQueryFramePhotoListPhotoCmd, data)
end
function ServicePhotoCmdProxy:RecvUpdateFrameShowPhotoCmd(data)
  local raidId = Game.MapManager:GetRaidID()
  if raidId == 10001 then
    Game.PictureWallManager:AddPictureInfos(data.shows)
  else
    Game.WeddingWallPicManager:UpdateFramePictureInfos(data.shows)
  end
  self:Notify(ServiceEvent.PhotoCmdUpdateFrameShowPhotoCmd, data)
end
function ServicePhotoCmdProxy:RecvFrameActionPhotoCmd(data)
  local raidId = Game.MapManager:GetRaidID()
  if raidId == 10001 then
    PhotoDataProxy.Instance:RecvFrameActionPhotoCmd(data)
  else
    PhotoDataProxy.Instance:RecvFrameActionPhotoCmd(data, true)
  end
  self:Notify(ServiceEvent.PhotoCmdFrameActionPhotoCmd, data)
end
function ServicePhotoCmdProxy:RecvQueryUserPhotoListPhotoCmd(data)
  PhotoDataProxy.Instance:RecvQueryUserPhotoListPhotoCmd(data)
  self:Notify(ServiceEvent.PhotoCmdQueryUserPhotoListPhotoCmd, data)
end
function ServicePhotoCmdProxy:RecvQueryMd5ListPhotoCmd(data)
  self:Notify(ServiceEvent.PhotoCmdQueryMd5ListPhotoCmd, data)
  local photoMD5s = data.item
  for i = 1, #photoMD5s do
    local photoMD5 = photoMD5s[i]
    local source = photoMD5.source
    local sourceID = photoMD5.sourceid
    local md5 = photoMD5.md5
    if source == ProtoCommon_pb.ESOURCE_PHOTO_SCENERY then
      GamePhoto.SetPhotoFileMD5_Scenery(sourceID, md5)
    elseif source == ProtoCommon_pb.ESOURCE_PHOTO_SELF then
      GamePhoto.SetPhotoFileMD5_Personal(sourceID, md5)
    elseif source == ProtoCommon_pb.ESOURCE_PHOTO_GUILD then
      GamePhoto.SetPhotoFileMD5_UnionLogo(sourceID, md5)
    elseif source == ProtoCommon_pb.ESOURCE_WEDDING_PHOTO then
      GamePhoto.SetPhotoFileMD5_Marry(sourceID, md5)
    elseif source == ProtoCommon_pb.ESOURCE_PHOTO_STAGE then
      GamePhoto.SetPhotoFileMD5_Stage(sourceID, md5)
    end
  end
end
function ServicePhotoCmdProxy:RecvWedPhotoShowPhotoCmd(data)
  self:Notify(ServiceEvent.PhotoCmdWedPhotoShowPhotoCmd, data)
end
function ServicePhotoCmdProxy:RecvQueryWedPhotoCmd(data)
  self:Notify(ServiceEvent.PhotoCmdQueryWedPhotoCmd, data)
end
function ServicePhotoCmdProxy:RecvQueryUrlPhotoCmd(data)
  local urls = data.urls
  local singleUrl
  for i = 1, #urls do
    singleUrl = urls[i]
    if not StringUtil.IsEmpty(singleUrl.char_url) then
      FunctionPhotoStorage.Me():SetPhotoUrlPath(singleUrl.type, singleUrl.char_url)
    end
    if not StringUtil.IsEmpty(singleUrl.acc_url) then
      FunctionPhotoStorage.Me():SetPhotoAccUrlPath(singleUrl.type, singleUrl.acc_url)
    end
  end
  self:Notify(ServiceEvent.PhotoCmdQueryUrlPhotoCmd, data)
end
function ServicePhotoCmdProxy:RecvQueryUploadInfoPhotoCmd(data)
  FunctionPhotoStorage.Me():OnRecvQueryUploadInfoPhotoCmd(data)
  self:Notify(ServiceEvent.PhotoCmdQueryUploadInfoPhotoCmd, data)
end
function ServicePhotoCmdProxy:CallFrameActionPhotoCmd(frameid, action, photo)
  if NetConfig.PBC then
    local msgId = ProtoReqInfoList.FrameActionPhotoCmd.id
    local msgParam = {}
    if frameid ~= nil then
      msgParam.frameid = frameid
    end
    if action ~= nil then
      msgParam.action = action
    end
    if photo ~= nil then
      msgParam.photos = {}
      for i = 1, #photo do
        local photoPb = GuildCmd_pb.GuildPhoto()
        photoPb.source = photo[i].source
        photoPb.sourceid = photo[i].sourceid
        photoPb.charid = photo[i].charid
        photoPb.accid_svr = photo[i].accid_svr
        table.insert(msgParam.photos, photoPb)
      end
    end
    self:SendProto2(msgId, msgParam)
  else
    local msg = PhotoCmd_pb.FrameActionPhotoCmd()
    if frameid ~= nil then
      msg.frameid = frameid
    end
    if action ~= nil then
      msg.action = action
    end
    if photo ~= nil then
      for i = 1, #photo do
        local photoPb = GuildCmd_pb.GuildPhoto()
        photoPb.source = photo[i].source
        photoPb.sourceid = photo[i].sourceid
        photoPb.charid = photo[i].charid
        photoPb.accid_svr = photo[i].accid_svr
        table.insert(msg.photos, photoPb)
      end
    end
    self:SendProto(msg)
  end
end
