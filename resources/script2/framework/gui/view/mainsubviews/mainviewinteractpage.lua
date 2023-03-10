autoImport("InteractMountKickBtnCell")
autoImport("NpcVisitCell")
MainviewInteractPage = class("MainviewInteractPage", SubView)
local ForbidShowReason = {
  Trigger = 1,
  AutoBattle = 2,
  Booth = 3,
  NoAct = 4
}
local InteractMountBtn_Status = {
  Sit = 0,
  ChangeSeat = 1,
  Kick = 2,
  KickOver = 3
}
local InteractMountBtn_2_Status = {Exit = 0}
local FlowerCarMagnetSightBtn_Status = {TurnOn = 0, TurnOff = 1}
function MainviewInteractPage:Init()
  self:FindObjs()
  self:AddButtonEvt()
  self:AddViewEvt()
  self:InitShow()
  self:UpdateInteractMountBtn()
  self.mountKickCells = {}
end
function MainviewInteractPage:FindObjs()
  local l_objMainBord = self:FindGO("MainBord")
  local l_objAnchorDownRight = self:FindGO("Anchor_DownRight", l_objMainBord)
  local l_objInteractBtnGrid = self:FindGO("InteractBtnGrid", l_objMainBord)
  self.interactBtnGrid = l_objInteractBtnGrid:GetComponent(UIGrid)
  self.interactBtnGO = self:FindGO("InteractBtn", l_objInteractBtnGrid)
  self.interactBtn = self.interactBtnGO:GetComponent(UIMultiSprite)
  self.interactLabel = self:FindGO("Label", self.interactBtnGO):GetComponent(UILabel)
  self.objInteractMountBtnRoot = self:FindGO("InteractMountBtns")
  self.objBtnInteractMount = self:FindGO("InteractMountBtn", self.objInteractMountBtnRoot)
  self.mulsprBtnInteractMount = self:FindComponent("Sprite", UIMultiSprite, self.objBtnInteractMount)
  self.objBtnInteractMount_2 = self:FindGO("InteractMountBtn2", self.objInteractMountBtnRoot)
  self.mulsprBtnInteractMount_2 = self:FindComponent("Sprite", UIMultiSprite, self.objBtnInteractMount_2)
  self.objBtnPushObj = self:FindGO("PushObjBtn", l_objAnchorDownRight)
  self.ButtonGrid2 = self:FindGO("Button2Grid")
  self.ButtonGrid2_UIGrid = self.ButtonGrid2:GetComponent(UIGrid)
  self.objBtnFlowerCarMagnetSight = self:FindGO("FlowerCarMagnetSightBtn", self.ButtonGrid2)
  self.spBtnFlowerCarMagnetSight = self.objBtnFlowerCarMagnetSight:GetComponent(UISprite)
  self.lbBtnFlowerCarMagnetSight = self:FindGO("Label", self.objBtnFlowerCarMagnetSight):GetComponent(UILabel)
  self.visitNpcGrid = self:FindGO("VisitNpcGrid", l_objAnchorDownRight):GetComponent(UIGrid)
  self.visitNpcCtrl = UIGridListCtrl.new(self.visitNpcGrid, NpcVisitCell, "NpcVisitCell")
  self.visitNpcCtrl:AddEventListener(MouseEvent.MouseClick, self.clickNpcCell, self)
end
function MainviewInteractPage:AddButtonEvt()
  self:AddClickEvent(self.interactBtnGO, function()
    Game.InteractNpcManager:MyselfManualClick()
  end)
  self:AddClickEvent(self.objBtnInteractMount, function()
    if self.interactMountBtn_Status == InteractMountBtn_Status.Sit then
      Game.InteractNpcManager:MyselfManualClickMount()
    elseif self.interactMountBtn_Status == InteractMountBtn_Status.ChangeSeat then
      Game.InteractNpcManager:TryChangeSeat()
    elseif self.interactMountBtn_Status == InteractMountBtn_Status.Kick or self.interactMountBtn_Status == InteractMountBtn_Status.KickOver then
      self:UpdateKickStatus(self.interactMountBtn_Status == InteractMountBtn_Status.Kick)
    end
  end)
  self:AddClickEvent(self.objBtnInteractMount_2, function()
    if self.interactMountBtn_2_Status == InteractMountBtn_2_Status.Exit then
      Game.InteractNpcManager:TryNotifyGetOffMount()
    end
  end)
  self:AddClickEvent(self.objBtnPushObj, function()
    RaidPuzzleManager.Me():TryPushCurrentTargetObject()
  end)
  self:AddClickEvent(self.objBtnFlowerCarMagnetSight, function()
    if self.lbBtnFlowerCarMagnetSight.text == ZhString.InteractFlowerCar_MagnetSightOff then
      Game.InteractNpcManager:CancelMagnet()
    else
      Game.InteractNpcManager:ExecuteMagnet()
    end
  end)
end
function MainviewInteractPage:AddViewEvt()
  self:AddListenEvt(InteractNpcEvent.MyselfTriggerChange, self.HandleTriggerChange)
  self:AddListenEvt(InteractNpcEvent.MyselfOnOffChange, self.UpdateInteractBtn)
  self:AddListenEvt(InteractNpcEvent.MyselfTriggerMountChange, self.UpdateInteractMountBtn)
  self:AddListenEvt(InteractNpcEvent.MyselfOnOffMountChange, self.UpdateInteractMountBtn)
  self:AddListenEvt(InteractNpcEvent.MyselfPassengerChange, self.UpdateInteractMountBtn)
  self:AddListenEvt(ServiceEvent.NUserBoothReqUserCmd, self.HandleBooth)
  self:AddListenEvt(MyselfEvent.MyPropChange, self.HandleProp)
  self:AddDispatcherEvt(AutoBattleManagerEvent.StateChanged, self.HandleAutoBattle)
  self:AddListenEvt(SceneUserEvent.SceneAddNpcs, self.HandleAddNpc)
  self:AddListenEvt(InteractNpcEvent.PushableTargetChange, self.UpdatePushObjBtn)
  self:AddListenEvt(InteractNpcEvent.FlowerCarMagnetSightChange, self.UpdateFlowerCarMagnetSightBtn)
  self:AddListenEvt(InteractNpcEvent.RefreshNpcVisitList, self.UpdateNpcVisitBtn)
end
function MainviewInteractPage:InitShow()
  self.reasonMap = {}
end
function MainviewInteractPage:HandleTriggerChange(note)
  self:UpdateReason(ForbidShowReason.Trigger, not note.body and 1 or 0)
end
function MainviewInteractPage:HandleAutoBattle()
  self:UpdateReason(ForbidShowReason.AutoBattle, Game.AutoBattleManager.on and 1 or nil)
end
function MainviewInteractPage:HandleBooth()
  self:UpdateReason(ForbidShowReason.Booth, Game.Myself:IsInBooth() and 1 or nil)
end
function MainviewInteractPage:HandleProp()
  self:UpdateReason(ForbidShowReason.NoAct, Game.Myself.data:NoAct() and 1 or nil)
end
function MainviewInteractPage:UpdateReason(type, value)
  local hasReason = self.reasonMap[type]
  if hasReason ~= value then
    self.reasonMap[type] = value
    self:ShowInteractBtn()
  end
end
function MainviewInteractPage:ShowInteractBtn()
  if Slua.IsNull(self.interactBtnGO) then
    return
  end
  for k, v in pairs(self.reasonMap) do
    if v == 1 then
      if self.interactBtnGO.activeSelf then
        self.interactBtnGO:SetActive(false)
        self.interactBtnGrid:Reposition()
      end
      return
    end
  end
  if self.reasonMap[ForbidShowReason.Trigger] == 0 then
    if not self.interactBtnGO.activeSelf then
      self.interactBtnGO:SetActive(true)
      self.interactBtnGrid:Reposition()
    end
    self:UpdateInteractBtn()
  end
end
function MainviewInteractPage:UpdateInteractBtn(note)
  local isMyselfOnNpc = note and note.body or Game.InteractNpcManager:IsMyselfOnNpc()
  self.interactBtn.CurrentState = isMyselfOnNpc and 1 or 0
  self.interactBtn:MakePixelPerfect()
  self.interactLabel.text = isMyselfOnNpc and ZhString.InteractNpc_GetOff or ZhString.InteractNpc_GetOn
end
function MainviewInteractPage:HandleAddNpc(note)
  local data = note.body
  if not data then
    return
  end
  local target
  for i = 1, #data do
    target = data[i]
    local opt = target.data and target.data.userdata:Get(UDEnum.OPTION)
    if opt == 1 then
      target:SetVisible(false, LayerChangeReason.Lock)
      FunctionPlayerUI.Me():MaskAllUI(target, PUIVisibleReason.Lock)
      target:SetClickable(true)
    end
  end
end
function MainviewInteractPage:UpdateKickStatus(isKickStatus)
  self:ClearKickCells()
  if not Game.InteractNpcManager:IsMyselfRideInteractMount() then
    return
  end
  local lastBtn_Status = self.interactMountBtn_Status
  if isKickStatus then
    local interactMount = Game.InteractNpcManager:GetInteractMount(Game.Myself.data.id)
    if not interactMount then
      LogUtility.Error("????????????????????????????????????", tostring(Game.Myself.data.id))
    end
    self.interactMountBtn_Status = InteractMountBtn_Status.KickOver
    local cpMap = interactMount:GetCPMap()
    local objCell, kickCell, player
    local container = SceneUIManager.Instance:GetSceneUIContainer(SceneUIType.RoleTopInfo)
    if not self.mountKickCells then
      self.mountKickCells = {}
    end
    for cpID, charID in pairs(cpMap) do
      player = SceneCreatureProxy.FindCreature(charID)
      if player then
        objCell = Game.AssetManager_UI:CreateSceneUIAsset(InteractMountKickBtnCell.ResID, container)
        objCell:SetActive(false)
        objCell.transform.localRotation = LuaGeometry.Const_Qua_identity
        objCell.transform.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
        kickCell = InteractMountKickBtnCell.new(objCell)
        kickCell:SetMountInfo(cpID, charID)
        kickCell:AddEventListener(MouseEvent.MouseClick, self.OnBtnMountKickClick, self)
        player:Client_RegisterFollow(kickCell.trans, nil, RoleDefines_EP.Top, OnLostCreatureFollow, charID)
        objCell:SetActive(true)
        self.mountKickCells[cpID] = kickCell
      else
        LogUtility.Error("????????????????????????", tostring(charID))
      end
    end
  else
    self.interactMountBtn_Status = InteractMountBtn_Status.Kick
  end
  if lastBtn_Status ~= self.interactMountBtn_Status then
    self.mulsprBtnInteractMount.CurrentState = self.interactMountBtn_Status
  end
end
local OnLostCreatureFollow = function(transform, creatureGUID)
  if not self.mountKickCells then
    return
  end
  for cpID, kickCell in pairs(self.mountKickCells) do
    if kickCell.charID == creatureGUID then
      if not LuaGameObject.ObjectIsNull(kickCell.gameObject) then
        Game.GOLuaPoolManager:AddToSceneUIPool(InteractMountKickBtnCell.ResID, kickCell.gameObject)
      end
      self.mountKickCells[cpID] = nil
      break
    end
  end
end
function MainviewInteractPage:OnBtnMountKickClick(cell)
  local charID = cell and cell.charID
  if not charID then
    LogUtility.Error("?????????masterID")
    return
  end
  ServiceNUserProxy.Instance:CallKickOffPassengerUserCmd(charID)
end
function MainviewInteractPage:UpdateInteractMountBtn(note)
  local lastBtn_Status = self.interactMountBtn_Status
  local lastBtn_2_Status = self.interactMountBtn_2_Status
  if Game.InteractNpcManager:IsMyselfRideInteractMount() then
    local interactMount = Game.InteractNpcManager:GetInteractMount(Game.Myself.data.id)
    local isEmpty = not interactMount or interactMount:IsEmpty()
    self.objBtnInteractMount:SetActive(not isEmpty)
    self.objBtnInteractMount_2:SetActive(false)
    if lastBtn_Status ~= InteractMountBtn_Status.KickOver or isEmpty then
      self.interactMountBtn_Status = InteractMountBtn_Status.Kick
    end
    self.interactMountBtn_2_Status = InteractMountBtn_2_Status.Exit
  elseif Game.InteractNpcManager:IsMyselfOnInteractMount() then
    self.objBtnInteractMount:SetActive(true)
    self.objBtnInteractMount_2:SetActive(true)
    self.interactMountBtn_Status = InteractMountBtn_Status.ChangeSeat
    self.interactMountBtn_2_Status = InteractMountBtn_2_Status.Exit
  else
    self.objBtnInteractMount:SetActive(Game.InteractNpcManager:GetTargetInteractMountID() ~= nil)
    self.objBtnInteractMount_2:SetActive(false)
    self.interactMountBtn_Status = InteractMountBtn_Status.Sit
    self.interactMountBtn_2_Status = InteractMountBtn_2_Status.Exit
  end
  if lastBtn_Status ~= self.interactMountBtn_Status then
    self.mulsprBtnInteractMount.CurrentState = self.interactMountBtn_Status
  end
  if lastBtn_2_Status ~= self.interactMountBtn_2_Status then
    self.mulsprBtnInteractMount_2.CurrentState = self.interactMountBtn_2_Status
  end
  self:UpdateKickStatus(self.interactMountBtn_Status == InteractMountBtn_Status.KickOver)
end
function MainviewInteractPage:ClearKickCells()
  if not self.mountKickCells then
    return
  end
  local player
  for cpID, kickCell in pairs(self.mountKickCells) do
    if kickCell then
      player = SceneCreatureProxy.FindCreature(kickCell.masterID)
      if player then
        player:Client_UnregisterFollow(kickCell.trans)
      end
      if not LuaGameObject.ObjectIsNull(kickCell.gameObject) then
        Game.GOLuaPoolManager:AddToSceneUIPool(InteractMountKickBtnCell.ResID, kickCell.gameObject)
      end
    end
  end
  TableUtility.TableClear(self.mountKickCells)
end
function MainviewInteractPage:UpdatePushObjBtn(note)
  local isShow = note.body == true
  if isShow == self.isShowBtnPushObj then
    return
  end
  self.isShowBtnPushObj = isShow
  self.objBtnPushObj:SetActive(isShow)
end
function MainviewInteractPage:UpdateFlowerCarMagnetSightBtn(note)
  if note.body.inMagnet then
    self.objBtnFlowerCarMagnetSight:SetActive(true)
    self.lbBtnFlowerCarMagnetSight.text = ZhString.InteractFlowerCar_MagnetSightOff
  else
    self.lbBtnFlowerCarMagnetSight.text = ZhString.InteractFlowerCar_MagnetSightOn
    if note.body.inRange then
      self.objBtnFlowerCarMagnetSight:SetActive(true)
    else
      self.objBtnFlowerCarMagnetSight:SetActive(false)
    end
  end
  self.interactBtnGrid:Reposition()
  if self.ButtonGrid2_UIGrid then
    self.ButtonGrid2_UIGrid:Reposition()
  end
end
function MainviewInteractPage:UpdateNpcVisitBtn(note)
  local npcs = note.body
  local result = {}
  local showLimit = GameConfig.Quest.maxVisitNpcSymbol or 4
  local count = 0
  for k, v in pairs(npcs) do
    if showLimit >= count then
      table.insert(result, v)
      count = count + 1
    end
  end
  self.visitNpcCtrl:ResetDatas(result)
end
function MainviewInteractPage:clickNpcCell(cellCtrl)
  local targetNpcId = cellCtrl and cellCtrl.npcid
  if cellCtrl.target and cellCtrl.target.data then
    FunctionVisitNpc.Me():AccessTarget(cellCtrl.target)
  end
end
function MainviewInteractPage:OnShow()
  self:UpdateInteractMountBtn()
end
function MainviewInteractPage:OnHide()
  self:ClearKickCells()
end
