autoImport("AudioHD")
autoImport("AudioPackageDownloader")
autoImport("BranchMgr")
SetViewSystemState = class("SetViewSystemState", SetViewSubPage)
local tempBGM = 1
local tempSound = 1
local tempPlot = 1
local npcVoiceTabName = {
  ZhString.SetViewSystem_VoiceToggleChinese,
  ZhString.SetViewSystem_VoiceToggleJapanese,
  ZhString.SetViewSystem_VoiceToggleKorean
}
local UISiblingIndex = {
  AudioHD,
  ShowDetailSet,
  ShowHurtNumSet,
  ShowHurtNumStyle,
  ShowOtherSet,
  MultiMountLimit,
  PushSet,
  GVoiceSet
}
local defaultVoice = 0
local voiceLabTab = {}
local voiceIndex = 1
local IconConfig = GameConfig.System.IconChange
local AudioVoiceMovingRootY = -345
local DownloadStatus = {
  Empty = 1,
  WaitDownload = 2,
  Downloading = 3,
  Over = 4
}
function SetViewSystemState:Init(initParama)
  SetViewSystemState.super.Init(self, initParama)
  self:FindObj()
  self:AddButtonEvt()
  self:AddViewEvts()
  self:Show()
end
function SetViewSystemState:FindObj()
  self.bgmSlider = self:FindGO("BgmSet/BgmSlider"):GetComponent("UISlider")
  self.soundSlider = self:FindGO("SoundSet/SoundSlider"):GetComponent("UISlider")
  self.speechTeamToggle = self:FindGO("SpeechTeamSet/SpeechTeamToggle"):GetComponent("UIToggle")
  self.speechGuildToggle = self:FindGO("SpeechGuildSet/SpeechGuildToggle"):GetComponent("UIToggle")
  self.speechChatZoneToggle = self:FindGO("SpeechChatZoneSet/SpeechChatZoneToggle"):GetComponent("UIToggle")
  self.speechPrivateChatToggle = self:FindGO("SpeechPrivateChatSet/SpeechPrivateChatToggle"):GetComponent("UIToggle")
  self.showDetailSet = self:FindGO("ShowDetailSet")
  self.showDetailToggleAll = self:FindGO("ShowDetailAll/ShowDetailToggleAll"):GetComponent("UIToggle")
  self.showDetailToggleFriend = self:FindGO("ShowDetailFriend/ShowDetailToggleFriend"):GetComponent("UIToggle")
  self.showDetailToggleClose = self:FindGO("ShowDetailClose/ShowDetailToggleClose"):GetComponent("UIToggle")
  self.showDetailSet:SetActive(false)
  self.SavingMode = self:FindGO("SavingMode")
  self.SavingModeToggle = self:FindGO("SavingMode/SavingModeToggle"):GetComponent("UIToggle")
  local l_objAudioHD = self:FindGO("AudioHD")
  self.audioRoot = l_objAudioHD
  self.audioHdBtn = self:FindGO("StartPauseBtn", l_objAudioHD)
  local l_objGridBGMBtns = self:FindGO("gridBtns_HD_BGM", l_objAudioHD)
  self.gridBGMBtns = l_objGridBGMBtns:GetComponent(UIGrid)
  self.objBtnDeleteBGM = self:FindGO("DeleteBtn", l_objGridBGMBtns)
  self.objBtnDownloadBGM = self:FindGO("StartPauseBtn", l_objGridBGMBtns)
  local l_objGridAVBtns = self:FindGO("gridBtns_HD_AV")
  self.gridAVBtns = l_objGridAVBtns:GetComponent(UIGrid)
  self.objBtnDeleteAV = self:FindGO("DeleteBtn", l_objGridAVBtns)
  self.objBtnDownloadAV = self:FindGO("AVStartPauseBtn", l_objGridAVBtns)
  self.audioDownloadLeft = self:FindGO("DownloadSizeLabel", l_objAudioHD):GetComponent("UILabel")
  self.audioDownloadHint = self:FindGO("DownloadHintLabel", l_objAudioHD):GetComponent("UILabel")
  self:InitOtherPlayerEquipHide()
  if GameObject.Find("ChineseVoice/ChineseVoiceToggle") then
    self.ChineseVoiceToggle = self:FindGO("ChineseVoice/ChineseVoiceToggle"):GetComponent("UIToggle")
    self.JapaneseVoiceToggle = self:FindGO("JapaneseVoice/JapaneseVoiceToggle"):GetComponent("UIToggle")
  end
  self.npcSoundPoplist = self:FindGO("NPCSoundPoplist"):GetComponent("UIPopupList")
  self.weddingSet = self:FindGO("WeddingSet")
  self.showWeddingToggleAll = self:FindGO("ShowWeddingToggleAll"):GetComponent(UIToggle)
  self.showWeddingToggleFriend = self:FindGO("ShowWeddingToggleFriend"):GetComponent(UIToggle)
  self.showWeddingToggleClose = self:FindGO("ShowWeddingToggleClose"):GetComponent(UIToggle)
  self.pushSet = self:FindGO("PushSet")
  self.pushGrid = self:FindGO("PushGrid"):GetComponent(UIGrid)
  self.pushToggle = {}
  self.pushToggle[0] = self:FindGO("PushPoringToggle"):GetComponent(UIToggle)
  self.pushToggle[1] = self:FindGO("PushGuildToggle"):GetComponent(UIToggle)
  self.pushToggle[2] = self:FindGO("PushAuctionToggle"):GetComponent(UIToggle)
  self.pushToggle[3] = self:FindGO("PushMonsterToggle"):GetComponent(UIToggle)
  self.pushToggle[4] = self:FindGO("PushBigCatToggle"):GetComponent(UIToggle)
  local PushAuction = self:FindGO("PushAuction")
  PushAuction:SetActive(FunctionUnLockFunc.checkFuncStateValid(121))
  local PushPoring = self:FindGO("PushPoring")
  PushPoring:SetActive(FunctionUnLockFunc.checkFuncStateValid(17))
  local PushGuild = self:FindGO("PushGuild")
  PushGuild:SetActive(FunctionUnLockFunc.checkFuncStateValid(4))
  local PushBigCat = self:FindGO("PushBigCat")
  PushBigCat:SetActive(FunctionUnLockFunc.checkFuncStateValid(3))
  self.pushGrid:Reposition()
  self.GVoiceSet = self:FindGO("GVoiceSet")
  if self.GVoiceSet then
    self.GVoiceSet.gameObject:SetActive(false)
  end
  self.TeamGVoice = self:FindGO("TeamGVoice", self.GVoiceSet)
  self.GuildGVoice = self:FindGO("GuildGVoice", self.GVoiceSet)
  self.OpenYang = self:FindGO("OpenYang", self.GVoiceSet)
  self.OpenMai = self:FindGO("OpenMai", self.GVoiceSet)
  self.OpenMai_UILabel = self:FindGO("OpenMai", self.GVoiceSet):GetComponent(UILabel)
  self.OpenMai_UILabel.text = "开启麦克风"
  self.TeamGVoiceToggle_UIToggle = self:FindGO("Toggle", self.TeamGVoice):GetComponent(UIToggle)
  self.GuildGVoiceToggle_UIToggle = self:FindGO("Toggle", self.GuildGVoice):GetComponent(UIToggle)
  self.OpenYangToggle_UIToggle = self:FindGO("Toggle", self.OpenYang):GetComponent(UIToggle)
  self.OpenMaiToggle_UIToggle = self:FindGO("Toggle", self.OpenMai):GetComponent(UIToggle)
  self.TeamGVoiceToggle_UIToggle.optionCanBeNone = true
  self.gvoiceToggle = {}
  self.gvoiceToggle[0] = self.TeamGVoiceToggle_UIToggle
  self.gvoiceToggle[1] = self.GuildGVoiceToggle_UIToggle
  self.gvoiceToggle[2] = self.OpenYangToggle_UIToggle
  self.gvoiceToggle[3] = self.OpenMaiToggle_UIToggle
  if GuildProxy.Instance:IHaveGuild() then
    self.GuildGVoice.gameObject:SetActive(true)
    self.GuildGVoiceToggle_UIToggle.group = 101
    self.TeamGVoiceToggle_UIToggle.group = 101
  end
  self.TeamGVoiceToggle_UIToggle.optionCanBeNone = true
  self.GuildGVoiceToggle_UIToggle.optionCanBeNone = true
  self.gvoiceToggle[2].group = 102
  self.gvoiceToggle[3].group = 103
  self.AutoAudio = self:FindGO("AutoAudio")
  if self.AutoAudio and ApplicationInfo.IsWindows() and GameConfig.SystemForbid.AutoPlayVoiceForWindows then
    self.AutoAudio.gameObject:SetActive(false)
  end
  self.npcSoundPoplistTempSprite = self:FindGO("NPCSoundPoplistTempSprite")
  TimeTickManager.Me():CreateOnceDelayTick(100, function(owner, deltaTime)
    self.npcSoundPoplistTempSprite:SetActive(true)
  end, self, 5)
  local skipStartCGGO = self:FindGO("SkipStartGameCG")
  if nil ~= skipStartCGGO then
    skipStartCGGO:SetActive(false)
  end
  self.objMultiMountLimit = self:FindGO("MultiMountLimit")
  self.togMultiMountTeamOnly = self:FindComponent("togTeamOnly", UIToggle, self.objMultiMountLimit)
  if GameConfig.SystemForbid.MultiMount and self.objMultiMountLimit then
    self.objMultiMountLimit:SetActive(false)
  end
  self.objVoicePartShowingSet = self:FindGO("VoicePartShowingSet")
  self.togVoicePartShowingSet = self:FindComponent("VoicePartShowingToggle", UIToggle, self.objVoicePartShowingSet)
  if GameConfig.SystemForbid.VoicePartShow and self.objVoicePartShowingSet then
    self.objVoicePartShowingSet:SetActive(false)
  end
  local mask = GameConfig.System.IconChange_Shield or 0
  self.changeAppIcon = self:FindGO("ChangeAppIcon")
  self.changeIconSP = self:FindGO("ChangeIconSP"):GetComponent(UITexture)
  local iconNumLabel = self:FindGO("IconNumLabel"):GetComponent(UILabel)
  iconNumLabel.text = string.format(ZhString.ChangeIcon_Tip, #IconConfig)
  local runtimePlatform = ApplicationInfo.GetRunPlatform()
  self.isShow = mask == 0 and runtimePlatform == RuntimePlatform.IPhonePlayer
  self.changeAppIcon:SetActive(self.isShow)
  if self.isShow then
    local iconstr = FunctionPlayerPrefs.Me():GetString(LocalSaveProxy.SAVE_KEY.ChangedAppIcon, "app_icon1")
    if not iconstr or iconstr == "" then
      iconstr = "app_icon1"
    end
    PictureManager.Instance:SetAppIcon(iconstr, self.changeIconSP)
  end
  self.plotSlider = self:FindGO("PlotSet/PlotSlider"):GetComponent("UISlider")
  self.nPCSoundToggle = self:FindGO("NPCSoundToggle"):GetComponent(UIToggle)
  self.audioVoiceExtraSet = self:FindGO("AudioVoiceExtraSet")
  self.audioVoiceBtn = self:FindGO("AVStartPauseBtn", self.audioVoiceExtraSet)
  self.audioVoiceBtnLabel = self:FindGO("AVStartPauseLabel", self.audioVoiceBtn):GetComponent("UILabel")
  self.audioVoiceBtnLabel.text = ""
  self.audioVoiceBtnIcon = self:FindGO("icon", self.audioVoiceBtn):GetComponent(UISprite)
  self.audioVoiceDownloadOverStatus = self:FindGO("DoneStatus", self.audioVoiceExtraSet)
  self.audioVoiceDownloadLeft = self:FindGO("AVDownloadSizeLabel", self.audioVoiceExtraSet):GetComponent("UILabel")
  self.audioVoiceDownloadHint = self:FindGO("AVDownloadHintLabel", self.audioVoiceExtraSet):GetComponent("UILabel")
  self.audioVoiceMovingRoot = self:FindGO("AudioVoiceMovingRoot")
  self.audioVoiceExtraSet:SetActive(false)
  local l_objVideoHD = self:FindGO("VodioHD")
  local l_objGridVideoBtns = self:FindGO("gridBtns", l_objVideoHD)
  self.gridVideoBtns = l_objGridVideoBtns:GetComponent(UIGrid)
  self.objBtnDeleteVideo = self:FindGO("DeleteBtn", l_objGridVideoBtns)
  self.objBtnDownloadVideo = self:FindGO("StartPauseBtn", l_objGridVideoBtns)
  self.mulsprBtnDownloadVideo = self:FindComponent("icon", UIMultiSprite, self.objBtnDownloadVideo)
  self.objVideoDownloadStatus = self:FindGO("DownloadStatus", l_objVideoHD)
  self.objVideoDownloadOverStatus = self:FindGO("DownloadOverStatus", l_objVideoHD)
  self.labVideoNeedDownloadSize = self:FindComponent("DownloadSizeLabel", UILabel, self.objVideoDownloadStatus)
  self.labVideoDownloadSpeed = self:FindComponent("DownloadSpeedLabel", UILabel, self.objVideoDownloadStatus)
  self.sliderVideoDownload = self:FindComponent("HDSlider", UISlider, self.objVideoDownloadStatus)
  self.table = self:FindGO("Table"):GetComponent(UITable)
  self.table.enabled = false
  self.table2 = self:FindGO("Table2"):GetComponent(UITable)
  self.table2.enabled = true
  if self:CheckIsGameLanguageSetEnable() then
  else
    self:FindGO("WhiteBg"):SetActive(false)
    self.audioVoiceExtraSet:SetActive(false)
  end
  self.bgmLabel = self:FindGO("BgmSet/BgmLabel"):GetComponent(UILabel)
  self.soundLabel = self:FindGO("SoundSet/SoundLabel"):GetComponent(UILabel)
  self.plotLabel = self:FindGO("PlotSet/PlotLabel"):GetComponent(UILabel)
  self.avSlider = self:FindGO("AVSlider"):GetComponent(UISlider)
  self.hdSlider = self:FindGO("HDSlider"):GetComponent(UISlider)
  self.showOtherSet = self:FindGO("ShowOtherSet")
  self.showHurtNumSet = self:FindGO("ShowHurtNumSet")
  self.ShowOtherNameToggle = self:FindGO("OtherNameLabel"):GetComponent(UIToggle)
  self.ShowOtherCharToggle = self:FindGO("ShowOtherCharToggle"):GetComponent(UIToggle)
  self.showAllHurtNumToggle = self:FindGO("ShowAllHurtNumToggle"):GetComponent(UIToggle)
  self.showTeamHurtNumToggle = self:FindGO("ShowTeamHurtNumToggle"):GetComponent(UIToggle)
  self.showSelfHurtNumToggle = self:FindGO("ShowSelfHurtNumToggle"):GetComponent(UIToggle)
  self.hurtNumStyleSimple = self:FindGO("HurtNumStyleSimple"):GetComponent(UIToggle)
  self.hurtNumStyleDetail = self:FindGO("HurtNumStyleDetail"):GetComponent(UIToggle)
  self.exchangeRewardSet = self:FindGO("ExchangeRewardSet")
  self.exchangeCodeLabel = self:FindComponent("input", UILabel, self.exchangeRewardSet)
  self.exchangeBtn = self:FindGO("exchangeBtn", self.exchangeRewardSet)
  if Game.inAppStoreReview then
    self.exchangeRewardSet:SetActive(false)
  elseif GameConfig.SystemForbid.GiftCode then
    self.exchangeRewardSet:SetActive(false)
  else
    self.exchangeRewardSet:SetActive(true)
  end
  self.debugInfoGO = self:FindGO("DebugInfos")
  if self.debugInfoGO then
    self.showBtnGO = self:FindGO("showButton", self.debugInfoGO)
    self:AddClickEvent(self.showBtnGO, function()
      self:ShowDebugInfo()
    end)
  end
  local timeSetParent = self:FindGO("PlayTimeSet")
  self.gameTimeSetGO = self:FindGO("GameTimeSetToggle", timeSetParent)
  self:AddClickEvent(self.gameTimeSetGO, function()
    self:UpdateGameTimeSetting(2)
  end)
  self.gameTimeSetToggle = self.gameTimeSetGO:GetComponent(UIToggle)
  self.playTimeSetGO = self:FindGO("PlayTimeSetToggle", timeSetParent)
  self:AddClickEvent(self.playTimeSetGO, function()
    self:UpdateGameTimeSetting(1)
  end)
  self.playTimeSetToggle = self.playTimeSetGO:GetComponent(UIToggle)
  local playTimeHelpBtn = self:FindGO("PlayTimeSetHelp", timeSetParent)
  self:AddClickEvent(playTimeHelpBtn, function()
    local data = Table_Help[9008]
    if data then
      TipsView.Me():ShowGeneralHelp(data.Desc)
    end
  end)
  self:InitLuckyNoftify()
end
local changeSetting = {}
local ChangeBGMVolume = function(vol, self)
  local setting = FunctionPerformanceSetting.Me()
  changeSetting.bgmVolume = vol
  setting:Apply(changeSetting)
  self.bgmLabel.text = math.floor(vol * 100) .. "%"
  EventManager.Me():PassEvent(SetViewEvent.SaveBtnStatus, self:IsChanged())
end
local ChangeSoundVolume = function(vol, self)
  local setting = FunctionPerformanceSetting.Me()
  changeSetting.soundVolume = vol
  setting:Apply(changeSetting)
  self.soundLabel.text = math.floor(vol * 100) .. "%"
  EventManager.Me():PassEvent(SetViewEvent.SaveBtnStatus, self:IsChanged())
end
local ChangePlotVolume = function(vol, self)
  local setting = FunctionPerformanceSetting.Me()
  changeSetting.plotVolume = vol
  setting:Apply(changeSetting)
  self.plotLabel.text = math.floor(vol * 100) .. "%"
  EventManager.Me():PassEvent(SetViewEvent.SaveBtnStatus, self:IsChanged())
end
local GetExterior = function()
  return FunctionPerformanceSetting.Me():GetOtherPlayerExterior()
end
function SetViewSystemState:AddButtonEvt()
  EventDelegate.Set(self.bgmSlider.onChange, function()
    ChangeBGMVolume(self.bgmSlider.value, self)
  end)
  EventDelegate.Set(self.soundSlider.onChange, function()
    ChangeSoundVolume(self.soundSlider.value, self)
  end)
  EventDelegate.Set(self.plotSlider.onChange, function()
    ChangePlotVolume(self.plotSlider.value, self)
    if not PlotAudioProxy.Instance.ManualChanged then
      self.nPCSoundToggle.value = self.plotSlider.value > 0.01
    end
    if self.plotSlider.value <= 0.01 then
      self.nPCSoundToggle.value = false
    end
    EventManager.Me():PassEvent(SetViewEvent.SaveBtnStatus, self:IsChanged())
  end)
  EventDelegate.Set(self.nPCSoundToggle.onChange, function()
    if self.nPCSoundToggle.value then
      if self.plotSlider.value < 0.01 then
        self.plotSlider.value = 1
      end
    elseif self.plotSlider.value >= 0.01 then
      PlotAudioProxy.Instance.ManualChanged = true
    end
    FunctionPlotCmd.Me():SetNpcVolumeToggle(self.nPCSoundToggle.value)
    EventManager.Me():PassEvent(SetViewEvent.SaveBtnStatus, self:IsChanged())
  end)
  EventDelegate.Add(self.ShowOtherNameToggle.onChange, function()
    EventManager.Me():PassEvent(SetViewEvent.SaveBtnStatus, self:IsChanged())
  end)
  EventDelegate.Add(self.ShowOtherCharToggle.onChange, function()
    EventManager.Me():PassEvent(SetViewEvent.SaveBtnStatus, self:IsChanged())
  end)
  EventDelegate.Add(self.showAllHurtNumToggle.onChange, function()
    EventManager.Me():PassEvent(SetViewEvent.SaveBtnStatus, self:IsChanged())
  end)
  EventDelegate.Add(self.showTeamHurtNumToggle.onChange, function()
    EventManager.Me():PassEvent(SetViewEvent.SaveBtnStatus, self:IsChanged())
  end)
  EventDelegate.Add(self.showSelfHurtNumToggle.onChange, function()
    EventManager.Me():PassEvent(SetViewEvent.SaveBtnStatus, self:IsChanged())
  end)
  EventDelegate.Add(self.hurtNumStyleSimple.onChange, function()
    EventManager.Me():PassEvent(SetViewEvent.SaveBtnStatus, self:IsChanged())
  end)
  EventDelegate.Add(self.hurtNumStyleDetail.onChange, function()
    EventManager.Me():PassEvent(SetViewEvent.SaveBtnStatus, self:IsChanged())
  end)
  EventDelegate.Add(self.speechTeamToggle.onChange, function()
    EventManager.Me():PassEvent(SetViewEvent.SaveBtnStatus, self:IsChanged())
  end)
  EventDelegate.Add(self.speechGuildToggle.onChange, function()
    EventManager.Me():PassEvent(SetViewEvent.SaveBtnStatus, self:IsChanged())
  end)
  EventDelegate.Add(self.speechChatZoneToggle.onChange, function()
    EventManager.Me():PassEvent(SetViewEvent.SaveBtnStatus, self:IsChanged())
  end)
  EventDelegate.Add(self.speechPrivateChatToggle.onChange, function()
    EventManager.Me():PassEvent(SetViewEvent.SaveBtnStatus, self:IsChanged())
  end)
  EventDelegate.Add(self.showDetailToggleAll.onChange, function()
    EventManager.Me():PassEvent(SetViewEvent.SaveBtnStatus, self:IsChanged())
  end)
  EventDelegate.Add(self.showDetailToggleFriend.onChange, function()
    EventManager.Me():PassEvent(SetViewEvent.SaveBtnStatus, self:IsChanged())
  end)
  EventDelegate.Add(self.showDetailToggleClose.onChange, function()
    EventManager.Me():PassEvent(SetViewEvent.SaveBtnStatus, self:IsChanged())
  end)
  EventDelegate.Add(self.togVoicePartShowingSet.onChange, function()
    EventManager.Me():PassEvent(SetViewEvent.SaveBtnStatus, self:IsChanged())
  end)
  if self:CheckIsGameLanguageSetEnable() then
    EventDelegate.Add(self.npcSoundPoplist.onChange, function()
      voiceIndex = voiceLabTab[self.npcSoundPoplist.value]
      self.audioVoiceExtraSet:SetActive(voiceIndex ~= defaultVoice)
      if voiceIndex ~= defaultVoice then
        TweenPosition.Begin(self.audioVoiceMovingRoot, self.OnEnterTag and self.IsSettingInited and 0.5 or 0, LuaGeometry.GetTempVector3(-13, AudioVoiceMovingRootY - 100, 0)).method = 2
      else
        TweenPosition.Begin(self.audioVoiceMovingRoot, self.OnEnterTag and self.IsSettingInited and 0.5 or 0, LuaGeometry.GetTempVector3(-13, AudioVoiceMovingRootY, 0)).method = 2
      end
      self:UpdateNpcVoiceDownloadInfo()
      EventManager.Me():PassEvent(SetViewEvent.SaveBtnStatus, self:IsChanged())
    end)
  end
  for i = 0, 4 do
    self:AddClickEvent(self.pushToggle[i].gameObject, function(obj)
      if not self.pushToggle[i].value or ExternalInterfaces.isUserNotificationEnable() then
      else
        ExternalInterfaces.ShowHintOpenPushView(ZhString.Push_title, ZhString.Push_message, ZhString.Push_cancelButtonTitle, ZhString.Push_otherButtonTitles)
        break
      end
      EventManager.Me():PassEvent(SetViewEvent.SaveBtnStatus, self:IsChanged())
    end)
    break
  end
  self:AddClickEvent(self.TeamGVoiceToggle_UIToggle.gameObject, function(obj)
    if self.TeamGVoiceToggle_UIToggle.value then
      GVoiceProxy.Instance:ActiveEnterChannel(ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_TEAM_ENUM.index)
      if self.GuildGVoiceToggle_UIToggle.value then
        self.GuildGVoiceToggle_UIToggle.value = false
        GVoiceProxy.Instance:LeaveGVoiceRoomAtChannel(ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_GUILD_ENUM.index)
      end
    else
      GVoiceProxy.Instance:LeaveGVoiceRoomAtChannel(ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_TEAM_ENUM.index)
    end
    EventManager.Me():PassEvent(SetViewEvent.SaveBtnStatus, self:IsChanged())
  end)
  self:AddClickEvent(self.GuildGVoiceToggle_UIToggle.gameObject, function(obj)
    if self.GuildGVoiceToggle_UIToggle.value then
      if not GVoiceProxy.Instance:IsMySelfGongHuiJinYan() then
        GVoiceProxy.Instance:SetPlayerChooseToJoinGuildVoice(true)
        GVoiceProxy.Instance:ActiveEnterChannel(ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_GUILD_ENUM.index)
      else
        MsgManager.FloatMsg(nil, "当前已经被会长禁言，无法开启麦克风")
      end
      if self.TeamGVoiceToggle_UIToggle.value then
        self.TeamGVoiceToggle_UIToggle = false
        GVoiceProxy.Instance:LeaveGVoiceRoomAtChannel(ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_TEAM_ENUM.index)
      end
    else
      GVoiceProxy.Instance:LeaveGVoiceRoomAtChannel(ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_GUILD_ENUM.index)
    end
    EventManager.Me():PassEvent(SetViewEvent.SaveBtnStatus, self:IsChanged())
  end)
  self:AddClickEvent(self.OpenYangToggle_UIToggle.gameObject, function(obj)
    if self.OpenYangToggle_UIToggle.value then
    else
      self.OpenMaiToggle_UIToggle.value = false
    end
    EventManager.Me():PassEvent(SetViewEvent.SaveBtnStatus, self:IsChanged())
  end)
  self:AddClickEvent(self.OpenMaiToggle_UIToggle.gameObject, function(obj)
    if GVoiceProxy.Instance:IsMySelfGongHuiJinYan() then
      MsgManager.FloatMsg(nil, "当前已经被会长禁言，无法开启麦克风")
      self.OpenMaiToggle_UIToggle.value = false
      return
    end
    if self.OpenMaiToggle_UIToggle.value then
    else
    end
    EventManager.Me():PassEvent(SetViewEvent.SaveBtnStatus, self:IsChanged())
  end)
  self:AddClickEvent(self.audioHdBtn, function(obj)
    if self.audioHD.status ~= AudioHD_Status.E_Done then
      local btnIcon = self:FindGO("icon", self.audioHdBtn):GetComponent(UISprite)
      local state = self.audioHD:SwitchHDDownload()
      if state == AudioBtn_Status.E_NewUpdate or state == AudioBtn_Status.E_Resume then
        btnIcon.spriteName = "set_icon_04"
      elseif state == AudioBtn_Status.E_Pause then
        btnIcon.spriteName = "set_icon_03"
      end
    end
  end)
  self:AddClickEvent(self.audioVoiceBtn, function(obj)
    local audioDownloader = self:GetNpcVoiceDownloader()
    if audioDownloader and audioDownloader.status ~= AudioHD_Status.E_Done then
      local state = audioDownloader:SwitchHDDownload()
      if state == AudioBtn_Status.E_NewUpdate or state == AudioBtn_Status.E_Resume then
        self.audioVoiceBtnIcon.spriteName = "set_icon_04"
      elseif state == AudioBtn_Status.E_Pause then
        self.audioVoiceBtnIcon.spriteName = "set_icon_03"
      end
    end
    EventManager.Me():PassEvent(SetViewEvent.SaveBtnStatus, self:IsChanged())
  end)
  local changeIconBtn = self:FindGO("ChangeIconBtn")
  self:AddClickEvent(changeIconBtn, function()
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.ChangeIconPopup
    })
    EventManager.Me():PassEvent(SetViewEvent.SaveBtnStatus, self:IsChanged())
  end)
  self.changeIconSP = self:FindGO("ChangeIconSP"):GetComponent(UITexture)
  local iconNumLabel = self:FindGO("IconNumLabel"):GetComponent(UILabel)
  iconNumLabel.text = string.format(ZhString.ChangeIcon_Tip, #IconConfig)
  EventDelegate.Add(self.togMultiMountTeamOnly.onChange, function()
    EventManager.Me():PassEvent(SetViewEvent.SaveBtnStatus, self:IsChanged())
  end)
  local iconNumLabel = self:FindGO("IconNumLabel"):GetComponent(UILabel)
  iconNumLabel.text = string.format(ZhString.ChangeIcon_Tip, #IconConfig)
  self:AddClickEvent(self.objBtnDownloadVideo, function()
    self:ClickDownloadAllVideo()
  end)
  self:AddClickEvent(self.objBtnDeleteVideo, function()
    MsgManager.ConfirmMsgByID(41360, function()
      self:DeleteAllLocalVideo()
    end, nil, nil)
  end)
  self:AddClickEvent(self.objBtnDeleteBGM, function()
    MsgManager.ConfirmMsgByID(41360, function()
      self:DeleteAllLocalBGM()
    end, nil, nil)
  end)
  self:AddClickEvent(self.objBtnDeleteAV, function()
    MsgManager.ConfirmMsgByID(41360, function()
      self:DeleteAllLocalAV()
    end, nil, nil)
  end)
  self:AddClickEvent(self.exchangeBtn, function()
    self:OnExchangeBtnClick()
  end)
  local showHurtNumHelp = self:FindGO("ShowHurtNumHelp")
  self:AddClickEvent(showHurtNumHelp, function()
    local data = Table_Help[650]
    if data then
      TipsView.Me():ShowGeneralHelp(data.Desc)
    end
  end)
  if self.walkAroundTog then
    EventDelegate.Add(self.walkAroundTog.onChange, function()
      self.walkAroundToggleTween:Play(not self.walkAroundTog.value)
      EventManager.Me():PassEvent(SetViewEvent.SaveBtnStatus, self:IsChanged())
    end)
    local walkAroundHelp = self:FindGO("WalkAroundHelp")
    self:AddClickEvent(walkAroundHelp, function()
      local data = Table_Help[9010]
      if data then
        TipsView.Me():ShowGeneralHelp(data.Desc)
      end
    end)
  end
end
function SetViewSystemState:AddViewEvts()
  self:AddListenEvt(ServiceEvent.SceneUser3BattleTimeCostSelectCmd, self.UpdateGameTimeSetting)
  self:AddListenEvt(PushEvent.OnJPushTagOperateResult, self.HandleJPushTagOperateResult)
  self:AddListenEvt(AudioHDEvent.OnReceiveAudioLabel1, self.HandleReceiveAudioHint1)
  self:AddListenEvt(AudioHDEvent.OnReceiveAudioLabel2, self.HandleReceiveAudioHint2)
  self:AddListenEvt(AudioHDEvent.OnReceiveAudioBtn3, self.HandleReceiveAudioBtn3)
  if self:CheckIsGameLanguageSetEnable() then
    self:AddListenEvt(AudioPackageDownloadEvent.OnInfoUpdate, self.HandleNpcVoiceDownloadUpdate)
  end
  EventManager.Me():AddEventListener(SetViewEvent.ChangeAppIcon, self.UpdateAppIcon, self)
end
function SetViewSystemState:CheckIsGameLanguageSetEnable()
  if self.isGameLanguageSetEnable == nil then
    self.isGameLanguageSetEnable = true
    local pageConfig = UnionConfig and UnionConfig.SetViewPages and UnionConfig.SetViewPages[self.__cname]
    pageConfig = pageConfig or GameConfig.SetViewPages and GameConfig.SetViewPages[self.__cname]
    if pageConfig and type(pageConfig) == "table" and next(pageConfig) and pageConfig.GameLanguageSet ~= nil then
      self.isGameLanguageSetEnable = pageConfig.GameLanguageSet
    end
  end
  return self.isGameLanguageSetEnable
end
function SetViewSystemState:InitOtherPlayerEquipHide()
  local showExteriorGO = self:FindGO("ShowExterior")
  self.ShowExteriorMoveRoot = self:FindGO("ShowExteriorMoveRoot", showExteriorGO)
  self.table3 = self:FindComponent("Table3", UITable, self.ShowExteriorMoveRoot)
  self.showExteriorTipGO = self:FindGO("ShowExteriorTip", showExteriorGO)
  self.showExteriorTipLab = self:FindComponent("TipLab", UILabel, self.showExteriorTipGO)
  self.showExteriorTipLab.text = ZhString.SetView_OtherPlayerEquipHide_Tip
  self.exteriorGrid = self:FindGO("Grid", self.table3.gameObject)
  self.walkAroundLab = self:FindComponent("WalkAroundLab", UILabel, showExteriorGO)
  if self.walkAroundLab then
    self.walkAroundLab.text = ZhString.SetView_WalkAround
    self.walkAroundTog = self:FindComponent("WalkAroundTog", UIToggle, showExteriorGO)
    self.walkAroundToggleTween = self.walkAroundTog:GetComponent(UIPlayTween)
    if BranchMgr.IsJapan() or BranchMgr.IsSEA() or BranchMgr.IsNA() or BranchMgr.IsEU() then
      self.walkAroundLab.gameObject:SetActive(false)
    end
  end
  local otherPlayerEquipHideLab = self:FindComponent("OtherPlayerEquipHideLab", UILabel, showExteriorGO)
  local otherPlayerBodyHideLab = self:FindComponent("OtherPlayerBodyHideLab", UILabel, showExteriorGO)
  local otherPlayerHeadHideLab = self:FindComponent("OtherPlayerHeadHideLab", UILabel, showExteriorGO)
  local otherPlayerFaceHideLab = self:FindComponent("OtherPlayerFaceHideLab", UILabel, showExteriorGO)
  local otherPlayerMouthHideLab = self:FindComponent("OtherPlayerMouthHideLab", UILabel, showExteriorGO)
  local otherPlayerWingHideLab = self:FindComponent("OtherPlayerWingHideLab", UILabel, showExteriorGO)
  local otherPlayerTailHideLab = self:FindComponent("OtherPlayerTailHideLab", UILabel, showExteriorGO)
  otherPlayerEquipHideLab.text = ZhString.SetView_OtherPlayerEquipHide_Title
  otherPlayerBodyHideLab.text = ZhString.SetView_OtherPlayerEquipHide_Body
  otherPlayerHeadHideLab.text = ZhString.SetView_OtherPlayerEquipHide_Head
  otherPlayerFaceHideLab.text = ZhString.SetView_OtherPlayerEquipHide_Face
  otherPlayerMouthHideLab.text = ZhString.SetView_OtherPlayerEquipHide_Mouth
  otherPlayerWingHideLab.text = ZhString.SetView_OtherPlayerEquipHide_Wing
  otherPlayerTailHideLab.text = ZhString.SetView_OtherPlayerEquipHide_Tail
  self.showExteriorTogs = {}
  self.otherPlayerEquipHideGO = self:FindGO("OtherPlayerEquipHide", self.objPersonalRoot)
  self.showExteriorTog = self:FindComponent("OtherPlayerEquipHideTog", UIToggle, showExteriorGO)
  self.showExteriorArrow = self:FindGO("Sprite", self.showExteriorTog.gameObject)
  self.showExteriorTogs[0] = self:FindComponent("OtherPlayerBodyHideTog", UIToggle, showExteriorGO)
  self.showExteriorTogs[1] = self:FindComponent("OtherPlayerHeadHideTog", UIToggle, showExteriorGO)
  self.showExteriorTogs[2] = self:FindComponent("OtherPlayerFaceHideTog", UIToggle, showExteriorGO)
  self.showExteriorTogs[3] = self:FindComponent("OtherPlayerMouthHideTog", UIToggle, showExteriorGO)
  self.showExteriorTogs[4] = self:FindComponent("OtherPlayerWingHideTog", UIToggle, showExteriorGO)
  self.showExteriorTogs[5] = self:FindComponent("OtherPlayerTailHideTog", UIToggle, showExteriorGO)
  for i = 0, 5 do
    self:AddClickEvent(self.showExteriorTogs[i].gameObject, function(obj)
      local _active = self:GetEquipHideWhenSaving() ~= 0
      if self.showExteriorTog.value ~= _active then
        self.showExteriorTog.value = _active
        local xAxisPos = _active and 70 or 37
        TweenPosition.Begin(self.showExteriorArrow, 0.05, LuaGeometry.GetTempVector3(xAxisPos, -1, 0)).method = 2
        if not _active then
          TimeTickManager.Me():CreateOnceDelayTick(200, function()
            self:ResetExterPosition(false, true)
          end, self, i + 10)
        end
      end
      EventManager.Me():PassEvent(SetViewEvent.SaveBtnStatus, self:IsChanged())
    end)
    break
  end
  self:AddClickEvent(self.showExteriorTog.gameObject, function(obj)
    local showExteriorTogOn = self.showExteriorTog.value
    TimeTickManager.Me():CreateOnceDelayTick(200, function()
      self:ResetExterPosition(showExteriorTogOn)
      for i = 0, 5 do
        self.showExteriorTogs[i].value = showExteriorTogOn
      end
      EventManager.Me():PassEvent(SetViewEvent.SaveBtnStatus, self:IsChanged())
    end, self, 9)
  end)
end
function SetViewSystemState:InitLuckyNoftify()
  local luckyNotifyGO = self:FindGO("LuckyNotifySet")
  local luckyNotifyLab = luckyNotifyGO:GetComponent(UILabel)
  luckyNotifyLab.text = ZhString.SetView_LuckyNotify
  local setting = FunctionPerformanceSetting.Me()
  self.luckyNotify = setting.setting.luckyNotify
  self.luckyNotifyBtn = self:FindGO("Background", luckyNotifyGO)
  self:AddClickEvent(self.luckyNotifyBtn, function()
    local isUseTween = self.OnEnterTag and self.IsSettingInited
    local luckyNotifySprt = self:FindGO("Img", self.luckyNotifyGO)
    local cover = self:FindGO("Cover", self.luckyNotifyGO)
    self.luckyNotify = not self.luckyNotify
    if self.luckyNotify then
      if nil ~= cover then
        cover:SetActive(false)
      end
      TweenPosition.Begin(luckyNotifySprt, isUseTween and 0.05 or 0, LuaGeometry.GetTempVector3(22, 0, 0)).method = 2
    else
      if nil ~= cover then
        cover:SetActive(true)
      end
      TweenPosition.Begin(luckyNotifySprt, isUseTween and 0.05 or 0, LuaGeometry.GetTempVector3(-22, 0, 0)).method = 2
    end
    EventManager.Me():PassEvent(SetViewEvent.SaveBtnStatus, self:IsChanged())
  end)
  local luckyNotifySprt = self:FindGO("Img", self.luckyNotifyGO)
  local cover = self:FindGO("Cover", self.luckyNotifyGO)
  if self.luckyNotify then
    if nil ~= cover then
      cover:SetActive(false)
    end
    TweenPosition.Begin(luckyNotifySprt, 0, LuaGeometry.GetTempVector3(22, 0, 0)).method = 2
  else
    if nil ~= cover then
      cover:SetActive(true)
    end
    TweenPosition.Begin(luckyNotifySprt, 0, LuaGeometry.GetTempVector3(-22, 0, 0)).method = 2
  end
  if GameConfig.System.lucky_guy_notify_open then
    luckyNotifyGO:SetActive(true)
  else
    luckyNotifyGO:SetActive(false)
  end
end
function SetViewSystemState:Show()
  self.IsSettingInited = false
  local setting = FunctionPerformanceSetting.Me()
  self.npcSoundPoplist:Clear()
  voiceLabTab = {}
  if not GameConfig.SEBranchSetting or not GameConfig.SEBranchSetting.Order then
    local voiceCfg = {1, 2}
  end
  defaultVoice = voiceCfg[1]
  for i = 1, #voiceCfg do
    local langIdx = voiceCfg[i]
    local str = npcVoiceTabName[langIdx]
    self.npcSoundPoplist:AddItem(str)
    voiceLabTab[str] = langIdx
  end
  self.bgmSlider.value = setting:GetSetting().bgmVolume
  tempBGM = setting:GetSetting().bgmVolume
  self.soundSlider.value = setting:GetSetting().soundVolume
  tempSound = setting:GetSetting().soundVolume
  self.plotSlider.value = setting:GetSetting().plotVolume
  tempPlot = setting:GetSetting().plotVolume
  self.speechTeamToggle.value = setting:IsAutoPlayChatChannel(ChatChannelEnum.Team)
  self.speechGuildToggle.value = setting:IsAutoPlayChatChannel(ChatChannelEnum.Guild)
  self.speechChatZoneToggle.value = setting:IsAutoPlayChatChannel(ChatChannelEnum.Zone)
  self.speechPrivateChatToggle.value = setting:IsAutoPlayChatChannel(ChatChannelEnum.Private)
  self.npcSoundPoplist.value = npcVoiceTabName[setting:GetSetting().voiceLanguage]
  local showDetail = MyselfProxy.Instance:GetQueryType()
  if showDetail == SettingEnum.ShowDetailFriend then
    self.showDetailToggleFriend.value = true
    self.showDetailToggleClose.value = false
    self.showDetailToggleAll.value = false
  elseif showDetail == SettingEnum.ShowDetailClose then
    self.showDetailToggleFriend.value = false
    self.showDetailToggleClose.value = true
    self.showDetailToggleAll.value = false
  else
    self.showDetailToggleFriend.value = false
    self.showDetailToggleClose.value = false
    self.showDetailToggleAll.value = true
  end
  local equipHide = GetExterior()
  local anyEquipHide = equipHide > 0
  self.showExteriorTog.value = anyEquipHide
  for i = 0, #self.showExteriorTogs do
    self.showExteriorTogs[i].value = not self:GetBitByInt(equipHide, i)
  end
  TimeTickManager.Me():CreateOnceDelayTick(200, function()
    self:ResetExterPosition(anyEquipHide)
  end, self, 16)
  if BackwardCompatibilityUtil.CompatibilityMode_V19 or ApplicationInfo.IsRunOnWindowns() then
    self.pushSet:SetActive(false)
  else
    self.pushSet:SetActive(true)
    local push = setting:GetSetting().push
    for i = 0, #self.pushToggle do
      self.pushToggle[i].value = self:GetBitByInt(push, i)
    end
  end
  if ExternalInterfaces.isUserNotificationEnable() then
  elseif ApplicationInfo.GetRunPlatform() == RuntimePlatform.Android then
  else
    for i = 0, 4 do
      self.pushToggle[i].value = false
    end
  end
  self.nPCSoundToggle.value = setting:GetSetting().plotVolumeToggle
  local myMultiMountOpt = Game.Myself.data.userdata:Get(UDEnum.MULTIMOUNT_OPT) or 0
  if 0 < myMultiMountOpt & SettingEnum.MultiMountTeam then
    self.togMultiMountTeamOnly.value = true
  else
    self.togMultiMountTeamOnly.value = false
  end
  self.ShowOtherNameToggle.value = not setting:GetSetting().isShowOtherName
  self.ShowOtherCharToggle.value = not setting:GetSetting().showOtherChar
  local showHurtNum = setting:GetSetting().showHurtNum
  self.showAllHurtNumToggle.value = showHurtNum == ShowHurtNum.All
  self.showTeamHurtNumToggle.value = showHurtNum == ShowHurtNum.Team
  self.showSelfHurtNumToggle.value = showHurtNum == ShowHurtNum.Self
  local hurtNumStyleDetail = setting:GetSetting().hurtNumStyleDetail
  self.hurtNumStyleDetail.value = hurtNumStyleDetail and true or false
  self.hurtNumStyleSimple.value = not self.hurtNumStyleDetail.value
  self.togVoicePartShowingSet.value = setting:GetSetting().voicePartShowing and true or false
  if self.isGameLanguageSetEnable then
    self.audioVoiceMovingRoot:SetActive(false)
    TimeTickManager.Me():CreateOnceDelayTick(100, function(owner, deltaTime)
      if voiceIndex ~= defaultVoice then
        self.audioVoiceMovingRoot.transform.localPosition = LuaGeometry.GetTempVector3(-13, AudioVoiceMovingRootY - 100, 0)
      else
        self.audioVoiceMovingRoot.transform.localPosition = LuaGeometry.GetTempVector3(-13, AudioVoiceMovingRootY, 0)
      end
      self.audioVoiceMovingRoot:SetActive(true)
      self.table2.enabled = true
      self.table2:Reposition()
      self.table.enabled = true
      self.table:Reposition()
    end, self, 6)
  else
    self.table2.enabled = true
    self.table2:Reposition()
    TimeTickManager.Me():CreateOnceDelayTick(100, function(owner, deltaTime)
      self.table.enabled = true
      self.table:Reposition()
    end, self, 7)
  end
  TimeTickManager.Me():CreateOnceDelayTick(100, function()
    if self.hdSlider then
      self.hdSlider.value = self.audioHD ~= nil and self.audioHD:GetPercent() or 0
    end
  end, self, 8)
  if self.walkAroundTog then
    self.walkAroundTog.value = not not setting:GetSetting().walkaround
  end
  self.IsSettingInited = true
end
function SetViewSystemState:ResetExterPosition(active, ignoreTweenArrow)
  self.exteriorGrid:SetActive(active)
  self.showExteriorTipGO:SetActive(active)
  if not ignoreTweenArrow then
    local arrowXAxisPos = active and 70 or 37
    TweenPosition.Begin(self.showExteriorArrow, 0.05, LuaGeometry.GetTempVector3(arrowXAxisPos, -1, 0)).method = 2
  end
  self.table3.enabled = true
  self.table3:Reposition()
end
function SetViewSystemState:Save()
  local speech = {}
  if self.AutoAudio.activeInHierarchy then
    if self.speechTeamToggle.value then
      table.insert(speech, ChatChannelEnum.Team)
    end
    if self.speechGuildToggle.value then
      table.insert(speech, ChatChannelEnum.Guild)
    end
    if self.speechChatZoneToggle.value then
      table.insert(speech, ChatChannelEnum.Zone)
    end
    if self.speechPrivateChatToggle.value then
      table.insert(speech, ChatChannelEnum.Private)
    end
  end
  local showDetail = 0
  if self.showDetailToggleAll.value then
    showDetail = SettingEnum.ShowDetailAll
  elseif self.showDetailToggleFriend.value then
    showDetail = SettingEnum.ShowDetailFriend
  elseif self.showDetailToggleClose.value then
    showDetail = SettingEnum.ShowDetailClose
  end
  local showWedding = 0
  if self.showWeddingToggleAll.value then
    showWedding = SettingEnum.ShowWeddingAll
  elseif self.showWeddingToggleFriend.value then
    showWedding = SettingEnum.ShowWeddingFriend
  elseif self.showWeddingToggleClose.value then
    showWedding = SettingEnum.ShowWeddingClose
  end
  tempBGM = self.bgmSlider.value
  tempSound = self.soundSlider.value
  local setting = FunctionPerformanceSetting.Me()
  setting:SetBegin()
  setting:SetBgmVolume(self.bgmSlider.value)
  setting:SetSoundVolume(self.soundSlider.value)
  setting:SetAutoPlayChatChannel(speech)
  setting:SetShowDetail(showDetail)
  setting:SetShowWedding(showWedding)
  setting:SetVoiceLanguage(voiceIndex)
  setting:SetOtherPlayerExterior(self:GetEquipHideWhenSaving())
  setting:SetPush(self:SetPush())
  setting:SetGVoice(self:SetGVoice())
  setting:SetPlotVolume(self.plotSlider.value)
  setting:SetPlotVolumeToggle(self.nPCSoundToggle.value)
  setting:SetShowOtherName(not self.ShowOtherNameToggle.value)
  setting:SetShowOtherChar(not self.ShowOtherCharToggle.value)
  local showHurtNum = ShowHurtNum.All
  if self.showTeamHurtNumToggle.value then
    showHurtNum = ShowHurtNum.Team
  elseif self.showSelfHurtNumToggle.value then
    showHurtNum = ShowHurtNum.Self
  end
  setting:SetShowHurtNum(showHurtNum)
  setting:SetHurtNumStyleDetail(self.hurtNumStyleDetail.value)
  setting:SetVoicePartShowing(self.togVoicePartShowingSet.value)
  setting:SetMultiMount(self.togMultiMountTeamOnly.value)
  if self.walkAroundTog then
    setting:SetWalkAround(self.walkAroundTog.value)
  end
  setting:SetLuckyNotify(self.luckyNotify)
  setting:SetEnd()
  local iconstr = FunctionPlayerPrefs.Me():GetString(LocalSaveProxy.SAVE_KEY.ChangedAppIcon, IconConfig[1])
  if not iconstr or iconstr == "" then
    iconstr = IconConfig[1]
  end
  PictureManager.Instance:SetAppIcon(iconstr, self.changeIconSP)
  local newMountOpt = 0
  if self.togMultiMountTeamOnly.value == true then
    newMountOpt = SettingEnum.MultiMountTeam
  end
  if newMountOpt ~= (Game.Myself.data.userdata:Get(UDEnum.MULTIMOUNT_OPT) or 0) then
    ServiceNUserProxy.Instance:CallSetMultiMountOptUserCmd(newMountOpt)
  end
end
function SetViewSystemState:GetLockCameraCtl()
  return self.lockCameraCtlToggle.value
end
function SetViewSystemState:GetEquipHideWhenSaving()
  local equipHide = 0
  for i = 0, #self.showExteriorTogs do
    equipHide = self:GetIntByBit(equipHide, i, self.showExteriorTogs[i].value)
  end
  return equipHide
end
function SetViewSystemState:SetPush()
  local push = 0
  for i = 0, #self.pushToggle do
    push = self:GetIntByBit(push, i, not self.pushToggle[i].value)
  end
  return push
end
function SetViewSystemState:SetGVoice()
  local gvoice = 0
  for i = 0, #self.gvoiceToggle do
    gvoice = self:GetIntByBit(gvoice, i, not self.gvoiceToggle[i].value)
  end
  return gvoice
end
function SetViewSystemState:GetBitByInt(num, index)
  return num >> index & 1 == 0
end
function SetViewSystemState:GetIntByBit(num, index, b)
  if b then
    num = num + (1 << index)
  end
  return num
end
function SetViewSystemState:HandleJPushTagOperateResult(note)
  local data = note.body
  if data then
  end
end
function SetViewSystemState:HandleReceiveAudioHint1(note)
  if note and note.body then
    self.audioDownloadLeft.text = note.body.info
    if self.hdSlider then
      self.hdSlider.value = self.audioHD:GetPercent()
    end
    self:RefreshBGMDownloadStatus()
  end
end
function SetViewSystemState:HandleReceiveAudioHint2(note)
  if note and note.body then
    self.audioDownloadHint.text = note.body.info
    if self.audioHD.status == AudioHD_Status.E_Done then
      local done = self:FindGO("DoneStatus", self.audioRoot)
      done.gameObject:SetActive(true)
      self.hdSlider.gameObject:SetActive(false)
      self.audioDownloadHint.gameObject:SetActive(false)
      self.audioDownloadLeft.gameObject:SetActive(false)
    else
      local done = self:FindGO("DoneStatus", self.audioRoot)
      done.gameObject:SetActive(false)
      self.hdSlider.gameObject:SetActive(true)
      self.audioDownloadHint.gameObject:SetActive(true)
      self.audioDownloadLeft.gameObject:SetActive(true)
    end
  end
end
function SetViewSystemState:HandleReceiveAudioBtn3(note)
  self:RefreshBGMBtn()
  if not note or note.body then
  end
end
function SetViewSystemState:HandleJPushTagOperateResult(note)
  local data = note.body
  if data then
  end
end
function SetViewSystemState:RefreshBGMBtn()
  local btnIcon = self:FindGO("icon", self.audioHdBtn):GetComponent(UISprite)
  local state = self.audioHD.btnStatus
  if state == AudioBtn_Status.E_NewUpdate then
    btnIcon.spriteName = "set_icon_04"
  elseif state == AudioBtn_Status.E_Pause then
    btnIcon.spriteName = "set_icon_03"
  elseif state == AudioBtn_Status.E_Resume then
    btnIcon.spriteName = "set_icon_04"
  end
end
function SetViewSystemState:RefreshAVBtn()
  local btnIcon = self:FindGO("icon", self.audioVoiceBtn):GetComponent(UISprite)
  local state = self.audioDownloader.btnStatus
  if state == AudioBtn_Status.E_NewUpdate then
    btnIcon.spriteName = "set_icon_04"
  elseif state == AudioBtn_Status.E_Pause then
    btnIcon.spriteName = "set_icon_03"
  elseif state == AudioBtn_Status.E_Resume then
    btnIcon.spriteName = "set_icon_04"
  end
end
function SetViewSystemState:OnEnter()
  self.super.OnEnter(self)
  self.OnEnterTag = true
  if self.audioHD then
    self.audioHD:Destroy()
    self.audioHD = nil
  end
  self.audioHD = AudioHD.new()
  self.audioHD:InitInfo()
  self:RefreshBGMDownloadStatus()
  self:StartRefreshVideoDownloadStatus()
  self:UpdateGameTimeSetting()
end
function SetViewSystemState:OnExit()
  ChangeBGMVolume(tempBGM, self)
  ChangeSoundVolume(tempSound, self)
  ChangePlotVolume(self.plotSlider.value, self)
  self.OnEnterTag = false
  self.super.OnExit(self)
  self.bgmSlider = nil
  self.soundSlider = nil
  self.npcSoundPoplist = nil
  self.audioHD:Destroy()
  self.audioHD = nil
  self.plotSlider = nil
  TimeTickManager.Me():ClearTick(self)
end
function SetViewSystemState:GetNpcVoiceDownloader(branch)
  branch = branch or voiceIndex
  if branch == defaultVoice then
    return
  end
  self.avBranch = branch
  redlog(tostring(branch))
  self.audioDownloader = AudioPackageDownloaderHolder.Ins():GetNpcVoiceDownloader(branch)
  return self.audioDownloader
end
function SetViewSystemState:UpdateNpcVoiceDownloadInfo(branch)
  branch = branch or voiceIndex
  if branch == defaultVoice then
    return
  end
  local audioDownloader = self:GetNpcVoiceDownloader(branch)
  if audioDownloader then
    local dlStatus = audioDownloader.status
    local btnStatus = audioDownloader.btnStatus
    local delta = audioDownloader.totalSize - audioDownloader.finishSize
    if btnStatus == AudioBtn_Status.E_Resume then
      self.audioVoiceDownloadLeft.text = string.format(ZhString.AudioHD_inProgress, StringUtil.ConvertFileSizeString(delta))
      self.audioVoiceDownloadHint.text = ZhString.AudioHD_ingResume
      self.audioVoiceBtnLabel.text = ZhString.AudioHD_resume
      self.audioVoiceBtnIcon.spriteName = "set_icon_04"
    elseif btnStatus == AudioBtn_Status.E_Pause then
      self.audioVoiceDownloadLeft.text = string.format(ZhString.AudioHD_inProgress, StringUtil.ConvertFileSizeString(delta))
      self.audioVoiceDownloadHint.text = string.format(ZhString.AudioHD_progressSpeed, StringUtil.ConvertFileSizeString(audioDownloader.speed)) .. "/s"
      self.audioVoiceBtnLabel.text = ZhString.AudioHD_pause
      self.audioVoiceBtnIcon.spriteName = "set_icon_03"
    elseif btnStatus == AudioBtn_Status.E_NewUpdate then
      self.audioVoiceDownloadLeft.text = string.format(ZhString.AudioHD_inProgress, StringUtil.ConvertFileSizeString(delta))
      self.audioVoiceBtnLabel.text = ZhString.AudioHD_start
      self.audioVoiceBtnIcon.spriteName = "set_icon_04"
    else
      self.audioVoiceDownloadLeft.text = string.format(ZhString.AudioHD_inProgress, StringUtil.ConvertFileSizeString(delta))
      self.audioVoiceBtnLabel.text = ZhString.AudioHD_start
      self.audioVoiceBtnIcon.spriteName = "set_icon_04"
    end
    if dlStatus == AudioHD_Status.E_Done then
      self.audioVoiceDownloadHint.text = ZhString.AudioHD_allDone
      self.audioVoiceBtnLabel.text = ZhString.AudioHD_done
      self.audioVoiceBtn.gameObject:SetActive(false)
      self.audioVoiceDownloadOverStatus:SetActive(true)
      self.audioVoiceDownloadLeft.gameObject:SetActive(false)
      self.avSlider.gameObject:SetActive(false)
    else
      self.audioVoiceBtn.gameObject:SetActive(true)
      self.audioVoiceDownloadOverStatus:SetActive(false)
      self.audioVoiceDownloadLeft.gameObject:SetActive(true)
      self.avSlider.gameObject:SetActive(true)
      self.avSlider.value = audioDownloader:GetPercent()
    end
  end
  self:RefreshAVDownloadStatus()
end
function SetViewSystemState:HandleNpcVoiceDownloadUpdate(data)
  local note = data.body
  if note.tag == "setview_npcvoice" and note.branch_id == voiceIndex then
    self:UpdateNpcVoiceDownloadInfo()
    if note.hint then
      self.audioVoiceDownloadHint.text = note.hint
    end
    if note.left then
      self.audioVoiceDownloadLeft.text = note.hint
    end
    if note.btn then
      self.audioVoiceBtnLabel.text = note.btn
    end
    if note.finishPercent and self.avSlider then
      self.avSlider.value = note.finishPercent
    end
  end
end
function SetViewSystemState:UpdateAppIcon()
  if self.isShow then
    local iconstr = FunctionPlayerPrefs.Me():GetString(LocalSaveProxy.SAVE_KEY.ChangedAppIcon, "APP_ICON")
    if not iconstr or iconstr == "" then
      iconstr = "APP_ICON"
    end
    PictureManager.Instance:SetAppIcon(iconstr, self.changeIconSP)
  end
end
function SetViewSystemState:RefreshVideoDownloadStatus()
  if FunctionVideoStorage == nil then
    return
  end
  local alreadyDownloadSize, totalSize, downloadSpeed = FunctionVideoStorage.Me():GetDownloadInfo()
  local curDownloadStatus = DownloadStatus.Empty
  if FunctionVideoStorage.Me():IsDownloadingAllVideo() then
    curDownloadStatus = DownloadStatus.Downloading
  elseif alreadyDownloadSize <= 0 and totalSize > 0 then
    curDownloadStatus = DownloadStatus.Empty
  elseif alreadyDownloadSize < totalSize then
    curDownloadStatus = DownloadStatus.WaitDownload
  else
    curDownloadStatus = DownloadStatus.Over
  end
  if curDownloadStatus ~= self.curVideoDownloadStatus then
    self.curVideoDownloadStatus = curDownloadStatus
    self.objBtnDeleteVideo:SetActive(curDownloadStatus ~= DownloadStatus.Empty)
    self.objBtnDownloadVideo:SetActive(curDownloadStatus ~= DownloadStatus.Over)
    self.gridVideoBtns:Reposition()
    self.mulsprBtnDownloadVideo.CurrentState = curDownloadStatus == DownloadStatus.Downloading and 1 or 0
    self.objVideoDownloadStatus:SetActive(curDownloadStatus ~= DownloadStatus.Over)
    self.objVideoDownloadOverStatus:SetActive(curDownloadStatus == DownloadStatus.Over)
    if curDownloadStatus ~= DownloadStatus.Downloading then
      TimeTickManager.Me():ClearTick(self, 2)
    end
    self.gridVideoBtns:Reposition()
  end
  if curDownloadStatus ~= DownloadStatus.Over then
    self.labVideoNeedDownloadSize.text = string.format(ZhString.DownloadTip_Left, (totalSize - alreadyDownloadSize) / 1024)
    self.labVideoDownloadSpeed.text = downloadSpeed and string.format(ZhString.DownloadTip_SimpleSpeed, downloadSpeed / 1024) or ""
    self.sliderVideoDownload.value = alreadyDownloadSize / totalSize
  end
end
function SetViewSystemState:CallGameTimeSetting(index)
  ServiceSceneUser3Proxy.Instance:CallBattleTimeCostSelectCmd(index)
end
function SetViewSystemState:UpdateGameTimeSetting(gameTimeSetting)
  if type(gameTimeSetting) ~= "number" then
    gameTimeSetting = ExpRaidProxy.Instance:GetGameTimeSetting()
  end
  self.gameTimeSetting = gameTimeSetting
  self.gameTimeSetToggle.value = gameTimeSetting == 2
  self.playTimeSetToggle.value = gameTimeSetting == 1
  EventManager.Me():PassEvent(SetViewEvent.SaveBtnStatus, self:IsChanged())
end
function SetViewSystemState:ClickDownloadAllVideo()
  if self.curVideoDownloadStatus == DownloadStatus.Downloading then
    FunctionVideoStorage.Me():CancelDownloadAllVideo()
    return
  end
  if Application.internetReachability == NetworkReachability.ReachableViaCarrierDataNetwork then
    MsgManager.ConfirmMsgByID(41358, function()
      self:StartDownloadAllVideo()
    end)
  else
    self:StartDownloadAllVideo()
  end
end
function SetViewSystemState:StartDownloadAllVideo()
  FunctionVideoStorage.Me():DownloadAllVideo()
  self:StartRefreshVideoDownloadStatus()
end
function SetViewSystemState:StartRefreshVideoDownloadStatus()
  TimeTickManager.Me():CreateTick(0, 1000, self.RefreshVideoDownloadStatus, self, 2)
end
function SetViewSystemState:DeleteAllLocalVideo()
  FunctionVideoStorage.Me():CancelDownloadAllVideo()
  FunctionVideoStorage.Me():DeleteAllLocalVideo()
  if self.curVideoDownloadStatus ~= DownloadStatus.Downloading then
    self:StartRefreshVideoDownloadStatus()
  end
end
function SetViewSystemState:RefreshBGMDownloadStatus()
  self.objBtnDeleteBGM:SetActive(self.audioHD:GetPercent() > 1.0E-4)
  self.objBtnDownloadBGM:SetActive(self.audioHD.status ~= AudioHD_Status.E_Done)
  self.gridBGMBtns:Reposition()
end
function SetViewSystemState:RefreshAVDownloadStatus()
  local showDel = self.audioDownloader and self.audioDownloader:GetPercent() > 1.0E-4
  local showDown = self.audioDownloader and self.audioDownloader.status ~= AudioHD_Status.E_Done
  self.objBtnDeleteAV:SetActive(showDel)
  self.objBtnDownloadAV:SetActive(showDown)
  self.gridAVBtns:Reposition()
end
function SetViewSystemState:DeleteAllLocalBGM()
  if self.audioHD ~= nil then
    self.audioHD:DeleteAllLocalHD()
    self.audioHD:Destroy()
    self.audioHD = nil
    self.audioHD = AudioHD.new()
    self.audioHD:InitInfo()
    self:RefreshBGMBtn()
  end
  TimeTickManager.Me():CreateOnceDelayTick(500, self.RefreshBGMDownloadStatus, self, 3)
end
function SetViewSystemState:DeleteAllLocalAV()
  AudioPackageDownloaderHolder.Ins():ResetNpcVoiceDownloader(self.avBranch)
  self:RefreshAVBtn()
  TimeTickManager.Me():CreateOnceDelayTick(500, self.RefreshAVDownloadStatus, self, 4)
end
function SetViewSystemState:IsChanged()
  local setting = FunctionPerformanceSetting.Me()
  setting:SetBegin()
  local oldSetting = setting.oldSetting
  local isChanged = false
  if math.floor(self.bgmSlider.value * 100) ~= math.floor(oldSetting.bgmVolume * 100) then
    isChanged = true
  end
  if math.floor(self.soundSlider.value * 100) ~= math.floor(oldSetting.soundVolume * 100) then
    isChanged = true
  end
  if math.floor(self.plotSlider.value * 100) ~= math.floor(oldSetting.plotVolume * 100) then
    isChanged = true
  end
  if voiceIndex ~= oldSetting.voiceLanguage then
    isChanged = true
  end
  if self:SetPush() ~= oldSetting.push then
    isChanged = true
  end
  if self:SetGVoice() ~= oldSetting.gvoice then
    isChanged = true
  end
  if self.nPCSoundToggle.value ~= oldSetting.plotVolumeToggle then
    isChanged = true
  end
  if not self.ShowOtherNameToggle.value ~= oldSetting.isShowOtherName then
    isChanged = true
  end
  if not self.ShowOtherCharToggle.value ~= oldSetting.showOtherChar then
    isChanged = true
  end
  local showHurtNum = ShowHurtNum.All
  if self.showTeamHurtNumToggle.value then
    showHurtNum = ShowHurtNum.Team
  elseif self.showSelfHurtNumToggle.value then
    showHurtNum = ShowHurtNum.Self
  end
  if showHurtNum ~= oldSetting.showHurtNum then
    isChanged = true
  end
  if self.hurtNumStyleDetail.value ~= oldSetting.hurtNumStyleDetail then
    isChanged = true
  end
  if self.togVoicePartShowingSet.value ~= oldSetting.voicePartShowing then
    isChanged = true
  end
  if self.togMultiMountTeamOnly.value ~= oldSetting.multimount then
    isChanged = true
  end
  if self.walkAroundTog and self.walkAroundTog.value ~= oldSetting.walkaround then
    isChanged = true
  end
  if self:GetEquipHideWhenSaving() ~= oldSetting.otherPlayerExterior then
    isChanged = true
  end
  local showDetail
  if self.showDetailToggleAll.value then
    showDetail = SettingEnum.ShowDetailAll
  elseif self.showDetailToggleFriend.value then
    showDetail = SettingEnum.ShowDetailFriend
  elseif self.showDetailToggleClose.value then
    showDetail = SettingEnum.ShowDetailClose
  end
  if oldSetting.showDetail ~= nil and tostring(showDetail) ~= tostring(oldSetting.showDetail) then
    isChanged = true
  end
  local speech = {}
  speech[ChatChannelEnum.Team] = self.speechTeamToggle.value
  speech[ChatChannelEnum.Guild] = self.speechGuildToggle.value
  speech[ChatChannelEnum.Zone] = self.speechChatZoneToggle.value
  speech[ChatChannelEnum.Private] = self.speechPrivateChatToggle.value
  local autoChannel = {}
  autoChannel[ChatChannelEnum.Team] = false
  autoChannel[ChatChannelEnum.Guild] = false
  autoChannel[ChatChannelEnum.Zone] = false
  autoChannel[ChatChannelEnum.Private] = false
  for k, v in pairs(oldSetting.autoPlayChatChannel) do
    autoChannel[v] = true
  end
  for k, v in pairs(speech) do
    if v ~= autoChannel[k] then
      isChanged = true
    end
  end
  if self.gameTimeSetting ~= ExpRaidProxy.Instance:GetGameTimeSetting() then
    isChanged = true
  end
  if self.luckyNotify ~= nil and self.luckyNotify ~= oldSetting.luckyNotify then
    isChanged = true
  end
  return isChanged
end
function SetViewSystemState:OnExchangeBtnClick()
  local content = self.exchangeCodeLabel.text
  if StringUtil.IsEmpty(content) then
    MsgManager.ShowMsgByID(42007)
    return
  end
  if self.inExchangeCd then
    MsgManager.ShowMsgByID(42008)
    return
  end
  ServiceUserEventProxy.Instance:CallGiftCodeExchangeEvent(content)
  TimeTickManager.Me():CreateOnceDelayTick(1000, function()
    self.inExchangeCd = false
  end, self, 100)
  self.inExchangeCd = true
end
function SetViewSystemState:ShowDebugInfo()
  local rate = ROSystemInfo.DeviceRate or 0
  local memSize = ApplicationInfo.GetSystemMemorySize()
  local screenCount = FunctionPerformanceSetting.Me():GetScreenCount() or "-"
  local effectSetting = FunctionPerformanceSetting.Me():GetEffectLv() or "-"
  local content = "" .. rate .. "." .. memSize .. "." .. screenCount .. "." .. effectSetting
  if not BackwardCompatibilityUtil.CompatibilityMode_V69 then
    content = content .. "." .. ExternalInterfaces.GetDeviceID()
  end
  UIUtil.PopUpDontAgainConfirmView(content, nil, nil, self, {
    Title = ZhString.DebugInfoTitle,
    button = ZhString.UniqueConfirmView_Confirm,
    Close = 1
  })
end
