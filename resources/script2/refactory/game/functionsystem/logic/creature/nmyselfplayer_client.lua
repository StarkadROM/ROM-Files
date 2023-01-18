local tmpVector3 = LuaVector3.Zero()
local tempCreatureArray = {}
local log = LogUtility.Info
local tempArray = {}
function NMyselfPlayer:Client_PlaceXYZTo(x, y, z, div, ignoreNavMesh)
  LuaVector3.Better_Set(tmpVector3, x, y, z)
  if div ~= nil then
    LuaVector3.Div(tmpVector3, div)
  end
  self:Client_PlaceTo(tmpVector3, ignoreNavMesh)
end
function NMyselfPlayer:Client_PlaceTo(pos, ignoreNavMesh)
  self.ai:PushCommand(FactoryAICMD.Me_GetPlaceToCmd(pos, ignoreNavMesh), self)
end
function NMyselfPlayer:Client_MoveXYZTo(x, y, z, div, ignoreNavMesh, callback, callbackOwner, callbackCustom)
  LuaVector3.Better_Set(tmpVector3, x, y, z)
  if div ~= nil then
    LuaVector3.Div(tmpVector3, div)
  end
  self:Client_MoveTo(tmpVector3, ignoreNavMesh, callback, callbackOwner, callbackCustom)
end
function NMyselfPlayer:Client_SetDirCmd(mode, dir, noSmooth)
  self.ai:PushCommand(FactoryAICMD.Me_GetSetAngleYCmd(mode, dir, noSmooth), self)
end
function NMyselfPlayer:Client_MoveTo(pos, ignoreNavMesh, callback, callbackOwner, callbackCustom, range, customMoveActionName)
  self.ai:PushCommand(FactoryAICMD.Me_GetMoveToCmd(pos, ignoreNavMesh, callback, callbackOwner, callbackCustom, range), self)
end
function NMyselfPlayer:Client_DirMove(dir, ignoreNavMesh)
  self.ai:PushCommand(FactoryAICMD.Me_GetDirMoveCmd(dir, ignoreNavMesh), self)
end
function NMyselfPlayer:Client_DirMoveEnd()
  self.ai:PushCommand(FactoryAICMD.Me_GetDirMoveEndCmd(), self)
end
function NMyselfPlayer:Client_PlayAction(name, normalizedTime, loop, fakeDead, forceDuration, freezeAtEnd)
  self.ai:PushCommand(FactoryAICMD.Me_GetPlayActionCmd(name, normalizedTime, loop, fakeDead, forceDuration, freezeAtEnd), self)
end
function NMyselfPlayer:Client_PlayAction2(name, normalizedTime, loop, fakeDead, forceDuration, freezeAtEnd)
  self.ai:PushCommand(FactoryAICMD.Me_GetPlayActionCmd(name, normalizedTime, loop, fakeDead, forceDuration, freezeAtEnd), self)
end
function NMyselfPlayer:Client_PlayActionMove(name, normalizedTime, loop, fakeDead, forceDuration, freezeAtEnd)
  name = name or self:GetMoveAction()
  local moveActionScale = 1
  local staticData = self.data.staticData
  if nil ~= staticData and nil ~= staticData.MoveSpdRate then
    moveActionScale = staticData.MoveSpdRate
  end
  local moveSpeed = self.data.props:GetPropByName("MoveSpd"):GetValue()
  local actionSpeed = self.moveActionSpd or moveActionScale * moveSpeed
  self.ai:PushCommand(FactoryAICMD.Me_GetPlayActionCmd(name, normalizedTime, loop, fakeDead, forceDuration, freezeAtEnd, actionSpeed), self)
end
function NMyselfPlayer:Client_PlayActionIdle(name, normalizedTime, loop, fakeDead, forceDuration, freezeAtEnd)
  name = name or self:GetIdleAction()
  self.ai:PushCommand(FactoryAICMD.Me_GetPlayActionCmd(name, normalizedTime, loop, fakeDead, forceDuration, freezeAtEnd), self)
end
function NMyselfPlayer:Client_PlayHolyAction(name, normalizedTime, loop, fakeDead, forceDuration, freezeAtEnd)
  self.ai:PushCommand(FactoryAICMD.Me_GetPlayHolyActionCmd(name, normalizedTime, loop, fakeDead, forceDuration, freezeAtEnd), self)
end
function NMyselfPlayer:Client_PlayHolyActionAndNotifyServer(actionID, loop)
  local actionInfo = Table_ActionAnime[actionID]
  if nil == actionInfo then
    return
  end
  self:Client_PlayHolyAction(actionInfo.Name, nil, loop)
  ServiceNUserProxy.Instance:CallUserActionNtf(self.data.id, actionID, loop and SceneUser2_pb.EUSERACTIONTYPE_MOTION or SceneUser2_pb.EUSERACTIONTYPE_NORMALMOTION)
end
function NMyselfPlayer:Client_PlayMotionAction(actionID)
  local actionInfo = Table_ActionAnime[actionID]
  if nil == actionInfo then
    return
  end
  self:Client_PlayAction(actionInfo.Name, nil, true)
  ServiceNUserProxy.Instance:CallUserActionNtf(self.data.id, actionID, SceneUser2_pb.EUSERACTIONTYPE_MOTION)
end
function NMyselfPlayer:Client_PlayNormalMotinAction(actionID)
  local actionInfo = Table_ActionAnime[actionID]
  if nil == actionInfo then
    return
  end
  self:Client_PlayAction(actionInfo.Name, nil, false)
  ServiceNUserProxy.Instance:CallUserActionNtf(self.data.id, actionID, SceneUser2_pb.EUSERACTIONTYPE_NORMALMOTION)
end
function NMyselfPlayer:Client_LockTarget(creature)
  if self == creature then
    return
  end
  if creature then
    if creature:GetClickable() then
      ServicePlayerProxy.Instance:CallMapObjectData(creature.data.id)
      Game.LockTargetEffectManager:SwitchLockedTarget(creature)
    else
      Game.LockTargetEffectManager:ClearLockedTarget()
      creature = nil
    end
  else
    Game.LockTargetEffectManager:ClearLockedTarget()
  end
  self:SetWeakData(NMyselfPlayer.WeakKey_LockTarget, creature)
  GameFacade.Instance:sendNotification(MyselfEvent.SelectTargetChange, creature)
  EventManager.Me():DispatchEvent(MyselfEvent.SelectTargetChange, creature)
end
function NMyselfPlayer:Client_AccessTarget(creature, custom, customDeleter, customType, accessRange)
  local myself = Game.Myself
  if myself.data and myself.data.userdata then
    local dressup = myself.data.userdata:Get(UDEnum.DRESSUP)
    if dressup == 1 or dressup == 2 then
      return
    end
  end
  self.ai:PushCommand(FactoryAICMD.Me_GetAccessCmd(creature, nil, accessRange, custom, customDeleter, customType), self)
end
function NMyselfPlayer:Client_ArrivedAccessTarget(creature, custom, customType)
  if creature then
    FunctionVisitNpc.Me():AccessTarget(creature, custom, customType)
  else
    errorLog("访问到达目标不存在")
  end
end
function NMyselfPlayer:Client_MoveHandler(destination)
  if Game.LogicManager_HandInHand then
    Game.LogicManager_HandInHand:TryBreakMyDoubleAction()
  end
  local clientskill = Game.Myself.skill
  if clientskill:IsCastingMoveRunSkill() then
    clientskill:_SwitchToAttack(Game.Myself)
    self:Logic_LookAtTargetPos()
  end
  EventManager.Me():PassEvent(MyselfEvent.StartToMove)
  if FunctionCheck.Me():CanSyncMove() then
    ServicePlayerProxy.Instance:CallMoveTo(destination[1], destination[2], destination[3])
  end
end
function NMyselfPlayer:Client_UseSkillHandler(random, phaseData, targetCreatureGUID, isTrigger)
  if self.disableSkillBroadcast then
    return
  end
  if self.skill.info and self.skill.info:GetRotateOnly() then
    local p = phaseData:GetPosition()
    if p then
      self.logicTransform:LookAt(p)
      self:Client_SyncRotationY(self.logicTransform:GetCurAngleY())
    end
  end
  ServicePlayerProxy.Instance:CallSkillBroadcast(random, phaseData, self, targetCreatureGUID, isTrigger)
  redlog("使用技能:" .. phaseData:GetSkillID() .. ", " .. phaseData:GetSkillPhase())
end
function NMyselfPlayer:Client_AutoAttackTarget(targetCreature)
  if not MyselfProxy.Instance.selectAutoNormalAtk and not self:Logic_IsBeTaunt() then
    return
  end
  local id = self.data:GetAttackSkillIDAndLevel()
  if id == 0 then
    return
  end
  if Game.SkillComboManager:PushSkill(id) then
    return
  end
  self:Client_UseSkill(id, targetCreature, nil, false, true)
end
function NMyselfPlayer:Client_AttackTarget(targetCreature)
  local id = self.data:GetAttackSkillIDAndLevel()
  if id == 0 then
    return
  end
  self:Client_UseSkill(id, targetCreature, nil, false, true)
end
function NMyselfPlayer:Client_BreakSkillLead(skillID)
  local skillInfo = Game.LogicManager_Skill:GetSkillInfo(skillID)
  if skillInfo:CanClientInterrupt() then
    local phaseData = SkillPhaseData.Create(skillID)
    phaseData:SetSkillPhase(SkillPhase.None)
    self:Client_UseSkillHandler(0, phaseData)
    self:Server_BreakSkill(skillID)
    phaseData:Destroy()
    phaseData = nil
    return true
  end
  return false
end
function NMyselfPlayer:Client_QuickUseSkill(skillID, targetCreature, targetPosition, forceTargetCreature, skillPhase, random)
  skillPhase = skillPhase or SkillPhase.Attack
  random = random or 0
  local phaseData = SkillPhaseData.Create(skillID)
  phaseData:SetSkillPhase(skillPhase)
  self:Client_UseSkillHandler(random, phaseData)
  self:Client_PlayUseSkill(phaseData)
  phaseData:Destroy()
  phaseData = nil
  return true
end
function NMyselfPlayer:Client_UseSkill(skillID, targetCreature, targetPosition, forceTargetCreature, noSearch, searchFilter, allowResearch, noLimit, ignoreCast, autoInterrupt)
  if self == targetCreature then
    targetCreature = nil
    forceTargetCreature = false
  end
  local skillInfo = Game.LogicManager_Skill:GetSkillInfo(skillID)
  if skillInfo:GetSkillType() == SkillType.FakeDead and self:IsFakeDead() then
    local phaseData = SkillPhaseData.Create(skillID)
    phaseData:SetSkillPhase(SkillPhase.Attack)
    self:Client_UseSkillHandler(0, phaseData)
    phaseData:Destroy()
    phaseData = nil
    return true
  end
  if skillInfo:GetSkillType() == SkillType.Ensemble and self:Logic_CanUseEnsembleSkill(skillInfo) == false then
    return false
  end
  if SkillTargetType.Point == skillInfo:GetTargetType(self) and targetPosition ~= nil and not ignoreCast then
    local isEarthMagic = skillInfo:IsEarthMagic(self)
    local isElementTrap = skillInfo:IsElementTrap(self)
    if isEarthMagic or isElementTrap then
      local trapMap = SceneTrapProxy.Instance:GetAll()
      local _LogicManager_Skill = Game.LogicManager_Skill
      local _DistanceXZ = VectorUtility.DistanceXZ_Square
      local data
      for k, v in pairs(trapMap) do
        data = _LogicManager_Skill:GetSkillInfo(v.skillID)
        if data ~= nil and (isEarthMagic and data:NoEarthMagic() or isElementTrap and data:NoElementTrap()) and _DistanceXZ(targetPosition, v.pos) <= data.logicParam.range * data.logicParam.range then
          return false, 609
        end
      end
    end
  end
  local lockedCreature = self:GetLockTarget()
  local oldTargetCreature = targetCreature
  local teamFirst = skillInfo:TeamFirst(self)
  local hatredFirst = self:IsAutoBattleProtectingTeam() and skillInfo:TargetEnemy(self)
  if not noSearch and nil ~= targetCreature then
    if teamFirst and not targetCreature:IsInMyTeam() then
      targetCreature = nil
    else
      local res, resValue, reason = skillInfo:CheckTarget(self, targetCreature)
      if not res then
        if resValue and resValue == 4 and reason == 1 then
          MsgManager.ShowMsgByIDTable(2216)
        end
        targetCreature = nil
      elseif hatredFirst and skillInfo:TargetOnlyEnemy(creature) and not targetCreature:IsHatred() then
        targetCreature = nil
      end
    end
  end
  if nil == targetCreature then
    if SkillTargetType.Creature == skillInfo:GetTargetType(self) then
      if noSearch then
        return false
      end
      if nil ~= lockedCreature and (not teamFirst or lockedCreature:IsInMyTeam()) and (not hatredFirst or lockedCreature:IsHatred()) and skillInfo:CheckTarget(self, lockedCreature) then
        targetCreature = lockedCreature
      else
        local searchRange = SkillLogic_Base.DefaultSearchRange
        if self:IsAutoBattleStanding() then
          searchRange = skillInfo:GetLaunchRange(self)
        end
        if hatredFirst then
          SkillLogic_Base.SearchTargetInRange(tempCreatureArray, self:GetPosition(), searchRange, skillInfo, self, searchFilter, SkillLogic_Base.SortComparator_HatredFirstDistance)
          targetCreature = tempCreatureArray[1]
          TableUtility.ArrayClear(tempCreatureArray)
          if nil == targetCreature or not targetCreature:IsHatred() then
            local autoBattleLockTarget, lockIDs = self.ai:GetAutoBattleLockTarget(self, skillInfo)
            if nil ~= autoBattleLockTarget then
              targetCreature = autoBattleLockTarget
            elseif nil ~= oldTargetCreature then
              targetCreature = oldTargetCreature
            end
          end
        else
          local autoBattleLockTarget, lockIDs = self.ai:GetAutoBattleLockTarget(self, skillInfo)
          if nil ~= autoBattleLockTarget then
            targetCreature = autoBattleLockTarget
          else
            local sortComparator = teamFirst and SkillLogic_Base.SortComparator_TeamFirstDistance or SkillLogic_Base.SortComparator_Distance
            SkillLogic_Base.SearchTargetInRange(tempCreatureArray, self:GetPosition(), searchRange, skillInfo, self, searchFilter, sortComparator)
            targetCreature = tempCreatureArray[1]
            TableUtility.ArrayClear(tempCreatureArray)
            if nil ~= oldTargetCreature and (nil == targetCreature or teamFirst and not targetCreature:IsInMyTeam()) then
              targetCreature = oldTargetCreature
            end
          end
        end
        if nil ~= targetCreature then
          self:Client_LockTarget(targetCreature)
        else
          return false
        end
      end
    elseif SkillTargetType.Point == skillInfo:GetTargetType(self) and nil ~= targetPosition then
      forceTargetCreature = false
    end
  elseif targetCreature ~= lockedCreature then
    if (SkillTargetType.Creature == skillInfo:GetTargetType(self) or forceTargetCreature) and self:IsAutoBattleStanding() then
      local skillLaunchRanage = skillInfo:GetLaunchRange(self)
      if VectorUtility.DistanceXZ_Square(self:GetPosition(), targetCreature:GetPosition()) > skillLaunchRanage * skillLaunchRanage then
        self:Client_ClearAutoBattleCurrentTarget()
        return false
      end
    end
    self:Client_LockTarget(targetCreature)
  end
  if targetCreature and targetCreature:GetCreatureType() == Creature_Type.Npc and (targetCreature.data:GetZoneType() == NpcData.ZoneType.ZONE_FIELD or targetCreature.data:GetZoneType() == NpcData.ZoneType.ZONE_STORM) and not targetCreature.data.isBossFromBranch and (targetCreature.data:IsBoss() or targetCreature.data:IsMini()) and self:GetBuffActive(104) then
    local curClientTime = ServerTime.CurClientTime()
    if not self.lastMsgTime or curClientTime - self.lastMsgTime > GameConfig.ChangeZone.buff_remind_interval * 1000 then
      MsgManager.ShowMsgByID(3094)
      self.lastMsgTime = curClientTime
    end
  end
  local isNormalSkill = self.data:GetAttackSkillIDAndLevel() == skillID
  local concurrent = not skillInfo:AllowConcurrent(self) or skillInfo:IsGuideCast(self) or skillInfo:GetCastInfo(self) <= 0.01
  local ignoreHit = skillInfo:IsHeavyHit()
  self.ai:PushCommand(FactoryAICMD.Me_GetSkillCmd(skillID, targetCreature, targetPosition, nil, forceTargetCreature, allowResearch, noLimit, ignoreCast, isNormalSkill, autoInterrupt, concurrent, ignoreHit), self)
  return true
end
function NMyselfPlayer:Client_SyncRotationY(y)
  if FunctionCheck.Me():CanSyncAngleY() then
    ServiceNUserProxy.Instance:CallSetDirection(y)
  end
end
function NMyselfPlayer:Client_EnterExitRangeHandler(exitPoint)
  if self:Client_IsCurrentCommand_Skill() then
    LogUtility.InfoFormat("<color=yellow>Call Enter Exit Point: </color>{0}, but skill is running", exitPoint.ID)
    return
  end
  LogUtility.InfoFormat("<color=blue>Call Enter Exit Point: </color>{0}", exitPoint.ID)
  local pos = self.logicTransform.currentPosition
  LuaVector3.Better_Set(tmpVector3, pos[1] * 1000, pos[2] * 1000, pos[3] * 1000)
  local mapid = SceneProxy.Instance.currentScene.mapID
  ServiceNUserProxy.Instance:CallExitPosUserCmd(tmpVector3, exitPoint.ID, mapid)
end
function NMyselfPlayer:Client_PauseIdleAI()
  self.ai:PauseIdleAI(self)
end
function NMyselfPlayer:Client_ResumeIdleAI()
  self.ai:ResumeIdleAI(self)
end
function NMyselfPlayer:Client_SetMissionCommand(newCmd)
  self.ai:SetAuto_MissionCommand(newCmd, self)
end
function NMyselfPlayer:Client_GetCurrentMissionCommand()
  self.ai:GetCurrentMissionCommand(self)
end
function NMyselfPlayer:Client_SetFollowLeader(leaderID, followType, ignoreNotifyServer)
  self.ai:SetAuto_FollowLeader(leaderID, followType, self, ignoreNotifyServer)
end
function NMyselfPlayer:Client_SetFollowLeaderMoveToMap(mapID, pos)
  self.ai:SetAuto_FollowLeaderMoveToMap(mapID, pos)
end
function NMyselfPlayer:Client_SetFollowLeaderTarget(guid, time)
  self.ai:SetAuto_FollowLeaderTarget(guid, time)
end
function NMyselfPlayer:Client_SetFollowLeaderDelay()
  self.ai:SetAuto_FollowLeaderDelay()
end
function NMyselfPlayer:Client_GetFollowLeaderID()
  return self.ai:GetFollowLeaderID(self)
end
function NMyselfPlayer:Client_IsFollowHandInHand()
  if self.handInActionID ~= nil then
    return false
  end
  return self.ai:IsFollowHandInHand(self)
end
function NMyselfPlayer:Client_SetFollower(followerID, followType)
  self.ai:SetFollower(followerID, followType, self)
end
function NMyselfPlayer:Client_ClearFollower()
  self.ai:ClearFollower(self)
end
function NMyselfPlayer:Client_GetAllFollowers()
  return self.ai:GetAllFollowers(self)
end
function NMyselfPlayer:Client_GetHandInHandFollower()
  return self.ai:GetHandInHandFollower(self)
end
function NMyselfPlayer:Client_ClearAutoBattleCurrentTarget()
  self.ai:ClearAuto_BattleCurrentTarget(self)
end
function NMyselfPlayer:Client_SetAutoBattleLockID(lockID)
  self.ai:SetAuto_BattleLockID(lockID, self)
end
function NMyselfPlayer:Client_UnSetAutoBattleLockID(lockID)
  self.ai:UnSetAuto_BattleLockID(lockID, self)
end
function NMyselfPlayer:Client_AutoBattleLost()
  self.ai:AutoBattleLost()
end
function NMyselfPlayer:Client_SetAutoBattleProtectTeam(on)
  self.ai:SetAuto_BattleProtectTeam(on, self)
end
function NMyselfPlayer:Client_SetAutoBattleStanding(on)
  if FunctionSniperMode.Me():IsWorking() then
    on = true
  end
  self.ai:SetAuto_BattleStanding(on, self)
end
function NMyselfPlayer:Client_SetAutoBattle(on)
  self.ai:SetAuto_Battle(on, self)
end
function NMyselfPlayer:Client_GetAutoBattleLockIDs()
  return self.ai:GetAutoBattleLockIDs(self)
end
function NMyselfPlayer:Client_ManualControlled()
  self:Client_SetMissionCommand(nil)
  self:Client_SetFollowLeaderDelay()
end
function NMyselfPlayer:Client_IsCurrentCommand_Skill()
  local cmd = self.ai:GetCurrentCommand(self)
  return nil ~= cmd and AI_CMD_Myself_Skill == cmd.AIClass
end
function NMyselfPlayer:Client_Die()
  FunctionSystem.InterruptMyMissionCommand()
  local params = Asset_Role.GetPlayActionParams(Asset_Role.ActionName.Die)
  params[6] = true
  params[7] = OnActionFinished
  params[8] = self.instanceID
  self:Logic_PlayAction(params, true)
  Asset_Role.ClearPlayActionParams(params)
end
function NMyselfPlayer:Client_SetAutoFakeDead(skillID)
  self.ai:SetAutoFakeDead(skillID, self)
end
function NMyselfPlayer:Client_SetAutoEndlessTowerSweep(on)
  self.ai:SetAuto_EndlessTowerSweep(on, self)
end
function NMyselfPlayer:Client_GetAutoEndlessTowerSweep()
  return self.ai:GetAuto_EndlessTowerSweep(self)
end
function NMyselfPlayer:Client_SetAutoSkillTargetPoint(on)
  self.ai:SetAuto_SkillTargetPoint(on)
end
function NMyselfPlayer:TryUseQuickRide()
  if Game.SkillOptionManager:GetSkillOption(SkillOptionManager.OptionEnum.QuickRide) ~= 0 or BagProxy.Instance.roleEquip:GetMount() or not GameConfig.SkillQuickRideID or not SkillProxy.Instance:HasLearnedSkill(GameConfig.SkillQuickRideID[1]) then
    return
  end
  if self.data:HasBuffID(6799) then
    return
  end
  if self.data:HasBuffID(4213) then
    MsgManager.ShowMsgByID(40603)
    return
  end
  if self.data:IsTransformed() then
    MsgManager.ShowMsgByID(40570)
    return
  end
  if SgAIManager.Me().m_isInBattle then
    return
  end
  FunctionSkill.Me():TryUseSkill(GameConfig.SkillQuickRideID[1])
end
function NMyselfPlayer:LearnedAutoLockBoss()
  local autoLockSkillID = GameConfig.SkillFunc.AutoLockBossID and GameConfig.SkillFunc.AutoLockBossID[1]
  return autoLockSkillID and SkillProxy.Instance:HasLearnedSkill(autoLockSkillID)
end
function NMyselfPlayer:CanUseAutoLockBoss()
  return Game.Myself:Client_GetFollowLeaderID() == 0 and self:LearnedAutoLockBoss()
end
function NMyselfPlayer:OnAddNpc(npc)
  local opt = npc.data.userdata:Get(UDEnum.OPTION)
  if npc:IsDead() or opt == 1 then
    return
  end
  local checkFuncs = ReusableTable.CreateArray()
  checkFuncs[#checkFuncs + 1] = NpcData.IsBossType_Dead
  self:TryAutoAttackTarget(npc, NpcData.IsBossType_Dead, SkillOptionManager.OptionEnum.AutoLockDeadBoss, checkFuncs)
  checkFuncs[#checkFuncs + 1] = NpcData.IsBossType_Mvp
  self:TryAutoAttackTarget(npc, NpcData.IsBossType_Mvp, SkillOptionManager.OptionEnum.AutoLockMvp, checkFuncs)
  checkFuncs[#checkFuncs + 1] = NpcData.IsBossType_Mini
  self:TryAutoAttackTarget(npc, NpcData.IsBossType_Mini, SkillOptionManager.OptionEnum.AutoLockMini, checkFuncs)
  ReusableTable.DestroyAndClearArray(checkFuncs)
end
function NMyselfPlayer:TryAutoAttackTarget(npc, funcSelfType, autoLockType, funcCheckTypes)
  if not funcSelfType(npc.data) or not npc.data:GetFeature_CanAutoLock() or not self:CanUseAutoLockBoss() or Game.SkillOptionManager:GetSkillOption(autoLockType) ~= 0 then
    return
  end
  if npc and npc.data.props:GetPropByName("Hiding"):GetValue() == 2 then
    return
  end
  MsgManager.FloatMsg(nil, string.format(ZhString.AutoAimMonster_Tip, npc.data:GetName()))
  local lockIDs = Game.Myself:Client_GetAutoBattleLockIDs()
  if not Game.AutoBattleManager.on or next(lockIDs) then
    self:Client_SetAutoBattleLockID(npc.data:GetStaticID())
    self:Client_SetAutoBattle(true)
    return true
  end
  local curTarget = self:GetLockTarget()
  local keepTarget = false
  if not curTarget or curTarget:IsDead() then
    keepTarget = false
  elseif funcCheckTypes then
    for i = 1, #funcCheckTypes do
      if funcCheckTypes[i](npc.data) then
        keepTarget = true
        break
      end
    end
  end
  if not keepTarget then
    if Game.AutoBattleManager.on then
      self:Client_ClearAutoBattleCurrentTarget()
    end
    self:Client_AttackTarget(npc)
  end
  EventManager.Me():DispatchEvent(AutoBattleManagerEvent.RefreshStatus, Game.AutoBattleManager)
  return true
end
function NMyselfPlayer:ConfirmUseItem_RandPos(func)
  if not func then
    return
  end
  local isLockMvp = Game.SkillOptionManager:GetSkillOption(SkillOptionManager.OptionEnum.AutoLockMvp) == 0
  local isLockMini = Game.SkillOptionManager:GetSkillOption(SkillOptionManager.OptionEnum.AutoLockMini) == 0
  local isLockDeadBoss = Game.SkillOptionManager:GetSkillOption(SkillOptionManager.OptionEnum.AutoLockDeadBoss) == 0
  if LocalSaveProxy.Instance:GetDontShowAgain(4999) or not Game.AutoBattleManager.on or not self:LearnedAutoLockBoss() or not NSceneNpcProxy.Instance:PickSingleNpc(function(npc)
    if npc.data:IsBossType_Mvp() then
      return isLockMvp
    elseif npc.data:IsBossType_Mini() then
      return isLockMini
    elseif npc.data:IsBossType_Dead() then
      return isLockDeadBoss
    end
  end) then
    func()
    return
  end
  MsgManager.DontAgainConfirmMsgByID(4999, func)
end
function NMyselfPlayer:Client_SetSkillDir(dir)
  self.skill:SetAttackWorkerDir(dir)
end
function NMyselfPlayer:Client_SetAutoReload(skillID)
  self.ai:Set_AutoReload(skillID, self)
end
function NMyselfPlayer:GetCenterPosition()
  return FunctionSniperMode.Me():GetCenterPosition() or self:GetPosition()
end
function NMyselfPlayer:Client_SetIsDirMoving(isDirMoving)
  self.isDirMoving = isDirMoving
end
function NMyselfPlayer:Client_IsDirMoving()
  return self.isDirMoving == true
end
function NMyselfPlayer:Client_IsMoving()
  return self:Client_IsDirMoving() or self:Client_IsMoveToWorking()
end
function NMyselfPlayer:Client_GetMoveToCustomActionName()
  if self:Client_IsDirMoving() then
    return
  end
  return NMyselfPlayer.super.Client_GetMoveToCustomActionName(self)
end
function NMyselfPlayer:Client_NotifyServerAngleY(time, deltaTime, force)
  if not force then
  elseif time > (self.nextNotifyAngleTime or 0) then
    local angleY = self.logicTransform:GetCurAngleY()
    if not self.prevNotifyAngleY or not NumberUtility.AlmostEqualAngle(self.prevNotifyAngleY, angleY) then
      self.nextNotifyAngleTime = time + 0.2
      self.prevNotifyAngleY = angleY
      ServiceNUserProxy.Instance:CallSetDirection(angleY)
    end
  end
end
function NMyselfPlayer:Client_StopNotifyServerAngleY()
  self.prevNotifyAngleY = 10086
end
local HugPopUpSkillData = {
  iconType = "skillIcon",
  btnStr = ZhString.FunctionPlayerTip_Pet_CancelHug,
  noClose = true,
  ClickCall = function(skillid)
    Game.Myself:Client_UseSkill(skillid, nil, nil, nil, nil, nil, nil, true)
  end
}
function NMyselfPlayer:Client_HandlerHugSkillPopUp(isAdd, skillid)
  if self.popUpAdded then
    QuickUseProxy.Instance:RemoveCommonNow(HugPopUpSkillData)
  end
  if isAdd then
    local skillData = Table_Skill[skillid]
    HugPopUpSkillData.skillid = skillid
    HugPopUpSkillData.ClickCallParam = skillid
    QuickUseProxy.Instance:AddSkillCallBack(HugPopUpSkillData)
  end
  self.popUpAdded = isAdd
end
function NMyselfPlayer:UpdateSanityBuff(bufflayer)
  local value = bufflayer / (self.MadBuffLimit or 100)
  if not Game.Myself:GetSceneUI() then
    local sceneUI
  end
  if sceneUI and sceneUI.roleBottomUI then
    sceneUI.roleBottomUI:UpdateSanity(Game.Myself, value)
  end
end
