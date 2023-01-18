Creature_SceneBottomUI = reusableClass("Creature_SceneBottomUI")
Creature_SceneBottomUI.PoolSize = 100
autoImport("SceneBottomHpSpCell")
autoImport("SceneBottomNameFactionCell")
autoImport("SceneBottomHeadwearRaidTowerInfoCell")
autoImport("NSceneBottomHeadwearRaidTowerInfoCell")
local SceneBottomHeadwearRaidTowerInfoCell_Class = SceneUIManager.UseUGUI and NSceneBottomHeadwearRaidTowerInfoCell or SceneBottomHeadwearRaidTowerInfoCell
function Creature_SceneBottomUI:ctor()
  Creature_SceneBottomUI.super.ctor(self)
end
local cellData = {}
function Creature_SceneBottomUI:DoConstruct(asArray, creature)
  self.id = creature.data.id
  self.followParents = {}
  self.isSelected = false
  self.isBeHit = false
  self.isDead = creature:IsDead()
  self.tryUpdateSanity = false
  self.savedValue = nil
  self:checkCreateHpSp(creature)
  self:checkCreateHeadwearRaidTowerInfo(creature)
end
function Creature_SceneBottomUI:GetSceneUIBottomFollow(type, creature)
  if not type then
    return
  end
  if not self.followParents[type] then
    local container = SceneUIManager.Instance:GetSceneUIContainer(type)
    if container then
      local follow = GameObject(string.format("RoleBottomFollow_%s", creature.data:GetName()))
      local followTransform = follow.transform
      followTransform:SetParent(container.transform, false)
      followTransform.localRotation = LuaGeometry.Const_Qua_identity
      follow.layer = container.layer
      creature:Client_RegisterFollow(followTransform, LuaGeometry.GetTempVector3(0, -0.15, 0), 0)
      self.followParents[type] = follow
    end
  end
  return self.followParents[type]
end
function Creature_SceneBottomUI:UnregisterSceneUITopFollows()
  for key, follow in pairs(self.followParents) do
    if not LuaGameObject.ObjectIsNull(follow) then
      Game.RoleFollowManager:UnregisterFollow(follow.transform)
      GameObject.Destroy(follow)
    end
    self.followParents[key] = nil
  end
end
function Creature_SceneBottomUI:DoDeconstruct(asArray)
  self:DestroyBottomUI()
  self:UnregisterSceneUITopFollows()
end
function Creature_SceneBottomUI:isHpSpVisible(creature)
  local id = creature.data.id
  local camp = creature.data:GetCamp()
  local neutral = RoleDefines_Camp.NEUTRAL == camp
  local creatureType = creature:GetCreatureType()
  local isMyself = creatureType == Creature_Type.Me
  local isPet = creatureType == Creature_Type.Pet
  local isPlayer = creatureType == Creature_Type.Player
  local isSelected = self.isSelected
  local isDead = self.isDead
  local detailedType = creature.data.detailedType
  local isWeaponPet = detailedType == NpcData.NpcDetailedType.WeaponPet
  local isMvpOrMini = detailedType == NpcData.NpcDetailedType.MINI or detailedType == NpcData.NpcDetailedType.MVP
  local isSkada = creature.data.isSkada
  local isInTwelvePVP = Game.MapManager:IsPvPMode_TeamTwelve()
  local isInDesertWolf = Game.MapManager:IsPvpMode_DesertWolf()
  if not creature:IsUIMask(MaskPlayerUIType.BloodType) then
    local maskBloodIndex
  end
  if not creature:IsUIMask(MaskPlayerUIType.BloodNameHonorFactionEmojiType) then
    local maskBNHFEIndex
  end
  local inEdMap = false
  local mapId = Game.MapManager:GetMapID()
  if mapId then
    local raidData = Table_MapRaid[mapId]
    inEdMap = raidData and raidData.Type == 11 or false
  end
  local mask = maskBloodIndex ~= nil or maskBNHFEIndex ~= nil
  local isSkillNpc = self:IsSkillNpc(detailedType)
  local isFarmingNpc = self:IsFarmingNpc(detailedType)
  local isSanityNPC = creature.data.isSanityNPC
  local isInVisible = mask or inEdMap or isPet and not isSkillNpc or neutral or isDead or creature.needMaskUI or isSanityNPC
  local isOb = PvpObserveProxy.Instance:IsRunning()
  if (isInDesertWolf or isInTwelvePVP) and not isOb and (isFarmingNpc or isPlayer or isMyself) or isSanityNPC then
    return true
  elseif isOb and (isFarmingNpc or isPlayer) then
    return true
  elseif isInVisible then
    return false
  elseif isMyself or TeamProxy.Instance:IsInMyTeam(id) or isSkillNpc then
    return true
  elseif camp ~= RoleDefines_Camp.ENEMY then
    if isSelected then
      return true
    end
  elseif isSelected or isMvpOrMini or self.isBeHit and not isSkada then
    return true
  end
  return false
end
function Creature_SceneBottomUI:IsSkillNpc(detailedType)
  local _NpcDetailedType = NpcData.NpcDetailedType
  if detailedType == _NpcDetailedType.SkillNpc then
    return true
  end
  if detailedType == _NpcDetailedType.PioneerNpc then
    return true
  end
  if detailedType == _NpcDetailedType.ShadowNpc then
    return true
  end
  if detailedType == _NpcDetailedType.GhostNpc then
    return true
  end
  if detailedType == _NpcDetailedType.CopyNpc then
    return true
  end
  if detailedType == _NpcDetailedType.SoulNpc then
    return true
  end
  if detailedType == _NpcDetailedType.FollowMaster then
    return true
  end
  return false
end
function Creature_SceneBottomUI:IsFarmingNpc(detailedType)
  local _NpcDetailedType = NpcData.NpcDetailedType
  if detailedType == _NpcDetailedType.DefenseTower then
    return true
  end
  if detailedType == _NpcDetailedType.PushMinion then
    return true
  end
  if detailedType == _NpcDetailedType.TwelveBase then
    return true
  end
  if detailedType == _NpcDetailedType.TwelveBarrack then
    return true
  end
  return false
end
function Creature_SceneBottomUI:checkCreateHpSp(creature)
  local isVisible = self:isHpSpVisible(creature)
  if isVisible then
    self:createHpSpCell(creature)
  end
end
function Creature_SceneBottomUI:createHpSpCell(creature)
  local parent = self:GetBottomObjParent(creature)
  if not parent then
    return
  end
  local resId = SceneBottomHpSpCell.resId
  Game.CreatureUIManager:AsyncCreateUIAsset(self.id, resId, parent, self.createHpSpCellFinish, creature)
end
function Creature_SceneBottomUI:GetBottomObjParent(creature)
  local parent
  if creature:GetCreatureType() == Creature_Type.Npc then
    if creature.data:IsMonster() then
      parent = self:GetSceneUIBottomFollow(SceneUIType.MonsterBottomInfo, creature)
    else
      parent = self:GetSceneUIBottomFollow(SceneUIType.NpcBottomInfo, creature)
    end
  elseif self:IsStaticPlayerType(creature) then
    parent = self:GetSceneUIBottomFollow(SceneUIType.StaticPlayerBottomInfo, creature)
  else
    parent = self:GetSceneUIBottomFollow(SceneUIType.PlayerBottomInfo, creature)
  end
  return parent
end
function Creature_SceneBottomUI:IsStaticPlayerType(creature)
  if not creature then
    return
  end
  if creature.IsInBooth and creature:IsInBooth() then
    return true
  end
  return false
end
function Creature_SceneBottomUI.createHpSpCellFinish(obj, creature)
  if obj then
    TableUtility.ArrayClear(cellData)
    cellData[1] = obj
    cellData[2] = creature
    if not creature or not creature:GetSceneUI() then
      local sceneUI
    end
    if sceneUI then
      local bottomUI = sceneUI.roleBottomUI
      Game.CreatureUIManager:RemoveCreatureWaitUI(bottomUI.id, SceneBottomHpSpCell.resId)
      bottomUI.hpSpCell = SceneBottomHpSpCell.CreateAsArray(cellData)
      local isVisible = bottomUI:isHpSpVisible(creature)
      bottomUI.hpSpCell:setHpSpVisible(isVisible)
      if bottomUI.tryUpdateSanity then
        bottomUI.hpSpCell:UpdateSanity(bottomUI.savedValue)
        bottomUI.savedValue = nil
      end
    end
  end
end
function Creature_SceneBottomUI:SetHp(ncreature)
  local hp = ncreature.data:GetHP()
  self.isDead = hp <= 0
  if self.hpSpCell then
    local buffhp, buffmaxhp = ncreature.data:GetBuffHpVals()
    if buffhp then
      self.hpSpCell:SetHp(buffhp, buffmaxhp or 1)
    else
      local maxHp = ncreature.data.props:GetPropByName("MaxHp"):GetValue()
      if self.isDead then
        self.hpSpCell.deadSlideAnim = true
      end
      self.hpSpCell:SetHp(hp, maxHp)
    end
    local isHpSpVisible = self:isHpSpVisible(ncreature)
    if isHpSpVisible then
      self.hpSpCell:setHpSpVisible(true)
    end
  end
end
function Creature_SceneBottomUI:SetSp(ncreature)
  if self.hpSpCell then
    local sp = ncreature.data.props:GetPropByName("Sp"):GetValue()
    local maxSp = ncreature.data.props:GetPropByName("MaxSp"):GetValue()
    local spTrans = ncreature.data.spTrans
    self.hpSpCell:SetSp(sp, maxSp, spTrans)
  end
end
function Creature_SceneBottomUI:isNameFactionVisible(creature)
  local id = creature.data.id
  local camp = creature.data:GetCamp()
  local creatureType = creature:GetCreatureType()
  local isMyself = creatureType == Creature_Type.Me
  local isPet = creatureType == Creature_Type.Pet
  local isPlayer = creatureType == Creature_Type.Player
  local isMyPet = isPet and creature:IsMyPet() or false
  local isSelected = self.isSelected
  local detailedType = creature.data.detailedType
  if not creature:IsUIMask(MaskPlayerUIType.NameType) then
    local maskBloodIndex
  end
  if not creature:IsUIMask(MaskPlayerUIType.NameHonorFactionType) then
    local maskBNHFIndex
  end
  if not creature:IsUIMask(MaskPlayerUIType.BloodNameHonorFactionEmojiType) then
    local maskBNHFEIndex
  end
  local showName = true
  if isMyself or isMyPet then
    showName = true
  elseif isPlayer then
    showName = FunctionPerformanceSetting.Me():IsShowOtherName()
  end
  local mask = not showName or maskBloodIndex ~= nil or maskBNHFIndex ~= nil or maskBNHFEIndex ~= nil
  isPlayer = isPlayer or creatureType == Creature_Type.Me
  local isCatchPet = isPet and creature.data.IsPet and creature.data:IsPet()
  local isMvpOrMini = detailedType == NpcData.NpcDetailedType.MINI or detailedType == NpcData.NpcDetailedType.MVP
  local isInMyTeam = TeamProxy.Instance:IsInMyTeam(id)
  local allShowName = false
  local allInVisible = false
  local selectShow = false
  local creatureShowName = creature:GetShowName()
  if creatureShowName then
    allShowName = creatureShowName == 2
    allInVisible = creatureShowName == 1
    selectShow = creatureShowName == 0
    selectShow = selectShow and isSelected or false
  end
  local visible = isPlayer or selectShow or isCatchPet or isMyPet or isMvpOrMini or isInMyTeam or isSelected or allShowName or creature.needMaskUI
  visible = visible and not allInVisible
  if mask then
    return false
  else
    return visible
  end
end
function Creature_SceneBottomUI:checkCreateNameFaction(creature)
  local isVisible = self:isNameFactionVisible(creature)
  if isVisible then
    self:createNameFaction(creature)
  end
end
function Creature_SceneBottomUI:createNameFaction(creature)
  local parent = self:GetBottomObjParent(creature)
  if not parent then
    return
  end
  DynamicSceneBottomUIPool.Me():create(self.id, parent, creature)
end
function Creature_SceneBottomUI.createNameFactionFinish(obj, creature)
  if obj then
    TableUtility.ArrayClear(cellData)
    cellData[1] = obj
    cellData[2] = creature
    local sceneUI = creature:GetSceneUI()
    if sceneUI then
      local bottomUI = sceneUI.roleBottomUI
      Game.CreatureUIManager:RemoveCreatureWaitUI(bottomUI.id, SceneBottomNameFactionCell.resId)
      bottomUI.nameFactionCell = SceneBottomNameFactionCell.CreateAsArray(cellData)
      local isVisible = bottomUI:isNameFactionVisible(creature)
      bottomUI.nameFactionCell:setNameFactionVisible(isVisible)
      local creatureType = creature:GetCreatureType()
      local showPre = creatureType == Creature_Type.Npc
      if showPre and FunctionQuest.Me():checkShowMonsterNamePre(creature) then
        bottomUI.nameFactionCell:SetQuestPrefixName(creature, true)
      end
    end
  end
end
function Creature_SceneBottomUI:HandleSettingMask(creature)
  if self.hpSpCell then
    local isVisible = self:isHpSpVisible(creature)
    self.hpSpCell:setHpSpVisible(isVisible)
  else
    self:checkCreateHpSp(creature)
  end
  if self.nameFactionCell then
    local isVisible = self:isNameFactionVisible(creature)
    self.nameFactionCell:setNameFactionVisible(isVisible)
  else
    self:checkCreateNameFaction(creature)
  end
end
function Creature_SceneBottomUI:HandlerPlayerFactionChange(creature)
  if self.nameFactionCell then
    self.nameFactionCell:SetFaction(creature)
  else
    self:checkCreateNameFaction(creature)
  end
end
function Creature_SceneBottomUI:HandleChangeTitle(creature)
  if self.nameFactionCell then
    self.nameFactionCell:SetName(creature)
  else
    self:checkCreateNameFaction(creature)
  end
end
function Creature_SceneBottomUI:HandleOB(creature)
  if self.nameFactionCell then
    self.nameFactionCell:SetName(creature)
    self.nameFactionCell:SetFaction(creature)
  else
    self:checkCreateNameFaction(creature)
  end
end
function Creature_SceneBottomUI:HandlerMemberDataChange(creature)
  if self.hpSpCell then
    local isVisible = self:isHpSpVisible(creature)
    self.hpSpCell:setHpSpVisible(isVisible)
  else
    self:checkCreateHpSp(creature)
  end
end
function Creature_SceneBottomUI:HandleCampChange(creature)
  if self.hpSpCell then
    local isVisible = self:isHpSpVisible(creature)
    self.hpSpCell:setHpSpVisible(isVisible)
    self.hpSpCell:setCamp(creature.data:GetCamp())
  else
    self:checkCreateHpSp(creature)
  end
  if self.nameFactionCell then
    local isVisible = self:isNameFactionVisible(creature)
    self.nameFactionCell:setNameFactionVisible(isVisible)
    self.nameFactionCell:SetName(creature)
  else
    self:checkCreateNameFaction(creature)
  end
end
function Creature_SceneBottomUI:SetIsSelected(isSelected, creature)
  self.isSelected = isSelected
  if self.hpSpCell then
    local isVisible = self:isHpSpVisible(creature)
    self.hpSpCell:setHpSpVisible(isVisible, isVisible)
  else
    self:checkCreateHpSp(creature)
  end
  if self.nameFactionCell then
    local isVisible = self:isNameFactionVisible(creature)
    self.nameFactionCell:setNameFactionVisible(isVisible)
  else
    self:checkCreateNameFaction(creature)
  end
end
function Creature_SceneBottomUI:SetIsBeHit(isBeHit, creature)
  self.isBeHit = isBeHit
  if self.hpSpCell then
    local isVisible = self:isHpSpVisible(creature)
    self.hpSpCell:setHpSpVisible(isVisible)
  else
    self:checkCreateHpSp(creature)
  end
end
function Creature_SceneBottomUI:ActiveSpHpCell(active, creature)
  creature = creature or SceneCreatureProxy.FindCreature(self.id)
  if not creature then
    redlog("没找到: ", self.id)
    return
  end
  if active then
    if self.hpSpCell and self:isHpSpVisible(creature) then
      if LuaGameObject.ObjectIsNull(self.hpSpCell.gameObject) then
        redlog("error！！！访问被移除creature。看到此报错请联系程序 name:", creature.data:GetName())
      else
        self.hpSpCell:setHpSpVisible(active)
      end
    else
      self:checkCreateHpSp(creature)
    end
  elseif self.hpSpCell then
    if LuaGameObject.ObjectIsNull(self.hpSpCell.gameObject) then
      redlog("error！！！访问被移除creature。看到此报错请联系程序 name:", creature.data and creature.data:GetName() or "creature data is nil")
    else
      self.hpSpCell:setHpSpVisible(active)
    end
  end
end
function Creature_SceneBottomUI:ActiveNameFactionCell(active, creature)
  creature = creature or SceneCreatureProxy.FindCreature(self.id)
  if not creature then
    return
  end
  if active then
    if self.nameFactionCell and self:isNameFactionVisible(creature) then
      if LuaGameObject.ObjectIsNull(self.nameFactionCell.gameObject) then
        redlog("error！！！访问被移除creature。看到此报错请联系程序 name:", creature.data:GetName())
      else
        self.nameFactionCell:SetActive(active)
      end
    else
      self:checkCreateNameFaction(creature)
    end
  elseif self.nameFactionCell then
    if LuaGameObject.ObjectIsNull(self.nameFactionCell.gameObject) then
      redlog("error！！！访问被移除creature。看到此报错请联系程序 name:", creature.data and creature.data:GetName() or "creature data is nil")
    else
      self.nameFactionCell:SetActive(active)
    end
  end
end
function Creature_SceneBottomUI:ActiveSceneUI(maskPlayerUIType, active, creature)
  if maskPlayerUIType == MaskPlayerUIType.BloodType then
    self:ActiveSpHpCell(active, creature)
  elseif maskPlayerUIType == MaskPlayerUIType.BloodNameHonorFactionEmojiType then
    self:ActiveSpHpCell(active, creature)
    self:ActiveNameFactionCell(active, creature)
  elseif maskPlayerUIType == MaskPlayerUIType.NameType then
    self:ActiveNameFactionCell(active, creature)
  elseif maskPlayerUIType == MaskPlayerUIType.NameHonorFactionType then
    self:ActiveNameFactionCell(active, creature)
  end
end
function Creature_SceneBottomUI:DestroyBottomUI()
  if self.nameFactionCell then
    DynamicSceneBottomUIPool.Me():cache(self.nameFactionCell)
  end
  if self.hpSpCell then
    ReusableObject.Destroy(self.hpSpCell)
  end
  Game.CreatureUIManager:RemoveCreatureWaitUI(self.id, SceneBottomHpSpCell.resId)
  Game.CreatureUIManager:RemoveCreatureWaitUI(self.id, SceneBottomNameFactionCell.resId)
  Game.CreatureUIManager:RemoveCreatureWaitUI(self.id, SceneBottomHeadwearRaidTowerInfoCell_Class.ResID)
  self.hpSpCell = nil
  self.nameFactionCell = nil
  self.towerInfoCell = nil
end
function Creature_SceneBottomUI:SetQuestPrefixVisible(creature, isShow)
  if self.nameFactionCell then
    self.nameFactionCell:SetQuestPrefixName(creature, isShow)
  end
end
function Creature_SceneBottomUI:BoothStateChange(creature)
  if not self.nameFactionCell and not self.hpSpCell then
    return
  end
  local parent = self:GetBottomObjParent(creature)
  if not parent then
    return
  end
  if self.nameFactionCell then
    SetParent(self.nameFactionCell.gameObject, parent)
    self.nameFactionCell.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(0, creature:GetCreatureType() == Creature_Type.Me and -19 or -10)
    self.nameFactionCell.gameObject.transform.localRotation = LuaGeometry.Const_Qua_identity
    self.nameFactionCell.gameObject.transform.localScale = LuaGeometry.Const_V3_one
  end
  if self.hpSpCell then
    SetParent(self.hpSpCell.gameObject, parent)
    self.hpSpCell.gameObject.transform.localPosition = LuaGeometry.Const_V3_zero
    self.hpSpCell.gameObject.transform.localRotation = LuaGeometry.Const_Qua_identity
    self.hpSpCell.gameObject.transform.localScale = LuaGeometry.Const_V3_one
  end
end
function Creature_SceneBottomUI:checkCreateHeadwearRaidTowerInfo(creature)
  if self:isHeadwearRaidTowerInfoVisible(creature) then
    self:createHeadwearRaidTowerInfoCell(creature)
  end
end
function Creature_SceneBottomUI:isHeadwearRaidTowerInfoVisible(creature)
  return Game.MapManager:IsPVEMode_HeadwearRaid() and creature.data and creature.data.staticData and HeadwearRaidProxy.Instance:IsHeadwearRaidTower(creature.data.staticData.id)
end
function Creature_SceneBottomUI:createHeadwearRaidTowerInfoCell(creature)
  local parent = self:GetBottomObjParent(creature)
  if not parent then
    return
  end
  Game.CreatureUIManager:AsyncCreateUIAsset(self.id, SceneBottomHeadwearRaidTowerInfoCell_Class.ResID, parent, self.createHeadwearRaidTowerInfoCellFinish, creature)
end
function Creature_SceneBottomUI.createHeadwearRaidTowerInfoCellFinish(obj, creature)
  if obj then
    TableUtility.ArrayClear(cellData)
    cellData[1] = obj
    cellData[2] = creature
    if not creature or not creature:GetSceneUI() then
      local sceneUI
    end
    if sceneUI then
      local bottomUI = sceneUI.roleBottomUI
      Game.CreatureUIManager:RemoveCreatureWaitUI(bottomUI.id, SceneBottomHeadwearRaidTowerInfoCell_Class.ResID)
      bottomUI.towerInfoCell = SceneBottomHeadwearRaidTowerInfoCell_Class.CreateAsArray(cellData)
    end
  end
end
function Creature_SceneBottomUI:UpdateHeadwearRaidTowerInfo(creature)
  if creature and self:isHeadwearRaidTowerInfoVisible(creature) and self.towerInfoCell then
    self.towerInfoCell:UpdateInfo()
  end
end
function Creature_SceneBottomUI:ShowHeadwearRaidTowerInfo(isShow)
  if isShow then
    self.towerInfoCell:Show()
  else
    self.towerInfoCell:Hide()
  end
end
function Creature_SceneBottomUI:UpdateSanity(ncreature, value)
  if self.hpSpCell then
    self.hpSpCell:UpdateSanity(value)
  else
    self:checkCreateHpSp(ncreature)
    self.savedValue = value
    self.tryUpdateSanity = true
  end
end
function Creature_SceneBottomUI:UpdateBullets(value)
  if self.hpSpCell then
    self.hpSpCell:UpdateBulletsNum(value)
  end
end
function Creature_SceneBottomUI:ShowBullets(value)
  if self.hpSpCell then
    self.hpSpCell:ShowBullets(value)
  end
end
function Creature_SceneBottomUI:ClearSanity()
  if self.hpSpCell then
    self.hpSpCell:ClearSanity()
  end
end
function Creature_SceneBottomUI:UpdateFrenzyLayer(layer, maxLayer)
  if self.hpSpCell then
    self.hpSpCell:UpdateFrenzyLayer(layer, maxLayer)
  end
end
function Creature_SceneBottomUI:ShowFrenzy(value)
  if self.hpSpCell then
    self.hpSpCell:ShowFrenzy(value)
    if self.nameFactionCell then
      self.nameFactionCell:Reposition(value)
    end
  end
end
function Creature_SceneBottomUI:InitTimeDiskInfo()
  if self.hpSpCell then
    self.hpSpCell:InitTimeDiskInfo()
    self.nameFactionCell:Reposition(true, -34)
  end
end
function Creature_SceneBottomUI:UpdateRotation(isSun, now, curGrid)
  if self.hpSpCell then
    self.hpSpCell:UpdateRotation(isSun, now, curGrid)
  end
end
function Creature_SceneBottomUI:RemoveTimeDisk()
  if self.hpSpCell then
    self.hpSpCell:RemoveTimeDisk()
    self.nameFactionCell:Reposition(true)
  end
end
function Creature_SceneBottomUI:InitStarMap()
  if self.hpSpCell then
    self.hpSpCell:InitStarMap()
    self.nameFactionCell:Reposition(true)
  end
end
function Creature_SceneBottomUI:UpdateStar(bufflayer)
  if self.hpSpCell then
    self.hpSpCell:UpdateStar(bufflayer)
  end
end
function Creature_SceneBottomUI:RemoveStarMap()
  if self.hpSpCell then
    self.hpSpCell:RemoveStarMap()
    self.nameFactionCell:Reposition(true)
  end
end
