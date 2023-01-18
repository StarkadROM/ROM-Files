local BaseCell = autoImport("BaseCell")
CardNCell = class("CardNCell", BaseCell)
autoImport("TipLabelCell")
function CardNCell:Init()
  self.iconContainer = self:FindGO("IconContainer")
  self.infoBord = self:FindGO("Info")
  self.icon = self:FindComponent("Icon", UISprite, self.iconContainer)
  self.iconPic = self:FindComponent("IconTex", UITexture)
  self.useSymbol = self:FindGO("UseSymbol")
  self.cardName = self:FindComponent("CardName", UILabel)
  self.cardNum = self:FindComponent("CardNum", UILabel)
  local cellObj = self:FindGO("TipLabelCell")
  self.tiplabelCell = TipLabelCell.new(cellObj)
  self:AddClickEvent(self.gameObject, function(go)
    self:SetChooseState(not self.use)
  end)
  self.useButton = self:FindComponent("UseButton", UIButton)
  self:AddClickEvent(self.useButton.gameObject, function(go)
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  local upPanel = Game.GameObjectUtil:FindCompInParents(self.gameObject, UIPanel)
  local panels = self:FindComponents(UIPanel)
  local minDepth
  for i = 1, #panels do
    if minDepth == nil then
      minDepth = panels[i].depth
    else
      minDepth = math.min(panels[i].depth, minDepth)
    end
  end
  local startDepth = upPanel.depth + 1
  for i = 1, #panels do
    panels[i].depth = panels[i].depth - minDepth + startDepth
  end
end
function CardNCell:SetData(data)
  self.data = data
  if data and data.cardInfo then
    self.gameObject:SetActive(true)
    local cardInfo = data.cardInfo
    if not PictureManager.Instance:SetCard(cardInfo.Picture, self.iconPic) then
      printRed(string.format("为找到名为%s的卡片资源。", cardInfo.Picture))
      PictureManager.Instance:SetCard("card_10001", self.iconPic)
    end
    self.cardName.text = cardInfo.Name
    self.cardNum.text = data.num > 1 and data.num or ""
    local contextlabel = {
      label = {},
      hideline = true,
      color = ColorUtil.NGUIWhite
    }
    local bufferIds = cardInfo.BuffEffect.buff
    if bufferIds then
      for i = 1, #bufferIds do
        local str = ItemUtil.getBufferDescById(bufferIds[i])
        local bufferStrs = string.split(str, "\n")
        for j = 1, #bufferStrs do
          table.insert(contextlabel.label, bufferStrs[j])
        end
      end
    end
    self.tiplabelCell:SetData(contextlabel)
    self:SetUse(data.used == true)
    self:SetChooseState(false)
  else
    self.tiplabelCell:SetData()
    self.gameObject:SetActive(false)
  end
end
function CardNCell:SetUse(b)
  self.useButton.isEnabled = not b
  self.useSymbol:SetActive(b)
end
function CardNCell:SetChooseState(use)
  if self:ObjIsNil(self.infoBord) then
    return
  end
  self.infoBord:SetActive(use)
  self.iconContainer:SetActive(not use)
  self.use = use
end
