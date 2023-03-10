BgmCtrl = class("BgmCtrl")
function BgmCtrl:ctor(audioSource, bgmType, playTimes, checkInterval, finishCallback)
  self.isPaused = false
  self.checkInterval = checkInterval
  self.bgmType = bgmType
  self.maxVolume = 1
  self.fadeDuration = 1.5
  self.mute = false
  self.playTimes = playTimes or 1
  self.looptime = 0
  self:SetAudioSource(audioSource, self.playTimes == 0)
  if self.checkInterval == nil then
    self.checkInterval = 1000
  end
  self.callback = finishCallback
end
function BgmCtrl:SetAudioSource(audioSource, loop)
  if Slua.IsNull(audioSource) then
    return
  end
  if self.audioSource ~= audioSource then
    self.audioSource = audioSource
    self:_TryUpdateHD()
  end
  if loop == nil then
    loop = true
  end
  local aSource = self.audioSource
  if aSource then
    aSource.loop = loop
    aSource.mute = self.mute
    self:SetMaxVolume(self.maxVolume)
    if not self:IsPlaying() then
      autoImport("VideoPanel")
      if not VideoPanel.Instance or not VideoPanel.Instance:IsPlaying() then
        self.audioSource:Play()
      end
    end
  end
end
function BgmCtrl:_TryUpdateHD()
  local clipName = self.audioSource.clip and self.audioSource.clip.name
  if clipName == nil then
    return
  end
  local filePath = ApplicationHelper.persistentDataPath .. "/" .. ApplicationInfo.GetRunPlatformStr() .. "/resources/public/audio/bgm_hd/"
  filePath = filePath .. clipName .. ".unity3d"
  if not FileHelper.ExistFile(filePath) then
    return
  end
  local hdBoundle = AssetBundle.LoadFromFile(filePath)
  if hdBoundle == nil then
    return
  end
  local hdClip = hdBoundle:LoadAsset(clipName, AudioClip)
  if hdClip == nil then
    return
  end
  self.audioSource.clip = hdClip
  self.audioSource:Play()
  hdBoundle:Unload(false)
end
function BgmCtrl:SetMute(val)
  if self.mute ~= val then
    self.mute = val
    if Slua.IsNull(self.audioSource) == false then
      self.audioSource.mute = self.mute
    end
  end
end
function BgmCtrl:SetMaxVolume(v)
  self.maxVolume = v
  if Slua.IsNull(self.audioSource) == false and v <= self.audioSource.volume then
    self.audioSource.volume = v
  end
end
function BgmCtrl:SetVolume(volume)
  if Slua.IsNull(self.audioSource) == false then
    self.audioSource.volume = math.min(volume, self.maxVolume)
  end
end
function BgmCtrl:GetVolume()
  if Slua.IsNull(self.audioSource) == false then
    return self.audioSource.volume
  end
  return 0
end
function BgmCtrl:SetProgress(progress)
  if Slua.IsNull(self.audioSource) == false then
    progress = math.clamp(progress, 0, self.audioSource.clip.length - 1)
    self.audioSource.time = progress
  end
end
function BgmCtrl:SetFinishCallback(finishCallback)
  self.callback = finishCallback
end
function BgmCtrl:Play()
  if Slua.IsNull(self.audioSource) == false then
    self.audioSource:Play()
  end
  if self.timeTick == nil and self.playTimes > 0 then
    self.timeTick = TimeTickManager.Me():CreateTick(0, self.checkInterval, self.IsFinish, self)
  end
end
function BgmCtrl:Pause(fade)
  if Slua.IsNull(self.audioSource) == false and not self.isPaused then
    self.isPaused = true
    if fade then
      self:FadeFromTo(self:GetVolume(), 0, nil, function()
        self.audioSource:Pause()
      end)
    else
      self.audioSource:Pause()
    end
  end
end
function BgmCtrl:UnPause(fade)
  if Slua.IsNull(self.audioSource) == false and self.isPaused then
    self.isPaused = false
    self.audioSource:UnPause()
    if fade then
      self:FadeFromTo(0, 1)
    end
  end
end
function BgmCtrl:Stop()
  if Slua.IsNull(self.audioSource) == false then
    self.audioSource:Stop()
  end
  TimeTickManager.Me():ClearTick(self)
  self.timeTick = nil
end
function BgmCtrl:IsFinish()
  if Slua.IsNull(self.audioSource) == false and not self.audioSource.isPlaying and not self.isPaused then
    self.looptime = self.looptime + 1
    if self.looptime >= self.playTimes then
      if self.callback ~= nil then
        self.callback()
      end
    else
      self:Play()
    end
  end
end
function BgmCtrl:GetProgress()
  if not Slua.IsNull(self.audioSource) then
    local progress = math.clamp(self.audioSource.time, 0, self.audioSource.clip.length - 1)
    return progress
  end
end
function BgmCtrl:IsPlaying()
  return Slua.IsNull(self.audioSource) == false and self.audioSource.isPlaying or false
end
function BgmCtrl:FadeFromTo(from, to, duration, fadeDoneCall)
  if not duration or not duration then
    duration = self.fadeDuration
  end
  to = math.min(to, self.maxVolume)
  from = math.min(from, self.maxVolume)
  if not Slua.IsNull(self.audioSource) then
    LeanTween.audioVolume(self.audioSource, from, to, duration):setOnComplete(fadeDoneCall)
  else
    redlog("not audiosource")
  end
end
function BgmCtrl:Destroy()
  self:Stop()
  if Slua.IsNull(self.audioSource) == false then
    LeanTween.cancel(self.audioSource.gameObject)
    GameObject.Destroy(self.audioSource.gameObject)
  end
  self.audioSource = nil
  self.callback = nil
end
