ServiceActivityCmdAutoProxy = class("ServiceActivityCmdAutoProxy", ServiceProxy)
ServiceActivityCmdAutoProxy.Instance = nil
ServiceActivityCmdAutoProxy.NAME = "ServiceActivityCmdAutoProxy"
function ServiceActivityCmdAutoProxy:ctor(proxyName)
  if ServiceActivityCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceActivityCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceActivityCmdAutoProxy.Instance = self
  end
end
function ServiceActivityCmdAutoProxy:Init()
end
function ServiceActivityCmdAutoProxy:onRegister()
  self:Listen(60, 1, function(data)
    self:RecvStartActCmd(data)
  end)
  self:Listen(60, 4, function(data)
    self:RecvStopActCmd(data)
  end)
  self:Listen(60, 2, function(data)
    self:RecvBCatUFOPosActCmd(data)
  end)
  self:Listen(60, 3, function(data)
    self:RecvActProgressNtfCmd(data)
  end)
  self:Listen(60, 5, function(data)
    self:RecvStartGlobalActCmd(data)
  end)
  self:Listen(60, 6, function(data)
    self:RecvActProgressExceptNtfCmd(data)
  end)
  self:Listen(60, 7, function(data)
    self:RecvTimeLimitShopPageCmd(data)
  end)
  self:Listen(60, 8, function(data)
    self:RecvAnimationLoginActCmd(data)
  end)
  self:Listen(60, 9, function(data)
    self:RecvGlobalDonationActivityInfoCmd(data)
  end)
  self:Listen(60, 10, function(data)
    self:RecvGlobalDonationActivityDonateCmd(data)
  end)
  self:Listen(60, 11, function(data)
    self:RecvGlobalDonationActivityAwardCmd(data)
  end)
  self:Listen(60, 12, function(data)
    self:RecvUserInviteInfoCmd(data)
  end)
  self:Listen(60, 13, function(data)
    self:RecvUserInviteBindUserCmd(data)
  end)
  self:Listen(60, 14, function(data)
    self:RecvUserInviteInviteAwardCmd(data)
  end)
  self:Listen(60, 15, function(data)
    self:RecvUserInviteShareAwardCmd(data)
  end)
  self:Listen(60, 16, function(data)
    self:RecvUserInviteInviteLoginAwardCmd(data)
  end)
  self:Listen(60, 17, function(data)
    self:RecvUserInviteRecallLoginAwardCmd(data)
  end)
  self:Listen(60, 18, function(data)
    self:RecvUserReturnInfoCmd(data)
  end)
  self:Listen(60, 19, function(data)
    self:RecvUserReturnQuestAwardCmd(data)
  end)
  self:Listen(60, 20, function(data)
    self:RecvUserReturnQuestAddCmd(data)
  end)
  self:Listen(60, 21, function(data)
    self:RecvUserReturnEnterChatRoomCmd(data)
  end)
  self:Listen(60, 22, function(data)
    self:RecvUserReturnLeaveChatRoomCmd(data)
  end)
  self:Listen(60, 23, function(data)
    self:RecvUserReturnLoginAwardCmd(data)
  end)
  self:Listen(60, 24, function(data)
    self:RecvUserReturnChatRoomRecordCmd(data)
  end)
  self:Listen(60, 25, function(data)
    self:RecvUserReturnRaidAwardCmd(data)
  end)
  self:Listen(60, 30, function(data)
    self:RecvWishActivityInfoCmd(data)
  end)
  self:Listen(60, 31, function(data)
    self:RecvWishActivityWishCmd(data)
  end)
  self:Listen(60, 32, function(data)
    self:RecvWishActivityLikeCmd(data)
  end)
  self:Listen(60, 33, function(data)
    self:RecvWishActivityLikeRecordCmd(data)
  end)
  self:Listen(60, 41, function(data)
    self:RecvUserReturnInviteCmd(data)
  end)
  self:Listen(60, 39, function(data)
    self:RecvUserReturnShareAwardCmd(data)
  end)
  self:Listen(60, 40, function(data)
    self:RecvUserReturnInviteAwardCmd(data)
  end)
  self:Listen(60, 38, function(data)
    self:RecvUserReturnBindCmd(data)
  end)
  self:Listen(60, 42, function(data)
    self:RecvUserReturnInviteRecordCmd(data)
  end)
  self:Listen(60, 43, function(data)
    self:RecvUserReturnInviteActivityNtfCmd(data)
  end)
  self:Listen(60, 34, function(data)
    self:RecvGuildAssembleSyncCmd(data)
  end)
  self:Listen(60, 35, function(data)
    self:RecvGuildAssembleAcceptCmd(data)
  end)
  self:Listen(60, 36, function(data)
    self:RecvGuildAssembleAwardCmd(data)
  end)
  self:Listen(60, 26, function(data)
    self:RecvDaySigninInfoCmd(data)
  end)
  self:Listen(60, 27, function(data)
    self:RecvDaySigninLoginAwardCmd(data)
  end)
  self:Listen(60, 28, function(data)
    self:RecvDaySigninActivityCmd(data)
  end)
  self:Listen(60, 46, function(data)
    self:RecvBattleFundNofityActCmd(data)
  end)
  self:Listen(60, 47, function(data)
    self:RecvBattleFundRewardActCmd(data)
  end)
  self:Listen(60, 44, function(data)
    self:RecvUserInviteCmd(data)
  end)
  self:Listen(60, 45, function(data)
    self:RecvUserInviteAwardCmd(data)
  end)
  self:Listen(60, 48, function(data)
    self:RecvNewPartnerCmd(data)
  end)
  self:Listen(60, 49, function(data)
    self:RecvNewPartnerBindCmd(data)
  end)
end
function ServiceActivityCmdAutoProxy:CallStartActCmd(items)
  if not NetConfig.PBC then
    local msg = ActivityCmd_pb.StartActCmd()
    if items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.items == nil then
        msg.items = {}
      end
      for i = 1, #items do
        table.insert(msg.items, items[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.StartActCmd.id
    local msgParam = {}
    if items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.items == nil then
        msgParam.items = {}
      end
      for i = 1, #items do
        table.insert(msgParam.items, items[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceActivityCmdAutoProxy:CallStopActCmd(id)
  if not NetConfig.PBC then
    local msg = ActivityCmd_pb.StopActCmd()
    if id ~= nil then
      msg.id = id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.StopActCmd.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceActivityCmdAutoProxy:CallBCatUFOPosActCmd(pos)
  if not NetConfig.PBC then
    local msg = ActivityCmd_pb.BCatUFOPosActCmd()
    if pos ~= nil and pos.x ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.pos == nil then
        msg.pos = {}
      end
      msg.pos.x = pos.x
    end
    if pos ~= nil and pos.y ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.pos == nil then
        msg.pos = {}
      end
      msg.pos.y = pos.y
    end
    if pos ~= nil and pos.z ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.pos == nil then
        msg.pos = {}
      end
      msg.pos.z = pos.z
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BCatUFOPosActCmd.id
    local msgParam = {}
    if pos ~= nil and pos.x ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.pos == nil then
        msgParam.pos = {}
      end
      msgParam.pos.x = pos.x
    end
    if pos ~= nil and pos.y ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.pos == nil then
        msgParam.pos = {}
      end
      msgParam.pos.y = pos.y
    end
    if pos ~= nil and pos.z ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.pos == nil then
        msgParam.pos = {}
      end
      msgParam.pos.z = pos.z
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceActivityCmdAutoProxy:CallActProgressNtfCmd(items)
  if not NetConfig.PBC then
    local msg = ActivityCmd_pb.ActProgressNtfCmd()
    if items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.items == nil then
        msg.items = {}
      end
      for i = 1, #items do
        table.insert(msg.items, items[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ActProgressNtfCmd.id
    local msgParam = {}
    if items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.items == nil then
        msgParam.items = {}
      end
      for i = 1, #items do
        table.insert(msgParam.items, items[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceActivityCmdAutoProxy:CallStartGlobalActCmd(id, type, params, starttime, endtime, open, count)
  if not NetConfig.PBC then
    local msg = ActivityCmd_pb.StartGlobalActCmd()
    if id ~= nil then
      msg.id = id
    end
    if type ~= nil then
      msg.type = type
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
    if starttime ~= nil then
      msg.starttime = starttime
    end
    if endtime ~= nil then
      msg.endtime = endtime
    end
    if open ~= nil then
      msg.open = open
    end
    if count ~= nil then
      msg.count = count
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.StartGlobalActCmd.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    if type ~= nil then
      msgParam.type = type
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
    if starttime ~= nil then
      msgParam.starttime = starttime
    end
    if endtime ~= nil then
      msgParam.endtime = endtime
    end
    if open ~= nil then
      msgParam.open = open
    end
    if count ~= nil then
      msgParam.count = count
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceActivityCmdAutoProxy:CallActProgressExceptNtfCmd(ids)
  if not NetConfig.PBC then
    local msg = ActivityCmd_pb.ActProgressExceptNtfCmd()
    if ids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.ids == nil then
        msg.ids = {}
      end
      for i = 1, #ids do
        table.insert(msg.ids, ids[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ActProgressExceptNtfCmd.id
    local msgParam = {}
    if ids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.ids == nil then
        msgParam.ids = {}
      end
      for i = 1, #ids do
        table.insert(msgParam.ids, ids[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceActivityCmdAutoProxy:CallTimeLimitShopPageCmd(actid, items, refreshat, refreshtimes, rerefreshcost, reqrefresh)
  if not NetConfig.PBC then
    local msg = ActivityCmd_pb.TimeLimitShopPageCmd()
    if actid ~= nil then
      msg.actid = actid
    end
    if items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.items == nil then
        msg.items = {}
      end
      for i = 1, #items do
        table.insert(msg.items, items[i])
      end
    end
    if refreshat ~= nil then
      msg.refreshat = refreshat
    end
    if refreshtimes ~= nil then
      msg.refreshtimes = refreshtimes
    end
    if rerefreshcost ~= nil then
      msg.rerefreshcost = rerefreshcost
    end
    if reqrefresh ~= nil then
      msg.reqrefresh = reqrefresh
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TimeLimitShopPageCmd.id
    local msgParam = {}
    if actid ~= nil then
      msgParam.actid = actid
    end
    if items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.items == nil then
        msgParam.items = {}
      end
      for i = 1, #items do
        table.insert(msgParam.items, items[i])
      end
    end
    if refreshat ~= nil then
      msgParam.refreshat = refreshat
    end
    if refreshtimes ~= nil then
      msgParam.refreshtimes = refreshtimes
    end
    if rerefreshcost ~= nil then
      msgParam.rerefreshcost = rerefreshcost
    end
    if reqrefresh ~= nil then
      msgParam.reqrefresh = reqrefresh
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceActivityCmdAutoProxy:CallAnimationLoginActCmd(id)
  if not NetConfig.PBC then
    local msg = ActivityCmd_pb.AnimationLoginActCmd()
    if id ~= nil then
      msg.id = id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AnimationLoginActCmd.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceActivityCmdAutoProxy:CallGlobalDonationActivityInfoCmd(stage, showcommpletetext, donateval, awardedpersonalid, globalprocess, awardedglobalid, globalcompletetime)
  if not NetConfig.PBC then
    local msg = ActivityCmd_pb.GlobalDonationActivityInfoCmd()
    if stage ~= nil then
      msg.stage = stage
    end
    if showcommpletetext ~= nil then
      msg.showcommpletetext = showcommpletetext
    end
    if donateval ~= nil then
      msg.donateval = donateval
    end
    if awardedpersonalid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.awardedpersonalid == nil then
        msg.awardedpersonalid = {}
      end
      for i = 1, #awardedpersonalid do
        table.insert(msg.awardedpersonalid, awardedpersonalid[i])
      end
    end
    if globalprocess ~= nil then
      msg.globalprocess = globalprocess
    end
    if awardedglobalid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.awardedglobalid == nil then
        msg.awardedglobalid = {}
      end
      for i = 1, #awardedglobalid do
        table.insert(msg.awardedglobalid, awardedglobalid[i])
      end
    end
    if globalcompletetime ~= nil then
      msg.globalcompletetime = globalcompletetime
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GlobalDonationActivityInfoCmd.id
    local msgParam = {}
    if stage ~= nil then
      msgParam.stage = stage
    end
    if showcommpletetext ~= nil then
      msgParam.showcommpletetext = showcommpletetext
    end
    if donateval ~= nil then
      msgParam.donateval = donateval
    end
    if awardedpersonalid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.awardedpersonalid == nil then
        msgParam.awardedpersonalid = {}
      end
      for i = 1, #awardedpersonalid do
        table.insert(msgParam.awardedpersonalid, awardedpersonalid[i])
      end
    end
    if globalprocess ~= nil then
      msgParam.globalprocess = globalprocess
    end
    if awardedglobalid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.awardedglobalid == nil then
        msgParam.awardedglobalid = {}
      end
      for i = 1, #awardedglobalid do
        table.insert(msgParam.awardedglobalid, awardedglobalid[i])
      end
    end
    if globalcompletetime ~= nil then
      msgParam.globalcompletetime = globalcompletetime
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceActivityCmdAutoProxy:CallGlobalDonationActivityDonateCmd(num, sucess)
  if not NetConfig.PBC then
    local msg = ActivityCmd_pb.GlobalDonationActivityDonateCmd()
    if num ~= nil then
      msg.num = num
    end
    if sucess ~= nil then
      msg.sucess = sucess
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GlobalDonationActivityDonateCmd.id
    local msgParam = {}
    if num ~= nil then
      msgParam.num = num
    end
    if sucess ~= nil then
      msgParam.sucess = sucess
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceActivityCmdAutoProxy:CallGlobalDonationActivityAwardCmd(type, id, sucess)
  if not NetConfig.PBC then
    local msg = ActivityCmd_pb.GlobalDonationActivityAwardCmd()
    if type ~= nil then
      msg.type = type
    end
    if id ~= nil then
      msg.id = id
    end
    if sucess ~= nil then
      msg.sucess = sucess
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GlobalDonationActivityAwardCmd.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if id ~= nil then
      msgParam.id = id
    end
    if sucess ~= nil then
      msgParam.sucess = sucess
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceActivityCmdAutoProxy:CallUserInviteInfoCmd(invitecode, inviteuserid, inviteusername, inviteawarded, invitelogindays, inviteawardid, sharawarded, recalluser, binduser, recalllogindays, loginawarddid)
  if not NetConfig.PBC then
    local msg = ActivityCmd_pb.UserInviteInfoCmd()
    if invitecode ~= nil then
      msg.invitecode = invitecode
    end
    if inviteuserid ~= nil then
      msg.inviteuserid = inviteuserid
    end
    if inviteusername ~= nil then
      msg.inviteusername = inviteusername
    end
    if inviteawarded ~= nil then
      msg.inviteawarded = inviteawarded
    end
    if invitelogindays ~= nil then
      msg.invitelogindays = invitelogindays
    end
    if inviteawardid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.inviteawardid == nil then
        msg.inviteawardid = {}
      end
      for i = 1, #inviteawardid do
        table.insert(msg.inviteawardid, inviteawardid[i])
      end
    end
    if sharawarded ~= nil then
      msg.sharawarded = sharawarded
    end
    if recalluser ~= nil then
      msg.recalluser = recalluser
    end
    if binduser ~= nil then
      msg.binduser = binduser
    end
    if recalllogindays ~= nil then
      msg.recalllogindays = recalllogindays
    end
    if loginawarddid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.loginawarddid == nil then
        msg.loginawarddid = {}
      end
      for i = 1, #loginawarddid do
        table.insert(msg.loginawarddid, loginawarddid[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UserInviteInfoCmd.id
    local msgParam = {}
    if invitecode ~= nil then
      msgParam.invitecode = invitecode
    end
    if inviteuserid ~= nil then
      msgParam.inviteuserid = inviteuserid
    end
    if inviteusername ~= nil then
      msgParam.inviteusername = inviteusername
    end
    if inviteawarded ~= nil then
      msgParam.inviteawarded = inviteawarded
    end
    if invitelogindays ~= nil then
      msgParam.invitelogindays = invitelogindays
    end
    if inviteawardid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.inviteawardid == nil then
        msgParam.inviteawardid = {}
      end
      for i = 1, #inviteawardid do
        table.insert(msgParam.inviteawardid, inviteawardid[i])
      end
    end
    if sharawarded ~= nil then
      msgParam.sharawarded = sharawarded
    end
    if recalluser ~= nil then
      msgParam.recalluser = recalluser
    end
    if binduser ~= nil then
      msgParam.binduser = binduser
    end
    if recalllogindays ~= nil then
      msgParam.recalllogindays = recalllogindays
    end
    if loginawarddid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.loginawarddid == nil then
        msgParam.loginawarddid = {}
      end
      for i = 1, #loginawarddid do
        table.insert(msgParam.loginawarddid, loginawarddid[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceActivityCmdAutoProxy:CallUserInviteBindUserCmd(invitecode, sucess)
  if not NetConfig.PBC then
    local msg = ActivityCmd_pb.UserInviteBindUserCmd()
    if invitecode ~= nil then
      msg.invitecode = invitecode
    end
    if sucess ~= nil then
      msg.sucess = sucess
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UserInviteBindUserCmd.id
    local msgParam = {}
    if invitecode ~= nil then
      msgParam.invitecode = invitecode
    end
    if sucess ~= nil then
      msgParam.sucess = sucess
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceActivityCmdAutoProxy:CallUserInviteInviteAwardCmd(sucess)
  if not NetConfig.PBC then
    local msg = ActivityCmd_pb.UserInviteInviteAwardCmd()
    if sucess ~= nil then
      msg.sucess = sucess
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UserInviteInviteAwardCmd.id
    local msgParam = {}
    if sucess ~= nil then
      msgParam.sucess = sucess
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceActivityCmdAutoProxy:CallUserInviteShareAwardCmd(sucess)
  if not NetConfig.PBC then
    local msg = ActivityCmd_pb.UserInviteShareAwardCmd()
    if sucess ~= nil then
      msg.sucess = sucess
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UserInviteShareAwardCmd.id
    local msgParam = {}
    if sucess ~= nil then
      msgParam.sucess = sucess
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceActivityCmdAutoProxy:CallUserInviteInviteLoginAwardCmd(id)
  if not NetConfig.PBC then
    local msg = ActivityCmd_pb.UserInviteInviteLoginAwardCmd()
    if id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.id == nil then
        msg.id = {}
      end
      for i = 1, #id do
        table.insert(msg.id, id[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UserInviteInviteLoginAwardCmd.id
    local msgParam = {}
    if id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.id == nil then
        msgParam.id = {}
      end
      for i = 1, #id do
        table.insert(msgParam.id, id[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceActivityCmdAutoProxy:CallUserInviteRecallLoginAwardCmd(id)
  if not NetConfig.PBC then
    local msg = ActivityCmd_pb.UserInviteRecallLoginAwardCmd()
    if id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.id == nil then
        msg.id = {}
      end
      for i = 1, #id do
        table.insert(msg.id, id[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UserInviteRecallLoginAwardCmd.id
    local msgParam = {}
    if id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.id == nil then
        msgParam.id = {}
      end
      for i = 1, #id do
        table.insert(msgParam.id, id[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceActivityCmdAutoProxy:CallUserReturnInfoCmd(endtime, loginday, awardday, quests, bBind)
  if not NetConfig.PBC then
    local msg = ActivityCmd_pb.UserReturnInfoCmd()
    if endtime ~= nil then
      msg.endtime = endtime
    end
    if loginday ~= nil then
      msg.loginday = loginday
    end
    if awardday ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.awardday == nil then
        msg.awardday = {}
      end
      for i = 1, #awardday do
        table.insert(msg.awardday, awardday[i])
      end
    end
    if quests ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.quests == nil then
        msg.quests = {}
      end
      for i = 1, #quests do
        table.insert(msg.quests, quests[i])
      end
    end
    if bBind ~= nil then
      msg.bBind = bBind
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UserReturnInfoCmd.id
    local msgParam = {}
    if endtime ~= nil then
      msgParam.endtime = endtime
    end
    if loginday ~= nil then
      msgParam.loginday = loginday
    end
    if awardday ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.awardday == nil then
        msgParam.awardday = {}
      end
      for i = 1, #awardday do
        table.insert(msgParam.awardday, awardday[i])
      end
    end
    if quests ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.quests == nil then
        msgParam.quests = {}
      end
      for i = 1, #quests do
        table.insert(msgParam.quests, quests[i])
      end
    end
    if bBind ~= nil then
      msgParam.bBind = bBind
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceActivityCmdAutoProxy:CallUserReturnQuestAwardCmd(id, success)
  if not NetConfig.PBC then
    local msg = ActivityCmd_pb.UserReturnQuestAwardCmd()
    if id ~= nil then
      msg.id = id
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UserReturnQuestAwardCmd.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceActivityCmdAutoProxy:CallUserReturnQuestAddCmd(quest)
  if not NetConfig.PBC then
    local msg = ActivityCmd_pb.UserReturnQuestAddCmd()
    if quest ~= nil and quest.type ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.quest == nil then
        msg.quest = {}
      end
      msg.quest.type = quest.type
    end
    if quest ~= nil and quest.id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.quest == nil then
        msg.quest = {}
      end
      msg.quest.id = quest.id
    end
    if quest ~= nil and quest.process ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.quest == nil then
        msg.quest = {}
      end
      msg.quest.process = quest.process
    end
    if quest ~= nil and quest.goal ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.quest == nil then
        msg.quest = {}
      end
      msg.quest.goal = quest.goal
    end
    if quest ~= nil and quest.awarded ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.quest == nil then
        msg.quest = {}
      end
      msg.quest.awarded = quest.awarded
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UserReturnQuestAddCmd.id
    local msgParam = {}
    if quest ~= nil and quest.type ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.quest == nil then
        msgParam.quest = {}
      end
      msgParam.quest.type = quest.type
    end
    if quest ~= nil and quest.id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.quest == nil then
        msgParam.quest = {}
      end
      msgParam.quest.id = quest.id
    end
    if quest ~= nil and quest.process ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.quest == nil then
        msgParam.quest = {}
      end
      msgParam.quest.process = quest.process
    end
    if quest ~= nil and quest.goal ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.quest == nil then
        msgParam.quest = {}
      end
      msgParam.quest.goal = quest.goal
    end
    if quest ~= nil and quest.awarded ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.quest == nil then
        msgParam.quest = {}
      end
      msgParam.quest.awarded = quest.awarded
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceActivityCmdAutoProxy:CallUserReturnEnterChatRoomCmd(success)
  if not NetConfig.PBC then
    local msg = ActivityCmd_pb.UserReturnEnterChatRoomCmd()
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UserReturnEnterChatRoomCmd.id
    local msgParam = {}
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceActivityCmdAutoProxy:CallUserReturnLeaveChatRoomCmd()
  if not NetConfig.PBC then
    local msg = ActivityCmd_pb.UserReturnLeaveChatRoomCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UserReturnLeaveChatRoomCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceActivityCmdAutoProxy:CallUserReturnLoginAwardCmd(day)
  if not NetConfig.PBC then
    local msg = ActivityCmd_pb.UserReturnLoginAwardCmd()
    if day ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.day == nil then
        msg.day = {}
      end
      for i = 1, #day do
        table.insert(msg.day, day[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UserReturnLoginAwardCmd.id
    local msgParam = {}
    if day ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.day == nil then
        msgParam.day = {}
      end
      for i = 1, #day do
        table.insert(msgParam.day, day[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceActivityCmdAutoProxy:CallUserReturnChatRoomRecordCmd(minrecorid, records)
  if not NetConfig.PBC then
    local msg = ActivityCmd_pb.UserReturnChatRoomRecordCmd()
    if minrecorid ~= nil then
      msg.minrecorid = minrecorid
    end
    if records ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.records == nil then
        msg.records = {}
      end
      for i = 1, #records do
        table.insert(msg.records, records[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UserReturnChatRoomRecordCmd.id
    local msgParam = {}
    if minrecorid ~= nil then
      msgParam.minrecorid = minrecorid
    end
    if records ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.records == nil then
        msgParam.records = {}
      end
      for i = 1, #records do
        table.insert(msgParam.records, records[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceActivityCmdAutoProxy:CallUserReturnRaidAwardCmd()
  if not NetConfig.PBC then
    local msg = ActivityCmd_pb.UserReturnRaidAwardCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UserReturnRaidAwardCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceActivityCmdAutoProxy:CallWishActivityInfoCmd(mywish, randomwish)
  if not NetConfig.PBC then
    local msg = ActivityCmd_pb.WishActivityInfoCmd()
    if mywish ~= nil and mywish.id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mywish == nil then
        msg.mywish = {}
      end
      msg.mywish.id = mywish.id
    end
    if mywish ~= nil and mywish.charid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mywish == nil then
        msg.mywish = {}
      end
      msg.mywish.charid = mywish.charid
    end
    if mywish ~= nil and mywish.charname ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mywish == nil then
        msg.mywish = {}
      end
      msg.mywish.charname = mywish.charname
    end
    if mywish ~= nil and mywish.text ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mywish == nil then
        msg.mywish = {}
      end
      msg.mywish.text = mywish.text
    end
    if mywish ~= nil and mywish.likenum ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mywish == nil then
        msg.mywish = {}
      end
      msg.mywish.likenum = mywish.likenum
    end
    if mywish ~= nil and mywish.likeed ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mywish == nil then
        msg.mywish = {}
      end
      msg.mywish.likeed = mywish.likeed
    end
    if randomwish ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.randomwish == nil then
        msg.randomwish = {}
      end
      for i = 1, #randomwish do
        table.insert(msg.randomwish, randomwish[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.WishActivityInfoCmd.id
    local msgParam = {}
    if mywish ~= nil and mywish.id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mywish == nil then
        msgParam.mywish = {}
      end
      msgParam.mywish.id = mywish.id
    end
    if mywish ~= nil and mywish.charid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mywish == nil then
        msgParam.mywish = {}
      end
      msgParam.mywish.charid = mywish.charid
    end
    if mywish ~= nil and mywish.charname ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mywish == nil then
        msgParam.mywish = {}
      end
      msgParam.mywish.charname = mywish.charname
    end
    if mywish ~= nil and mywish.text ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mywish == nil then
        msgParam.mywish = {}
      end
      msgParam.mywish.text = mywish.text
    end
    if mywish ~= nil and mywish.likenum ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mywish == nil then
        msgParam.mywish = {}
      end
      msgParam.mywish.likenum = mywish.likenum
    end
    if mywish ~= nil and mywish.likeed ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mywish == nil then
        msgParam.mywish = {}
      end
      msgParam.mywish.likeed = mywish.likeed
    end
    if randomwish ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.randomwish == nil then
        msgParam.randomwish = {}
      end
      for i = 1, #randomwish do
        table.insert(msgParam.randomwish, randomwish[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceActivityCmdAutoProxy:CallWishActivityWishCmd(text, success)
  if not NetConfig.PBC then
    local msg = ActivityCmd_pb.WishActivityWishCmd()
    if text ~= nil then
      msg.text = text
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.WishActivityWishCmd.id
    local msgParam = {}
    if text ~= nil then
      msgParam.text = text
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceActivityCmdAutoProxy:CallWishActivityLikeCmd(id, cancel)
  if not NetConfig.PBC then
    local msg = ActivityCmd_pb.WishActivityLikeCmd()
    if id ~= nil then
      msg.id = id
    end
    if cancel ~= nil then
      msg.cancel = cancel
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.WishActivityLikeCmd.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    if cancel ~= nil then
      msgParam.cancel = cancel
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceActivityCmdAutoProxy:CallWishActivityLikeRecordCmd(id, recordid, record)
  if not NetConfig.PBC then
    local msg = ActivityCmd_pb.WishActivityLikeRecordCmd()
    if id ~= nil then
      msg.id = id
    end
    if recordid ~= nil then
      msg.recordid = recordid
    end
    if record ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.record == nil then
        msg.record = {}
      end
      for i = 1, #record do
        table.insert(msg.record, record[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.WishActivityLikeRecordCmd.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    if recordid ~= nil then
      msgParam.recordid = recordid
    end
    if record ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.record == nil then
        msgParam.record = {}
      end
      for i = 1, #record do
        table.insert(msgParam.record, record[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceActivityCmdAutoProxy:CallUserReturnInviteCmd(code, invitenum, awardid, hasnewinvite, got_share_reward)
  if not NetConfig.PBC then
    local msg = ActivityCmd_pb.UserReturnInviteCmd()
    if code ~= nil then
      msg.code = code
    end
    if invitenum ~= nil then
      msg.invitenum = invitenum
    end
    if awardid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.awardid == nil then
        msg.awardid = {}
      end
      for i = 1, #awardid do
        table.insert(msg.awardid, awardid[i])
      end
    end
    if hasnewinvite ~= nil then
      msg.hasnewinvite = hasnewinvite
    end
    if got_share_reward ~= nil then
      msg.got_share_reward = got_share_reward
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UserReturnInviteCmd.id
    local msgParam = {}
    if code ~= nil then
      msgParam.code = code
    end
    if invitenum ~= nil then
      msgParam.invitenum = invitenum
    end
    if awardid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.awardid == nil then
        msgParam.awardid = {}
      end
      for i = 1, #awardid do
        table.insert(msgParam.awardid, awardid[i])
      end
    end
    if hasnewinvite ~= nil then
      msgParam.hasnewinvite = hasnewinvite
    end
    if got_share_reward ~= nil then
      msgParam.got_share_reward = got_share_reward
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceActivityCmdAutoProxy:CallUserReturnShareAwardCmd(success)
  if not NetConfig.PBC then
    local msg = ActivityCmd_pb.UserReturnShareAwardCmd()
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UserReturnShareAwardCmd.id
    local msgParam = {}
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceActivityCmdAutoProxy:CallUserReturnInviteAwardCmd(awardid, success)
  if not NetConfig.PBC then
    local msg = ActivityCmd_pb.UserReturnInviteAwardCmd()
    if awardid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.awardid == nil then
        msg.awardid = {}
      end
      for i = 1, #awardid do
        table.insert(msg.awardid, awardid[i])
      end
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UserReturnInviteAwardCmd.id
    local msgParam = {}
    if awardid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.awardid == nil then
        msgParam.awardid = {}
      end
      for i = 1, #awardid do
        table.insert(msgParam.awardid, awardid[i])
      end
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceActivityCmdAutoProxy:CallUserReturnBindCmd(code, success)
  if not NetConfig.PBC then
    local msg = ActivityCmd_pb.UserReturnBindCmd()
    if code ~= nil then
      msg.code = code
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UserReturnBindCmd.id
    local msgParam = {}
    if code ~= nil then
      msgParam.code = code
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceActivityCmdAutoProxy:CallUserReturnInviteRecordCmd(records, activityid)
  if not NetConfig.PBC then
    local msg = ActivityCmd_pb.UserReturnInviteRecordCmd()
    if records ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.records == nil then
        msg.records = {}
      end
      for i = 1, #records do
        table.insert(msg.records, records[i])
      end
    end
    if activityid ~= nil then
      msg.activityid = activityid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UserReturnInviteRecordCmd.id
    local msgParam = {}
    if records ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.records == nil then
        msgParam.records = {}
      end
      for i = 1, #records do
        table.insert(msgParam.records, records[i])
      end
    end
    if activityid ~= nil then
      msgParam.activityid = activityid
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceActivityCmdAutoProxy:CallUserReturnInviteActivityNtfCmd(activityid)
  if not NetConfig.PBC then
    local msg = ActivityCmd_pb.UserReturnInviteActivityNtfCmd()
    if activityid ~= nil then
      msg.activityid = activityid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UserReturnInviteActivityNtfCmd.id
    local msgParam = {}
    if activityid ~= nil then
      msgParam.activityid = activityid
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceActivityCmdAutoProxy:CallGuildAssembleSyncCmd(status, awardid, isnew, isacceptchar, iscompleteguild)
  if not NetConfig.PBC then
    local msg = ActivityCmd_pb.GuildAssembleSyncCmd()
    if status ~= nil then
      msg.status = status
    end
    if awardid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.awardid == nil then
        msg.awardid = {}
      end
      for i = 1, #awardid do
        table.insert(msg.awardid, awardid[i])
      end
    end
    if isnew ~= nil then
      msg.isnew = isnew
    end
    if isacceptchar ~= nil then
      msg.isacceptchar = isacceptchar
    end
    if iscompleteguild ~= nil then
      msg.iscompleteguild = iscompleteguild
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GuildAssembleSyncCmd.id
    local msgParam = {}
    if status ~= nil then
      msgParam.status = status
    end
    if awardid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.awardid == nil then
        msgParam.awardid = {}
      end
      for i = 1, #awardid do
        table.insert(msgParam.awardid, awardid[i])
      end
    end
    if isnew ~= nil then
      msgParam.isnew = isnew
    end
    if isacceptchar ~= nil then
      msgParam.isacceptchar = isacceptchar
    end
    if iscompleteguild ~= nil then
      msgParam.iscompleteguild = iscompleteguild
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceActivityCmdAutoProxy:CallGuildAssembleAcceptCmd(success)
  if not NetConfig.PBC then
    local msg = ActivityCmd_pb.GuildAssembleAcceptCmd()
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GuildAssembleAcceptCmd.id
    local msgParam = {}
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceActivityCmdAutoProxy:CallGuildAssembleAwardCmd(id, success)
  if not NetConfig.PBC then
    local msg = ActivityCmd_pb.GuildAssembleAwardCmd()
    if id ~= nil then
      msg.id = id
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GuildAssembleAwardCmd.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceActivityCmdAutoProxy:CallDaySigninInfoCmd(infos, tip)
  if not NetConfig.PBC then
    local msg = ActivityCmd_pb.DaySigninInfoCmd()
    if infos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.infos == nil then
        msg.infos = {}
      end
      for i = 1, #infos do
        table.insert(msg.infos, infos[i])
      end
    end
    if tip ~= nil then
      msg.tip = tip
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DaySigninInfoCmd.id
    local msgParam = {}
    if infos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.infos == nil then
        msgParam.infos = {}
      end
      for i = 1, #infos do
        table.insert(msgParam.infos, infos[i])
      end
    end
    if tip ~= nil then
      msgParam.tip = tip
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceActivityCmdAutoProxy:CallDaySigninLoginAwardCmd(activityid, days)
  if not NetConfig.PBC then
    local msg = ActivityCmd_pb.DaySigninLoginAwardCmd()
    if activityid ~= nil then
      msg.activityid = activityid
    end
    if days ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.days == nil then
        msg.days = {}
      end
      for i = 1, #days do
        table.insert(msg.days, days[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DaySigninLoginAwardCmd.id
    local msgParam = {}
    if activityid ~= nil then
      msgParam.activityid = activityid
    end
    if days ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.days == nil then
        msgParam.days = {}
      end
      for i = 1, #days do
        table.insert(msgParam.days, days[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceActivityCmdAutoProxy:CallDaySigninActivityCmd(infos)
  if not NetConfig.PBC then
    local msg = ActivityCmd_pb.DaySigninActivityCmd()
    if infos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.infos == nil then
        msg.infos = {}
      end
      for i = 1, #infos do
        table.insert(msg.infos, infos[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DaySigninActivityCmd.id
    local msgParam = {}
    if infos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.infos == nil then
        msgParam.infos = {}
      end
      for i = 1, #infos do
        table.insert(msgParam.infos, infos[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceActivityCmdAutoProxy:CallBattleFundNofityActCmd(info)
  if not NetConfig.PBC then
    local msg = ActivityCmd_pb.BattleFundNofityActCmd()
    if info ~= nil and info.activityid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.activityid = info.activityid
    end
    if info ~= nil and info.starttime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.starttime = info.starttime
    end
    if info ~= nil and info.buytime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.buytime = info.buytime
    end
    if info ~= nil and info.loginday ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.loginday = info.loginday
    end
    if info ~= nil and info.rewarddays ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.rewarddays == nil then
        msg.info.rewarddays = {}
      end
      for i = 1, #info.rewarddays do
        table.insert(msg.info.rewarddays, info.rewarddays[i])
      end
    end
    if info ~= nil and info.freerewarddays ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.freerewarddays == nil then
        msg.info.freerewarddays = {}
      end
      for i = 1, #info.freerewarddays do
        table.insert(msg.info.freerewarddays, info.freerewarddays[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BattleFundNofityActCmd.id
    local msgParam = {}
    if info ~= nil and info.activityid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.activityid = info.activityid
    end
    if info ~= nil and info.starttime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.starttime = info.starttime
    end
    if info ~= nil and info.buytime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.buytime = info.buytime
    end
    if info ~= nil and info.loginday ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.loginday = info.loginday
    end
    if info ~= nil and info.rewarddays ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.rewarddays == nil then
        msgParam.info.rewarddays = {}
      end
      for i = 1, #info.rewarddays do
        table.insert(msgParam.info.rewarddays, info.rewarddays[i])
      end
    end
    if info ~= nil and info.freerewarddays ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.freerewarddays == nil then
        msgParam.info.freerewarddays = {}
      end
      for i = 1, #info.freerewarddays do
        table.insert(msgParam.info.freerewarddays, info.freerewarddays[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceActivityCmdAutoProxy:CallBattleFundRewardActCmd(activityid, rewardday, free)
  if not NetConfig.PBC then
    local msg = ActivityCmd_pb.BattleFundRewardActCmd()
    if activityid ~= nil then
      msg.activityid = activityid
    end
    if rewardday ~= nil then
      msg.rewardday = rewardday
    end
    if free ~= nil then
      msg.free = free
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BattleFundRewardActCmd.id
    local msgParam = {}
    if activityid ~= nil then
      msgParam.activityid = activityid
    end
    if rewardday ~= nil then
      msgParam.rewardday = rewardday
    end
    if free ~= nil then
      msgParam.free = free
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceActivityCmdAutoProxy:CallUserInviteCmd(code, awardid, hasnewinvite)
  if not NetConfig.PBC then
    local msg = ActivityCmd_pb.UserInviteCmd()
    if code ~= nil then
      msg.code = code
    end
    if awardid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.awardid == nil then
        msg.awardid = {}
      end
      for i = 1, #awardid do
        table.insert(msg.awardid, awardid[i])
      end
    end
    if hasnewinvite ~= nil then
      msg.hasnewinvite = hasnewinvite
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UserInviteCmd.id
    local msgParam = {}
    if code ~= nil then
      msgParam.code = code
    end
    if awardid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.awardid == nil then
        msgParam.awardid = {}
      end
      for i = 1, #awardid do
        table.insert(msgParam.awardid, awardid[i])
      end
    end
    if hasnewinvite ~= nil then
      msgParam.hasnewinvite = hasnewinvite
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceActivityCmdAutoProxy:CallUserInviteAwardCmd(awardid, activityid)
  if not NetConfig.PBC then
    local msg = ActivityCmd_pb.UserInviteAwardCmd()
    if awardid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.awardid == nil then
        msg.awardid = {}
      end
      for i = 1, #awardid do
        table.insert(msg.awardid, awardid[i])
      end
    end
    if activityid ~= nil then
      msg.activityid = activityid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UserInviteAwardCmd.id
    local msgParam = {}
    if awardid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.awardid == nil then
        msgParam.awardid = {}
      end
      for i = 1, #awardid do
        table.insert(msgParam.awardid, awardid[i])
      end
    end
    if activityid ~= nil then
      msgParam.activityid = activityid
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceActivityCmdAutoProxy:CallNewPartnerCmd(awardid)
  if not NetConfig.PBC then
    local msg = ActivityCmd_pb.NewPartnerCmd()
    if awardid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.awardid == nil then
        msg.awardid = {}
      end
      for i = 1, #awardid do
        table.insert(msg.awardid, awardid[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NewPartnerCmd.id
    local msgParam = {}
    if awardid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.awardid == nil then
        msgParam.awardid = {}
      end
      for i = 1, #awardid do
        table.insert(msgParam.awardid, awardid[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceActivityCmdAutoProxy:CallNewPartnerBindCmd(code, success)
  if not NetConfig.PBC then
    local msg = ActivityCmd_pb.NewPartnerBindCmd()
    if code ~= nil then
      msg.code = code
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NewPartnerBindCmd.id
    local msgParam = {}
    if code ~= nil then
      msgParam.code = code
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceActivityCmdAutoProxy:RecvStartActCmd(data)
  self:Notify(ServiceEvent.ActivityCmdStartActCmd, data)
end
function ServiceActivityCmdAutoProxy:RecvStopActCmd(data)
  self:Notify(ServiceEvent.ActivityCmdStopActCmd, data)
end
function ServiceActivityCmdAutoProxy:RecvBCatUFOPosActCmd(data)
  self:Notify(ServiceEvent.ActivityCmdBCatUFOPosActCmd, data)
end
function ServiceActivityCmdAutoProxy:RecvActProgressNtfCmd(data)
  self:Notify(ServiceEvent.ActivityCmdActProgressNtfCmd, data)
end
function ServiceActivityCmdAutoProxy:RecvStartGlobalActCmd(data)
  self:Notify(ServiceEvent.ActivityCmdStartGlobalActCmd, data)
end
function ServiceActivityCmdAutoProxy:RecvActProgressExceptNtfCmd(data)
  self:Notify(ServiceEvent.ActivityCmdActProgressExceptNtfCmd, data)
end
function ServiceActivityCmdAutoProxy:RecvTimeLimitShopPageCmd(data)
  self:Notify(ServiceEvent.ActivityCmdTimeLimitShopPageCmd, data)
end
function ServiceActivityCmdAutoProxy:RecvAnimationLoginActCmd(data)
  self:Notify(ServiceEvent.ActivityCmdAnimationLoginActCmd, data)
end
function ServiceActivityCmdAutoProxy:RecvGlobalDonationActivityInfoCmd(data)
  self:Notify(ServiceEvent.ActivityCmdGlobalDonationActivityInfoCmd, data)
end
function ServiceActivityCmdAutoProxy:RecvGlobalDonationActivityDonateCmd(data)
  self:Notify(ServiceEvent.ActivityCmdGlobalDonationActivityDonateCmd, data)
end
function ServiceActivityCmdAutoProxy:RecvGlobalDonationActivityAwardCmd(data)
  self:Notify(ServiceEvent.ActivityCmdGlobalDonationActivityAwardCmd, data)
end
function ServiceActivityCmdAutoProxy:RecvUserInviteInfoCmd(data)
  self:Notify(ServiceEvent.ActivityCmdUserInviteInfoCmd, data)
end
function ServiceActivityCmdAutoProxy:RecvUserInviteBindUserCmd(data)
  self:Notify(ServiceEvent.ActivityCmdUserInviteBindUserCmd, data)
end
function ServiceActivityCmdAutoProxy:RecvUserInviteInviteAwardCmd(data)
  self:Notify(ServiceEvent.ActivityCmdUserInviteInviteAwardCmd, data)
end
function ServiceActivityCmdAutoProxy:RecvUserInviteShareAwardCmd(data)
  self:Notify(ServiceEvent.ActivityCmdUserInviteShareAwardCmd, data)
end
function ServiceActivityCmdAutoProxy:RecvUserInviteInviteLoginAwardCmd(data)
  self:Notify(ServiceEvent.ActivityCmdUserInviteInviteLoginAwardCmd, data)
end
function ServiceActivityCmdAutoProxy:RecvUserInviteRecallLoginAwardCmd(data)
  self:Notify(ServiceEvent.ActivityCmdUserInviteRecallLoginAwardCmd, data)
end
function ServiceActivityCmdAutoProxy:RecvUserReturnInfoCmd(data)
  self:Notify(ServiceEvent.ActivityCmdUserReturnInfoCmd, data)
end
function ServiceActivityCmdAutoProxy:RecvUserReturnQuestAwardCmd(data)
  self:Notify(ServiceEvent.ActivityCmdUserReturnQuestAwardCmd, data)
end
function ServiceActivityCmdAutoProxy:RecvUserReturnQuestAddCmd(data)
  self:Notify(ServiceEvent.ActivityCmdUserReturnQuestAddCmd, data)
end
function ServiceActivityCmdAutoProxy:RecvUserReturnEnterChatRoomCmd(data)
  self:Notify(ServiceEvent.ActivityCmdUserReturnEnterChatRoomCmd, data)
end
function ServiceActivityCmdAutoProxy:RecvUserReturnLeaveChatRoomCmd(data)
  self:Notify(ServiceEvent.ActivityCmdUserReturnLeaveChatRoomCmd, data)
end
function ServiceActivityCmdAutoProxy:RecvUserReturnLoginAwardCmd(data)
  self:Notify(ServiceEvent.ActivityCmdUserReturnLoginAwardCmd, data)
end
function ServiceActivityCmdAutoProxy:RecvUserReturnChatRoomRecordCmd(data)
  self:Notify(ServiceEvent.ActivityCmdUserReturnChatRoomRecordCmd, data)
end
function ServiceActivityCmdAutoProxy:RecvUserReturnRaidAwardCmd(data)
  self:Notify(ServiceEvent.ActivityCmdUserReturnRaidAwardCmd, data)
end
function ServiceActivityCmdAutoProxy:RecvWishActivityInfoCmd(data)
  self:Notify(ServiceEvent.ActivityCmdWishActivityInfoCmd, data)
end
function ServiceActivityCmdAutoProxy:RecvWishActivityWishCmd(data)
  self:Notify(ServiceEvent.ActivityCmdWishActivityWishCmd, data)
end
function ServiceActivityCmdAutoProxy:RecvWishActivityLikeCmd(data)
  self:Notify(ServiceEvent.ActivityCmdWishActivityLikeCmd, data)
end
function ServiceActivityCmdAutoProxy:RecvWishActivityLikeRecordCmd(data)
  self:Notify(ServiceEvent.ActivityCmdWishActivityLikeRecordCmd, data)
end
function ServiceActivityCmdAutoProxy:RecvUserReturnInviteCmd(data)
  self:Notify(ServiceEvent.ActivityCmdUserReturnInviteCmd, data)
end
function ServiceActivityCmdAutoProxy:RecvUserReturnShareAwardCmd(data)
  self:Notify(ServiceEvent.ActivityCmdUserReturnShareAwardCmd, data)
end
function ServiceActivityCmdAutoProxy:RecvUserReturnInviteAwardCmd(data)
  self:Notify(ServiceEvent.ActivityCmdUserReturnInviteAwardCmd, data)
end
function ServiceActivityCmdAutoProxy:RecvUserReturnBindCmd(data)
  self:Notify(ServiceEvent.ActivityCmdUserReturnBindCmd, data)
end
function ServiceActivityCmdAutoProxy:RecvUserReturnInviteRecordCmd(data)
  self:Notify(ServiceEvent.ActivityCmdUserReturnInviteRecordCmd, data)
end
function ServiceActivityCmdAutoProxy:RecvUserReturnInviteActivityNtfCmd(data)
  self:Notify(ServiceEvent.ActivityCmdUserReturnInviteActivityNtfCmd, data)
end
function ServiceActivityCmdAutoProxy:RecvGuildAssembleSyncCmd(data)
  self:Notify(ServiceEvent.ActivityCmdGuildAssembleSyncCmd, data)
end
function ServiceActivityCmdAutoProxy:RecvGuildAssembleAcceptCmd(data)
  self:Notify(ServiceEvent.ActivityCmdGuildAssembleAcceptCmd, data)
end
function ServiceActivityCmdAutoProxy:RecvGuildAssembleAwardCmd(data)
  self:Notify(ServiceEvent.ActivityCmdGuildAssembleAwardCmd, data)
end
function ServiceActivityCmdAutoProxy:RecvDaySigninInfoCmd(data)
  self:Notify(ServiceEvent.ActivityCmdDaySigninInfoCmd, data)
end
function ServiceActivityCmdAutoProxy:RecvDaySigninLoginAwardCmd(data)
  self:Notify(ServiceEvent.ActivityCmdDaySigninLoginAwardCmd, data)
end
function ServiceActivityCmdAutoProxy:RecvDaySigninActivityCmd(data)
  self:Notify(ServiceEvent.ActivityCmdDaySigninActivityCmd, data)
end
function ServiceActivityCmdAutoProxy:RecvBattleFundNofityActCmd(data)
  self:Notify(ServiceEvent.ActivityCmdBattleFundNofityActCmd, data)
end
function ServiceActivityCmdAutoProxy:RecvBattleFundRewardActCmd(data)
  self:Notify(ServiceEvent.ActivityCmdBattleFundRewardActCmd, data)
end
function ServiceActivityCmdAutoProxy:RecvUserInviteCmd(data)
  self:Notify(ServiceEvent.ActivityCmdUserInviteCmd, data)
end
function ServiceActivityCmdAutoProxy:RecvUserInviteAwardCmd(data)
  self:Notify(ServiceEvent.ActivityCmdUserInviteAwardCmd, data)
end
function ServiceActivityCmdAutoProxy:RecvNewPartnerCmd(data)
  self:Notify(ServiceEvent.ActivityCmdNewPartnerCmd, data)
end
function ServiceActivityCmdAutoProxy:RecvNewPartnerBindCmd(data)
  self:Notify(ServiceEvent.ActivityCmdNewPartnerBindCmd, data)
end
ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.ActivityCmdStartActCmd = "ServiceEvent_ActivityCmdStartActCmd"
ServiceEvent.ActivityCmdStopActCmd = "ServiceEvent_ActivityCmdStopActCmd"
ServiceEvent.ActivityCmdBCatUFOPosActCmd = "ServiceEvent_ActivityCmdBCatUFOPosActCmd"
ServiceEvent.ActivityCmdActProgressNtfCmd = "ServiceEvent_ActivityCmdActProgressNtfCmd"
ServiceEvent.ActivityCmdStartGlobalActCmd = "ServiceEvent_ActivityCmdStartGlobalActCmd"
ServiceEvent.ActivityCmdActProgressExceptNtfCmd = "ServiceEvent_ActivityCmdActProgressExceptNtfCmd"
ServiceEvent.ActivityCmdTimeLimitShopPageCmd = "ServiceEvent_ActivityCmdTimeLimitShopPageCmd"
ServiceEvent.ActivityCmdAnimationLoginActCmd = "ServiceEvent_ActivityCmdAnimationLoginActCmd"
ServiceEvent.ActivityCmdGlobalDonationActivityInfoCmd = "ServiceEvent_ActivityCmdGlobalDonationActivityInfoCmd"
ServiceEvent.ActivityCmdGlobalDonationActivityDonateCmd = "ServiceEvent_ActivityCmdGlobalDonationActivityDonateCmd"
ServiceEvent.ActivityCmdGlobalDonationActivityAwardCmd = "ServiceEvent_ActivityCmdGlobalDonationActivityAwardCmd"
ServiceEvent.ActivityCmdUserInviteInfoCmd = "ServiceEvent_ActivityCmdUserInviteInfoCmd"
ServiceEvent.ActivityCmdUserInviteBindUserCmd = "ServiceEvent_ActivityCmdUserInviteBindUserCmd"
ServiceEvent.ActivityCmdUserInviteInviteAwardCmd = "ServiceEvent_ActivityCmdUserInviteInviteAwardCmd"
ServiceEvent.ActivityCmdUserInviteShareAwardCmd = "ServiceEvent_ActivityCmdUserInviteShareAwardCmd"
ServiceEvent.ActivityCmdUserInviteInviteLoginAwardCmd = "ServiceEvent_ActivityCmdUserInviteInviteLoginAwardCmd"
ServiceEvent.ActivityCmdUserInviteRecallLoginAwardCmd = "ServiceEvent_ActivityCmdUserInviteRecallLoginAwardCmd"
ServiceEvent.ActivityCmdUserReturnInfoCmd = "ServiceEvent_ActivityCmdUserReturnInfoCmd"
ServiceEvent.ActivityCmdUserReturnQuestAwardCmd = "ServiceEvent_ActivityCmdUserReturnQuestAwardCmd"
ServiceEvent.ActivityCmdUserReturnQuestAddCmd = "ServiceEvent_ActivityCmdUserReturnQuestAddCmd"
ServiceEvent.ActivityCmdUserReturnEnterChatRoomCmd = "ServiceEvent_ActivityCmdUserReturnEnterChatRoomCmd"
ServiceEvent.ActivityCmdUserReturnLeaveChatRoomCmd = "ServiceEvent_ActivityCmdUserReturnLeaveChatRoomCmd"
ServiceEvent.ActivityCmdUserReturnLoginAwardCmd = "ServiceEvent_ActivityCmdUserReturnLoginAwardCmd"
ServiceEvent.ActivityCmdUserReturnChatRoomRecordCmd = "ServiceEvent_ActivityCmdUserReturnChatRoomRecordCmd"
ServiceEvent.ActivityCmdUserReturnRaidAwardCmd = "ServiceEvent_ActivityCmdUserReturnRaidAwardCmd"
ServiceEvent.ActivityCmdWishActivityInfoCmd = "ServiceEvent_ActivityCmdWishActivityInfoCmd"
ServiceEvent.ActivityCmdWishActivityWishCmd = "ServiceEvent_ActivityCmdWishActivityWishCmd"
ServiceEvent.ActivityCmdWishActivityLikeCmd = "ServiceEvent_ActivityCmdWishActivityLikeCmd"
ServiceEvent.ActivityCmdWishActivityLikeRecordCmd = "ServiceEvent_ActivityCmdWishActivityLikeRecordCmd"
ServiceEvent.ActivityCmdUserReturnInviteCmd = "ServiceEvent_ActivityCmdUserReturnInviteCmd"
ServiceEvent.ActivityCmdUserReturnShareAwardCmd = "ServiceEvent_ActivityCmdUserReturnShareAwardCmd"
ServiceEvent.ActivityCmdUserReturnInviteAwardCmd = "ServiceEvent_ActivityCmdUserReturnInviteAwardCmd"
ServiceEvent.ActivityCmdUserReturnBindCmd = "ServiceEvent_ActivityCmdUserReturnBindCmd"
ServiceEvent.ActivityCmdUserReturnInviteRecordCmd = "ServiceEvent_ActivityCmdUserReturnInviteRecordCmd"
ServiceEvent.ActivityCmdUserReturnInviteActivityNtfCmd = "ServiceEvent_ActivityCmdUserReturnInviteActivityNtfCmd"
ServiceEvent.ActivityCmdGuildAssembleSyncCmd = "ServiceEvent_ActivityCmdGuildAssembleSyncCmd"
ServiceEvent.ActivityCmdGuildAssembleAcceptCmd = "ServiceEvent_ActivityCmdGuildAssembleAcceptCmd"
ServiceEvent.ActivityCmdGuildAssembleAwardCmd = "ServiceEvent_ActivityCmdGuildAssembleAwardCmd"
ServiceEvent.ActivityCmdDaySigninInfoCmd = "ServiceEvent_ActivityCmdDaySigninInfoCmd"
ServiceEvent.ActivityCmdDaySigninLoginAwardCmd = "ServiceEvent_ActivityCmdDaySigninLoginAwardCmd"
ServiceEvent.ActivityCmdDaySigninActivityCmd = "ServiceEvent_ActivityCmdDaySigninActivityCmd"
ServiceEvent.ActivityCmdBattleFundNofityActCmd = "ServiceEvent_ActivityCmdBattleFundNofityActCmd"
ServiceEvent.ActivityCmdBattleFundRewardActCmd = "ServiceEvent_ActivityCmdBattleFundRewardActCmd"
ServiceEvent.ActivityCmdUserInviteCmd = "ServiceEvent_ActivityCmdUserInviteCmd"
ServiceEvent.ActivityCmdUserInviteAwardCmd = "ServiceEvent_ActivityCmdUserInviteAwardCmd"
ServiceEvent.ActivityCmdNewPartnerCmd = "ServiceEvent_ActivityCmdNewPartnerCmd"
ServiceEvent.ActivityCmdNewPartnerBindCmd = "ServiceEvent_ActivityCmdNewPartnerBindCmd"
