AudioUtil = {}
function AudioUtil.PlayNpcVisitVocal(soundConfig)
  local sSoundConfigs = string.split(soundConfig, ";")
  local length = #sSoundConfigs
  if length == 0 then
    return
  end
  local soundConfigMap = {}
  local defaultConfig
  for i = 1, #sSoundConfigs do
    local sConfigs = string.split(sSoundConfigs[i], ":")
    if #sConfigs == 1 then
      defaultConfig = sConfigs[1]
    elseif #sConfigs == 2 then
      soundConfigMap[sConfigs[1]] = sConfigs[2]
    end
  end
  if soundConfigMap.M and soundConfigMap.F then
    if Game.Myself then
      local gender = Game.Myself.data.userdata:Get(UDEnum.SEX)
      if gender == 1 then
        AudioUtil.Play2DRandomSound(soundConfigMap.M)
      elseif gender == 2 then
        AudioUtil.Play2DRandomSound(soundConfigMap.F)
      end
    end
  elseif defaultConfig then
    AudioUtil.Play2DRandomSound(defaultConfig)
  end
end
function AudioUtil.Play2DRandomSound(soundConfig)
  if soundConfig ~= "" then
    local paths = string.split(soundConfig, "-")
    local rdmIndex = math.random(1, #paths)
    if rdmIndex then
      AudioUtil.PlaySound_ByLanguangeSetting(paths[rdmIndex])
    end
  end
end
function AudioUtil.SPlayOn_ByLanguangeSetting(path, audioSourceType)
  local clip = AudioUtil.GetSound_ByLanguangeSetting(path)
  if clip then
    local audioSource = AudioHelper.Play_At(clip, 0, 0, 0, 0, audioSourceType or AudioSourceType.BGM_Music)
    return audioSource
  end
end
function AudioUtil.PlayPlot_ByLanguangeSetting(path, audioSourceType)
  local clip = AudioUtil.GetSound_ByLanguangeSetting(path)
  if clip then
    local audioSource = AudioHelper.PlayPlot_At(clip, 0, 0, 0, 0, audioSourceType or AudioSourceType.NPC_Poemstory)
    return audioSource
  end
end
function AudioUtil.PlaySound_ByLanguangeSetting(path, audioSourceType)
  local clip = AudioUtil.GetSound_ByLanguangeSetting(path)
  if clip then
    AudioUtility.PlayOneShot2DSingle_Clip(clip, audioSourceType or AudioSourceType.NPC)
  end
end
function AudioUtil.GetSound_ByLanguangeSetting(path)
  local fullPath
  local voice = FunctionPerformanceSetting.Me():GetLanguangeVoice()
  local defaultVoice = GameConfig.SEBranchSetting and GameConfig.SEBranchSetting.Order and GameConfig.SEBranchSetting.Order[1] or voice
  local is_default = defaultVoice == voice
  local clip
  if is_default then
    fullPath = ResourcePathHelper.NewAudioSE(path)
    clip = Game.AssetManager:LoadByType(fullPath, AudioClip)
  else
    local pathSp = string.split(path, "/")
    local SubFoldersIgnoreCase = {}
    for i = 1, #GameConfig.SEBranchSetting.SubFolders do
      TableUtility.ArrayPushBack(SubFoldersIgnoreCase, string.upper(GameConfig.SEBranchSetting.SubFolders[i]))
    end
    if #pathSp > 1 and TableUtility.ArrayFindIndex(SubFoldersIgnoreCase, string.upper(pathSp[1])) > 0 then
      clip = AudioUtil.TryLoadNPCAudioFromDownload(path, voice)
      if not clip then
        if voice == LanguageVoice.Jananese then
          fullPath = ResourcePathHelper.AudioSE_JP(path)
        elseif voice == LanguageVoice.Korean then
          fullPath = ResourcePathHelper.AudioSE_KR(path)
        else
          fullPath = ResourcePathHelper.NewAudioSE(path)
        end
        clip = Game.AssetManager:LoadByType(fullPath, AudioClip)
      end
    else
      fullPath = ResourcePathHelper.NewAudioSE(path)
      clip = Game.AssetManager:LoadByType(fullPath, AudioClip)
    end
  end
  return clip
end
local lang_branches = {
  "cn",
  "jp",
  "kr"
}
function AudioUtil.TryLoadNPCAudioFromDownload(oriPath, voice)
  local pathSp = string.split(oriPath, "/")
  local clipName = pathSp[#pathSp]
  local branch = lang_branches[voice]
  oriPath = string.lower(oriPath)
  redlog("converted oripath", oriPath)
  local filePath = ApplicationHelper.persistentDataPath .. string.format("/%s/resources/public/audio/se/%s/%s.unity3d", ApplicationInfo.GetRunPlatformStr(), branch, oriPath)
  redlog("TryLoadNPCAudioFromDownload", "filePath ", filePath)
  if not FileHelper.ExistFile(filePath) then
    redlog("TryLoadNPCAudioFromDownload", "file not exist!")
    return
  end
  local bundle = AssetBundle.LoadFromFile(filePath)
  if bundle == nil then
    return
  end
  local clip = bundle:LoadAsset(clipName, AudioClip)
  bundle:Unload(false)
  return clip
end
function AudioUtil.ParseNPCAudioCfgPath(soundConfig)
  local sSoundConfigs = string.split(soundConfig, ";")
  local length = #sSoundConfigs
  if length == 0 then
    return
  end
  local soundConfigMap = {}
  local defaultConfig
  for i = 1, #sSoundConfigs do
    local sConfigs = string.split(sSoundConfigs[i], ":")
    if #sConfigs == 1 then
      defaultConfig = sConfigs[1]
    elseif #sConfigs == 2 then
      soundConfigMap[sConfigs[1]] = sConfigs[2]
    end
  end
  if soundConfigMap.M and soundConfigMap.F then
    if Game.Myself then
      local gender = Game.Myself.data.userdata:Get(UDEnum.SEX)
      if gender == 1 then
        return AudioUtil.PreParsePath(soundConfigMap.M)
      elseif gender == 2 then
        return AudioUtil.PreParsePath(soundConfigMap.F)
      end
    end
  elseif defaultConfig then
    return AudioUtil.PreParsePath(defaultConfig)
  end
end
function AudioUtil.PreParsePath(soundConfig)
  if soundConfig ~= "" then
    local paths = string.split(soundConfig, "-")
    local rdmIndex = math.random(1, #paths)
    if rdmIndex then
      return paths[rdmIndex]
    end
  end
end
