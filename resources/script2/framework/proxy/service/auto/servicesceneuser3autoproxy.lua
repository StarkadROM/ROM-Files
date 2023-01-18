ServiceSceneUser3AutoProxy = class("ServiceSceneUser3AutoProxy", ServiceProxy)
ServiceSceneUser3AutoProxy.Instance = nil
ServiceSceneUser3AutoProxy.NAME = "ServiceSceneUser3AutoProxy"
function ServiceSceneUser3AutoProxy:ctor(proxyName)
  if ServiceSceneUser3AutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceSceneUser3AutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceSceneUser3AutoProxy.Instance = self
  end
end
function ServiceSceneUser3AutoProxy:Init()
end
function ServiceSceneUser3AutoProxy:onRegister()
  self:Listen(82, 1, function(data)
    self:RecvFirstDepositInfo(data)
  end)
  self:Listen(82, 2, function(data)
    self:RecvFirstDepositReward(data)
  end)
  self:Listen(82, 3, function(data)
    self:RecvClientPayLog(data)
  end)
  self:Listen(82, 4, function(data)
    self:RecvDailyDepositInfo(data)
  end)
  self:Listen(82, 5, function(data)
    self:RecvDailyDepositGetReward(data)
  end)
  self:Listen(82, 6, function(data)
    self:RecvBattleTimeCostSelectCmd(data)
  end)
  self:Listen(82, 9, function(data)
    self:RecvPlugInNotify(data)
  end)
  self:Listen(82, 10, function(data)
    self:RecvPlugInUpload(data)
  end)
  self:Listen(82, 15, function(data)
    self:RecvHeroStoryQusetInfo(data)
  end)
  self:Listen(82, 16, function(data)
    self:RecvHeroStoryQuestAccept(data)
  end)
  self:Listen(82, 14, function(data)
    self:RecvHeroStoryQuestReward(data)
  end)
  self:Listen(82, 13, function(data)
    self:RecvHeroGrowthQuestInfo(data)
  end)
  self:Listen(82, 8, function(data)
    self:RecvQueryProfessionRecordSimpleData(data)
  end)
  self:Listen(82, 11, function(data)
    self:RecvHeroBuyUserCmd(data)
  end)
  self:Listen(82, 12, function(data)
    self:RecvHeroShowUserCmd(data)
  end)
  self:Listen(82, 17, function(data)
    self:RecvAccumDepositInfo(data)
  end)
  self:Listen(82, 18, function(data)
    self:RecvAccumDepositReward(data)
  end)
  self:Listen(82, 19, function(data)
    self:RecvBoliGoldGetReward(data)
  end)
  self:Listen(82, 20, function(data)
    self:RecvBoliGoldInfo(data)
  end)
  self:Listen(82, 21, function(data)
    self:RecvBoliGoldGetFreeReward(data)
  end)
  self:Listen(82, 22, function(data)
    self:RecvResourceCheckUserCmd(data)
  end)
end
function ServiceSceneUser3AutoProxy:CallFirstDepositInfo(end_time, got_gear, accumlated_deposit, first_deposit_rewarded, version)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.FirstDepositInfo()
    if end_time ~= nil then
      msg.end_time = end_time
    end
    if got_gear ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.got_gear == nil then
        msg.got_gear = {}
      end
      for i = 1, #got_gear do
        table.insert(msg.got_gear, got_gear[i])
      end
    end
    if accumlated_deposit ~= nil then
      msg.accumlated_deposit = accumlated_deposit
    end
    if first_deposit_rewarded ~= nil then
      msg.first_deposit_rewarded = first_deposit_rewarded
    end
    if version ~= nil then
      msg.version = version
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.FirstDepositInfo.id
    local msgParam = {}
    if end_time ~= nil then
      msgParam.end_time = end_time
    end
    if got_gear ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.got_gear == nil then
        msgParam.got_gear = {}
      end
      for i = 1, #got_gear do
        table.insert(msgParam.got_gear, got_gear[i])
      end
    end
    if accumlated_deposit ~= nil then
      msgParam.accumlated_deposit = accumlated_deposit
    end
    if first_deposit_rewarded ~= nil then
      msgParam.first_deposit_rewarded = first_deposit_rewarded
    end
    if version ~= nil then
      msgParam.version = version
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceSceneUser3AutoProxy:CallFirstDepositReward(first_deposit_reward, gear)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.FirstDepositReward()
    if first_deposit_reward ~= nil then
      msg.first_deposit_reward = first_deposit_reward
    end
    if gear ~= nil then
      msg.gear = gear
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.FirstDepositReward.id
    local msgParam = {}
    if first_deposit_reward ~= nil then
      msgParam.first_deposit_reward = first_deposit_reward
    end
    if gear ~= nil then
      msgParam.gear = gear
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceSceneUser3AutoProxy:CallClientPayLog(event_id, event_param)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.ClientPayLog()
    if event_id ~= nil then
      msg.event_id = event_id
    end
    if event_param ~= nil then
      msg.event_param = event_param
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ClientPayLog.id
    local msgParam = {}
    if event_id ~= nil then
      msgParam.event_id = event_id
    end
    if event_param ~= nil then
      msgParam.event_param = event_param
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceSceneUser3AutoProxy:CallDailyDepositInfo(version, deposit_gold, start_time, end_time, gotten_rewards)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.DailyDepositInfo()
    if version ~= nil then
      msg.version = version
    end
    if deposit_gold ~= nil then
      msg.deposit_gold = deposit_gold
    end
    if start_time ~= nil then
      msg.start_time = start_time
    end
    if end_time ~= nil then
      msg.end_time = end_time
    end
    if gotten_rewards ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.gotten_rewards == nil then
        msg.gotten_rewards = {}
      end
      for i = 1, #gotten_rewards do
        table.insert(msg.gotten_rewards, gotten_rewards[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DailyDepositInfo.id
    local msgParam = {}
    if version ~= nil then
      msgParam.version = version
    end
    if deposit_gold ~= nil then
      msgParam.deposit_gold = deposit_gold
    end
    if start_time ~= nil then
      msgParam.start_time = start_time
    end
    if end_time ~= nil then
      msgParam.end_time = end_time
    end
    if gotten_rewards ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.gotten_rewards == nil then
        msgParam.gotten_rewards = {}
      end
      for i = 1, #gotten_rewards do
        table.insert(msgParam.gotten_rewards, gotten_rewards[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceSceneUser3AutoProxy:CallDailyDepositGetReward(reward_index, version)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.DailyDepositGetReward()
    if reward_index ~= nil then
      msg.reward_index = reward_index
    end
    if version ~= nil then
      msg.version = version
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DailyDepositGetReward.id
    local msgParam = {}
    if reward_index ~= nil then
      msgParam.reward_index = reward_index
    end
    if version ~= nil then
      msgParam.version = version
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceSceneUser3AutoProxy:CallBattleTimeCostSelectCmd(ecost)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.BattleTimeCostSelectCmd()
    if ecost ~= nil then
      msg.ecost = ecost
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BattleTimeCostSelectCmd.id
    local msgParam = {}
    if ecost ~= nil then
      msgParam.ecost = ecost
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceSceneUser3AutoProxy:CallPlugInNotify(infos, detectinterval)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.PlugInNotify()
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
    if detectinterval ~= nil then
      msg.detectinterval = detectinterval
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PlugInNotify.id
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
    if detectinterval ~= nil then
      msgParam.detectinterval = detectinterval
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceSceneUser3AutoProxy:CallPlugInUpload(infos, flag)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.PlugInUpload()
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
    if flag ~= nil then
      msg.flag = flag
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PlugInUpload.id
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
    if flag ~= nil then
      msgParam.flag = flag
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceSceneUser3AutoProxy:CallHeroStoryQusetInfo(profession, story_quests)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.HeroStoryQusetInfo()
    if profession ~= nil then
      msg.profession = profession
    end
    if story_quests ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.story_quests == nil then
        msg.story_quests = {}
      end
      for i = 1, #story_quests do
        table.insert(msg.story_quests, story_quests[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.HeroStoryQusetInfo.id
    local msgParam = {}
    if profession ~= nil then
      msgParam.profession = profession
    end
    if story_quests ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.story_quests == nil then
        msgParam.story_quests = {}
      end
      for i = 1, #story_quests do
        table.insert(msgParam.story_quests, story_quests[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceSceneUser3AutoProxy:CallHeroStoryQuestAccept(id, success)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.HeroStoryQuestAccept()
    if id ~= nil then
      msg.id = id
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.HeroStoryQuestAccept.id
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
function ServiceSceneUser3AutoProxy:CallHeroStoryQuestReward(id, success)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.HeroStoryQuestReward()
    if id ~= nil then
      msg.id = id
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.HeroStoryQuestReward.id
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
function ServiceSceneUser3AutoProxy:CallHeroGrowthQuestInfo(profession, growth_quests)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.HeroGrowthQuestInfo()
    if profession ~= nil then
      msg.profession = profession
    end
    if growth_quests ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.growth_quests == nil then
        msg.growth_quests = {}
      end
      for i = 1, #growth_quests do
        table.insert(msg.growth_quests, growth_quests[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.HeroGrowthQuestInfo.id
    local msgParam = {}
    if profession ~= nil then
      msgParam.profession = profession
    end
    if growth_quests ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.growth_quests == nil then
        msgParam.growth_quests = {}
      end
      for i = 1, #growth_quests do
        table.insert(msgParam.growth_quests, growth_quests[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceSceneUser3AutoProxy:CallQueryProfessionRecordSimpleData(records)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.QueryProfessionRecordSimpleData()
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
    local msgId = ProtoReqInfoList.QueryProfessionRecordSimpleData.id
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
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceSceneUser3AutoProxy:CallHeroBuyUserCmd(branch, success)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.HeroBuyUserCmd()
    if branch ~= nil then
      msg.branch = branch
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.HeroBuyUserCmd.id
    local msgParam = {}
    if branch ~= nil then
      msgParam.branch = branch
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceSceneUser3AutoProxy:CallHeroShowUserCmd(infos)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.HeroShowUserCmd()
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
    local msgId = ProtoReqInfoList.HeroShowUserCmd.id
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
function ServiceSceneUser3AutoProxy:CallAccumDepositInfo(cur_act, accumlated_deposit, gotten_rewards, end_time)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.AccumDepositInfo()
    if cur_act ~= nil then
      msg.cur_act = cur_act
    end
    if accumlated_deposit ~= nil then
      msg.accumlated_deposit = accumlated_deposit
    end
    if gotten_rewards ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.gotten_rewards == nil then
        msg.gotten_rewards = {}
      end
      for i = 1, #gotten_rewards do
        table.insert(msg.gotten_rewards, gotten_rewards[i])
      end
    end
    if end_time ~= nil then
      msg.end_time = end_time
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AccumDepositInfo.id
    local msgParam = {}
    if cur_act ~= nil then
      msgParam.cur_act = cur_act
    end
    if accumlated_deposit ~= nil then
      msgParam.accumlated_deposit = accumlated_deposit
    end
    if gotten_rewards ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.gotten_rewards == nil then
        msgParam.gotten_rewards = {}
      end
      for i = 1, #gotten_rewards do
        table.insert(msgParam.gotten_rewards, gotten_rewards[i])
      end
    end
    if end_time ~= nil then
      msgParam.end_time = end_time
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceSceneUser3AutoProxy:CallAccumDepositReward(get_reward)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.AccumDepositReward()
    if get_reward ~= nil then
      msg.get_reward = get_reward
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AccumDepositReward.id
    local msgParam = {}
    if get_reward ~= nil then
      msgParam.get_reward = get_reward
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceSceneUser3AutoProxy:CallBoliGoldGetReward(select, reward, rest_key)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.BoliGoldGetReward()
    if select ~= nil then
      msg.select = select
    end
    if reward ~= nil then
      msg.reward = reward
    end
    if rest_key ~= nil then
      msg.rest_key = rest_key
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BoliGoldGetReward.id
    local msgParam = {}
    if select ~= nil then
      msgParam.select = select
    end
    if reward ~= nil then
      msgParam.reward = reward
    end
    if rest_key ~= nil then
      msgParam.rest_key = rest_key
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceSceneUser3AutoProxy:CallBoliGoldInfo(act_id, deposit_gold, selected, gotten_rewards, rest_key, free_reward_gotten)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.BoliGoldInfo()
    if act_id ~= nil then
      msg.act_id = act_id
    end
    if deposit_gold ~= nil then
      msg.deposit_gold = deposit_gold
    end
    if selected ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.selected == nil then
        msg.selected = {}
      end
      for i = 1, #selected do
        table.insert(msg.selected, selected[i])
      end
    end
    if gotten_rewards ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.gotten_rewards == nil then
        msg.gotten_rewards = {}
      end
      for i = 1, #gotten_rewards do
        table.insert(msg.gotten_rewards, gotten_rewards[i])
      end
    end
    if rest_key ~= nil then
      msg.rest_key = rest_key
    end
    if free_reward_gotten ~= nil then
      msg.free_reward_gotten = free_reward_gotten
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BoliGoldInfo.id
    local msgParam = {}
    if act_id ~= nil then
      msgParam.act_id = act_id
    end
    if deposit_gold ~= nil then
      msgParam.deposit_gold = deposit_gold
    end
    if selected ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.selected == nil then
        msgParam.selected = {}
      end
      for i = 1, #selected do
        table.insert(msgParam.selected, selected[i])
      end
    end
    if gotten_rewards ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.gotten_rewards == nil then
        msgParam.gotten_rewards = {}
      end
      for i = 1, #gotten_rewards do
        table.insert(msgParam.gotten_rewards, gotten_rewards[i])
      end
    end
    if rest_key ~= nil then
      msgParam.rest_key = rest_key
    end
    if free_reward_gotten ~= nil then
      msgParam.free_reward_gotten = free_reward_gotten
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceSceneUser3AutoProxy:CallBoliGoldGetFreeReward()
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.BoliGoldGetFreeReward()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BoliGoldGetFreeReward.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceSceneUser3AutoProxy:CallResourceCheckUserCmd(resources)
  if not NetConfig.PBC then
    local msg = SceneUser3_pb.ResourceCheckUserCmd()
    if resources ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.resources == nil then
        msg.resources = {}
      end
      for i = 1, #resources do
        table.insert(msg.resources, resources[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ResourceCheckUserCmd.id
    local msgParam = {}
    if resources ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.resources == nil then
        msgParam.resources = {}
      end
      for i = 1, #resources do
        table.insert(msgParam.resources, resources[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end
function ServiceSceneUser3AutoProxy:RecvFirstDepositInfo(data)
  self:Notify(ServiceEvent.SceneUser3FirstDepositInfo, data)
end
function ServiceSceneUser3AutoProxy:RecvFirstDepositReward(data)
  self:Notify(ServiceEvent.SceneUser3FirstDepositReward, data)
end
function ServiceSceneUser3AutoProxy:RecvClientPayLog(data)
  self:Notify(ServiceEvent.SceneUser3ClientPayLog, data)
end
function ServiceSceneUser3AutoProxy:RecvDailyDepositInfo(data)
  self:Notify(ServiceEvent.SceneUser3DailyDepositInfo, data)
end
function ServiceSceneUser3AutoProxy:RecvDailyDepositGetReward(data)
  self:Notify(ServiceEvent.SceneUser3DailyDepositGetReward, data)
end
function ServiceSceneUser3AutoProxy:RecvBattleTimeCostSelectCmd(data)
  self:Notify(ServiceEvent.SceneUser3BattleTimeCostSelectCmd, data)
end
function ServiceSceneUser3AutoProxy:RecvPlugInNotify(data)
  self:Notify(ServiceEvent.SceneUser3PlugInNotify, data)
end
function ServiceSceneUser3AutoProxy:RecvPlugInUpload(data)
  self:Notify(ServiceEvent.SceneUser3PlugInUpload, data)
end
function ServiceSceneUser3AutoProxy:RecvHeroStoryQusetInfo(data)
  self:Notify(ServiceEvent.SceneUser3HeroStoryQusetInfo, data)
end
function ServiceSceneUser3AutoProxy:RecvHeroStoryQuestAccept(data)
  self:Notify(ServiceEvent.SceneUser3HeroStoryQuestAccept, data)
end
function ServiceSceneUser3AutoProxy:RecvHeroStoryQuestReward(data)
  self:Notify(ServiceEvent.SceneUser3HeroStoryQuestReward, data)
end
function ServiceSceneUser3AutoProxy:RecvHeroGrowthQuestInfo(data)
  self:Notify(ServiceEvent.SceneUser3HeroGrowthQuestInfo, data)
end
function ServiceSceneUser3AutoProxy:RecvQueryProfessionRecordSimpleData(data)
  self:Notify(ServiceEvent.SceneUser3QueryProfessionRecordSimpleData, data)
end
function ServiceSceneUser3AutoProxy:RecvHeroBuyUserCmd(data)
  self:Notify(ServiceEvent.SceneUser3HeroBuyUserCmd, data)
end
function ServiceSceneUser3AutoProxy:RecvHeroShowUserCmd(data)
  self:Notify(ServiceEvent.SceneUser3HeroShowUserCmd, data)
end
function ServiceSceneUser3AutoProxy:RecvAccumDepositInfo(data)
  self:Notify(ServiceEvent.SceneUser3AccumDepositInfo, data)
end
function ServiceSceneUser3AutoProxy:RecvAccumDepositReward(data)
  self:Notify(ServiceEvent.SceneUser3AccumDepositReward, data)
end
function ServiceSceneUser3AutoProxy:RecvBoliGoldGetReward(data)
  self:Notify(ServiceEvent.SceneUser3BoliGoldGetReward, data)
end
function ServiceSceneUser3AutoProxy:RecvBoliGoldInfo(data)
  self:Notify(ServiceEvent.SceneUser3BoliGoldInfo, data)
end
function ServiceSceneUser3AutoProxy:RecvBoliGoldGetFreeReward(data)
  self:Notify(ServiceEvent.SceneUser3BoliGoldGetFreeReward, data)
end
function ServiceSceneUser3AutoProxy:RecvResourceCheckUserCmd(data)
  self:Notify(ServiceEvent.SceneUser3ResourceCheckUserCmd, data)
end
ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.SceneUser3FirstDepositInfo = "ServiceEvent_SceneUser3FirstDepositInfo"
ServiceEvent.SceneUser3FirstDepositReward = "ServiceEvent_SceneUser3FirstDepositReward"
ServiceEvent.SceneUser3ClientPayLog = "ServiceEvent_SceneUser3ClientPayLog"
ServiceEvent.SceneUser3DailyDepositInfo = "ServiceEvent_SceneUser3DailyDepositInfo"
ServiceEvent.SceneUser3DailyDepositGetReward = "ServiceEvent_SceneUser3DailyDepositGetReward"
ServiceEvent.SceneUser3BattleTimeCostSelectCmd = "ServiceEvent_SceneUser3BattleTimeCostSelectCmd"
ServiceEvent.SceneUser3PlugInNotify = "ServiceEvent_SceneUser3PlugInNotify"
ServiceEvent.SceneUser3PlugInUpload = "ServiceEvent_SceneUser3PlugInUpload"
ServiceEvent.SceneUser3HeroStoryQusetInfo = "ServiceEvent_SceneUser3HeroStoryQusetInfo"
ServiceEvent.SceneUser3HeroStoryQuestAccept = "ServiceEvent_SceneUser3HeroStoryQuestAccept"
ServiceEvent.SceneUser3HeroStoryQuestReward = "ServiceEvent_SceneUser3HeroStoryQuestReward"
ServiceEvent.SceneUser3HeroGrowthQuestInfo = "ServiceEvent_SceneUser3HeroGrowthQuestInfo"
ServiceEvent.SceneUser3QueryProfessionRecordSimpleData = "ServiceEvent_SceneUser3QueryProfessionRecordSimpleData"
ServiceEvent.SceneUser3HeroBuyUserCmd = "ServiceEvent_SceneUser3HeroBuyUserCmd"
ServiceEvent.SceneUser3HeroShowUserCmd = "ServiceEvent_SceneUser3HeroShowUserCmd"
ServiceEvent.SceneUser3AccumDepositInfo = "ServiceEvent_SceneUser3AccumDepositInfo"
ServiceEvent.SceneUser3AccumDepositReward = "ServiceEvent_SceneUser3AccumDepositReward"
ServiceEvent.SceneUser3BoliGoldGetReward = "ServiceEvent_SceneUser3BoliGoldGetReward"
ServiceEvent.SceneUser3BoliGoldInfo = "ServiceEvent_SceneUser3BoliGoldInfo"
ServiceEvent.SceneUser3BoliGoldGetFreeReward = "ServiceEvent_SceneUser3BoliGoldGetFreeReward"
ServiceEvent.SceneUser3ResourceCheckUserCmd = "ServiceEvent_SceneUser3ResourceCheckUserCmd"
