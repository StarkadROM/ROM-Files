autoImport("MyselfEquipItemCell")
PackageEquipPage = class("PackageEquipPage", SubView)
PackageEquip_FashionParts = {
  2,
  7,
  8,
  1,
  9,
  10,
  11,
  12,
  13,
  5
}
if GameConfig.SystemForbid.FashionPart then
  PackageEquip_FashionParts = {
    8,
    7,
    9,
    1,
    10,
    11,
    12,
    5
  }
end
PackageEquip_ShowShieldPart_Class = {
  72,
  73,
  74,
  75
}
PackageEquip_ShowCar_Class = {
  [61] = 1,
  [62] = 1,
  [63] = 1,
  [64] = 1,
  [65] = 1,
  [132] = 1,
  [133] = 1,
  [134] = 1,
  [135] = 1,
  [143] = 1,
  [144] = 1,
  [145] = 1
}
autoImport("MyselfEquipItemCell")
autoImport("EquipPreviewMenuCell")
local EQUIP_MAXINDEX
local FullRefinePos = GameConfig.TwelvePvp.FullRefinePos
function PackageEquipPage:Init()
  EQUIP_MAXINDEX = ItemUtil.EquipMaxIndex()
  self:AddViewInterest()
  self:InitUI()
end
function PackageEquipPage:GetEquipGrid()
  if self.equipGrid ~= nil then
    return self.equipGrid
  end
  self.equipGrid = self:FindComponent("EquipGrid", UIGrid)
  function self.equipGrid.onReposition()
    if not self.equipGrid then
      return
    end
    local childCount = self.equipGrid.transform.childCount
    if childCount == 13 then
      local cell13 = self.equipGrid.transform:GetChild(12)
      if cell13 then
        cell13.transform.localPosition = LuaGeometry.GetTempVector3(216, -488)
      end
    elseif childCount == 14 then
      local cell13 = self.equipGrid.transform:GetChild(12)
      if cell13 then
        cell13.transform.localPosition = LuaGeometry.GetTempVector3(144, -488)
      end
      local cell14 = self.equipGrid.transform:GetChild(13)
      if cell14 then
        cell14.transform.localPosition = LuaGeometry.GetTempVector3(288, -488)
      end
    end
  end
  return self.equipGrid
end
function PackageEquipPage:InitCtls()
  local myPro = Game.Myself.data.userdata:Get(UDEnum.PROFESSION)
  if self.roleEquips then
    local cachePro = self.cachePro
    if cachePro ~= nil and cachePro == myPro then
      return
    end
  end
  self.cachePro = myPro
  self.share = self:FindGO("ShareButton")
  self:AddClickEvent(self.share, function()
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.PackageEquipShareView,
      viewdata = {
        data = self.curData,
        argumentTable = self.curArgumentTable
      }
    })
  end)
  local rewardTips = self:FindGO("WeekRewardTips")
  local FirstRewardIcon = self:FindGO("FirstRewardIcon", rewardTips):GetComponent(UISprite)
  local data = ItemData.new("FirstRewardIcon", GameConfig.Share.ShareReward[1])
  IconManager:SetItemIcon(data.staticData.Icon, FirstRewardIcon)
  local FirstRewardCountLbl = self:FindGO("FirstRewardCountLbl", rewardTips):GetComponent(UILabel)
  FirstRewardCountLbl.text = "x" .. GameConfig.Share.ShareReward[2]
  local weekReward = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_SHARE_WEEK_REWARD) or 0
  if weekReward == 1 then
    rewardTips:SetActive(false)
  else
    rewardTips:SetActive(true)
  end
  self:InitEquipCtl()
  self:InitFoldedEquipCtl()
  self:AddListenEvt(ShareNewEvent.HideWeekShraeTip, self.OnHideWeekShareTip, self)
end
function PackageEquipPage:CheckShowShareBtn()
  if GameConfig.Share then
    local canOpen = FunctionUnLockFunc.Me():CheckCanOpen(GameConfig.Share.MenuID)
    if canOpen then
      self:Show(self.share)
    else
      self:Hide(self.share)
    end
    local rewardTips = self:FindGO("WeekRewardTips")
    local weekReward = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_SHARE_WEEK_REWARD) or 0
    if weekReward == 1 then
      rewardTips:SetActive(false)
    else
      rewardTips:SetActive(true)
    end
  end
end
function PackageEquipPage:OnHideWeekShareTip()
  local rewardTips = self:FindGO("WeekRewardTips")
  if rewardTips then
    rewardTips:SetActive(false)
  end
end
function PackageEquipPage:InitEquipCtl()
  local equipGrid = self:GetEquipGrid()
  if equipGrid.transform.childCount > 0 then
    for i = equipGrid.transform.childCount - 1, 0, -1 do
      local go = equipGrid.transform:GetChild(i)
      if go and go ~= self.chooseSymbol then
        GameObject.DestroyImmediate(go.gameObject)
      end
    end
  end
  self.roleEquips = {}
  local profession = MyselfProxy.Instance:GetMyProfession()
  local canEquipCar = Table_Class[profession].Type == 6 or PackageEquip_ShowCar_Class[profession] ~= nil
  for i = 1, 14 do
    if i ~= 14 or canEquipCar then
      local obj
      obj = self:LoadPreferb("cell/RoleEquipItemCell", equipGrid)
      obj.name = "RoleEquipItemCell" .. i
      self.roleEquips[i] = MyselfEquipItemCell.new(obj, i)
      self.roleEquips[i]:AddEventListener(MouseEvent.MouseClick, self.ClickEquip, self)
      self.roleEquips[i]:AddEventListener(MouseEvent.DoubleClick, self.DoubleClickEquip, self)
    end
  end
  equipGrid:Reposition()
end
function PackageEquipPage:InitEquipSuitPreviewCtl()
  self.previewSuitRoot = self:FindGO("PreviewSuitRoot")
  if not self.previewSuitRoot then
    return
  end
  local suitSkillId = GameConfig.RiskSkill and GameConfig.RiskSkill.magicSuit
  if not suitSkillId then
    return
  end
  self.magicSuitUnlock = SkillProxy.Instance:HasLearnedSkill(suitSkillId)
  self.previewSuitRoot:SetActive(self.magicSuitUnlock)
  if not self.suitpreviewInited then
    self.suitpreviewInited = true
    self.suitNameInput = self:FindComponent("SuitNameInput", UIInput, self.previewSuitRoot)
    self:Hide(self.suitNameInput)
    local menuTable = self:FindComponent("MenuTable", UITable, self.previewSuitRoot)
    self.equipSuitCtl = UIGridListCtrl.new(menuTable, EquipPreviewMenuCell, "EquipPreviewMenuCell")
    self.equipSuitCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickSuitCell, self)
    self.saveSuitBtn = self:FindGO("SaveSuitBtn")
    local saveSuitLab = self:FindComponent("Label", UILabel, self.saveSuitBtn)
    saveSuitLab.text = ZhString.RoleSuitEquipPreview_SaveBtn
    self:AddClickEvent(self.saveSuitBtn, function()
      self:OnClickSaveSuitBtn()
    end)
    self.saveMenuGrid = self:FindComponent("SaveMenuGrid", UIGrid, self.previewSuitRoot)
    self.equipSaveSuitCtl = UIGridListCtrl.new(self.saveMenuGrid, EquipPreviewMenuCell, "EquipPreviewMenuCell")
    self.equipSaveSuitCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickSaveSuit, self)
  end
end
function PackageEquipPage:OnClickSaveSuitBtn()
  if not self.saveSuitMenuInited then
    local data = EquipBagPreviewProxy.Instance:GetSuitMenu()
    self.equipSaveSuitCtl:ResetDatas(data)
    self.saveSuitMenuInited = true
  end
  self:Show(self.saveMenuGrid)
end
function PackageEquipPage:OnClickSaveSuit(cellCtl)
  local index = cellCtl.data
  if not index then
    return
  end
  self:Hide(self.saveMenuGrid)
  EquipBagPreviewProxy.Instance:DoSave(index)
end
function PackageEquipPage:UpdateSuitMenu()
  local data = EquipBagPreviewProxy.Instance:GetSuitMenu()
  self.equipSuitCtl:ResetDatas(data)
end
function PackageEquipPage:OnClickSuitCell(cellCtl)
  local index = cellCtl.data
  if not index then
    return
  end
  EquipBagPreviewProxy.Instance:DoApply(index)
end
local foldedEquipConfig = {
  [5] = 19,
  [7] = 15,
  [8] = 16,
  [11] = 17
}
function PackageEquipPage:InitFoldedEquipCtl()
  self.foldedEquip = {}
  for k, v in pairs(foldedEquipConfig) do
    local cellGO = self.roleEquips[k] and self.roleEquips[k].gameObject
    local go = cellGO and self:FindGO("ArtifactEquipCell", cellGO)
    if cellGO and not go then
      local createFoldedGO = function()
        go = self:LoadPreferb("cell/ArtifactEquipCell", cellGO)
        go.name = "ArtifactEquipCell"
      end
      createFoldedGO()
    end
    if go then
      local equipGO = self:FindGO("RoleEquipItemCell", go)
      if equipGO then
        local roleEquipCell = MyselfEquipItemCell.new(equipGO, v)
        roleEquipCell:AddEventListener(MouseEvent.MouseClick, self.ClickEquip, self)
        roleEquipCell:AddEventListener(MouseEvent.DoubleClick, self.DoubleClickEquip, self)
        self.roleEquips[v] = roleEquipCell
        if k >= 13 then
          go.transform.localEulerAngles = LuaGeometry.GetTempVector3(0, 0, -90)
          equipGO.transform.localEulerAngles = LuaGeometry.GetTempVector3(0, 0, 90)
        elseif k <= 6 then
          go.transform.localEulerAngles = LuaGeometry.GetTempVector3(0, 0, -180)
          equipGO.transform.localEulerAngles = LuaGeometry.GetTempVector3(0, 0, 180)
        end
      end
      self.foldedEquip[k] = go
    else
    end
  end
end
function PackageEquipPage:InitUI()
  self.chooseSymbol = self:FindGO("EquipChoose")
  self.normalStick = self.container.normalStick
end
function PackageEquipPage:OnEnter()
  PackageEquipPage.super.OnEnter(self)
  self.grids = {}
  self:InitCtls()
  self:UpdateEquip()
  self:InitEquipSuitPreviewCtl()
end
local tipOffset = {210, 0}
function PackageEquipPage:ClickEquip(cellCtl)
  if self.container.markingFavoriteMode then
    return
  end
  local packageView = self.container
  if packageView.equipStrengthenIsShow then
    if cellCtl ~= nil and self.chooseSite ~= cellCtl.index then
      if StrengthProxy.Instance:IsCouldStrengthen(cellCtl.index) then
        self:SetChoosenSite(cellCtl)
        packageView.equipStrengthenViewController:Refresh(cellCtl.index)
      else
        MsgManager.ShowMsgByIDTable(243)
      end
    else
      self:CancelChoose()
      packageView.equipStrengthenViewController:SetNormalOrEmpty(false)
    end
  elseif cellCtl ~= nil and self.chooseEquip ~= cellCtl then
    self:SetChoose(cellCtl)
    local data = cellCtl.data
    if data and data.staticData then
      local funcs = self.container:GetDataFuncs(data, FunctionItemFunc_Source.RoleEquipBag, cellCtl.isfashion)
      local callback = function()
        self:CancelChoose()
      end
      local show = false
      for i = 1, #FullRefinePos do
        if FullRefinePos[i] == cellCtl.index then
          show = true
        end
      end
      local sdata = {
        itemdata = data,
        funcConfig = funcs,
        ignoreBounds = {
          cellCtl.gameObject
        },
        callback = callback,
        showUpTip = true,
        showFullAttr = (PvpProxy.Instance:IsFreeFire() or TwelvePvPProxy.Instance:IsInNormalTwelvePvp()) and show,
        equipBuffUpSource = Game.Myself.data.id,
        showButton = "equip"
      }
      local itemTip = self:ShowItemTip(sdata, self.normalStick, nil, tipOffset)
      if not cellCtl:IsEffective() then
        itemTip:GetCell(1):SetNoEffectTip(true)
      end
    else
      self:ShowItemTip()
    end
  else
    self:CancelChoose()
  end
end
function PackageEquipPage:SetChoose(cellCtl)
  self:SetChoosenSite()
  if cellCtl then
    local index = cellCtl.index
    if type(index) == "number" then
      BagProxy.Instance:SetToEquipPos(ItemUtil.GetEposByIndex(index))
    else
      BagProxy.Instance:SetToEquipPos()
    end
    local go = cellCtl.gameObject
    if go then
      self.chooseSymbol:SetActive(true)
      self.chooseSymbol.transform:SetParent(go.transform, false)
    else
      self.chooseSymbol:SetActive(false)
      self.chooseSymbol.transform:SetParent(go.transform, false)
      self.chooseSymbol.transform:SetParent(self.trans, false)
    end
    self.chooseEquip = cellCtl
  else
    self.chooseSymbol:SetActive(false)
    self.chooseSymbol.transform:SetParent(self.trans, false)
    BagProxy.Instance:SetToEquipPos()
    self.chooseEquip = nil
  end
end
function PackageEquipPage:SetChoosenSite(cellCtl)
  if cellCtl then
    local index = cellCtl.index
    local go = cellCtl.gameObject
    if go then
      self.chooseSymbol:SetActive(true)
      self.chooseSymbol.transform:SetParent(go.transform, false)
    else
      self.chooseSymbol:SetActive(false)
      self.chooseSymbol.transform:SetParent(go.transform, false)
      self.chooseSymbol.transform:SetParent(self.trans, false)
    end
    self.chooseSite = index
  else
    self.chooseSymbol:SetActive(false)
    self.chooseSymbol.transform:SetParent(self.trans, false)
    self.chooseSite = nil
  end
end
function PackageEquipPage:DoubleClickEquip(cellCtl)
  if self.container.markingFavoriteMode then
    return
  end
  local packageView = self.container
  if packageView.equipStrengthenIsShow then
    return
  end
  local data = cellCtl.data
  if data then
    local funcs = self.container:GetDataFuncs(data, FunctionItemFunc_Source.RoleEquipBag)
    if funcs[1] then
      local tipfunc = FunctionItemFunc.Me():GetFuncById(funcs[1])
      if type(tipfunc) == "function" then
        tipfunc(data)
      end
    end
  end
  self:SetChoose()
  TipManager.Instance:CloseItemTip()
end
function PackageEquipPage:UpdateEquipItems()
  local equipdata = BagProxy.Instance.roleEquip.siteMap
  for i = 1, EQUIP_MAXINDEX do
    if self.roleEquips[i] then
      self.roleEquips[i]:SetData(equipdata[i])
    end
  end
end
function PackageEquipPage:UpdateEquip()
  self:UpdateEquipItems()
  if TwelvePvPProxy.Instance:IsInNormalTwelvePvp() then
    self:HandleTeamTwelveLaunch()
  end
  if Game.MapManager:IsPvpMode_DesertWolf() then
    self:HandleFreeFireChanged()
  end
  if self.equipGrid then
    self.equipGrid.repositionNow = true
  end
end
function PackageEquipPage:SetItemDragEnabled(b)
end
function PackageEquipPage:AddViewInterest()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateEquip)
  self:AddListenEvt(ItemEvent.EquipUpdate, self.UpdateEquip)
  self:AddListenEvt(ItemEvent.StrengthLvUpdate, self.HandleStrengthLvup)
  self:AddListenEvt(ItemEvent.StrengthLvReinit, self.HandleStrengthReInit)
  self:AddListenEvt(ItemEvent.GuildStrengthLvUpdate, self.UpdateEquip)
  self:AddListenEvt(ServiceEvent.ItemEquipPosDataUpdate, self.UpdateEquip)
  self:AddListenEvt(MyselfEvent.MyProfessionChange, self.UpdateEquip)
  self:AddListenEvt(ItemEvent.Equip, self.CancelChoose)
  self:AddListenEvt(PVPEvent.TeamTwelve_Launch, self.HandleTeamTwelveLaunch)
  self:AddListenEvt(PVPEvent.TeamTwelve_ShutDown, self.HandleTeamTwelveShutdown)
  self:AddListenEvt(MyselfEvent.SyncBuffs, self.UpdateEquip)
  self:AddDispatcherEvt(PVPEvent.OnFreeFireStateChanged, self.HandleFreeFireChanged)
end
function PackageEquipPage:CancelChoose()
  self.chooseSymbol:SetActive(false)
  self.chooseSymbol.transform:SetParent(self.trans, false)
  self:ShowItemTip()
  self:SetChoose()
end
function PackageEquipPage:OnExit()
  self:CancelChoose()
  PackageEquipPage.super.OnExit(self)
end
function PackageEquipPage:OnDestroy()
  for index, gridTables in pairs(self.grids) do
    if gridTables then
      TableUtility.TableClear(gridTables)
    end
  end
  PackageEquipPage.super.OnDestroy(self)
end
function PackageEquipPage:AddMaskOnItems()
  local roleEquips = self.roleEquips
  if roleEquips then
    for _, roleEquip in pairs(roleEquips) do
      roleEquip:ShowMask()
    end
  end
end
function PackageEquipPage:ShowPureSite(var)
  local roleEquips = self.roleEquips
  if roleEquips then
    for _, roleEquip in pairs(roleEquips) do
      roleEquip:ShowPureSite(var)
    end
  end
  for _, v in pairs(self.foldedEquip) do
    v:SetActive(not var)
  end
end
function PackageEquipPage:RemoveMaskOnItems()
  local roleEquips = self.roleEquips
  if roleEquips then
    for _, roleEquip in pairs(roleEquips) do
      roleEquip:HideMask()
    end
  end
end
function PackageEquipPage:ActiveSuitPreview(show)
  if not self.magicSuitUnlock then
    return
  end
  if show then
    self:Show(self.previewSuitRoot)
    self:Hide(self.saveMenuGrid)
    self:UpdateSuitMenu()
  else
    self:Hide(self.previewSuitRoot)
    self:UpdateEquipItems()
  end
end
function PackageEquipPage:HandleTeamTwelveLaunch()
  if not self.roleEquips then
    return
  end
  if not TwelvePvPProxy.Instance:IsInNormalTwelvePvp() then
    return
  end
  for i = 1, #FullRefinePos do
    if self.roleEquips[FullRefinePos[i]] then
      self.roleEquips[i]:UpdateTwelveInfo()
    end
  end
end
function PackageEquipPage:HandleStrengthLvup(note)
  local roleEquips = self.roleEquips
  if not roleEquips then
    return
  end
  local data = note.body
  if not data or #data ~= 2 then
    return
  end
  local pos = data[1]
  local lv = data[2]
  if roleEquips[pos] then
    roleEquips[pos]:UpdateSiteStrengthenLv(lv)
  end
  self:UpdateEquip()
end
local t = SceneItem_pb.ESTRENGTHTYPE_NORMAL
function PackageEquipPage:HandleStrengthReInit()
  local roleEquips = self.roleEquips
  if not roleEquips then
    return
  end
  local _StrengthProxy = StrengthProxy.Instance
  for i = 1, EQUIP_MAXINDEX do
    if roleEquips[i] then
      local lv = _StrengthProxy:GetStrengthLvByPos(t, i)
      roleEquips[i]:UpdateSiteStrengthenLv(lv)
    end
  end
  self:UpdateEquip()
end
function PackageEquipPage:HandleTeamTwelveShutdown()
  if not self.roleEquips then
    return
  end
  local equipdata = BagProxy.Instance.roleEquip.siteMap
  for i = 1, EQUIP_MAXINDEX do
    if self.roleEquips[i] then
      self.roleEquips[i]:SetData(equipdata[i])
    end
  end
end
function PackageEquipPage:HandleFreeFireChanged()
  if not self.roleEquips then
    return
  end
  local isFreeFire = PvpProxy.Instance:IsFreeFire()
  local equipdata = BagProxy.Instance.roleEquip.siteMap
  for i = 1, EQUIP_MAXINDEX do
    local equip = self.roleEquips[i]
    if equip then
      equip:SetData(equipdata[i])
      if isFreeFire and TableUtil.HasValue(FullRefinePos, i) then
        equip:UpdateRefineLevelByPlayer()
      end
    end
  end
end
