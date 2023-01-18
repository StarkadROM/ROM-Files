autoImport("EquipChooseCell")
EquipChooseBord = class("EquipChooseBord", CoreView)
EquipChooseBord.CellControl = EquipChooseCell
EquipChooseBord.PfbPath = "part/EquipChooseBord"
EquipChooseBord.CellPfbName = "EquipChooseCell"
EquipChooseBord.ChooseItem = "EquipChooseBord_ChooseItem"
EquipChooseBord.ChildNum = 1
EquipChooseBord.ChildInterver = 0
local itemTipOffset = {216, -290}
function EquipChooseBord:ctor(parent, getDataFunc)
  self.gameObject_Parent = parent
  self.gameObject = self:LoadPreferb(self.PfbPath, parent)
  self.gameObject.transform.localPosition = LuaGeometry.Const_V3_zero
  self.getDataFunc = getDataFunc
  self:InitBord()
end
function EquipChooseBord:InitBord()
  self:InitDepth()
  self.title = self:FindComponent("Title", UILabel)
  self.noneTip = self:FindComponent("NoneTip", UILabel)
  self.chooseCtl = WrapListCtrl.new(self:FindGO("ChooseGrid"), self.CellControl, self.CellPfbName, nil, self.ChildNum, self.ChildInterver, true)
  self.chooseCtl:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
  self.chooseCtl:AddEventListener(EquipChooseCellEvent.ClickItemIcon, self.ClickItemIcon, self)
  self.closeBtn = self:FindGO("CloseButton")
  if self.closeBtn then
    self:AddClickEvent(self.closeBtn, function()
      self:Hide()
    end)
  end
  self.needSetCheckValidFuncOnShow = true
  self.tipData = {
    funcConfig = {},
    callback = function()
      self.clickId = 0
    end,
    ignoreBounds = {}
  }
end
function EquipChooseBord:InitDepth()
  local upPanel = Game.GameObjectUtil:FindCompInParents(self.gameObject_Parent, UIPanel, false)
  local panels = self:FindComponents(UIPanel)
  for i = 1, #panels do
    panels[i].depth = upPanel.depth + panels[i].depth
  end
end
function EquipChooseBord:SetItemTipInValid()
  self.itemTipInvalid = true
end
function EquipChooseBord:ClickItemIcon(cellctl)
  if self.itemTipInvalid then
    return
  end
  local data = cellctl and cellctl.data
  local go = cellctl and cellctl.itemIcon
  local newClickId = data and data.id or 0
  if self.clickId ~= newClickId then
    self.clickId = newClickId
    self.tipData.itemdata = data
    self.tipData.ignoreBounds[1] = go
    self:ShowItemTip(self.tipData, go:GetComponent(UIWidget), nil, itemTipOffset)
  else
    self:ShowItemTip()
    self.clickId = 0
  end
end
function EquipChooseBord:HandleClickItem(cellctl)
  local data = cellctl and cellctl.data
  self:SetChoose(data)
  self:PassEvent(EquipChooseBord.ChooseItem, data)
  if self.chooseCall then
    self.chooseCall(self.chooseCallParam, data)
  end
end
function EquipChooseBord:SetChoose(data)
  local newChooseId = data and data.id or 0
  if self.chooseId ~= newChooseId then
    self.chooseId = newChooseId
  end
  local cells = self.chooseCtl:GetCells()
  for _, cell in pairs(cells) do
    cell:SetChooseId(self.chooseId)
  end
end
function EquipChooseBord:ResetDatas(datas, resetPos)
  self.datas = datas
  self:ResetCtrl(datas, resetPos)
end
function EquipChooseBord:ResetCtrl(datas, resetPos)
  if resetPos then
    self.chooseCtl:ResetPosition()
  end
  self.chooseCtl:ResetDatas(datas)
  self.noneTip.gameObject:SetActive(#datas == 0)
end
function EquipChooseBord:UpdateChooseInfo(datas)
  if not datas and self.getDataFunc then
    datas = self.getDataFunc()
  end
  datas = datas or {}
  self:ResetDatas(datas)
end
function EquipChooseBord:Show(updateInfo, chooseCall, chooseCallParam, checkFunc, checkFuncParam, checkTip, cellName)
  if updateInfo then
    self:UpdateChooseInfo()
    if cellName then
      self:SetChooseCellBtnName(cellName)
    end
  end
  self.gameObject:SetActive(true)
  if self.needSetCheckValidFuncOnShow then
    self:Set_CheckValidFunc(checkFunc, checkFuncParam, checkTip)
  end
  self.chooseCall = chooseCall
  self.chooseCallParam = chooseCallParam
end
function EquipChooseBord:Hide()
  TipManager.CloseTip()
  self.gameObject:SetActive(false)
  self:ResetDatas(_EmptyTable)
  self.chooseCall = nil
  self.chooseCallParam = nil
  self.checkFunc = nil
  self.checkTip = nil
end
function EquipChooseBord:ActiveSelf()
  return self.gameObject.activeSelf
end
function EquipChooseBord:SetBordTitle(text)
  self.title.text = text
end
function EquipChooseBord:SetChooseCellBtnName(zhstring)
  local cells = self.chooseCtl:GetCells()
  for i = 1, #cells do
    cells[i]:SetChooseButtonText(zhstring)
  end
end
function EquipChooseBord:Set_CheckValidFunc(checkFunc, checkFuncParam, checkTip, needShowInvalidItemTip)
  local cells = self.chooseCtl:GetCells()
  for i = 1, #cells do
    cells[i]:Set_CheckValidFunc(checkFunc, checkFuncParam, checkTip, needShowInvalidItemTip)
  end
end
function EquipChooseBord:SetNoneTip(text)
  self.noneTip.text = text
end
