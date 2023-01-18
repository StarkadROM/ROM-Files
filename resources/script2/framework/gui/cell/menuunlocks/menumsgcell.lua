local BaseCell = autoImport("BaseCell")
MenuMsgCell = class("MenuMsgCell", BaseCell)
function MenuMsgCell:Init()
  self:InitUI()
end
function MenuMsgCell:InitUI()
  self.tip = SpriteLabel.new(self:FindGO("MsgLabel"), nil, 50, 50, true)
  self.icon = self:FindGO("TitleIcon"):GetComponent(UISprite)
  self.animHelper = self.gameObject:GetComponent(SimpleAnimatorPlayer)
  self.animHelper = self.animHelper.animatorHelper
  self:AddAnimatorEvent()
  local go = self:LoadPreferb_ByFullPath(ResourcePathHelper.EffectUI("TitleEffect"), self:FindGO("EffectContainer"))
  go.transform.localPosition = LuaGeometry.GetTempVector3(0, 83.7, 0)
end
function MenuMsgCell:IsShowed()
  return self.isShowed
end
function MenuMsgCell:ResetAnim()
  self.isShowed = false
  TimeTickManager.Me():ClearTick(self)
  TimeTickManager.Me():CreateOnceDelayTick(GameConfig.ItemPopShowTimeLim, function(owner, deltaTime)
    self.isShowed = true
  end, self)
end
function MenuMsgCell:PlayHide()
  if self.isShowed then
    self:PassEvent(SystemUnLockEvent.ShowNextEvent, self.data)
  end
end
function MenuMsgCell:AddAnimatorEvent()
  function self.animHelper.loopCountChangedListener(state, oldLoopCount, newLoopCount)
    if not self.isShowed then
      self.isShowed = true
    end
  end
end
function MenuMsgCell:SetData(data)
  self.data = data
  self:ResetAnim()
  self.tip:Reset()
  if data.Type.isMenu then
    local config = data.data
    local msg = config.Tip
    if config.event and config.event.type == "scenery" then
      local _, viewindex = next(config.event.param)
      if viewindex and Table_Viewspot[viewindex] then
        local pointName = Table_Viewspot[viewindex].SpotName
        msg = string.format(msg, pointName)
      end
    end
    self.tip:SetText(msg, true)
    self:SetTitleIcon(config.Icon)
  else
    local config = self.data.data
    self.tip:SetText(config.text, true)
    self:SetTitleIcon(config.title)
  end
  self.animHelper:Play("UnLockMsg1", 1, false)
  self:PlayUISound(AudioMap.Maps.FunctionUnlock)
end
local min = math.min
local MAX_SIZE = 100
function MenuMsgCell:SetTitleIcon(configIcon)
  local atlasStr
  local iconStr = ""
  if configIcon ~= nil then
    if type(configIcon) == "table" then
      atlasStr, iconStr = next(configIcon)
    else
      atlasStr, iconStr = MsgParserProxy.Instance:GetIconInfo(configIcon)
    end
    if atlasStr ~= nil and iconStr ~= nil then
      self:Show(self.icon)
      if atlasStr == "itemicon" then
        IconManager:SetItemIcon(iconStr, self.icon)
        self.icon:MakePixelPerfect()
      elseif atlasStr == "skillicon" then
        IconManager:SetSkillIcon(iconStr, self.icon)
        self.icon:MakePixelPerfect()
      else
        IconManager:SetUIIcon(iconStr, self.icon)
        self.icon:MakePixelPerfect()
      end
      self.icon.width = min(self.icon.width, MAX_SIZE)
      self.icon.height = min(self.icon.height, MAX_SIZE)
      self.icon.transform.localScale = LuaGeometry.GetTempVector3(1.3, 1.3, 1)
    else
      self:Hide(self.icon)
    end
  else
    self:Hide(self.icon)
  end
end
