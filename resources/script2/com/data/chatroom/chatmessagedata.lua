ChatMessageData = reusableClass("ChatMessageData")
ChatMessageData.PoolSize = 5
local Channel_Enum_String = {
  ECHAT_CHANNEL_ROUND = ChatCmd_pb.ECHAT_CHANNEL_ROUND,
  ECHAT_CHANNEL_TEAM = ChatCmd_pb.ECHAT_CHANNEL_TEAM,
  ECHAT_CHANNEL_GUILD = ChatCmd_pb.ECHAT_CHANNEL_GUILD,
  ECHAT_CHANNEL_FRIEND = ChatCmd_pb.ECHAT_CHANNEL_FRIEND,
  ECHAT_CHANNEL_WORLD = ChatCmd_pb.ECHAT_CHANNEL_WORLD,
  ECHAT_CHANNEL_SYS = ChatCmd_pb.ECHAT_CHANNEL_SYS,
  ECHAT_CHANNEL_ROOM = ChatCmd_pb.ECHAT_CHANNEL_ROOM,
  ECHAT_CHANNEL_CHAT = ChatCmd_pb.ECHAT_CHANNEL_CHAT,
  ECHAT_CHANNEL_USERRETURN_ROOM = ChatCmd_pb.ECHAT_CHANNEL_USERRETURN_ROOM,
  ECHAT_CHANNEL_RESERVE_ROOM = ChatCmd_pb.ECHAT_CHANNEL_RESERVE_ROOM
}
function ChatMessageData:ctor()
  ChatMessageData.super.ctor(self)
end
function ChatMessageData:SetData(data)
  if data then
    if data.id == Game.Myself.data.id then
      self[1] = data.targetid
    elseif data.targetid == Game.Myself.data.id then
      self[1] = data.id
    end
    self[2] = data.id
    self[3] = data.name
    self[4] = data.channel
    self[5] = data.channelName
    self[6] = data.hair
    self[7] = data.haircolor
    self[8] = data.body
    self[9] = data.gender
    self[10] = data.guildname
    self[11] = data.rolejob
    self[12] = data.str
    self[13] = data.baselevel
    if data.cellType then
      self[14] = data.cellType
    elseif self[2] then
      if self[2] == Game.Myself.data.id then
        if data.redpacketret and not StringUtil.IsEmpty(data.redpacketret.strRedPacketID) then
          self[14] = ChatTypeEnum.MyselfRedPacket
        else
          self[14] = ChatTypeEnum.MySelfMessage
        end
      elseif data.redpacketret and not StringUtil.IsEmpty(data.redpacketret.strRedPacketID) then
        self[14] = ChatTypeEnum.SomeoneRedPacket
      else
        self[14] = ChatTypeEnum.SomeoneMessage
      end
    end
    self[15] = data.voiceid
    self[16] = data.voicetime
    if data.time then
      self[17] = data.time
    else
      self[17] = ServerTime.CurServerTime() / 1000
    end
    self[18] = data.targetid
    self[19] = data.appellation
    self[20] = data.blink
    self[21] = data.portrait
    self[22] = data.head
    self[23] = data.face
    self[24] = data.mouth
    self[25] = data.removeTime
    self[26] = data.eye
    self[27] = data.zoneid
    self[28] = data.serverid
    self[29] = data.accid
    self[30] = data.roomid
    self[35] = data.isreturnuser
    self[36] = data.chat_frame
    if data.photo and data.photo.source and data.photo.sourceid and data.photo.source ~= 0 and data.photo.sourceid ~= 0 then
      self[31] = PhotoData.new(data.photo)
      if data.id == Game.Myself.data.id then
        self[31].loaded = true
      end
    end
    local expression = data.expression
    if expression then
      self[32] = expression.type
      self[33] = expression.id
    end
    self[34] = data.portrait_frame
    if data.msgid and data.msgid ~= 0 then
      self[14] = ChatTypeEnum.SystemMessage
      local sys = Table_Sysmsg[data.msgid]
      if sys then
        self[12] = sys.Text
      end
    elseif data.sysmsgid and data.sysmsgid ~= 0 then
      local sys = Table_Sysmsg[data.sysmsgid]
      if sys then
        self[12] = sys.Text
      end
    end
    if self[14] ~= ChatTypeEnum.SystemMessage then
      self[12] = ChatRoomProxy.Instance:StripSymbols(self[12])
    end
    self.isSelf = self[2] == Game.Myself.data.id
    self.portraitImage = data.portraitImage
    self.roleType = data.roleType
    if self[14] == ChatTypeEnum.SomeoneMessage then
      if self:GetChannel() == ChatChannelEnum.Team then
        local _TeamProxy = TeamProxy.Instance
        if _TeamProxy:IHaveGroup() and _TeamProxy:IsInMyTeam(self:GetId()) then
          self.isTeamGroup = true
        else
          self.isTeamGroup = false
        end
      else
        self.isTeamGroup = false
      end
    end
    self.alignment = data.alignment
    local isHideInSimplify = data.isHideInSimplify
    if isHideInSimplify ~= nil then
      self.isHideInSimplify = isHideInSimplify
    else
      self.isHideInSimplify = self[14] == ChatTypeEnum.SystemMessage and self[4] ~= ChatChannelEnum.System
    end
    local redPacketData = data.redpacketret
    if redPacketData then
      self.redPacketGUID = redPacketData.strRedPacketID
      self.redPacketItemId = redPacketData.itemID
    end
    if data.items and 0 < #data.items then
      self.items = {}
      for i = 1, #data.items do
        self.items[i] = {
          data.items[i].guid,
          data.items[i].id
        }
      end
    end
    self.share_data = nil
    if data.share_data then
      self.share_data = {}
      self.share_data.type = data.share_data.type
      self.share_data.items = {}
      if self.share_data.type == ESHAREMSGTYPE.ESHARE_LOTTERY_TEN then
        if data.share_data.share_items then
          for i = 1, #data.share_data.share_items do
            self.share_data.items[i] = {
              data.share_data.share_items[i].guid,
              data.share_data.share_items[i].itemid,
              data.share_data.share_items[i].count
            }
          end
        end
      elseif self.share_data.type == ESHAREMSGTYPE.ESHARE_COMPOSE_ARTIFACT then
        if data.share_data.share_items then
          for i = 1, #data.share_data.share_items do
            self.share_data.items[i] = ItemData.new(data.share_data.share_items[i].guid, data.share_data.share_items[i].itemid)
            self.share_data.items[i]:SetItemNum(1)
          end
        end
      elseif self.share_data.type == ESHAREMSGTYPE.ESHARE_EXTRACTION then
        if data.share_data.share_items then
          for i = 1, #data.share_data.share_items do
            self.share_data.items[i] = ItemData.new(data.share_data.share_items[i].guid, data.share_data.share_items[i].itemid)
            self.share_data.items[i]:SetItemNum(1)
            self.share_data.items[i].extractionLv = data.share_data.share_items[i].count
          end
        end
      elseif self.share_data.type == ESHAREMSGTYPE.ESHARE_SPEC_ITEM_GET then
        if data.share_data.share_items then
          for i = 1, #data.share_data.share_items do
            self.share_data.items[i] = {
              data.share_data.share_items[i].guid,
              data.share_data.share_items[i].itemid,
              data.share_data.share_items[i].count
            }
          end
        end
      elseif data.share_data.items then
        for i = 1, #data.share_data.items do
          if self.share_data.type == ESHAREMSGTYPE.ESHARE_REMOULD_ARTIFACT then
            self.share_data.items[i] = ItemData.new(data.share_data.items[i].base.guid, data.share_data.items[i].base.id)
            self.share_data.items[i]:SetItemNum(data.share_data.items[i].base.count)
            self.share_data.items[i]:ParseFromServerData(data.share_data.items[i])
          elseif self.share_data.type == ESHAREMSGTYPE.ESHARE_ENCHANT then
            self.share_data.items[i] = ItemData.new(data.share_data.items[i].base.guid, data.share_data.items[i].base.id)
            self.share_data.items[i]:SetItemNum(data.share_data.items[i].base.count)
            self.share_data.items[i]:ParseFromServerData(data.share_data.items[i])
          elseif self.share_data.type == ESHAREMSGTYPE.ESHARE_REFINE then
            self.share_data.items[i] = ItemData.new(data.share_data.items[i].base.guid, data.share_data.items[i].base.id)
            self.share_data.items[i]:SetItemNum(data.share_data.items[i].base.count)
            self.share_data.items[i]:ParseFromServerData(data.share_data.items[i])
          elseif self.share_data.type == ESHAREMSGTYPE.ESHARE_NEW_EQUIP then
            self.share_data.items[i] = ItemData.new(data.share_data.items[i].base.guid, data.share_data.items[i].base.id)
            self.share_data.items[i]:SetItemNum(data.share_data.items[i].base.count)
            self.share_data.items[i]:ParseFromServerData(data.share_data.items[i])
          else
            self.share_data.items[i] = {
              data.share_data.items[i].base.guid,
              data.share_data.items[i].base.id,
              data.share_data.items[i].base.count
            }
          end
        end
      end
    end
  end
end
function ChatMessageData:SetStr(str)
  local chatFrameID = self[36]
  local chatFrameConfig = Table_UserChatFrame[chatFrameID]
  if chatFrameConfig and chatFrameConfig.BBCodeColor then
    str = string.gsub(str, "colortext", chatFrameConfig.BBCodeColor)
  else
    str = string.gsub(str, "colortext", "1F74BF")
  end
  self[12] = str
end
function ChatMessageData:SetChannelName(channelName)
  self[5] = channelName
end
function ChatMessageData:SetPhotoInfo(info)
  self.photoInfo = info
end
function ChatMessageData:SetPhotoLoaded(loaded)
  if self[31] then
    self[31].loaded = loaded
  end
end
function ChatMessageData:GetChatId()
  return self[1]
end
function ChatMessageData:GetId()
  return self[2]
end
function ChatMessageData:GetName()
  if self[3] == nil then
    if self.isSelf then
      self[3] = Game.Myself.data.name
    else
      local socialData = Game.SocialManager:Find(self:GetId())
      if socialData and socialData.name ~= "" then
        self[3] = socialData.name
      end
    end
  end
  return self[3]
end
function ChatMessageData:GetChannel()
  if NetConfig.PBC then
    local result = Channel_Enum_String[self[4]]
    if result then
      return result
    else
      return self[4]
    end
  else
    return self[4]
  end
end
function ChatMessageData:GetChannelName()
  return self[5]
end
function ChatMessageData:GetHair()
  if self[6] == nil then
    if self.isSelf then
      self[6] = Game.Myself.data.userdata:Get(UDEnum.HAIR)
    else
      local socialData = Game.SocialManager:Find(self:GetId())
      if socialData and socialData.hairID ~= 0 then
        self[6] = socialData.hairID
      end
    end
  end
  return self[6]
end
function ChatMessageData:GetHaircolor()
  if self[7] == nil then
    if self.isSelf then
      self[7] = Game.Myself.data.userdata:Get(UDEnum.HAIRCOLOR)
    else
      local socialData = Game.SocialManager:Find(self:GetId())
      if socialData and socialData.haircolor ~= 0 then
        self[7] = socialData.haircolor
      end
    end
  end
  return self[7]
end
function ChatMessageData:GetBody()
  if self[8] == nil then
    if self.isSelf then
      self[8] = Game.Myself.data.userdata:Get(UDEnum.BODY)
    else
      local socialData = Game.SocialManager:Find(self:GetId())
      if socialData and socialData.bodyID ~= 0 then
        self[8] = socialData.bodyID
      end
    end
  end
  return self[8]
end
function ChatMessageData:GetGender()
  if self[9] == nil then
    if self.isSelf then
      self[9] = Game.Myself.data.userdata:Get(UDEnum.SEX)
    else
      local socialData = Game.SocialManager:Find(self:GetId())
      if socialData and socialData.gender ~= 0 then
        self[9] = socialData.gender
      end
    end
  end
  return self[9]
end
function ChatMessageData:GetHead()
  if self[22] == nil then
    if self.isSelf then
      self[22] = Game.Myself.data.userdata:Get(UDEnum.HEAD)
    else
      local socialData = Game.SocialManager:Find(self:GetId())
      if socialData and socialData.headID ~= 0 then
        self[22] = socialData.headID
      end
    end
  end
  return self[22]
end
function ChatMessageData:GetFace()
  if self[23] == nil then
    if self.isSelf then
      self[23] = Game.Myself.data.userdata:Get(UDEnum.FACE)
    else
      local socialData = Game.SocialManager:Find(self:GetId())
      if socialData and socialData.faceID ~= 0 then
        self[23] = socialData.faceID
      end
    end
  end
  return self[23]
end
function ChatMessageData:GetMouth()
  if self[24] == nil then
    if self.isSelf then
      self[24] = Game.Myself.data.userdata:Get(UDEnum.MOUTH)
    else
      local socialData = Game.SocialManager:Find(self:GetId())
      if socialData and socialData.mouthID ~= 0 then
        self[24] = socialData.mouthID
      end
    end
  end
  return self[24]
end
function ChatMessageData:GetEye()
  if self[26] == nil then
    if self.isSelf then
      self[26] = Game.Myself.data.userdata:Get(UDEnum.EYE)
    else
      local socialData = Game.SocialManager:Find(self:GetId())
      if socialData and socialData.eyeID ~= 0 then
        self[26] = socialData.eyeID
      end
    end
  end
  return self[26]
end
function ChatMessageData:GetGuildname()
  if self[10] == nil then
    if self.isSelf then
      self[10] = GuildProxy.Instance.myGuildData and GuildProxy.Instance.myGuildData.name
    else
      local socialData = Game.SocialManager:Find(self:GetId())
      if socialData and socialData.guildname ~= "" then
        self[10] = socialData.guildname
      end
    end
  end
  return self[10]
end
function ChatMessageData:GetProfession()
  return self[11]
end
function ChatMessageData:GetStr(isStripSymbols)
  local str = self[12]
  if isStripSymbols then
    if self.strStripSymbols == nil then
      self.strStripSymbols = ChatRoomProxy.Instance:StripSymbols(str)
    end
    return self.strStripSymbols
  else
    return str
  end
end
function ChatMessageData:GetShowStr(isStripSymbols)
  if self:GetPhoto() then
    return ZhString.Chat_PhotoSimply
  else
    return self:GetStr(isStripSymbols)
  end
end
function ChatMessageData:GetLevel()
  if self[13] == nil then
    if self.isSelf then
      self[13] = MyselfProxy.Instance:RoleLevel()
    else
      local socialData = Game.SocialManager:Find(self:GetId())
      if socialData and socialData.level ~= 0 then
        self[13] = socialData.level
      end
    end
  end
  return self[13]
end
function ChatMessageData:GetCellType()
  return self[14]
end
function ChatMessageData:GetVoiceid()
  return self[15]
end
function ChatMessageData:GetVoicetime()
  return self[16]
end
function ChatMessageData:GetTime()
  return self[17]
end
function ChatMessageData:GetTargetid()
  return self[18]
end
function ChatMessageData:GetAppellation()
  if self[19] == nil then
    if self.isSelf then
      local achData = MyselfProxy.Instance:GetCurManualAppellation()
      if achData then
        self[19] = achData.id
      end
    else
      local socialData = Game.SocialManager:Find(self:GetId())
      if socialData and socialData.appellation ~= 0 then
        self[19] = socialData.appellation
      end
    end
  end
  return self[19]
end
function ChatMessageData:GetBlink()
  if self[20] == nil then
    if self.isSelf then
      self[20] = FunctionPlayerHead.Me().blinkEnabled
    else
      local socialData = Game.SocialManager:Find(self:GetId())
      if socialData then
        self[20] = socialData.blink
      end
    end
  end
  return self[20]
end
function ChatMessageData:GetPortrait()
  if self[21] == nil then
    if self.isSelf then
      self[21] = Game.Myself.data.userdata:Get(UDEnum.PORTRAIT)
    else
      local socialData = Game.SocialManager:Find(self:GetId())
      if socialData and socialData.portrait ~= 0 then
        self[21] = socialData.portrait
      end
    end
  end
  return self[21]
end
function ChatMessageData:GetZoneId()
  if self[27] == nil then
    if self.isSelf then
      self[27] = Game.Myself.data.userdata:Get(UDEnum.ZONEID)
    else
      local socialData = Game.SocialManager:Find(self:GetId())
      if socialData and socialData.zoneid ~= 0 then
        self[27] = socialData.zoneid
      end
    end
  end
  return self[27]
end
function ChatMessageData:GetServerId()
  if self[28] == nil then
    if self.isSelf then
      self[28] = Game.Myself.data.userdata:Get(UDEnum.SERVERID)
    else
      local socialData = Game.SocialManager:Find(self:GetId())
      if socialData and socialData.serverid ~= 0 then
        self[28] = socialData.serverid
      end
    end
  end
  return self[28]
end
function ChatMessageData:GetAccId()
  return self[29]
end
function ChatMessageData:GetHomeId()
  return self[30]
end
function ChatMessageData:GetPhoto(isParse)
  if isParse then
    self:TryParsePhotoInfo()
  end
  return self[31] or self.photoInfo
end
function ChatMessageData:GetPhotoInfo()
  local photoData = self[31]
  if photoData then
    local accid, charid, source, sourceid, time = 0, 0, 0, 0, 0
    accid = photoData.isBelongAccPic and (photoData.charid or 0)
    charid = photoData.charid or 0
    source = photoData.source or 0
    sourceid = photoData.sourceid or 0
    time = photoData.time or 0
    return string.format("%d,%d,%d,%d,%d", accid, charid, source, sourceid, time)
  end
  return ""
end
function ChatMessageData:GetExpressionType()
  return self[32]
end
function ChatMessageData:GetExpressionId()
  return self[33] or 0
end
function ChatMessageData:GetPortraitFrame()
  if self[34] == nil then
    if self.isSelf then
      self[34] = Game.Myself.data.userdata:Get(UDEnum.PORTRAIT_FRAME)
    else
      local socialData = Game.SocialManager:Find(self:GetId())
      if socialData and socialData.portraitframe ~= 0 then
        self[34] = socialData.portraitframe
      end
    end
  end
  return self[34]
end
function ChatMessageData:GetExpressionType()
  return self[32]
end
function ChatMessageData:GetExpressionId()
  return self[33] or 0
end
function ChatMessageData:IsReturnUser()
  return self[35] or false
end
function ChatMessageData:GetChatframeId()
  return self[36] or 0
end
function ChatMessageData:GetMainViewText()
  if self.mainViewText == nil then
    local channel = self:GetChannel()
    local cellType = self:GetCellType()
    local expressionId = self:GetExpressionId()
    local color = ChatRoomProxy.Instance.channelColor[channel]
    local name = ""
    if expressionId == 0 and cellType ~= ChatTypeEnum.SystemMessage then
      if channel == ChatChannelEnum.Private and self:GetId() == Game.Myself.data.id then
        local targetid = self:GetTargetid()
        if targetid then
          local chatData = ChatRoomProxy.Instance.privateChatList[targetid]
          if chatData then
            name = string.format(ZhString.Chat_PrivateMainView, color, tostring(chatData.name), color)
          end
        end
      else
        local dataName = self:GetName()
        if dataName then
          name = string.format(ZhString.Chat_MainView, tostring(dataName), color)
        end
      end
    end
    local str = ""
    if self:GetPhoto() then
      str = ZhString.Chat_PhotoSimply
    elseif cellType == ChatTypeEnum.SystemMessage then
      str = self:GetStr()
    elseif expressionId ~= 0 then
      local targetId = self:GetTargetid()
      local targetData = Game.SocialManager:Find(targetId)
      if not targetData then
        local targetCreature = SceneCreatureProxy.FindCreature(targetId)
        targetData = targetCreature and targetCreature.data
      end
      str = ChatRoomProxy.MakeExpressionText(self:GetStr(true), self:GetName(), targetData and targetData.name)
    else
      str = AppendSpace2Str(self:GetStr(true))
    end
    self.mainViewText = string.format("%s%s | [-]%s%s%s[-]", color, ChatRoomProxy.Instance.channelNames[channel], name, color, str)
  end
  return self.mainViewText
end
function ChatMessageData:CanDestroy()
  if self[25] and ServerTime.CurServerTime() / 1000 - self[17] > self[25] then
    return true
  end
  return false
end
function ChatMessageData:IsTeamGroup()
  return self.isTeamGroup
end
function ChatMessageData:IsPhotoLoaded()
  return self[31] and self[31].loaded
end
function ChatMessageData:TransByHeadImageData(data)
  local iconData = data.iconData
  if iconData.type == HeadImageIconType.Simple then
    self.portraitImage = iconData.icon
  elseif iconData.type == HeadImageIconType.Avatar then
    self[6] = iconData.hairID
    self[7] = iconData.haircolor
    self[8] = iconData.bodyID
    self[9] = iconData.gender
    self[26] = iconData.eyeID
  end
end
local tempPhotoData = {}
function ChatMessageData:TryParsePhotoInfo()
  if self.photoInfo ~= nil then
    local strsp = string.split(self.photoInfo, ",")
    if #strsp < 5 then
      redlog("local photo info format error")
    else
      tempPhotoData.accid = tonumber(strsp[1]) or 0
      tempPhotoData.charid = tonumber(strsp[2]) or 0
      tempPhotoData.source = tonumber(strsp[3]) or 0
      tempPhotoData.sourceid = tonumber(strsp[4]) or 0
      tempPhotoData.time = tonumber(strsp[5]) or 0
      if tempPhotoData.source ~= 0 and tempPhotoData.sourceid ~= 0 then
        self[31] = PhotoData.new(tempPhotoData)
        if self[2] == Game.Myself.data.id then
          self:SetPhotoLoaded(true)
        end
      end
    end
    self.photoInfo = nil
  end
end
function ChatMessageData:GetRedPacketGUID()
  return self.redPacketGUID
end
function ChatMessageData:GetRedPacketIcon()
  local config = Table_Item[self.redPacketItemId]
  if config then
    return config.Icon
  end
end
function ChatMessageData:DoConstruct(asArray, serverData)
  ChatMessageData.super.DoConstruct(self, asArray, serverData)
  self:SetData(serverData)
end
function ChatMessageData:DoDeconstruct(asArray)
  ChatMessageData.super.DoDeconstruct(self, asArray)
  self.strStripSymbols = nil
  self.mainViewText = nil
  self.isSelf = nil
  self.portraitImage = nil
  self.roleType = nil
  self.isTeamGroup = nil
  self.alignment = nil
  self.isHideInSimplify = nil
  self.photoInfo = nil
  self.share_data = nil
  TableUtility.ArrayClear(self)
end
