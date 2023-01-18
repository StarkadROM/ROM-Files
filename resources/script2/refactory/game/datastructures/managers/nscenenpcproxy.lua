autoImport("SceneCreatureProxy")
NSceneNpcProxy = class("NSceneNpcProxy", SceneCreatureProxy)
NSceneNpcProxy.Instance = nil
NSceneNpcProxy.NAME = "NSceneNpcProxy"
local tmpArray = {}
local tempPos = LuaVector3.Zero()
local _SqrDistance = LuaVector3.Distance_Square
local TrapNpcID = {}
for i = 1, #GameConfig.TrapNpcID do
  TrapNpcID[GameConfig.TrapNpcID[i]] = 1
end
function NSceneNpcProxy:ctor(proxyName, data)
  self:CountClear()
  self.cacheParts = {}
  self.userMap = {}
  self.npcMap = {}
  self.npcGroupMap = {}
  self.userMapDead = {}
  self.userMapRemove = {}
  if NSceneNpcProxy.Instance == nil then
    NSceneNpcProxy.Instance = self
  end
  self.proxyName = proxyName or NSceneNpcProxy.NAME
  if Game and Game.LogicManager_Creature then
    Game.LogicManager_Creature:SetSceneNpcProxy(self)
  end
  self.delayRemoveDuration = {}
  self.delayRemoveDuration[NpcData.NpcDetailedType.MVP] = GameConfig.MonsterBodyDisappear.MVP
  self.delayRemoveDuration[NpcData.NpcDetailedType.MINI] = GameConfig.MonsterBodyDisappear.MINI
  self.delayRemoveDuration[NpcData.NpcDetailedType.NPC] = GameConfig.MonsterBodyDisappear.NPC
  self.delayRemoveDuration[NpcData.NpcDetailedType.Monster] = GameConfig.MonsterBodyDisappear.Monster
end
function NSceneNpcProxy:SyncMove(data, isPathFidingOptOn)
  local npc = self:Find(data.charid)
  if nil ~= npc then
    npc:Server_MoveToXYZCmd(data.pos.x, data.pos.y, data.pos.z)
    local f_notifyMove = npc.data and npc.data.GetFeature_NotifyMove
    if f_notifyMove and f_notifyMove(npc.data) then
      GameFacade.Instance:sendNotification(SceneUserEvent.NpcSyncMove, npc.data.id)
    end
    return true
  end
  return false
end
local FUNC_GET_NPC_CLASSREF = function(data, classRef)
  if classRef then
    return classRef
  end
  local isStage
  for k, v in pairs(GameConfig.DressUp.stageid) do
    isStage = data.npcID == v
    if isStage then
      return NStageNpc
    end
  end
  return NNpc
end
function NSceneNpcProxy:Add(data, classRef, isTrap)
  local npc = self:Find(data.id)
  if npc ~= nil then
    return npc
  end
  local npcID = data.npcID
  if Table_Monster[npcID] == nil and Table_Npc[npcID] == nil then
    helplog("找不到Npc配置", npcID)
    return
  end
  classRef = FUNC_GET_NPC_CLASSREF(data, classRef)
  npc = classRef.CreateAsTable(data)
  self.userMap[data.id] = npc
  if classRef == NNpc or classRef == NStageNpc or classRef == NFollowNpc then
    if isTrap and data.owner ~= 0 then
      local creature = SceneCreatureProxy.FindCreature(data.owner)
      if creature and creature.data:GetCamp() == RoleDefines_Camp.ENEMY then
        npc:ShowWarnRingEffect()
      end
    end
    self:AddNpc(npc)
  end
  if 0 < data.searchrange then
    npc:ShowViewRange(data.searchrange)
  end
  self:CountPlus()
  if data.effect then
  end
  npc:RegistCulling()
  if npc.data and npc.data:IsMusicBox() then
    FunctionMusicBox.Me():AddMusicBox(npc)
  end
  if npc.data:IsSkada() then
    HomeSkadaManager.Me():CreateSkadaMonitor(npc)
  end
  local spEffectDatas = data.speffectdata
  if nil ~= spEffectDatas then
    for i = 1, #spEffectDatas do
      npc:Server_AddSpEffect(spEffectDatas[i])
    end
  end
  if Game.Myself then
    Game.Myself:OnAddNpc(npc)
  end
  local chantskill = data.chantskill
  if chantskill then
    npc:SetChantSkill(chantskill)
  end
  return npc
end
function NSceneNpcProxy:Remove(guid, delay, fadeout)
  local targetguid = MyselfProxy.Instance:GetTargetAndPos()
  if targetguid and targetguid == guid then
    return
  end
  local npc = self:Find(guid)
  if nil ~= npc then
    self:RemoveNpc(npc)
    if npc:IsDead() and npc.data:IsMonster_Detail() then
      GameFacade.Instance:sendNotification(CreatureEvent.NpcDie, npc)
      EventManager.Me():PassEvent(CreatureEvent.NpcDie, npc)
      self:Die(guid, npc)
    elseif delay ~= nil and delay > 0 or fadeout ~= nil and fadeout > 0 then
      self:DelayRemove(npc, delay, fadeout)
    else
      self:RealRemove(guid, false)
    end
    return true
  end
  return false
end
function NSceneNpcProxy:CheckNpcType(guid)
  local npc = self:Find(guid)
  if npc ~= nil and npc.data:IsMonster_Detail() then
    npc:SetDeadTime()
  end
end
function NSceneNpcProxy:SetSearchRange(data)
  local npc = self:Find(data.id)
  if npc ~= nil then
    npc:ShowViewRange(data.range)
  end
end
local tmpNpcs = {}
function NSceneNpcProxy:PureAddSome(datas)
  local data
  for i = 1, #datas do
    data = datas[i]
    if data ~= nil then
      local isTrap = TrapNpcID[data.npcID] ~= nil
      if data.owner == 0 or isTrap then
        tmpNpcs[#tmpNpcs + 1] = self:Add(data, nil, isTrap)
      else
        tmpArray[#tmpArray + 1] = data
      end
    end
  end
  if #tmpNpcs > 0 then
    GameFacade.Instance:sendNotification(SceneUserEvent.SceneAddNpcs, tmpNpcs)
    EventManager.Me():PassEvent(SceneUserEvent.SceneAddNpcs, tmpNpcs)
    TableUtility.ArrayClear(tmpNpcs)
  end
  if tmpArray and #tmpArray > 0 then
    NScenePetProxy.Instance:PureAddSome(tmpArray)
    TableUtility.ArrayClear(tmpArray)
  end
  SceneCarrierProxy.Instance:PureAddSome(datas)
end
function NSceneNpcProxy:RemoveSome(guids, delay, fadeout)
  local npcs = NSceneNpcProxy.super.RemoveSome(self, guids, delay, fadeout)
  if npcs and #npcs > 0 then
    GameFacade.Instance:sendNotification(SceneUserEvent.SceneRemoveNpcs, npcs)
    EventManager.Me():PassEvent(SceneUserEvent.SceneRemoveNpcs, npcs)
  end
end
function NSceneNpcProxy:Die(guid, npc)
  if npc == nil then
    npc = self:Find(guid)
  end
  if npc then
    local delay = self.delayRemoveDuration[npc.data.detailedType]
    if delay == nil then
      delay = 2000
    end
    npc:SetDelayRemove(delay / 1000)
  end
  return npc
end
function NSceneNpcProxy:DelayRemove(npc, delay, duration)
  if npc then
    delay = delay or 0
    npc:SetDelayRemove(delay / 1000, duration and duration / 1000)
  end
end
function NSceneNpcProxy:DieWithoutDelayRemove(guid)
  return NSceneNpcProxy.super.Die(self, guid)
end
function NSceneNpcProxy:RealRemove(guid, fade)
  return NSceneNpcProxy.super.Remove(self, guid, fade)
end
local clearArr = {}
function NSceneNpcProxy:Clear()
  self:ChangeAddMode(SceneCreatureProxy.AddMode.Normal)
  self:ClearNpc()
  local npcs = NSceneNpcProxy.super.Clear(self)
  if npcs and #npcs > 0 then
    GameFacade.Instance:sendNotification(SceneUserEvent.SceneRemoveNpcs, npcs)
    EventManager.Me():PassEvent(SceneUserEvent.SceneRemoveNpcs, npcs)
  end
  self:ClearPartsCache()
end
function NSceneNpcProxy:GetOrCreatePartsFromStaticData(staticData)
  local parts = self.cacheParts[staticData.id]
  if parts == nil then
    parts = Asset_Role.CreatePartArray()
    Asset_RoleUtility.SetRoleParts(staticData, parts)
    self.cacheParts[staticData.id] = parts
  end
  return parts
end
local emptyParts
function NSceneNpcProxy:GetNpcEmptyParts()
  if emptyParts == nil then
    emptyParts = Asset_Role.CreatePartArray()
  end
  return emptyParts
end
function NSceneNpcProxy:ClearPartsCache()
  if self.cacheParts then
    for k, v in pairs(self.cacheParts) do
      Asset_Role.DestroyPartArray(v)
      self.cacheParts[k] = nil
    end
  else
    self.cacheParts = {}
  end
end
function NSceneNpcProxy:AddNpcIntoMap(npc)
  local npcID = npc.data.staticData.id
  local npcList = self.npcMap[npcID]
  if nil == npcList then
    npcList = {}
    self.npcMap[npcID] = npcList
  elseif 1 <= TableUtil.ArrayIndexOf(npcList, npc) then
    return
  end
  npcList[#npcList + 1] = npc
end
function NSceneNpcProxy:AddNpcIntoGroupMap(npc)
  local npcGroupID = npc.data:GetGroupID()
  if nil == npcGroupID then
    return
  end
  local npcList = self.npcGroupMap[npcGroupID]
  if nil == npcList then
    npcList = {}
    self.npcGroupMap[npcGroupID] = npcList
  elseif 1 <= TableUtil.ArrayIndexOf(npcList, npc) then
    return
  end
  npcList[#npcList + 1] = npc
end
function NSceneNpcProxy:AddNpc(npc)
  self:AddNpcIntoMap(npc)
  self:AddNpcIntoGroupMap(npc)
end
function NSceneNpcProxy:RemoveNpcFromMap(npc)
  local npcID = npc.data.staticData.id
  local npcList = self.npcMap[npcID]
  if nil ~= npcList then
    TableUtil.Remove(npcList, npc)
  end
end
function NSceneNpcProxy:RemoveNpcFromGroupMap(npc)
  local npcGroupID = npc.data:GetGroupID()
  if nil == npcGroupID then
    return
  end
  local npcList = self.npcGroupMap[npcGroupID]
  if nil ~= npcList then
    TableUtil.Remove(npcList, npc)
  end
end
function NSceneNpcProxy:RemoveNpc(npc)
  if nil == npc then
    return
  end
  if npc.data:IsMusicBox() then
    FunctionMusicBox.Me():RemoveMusicBox(npc)
  end
  if npc.data:IsSkada() then
    HomeSkadaManager.Me():RemoveSkadaMonitor(npc)
  end
  self:RemoveNpcFromMap(npc)
  self:RemoveNpcFromGroupMap(npc)
end
function NSceneNpcProxy:ClearNpc()
  self.npcMap = {}
  self.npcGroupMap = {}
end
function NSceneNpcProxy:FindNpcs(npcID)
  return self.npcMap[npcID]
end
function NSceneNpcProxy:FindNpcsByGroupID(npcGroupID)
  return self.npcGroupMap[npcGroupID]
end
function NSceneNpcProxy:_FindNearestNpc(npcs, position, filter, randomDistance)
  LuaVector3.Better_Set(tempPos, position[1], position[2], position[3])
  local nearestNpc, minDist
  if nil == randomDistance then
    randomDistance = 0
  end
  local sqrRequireDis = randomDistance * randomDistance
  for i = 1, #npcs do
    local npc = npcs[i]
    if nil == filter or filter(npc) then
      local npcPosition = npc:GetPosition()
      local sqrDis = _SqrDistance(npcPosition, tempPos)
      if sqrRequireDis > 0 and sqrRequireDis > sqrDis then
        return npc, math.sqrt(sqrDis)
      end
      if not minDist or minDist > sqrDis then
        local canArrive = NavMeshUtils.CanArrived(tempPos, npcPosition, WorldTeleport.DESTINATION_VALID_RANGE, true)
        if canArrive then
          minDist = sqrDis
          nearestNpc = npc
        end
      end
    else
    end
  end
  return nearestNpc, minDist and math.sqrt(minDist)
end
local templist
function NSceneNpcProxy:_FindNearestNpcByNavmesh(npcs, position, filter, randomDistance)
  LuaVector3.Better_Set(tempPos, position[1], position[2], position[3])
  if templist == nil then
    templist = {}
  end
  if nil == randomDistance then
    randomDistance = 0
  end
  local sqrRequireDis = randomDistance * randomDistance
  local limitNum, insertCount = 3, 0
  local inserted
  for i = 1, #npcs do
    local npc = npcs[i]
    if nil == filter or filter(npc) then
      local npcPosition = npc:GetPosition()
      local sqrDis = _SqrDistance(npcPosition, tempPos)
      if sqrRequireDis > 0 and sqrRequireDis > sqrDis then
        TableUtility.ArrayClear(templist)
        return npc, math.sqrt(sqrDis)
      end
      inserted = false
      if limitNum > insertCount then
        for j = 1, insertCount do
          if sqrDis < templist[j][3] then
            inserted = true
            table.insert(templist, j, {
              npc,
              npcPosition,
              sqrDis
            })
          end
        end
        if not inserted then
          table.insert(templist, {
            npc,
            npcPosition,
            sqrDis
          })
        end
        insertCount = insertCount + 1
      else
        for j = 1, insertCount do
          if sqrDis < templist[j][3] then
            inserted = true
            table.insert(templist, j, {
              npc,
              npcPosition,
              sqrDis
            })
          end
        end
        if inserted then
          table.remove(templist)
        end
      end
    end
  end
  local minDist, nearestNpc = math.huge, nil
  for i = 1, #templist do
    local npcPosition = templist[i][2]
    local suc, path
    suc, path = NavMeshUtils.CanArrived(tempPos, npcPosition, WorldTeleport.DESTINATION_VALID_RANGE, true, nil)
    if suc then
      local dist = NavMeshUtils.GetPathDistance(path)
      if minDist > dist then
        minDist = dist
        nearestNpc = templist[i][1]
      end
    end
  end
  TableUtility.ArrayClear(templist)
  return nearestNpc, minDist
end
function NSceneNpcProxy:FindNearestNpc(position, npcID, filter, randomDistance, useNavmesh)
  local npcs = self:FindNpcs(npcID)
  if nil == npcs then
    return nil
  end
  if useNavmesh then
    return self:_FindNearestNpcByNavmesh(npcs, position, filter, randomDistance)
  else
    return self:_FindNearestNpc(npcs, position, filter, randomDistance)
  end
end
function NSceneNpcProxy:FindNearestNpc_IngoreCanArrive(position, npcID, filter, randomDistance)
  local npcs = self:FindNpcs(npcID)
  if nil == npcs then
    return nil
  end
  LuaVector3.Better_Set(tempPos, position[1], position[2], position[3])
  local nearestNpc
  local minDist = math.huge
  randomDistance = randomDistance or 0
  randomDistance = randomDistance * randomDistance
  local sqrDistance
  for i = 1, #npcs do
    if nil == filter or filter(npcs[i]) then
      sqrDistance = LuaVector3.Distance_Square(npcs[i]:GetPosition(), tempPos)
      if randomDistance > 0 and randomDistance > sqrDistance then
        return npcs[i], math.sqrt(sqrDistance)
      end
      if not nearestNpc or minDist > sqrDistance then
        minDist = sqrDistance
        nearestNpc = npcs[i]
      end
    end
  end
  return nearestNpc, minDist and math.sqrt(minDist)
end
function NSceneNpcProxy:FindNearestNpcByGroupID(position, npcGroupID, filter, randomDistance)
  local npcs = self:FindNpcsByGroupID(npcGroupID)
  if nil == npcs then
    return nil
  end
  return self:_FindNearestNpc(npcs, position, filter, randomDistance)
end
local nearNpcList = {}
function NSceneNpcProxy:FindNearNpcs(position, distance, filter)
  if Game.LogicManager_MapCell:IsCreatureUpdateWorking() then
    return Game.LogicManager_MapCell:GetCreaturesAround(position, filter, distance, Creature_Type.Npc)
  end
  LuaVector3.Better_Set(tempPos, position[1], position[2], position[3])
  TableUtility.TableClear(nearNpcList)
  local sqrDis = distance * distance
  for k, v in pairs(self.npcMap) do
    for i = 1, #v do
      local npc = v[i]
      if sqrDis >= _SqrDistance(npc:GetPosition(), tempPos) and (nil == filter or filter(npc)) then
        table.insert(nearNpcList, npc)
      end
    end
  end
  return nearNpcList
end
function NSceneNpcProxy:FindNpcInRange(position, distance, filter, useRealTimeData)
  if not useRealTimeData and Game.LogicManager_MapCell:IsCreatureUpdateWorking() then
    return Game.LogicManager_MapCell:FindCreatureAround(position, filter, distance, Creature_Type.Npc)
  end
  LuaVector3.Better_Set(tempPos, position[1], position[2], position[3])
  local sqrDis = distance * distance
  for k, v in pairs(self.npcMap) do
    for i = 1, #v do
      local npc = v[i]
      if sqrDis >= _SqrDistance(npc:GetPosition(), tempPos) and (nil == filter or filter(npc)) then
        return npc
      end
    end
  end
end
function NSceneNpcProxy:FindNearestInNearNpc(position, distance, filter)
  if Game.LogicManager_MapCell:IsCreatureUpdateWorking() then
    return Game.LogicManager_MapCell:FindNearestCreatureAround(position, filter, distance, Creature_Type.Npc)
  end
  LuaVector3.Better_Set(tempPos, position[1], position[2], position[3])
  local nearestNpc
  local minDistSq = distance * distance
  for k, v in pairs(self.npcMap) do
    for i = 1, #v do
      local npc = v[i]
      local dist = _SqrDistance(npc:GetPosition(), tempPos)
      if minDistSq >= dist and (nil == filter or filter(npc)) then
        minDistSq = dist
        nearestNpc = npc
      end
    end
  end
  return nearestNpc
end
function NSceneNpcProxy:TraversingCreatureAround(position, distance, action)
  if not action then
    return
  end
  if Game.LogicManager_MapCell:IsCreatureUpdateWorking() then
    Game.LogicManager_MapCell:TraversingCreatureAround(position, action, distance, Creature_Type.Npc)
    return
  end
  LuaVector3.Better_Set(tempPos, position[1], position[2], position[3])
  local sqrDis = distance * distance
  for k, v in pairs(self.npcMap) do
    for i = 1, #v do
      if sqrDis >= _SqrDistance(v[i]:GetPosition(), tempPos) then
        action(v[i])
      end
    end
  end
end
function NSceneNpcProxy:FindNpcByUniqueId(uniqueId, filter)
  local list = {}
  for k, v in pairs(self.npcMap) do
    for i = 1, #v do
      local npc = v[i]
      if (nil == filter or filter(npc)) and uniqueId == npc.data.uniqueid then
        table.insert(list, npc)
      end
    end
  end
  return list
end
function NSceneNpcProxy:PickSingleNpc(filter)
  for k, v in pairs(self.npcMap) do
    for i = 1, #v do
      local npc = v[i]
      if nil == filter or filter(npc) then
        return npc
      end
    end
  end
end
function NSceneNpcProxy:PickNpcs(filter, tarList)
  local list = tarList or {}
  for k, v in pairs(self.npcMap) do
    for i = 1, #v do
      local npc = v[i]
      if nil == filter or filter(npc) then
        table.insert(list, npc)
      end
    end
  end
  return list
end
function NSceneNpcProxy:UpdateCamp(monstermap, camp)
  local campid = 1
  for npcStaticID, roles in pairs(self.npcMap) do
    for i = 1, #roles do
      local role = roles[i]
      if role and role.data then
        campid = monstermap[npcStaticID] and camp or 3 - camp
        if monstermap[npcStaticID] then
          role.data:Camp_SetIsInTwelveScene(false)
          role.data:Camp_SetIsInMyTeam(true)
        else
          role.data:Camp_SetIsInTwelveScene(true)
          role.data:Camp_SetIsInMyTeam(false)
        end
        if role.data:IsSiegeCar() then
          self.siegeCars[campid] = role.data.id
          local sceneUI = role:GetSceneUI()
          if sceneUI then
            sceneUI.roleTopUI:SetSiegeCarInfo(role, campid)
          end
        end
      end
    end
  end
end
function NSceneNpcProxy:SyncServerSkill(data)
  local petid = data.petid
  if petid ~= nil and petid > 0 then
    return self:SyncServerPetSkill(data)
  end
  return NSceneUserProxy.super.SyncServerSkill(self, data)
end
function NSceneNpcProxy:AddToDeadMap(guid)
  self.userMapDead[guid] = guid
end
function NSceneNpcProxy:AddToRemoveMap(guid)
  self.userMapRemove[guid] = guid
end
function NSceneNpcProxy:PrintNpcDeadRemoveMap()
  redlog("PrintNpcDeadRemoveMap ========== start ==========")
  local containsMap = {}
  local diffMap = {}
  local countDead = 0
  for k, v in pairs(self.userMapDead) do
    countDead = countDead + 1
    if TableUtility.TableFindKey(self.userMapRemove, k) then
      containsMap[k] = v
    else
      diffMap[k] = v
    end
  end
  local countContains = 0
  for k, v in pairs(containsMap) do
    countContains = countContains + 1
  end
  local countDiff = 0
  for k, v in pairs(diffMap) do
    redlog("[PrintNpcDeadRemoveMap diffMap ========== ]", k, v)
    countDiff = countDiff + 1
  end
  redlog("PrintNpcDeadRemoveMap containsMapCount = " .. countContains .. ", diffMapCount = " .. countDiff .. ", deadCount = " .. countDead)
  redlog("PrintNpcDeadRemoveMap ========== end ==========")
end
