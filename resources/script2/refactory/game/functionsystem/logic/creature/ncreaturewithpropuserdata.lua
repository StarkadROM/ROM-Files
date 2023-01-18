NCreatureWithPropUserdata = class("NCreatureWithPropUserdata", NCreature)
autoImport("NCreatureWithPropUserdata_Client")
local Table_Buffer = Table_Buffer
local Table_Body = Table_Body
local Table_Class = Table_Class
function NCreatureWithPropUserdata:ctor(aiClass)
  NCreatureWithPropUserdata.super.ctor(self, aiClass)
  self.userDataManager = nil
  self.propmanager = nil
end
function NCreatureWithPropUserdata:IsPhotoStatus()
  return self.data.userdata:Get(UDEnum.STATUS) == ProtoCommon_pb.ECREATURESTATUS_PHOTO
end
function NCreatureWithPropUserdata:IsDead()
  local status = self.data.userdata:Get(UDEnum.STATUS)
  return status == ProtoCommon_pb.ECREATURESTATUS_DEAD or status == ProtoCommon_pb.ECREATURESTATUS_INRELIVE
end
function NCreatureWithPropUserdata:IsInRevive()
  return self.data.userdata:Get(UDEnum.STATUS) == ProtoCommon_pb.ECREATURESTATUS_INRELIVE
end
function NCreatureWithPropUserdata:IsFakeDead()
  return self.data.userdata:Get(UDEnum.STATUS) == ProtoCommon_pb.ECREATURESTATUS_FAKEDEAD
end
function NCreatureWithPropUserdata:Server_SetUserDatas(serverUserdatas, init)
  local userdata = self.data.userdata
  local sdata
  local manager = self.userDataManager
  local oldValue
  for i = 1, #serverUserdatas do
    sdata = serverUserdatas[i]
    if sdata ~= nil then
      manager:SetUserData(init, self, userdata, sdata.type, sdata.value, sdata.data)
    end
  end
end
function NCreatureWithPropUserdata:Server_SetAttrs(serverAttrs)
  local props = self.data.props
  local sdata
  local manager = self.propmanager
  for i = 1, #serverAttrs do
    sdata = serverAttrs[i]
    if sdata ~= nil then
      manager:SetProp(self, props, sdata.type, sdata.value)
    end
  end
end
function NCreatureWithPropUserdata:SetVisible(v, reason)
  local assetRoleInVisible = self.assetRole:GetInvisible()
  NCreatureWithPropUserdata.super.SetVisible(self, v, reason)
  local hideBodyOnly = reason == LayerChangeReason.HideBodyOnly
  local nowAssetRoleInVisible = self.assetRole:GetInvisible()
  if nowAssetRoleInVisible ~= assetRoleInVisible then
    if self.buffs ~= nil then
      for k, buff in pairs(self.buffs) do
        if buff and buff:GetType() == Buff.Type.State then
          buff:SetEffectVisible(not nowAssetRoleInVisible)
        end
      end
    end
    if self.buffGroups ~= nil then
      for k, v in pairs(self.buffGroups) do
        v:SetEffectVisible(not nowAssetRoleInVisible)
      end
    end
    if not hideBodyOnly or not nowAssetRoleInVisible then
      if self.skill ~= nil then
        self.skill:SetEffectVisible(not nowAssetRoleInVisible)
      end
      if self.skillFreeCast ~= nil then
        self.skillFreeCast:SetEffectVisible(not nowAssetRoleInVisible)
      end
    elseif hideBodyOnly then
      if self.skill ~= nil then
        self.skill:SetEffectVisible(hideBodyOnly)
      end
      if self.skillFreeCast ~= nil then
        self.skillFreeCast:SetEffectVisible(hideBodyOnly)
      end
    end
  end
end
function NCreatureWithPropUserdata:OnBodyCreated()
  NCreatureWithPropUserdata.super.OnBodyCreated(self)
  if self.buffs ~= nil then
    for k, buff in pairs(self.buffs) do
      if buff and buff:GetType() == Buff.Type.State then
        buff:OnBodyCreated(self)
      end
    end
  end
end
function NCreatureWithPropUserdata:InitBuffs(serverData, needhit)
  local buffDatas = serverData.buffs
  if buffDatas then
    local buffData
    for i = 1, #buffDatas do
      buffData = buffDatas[i]
      self:AddBuff(buffData.id, true, needhit, buffData.fromid, buffData.layer, buffData.level, buffData.active, buffData.stateid)
    end
  end
end
local superUpdate = NCreatureWithPropUserdata.super.Update
function NCreatureWithPropUserdata:Update(time, deltaTime)
  superUpdate(self, time, deltaTime)
  if self.data.campChanged then
    self:HandleCampChange()
  end
end
function NCreatureWithPropUserdata:HandleCampChange()
  self.data.campChanged = false
  self:ResetClickPriority()
  if self.sceneui then
    self.sceneui.roleBottomUI:HandleCampChange(self)
  end
  EventManager.Me():PassEvent(CreatureEvent.Player_CampChange, self)
end
function NCreatureWithPropUserdata:NoAttackedByTarget(targetCreature)
  if self.attackBuffCheckMap then
    for buffID, v in pairs(self.attackBuffCheckMap) do
      if targetCreature:HasBuff(buffID) then
        return false
      end
    end
    return true
  end
  return false
end
function NCreatureWithPropUserdata:AddBuff(buffID, init, needhit, fromID, layer, level, active, stateid, maxLayer)
  if nil == buffID then
    return
  end
  local buffInfo = Table_Buffer[buffID]
  if nil == buffInfo then
    return
  end
  if needhit == nil then
    needhit = true
  end
  if not self.buffs or not self.buffs[buffID] then
    local buff
  end
  local buffStateID = self:GetBuffStateID(buffInfo, stateid, layer, fromID, active)
  if buff ~= nil and buffStateID ~= nil and buff.staticData ~= nil and buffStateID ~= buff.staticData.id then
    self:_RemoveBuff(buffID)
    buff = nil
  end
  if buff == nil then
    self.data:AddBuff(buffID, fromID, layer, level, active, true)
    self:TryHandleAddSpecialBuff(buffInfo, fromID)
    self:TryUpdateSpecialBuff(buffInfo, active, fromID, layer, maxLayer)
    if self.buffs == nil then
      self.buffs = {}
    end
    if nil ~= buffStateID and buffStateID > 0 and self.data:IsBuffStateValid(buffInfo) then
      buff = BuffState.Create(layer or 1, level or 0, active, buffStateID, buffID)
      if init then
        buff:Refresh(self)
      else
        buff:Start(self)
      end
      buff:SetEffectVisible(not self.assetRole:GetInvisible())
    else
      buff = Buff.Create(layer or 1, level or 0, active)
    end
    self.buffs[buffID] = buff
    if not buffInfo.BuffEffect or not buffInfo.BuffEffect.StateEffect then
      local stateEffect
    end
    if nil ~= stateEffect then
      local buffStateCount = self.buffStateCount
      if buffStateCount == nil then
        buffStateCount = {}
        self.buffStateCount = buffStateCount
      end
      local count = buffStateCount[stateEffect]
      if count == nil then
        count = 1
      else
        count = count + 1
      end
      buffStateCount[stateEffect] = count
    end
  else
    self.data:AddBuff(buffID, fromID, layer, level, active)
    self:TryUpdateSpecialBuff(buffInfo, active, fromID, layer, maxLayer)
    if needhit and buff:GetType() == Buff.Type.State then
      buff:Hit(self)
    end
    buff:SetLayer(layer or 1)
    buff:SetActive(active, self)
  end
  return buff
end
function NCreatureWithPropUserdata:GetBuffStateID(staticData, stateid, layer, fromID, active)
  local dynamic = Game.SkillDynamicManager:GetDynamicBuff(fromID ~= 0 and fromID or self.data.id, staticData.id)
  if dynamic ~= nil then
    return dynamic
  end
  if stateid ~= nil and stateid ~= 0 then
    return stateid
  end
  local buffeffect = staticData.BuffEffect
  if buffeffect ~= nil then
    local layerState = buffeffect.LayerState
    if layerState ~= nil then
      local maxLayer = 0
      layer = layer or 1
      for k, v in pairs(layerState) do
        if k > maxLayer and k <= layer then
          maxLayer = k
        end
      end
      return layerState[maxLayer]
    end
    local layerStateSelf = buffeffect.LayerState_self
    if layerStateSelf ~= nil then
      local maxLayer = 0
      layer = layer or 1
      for k, v in pairs(layerStateSelf) do
        if k > maxLayer and k <= layer then
          maxLayer = k
        end
      end
      return layerStateSelf[maxLayer]
    end
    local conditonBuffState = buffeffect.condition_buffstate
    if conditonBuffState then
      if active then
        return conditonBuffState[1]
      else
        return conditonBuffState[2]
      end
    end
  end
  return staticData.BuffStateID
end
function NCreatureWithPropUserdata:TryHandleAddSpecialBuff(buffInfo, fromID)
  if buffInfo then
    local buffeffect = buffInfo.BuffEffect
    if buffeffect.weak_freeze ~= nil and buffeffect.weak_freeze == 1 then
      self.data:_AddWeakFreezeSkillBuff(buffInfo, buffeffect.id)
      if self.data:WeakFreeze() then
        self:Logic_Freeze(true)
      end
    end
    local buffType = buffeffect.type
    if buffType == BuffType.RideWolf then
      self:Logic_RideAction(true, RideActionReason.RideWolf)
    elseif buffType == BuffType.NoRelive then
      self:Client_NoRelive(1)
    elseif buffType == BuffType.ClientHide then
      self:SetClientStealth(true, buffeffect.stealthColor)
    elseif buffType == BuffType.CanMoveUseSkill then
      local cType = NCreature.ConcurrentType.Normal
      if buffeffect.rotateonly then
        cType = NCreature.ConcurrentType.RotateOnly
      end
      self:SetAllowConcurrent(cType, buffeffect.skillids)
      if buffeffect.anglespeed then
        self.logicTransform:SetRotateSpeed(buffeffect.anglespeed)
      end
    elseif buffType == BuffType.CanAttackedBy then
      if not self.attackBuffCheckMap then
        self.attackBuffCheckMap = {}
      end
      for k, v in pairs(buffeffect.buffIds) do
        self.attackBuffCheckMap[v] = 1
      end
    elseif buffType == BuffType.BeTaunt then
      self:Logic_BeTaunt(true, fromID)
    elseif buffType == BuffType.HandStatus then
      self:Client_AddHugRole(buffeffect.npcId)
    elseif buffType == BuffType.Clearautolock then
      self.data:SetNoAutoLock(buffeffect.value == 1)
      EventManager.Me():DispatchEvent(SkillEvent.ClearLockTarget, self)
    end
  end
end
function NCreatureWithPropUserdata:RemoveBuff(buffID)
  if nil == buffID then
    return
  end
  if self.buffs ~= nil then
    local buff = self.buffs[buffID]
    if buff then
      self:_RemoveBuff(buffID)
      local buffInfo = Table_Buffer[buffID]
      if nil == buffInfo then
        return
      end
      self.data:RemoveBuff(buffID)
      self:TryHandleRemoveSpecialBuff(buffInfo)
      self:TryUpdateSpecialBuff(buffInfo, false)
      if not buffInfo.BuffEffect or not buffInfo.BuffEffect.StateEffect then
        local stateEffect
      end
      if nil ~= stateEffect then
        local buffStateCount = self.buffStateCount
        if buffStateCount ~= nil then
          local count = buffStateCount[stateEffect]
          if count then
            count = count - 1
            buffStateCount[stateEffect] = count
          end
        end
      end
    end
  end
end
function NCreatureWithPropUserdata:_RemoveBuff(buffID)
  local buff = self.buffs[buffID]
  if buff == nil then
    return
  end
  if buff:GetType() == Buff.Type.State then
    buff:End(self)
  end
  buff:Destroy()
  self.buffs[buffID] = nil
end
function NCreatureWithPropUserdata:TryHandleRemoveSpecialBuff(buffInfo)
  if nil == buffInfo then
    return
  end
  local buffeffect = buffInfo.BuffEffect
  if buffeffect.weak_freeze ~= nil and buffeffect.weak_freeze == 1 then
    self.data:_RemoveWeakFreezeSkillBuff(buffInfo, buffeffect.id)
    if not self.data:WeakFreeze() then
      self:Logic_Freeze(0 < self.data.props:GetPropByName("Freeze"):GetValue())
    end
  end
  local buffType = buffeffect.type
  if buffType == BuffType.RideWolf then
    self:Logic_RideAction(false, RideActionReason.RideWolf)
  elseif buffType == BuffType.NoRelive then
    self:Client_NoRelive(-1)
    if not self.data:NoRelive() then
      GameFacade.Instance:sendNotification(PlayerEvent.BuffChange, self.data.id)
    end
  elseif buffType == BuffType.ClientHide then
    self:SetClientStealth(false, buffeffect.stealthColor)
  elseif buffType == BuffType.CanMoveUseSkill then
    if buffeffect.anglespeed then
      self.logicTransform:SetRotateSpeed(self.data:ReturnRotateSpeedWithFactor())
    end
    if buffeffect.rotateonly then
      self.logicTransform:StopRotation()
      self:Client_StopNotifyServerAngleY()
    end
    self:SetAllowConcurrent(false)
  elseif buffType == BuffType.BeTaunt then
    self:Logic_BeTaunt(false)
  elseif buffType == BuffType.HandStatus then
    self:Client_RemoveHugRole()
  elseif buffType == BuffType.CanAttackedBy then
    if self.attackBuffCheckMap then
      for k, v in pairs(buffeffect.buffIds) do
        self.attackBuffCheckMap[k] = nil
      end
    end
  elseif buffType == BuffType.Dirlndicator then
    if self == Game.Myself then
      self:ClearContractEffects()
    end
  elseif buffType == BuffType.Clearautolock then
    self.data:SetNoAutoLock(nil)
  end
end
function NCreatureWithPropUserdata:TryUpdateSpecialBuff(buffInfo, active, fromID, layer, maxLayer)
  local buffeffect = buffInfo.BuffEffect
  local buffType = buffeffect.type
  if buffType == BuffType.AttrChange then
    local attrEffect = buffeffect.AttrEffect
    if attrEffect ~= nil then
      local isUpdate = false
      for i = 1, #attrEffect do
        if attrEffect[i] == 11 then
          isUpdate = true
          break
        end
      end
      if isUpdate then
        self:Logic_RideAction(active, RideActionReason.BattleInRiding)
      end
    end
  elseif buffType == BuffType.DynamicSkillConfig then
    if active then
      self.data:_DynamicSkillConfigAdd(buffeffect)
    else
      self.data:_DynamicSkillConfigRemove(buffeffect)
    end
  elseif buffType == BuffType.Dirlndicator then
    if self == Game.Myself then
      if active then
        self:SetDragonContractEffect(fromID)
      else
        self:RemoveContractEffect(fromID)
      end
    end
  elseif buffType == BuffType.Clearautolock then
    self.data:SetNoAutoLock(active)
  elseif buffType == BuffType.Remould then
    if active then
      self.data:UpdateBuffHpVals(layer, maxLayer or 1)
    else
      self.data:UpdateBuffHpVals(nil, nil)
    end
    local ui = self:GetSceneUI()
    if ui then
      ui.roleBottomUI:SetHp(self)
    end
    EventManager.Me():PassEvent(CreatureEvent.BuffHpChange, self)
  elseif buffType == BuffType.RotateSelf then
    if active then
      self:Logic_Spin(buffeffect.duration, buffeffect.speed)
    else
      self:Logic_SpinEnd()
    end
  end
end
function NCreatureWithPropUserdata:RegisterBuffGroup(buff)
  local groupID = buff.staticData.GroupID
  if groupID ~= nil then
    if self.buffGroups == nil then
      self.buffGroups = {}
    end
    local group = self.buffGroups[groupID]
    if group == nil then
      group = BuffGroup.Create()
      group:SetEffectVisible(not self.assetRole:GetInvisible())
      self.buffGroups[groupID] = group
    end
    group:RegisterBuff(self, buff)
  end
end
function NCreatureWithPropUserdata:UnRegisterBuffGroup(buff)
  local groupID = buff.staticData.GroupID
  if groupID ~= nil and self.buffGroups ~= nil then
    local group = self.buffGroups[groupID]
    if group ~= nil then
      group:UnRegisterBuff(self, buff)
      if group:GetBuffCount() == 0 then
        group:Destroy()
        self.buffGroups[groupID] = nil
      end
    end
  end
end
function NCreatureWithPropUserdata:GetBuffLayer(buffID)
  if self.buffs ~= nil and buffID ~= nil then
    local buff = self.buffs[buffID]
    if buff ~= nil then
      return buff:GetLayer()
    end
  end
  return 0
end
function NCreatureWithPropUserdata:HasBuff(buffID)
  if self.buffs ~= nil and buffID ~= nil then
    return self.buffs[buffID] ~= nil
  end
  return false
end
function NCreatureWithPropUserdata:HasBuffs(buffIDs)
  local buffs = self.buffs
  if buffs ~= nil and buffIDs ~= nil then
    for i = 1, #buffIDs do
      if buffs[buffIDs[i]] ~= nil then
        return true
      end
    end
  end
  return false
end
function NCreatureWithPropUserdata:HasBuffStates(buffStateIDs)
  local buffStateCount = self.buffStateCount
  if buffStateCount ~= nil and buffStateIDs ~= nil then
    local count
    for i = 1, #buffStateIDs do
      count = buffStateCount[buffStateIDs[i]]
      if count ~= nil and count > 0 then
        return true
      end
    end
  end
  return false
end
function NCreatureWithPropUserdata:GetBuffActive(buffID)
  if buffID ~= nil and self.buffs ~= nil then
    local buff = self.buffs[buffID]
    if buff ~= nil then
      return buff:GetActive()
    end
  end
  return false
end
function NCreatureWithPropUserdata:GetBuffLevel(buffID)
  if buffID ~= nil and self.buffs ~= nil then
    local buff = self.buffs[buffID]
    if buff ~= nil then
      return buff:GetLevel()
    end
  end
  return 0
end
function NCreatureWithPropUserdata:ClearBuff()
  if self.buffs ~= nil then
    for k, v in pairs(self.buffs) do
      v:Destroy()
      self.buffs[k] = nil
    end
  end
  if self.buffStateCount ~= nil then
    for k, v in pairs(self.buffStateCount) do
      self.buffStateCount[k] = nil
    end
  end
  if self.buffGroups ~= nil then
    for k, v in pairs(self.buffGroups) do
      v:Destroy()
      self.buffGroups[k] = nil
    end
  end
  self.attackBuffCheckMap = nil
end
function NCreatureWithPropUserdata:UpdateMultiMountStatus()
  Game.InteractNpcManager:UpdateMultiMountStatus(self)
end
function NCreatureWithPropUserdata:HandlerAssetRoleSuffixMap()
  local userdata = self.data.userdata
  if userdata == nil then
    return
  end
  local buffEffect = self.data:GetBuffEffectByType(BuffType.ProfessionTransform)
  local profess = buffEffect ~= nil and buffEffect.classid or userdata:Get(UDEnum.PROFESSION)
  if profess == nil or profess == 0 then
    return
  end
  local classData, suffixMapToSet = Table_Class[profess], nil
  if classData and classData.ActionSuffixMap and next(classData.ActionSuffixMap) then
    local bodyId = userdata:Get(UDEnum.BODY) or 0
    local classBody = userdata:Get(UDEnum.SEX) == 1 and classData.MaleBody or classData.FemaleBody
    local bodyData = Table_Body[bodyId]
    if bodyData then
      if classData.Feature and 0 < classData.Feature & 2 and bodyId ~= classBody and TableUtility.ArrayFindIndex(GameConfig.Dual, bodyId) == 0 then
        suffixMapToSet = nil
      elseif bodyData.Feature and 0 < bodyData.Feature & 1 then
        suffixMapToSet = classData.ActionSuffixMap
      end
    end
  end
  if self.assetRole then
    self.assetRole:SetSuffixReplaceMap(suffixMapToSet)
  end
end
function NCreatureWithPropUserdata:DoDeconstruct(asArray)
  if self.data then
    self.data:ClearClientForceDressParts()
  end
  Game.SkillDynamicManager:Clear(self.data.id)
  NCreatureWithPropUserdata.super.DoDeconstruct(self, asArray)
  self:ClearBuff()
end
function NCreatureWithPropUserdata:Client_StopNotifyServerAngleY()
end
