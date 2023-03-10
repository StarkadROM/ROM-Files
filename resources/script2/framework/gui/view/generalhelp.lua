autoImport("BaseTip")
GeneralHelp = class("GeneralHelp", BaseTip)
function GeneralHelp:Init()
  self:FindObjs()
  self.spritelabel = SpriteLabel.new(self.introduceLabel)
  local closeBtn = self:FindGO("CloseButton")
  self:AddClickEvent(closeBtn, function()
    self:CloseSelf()
  end)
end
function GeneralHelp:FindObjs()
  self.scrollView = self:FindGO("IntroduceScrollView"):GetComponent(UIScrollView)
  self.title = self:FindGO("Title"):GetComponent(UILabel)
  self.introduceLabel = self:FindGO("IntroduceLabel"):GetComponent(UIRichLabel)
  self.boundHelper = self:FindGO("BoundsCalulateHelper"):GetComponent(UIWidget)
  self.urlLable = self:FindGO("IntroduceLabel"):GetComponent(UILabelClickUrl)
  if self.urlLable == nil then
    self.urlLable = self:FindGO("IntroduceLabel").gameObject:AddComponent(UILabelClickUrl)
    self.introduceLabel.autoResizeBoxCollider = true
  end
  local boxCollider = self:FindGO("IntroduceLabel"):GetComponent(BoxCollider)
  if boxCollider == nil then
    self:FindGO("IntroduceLabel").gameObject:AddComponent(BoxCollider)
  end
  function self.urlLable.callback(url)
    local tb = Table_ShortcutPower[tonumber(url)]
    if tb ~= nil then
      self:CloseSelf()
      local curID = Game.MapManager:GetRaidID() or 0
      if curID ~= 0 then
        MsgManager.ShowMsgByIDTable(27002)
        return
      end
      UIManagerProxy.Instance:ReturenToMainView()
      FuncShortCutFunc.Me():CallByID(tb.id)
    end
  end
end
function GeneralHelp:SetData(data)
  self.data = data
  if data then
    self.spritelabel:SetText(OverSea.LangManager.Instance():GetLangByKey(data))
    self.boundHelper:UpdateAnchors()
    self.scrollView:ResetPosition()
  end
end
function GeneralHelp:SetTitle(title)
  self.title.text = StringUtil.IsEmpty(title) and ZhString.Help_Title or title
end
function GeneralHelp:CloseSelf()
  TipsView.Me():HideCurrent()
  EventManager.Me():DispatchEvent(UICloseEvent.GeneralHelpClose)
end
function GeneralHelp:DestroySelf()
  GameObject.Destroy(self.gameObject)
end
