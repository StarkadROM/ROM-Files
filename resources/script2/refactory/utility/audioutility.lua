autoImport("AudioDefines")
AudioUtility = class("AudioUtility")
local volume = 1
local mute = 0
function AudioUtility.SetVolume(v)
  volume = v
  if mute > 0 then
    return
  end
  AudioHelper.volume = v
end
function AudioUtility.GetVolume()
  return volume
end
function AudioUtility.Mute(on)
  if on then
    mute = mute + 1
    if 1 == mute then
      AudioHelper.volume = 0
    end
  else
    mute = mute - 1
    if 0 == mute then
      AudioHelper.volume = volume
    end
  end
end
function AudioUtility.PlayOneShot2D_Path(path, audioSourceType)
  local clip = AudioUtility.GetAudioClip(path)
  if nil == clip then
    return
  end
  return AudioHelper.PlayOneShot2D(clip, audioSourceType or AudioSourceType.ONESHOTSE)
end
function AudioUtility.StopOneShot2D_Clip(audioController)
  if audioController then
    audioController:Stop()
  end
end
function AudioUtility.PlayOneShot2DSingle_Clip(clip, atype)
  AudioHelper.Play_At(clip, 0, 0, 0, 0, atype or AudioSourceType.ONESHOTSE)
end
function AudioUtility.PlayOneShotAt_Path(path, x, y, z, audioSourceType)
  local clip = AudioUtility.GetAudioClip(path)
  if nil == clip then
    return
  end
  return AudioHelper.PlayOneShotAt(clip, x, y, z, audioSourceType)
end
function AudioUtility.GetAudioClip(path)
  local clip
  if path then
    clip = AudioUtil.GetSound_ByLanguangeSetting(path)
  end
  return clip
end
function AudioUtility.PlayLoop_At(path, x, y, z, audioSourceType)
  local clip = AudioUtility.GetAudioClip(path)
  if clip then
    return AudioHelper.PlayLoop_At(clip, x, y, z, 0, audioSourceType)
  end
end
function AudioUtility:PlayOneShotOn(path, audioSource, audioSourceType)
  local clip = AudioUtility.GetAudioClip(path)
  if clip then
    return AudioHelper.PlayOneShotOn(clip, audioSource, audioSourceType)
  end
end
function AudioUtility:PlayOn(path, audioSource, loop, audioSourceType)
  local clip = AudioUtility.GetAudioClip(path)
  if loop == nil then
    loop = false
  end
  if clip then
    return AudioHelper.PlayOn(clip, audioSource, loop, audioSourceType)
  end
end
