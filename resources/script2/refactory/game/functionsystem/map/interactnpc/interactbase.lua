InteractBase = class("InteractBase", ReusableObject)
InteractBase.PoolSize = 5
local tempArgs = {
  [1] = nil,
  [2] = nil
}
local TableClear = TableUtility.TableClear
local LayerChangeReasonInteractNpc = LayerChangeReason.InteractNpc
local PUIVisibleReasonInteractNpc = PUIVisibleReason.InteractNpc
function InteractBase.GetArgs(staticData, id)
  tempArgs[1] = staticData
  tempArgs[2] = id
  return tempArgs
end
function InteractBase:ctor()
  self.cpMap = {}
end
function InteractBase:Update(time, deltaTime)
  return false
end
function InteractBase:RequestGetOn(cpid, charid)
  self:GetOn(cpid, charid)
end
function InteractBase:RequestGetOff(charid)
  self:GetOff(charid)
end
function InteractBase:GetOn(cpid, charid)
  if self.cpMap[cpid] == charid then
    return
  end
  local npc = self:GetNpc()
  if npc == nil then
    return
  end
  local cpTransform = self:GetCP(npc, cpid)
  if cpTransform == nil then
    return
  end
  local creature = self:GetCreature(charid)
  if creature == nil or not creature:HasAllPartLoaded() then
    self:AddWatchPlayerGuid(charid, cpid)
    return
  end
  self:AddCpCount(cpid)
  self.cpMap[cpid] = charid
  creature:SetParent(cpTransform)
  creature:Logic_SetAngleY(0, true)
  creature:Logic_LockRotation(true)
  local assetRole = creature.assetRole
  assetRole:SetShadowEnable(false)
  assetRole:SetMountDisplay(false)
  assetRole:SetWingDisplay(false)
  assetRole:SetTailDisplay(false)
  creature:SetPeakEffectVisible(false, LayerChangeReasonInteractNpc)
  local FunctionPlayerUI = FunctionPlayerUI.Me()
  FunctionPlayerUI:MaskBloodBar(creature, PUIVisibleReasonInteractNpc)
  FunctionPlayerUI:MaskNameHonorFactionType(creature, PUIVisibleReasonInteractNpc)
  local partner = creature.partner
  if partner ~= nil then
    partner:SetVisible(false, LayerChangeReasonInteractNpc)
  end
  local actionID = self.staticData.MountInfo[cpid]
  if actionID ~= nil then
    local actionInfo = Table_ActionAnime[actionID]
    if actionInfo == nil then
      return
    end
    self:PlayOnAction(creature, actionInfo.Name)
  end
end
function InteractBase:GetOff(charid)
  self:RemoveWatchPlayerGuid(charid)
  for k, v in pairs(self.cpMap) do
    if v == charid then
      self.cpMap[k] = nil
      self:MinusCpCount(k)
      break
    end
  end
  local creature = self:GetCreature(charid)
  if creature == nil then
    return
  end
  creature:Logic_LockRotation(false)
  creature:SetParent(nil, true)
  creature:Logic_NavMeshPlaceTo(creature:GetPosition())
  local assetRole = creature.assetRole
  assetRole:SetShadowEnable(true)
  assetRole:SetMountDisplay(true)
  assetRole:SetWingDisplay(true)
  assetRole:SetTailDisplay(true)
  creature:SetPeakEffectVisible(true, LayerChangeReasonInteractNpc)
  local FunctionPlayerUI = FunctionPlayerUI.Me()
  FunctionPlayerUI:UnMaskBloodBar(creature, PUIVisibleReasonInteractNpc)
  FunctionPlayerUI:UnMaskNameHonorFactionType(creature, PUIVisibleReasonInteractNpc)
  local partner = creature.partner
  if partner ~= nil then
    partner:SetVisible(true, LayerChangeReasonInteractNpc)
  end
  self:PlayOffAction(creature)
end
function InteractBase:TryNotifyGetOn(param)
  return false
end
function InteractBase:TryNotifyGetOff()
  return false
end
function InteractBase:GetNpc()
  return nil
end
function InteractBase:GetCreature(charid)
  return SceneCreatureProxy.FindCreature(charid)
end
function InteractBase:GetCP(npc, cpid)
  return nil
end
function InteractBase:IsNotifyChange()
  return false
end
function InteractBase:IsAuto()
  return false
end
function InteractBase:GetCharid(cpid)
  return self.cpMap[cpid]
end
function InteractBase:GetCPMap()
  return self.cpMap
end
function InteractBase:IsFull()
  return self.cpCount >= self.cpMaxCount
end
function InteractBase:IsEmpty()
  return self.cpCount < 1
end
function InteractBase:PlayOnAction(creature, name)
  creature:Client_PlayAction2(name, nil, true)
end
function InteractBase:PlayOffAction(creature)
  creature:Logic_PlayAction_Idle()
end
function InteractBase:RequestGetOffAll()
  for k, v in pairs(self.cpMap) do
    self:RequestGetOff(v)
  end
end
function InteractBase:AddCpCount(cpid)
  self.cpCount = self.cpCount + 1
end
function InteractBase:MinusCpCount(cpid)
  self.cpCount = self.cpCount - 1
end
function InteractBase:DoConstruct(asArray, data)
  self.staticData = data[1]
  self.id = data[2]
  self.cpCount = 0
  local count = 0
  if self.staticData.MountInfo then
    for k, v in pairs(self.staticData.MountInfo) do
      count = count + 1
    end
  end
  self.cpMaxCount = count
  self.watchPlayerGuids = {}
  self.watchPlayerCount = 0
end
function InteractBase:DoDeconstruct(asArray)
  self.staticData = nil
  self.id = nil
  self.cpCount = nil
  self.cpMaxCount = nil
  TableClear(self.cpMap)
  TableClear(self.watchPlayerGuids)
  self.watchPlayerCount = 0
  EventDispatcherRobust.Me():RemoveEventListener(CreatureEvent.OnAllPartLoaded, self.OnSceneUserAddedOrLoaded, self)
end
function InteractBase:AddWatchPlayerGuid(guid, cpid)
  if guid and cpid and not self.watchPlayerGuids[guid] then
    self.watchPlayerGuids[guid] = cpid
    self.watchPlayerCount = self.watchPlayerCount + 1
    if self.watchPlayerCount == 1 then
      EventDispatcherRobust.Me():AddEventListener(CreatureEvent.OnAllPartLoaded, self.OnSceneUserAddedOrLoaded, self)
    end
  end
end
function InteractBase:RemoveWatchPlayerGuid(guid)
  if guid and self.watchPlayerGuids[guid] then
    self.watchPlayerGuids[guid] = nil
    self.watchPlayerCount = self.watchPlayerCount - 1
    if self.watchPlayerCount <= 0 then
      self.watchPlayerCount = 0
      EventDispatcherRobust.Me():RemoveEventListener(CreatureEvent.OnAllPartLoaded, self.OnSceneUserAddedOrLoaded, self)
    end
  end
end
function InteractBase:OnSceneUserAddedOrLoaded(guid)
  if guid then
    local cpid = self.watchPlayerGuids[guid]
    if cpid then
      self:RemoveWatchPlayerGuid(guid)
      self:GetOn(cpid, guid)
    end
  end
end
