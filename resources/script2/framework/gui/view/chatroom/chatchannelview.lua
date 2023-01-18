autoImport("WrapScrollViewHelper")
autoImport("ChatRoomCombineCell")
ChatChannelView = class("ChatChannelView", SubView)
local SwitchBarrage = function(self)
  if self.BarrageRoot.CurrentState == BarrageStateEnum.Off then
    self:ShowBarrage(BarrageStateEnum.On)
  elseif self.BarrageRoot.CurrentState == BarrageStateEnum.On then
    self:ShowBarrage(BarrageStateEnum.Off)
  end
end
local ClickBarrage = function(self)
  SwitchBarrage(self)
  ChatRoomProxy.Instance:SetBarrageState(self.curChannel, self.BarrageRoot.CurrentState)
end
local ClickPetTalk = function(self)
  ServiceNUserProxy.Instance:CallNewSetOptionUserCmd(SceneUser2_pb.EOPTIONTYPE_USE_PETTALK, self.BarrageRoot.CurrentState == BarrageStateEnum.On and 0 or 1)
end
local ClickServer = function(self)
  SwitchBarrage(self)
  ChatRoomProxy.Instance:SetServerState(self.curChannel, self.BarrageRoot.CurrentState)
end
local BarrageType = {
  [ChatChannelEnum.World] = {
    ClickFunc = ClickServer,
    Text = ZhString.Chat_Server
  },
  [ChatChannelEnum.Current] = {
    ClickFunc = ClickPetTalk,
    Text = ZhString.Chat_PetTalk,
    Atlas = "uiicon",
    Icon = "tab_icon_47",
    Size = {80, 80}
  },
  [ChatChannelEnum.Team] = {
    ClickFunc = ClickBarrage,
    Text = ZhString.Chat_Barrage,
    Atlas = "NewUI6",
    Icon = "new-chatroom_icon_barrage",
    Size = {40, 40}
  },
  [ChatChannelEnum.Guild] = {
    ClickFunc = ClickBarrage,
    Text = ZhString.Chat_Barrage,
    Atlas = "NewUI6",
    Icon = "new-chatroom_icon_barrage",
    Size = {40, 40}
  },
  [ChatChannelEnum.GVG] = {
    ClickFunc = ClickBarrage,
    Text = ZhString.Chat_Barrage,
    Atlas = "NewUI6",
    Icon = "new-chatroom_icon_barrage",
    Size = {40, 40}
  },
  [ChatChannelEnum.ReserveRoom] = {
    ClickFunc = ClickBarrage,
    Text = ZhString.Chat_Barrage,
    Atlas = "NewUI6",
    Icon = "new-chatroom_icon_barrage",
    Size = {40, 40}
  }
}
local ToSimplify = {
  [ChatChannelEnum.System] = ChatChannelEnum.All,
  [ChatChannelEnum.World] = ChatChannelEnum.All
}
local skyBlue = LuaColor.New(0.7372549019607844, 1, 1, 1)
local colorGray = LuaColor.Gray()
function ChatChannelView:Init()
  self.Color = {Default = "B8BDDC", Toggle = "FFFFFF"}
  self.recruitReqInterval = 30
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self:InitShow()
end
function ChatChannelView:FindObjs()
  self.ChatChannel = self.container.ChatChannel
  self.contentScrollView = self:FindGO("contentScrollView", self.ChatChannel):GetComponent(UIScrollView)
  self.ContentPanel = self.contentScrollView.gameObject:GetComponent(UIPanel)
  self.ChannelToggle_system = self:FindGO("ChannelToggle_system", self.ChatChannel):GetComponent(UIToggle)
  self.ChannelToggle_world = self:FindGO("ChannelToggle_world", self.ChatChannel):GetComponent(UIToggle)
  self.ChannelToggle_current = self:FindGO("ChannelToggle_current", self.ChatChannel):GetComponent(UIToggle)
  self.ChannelToggle_guild = self:FindGO("ChannelToggle_guild", self.ChatChannel):GetComponent(UIToggle)
  self.ChannelToggle_gvg = self:FindGO("ChannelToggle_gvg", self.ChatChannel):GetComponent(UIToggle)
  self.ChannelToggle_Team = self:FindGO("ChannelToggle_Team", self.ChatChannel):GetComponent(UIToggle)
  self.ChannelToggle_return = self:FindGO("ChannelToggle_return", self.ChatChannel):GetComponent(UIToggle)
  self.ChannelToggle_recruit = self:FindGO("ChannelToggle_Recruit", self.ChatChannel):GetComponent(UIToggle)
  self.SystemLabel = self:FindGO("SystemLabel", self.ChannelToggle_system.gameObject):GetComponent(UILabel)
  self.WorldLabel = self:FindGO("WorldLabel", self.ChannelToggle_world.gameObject):GetComponent(UILabel)
  self.CurrentLabel = self:FindGO("CurrentLabel", self.ChannelToggle_current.gameObject):GetComponent(UILabel)
  self.GuildLabel = self:FindGO("GuildLabel", self.ChannelToggle_guild.gameObject):GetComponent(UILabel)
  self.TeamLabel = self:FindGO("TeamLabel", self.ChannelToggle_Team.gameObject):GetComponent(UILabel)
  self.ReturnLabel = self:FindGO("ReturnLabel", self.ChannelToggle_return.gameObject):GetComponent(UILabel)
  self.RecruitLabel = self:FindGO("RecruitLabel", self.ChannelToggle_recruit.gameObject):GetComponent(UILabel)
  self.ContentTable = self:FindGO("ContentTable", self.ChatChannel)
  self.NewMessage = self:FindGO("NewMessageBg", self.ChatChannel)
  self.NewMessageLabel = self:FindGO("NewMessageLabel", self.NewMessage):GetComponent(UILabel)
  self.barrageRootGo = self:FindGO("BarrageRoot", self.ChatChannel)
  self.BarrageRoot = self.barrageRootGo:GetComponent(UIMultiSprite)
  self.BarrageOff = self:FindGO("BarrageOff", self.barrageRootGo)
  self.BarrageOn = self:FindGO("BarrageOn", self.barrageRootGo)
  self.barrageOffLabel = self:FindGO("BarrageOffLabel", self.barrageRootGo):GetComponent(UILabel)
  self.barrageOnLabel = self:FindGO("BarrageOnLabel", self.barrageRootGo):GetComponent(UILabel)
  self.barrageIcon = self:FindGO("BarrageIcon", self.barrageRootGo):GetComponent(GradientUISprite)
  self.ChannelToggle_ReserveRoom = self:FindGO("ChannelToggle_ReserveRoom", self.ChatChannel):GetComponent(UIToggle)
  self.ReserveRoomLabel = self:FindComponent("Label", UILabel, self.ChannelToggle_ReserveRoom.gameObject)
  self.chatChannelGrid = self:FindComponent("ChatRoomChannel", UIGrid, self.ChatChannel)
  self.guildMercenary = self:FindGO("GuildMercenary", self.ChatChannel)
  self.guildMercenaryName = self:FindGO("Name", self.guildMercenary):GetComponent(UILabel)
end
function ChatChannelView:AddEvts()
  self:AddClickEvent(self.ChannelToggle_system.gameObject, function(g)
    self:ClickChannelToggle_system(g)
  end)
  self:AddClickEvent(self.ChannelToggle_world.gameObject, function(g)
    self:ClickChannelToggle_world(g)
  end)
  self:AddClickEvent(self.ChannelToggle_current.gameObject, function(g)
    self:ClickChannelToggle_current(g)
  end)
  self:AddClickEvent(self.ChannelToggle_guild.gameObject, function(g)
    self:ClickChannelToggle_guild(g)
  end)
  self:AddClickEvent(self.ChannelToggle_gvg.gameObject, function(g)
    self:ClickChannelToggle_gvg(g)
  end)
  self:AddClickEvent(self.ChannelToggle_Team.gameObject, function(g)
    self:ClickChannelToggle_Team(g)
  end)
  self:AddClickEvent(self.ChannelToggle_return.gameObject, function(g)
    self:ClickChannelToggle_return(g)
  end)
  self:AddClickEvent(self.ChannelToggle_recruit.gameObject, function(g)
    self:ClickChannelToggle_recruit(g)
  end)
  self:AddClickEvent(self.NewMessage, function(g)
    self:HandleNewMessage()
  end)
  self:AddClickEvent(self.barrageRootGo, function(g)
    self:ClickBarrage()
  end)
  self:AddClickEvent(self.ChannelToggle_ReserveRoom.gameObject, function(g)
    self:ClickChannelToggle_ReserveRoom(g)
  end)
end
function ChatChannelView:AddViewEvts()
  self:AddListenEvt(ServiceEvent.SessionTeamEnterTeam, self.HandleResetTalk)
  self:AddListenEvt(ServiceEvent.SessionTeamExitTeam, self.HandleResetTalk)
  self:AddListenEvt(ServiceEvent.GuildCmdEnterGuildGuildCmd, self.HandleGuild)
  self:AddListenEvt(ServiceEvent.GuildCmdExitGuildGuildCmd, self.HandleGuild)
  self:AddListenEvt(GuildEvent.EnterMercenary, self.HandleGVG)
  self:AddListenEvt(GuildEvent.ExitMercenary, self.HandleGVG)
  self:AddListenEvt(ServiceEvent.GuildCmdGuildDataUpdateGuildCmd, self.HandleGVG)
  self:AddListenEvt(MyselfEvent.MyDataChange, self.HandleMyDataChange)
  self:AddListenEvt(ChatRoomEvent.UpdateCurChannel, self.HandleUpdateCurChannel)
  self:AddListenEvt(ServiceEvent.SessionTeamUpdateRecruitTeamInfoTeamCmd, self.HandleRecruitTeamUpdate)
  self:AddListenEvt(ServiceEvent.SessionTeamUserApplyUpdateTeamCmd, self.HandleUserTeamApplyUpdate)
  self:AddListenEvt(ServiceEvent.SessionTeamMyGroupApplyUpdateTeamCmd, self.HandleUserTeamApplyUpdate)
end
function ChatChannelView:InitShow()
  self.SystemLabel.text = ZhString.Chat_system
  self.WorldLabel.text = ZhString.Chat_world
  self.CurrentLabel.text = ZhString.Chat_current
  self.GuildLabel.text = ZhString.Chat_guild
  self.TeamLabel.text = ZhString.Chat_team
  self:InitContentList()
  self.channelToggles = {
    self.ChannelToggle_system,
    self.ChannelToggle_world,
    self.ChannelToggle_current,
    self.ChannelToggle_guild,
    self.ChannelToggle_gvg,
    self.ChannelToggle_Team,
    self.ChannelToggle_return,
    self.ChannelToggle_recruit
  }
  local x, z
  x, self.tablePositionY, z = LuaGameObject.GetLocalPosition(self.ContentTable.transform)
  self.panelCenterY = self.ContentPanel.baseClipRegion.y
  self.panelSizeY = self.ContentPanel.baseClipRegion.w
end
function ChatChannelView:InitUI()
  local viewdata = self.container.viewdata.viewdata
  local channel
  if viewdata and viewdata.key == "Channel" then
    channel = viewdata.channel or ChatChannelEnum.System
  else
    channel = ChatRoomProxy.Instance:GetChatRoomChannel()
    if channel == ChatChannelEnum.Private then
      channel = nil
    end
  end
  local flag = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_USERRETURN_FLAG) or 0
  self.ChannelToggle_return.gameObject:SetActive(flag ~= 0)
  if channel ~= nil then
    self:SetDefaultColor()
    self.curChannel = channel
    self:SetToggle(self.curChannel)
    self:SetToggleColor()
    self:ResetTalk()
  end
  self:ResetNewMessage()
  self.ContentTable:SetActive(true)
  if self.ChannelToggle_ReserveRoom ~= nil then
    self.ChannelToggle_ReserveRoom.gameObject:SetActive(true)
  end
  self:UpdateGVG(self:IsShowGVG())
  self.chatChannelGrid:Reposition()
end
function ChatChannelView:OnEnter()
  self.super.OnEnter(self)
  self:InitUI()
end
function ChatChannelView:OnExit()
  self.isShowGVG = nil
  self.ContentTable:SetActive(false)
  ChatChannelView.super.OnExit(self)
end
function ChatChannelView:RecvChatRetUserCmd(note)
  if note.body:GetChannel() ~= self.curChannel then
    return
  end
  xdlog("RecvChatRetUserCmd", note.body:GetChannel())
  if self.isLock then
    if note.body:GetId() == Game.Myself.data.id then
      self.isLock = false
      self.unRead = 0
    else
      self.unRead = self.unRead + 1
    end
  end
  if self.unRead > 0 then
    self:ShowNewMessage()
    self:UpdateChatChannelInfo(self.curChannel)
  else
    self.NewMessage:SetActive(false)
    self:ResetPositionInfo()
  end
end
function ChatChannelView:InitContentList()
  self.itemContent = WrapScrollViewHelper.new(ChatRoomCombineCell, ChatRoomPage.rid, self.contentScrollView.gameObject, self.ContentTable, 25, function()
    if self.itemContent:GetIsMoveToFirst() then
      self:ResetNewMessage()
    else
      self.isLock = true
    end
  end)
  self.itemContent:AddEventListener(ChatRoomEvent.SelectHead, self.container.HandleClickHead, self)
  self.itemContent:AddEventListener(TeamEvent.UpdateRecruitTeamInfo, self.HandleUpdateRecruitTeamInfo, self)
end
function ChatChannelView:ChatRoomPageData(channel)
  return ChatRoomProxy.Instance:GetMessagesByChannel(channel)
end
function ChatChannelView:UpdateChatChannelInfo(channel)
  if channel == nil then
    channel = self.curChannel
  end
  local datas = self:ChatRoomPageData(channel)
  if datas then
    self.itemContent:UpdateInfo(datas, self.isLock)
    self.container:ShowEmptyTip(#datas == 0, ChatRoomEnum.CHANNEL)
  end
end
function ChatChannelView:ResetPositionInfo(isCheckCanDestroy)
  local datas = self:ChatRoomPageData(self.curChannel)
  if datas then
    GameFacade.Instance:sendNotification(XDEUIEvent.ChatEmpty, #datas == 0)
    if isCheckCanDestroy then
      Game.ChatSystemManager:CheckCanDestroy(datas)
    end
    self.itemContent:ResetPosition(datas)
    self.container:ShowEmptyTip(#datas == 0, ChatRoomEnum.CHANNEL)
  end
end
function ChatChannelView:UpdatePetTalk()
  local isOn = BarrageStateEnum.On
  local option = Game.Myself.data.userdata:Get(UDEnum.OPTION)
  if option ~= nil and BitUtil.band(option, SceneUser2_pb.EOPTIONTYPE_USE_PETTALK) == 0 then
    isOn = BarrageStateEnum.Off
  end
  self:ShowBarrage(isOn)
end
function ChatChannelView:ClickChannelToggle_system(g)
  self:HandleClickChannel(ChatChannelEnum.System)
end
function ChatChannelView:ClickChannelToggle_world(g)
  self:HandleClickChannel(ChatChannelEnum.World)
end
function ChatChannelView:ClickChannelToggle_current(g)
  self:HandleClickChannel(ChatChannelEnum.Current)
end
function ChatChannelView:ClickChannelToggle_guild(g)
  self:HandleClickChannel(ChatChannelEnum.Guild)
end
function ChatChannelView:ClickChannelToggle_gvg()
  self:HandleClickChannel(ChatChannelEnum.GVG)
end
function ChatChannelView:ClickChannelToggle_Team(g)
  self:HandleClickChannel(ChatChannelEnum.Team)
end
function ChatChannelView:ClickChannelToggle_return(g)
  self:HandleClickChannel(ChatChannelEnum.Return)
end
function ChatChannelView:ClickChannelToggle_recruit(g)
  self:UpdateRecruitTeamInfo()
end
function ChatChannelView:ClickChannelToggle_ReserveRoom(g)
  self:HandleClickChannel(ChatChannelEnum.ReserveRoom)
end
function ChatChannelView:HandleClickChannel(channel)
  self:SetDefaultColor()
  self.curChannel = channel
  self:SetToggleColor()
  self:ResetNewMessage()
  self:ResetPositionInfo(true)
  self.container:ResetKeyword()
  self:ResetTalk()
end
function ChatChannelView:HandleNewMessage()
  self:ResetNewMessage()
  self:ResetPositionInfo()
end
function ChatChannelView:ClickBarrage()
  local barrageConfig = BarrageType[self.curChannel]
  if barrageConfig ~= nil then
    barrageConfig.ClickFunc(self)
  end
end
function ChatChannelView:ShowBarrage(state)
  if state ~= self.BarrageRoot.CurrentState then
    self.BarrageRoot.CurrentState = state
    if state == BarrageStateEnum.Off then
      self.BarrageOff:SetActive(true)
      self.BarrageOn:SetActive(false)
      self.barrageIcon.gradientBottom = colorGray
    elseif state == BarrageStateEnum.On then
      self.BarrageOff:SetActive(false)
      self.BarrageOn:SetActive(true)
      self.barrageIcon.gradientBottom = skyBlue
    end
  end
  local barrageConfig = BarrageType[self.curChannel]
  if barrageConfig ~= nil then
    self.barrageOnLabel.text = barrageConfig.Text
    self.barrageOffLabel.text = barrageConfig.Text
    if barrageConfig.Atlas then
      self.barrageIcon.width = barrageConfig.Size[1]
      self.barrageIcon.height = barrageConfig.Size[2]
      if IconManager:SetIconByType(barrageConfig.Icon, self.barrageIcon, barrageConfig.Atlas) then
        return
      end
      local uiAtlas = RO.AtlasMap.GetAtlas(barrageConfig.Atlas)
      if uiAtlas then
        self.barrageIcon.atlas = uiAtlas
        self.barrageIcon.spriteName = barrageConfig.Icon
      end
    end
  end
end
function ChatChannelView:ResetNewMessage()
  self.isLock = false
  self.unRead = 0
  if self.NewMessage.activeSelf then
    self.NewMessage:SetActive(false)
  end
end
function ChatChannelView:HandleResetTalk()
  if self.container.CurrentState == ChatRoomEnum.CHANNEL then
    self:ResetTalk()
  end
end
function ChatChannelView:ResetTalk()
  if self.curChannel == ChatChannelEnum.World then
    self.container:SetVisible(true)
    self:UpdateGuildMercenary(false)
    self.barrageRootGo:SetActive(false)
    self:ShowBarrage(ChatRoomProxy.Instance:GetServerState(self.curChannel))
  elseif self.curChannel == ChatChannelEnum.Current then
    self.container:SetVisible(true)
    self:UpdateGuildMercenary(false)
    self.barrageRootGo:SetActive(true)
    self:UpdatePetTalk()
  elseif self.curChannel == ChatChannelEnum.Team then
    self.container:IsInTeam()
    self:UpdateGuildMercenary(false)
    self.barrageRootGo:SetActive(true)
    self:ShowBarrage(ChatRoomProxy.Instance:GetBarrageState(self.curChannel))
  elseif self.curChannel == ChatChannelEnum.Guild then
    self.container:IsInGuild()
    self:UpdateGuildMercenary(false)
    self.barrageRootGo:SetActive(true)
    self:ShowBarrage(ChatRoomProxy.Instance:GetBarrageState(self.curChannel))
  elseif self.curChannel == ChatChannelEnum.GVG then
    self.container:SetVisible(true)
    self:UpdateGuildMercenary(true)
    self.barrageRootGo:SetActive(true)
    self:ShowBarrage(ChatRoomProxy.Instance:GetBarrageState(self.curChannel))
  elseif self.curChannel == ChatChannelEnum.System then
    self.container:SetVisible(false)
    self:UpdateGuildMercenary(false)
    self.barrageRootGo:SetActive(false)
  elseif self.curChannel == ChatChannelEnum.Return then
    self.container:SetVisible(true)
    self:UpdateGuildMercenary(false)
    self.barrageRootGo:SetActive(false)
  elseif self.curChannel == ChatChannelEnum.Recruit then
    self.container:SetVisible(false)
    self:UpdateGuildMercenary(false)
    self.barrageRootGo:SetActive(false)
  elseif self.curChannel == ChatChannelEnum.ReserveRoom then
    self.container:IsInReserveRoom()
    self:UpdateGuildMercenary(false)
    self.barrageRootGo:SetActive(true)
    self:ShowBarrage(ChatRoomProxy.Instance:GetBarrageState(self.curChannel))
  end
  ChatRoomProxy.Instance:SetCurrentChatChannel(ToSimplify[self.curChannel] or self.curChannel)
end
function ChatChannelView:SetDefaultColor()
  if self.defaultResultC == nil then
    local hasC
    hasC, self.defaultResultC = ColorUtil.TryParseHexString(self.Color.Default)
  end
  if self.defaultResultC then
    self:SetColor(self.curChannel, self.defaultResultC)
  end
end
function ChatChannelView:SetToggleColor()
  if self.toggleResultC == nil then
    local hasC
    hasC, self.toggleResultC = ColorUtil.TryParseHexString(self.Color.Toggle)
  end
  if self.toggleResultC then
    self:SetColor(self.curChannel, self.toggleResultC)
  end
end
function ChatChannelView:SetToggle(curChannel)
  for i = 1, #self.channelToggles do
    self.channelToggles[i]:Set(false)
  end
  if curChannel == ChatChannelEnum.System then
    self.ChannelToggle_system:Set(true)
  elseif curChannel == ChatChannelEnum.World then
    self.ChannelToggle_world:Set(true)
  elseif curChannel == ChatChannelEnum.Current then
    self.ChannelToggle_current:Set(true)
  elseif curChannel == ChatChannelEnum.Guild then
    self.ChannelToggle_guild:Set(true)
  elseif curChannel == ChatChannelEnum.GVG then
    self.ChannelToggle_gvg:Set(true)
  elseif curChannel == ChatChannelEnum.Team then
    self.ChannelToggle_Team:Set(true)
  elseif curChannel == ChatChannelEnum.Return then
    self.ChannelToggle_return:Set(true)
  elseif curChannel == ChatChannelEnum.Recruit then
    self.ChannelToggle_recruit:Set(true)
  elseif curChannel == ChatChannelEnum.ReserveRoom then
    self.ChannelToggle_ReserveRoom:Set(true)
  end
end
function ChatChannelView:SetColor(curChannel, color)
  if curChannel == ChatChannelEnum.System then
    self.SystemLabel.color = color
  elseif curChannel == ChatChannelEnum.World then
    self.WorldLabel.color = color
  elseif curChannel == ChatChannelEnum.Current then
    self.CurrentLabel.color = color
  elseif curChannel == ChatChannelEnum.Guild then
    self.GuildLabel.color = color
  elseif curChannel == ChatChannelEnum.Team then
    self.TeamLabel.color = color
  elseif curChannel == ChatChannelEnum.Return then
    self.ReturnLabel.color = color
  elseif curChannel == ChatChannelEnum.Recruit then
    self.RecruitLabel.color = color
  elseif curChannel == ChatChannelEnum.ReserveRoom then
    self.ReserveRoomLabel.color = color
  end
end
function ChatChannelView:SendMessage(content, voice, voicetime, photo, expression)
  ServiceChatCmdProxy.Instance:CallChatCmd(self.curChannel, content, nil, voice, voicetime, nil, nil, photo, expression)
end
function ChatChannelView:ShowNewMessage()
  if not self.NewMessage.activeSelf then
    self.NewMessage:SetActive(true)
  end
  self.NewMessageLabel.text = tostring(self.unRead) .. ZhString.Chat_newMessage
end
function ChatChannelView:HandleKeywordEffect(note)
  local datas = note.body
  if self.container.CurrentState ~= ChatRoomEnum.CHANNEL then
    return
  end
  if datas.message:GetChannel() ~= self.curChannel then
    return
  end
  self.container:AddKeywordEffect(datas.data)
end
function ChatChannelView:HandleMyDataChange(note)
  if self.curChannel == ChatChannelEnum.Current then
    self:UpdatePetTalk()
  end
end
function ChatChannelView:HandleUpdateCurChannel(note)
  self:UpdateChatChannelInfo()
end
function ChatChannelView:HandleUpdateRecruitTeamInfo(teamId)
  self:UpdateRecruitTeamInfo(teamId)
end
function ChatChannelView:UpdateRecruitTeamInfo(teamId)
  if self.recruitReqColding then
    self:HandleClickChannel(ChatChannelEnum.Recruit)
    return
  end
  local teams = ReusableTable.CreateArray()
  if teamId then
    teams = TeamProxy.Instance:GetReqRecruitTeamInfo(teams, teamId)
  else
    teams = TeamProxy.Instance:GetReqRecruitTeamInfoList(teams)
  end
  if #teams > 0 then
    ServiceSessionTeamProxy.Instance:CallReqRecruitTeamInfoTeamCmd(teams)
    self.recruitReqColding = true
    TimeTickManager.Me():CreateOnceDelayTick(self.recruitReqInterval * 1000, function()
      self.recruitReqColding = false
    end, self)
  else
    self:HandleClickChannel(ChatChannelEnum.Recruit)
  end
  ReusableTable.DestroyAndClearArray(teams)
end
function ChatChannelView:HandleRecruitTeamUpdate(note)
  self:HandleClickChannel(ChatChannelEnum.Recruit)
end
function ChatChannelView:HandleUserTeamApplyUpdate(note)
  self:ResetPositionInfo()
end
function ChatChannelView:IsShowGVG()
  local _GuildProxy = GuildProxy.Instance
  if _GuildProxy:DoIHaveMercenaryGuild() then
    return true
  end
  local num = _GuildProxy:GetMyGuildMercenaryCount()
  if num ~= nil and num > 0 then
    return true
  end
  return false
end
function ChatChannelView:UpdateGVG(isShow)
  if self.isShowGVG == isShow then
    return
  end
  self.isShowGVG = isShow
  self.ChannelToggle_gvg.gameObject:SetActive(isShow)
  if isShow then
    self:UpdateGVGName()
  end
end
function ChatChannelView:UpdateGVGName()
  local _GuildProxy = GuildProxy.Instance
  local data = _GuildProxy:GetMyMercenaryGuildData() or _GuildProxy.myGuildData
  self.guildMercenaryName.text = data.name
end
function ChatChannelView:UpdateGuildMercenary(isShow)
  self.guildMercenary:SetActive(isShow)
  if isShow then
    local transform = self.ContentTable.transform
    local x, y, z = LuaGameObject.GetLocalPosition(transform)
    transform.localPosition = LuaGeometry.GetTempVector3(x, self.tablePositionY - 48, z)
    local baseClipRegion = self.ContentPanel.baseClipRegion
    self.ContentPanel.baseClipRegion = LuaGeometry.GetTempVector4(baseClipRegion.x, self.panelCenterY - 24, baseClipRegion.z, self.panelSizeY - 48)
  else
    local transform = self.ContentTable.transform
    local x, y, z = LuaGameObject.GetLocalPosition(transform)
    transform.localPosition = LuaGeometry.GetTempVector3(x, self.tablePositionY, z)
    local baseClipRegion = self.ContentPanel.baseClipRegion
    self.ContentPanel.baseClipRegion = LuaGeometry.GetTempVector4(baseClipRegion.x, self.panelCenterY, baseClipRegion.z, self.panelSizeY)
  end
end
function ChatChannelView:HandleGuild()
  if self.container.CurrentState ~= ChatRoomEnum.CHANNEL then
    return
  end
  if self.curChannel == ChatChannelEnum.Guild then
    self:ResetTalk()
  elseif self.curChannel == ChatChannelEnum.GVG then
    self:HandleGVG()
  end
end
function ChatChannelView:HandleGVG()
  if self.container.CurrentState ~= ChatRoomEnum.CHANNEL then
    return
  end
  local isShow = self:IsShowGVG()
  if self.isShowGVG ~= isShow then
    if isShow then
      self:UpdateGVG(true)
      self.chatChannelGrid:Reposition()
    else
      self.container:CloseSelf()
    end
  end
end
function ChatChannelView:HandleGVGName()
  if self.container.CurrentState ~= ChatRoomEnum.CHANNEL then
    return
  end
  if not self.isShowGVG then
    return
  end
  self:UpdateGVGName()
end
