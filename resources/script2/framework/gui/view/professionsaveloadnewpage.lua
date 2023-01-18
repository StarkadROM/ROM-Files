autoImport("SaveNewCell")
ProfessionSaveLoadNewPage = class("ProfessionSaveLoadNewPage", SubView)
local Prefab_Path = ResourcePathHelper.UIView("ProfessionSaveLoadNewPage")
function ProfessionSaveLoadNewPage:Init()
  self:LoadPrefab()
  self:FindObjs()
  ServiceNUserProxy.Instance:CallQueryProfessionDataDetailUserCmd(SaveInfoEnum.Record)
end
function ProfessionSaveLoadNewPage:LoadPrefab()
  local obj = self:LoadPreferb_ByFullPath(Prefab_Path, self.container, true)
  obj.name = "ProfessionSaveLoadNewPage"
  self.gameObject = obj
end
function ProfessionSaveLoadNewPage:FindObjs()
  self.recordList = self:FindGO("RecordList")
  self.listScrollView = self:FindComponent("ListScrollView", UIScrollView, self.recordList)
  self.saveGrid = self:FindComponent("saveGrid", UIGrid)
  self.saveCtl = UIGridListCtrl.new(self.saveGrid, SaveNewCell, "SaveNewCell")
  self.saveCtl:AddEventListener(MouseEvent.MouseClick, self.ClickItem, self)
  self.saveCtl:AddEventListener(MouseEvent.DoubleClick, self.DoubleClickItem, self)
  self.loadBtn = self:FindGO("loadBtn")
  self:AddClickEvent(self.loadBtn, function()
    self:OnLoadBtnClick()
  end)
  self.saveBtn = self:FindGO("saveBtn")
  self:AddClickEvent(self.saveBtn, function()
    self:OnSaveBtnClick()
  end)
  self.nilTip = self:FindGO("nilTip")
  local myselfData = Game.Myself.data
  if Game.Myself:IsDead() or myselfData:IsTransformed() or myselfData:IsInMagicMachine() or myselfData:IsOnWolf() or myselfData:GetBuffListByType("Transform") ~= nil or Game.Myself:IsInBooth() then
    self:SetTextureGrey(self.loadBtn)
    self:SetTextureGrey(self.saveBtn)
  end
end
function ProfessionSaveLoadNewPage:OnEnter()
  self:Show()
end
function ProfessionSaveLoadNewPage:OnExit()
  self:Hide()
  MultiProfessionSaveProxy.Instance:SetSavedRecordId(self.curSaveId)
end
function ProfessionSaveLoadNewPage:Show()
  self.container:UpdateNodeSwitch(1)
  self.gameObject:SetActive(true)
  self:SetPreview()
  self.container:OnProfessionSaveLoadPageShow()
end
function ProfessionSaveLoadNewPage:Hide()
  self.gameObject:SetActive(false)
  self:ShowModel()
  self.container:OnProfessionSaveLoadPageHide()
end
function ProfessionSaveLoadNewPage:SetData()
  self:SetSaveList()
  self:SetEquip()
end
function ProfessionSaveLoadNewPage:SetSaveList()
  local datas = {}
  local _slotdatas = MultiProfessionSaveProxy.Instance.slotDatas
  for i = 1, #_slotdatas do
    table.insert(datas, _slotdatas[i])
    if _slotdatas[i].status ~= 0 or _slotdatas[i].type ~= SceneUser2_pb.ESLOT_BUY then
    end
  end
  self.saveCtl:ResetDatas(datas)
  self.curSaveId = self.curSaveId or MultiProfessionSaveProxy.Instance:GetSavedRecordId()
  self:RefreshChoose()
  local cells = self.saveCtl:GetCells()
  local relative
  for i = 1, #cells do
    local cell = cells[i]
    if cell.id == self.curSaveId then
      local panel = self.listScrollView.panel
      local bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform, cell.gameObject.transform)
      local offset = panel:CalculateConstrainOffset(bound.min, bound.max)
      relative = LuaVector3(0, offset.y, 0)
      break
    end
  end
  if relative then
    self.listScrollView:MoveRelative(relative)
  end
end
function ProfessionSaveLoadNewPage:RefreshChoose()
  local childCells = self.saveCtl:GetCells()
  for i = 1, #childCells do
    local childCell = childCells[i]
    childCell:ShowChoose(self.curSaveId)
  end
end
function ProfessionSaveLoadNewPage:SetPreview()
  local saveData = MultiProfessionSaveProxy.Instance.recordDatas[self.curSaveId]
  local curSlotStatus = MultiProfessionSaveProxy.Instance:GetCurrentSlotStatus(self.curSaveId)
  if saveData == nil then
    self:ClearPreview()
    if curSlotStatus == 1 then
      self.saveBtn:SetActive(true)
    end
  else
    self:SetInfo()
    self.nilTip:SetActive(false)
    self.saveBtn:SetActive(false)
    self.container:SetSwitchNodeActive(true)
  end
end
function ProfessionSaveLoadNewPage:ClearPreview()
  self.nilTip:SetActive(true)
  self.saveBtn:SetActive(false)
  self.loadBtn:SetActive(false)
  self:HideModel()
  self:HideInfo()
  self.container:SetSwitchNodeActive(false)
end
function ProfessionSaveLoadNewPage:SetInfo()
  local userData = MultiProfessionSaveProxy.Instance:GetUserDataByID(self.curSaveId)
  self:SetRoleInfo()
  self:SetAttribute()
  self:SetModel(userData)
  self:SetProcess()
  self:SetEquip()
  self:ShowInfo()
  self:ShowModel()
end
function ProfessionSaveLoadNewPage:SetEquip()
  local saveData = MultiProfessionSaveProxy.Instance:GetUsersaveData(self.curSaveId)
  if saveData then
    local data = {
      showType = MPShowType.FromSave,
      userSaveInfoData = saveData
    }
    self.container:SetEquip(data)
  end
end
function ProfessionSaveLoadNewPage:SetModel(userData)
  local parts = Asset_Role.CreatePartArray()
  local _partIndex = Asset_Role.PartIndex
  local _partIndexEX = Asset_Role.PartIndexEx
  if userData then
    local hair = userData:Get(UDEnum.HAIR)
    parts[_partIndex.Body] = userData:Get(UDEnum.BODY) or 0
    parts[_partIndex.Hair] = hair or 0
    parts[_partIndex.Eye] = userData:Get(UDEnum.EYE) or 0
    parts[_partIndex.LeftWeapon] = 0
    parts[_partIndex.RightWeapon] = 0
    parts[_partIndex.Head] = userData:Get(UDEnum.HEAD) or 0
    parts[_partIndex.Wing] = userData:Get(UDEnum.BACK) or 0
    parts[_partIndex.Face] = userData:Get(UDEnum.FACE) or 0
    parts[_partIndex.Tail] = userData:Get(UDEnum.TAIL) or 0
    parts[_partIndex.Mount] = 0
    parts[_partIndex.Mouth] = userData:Get(UDEnum.MOUTH) or 0
    parts[_partIndexEX.Gender] = userData:Get(UDEnum.SEX) or 0
    parts[_partIndexEX.HairColorIndex] = userData:Get(UDEnum.HAIRCOLOR) or 0
    parts[_partIndexEX.BodyColorIndex] = userData:Get(UDEnum.CLOTHCOLOR) or 0
  end
  FunctionMultiProfession.Me():UpdateRoleModel(parts)
  self.container:ShowSwitchEffect()
  AudioUtility.PlayOneShot2D_Path(AudioMap.UI.ProfessionSwitch, AudioSourceType.UI)
  Asset_Role.DestroyPartArray(parts)
end
function ProfessionSaveLoadNewPage:SetProcess()
  local result = ReusableTable.CreateArray()
  local saveData = MultiProfessionSaveProxy.Instance:GetUsersaveData(self.curSaveId)
  local usedAstro = saveData and AstrolabeProxy.Instance:GetPoints_CostGoldMedalCount(saveData) or 0
  local totalAstro = GameConfig.Profession.maxAstro or 0
  local data = {
    order = 5,
    curValue = usedAstro,
    maxValue = totalAstro
  }
  data.clickFunc = self.OnAstroBtnClick
  data.owner = self
  data.funcParams = self.curSaveId
  result[5] = data
  local usedSkill = MultiProfessionSaveProxy.Instance:GetUsedPoints(self.curSaveId)
  local totalSkill = MultiProfessionSaveProxy.Instance:GetUnusedSkillPoint(self.curSaveId) + usedSkill
  data = {
    order = 1,
    curValue = usedSkill,
    maxValue = totalSkill
  }
  data.clickFunc = self.OnSkillBtnClick
  data.owner = self
  data.funcParams = self.curSaveId
  result[1] = data
  local skillGem = 0
  local attrGem = 0
  local maxSkillGem = GameConfig.Profession.maxSkillGem or 0
  local maxAttrGem = GameConfig.Profession.maxAttrGem or 0
  local gemData = MultiProfessionSaveProxy.Instance:GetGemData(self.curSaveId)
  local classid = MultiProfessionSaveProxy.Instance:GetProfession(self.curSaveId)
  if gemData and #gemData > 0 then
    for i = 1, #gemData do
      local single = gemData[i]
      if single.gemSkillData and single.gemSkillData.available then
        skillGem = skillGem + 1
      elseif single.gemAttrData then
        attrGem = attrGem + 1
      end
    end
  end
  if ProfessionProxy.IsHero(classid) then
    data = {
      order = 2,
      curValue = MultiProfessionSaveProxy.Instance:GetHeroFeatureLv(self.curSaveId) or 1,
      maxValue = maxSkillGem + 1
    }
    data.clickFunc = self.OnGemBtnClick
    data.owner = self
    data.funcParams = self.curSaveId
    result[2] = data
  else
    data = {
      order = 3,
      curValue = skillGem,
      maxValue = maxSkillGem
    }
    data.clickFunc = self.OnGemBtnClick
    data.owner = self
    data.funcParams = self.curSaveId
    result[3] = data
  end
  data = {
    order = 4,
    curValue = attrGem,
    maxValue = maxAttrGem
  }
  data.clickFunc = self.OnGemBtnClick
  data.owner = self
  data.funcParams = self.curSaveId
  result[4] = data
  local progress = PersonalArtifactProxy.Instance:GetPreviewProgress(SaveInfoEnum.Record, self.curSaveId)
  data = {
    order = 6,
    curValue = math.floor(progress * 100 + 0.5)
  }
  data.clickFunc = self.OnArtifactBtnClick
  data.owner = self
  data.funcParams = self.curSaveId
  result[6] = data
  local extractData = MultiProfessionSaveProxy.Instance:GetExtract(self.curSaveId)
  local activeCount = extractData and extractData:GetActiveCount() or 0
  local gridCount = GameConfig.EquipExtraction and GameConfig.EquipExtraction.GridCountDefault or 2
  data = {
    order = 7,
    curValue = activeCount,
    maxValue = gridCount
  }
  data.clickFunc = self.OnExtractBtnClick
  data.owner = self
  data.funcParams = self.curSaveId
  result[7] = data
  self.container:UpdateClassProcess(result)
  ReusableTable.DestroyAndClearArray(result)
end
function ProfessionSaveLoadNewPage:ShowModel()
  FunctionMultiProfession.Me():SetRoleModelActive(true)
end
function ProfessionSaveLoadNewPage:HideModel()
  FunctionMultiProfession.Me():SetRoleModelActive(false)
end
function ProfessionSaveLoadNewPage:SetRoleInfo()
  local lv = MultiProfessionSaveProxy.Instance:GetJobLevel(self.curSaveId)
  local classID = MultiProfessionSaveProxy.Instance:GetProfession(self.curSaveId)
  lv = ProfessionProxy.Instance:GetThisJobLevelForClient(classID, lv)
  self.container:UpdateCurClassBranch(classID, false, true, lv)
  local props = MultiProfessionSaveProxy.Instance:GetProps(self.curSaveId)
  if props then
    local result = {}
    for i = 1, #GameConfig.SavePreviewAttrMain do
      local single = GameConfig.SavePreviewAttrMain[i]
      local prop = props.mProps[single]
      if prop then
        local value = prop.value
        self.container:SetPolygonValue(i, value, false)
      end
    end
  end
  self.container:SetMaxJobTipActive(false)
end
function ProfessionSaveLoadNewPage:SetAttribute()
  local props = MultiProfessionSaveProxy.Instance:GetProps(self.curSaveId)
  self.container:SetProps(props)
end
function ProfessionSaveLoadNewPage:ShowInfo()
  local curNodeIndex = self.container.basePart.curSwitchNode
  if curNodeIndex == 1 then
    self.container:SwitchPageStatus(ProfessionPageBasePart.TweenGroup.Ymir)
    self.loadBtn:SetActive(true)
  elseif curNodeIndex == 2 then
    self.container:ShowEquip(true)
    self.loadBtn:SetActive(false)
  end
end
function ProfessionSaveLoadNewPage:HideInfo()
  local curNodeIndex = self.container.basePart.curSwitchNode
  if curNodeIndex == 1 then
    self.container:SwitchPageStatus(ProfessionPageBasePart.TweenGroup.YmirNoRecord)
  elseif curNodeIndex == 2 then
    self.container:ShowEquip(false)
  end
end
function ProfessionSaveLoadNewPage:ClickItem(cell)
  if cell and cell.id ~= self.curSaveId then
    if cell.data.status == 0 then
      if cell.data.type == SceneUser2_pb.ESLOT_MONTH_CARD then
        return
      else
        GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.PurchaseSaveSlotPopUp,
          viewdata = cell.data
        })
        return
      end
    end
    self.curSaveId = cell.id
    self:SetPreview()
    self:RefreshChoose()
  end
end
function ProfessionSaveLoadNewPage:DoubleClickItem(cell)
  if Game.Myself:IsDead() then
    MsgManager.ShowMsgByID(2500)
    return
  end
  if cell ~= nil and cell.data.status == 1 and cell.data.recordTime ~= 0 then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.ChangeSaveNamePopUp,
      viewdata = cell
    })
  else
    return
  end
end
function ProfessionSaveLoadNewPage:OnNodeSwitch(index)
  local saveData = MultiProfessionSaveProxy.Instance.recordDatas[self.curSaveId]
  self.loadBtn:SetActive(saveData and index == 1 or false)
end
function ProfessionSaveLoadNewPage:OnLoadBtnClick()
  if self.call_lock then
    return
  end
  local myselfData = Game.Myself.data
  if Game.Myself:IsDead() then
    MsgManager.ShowMsgByID(2500)
    return
  end
  if myselfData:IsTransformed() then
    MsgManager.ShowMsgByID(27009)
    return
  end
  if myselfData:IsInMagicMachine() then
    MsgManager.ShowMsgByID(27008)
    return
  end
  if myselfData:IsOnWolf() then
    MsgManager.ShowMsgByID(27007)
    return
  end
  if myselfData:GetBuffListByType("Transform") ~= nil then
    MsgManager.ShowMsgByID(27009)
    return
  end
  if Game.Myself:IsInBooth() then
    MsgManager.ShowMsgByID(25708)
    return
  end
  self:LockCall()
  local callRecord = function()
    ServiceNUserProxy.Instance:CallLoadRecordUserCmd(self.curSaveId)
  end
  local totalContri, totalGold = MultiProfessionSaveProxy.Instance:GetContribute(self.curSaveId), MultiProfessionSaveProxy.Instance:GetGoldMedal(self.curSaveId)
  AstrolabeProxy.ConfirmAstrolMaterialOnChange(totalContri, totalGold, function()
    if GemProxy.CheckIsGemDataDifferentFrom(MultiProfessionSaveProxy.Instance:GetGemData(self.curSaveId)) then
      MsgManager.ConfirmMsgByID(36011, callRecord)
    else
      callRecord()
    end
  end)
end
function ProfessionSaveLoadNewPage:OnSaveBtnClick()
  if self.call_lock then
    return
  end
  if Game.Myself:IsDead() then
    MsgManager.ShowMsgByID(2500)
    return
  end
  self:LockCall()
  local str = string.format(ZhString.MultiProfession_SaveName, self.curSaveId)
  ServiceNUserProxy:CallSaveRecordUserCmd(self.curSaveId, str)
end
function ProfessionSaveLoadNewPage:LockCall()
  if self.call_lock then
    return
  end
  self.call_lock = true
  if not self.lock_lt then
    self.lock_lt = TimeTickManager.Me():CreateOnceDelayTick(500, function(owner, deltaTime)
      self.lock_lt = nil
      self.call_lock = false
    end, self)
  end
end
function ProfessionSaveLoadNewPage:CancelLockCall()
  if not self.call_lock then
    return
  end
  self.call_lock = false
  if self.lock_lt then
    self.lock_lt:Destroy()
    self.lock_lt = nil
  end
end
function ProfessionSaveLoadNewPage:HandleRecvUpdateRecordInfoUserCmd(note)
  redlog("ProfessionSaveLoadNewPage:HandleRecvUpdateRecordInfoUserCmd")
  self:CancelLockCall()
  self:SetData()
  self:SetPreview()
end
function ProfessionSaveLoadNewPage:OnStatusChange()
  self:SetData()
end
function ProfessionSaveLoadNewPage:OnAstroBtnClick(param)
  if not MyselfProxy.Instance:IsUnlockAstrolabe() then
    MsgManager.ShowMsgByID(25432)
    return
  end
  local savedata = MultiProfessionSaveProxy.Instance.recordDatas[param]
  if savedata == nil then
    return
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.AstrolabeView,
    viewdata = {storageId = param}
  })
end
function ProfessionSaveLoadNewPage:OnSkillBtnClick(param)
  if GameConfig.SystemForbid.MultiProfession then
    MsgManager.ShowMsgByID(25413)
    return
  end
  local savedata = MultiProfessionSaveProxy.Instance.recordDatas[param]
  if savedata == nil then
    return
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.CharactorProfessSkill,
    viewdata = {
      saveId = param,
      saveType = SaveInfoEnum.Record,
      allowedSkillTip = {
        SkillTip.FuncTipType.SubSkillsReadOnly,
        SkillTip.FuncTipType.ItemCost
      }
    }
  })
end
function ProfessionSaveLoadNewPage:OnGemBtnClick(param)
  local savedata = MultiProfessionSaveProxy.Instance.recordDatas[param]
  if savedata == nil then
    return
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.GemEmbedPreview,
    viewdata = {
      saveId = param,
      saveType = SaveInfoEnum.Record
    }
  })
end
function ProfessionSaveLoadNewPage:OnArtifactBtnClick(param)
  local savedata = MultiProfessionSaveProxy.Instance.recordDatas[param]
  if savedata == nil then
    return
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.PersonalArtifactFunctionView,
    viewdata = {
      save_type = SaveInfoEnum.Record,
      save_id = param
    }
  })
end
function ProfessionSaveLoadNewPage:OnExtractBtnClick(param)
  local savedata = MultiProfessionSaveProxy.Instance.recordDatas[param]
  if savedata == nil then
    return
  end
  local extractData = MultiProfessionSaveProxy.Instance:GetExtract(param)
  local extractList = extractData and extractData:GetExtractData()
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.MagicBoxPanel,
    viewdata = {preview = true, slotdatas = extractList}
  })
end
