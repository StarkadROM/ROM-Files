autoImport("ItemCell")
local BaseCell = autoImport("BaseCell")
EquipChooseCell = class("EquipChooseCell", BaseCell)
EquipChooseCell.CellControl = ItemCell
local redTipOffset = {-10, -10}
function EquipChooseCell:Init()
  self.itemCell = self.CellControl.new(self.gameObject)
  self.nameLab = self.itemCell.nameLab
  self.equipEd = self:FindGO("EquipEd")
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self.chooseButton = self:FindGO("ChooseButton")
  if self.chooseButton then
    self.chooseButtonLabel = self:FindComponent("Label", UILabel, self.chooseButton)
    self:AddClickEvent(self.chooseButton, function()
      self:PassEvent(MouseEvent.MouseClick, self)
    end)
  else
    self:AddClickEvent(self.gameObject, function()
      if self.isValid then
        self:PassEvent(MouseEvent.MouseClick, self)
      end
    end)
  end
  self.invalidTip = self:FindComponent("InvalidTip", UILabel)
  self.invalidItemTip = self:FindGO("InvalidItemTip")
  self.favoriteTip = self:FindGO("FavoriteTip")
  self.itemIcon = self:FindGO("Item")
  self.itemIconWidget = self.itemIcon:GetComponent(UIWidget)
  self:AddClickEvent(self.itemIcon, function()
    self:PassEvent(EquipChooseCellEvent.ClickItemIcon, self)
  end)
  self.personalArtifactUniqueEffect = self:FindGO("PersonalArtifactUniqueEffect")
end
function EquipChooseCell:SetData(data)
  self.data = data
  local flag = data == nil or data.staticData == nil
  self.gameObject:SetActive(not flag)
  if flag then
    return
  end
  self.itemCell:SetData(data)
  self.itemCell:UpdateMyselfInfo()
  self.itemCell:SetIconGrey(data.id == "NoGet")
  self:Show(self.nameLab)
  self:SetShowChooseButton(true)
  self:UpdateEquiped()
  self:UpdateChoose()
  self:CheckValid()
  self:UpdateShowRedTip(data)
  self:UpdateFavoriteTip()
  self:TryUpdatePersonalArtifact()
  TimeTickManager.Me():CreateOnceDelayTick(16, function()
    if not Slua.IsNull(self.itemCell.attrGrid) then
      self.itemCell.attrGrid:Reposition()
    end
  end, self)
end
function EquipChooseCell:UpdateFavoriteTip()
  if not self.favoriteTip then
    return
  end
  self.favoriteTip:SetActive((not self.equipEd or not self.equipEd.activeSelf) and self.data ~= nil and BagProxy.Instance:CheckIsFavorite(self.data))
end
function EquipChooseCell:UpdateEquiped()
  if not self.equipEd then
    return
  end
  self.equipEd:SetActive(self.data ~= nil and self.data.equiped == 1)
end
function EquipChooseCell:SetChooseId(chooseId)
  self.chooseId = chooseId
  self:UpdateChoose()
end
function EquipChooseCell:UpdateChoose()
  if self.chooseSymbol then
    if self.chooseId and self.data and self.data.id == self.chooseId then
      self.chooseSymbol:SetActive(true)
    else
      self.chooseSymbol:SetActive(false)
    end
  end
end
function EquipChooseCell:TryUpdatePersonalArtifact()
  if not self.personalArtifactUniqueEffect then
    return
  end
  local paData = self.data and self.data.personalArtifactData
  self.personalArtifactUniqueEffect:SetActive(paData ~= nil and paData:IsUniqueEffectAvailable())
end
function EquipChooseCell:UpdateShowRedTip(data)
  local isActive = data and data.isShowRedTip
  if isActive then
    self:TryAddManualRedTip()
  else
    self:TryRemoveManualRedTip()
  end
  if self.redTip then
    self.redTip.gameObject:SetActive(isActive and true or false)
  end
end
function EquipChooseCell:TryAddManualRedTip()
  if self.redTip then
    return
  end
  self.redTip = Game.AssetManager_UI:CreateAsset(RedTip.resID, self.itemIcon):GetComponent(UISprite)
  UIUtil.ChangeLayer(self.redTip, self.itemIcon.layer)
  self.redTip.transform.position = NGUIUtil.GetAnchorPoint(self.itemIcon, self.itemIconWidget, NGUIUtil.AnchorSide.TopRight, redTipOffset)
  self.redTip.transform.localScale = LuaGeometry.Const_V3_one
  self.redTip.depth = self.itemIconWidget.depth + 10
end
function EquipChooseCell:TryRemoveManualRedTip()
  if not self.redTip then
    return
  end
  Game.GOLuaPoolManager:AddToUIPool(RedTip.resID, self.redTip.gameObject)
  self.redTip = nil
end
function EquipChooseCell:Set_CheckValidFunc(checkFunc, checkFuncParam, checkTip, needShowInvalidItemTip)
  self.checkFunc = checkFunc
  self.checkFuncParam = checkFuncParam
  self.checkTip = checkTip
  self.isShowInvalidItemTip = needShowInvalidItemTip and true or false
  self:CheckValid()
end
function EquipChooseCell:CheckValid()
  if self.data == nil then
    return
  end
  if self.checkFunc then
    local otherTip
    self.isValid, otherTip = self.checkFunc(self.checkFuncParam, self.data)
    if self.isValid then
      self:SetShowChooseButton(true)
      if otherTip then
        self.invalidTip.gameObject:SetActive(true)
        self.invalidTip.text = tostring(otherTip)
      else
        self.invalidTip.gameObject:SetActive(false)
      end
    else
      self:SetShowChooseButton(false)
      self.invalidTip.gameObject:SetActive(true)
      self.invalidTip.text = tostring(otherTip or self.checkTip)
    end
    if self.invalidItemTip then
      self.invalidItemTip:SetActive(not self.isValid)
    end
  else
    self:SetShowChooseButton(true)
    self.invalidTip.gameObject:SetActive(false)
    if self.invalidItemTip then
      self.invalidItemTip:SetActive(false)
    end
  end
end
function EquipChooseCell:SetShowChooseButton(isShow)
  if not self.chooseButton then
    return
  end
  self.chooseButton:SetActive(isShow and true or false)
end
function EquipChooseCell:SetChooseButtonText(text)
  if not self.chooseButtonLabel then
    return
  end
  self.chooseButtonLabel.text = tostring(text) or ""
end
function EquipChooseCell:SetShowStrengthLvOfItem(b)
  self.itemCell.forbidShowStrengthLv = not b
end
function EquipChooseCell:SetShowRefineLvOfItem(b)
  self.itemCell.forbidShowRefineLv = not b
end
function EquipChooseCell:SetShowEquipLvOfItem(b)
  self.itemCell.forbidShowEquipLv = not b
end
function EquipChooseCell:OnCellDestroy()
  TimeTickManager.Me():ClearTick(self)
  self:TryRemoveManualRedTip()
end
