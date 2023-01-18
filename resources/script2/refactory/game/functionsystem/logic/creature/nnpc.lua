autoImport("Creature_SceneUI")
NNpc = reusableClass("NNpc", NCreatureWithPropUserdata)
NNpc.PoolSize = 100
autoImport("NNpc_Effect")
autoImport("NNpc_Logic")
local Table_Monster = Table_Monster
local Table_Npc = Table_Npc
local Table_ActionAnime = Table_ActionAnime
local ForceRemoveDelay = 3
local SmoothRemoveDuration = 0.3
local MonsterDressDisableDistanceLevel = 1
local ActionForceDurationConfig = {
  [250010] = {
    [Asset_Role.ActionName.FunctionalShow] = 21.667,
    [Asset_Role.ActionName.FunctionalShow2] = 12.233
  },
  [250310] = {
    [Asset_Role.ActionName.FunctionalShow] = 5.0
  },
  [270300] = {
    [Asset_Role.ActionName.FunctionalShow] = 5.0
  }
}
function NNpc:ctor(aiClass)
  NNpc.super.ctor(self, aiClass)
  self.sceneui = nil
  self.userDataManager = Game.LogicManager_Npc_Userdata
  self.propmanager = Game.LogicManager_Npc_Props
  self.skill = ServerSkill.new()
  self.originalRotation = nil
end
function NNpc:GetCreatureType()
  return Creature_Type.Npc
end
function NNpc:GetSceneUI()
  return self.sceneui
end
function NNpc:Server_SetDirCmd(mode, dir, noSmooth)
  if mode == AI_CMD_SetAngleY.Mode.SetAngleY then
    self.originalRotation = dir
  end
  self.ai:PushCommand(FactoryAICMD.GetSetAngleYCmd(mode, dir, noSmooth), self)
end
function NNpc:Server_GetOnInteractNpc(mountid, charid)
  Game.InteractNpcManager:AddMountInter(self.data.id, mountid, charid)
end
function NNpc:RegisterInteractNpc()
  if self.data.staticData then
    local interactConfig = Table_InteractNpc[self.data.staticData.id]
    if interactConfig and interactConfig.Type == InteractNpc.InteractType.SceneObject then
      return
    end
    Game.InteractNpcManager:RegisterInteractNpc(self.data.staticData.id, self.data.id)
  end
end
function NNpc:UnregisterInteractNpc()
  Game.InteractNpcManager:UnregisterInteractNpc(self.data.id)
end
function NNpc:Server_PlayActionCmd(name, normalizedTime, loop, fakeDead, forceDuration, freezeAtEnd)
  local config = ActionForceDurationConfig[self.data.staticData.id]
  if config and not forceDuration then
    forceDuration = config[name]
  end
  NNpc.super.Server_PlayActionCmd(self, name, normalizedTime, loop, fakeDead, forceDuration, freezeAtEnd)
end
function NNpc:InitAssetRole()
  if self.data.id == 812725 then
    redlog("InitAssetRole", self.data.id)
  end
  NNpc.super.InitAssetRole(self)
  local assetRole = self.assetRole
  assetRole:SetGUID(self.data.id)
  assetRole:SetName(self.data:GetOriginName())
  assetRole:SetClickPriority(self.data:GetClickPriority())
  local sData = self.data.staticData
  if sData == nil then
    return
  end
  local shadowOff = sData.shadow == 1 or sData.move == 1
  if shadowOff then
    assetRole:SetShadowEnable(false)
  else
    assetRole:SetShadowEnable(true)
  end
  assetRole:SetColliderEnable(not self.data:NoAccessable())
  assetRole:SetInvisible(false)
  assetRole:SetWeaponDisplay(true)
  assetRole:SetMountDisplay(true)
  assetRole:SetRenderEnable(true)
  assetRole:SetActionSpeed(1)
  assetRole:SetNpcDefaultExpression(sData.DefaultExpression, sData.ReplaceActionExpresssion)
  if self.data and self.data.staticData then
    local scDis = self.data.staticData.ShadowCastDistance
    if scDis then
      assetRole:EnableShadowCastCheck(LuaGeometry.GetTempVector3(scDis[1], scDis[2], scDis[3]))
    end
  end
  if self.data.staticData.id == GameConfig.GVGConfig.StatueNpcID then
    assetRole:SetIgnoreExpression()
    assetRole:SetIgnoreColor()
    assetRole:SetShaderInfo("RO/SP/PartOutlineMatcap", "Public/Shader", "RolePartOutlineSPMatcap", ResourcePathHelper.ModelMainTexture("pub_gold_matcap"), "_SPMatcapMap")
  end
end
function NNpc:InitLogicPos(x, y, z)
  if self.data:GetFeature_IgnoreNavmesh() then
    self:Logic_PlaceXYZTo(x, y, z)
  else
    self:Logic_NavMeshPlaceXYZTo(x, y, z)
  end
end
function NNpc:InitAction(serverData)
  local data = self.data
  local assetRole = self.assetRole
  if serverData.isbirth and data.staticData then
    local BirthTime = data.staticData.BirthTime
    if BirthTime and BirthTime > 0 then
      self:Server_PlayActionCmd(Asset_Role.ActionName.Born, nil, false, false, BirthTime)
      return true
    end
  end
  local actionid = serverData.motionactionid
  if actionid and actionid ~= 0 then
    local actionData = Table_ActionAnime[actionid]
    if actionData then
      assetRole:PlayAction_Simple(actionData.Name)
      self.ai:SetNoIdleAction()
      return true
    end
  end
  local puzzlemotionid = serverData.puzzlemotionid
  if puzzlemotionid and puzzlemotionid ~= 0 then
    local actionData = Table_ActionAnime[puzzlemotionid]
    if actionData then
      assetRole:PlayAction_Simple(actionData.Name)
      self.ai:SetNoIdleAction()
      return true
    end
  end
  local defaultGear = data:GetDefaultGear()
  if defaultGear ~= nil then
    local actionName = string.format("state%d", defaultGear)
    assetRole:PlayAction_Simple(actionName)
    return true
  end
  local timeControlGear = data:GetTimeControlGear()
  if timeControlGear ~= nil then
    local actionName = string.format("state%d", timeControlGear)
    assetRole:PlayAction_Simple(actionName)
    self.ai:SetNoIdleAction()
    return true
  end
  if data.staticData.id == GameConfig.GVGConfig.StatueNpcID then
    GvgProxy.Instance:UpdateStatuePose(nil, self)
  end
  return false
end
function NNpc:InitTextMesh()
  local config = GameConfig.TextMesh
  if config ~= nil then
    local data = self.data
    local info = config[data.staticData.id]
    if info ~= nil then
      local effect = info.effect
      if effect ~= nil then
        Game.GameObjectManagers[Game.GameObjectType.TextMesh]:SpawnEffect(self, effect, data.name, 0, true, true)
      end
      local model = info.model
      if model ~= nil then
        local text = data.name
        if data:IsGvgStatuePedestal() then
          local info = GvgProxy.Instance:GetStatueInfo()
          text = info and info.guildname or ""
        end
        local body = self.assetRole:GetPartObject(Asset_Role.PartIndex.Body)
        if body ~= nil then
          Game.GameObjectManagers[Game.GameObjectType.TextMesh]:SpawnModel(body.gameObject, text)
        end
      end
    end
  end
end
function NNpc:ClearTextMesh()
  local config = GameConfig.TextMesh
  if config ~= nil then
    local info = config[self.data.staticData.id]
    if info ~= nil then
      local model = info.model
      if model ~= nil then
        local body = self.assetRole:GetPartObject(Asset_Role.PartIndex.Body)
        if body ~= nil then
          Game.GameObjectManagers[Game.GameObjectType.TextMesh]:Clear(body.gameObject:GetInstanceID())
        end
      end
    end
  end
end
function NNpc:HandlerAssetRoleSuffixMap()
  if self.data:IsCopyNpc_Detail() or self.data:IsFollowMaster_Detail() then
    NNpc.super.HandlerAssetRoleSuffixMap(self)
  end
end
function NNpc:SetDressEnable(v)
end
function NNpc:GetDressParts()
  if not self:IsDressEnable() then
    return NSceneNpcProxy.Instance:GetNpcEmptyParts(), true
  end
  local parts = self.data:GetDressParts()
  return parts, not self.data.useServerDressData
end
local superServer_SetPosCmd = NNpc.super.Server_SetPosCmd
function NNpc:Server_SetPosCmd(p, ignoreNavMesh)
  superServer_SetPosCmd(self, p, self.data:GetFeature_IgnoreNavmesh())
end
local superServer_MoveToCmd = NNpc.super.Server_MoveToCmd
function NNpc:Server_MoveToCmd(p, ignoreNavMesh, endCallback)
  superServer_MoveToCmd(self, p, self.data:GetFeature_IgnoreExtraNavmesh(), endCallback)
end
function NNpc:Init(serverData)
  self:InitAssetRole()
  self:InitLogicTransform(serverData.pos.x, serverData.pos.y, serverData.pos.z, nil, 1)
  if self.data.id == 812725 then
    redlog("InitLogicTransform", self.data.id, serverData.pos.x, serverData.pos.y, serverData.pos.z)
  end
  self:Server_SetUserDatas(serverData.datas, true)
  self:Server_SetAttrs(serverData.attrs)
  self.sceneui = Creature_SceneUI.CreateAsTable(self)
  self.sceneui.roleBottomUI:HandleChangeTitle(self)
  self.data:RefreshNightmareStatus()
  self:InitAction(serverData)
  self.bosstype = serverData.bosstype
  self:InitBuffs(serverData)
  local color = self.data:HasOutline()
  if color then
    self.assetRole:AddOutlineProcess()
    self:RegisterInsightNpc()
  end
  local dest = serverData.dest
  if dest and not PosUtil.IsZero(dest) then
    self:Server_MoveToXYZCmd(dest.x, dest.y, dest.z, 1000)
  end
  local npc = Table_Monster[serverData.npcID] or Table_Npc[serverData.npcID]
  if npc and npc.SE then
    self.assetRole:PlaySEOneShotOn(npc.SE[math.random(1, #npc.SE)])
  end
  if serverData.fadein and serverData.fadein > 0 and self.assetRole then
    self.assetRole:SetSmoothDisplayBody(0)
    local to = self.data.userdata:Get(UDEnum.ALPHA) or 1
    self.assetRole:AlphaFromTo(0, to, serverData.fadein / 1000)
  end
  self:RegisterInteractNpc()
  local mounts = serverData.mounts
  if mounts then
    for i = 1, #mounts do
      self:Server_GetOnInteractNpc(mounts[i].mountid, mounts[i].charid)
    end
  end
  HomeManager.Me():SetRelativeCreature(self.data:GetRelativeFurnitureID(), self.data.id)
  self:UpdateWithRelativeFurniture()
end
function NNpc:ShowViewRange(range)
  if nil == self.effectControllerViewRange then
    self.effectControllerViewRange = ViewRangeEffect.CreateAsTable(self.data.id)
  end
  if nil ~= self.effectControllerViewRange then
    self.effectControllerViewRange:ShowRange(range)
  end
end
function NNpc:ParseServerData(serverData)
  return NpcData.CreateAsTable(serverData)
end
function NNpc:SetDeadTime()
  if self.deadTimeFlag ~= nil then
    return
  end
  self.deadTimeFlag = UnityTime + (GameConfig.MonsterBodyDisappear.DeadDispTime[self.data.staticData.id] or ForceRemoveDelay)
end
function NNpc:SetDelayRemove(delayTime, duration)
  if nil ~= self.delayRemoveTimeFlag then
    return
  end
  self.smoothRemoving = false
  if delayTime then
    self:SetClickable(false)
    self.delayRemoveTimeFlag = UnityTime + delayTime
    self.fadeOutRemoveDuration = duration or SmoothRemoveDuration
  else
    self.delayRemoveTimeFlag = nil
    self.fadeOutRemoveDuration = nil
  end
  if self.data and self.data:GetPushableObjID() then
    RaidPuzzleManager.Me():RemovePushObject(self)
  end
end
local superUpdate = NNpc.super.Update
function NNpc:Update(time, deltaTime)
  superUpdate(self, time, deltaTime)
  if self.delayRemoveTimeFlag ~= nil and time >= self.delayRemoveTimeFlag then
    if not self.smoothRemoving then
      if nil ~= self.forceRemoveTimeFlag then
        if time < self.forceRemoveTimeFlag and self.ai:IsDiePending() then
          return
        end
      elseif self.ai:IsDiePending() then
        self.forceRemoveTimeFlag = time + ForceRemoveDelay
        return
      end
      self.smoothRemoving = true
      local duration = self.fadeOutRemoveDuration or SmoothRemoveDuration
      self.delayRemoveTimeFlag = self.delayRemoveTimeFlag + duration
      self.assetRole:AlphaTo(0, duration)
    else
      self:_DelayDestroy()
    end
  end
  if self.deadTimeFlag ~= nil and time >= self.deadTimeFlag and self.assetRole ~= nil then
    NSceneNpcProxy.Instance:RemoveNpc(self)
    self:_DelayDestroy()
  end
end
function NNpc:_DelayDestroy()
  if not NSceneNpcProxy.Instance:RealRemove(self.data.id, true) then
    self:Destroy()
  end
end
function NNpc:GetDressDisableDistanceLevel()
  if self.data:IsMonster() then
    return self.data.staticData.DistanceLevel or MonsterDressDisableDistanceLevel
  end
  return NNpc.super.GetDressDisableDistanceLevel(self)
end
function NNpc:TrySetComodoBuildingData()
  if not self.data then
    return
  end
  if Game.MapManager:GetRaidID() ~= GameConfig.Manor.RaidID then
    return
  end
  if not ComodoBuildingProxy.CheckHasProduceTopUi(self.data.staticData.id) then
    return
  end
  local sceneUi = self:GetSceneUI()
  if sceneUi then
    sceneUi.roleTopUI:UpdateComodoBuildingProduce()
  end
end
function NNpc:SetSkillNpc(skillConfig)
  if skillConfig then
    self.sourceSkill = skillConfig
    local funcType = skillConfig.Logic_Param.function_type
    if funcType == "Bi_Transport" then
      self:_AddSkillTransportTrigger()
    end
  else
    self:_EndSkillNpc()
  end
end
function NNpc:_EndSkillNpc()
  if self.sourceSkill then
    local funcType = self.sourceSkill.Logic_Param.function_type
    if funcType == "Bi_Transport" then
      self:_RemoveSkillTransportTrigger()
    end
    self.sourceSkill = nil
  end
end
local triggerData = {}
function NNpc:_AddSkillTransportTrigger()
  triggerData.id = self.data.id
  triggerData.type = AreaTrigger_Skill.Transport
  triggerData.creature = self
  triggerData.reachDis = self.sourceSkill.Logic_Param.range
  local trigger = SkillAreaTrigger.CreateAsTable(triggerData)
  Game.AreaTrigger_Skill:AddCheck(trigger)
  TableUtility.TableClear(triggerData)
end
function NNpc:_RemoveSkillTransportTrigger()
  Game.AreaTrigger_Skill:RemoveCheck(self.data.id)
end
function NNpc:UpdateWithRelativeFurniture()
  local furnitureID = self.data:GetRelativeFurnitureID()
  if not HomeManager.Me():IsAtHome() or StringUtil.IsEmpty(furnitureID) then
    return
  end
  local nFurniture = HomeManager.Me():FindFurniture(furnitureID)
  if nFurniture then
    self:Logic_LockRotation(false)
    self.logicTransform:SetAngleY(nFurniture.assetFurniture:GetEulerAnglesY())
  end
  self:Logic_LockRotation(true)
end
function NNpc:GetBossType()
  return self.bosstype
end
function NNpc:SetForceUpdate(b)
  self.ai:SetForceUpdate(b)
end
function NNpc:LookAt(p)
  if self.data:GetFeature_IgnoreLookAt() then
    return
  end
  NNpc.super.LookAt(self, p)
end
function NNpc:OnPartCreated(part)
  NNpc.super.OnPartCreated(self, part)
  local partner = self.partner
  if partner ~= nil then
    partner:OnMasterPartCreated(self, part)
  end
end
function NNpc:OnBodyCreated()
  NNpc.super.OnBodyCreated(self)
  self:InitTextMesh()
end
function NNpc:RegisterInsightNpc()
  local staticData = self.data and self.data.staticData
  if staticData and staticData.OutlineColor then
    Game.GameObjectManagers[Game.GameObjectType.InsightGO]:AddNPC(self.data.id, staticData.OutlineMenuID, self.assetRole.outline, self.data.staticData.id, staticData.OutlineColor.color)
  end
end
function NNpc:UnregisterInsightNpc()
  local staticData = self.data and self.data.staticData
  if staticData and staticData.OutlineColor then
    Game.GameObjectManagers[Game.GameObjectType.InsightGO]:RemoveNPC(self.data.id)
  end
end
function NNpc:IsRobotNpc()
  return self.data:IsRobotNpc()
end
function NNpc:DoConstruct(asArray, serverData)
  if serverData.id == 812725 then
    redlog("NNpc:DoConstruct", serverData.id)
  end
  self:CreateWeakData()
  local data = self:ParseServerData(serverData)
  NNpc.super.DoConstruct(self, asArray, data)
  self:Init(serverData)
  if self:GetCreatureType() == Creature_Type.Npc and Game.MapManager:IsHomeMap(Game.MapManager:GetMapID()) then
    self.ai:DOPatrol(self)
  end
  Game.LogicManager_NpcTriggerAnim:OnAddNpc(self)
  self.delayRemoveTimeFlag = nil
  self.deadTimeFlag = nil
  self:TrySetComodoBuildingData()
end
function NNpc:DoDeconstruct(asArray)
  self:ClearTextMesh()
  self:UnregisterInteractNpc()
  self:UnregisterInsightNpc()
  HomeManager.Me():RemoveRelativeCreature(self.data:GetRelativeFurnitureID())
  if self.data:GetPushableObjID() then
    RaidPuzzleManager.Me():RemovePushObject(self)
  end
  self:Logic_LockRotation(false)
  self:_EndSkillNpc()
  self:UnRegistCulling()
  Game.LogicManager_NpcTriggerAnim:OnRemoveNpc(self)
  Game.AreaTrigger_Buff:ClearTrigger(self.data.id)
  NNpc.super.DoDeconstruct(self, asArray)
  self.delayRemoveTimeFlag = nil
  self.fadeOutRemoveDuration = nil
  self.forceRemoveTimeFlag = nil
  self.deadTimeFlag = nil
  self.smoothRemoving = false
  if self.effectControllerViewRange ~= nil then
    self.effectControllerViewRange:Destroy()
    self.effectControllerViewRange = nil
  end
  self.originalRotation = nil
  self.sceneui:Destroy()
  self.sceneui = nil
  self.assetRole:Destroy()
  self.assetRole = nil
  if Game.MapManager:IsHomeMap(Game.MapManager:GetMapID()) then
    self.ai:RemovePatrol()
  end
end
