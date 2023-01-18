autoImport("BgmCtrl")
FunctionBGMCmd = class("FunctionBGMCmd")
FunctionBGMCmd.BgmSort = {
  Default = {priority = 1},
  Mission = {priority = 2},
  JukeBox = {priority = 3},
  Activity = {priority = 4},
  UI = {priority = 5},
  PlotAudio = {priority = 10}
}
FunctionBGMCmd.MaxVolume = 0.3
function FunctionBGMCmd.Me()
  if nil == FunctionBGMCmd.me then
    FunctionBGMCmd.me = FunctionBGMCmd.new()
  end
  return FunctionBGMCmd.me
end
function FunctionBGMCmd:ctor()
  self.currentNewBgm = nil
  self.currentVolume = FunctionBGMCmd.MaxVolume
  self.mute = false
  self.fadeInStart = 0
  self.fadeinDuration = 1.5
  self.defaultBgm = BgmCtrl.new(nil, FunctionBGMCmd.BgmSort.Default, 0, 100)
  self:Reset()
  self:SetMaxVolume(FunctionBGMCmd.MaxVolume)
  self.extraVolume = nil
end
function FunctionBGMCmd:Reset()
  self:SetCurrentBgm(self.defaultBgm, false)
end
function FunctionBGMCmd:StartSpeakVoice()
  self:SetVolume(0.2 * self.currentVolume)
end
function FunctionBGMCmd:EndSpeakVoice()
  self:SetVolume(self.currentVolume)
end
function FunctionBGMCmd:StartSolo()
  self:SetVolume(0.2 * self.currentVolume)
end
function FunctionBGMCmd:EndSolo()
  self:SetVolume(self.currentVolume)
end
function FunctionBGMCmd:StartPlotAudio()
  self:SetVolume(0.2 * self.currentVolume)
end
function FunctionBGMCmd:EndPlotAudio()
  self:SetVolume(self.currentVolume)
end
function FunctionBGMCmd:GetMaxVolume(v)
  return math.min(v, self.currentVolume)
end
function FunctionBGMCmd:SetMute(val)
  self.mute = val
  if self.currentNewBgm then
    self.currentNewBgm:SetMute(val)
  end
end
function FunctionBGMCmd:SettingSetVolume(v)
  if v >= 0 and v <= 1 then
    v = FunctionBGMCmd.MaxVolume * v
  end
  AudioManager.volume = v
  self.currentVolume = v
  self:SetMaxVolume(v)
  self:SetVolume(v)
end
function FunctionBGMCmd:SetVolume(v)
  v = self:GetMaxVolume(v)
  if self.currentNewBgm and not self.extraVolume then
    self.currentNewBgm:SetVolume(v)
  end
end
function FunctionBGMCmd:SetMaxVolume(v)
  v = self:GetMaxVolume(v)
  if self.defaultBgm then
    self.defaultBgm:SetMaxVolume(v)
  end
  if self.currentNewBgm and not self.extraVolume then
    self.currentNewBgm:SetMaxVolume(v)
  end
end
function FunctionBGMCmd:SetExtraVolume(v)
  self.extraVolume = v
  if self.currentNewBgm and self.extraVolume then
    AudioManager.volume = v
    self.currentNewBgm:SetVolume(v)
  end
end
function FunctionBGMCmd:GetDefaultBGM()
  if self.defaultBgm and AudioManager.Instance ~= nil then
    self.defaultBgm:SetAudioSource(AudioManager.Instance.bgMusic)
  end
  return self.defaultBgm
end
function FunctionBGMCmd:SetCurrentBgm(bgm, fade, outDuration, inDuration, fadeInStart, keepBGM)
  if self.currentNewBgm ~= bgm and self.currentNewBgm and not keepBGM then
    if fade then
      local currentNewBgm = self.currentNewBgm
      currentNewBgm:FadeFromTo(currentNewBgm:GetVolume(), 0, outDuration, function()
        if currentNewBgm ~= self.defaultBgm then
          currentNewBgm:Destroy()
        end
      end)
      break
    elseif self.currentNewBgm ~= self.defaultBgm then
      self.currentNewBgm:Destroy()
    end
  end
  self.currentNewBgm = bgm
  if self.currentNewBgm and fade then
    self.currentNewBgm:FadeFromTo(fadeInStart and fadeInStart or self.fadeInStart, 1, inDuration or self.fadeinDuration)
  else
  end
end
function FunctionBGMCmd:PlayJukeBox(bgmPath, progress, percent, playTimes, outDuration, inDuration, fallbackDuration, fallbackFadeStartVolumn, force)
  self:TryPlayBGMSort(bgmPath, progress, FunctionBGMCmd.BgmSort.JukeBox, percent, playTimes, outDuration, inDuration, fallbackDuration, fallbackFadeStartVolumn, nil, nil, force)
end
function FunctionBGMCmd:StopJukeBox(fallbackDuration, fallbackFadeStartVolumn)
  self:StopBgm(FunctionBGMCmd.BgmSort.JukeBox, fallbackDuration, fallbackFadeStartVolumn)
end
function FunctionBGMCmd:PlayMissionBgm(bgmPath, playTimes)
  self:TryPlayBGMSort(bgmPath, 0, FunctionBGMCmd.BgmSort.Mission, false, playTimes)
end
function FunctionBGMCmd:StopMissionBgm(defaultBgmFromStart)
  if defaultBgmFromStart and self.defaultBgm then
    self.defaultBgm:SetProgress(0)
  end
  self:StopBgm(FunctionBGMCmd.BgmSort.Mission)
end
function FunctionBGMCmd:PlayActivityBgm(bgmPath, playTimes)
  self:TryPlayBGMSort(bgmPath, 0, FunctionBGMCmd.BgmSort.Activity, false, playTimes)
end
function FunctionBGMCmd:StopActivityBgm()
  self:StopBgm(FunctionBGMCmd.BgmSort.Activity)
end
function FunctionBGMCmd:PlayUIBgm(bgmPath, playTimes, outDuration, inDuration, fallbackDuration, fallbackFadeStartVolumn, finishCallback)
  self:TryPlayBGMSort(bgmPath, 0, FunctionBGMCmd.BgmSort.UI, false, playTimes, outDuration, inDuration, fallbackDuration, fallbackFadeStartVolumn, finishCallback)
end
function FunctionBGMCmd:StopUIBgm(fallbackDuration, fallbackFadeStartVolumn)
  self:StopBgm(FunctionBGMCmd.BgmSort.UI, fallbackDuration, fallbackFadeStartVolumn)
end
function FunctionBGMCmd:PlayPlotAudio(bgmPath, progress, playTimes, outDuration, inDuration, fallbackDuration, fallbackFadeStartVolumn, finishCallback, keepBGM, extraVolume)
  self.extraVolume = extraVolume
  self:TryPlayBGMSort(bgmPath, progress, FunctionBGMCmd.BgmSort.PlotAudio, false, playTimes, outDuration, inDuration, fallbackDuration, fallbackFadeStartVolumn, finishCallback, keepBGM)
end
function FunctionBGMCmd:StopPlotAudio(fallbackDuration, fallbackFadeStartVolumn)
  self:StopBgm(FunctionBGMCmd.BgmSort.PlotAudio, fallbackDuration, fallbackFadeStartVolumn)
end
function FunctionBGMCmd:PausePlotAudio(fade)
  if self.currentNewBgm then
    if AudioManager.Instance ~= nil then
      self.defaultBgm:SetAudioSource(AudioManager.Instance.bgMusic)
    end
    self.currentNewBgm:Pause(fade)
    return self.currentNewBgm:GetProgress()
  end
end
function FunctionBGMCmd:GetCurrentProgress()
  if self.currentNewBgm then
    return self.currentNewBgm:GetProgress()
  end
end
function FunctionBGMCmd:ResumePlotAudio(progress)
  if self.currentNewBgm then
    if AudioManager.Instance ~= nil then
      self.defaultBgm:SetAudioSource(AudioManager.Instance.bgMusic)
    end
    self.currentNewBgm:SetProgress(progress)
    self.currentNewBgm:Play()
  end
end
local cacheBgmFullPath
function FunctionBGMCmd:ReplaceCurrentBgm(bgmPath)
  if AudioManager.Instance ~= nil and AudioManager.Instance.bgMusic ~= nil then
    LogUtility.InfoFormat("场景默认背景音乐替换为{0}", bgmPath)
    if cacheBgmFullPath then
      ResourceManager.Instance:SUnLoad(cacheBgmFullPath, false)
    end
    cacheBgmFullPath = ResourcePathHelper.AudioBGM(bgmPath)
    local clip = ResourceManager.Instance:SLoadByType(cacheBgmFullPath, AudioClip)
    if clip ~= nil then
      AudioManager.Instance.bgMusic.clip = clip
      AudioManager.Instance.bgMusic:Play()
    end
  end
end
function FunctionBGMCmd:TryPlayBGMSort(bgmPath, progress, playType, percent, playTimes, outDuration, inDuration, fallbackDuration, fallbackFadeStartVolumn, finishCallback, keepBGM, force)
  if percent and progress >= 1 then
    redlog("播放音乐超过其总长度,无视此次播放")
    return
  end
  if not force then
    if self.currentNewBgm and self.currentNewBgm.bgmType.priority > playType.priority then
      return
    end
  else
    self.currentNewBgm = self.defaultBgm
  end
  self:ChangeBGM(bgmPath, progress, playType, percent, playTimes, outDuration, inDuration, fallbackDuration, fallbackFadeStartVolumn, finishCallback, keepBGM)
end
function FunctionBGMCmd:StopBgm(playType, fallbackDuration, fallbackFadeStartVolumn)
  if self.currentNewBgm and self.currentNewBgm.bgmType == playType then
    self:Clear(fallbackDuration, fallbackFadeStartVolumn)
  end
end
function FunctionBGMCmd:Pause(fade)
  if self.currentNewBgm then
    if AudioManager.Instance ~= nil then
      self.defaultBgm:SetAudioSource(AudioManager.Instance.bgMusic)
    end
    self.currentNewBgm:Pause(fade)
  end
end
function FunctionBGMCmd:UnPause(fade)
  if self.currentNewBgm then
    if AudioManager.Instance ~= nil then
      self.defaultBgm:SetAudioSource(AudioManager.Instance.bgMusic)
    end
    self.currentNewBgm:UnPause(fade)
  end
end
local nowBgmPath
local audioconfig = {}
function FunctionBGMCmd:ChangeBGM(bgmPath, progress, playType, percent, playTimes, outDuration, inDuration, fallbackDuration, fallbackFadeStartVolumn, finishCallback, keepBGM)
  if AudioManager.Instance ~= nil then
    self.defaultBgm:SetAudioSource(AudioManager.Instance.bgMusic)
    progress = progress or 0
    do
      local go = GameObject("ReplaceBGM")
      go:AddComponent(AudioSource)
      go.transform.parent = AudioManager.Instance.bgMusic.transform.parent
      if nowBgmPath then
        ResourceManager.Instance:SUnLoad(nowBgmPath, false)
      end
      nowBgmPath = ResourcePathHelper.AudioBGM(bgmPath)
      local audioSource = AudioHelper.SPlayOn(nowBgmPath, go, AudioSourceType.BGM_Music)
      redlog("nowBgmPath", nowBgmPath)
      if audioSource == nil then
        helplog("not find BGM", bgmPath)
        audioSource = AudioUtil.SPlayOn_ByLanguangeSetting(ResourcePathHelper.RelativeAudioPoemStory(bgmPath), AudioSourceType.NPC_Poemstory)
        if not audioSource then
          error("not find AudioPoemStory:" .. bgmPath)
          return
        end
      end
      local bgmCtrl = BgmCtrl.new(audioSource, playType, playTimes, 100, nil)
      bgmCtrl:SetFinishCallback(function()
        bgmCtrl:Destroy()
        self:Clear(fallbackDuration, fallbackFadeStartVolumn)
        if finishCallback then
          finishCallback()
        end
      end)
      bgmCtrl:SetMute(self.mute)
      bgmCtrl:SetMaxVolume(self.extraVolume ~= nil and self.extraVolume or self.currentVolume)
      if percent then
        progress = math.clamp(progress, 0, 0.99)
        progress = progress * audioSource.clip.length
      else
        progress = math.clamp(progress, 0, audioSource.clip.length - 1)
      end
      bgmCtrl:SetProgress(progress)
      bgmCtrl:Play()
      bgmCtrl:FadeFromTo(self.fadeInStart or 0, self.extraVolume or self.currentVolume, inDuration or self.fadeinDuration)
      self:SetCurrentBgm(bgmCtrl, true, outDuration, inDuration, nil, keepBGM)
    end
  else
  end
end
function FunctionBGMCmd:Clear(fallbackDuration, fallbackFadeStartVolumn)
  LogUtility.Info(string.format("播放结束 fallbackDuration:%s fallbackFadeStartVolumn:%s", fallbackDuration, fallbackFadeStartVolumn))
  self:SetCurrentBgm(self.defaultBgm, true, nil, fallbackDuration, fallbackFadeStartVolumn)
end
function FunctionBGMCmd:IsDefaultBGM()
  return self.currentNewBgm == self.defaultBgm
end
