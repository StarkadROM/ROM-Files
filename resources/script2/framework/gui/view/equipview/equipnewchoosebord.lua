autoImport("EquipChooseBord")
autoImport("EquipNewChooseCell")
EquipNewChooseBord = class("EquipNewChooseBord", EquipChooseBord)
EquipNewChooseBord.CellControl = EquipNewChooseCell
EquipNewChooseBord.PfbPath = "part/EquipNewChooseBord"
EquipNewChooseBord.CellPfbName = "EquipNewChooseCell"
function EquipNewChooseBord:InitBord()
  EquipNewChooseBord.super.InitBord(self)
  self.textForAll = ZhString.Card_All
  self.filterPop = self:FindComponent("FilterPop", UIPopupList)
  self.filterPop.gameObject:SetActive(false)
  self.posTween = self.gameObject:GetComponent(TweenPosition)
  self:SetTweenActive(false)
  function self.tipData.callback()
    self.clickId = 0
    self:UpdateItemIconChoose()
  end
end
local defaultDataTypeGetter = function(data)
  return data and data.staticData and data.staticData.Type
end
function EquipNewChooseBord:SetFilterPopData(data, dataTypeGetter)
  local flag = data ~= nil and #data > 0
  self.filterPop.gameObject:SetActive(flag)
  if flag then
    self.filterPop:Clear()
    self.filterPop:AddItem(self.textForAll)
    for i = 1, #data do
      self.filterPop:AddItem(data[i].name, data[i].types)
    end
    self.filterPop.value = self.textForAll
    EventDelegate.Add(self.filterPop.onChange, function()
      self:_OnFilterPopChange(true)
    end)
  end
end
function EquipNewChooseBord:_OnFilterPopChange(resetPos)
  if not self.datas or not next(self.datas) then
    return
  end
  local d = self.filterPop.data
  if d then
    local filteredData, arrayFindIndex, arrayPushBack = ReusableTable.CreateArray(), TableUtility.ArrayFindIndex, TableUtility.ArrayPushBack
    if not dataTypeGetter then
      dataTypeGetter = defaultDataTypeGetter
    end
    for i = 1, #self.datas do
      if arrayFindIndex(d, dataTypeGetter(self.datas[i])) > 0 then
        arrayPushBack(filteredData, self.datas[i])
      end
    end
    self:ResetCtrl(filteredData, resetPos)
    ReusableTable.DestroyAndClearArray(filteredData)
  else
    self:ResetCtrl(self.datas, resetPos)
  end
end
function EquipNewChooseBord:ResetDatas(datas, resetPos)
  EquipNewChooseBord.super.ResetDatas(self, datas, resetPos)
  self:_OnFilterPopChange(resetPos)
end
function EquipNewChooseBord:ResetFilter()
  self.filterPop.value = self.textForAll
  self:_OnFilterPopChange()
end
function EquipNewChooseBord:Show(...)
  EquipNewChooseBord.super.Show(self, ...)
  self:TryPlayPosTween()
end
function EquipNewChooseBord:Hide()
  self:TryPlayPosTween(false, function()
    EquipNewChooseBord.super.Hide(self)
  end)
end
function EquipNewChooseBord:SetTweenActive(isActive)
  self.tweenActive = isActive and true or false
  if self.posTween.amountPerDelta > 0 then
    self.posTween:Sample(1, true)
  elseif self.posTween.amountPerDelta < 0 then
    self.posTween:Sample(0, true)
  end
  self.posTween.enabled = self.tweenActive
end
local _tweenPlay = function(tween, isForward)
  if isForward ~= false then
    tween:PlayForward()
  else
    tween:PlayReverse()
  end
end
function EquipNewChooseBord:TryPlayPosTween(isForward, onFinished)
  if not self.tweenActive then
    if onFinished then
      onFinished()
    end
    return
  end
  _tweenPlay(self.posTween, isForward)
  self.posTween:ResetToBeginning()
  self.posTween:SetOnFinished(onFinished)
  _tweenPlay(self.posTween, isForward)
end
function EquipNewChooseBord:IsTweenPlaying()
  local f = self.posTween.tweenFactor
  return f > 0.15 and f < 0.85
end
function EquipNewChooseBord:HandleClickItem(cellctl)
  if self:IsTweenPlaying() then
    return
  end
  EquipNewChooseBord.super.HandleClickItem(self, cellctl)
end
function EquipNewChooseBord:ClickItemIcon(cellctl)
  EquipNewChooseBord.super.ClickItemIcon(self, cellctl)
  self:UpdateItemIconChoose()
end
function EquipNewChooseBord:UpdateItemIconChoose()
  for _, cell in pairs(self.chooseCtl:GetCells()) do
    cell:SetItemIconChooseId(self.clickId)
  end
end
function EquipNewChooseBord:SetTypeLabelTextGetter(getter)
  for _, cell in pairs(self.chooseCtl:GetCells()) do
    cell:SetTypeLabelTextGetter(getter)
  end
end
autoImport("EquipNewCountChooseCell")
EquipNewCountChooseBord = class("EquipNewCountChooseBord", EquipNewChooseBord)
EquipNewCountChooseBord.CellControl = EquipNewCountChooseCell
function EquipNewCountChooseBord:InitBord()
  EquipNewMultiChooseBord.super.InitBord(self)
  self.chooseCtl:AddEventListener(EquipChooseCellEvent.CountChooseChange, self.OnCountChooseChange, self)
end
function EquipNewCountChooseBord:OnCountChooseChange(cellCtl)
  if self:IsTweenPlaying() then
    return
  end
  self:PassEvent(EquipChooseCellEvent.CountChooseChange, cellCtl)
end
function EquipNewCountChooseBord:SetChooseReference(reference)
  local cells = self.chooseCtl:GetCells()
  for _, cell in pairs(cells) do
    cell:SetChooseReference(reference)
  end
end
function EquipNewCountChooseBord:SetUseItemNum(b)
  local cells = self.chooseCtl:GetCells()
  for _, cell in pairs(cells) do
    cell:SetUseItemNum(b)
  end
end
EquipNewMultiChooseBord = class("EquipNewMultiChooseBord", EquipNewChooseBord)
EquipNewMultiChooseBord.CellControl = EquipNewMultiChooseCell
function EquipNewMultiChooseBord:InitBord()
  EquipNewMultiChooseBord.super.InitBord(self)
  self.chooseCtl:AddEventListener(EquipChooseCellEvent.ClickCancel, self.ClickCancel, self)
end
function EquipNewMultiChooseBord:ClickCancel(cellCtl)
  if self:IsTweenPlaying() then
    return
  end
  self:PassEvent(EquipChooseCellEvent.ClickCancel, cellCtl and cellCtl.data)
end
function EquipNewMultiChooseBord:SetChoose(data)
end
function EquipNewMultiChooseBord:SetChooseReference(reference)
  local cells = self.chooseCtl:GetCells()
  for _, cell in pairs(cells) do
    cell:SetChoose(reference)
  end
end
