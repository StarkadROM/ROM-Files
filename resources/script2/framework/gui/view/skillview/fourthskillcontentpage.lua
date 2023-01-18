autoImport("SkillTip")
autoImport("FourthSkillCell")
autoImport("SkillItemData")
FourthSkillContentPage = class("FourthSkillContentPage", SkillBaseContentPage)
function FourthSkillContentPage:Init()
  self.sandTipOffset = {205, 0}
  self.skillDatas = {}
  self.skillCellMap = {}
  self.tipdata = {}
  self.usedMatItemMap = {}
  self:FindObjs()
  self:InitProfessSkill()
  self:AddViewListener()
  self:AddButtonEvts()
end
function FourthSkillContentPage:FindObjs()
  self.objBackGround = self:FindGO("FourthSkillBG", self:FindGO("Bg"))
  self.objBaseBG = self:FindGO("FourthSkillBaseBG", self.objBackGround)
  self.objMahoujin = self:FindGO("Mahoujin", self.objBackGround)
  self.objMahoujin:GetComponent(UIWidget).alpha = 0
  self.texProfession = self:FindComponent("texProfession", UITexture, self.objMahoujin)
  self.sprHalo = self:FindComponent("Halo", UISprite, self.objMahoujin)
  self.gameObject = self:FindGO("FourthSkillContentPage", self:FindGO("SkillPages"))
  self.objRoot = self:FindGO("ContentRoot")
  self.objLeftTopInfo = self:FindGO("Left", self:FindGO("Up", self.objRoot))
  self.labProfessName = self:FindComponent("ProfessName", UILabel, self.objLeftTopInfo)
  self.sprProfessIcon = self:FindComponent("ProfessIcon", UISprite, self.objLeftTopInfo)
  self.sprProfessColor = self:FindComponent("ProfessionColor", UISprite, self.objLeftTopInfo)
  self.fourthSkillPoints = self:FindGO("FourthSkilPoints", self.objLeftTopInfo)
  self.sprFourthSkillPointIcon = self:FindComponent("sprFourthSkillPointIcon", UISprite, self.objLeftTopInfo)
  self.labFourthSkillPoints = self:FindComponent("labFourthSkillPoints", UILabel, self.objLeftTopInfo)
  self.objBreakPoints = self:FindGO("BreakPoints", self.objLeftTopInfo)
  self.sprBreakPointIcon = self:FindComponent("sprBreakPointIcon", UISprite, self.objBreakPoints)
  self.labBreakPoints = self:FindComponent("labBreakPoints", UILabel, self.objBreakPoints)
  self.sprExchangeSkillPointBtn = self:FindComponent("ExchangeSkillPointBtn", UISprite, self.objLeftTopInfo)
  self.sprExchangeSkillPointBtn.gameObject:SetActive(false)
  self.objRightButtons = self:FindGO("RightBtns", self.objRoot)
  self.objBtnConfirm = self:FindGO("FourthSkillConfirmBtn", self.objRightButtons)
  self.objBtnCancel = self:FindGO("FourthSkillCancelBtn", self.objRightButtons)
  self.objLeftButtons = self:FindGO("FourthSkill", self:FindGO("LeftBtns", self.objRoot))
  self.objSkillResetBtn = self:FindGO("FourthSkillResetBtn", self.objLeftButtons)
  self.objBtnSize = self:FindGO("FourthSkillSizeBtn", self.objLeftButtons)
  self.sprBtnSizeIcon = self:FindComponent("Icon", UIMultiSprite, self.objBtnSize)
  self.objScrollArea = self:FindGO("FourthSkillArea", self:FindGO("ScrollArea", self.objRoot))
  self.objContents = self:FindGO("Contents", self.objRoot)
  self.objSkillContainer = self:FindGO("FourthSkillContainer", self.objContents)
  self.contentPanel = self:FindComponent("FourthSkillContent", UIPanel, self.objContents)
  self.contentScroll = self.contentPanel.gameObject:GetComponent(ScrollViewWithProgress)
  self.emptyTip = self:FindGO("FourthSkillEmptyTip", self.objContents)
  self.objBtnShowAllMaxTip = self:FindGO("AllMaxTipBtn", self.objRightButtons)
  self.objAllMaxTip = self:FindGO("AllMaxTip", self.objRightButtons)
  local l_labTip = self:FindComponent("labAllMaxRewardTip", UILabel, self.objAllMaxTip)
  l_labTip.text = string.format(ZhString.SkillView_FourthSkillFullRewardTip, GameConfig.SkillFourth and GameConfig.SkillFourth.SkillFullRewardPoint or 300)
  self.csClickOtherPlace_AllMaxTip = self.objAllMaxTip:GetComponent(CallBackWhenClickOtherPlace)
  function self.csClickOtherPlace_AllMaxTip.call()
    self:ShowAllMaxTip(false)
  end
end
function FourthSkillContentPage:InitProfessSkill()
  self.professList = ListCtrl.new(self.objSkillContainer, FourthSkillCell, "FourthSkillCell")
  self.professList:AddEventListener(MouseEvent.MouseClick, self.ShowTipHandler, self)
  self.professList:AddEventListener(SkillCell.SimulationUpgrade, self.SimulationUpgradeHandler, self)
  self.professList:AddEventListener(SkillCell.SimulationDowngrade, self.SimulationDowngradeHandler, self)
  self.professList:AddEventListener(FourthSkillCell.ClickFourthBreak, self.FourthBreakHandler, self)
end
function FourthSkillContentPage:AddViewListener()
  self:AddListenEvt(SkillEvent.SkillUpdate, self.HandleSkillUpdate)
  self:AddListenEvt(MyselfEvent.MyDataChange, self.HandleMyDataChange)
end
function FourthSkillContentPage:AddButtonEvts()
  self:AddClickEvent(self.objBtnCancel, function()
    self:ClearSimulate()
  end)
  self:AddClickEvent(self.objBtnConfirm, function()
    local skillIDs = ReusableTable.CreateArray()
    local cells = self.professList:GetCells()
    local id
    for i = 1, #cells do
      id = cells[i]:TryGetSimulateSkillID()
      if id then
        skillIDs[#skillIDs + 1] = id
      end
    end
    self.forbidMyDataChange = true
    self.container:CheckNeedShowOverFlow(skillIDs)
    ServiceSkillProxy.Instance:CallLevelupSkill(SceneSkill_pb.ELEVELUPTYPE_FOURTH, skillIDs)
    ReusableTable.DestroyAndClearArray(skillIDs)
  end)
  self:AddClickEvent(self.objSkillResetBtn, function()
    local sb = LuaStringBuilder.CreateAsTable()
    local costItem = GameConfig.SkillFourth and GameConfig.SkillFourth.ResetCost
    if costItem then
      local itemData
      for index, costData in pairs(costItem) do
        if sb:GetCount() > 0 then
          sb:Append(ZhString.ItemTip_ChAnd)
        end
        sb:Append(costData[2] or "???")
        itemData = Table_Item[costData[1]]
        sb:Append(itemData and itemData.NameZh or "???")
      end
    end
    MsgManager.ConfirmMsgByID(40724, function()
      if costItem then
        for index, costData in pairs(costItem) do
          if HappyShopProxy.Instance:GetItemNum(costData[1]) < (costData[2] or 0) then
            local itemData = Table_Item[costData[1]]
            MsgManager.ShowMsgByID(40914, itemData and itemData.NameZh or "???")
            return
          end
        end
      end
      ServiceSkillProxy.Instance:CallResetSkill(SceneSkill_pb.ERESETSKILLTYPE_FOURTH)
    end, nil, nil, sb:ToString())
    sb:Destroy()
  end)
  self:AddClickEvent(self.objBtnSize, function()
    self:ChangeShowScale(not self.isShowSmall)
  end)
  self:AddClickEvent(self.sprExchangeSkillPointBtn.gameObject, function()
    if TipsView.Me():IsCurrentTip(TechTreeSandExchangeTip) then
      TipsView.Me():HideCurrent()
      return
    end
    if not TipManager.ShowSandExchangeTip then
      return
    end
    if self.container.multiSaveId then
      self.gainWayTip = GainWayTip.new(self.fourthSkillPoints, self.contentPanel.depth + 1)
      self.gainWayTip:SetData(GameConfig.MoneyId and GameConfig.MoneyId.FourthSkillSand or 12903)
      self.gainWayTip:SetPivotOffset(82)
      self.gainWayTip:AddEventListener(ItemEvent.GoTraceItem, function()
        self.gainWayTip:OnExit()
      end, self)
      self.gainWayTip:AddEventListener(GainWayTip.CloseGainWay, function()
        self.gainWayTip = nil
      end, self)
    else
      TipManager.Instance:ShowSandExchangeTip(self.sprExchangeSkillPointBtn, NGUIUtil.AnchorSide.Rig0ht, self.sandTipOffset)
    end
  end)
  self:AddClickEvent(self.objBtnShowAllMaxTip, function()
    self:ShowAllMaxTip(true)
  end)
  self:AddClickEvent(self.sprFourthSkillPointIcon.gameObject, function()
    self:HandleClickCostMat(self.sprFourthSkillPointIcon, self.fourthSkillSandItemData)
  end)
  self:AddClickEvent(self.sprBreakPointIcon.gameObject, function()
    self:HandleClickCostMat(self.sprBreakPointIcon, self.skillBookItemData)
  end)
end
function FourthSkillContentPage:HandleClickCostMat(widget, data)
  local tipdata = ReusableTable.CreateTable()
  tipdata.itemdata = data
  tipdata.funcConfig = {}
  TipManager.Instance:ShowItemFloatTip(tipdata, widget, NGUIUtil.AnchorSide.Right, {220, 0})
  ReusableTable.DestroyAndClearTable(tipdata)
end
function FourthSkillContentPage:OnEnter()
  FourthSkillContentPage.super.OnEnter(self)
  self.inited = false
  self:ChangeShowScale(true, true)
  local fourthSkillSandId = GameConfig.MoneyId and GameConfig.MoneyId.FourthSkillSand or 12903
  self.fourthSkillSandItemData = ItemData.new("fourthSkillSandId", fourthSkillSandId)
  local staticData = Table_Item[fourthSkillSandId]
  if not staticData or not IconManager:SetItemIcon(staticData.Icon, self.sprFourthSkillPointIcon) then
    IconManager:SetItemIcon("item_45001", self.sprFourthSkillPointIcon)
  end
  local skillBookID = GameConfig.SkillFourth and GameConfig.SkillFourth.SkillBookID or 6700
  self.skillBookItemData = ItemData.new("skillBook", skillBookID)
  staticData = Table_Item[skillBookID]
  if not staticData or not IconManager:SetItemIcon(staticData.Icon, self.sprBreakPointIcon) then
    IconManager:SetItemIcon("item_45001", self.sprBreakPointIcon)
  end
  self.effectFrag = self:PlayUIEffect(EffectMap.UI.Eff_SkillView_Fragment, self:FindGO("effRoot_Fragment", self.objMahoujin))
  self.effectFrag:RegisterWeakObserver(self)
  self.effectFrag:SetActive(false)
  self.isLockFunctions = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.allowedSkillTip
  if self.isLockFunctions then
    self.objSkillResetBtn:SetActive(false)
  end
  self.sprExchangeSkillPointBtn.gameObject:SetActive(FunctionUnLockFunc.Me():CheckCanOpen(10002) == true)
  self.isBreakValid = FunctionUnLockFunc.checkFuncStateValid(113) == true
  self.objBreakPoints:SetActive(self.isBreakValid)
  self.objBtnShowAllMaxTip:SetActive(self.isBreakValid)
  self:ShowAllMaxTip(false, true)
end
function FourthSkillContentPage:OnExit()
  if self.curProTexName then
    PictureManager.Instance:UnLoadProfession(self.curProTexName, self.texProfession)
    self.curProTexName = nil
  end
  if self.effectFrag and self.effectFrag:Alive() then
    self.effectFrag:Destroy()
  end
  self:ShowAllMaxTip(false, true)
  FourthSkillContentPage.super.OnExit(self)
end
function FourthSkillContentPage:ObserverDestroyed(obj)
  if obj == self.effectFrag then
    self.effectFrag = nil
  end
end
function FourthSkillContentPage:ShowTipHandler(cell)
  self:_ShowTip(cell, SkillTip, "SkillTip")
end
function FourthSkillContentPage:_ShowTip(cell, tipCtrl, tipView)
  local camera = NGUITools.FindCameraForLayer(cell.gameObject.layer)
  if camera then
    local viewPos = camera:WorldToViewportPoint(cell.gameObject.transform.position)
    self.tipdata.data = cell:GetSimulateSkillItemData()
    TipsView.Me():ShowTip(tipCtrl, self.tipdata, tipView)
    local tip = TipsView.Me().currentTip
    if tip then
      tip:SetCheckClick(self:TipClickCheck())
      tip.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(self.contentPanel.width / 4 * (viewPos.x <= 0.5 and 1 or -1), 0, 0)
      local itemCostCells = tip:GetItemCostCells()
      if itemCostCells then
        for i = 1, #itemCostCells do
          itemCostCells[i]:ResetUsableItemNum(self:GetUsableItemNumByID(itemCostCells[i].id, itemCostCells[i].currentItemNum))
        end
      end
    end
  end
end
function FourthSkillContentPage:TipClickCheck()
  if self.tipCheck == nil then
    function self.tipCheck()
      local click = UICamera.selectedObject
      if not click then
        return false
      end
      local cells = self.professList:GetCells()
      for i = 1, #cells do
        if cells[i]:IsClickMe(click) then
          return true
        end
      end
      return false
    end
  end
  return self.tipCheck
end
function FourthSkillContentPage:SimulationUpgradeHandler(cell)
  local nextSkillStaticData = cell:GetNextSkillStaticData()
  local costItem = nextSkillStaticData and nextSkillStaticData.ItemCost
  if costItem then
    for index, costData in pairs(costItem) do
      if self:GetUsableItemNumByID(costData.id) < costData.count then
        return
      end
    end
  end
  if not cell:IsFitNextJobLevel(MyselfProxy.Instance:JobLevel()) then
    return
  end
  if not cell:TrySimulateUpgrade() then
    return
  end
  self:SetEditMode(true)
  if costItem then
    for index, costData in pairs(costItem) do
      self.usedMatItemMap[costData.id] = (self.usedMatItemMap[costData.id] or 0) + costData.count
    end
  end
  self:RefreshFourthSkillMaterialItems()
end
function FourthSkillContentPage:SimulationDowngradeHandler(cell)
  local curSortID = cell.data.sortID
  local staticData = cell:GetSimulateStaticData()
  if not staticData then
    LogUtility.Error("Cannot Find Skill StaticData!")
    return
  end
  local skillCells = self.professList:GetCells()
  local singleSkillCell
  for i = 1, #skillCells do
    singleSkillCell = skillCells[i]
    if singleSkillCell.data.requiredSkillID == staticData.id and singleSkillCell:GetSimulateLevel() > 0 then
      MsgManager.ShowMsgByID(607, singleSkillCell.data.staticData.NameZh)
      return
    end
  end
  if not cell:TrySimulateDowngrade() then
    return
  end
  local haveChange = false
  for i = 1, #skillCells do
    if skillCells[i]:IsChanged() then
      haveChange = true
      break
    end
  end
  local costItem = staticData.ItemCost
  if costItem then
    for index, costData in pairs(costItem) do
      self.usedMatItemMap[costData.id] = math.max((self.usedMatItemMap[costData.id] or 0) - costData.count, 0)
    end
  end
  if not haveChange then
    self:SetEditMode(false)
  end
  self:RefreshFourthSkillMaterialItems()
end
function FourthSkillContentPage:FourthBreakHandler(cell)
  local id = cell.data.id
  if LocalSaveProxy.Instance:GetDontShowAgain(40923) then
    self:ConfirmFourthSkillBreak(id)
    return
  end
  MsgManager.DontAgainConfirmMsgByID(40923, function()
    self:ConfirmFourthSkillBreak(id)
  end)
end
function FourthSkillContentPage:ConfirmFourthSkillBreak(id)
  local skillIDs = ReusableTable.CreateArray()
  skillIDs[#skillIDs + 1] = id
  ServiceSkillProxy.Instance:CallLevelupSkill(SceneSkill_pb.ELEVELUPTYPE_BREAK_LIMIT, skillIDs)
  ReusableTable.DestroyAndClearArray(skillIDs)
end
function FourthSkillContentPage:SetProfessSkills(needLayout)
  TableUtility.TableClear(self.usedMatItemMap)
  TableUtility.TableClear(self.skillDatas)
  local myProfess = SkillProxy.Instance:GetMyProfession()
  local staticData = Table_Class[myProfess]
  if staticData then
    IconManager:SetNewProfessionIcon(staticData.icon, self.sprProfessIcon)
    self.labProfessName.text = ProfessionProxy.GetProfessionName(myProfess, MyselfProxy.Instance:GetMySex())
  end
  local professTree = ProfessionProxy.Instance:GetProfessionTreeByClassId(myProfess)
  local myFourthClassID
  if professTree then
    local p = professTree.transferRoot
    local config = GameConfig.SkillFourth and GameConfig.SkillFourth.ProfessTexID
    self.curProTexName = "profession_" .. (config and config[p.id] or p.id)
    PictureManager.Instance:SetProfession(self.curProTexName, self.texProfession)
    config = GameConfig.SkillFourth and GameConfig.SkillFourth.ProfessColor
    local configColor = config[p.id]
    if not configColor then
      LogUtility.Error("Cannot Find Color Config in GameConfig.SkillFourth.ProfessColor, id is " .. p.id)
    end
    self.sprHalo.color = LuaGeometry.GetTempColorByHtml(configColor or "#C0EC29")
    self.sprProfessColor.color = ProfessionProxy.Instance:SafeGetColorFromColorUtil("CareerIconBg" .. staticData.Type)
    local typeBranch = staticData.TypeBranch
    while p ~= nil do
      if p.depth == 5 then
        myFourthClassID = p.id
        break
      end
      p = p:GetNextByBranch(typeBranch)
    end
  end
  if myFourthClassID then
    local ps = SkillProxy.Instance:FindProfessSkill(myFourthClassID, true)
    TableUtil.InsertArray(self.skillDatas, ps.skills)
    self.objBtnShowAllMaxTip:SetActive(self.isBreakValid == true and not SkillProxy.Instance:HaveAlreadyGetFourthSkillFullAward())
    self.professList:ResetDatas(self.skillDatas, true, false)
    if needLayout then
      self:LayOutProfessSkills()
    end
  else
    self.professList:ResetDatas(self.skillDatas, true, false)
    self.objBtnShowAllMaxTip:SetActive(false)
  end
  self.emptyTip:SetActive(#self.skillDatas == 0)
  self:RefreshFourthSkillMaterialItems(true)
  self:RefreshFourthSkillBreakPoints()
end
function FourthSkillContentPage:LayOutProfessSkills()
  TableUtility.TableClear(self.skillCellMap)
  self.contentPanel:ResetAndUpdateAnchors()
  local cellWidth = self.contentPanel.width / (GameConfig.SkillFourth and GameConfig.SkillFourth.MaxGridX or 12)
  local cellHeight = self.contentPanel.height / (GameConfig.SkillFourth and GameConfig.SkillFourth.MaxGridY or 6)
  local cells = self.professList:GetCells()
  local cell, x, y
  local requiringCells = ReusableTable.CreateArray()
  for i = 1, #cells do
    cell = cells[i]
    self.skillCellMap[cell.data.sortID] = cell
    if cell.data.requiredSkillID then
      requiringCells[#requiringCells + 1] = cell
    end
    cell:RemoveLink()
    cell:ResetLink()
    x, y = cell:GetGridXY()
    cell:SetLocalPosition(cellWidth * x, -y * cellHeight)
  end
  local requiredSkill
  for i = 1, #requiringCells do
    cell = requiringCells[i]
    requiredSkill = self.skillCellMap[math.floor(cell.data.requiredSkillID / 1000)]
    if requiredSkill then
      requiredSkill:DrawLink(cell)
      if self.container.multiSaveId ~= nil then
        requiredSkill:LinkUnlock(cell.data.sortID, requiredSkill.data.id >= cell.data.requiredSkillID and requiredSkill.data.learned)
      end
    end
  end
  ReusableTable.DestroyAndClearArray(requiringCells)
  self.contentScroll:ResetPosition()
end
function FourthSkillContentPage:RefreshSkillsStatus()
  local myJobLevel = MyselfProxy.Instance:JobLevel()
  local cells = self.professList:GetCells()
  local showBreak = not self.isEditMode and not self.isLockFunctions and self:GetFourthSkillBrankPoints() > 0
  local singleSkillCell, singleSkillData, requiredSkillCell, fitJob, fitRequiredSkill, hasMatItem
  for i = 1, #cells do
    singleSkillCell = cells[i]
    singleSkillData = singleSkillCell.data
    fitJob = singleSkillCell:IsFitNextJobLevel(myJobLevel)
    requiredSkillCell = nil
    fitRequiredSkill = true
    hasMatItem = true
    if singleSkillData.requiredSkillID then
      requiredSkillCell = self.skillCellMap[math.floor(singleSkillData.requiredSkillID / 1000)]
      fitRequiredSkill = requiredSkillCell and requiredSkillCell.simulateID and requiredSkillCell.simulateID >= singleSkillData.requiredSkillID and 0 < requiredSkillCell:GetSimulateLevel()
    end
    local nextSkillStaticData = singleSkillCell:GetNextSkillStaticData()
    local costItem = nextSkillStaticData and nextSkillStaticData.ItemCost
    if costItem then
      for index, costData in pairs(costItem) do
        if self:GetUsableItemNumByID(costData.id) < costData.count then
          hasMatItem = false
          break
        end
      end
    end
    singleSkillCell:SetCellEnable(fitJob and fitRequiredSkill and hasMatItem and not self.container.multiSaveId, not self.container.multiSaveId)
    singleSkillCell:ShowBreakButton(showBreak)
    if requiredSkillCell then
      requiredSkillCell:LinkUnlock(singleSkillCell.data.sortID, fitRequiredSkill)
    end
    if self.container.multiSaveId then
      singleSkillCell:SetDragEnable(false)
    end
  end
end
function FourthSkillContentPage:GetUsableItemNumByID(id, baseNum)
  if not id then
    return 0
  end
  return math.max((baseNum or HappyShopProxy.Instance:GetItemNum(id)) - (self.usedMatItemMap[id] or 0), 0)
end
function FourthSkillContentPage:RefreshFourthSkillMaterialItems(forceRefreshStatus)
  local lastNumTxt = self.labFourthSkillPoints.text
  self.labFourthSkillPoints.text = self:GetUsableItemNumByID(GameConfig.MoneyId and GameConfig.MoneyId.FourthSkillSand or 12903)
  if self.labFourthSkillPoints.text ~= lastNumTxt or forceRefreshStatus then
    self:RefreshSkillsStatus()
  end
end
function FourthSkillContentPage:GetFourthSkillBrankPoints()
  return HappyShopProxy.Instance:GetItemNumByStaticID(GameConfig.SkillFourth and GameConfig.SkillFourth.SkillBookID)
end
function FourthSkillContentPage:RefreshFourthSkillBreakPoints()
  self.labBreakPoints.text = self:GetFourthSkillBrankPoints()
end
function FourthSkillContentPage:HandleMyDataChange(note)
  local data = note.body
  if not data then
    return
  end
  local sandType = ProtoCommon_pb.EUSERDATATYPE_SAND
  local breakPointType = ProtoCommon_pb.EUSERDATATYPE_BREAK_POINT
  for i = 1, #data do
    if data[i].type == sandType then
      if not self.forbidMyDataChange then
        self:RefreshFourthSkillMaterialItems()
      end
    elseif data[i].type == breakPointType then
      self:RefreshFourthSkillBreakPoints()
    end
  end
end
function FourthSkillContentPage:ChangeShowScale(isSmall, immediate)
  if self.isShowSmall == isSmall then
    return
  end
  self.isShowSmall = isSmall
  self.sprBtnSizeIcon.CurrentState = self.isShowSmall and 0 or 1
  local scale = self.isShowSmall and 0.5 or 1
  local tarVecScale = LuaGeometry.GetTempVector3(scale, scale, 1)
  if immediate then
    self.objSkillContainer.transform.localScale = tarVecScale
    self.contentScroll:ResetPosition()
  else
    local tweener = TweenScale.Begin(self.objSkillContainer, 0.2, tarVecScale)
    tweener:SetOnFinished(function()
      self.contentScroll:ResetPosition()
    end)
  end
end
function FourthSkillContentPage:SetEditMode(val)
  if self.isEditMode ~= val then
    self.isEditMode = val
    if val then
      self:Show(self.objBtnConfirm)
      self:Show(self.objBtnCancel)
      self:Hide(self.objSkillResetBtn)
    else
      self:Hide(self.objBtnConfirm)
      self:Hide(self.objBtnCancel)
      if not self.isLockFunctions then
        self:Show(self.objSkillResetBtn)
      end
    end
  end
end
function FourthSkillContentPage:HandleSkillUpdate()
  self:ClearSimulate(false)
end
function FourthSkillContentPage:ClearSimulate(needLayout)
  self.forbidMyDataChange = false
  TableUtility.TableClear(self.usedMatItemMap)
  self:SetEditMode(false)
  self:SetProfessSkills(needLayout)
end
function FourthSkillContentPage:ConfirmEditMode(toDo, owner, param)
  if self.isEditMode then
    MsgManager.ConfirmMsgByID(602, function()
      self:ClearSimulate()
      toDo(owner, param)
    end)
  else
    toDo(owner, param)
  end
end
function FourthSkillContentPage:IsEditMode()
  return self.isEditMode
end
function FourthSkillContentPage:OnSwitch(val)
  if val and not self.inited then
    self:ClearSimulate(true)
  end
  self.objRoot:SetActive(val == true)
  self.objBaseBG:SetActive(val == true)
  if self.effectFrag then
    self.effectFrag:SetActive(val == true)
  end
  self:ShowAllMaxTip(false, true)
  if val then
    TweenAlpha.Begin(self.objMahoujin, 0.5, 1)
    if not self.inited then
      self.contentScroll:ResetPosition()
      self.inited = true
    end
  else
    TweenAlpha.Begin(self.objMahoujin, 0, 0)
  end
end
function FourthSkillContentPage:ShowAllMaxTip(isShow, immediate)
  if self.isShowAllMaxTip == isShow then
    return
  end
  self.csClickOtherPlace_AllMaxTip.enabled = isShow == true
  TweenAlpha.Begin(self.objAllMaxTip, immediate and 0 or 0.3, isShow and 1 or 0)
end
function FourthSkillContentPage:OnDestroy()
  self.professList:Destroy()
  FourthSkillContentPage.super.OnDestroy(self)
end
