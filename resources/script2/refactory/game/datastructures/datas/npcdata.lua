NpcData = reusableClass("NpcData", CreatureDataWithPropUserdata)
NpcData.PoolSize = 100
autoImport("NpcData_Pushable")
local NpcMonsterUtility = NpcMonsterUtility
NpcData.NpcType = {
  Npc = 1,
  Monster = 2,
  Pet = 3
}
NpcData.NpcDetailedType = {
  NPC = "NPC",
  GatherNPC = "GatherNPC",
  SealNPC = "SealNPC",
  WeaponPet = "WeaponPet",
  Monster = "Monster",
  MINI = "MINI",
  MVP = "MVP",
  Escort = "Escort",
  SkillNpc = "SkillNpc",
  FoodNpc = "FoodNpc",
  PetNpc = "PetNpc",
  CatchNpc = "CatchNpc",
  BeingNpc = "BeingNpc",
  StageNpc = "StageNpc",
  DeadBoss = "DeadBoss",
  PioneerNpc = "PioneerNpc",
  ShadowNpc = "ShadowNpc",
  GhostNpc = "GhostNpc",
  BFBuilding = "BUILD",
  RareElite = "RareElite",
  WorldBoss = "WorldBoss",
  SiegeCar = "SiegeCar",
  TwelveBase = "TwelveBase",
  DefenseTower = "DefenseTower",
  PushMinion = "PushMinion",
  TwelveBarrack = "TwelveBarrack",
  CopyNpc = "CopyNpc",
  Boki = "Boki",
  SoulNpc = "SoulNpc",
  FollowMaster = "FollowMaster",
  RobotNpc = "RobotNpc"
}
NpcData.ZoneType = {
  ZONE_MIN = 0,
  ZONE_FIELD = 1,
  ZONE_TASK = 2,
  ZONE_ENDLESSTOWER = 3,
  ZONE_LABORATORY = 4,
  ZONE_SEAL = 5,
  ZONE_DOJO = 6,
  ZONE_MAX = 7,
  ZONE_STORM = 22
}
NpcData.BossType = {
  Mvp = 1,
  Mini = 2,
  Dead = 3
}
local tempArray = {}
local GetNpcPriority = function(data)
  local skillinfo = Game.LogicManager_Skill:GetSkillInfo(data.skillID)
  if skillinfo ~= nil then
    local fromCreature = SceneCreatureProxy.FindCreature(data.skillOwner)
    if fromCreature ~= nil then
      local logicParam = skillinfo.logicParam
      if logicParam.isCountTrap ~= 1 and logicParam.isTimeTrap ~= 1 or not Asset_Effect.EffectTypes.Map then
        local effectType
      end
      return SkillInfo.GetEffectPriority(fromCreature, effectType, nil, skillinfo.camps)
    end
  end
  return 2
end
function NpcData:ctor()
  NpcData.super.ctor(self)
  self.staticData = nil
  self.uniqueid = nil
  self.behaviourData = BehaviourData.new()
  self.charactors = ReusableTable.CreateArray()
  self.useServerDressData = false
end
function NpcData:GetCamp()
  if self.campHandler and self.campHandler.dirty then
    self:SetCamp(self.campHandler:GetCamp())
  end
  return self.camp
end
function NpcData:GetDefaultGear()
  return self.staticData.DefaultGear
end
function NpcData:NoPlayIdle()
  return 1 == self.staticData.DisableWait
end
function NpcData:NoPlayShow()
  return 1 == self.staticData.DisablePlayshow
end
function NpcData:NoAutoAttack()
  return 1 == self.staticData.NoAutoAttack
end
function NpcData:GetAccessRange()
  return self.staticData.AccessRange or 2
end
function NpcData:IsNpc()
  return self.type == NpcData.NpcType.Npc
end
function NpcData:IsMonster()
  return self.type == NpcData.NpcType.Monster
end
function NpcData:IsPet()
  return self.type == NpcData.NpcType.Pet
end
function NpcData:IsMonster_Detail()
  return self.detailedType == NpcData.NpcDetailedType.Monster
end
function NpcData:IsBoss()
  return self.detailedType == NpcData.NpcDetailedType.MVP
end
function NpcData:IsMini()
  return self.detailedType == NpcData.NpcDetailedType.MINI
end
function NpcData:IsDeadBoss()
  return self.detailedType == NpcData.NpcDetailedType.DeadBoss
end
function NpcData:IsBossType_Mvp()
  local bossData = Table_Boss[self.staticData.id]
  if bossData then
    return bossData.Type == NpcData.BossType.Mvp
  else
    return self:IsBoss()
  end
end
function NpcData:IsBossType_Mini()
  local bossData = Table_Boss[self.staticData.id]
  if bossData then
    return bossData.Type == NpcData.BossType.Mini
  else
    return self:IsMini()
  end
end
function NpcData:IsBossType_Dead()
  local bossData = Table_Boss[self.staticData.id]
  if bossData then
    return bossData.Type == NpcData.BossType.Dead
  else
    return self:IsDeadBoss()
  end
end
function NpcData:IsSkillNpc_Detail()
  return self.detailedType == NpcData.NpcDetailedType.SkillNpc
end
function NpcData:IsCatchNpc_Detail()
  return self.detailedType == NpcData.NpcDetailedType.CatchNpc
end
function NpcData:IsBeingNpc_Detail()
  return self.detailedType == NpcData.NpcDetailedType.BeingNpc
end
function NpcData:IsPioneerNpc_Detail()
  return self.detailedType == NpcData.NpcDetailedType.PioneerNpc
end
function NpcData:IsShadowNpc_Detail()
  return self.detailedType == NpcData.NpcDetailedType.ShadowNpc
end
function NpcData:IsGhostNpc_Detail()
  return self.detailedType == NpcData.NpcDetailedType.GhostNpc
end
function NpcData:IsRareElite_Detail()
  return self.detailedType == NpcData.NpcDetailedType.RareElite
end
function NpcData:IsWorldBoss_Detail()
  return self.detailedType == NpcData.NpcDetailedType.WorldBoss
end
function NpcData:IsCopyNpc_Detail()
  return self.detailedType == NpcData.NpcDetailedType.CopyNpc
end
function NpcData:IsFollowMaster_Detail()
  return self.detailedType == NpcData.NpcDetailedType.FollowMaster
end
function NpcData:IsBoki_Detail()
  return self.detailedType == NpcData.NpcDetailedType.Boki
end
local MusicNpcConfig = GameConfig.System.musicboxnpc
local type_MusicNpcConfig = type(MusicNpcConfig)
function NpcData:IsMusicBox()
  if self.staticData.id == GameConfig.Joy.music_npc_i then
    return true
  end
  if type_MusicNpcConfig == "table" then
    return MusicNpcConfig[self.staticData.id] ~= nil
  end
  return self.staticData.id == MusicNpcConfig
end
function NpcData:IsSkada()
  return self.isSkada == true
end
function NpcData:IsSoulNpc()
  return self.detailedType == NpcData.NpcDetailedType.SoulNpc
end
local ElementNpcMap
local GetElementNpcMap = function()
  local nowRaid = Game.MapManager:GetRaidID()
  if ElementNpcMap then
    return ElementNpcMap[nowRaid]
  end
  ElementNpcMap = {}
  local _PvpTeamRaid = GameConfig.PvpTeamRaid
  for raidId, config in pairs(_PvpTeamRaid) do
    ElementNpcMap[raidId] = {}
    local elementNpcsID = config.ElementNpcsID
    for i = 1, #elementNpcsID do
      ElementNpcMap[raidId][elementNpcsID[i].npcid] = 1
    end
  end
  return ElementNpcMap[nowRaid]
end
function NpcData:IsElementNpc()
  local map = GetElementNpcMap()
  if map == nil then
    return
  end
  local npcid = self.staticData and self.staticData.id
  return npcid and map[npcid] == 1
end
local ElementNpcMap_Mid
local GetElementNpcMap_Mid = function()
  local nowRaid = Game.MapManager:GetRaidID()
  if ElementNpcMap_Mid then
    return ElementNpcMap_Mid[nowRaid]
  end
  ElementNpcMap_Mid = {}
  local _PvpTeamRaid = GameConfig.PvpTeamRaid
  for raidId, config in pairs(_PvpTeamRaid) do
    local buffConfig = config.BuffEffect
    ElementNpcMap_Mid[raidId] = {}
    for npcid, _ in pairs(buffConfig) do
      ElementNpcMap_Mid[raidId][npcid] = 1
    end
  end
  return ElementNpcMap_Mid[nowRaid]
end
function NpcData:IsElementNpc_Mid()
  if not Game.MapManager:IsPVPMode_TeamPws() then
    return false
  end
  local map = GetElementNpcMap_Mid()
  if map == nil then
    return false
  end
  local npcid = self.staticData and self.staticData.id
  return npcid and map[npcid] == 1
end
local normal_card_npc = GameConfig.CardRaid.normal_card_npc
local boss_card_npc = GameConfig.CardRaid.boss_card_npc
function NpcData:IsPveCardEffect()
  local sid = self.staticData and self.staticData.id or 0
  return sid == normal_card_npc or sid == boss_card_npc
end
function NpcData:IsSiegeCar()
  if not Game.MapManager:IsPvPMode_TeamTwelve() then
    return false
  end
  return self.detailedType == NpcData.NpcDetailedType.SiegeCar
end
function NpcData:IsTwelveBase_Detail()
  return self.detailedType == NpcData.NpcDetailedType.TwelveBase
end
function NpcData:GetStaticID()
  return self.staticData.id
end
function NpcData:GetBaseLv()
  local level
  if nil ~= self.userdata then
    level = self.userdata:Get(UDEnum.ROLELEVEL)
  end
  if nil == level then
    if nil ~= self.staticData and nil ~= self.staticData.Level then
      level = self.staticData.Level
    else
      level = 1
    end
  end
  return level
end
function NpcData:NoHitEffectMove()
  if self.behaviourData:GetNonMoveable() == 1 then
    return true
  end
  return NpcData.super.NoHitEffectMove(self)
end
function NpcData:NoAttackEffectMove()
  if self.behaviourData:GetNonMoveable() == 1 then
    return true
  end
  return NpcData.super.NoAttackEffectMove(self)
end
function NpcData:GetShape()
  return self.staticData.Shape
end
function NpcData:GetGroupID()
  return self.staticData.GroupID
end
function NpcData:GetRace()
  return self.staticData.Race_Parsed
end
function NpcData:GetOriginName()
  if self.staticData == nil or self.staticData.NameZh == nil then
    return "none"
  end
  return self.staticData.NameZh
end
function NpcData:GetName(isInScene)
  local name = self.name and self.name or self:GetOriginName()
  return self:WithPrefixName(isInScene) .. OverSea.LangManager.Instance():GetLangByKey(name)
end
function NpcData:GetNpcID()
  return self.staticData.id
end
function NpcData:GetDefaultScale()
  if self.staticData then
    return self.staticData.Scale or 1
  end
  return 1
end
function NpcData:GetClassID()
  return 0
end
function NpcData:GetRelativeFurnitureID()
  return self.furnitureID
end
function NpcData:GetPushableObjID()
  return self.pushableobjID
end
function NpcData:GetFeature(bit)
  if self.staticData and self.staticData.Features then
    return self.staticData.Features & bit > 0
  end
  return false
end
function NpcData:GetFeature_ChangeLinePunish()
  return self:GetFeature(1)
end
function NpcData:GetFeature_BeHold()
  return self:GetFeature(4)
end
function NpcData:GetFeature_FakeMini()
  return self:GetFeature(16)
end
function NpcData:GetFeature_IgnoreNavmesh()
  return self:GetFeature(32)
end
function NpcData:GetFeature_NotifyMove()
  return self:GetFeature(64)
end
function NpcData:GetFeature_StayVisitRot()
  return self:GetFeature(128)
end
function NpcData:GetFeature_IgnoreAutoBattle()
  if self.forceSelect then
    return false
  else
    return self:GetFeature(256)
  end
end
function NpcData:GetFeature_IgnoreEffectCulling()
  return self:GetFeature(512)
end
function NpcData:GetFeature_CanAutoLock()
  if self.noAutoLock then
    return false
  end
  return self:GetFeature(8192)
end
function NpcData:GetFeature_IgnoreExtraNavmesh()
  return self:GetFeature(4096)
end
function NpcData:GetFeature_IgnoreLookAt()
  return self:GetFeature(65536)
end
function NpcData:GetFeature_ForceSelect()
  return self:GetFeature(131072)
end
function NpcData:GetFeature_IgnoreRotation()
  return self:GetFeature(262144)
end
function NpcData:WithPrefixName(isInScene)
  if self.affixs ~= nil then
    return NpcData.WithAffixName(self.affixs, isInScene)
  end
  return NpcData.WithCharactorName(self.charactors, isInScene)
end
function NpcData.WithCharactorName(charactors, isInScene)
  local charactorNames = ""
  local charactorConf, charactorConfig
  if isInScene then
    charactorConfig = GameConfig.MonsterCharacterColorInScene or GameConfig.MonsterCharacterColor
  else
    charactorConfig = GameConfig.MonsterCharacterColor
  end
  for i = 1, #charactors do
    charactorConf = Table_Character[charactors[i]]
    if charactorConf then
      charactorConf.Name = OverSea.LangManager.Instance():GetLangByKey(charactorConf.Name)
      local npcCharactorSplit = OverSea.LangManager.Instance():GetLangByKey(ZhString.NpcCharactorSplit)
      charactorNames = charactorNames .. string.format(charactorConfig[charactorConf.NameColor], charactorConf.Name .. (i == #charactors and npcCharactorSplit or ""))
    else
      errorLog(string.format("creature id:%s charactor cannot find config %s", self.id, charactors[i]))
    end
  end
  return charactorNames
end
function NpcData.WithAffixName(affixs, isInScene)
  local affixNames = ""
  local config, colorStr
  if isInScene then
    colorStr = "<color=#FF0000>%s</color>"
  else
    colorStr = "[c][FF0000]%s[-][/c]"
  end
  for i = 1, #affixs do
    config = Table_MonsterAffix[affixs[i]]
    if config ~= nil then
      config.Name = OverSea.LangManager.Instance():GetLangByKey(config.Name)
      local npcCharactorSplit = OverSea.LangManager.Instance():GetLangByKey(ZhString.NpcCharactorSplit)
      affixNames = affixNames .. string.format(colorStr, config.Name .. (i == #affixs and npcCharactorSplit or ""))
    end
  end
  return affixNames
end
function NpcData:SetBehaviourData(num)
  self.behaviourData:Set(num or 0)
  self.noPicked = self.behaviourData:GetSkillNonSelectable()
end
function NpcData:GetZoneType()
  local str = self.staticData.Zone
  if str == "Field" then
    return NpcData.ZoneType.ZONE_FIELD
  elseif str == "Task" then
    return NpcData.ZoneType.ZONE_TASK
  elseif str == "EndlessTower" then
    return NpcData.ZoneType.ZONE_ENDLESSTOWER
  elseif str == "Laboratory" then
    return NpcData.ZoneType.ZONE_LABORATORY
  elseif str == "Repair" then
    return NpcData.ZoneType.ZONE_SEAL
  elseif str == "Dojo" then
    return NpcData.ZoneType.ZONE_DOJO
  elseif str == "Storm" then
    return NpcData.ZoneType.ZONE_STORM
  end
end
function NpcData:SetUseServerDressData(v)
  self.useServerDressData = v
end
function NpcData:GetDressParts()
  local parts = NSceneNpcProxy.Instance:GetOrCreatePartsFromStaticData(self.staticData)
  if self.useServerDressData then
    local userData = self.userdata
    if userData ~= nil then
      local cloned = NpcData.super.GetDressParts(self)
      for k, v in pairs(cloned) do
        if v == 0 then
          cloned[k] = parts[k]
        end
      end
      return cloned
    end
  else
    self:SpecialProcessParts(parts)
  end
  return parts
end
function NpcData:Camp_SetIsInMyGuild(val)
  if self.campHandler then
    self.campHandler:SetIsSameGuild(val)
    self.campChanged = self.campHandler.dirty
  end
end
function NpcData:Camp_SetIsInMyTeam(val)
  if self.campHandler then
    self.campHandler:SetIsSameTeam(val)
    self.campChanged = self.campHandler.dirty
  end
end
function NpcData:Camp_SetIsInGVG(val)
  if self.campHandler then
    self.campHandler:SetIsInGVGScene(val)
    self.campChanged = self.campHandler.dirty
  end
end
function NpcData:Camp_SetIsInTwelveScene(val)
  if self.campHandler then
    self.campHandler:SetIsInTwelveScene(val)
    self.campChanged = self.campHandler.dirty
  end
end
function NpcData:GetDetailedType()
  return self.detailedType
end
function NpcData:IsImmuneSkill(skillID)
  local immuneSkills = self.staticData.ImmuneSkill
  if immuneSkills and #immuneSkills > 0 then
    return 0 < TableUtility.ArrayFindIndex(immuneSkills, skillID)
  end
  return false
end
function NpcData:IsFly()
  return nil ~= self.behaviourData and self.behaviourData:IsFly()
end
function NpcData:DamageAlways1()
  return nil ~= self.behaviourData and 0 < self.behaviourData:GetDamageAlways1() or false
end
function NpcData:CanVisit()
  if self.forceSelect then
    return true
  end
  local behaviourData = self.behaviourData
  return behaviourData ~= nil and behaviourData:CanVisit()
end
function NpcData:SetOwnerID(ownerID)
  self.ownerID = ownerID
end
function NpcData:RefreshNightmareStatus()
  if not Game.Myself or Game.Myself.data.id == self.id or not Game.Myself:IsAtNightmareMap() then
    return
  end
  local nightmare = self.userdata:Get(UDEnum.NIGHTMARE) or 0
  local myNightmareLv = Game.Myself:GetNightmareLevel()
  if nightmare > 0 and myNightmareLv > 0 and nightmare <= myNightmareLv then
    self.isNightmareStatus = true
  end
end
function NpcData:IsNightmareMonster()
  return 0 < (self.userdata:Get(UDEnum.NIGHTMARE) or 0)
end
function NpcData:IsNightmareStatus()
  return self.isNightmareStatus == true
end
function NpcData:IsGvgStatue()
  return self.staticData.id == GameConfig.GVGConfig.StatueNpcID
end
function NpcData:IsGvgStatuePedestal()
  return self.staticData.id == GameConfig.GVGConfig.StatuePedestalNpcID
end
function NpcData:SpecialProcessParts(parts)
  if self:IsNightmareStatus() then
    local bodyConfig = Table_NightmareBody and Table_NightmareBody[parts[Asset_Role.PartIndex.Body] or 0]
    if bodyConfig and bodyConfig.Crazy and bodyConfig.Crazy ~= 0 then
      parts[Asset_Role.PartIndex.Body] = bodyConfig.Crazy
    end
  elseif self:IsGvgStatue() then
    local info = GvgProxy.Instance:GetStatueInfo()
    if info ~= nil then
      local PartIndex = Asset_Role.PartIndex
      if info.body ~= nil then
        parts[PartIndex.Body] = info.body
      end
      parts[PartIndex.Hair] = info.hair
      parts[PartIndex.Head] = info.head
      parts[PartIndex.Face] = info.face
      parts[PartIndex.Eye] = info.eye
      parts[PartIndex.Mouth] = info.mouth
      parts[PartIndex.Wing] = info.back
      parts[PartIndex.Tail] = info.tail
    end
  end
  NpcData.super.SpecialProcessParts(self, parts)
end
function NpcData:GetTeamID()
  return self.teamid
end
function NpcData:GetGroupTeamID()
  return self.groupid
end
function NpcData:NoPicked()
  if self.forceSelect then
    return false
  end
  return 0 < self.noPicked
end
function NpcData:GetMasterUser()
  if self.ownerID then
    local owner = SceneCreatureProxy.FindCreature(self.ownerID)
    return owner and owner.data
  end
  return nil
end
function NpcData:GetPriority()
  return self.priority
end
function NpcData:HasOutline()
  return self.staticData.OutlineColor and self.staticData.OutlineColor.color
end
local globalActNpc = GameConfig.ActivityNpcGear
function NpcData:GetTimeControlGear()
  if not globalActNpc then
    return
  end
  local globalActList = globalActNpc[self.staticData.id]
  if globalActList then
    for k, v in pairs(globalActList) do
      if FunctionActivity.Me():IsActivityRunning(k) then
        local activityData = FunctionActivity.Me():GetActivityData(k)
        local startTimeStamp = activityData and activityData.whole_starttime
        local curTime = ServerTime.CurServerTime() / 1000
        if startTimeStamp > curTime then
          return nil
        end
        local passedTime = math.floor((curTime - startTimeStamp) / 86400)
        local actionState
        for i = 1, #v do
          local single = v[i]
          if passedTime > single.timepass then
            actionState = single.state
          end
        end
        return actionState
      end
    end
  end
end
function NpcData:IsRobotNpc()
  return self.detailedType == NpcData.NpcDetailedType.RobotNpc
end
function NpcData:DoConstruct(asArray, serverData)
  NpcData.super.DoConstruct(self, asArray, serverData)
  self.dressEnable = true
  self.id = serverData.id
  self.uniqueid = serverData.uniqueid
  self.name = serverData.name and OverSea.LangManager.Instance():GetLangByKey(serverData.name) or serverData.name
  if serverData.waitaction == "" then
  end
  self.idleAction = serverData.waitaction
  self.teamid = serverData.teamid
  self.groupid = serverData.groupid
  self.followTargetOffset = serverData.followTargetOffset
  if serverData.character and #serverData.character > 0 then
    TableUtility.ArrayShallowCopy(self.charactors, serverData.character)
  end
  if serverData.affix and 0 < #serverData.affix then
    if self.affixs == nil then
      self.affixs = ReusableTable.CreateArray()
    end
    TableUtility.ArrayShallowCopy(self.affixs, serverData.affix)
  end
  if self.staticData == nil or self.staticData.id ~= serverData.npcID then
    self.staticData = Table_Monster[serverData.npcID]
    if self.staticData == nil then
      self.staticData = Table_Npc[serverData.npcID]
    end
    if self.staticData == nil then
      errorLog(string.format("找不到Npc配置,%s", serverData.npcID))
      LogUtility.InfoFormat("<color=red>找不到Npc配置,{0}</color>", serverData.npcID)
      return
    end
    self.shape = self.staticData.Shape
    self.race = self.staticData.Race_Parsed
    self.detailedType = NpcData.NpcDetailedType[self.staticData.Type]
  end
  local isMercenaryCat = false
  self.camp = RoleDefines_Camp.NEUTRAL
  local npcmonsterUtility = NpcMonsterUtility
  if npcmonsterUtility.IsMonsterByData(self.staticData) then
    self.type = NpcData.NpcType.Monster
    self.camp = RoleDefines_Camp.ENEMY
  elseif npcmonsterUtility.IsPetByData(self.staticData) then
    self.type = NpcData.NpcType.Pet
  else
    self.type = NpcData.NpcType.Npc
    if npcmonsterUtility.IsNpcByData(self.staticData) then
      self.camp = RoleDefines_Camp.NEUTRAL
    elseif npcmonsterUtility.IsFriendNpcByData(self.staticData) then
      self.camp = RoleDefines_Camp.FRIEND
      if HeadwearRaidProxy.Instance:IsHeadwearRaidTower(self.staticData.id) then
        self.camp = RoleDefines_Camp.NEUTRAL
      end
    end
    if self.staticData.Type == "WeaponPet" or self.staticData.Type == "SkillNpc" or self.staticData.Type == "RobotNpc" then
      self.camp = RoleDefines_Camp.FRIEND
      if self.staticData.Type == "WeaponPet" then
        isMercenaryCat = true
      end
    end
  end
  if not isMercenaryCat and not self:IsNpc() then
    if self.teamid and not self.campHandler then
      self.campHandler = CampHandler.new(self.camp)
    end
    if self.groupid and not self.campHandler then
      self.campHandler = CampHandler.new(self.camp)
    end
    if serverData.guildid and serverData.guildid ~= 0 then
      if not self.campHandler then
        self.campHandler = CampHandler.new(self.camp)
      end
      TableUtility.ArrayClear(tempArray)
      tempArray[1] = serverData.guildid
      tempArray[2] = serverData.guildname
      tempArray[3] = serverData.guildicon
      tempArray[4] = serverData.guildjob
      self:SetGuildData(tempArray)
    end
  end
  self.boss = self:IsBoss() or self:IsRareElite_Detail() or self:IsWorldBoss_Detail()
  self.mini = self:IsMini() or self:GetFeature_FakeMini()
  self.isSkada = GameConfig.Home.SkadaNpcIDs and 0 < TableUtility.ArrayFindIndex(GameConfig.Home.SkadaNpcIDs, self.staticData.id)
  local comodoconfig = GameConfig.ComodoRaid
  self.isSanityNPC = (comodoconfig and comodoconfig.SanityNpc) == self.staticData.id
  self.zoneType = self:GetZoneType()
  self:SetBehaviourData(serverData.behaviour)
  self.changelinepunish = self:GetFeature_ChangeLinePunish()
  self.isBossFromBranch = serverData.isBossFromBranch
  self.noPunishBoss = self:IsRareElite_Detail() or self:IsWorldBoss_Detail()
  self:SpawnCullingID()
  self.bodyScale = self:GetDefaultScale()
  self.search = serverData.search
  self.searchrange = serverData.searchrange
  self:SetOwnerID(serverData.owner)
  self.furnitureID = serverData.furnguid
  self.pushableobjID = serverData.boxid
  if self.pushableobjID then
    self:Push_SetDirection(serverData.direction)
  end
  self.isRareElite = self:IsRareElite_Detail()
  self.skillID = serverData.skillid
  self.skillOwner = serverData.skillowner
  if self.skillID ~= 0 then
    self.priority = GetNpcPriority(self)
    self.dressEnable = Game.EffectManager:GetNpcLevel(self.priority)
  end
end
function NpcData:SetNoAutoLock(val)
  self.noAutoLock = val
end
function NpcData:GetNoAutoLock(val)
  return self.noAutoLock
end
function NpcData:DoDeconstruct(asArray)
  NpcData.super.DoDeconstruct(self, asArray)
  self.noAutoLock = nil
  self:Push_ClearData()
  self.staticData = nil
  self.campHandler = nil
  self.useServerDressData = false
  self.furnitureID = nil
  TableUtility.ArrayClear(self.charactors)
  if self.affixs ~= nil then
    ReusableTable.DestroyAndClearArray(self.affixs)
    self.affixs = nil
  end
  self.isNightmareStatus = nil
  self.teamid = nil
  self.forceSelect = false
  self.skillID = nil
  self.skillOwner = nil
  self.priority = nil
end
function NpcData:SetBossType(bossType)
  if self:IsMonster_Detail() then
    self.boss = bossType
  end
end
