autoImport("QueueBaseCell")
InviteConfirmCell = class("InviteConfirmCell", QueueBaseCell)
InviteConfirmCell.resID = ResourcePathHelper.UICell("InviteConfirmCell")
function InviteConfirmCell:ctor(parent, data)
  self.parent = parent
  self.data = data
end
function InviteConfirmCell:Enter()
  if not self.gameObject then
    self.gameObject = self:CreateObj(InviteConfirmCell.resID, self.parent)
    self.tipLabel = self:FindGO("Tip"):GetComponent(UILabel)
    self.loveTitle = self:FindGO("LoveTitle")
    self.nobtn = self:FindGO("NoBtn")
    self.yesbtn = self:FindGO("YesBtn")
    self.yestip = self:FindGO("Label", self.yesbtn):GetComponent(UILabel)
    self.lab = self:FindGO("Context"):GetComponent(UILabel)
    self.timeSliderObj = self:FindGO("TimeSlider")
    self.timeSlider = self.timeSliderObj:GetComponent(UISlider)
    self:SetEvent(self.yesbtn, function()
      self:ExcuteYesEvent()
    end)
    self:SetEvent(self.nobtn, function()
      self:ExcuteNoEvent()
    end)
  end
  self:SetData()
end
function InviteConfirmCell:ExcuteYesEvent()
  if self.yesevt then
    self.yesevt(self.playerid)
  end
  self:PassEvent(InviteConfirmEvent.Agree, self)
  local noClose = self.data and self.data.agreeNoClose
  if not noClose then
    self:Exit()
  end
end
function InviteConfirmCell:ExcuteNoEvent()
  if self.noevt then
    self.noevt(self.playerid)
  end
  if self.data.CanNOTrefuse then
  else
    self:PassEvent(InviteConfirmEvent.Refuse, self)
    self:Exit()
  end
end
function InviteConfirmCell:SetData(data)
  if data then
    self.data = data
  else
    data = self.data
  end
  if self.data then
    if self.data.type == InviteType.FerrisWheel then
      self.tipLabel.gameObject:SetActive(false)
      self.loveTitle:SetActive(true)
    else
      self.tipLabel.gameObject:SetActive(true)
      self.loveTitle:SetActive(false)
    end
    self.playerid = data.playerid
    if data.msgId then
      local tipData = Table_Sysmsg[data.msgId]
      self.tipLabel.text = tipData.Title
      local msgParama = data.msgParama or {}
      local msgParama2 = ReusableTable.CreateTable()
      local suffix = OverseasConfig.OriginTeamName
      for k, v in ipairs(msgParama) do
        if type(v) == "string" then
          msgParama2[k] = v:gsub(suffix, OverSea.LangManager.Instance():GetLangByKey(suffix))
        else
          msgParama2[k] = v
        end
      end
      self.lab.text = MsgParserProxy.Instance:TryParse(tipData.Text, unpack(msgParama2))
      ReusableTable.DestroyAndClearTable(msgParama2)
      self.yestip.text = tipData.button
    else
      self.lab.text = data.lab
      self.yestip.text = data.button
    end
    self:FitCell()
    if data.tip then
      self.tipLabel.text = data.tip
    end
    self.yesevt = data.yesevt
    self.noevt = data.noevt
    self.endevt = data.endevt
    self:UpdateTime(data.time, data.time)
  end
end
function InviteConfirmCell:FitCell()
  local lab = self.lab
  lab.width = 280
  lab.overflowMethod = 1
  lab:ProcessText()
  local strContent = lab.text
  local bWarp, strOut
  bWarp, strOut = lab:Wrap(strContent, strOut, lab.height)
  if not bWarp then
    lab.overflowMethod = 2
    lab:ProcessText()
    if lab.width >= 1100 then
      lab.width = 1100
      lab.overflowMethod = 0
      lab:ProcessText()
    end
  end
  lab.transform.localPosition = LuaGeometry.GetTempVector3(-195, 7)
end
function InviteConfirmCell:UpdateTime(leftTime, totalTime)
  if self.timeSliderObj and not LuaGameObject.ObjectIsNull(self.timeSliderObj) then
    LeanTween.cancel(self.timeSliderObj)
  end
  if leftTime == nil or totalTime == nil then
    self.timeSlider.gameObject:SetActive(false)
    return
  end
  self.timeSlider.gameObject:SetActive(true)
  local value = leftTime / totalTime
  LeanTween.sliderNGUI(self.timeSlider, value, 0, leftTime):setOnComplete(function()
    if self.endevt then
      self.endevt(self.playerid)
    end
    if self.data.CanNOTrefuse then
    else
      self:PassEvent(InviteConfirmEvent.TimeOver, self)
      self:Exit()
    end
  end)
end
function InviteConfirmCell:Exit()
  LeanTween.cancel(self.gameObject)
  if self.timeSliderObj and not LuaGameObject.ObjectIsNull(self.timeSliderObj) then
    LeanTween.cancel(self.timeSliderObj)
  end
  Game.GOLuaPoolManager:AddToUIPool(InviteConfirmCell.resID, self.gameObject)
  self.gameObject = nil
  InviteConfirmCell.super.Exit(self)
end
