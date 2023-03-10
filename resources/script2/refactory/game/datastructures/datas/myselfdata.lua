MyselfData = reusableClass("MyselfData", PlayerData)
autoImport("Occupation")
autoImport("BuffLimit")
RandomFunction = class("RandomFunction")
function RandomFunction:ctor(a)
  self:UpdateArray(a, 1, #a)
  self.index = 1
end
function RandomFunction:ResetIndex(i)
  self.index = i
end
function RandomFunction:UpdateArray(a, begIndex, endIndex)
  if nil == self.array then
    self.array = {}
  end
  for i = begIndex, endIndex do
    self.array[i] = a[i - begIndex + 1]
  end
end
function RandomFunction:GetRandom()
  local p, newIndex = CommonFun.GetRandom(self.array, self.index)
  self.index = newIndex
  return p
end
HatredFunction = class("HatredFunction")
HatredFunction.ValidTime = 3
function HatredFunction.InfoValid(info, time)
  return time < info.lastAttackTime + HatredFunction.ValidTime
end
function HatredFunction:ctor()
  self.targets = {}
end
function HatredFunction:RefreshTargets()
  local invalidTargets = {}
  local time = UnityTime
  for k, v in pairs(self.targets) do
    if not HatredFunction.InfoValid(v, time) then
      invalidTargets[#invalidTargets + 1] = k
    end
  end
  for i = 1, #invalidTargets do
    self.targets[invalidTargets[i]] = nil
  end
end
function HatredFunction:RefreshInfo(targetID)
  local info = self.targets[targetID]
  if nil == info then
    info = {}
    self.targets[targetID] = info
  end
  info.lastAttackTime = UnityTime
end
function HatredFunction:CheckValid(targetID, time)
  local info = self.targets[targetID]
  if nil ~= info then
    return HatredFunction.InfoValid(info, time)
  end
  return false
end
local ShowSp = GameConfig.DemoRaid.ShowSp
function MyselfData:ctor()
  MyselfData.super.ctor(self)
  self.shape = CommonFun.Shape.M
  self.race = CommonFun.Race.DemiHuman
  self.transformData = TransformData.new()
  self.transformData:CacheOrigin(self)
  self:InitBuffHandler()
end
function MyselfData:GetCamp()
  return RoleDefines_Camp.FRIEND
end
function MyselfData:GetName()
  return self.name
end
function MyselfData:GetTeamID()
  return self.teamID
end
function MyselfData:GetRealTeamID()
  if TeamProxy.Instance:IHaveTeam() then
    return self:GetTeamID()
  else
    return 0
  end
end
function MyselfData:SetTeamID(teamID)
  self.teamID = teamID
end
local PartIndex, PartIndexEx
function MyselfData:GetDressParts()
  if PartIndex == nil then
    PartIndex = Asset_Role.PartIndex
  end
  if PartIndexEx == nil then
    PartIndexEx = Asset_Role.PartIndexEx
  end
  local parts = Asset_Role.CreatePartArray()
  if self.userdata then
    local userData = self.userdata
    parts[PartIndex.Body] = userData:Get(UDEnum.BODY) or 0
    parts[PartIndex.Hair] = userData:Get(UDEnum.HAIR) or 0
    parts[PartIndex.LeftWeapon] = userData:Get(UDEnum.LEFTHAND) or 0
    parts[PartIndex.RightWeapon] = userData:Get(UDEnum.RIGHTHAND) or 0
    parts[PartIndex.Head] = userData:Get(UDEnum.HEAD) or 0
    parts[PartIndex.Wing] = userData:Get(UDEnum.BACK) or 0
    parts[PartIndex.Face] = userData:Get(UDEnum.FACE) or 0
    parts[PartIndex.Tail] = userData:Get(UDEnum.TAIL) or 0
    parts[PartIndex.Eye] = userData:Get(UDEnum.EYE) or 0
    parts[PartIndex.Mouth] = userData:Get(UDEnum.MOUTH) or 0
    parts[PartIndex.Mount] = userData:Get(UDEnum.MOUNT) or 0
    parts[PartIndexEx.Gender] = userData:Get(UDEnum.SEX) or 0
    parts[PartIndexEx.HairColorIndex] = userData:Get(UDEnum.HAIRCOLOR) or 0
    parts[PartIndexEx.EyeColorIndex] = userData:Get(UDEnum.EYECOLOR) or 0
    parts[PartIndexEx.BodyColorIndex] = userData:Get(UDEnum.CLOTHCOLOR) or 0
    self:SpecialProcessPart_Sheath(parts)
  else
    for i = 1, 12 do
      parts[i] = 0
    end
  end
  return parts
end
function MyselfData:GetLernedSkillLevel(skillID)
  return SkillProxy.Instance:GetLearnedSkillLevelBySortID(skillID)
end
function MyselfData:GetArrowID()
  local item = BagProxy.Instance:GetNowActiveItem()
  if nil ~= item and nil ~= item.staticData then
    return item.staticData.id
  end
  return MyselfData.super.GetArrowID(self)
end
function MyselfData:GetEquipedRefineLv(site)
  local weaponData = BagProxy.Instance.roleEquip:GetEquipBySite(site)
  if nil ~= weaponData and nil ~= weaponData.equipInfo and nil ~= weaponData.equipInfo.refinelv then
    return weaponData.equipInfo.refinelv
  end
  return MyselfData.super.GetEquipedRefineLv(self, site)
end
function MyselfData:GetEquipedStrengthLv(site)
  local weaponData = BagProxy.Instance.roleEquip:GetEquipBySite(site)
  if weaponData ~= nil and weaponData.equipInfo ~= nil and weaponData.equipInfo.strengthlv ~= nil then
    return weaponData.equipInfo.strengthlv
  end
  return MyselfData.super.GetEquipedStrengthLv(self, site)
end
function MyselfData:GetEquipedItemNum(itemid)
  return BagProxy.Instance.roleEquip:GetEquipedItemNum(itemid)
end
function MyselfData:GetEquipedWeaponType()
  return self:GetEquipedType(GameConfig.EquipType[1].site[1])
end
function MyselfData:GetEquipedType(site)
  local weaponData = BagProxy.Instance.roleEquip:GetEquipBySite(site)
  if nil ~= weaponData and nil ~= weaponData.staticData and nil ~= weaponData.staticData.Type then
    return weaponData.staticData.Type
  end
  return MyselfData.super:GetEquipedType(self, site)
end
function MyselfData:GetEquipedID(site)
  local weaponData = BagProxy.Instance.roleEquip:GetEquipBySite(site)
  if nil ~= weaponData and nil ~= weaponData.staticData and nil ~= weaponData.staticData.id then
    return weaponData.staticData.id
  end
  return MyselfData.super:GetEquipedID(self, site)
end
function MyselfData:getEquipLv(site)
  local weaponData = BagProxy.Instance.roleEquip:GetEquipBySite(site)
  if nil ~= weaponData and nil ~= weaponData.staticData and nil ~= weaponData.staticData.id then
    return weaponData.equipInfo and weaponData.equipInfo.equiplv or 0
  end
  return 0
end
function MyselfData:GetEnchantAttrsBySite(site)
  local weaponData = BagProxy.Instance.roleEquip:GetEquipBySite(site)
  if weaponData and weaponData.enchantInfo then
    return weaponData.enchantInfo:GetEnchantAttrs()
  end
  return MyselfData.super:GetEnchantAttrsBySite(self, site)
end
function MyselfData:GetCombineEffectsBySite(site)
  local weaponData = BagProxy.Instance.roleEquip:GetEquipBySite(site)
  if weaponData and weaponData.enchantInfo then
    return weaponData.enchantInfo:GetCombineEffects()
  end
  return MyselfData.super:GetCombineEffectsBySite(self, site)
end
function MyselfData:GetDynamicSkillInfo(skillID)
  return SkillProxy.Instance:GetDynamicSkillInfoByID(skillID)
end
function MyselfData:GetSkillExtraCD()
  return self.skillExtraCD or 0
end
function MyselfData:GetCartNums()
  local max = BagProxy.Instance.barrowBag:GetUplimit()
  local items = BagProxy.Instance.barrowBag:GetItems()
  return #items, max
end
function MyselfData:GetPackageItemNum(itemid)
  return BagProxy.Instance:GetItemNumByStaticID(itemid)
end
function MyselfData:GetEquipCardNum(site, cardID)
  return BagProxy.Instance.roleEquip:GetEquipCardNumBySiteAndCardID(site, cardID)
end
function MyselfData:GetRunePoint(specialEffectID)
  return AstrolabeProxy.Instance:GetSpecialEffectCount(specialEffectID)
end
function MyselfData:GetActiveAstrolabePoints()
  return AstrolabeProxy.Instance:GetActiveStarPoints()
end
function MyselfData:GetAdventureSavedHeadWear(quality)
  return AdventureDataProxy.Instance:getNumOfStoredHeaddress(quality)
end
function MyselfData:GetAdventureSavedCard(quality)
  return AdventureDataProxy.Instance:getNumOfStoredCard(quality)
end
function MyselfData:GetAdventureTitle()
  return AdventureDataProxy.Instance:GetCurAdventureAppellation()
end
function MyselfData:GetGuildData()
  if self.guildData == nil then
    return GuildProxy.Instance.myGuildData
  end
  return self.guildData
end
function MyselfData:GetMercenaryGuildData()
  if self.mercenaryGuildData == nil then
    return GuildProxy.Instance.myMercenaryGuild
  end
  return self.mercenaryGuildData
end
function MyselfData:GetMapInfo()
  local mapmanager = Game.MapManager
  local mode = 1
  if mapmanager:IsPVPMode() then
    mode = 2
    if mapmanager:IsPVPMode_GVGDetailed() then
      mode = 4
    end
  elseif mapmanager:IsRaidMode() then
    mode = 3
  end
  return mapmanager:GetMapID(), mode
end
function MyselfData:UpdateRandomFunc(array, begIndex, endIndex)
  if nil ~= self.randomFunc then
    self.randomFunc:UpdateArray(array, begIndex, endIndex)
  else
    self.randomFunc = RandomFunction.new(array, begIndex, endIndex)
  end
end
function MyselfData:GetRandom()
  return self.randomFunc and self.randomFunc:GetRandom() or MyselfData.super.GetRandom(self)
end
function MyselfData:ResetRandom()
  if self.randomFunc then
    self.randomFunc:ResetIndex(1)
  end
end
function MyselfData:RemoveInvalidHatred()
  if nil ~= self.hatredFunc then
    self.hatredFunc:RefreshTargets()
  end
end
function MyselfData:RefreshHatred(id)
  if nil == self.hatredFunc then
    self.hatredFunc = HatredFunction.new()
  end
  self.hatredFunc:RefreshInfo(id)
end
function MyselfData:CheckHatred(id, time)
  return nil ~= self.hatredFunc and self.hatredFunc:CheckValid(id, time)
end
local StarBuff = GameConfig.StarShape.starBuff or 136190
local Hero_SanityBuff = GameConfig.SkillCommon.Hero_SanityBuff or 136400
function MyselfData:InitBuffHandler()
  self.buffHandler = {
    [BuffType.LimitSkill] = {
      Add = self._LimitSkillAdd,
      Remove = self._LimitSkillRemove
    },
    [BuffType.LimitUseItem] = {
      Add = self._LimitUseItemAdd,
      Remove = self._LimitUseItemRemove
    },
    [BuffType.ForbidEquip] = {
      Add = self._ForbidEquipAdd,
      Remove = self._ForbidEquipRemove
    },
    [BuffType.NoEarthSkill] = {
      Add = self._NoEarthSkillAdd,
      Remove = self._NoEarthSkillRemove
    },
    [BuffType.StatusChange] = {
      Add = self._StatusChangeAdd
    },
    [BuffType.DisableSkill] = {
      Add = self._DisableSkillAdd,
      Remove = self._DisableSkillRemove
    },
    [BuffType.EnsemblePuppet] = {
      Add = self._ClientPropsAdd,
      Remove = self._ClientPropsRemove
    },
    [BuffType.FollowShield] = {
      Add = self._FollowShieldAdd,
      Remove = self._FollowShieldRemove
    },
    [BuffType.DisplayProps] = {
      Add = self._DisplayPropsAdd,
      Remove = self._DisplayPropsRemove
    },
    [BuffType.SeeHide] = {
      Add = self._SeeHideAdd,
      Remove = self._SeeHideRemove
    },
    [BuffType.SniperMode] = {
      Add = self._SniperModeAdd,
      Remove = self._SniperModeRemove
    },
    [BuffType.FindHiding] = {
      Add = self._FindHidingAdd,
      Remove = self._FindHidingRemove
    },
    [BuffType.NoBulletConsume] = {
      Add = self._NoBulletConsumeAdd,
      Remove = self._NoBulletConsumeRemove
    },
    [BuffType.UpperLimitChange] = {
      Add = self._UpperLimitChangeAdd,
      Remove = self._UpperLimitChangeRemove
    },
    [BuffType.ChangeScale] = {
      Add = self._ChangeScaleAdd,
      Remove = self._ChangeScaleRemove
    },
    [BuffType.StarShape] = {
      Add = self._StarShapeAdd,
      Remove = self._StarShapeRemove
    },
    [BuffType.KickSkillSpeedUp] = {
      Add = self._KickSkillSpeedUpAdd,
      Remove = self._KickSkillSpeedUpRemove
    },
    [BuffType.SkipTimeDisk] = {
      Add = self._BuffSkipTimeDiskAdd,
      Remove = self._BuffSkipTimeDiskRemove
    },
    [BuffType.Disappear] = {
      Add = self._DisappearAdd,
      Remove = self._DisappearRemove
    }
  }
  self.buffClientPropsHandler = {
    [BuffType.EnsemblePuppet] = MyselfData.ClientProps.SelfEnsemble
  }
  self.buffSpecialHandler = {
    [StarBuff] = {
      Update = self.UpdateStarBuff,
      Remove = self.RemoveStarBuff
    },
    [Hero_SanityBuff] = {
      Update = self.UpdateFrenzyBuff,
      Remove = self.RemoveFrenzyBuff
    }
  }
end
function MyselfData:_LimitSkillAdd(buffeffect, fromID, isInit, level, active, buffID)
  local dirty = false
  local skillIDs = buffeffect.id
  local ignoreTarget = buffeffect.IgnoreTarget
  if skillIDs ~= nil then
    if self.limitBuffs == nil then
      self.limitBuffs = ReusableTable.CreateTable()
      self.limitBuffs.count = 0
    end
    for i = 1, #skillIDs do
      self:_AddLimitSkillBuff(self.limitBuffs, skillIDs[i], fromID, ignoreTarget, buffID)
    end
    dirty = true
  end
  local notSkillIDs = buffeffect.notid
  if notSkillIDs ~= nil then
    if self.limitNotBuffs == nil then
      self.limitNotBuffs = ReusableTable.CreateTable()
      self.limitNotBuffs.count = 0
    end
    for i = 1, #notSkillIDs do
      self:_AddLimitSkillBuff(self.limitNotBuffs, notSkillIDs[i], fromID, ignoreTarget, buffID)
    end
    dirty = true
  end
  local notElement = buffeffect.notElement
  if notElement ~= nil then
    local limits = self.limitNotElement
    if limits == nil then
      limits = ReusableTable.CreateTable()
      self.limitNotElement = limits
    end
    limits[notElement] = 1
    dirty = true
  end
  if dirty then
    EventManager.Me():PassEvent(MyselfEvent.EnableUseSkillStateChange)
  end
end
function MyselfData:_LimitSkillRemove(buffeffect, level, buffID)
  local dirty = false
  local skillIDs = buffeffect.id
  if self.limitBuffs ~= nil and skillIDs ~= nil then
    for i = 1, #skillIDs do
      self:_RemoveLimitSkillBuff(self.limitBuffs, skillIDs[i], buffID)
    end
    dirty = true
  end
  local notSkillIDs = buffeffect.notid
  if self.limitNotBuffs ~= nil and notSkillIDs ~= nil then
    for i = 1, #notSkillIDs do
      self:_RemoveLimitSkillBuff(self.limitNotBuffs, notSkillIDs[i], buffID)
    end
    dirty = true
  end
  local notElement = buffeffect.notElement
  if notElement ~= nil then
    local limits = self.limitNotElement
    if limits ~= nil then
      limits[notElement] = nil
      dirty = true
    end
  end
  if dirty then
    EventManager.Me():PassEvent(MyselfEvent.EnableUseSkillStateChange)
  end
end
function MyselfData:_LimitUseItemAdd(buffeffect, fromID, isInit)
  if not isInit then
    return
  end
  ItemsWithRoleStatusChange:Instance():AddBuffLimitUseItem(buffeffect.forbid_type, buffeffect.ok_type, buffeffect.forbid_ids, buffeffect.ok_ids, buffeffect.forbid_all)
end
function MyselfData:_LimitUseItemRemove(buffeffect)
  ItemsWithRoleStatusChange:Instance():RemoveBuffLimitUseItem(buffeffect.forbid_type, buffeffect.ok_type, buffeffect.forbid_ids, buffeffect.ok_ids, buffeffect.forbid_all)
end
function MyselfData:_ForbidEquipAdd(buffeffect, fromID, isInit)
  if not isInit then
    return
  end
  ItemsWithRoleStatusChange:Instance():AddBuffForbidEquip(buffeffect)
end
function MyselfData:_ForbidEquipRemove(buffeffect)
  ItemsWithRoleStatusChange:Instance():RemoveBuffForbidEquip(buffeffect)
end
function MyselfData:_NoEarthSkillAdd(buffeffect)
  local skillIDs = buffeffect.id
  if skillIDs ~= nil then
    local map = self.noEarthSkill
    if map == nil then
      map = {}
      self.noEarthSkill = map
    end
    local id
    for i = 1, #skillIDs do
      id = skillIDs[i]
      if map[id] == nil then
        map[id] = id
      end
    end
  end
end
function MyselfData:_NoEarthSkillRemove(buffeffect)
  local map = self.noEarthSkill
  if map == nil then
    return
  end
  local skillIDs = buffeffect.id
  if skillIDs ~= nil then
    for i = 1, #skillIDs do
      map[skillIDs[i]] = nil
    end
  end
end
function MyselfData:_StatusChangeAdd(buffeffect)
  local attrEffect = buffeffect.AttrEffect
  if attrEffect ~= nil then
    local attr
    for i = 1, #attrEffect do
      attr = attrEffect[i]
      if attr == 27 then
        if MyselfData.BlindMaskViewInstance == nil then
          GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
            view = PanelConfig.BlindMaskView,
            viewdata = {
              BgEffect = buffeffect.BgEffect,
              BgColor = buffeffect.BgColor
            }
          })
        else
          MyselfData.BlindMaskViewInstance:ResetEffect(buffeffect.BgEffect, buffeffect.BgColor)
        end
      end
    end
  end
end
function MyselfData:_DisableSkillAdd(buffeffect, fromID, isInit, level)
  self:Client_SetProps(MyselfData.ClientProps.DisableSkill, true)
  local add_cd = buffeffect.add_cd
  if add_cd == nil then
    return
  end
  self.skillExtraCD = CommonFun.calcBuffValue(self, self, add_cd.type, add_cd.a, add_cd.b, add_cd.c, add_cd.d, level, 0)
end
function MyselfData:_DisableSkillRemove(buffeffect, level)
  self:Client_ResetProps(MyselfData.ClientProps.DisableSkill)
  self.skillExtraCD = nil
end
function MyselfData:_ClientPropsAdd(buffeffect, fromID, isInit)
  if not isInit then
    return
  end
  local propsName = self.buffClientPropsHandler[buffeffect.type]
  if propsName ~= nil then
    self:Client_SetProps(propsName, true)
  end
end
function MyselfData:_ClientPropsRemove(buffeffect)
  local propsName = self.buffClientPropsHandler[buffeffect.type]
  if propsName ~= nil then
    self:Client_SetProps(propsName, false)
  end
end
function MyselfData:_FollowShieldAdd(buffeffect, fromID)
  Game.Myself:Client_SetFollowLeader(fromID)
end
function MyselfData:_FollowShieldRemove(buffeffect)
  Game.Myself:Client_SetFollowLeader(0)
end
function MyselfData:_SeeHideAdd(buffeffect, fromID, isInit, level, active)
  if active then
    Game.AreaTrigger_Buff:LaunchCheck(AreaTrigger_Buff.SeeHide)
  end
end
function MyselfData:_SeeHideRemove(buffeffect)
  Game.AreaTrigger_Buff:ShutdownCheck(AreaTrigger_Buff.SeeHide)
end
function MyselfData:_DynamicSkillConfigAdd(buffeffect)
  MyselfData.super._DynamicSkillConfigAdd(self, buffeffect)
  if buffeffect.configType == SkillDynamicManager.Config.Icon then
    GameFacade.Instance:sendNotification(SkillEvent.ChangeIcon, buffeffect.ids)
  end
end
function MyselfData:_DynamicSkillConfigRemove(buffeffect)
  MyselfData.super._DynamicSkillConfigRemove(self, buffeffect)
  if buffeffect.configType == SkillDynamicManager.Config.Icon then
    GameFacade.Instance:sendNotification(SkillEvent.ChangeIcon, buffeffect.ids)
  end
end
function MyselfData:_DisplayPropsAdd(buffeffect)
  Game.SkillDynamicManager:AddDynamicProps(buffeffect)
end
function MyselfData:_DisplayPropsRemove(buffeffect)
  Game.SkillDynamicManager:RemoveDynamicProps(buffeffect)
end
function MyselfData:AddBuff(buffID, fromID, layer, level, active, isInit)
  if buffID == nil then
    return
  end
  local buffInfo = Table_Buffer[buffID]
  if buffInfo == nil then
    return
  end
  local buff = MyselfData.super.AddBuff(self, buffID, fromID, layer, level, active)
  local buffeffect = buffInfo.BuffEffect
  if buff and buffeffect.LayerState_self then
    if active then
      if not self.multiSourceBuff[buffID] then
        self.multiSourceBuff[buffID] = {}
      end
      if not self.multiSourceBuff[buffID][fromID] then
        self.multiSourceBuff[buffID][fromID] = {}
      end
      self.multiSourceBuff[buffID][fromID] = buff
    elseif self.multiSourceBuff and self.multiSourceBuff[buffID] and self.multiSourceBuff[buffID][fromID] then
      self.multiSourceBuff[buffID][fromID] = nil
    end
  end
  local handler = self.buffHandler[buffeffect.type]
  if handler ~= nil then
    local addHandler = handler.Add
    if addHandler then
      addHandler(self, buffeffect, fromID, isInit, level, active, buffID)
    end
  end
  if not self.spTrans then
    self.spTrans = ShowSp and ShowSp[buffID]
  end
  local spHandler = self.buffSpecialHandler[buffID]
  if spHandler then
    local updateHandler = spHandler.Update
    if updateHandler then
      updateHandler(self, buffID, layer)
    end
  end
end
function MyselfData:RemoveBuff(buffID)
  if buffID == nil then
    return
  end
  local buffInfo = Table_Buffer[buffID]
  if buffInfo == nil then
    return
  end
  MyselfData.super.RemoveBuff(self, buffID)
  local buffeffect = buffInfo.BuffEffect
  local handler = self.buffHandler[buffeffect.type]
  if handler ~= nil then
    local removeHandler = handler.Remove
    if removeHandler then
      removeHandler(self, buffeffect, level, buffID)
    end
  end
  if ShowSp and ShowSp[buffID] then
    self.spTrans = nil
  end
  local spHandler = self.buffSpecialHandler[buffID]
  if spHandler then
    local removeHandler = spHandler.Remove
    if removeHandler then
      removeHandler(self, buffID, layer)
    end
  end
end
function MyselfData:IsBuffStateValid(buffInfo)
  return true
end
function MyselfData:GetWeaponPetLevel()
  return MercenaryCatProxy.Instance:GetMercenaryLv()
end
function MyselfData:_AddLimitSkillBuff(map, skillid, fromID, ignoreTarget, buffID)
  local limitBuff = map[skillid]
  if limitBuff == nil then
    limitBuff = BuffLimit.CreateAsTable(data)
    map[skillid] = limitBuff
    map.count = map.count + 1
  end
  limitBuff:SetData(buffID, fromID, ignoreTarget)
end
function MyselfData:_RemoveLimitSkillBuff(map, skillid, buffID)
  local limitBuff = map[skillid]
  if limitBuff ~= nil then
    limitBuff:ClearData(buffID)
    if limitBuff:IsEmpty() then
      limitBuff:Destroy()
      map[skillid] = nil
      map.count = map.count - 1
    end
  end
end
function MyselfData:ForceClearWeakFreezeSkillBuff()
  if self.weakFreezeBuffs ~= nil then
    ReusableTable.DestroyAndClearTable(self.weakFreezeBuffs)
    self.weakFreezeBuffs = nil
  end
end
function MyselfData:CanBreakWeakFreezeBySkillID(skillIdAndLevel)
  return self:CanBreakWeakFreezeBySkillSortID(math.floor(skillIdAndLevel / 1000))
end
function MyselfData:CanBreakWeakFreezeBySkillSortID(sortID)
  if self.weakFreezeBuffs and self.weakFreezeBuffs.count > 0 then
    local skillBuff = self.weakFreezeBuffs[sortID]
    if skillBuff and #skillBuff == self.weakFreezeBuffs.count then
      return true
    end
  end
  return false
end
function MyselfData:_ClearBuffs()
  if self.limitBuffs ~= nil then
    for i = #self.limitBuffs, 1, -1 do
      self.limitBuffs[i]:Destroy()
      self.limitBuffs[i] = nil
    end
    ReusableTable.DestroyTable(self.limitBuffs)
    self.limitBuffs = nil
  end
  if self.limitNotBuffs ~= nil then
    for i = #self.limitNotBuffs, 1, -1 do
      self.limitNotBuffs[i]:Destroy()
      self.limitNotBuffs[i] = nil
    end
    ReusableTable.DestroyTable(self.limitNotBuffs)
    self.limitNotBuffs = nil
  end
  if self.limitNotElement ~= nil then
    ReusableTable.DestroyAndClearTable(self.limitNotElement)
    self.limitNotElement = nil
  end
  self.noEarthSkill = nil
  self.skillExtraCD = nil
  self:ForceClearWeakFreezeSkillBuff()
  MyselfData.super._ClearBuffs(self)
end
function MyselfData:HasLimitSkill()
  if self.limitBuffs then
    return self.limitBuffs.count > 0
  end
  return false
end
function MyselfData:HasLimitNotSkill()
  if self.limitNotBuffs and not self:HasLimitSkill() then
    return self.limitNotBuffs.count > 0
  end
  return false
end
function MyselfData:GetLimitSkill(skillID)
  if self.limitBuffs ~= nil then
    return self.limitBuffs[math.floor(skillID / 1000)]
  end
end
function MyselfData:GetLimitNotSkill(skillID)
  if self.limitNotBuffs ~= nil and not self:HasLimitSkill() then
    return self.limitNotBuffs[math.floor(skillID / 1000)]
  end
end
function MyselfData:GetLimitNotElement(skillID)
  local limits = self.limitNotElement
  if limits == nil then
    return false
  end
  local data = Table_Skill[skillID]
  if data == nil then
    return false
  end
  local damage = data.Damage
  if damage == nil or #damage == 0 then
    return false
  end
  local element
  for i = 1, #damage do
    element = damage[i].elementparam
    if element ~= nil and limits[element] ~= nil then
      return true
    end
  end
  if element ~= nil then
    return false
  end
  element = self:GetProperty("AtkAttr")
  if element ~= nil and limits[element] ~= nil then
    return true
  end
  return false
end
function MyselfData:GetLimitSkillTarget(skillID)
  return self:GetLimitSkillTargetBySortID(math.floor(skillID / 1000))
end
function MyselfData:GetLimitSkillTargetBySortID(sortID)
  if self.limitBuffs then
    local limitBuff = self.limitBuffs[sortID]
    if limitBuff ~= nil then
      return limitBuff:GetFromID()
    end
  end
  return nil
end
function MyselfData:GetNoEarthSkill(skillid)
  local map = self.noEarthSkill
  if map == nil then
    return false
  end
  return map[math.floor(skillid / 1000)] ~= nil
end
function MyselfData:InGuildZone()
  local myGuildData = GuildProxy.Instance.myGuildData
  if myGuildData == nil then
    return false
  end
  local curZoneId = self.userdata:Get(UDEnum.ZONEID) or 0
  return curZoneId == math.fmod(myGuildData.zoneid, 10000)
end
function MyselfData:InGvgZone()
  return GvgProxy.Instance:CheckCurMapIsInGuildUnionGroup()
end
function MyselfData:NoAttackMetal()
  local myGuildData = GuildProxy.Instance.myGuildData
  if myGuildData == nil then
    return false
  end
  return myGuildData.insupergvg == true or myGuildData.no_attack_metal
end
function MyselfData:GetRangeEnemy(range)
  if range ~= nil then
    do
      local me = Game.Myself
      if me then
        local count = 0
        local pos = me:GetPosition()
        local squareRange = range * range
        NSceneUserProxy.Instance:TraversingCreatureAround(pos, range, function(v)
          if self:IsEnemy(v.data) then
            count = count + 1
          end
        end)
        NSceneNpcProxy.Instance:TraversingCreatureAround(pos, range, function(v)
          if self:IsEnemy(v.data) then
            count = count + 1
          end
        end)
        NScenePetProxy.Instance:TraversingCreatureAround(pos, range, function(v)
          if self:IsEnemy(v.data) then
            count = count + 1
          end
        end)
        return count
      end
    end
  else
  end
  return MyselfData.super:GetRangeEnemy(self, range)
end
function MyselfData:GetHighHpBeingGUID()
  local _PetProxy = PetProxy.Instance
  local list = _PetProxy:GetMySummonBeingList()
  local beingGuid = 0
  local maxHp = 0
  for i = 1, #list do
    local being = GetSceneBeingNpc(list[i])
    if being ~= nil then
      local props = being.data.props
      if props ~= nil then
        local hp = props:GetPropByName("Hp"):GetValue()
        if maxHp < hp then
          maxHp = hp
          beingGuid = being.data.id
        end
      end
    end
  end
  return beingGuid
end
function MyselfData:getCurElementElfID()
  return Game.SkillOptionManager:GetSkillOption(SkillOptionManager.OptionEnum.SummonElement)
end
function MyselfData:GetGemValue(paramId)
  return GemProxy.Instance:GetParamValueFromBuffParamId(paramId)
end
function MyselfData:IsOb()
  return PvpObserveProxy.Instance:IsRunning()
end
function MyselfData:GetTypeBranchNumInTeam(branchs)
  local num = 0
  local _TeamProxy = TeamProxy.Instance
  if _TeamProxy:IHaveTeam() then
    local map = ReusableTable.CreateTable()
    for i = 1, #branchs do
      map[branchs[i]] = 1
    end
    local profession, class
    local memberMap = _TeamProxy.myTeam:GetMemberMap()
    for k, v in memberMap, nil, nil do
      profession = v.profession
      if profession ~= nil then
        class = Table_Class[profession]
        if class ~= nil and map[class.TypeBranch] ~= nil then
          num = num + 1
        end
      end
    end
    ReusableTable.DestroyAndClearTable(map)
  end
  return num
end
function MyselfData:GetCatNumInTeam()
  local num = 0
  local _TeamProxy = TeamProxy.Instance
  if _TeamProxy:IHaveTeam() then
    local memberMap = _TeamProxy.myTeam:GetMemberMap()
    for k, v in memberMap, nil, nil do
      if v:IsHireMember() then
        num = num + 1
      end
    end
  end
  return num
end
function MyselfData:HasEquipFeature(feature)
  local equipBag = BagProxy.Instance:GetRoleEquipBag()
  return equipBag:GetNumByEquipFeature(feature) > 0
end
function MyselfData:AddPetID(petID)
  MyselfData.super.AddPetID(self, petID)
  EventManager.Me():PassEvent(MyselfEvent.PetChange, petID)
end
function MyselfData:RemovePetID(petID)
  MyselfData.super.RemovePetID(self, petID)
  EventManager.Me():PassEvent(MyselfEvent.PetChange, petID)
end
function MyselfData:SetReplaceNormalAtkID(skillid)
  self.replaceNormalAtkID = skillid
end
function MyselfData:GetAttackSkillIDAndLevel()
  if self.replaceNormalAtkID ~= nil then
    return self.replaceNormalAtkID
  end
  return MyselfData.super.GetAttackSkillIDAndLevel(self)
end
function MyselfData:GetBoKiSkillLv(familyId)
  return BokiProxy.Instance:GetBokiSkillLv(familyId)
end
function MyselfData:_SniperModeAdd(buffeffect)
  FunctionSniperMode.Me():Launch(buffeffect)
end
function MyselfData:_SniperModeRemove(buffeffect)
  FunctionSniperMode.Me():Shutdown(buffeffect)
end
function MyselfData:GetCurChantTime()
  return Game.Myself:GetCurChantTime()
end
function MyselfData:_FindHidingAdd(buffeffect)
  if Game.Myself then
    Game.Myself:LaunchCloseToWallCheck(buffeffect)
  end
end
function MyselfData:_FindHidingRemove()
  if Game.Myself then
    Game.Myself:ShutDownCloseToWallCheck()
  end
end
function MyselfData:_NoBulletConsumeAdd(buffeffect)
  SkillProxy.Instance:NoBulletConsumeAdd(buffeffect)
end
function MyselfData:_NoBulletConsumeRemove(buffeffect)
  SkillProxy.Instance:NoBulletConsumeRemove(buffeffect)
end
local tempBullets = 0
function MyselfData:_UpperLimitChangeAdd(buffeffect, fromID, isInit, level, active, buffID)
  if active then
    if not self.bulletsMap then
      self.bulletsMap = {}
    end
    self.bulletsMap[buffID] = buffeffect.MaxBullet
  else
    self:_UpperLimitChangeRemove(buffeffect, level, buffID)
  end
end
function MyselfData:_UpperLimitChangeRemove(buffeffect, level, buffID)
  if not self.bulletsMap then
    self.bulletsMap = {}
  end
  self.bulletsMap[buffID] = 0
end
function MyselfData:_ChangeScaleAdd(buffeffect)
  if not buffeffect.changeZoom then
    return
  end
  local cameraController = CameraController.singletonInstance
  if cameraController then
    cameraController.ZoomWithFocusScale = true
  end
end
function MyselfData:_ChangeScaleRemove(buffeffect)
  if not buffeffect.changeZoom then
    return
  end
  local cameraController = CameraController.singletonInstance
  if cameraController then
    cameraController.ZoomWithFocusScale = false
  end
end
function MyselfData:GetMaxBullets()
  if self.bulletsMap then
    tempBullets = 0
    for buffid, addon in pairs(self.bulletsMap) do
      tempBullets = tempBullets + addon
    end
    return tempBullets
  end
  return 0
end
function MyselfData:GetMapTeammateNum()
  local num = 0
  local _TeamProxy = TeamProxy.Instance
  if _TeamProxy:IHaveTeam() then
    local memberMap = _TeamProxy.myTeam:GetMemberMap()
    for k, v in memberMap, nil, nil do
      if v:IsSameMap() then
        num = num + 1
      end
    end
  end
  return num
end
function MyselfData:GetSkillMark(targetUser, markType)
  if not targetUser then
    return false
  end
  local marks = SkillProxy.Instance:GetSkillMark(markType)
  if not marks then
    return false
  end
  local isNpc = targetUser:IsNpc() or targetUser:IsMonster()
  local isPlayer = targetUser:IsPlayer()
  for i = 1, #marks do
    if isNpc and marks[i].npcid == targetUser:GetNpcID() then
      return true
    elseif isPlayer and marks[i].epro == targetUser:GetProfressionID() then
      return true
    end
  end
  return false
end
function MyselfData:GetSunMark(targetUser)
  return self:GetSkillMark(targetUser, 1)
end
function MyselfData:GetMoonMark(targetUser)
  return self:GetSkillMark(targetUser, 2)
end
function MyselfData:GetTimeDiskGrid()
  return SkillProxy.Instance:GetTimeDiskGrid() or 1
end
function MyselfData:_StarShapeAdd(buffeffect, fromID, isInit, level, active, buffID)
  local bufflayer = Game.Myself:GetBuffLayer(StarBuff) or 0
  Game.Myself:UpdateStar(bufflayer)
  self.starShapeAdd = true
end
function MyselfData:_StarShapeRemove(buffeffect, level, buffID)
  Game.Myself:RemoveStarMap()
  self.starShapeAdd = false
end
function MyselfData:UpdateStarBuff(buffID, layer)
  Game.Myself:UpdateStar(layer)
end
function MyselfData:RemoveStarBuff()
  if self.starShapeAdd then
    Game.Myself:UpdateStar(0)
  end
end
function MyselfData:_KickSkillSpeedUpAdd(buffeffect, fromID, isInit, level, active, buffID)
  self.KickSkillSpeedUp = true
end
function MyselfData:_KickSkillSpeedUpRemove(buffeffect, level, buffID)
  self.KickSkillSpeedUp = false
end
function MyselfData:_BuffSkipTimeDiskAdd(buffeffect, fromID, isInit, level, active, buffID)
  self._skipTimeDisk = true
end
function MyselfData:_BuffSkipTimeDiskRemove(buffeffect, level, buffID)
  self._skipTimeDisk = false
end
function MyselfData:GetSpareBattleTime()
  local data = ExpRaidProxy.Instance.battleTimelen
  local spareTime = data.totaltime - data.timelen
  local sparePlayTime = data.playtime - data.usedplaytime
  return spareTime + sparePlayTime
end
function MyselfData:UpdateFrenzyBuff(bufffID, layer)
  local data = Table_Buffer[bufffID]
  local buffeffect = data.BuffEffect.ChangeBuffLayer
  self.maxFrenzyLayer = CommonFun.calcBuffValue(self, self, buffeffect.type, buffeffect.a, buffeffect.b, buffeffect.c, buffeffect.d)
  if not Game.Myself:GetSceneUI() then
    local sceneUI
  end
  if sceneUI then
    sceneUI.roleBottomUI:UpdateFrenzyLayer(layer, self.maxFrenzyLayer)
  end
end
function MyselfData:RemoveFrenzyBuff(bufffID)
  local data = Table_Buffer[bufffID]
  local buffeffect = data.BuffEffect.ChangeBuffLayer
  self.maxFrenzyLayer = CommonFun.calcBuffValue(self, self, buffeffect.type, buffeffect.a, buffeffect.b, buffeffect.c, buffeffect.d)
  if not Game.Myself:GetSceneUI() then
    local sceneUI
  end
  if ProfessionProxy.IsThanatos() then
    sceneUI.roleBottomUI:UpdateFrenzyLayer(0, self.maxFrenzyLayer)
  else
    sceneUI.roleBottomUI:ShowFrenzy(false)
  end
end
function MyselfData:_DisappearAdd()
  Game.Myself:SetDisapper(true)
end
function MyselfData:_DisappearRemove()
  Game.Myself:SetDisapper(false)
end
function MyselfData:DoConstruct(asArray, serverData)
  helplog("MyselfData:DoConstruct")
  MyselfData.super.DoConstruct(self, asArray, serverData)
  self.id = serverData.id
  self.name = serverData.name
  self.dressEnable = true
  self.maxbullets = 0
  self.starShapeAdd = false
  self.spTrans = nil
end
function MyselfData:GetCurrentMaxLayer(buffid, fromid)
  if self.multiSourceBuff and self.multiSourceBuff[buffid] then
    return self.multiSourceBuff[buffid][fromid] or 0
  end
  return 0
end
function MyselfData:DoDeconstruct(asArray)
  helplog("MyselfData:DoDeconstruct")
  self.skillExtraCD = nil
  self.replaceNormalAtkID = nil
  self.maxbullets = 0
  self.spTrans = nil
  self.starShapeAdd = false
  MyselfData.super.DoDeconstruct(self, asArray)
end
function MyselfData:GetBuffStateID(staticData, stateid, newlayer, fromID, active)
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
      layer = self:GetCurrentMaxLayer(staticData.id) or 1
      layer = newlayer > layer and newlayer or layer
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
