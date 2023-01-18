local BaseCell = autoImport("BaseCell")
ItemTipFuncCell = class("ItemTipFuncCell", BaseCell)
function ItemTipFuncCell:Init()
  self.label = self:FindChild("Label"):GetComponent(UILabel)
  self.label_effect_oriColor = self.label.effectColor
  self.bg = self:FindChild("Background"):GetComponent(UISprite)
  self.collider = self.gameObject:GetComponent(BoxCollider)
  self:AddCellClickEvent()
end
function ItemTipFuncCell:SetData(data)
  self.data = data
  if data then
    self.gameObject:SetActive(true)
    if data.type == "Active" then
      if data.itemData and data.itemData.isactive then
        self.label.text = ZhString.ItemTipFuncCell_Down
      else
        self.label.text = data.name
      end
    elseif data.type == "GetTask" then
      if not data.itemData or not data.itemData.staticData then
        return
      end
      local questID = Table_UseItem[data.itemData.staticData.id].UseEffect.questid
      if questID then
        local bContain, enum = QuestProxy.Instance:checkQuestHasAccept(questID)
        if bContain and enum and enum == 1 then
          self.label.text = ZhString.AdventureRewardPanel_HasGetAward
          self:SetTextureGrey(self.gameObject)
        else
          self.label.text = data.name
        end
      end
    elseif data.itemData and data.itemData.isactive then
      self.label.text = ZhString.FunctionNpcFunc_Cancel
    else
      self.label.text = data.name
    end
    if data.inactive == true then
      self.collider.enabled = false
      self.bg.color = ColorUtil.NGUIShaderGray
      self.label.effectColor = ColorUtil.NGUIGray
    else
      self.collider.enabled = true
      self.bg.color = ColorUtil.NGUIWhite
      self.label.effectColor = self.label_effect_oriColor
    end
  else
    self.gameObject:SetActive(false)
  end
  self:UpdateGuideTarget()
end
function ItemTipFuncCell:AddQuestCallback(note)
  if not self.data or self.data.type ~= "GetTask" then
    return
  end
  local result = false
  local useItemID = self.data.itemData.staticData.id
  local itemQuestID = Table_UseItem[useItemID].UseEffect.id
  if itemQuestID then
    for k, v in pairs(note.data) do
      if v == itemQuestID then
        result = true
        break
      end
    end
  end
  if result then
    local taskID = itemQuestID
    local name = MsgParserProxy.Instance:GetQuestName(taskID)
    if name then
    end
  end
end
function ItemTipFuncCell:UpdateGuideTarget()
  if self.data and self.data.type == "Apply" then
    self:RegisterGuideTarget(ClientGuide.TargetType.itemtip_applybutton, self.gameObject)
  elseif self.data and self.data.type == "EmbedGem" then
    self:RegisterGuideTarget(ClientGuide.TargetType.itemtip_embedgembutton, self.gameObject)
  end
end
