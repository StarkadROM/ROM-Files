autoImport("HeadIconCell")
local baseCell = autoImport("BaseCell")
SocialBaseCell = class("SocialBaseCell", baseCell)
function SocialBaseCell:Init()
  self:FindObjs()
  self:InitShow()
end
function SocialBaseCell:FindObjs()
  self.profession = self:FindGO("ProfessIcon"):GetComponent(UISprite)
  self.professIconBG = self:FindGO("CareerBg"):GetComponent(UISprite)
  self.level = self:FindGO("Level"):GetComponent(UILabel)
  self.name = self:FindGO("Name"):GetComponent(UILabel)
  self.genderIcon = self:FindGO("GenderIcon"):GetComponent(UISprite)
end
function SocialBaseCell:InitShow()
end
function SocialBaseCell:TryInitHeadIcon()
  if self.headIcon ~= nil then
    return
  end
  local headContainer = self:FindGO("HeadContainer")
  self.headIcon = HeadIconCell.new()
  self.headIcon:CreateSelf(headContainer)
  self.headIcon.gameObject:AddComponent(UIDragScrollView)
  self.headIcon:SetScale(0.6)
  self.headIcon:SetMinDepth(1)
  self:SetEvent(self.headIcon.clickObj.gameObject, function()
    self:PassEvent(FriendEvent.SelectHead, self)
  end)
end
function SocialBaseCell:SetData(data)
  self.data = data
  self.gameObject:SetActive(data ~= nil)
  if data then
    local config = Table_Class[data.profession]
    if config then
      IconManager:SetNewProfessionIcon(config.icon, self.profession)
      local iconColor = ColorUtil["CareerIconBg" .. config.Type]
      if iconColor == nil then
        iconColor = ColorUtil.CareerIconBg0
      end
      self.professIconBG.color = iconColor
    end
    self.level.text = "Lv." .. data.level
    self:TryInitHeadIcon()
    local headData = Table_HeadImage[data.portrait]
    if data.portrait and data.portrait ~= 0 and headData and headData.Picture then
      self.headIcon:SetSimpleIcon(headData.Picture, headData.Frame)
      self.headIcon:SetPortraitFrame(data.portraitframe)
      self.headIcon:SetAfkIcon(AfkProxy.ParseIsAfk(data.afk))
    else
      self.headIcon:SetData(data)
    end
    if data.gender == ProtoCommon_pb.EGENDER_MALE then
      self.genderIcon.CurrentState = 0
    elseif data.gender == ProtoCommon_pb.EGENDER_FEMALE then
      self.genderIcon.CurrentState = 1
    end
    self.name.text = data.name
    self.name.text = AppendSpace2Str(data.name)
  end
end
