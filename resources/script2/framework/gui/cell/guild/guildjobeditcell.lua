local BaseCell = autoImport("BaseCell")
GuildJobEditCell = class("GuildJobEditCell", BaseCell)
GuildJobEditCell.GuildNameChange = "GuildJobEditCell_GuildNameChange"
GuildJobEditEvent = {
  NameChange = "GuildJobEditCell_GuildNameChange",
  AuthorityChange = "GuildJobEditEvent_AuthorityChange",
  EditAuthorityChange = "GuildJobEditEvent_EditAuthorityChange"
}
GuildJobEditType = {
  GuildAuthorityMap.InviteJoin,
  GuildAuthorityMap.KickMember,
  GuildAuthorityMap.EditPicture,
  GuildAuthorityMap.Mercenary_Invite_Approve
}
local MAX_LENGTH = GameConfig.System.guildjob_max or 5
function GuildJobEditCell:Init()
  self.input = self:FindComponent("Input", UIInput)
  self.input_boxcollider = self.input:GetComponent(BoxCollider)
  self.input_sp = self.input:GetComponent(UISprite)
  self.authInfoMap = {}
  for i = 1, #GuildJobEditType do
    local authorityType = GuildJobEditType[i]
    local authInfo = {}
    authInfo.symbol = self:FindComponent("Auth_" .. authorityType, UISprite)
    authInfo.tog = self:FindComponent("Auth_Tog_" .. authorityType, UIToggle)
    authInfo.value = false
    self.authInfoMap[authorityType] = authInfo
    if not authInfo.tog then
      redlog("[bt] tog not found", authorityType)
    end
    self:AddClickEvent(authInfo.tog.gameObject, function(go)
      local param = {}
      param[1] = self
      param[2] = authorityType
      param[3] = authInfo.tog.value
      self:PassEvent(GuildJobEditEvent.AuthorityChange, param)
    end)
    break
  end
  self.editAuthInfo = {}
  self.editAuthInfo.symbol = self:FindComponent("Auth_Edit", UISprite)
  self.editAuthInfo.tog = self:FindComponent("Auth_Tog_Edit", UIToggle)
  self.editAuthInfo.value = false
  self:AddClickEvent(self.editAuthInfo.tog.gameObject, function(go)
    self:PassEvent(GuildJobEditEvent.EditAuthorityChange, {
      self,
      self.editAuthInfo.tog.value
    })
  end)
  EventDelegate.Set(self.input.onChange, function()
    self:PassEvent(GuildJobEditEvent.NameChange, self)
  end)
  self:AddSelectEvent(self.input, function(go, state)
    if state and FunctionUnLockFunc.Me():ForbidInput(ProtoCommon_pb.EFUNCPARAM_RENAME_GUILD_JOBNAME) then
      self.input.isSelected = false
    end
  end)
  UIUtil.LimitInputCharacter(self.input, MAX_LENGTH)
end
function GuildJobEditCell:SetData(data)
  self.data = data
  if data then
    data.name = OverSea.LangManager.Instance():GetLangByKey(data.name)
    self.input.value = data.name
    local canEditName = GuildProxy.Instance:CanIDoAuthority(GuildAuthorityMap.SetJobname)
    self.input_boxcollider.enabled = canEditName
    self.input_sp.enabled = canEditName
    self:UpdateAuthoritys()
    self:UpdateEditSymbol()
  end
end
function GuildJobEditCell:UpdateAuthoritys()
  local guildProxy = GuildProxy.Instance
  for authorityType, authInfo in pairs(self.authInfoMap) do
    local canedit = guildProxy:CanIEditAuthority(self.data.id, authorityType)
    local cando = guildProxy:CanJobDoAuthority(self.data.id, authorityType)
    authInfo.value = cando
    if authorityType == GuildAuthorityMap.Mercenary_Invite_Approve then
      local isChairMan = guildProxy:ImGuildChairman()
      canedit = isChairMan and self.data.id == GuildJobType.ViceChairman or false
    end
    if canedit then
      authInfo.tog.gameObject:SetActive(true)
      authInfo.symbol.gameObject:SetActive(false)
      authInfo.tog.value = cando
    else
      authInfo.tog.gameObject:SetActive(false)
      authInfo.symbol.gameObject:SetActive(true)
      authInfo.symbol.spriteName = authInfo.value and "com_icon_check" or "com_icon_off"
      authInfo.symbol:MakePixelPerfect()
    end
  end
end
function GuildJobEditCell:UpdateEditSymbol()
  local authInfo = self.editAuthInfo
  local isChairMan = GuildProxy.Instance:ImGuildChairman()
  if isChairMan and self.data.id == GuildJobType.ViceChairman then
    authInfo.tog.gameObject:SetActive(true)
    authInfo.symbol.gameObject:SetActive(false)
    authInfo.tog.value = self.data.editauth > 0
  else
    authInfo.tog.gameObject:SetActive(false)
    authInfo.symbol.gameObject:SetActive(true)
    authInfo.symbol.spriteName = self.data.editauth > 0 and "com_icon_check" or "com_icon_off"
    authInfo.symbol:MakePixelPerfect()
  end
end
