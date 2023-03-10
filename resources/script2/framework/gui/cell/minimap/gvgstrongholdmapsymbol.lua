GvgStrongHoldMapSymbol = class("GvgStrongHoldMapSymbol", CoreView)
local ProgressColor = {
  Blue = Color(0.11372549019607843, 0.8431372549019608, 1, 1),
  Red = Color(0.9803921568627451, 0.11372549019607843, 0.2784313725490196, 1)
}
function GvgStrongHoldMapSymbol:ctor(obj, data, clickCallback, alwaysShowProgress)
  GvgStrongHoldMapSymbol.super.ctor(self, obj)
  self.clickCallback = clickCallback
  self.alwaysShowProgress = alwaysShowProgress
  self.guildHeadData = GuildHeadData.new()
  self:FindObjs()
  self:SetData(data)
end
function GvgStrongHoldMapSymbol:FindObjs()
  self.collider = self.gameObject:GetComponent(BoxCollider)
  if self.collider then
    self:AddClickEvent(self.gameObject, function()
      self:OnSymbolClicked()
    end)
  end
  self.activeIcon = self:FindComponent("ActiveIcon", UISprite)
  IconManager:SetMapIcon("GVG_icon_map", self.activeIcon)
  self.deactiveIcon = self:FindComponent("DeactiveIcon", UISprite)
  IconManager:SetMapIcon("map_tpvppt", self.deactiveIcon)
  self.guildIcon = self:FindComponent("GuildIcon", UISprite)
  self.guildTexture = self:FindComponent("GuildTexture", UITexture)
  self.indexLab = self:FindComponent("IndexLab", UILabel)
  self.battleIcon = self:FindComponent("BattleIcon", UISprite)
  self.progressBar = self:FindComponent("Progress", UIProgressBar)
  self.progressFg = self:FindComponent("fg", UISprite, self.progressBar.gameObject)
  self.progressBg = self:FindComponent("bg", UISprite, self.progressBar.gameObject)
end
function GvgStrongHoldMapSymbol:SetColliderEnabled(b)
  if self.clickCallback == false then
    b = false
  end
  if self.collider then
    b = b or false
    self.collider.enabled = b
  end
end
function GvgStrongHoldMapSymbol:SetData(data)
  if not data then
    return
  end
  self.data = data
  local depth = data:GetMapSymbolDepth()
  if depth then
    self.activeIcon.depth = depth
    self.deactiveIcon.depth = depth
    self.progressBg.depth = depth + 1
    self.progressFg.depth = depth + 2
    self.guildIcon.depth = depth + 1
    self.guildTexture.depth = depth + 1
    self.indexLab.depth = depth + 1
    self.battleIcon.depth = depth + 2
  end
  if data:IsActive() then
    self.activeIcon.gameObject:SetActive(true)
    self.deactiveIcon.gameObject:SetActive(false)
  else
    self.activeIcon.gameObject:SetActive(false)
    self.deactiveIcon.gameObject:SetActive(true)
  end
  self.indexLab.text = data:GetIndex()
  if data:IsOccupied() then
    self.indexLab.gameObject:SetActive(false)
    self.battleIcon.gameObject:SetActive(false)
    self:UpdateGuildIcon()
  else
    self:SetColliderEnabled(false)
    self.guildIcon.gameObject:SetActive(false)
    self.guildTexture.gameObject:SetActive(false)
    if data:IsScrambling() then
      self.indexLab.gameObject:SetActive(false)
      self.battleIcon.gameObject:SetActive(true)
    else
      self.indexLab.gameObject:SetActive(true)
      self.battleIcon.gameObject:SetActive(false)
    end
  end
  self:UpdateProgress()
end
function GvgStrongHoldMapSymbol:OnSymbolClicked()
  local guildId = self.data and self.data:GetHoldGuildId()
  if guildId and self.data:IsOccupied() and GuildProxy.Instance:IsMyGuildUnion(guildId) then
    if Game.Myself.data:HasBuffID(GameConfig.GVGConfig.go_point_cd_buff) then
      if self.clickCallback then
        self.clickCallback()
      end
      return
    end
    if self.data then
      ServiceNUserProxy.Instance:CallUseDeathTransferCmd(nil, nil, self.data and self.data.id)
    end
  elseif self.clickCallback then
    self.clickCallback()
  end
end
function GvgStrongHoldMapSymbol:UpdateGuildIcon()
  if not self.data then
    return
  end
  local guildPortrait = self.data:GetHoldGuildPortrait()
  if not guildPortrait or guildPortrait == 0 or guildPortrait == "" then
    self.guildIcon.gameObject:SetActive(false)
    self.guildTexture.gameObject:SetActive(false)
    self:SetColliderEnabled(false)
  else
    local guildHeadData = self.guildHeadData
    local guildId = self.data:GetHoldGuildId()
    guildHeadData:SetGuildId(guildId)
    guildHeadData:SetBy_InfoId(guildPortrait)
    local guildIndex = guildHeadData.index
    local isConfig = guildHeadData.type == GuildHeadData_Type.Config
    if isConfig then
      self.guildIcon.gameObject:SetActive(true)
      self.guildTexture.gameObject:SetActive(false)
      local iconName = guildHeadData.staticData and guildHeadData.staticData.Icon or ""
      IconManager:SetGuildIcon(iconName, self.guildIcon)
    else
      self.guildIcon.gameObject:SetActive(false)
      self.guildTexture.gameObject:SetActive(true)
      local pic = FunctionGuild.Me():GetCustomPicCache(guildId, guildHeadData.index)
      if pic then
        if tonumber(pic.name) == guildHeadData.time then
          self.guildTexture.mainTexture = pic
        else
          self:SetGuildCustomIcon(guildHeadData, self.guildTexture, guildIndex)
        end
      else
        self:SetGuildCustomIcon(guildHeadData, self.guildTexture, guildIndex)
      end
    end
    self:SetColliderEnabled(GuildProxy.Instance:IsMyGuildUnion(guildId))
  end
end
function GvgStrongHoldMapSymbol:SetGuildCustomIcon(data, texture, index)
  if not data or data.type ~= GuildHeadData_Type.Custom then
    return
  end
  local success_callback = function(bytes, localTimestamp)
    local pic = Texture2D(50, 50, TextureFormat.RGB24, false)
    pic.name = data.time
    local bRet = ImageConversion.LoadImage(pic, bytes)
    if not FunctionGuild.Me():GetCustomPicCache(data.guildid, data.index) then
      FunctionGuild.Me():SetCustomPicCache(data.guildid, data.index, pic)
    end
    if index == data.index and texture then
      texture.mainTexture = pic
    end
  end
  local pic_type = data.pic_type
  if StringUtil.IsEmpty(pic_type) then
    pic_type = PhotoFileInfo.PictureFormat.JPG
  end
  UnionLogo.Ins():SetUnionID(data.guildid)
  UnionLogo.Ins():GetOriginImage(UnionLogo.CallerIndex.LogoEditor, data.index, data.time, pic_type, nil, success_callback, nil, nil, nil)
end
function GvgStrongHoldMapSymbol:UpdateProgress()
  if not self.data then
    return
  end
  local guildId = self.data:GetHoldGuildId()
  if guildId and GuildProxy.Instance:IsMyGuildUnion(guildId) then
    self.progressFg.color = ProgressColor.Blue
  else
    self.progressFg.color = ProgressColor.Red
  end
  local progress = self.data:GetProgress() or 0
  if self.alwaysShowProgress or progress > 0 and progress < 1.0 then
    self.progressBar.gameObject:SetActive(true)
    self.progressBar.value = progress
  else
    self.progressBar.gameObject:SetActive(false)
  end
end
