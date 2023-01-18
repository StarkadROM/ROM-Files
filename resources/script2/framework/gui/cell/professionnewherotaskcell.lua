local BaseCell = autoImport("BaseCell")
ProfessionNewHeroTaskCell = class("ProfessionNewHeroTaskCell", BaseCell)
local NormalColor = Color(0.12156862745098039, 0.4549019607843137, 0.7490196078431373, 1)
local FinishedColor = Color(0.3686274509803922, 0.7176470588235294, 0.1450980392156863, 1)
local FinishAlpha = 0.5
function ProfessionNewHeroTaskCell:ctor(obj)
  ProfessionNewHeroTaskCell.super.ctor(self, obj)
  self:FindObjs()
end
function ProfessionNewHeroTaskCell:FindObjs()
  local container = self:FindGO("Container")
  self.inoutTween = container:GetComponent(TweenPosition)
  self.normalGroupGO = self:FindGO("NormalGroup")
  self.goBtnGO = self:FindGO("GoBtn", self.normalGroupGO)
  self:AddClickEvent(self.goBtnGO, function()
    self:OnGotoClicked()
  end)
  self.progressGO = self:FindGO("ProgressLab", self.normalGroupGO)
  self.progressLab = self.progressGO:GetComponent(UILabel)
  self.finishGroupGO = self:FindGO("FinishGroup")
  local contentGroupGO = self:FindGO("ContentGroup")
  self.contentGroup = contentGroupGO:GetComponent(UIWidget)
  self.descLabel = self:FindComponent("Desc", UIRichLabel, contentGroupGO)
  self.descSpriteLabel = SpriteLabel.new(self.descLabel, nil, 20, 20)
end
function ProfessionNewHeroTaskCell:SetData(data)
  self.data = data
  if data then
    local exUseLua = SpriteLabel.useLuaVersion
    SpriteLabel.useLuaVersion = true
    self.descSpriteLabel:SetText(data:GetTraceInfo())
    SpriteLabel.useLuaVersion = exUseLua
    if data:IsCompleted() then
      self.finishGroupGO:SetActive(true)
      self.normalGroupGO:SetActive(false)
      self.goBtnGO:SetActive(false)
      self.contentGroup.alpha = FinishAlpha
    else
      self.finishGroupGO:SetActive(false)
      self.normalGroupGO:SetActive(true)
      local gt = data:GetGoto()
      if gt ~= nil then
        self.goBtnGO:SetActive(true)
        self.progressGO:SetActive(false)
      else
        self.goBtnGO:SetActive(false)
        self.progressGO:SetActive(true)
        self.progressLab.text = data:GetProgressStr()
      end
      self.contentGroup.alpha = 1
    end
  end
end
function ProfessionNewHeroTaskCell:SetChoose(b)
  self.selectedGO:SetActive(not not b)
end
function ProfessionNewHeroTaskCell:OnGotoClicked()
  local gotoId = self.data and self.data:GetGoto()
  if gotoId then
    GameFacade.Instance:sendNotification(UIEvent.CloseUI, MultiProfessionNewView.ViewType)
    FuncShortCutFunc.Me():CallByID(gotoId)
  end
end
