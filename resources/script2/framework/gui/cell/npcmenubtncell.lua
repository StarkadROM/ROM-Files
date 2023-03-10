baseCell = autoImport("BaseCell")
NpcMenuBtnCell = class("NpcMenuBtnCell", baseCell)
NpcMenuBtnCell.GuideType = {
  VarietyShop = 10,
  HeadShop = 18,
  PicMake = 21,
  AdventureSkill = 37,
  Teleporter = 160,
  Lottery_Doll = 510,
  TechTree = 513
}
NpcMenuBtnCell.Style = {
  Primary = 1,
  Second = 2,
  Normal = 3,
  Grey = 4
}
NpcMenuBtnCell.EndTimeShowingCfgMap = {
  [372] = GameConfig.EquipRecovery,
  [373] = GameConfig.EquipRecovery
}
function NpcMenuBtnCell:Init()
  self.bg = self:FindComponent("Bg", UIMultiSprite)
  self.icon = self:FindComponent("Icon", UIMultiSprite)
  self.label = self:FindComponent("Label", UILabel)
  self.labelTrans = self.label.transform
  self.endTimeLabel = self:FindComponent("EndTimeLabel", UILabel)
  self.contentTipParent = self:FindGO("ContentTipParent")
  self.contentTip = self:FindGO("ContentTip")
  self.contentLabel = self:FindComponent("ContentLabel", UILabel)
  self.button = self:FindGO("Button")
  self.multiplySymbol = self:FindGO("MultiplySymbol")
  self.multiplySymbol_label = self:FindComponent("muLabel", UILabel, self.multiplySymbol.gameObject)
  self:SetEvent(self.button, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  local longPress = self.button:GetComponent(UILongPress)
  function longPress.pressEvent(obj, state)
    if not self.isContentToLong then
      self:TriggerContentTip(state)
    end
  end
  self:OveReward()
end
function NpcMenuBtnCell:OveReward()
  self.multiplySymbol_reward = self:FindComponent("Tip", UILabel, self.multiplySymbol.gameObject)
  if BranchMgr.IsSEA() or BranchMgr.IsEU() or BranchMgr.IsNA() then
    if AppBundleConfig.GetSDKLang() ~= "cn" then
      self.multiplySymbol_reward.text = ZhString.OverSea_Reward
    else
      self.multiplySymbol_reward.text = ZhString.Cn_Reward
    end
  else
    self.multiplySymbol_reward.text = ZhString.Cn_Reward
  end
end
function NpcMenuBtnCell:SetData(data)
  self:AddOrRemoveGuideId(self.button)
  self.data = data
  local menuType, name = data.menuType, data.name
  self.content = tostring(name)
  self.label.text = self.content
  self.isContentToLong = UIUtil.WrapLabel(self.label)
  local style = NpcMenuBtnCell.Style.Normal
  if menuType == Dialog_MenuData_Type.NpcFunc then
    style = NpcMenuBtnCell.Style.Normal
    if data.key then
      local guideId = NpcMenuBtnCell.GuideType[data.key]
      if guideId then
        self:AddOrRemoveGuideId(self.button, guideId)
      end
    end
  elseif menuType == Dialog_MenuData_Type.Task then
    local task = data.task
    if task.type == QuestDataType.QuestDataType_MAIN or task.type == QuestDataType.QuestDataType_WANTED then
      style = NpcMenuBtnCell.Style.Primary
    elseif task.type == QuestDataType.QuestDataType_BRANCH then
      style = NpcMenuBtnCell.Style.Second
    else
      style = NpcMenuBtnCell.Style.Normal
    end
  elseif menuType == Dialog_MenuData_Type.Option then
    style = NpcMenuBtnCell.Style.Normal
  elseif menuType == Dialog_MenuData_Type.CustomFunc then
    style = NpcMenuBtnCell.Style.Normal
  end
  if data.state == NpcFuncState.InActive then
    self.gameObject:SetActive(false)
  else
    self.gameObject:SetActive(true)
    if data.state == NpcFuncState.Grey then
      style = NpcMenuBtnCell.Style.Grey
    end
  end
  self:SetStyle(style)
  self:UpdateMultiplyInfo()
  self:UpdateEndTimeLabel()
end
function NpcMenuBtnCell:SetStyle(style)
  if style ~= self.style then
    self.style = style
    if style == NpcMenuBtnCell.Style.Primary then
      self.bg.CurrentState = 1
      self.label.color = LuaGeometry.GetTempColor()
      self.label.effectColor = LuaGeometry.GetTempColor(0.7686274509803922, 0.5254901960784314, 0)
      self:ActiveIcon(true, 0)
    elseif style == NpcMenuBtnCell.Style.Second then
      self.bg.CurrentState = 0
      self.label.color = LuaGeometry.GetTempColor()
      self.label.effectColor = LuaGeometry.GetTempColor(0.27058823529411763, 0.37254901960784315, 0.6823529411764706)
      self:ActiveIcon(true, 1)
    elseif style == NpcMenuBtnCell.Style.Normal then
      self.bg.CurrentState = 0
      self.label.color = LuaGeometry.GetTempColor()
      self.label.effectColor = LuaGeometry.GetTempColor(0.27058823529411763, 0.37254901960784315, 0.6823529411764706)
      self:ActiveIcon(false)
    elseif style == NpcMenuBtnCell.Style.Grey then
      self.bg.CurrentState = 2
      self.label.color = LuaGeometry.GetTempColor(0.9372549019607843, 0.9372549019607843, 0.9372549019607843)
      self.label.effectColor = LuaGeometry.GetTempColor(0.39215686274509803, 0.40784313725490196, 0.4627450980392157)
      self:ActiveIcon(false)
    end
  end
end
function NpcMenuBtnCell:ActiveIcon(b, state)
  b = b and true or false
  self.icon.gameObject:SetActive(b)
  self.labelTrans.localPosition = LuaGeometry.GetTempVector3(b and 10 or 0, self.labelTrans.localPosition.y)
  if b then
    if state then
      self.icon.CurrentState = state
    end
    self.icon:UpdateAnchors()
  end
end
local NpcFunction_Multiply_RewardMap = {
  [1000] = AERewardType.Tower,
  [1100] = AERewardType.Laboratory,
  [1003] = AERewardType.TeamGroup,
  [4015] = AERewardType.GuildRaid,
  [1450] = AERewardType.GuildDojo,
  [10001] = AERewardType.PveCard,
  [10022] = AERewardType.EXPRaid,
  [10140] = AERewardType.ComodoRaid,
  [10141] = AERewardType.SevenRoyalFamiliesRaid
}
function NpcMenuBtnCell:UpdateMultiplyInfo()
  local data = self.data
  if data == nil or data.npcFuncData == nil then
    self.multiplySymbol:SetActive(false)
    return
  end
  local typeid = data.npcFuncData.id
  if typeid == 1003 then
    local isOpen = ActivityEventProxy.Instance:GetGroupRaidRewardActivityState()
    if isOpen then
      self.multiplySymbol:SetActive(true)
      return
    else
      self.multiplySymbol:SetActive(false)
    end
  end
  if self:GetShowEndTime(typeid) then
    self.multiplySymbol:SetActive(false)
    return
  end
  local rewardType = NpcFunction_Multiply_RewardMap[typeid]
  if rewardType == nil then
    self.multiplySymbol:SetActive(false)
    return
  end
  local rewardInfo = ActivityEventProxy.Instance:GetRewardByType(rewardType)
  if rewardInfo == nil then
    self.multiplySymbol:SetActive(false)
    return
  end
  local multiply = rewardInfo:GetMultiple() or 1
  if multiply > 1 then
    self.multiplySymbol_label.text = "*" .. multiply
    self.multiplySymbol:SetActive(true)
  else
    self.multiplySymbol:SetActive(false)
  end
end
function NpcMenuBtnCell:UpdateEndTimeLabel()
  local endTime = self:GetShowEndTime()
  self.endTimeLabel.text = endTime and string.format(ZhString.NpcMenuBtnCell_EndTimeFormat, endTime) or ""
  self.label.height = endTime and 25 or 50
  self.labelTrans.localPosition = LuaGeometry.GetTempVector3(self.labelTrans.localPosition.x, endTime and 10.5 or 2.5)
end
local npcFuncEndTimeStrMap
function NpcMenuBtnCell:GetShowEndTime(npcFunctionId)
  if not npcFuncEndTimeStrMap then
    npcFuncEndTimeStrMap = {}
    local str, lower
    for id, cfg in pairs(NpcMenuBtnCell.EndTimeShowingCfgMap) do
      for k, v in pairs(cfg) do
        lower = string.lower(k)
        if EnvChannel.IsTFBranch() then
          if lower == "tfendtime" then
            str = v
            break
          end
        elseif lower == "endtime" then
          str = v
          break
        end
      end
      if str then
        str = string.split(str, " ")[1]
        npcFuncEndTimeStrMap[id] = str
      else
        LogUtility.WarningFormat("Cannot find endtime config of {0}", npcFunctionId)
        TableUtil.Print(cfg)
      end
    end
  end
  if not npcFunctionId then
    local data = self.data and self.data.npcFuncData
    npcFunctionId = data and data.id
  end
  return npcFunctionId and npcFuncEndTimeStrMap[npcFunctionId]
end
function NpcMenuBtnCell:TriggerContentTip(isShow)
  isShow = isShow and true or false
  self.contentTip:SetActive(isShow)
  self.contentTipParent.transform.localPosition = LuaGeometry.GetTempVector3(isShow and 0 or 200, 0)
  if isShow then
    self.contentLabel.text = self.content
  end
end
