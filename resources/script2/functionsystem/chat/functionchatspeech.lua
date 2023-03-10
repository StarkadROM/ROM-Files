autoImport("VoiceController")
FunctionChatSpeech = class("FunctionChatSpeech")
function FunctionChatSpeech.Me()
  if nil == FunctionChatSpeech.me then
    FunctionChatSpeech.me = FunctionChatSpeech.new()
  end
  return FunctionChatSpeech.me
end
function FunctionChatSpeech:ctor()
  self:Init()
end
function FunctionChatSpeech:Init()
  self.recognizerFileName = "asr.wav"
  self.speechFileName = "asr.mp3"
end
function FunctionChatSpeech:Reset(obj, finishCallback)
  self.VoiceController = VoiceController.new(obj, 1000, finishCallback)
end
function FunctionChatSpeech:GetByteByPcmfile()
  local bytes
  if self.speechFileName then
    bytes = FileDirectoryHandler.LoadFile(self.speechFileName)
    if bytes then
    end
  end
  return bytes
end
function FunctionChatSpeech:PlayAudioByBytes(bytes, id)
  local audioClip = self:GetAudioClip(bytes)
  self.VoiceController:Play(audioClip)
  FunctionBGMCmd.Me():StartSpeakVoice()
  if id then
    GameFacade.Instance:sendNotification(ChatRoomEvent.StopVoice)
    self:SetCurrentVoiceId(id)
    GameFacade.Instance:sendNotification(ChatRoomEvent.StartVoice)
  end
end
function FunctionChatSpeech:PlayAudioByPath(path, id)
  local speechRecognizer = UIManagerProxy.Instance.speechRecognizer
  if speechRecognizer == nil then
    return
  end
  speechRecognizer:GetAudio(path, function(audioClip)
    if audioClip == nil then
      return
    end
    self.VoiceController:Play(audioClip)
    FunctionBGMCmd.Me():StartSpeakVoice()
    if id then
      GameFacade.Instance:sendNotification(ChatRoomEvent.StopVoice)
      self:SetCurrentVoiceId(id)
      GameFacade.Instance:sendNotification(ChatRoomEvent.StartVoice)
    end
  end)
end
function FunctionChatSpeech:GetLengthByBytes(bytes)
  if bytes == nil or #bytes <= 0 then
    return 0
  end
  local audioClip = self:GetAudioClip(bytes)
  if audioClip then
    local length = math.ceil(audioClip.length)
    GameObject.Destroy(audioClip)
    return length
  else
    return 0
  end
end
function FunctionChatSpeech:GetAudioClip(bytes)
  local audioClip
  audioClip = AudioHelper.GetAudioClipByPcmByte(bytes, "ChatSpeech")
  return audioClip
end
function FunctionChatSpeech:GetVoiceController()
  return self.VoiceController
end
function FunctionChatSpeech:SetCurrentVoiceId(id)
  self.voiceId = id
end
function FunctionChatSpeech:GetCurrentVoiceId()
  return self.voiceId
end
