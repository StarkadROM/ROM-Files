autoImport("ChatRoomCell")
ChatRoomMySelfCell = reusableClass("ChatRoomMySelfCell", ChatRoomCell)
ChatRoomMySelfCell.rid = ResourcePathHelper.UICell("ChatRoomMySelfCell")
local pos = LuaVector3.Zero()
function ChatRoomMySelfCell:CreateSelf(parent)
  if parent then
    self.gameObject = self:CreateObj(ChatRoomMySelfCell.rid, parent)
  end
  self.chatframeId = nil
end
function ChatRoomMySelfCell:SetData(data)
  ChatRoomMySelfCell.super.SetData(self, data)
  if self.returnSymbol.activeSelf and data:IsReturnUser() then
    LuaVector3.Better_Set(pos, LuaGameObject.GetLocalPosition(self.adventureTrans))
    pos[1] = pos.x - self.adventure.printedSize.x - 30
    self.nameTrans.localPosition = pos
  else
    LuaVector3.Better_Set(pos, LuaGameObject.GetLocalPosition(self.adventureTrans))
    pos[1] = pos.x - self.adventure.printedSize.x - 5
    self.nameTrans.localPosition = pos
  end
  local chatframeId = data:GetChatframeId()
  if chatframeId and chatframeId ~= 0 then
    self.bgDecorate:SetActive(true)
    if self.chatframeId ~= chatframeId then
      local config = Table_UserChatFrame[chatframeId]
      if config then
        self.contentSpriteBg.flip = 1
        self.contentSpriteBg.spriteName = config.BubbleName
        self.bgDecorate_Icon.spriteName = config.IconName
        self.chatframeId = chatframeId
        if config.TextColor and config.TextColor ~= "" then
          local _, color = ColorUtil.TryParseHtmlString(config.TextColor)
          self.chatContent.color = color
        else
          self.chatContent.color = LuaColor.black
        end
      end
    end
    LuaVector3.Better_Set(pos, -2 - self.contentSpriteBg.width, 25 - self.contentSpriteBg.height, 0)
    self.bgDecorate.transform.localPosition = pos
  else
    self.bgDecorate:SetActive(false)
    self.contentSpriteBg.flip = 0
    self.contentSpriteBg.spriteName = "new-chatroom_bg_2"
    self.chatContent.color = LuaColor.black
    self.chatframeId = nil
  end
end
