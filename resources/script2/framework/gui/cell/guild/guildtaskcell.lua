local BaseCell = autoImport("BaseCell")
GuildTaskCell = class("GuildTaskCell", BaseCell)
local pos = LuaVector3.Zero()
function GuildTaskCell:Init()
  self:FindObjs()
  self:AddButtonEvt()
end
function GuildTaskCell:FindObjs()
  self.taskName = self:FindComponent("TaskName", UILabel)
  self.desc = self:FindComponent("Desc", UILabel)
  self.confirmed = self:FindGO("Confirmed")
  self.progress = self:FindComponent("Progress", UILabel)
  self.confirmBtn = self:FindGO("ConfirmBtn"):GetComponent(UISprite)
  self.confirmLabel = self:FindGO("Label", self.confirmBtn.gameObject):GetComponent(UILabel)
  self.taskBg1 = self:FindGO("TaskBg1")
  self.taskBg2 = self:FindGO("TaskBg2")
end
function GuildTaskCell:AddButtonEvt()
  self:AddClickEvent(self.confirmBtn.gameObject, function()
    if self.canConfirm then
      FuncShortCutFunc.Me():CallByID(1000)
    end
  end)
end
function GuildTaskCell:SetData(data)
  self.data = data
  self.gameObject:SetActive(data ~= nil)
  if data then
    local staticData = Table_GuildChallenge[data.id]
    if staticData ~= nil then
      self.taskName.text = staticData.Name
      self.desc.text = staticData.Traceinfo
      self.progress.text = string.format(ZhString.GuildChallenge_Progress, data.progress, staticData.Target)
      local sizeX = self.taskName.localSize.x
      local posX = sizeX / 2 + 28
      pos[1] = posX
      self.taskBg1.transform.localPosition = pos
      pos[1] = -posX
      self.taskBg2.transform.localPosition = pos
    end
    local canReward = data.reward == true
    self.confirmBtn.gameObject:SetActive(canReward)
    if data.finish then
      self:SetConfirm(true)
      self.confirmBtn.gameObject:SetActive(canReward)
      self.confirmed.gameObject:SetActive(not canReward)
    else
      self:SetConfirm(false)
      self.confirmBtn.gameObject:SetActive(true)
      self.confirmed.gameObject:SetActive(false)
    end
  end
end
function GuildTaskCell:SetConfirm(canConfirm)
  self.canConfirm = canConfirm
  if canConfirm then
    self.confirmBtn.spriteName = "com_btn_1"
    self.confirmLabel.effectColor = ColorUtil.ButtonLabelBlue
  else
    self.confirmBtn.spriteName = "com_btn_13"
    self.confirmLabel.effectColor = ColorUtil.NGUIGray
  end
end
