Astrolabe_BordData = class("Astrolabe_BordData")
AstrolabeProxy_Plate_Length = 100
Astrolabe_Origin_PointID = 10000
autoImport("Table_Astrolabe")
autoImport("Table_AstrolabeUI")
autoImport("Astrolabe_PlateData")
local ArrayPushBack = TableUtility.ArrayPushBack
local TableClear = TableUtility.TableClear
local floor = math.floor
local _ProfessionProxy
local PointCountInit, TotalPointCount_Map = false, {}
local Default_TypeBranch = GameConfig.Astrolabe.Default_TypeBranch
local t_temp = {}
function Astrolabe_BordData:ctor()
  _ProfessionProxy = ProfessionProxy.Instance
  self.activePointsMap = {}
  self.offPoints_IDMap = {}
  self.add_EffectMap = {}
  self.add_SpecialEffectMap = {}
  self.specialEffectCountMap = {}
  self.skillSpecialEffectEnable = {}
  self:InitPlates()
  self:InitPlatesBg()
end
function Astrolabe_BordData:InitPlates()
  self.platesMap = {}
  for plateid, plateSData in pairs(Table_Astrolabe) do
    local plateData = Astrolabe_PlateData.new(self)
    plateData:ReInitData(plateSData)
    self.platesMap[plateid] = plateData
    if PointCountInit == false then
      local unlock = plateData:GetUnlock()
      local evo, lv = unlock.lv or unlock.evo or 0, 0
      local _t = TotalPointCount_Map[evo]
      if _t == nil then
        _t = {}
        TotalPointCount_Map[evo] = _t
      end
      if _t[lv] == nil then
        _t[lv] = plateData.point_count
      else
        _t[lv] = _t[lv] + plateData.point_count
      end
    end
  end
  PointCountInit = true
  self.specialPoints = nil
end
function Astrolabe_BordData:InitPlatesBg()
  self.platesBgMap = {}
  for id1, bgDatas in pairs(Table_AstrolabeUI) do
    for id2, bgData in pairs(bgDatas) do
      local cid = id1 * 10000 + id2
      self.platesBgMap[cid] = bgData
    end
  end
  return self.platesBgMap
end
function Astrolabe_BordData:UnlockPlateByMenuId(menuid)
  self.specialPointsDirty = true
end
function Astrolabe_BordData:InitPlates_Prop(profession)
  self.specialPointsDirty = true
  self.profession = profession
  local classData = profession and Table_Class[profession]
  if classData == nil then
    return
  end
  local typeBranch = classData and classData.TypeBranch
  if typeBranch == nil then
    local class_typeid = classData.Type
    typeBranch = Default_TypeBranch and Default_TypeBranch[class_typeid]
  end
  if typeBranch == nil or typeBranch == 0 then
    return
  end
  self.propTableName = "Table_Rune_" .. typeBranch
  local propConfig = _G[self.propTableName]
  if propConfig == nil then
    autoImport(self.propTableName)
    propConfig = _G[self.propTableName]
  end
  if propConfig == nil then
    redlog("Not Find Rune_Config!", self.propTableName)
    return
  end
  for guid, propData in pairs(propConfig) do
    local pointData = self:GetPointByGuid(guid)
    if pointData then
      pointData:SetPropData(propData.Attr)
    end
  end
  self:RefreshActiveEffectMap()
  local sdataTableName = "Table_Rune"
  local sConfig = _G[sdataTableName]
  if sConfig == nil then
    autoImport(sdataTableName)
    sConfig = _G[sdataTableName]
  end
  for id, sData in pairs(sConfig) do
    local pointData = self:GetPointByGuid(id)
    if pointData then
      pointData:SetStaticData(sData)
    end
  end
end
function Astrolabe_BordData:InitUnlockParam(profession, rolelevel)
  if self.platesMap == nil then
    return
  end
  for k, plateData in pairs(self.platesMap) do
    plateData:SetProfession(profession)
    plateData:SetRoleLevel(rolelevel)
  end
end
function Astrolabe_BordData:GetPlateMap()
  return self.platesMap
end
function Astrolabe_BordData:GetPlateBgDatas()
  return self.platesBgMap
end
function Astrolabe_BordData:GetPlateData(plateid)
  return self.platesMap[plateid]
end
function Astrolabe_BordData:GetPointByGuid(point_guid)
  local plateid = math.floor(point_guid / 10000)
  local posid = point_guid % 10000
  return self:GetPointByPosInfo(plateid, posid)
end
function Astrolabe_BordData:GetPointByPosInfo(plateid, posid)
  local plateData = self.platesMap[plateid]
  if plateData == nil then
    redlog(string.format("not find plateid:%s", plateid))
    return
  end
  return plateData:GetPointDataByPos(posid)
end
function Astrolabe_BordData:GetTotalPointCount(rolelv, profession)
  local depth = _ProfessionProxy:GetDepthByClassId(profession)
  local max_evo = depth
  if max_evo == 4 and not FunctionUnLockFunc.Me():CheckCanOpen(5002) then
    max_evo = 3
  end
  if max_evo == 3 and not FunctionUnLockFunc.Me():CheckCanOpen(5001) then
    max_evo = 2
  end
  local result_count = 0
  for evo, nums in pairs(TotalPointCount_Map) do
    if evo <= max_evo then
      for lv, num in pairs(nums) do
        if lv <= rolelv then
          result_count = result_count + num
        end
      end
    end
  end
  return result_count
end
function Astrolabe_BordData:GetActivePointsMap()
  return self.activePointsMap
end
function Astrolabe_BordData:GetAdd_EffectMap()
  return self.add_EffectMap
end
function Astrolabe_BordData:GetSkill_SpecialEffect(skillid)
  return self.add_SpecialEffectMap[skillid]
end
function Astrolabe_BordData:GetSpecialEffectCount(specialEffectId)
  local count = self.specialEffectCountMap[specialEffectId]
  if count == nil then
    return 0
  end
  local config = Table_RuneSpecial[specialEffectId]
  if config.Type == 2 then
    local enable = self.skillSpecialEffectEnable[specialEffectId]
    if enable == false or enable == nil then
      return 0
    end
  end
  return count
end
function Astrolabe_BordData:GetOffPointsIDMap()
  return self.offPoints_IDMap
end
function Astrolabe_BordData:GetPlanIdsMap()
  return self.planIdsMap
end
function Astrolabe_BordData:CheckIsInPlaned(id)
  return self.planIdsMap and self.planIdsMap[id] ~= nil or false
end
function Astrolabe_BordData:Server_SetActivePoints(pids, actType)
  if actType == AstrolabeCmd_pb.EASTROLABETYPE_PLAN then
    self.planIdsMap = {}
    for i = 1, #pids do
      self.planIdsMap[pids[i]] = 1
    end
    return
  end
  for i = 1, #pids do
    self:Server_ActivePoint(pids[i])
  end
end
function Astrolabe_BordData:Server_ActivePoint(guid)
  local plateid, posid = math.floor(guid / 10000), guid % 10000
  local pointData = self:GetPointByPosInfo(plateid, posid)
  if pointData and not pointData:IsActive() then
    pointData:SetActive(true)
    local plateData = self.platesMap[plateid]
    local pointMap = plateData:GetPointMap()
    local innerConnect = pointData:GetInnerConnect()
    for i = 1, #innerConnect do
      local pointData2 = pointMap[innerConnect[i]]
      local state2 = pointData2:GetState()
      if state2 < Astrolabe_PointData_State.Off then
        pointData2:SetState(Astrolabe_PointData_State.Off)
      end
    end
    local outerConnect = pointData:GetOuterConnect()
    if outerConnect then
      for i = 1, #outerConnect do
        local outerPoint = self:GetPointByGuid(outerConnect[i])
        local outerState = outerPoint:GetState()
        if outerState < Astrolabe_PointData_State.Off then
          outerPoint:SetState(Astrolabe_PointData_State.Off)
        end
      end
    end
    self:UpdateActiveEffectMap(pointData)
    self.activePointsMap[guid] = pointData
  end
end
function Astrolabe_BordData:SkillSetSpecialEnable(specialEffectId, enabled)
  self.skillSpecialEffectEnable[specialEffectId] = enabled
end
function Astrolabe_BordData:RefreshPointState(point_guid, state)
  if state == Astrolabe_PointData_State.Off then
    self.offPoints_IDMap[point_guid] = 1
  else
    self.offPoints_IDMap[point_guid] = nil
  end
end
function Astrolabe_BordData:UpdateActiveEffectMap(pointData)
  local isActive = pointData:IsActive()
  local effect = pointData:GetEffect()
  if effect then
    local add_EffectMap = self.add_EffectMap
    for attriKey, value in pairs(effect) do
      if isActive then
        if add_EffectMap[attriKey] then
          add_EffectMap[attriKey] = add_EffectMap[attriKey] + value
        else
          add_EffectMap[attriKey] = value
        end
      elseif add_EffectMap[attriKey] then
        add_EffectMap[attriKey] = add_EffectMap[attriKey] - value
      end
    end
  end
  local seid = pointData:GetSpecialEffect()
  if seid == nil then
    return
  end
  local effectData = Table_RuneSpecial[seid]
  if effectData == nil then
    return
  end
  local specialEffectCountMap = self.specialEffectCountMap
  local count
  if isActive then
    count = specialEffectCountMap[seid]
    count = count == nil and 1 or count + 1
    specialEffectCountMap[seid] = count
  elseif specialEffectCountMap[seid] then
    specialEffectCountMap[seid] = specialEffectCountMap[seid] - 1
    if specialEffectCountMap[seid] == 0 then
      specialEffectCountMap[seid] = nil
    end
  end
  local skillIds = effectData.SkillID
  if skillIds == nil then
    return
  end
  local add_SpecialEffectMap = self.add_SpecialEffectMap
  if isActive then
    for i = 1, #skillIds do
      local skillId = skillIds[i]
      local ids = add_SpecialEffectMap[skillId]
      if ids == nil then
        ids = {}
        add_SpecialEffectMap[skillId] = ids
      end
      if ids[seid] == nil then
        ids[seid] = 1
      else
        ids[seid] = ids[seid] + 1
      end
    end
  else
    for i = 1, #skillIds do
      local skillId = skillIds[i]
      local ids = add_SpecialEffectMap[skillId]
      if ids ~= nil and ids[seid] ~= nil then
        ids[seid] = ids[seid] - 1
        if ids[seid] == 0 then
          ids[seid] = nil
          if next(ids) == nil then
            add_SpecialEffectMap[skillId] = nil
          end
        end
      end
    end
  end
end
function Astrolabe_BordData:Server_ResetPoints(server_stars, noReset)
  for i = 1, #server_stars do
    local id = server_stars[i]
    if id == Astrolabe_Origin_PointID and noReset ~= true then
      self:Reset()
      return
    end
    self:Server_ResetPoint(server_stars[i])
  end
end
function Astrolabe_BordData:Server_ResetPoint(guid)
  local pointData = self:GetPointByGuid(guid)
  if pointData == nil then
    return
  end
  if not pointData:IsActive() then
    return
  end
  pointData:SetActive(false)
  pointData:SetState(Astrolabe_PointData_State.Lock)
  pointData:UpdateLockState(self)
  local plateid = math.floor(guid / 10000)
  local plateData = self:GetPlateData(plateid)
  local pointMap = plateData:GetPointMap()
  local innerConnect = pointData:GetInnerConnect()
  for i = 1, #innerConnect do
    local pointData2 = pointMap[innerConnect[i]]
    pointData2:UpdateLockState(self)
  end
  local outerConnect = pointData:GetOuterConnect()
  if outerConnect then
    for i = 1, #outerConnect do
      local outerPoint = self:GetPointByGuid(outerConnect[i])
      outerPoint:UpdateLockState(self)
    end
  end
  self:UpdateActiveEffectMap(pointData)
  self.activePointsMap[guid] = nil
end
function Astrolabe_BordData:Reset()
  local activePointsMap = self.activePointsMap
  for activeid, pointData in pairs(activePointsMap) do
    pointData:SetState(Astrolabe_PointData_State.Lock)
    local innerConnect = pointData:GetInnerConnect()
    for i = 1, #innerConnect do
      local id = innerConnect[i] + pointData.plateid * 10000
      local pointData2 = self:GetPointByGuid(id)
      pointData2:SetState(Astrolabe_PointData_State.Lock)
    end
    local outerConnect = pointData:GetOuterConnect()
    if outerConnect then
      for i = 1, #outerConnect do
        local id = outerConnect[i]
        local outerPoint = self:GetPointByGuid(id)
        outerPoint:SetState(Astrolabe_PointData_State.Lock)
      end
    end
  end
  TableClear(activePointsMap)
  self:ResetAddEffect(plate)
end
function Astrolabe_BordData:ResetAddEffect()
  TableClear(self.add_EffectMap)
  TableClear(self.add_SpecialEffectMap)
  TableClear(self.specialEffectCountMap)
  TableClear(self.skillSpecialEffectEnable)
end
function Astrolabe_BordData:RefreshActiveEffectMap()
  self:ResetAddEffect()
  for k, pointData in pairs(self.activePointsMap) do
    self:UpdateActiveEffectMap(pointData)
  end
end
function Astrolabe_BordData:CheckPlateIsUnlock(plateid)
  local plateData = self.platesMap[plateid]
  if plateData == nil then
    error(string.format("Not Find Plate:%s", plateid))
    return
  end
  return plateData:IsUnlock()
end
function Astrolabe_BordData:CheckNeed_DoServer_InitPlate()
  local originPoint = self:GetPointByGuid(Astrolabe_Origin_PointID)
  if not originPoint:IsActive() then
    TableClear(t_temp)
    t_temp[1] = Astrolabe_Origin_PointID
    ServiceAstrolabeCmdProxy.Instance:CallAstrolabeActivateStarCmd(t_temp)
  end
end
function Astrolabe_BordData:ResetActivePoint(globalID)
  local activeMap = self:GetActivePointsMap()
  self:BuildUndirectedGraph(activeMap)
  return self:_ResetPoint(globalID, activeMap)
end
function Astrolabe_BordData:ResetPlanPoint(globalID, activeMap)
  activeMap = activeMap or self:GetPlanIdsMap()
  self:BuildUndirectedGraph(activeMap)
  return self:_ResetPoint(globalID, activeMap)
end
local cutVertexes = {}
function Astrolabe_BordData:_ResetPoint(globalID, activeMap)
  activeMap = activeMap or self:GetActivePointsMap()
  local deActivatedPoints = {
    [globalID] = true
  }
  if self:IsCutVertex(globalID) then
    for i = 1, #cutVertexes[globalID] do
      self:GetAllChildren(cutVertexes[globalID][i], deActivatedPoints, activeMap)
    end
  end
  return deActivatedPoints
end
function Astrolabe_BordData:BuildUndirectedGraph(activeMap)
  self:ReuseTarjanCache()
  self:Tarjan(Astrolabe_Origin_PointID, nil, activeMap)
end
local TableAstrolabe = Table_Astrolabe
local counter = 0
local visited = {}
local dfn = {}
local low = {}
function Astrolabe_BordData:Tarjan(u, parent, activeMap)
  local v, children, starID, astrolabeID = 0, 0, 0, 0
  local connects, star = {}, {}
  visited[u] = true
  counter = counter + 1
  dfn[u], low[u] = counter, counter
  astrolabeID = floor(u / 10000)
  starID = u % 10000
  star = TableAstrolabe[astrolabeID].stars[starID]
  for i = 1, #star do
    local connects = star[i]
    for k = 1, #connects do
      local v = connects[k]
      if v < 10000 then
        v = v + astrolabeID * 10000
      end
      if activeMap[v] then
        if not visited[v] then
          children = children + 1
          self:Tarjan(v, u, activeMap)
          if low[u] > low[v] then
            low[u] = low[v]
          end
          if not parent and children > 1 then
            if not cutVertexes[u] then
              cutVertexes[u] = {}
            end
            ArrayPushBack(cutVertexes[u], v)
          end
          if parent and low[v] >= dfn[u] then
            if not cutVertexes[u] then
              cutVertexes[u] = {}
            end
            ArrayPushBack(cutVertexes[u], v)
          end
        elseif v ~= parent and low[u] > dfn[v] then
          low[u] = dfn[v]
        end
      end
    end
  end
end
local queue = {}
local head, last, parent, astrolabeID, starID = 0, 0, 0, 0, 0
function Astrolabe_BordData:GetAllChildren(root, deActivatedPoints, activeMap)
  local RootLowValue = low[root]
  head = 0
  last = 1
  queue[last] = root
  deActivatedPoints[root] = true
  while last > head do
    head = head + 1
    parent = queue[head]
    astrolabeID = floor(parent / 10000)
    starID = parent % 10000
    star = TableAstrolabe[astrolabeID].stars[starID]
    for i = 1, #star do
      local connects = star[i]
      for k = 1, #connects do
        local id = connects[k]
        if id < 10000 then
          id = id + astrolabeID * 10000
        end
        if not deActivatedPoints[id] and activeMap[id] and RootLowValue <= low[id] then
          deActivatedPoints[id] = true
          last = last + 1
          queue[last] = id
        end
      end
    end
  end
end
function Astrolabe_BordData:IsCutVertex(globalID)
  return cutVertexes[globalID]
end
function Astrolabe_BordData:ReuseTarjanCache()
  counter = 0
  cutVertexes = {}
  self:ReuseVisitedArray()
end
function Astrolabe_BordData:ReuseVisitedArray()
  for k, _ in pairs(visited) do
    visited[k] = false
  end
end
function Astrolabe_BordData:ClearTarjanCache()
  visited = {}
  dfn = {}
  low = {}
  cutVertexes = {}
  queue = {}
end
function Astrolabe_BordData:SetEvo(evo)
  for k, plateData in pairs(self.platesMap) do
    plateData:SetEvo(evo)
  end
  self.specialPointsDirty = true
end
function Astrolabe_BordData:_initSpecialPoints()
  if not self.specialPointsDirty and self.specialPoints then
    return
  end
  self.specialPointsDirty = false
  self.specialPoints = {}
  local plateMap = self:GetPlateMap()
  local pointMap, iconIndex
  local insertSort = TableUtility.InsertSort
  local sortFunc = function(iN, iNsert)
    return iN.guid > iNsert.id
  end
  for plateid, plateData in pairs(plateMap) do
    if plateData:IsUnlock() then
      pointMap = plateData:GetPointMap()
      for pid, pointData in pairs(pointMap) do
        local pName = pointData:GetName()
        iconIndex = pointData:GetIconIndex()
        if iconIndex == 5 or iconIndex == 6 then
          insertSort(self.specialPoints, pointData, sortFunc)
        end
      end
    end
  end
end
function Astrolabe_BordData:GetAllSpeicalPoints(overlap)
  self:_initSpecialPoints()
  if not overlap then
    return self.specialPoints
  end
  local overlapMap = {}
  local result = {}
  local insertSort = TableUtility.InsertSort
  local sortFunc = function(iN, iNsert)
    return iN:GetName() > iNsert:GetName()
  end
  for id, pointData in pairs(self.specialPoints) do
    pName = pointData:GetName()
    pName = string.lower(pName)
    if not overlapMap[pName] then
      overlapMap[pName] = 1
      insertSort(result, pointData, sortFunc)
    end
  end
  return result
end
function Astrolabe_BordData:MatchSpecialPointByName(keyword, refTable, overlap)
  if keyword == nil or keyword == "" then
    return
  end
  keyword = string.lower(keyword)
  local pName
  local allPoints = self:GetAllSpeicalPoints(overlap)
  for i = 1, #allPoints do
    pName = allPoints[i]:GetName()
    pName = string.lower(pName)
    if string.find(pName, keyword, nil, true) then
      table.insert(refTable, allPoints[i])
    end
  end
end
