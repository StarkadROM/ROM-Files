using("RO.RoleAvatar")
autoImport("Appellation")
autoImport("Occupation")
local MyselfProxy = class("MyselfProxy", pm.Proxy)
MyselfProxy.Instance = nil
MyselfProxy.NAME = "MyselfProxy"
function MyselfProxy:ctor(proxyName, data)
  self.proxyName = proxyName or MyselfProxy.NAME
  if MyselfProxy.Instance == nil then
    MyselfProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self.selectAutoNormalAtk = true
  self.failPassPersonalEndlessTower = false
end
function MyselfProxy:onRegister()
  self.myself = nil
  self.vars = nil
  self.buffers = nil
  self.buffAttr = nil
  self.buffersProps = RolePropsContainer.CreateAsTable()
  self.extraProps = RolePropsContainer.CreateAsTable()
  self:ClearProps()
  self.buffAttr = {}
  self.traceItems = {}
  self.equipPosStateTimeMap, self.equipPosOnCdEndTimeMap = {}, {}
  self.unlockActionIds = {}
  self.unlockEmojiIds = {}
  self:InitPropsTab()
  self.debtDatas = {}
  self.accvars = nil
end
function MyselfProxy:ClearProps()
  if self.buffersProps then
    for _, o in pairs(self.buffersProps.configs) do
      self.buffersProps:SetValueById(o.id, 0)
    end
  end
  if self.extraProps then
    for _, o in pairs(self.extraProps.configs) do
      self.extraProps:SetValueById(o.id, 0)
    end
  end
end
function MyselfProxy:CurMaxJobLevel()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.CUR_MAXJOB) or 0
end
function MyselfProxy:AllProfessionMaxJobLv()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.PROFESSION_MAXJOB) or 0
end
function MyselfProxy:onRemove()
  self.buffersProps:Destroy()
  self.buffersProps = nil
  self.extraProps:Destroy()
  self.extraProps = nil
end
function MyselfProxy:SetUserRolesInfo(snapShotUserInfo)
  if self.snapShotUserInfo == nil then
    self.snapShotUserInfo = {}
  else
    TableUtility.TableClear(self.snapShotUserInfo)
  end
  local client_datas = {}
  local server_datas = snapShotUserInfo.data
  self.roleNameValid = {}
  for i = 1, #server_datas do
    local server_data = server_datas[i]
    local snapShotDataPB = {}
    snapShotDataPB.id = server_data.id
    snapShotDataPB.baselv = server_data.baselv
    snapShotDataPB.hair = server_data.hair
    snapShotDataPB.haircolor = server_data.haircolor
    snapShotDataPB.lefthand = server_data.lefthand
    snapShotDataPB.righthand = server_data.righthand
    snapShotDataPB.body = server_data.body
    snapShotDataPB.head = server_data.head
    snapShotDataPB.back = server_data.back
    snapShotDataPB.face = server_data.face
    snapShotDataPB.tail = server_data.tail
    snapShotDataPB.mount = server_data.mount
    snapShotDataPB.eye = server_data.eye
    snapShotDataPB.partnerid = server_data.partnerid
    snapShotDataPB.portrait = server_data.portrait
    snapShotDataPB.mouth = server_data.mouth
    snapShotDataPB.clothcolor = server_data.clothcolor
    snapShotDataPB.name = server_data.name
    snapShotDataPB.sequence = server_data.sequence
    snapShotDataPB.isopen = server_data.isopen
    snapShotDataPB.deletetime = server_data.deletetime
    snapShotDataPB.gender = server_data.gender
    snapShotDataPB.profession = server_data.profession
    snapShotDataPB.name_invalid = server_data.name_invalid
    self.roleNameValid[snapShotDataPB.id] = snapShotDataPB.name_invalid
    snapShotDataPB.delete_marks = server_data.delete_marks
    table.insert(client_datas, snapShotDataPB)
  end
  self.snapShotUserInfo.data = client_datas
  self.snapShotUserInfo.lastselect = snapShotUserInfo.lastselect
  self.snapShotUserInfo.deletechar = snapShotUserInfo.deletechar
  self.snapShotUserInfo.deletecdtime = snapShotUserInfo.deletecdtime
  self.snapShotUserInfo.maincharid = snapShotUserInfo.maincharid
  self.snapShotUserInfo.area = snapShotUserInfo.area
end
function MyselfProxy:GetUserRolesInfo()
  return self.snapShotUserInfo
end
function MyselfProxy:IsCurRoleNameInValid()
  local myselfid = Game.Myself and Game.Myself.data and Game.Myself.data.id
  return myselfid and self.roleNameValid[myselfid] == true
end
function MyselfProxy:GetZenyDebt()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.ZENY_DEBT) or 0
end
function MyselfProxy:GetROB()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.SILVER) or 0
end
function MyselfProxy:GetPvpColor()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.PVP_COLOR)
end
function MyselfProxy:GetGold()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.GOLD) or 0
end
function MyselfProxy:GetDiamond()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.DIAMOND) or 0
end
function MyselfProxy:GetGarden()
  return BagProxy.Instance:GetItemNumByStaticID(GameConfig.MoneyId.Happy)
end
function MyselfProxy:GetLaboratory()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.LABORATORY) or 0
end
function MyselfProxy:RoleLevel()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL) or 0
end
function MyselfProxy:JobLevel()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.JOBLEVEL) or 0
end
function MyselfProxy:JobExp()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.JOBEXP) or 0
end
function MyselfProxy:GetMyProfession()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.PROFESSION) or 0
end
function MyselfProxy:GetMyGuildScore()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.GUILD_SCORE) or 0
end
function MyselfProxy:GetTwelvePVPCamp()
  if self:InOb() then
    return FuBenCmd_pb.EGROUPCAMP_RED
  else
    return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.TWELVEPVP_CAMP) or 1
  end
end
function MyselfProxy:UpdateObPosition(playerId, x, y, z, div)
  if self:IsObTarget(playerId) and Game.Myself then
    Game.Myself:Client_PlaceXYZTo(x, y, z, div)
  end
end
function MyselfProxy:InOb()
  return PvpObserveProxy.Instance:IsRunning()
end
function MyselfProxy:IsObTarget(id)
  return PvpObserveProxy.Instance:IsAttachingPlayer(id)
end
function MyselfProxy:GetMyProfessionType()
  local profession = self:GetMyProfession()
  profession = Table_Class[profession]
  return profession and profession.Type or 0
end
function MyselfProxy:GetMyProfessionTypeBranch()
  local profession = self:GetMyProfession()
  profession = Table_Class[profession]
  return profession and profession.TypeBranch or 0
end
function MyselfProxy:GetMyProfessionSpecial()
  local profession = self:GetMyProfession()
  profession = Table_Class[profession]
  return profession and profession.IsSpecialJob == 1
end
function MyselfProxy:GetMyRace()
  local profession = self:GetMyProfession()
  profession = Table_Class[profession]
  return profession and profession.Race
end
function MyselfProxy:GetTwelvePvpCoin()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.TWELVEPVP_COIN) or 0
end
function MyselfProxy:GetMyProfessionName()
  return ProfessionProxy.GetProfessionName(self:GetMyProfession(), self:GetMySex())
end
function MyselfProxy:IsHero()
  return ProfessionProxy.IsHero(self:GetMyProfession())
end
function MyselfProxy:GetMyMapID()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.MAPID) or 0
end
function MyselfProxy:GetServantStarCount()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.SERVANT_CHALLENGE_EXP) or 0
end
function MyselfProxy:GetMySex()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.SEX) or 1
end
function MyselfProxy:GetMyServantID()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.SERVANTID) or 0
end
function MyselfProxy:GetServantDialogIconCFG()
  local id = self:GetMyServantID()
  local cfg = GameConfig.Servant.dialogID_Icon
  if id and id ~= 0 and cfg and cfg[id] then
    return cfg[id]
  end
end
function MyselfProxy:GetZoneId()
  local myself = Game.Myself
  if myself then
    local userdata = myself.data.userdata
    return ChangeZoneProxy.Instance:GetZoneId(userdata:Get(UDEnum.ZONEID), userdata:Get(UDEnum.REAL_ZONEID))
  end
  return 0
end
function MyselfProxy:IsInPvpZone()
  local zoneid = Game.Myself and Game.Myself.data.userdata:Get(UDEnum.ZONEID) or 0
  return ChangeZoneProxy.Instance:IsPvpZone(zoneid)
end
function MyselfProxy:GetZoneString()
  return ChangeZoneProxy.Instance:ZoneNumToString(self:GetZoneId())
end
function MyselfProxy:GetServerId()
  return FunctionLogin.Me():GetLineGroup() or 1
end
function MyselfProxy:IsSameServer(serverid)
  return serverid == self:GetServerId()
end
function MyselfProxy:GetMyTradeGroup()
  return ChangeZoneProxy.Instance:GetTradeGroupID(self:GetServerId()) or 0
end
function MyselfProxy:IsSameTradeGroup(groupid)
  return self:GetMyTradeGroup() == groupid
end
function MyselfProxy:GetQuota()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.QUOTA) or 0
end
function MyselfProxy:GetQuotaLock()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.QUOTA_LOCK) or 0
end
function MyselfProxy:GetHasCharge()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.HASCHARGE) or 0
end
function MyselfProxy:GetMyselfFashionHide()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.MYSELF_FASHION_HIDE) or 0
end
function MyselfProxy:GetQueryType()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.QUERYTYPE) or 0
end
function MyselfProxy:GetQueryWeddingType()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.QUERYWEDDINGTYPE) or 0
end
function MyselfProxy:GetPvpCoin()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.PVPCOIN) or 0
end
function MyselfProxy:GetLottery()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.LOTTERY) or 0
end
function MyselfProxy:GetGuildHonor()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.GUILDHONOR) or 0
end
function MyselfProxy:GetServantFavorability()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.FAVORABILITY) or 0
end
function MyselfProxy:GetBoothScore()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.BOOTH_SCORE) or 0
end
function MyselfProxy:GetExpRaidScore()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.EXPRAID_SCORE) or 0
end
function MyselfProxy:GetExpRaidScoreInRaid()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.EXPRAID_SCORE_RAID) or 0
end
function MyselfProxy:GetBeingCount()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.BEING_COUNT) or 1
end
function MyselfProxy:GetContribution()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.CONTRIBUTE) or 0
end
function MyselfProxy:GetBindContribution()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.BIND_CONTRIBUTE) or 0
end
function MyselfProxy:GetDressUp()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.DRESSUP) or 0
end
function MyselfProxy:GetFreeLottery()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.FREELOTTERY) or 0
end
function MyselfProxy:GetGagTime()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.GAGTIME) or 0
end
function MyselfProxy:IsInGagTime()
  local time = self:GetGagTime()
  if time == 0 then
    return false
  end
  local serverTime = ServerTime.CurServerTime() / 1000
  if time < serverTime then
    return false
  end
  return true, time - serverTime
end
function MyselfProxy:GetOfflineStamp()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.AFK_FUNCTIME) or 0
end
function MyselfProxy:GetAfkRemainingTime()
  local seconds = self:GetOfflineStamp() - ServerTime.CurServerTime() / 1000
  if seconds < 0 then
    seconds = 0
  end
  return seconds
end
function MyselfProxy:GetAfkStatus()
  local remainingTime = self:GetAfkRemainingTime()
  if remainingTime <= 0 then
    return true, 0
  end
  return false, remainingTime
end
function MyselfProxy:ResetMyBornPos(x, y, z)
  LogUtility.Info("bornPos.." .. x .. " " .. y .. " " .. z)
  if Game.Myself then
    Game.Myself:Server_SetPosXYZCmd(x, y, z, 1000)
  end
end
function MyselfProxy:ResetMyPos(x, y, z, isgomap)
  if isgomap == nil then
    isgomap = false
  end
  if Game.Myself then
    Game.Myself:Server_SetPosXYZCmd(x, y, z, 1000)
  else
    LogUtility.Info("?????????????????????????????????myself")
  end
end
function MyselfProxy:SetProps(UserAttrSyncCmd, update)
  self:setExtraProps(UserAttrSyncCmd.pointattrs, update)
  if Game.Myself then
    Game.Myself:Server_SetUserDatas(UserAttrSyncCmd.datas, not update)
    Game.Myself:Server_SetAttrs(UserAttrSyncCmd.attrs)
  end
end
function MyselfProxy:InitNMyself(data)
  if Game.Myself == nil then
    local myData = MyselfData.CreateAsTable(data)
    Game.Myself = NMyselfPlayer.CreateAsTable(myData)
    GAME_MYSELF_GUID = Game.Myself.data.id
  end
  FunctionSkillEnableCheck.Me():SetMySelf(Game.Myself)
end
function MyselfProxy:SetMySelfCurRole(data)
  if not self.myself then
    self:InitNMyself(data)
  end
  FunctionPlayerPrefs.Me():InitUser(data.id)
  LocalSaveProxy.Instance:InitDontShowAgain()
  LocalSaveProxy.Instance:InitWorldQuestNewTag()
  LocalSaveProxy.Instance:InitBannerDontShowAgain()
  FunctionPerformanceSetting.Me():Load()
  if PQTL_Manager.Instance then
    PQTL_Manager.Instance.MyselfGUID = data.id
  end
end
function MyselfProxy:InitRole(data)
  local p = self.myself or MySelfPlayer.new(data.id)
  p.name = data.name
  p.roleInfo.ID = data.id
  p:ResetPropToRoleInfo()
  return p
end
function MyselfProxy:SetChooseRoleId(id)
  self.chooseRoleId = id
end
function MyselfProxy:GetChooseRoleId()
  return self.chooseRoleId
end
function MyselfProxy:SetShortCuts(shortCuts)
  if shortCuts ~= nil then
    for i = 1, #shortCuts do
    end
  end
end
function MyselfProxy:RecvVarUpdate(data)
  if self.vars == nil then
    self.vars = {}
  end
  if self.accvars == nil then
    self.accvars = {}
  end
  if data ~= nil and data.vars ~= nil then
    local vars = data.vars
    local varslen = #vars
    for i = 1, varslen do
      local single = vars[i]
      if single then
        local varData = self.vars[single.type]
        if not varData then
          varData = {
            type = single.type,
            time = single.time
          }
          self.vars[single.type] = varData
        end
        varData.value = single.value
      end
    end
  end
  if data ~= nil and data.accvars ~= nil then
    local accvars = data.accvars
    local acclen = #accvars
    for i = 1, acclen do
      local single = accvars[i]
      if single then
        local accvarData = self.accvars[single.type]
        if not accvarData then
          accvarData = {
            type = single.type,
            time = single.time
          }
          self.accvars[single.type] = accvarData
        end
        accvarData.value = single.value
      end
    end
  end
end
function MyselfProxy:getVarByType(type)
  if self.vars == nil then
    return
  end
  return self.vars[type]
end
function MyselfProxy:getVarValueByType(type)
  if not self.vars or not type then
    return
  end
  return self.vars[type] and self.vars[type].value
end
function MyselfProxy:GetAccVarByType(type)
  if self.accvars == nil then
    return
  end
  return self.accvars[type]
end
function MyselfProxy:GetAccVarValueByType(type)
  if not self.accvars then
    return
  end
  return self.accvars[type] and self.accvars[type].value
end
function MyselfProxy:RecvBufferUpdate(data)
  printRed("MyselfProxy:RecvBufferUpdate( data )")
  self.buffers = self.buffers or {}
  local updateBffs = {}
  local addBffs = {}
  if data.buff then
    for i = 1, #data.buff do
      local single = data.buff[i]
      if self.buffers[single.id] then
        local data = {}
        data.id = single.id
        data.oldLayer = self.buffers[single.id]
        data.newLayer = single.layer
        table.insert(updateBffs, data)
      else
        table.insert(addBffs, single)
      end
      self.buffers[single.id] = single.layer
    end
  end
  for i = 1, #updateBffs do
    local single = updateBffs[i]
    local buffData = Table_Buffer[single.id]
    local effect = buffData.BuffEffect
    local newLayer = single.newLayer
    local oldLayer = single.oldLayer
    if effect.type == "AttrChange" then
      for j, w in pairs(effect) do
        local prop = self.buffersProps[j]
        if j ~= "type" and prop and type(w) == "number" then
          local oldValue = self.buffersProps:GetValueByName(j)
          local deltaValue = (newLayer - oldLayer) * w
          if prop.propVO.isPercent then
            deltaValue = deltaValue * 1000
            oldValue = oldValue * 1000
          end
          local value = oldValue + deltaValue
          self.buffersProps:SetValueByName(j, value)
          self.buffAttr[j] = value
        end
      end
    end
  end
  for i = 1, #addBffs do
    local single = addBffs[i]
    local buffData = Table_Buffer[single.id]
    if buffData ~= nil and buffData.BuffEffect ~= nil then
      local effect = buffData.BuffEffect
      local v = single.layer
      if effect.type == "AttrChange" then
        for j, w in pairs(effect) do
          if j ~= "type" and type(w) == "number" then
            local prop = self.buffersProps[j]
            if prop then
              local oldValue = self.buffersProps:GetValueByName(j)
              local deltaValue = w * v
              if prop.propVO.isPercent then
                deltaValue = deltaValue * 1000
                oldValue = oldValue * 1000
              end
              local vl = deltaValue + oldValue
              self.buffersProps:SetValueByName(j, vl)
              self.buffAttr[j] = vl
            end
          end
        end
      end
    end
  end
end
function MyselfProxy:setExtraProps(props, update)
  if props ~= nil and #props > 0 then
    for i = 1, #props do
      if props[i] ~= nil then
        self.extraProps:SetValueById(props[i].type, props[i].value)
      end
    end
  end
end
function MyselfProxy:checkProfessionIsOpenById(profession)
  self:checkProfessionIsOpenByProfessionData(Table_Class[profession])
  return false
end
function MyselfProxy:checkProfessionIsOpenByProfessionData(professionData)
  return false
end
function MyselfProxy:initAllTitle(data)
  self.appellations = {}
  local titles = data.title_datas
  for i = 1, #titles do
    local title = titles[i]
    local Appellation = Appellation.new(title.id, title.title_type, title.createtime)
    self.appellations[#self.appellations + 1] = Appellation
  end
end
function MyselfProxy:newTitle(data)
  local titleData = data.title_data
  local id = data.charid
  if id == Game.Myself.data.id then
    local Appellation = Appellation.new(titleData.id, titleData.title_type, titleData.createtime)
    for i = 1, #self.appellations do
      local title = self.appellations[i]
      if title.id == Appellation.id then
        self.appellations[i] = Appellation
        return
      end
    end
    self.appellations[#self.appellations + 1] = Appellation
  end
  if titleData.title_type == UserEvent_pb.ETITLE_TYPE_MANNUAL then
    local creature = NSceneUserProxy.Instance:Find(id)
    if creature then
      GameFacade.Instance:sendNotification(SceneUserEvent.LevelUp, creature, SceneUserEvent.AppellationUp)
    end
  end
end
function MyselfProxy:GetCurManualAppellation()
  local curApp
  for i = 1, #self.appellations do
    local title = self.appellations[i]
    if title.titleType == UserEvent_pb.ETITLE_TYPE_MANNUAL and not curApp then
      curApp = title
      break
    end
  end
  if curApp then
    local nextApp = self:getAppellationById(curApp.staticData.PostID)
    while nextApp do
      curApp = nextApp
      nextApp = self:getAppellationById(curApp.staticData.PostID)
    end
  end
  return curApp
end
function MyselfProxy:GetCurFoodCookerApl()
  local curApp
  for i = 1, #self.appellations do
    local title = self.appellations[i]
    if title.titleType == UserEvent_pb.ETITLE_TYPE_FOODCOOKER and not curApp then
      curApp = title
      break
    end
  end
  if curApp then
    local nextApp = self:getAppellationById(curApp.staticData.PostID)
    while nextApp do
      curApp = nextApp
      nextApp = self:getAppellationById(curApp.staticData.PostID)
    end
  end
  return curApp
end
function MyselfProxy:GetCurFoodTasteApl()
  local curApp
  for i = 1, #self.appellations do
    local title = self.appellations[i]
    if title.titleType == UserEvent_pb.ETITLE_TYPE_FOODTASTER and not curApp then
      curApp = title
      break
    end
  end
  if curApp then
    local nextApp = self:getAppellationById(curApp.staticData.PostID)
    while nextApp do
      curApp = nextApp
      nextApp = self:getAppellationById(curApp.staticData.PostID)
    end
  end
  return curApp
end
function MyselfProxy:getAppellationById(id)
  if not id then
    return
  end
  for i = 1, #self.appellations do
    local title = self.appellations[i]
    if title.id == id then
      return title
    end
  end
end
function MyselfProxy:SetTraceItem(updates, dels)
  if updates then
    for i = 1, #updates do
      local upItem = updates[i]
      self.traceItems[upItem.itemid] = upItem
    end
  end
  if dels then
    for i = 1, #dels do
      local delid = dels[i]
      self.traceItems[delid] = nil
    end
  end
end
function MyselfProxy:GetTraceItems()
  local result = {}
  for _, item in pairs(self.traceItems) do
    table.insert(result, item)
  end
  return result
end
function MyselfProxy:GetTraceItemByItemId(itemid)
  return self.traceItems[itemid]
end
function MyselfProxy:SetUnlockActionIdMap(ids)
  for i = 1, #ids do
    local id = ids[i]
    self.unlockActionIds[id] = 1
  end
end
function MyselfProxy:GetUnlockActionMap()
  return self.unlockActionIds
end
function MyselfProxy:SetUnlockEmojiMap(ids)
  for i = 1, #ids do
    local id = ids[i]
    self.unlockEmojiIds[id] = 1
  end
end
function MyselfProxy:GetUnlockEmojiMap()
  return self.unlockEmojiIds
end
function MyselfProxy:HasJobBreak()
  if GameConfig.SystemForbid.Peak then
    return false
  end
  local _FunctionUnLockFunc = FunctionUnLockFunc.Me()
  return _FunctionUnLockFunc:CheckCanOpen(450) or _FunctionUnLockFunc:CheckCanOpen(453)
end
function MyselfProxy:HasJobNewBreak()
  return FunctionUnLockFunc.Me():CheckCanOpen(451)
end
function MyselfProxy:HasMaxJobBreak()
  return self:HasJobBreak() and self:CurMaxJobLevel() >= GameConfig.Dead.max_peaklv or false
end
function MyselfProxy:UpdateRandomFunc(array, beginIndex, endIndex)
  if nil ~= self.myself then
    self.myself:UpdateRandomFunc(array, beginIndex, endIndex)
  end
  if nil ~= Game.Myself then
    Game.Myself.data:UpdateRandomFunc(array, beginIndex, endIndex)
  end
end
function MyselfProxy:Server_SetEquipPos_StateTime(server_EquipPosDatas)
  local logStr = "????????????:"
  for i = 1, #server_EquipPosDatas do
    local d = server_EquipPosDatas[i]
    local ld = self.equipPosStateTimeMap[d.pos]
    if ld == nil then
      ld = {}
      self.equipPosStateTimeMap[d.pos] = ld
    end
    ld.offstarttime = d.offstarttime
    ld.offendtime = d.offendtime
    ld.offduration = d.offendtime - d.offstarttime
    ld.protecttime = d.protecttime
    ld.protectalways = d.protectalways
    logStr = logStr .. string.format("??????:%s || ??????????????????:%s ??????????????????:%s ??????????????????:%s ??????????????????:%s", tostring(d.pos), os.date("%m???%d???%H???%M???%S???", d.offstarttime), os.date("%m???%d???%H???%M???%S???", d.offendtime), os.date("%m???%d???%H???%M???%S???", d.protecttime), tostring(d.protectalways))
    logStr = logStr .. "\n"
  end
  helplog(logStr)
  FunctionBuff.Me():UpdateOffingEquipBuff()
  FunctionBuff.Me():UpdateProtectEquipBuff()
end
function MyselfProxy:GetEquipPos_StateTime(site)
  return self.equipPosStateTimeMap[site]
end
function MyselfProxy:IsEquipPosInOffing(site)
  local stateTime = self:GetEquipPos_StateTime(site)
  if stateTime and stateTime.offendtime and stateTime.offendtime > 0 then
    return 0 < ServerTime.ServerDeltaSecondTime(stateTime.offendtime * 1000)
  end
  return false
end
function MyselfProxy:GetOffingEquipPoses()
  local offPoses = {}
  for k, v in pairs(self.equipPosStateTimeMap) do
    if self:IsEquipPosInOffing(k) then
      table.insert(offPoses, k)
    end
  end
  table.sort(offPoses, function(a, b)
    return a < b
  end)
  return offPoses
end
function MyselfProxy:IsEquipPosInProtecting(site)
  local stateTime = self:GetEquipPos_StateTime(site)
  if stateTime then
    if stateTime.protectalways > 0 then
      return true
    end
    if stateTime.protecttime and 0 < stateTime.protecttime then
      return 0 < ServerTime.ServerDeltaSecondTime(stateTime.protecttime * 1000)
    end
  end
  return false
end
function MyselfProxy:HandleRelieveCd(data)
  self.reliveStamp = data.time + ServerTime.CurServerTime() / 1000
  self.reliveName = data.name
end
function MyselfProxy:ClearReliveCd()
  self.reliveStamp = nil
  self.reliveName = nil
end
function MyselfProxy:HandleRelieveFubenCd(data)
  self.reliveFubenCD = data.next_relive_time
end
function MyselfProxy:ClearReliveFubenCd()
  self.reliveFubenCD = nil
end
function MyselfProxy:GetProtectEquipPoses()
  local protectPoses = {}
  for k, v in pairs(self.equipPosStateTimeMap) do
    if self:IsEquipPosInProtecting(k) then
      table.insert(protectPoses, k)
    end
  end
  table.sort(protectPoses, function(a, b)
    return a < b
  end)
  return protectPoses
end
function MyselfProxy:IsUnlockAstrolabe()
  local panelId = PanelConfig.AstrolabeView.id
  return FunctionUnLockFunc.Me():CheckCanOpenByPanelId(panelId)
end
function MyselfProxy:SetDebts(data)
  TableUtility.ArrayClear(self.debtDatas)
  if not data.acc_items then
    return
  end
  local accItems = data.acc_items
  for i = 1, #accItems do
    local single = accItems[i].base
    local data = {
      id = single.id,
      num = single.count,
      type = 1
    }
    self.debtDatas[#self.debtDatas + 1] = data
  end
end
local debtsResult = {}
function MyselfProxy:GetDebts()
  TableUtility.ArrayClear(debtsResult)
  for i = 1, #self.debtDatas do
    debtsResult[#debtsResult + 1] = self.debtDatas[i]
  end
  local zenyDebt = self:GetZenyDebt()
  if zenyDebt > 0 then
    local data = {
      id = GameConfig.MoneyId.Zeny,
      num = zenyDebt,
      type = 3
    }
    debtsResult[#debtsResult + 1] = data
  end
  return debtsResult
end
function MyselfProxy:InitPropsTab()
  self.propTabConfigs = {}
  local PropTabConfig = GameConfig.PropTabConfig
  if not PropTabConfig then
    return
  end
  local propsTable = Table_RoleData
  for k, v in pairs(propsTable) do
    local class = v.class
    if class then
      local propTab = PropTabConfig[class]
      if propTab then
        if not self.propTabConfigs[class] then
          local propConfigData = {
            desc = propTab.desc,
            name = propTab.name,
            props = {},
            id = propTab.id
          }
        end
        local props = propConfigData.props
        props[#props + 1] = v
        self.propTabConfigs[class] = propConfigData
      end
    end
  end
  for k, v in pairs(self.propTabConfigs) do
    local props = v.props
    table.sort(props, function(l, r)
      return l.order < r.order
    end)
  end
end
function MyselfProxy:GetTotalNeedBaseExp()
  local userData = Game.Myself.data.userdata
  local roleExp = userData:Get(UDEnum.ROLEEXP) or 0
  local tempExpNeed = 0
  local tempLevel = self:RoleLevel()
  local maxLevel = userData:Get(UDEnum.ROLELEVEL_MAX) or Table_BaseLevel[#Table_BaseLevel].id
  while tempLevel < maxLevel do
    local nextBaseLevel = Table_BaseLevel[tempLevel + 1]
    if nextBaseLevel then
      tempExpNeed = tempExpNeed + nextBaseLevel.NeedExp
      tempLevel = tempLevel + 1
    else
      break
    end
  end
  tempExpNeed = tempExpNeed - roleExp
  return tempExpNeed
end
function MyselfProxy:GetTotalNeedJobExp()
  local userData = Game.Myself.data.userdata
  local nowJob = Game.Myself.data:GetCurOcc()
  local maxJobLevel = userData:Get(UDEnum.CUR_MAXJOB) or 0
  local tempJobExpNeed = 0
  local tempJobLevel = nowJob.level
  local isHero = ProfessionProxy.IsHero(nowJob.profession)
  while maxJobLevel > tempJobLevel do
    local nextJobLevel = Table_JobLevel[tempJobLevel + 1]
    if nextJobLevel then
      local nextExpValue = isHero and Table_JobLevel[tempJobLevel + 1].HeroJobExp or Table_JobLevel[tempJobLevel + 1].JobExp
      tempJobExpNeed = tempJobExpNeed + nextExpValue
      tempJobLevel = tempJobLevel + 1
    else
      break
    end
  end
  tempJobExpNeed = tempJobExpNeed - nowJob.exp
  return tempJobExpNeed
end
function MyselfProxy:SyncEquipPosOnCd(datas)
  if not datas then
    return
  end
  local element
  for i = 1, #datas do
    element = datas[i]
    self.equipPosOnCdEndTimeMap[element.pos] = element.time
  end
end
function MyselfProxy:GetEquipPosOnCdTime(pos)
  local endTime = self.equipPosOnCdEndTimeMap[pos]
  if not endTime then
    return
  end
  local delta = ServerTime.ServerDeltaSecondTime(endTime * 1000)
  if delta <= 0 then
    self.equipPosOnCdEndTimeMap[pos] = nil
    return
  end
  return delta
end
function MyselfProxy:GetOtherPlayerEquipHide()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.HIDEOTHER) or 0
end
function MyselfProxy:SetQuestRepairMode(bool)
  xdlog("??????????????????", bool)
  self.questRepairModeOn = bool
  GameFacade.Instance:sendNotification(QuestEvent.QuestRepairMode, self.questRepairModeOn)
end
function MyselfProxy:SetTargetAndPos(data)
  if data and data.sign then
    self.targetGuid = data.guid
    self.targetPos = ProtolUtility.S2C_Vector3(data.pos)
  else
    self.targetGuid = nil
    if self.targetPos then
      self.targetPos:Destroy()
      self.targetPos = nil
    end
  end
end
function MyselfProxy:GetTargetAndPos()
  return self.targetGuid, self.targetPos
end
function MyselfProxy:SetMaxBullets(value)
  self.maxBulltes = value
end
function MyselfProxy:SetCurBullets(value)
  self.curBulltes = value
end
function MyselfProxy:GetCurBullets(value)
  return self.curBulltes or 0
end
function MyselfProxy:GetMyDefaultTeamRole()
  local profession = self:GetMyProfession()
  profession = Table_Class[profession]
  return profession and profession.TeamFunction and profession.TeamFunction.default
end
function MyselfProxy:GetMyTeamRoles()
  local profession = self:GetMyProfession()
  profession = Table_Class[profession]
  return profession and profession.TeamFunction and profession.TeamFunction.selects
end
function MyselfProxy:GetWantedBaseLv(extraExp)
  if extraExp <= 0 then
    return 0, 0
  end
  local myRoleLv = self:RoleLevel()
  local roleExp = Game.Myself and Game.Myself.data.userdata:Get(UDEnum.ROLEEXP)
  extraExp = extraExp + roleExp
  local baseData
  local upgradeLv = 0
  while extraExp > 0 do
    myRoleLv = myRoleLv + 1
    baseData = Table_BaseLevel[myRoleLv]
    if not baseData then
      return upgradeLv, 0
    end
    if extraExp < baseData.NeedExp then
      return upgradeLv, upgradeLv > 0 and extraExp or extraExp - roleExp
    end
    extraExp = extraExp - baseData.NeedExp
    upgradeLv = upgradeLv + 1
  end
end
function MyselfProxy:GetWantedJobLv(extraExp)
  if extraExp <= 0 then
    return 0, 0
  end
  local pro = self:GetMyProfession()
  local cur_lv = self:JobLevel()
  local cur_max = self:CurMaxJobLevel()
  local refactoryLv, cur_max = Occupation.GetMyFixedJobLevelWithMax_Refactory(cur_lv, cur_max, pro)
  local curOcc = Game.Myself.data:GetCurOcc()
  local isHero = ProfessionProxy.IsHero(pro)
  extraExp = extraExp + curOcc.exp
  local jobData
  local upgradeLv = 0
  while extraExp > 0 do
    cur_lv = cur_lv + 1
    if cur_max <= refactoryLv + upgradeLv then
      return upgradeLv, 0
    end
    jobData = Table_JobLevel[cur_lv]
    local curLeveljobExp = isHero and jobData.HeroJobExp or jobData.JobExp or 0
    if extraExp < curLeveljobExp then
      return upgradeLv, upgradeLv > 0 and extraExp or extraExp - curOcc.exp
    end
    extraExp = extraExp - (isHero and jobData.HeroJobExp or jobData.JobExp or 0)
    upgradeLv = upgradeLv + 1
  end
end
return MyselfProxy
