using("UnityEngine")
using("RO")
autoImport("SetView")
autoImport("HurtNum")
autoImport("PushConfig")
FunctionPerformanceSetting = class("FunctionPerformanceSetting")
FunctionPerformanceSetting.OriginalData = {}
local mapRecommandConfig = {}
function FunctionPerformanceSetting.Me()
  if nil == FunctionPerformanceSetting.me then
    FunctionPerformanceSetting.me = FunctionPerformanceSetting.new()
  end
  return FunctionPerformanceSetting.me
end
local GetEffectRate = function()
  local deviceRate = ROSystemInfo.DeviceRate
  if ApplicationInfo.IsEmulator() then
    return LogicManager_MapCell.LODLevel.Mid
  elseif deviceRate <= 3 then
    return LogicManager_MapCell.LODLevel.Low
  elseif deviceRate == 4 then
    return LogicManager_MapCell.LODLevel.Mid
  else
    return LogicManager_MapCell.LODLevel.High
  end
end
local DeviceModelAntiMap = {
  ["HUAWEI ELE-AL00"] = 2
}
local GetDeviceMsaa = function(anti)
  local limit = DeviceModelAntiMap[ApplicationInfo.GetDeviceModel()]
  if limit and anti > limit then
    return limit
  end
  return anti
end
function FunctionPerformanceSetting:ctor()
  self.setting = {
    outLine = true,
    skillEffect = true,
    skillAudioEffect = true,
    slim = false,
    immediatelyDress = false,
    bgmVolume = 1,
    soundVolume = 1,
    autoPlayChatChannel = {
      ChatChannelEnum.Team,
      ChatChannelEnum.Zone,
      ChatChannelEnum.Private
    },
    screenCount = GameConfig.Setting.ScreenCountLow,
    isShowOtherName = true,
    showOtherChar = true,
    voiceLanguage = LanguageVoice.Chinese,
    powerMode = true,
    resolution = 1,
    push = 31,
    gvoice = 0,
    targetFrameRate = 1,
    skipStartGameCG = false,
    isFirstTimeInstall = true,
    showHurtNum = ShowHurtNum.All,
    hurtNumStyleDetail = false,
    showFpsFrameHint = true,
    disableFreeCamera = false,
    disableFreeCameraVert = false,
    plotVolume = 1,
    plotVolumeToggle = true,
    otherPlayerExterior = 0,
    showPeak = true,
    qualityLevel = 2,
    showBloom = false,
    showEnv = false,
    shadowRate = 0,
    antiRate = 0,
    effectLv = 1,
    voicePartShowing = false,
    multimount = true,
    showDetail = MyselfProxy.Instance and MyselfProxy.Instance:GetQueryType() or SettingEnum.ShowDetailAll,
    fxaa = false,
    luckyNotify = true,
    walkaround = true
  }
  self.qualitySetConfig = {
    [1] = {
      anti = 1,
      bloom = false,
      shadow = 0,
      effect = 0,
      env = false,
      fxaa = false
    },
    [2] = {
      anti = 1,
      bloom = true,
      shadow = 1,
      effect = 1,
      env = false,
      fxaa = true
    },
    [3] = {
      anti = 2,
      bloom = true,
      shadow = 2,
      effect = 2,
      env = false,
      fxaa = true
    },
    [0] = {
      anti = 1,
      bloom = false,
      shadow = 0,
      effect = 0,
      env = false,
      fxaa = false
    }
  }
  self.recommendConfig = {
    [1] = {
      anti = 1,
      shadow = 0,
      effect = 0,
      bloom = false,
      fxaa = false
    },
    [2] = {
      anti = 1,
      shadow = 0,
      effect = 0,
      bloom = false,
      fxaa = false
    },
    [3] = {
      anti = 1,
      shadow = 0,
      effect = 1,
      bloom = true,
      fxaa = true
    },
    [4] = {
      anti = 1,
      shadow = 1,
      effect = 1,
      bloom = true,
      fxaa = true
    },
    [5] = {
      anti = 2,
      shadow = 2,
      effect = 2,
      bloom = true,
      fxaa = true
    }
  }
  local seCfg = GameConfig.SEBranchSetting and GameConfig.SEBranchSetting.Order
  if seCfg and #seCfg > 0 then
    self.setting.voiceLanguage = seCfg[1]
  elseif BranchMgr.IsSEA() or BranchMgr.IsNA() or BranchMgr.IsEU() then
    self.setting.voiceLanguage = LanguageVoice.Jananese
  end
  if ApplicationInfo.IsRunOnWindowns() then
    self.setting.resolution = 2
  end
  self:InitByDeviceRate()
  self:InitRecommandConfig()
  self:TryReduceConfig()
  EventManager.Me():AddEventListener(LoadSceneEvent.FinishLoadScene, self.OnSceneLoaded, self)
end
function FunctionPerformanceSetting:TryReduceConfig()
  if ROSystemInfo.DeviceRate <= 2 or ApplicationInfo.GetSystemMemorySize() < 2800 then
    local basicFps = 30
    local runtimePlatform = ApplicationInfo.GetRunPlatform()
    if runtimePlatform == RuntimePlatform.IPhonePlayer then
      ApplicationInfo.SetTargetFrameRate(basicFps)
    elseif runtimePlatform == RuntimePlatform.Android then
      ApplicationInfo.SetTargetFrameRate(basicFps)
    end
    self:SetBloom(false)
    self:ApplyBloom()
  end
  FunctionPerformanceSetting.AdjustLodBiasByDevice()
end
function FunctionPerformanceSetting.AdjustLodBiasByDevice()
  if ApplicationInfo.IsRunOnEditor() then
    return
  end
  if ROSystemInfo.DeviceRate == 5 then
    QualitySettings.lodBias = 3
  elseif ROSystemInfo.DeviceRate == 4 then
    QualitySettings.lodBias = 2
  else
    QualitySettings.lodBias = 2
  end
end
function FunctionPerformanceSetting:InitByDeviceRate()
  if self.setting.qualityLevel == nil then
    self.setting.qualityLevel = 2
  end
end
function FunctionPerformanceSetting:InitRecommandConfig()
  local deviceRate = ROSystemInfo.DeviceRate
  self.qualitySetConfig[2].anti = self.recommendConfig[deviceRate].anti
  self.qualitySetConfig[2].effect = self.recommendConfig[deviceRate].effect
  self.qualitySetConfig[2].bloom = self.recommendConfig[deviceRate].bloom
  self.qualitySetConfig[2].fxaa = self.recommendConfig[deviceRate].fxaa
  if ApplicationInfo.GetRunPlatform() == RuntimePlatform.Android and ApplicationInfo.IsEmulator() then
    self.qualitySetConfig[2].shadow = 1
    if self.qualitySetConfig[2].effect < 1 then
      self.qualitySetConfig[2].effect = 1
    end
  else
    self.qualitySetConfig[2].shadow = self.recommendConfig[deviceRate].shadow
  end
  self:SetAnti(self.qualitySetConfig[2].anti)
  if not mapRecommandConfig.shadowRate then
    self:SetShadow(self.qualitySetConfig[2].shadow)
  end
  self:SetBloom(self.qualitySetConfig[2].bloom)
  self:SetEffectLv(self.qualitySetConfig[2].effect)
  self:SetFxaa(self.qualitySetConfig[2].fxaa)
  if deviceRate < 3 then
    HurtNumLimit[1] = HurtNumLimit[1] * 0.5
    HurtNumLimit[2] = HurtNumLimit[2] * 0.5
  end
  self.setting.targetFrameRate = deviceRate >= 4 and 3 or 1
end
function FunctionPerformanceSetting:IsPersonal(qualityLevel, type, value)
  if qualityLevel == 0 then
    return true
  end
  local config = self.qualitySetConfig[qualityLevel]
  if config.type == value then
  end
  return true
end
function FunctionPerformanceSetting:GetDefaultQuality()
  local rate = ROSystemInfo.DeviceRate
  local defaultQuality
  if rate <= 3 then
    defaultQuality = 1
  elseif rate > 3 and rate < 5 then
    defaultQuality = 2
  elseif rate >= 5 then
    defaultQuality = 3
  end
  return defaultQuality
end
local checkVoiceLanguageValid = function(self)
  local seCfg = GameConfig.SEBranchSetting and GameConfig.SEBranchSetting.Order
  local curVoice = self.setting.voiceLanguage
  if seCfg and #seCfg > 0 and 0 >= TableUtility.ArrayFindIndex(seCfg, curVoice) then
    self.setting.voiceLanguage = seCfg[1]
    self:Save()
  end
end
function FunctionPerformanceSetting:Load()
  local isCall = pcall(function(i)
    local localSet = LocalSaveProxy.Instance:LoadSetting()
    if localSet then
      for k, v in pairs(localSet) do
        for k1, v1 in pairs(self.setting) do
          if k == k1 and nil ~= v then
            self.setting[k] = v
          end
        end
      end
    end
  end)
  self:CheckOverSeaIsNeed3DCamera()
  self:Apply()
  checkVoiceLanguageValid(self)
end
function FunctionPerformanceSetting:CheckOverSeaIsNeed3DCamera()
  local cameraCfg = UnionConfig.System and UnionConfig.System.Camera3D
  if cameraCfg and cameraCfg == 1 then
    self:SetLockFreeCameraVert(true)
  end
end
function FunctionPerformanceSetting:Save()
  LocalSaveProxy.Instance:SaveSetting(self.setting)
end
function FunctionPerformanceSetting:GetSetting()
  return self.setting
end
function FunctionPerformanceSetting:SetRunning()
  return nil ~= self.oldSetting
end
function FunctionPerformanceSetting:SetBegin()
  if self:SetRunning() then
    return
  end
  self.oldSetting = {}
  for k, v in pairs(self.setting) do
    self.oldSetting[k] = v
  end
end
function FunctionPerformanceSetting:SetOutLine(on)
  self.setting.outLine = on
end
function FunctionPerformanceSetting:SetSkillEffect(on)
  self.setting.skillEffect = on
end
function FunctionPerformanceSetting:SetSkillAudioEffect(on)
  self.setting.skillAudioEffect = on
end
function FunctionPerformanceSetting:SetSlim(on)
  self.setting.slim = on
end
function FunctionPerformanceSetting:SetImmediatelyDress(on)
  self.setting.immediatelyDress = on
end
function FunctionPerformanceSetting:SetBgmVolume(volume)
  self.setting.bgmVolume = volume
end
function FunctionPerformanceSetting:SetSoundVolume(volume)
  self.setting.soundVolume = volume
end
function FunctionPerformanceSetting:SetPlotVolume(volume)
  self.setting.plotVolume = volume
end
function FunctionPerformanceSetting:SetPlotVolumeToggle(on)
  self.setting.plotVolumeToggle = on
end
function FunctionPerformanceSetting:SetAutoPlayChatChannel(channelList)
  self.setting.autoPlayChatChannel = channelList
end
function FunctionPerformanceSetting:SetScreenCount(count)
  self.setting.screenCount = count
  if Game.GameHealthProtector then
    Game.GameHealthProtector:RefreshCheckGameFrameRateStatus()
  end
end
function FunctionPerformanceSetting:SetEffectLv(lv)
  self.setting.effectLv = lv
end
function FunctionPerformanceSetting:SetFxaa(on)
  self.setting.fxaa = on
end
function FunctionPerformanceSetting:SetShowOtherName(on)
  self.setting.isShowOtherName = on
end
function FunctionPerformanceSetting:SetShowOtherChar(on)
  self.setting.showOtherChar = on
end
function FunctionPerformanceSetting:SetShowDetail(showDetail)
  self.setting.showDetail = showDetail
end
function FunctionPerformanceSetting:SetShowWedding(showWedding)
  self.setting.showWedding = showWedding
end
function FunctionPerformanceSetting:SetVoiceLanguage(language)
  self.setting.voiceLanguage = language
end
function FunctionPerformanceSetting:SetPowerMode(on)
  self.setting.powerMode = on
end
function FunctionPerformanceSetting:SetLockFreeCameraVert(on)
  self.setting.disableFreeCameraVert = on
end
function FunctionPerformanceSetting:SetLockCamera(on)
  self.setting.disableFreeCamera = on
end
function FunctionPerformanceSetting:SetResolution(index)
  self.setting.resolution = index
end
function FunctionPerformanceSetting:SetPush(push)
  self.setting.push = push
end
function FunctionPerformanceSetting:SetGVoice(value)
  self.setting.gvoice = value
end
function FunctionPerformanceSetting:SetFrameRate(value)
  self.setting.targetFrameRate = value
end
function FunctionPerformanceSetting:SetFirstTimeInstall(value)
  self.setting.isFirstTimeInstall = value
end
function FunctionPerformanceSetting:SetShowHurtNum(value)
  self.setting.showHurtNum = value
end
function FunctionPerformanceSetting:SetHurtNumStyleDetail(on)
  self.setting.hurtNumStyleDetail = on
end
function FunctionPerformanceSetting:SetShowFpsFrameHint(on)
  self.setting.showFpsFrameHint = on
end
function FunctionPerformanceSetting:SetPeak(on)
  self.setting.showPeak = on
end
function FunctionPerformanceSetting:SetBloom(on)
  self.setting.showBloom = on
end
function FunctionPerformanceSetting:SetEnviro(on)
  self.setting.showEnviro = on
end
function FunctionPerformanceSetting:SetShadow(value)
  self.setting.shadowRate = value
end
function FunctionPerformanceSetting:SetAnti(value)
  self.setting.antiRate = value
end
function FunctionPerformanceSetting:SetQualityLevel(value)
  self.setting.qualityLevel = value
end
function FunctionPerformanceSetting:SetMultiMount(on)
  self.setting.multimount = on
end
function FunctionPerformanceSetting:SetVoicePartShowing(value)
  self.setting.voicePartShowing = value
end
function FunctionPerformanceSetting:SetOtherPlayerExterior(var)
  self.setting.otherPlayerExterior = var
end
function FunctionPerformanceSetting:SetLuckyNotify(value)
  self.setting.luckyNotify = value
end
function FunctionPerformanceSetting:SetWalkAround(b)
  self.setting.walkaround = b
end
function FunctionPerformanceSetting:GetWalkAround()
  return self.setting.walkaround
end
function FunctionPerformanceSetting:ResetQualityConfig()
  self:InitByDeviceRate()
  local config = self.qualitySetConfig[self.setting.qualityLevel]
  self:SetAnti(config.anti)
  self:SetBloom(config.bloom)
  self:SetShadow(config.shadow)
  self:SetEnviro(config.env)
end
function FunctionPerformanceSetting:SetEnd()
  if not self:SetRunning() then
    return
  end
  local changed = false
  local changedSetting = {}
  if self.oldSetting.outLine ~= self.setting.outLine then
    changedSetting.outLine = self.setting.outLine
    changed = true
  end
  if self.oldSetting.skillEffect ~= self.setting.skillEffect then
    changedSetting.skillEffect = self.setting.skillEffect
    changed = true
  end
  if self.oldSetting.skillAudioEffect ~= self.setting.skillAudioEffect then
    changedSetting.skillAudioEffect = self.setting.skillAudioEffect
    changed = true
  end
  if self.oldSetting.slim ~= self.setting.slim then
    changedSetting.slim = self.setting.slim
    changed = true
  end
  if self.oldSetting.immediatelyDress ~= self.setting.immediatelyDress then
    changedSetting.immediatelyDress = self.setting.immediatelyDress
    changed = true
  end
  if self.oldSetting.bgmVolume ~= self.setting.bgmVolume then
    changedSetting.bgmVolume = self.setting.bgmVolume
    changed = true
  end
  if self.oldSetting.soundVolume ~= self.setting.soundVolume then
    changedSetting.soundVolume = self.setting.soundVolume
    changed = true
  end
  if self.oldSetting.autoPlayChatChannel ~= self.setting.autoPlayChatChannel then
    changedSetting.autoPlayChatChannel = self.setting.autoPlayChatChannel
    changed = true
  end
  if self.oldSetting.screenCount ~= self.setting.screenCount then
    changedSetting.screenCount = self.setting.screenCount
    changed = true
  end
  if self.oldSetting.effectLv ~= self.setting.effectLv then
    changedSetting.effectLv = self.setting.effectLv
    changed = true
  end
  if self.oldSetting.isShowOtherName ~= self.setting.isShowOtherName then
    changedSetting.isShowOtherName = self.setting.isShowOtherName
    changed = true
  end
  if self.oldSetting.showOtherChar ~= self.setting.showOtherChar then
    changedSetting.showOtherChar = self.setting.showOtherChar
    changed = true
  end
  local showDetail = MyselfProxy.Instance:GetQueryType()
  if showDetail > 0 and self.oldSetting.showDetail ~= self.setting.showDetail then
    changedSetting.showDetail = self.setting.showDetail
    changed = true
  end
  local showWedding = MyselfProxy.Instance:GetQueryWeddingType()
  if showWedding > 0 and self.oldSetting.showWedding ~= self.setting.showWedding then
    changedSetting.showWedding = self.setting.showWedding
    changed = true
  end
  if self.oldSetting.voiceLanguage ~= self.setting.voiceLanguage then
    changedSetting.voiceLanguage = self.setting.voiceLanguage
    changed = true
  end
  if self.oldSetting.powerMode ~= self.setting.powerMode then
    changedSetting.powerMode = self.setting.powerMode
    changed = true
  end
  if self.oldSetting.disableFreeCamera ~= self.setting.disableFreeCamera then
    changedSetting.disableFreeCamera = self.setting.disableFreeCamera
    changed = true
  end
  if self.oldSetting.disableFreeCameraVert ~= self.setting.disableFreeCameraVert then
    changedSetting.disableFreeCameraVert = self.setting.disableFreeCameraVert
    changed = true
  end
  if self.oldSetting.resolution ~= self.setting.resolution then
    changedSetting.resolution = self.setting.resolution
    changed = true
  end
  if self.oldSetting.push ~= self.setting.push then
    changedSetting.push = self.setting.push
    changed = true
  end
  if self.oldSetting.gvoice ~= self.setting.gvoice then
    changedSetting.gvoice = self.setting.gvoice
    changed = true
  end
  if self.oldSetting.isFirstTimeInstall ~= self.setting.isFirstTimeInstall then
    changedSetting.isFirstTimeInstall = self.setting.isFirstTimeInstall
    changed = true
  end
  if self.oldSetting.showHurtNum ~= self.setting.showHurtNum then
    changedSetting.showHurtNum = self.setting.showHurtNum
    changed = true
  end
  if self.oldSetting.hurtNumStyleDetail ~= self.setting.hurtNumStyleDetail then
    changedSetting.hurtNumStyleDetail = self.setting.hurtNumStyleDetail
    changed = true
  end
  if self.oldSetting.showFpsFrameHint ~= self.setting.showFpsFrameHint then
    changedSetting.showFpsFrameHint = self.setting.showFpsFrameHint
    changed = true
  end
  if self.oldSetting.plotVolume ~= self.setting.plotVolume then
    changedSetting.plotVolume = self.setting.plotVolume
    changed = true
  end
  if self.oldSetting.plotVolumeToggle ~= self.setting.plotVolumeToggle then
    changedSetting.plotVolumeToggle = self.setting.plotVolumeToggle
    changed = true
  end
  if self.oldSetting.showPeak ~= self.setting.showPeak then
    changedSetting.showPeak = self.setting.showPeak
    changed = true
  end
  if self.oldSetting.qualityLevel ~= self.setting.qualityLevel then
    changedSetting.qualityLevel = self.setting.qualityLevel
    changed = true
  end
  if self.oldSetting.showBloom ~= self.setting.showBloom then
    changedSetting.showBloom = self.setting.showBloom
    changed = true
  end
  if self.oldSetting.shadowRate ~= self.setting.shadowRate then
    changedSetting.shadowRate = self.setting.shadowRate
    changed = true
  end
  if self.oldSetting.antiRate ~= self.setting.antiRate then
    changedSetting.antiRate = self.setting.antiRate
    changed = true
  end
  if self.oldSetting.fxaa ~= self.setting.fxaa then
    changedSetting.fxaa = self.setting.fxaa
    changed = true
  end
  if self.oldSetting.voicePartShowing ~= self.setting.voicePartShowing then
    changedSetting.voicePartShowing = self.setting.voicePartShowing
    changed = true
  end
  if self.oldSetting.targetFrameRate ~= self.setting.targetFrameRate then
    changedSetting.targetFrameRate = self.setting.targetFrameRate
    changed = true
  end
  if self.oldSetting.otherPlayerExterior ~= self.setting.otherPlayerExterior then
    changedSetting.otherPlayerExterior = self.setting.otherPlayerExterior
    changed = true
  end
  if self.oldSetting.luckyNotify ~= self.setting.luckyNotify then
    changedSetting.luckyNotify = self.setting.luckyNotify
    changed = true
  end
  if self.oldSetting.walkaround ~= self.setting.walkaround then
    changedSetting.walkaround = self.setting.walkaround
    changed = true
  end
  self.oldSetting = nil
  if changed then
    self:Save()
    self:Apply(changedSetting)
  end
end
function FunctionPerformanceSetting:Apply(setting)
  setting = setting or self.setting
  if nil ~= setting.outLine then
    if setting.outLine then
      RenderingManager.Instance:SetOutline(1)
    else
      RenderingManager.Instance:SetOutline(0)
    end
  end
  if nil ~= setting.slim then
    local flag = 0
    if self.setting.slim then
      flag = 1
    end
    ServiceNUserProxy.Instance:CallNewSetOptionUserCmd(SceneUser2_pb.EOPTIONTYPE_USE_SLIM, flag)
  end
  if nil == setting.bgmVolume or GVoiceProxy.Instance.curChannel ~= nil then
  else
    FunctionBGMCmd.Me():SettingSetVolume(setting.bgmVolume)
  end
  if nil == setting.soundVolume or GVoiceProxy.Instance.curChannel ~= nil then
  else
    AudioUtility.SetVolume(setting.soundVolume)
  end
  if nil ~= setting.autoPlayChatChannel then
    ChatRoomProxy.Instance:ResetAutoSpeechChannel()
  end
  if nil ~= setting.screenCount then
    Game.LogicManager_RoleDress:SetLimitCount(setting.screenCount)
    Game.GameHealthProtector:SetSettingLimitCount(setting.screenCount)
  end
  if nil ~= setting.effectLv then
    local realEffectLV = 2 - setting.effectLv
    EffectHandleManager.Instance.lodLevel = realEffectLV
    if LogicManager_MapCell.LODLevel.High == realEffectLV then
      EffectManager.SetEffectLodLevel(0)
    elseif LogicManager_MapCell.LODLevel.Mid == realEffectLV then
      EffectManager.SetEffectLodLevel(1)
    else
      EffectManager.SetEffectLodLevel(2)
    end
  end
  if nil ~= setting.showOtherChar then
    Game.LogicManager_RoleDress:SetDressDisable(not setting.showOtherChar)
  end
  if nil ~= setting.isShowOtherName then
    GameFacade.Instance:sendNotification(SetEvent.ShowOtherName)
  end
  if nil ~= setting.showDetail or nil ~= setting.showWedding then
    ServiceNUserProxy.Instance:CallSetOptionUserCmd(setting.showDetail, nil, setting.showWedding)
  end
  if nil ~= setting.powerMode then
    Game.HandUpManager:UpdateOpenState()
  end
  if nil ~= setting.disableFreeCamera or nil ~= setting.disableFreeCameraVert then
    FunctionCameraEffect.Me():InitFreeCameraParam()
    Game.MapManager:UpdateCameraState(CameraController.singletonInstance)
    GameFacade.Instance:sendNotification(SetEvent.CameraCtrlChange)
  end
  if nil ~= setting.resolution and not ApplicationInfo.IsRunOnWindowns() then
    Game.SetResolution(setting.resolution)
  end
  if nil ~= setting.push then
    local _PushEventConfig = PushConfig.EventConfig
    local list = LuaUtils.CreateStringList()
    for i = 0, #_PushEventConfig do
      if setting.push >> i & 1 == 0 then
        list:Add(_PushEventConfig[i])
      end
    end
    list:Add(PushConfig.Channel)
    if ApplicationInfo.IsRunOnEditor() then
    elseif BranchMgr.IsChina() then
      PushProxy.Instance:SetTags(os.time(), list)
    end
  end
  if nil ~= setting.targetFrameRate then
    if setting.targetFrameRate == 1 then
      ApplicationInfo.SetTargetFrameRate(30)
    elseif setting.targetFrameRate == 2 then
      ApplicationInfo.SetTargetFrameRate(60)
    elseif setting.targetFrameRate == 3 then
      ApplicationInfo.SetTargetFrameRate(45)
    else
      helplog("FrameRate data is nil--> default index = 1, FrameRate = 30")
    end
  end
  if nil ~= setting.plotVolume then
    FunctionPlotCmd.Me():SettingSetVolume(setting.plotVolume)
  end
  if nil ~= setting.plotVolumeToggle then
    FunctionPlotCmd.Me():SetNpcVolumeToggle(setting.plotVolumeToggle)
  end
  if nil ~= setting.otherPlayerExterior then
    redlog("otherPlayerExterior: ", setting.otherPlayerExterior)
    ServiceUserEventProxy.Instance:CallSetHideOtherCmd(setting.otherPlayerExterior)
  end
  if nil ~= setting.showPeak then
    helplog("show Peak :" .. tostring(setting.showPeak))
    if Game.Myself ~= nil then
      Game.Myself:SetPeakEffectVisible(setting.showPeak, FunctionSceneFilter.PeakEffectFilter)
    end
  end
  if nil ~= setting.voicePartShowing then
    GameFacade.Instance:sendNotification(SetEvent.SetShowVoicePart)
  end
  self:ApplyBloom()
  local anti = math.pow(2, self.setting.antiRate - 1)
  PostprocessManager.Instance:SetMSAA(GetDeviceMsaa(anti))
  self:ApplyShadow(setting.shadowRate)
  self:ApplyFxaa()
  if nil ~= setting.luckyNotify then
    local flag = 0
    if self.setting.luckyNotify then
      flag = 1
    end
    ServiceNUserProxy.Instance:CallNewSetOptionUserCmd(SceneUser2_pb.EOPTIONTYPE_LUCKY_GUY_NOTIFY, flag)
  end
  if setting.walkaround ~= nil then
    self:ApplyWalkAround(setting.walkaround)
  end
end
function FunctionPerformanceSetting:ApplyWalkAround(b)
  if b then
    FunctionSceneFilter.Me():EndFilter(GameConfig.Booth.screenFilterID)
  else
    FunctionSceneFilter.Me():StartFilter(GameConfig.Booth.screenFilterID)
  end
end
function FunctionPerformanceSetting:ApplyFxaa()
  Game.EnviromentManager:SwitchFxaa(self:GetFxaa())
end
function FunctionPerformanceSetting:ApplyShadow(shadowRate)
  shadowRate = shadowRate or self:GetShadowRate()
  local texSize = shadowRate * 1024
  local lighArray = {}
  local lights = GameObject.FindObjectsOfType(Light)
  for _, light in pairs(lights) do
    if light.type == 1 then
      table.insert(lighArray, light.gameObject)
      break
    end
  end
  if #lighArray > 0 then
    local result = texSize > 0
    for k, v in pairs(lighArray) do
      if not Slua.IsNull(v) then
        v:SetActive(result)
      end
    end
  else
    redlog("missing light go")
  end
  if Slua.IsNull(LightMono.GlobalDirectionalLight) then
    LightMono.DirectionalLightOn = texSize > 0
  else
    LightMono.SwitchDirectionalLight(texSize > 0)
  end
  if not BackwardCompatibilityUtil.CompatibilityMode_V54 then
    local p = RenderingManager.Instance:GetNowURPAssetParam()
    if texSize > 0 then
      p.mainLightRenderingMode = 1
      p.mainLightShadowmapResolution = texSize
    else
      p.mainLightRenderingMode = 0
    end
    p.additionalLightsRenderingMode = 0
    p.shadowCascadeOption = 0
    RenderingManager.Instance:UpdateURPAssetParam(p)
  else
    RenderingManager.Instance:SetShadowSize(texSize)
  end
  local config
  if texSize == 2048 then
    config = Asset_Role.PartShadow[3]
  elseif texSize == 1024 then
    config = Asset_Role.PartShadow[2]
  else
    config = Asset_Role.PartShadow[1]
  end
  RoleComplete.SetShadowConfig(config)
  local allRole = NSceneUserProxy.Instance.userMap
  if allRole ~= nil then
    for k, v in pairs(allRole) do
      v.assetRole:ApplyShadowConfig()
    end
  end
  local allNpc = NSceneNpcProxy.Instance.userMap
  if allNpc ~= nil then
    for k, v in pairs(allNpc) do
      v.assetRole:ApplyShadowConfig()
    end
  end
  if Game and Game.Myself then
    Game.Myself.assetRole:ApplyShadowConfig()
  end
end
function FunctionPerformanceSetting:ApplyBloom()
  if Game.EnviromentManager ~= nil then
    Game.EnviromentManager:SwitchCameraDefaultEffect(self:GetBloom())
  end
end
function FunctionPerformanceSetting:OnSceneLoaded()
  local setting = self:GetSetting()
end
function FunctionPerformanceSetting:IsAutoPlayChatChannel(channel)
  if channel == nil then
    return false
  end
  for k, v in pairs(self.setting.autoPlayChatChannel) do
    if v == channel then
      return true
    end
  end
  return false
end
function FunctionPerformanceSetting:IsShowOtherName()
  return self.setting.isShowOtherName == true
end
function FunctionPerformanceSetting:GetLanguangeVoice()
  return self.setting.voiceLanguage
end
function FunctionPerformanceSetting:GetPowerMode()
  return self.setting.powerMode
end
function FunctionPerformanceSetting:GetPush()
  return self.setting.push
end
function FunctionPerformanceSetting:GetGvoice()
  return self.setting.gvoice
end
function FunctionPerformanceSetting:ShowHurtNum()
  return self.setting.showHurtNum
end
function FunctionPerformanceSetting:GetHurtNumStyleDetail()
  return self.setting.hurtNumStyleDetail
end
function FunctionPerformanceSetting:GetScreenCount()
  return self.setting.screenCount
end
function FunctionPerformanceSetting:IsEffectLow()
  local realEffectLv = 2 - self:GetEffectLv()
  return LogicManager_MapCell.LODLevel.Low == realEffectLv
end
function FunctionPerformanceSetting:GetEffectLv()
  return self.setting.effectLv
end
function FunctionPerformanceSetting:GetCameraLocked()
  return GameConfig.SystemForbid.FreeCamera or self.setting.disableFreeCamera
end
function FunctionPerformanceSetting:VerticalCameraLocked()
  return self:GetCameraLocked() or self.setting.disableFreeCameraVert
end
function FunctionPerformanceSetting:GetCameraMode()
  if self:GetCameraLocked() then
    return 1
  end
  if self:VerticalCameraLocked() then
    return 2
  end
  return 3
end
function FunctionPerformanceSetting:GetBGMSetting()
  return self.setting.bgmVolume
end
function FunctionPerformanceSetting:GetPeak()
  return self.setting.showPeak
end
function FunctionPerformanceSetting:GetSlim()
  return self.setting.slim
end
function FunctionPerformanceSetting:GetOutline()
  return self.setting.outLine
end
function FunctionPerformanceSetting:GetTargetFrameRate()
  return self.setting.targetFrameRate
end
function FunctionPerformanceSetting:GetTargetFrameRateInterval()
  if self.setting.targetFrameRate == 1 then
    return 33
  else
    return 16
  end
end
function FunctionPerformanceSetting:GetQualitySet()
  return self.setting.qualityLevel
end
function FunctionPerformanceSetting:GetQualityConfig(configLevel)
  if configLevel == nil then
    return self.qualitySetConfig[self.setting.qualityLevel]
  else
    return self.qualitySetConfig[configLevel]
  end
end
function FunctionPerformanceSetting:GetBloom()
  return self.setting.showBloom
end
function FunctionPerformanceSetting:GetEnviro()
  return self.setting.showEnviro
end
function FunctionPerformanceSetting:GetShadowRate()
  if mapRecommandConfig.shadowRate then
    return mapRecommandConfig.shadowRate
  end
  return self.setting.shadowRate
end
function FunctionPerformanceSetting:GetAntiRate()
  return self.setting.antiRate
end
function FunctionPerformanceSetting:GetVoicePartShowing()
  return self.setting.voicePartShowing or false
end
function FunctionPerformanceSetting:GetFxaa()
  return self.setting.fxaa and self.setting.showBloom and ROSystemInfo.DeviceRate > 2
end
function FunctionPerformanceSetting:GetOtherPlayerExterior()
  return self.setting.otherPlayerExterior
end
function FunctionPerformanceSetting:ApplyAntiRateSetting()
  local anti = math.pow(2, self.setting.antiRate - 1)
  PostprocessManager.Instance:SetMSAA(GetDeviceMsaa(anti))
end
local changedSetting = {}
function FunctionPerformanceSetting.EnterSavingMode()
  local tab = Game.GetResolutionNames()
  changedSetting.outLine = false
  changedSetting.slim = false
  changedSetting.effectLv = 2
  changedSetting.screenCount = GameConfig.Setting.ScreenCountLow
  changedSetting.isShowOtherName = false
  changedSetting.resolution = #tab
  changedSetting.targetFrameRate = 1
  FunctionPerformanceSetting.Me():Apply(changedSetting)
end
function FunctionPerformanceSetting.ExitSavingMode()
  local me = FunctionPerformanceSetting.Me()
  changedSetting.outLine = me:GetSetting().outLine
  changedSetting.slim = me:GetSetting().slim
  changedSetting.screenCount = me:GetSetting().screenCount
  changedSetting.effectLv = me:GetSetting().effectLv
  changedSetting.isShowOtherName = me:GetSetting().isShowOtherName
  changedSetting.resolution = me:GetSetting().resolution
  changedSetting.targetFrameRate = me:GetSetting().targetFrameRate
  FunctionPerformanceSetting.Me():Apply(changedSetting)
end
SettingEnum = {
  ShowDetailAll = SceneUser2_pb.EQUERYTYPE_ALL,
  ShowDetailFriend = SceneUser2_pb.EQUERYTYPE_FRIEND,
  ShowDetailClose = SceneUser2_pb.EQUERYTYPE_CLOSE,
  ShowWeddingAll = SceneUser2_pb.EQUERYTYPE_WEDDING_ALL,
  ShowWeddingFriend = SceneUser2_pb.EQUERYTYPE_WEDDING_FRIEND,
  ShowWeddingClose = SceneUser2_pb.EQUERYTYPE_WEDDING_CLOSE,
  MultiMountTeam = SceneUser2_pb.EMULTIMOUNT_OPTION_TEAM
}
LanguageVoice = {
  Chinese = 1,
  Jananese = 2,
  Korean = 3
}
ShowHurtNum = {
  All = 1,
  Team = 2,
  Self = 3
}
function FunctionPerformanceSetting.CheckInputForbidden()
  return GameConfig.System.ForceForbiddenInput == 1
end
local GetSettingFuncMap = {
  shadowRate = FunctionPerformanceSetting.GetShadowRate
}
function FunctionPerformanceSetting.ApplyMapSetting(mapSetting)
  for k, v in pairs(mapSetting) do
    mapRecommandConfig[k] = v
  end
  FunctionPerformanceSetting.Me():Apply(mapSetting)
end
function FunctionPerformanceSetting.ExitMapSetting()
  if not next(mapRecommandConfig) then
    return
  end
  local settingMe = FunctionPerformanceSetting.Me()
  for k, v in pairs(mapRecommandConfig) do
    mapRecommandConfig[k] = GetSettingFuncMap[k](settingMe)
  end
  FunctionPerformanceSetting.Me():Apply(mapRecommandConfig)
  TableUtility.TableClear(mapRecommandConfig)
end
