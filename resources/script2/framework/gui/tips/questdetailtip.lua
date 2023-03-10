autoImport("BaseTip")
QuestDetailTip = class("QuestDetailTip", BaseTip)
local tempColor = LuaColor.white
function QuestDetailTip:Init()
  self:initView()
end
function QuestDetailTip:initView()
  self.bg = self:FindComponent("Bg", UISprite)
  self.title = self:FindComponent("Title", UILabel)
  self.process = self:FindComponent("Process", UILabel)
  self.Table = self:FindComponent("Table", UITable)
  self.rewardCt = self:FindGO("rewardCt")
  self.rewardTitle = self:FindComponent("rewardTitle", UILabel)
  self.rewardTitle.text = ZhString.QuestDetailTip_Reward
end
function QuestDetailTip:SetData(data)
  self.data = data
  self.title.text = data.traceTitle
  local process = data:getProcessInfo()
  if process then
    self:Show(self.process.gameObject)
    local totalNum = process.totalNum or 0
    local curProcess = process.process or 0
    if process.name then
      local str = process.name .. "(" .. curProcess .. "/" .. totalNum .. ")"
      self.process.text = string.format(ZhString.QuestDetailTip_Process, str)
    else
      local str = "(" .. curProcess .. "/" .. totalNum .. ")"
      self.process.text = string.format(ZhString.QuestDetailTip_Process, str)
    end
  else
    self:Hide(self.process.gameObject)
  end
  local rewards = data.allrewardid
  if data.rewards then
    self:initRewardView()
    self:Show(self.rewardCt.gameObject)
    local rewardData = {
      hideline = true,
      color = ColorUtil.NGUIWhite,
      label = {}
    }
    for i = 1, #data.rewards do
      local single = data.rewards[i]
      local str = ""
      if single then
        if single.id == 300 then
          str = "Base x " .. single.count
        elseif single.id == 400 then
          str = "Job x " .. single.count
        else
          local itemData = Table_Item[single.id]
          if itemData then
            str = string.format("{itemicon=%s} %s x %s", single.id, itemData.NameZh, single.count)
          else
            self:DestroySelf()
            return
          end
        end
        table.insert(rewardData.label, str)
      end
    end
    self.rewardDetail:SetData(rewardData)
  elseif rewards and #rewards > 1 then
    self:initRewardView()
    self:Show(self.rewardCt.gameObject)
    local rewardData = {
      hideline = true,
      tiplabel = ZhString.QuestDetailTip_MultReward,
      color = ColorUtil.NGUIWhite
    }
    self.rewardDetail:SetData(rewardData)
  elseif rewards and #rewards > 0 then
    self:initRewardView()
    self:Show(self.rewardCt.gameObject)
    local rewardData = {
      hideline = true,
      color = ColorUtil.NGUIWhite,
      label = {}
    }
    local rewardId = rewards[1]
    if rewardId then
      local items = ItemUtil.GetRewardItemIdsByTeamId(rewardId)
      for i = 1, #items do
        local item = items[i]
        local str = ""
        if item.id == 300 then
          str = "Base x " .. item.num
        elseif item.id == 400 then
          str = "Job x " .. item.num
        else
          local itemData = Table_Item[item.id]
          if itemData then
            str = string.format("{itemicon=%s} %s x %s", item.id, itemData.NameZh, item.num)
          else
            self:DestroySelf()
            return
          end
        end
        table.insert(rewardData.label, str)
      end
      self.rewardDetail:SetData(rewardData)
    else
      self:DestroySelf()
      return
    end
  else
    self:Hide(self.rewardCt.gameObject)
  end
  self.Table:Reposition()
  local bound = NGUIMath.CalculateRelativeWidgetBounds(self.Table.transform)
  self.bg.height = bound.size.y + 20
end
function QuestDetailTip:initRewardView()
  local obj = self:FindGO("TipLabelCell")
  if obj then
    GameObject.DestroyImmediate(obj)
  end
  obj = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("TipLabelCell"), self.rewardCt.gameObject)
  obj.transform.localPosition = LuaGeometry.Const_V3_zero
  local label = self:FindComponent("Label", UILabel, obj)
  label.width = self.bg.width - 30
  label.color = ColorUtil.NGUIWhite
  self.rewardDetail = TipLabelCell.new(obj)
  self.rewardDetail.tiplabel.width = self.bg.width - 30
end
