autoImport("EquipChooseCell")
EquipCountChooseCell = class("EquipCountChooseCell", EquipChooseCell)
local tickManager
function EquipCountChooseCell:Init()
  if not tickManager then
    tickManager = TimeTickManager.Me()
  end
  EquipCountChooseCell.super.Init(self)
  self:InitCountChooseBord()
  self.desc = self:FindComponent("Desc", UILabel)
  self.itemNumLabel = self:FindComponent("NumLabel", UILabel, self.itemCell.item)
end
function EquipCountChooseCell:InitCountChooseBord()
  self.countChooseBord = self:FindGO("CountChooseBord")
  if not self.countChooseBord then
    LogUtility.Error("Cannot find CountChooseBord. Is that what you want?")
    return
  end
  local countChoose_AddButton = self:FindGO("AddButton", self.countChooseBord)
  self.countChoose_AddButton_Sp = countChoose_AddButton:GetComponent(UISprite)
  self.countChoose_AddButton_Collider = countChoose_AddButton:GetComponent(BoxCollider)
  self:AddClickEvent(countChoose_AddButton, function()
    self:DoAddCountChoose()
  end)
  local longPress = countChoose_AddButton:GetComponent(UILongPress)
  function longPress.pressEvent(obj, state)
    self:QuickDoAddCountChoose(state)
  end
  local countChoose_MinusButton = self:FindGO("MinusButton", self.countChooseBord)
  self.countChoose_MinusButton_Sp = countChoose_MinusButton:GetComponent(UISprite)
  self.countChoose_MinusButton_Collider = countChoose_MinusButton:GetComponent(BoxCollider)
  self:AddClickEvent(countChoose_MinusButton, function()
    self:DoMinusCountChoose()
  end)
  longPress = countChoose_MinusButton:GetComponent(UILongPress)
  function longPress.pressEvent(obj, state)
    self:QuickMinusAddCountChoose(state)
  end
  self.countChoose_CountInput = self:FindComponent("CountInput", UIInput, self.countChooseBord)
  UIUtil.LimitInputCharacter(self.countChoose_CountInput, 5)
  EventDelegate.Set(self.countChoose_CountInput.onChange, function()
    self.chooseCount = tonumber(self.countChoose_CountInput.value) or 0
    self:UpdateCountChoose()
    self:PassEvent(EquipChooseCellEvent.CountChooseChange, self)
  end)
  self.countChoose_Count = self:FindComponent("Count", UILabel, self.countChooseBord)
end
function EquipCountChooseCell:SetData(data)
  EquipCountChooseCell.super.SetData(self, data)
  if not data then
    return
  end
  self:UpdateCurrentCount()
  self:SetChooseCount(self.data.chooseCount or self.chooseCount or 0)
  self:UpdateDesc()
end
function EquipCountChooseCell:DoAddCountChoose()
  if not self.data then
    return
  end
  self:SetChooseCount(self.chooseCount + 1)
end
function EquipCountChooseCell:QuickDoAddCountChoose(open)
  if open then
    tickManager:CreateTick(0, 100, self.DoAddCountChoose, self, 11)
  else
    tickManager:ClearTick(self, 11)
  end
end
function EquipCountChooseCell:DoMinusCountChoose()
  if not self.data then
    return
  end
  self:SetChooseCount(self.chooseCount - 1)
end
function EquipCountChooseCell:QuickMinusAddCountChoose(open)
  if open then
    tickManager:CreateTick(0, 100, self.DoMinusCountChoose, self, 12)
  else
    tickManager:ClearTick(self, 12)
  end
end
function EquipCountChooseCell:CheckValid()
  EquipCountChooseCell.super.CheckValid(self)
  if self.invalidTip.gameObject.activeSelf then
    self.countChooseBord:SetActive(false)
  else
    self.countChooseBord:SetActive(true)
  end
end
function EquipCountChooseCell:SetChooseCount(count)
  self.chooseCount = count
  if self.data and self.data.__isclone then
    self.data.chooseCount = count
  end
  if not self.countChooseBord then
    return
  end
  self.countChoose_CountInput.value = self.chooseCount
  self:UpdateCountChoose()
end
function EquipCountChooseCell:UpdateCountChoose()
  if not self.countChooseBord then
    return
  end
  if not self.data then
    return
  end
  local max = self:GetMaxNumOfItem()
  if max < self.chooseCount or self.chooseCount < 0 then
    self.chooseCount = math.clamp(self.chooseCount, 0, max)
    if self.data and self.data.__isclone then
      self.data.chooseCount = count
    end
    self.countChoose_CountInput.value = self.chooseCount
  end
  self:_ActiveButton(self.chooseCount and max > self.chooseCount, self.countChoose_AddButton_Sp, self.countChoose_AddButton_Collider)
  self:_ActiveButton(self.chooseCount and self.chooseCount > 0, self.countChoose_MinusButton_Sp, self.countChoose_MinusButton_Collider)
end
function EquipCountChooseCell:UpdateCurrentCount()
  if self.itemNumLabel then
    self.itemNumLabel.text = self:GetMaxNumOfItem()
  end
end
function EquipCountChooseCell:GetMaxNumOfItem()
  if not self.data then
    return 0
  end
  local staticMaxNum, num = self.data.staticData.MaxNum, self:GetItemNum()
  local max = staticMaxNum and math.min(num, staticMaxNum) or num
  return math.min(max, 99999)
end
function EquipCountChooseCell:GetItemNum()
  if not self.data then
    return 0
  end
  return HappyShopProxy.Instance:GetItemNum(self.data.staticData.id)
end
function EquipCountChooseCell:UpdateDesc()
  self.desc.text = ""
end
function EquipCountChooseCell:_ActiveButton(b, sp, collider)
  b = b and true or false
  sp.alpha = b and 1 or 0.5
  collider.enabled = b
end
EquipAlchemyChooseCell = class("EquipAlchemyChooseCell", EquipCountChooseCell)
function EquipAlchemyChooseCell:SetData(data)
  local flag = data ~= nil
  self.gameObject:SetActive(flag)
  if flag then
    self.data = self.data or ItemData.new()
    self.data:ResetData("AlchemyChoose", data[1])
    self.energy = data[2]
    EquipAlchemyChooseCell.super.SetData(self, self.data)
  end
end
function EquipAlchemyChooseCell:GetItemNum()
  if not self.data then
    return 0
  end
  return BagProxy.Instance:GetItemNumByStaticID(self.data.staticData.id, GameConfig.PackageMaterialCheck.EquipAlchemy_pack)
end
function EquipAlchemyChooseCell:UpdateDesc()
  EquipAlchemyChooseCell.super.UpdateDesc(self)
  if not self.data or not self.energy then
    return
  end
  self.desc.text = string.format(ZhString.ItemExtract_CountChooseFormat, math.floor(self.energy * 10) / 100)
end
