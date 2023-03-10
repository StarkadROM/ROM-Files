autoImport("BaseGuildPrayDialog")
autoImport("GvGPvpPrayTypeCell")
autoImport("PrayToggleCell")
GvGPvPPrayDialog = class("GvGPvPPrayDialog", BaseGuildPrayDialog)
GvGPvPPrayDialog.ViewType = UIViewType.DialogLayer
local _GVGPrayConfig = GameConfig.GvGPvP_PrayType
function GvGPvPPrayDialog:InitUI()
  GvGPvPPrayDialog.super.InitUI(self)
  self:InitCoins()
  self.pageToggleRoot = self:FindGO("toggleRoot")
  local ListTable = self.pageToggleRoot:GetComponent(UIGrid)
  self.gridListCtl = UIGridListCtrl.new(ListTable, PrayToggleCell, "PrayToggleCell")
  self.gridListCtl:AddEventListener(MouseEvent.MouseClick, self._clickPageToggle, self)
  local togList = {}
  for i = 1, #_GVGPrayConfig do
    table.insert(togList, _GVGPrayConfig[i])
  end
  self.gridListCtl:ResetDatas(togList)
  self:_refreshChoose()
  self.choosePageID = GuildCmd_pb.EPRAYTYPE_GVG_ATK
  self.itemPrayRoot = self:FindGO("cutWrap")
  self.resetBtn = self:FindGO("ResetBtn")
  self:AddClickEvent(self.resetBtn, function(go)
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.GvGPvPPrayResetPopUp
    })
  end)
  local multiPrayButton = self:FindGO("MultiPrayButton")
  self.multiPrayCount = self:FindComponent("Label", UILabel, multiPrayButton)
  self:AddClickEvent(multiPrayButton, function(go)
    self:OnClickPray(self.chooseData:CalcMaxPrayCount())
  end)
  self:InitPray()
end
function GvGPvPPrayDialog:OnClickPray(praycount)
  local chooseData = self.chooseData
  if not chooseData then
    return
  end
  if not chooseData.nextPray or 0 == chooseData.nextPray.lv then
    MsgManager.ShowMsgByIDTable(2720)
    return
  end
  if nil == praycount then
    local ownCost = BagProxy.Instance:GetItemNumByStaticID(chooseData.nextPray.itemCost.staticData.id)
    if ownCost < chooseData.nextPray.itemCost.num then
      MsgManager.ShowMsgByIDTable(3554, chooseData.costName)
      return
    end
  elseif praycount <= 0 then
    MsgManager.ShowMsgByIDTable(3554, chooseData.costName)
    return
  end
  self:ActiveLock(true)
  TimeTickManager.Me():ClearTick(self)
  TimeTickManager.Me():CreateOnceDelayTick(1500, function(owner, deltaTime)
    self:PlayPrayResultAnim()
    self:ActiveLock(false)
    self:_updatePrayGrid()
    self:_updateDialogContent()
  end, self)
  local npcInfo = self:GetCurNpc()
  if npcInfo then
    praycount = praycount or 1
    ServiceGuildCmdProxy.Instance:CallPrayGuildCmd(GuildCmd_pb.EPRAYACTION_PRAY, chooseData.id, praycount)
  end
end
function GvGPvPPrayDialog:PlayPrayResultAnim()
  for _, cell in pairs(self.prayCells) do
    if self.chooseData and cell.data.id == self.chooseData.id then
      cell:PlayPrayEffect()
    end
  end
end
function GvGPvPPrayDialog:ChoosePray(cellctl)
  local data = cellctl and cellctl.data
  if data then
    self.chooseData = cellctl.data
    if self.chooseId ~= data.id then
      self.chooseId = data.id
      self:_updateDialogContent()
      for _, cell in pairs(self.prayCells) do
        cell:SetChoose(self.chooseId)
      end
    end
  end
end
function GvGPvPPrayDialog:_updateDialogContent()
  if self.lockState then
    return
  end
  local npcInfo = self:GetCurNpc()
  if not npcInfo then
    return
  end
  local prayData = GuildPrayProxy.Instance:GetPrayListByType(self.choosePageID)
  for i = 1, #prayData do
    if prayData[i].id == self.chooseData.id then
      self.chooseData = prayData[i]
      break
    end
  end
  local prayDlgData = {
    Speaker = npcInfo.data.staticData.id,
    NoSpeak = true
  }
  local args = self.chooseData:GetAddAttrValue()
  if args[1] then
    prayDlgData.Text = string.format(ZhString.GvGPvPPray_Dialog, args[2], args[4], args[5], args[6])
  else
    prayDlgData.Text = string.format(ZhString.GvGPvPPray_DialogLimit, args[2])
  end
  self.prayDialog:SetData(prayDlgData)
  self.multiPrayCount.text = string.format(ZhString.GvGPvPPray_Dialog_PrayCount, self.chooseData:CalcMaxPrayCount())
end
function GvGPvPPrayDialog:InitPray()
  self:ShowUIByPage(self.choosePageID)
  self:_refreshChoose()
  self:_updatePrayGrid()
end
function GvGPvPPrayDialog:_refreshChoose()
  if self.gridListCtl then
    local childCells = self.gridListCtl:GetCells()
    for i = 1, #childCells do
      local childCell = childCells[i]
      childCell:ShowChooseImg(self.choosePageID)
    end
  end
end
function GvGPvPPrayDialog:DisplayPrayByType(data)
  if not self.itemWrapHelper then
    local wrapConfig = {
      wrapObj = self.itemPrayRoot,
      pfbNum = 5,
      cellName = "GvGPvpPrayTypeCell",
      control = GvGPvpPrayTypeCell,
      dir = 1
    }
    self.itemWrapHelper = WrapCellHelper.new(wrapConfig)
    self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.ChoosePray, self)
  end
  self.itemWrapHelper:UpdateInfo(data)
  self.itemWrapHelper:ResetPosition()
  self.prayCells = self.itemWrapHelper:GetCellCtls()
  self:ChoosePray(self.prayCells[1])
end
function GvGPvPPrayDialog:_clickPageToggle(cellctl)
  if cellctl and cellctl.data.type ~= self.choosePageID then
    self.choosePageID = cellctl.data.type
    self:ShowUIByPage(self.choosePageID)
    self:_refreshChoose()
  end
end
function GvGPvPPrayDialog:ShowUIByPage(type)
  local pageData = GuildPrayProxy.Instance:GetPrayListByType(type)
  if pageData then
    self:DisplayPrayByType(pageData)
  end
end
function GvGPvPPrayDialog:_updatePrayGrid()
  if self.lockState then
    return
  end
  if self.itemWrapHelper then
    local data = GuildPrayProxy.Instance:GetPrayListByType(self.choosePageID)
    self.itemWrapHelper:UpdateInfo(data)
  end
end
function GvGPvPPrayDialog:InitCoins()
  if #_GVGPrayConfig ~= 3 then
    return
  end
  self.atkLab = self:FindComponent("Label", UILabel, self:FindGO("atkIcon"))
  self.atkIcon = self:FindComponent("symbol", UISprite, self:FindGO("atkIcon"))
  self.defLab = self:FindComponent("Label", UILabel, self:FindGO("defIcon"))
  self.defIcon = self:FindComponent("symbol", UISprite, self:FindGO("defIcon"))
  self.attrCellLab = self:FindComponent("Label", UILabel, self:FindGO("attrCellIcon"))
  self.attrCellIcon = self:FindComponent("symbol", UISprite, self:FindGO("attrCellIcon"))
  self.costItem = {}
  self.costItem.atk = _GVGPrayConfig[1][2]
  self.costItem.def = _GVGPrayConfig[2][2]
  self.costItem.cell = _GVGPrayConfig[3][2]
  IconManager:SetItemIcon(Table_Item[self.costItem.atk].Icon, self.atkIcon)
  IconManager:SetItemIcon(Table_Item[self.costItem.def].Icon, self.defIcon)
  IconManager:SetItemIcon(Table_Item[self.costItem.cell].Icon, self.attrCellIcon)
  self:_updateCoins()
end
function GvGPvPPrayDialog:_updateCoins()
  local _bagMrg = BagProxy.Instance
  self.atkLab.text = _bagMrg:GetItemNumByStaticID(self.costItem.atk)
  self.defLab.text = _bagMrg:GetItemNumByStaticID(self.costItem.def)
  self.attrCellLab.text = _bagMrg:GetItemNumByStaticID(self.costItem.cell)
end
