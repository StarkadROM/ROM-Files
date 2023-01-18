StartUpCommand = class("StartUpCommand", pm.MacroCommand)
autoImport("PrepDataProxyCommand")
autoImport("PrepServiceProxyCommand")
autoImport("PrepCMDCommand")
autoImport("PrepUICommand")
autoImport("SpeechRecognizer")
function StartUpCommand:initializeMacroCommand()
  self:addSubCommand(PrepCMDCommand)
  self:addSubCommand(PrepDataProxyCommand)
  self:addSubCommand(PrepServiceProxyCommand)
  self:addSubCommand(PrepUICommand)
  FunctionAppStateMonitor.Me():Launch()
  local channel = ""
  local branchText = ""
  local runtimePlatform = ApplicationInfo.GetRunPlatform()
  if runtimePlatform == RuntimePlatform.IPhonePlayer then
    channel = GameConfig.Channel["1"].name
  elseif runtimePlatform == RuntimePlatform.Android then
    local channelID
    if not BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V13) then
      channelID = ChannelInfo.GetChannelID()
    else
      channelID = FunctionSDK.Instance:GetChannelID()
    end
    local channelDetail = GameConfig.Channel[channelID]
    if channelDetail then
      channel = channelDetail.name
    end
  elseif runtimePlatform == RuntimePlatform.WindowsPlayer or runtimePlatform == RuntimePlatform.WindowsEditor then
    channel = "windows"
  end
  if runtimePlatform == RuntimePlatform.IPhonePlayer or runtimePlatform == RuntimePlatform.Android or runtimePlatform == RuntimePlatform.WindowsPlayer or runtimePlatform == RuntimePlatform.WindowsEditor then
    local tyrantdbApplicationInfo = AppBundleConfig.GetTyrantdbInfo()
    local tyrantdbApplicationID = tyrantdbApplicationInfo.APP_ID
    local version = ApplicationInfo.GetVersion()
    if runtimePlatform == RuntimePlatform.IPhonePlayer then
      version = FunctionTyrantdb.Instance:GetAppVersion()
    end
    helplog("tyrantdbApplicationID is " .. tyrantdbApplicationID)
    if EnvChannel.IsTrunkBranch() then
      branchText = "Trunk"
      if runtimePlatform == RuntimePlatform.IPhonePlayer then
        channel = branchText .. "内网iOS"
      elseif runtimePlatform == RuntimePlatform.Android then
        channel = branchText .. "内网Android"
      elseif runtimePlatform == RuntimePlatform.WindowsPlayer then
        channel = branchText .. "内网Windows"
      elseif runtimePlatform == RuntimePlatform.WindowsEditor then
        channel = branchText .. "内网WindowsUnity编辑器"
      end
    elseif EnvChannel.IsStudioBranch() then
      branchText = "Studio"
      if runtimePlatform == RuntimePlatform.IPhonePlayer then
        channel = branchText .. "内网iOS"
      elseif runtimePlatform == RuntimePlatform.Android then
        channel = branchText .. "内网Android"
      elseif runtimePlatform == RuntimePlatform.WindowsPlayer then
        channel = branchText .. "内网Windows"
      elseif runtimePlatform == RuntimePlatform.WindowsEditor then
        channel = branchText .. "内网WindowsUnity编辑器"
      end
    end
    helplog("channel is " .. channel)
    helplog("version is " .. version)
    if BackwardCompatibilityUtil.CompatibilityMode_V60 and BranchMgr.IsChina() then
      FunctionTyrantdb.Instance:Initialize(tyrantdbApplicationID, channel, version, false)
    end
  end
  if BranchMgr.IsChina() then
    local envChannel = EnvChannel.Channel.Name
    local channelConfig = EnvChannel.ChannelConfig
    if ApplicationInfo.IsRunOnEditor() then
      LogUtility.Info("编辑器模式 无法使用jpush")
    else
      ROPush.Init("JPushBinding")
      ROPush.SetDebug(envChannel == channelConfig.Develop.Name or envChannel == channelConfig.Studio.Name)
      ROPush.ResetBadge()
      ROPush.SetApplicationIconBadgeNumber(0)
    end
  end
  NetMonitor.Me():InitCallBack()
  NetMonitor.Me():ListenSkillUseSendCallBack()
  LuaGC.StartLuaGC()
end
