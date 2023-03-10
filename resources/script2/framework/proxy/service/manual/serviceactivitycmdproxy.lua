autoImport("ServiceActivityCmdAutoProxy")
ServiceActivityCmdProxy = class("ServiceActivityCmdProxy", ServiceActivityCmdAutoProxy)
ServiceActivityCmdProxy.Instance = nil
ServiceActivityCmdProxy.NAME = "ServiceActivityCmdProxy"
function ServiceActivityCmdProxy:ctor(proxyName)
  if ServiceActivityCmdProxy.Instance == nil then
    self.proxyName = proxyName or ServiceActivityCmdProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceActivityCmdProxy.Instance = self
  end
end
function ServiceActivityCmdProxy:RecvBCatUFOPosActCmd(data)
  self:Notify(ServiceEvent.ActivityCmdBCatUFOPosActCmd, data)
end
function ServiceActivityCmdProxy:RecvStartActCmd(data)
  local items = data.items
  if items and #items > 0 then
    local item
    for i = 1, #items do
      item = items[i]
      if item then
        FunctionActivity.Me():Launch(item.id, item.mapid, item.starttime, item.endtime, item.path, item.unshowmap)
      end
    end
  end
  self:Notify(ServiceEvent.ActivityCmdStartActCmd, data)
end
function ServiceActivityCmdProxy:RecvStopActCmd(data)
  FunctionActivity.Me():ShutDownActivity(data.id)
  self:Notify(ServiceEvent.ActivityCmdStopActCmd, data)
end
function ServiceActivityCmdProxy:RecvActProgressNtfCmd(data)
  local items = data.items
  if items and #items > 0 then
    local item
    for i = 1, #items do
      item = items[i]
      if item then
        FunctionActivity.Me():UpdateState(item.id, item.progress, item.starttime, item.endtime)
      end
    end
  end
  self:Notify(ServiceEvent.ActivityCmdActProgressNtfCmd, data)
end
function ServiceActivityCmdProxy:RecvActProgressExceptNtfCmd(data)
  FunctionActivity.Me():UpdateActExceptData(data)
  self:Notify(ServiceEvent.ActivityCmdActNtfProgressExceptCmd, data)
end
function ServiceActivityCmdProxy:RecvStartGlobalActCmd(data)
  BlackSmithProxy.Instance:SetEquipOptDiscounts(data.type, data.open and data.params)
  FriendProxy.Instance:SetRecallActivity(data)
  if data.open then
    if data.type == ActivityCmd_pb.GACTIVITY_CHARGE_DISCOUNT then
      NewRechargeProxy.Ins:Deposit_SetProductActivity_Discount(data.open, data)
    elseif data.type == ActivityCmd_pb.GACTIVITY_CHARGE_EXTRA_REWARD then
      NewRechargeProxy.Ins:Deposit_SetProductActivity_GainMore(data.open, data)
    elseif data.type == ActivityCmd_pb.GACTIVITY_CHARGE_EXTRA_COUNT then
      NewRechargeProxy.Ins:Deposit_SetProductActivity_MoreTimes(data.open, data)
    elseif data.type == ActivityCmd_pb.GACTIVITY_WEDDING_SERVICE then
      if data.params then
        local j = 1
        for i = 1, #data.params / 2 do
          WeddingProxy.Instance:AddDiscount(data.params[j], data.params[j + 1])
          j = j + 2
        end
      end
    elseif data.type == ActivityCmd_pb.GACTIVITY_COUNT_DOWN then
      FunctionActivity.Me():AddCountDownAct(data.id, data.params[1], data.params[2], data.params[3], data.params[4])
    elseif data.type == ActivityCmd_pb.GACTIVITY_IMAGE_RAID then
      MoroccTimeProxy.Instance:AddMoroccSealData(data.id, data.params[1], data.params[2], data.params[4])
    elseif data.type == ActivityCmd_pb.GACTIVITY_HITPOLLY then
      FunctionActivity.Me():Launch(data.type, nil, data.starttime, data.endtime)
      ServiceActHitPollyProxy.Instance:CallActityHitPollySync()
    elseif data.type == ActivityCmd_pb.GACTIVITY_WORLD_LABEL then
      local activityType = data.params[1]
      local startTime = data.starttime
      local endTime = data.endtime
      FunctionActivity.Me():Launch(activityType, nil, startTime, endTime)
    elseif data.type == ActivityCmd_pb.GACTIVITY_RIDE_LOTTERY then
      MountLotteryProxy.Instance:SetMountActivity(data)
      GameFacade.Instance:sendNotification(MountLotteryEvent.ActivityOpen)
    elseif data.type == ActivityCmd_pb.GACTIVITY_EASTROLOGYTYPE_CONSTELLATION then
      local startTime = data.starttime
      local endTime = data.endtime
      local params = data.params
      FunctionActivity.Me():Launch(data.type, nil, startTime, endTime)
      FunctionActivity.Me():SetParams(data.type, params)
    elseif data.type == ActivityCmd_pb.GACTIVITY_EASTROLOGYTYPE_ACTIVITY then
      local startTime = data.starttime
      local endTime = data.endtime
      local params = data.params
      FunctionActivity.Me():Launch(data.type, nil, startTime, endTime)
      FunctionActivity.Me():SetParams(data.type, params)
    elseif data.type == ActivityCmd_pb.GACTIVITY_TEAM_GROUP then
      ActivityEventProxy.Instance:SetGroupRaidRewardActivityState(true)
    elseif data.type == ActivityCmd_pb.GACTIVITY_RECALL_PRIVILEGE then
      local startTime = data.starttime
      local endTime = data.endtime
      local params = data.params
      FunctionActivity.Me():Launch(data.type, nil, startTime, endTime)
      FunctionActivity.Me():SetParams(data.type, params)
    elseif data.type == ActivityCmd_pb.GACTIVITY_PAY_SIGN then
      PaySignProxy.Instance:SetGlobalAct(data)
    elseif data.type == ActivityCmd_pb.GACTIVITY_FESTIVAL_SIGNIN then
      RememberLoginProxy.Instance:SetActivityState(data)
    elseif data.type == ActivityCmd_pb.GACTIVITY_EXTRACT_DISCOUNT then
      AttrExtractionProxy.Instance:SetDiscount(data.params)
    elseif data.type == ActivityCmd_pb.GACTIVITY_PUZZLE or data.type == ActivityCmd_pb.GACTIVITY_PUZZLE_2 or data.type == ActivityCmd_pb.GACTIVITY_PUZZLE_3 or data.type == ActivityCmd_pb.GACTIVITY_PUZZLE_4 then
      local startTime = data.starttime
      local endTime = data.endtime
      local params = data.params
      FunctionActivity.Me():Launch(data.type, nil, startTime, endTime)
      FunctionActivity.Me():SetParams(data.type, params)
      ActivityPuzzleProxy.Instance:RecvActivityPuzzleList(params, startTime, endTime)
      GameFacade.Instance:sendNotification(ActivityPuzzleEvent.ActivityOpen)
    elseif data.type == ActivityCmd_pb.GACTIVITY_GROUPON then
      redlog("ActivityCmd_pb.GACTIVITY_GROUPON")
      GrouponProxy.Instance:SetGlobalAct(data)
    elseif data.type == ActivityCmd_pb.GACTIVITY_HEIMDALLR_EYE then
      BifrostProxy.Instance:InitStatic()
    elseif data.type == ActivityCmd_pb.GACTIVITY_BIFROST then
      FunctionActivity.Me():Launch(data.type, nil, data.starttime, data.endtime)
    elseif data.type == ActivityCmd_pb.GACTIVITY_NOVICE_NOTEBOOK then
      JournalProxy.Instance:UpdateJournalId(data.id)
    elseif data.type == ActivityCmd_pb.GACTIVITY_TIMELIMIT_SHOP then
      FunctionActivity.Me():Launch(data.type, nil, data.starttime, data.endtime)
      SupplyDepotProxy.Instance:UpdateActData(data)
    elseif data.type == ActivityCmd_pb.GACTIVITY_MINIRO then
      local activityID = data.id
      local startTime = data.starttime
      local endTime = data.endtime
      local activityData = {
        [1] = activityID,
        [2] = startTime,
        [3] = endTime
      }
      MiniROProxy.Instance:SetActivityData(activityData)
      FunctionActivity.Me():Launch(data.type, nil, data.starttime, data.endtime)
    elseif data.type == ActivityCmd_pb.GACTIVITY_DISNEY_CHALLENGE_TASK then
      DisneyProxy.Instance:SetGlobalAct(data)
    elseif data.type == ActivityCmd_pb.GACTIVITY_DONATE then
      DonateProxy.Instance:AddActivity(data.type, data.id, data.starttime, data.endtime)
    elseif data.type == ActivityCmd_pb.GACTIVITY_TOWER_DAILY_RESET then
      FunctionActivity.Me():Launch(data.type, nil, data.starttime, data.endtime)
    elseif data.type == ActivityCmd_pb.GACTIVITY_DISNEY_GUIDE then
      DisneyStageProxy.Instance:LaunchGlobalActivity(data.id)
      FunctionActivity.Me():Launch(data.type, nil, data.starttime, data.endtime)
    elseif data.type == ActivityCmd_pb.GACTIVITY_FAVORITE then
      MidSummerActProxy.Instance:AddActivity(data.id, data.starttime, data.endtime)
    elseif data.type == ActivityCmd_pb.GACTIVITY_DISNEY_MUSIC then
      DisneyStageProxy.Instance:LaunchDisneyMusicTeam(data.id)
      FunctionActivity.Me():Launch(data.type, nil, data.starttime, data.endtime)
    elseif data.type == ActivityCmd_pb.GACTIVITY_GLOBAL_DONATE then
      CrowdfundingActProxy.Instance:AddActivity(data.id, data.starttime, data.endtime, data.params)
    elseif data.type == ActivityCmd_pb.GACTIVITY_USER_INVITE then
      FunctionActivity.Me():Launch(data.type, nil, data.starttime, data.endtime)
      PlayerRefluxProxy.Instance:AddActivity(data)
    elseif data.type == ActivityCmd_pb.GACTIVITY_DAY_SIGNIN then
      FunctionActivity.Me():Launch(data.type, nil, data.starttime, data.endtime)
      DailyLoginProxy.Instance:StartAct(data)
    elseif data.type == ActivityCmd_pb.GACTIVITY_WISH then
      FunctionActivity.Me():Launch(data.type, nil, data.starttime, data.endtime)
    elseif data.type == ActivityCmd_pb.GACTIVITY_HEADWEARACTIVITYSCENE then
      FunctionActivity.Me():Launch(data.type, nil, data.starttime, data.endtime)
    elseif data.type == ActivityCmd_pb.GACTIVITY_USERRETURN_INVITE then
      FunctionActivity.Me():Launch(data.type, nil, data.starttime, data.endtime)
    elseif data.type == ActivityCmd_pb.GACTIVITY_RECOMMEND then
      ReturnActivityProxy.Instance:RecommendActData(data)
      FunctionActivity.Me():Launch(data.type, nil, data.starttime, data.endtime)
    elseif data.type == ActivityCmd_pb.GACTIVITY_NEWPARTNER then
      NewPartnerActProxy.Instance:NewPartnerData(data)
      FunctionActivity.Me():Launch(data.type, nil, data.starttime, data.endtime)
    elseif data.type == ActivityCmd_pb.GACTIVITY_LOTTERY_DAILY_REWARD then
      LotteryProxy.Instance:AddDailyReward(data.id, data.endtime)
      FunctionActivity.Me():Launch(data.type, nil, data.starttime, data.endtime)
    elseif data.type == ActivityCmd_pb.GACTIVITY_AFRICANPORING then
      AfricanPoringProxy.Instance:Init(data)
      FunctionActivity.Me():Launch(data.type, nil, data.starttime, data.endtime)
    end
  elseif data.type == ActivityCmd_pb.GACTIVITY_CHARGE_DISCOUNT then
    NewRechargeProxy.Ins:Deposit_SetProductActivity_Discount(data.open, data)
  elseif data.type == ActivityCmd_pb.GACTIVITY_CHARGE_EXTRA_REWARD then
    NewRechargeProxy.Ins:Deposit_SetProductActivity_GainMore(data.open, data)
  elseif data.type == ActivityCmd_pb.GACTIVITY_CHARGE_EXTRA_COUNT then
    NewRechargeProxy.Ins:Deposit_SetProductActivity_MoreTimes(data.open, data)
  elseif data.type == ActivityCmd_pb.GACTIVITY_WEDDING_SERVICE then
    WeddingProxy.Instance:ClearDiscount(data.params[1])
  elseif data.type == ActivityCmd_pb.GACTIVITY_IMAGE_RAID then
    MoroccTimeProxy.Instance:RemoveMoroccSealData(data.id)
  elseif data.type == ActivityCmd_pb.GACTIVITY_WORLD_LABEL then
    FunctionActivity.Me():ShutDownActivity(data.params[1])
  elseif data.type == ActivityCmd_pb.GACTIVITY_TEAM_GROUP then
    ActivityEventProxy.Instance:SetGroupRaidRewardActivityState(false)
  elseif data.type == ActivityCmd_pb.GACTIVITY_RIDE_LOTTERY then
    MountLotteryProxy.Instance:SetMountActivity(data)
    GameFacade.Instance:sendNotification(MountLotteryEvent.ActivityClose)
  elseif data.type == ActivityCmd_pb.GACTIVITY_RECALL_PRIVILEGE then
    local activityType = data.params[1]
    FunctionActivity.Me():ShutDownActivity(activityType)
  elseif data.type == ActivityCmd_pb.GACTIVITY_HITPOLLY then
    FunctionActivity.Me():ShutDownActivity(data.type)
  elseif data.type == ActivityCmd_pb.GACTIVITY_PAY_SIGN then
    PaySignProxy.Instance:SetGlobalAct(data)
  elseif data.type == ActivityCmd_pb.GACTIVITY_FESTIVAL_SIGNIN then
    RememberLoginProxy.Instance:SetActivityState(data)
  elseif data.type == ActivityCmd_pb.GACTIVITY_PUZZLE or data.type == ActivityCmd_pb.GACTIVITY_PUZZLE_2 or data.type == ActivityCmd_pb.GACTIVITY_PUZZLE_3 or data.type == ActivityCmd_pb.GACTIVITY_PUZZLE_4 then
    FunctionActivity.Me():ShutDownActivity(data.type)
    ActivityPuzzleProxy.Instance:ClearActivityPuzzleList(data.params)
    GameFacade.Instance:sendNotification(ActivityPuzzleEvent.ActivityClose)
  elseif data.type == ActivityCmd_pb.GACTIVITY_EXTRACT_DISCOUNT then
    AttrExtractionProxy.Instance:ResetDiscount()
  elseif data.type == ActivityCmd_pb.GACTIVITY_GROUPON then
    GrouponProxy.Instance:SetGlobalAct(data)
  elseif data.type == ActivityCmd_pb.GACTIVITY_HEIMDALLR_EYE then
    BifrostProxy.Instance:ShutDownBrokenCrystal()
  elseif data.type == ActivityCmd_pb.GACTIVITY_BIFROST then
    FunctionActivity.Me():ShutDownActivity(data.type)
  elseif data.type == ActivityCmd_pb.GACTIVITY_NOVICE_NOTEBOOK then
    JournalProxy.Instance:UpdateJournalId(nil)
  elseif data.type == ActivityCmd_pb.GACTIVITY_TIMELIMIT_SHOP then
    FunctionActivity.Me():ShutDownActivity(data.type)
  elseif data.type == ActivityCmd_pb.GACTIVITY_MINIRO then
    ServiceSceneTipProxy.Instance:CallBrowseRedTipCmd(SceneTip_pb.EREDSYS_MINIRO_DICE)
    MiniROProxy.Instance:SetActivityData(nil)
    FunctionActivity.Me():ShutDownActivity(data.type)
  elseif data.type == ActivityCmd_pb.GACTIVITY_DONATE then
    DonateProxy.Instance:RemoveActivity(data.id)
  elseif data.type == ActivityCmd_pb.GACTIVITY_TOWER_DAILY_RESET then
    FunctionActivity.Me():ShutDownActivity(data.type)
  elseif data.type == ActivityCmd_pb.GACTIVITY_DISNEY_GUIDE then
    DisneyStageProxy.Instance:ShutDownGlobalActivity(data.id)
    FunctionActivity.Me():ShutDownActivity(data.type)
  elseif data.type == ActivityCmd_pb.GACTIVITY_FAVORITE then
    MidSummerActProxy.Instance:RemoveActivity(data.id)
  elseif data.type == ActivityCmd_pb.GACTIVITY_DISNEY_MUSIC then
    DisneyStageProxy.Instance:ShutDownDisneyMusicTeamActivity()
  elseif data.type == ActivityCmd_pb.GACTIVITY_FAVORITE then
    CrowdfundingActProxy.Instance:RemoveActivity(data.id)
  elseif data.type == ActivityCmd_pb.GACTIVITY_USER_INVITE then
    FunctionActivity.Me():ShutDownActivity(data.type)
  elseif data.type == ActivityCmd_pb.GACTIVITY_HEADWEARACTIVITYSCENE then
    FunctionActivity.Me():ShutDownActivity(data.type)
  elseif data.type == ActivityCmd_pb.GACTIVITY_USERRETURN_INVITE then
    FunctionActivity.Me():ShutDownActivity(data.type)
  elseif data.type == ActivityCmd_pb.GACTIVITY_RECOMMEND then
    FunctionActivity.Me():ShutDownActivity(data.type)
  elseif data.type == ActivityCmd_pb.GACTIVITY_NEWPARTNER then
    FunctionActivity.Me():ShutDownActivity(data.type)
  elseif data.type == ActivityCmd_pb.GACTIVITY_LOTTERY_DAILY_REWARD then
    LotteryProxy.Instance:RemoveDailyReward(data.id)
    FunctionActivity.Me():ShutDownActivity(data.type)
  elseif data.type == ActivityCmd_pb.GACTIVITY_AFRICANPORING then
    AfricanPoringProxy.Instance:Destroy()
    FunctionActivity.Me():ShutDownActivity(data.type)
  end
  self:Notify(ServiceEvent.ActivityCmdStartGlobalActCmd, data)
end
function ServiceActivityCmdProxy:CallTimeLimitShopPageCmd(actid, items, refreshat, refreshtimes, rerefreshcost, reqrefresh)
  local now = UnityUnscaledTime
  if self.lastRefreshTimelimitShop then
    local dTime = now - self.lastRefreshTimelimitShop
    if dTime < 0.5 then
      redlog("[shop] 0.5???????????????????????????")
      return
    end
  end
  self.lastRefreshTimelimitShop = now
  ServiceActivityCmdProxy.super.CallTimeLimitShopPageCmd(self, actid, items, refreshat, refreshtimes, rerefreshcost, true)
end
function ServiceActivityCmdProxy:RecvTimeLimitShopPageCmd(data)
  SupplyDepotProxy.Instance:UpdateDepotData(data)
  self:Notify(ServiceEvent.ActivityCmdTimeLimitShopPageCmd, data)
end
function ServiceActivityCmdProxy:RecvAnimationLoginActCmd(data)
  LinkCharacterProxy.Instance:SetCurrentCharacter(data.id)
  ServiceActivityCmdProxy.super.RecvAnimationLoginActCmd(self, data)
end
function ServiceActivityCmdProxy:RecvFestivalSigninInfo(data)
  RememberLoginProxy.Instance:RecvFestivalSigninInfo(data)
  self:Notify(ServiceEvent.ActivityCmdFestivalSigninInfo, data)
end
function ServiceActivityCmdProxy:RecvFestivalSigninLoginAward(data)
  RememberLoginProxy.Instance:RecvFestivalSigninLoginAward(data)
  self:Notify(ServiceEvent.ActivityCmdFestivalSigninLoginAward, data)
end
function ServiceActivityCmdProxy:RecvGlobalDonationActivityInfoCmd(data)
  CrowdfundingActProxy.Instance:RecvInfo(data)
  ServiceActivityCmdProxy.super.RecvGlobalDonationActivityInfoCmd(self, data)
end
function ServiceActivityCmdProxy:RecvGlobalDonationActivityDonateCmd(data)
  if data.sucess then
    CrowdfundingActProxy.Instance:RecordSelfDonate(data.num)
  end
  ServiceActivityCmdProxy.super.RecvGlobalDonationActivityDonateCmd(self, data)
end
function ServiceActivityCmdProxy:RecvGlobalDonationActivityAwardCmd(data)
  if data.sucess then
    CrowdfundingActProxy.Instance:RecordAwardedId(data.id, data.type == ActivityCmd_pb.EGLOBALDONATIONACT_AWARD_GLOBAL)
  end
  ServiceActivityCmdProxy.super.RecvGlobalDonationActivityAwardCmd(self, data)
end
function ServiceActivityCmdProxy:RecvUserInviteInfoCmd(data)
  redlog("========ServiceActivityCmdAutoProxy:RecvUserInviteInfoCmd(data) =======")
  TableUtil.Print(data)
  PlayerRefluxProxy.Instance:SetRefluxData(data)
end
function ServiceActivityCmdProxy:RecvUserInviteInviteLoginAwardCmd(data)
  TableUtil.Print(data)
  redlog("========ServiceActivityCmdAutoProxy:RecvUserInviteInviteLoginAwardCmd(data) =======")
  PlayerRefluxProxy.Instance:SetInviteawardId(data)
  self:Notify(ServiceEvent.ActivityCmdUserInviteInviteLoginAwardCmd, data)
end
function ServiceActivityCmdProxy:RecvUserInviteBindUserCmd(data)
  redlog("========ServiceActivityCmdAutoProxy:RecvUserInviteBindUserCmd(data) =======")
  TableUtil.Print(data)
  PlayerRefluxProxy.Instance:Setbinduser(data)
  self:Notify(ServiceEvent.ActivityCmdUserInviteBindUserCmd, data)
end
function ServiceActivityCmdProxy:RecvUserInviteRecallLoginAwardCmd(data)
  redlog("========ServiceActivityCmdAutoProxy:RecvUserInviteRecallLoginAwardCmd(data) =======")
  TableUtil.Print(data)
  PlayerRefluxProxy.Instance:SetLoginawarddid(data)
  self:Notify(ServiceEvent.ActivityCmdUserInviteRecallLoginAwardCmd, data)
end
function ServiceActivityCmdProxy:RecvUserInviteInviteAwardCmd(data)
  redlog("========ServiceActivityCmdAutoProxy:RecvUserInviteInviteAwardCmd(data) =======")
  TableUtil.Print(data)
  PlayerRefluxProxy.Instance:SetInviteawarded(data)
  self:Notify(ServiceEvent.ActivityCmdUserInviteInviteAwardCmd, data)
end
function ServiceActivityCmdProxy:RecvUserInviteShareAwardCmd(data)
  redlog("========ServiceActivityCmdAutoProxy:RecvUserInviteShareAwardCmd(data) =======")
  TableUtil.Print(data)
  PlayerRefluxProxy.Instance:Setsharawarded(data)
  self:Notify(ServiceEvent.ActivityCmdUserInviteShareAwardCmd, data)
end
function ServiceActivityCmdProxy:RecvUserReturnInfoCmd(data)
  xdlog("?????????????????????")
  ReturnActivityProxy.Instance:RecvUserReturnInfoCmd(data)
  self:Notify(ServiceEvent.ActivityCmdUserReturnInfoCmd, data)
end
function ServiceActivityCmdProxy:RecvUserReturnShareAwardCmd(data)
  ReturnActivityProxy.Instance:RecvUserReturnShareAwardCmd(data)
  self:Notify(ServiceEvent.ActivityCmdUserReturnShareAwardCmd, data)
end
function ServiceActivityCmdProxy:RecvUserReturnQuestAwardCmd(data)
  ReturnActivityProxy.Instance:RecvUserReturnQuestAwardCmd(data)
  self:Notify(ServiceEvent.ActivityCmdUserReturnQuestAwardCmd, data)
end
function ServiceActivityCmdProxy:RecvUserInviteAwardCmd(data)
  ReturnActivityProxy.Instance:RecvUserInviteAwardCmd(data)
  NewPartnerActProxy.Instance:RecvUserInviteAwardCmd(data)
  self:Notify(ServiceEvent.ActivityCmdUserInviteAwardCmd, data)
end
function ServiceActivityCmdAutoProxy:RecvNewPartnerCmd(data)
  NewPartnerActProxy.Instance:RecvNewPartnerCmd(data)
  self:Notify(ServiceEvent.ActivityCmdNewPartnerCmd, data)
end
function ServiceActivityCmdProxy:RecvUserReturnQuestAddCmd(data)
  xdlog("??????????????????")
  ReturnActivityProxy.Instance:RecvUserReturnQuestAddCmd(data)
  self:Notify(ServiceEvent.ActivityCmdUserReturnQuestAddCmd, data)
end
function ServiceActivityCmdProxy:RecvUserReturnEnterChatRoomCmd(data)
  xdlog("?????????????????????")
  ChatRoomProxy.Instance:RecvUserReturnEnterChatRoomCmd(data)
  self:Notify(ServiceEvent.ActivityCmdUserReturnEnterChatRoomCmd, data)
end
function ServiceActivityCmdProxy:RecvUserReturnLeaveChatRoomCmd(data)
  xdlog("???????????????")
  ChatRoomProxy.Instance:RecvUserReturnLeaveChatRoomCmd(data)
  self:Notify(ServiceEvent.ActivityCmdUserReturnLeaveChatRoomCmd, data)
end
function ServiceActivityCmdProxy:RecvUserReturnLoginAwardCmd(data)
  xdlog("??????????????????")
  ReturnActivityProxy.Instance:RecvUserReturnLoginAwardCmd(data)
  self:Notify(ServiceEvent.ActivityCmdUserReturnLoginAwardCmd, data)
end
function ServiceActivityCmdProxy:RecvUserReturnChatRoomRecordCmd(data)
  xdlog("?????????????????? ?????????")
  self:Notify(ServiceEvent.ActivityCmdUserReturnChatRoomRecordCmd, data)
end
function ServiceActivityCmdProxy:RecvUserReturnRaidAwardCmd(data)
  self:Notify(ServiceEvent.ActivityCmdUserReturnRaidAwardCmd, data)
end
function ServiceActivityCmdProxy:RecvUserReturnInviteActivityNtfCmd(data)
  ReturnActivityProxy.Instance:RecvUserReturnInviteActivityNtfCmd(data)
  self:Notify(ServiceEvent.ActivityCmdUserReturnInviteActivityNtfCmd, data)
end
function ServiceActivityCmdProxy:RecvUserReturnBindCmd(data)
  ReturnActivityProxy.Instance:RecvUserReturnBindCmd(data)
  self:Notify(ServiceEvent.ActivityCmdUserReturnBindCmd, data)
end
function ServiceActivityCmdProxy:RecvUserReturnInviteCmd(data)
  ReturnActivityProxy.Instance:RecvUserReturnInviteCmd(data)
  self:Notify(ServiceEvent.ActivityCmdUserReturnInviteCmd, data)
end
function ServiceActivityCmdProxy:RecvUserReturnInviteAwardCmd(data)
  ReturnActivityProxy.Instance:RecvUserReturnInviteAwardCmd(data)
  self:Notify(ServiceEvent.ActivityCmdUserReturnInviteAwardCmd, data)
end
function ServiceActivityCmdProxy:RecvUserReturnInviteRecordCmd(data)
  ReturnActivityProxy.Instance:RecvUserReturnInviteRecordCmd(data)
  self:Notify(ServiceEvent.ActivityCmdUserReturnInviteRecordCmd, data)
end
function ServiceActivityCmdProxy:RecvGuildAssembleSyncCmd(data)
  redlog("ServiceActivityCmdProxy:RecvGuildAssembleSyncCmd")
  GuildProxy.Instance:UpdateGuildAssemble(data)
  self:Notify(ServiceEvent.ActivityCmdGuildAssembleSyncCmd, data)
end
function ServiceActivityCmdProxy:RecvDaySigninInfoCmd(data)
  DailyLoginProxy.Instance:RecvDaySigninInfoCmd(data)
  self:Notify(ServiceEvent.ActivityCmdDaySigninInfoCmd, data)
end
function ServiceActivityCmdProxy:RecvDaySigninLoginAwardCmd(data)
  DailyLoginProxy.Instance:RecvDaySigninLoginAwardCmd(data)
  self:Notify(ServiceEvent.ActivityCmdDaySigninLoginAwardCmd, data)
end
function ServiceActivityCmdProxy:RecvDaySigninActivityCmd(data)
  DailyLoginProxy.Instance:RecvDaySigninActivityCmd(data)
  self:Notify(ServiceEvent.ActivityCmdDaySigninActivityCmd, data)
end
function ServiceActivityCmdProxy:RecvBattleFundNofityActCmd(data)
  BattleFundProxy.Instance:RecvBattleFundInfo(data)
  self:Notify(ServiceEvent.ActivityCmdBattleFundNofityActCmd, data)
end
function ServiceActivityCmdProxy:RecvUserInviteCmd(data)
  ReturnActivityProxy.Instance:RecvUserInviteCmd(data)
  self:Notify(ServiceEvent.ActivityCmdUserInviteCmd, data)
end
