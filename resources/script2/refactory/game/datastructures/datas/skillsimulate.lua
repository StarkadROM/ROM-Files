SkillSimulate = class("SkillSimulate")
SkillSimulate.HasNoModifiedSkills = "SkillSimulate.HasNoModifiedSkills"
function SkillSimulate:ctor(skillItemDatas, usedPoints, leftPoints)
  self.skillList = {}
  self:Reset()
  self:ResetDatas(skillItemDatas, usedPoints, leftPoints)
end
function SkillSimulate:Reset()
  self.inited = false
  self:SetEditMode(false)
  self.simulateSkills = {}
  self.modifiedSkillBySort = {}
end
function SkillSimulate:SetEditMode(v)
  self.isEditMode = v
end
function SkillSimulate:GetModifiedSkills()
  TableUtility.TableClear(self.skillList)
  return TableUtil.HashToArray(self.modifiedSkillBySort, self.skillList)
end
function SkillSimulate:ResetDatas(skillItemDatas, usedPoints, leftPoints)
  self.usedPoints = usedPoints
  self.leftPoints = leftPoints
  self.source_usedPoints = usedPoints
  self.source_leftPoints = leftPoints
  if skillItemDatas then
    local cacheSkill
    for i = 1, #skillItemDatas do
      skill = skillItemDatas[i]
      cacheSkill = self.simulateSkills[skill.sortID]
      if cacheSkill == nil then
        cacheSkill = SkillSimulateData.new(skill)
        self.simulateSkills[skill.sortID] = cacheSkill
      else
        cacheSkill:ResetSource(skill)
      end
    end
    if not self.inited then
      self:ResetSkillLinks()
    end
    self.inited = true
  end
end
function SkillSimulate:ResetSkillLinks()
  local sortID, requiredSkill
  for k, skill in pairs(self.simulateSkills) do
    if skill.sourceSkill.requiredSkillID then
      sortID = math.floor(skill.sourceSkill.requiredSkillID / 1000)
      requiredSkill = self.simulateSkills[sortID]
      if requiredSkill then
        requiredSkill:SetUnlockSimulate(skill, skill.sourceSkill.requiredSkillID)
        skill:SetRequiredSimulate(requiredSkill)
      end
    end
    if skill.sourceSkill.requiredSkills then
      local requiredSkills = skill.sourceSkill.requiredSkills
      for i = 1, #requiredSkills do
        requiredSkillID = requiredSkills[i]
        sortID = math.floor(requiredSkillID / 1000)
        requiredSkill = self.simulateSkillID[sortID]
        if requiredSkill then
          requiredSkill:SetUnlockSimulate(skill, skill.sourceSkill.requiredSkillID)
          skill:AddMultiRequirements(requiredSkill)
        end
      end
    end
  end
end
function SkillSimulate:ExtraCheckFunc(func, funcParam)
  self.extraCheckFunc = func
  self.extraCheckFuncParam = funcParam
end
function SkillSimulate:RollBack()
  for k, sskill in pairs(self.simulateSkills) do
    sskill:Reset()
  end
  self:SetEditMode(false)
  self.modifiedSkillBySort = {}
  self.usedPoints = self.source_usedPoints
  self.leftPoints = self.source_leftPoints
end
function SkillSimulate:UpgradeSkillBySortID(sortID)
  local simulateData = self.simulateSkills[sortID]
  local changed, delta = simulateData:Upgrade()
  if changed then
    self:RefreshProfessPoints(delta, true)
  end
  return changed, delta
end
function SkillSimulate:DowngradeSkillBySortID(sortID, level)
  local simulateData = self.simulateSkills[sortID]
  local changed, delta = simulateData:Downgrade(level)
  if changed then
    self:RefreshProfessPoints(delta, true)
  end
  return changed, delta
end
function SkillSimulate:RefreshProfessPoints(delta, recursive)
  self.usedPoints = self.usedPoints + delta
  self.leftPoints = self.leftPoints - delta
end
function SkillSimulate:GetSimulateSkill(sortID)
  return self.simulateSkills[sortID]
end
function SkillSimulate:HasPreviousSimulateSkillData(sortID)
  local skill = self.simulateSkills[sortID]
  if skill then
    return skill:HasPreviousLevel()
  end
  return false
end
function SkillSimulate:HasModifiedSkill()
  for k, v in pairs(self.modifiedSkillBySort) do
    return true
  end
  return false
end
function SkillSimulate:Upgrade(cell, cells)
  local simulate = self:GetSimulateSkill(cell.data.sortID)
  local fitCost = simulate:FitNextSkillPointCost(self.leftPoints)
  if fitCost then
    local myJobLevel = MyselfProxy.Instance:JobLevel()
    local fitJobLv, needJobLv = simulate:FitNextJobLevel(myJobLevel)
    if fitJobLv then
      local upgradeSuccess, points = self:UpgradeSkillBySortID(cell.data.sortID)
      if upgradeSuccess then
        cell:ShowDowngrade(true)
        self:UpdateLevel(cell, simulate)
        self.modifiedSkillBySort[simulate.sortID] = simulate.id
      end
      self:CheckCellState(cell, simulate)
      self:ScallAllDatas(cells)
      self:SetEditMode(true)
      return true
    else
      MsgManager.ShowMsgByIDTable(603, {
        ProfessionProxy.GetProfessionName(simulate.profession, MyselfProxy.Instance:GetMySex()),
        Occupation.GetFixedJobLevel(needJobLv, simulate.profession)
      })
    end
  else
    MsgManager.ShowMsgByIDTable(604)
  end
  return false
end
function SkillSimulate:Downgrade(cell, cells)
  local simulate = self:GetSimulateSkill(cell.data.sortID)
  if simulate.unlockSimulateData and simulate.unlockSimulateData.learned then
    if simulate.id == simulate.unlockSimulateData.sourceSkill.requiredSkillID then
      MsgManager.ShowMsgByIDTable(607, {
        simulate.unlockSimulateData.data.staticData.NameZh
      })
      return false
    end
    local requiredSkills = simulate.unlockSimulateData.sourceSkill.requiredSkills
    if requiredSkills and next(requiredSkills) then
      for i = 1, #requiredSkills do
        if requiredSkills[i] // 1000 == simulate.id // 1000 and requiredSkills[i] >= simulate.id then
          MsgManager.ShowMsgByIDTable(607, {
            simulate.unlockSimulateData.data.staticData.NameZh
          })
          return false
        end
      end
    end
  end
  local downgradeSuccess, points = self:DowngradeSkillBySortID(cell.data.sortID)
  if downgradeSuccess then
    self.modifiedSkillBySort[simulate.sortID] = simulate.id
  end
  self:UpdateLevel(cell, simulate)
  if not self:HasPreviousSimulateSkillData(cell.data.sortID) then
    self.modifiedSkillBySort[simulate.sortID] = nil
    cell:ShowDowngrade(false)
  end
  self:CheckCellState(cell, simulate)
  self:ScallAllDatas(cells)
  if self:HasModifiedSkill() == false then
    self:SetEditMode(false)
    GameFacade.Instance:sendNotification(SkillSimulate.HasNoModifiedSkills)
  end
  return true
end
function SkillSimulate:UpdateLevel(cell, simulate)
  if simulate.id ~= simulate.sourceSkill.id or simulate.learned ~= simulate.sourceSkill.learned then
    cell:SetLevel(Table_Skill[simulate.id].Level, "54B30A")
    cell:SetDragEnable(true)
  elseif simulate.learned then
    cell:SetDragEnable(true)
    cell:SetLevel(Table_Skill[simulate.id].Level)
  else
    cell:SetDragEnable(false)
    cell:SetLevel(0)
  end
end
function SkillSimulate:CheckCellState(cell, simulate)
  simulate = simulate or self:GetSimulateSkill(cell.data.sortID)
  cell:EnableGray(not simulate.data.learned)
end
function SkillSimulate:GetSimulateSkillItemData(sortID, autoCreate)
  if autoCreate == nil then
    autoCreate = true
  end
  local simulateData = self.simulateSkills[sortID]
  if simulateData then
    local data = simulateData.data
    if data == nil and autoCreate then
      simulateData.data = SkillItemData.new(simulateData.id, 0, 0, 0, 0)
      data = simulateData.data
      data.learned = simulateData.sourceSkill.learned
    elseif data.id ~= simulateData.id then
      data:Reset(simulateData.id, 0, 0, 0, 0)
    end
    return data
  end
  return nil
end
function SkillSimulate:ScallAllDatas(cells)
  local cell
  local skillCells = {}
  for i = 1, #cells do
    cell = cells[i]
    skillCells[cell.data.sortID] = cell
  end
  local myJobLevel = MyselfProxy.Instance:JobLevel()
  local fitJob, fitRequiredSkill, hasPoint, extraCheck, fitRequiredSkills
  local realSimulate = self.leftPoints ~= self.source_leftPoints
  extraCheck = true
  for k, skill in pairs(self.simulateSkills) do
    cell = skillCells[skill.data.sortID]
    if cell then
      fitJob = skill:FitNextJobLevel(myJobLevel)
      fitRequiredSkill = skill:FitRequiredSkill()
      fitRequiredSkills = skill:FitMultiRequiredSkills()
      hasPoint = skill:FitNextSkillPointCost(self.leftPoints)
      if self.extraCheckFunc then
        extraCheck = self.extraCheckFunc(self.extraCheckFuncParam, skill)
      end
      if skill.learned then
        cell:EnableGray(false)
        cell:ShowUpgrade(skill:HasNextLevel())
        if not hasPoint or not fitJob or not skill:HasNextLevel() or not extraCheck then
          if realSimulate then
            cell:SetUpgradeEnable(false)
          else
            cell:SetNameBgEnable(false)
            cell:ShowUpgrade(false)
          end
        else
          cell:SetUpgradeEnable(true)
          cell:SetNameBgEnable(true)
        end
      elseif fitJob and fitRequiredSkill and fitRequiredSkills and hasPoint and extraCheck then
        cell:ShowUpgrade(true)
        cell:SetUpgradeEnable(true)
        cell:EnableGray(false)
      else
        cell:ShowUpgrade(false)
        cell:EnableGray(true)
      end
      if cell.requiredCell then
        cell.requiredCell:LinkUnlock(cell.data.sortID, fitRequiredSkill and fitRequiredSkills)
      end
      if cell.requiredCells then
        for i = 1, #cell.requiredCells do
          cell.requiredCells[i]:MultiLinkUnlock(cell.data.sortID, fitRequiredSkills)
        end
      end
    end
  end
end
