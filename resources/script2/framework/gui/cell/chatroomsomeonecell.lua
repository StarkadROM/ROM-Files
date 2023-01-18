autoImport("ChatRoomCell")
ChatRoomSomeoneCell = reusableClass("ChatRoomSomeoneCell", ChatRoomCell)
ChatRoomSomeoneCell.rid = ResourcePathHelper.UICell("ChatRoomSomeoneCell")
local pos = LuaVector3.zero
function ChatRoomSomeoneCell:Deconstruct()
  self.bgIndex = nil
  self.isTeam = false
  ChatRoomSomeoneCell.super.Deconstruct(self)
end
function ChatRoomSomeoneCell:CreateSelf(parent)
  if parent then
    self.gameObject = self:CreateObj(ChatRoomSomeoneCell.rid, parent)
  end
end
function ChatRoomSomeoneCell:FindObjs()
  ChatRoomSomeoneCell.super.FindObjs(self)
  self.zoneGO = self:FindGO("Zone")
  self.zone = self.zoneGO:GetComponent(UILabel)
  self.bg = self:FindGO("contentSpriteBg"):GetComponent(UISprite)
end
function ChatRoomSomeoneCell:SetData(data)
  ChatRoomSomeoneCell.super.SetData(self, data)
  if data ~= nil then
    local serverid = data:GetServerId()
    if serverid and serverid ~= MyselfProxy.Instance:GetServerId() then
      self.zoneGO:SetActive(true)
      self.zone.text = data:GetServerId()
    else
      self.zoneGO:SetActive(false)
    end
    self:_SetBg(data)
    if self.returnSymbol.activeSelf and data:IsReturnUser() then
      LuaVector3.Better_Set(pos, LuaGameObject.GetLocalPosition(self.adventureTrans))
      pos[1] = pos.x + self.adventure.printedSize.x + 26
      self.nameTrans.localPosition = pos
    else
      LuaVector3.Better_Set(pos, LuaGameObject.GetLocalPosition(self.adventureTrans))
      pos[1] = pos.x + self.adventure.printedSize.x + 5
      self.nameTrans.localPosition = pos
    end
  end
end
function ChatRoomSomeoneCell:_SetBg(data)
  local chatframeId = data:GetChatframeId()
  if not chatframeId or chatframeId == 0 then
    local isTeam = data:IsTeamGroup()
    if self.bgIndex or self.isTeam ~= isTeam then
      self.bgDecorate:SetActive(false)
      local bg = self.bg
      bg.spriteName = isTeam and "chatroom_bg_2" or "chatroom_bg_1"
      bg.flip = isTeam and 1 or 0
      self.isTeam = isTeam
      self.bgIndex = nil
    end
    self.chatContent.color = LuaColor.black
  else
    if not self.bgIndex or self.bgIndex ~= chatframeId then
      local config = Table_UserChatFrame[chatframeId]
      if config then
        self.bgDecorate:SetActive(true)
        local bg = self.bg
        bg.spriteName = config.BubbleName
        self.bgDecorate_Icon.spriteName = config.IconName
        self.bgIndex = chatframeId
        if config.TextColor and config.TextColor ~= "" then
          local _, color = ColorUtil.TryParseHtmlString(config.TextColor)
          self.chatContent.color = color
        else
          self.chatContent.color = LuaColor.black
        end
      end
    end
    self.contentSpriteBg.width = self.contentSpriteBg.width + 2
    LuaVector3.Better_Set(pos, self.contentSpriteBg.width, 25 - self.contentSpriteBg.height, 0)
    self.bgDecorate.transform.localPosition = pos
  end
end
