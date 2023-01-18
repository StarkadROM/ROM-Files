autoImport("ServiceSceneUser3AutoProxy")
autoImport("SpyInfo")
ServiceSceneUser3Proxy = class("ServiceQueueEnterCmdProxy", ServiceSceneUser3AutoProxy)
ServiceSceneUser3Proxy.Instance = nil
ServiceSceneUser3Proxy.NAME = "ServiceSceneUser3Proxy"
function ServiceSceneUser3Proxy:ctor(proxyName)
  if ServiceSceneUser3Proxy.Instance == nil then
    self.proxyName = proxyName or ServiceSceneUser3Proxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceSceneUser3Proxy.Instance = self
  end
end
function ServiceSceneUser3Proxy:RecvFirstDepositInfo(data)
  NoviceShopProxy.Instance:RecvFirstDepositInfo(data)
  self:Notify(ServiceEvent.SceneUser3FirstDepositInfo, data)
end
function ServiceSceneUser3Proxy:RecvFirstDepositReward(data)
  self:Notify(ServiceEvent.SceneUser3FirstDepositReward, data)
end
function ServiceSceneUser3Proxy:RecvAccumDepositInfo(data)
  AccumulativeShopProxy.Instance:RecvAccumDepositInfo(data)
  self:Notify(ServiceEvent.SceneUser3AccumDepositInfo, data)
end
function ServiceSceneUser3Proxy:RecvAccumDepositReward(data)
  AccumulativeShopProxy.Instance:RecvAccumDepositReward(data)
  self:Notify(ServiceEvent.SceneUser3AccumDepositReward, data)
end
function ServiceSceneUser3Proxy:RecvDailyDepositInfo(data)
  DailyDepositProxy.Instance:RecvDailyDepositInfo(data)
  self:Notify(ServiceEvent.SceneUser3DailyDepositInfo, data)
end
function ServiceSceneUser3Proxy:RecvBattleTimeCostSelectCmd(data)
  ExpRaidProxy.Instance:SyncGameTimeSetting(data)
  self:Notify(ServiceEvent.SceneUser3BattleTimeCostSelectCmd, data)
end
function ServiceSceneUser3Proxy:RecvPlugInNotify(data)
  helplog("RecvPlugInNotify")
  if not BackwardCompatibilityUtil.CompatibilityMode_V68 then
    helplog("start spy detect")
    SpyInfo.SetSpyConfig(data.infos)
    local detectInterval = data.detectinterval * 1000
    if self.spyDetecter ~= nil then
      TimeTickManager.Me():ClearTick(self.spyDetecter)
    end
    self.spyDetecter = TimeTickManager.Me():CreateTick(0, detectInterval, function()
      SpyInfo.Detect()
    end, self)
  end
end
function ServiceSceneUser3Proxy:RecvHeroGrowthQuestInfo(data)
  HeroProfessionProxy.Instance:UpdateHeroQuests(data.profession, data.growth_quests)
  self:Notify(ServiceEvent.SceneUser3HeroGrowthQuestInfo, data)
end
function ServiceSceneUser3Proxy:RecvHeroStoryQusetInfo(data)
  HeroProfessionProxy.Instance:UpdateHeroStories(data.profession, data.story_quests)
  self:Notify(ServiceEvent.SceneUser3HeroStoryQusetInfo, data)
end
function ServiceSceneUser3Proxy:RecvHeroStoryQuestAccept(data)
  HeroProfessionProxy.Instance:HandleUnlockStoryResp(data)
  self:Notify(ServiceEvent.SceneUser3HeroStoryQuestAccept, data)
end
function ServiceSceneUser3Proxy:RecvHeroStoryQuestReward(data)
  HeroProfessionProxy.Instance:HandleHeroStoryQuestRewardResp(data)
  self:Notify(ServiceEvent.SceneUser3HeroStoryQuestReward, data)
end
function ServiceSceneUser3Proxy:RecvHeroShowUserCmd(data)
  ProfessionProxy.Instance:UpdateRechargeHeroList(data)
  self:Notify(ServiceEvent.SceneUser3HeroShowUserCmd, data)
end
function ServiceSceneUser3Proxy:RecvQueryProfessionRecordSimpleData(data)
  MultiProfessionSaveProxy.Instance:RecvProfessionRecordSimpleData(data)
  self:Notify(ServiceEvent.SceneUser3QueryProfessionRecordSimpleData, data)
end
function ServiceSceneUser3Proxy:RecvBoliGoldGetReward(data)
  TreasuryRechargeProxy.Instance:RecvBoliGoldGetReward(data)
  self:Notify(ServiceEvent.SceneUser3BoliGoldGetReward, data)
end
function ServiceSceneUser3Proxy:RecvBoliGoldInfo(data)
  TreasuryRechargeProxy.Instance:RecvBoliGoldInfoCmd(data)
  self:Notify(ServiceEvent.SceneUser3BoliGoldInfo, data)
end
function ServiceSceneUser3Proxy:RecvBoliGoldGetFreeReward(data)
  TreasuryRechargeProxy.Instance:RecvBoliGoldGetFreeReward(data)
  self:Notify(ServiceEvent.SceneUser3BoliGoldGetFreeReward, data)
end
function ServiceSceneUser3Proxy:RecvResourceCheckUserCmd(data)
  local versionPath = table.concat({
    ApplicationHelper.persistentDataPath,
    "/",
    ApplicationHelper.platformFolder,
    "/",
    RO.Config.ROPathConfig.VersionFileName
  })
  local config = RO.Config.BuildBundleConfig.CreateByFile(versionPath)
  local resVersion = config ~= nil and tostring(config.currentVersion) or "Unknown"
  local retData = {}
  local installVersion = "0"
  local ta = Resources.Load(RO.Config.ROPathConfig.TrimExtension(RO.Config.ROPathConfig.VersionFileName))
  if ta then
    local config = RO.Config.BuildBundleConfig.CreateByStr(ta.text)
    installVersion = config ~= nil and config.currentVersion or 0
  end
  local subs = FileDirectoryHandler.GetChildrenName(table.concat({
    ApplicationHelper.persistentDataPath,
    "/",
    ApplicationHelper.platformFolder
  }))
  local tb = {}
  for i = 1, #subs do
    tb[#tb + 1] = subs[i]
  end
  local ps = table.concat(tb, ";")
  for i = 1, #data.resources do
    local s = data.resources[i]
    local path = table.concat({
      ApplicationHelper.persistentDataPath,
      "/",
      ApplicationHelper.platformFolder,
      "/",
      s.resource
    })
    helplog("RecvResourceCheckUserCmd:[path]", s.resource)
    local exists = FileHelper.ExistFile(path)
    local server = {}
    local rePath
    if exists then
      local fileMD5 = MyMD5.HashFile(path)
      rePath = path
      server.checksum = fileMD5
    else
      rePath = "not in persistent!!!"
      path = table.concat({
        Application.streamingAssetsPath,
        "/",
        s.resource
      })
      server.checksum = MyMD5.HashFile(path)
    end
    server.resource = rePath .. ps
    server.platform = ApplicationHelper.platformFolder .. "@" .. SystemInfo.deviceModel
    server.version = resVersion .. "@" .. installVersion
    retData[#retData + 1] = server
  end
  self:CallResourceCheckUserCmd(retData)
end
