local BaseCell = autoImport("BaseCell")
QuestionnaireChooseCell = class("QuestionnaireChooseCell", BaseCell)
function QuestionnaireChooseCell:Init()
  QuestionnaireChooseCell.super.Init(self)
  self:FindObjs()
  self:AddEvts()
  self:AddCellClickEvent()
end
function QuestionnaireChooseCell:FindObjs()
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self.desc = self:FindGO("Desc"):GetComponent(UILabel)
  self.seperateBG = self:FindGO("SeperateBg")
  self.inputField = self:FindGO("InputField")
  self.answerInput = self.inputField:GetComponent(UIInput)
end
function QuestionnaireChooseCell:SetData(data)
  self.inputField:SetActive(false)
  local _, extra = math.modf(self.indexInList / 2)
  self.seperateBG:SetActive(extra > 0)
  self.chooseStatus = false
  self.chooseSymbol:SetActive(false)
  local chooseLabel = data
  self.desc.text = chooseLabel
end
function QuestionnaireChooseCell:SetChoose(bool)
  self.chooseStatus = bool
  self.chooseSymbol:SetActive(bool)
end
function QuestionnaireChooseCell:SwitchStatus()
  self.chooseStatus = not self.chooseStatus
  self.chooseSymbol:SetActive(self.chooseStatus)
end
function QuestionnaireChooseCell:AddEvts()
  local onSubmit = function()
    self:PassEvent(PlayerSurveyEvent.OnManualInputSubmit, self)
  end
  EventDelegate.Set(self.answerInput.onSubmit, function()
    local manualInput = self.answerInput.value
    if #manualInput > 100 then
      local subInput = StringUtil.Sub(manualInput, 1, 100)
      self.answerInput.value = subInput
    end
    self:PassEvent(PlayerSurveyEvent.OnManualInputSubmit, self)
  end)
  self:AddSelectEvent(self.answerInput, onSubmit)
end
function QuestionnaireChooseCell:SetInputField()
  self.inputField:SetActive(self.chooseStatus)
end
function QuestionnaireChooseCell:SetInputAnswer(text)
  self.answerInput.value = text
end
