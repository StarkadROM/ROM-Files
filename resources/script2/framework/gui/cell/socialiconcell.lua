local BaseCell = autoImport("BaseCell")
SocialIconCell = class("SocialIconCell", BaseCell)
function SocialIconCell:Init()
  self.icon = self:FindGO("icon"):GetComponent(UIMultiSprite)
  self.cancelMark = self:FindGO("cancelMark")
  self.check = self:FindGO("check")
  self.mask = self:FindGO("mask")
  self.passEvent = true
  self:SetEvent(self.gameObject, function()
    if self.passEvent then
      self:PassEvent(MouseEvent.MouseClick, self)
    end
  end)
end
function SocialIconCell:SetData(data)
  self.data = data
  local key = data.key
  if not PlayerTipFuncConfig[key] then
    self.gameObject:SetActive(false)
    errorLog(string.format("%s Not Defined in FunctionPlayerTip", key))
    return
  end
  self:SetSocialState(data.socialState)
end
function SocialIconCell:SetSocialState(sState)
  local state = math.modf(sState / 10)
  self.icon.CurrentState = state - 1
  self.icon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(0.8, 0.8, 0.8)
  local showcheck = math.fmod(sState, 10) == 1
  self.check:SetActive(showcheck)
  self.mask:SetActive(showcheck)
  local showCancelMark = math.fmod(sState, 10) == 2
  self.cancelMark:SetActive(showCancelMark)
end
