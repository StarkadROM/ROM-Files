ServicePhotoCmdAutoProxy = class("ServicePhotoCmdAutoProxy", ServiceProxy)
ServicePhotoCmdAutoProxy.Instance = nil
ServicePhotoCmdAutoProxy.NAME = "ServicePhotoCmdAutoProxy"
function ServicePhotoCmdAutoProxy:ctor(proxyName)
  if ServicePhotoCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServicePhotoCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServicePhotoCmdAutoProxy.Instance = self
  end
end
function ServicePhotoCmdAutoProxy:Init()
end
function ServicePhotoCmdAutoProxy:onRegister()
  self:Listen(30, 1, function(data)
    self:RecvPhotoQueryListCmd(data)
  end)
  self:Listen(30, 2, function(data)
    self:RecvPhotoOptCmd(data)
  end)
  self:Listen(30, 3, function(data)
    self:RecvPhotoUpdateNtf(data)
  end)
  self:Listen(30, 4, function(data)
    self:RecvFrameActionPhotoCmd(data)
  end)
  self:Listen(30, 5, function(data)
    self:RecvQueryFramePhotoListPhotoCmd(data)
  end)
  self:Listen(30, 6, function(data)
    self:RecvQueryUserPhotoListPhotoCmd(data)
  end)
  self:Listen(30, 7, function(data)
    self:RecvUpdateFrameShowPhotoCmd(data)
  end)
  self:Listen(30, 8, function(data)
    self:RecvFramePhotoUpdatePhotoCmd(data)
  end)
  self:Listen(30, 9, function(data)
    self:RecvQueryMd5ListPhotoCmd(data)
  end)
  self:Listen(30, 10, function(data)
    self:RecvAddMd5PhotoCmd(data)
  end)
  self:Listen(30, 11, function(data)
    self:RecvRemoveMd5PhotoCmd(data)
  end)
  self:Listen(30, 12, function(data)
    self:RecvQueryUrlPhotoCmd(data)
  end)
  self:Listen(30, 13, function(data)
    self:RecvQueryUploadInfoPhotoCmd(data)
  end)
end
function ServicePhotoCmdAutoProxy:CallPhotoQueryListCmd(photos, size)
  if not NetConfig.PBC then
    local msg = PhotoCmd_pb.PhotoQueryListCmd()
    if photos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.photos == nil then
        msg.photos = {}
      end
      for i = 1, #photos do
        table.insert(msg.photos, photos[i])
      end
    end
    if size ~= nil then
      msg.size = size
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PhotoQueryListCmd.id
    local msgParam = {}
    if photos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.photos == nil then
        msgParam.photos = {}
      end
      for i = 1, #photos do
        table.insert(msgParam.photos, photos[i])
      end
    end
    if size ~= nil then
      msgParam.size = size
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServicePhotoCmdAutoProxy:CallPhotoOptCmd(opttype, index, anglez, mapid)
  if not NetConfig.PBC then
    local msg = PhotoCmd_pb.PhotoOptCmd()
    if opttype ~= nil then
      msg.opttype = opttype
    end
    if index ~= nil then
      msg.index = index
    end
    if anglez ~= nil then
      msg.anglez = anglez
    end
    if mapid ~= nil then
      msg.mapid = mapid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PhotoOptCmd.id
    local msgParam = {}
    if opttype ~= nil then
      msgParam.opttype = opttype
    end
    if index ~= nil then
      msgParam.index = index
    end
    if anglez ~= nil then
      msgParam.anglez = anglez
    end
    if mapid ~= nil then
      msgParam.mapid = mapid
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServicePhotoCmdAutoProxy:CallPhotoUpdateNtf(opttype, photo)
  if not NetConfig.PBC then
    local msg = PhotoCmd_pb.PhotoUpdateNtf()
    if opttype ~= nil then
      msg.opttype = opttype
    end
    if photo ~= nil and photo.index ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.photo == nil then
        msg.photo = {}
      end
      msg.photo.index = photo.index
    end
    if photo ~= nil and photo.mapid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.photo == nil then
        msg.photo = {}
      end
      msg.photo.mapid = photo.mapid
    end
    if photo ~= nil and photo.time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.photo == nil then
        msg.photo = {}
      end
      msg.photo.time = photo.time
    end
    if photo ~= nil and photo.anglez ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.photo == nil then
        msg.photo = {}
      end
      msg.photo.anglez = photo.anglez
    end
    if photo ~= nil and photo.isupload ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.photo == nil then
        msg.photo = {}
      end
      msg.photo.isupload = photo.isupload
    end
    if photo ~= nil and photo.charid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.photo == nil then
        msg.photo = {}
      end
      msg.photo.charid = photo.charid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PhotoUpdateNtf.id
    local msgParam = {}
    if opttype ~= nil then
      msgParam.opttype = opttype
    end
    if photo ~= nil and photo.index ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.photo == nil then
        msgParam.photo = {}
      end
      msgParam.photo.index = photo.index
    end
    if photo ~= nil and photo.mapid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.photo == nil then
        msgParam.photo = {}
      end
      msgParam.photo.mapid = photo.mapid
    end
    if photo ~= nil and photo.time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.photo == nil then
        msgParam.photo = {}
      end
      msgParam.photo.time = photo.time
    end
    if photo ~= nil and photo.anglez ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.photo == nil then
        msgParam.photo = {}
      end
      msgParam.photo.anglez = photo.anglez
    end
    if photo ~= nil and photo.isupload ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.photo == nil then
        msgParam.photo = {}
      end
      msgParam.photo.isupload = photo.isupload
    end
    if photo ~= nil and photo.charid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.photo == nil then
        msgParam.photo = {}
      end
      msgParam.photo.charid = photo.charid
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServicePhotoCmdAutoProxy:CallFrameActionPhotoCmd(frameid, action, photos)
  if not NetConfig.PBC then
    local msg = PhotoCmd_pb.FrameActionPhotoCmd()
    if frameid ~= nil then
      msg.frameid = frameid
    end
    if action ~= nil then
      msg.action = action
    end
    if photos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.photos == nil then
        msg.photos = {}
      end
      for i = 1, #photos do
        table.insert(msg.photos, photos[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.FrameActionPhotoCmd.id
    local msgParam = {}
    if frameid ~= nil then
      msgParam.frameid = frameid
    end
    if action ~= nil then
      msgParam.action = action
    end
    if photos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.photos == nil then
        msgParam.photos = {}
      end
      for i = 1, #photos do
        table.insert(msgParam.photos, photos[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServicePhotoCmdAutoProxy:CallQueryFramePhotoListPhotoCmd(frameid, photos)
  if not NetConfig.PBC then
    local msg = PhotoCmd_pb.QueryFramePhotoListPhotoCmd()
    if frameid ~= nil then
      msg.frameid = frameid
    end
    if photos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.photos == nil then
        msg.photos = {}
      end
      for i = 1, #photos do
        table.insert(msg.photos, photos[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryFramePhotoListPhotoCmd.id
    local msgParam = {}
    if frameid ~= nil then
      msgParam.frameid = frameid
    end
    if photos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.photos == nil then
        msgParam.photos = {}
      end
      for i = 1, #photos do
        table.insert(msgParam.photos, photos[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServicePhotoCmdAutoProxy:CallQueryUserPhotoListPhotoCmd(frames, maxphoto, maxframe)
  if not NetConfig.PBC then
    local msg = PhotoCmd_pb.QueryUserPhotoListPhotoCmd()
    if frames ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.frames == nil then
        msg.frames = {}
      end
      for i = 1, #frames do
        table.insert(msg.frames, frames[i])
      end
    end
    if maxphoto ~= nil then
      msg.maxphoto = maxphoto
    end
    if maxframe ~= nil then
      msg.maxframe = maxframe
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryUserPhotoListPhotoCmd.id
    local msgParam = {}
    if frames ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.frames == nil then
        msgParam.frames = {}
      end
      for i = 1, #frames do
        table.insert(msgParam.frames, frames[i])
      end
    end
    if maxphoto ~= nil then
      msgParam.maxphoto = maxphoto
    end
    if maxframe ~= nil then
      msgParam.maxframe = maxframe
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServicePhotoCmdAutoProxy:CallUpdateFrameShowPhotoCmd(shows)
  if not NetConfig.PBC then
    local msg = PhotoCmd_pb.UpdateFrameShowPhotoCmd()
    if shows ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.shows == nil then
        msg.shows = {}
      end
      for i = 1, #shows do
        table.insert(msg.shows, shows[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UpdateFrameShowPhotoCmd.id
    local msgParam = {}
    if shows ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.shows == nil then
        msgParam.shows = {}
      end
      for i = 1, #shows do
        table.insert(msgParam.shows, shows[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServicePhotoCmdAutoProxy:CallFramePhotoUpdatePhotoCmd(frameid, update, del)
  if not NetConfig.PBC then
    local msg = PhotoCmd_pb.FramePhotoUpdatePhotoCmd()
    if frameid ~= nil then
      msg.frameid = frameid
    end
    if update ~= nil and update.accid_svr ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.update == nil then
        msg.update = {}
      end
      msg.update.accid_svr = update.accid_svr
    end
    if update ~= nil and update.accid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.update == nil then
        msg.update = {}
      end
      msg.update.accid = update.accid
    end
    if update ~= nil and update.charid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.update == nil then
        msg.update = {}
      end
      msg.update.charid = update.charid
    end
    if update ~= nil and update.anglez ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.update == nil then
        msg.update = {}
      end
      msg.update.anglez = update.anglez
    end
    if update ~= nil and update.time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.update == nil then
        msg.update = {}
      end
      msg.update.time = update.time
    end
    if update ~= nil and update.mapid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.update == nil then
        msg.update = {}
      end
      msg.update.mapid = update.mapid
    end
    if update ~= nil and update.sourceid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.update == nil then
        msg.update = {}
      end
      msg.update.sourceid = update.sourceid
    end
    if update ~= nil and update.source ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.update == nil then
        msg.update = {}
      end
      msg.update.source = update.source
    end
    if del ~= nil and del.accid_svr ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.del == nil then
        msg.del = {}
      end
      msg.del.accid_svr = del.accid_svr
    end
    if del ~= nil and del.accid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.del == nil then
        msg.del = {}
      end
      msg.del.accid = del.accid
    end
    if del ~= nil and del.charid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.del == nil then
        msg.del = {}
      end
      msg.del.charid = del.charid
    end
    if del ~= nil and del.anglez ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.del == nil then
        msg.del = {}
      end
      msg.del.anglez = del.anglez
    end
    if del ~= nil and del.time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.del == nil then
        msg.del = {}
      end
      msg.del.time = del.time
    end
    if del ~= nil and del.mapid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.del == nil then
        msg.del = {}
      end
      msg.del.mapid = del.mapid
    end
    if del ~= nil and del.sourceid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.del == nil then
        msg.del = {}
      end
      msg.del.sourceid = del.sourceid
    end
    if del ~= nil and del.source ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.del == nil then
        msg.del = {}
      end
      msg.del.source = del.source
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.FramePhotoUpdatePhotoCmd.id
    local msgParam = {}
    if frameid ~= nil then
      msgParam.frameid = frameid
    end
    if update ~= nil and update.accid_svr ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.update == nil then
        msgParam.update = {}
      end
      msgParam.update.accid_svr = update.accid_svr
    end
    if update ~= nil and update.accid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.update == nil then
        msgParam.update = {}
      end
      msgParam.update.accid = update.accid
    end
    if update ~= nil and update.charid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.update == nil then
        msgParam.update = {}
      end
      msgParam.update.charid = update.charid
    end
    if update ~= nil and update.anglez ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.update == nil then
        msgParam.update = {}
      end
      msgParam.update.anglez = update.anglez
    end
    if update ~= nil and update.time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.update == nil then
        msgParam.update = {}
      end
      msgParam.update.time = update.time
    end
    if update ~= nil and update.mapid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.update == nil then
        msgParam.update = {}
      end
      msgParam.update.mapid = update.mapid
    end
    if update ~= nil and update.sourceid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.update == nil then
        msgParam.update = {}
      end
      msgParam.update.sourceid = update.sourceid
    end
    if update ~= nil and update.source ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.update == nil then
        msgParam.update = {}
      end
      msgParam.update.source = update.source
    end
    if del ~= nil and del.accid_svr ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.del == nil then
        msgParam.del = {}
      end
      msgParam.del.accid_svr = del.accid_svr
    end
    if del ~= nil and del.accid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.del == nil then
        msgParam.del = {}
      end
      msgParam.del.accid = del.accid
    end
    if del ~= nil and del.charid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.del == nil then
        msgParam.del = {}
      end
      msgParam.del.charid = del.charid
    end
    if del ~= nil and del.anglez ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.del == nil then
        msgParam.del = {}
      end
      msgParam.del.anglez = del.anglez
    end
    if del ~= nil and del.time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.del == nil then
        msgParam.del = {}
      end
      msgParam.del.time = del.time
    end
    if del ~= nil and del.mapid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.del == nil then
        msgParam.del = {}
      end
      msgParam.del.mapid = del.mapid
    end
    if del ~= nil and del.sourceid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.del == nil then
        msgParam.del = {}
      end
      msgParam.del.sourceid = del.sourceid
    end
    if del ~= nil and del.source ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.del == nil then
        msgParam.del = {}
      end
      msgParam.del.source = del.source
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServicePhotoCmdAutoProxy:CallQueryMd5ListPhotoCmd(item)
  if not NetConfig.PBC then
    local msg = PhotoCmd_pb.QueryMd5ListPhotoCmd()
    if item ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      for i = 1, #item do
        table.insert(msg.item, item[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryMd5ListPhotoCmd.id
    local msgParam = {}
    if item ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      for i = 1, #item do
        table.insert(msgParam.item, item[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServicePhotoCmdAutoProxy:CallAddMd5PhotoCmd(md5)
  if not NetConfig.PBC then
    local msg = PhotoCmd_pb.AddMd5PhotoCmd()
    if md5 ~= nil and md5.sourceid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.md5 == nil then
        msg.md5 = {}
      end
      msg.md5.sourceid = md5.sourceid
    end
    if md5 ~= nil and md5.time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.md5 == nil then
        msg.md5 = {}
      end
      msg.md5.time = md5.time
    end
    if md5 ~= nil and md5.source ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.md5 == nil then
        msg.md5 = {}
      end
      msg.md5.source = md5.source
    end
    if md5 ~= nil and md5.md5 ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.md5 == nil then
        msg.md5 = {}
      end
      msg.md5.md5 = md5.md5
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AddMd5PhotoCmd.id
    local msgParam = {}
    if md5 ~= nil and md5.sourceid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.md5 == nil then
        msgParam.md5 = {}
      end
      msgParam.md5.sourceid = md5.sourceid
    end
    if md5 ~= nil and md5.time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.md5 == nil then
        msgParam.md5 = {}
      end
      msgParam.md5.time = md5.time
    end
    if md5 ~= nil and md5.source ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.md5 == nil then
        msgParam.md5 = {}
      end
      msgParam.md5.source = md5.source
    end
    if md5 ~= nil and md5.md5 ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.md5 == nil then
        msgParam.md5 = {}
      end
      msgParam.md5.md5 = md5.md5
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServicePhotoCmdAutoProxy:CallRemoveMd5PhotoCmd(md5)
  if not NetConfig.PBC then
    local msg = PhotoCmd_pb.RemoveMd5PhotoCmd()
    if md5 ~= nil and md5.sourceid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.md5 == nil then
        msg.md5 = {}
      end
      msg.md5.sourceid = md5.sourceid
    end
    if md5 ~= nil and md5.time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.md5 == nil then
        msg.md5 = {}
      end
      msg.md5.time = md5.time
    end
    if md5 ~= nil and md5.source ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.md5 == nil then
        msg.md5 = {}
      end
      msg.md5.source = md5.source
    end
    if md5 ~= nil and md5.md5 ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.md5 == nil then
        msg.md5 = {}
      end
      msg.md5.md5 = md5.md5
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RemoveMd5PhotoCmd.id
    local msgParam = {}
    if md5 ~= nil and md5.sourceid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.md5 == nil then
        msgParam.md5 = {}
      end
      msgParam.md5.sourceid = md5.sourceid
    end
    if md5 ~= nil and md5.time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.md5 == nil then
        msgParam.md5 = {}
      end
      msgParam.md5.time = md5.time
    end
    if md5 ~= nil and md5.source ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.md5 == nil then
        msgParam.md5 = {}
      end
      msgParam.md5.source = md5.source
    end
    if md5 ~= nil and md5.md5 ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.md5 == nil then
        msgParam.md5 = {}
      end
      msgParam.md5.md5 = md5.md5
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServicePhotoCmdAutoProxy:CallQueryUrlPhotoCmd(urls)
  if not NetConfig.PBC then
    local msg = PhotoCmd_pb.QueryUrlPhotoCmd()
    if urls ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.urls == nil then
        msg.urls = {}
      end
      for i = 1, #urls do
        table.insert(msg.urls, urls[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryUrlPhotoCmd.id
    local msgParam = {}
    if urls ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.urls == nil then
        msgParam.urls = {}
      end
      for i = 1, #urls do
        table.insert(msgParam.urls, urls[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServicePhotoCmdAutoProxy:CallQueryUploadInfoPhotoCmd(type, id, customparam, path, params, useaws)
  if not NetConfig.PBC then
    local msg = PhotoCmd_pb.QueryUploadInfoPhotoCmd()
    if type ~= nil then
      msg.type = type
    end
    if id ~= nil then
      msg.id = id
    end
    if customparam ~= nil then
      msg.customparam = customparam
    end
    if path ~= nil then
      msg.path = path
    end
    if params ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.params == nil then
        msg.params = {}
      end
      for i = 1, #params do
        table.insert(msg.params, params[i])
      end
    end
    if useaws ~= nil then
      msg.useaws = useaws
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryUploadInfoPhotoCmd.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if id ~= nil then
      msgParam.id = id
    end
    if customparam ~= nil then
      msgParam.customparam = customparam
    end
    if path ~= nil then
      msgParam.path = path
    end
    if params ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.params == nil then
        msgParam.params = {}
      end
      for i = 1, #params do
        table.insert(msgParam.params, params[i])
      end
    end
    if useaws ~= nil then
      msgParam.useaws = useaws
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServicePhotoCmdAutoProxy:RecvPhotoQueryListCmd(data)
  self:Notify(ServiceEvent.PhotoCmdPhotoQueryListCmd, data)
end
function ServicePhotoCmdAutoProxy:RecvPhotoOptCmd(data)
  self:Notify(ServiceEvent.PhotoCmdPhotoOptCmd, data)
end
function ServicePhotoCmdAutoProxy:RecvPhotoUpdateNtf(data)
  self:Notify(ServiceEvent.PhotoCmdPhotoUpdateNtf, data)
end
function ServicePhotoCmdAutoProxy:RecvFrameActionPhotoCmd(data)
  self:Notify(ServiceEvent.PhotoCmdFrameActionPhotoCmd, data)
end
function ServicePhotoCmdAutoProxy:RecvQueryFramePhotoListPhotoCmd(data)
  self:Notify(ServiceEvent.PhotoCmdQueryFramePhotoListPhotoCmd, data)
end
function ServicePhotoCmdAutoProxy:RecvQueryUserPhotoListPhotoCmd(data)
  self:Notify(ServiceEvent.PhotoCmdQueryUserPhotoListPhotoCmd, data)
end
function ServicePhotoCmdAutoProxy:RecvUpdateFrameShowPhotoCmd(data)
  self:Notify(ServiceEvent.PhotoCmdUpdateFrameShowPhotoCmd, data)
end
function ServicePhotoCmdAutoProxy:RecvFramePhotoUpdatePhotoCmd(data)
  self:Notify(ServiceEvent.PhotoCmdFramePhotoUpdatePhotoCmd, data)
end
function ServicePhotoCmdAutoProxy:RecvQueryMd5ListPhotoCmd(data)
  self:Notify(ServiceEvent.PhotoCmdQueryMd5ListPhotoCmd, data)
end
function ServicePhotoCmdAutoProxy:RecvAddMd5PhotoCmd(data)
  self:Notify(ServiceEvent.PhotoCmdAddMd5PhotoCmd, data)
end
function ServicePhotoCmdAutoProxy:RecvRemoveMd5PhotoCmd(data)
  self:Notify(ServiceEvent.PhotoCmdRemoveMd5PhotoCmd, data)
end
function ServicePhotoCmdAutoProxy:RecvQueryUrlPhotoCmd(data)
  self:Notify(ServiceEvent.PhotoCmdQueryUrlPhotoCmd, data)
end
function ServicePhotoCmdAutoProxy:RecvQueryUploadInfoPhotoCmd(data)
  self:Notify(ServiceEvent.PhotoCmdQueryUploadInfoPhotoCmd, data)
end
ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.PhotoCmdPhotoQueryListCmd = "ServiceEvent_PhotoCmdPhotoQueryListCmd"
ServiceEvent.PhotoCmdPhotoOptCmd = "ServiceEvent_PhotoCmdPhotoOptCmd"
ServiceEvent.PhotoCmdPhotoUpdateNtf = "ServiceEvent_PhotoCmdPhotoUpdateNtf"
ServiceEvent.PhotoCmdFrameActionPhotoCmd = "ServiceEvent_PhotoCmdFrameActionPhotoCmd"
ServiceEvent.PhotoCmdQueryFramePhotoListPhotoCmd = "ServiceEvent_PhotoCmdQueryFramePhotoListPhotoCmd"
ServiceEvent.PhotoCmdQueryUserPhotoListPhotoCmd = "ServiceEvent_PhotoCmdQueryUserPhotoListPhotoCmd"
ServiceEvent.PhotoCmdUpdateFrameShowPhotoCmd = "ServiceEvent_PhotoCmdUpdateFrameShowPhotoCmd"
ServiceEvent.PhotoCmdFramePhotoUpdatePhotoCmd = "ServiceEvent_PhotoCmdFramePhotoUpdatePhotoCmd"
ServiceEvent.PhotoCmdQueryMd5ListPhotoCmd = "ServiceEvent_PhotoCmdQueryMd5ListPhotoCmd"
ServiceEvent.PhotoCmdAddMd5PhotoCmd = "ServiceEvent_PhotoCmdAddMd5PhotoCmd"
ServiceEvent.PhotoCmdRemoveMd5PhotoCmd = "ServiceEvent_PhotoCmdRemoveMd5PhotoCmd"
ServiceEvent.PhotoCmdQueryUrlPhotoCmd = "ServiceEvent_PhotoCmdQueryUrlPhotoCmd"
ServiceEvent.PhotoCmdQueryUploadInfoPhotoCmd = "ServiceEvent_PhotoCmdQueryUploadInfoPhotoCmd"
