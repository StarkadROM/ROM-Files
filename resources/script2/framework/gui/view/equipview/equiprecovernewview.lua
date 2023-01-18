autoImport("EquipNewChooseBord")
autoImport("EquipRecoverCell")
autoImport("BaseItemNewCell")
EquipRecoverNewView = class("EquipRecoverNewView", BaseView)
EquipRecoverNewView.BrotherView = EquipRecoverCombinedView
EquipRecoverNewView.ViewType = UIViewType.NormalLayer
function EquipRecoverNewView:OnEnter()
  if self.npcdata then
    local npcRootTrans = self.npcdata.assetRole.completeTransform
    if npcRootTrans then
      self:CameraFocusOnNpc(npcRootTrans)
    end
  end
  if self.isCombine then
    self.content.transform.localPosition = LuaGeometry.GetTempVector3(-72, 0, 0)
    self.closeButton:SetActive(false)
  else
    self.content.transform.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
    self.closeButton:SetActive(true)
  end
end
function EquipRecoverNewView:OnShow()
  Game.Myself:UpdateEpNodeDisplay(true)
end
function EquipRecoverNewView:OnExit()
  self:CameraReset()
  EquipRecoverNewView.super.OnExit(self)
end
function EquipRecoverNewView:Init()
  local viewdata = self.viewdata.viewdata
  self.npcdata = viewdata and viewdata.npcdata
  self.isCombine = viewdata and viewdata.isCombine
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self:InitView()
end
function EquipRecoverNewView:FindObjs()
  self.content = self:FindGO("Content")
  self.closeButton = self:FindGO("CloseButton")
  self.title = self:FindComponent("Title", UILabel)
  self.addItemButton = self:FindGO("AddItemInButton")
  self.targetBtn = self:FindGO("TargetCell")
  self.totalCost = self:FindGO("PriceNum"):GetComponent(UILabel)
  local sprite = self:FindComponent("PriceIcon", UISprite)
  IconManager:SetItemIcon(Table_Item[GameConfig.MoneyId.Zeny].Icon, sprite)
  self.itemName = self:FindGO("ItemName"):GetComponent(UILabel)
  self.itemNameBg = self:FindGO("NameBg"):GetComponent(UISprite)
  self.emptyTip = self:FindGO("EmptyTip")
  self.helpBtn = self:FindGO("HelpButton")
  self.helpBtn:SetActive(false)
end
local cardids = {}
function EquipRecoverNewView:AddEvts()
  self:AddClickEvent(self.addItemButton, function(go)
    self:ClickTargetCell()
  end)
  local recoverButton = self:FindGO("RecoverButton")
  self:AddClickEvent(recoverButton, function()
    if self.nowdata then
      if MyselfProxy.Instance:GetROB() < tonumber(self.totalCost.text) then
        MsgManager.ShowMsgByID(1)
        return
      end
      do
        local cells = self.recoverCtl:GetCells()
        local enchant = false
        local upgrade = false
        TableUtility.ArrayClear(cardids)
        if #cells > 0 then
          for i = 1, 2 do
            if cells[i].data ~= EquipRecoverProxy.RecoverType.EmptyCard and cells[i].toggle.value then
              TableUtility.ArrayPushBack(cardids, cells[i].data.id)
            end
          end
          enchant = cells[3].toggle.value
          upgrade = cells[4].toggle.value
        end
        local cardCount = #cardids
        local bagData = BagProxy.Instance:GetBagByType(BagProxy.BagType.MainBag)
        if cardCount > bagData:GetSpaceItemNum() then
          MsgManager.ShowMsgByID(3101)
          return
        end
        if cardCount > 0 or enchant or upgrade then
          local callFunc = function()
            ServiceItemProxy.Instance:CallRestoreEquipItemCmd(self.nowdata.id, false, cardids, enchant, upgrade, false)
          end
          if enchant then
            FunctionSecurity.Me():NormalOperation(function()
              callFunc()
            end)
          else
            callFunc()
          end
        else
        end
      end
    else
    end
  end)
end
function EquipRecoverNewView:AddViewEvts()
  self:AddListenEvt(ServiceEvent.ItemRestoreEquipItemCmd, self.HandleRecover)
end
function EquipRecoverNewView:InitView()
  local chooseContaienr = self:FindGO("ChooseContainer")
  self.chooseBord = EquipNewChooseBord.new(chooseContaienr, function()
    return EquipRecoverProxy.Instance:GetRecoverEquips()
  end)
  self.chooseBord:SetFilterPopData(GameConfig.EquipChooseFilter)
  self.chooseBord:AddEventListener(EquipChooseBord.ChooseItem, self.ChooseItem, self)
  self.chooseBord:Hide()
  self.targetCell = BaseItemNewCell.new(self.targetBtn)
  self.targetCell:AddEventListener(MouseEvent.MouseClick, self.ClickTargetCell, self)
  local recoverGrid = self:FindComponent("RecoverGrid", UIGrid)
  self.recoverCtl = UIGridListCtrl.new(recoverGrid, EquipRecoverCell, "EquipRecoverNewCell")
  self.recoverCtl:AddEventListener(EquipRecoverEvent.Select, self.HandleSelect, self)
end
function EquipRecoverNewView:ChooseItem(itemData)
  self.nowdata = itemData
  self.targetCell:SetData(itemData)
  local printX = self.itemName.printedSize.x
  self.itemNameBg.width = printX + 30
  self.recoverCtl:ResetDatas(EquipRecoverProxy.Instance:GetRecoverToggle(itemData))
  self.chooseBord:Hide()
  self.targetBtn:SetActive(itemData ~= nil)
  self.addItemButton:SetActive(itemData == nil)
  self.emptyTip:SetActive(itemData == nil)
end
function EquipRecoverNewView:ClickTargetCell()
  local equipdatas = EquipRecoverProxy.Instance:GetRecoverEquips()
  if #equipdatas > 0 then
    self.chooseBord:ResetDatas(equipdatas, true)
    self.chooseBord:Show(false)
  else
    MsgManager.ShowMsgByIDTable(390)
    self.chooseBord:Hide()
  end
end
function EquipRecoverNewView:HandleSelect(cellctl)
  local totalCost = 0
  local cells = self.recoverCtl:GetCells()
  for i = 1, #cells do
    if cells[i].toggle.value then
      totalCost = totalCost + tonumber(cells[i].cost.text)
    end
  end
  self.totalCost.text = totalCost
end
function EquipRecoverNewView:HandleRecover()
  local equipdatas = EquipRecoverProxy.Instance:GetRecoverEquips()
  self.chooseBord:ResetDatas(equipdatas, true)
  self:ChooseItem()
end
