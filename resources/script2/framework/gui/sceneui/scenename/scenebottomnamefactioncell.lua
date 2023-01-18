local BaseCell = autoImport("BaseCell")
autoImport("UnionLogo")
SceneBottomNameFactionCell = reusableClass("SceneBottomNameFactionCell", BaseCell)
SceneBottomNameFactionCell.resId = ResourcePathHelper.UIPrefab_Cell("SceneBottomNameFactionCell")
SceneBottomNameFactionCell.npcColor = Color(1, 0.7725490196078432, 0.0784313725490196, 1)
SceneBottomNameFactionCell.playerOrMstColor = Color(0.984313725490196, 0.9450980392156862, 0.9098039215686274, 1)
SceneBottomNameFactionCell.playerEnemyColor = Color(1, 0, 0, 1)
SceneBottomNameFactionCell.OpitimizedMode = false
local tempVector3 = LuaVector3.Zero()
local tempVector2 = LuaVector2.Zero()
SceneBottomNameFactionCell.PoolSize = 50
function SceneBottomNameFactionCell:Construct(asArray, args)
  self:DoConstruct(asArray, args)
end
function SceneBottomNameFactionCell:DoConstruct(asArray, args)
  self._alive = true
  local gameObject = args[1]
  local creature = args[2]
  self.gameObject = gameObject
  if creature:GetCreatureType() == Creature_Type.Me then
    LuaVector3.Better_Set(tempVector3, 0, -19, 0)
  else
    LuaVector3.Better_Set(tempVector3, 0, -10, 0)
  end
  self.transform = self.gameObject.transform
  self.transform.localPosition = tempVector3
  self.transform.localRotation = LuaGeometry.Const_Qua_identity
  LuaVector3.Better_Set(tempVector3, 1, 1, 1)
  self.transform.localScale = tempVector3
  self.canvasGroup = gameObject:GetComponent(CanvasGroup)
  self:initData(creature)
  self:initNameView()
  self:initFactionView()
  self:SetName(creature)
  self:SetFaction(creature)
  self:ChangeNameFactionForServant(creature)
end
function SceneBottomNameFactionCell:refreshData(_parent, _creature)
  SetParent(self.gameObject, _parent.transform)
  self.transform.localPosition = LuaGeometry.GetTempVector3(0, _creature:GetCreatureType() == Creature_Type.Me and -19 or -10, 0)
  self.transform.localRotation = LuaGeometry.Const_Qua_identity
  self.transform.localScale = LuaGeometry.Const_V3_one
  self:initData(_creature)
  self:SetName(_creature)
  self:SetFaction(_creature)
  self:ChangeNameFactionForServant(_creature)
end
function SceneBottomNameFactionCell:initData(creature)
  self.ismyselfPet = self.creatureType == Creature_Type.Pet and creature:IsMyPet()
end
function SceneBottomNameFactionCell:Deconstruct(asArray)
  if not LuaGameObject.ObjectIsNull(self.gameObject) then
    local parent = self.transform.parent
    if SceneBottomNameFactionCell.OpitimizedMode and not self:ObjIsNil(parent) then
      SetParent(self.gameObject, parent.parent)
      Game.GOLuaPoolManager:AddToSceneUIMovePool(SceneBottomNameFactionCell.resId, self.gameObject)
    else
      Game.GOLuaPoolManager:AddToSceneUIPool(SceneBottomNameFactionCell.resId, self.gameObject)
    end
  end
  if self.customIconGuildID then
    GuildPictureManager.Instance():RemoveGuildPicRelative(self.customIconGuildID, self.masterID)
  end
  self.canvasGroup = nil
  self.masterID = nil
  self.customIconGuildID = nil
  self.factionIconAnchor = nil
  self.factionIcon = nil
  self.factionIconBg = nil
  self.factionIcon_ = nil
  self.factionName = nil
  self.factionJob = nil
  self.factionInfo = nil
  self.factionTable = nil
  self.factionAnchor = nil
  self.uiname = nil
  self.gameObject = nil
  self.transform = nil
  self.factionInfoRectTrans = nil
  self.isVisible = nil
  self._alive = false
end
function SceneBottomNameFactionCell:Exit()
  TableUtility.TableClear(self)
end
function SceneBottomNameFactionCell:initFactionView()
  self.factionIcon = self:FindGO("factionIcon"):GetComponent(Image)
  self.factionIconBg = self:FindGO("factionIconBg", self.factionIcon.gameObject):GetComponent(Image)
  self.factionIcon_ = self:FindGO("factionIcon_"):GetComponent(RawImage)
  self.factionName = self:FindGO("factionName"):GetComponent(Text)
  self.factionJob = self:FindGO("factionJob"):GetComponent(Text)
  self.factionInfo = self:FindGO("factionInfo")
  self.factionInfoRectTrans = self:FindComponent("factionInfo", RectTransform)
end
function SceneBottomNameFactionCell:initNameView()
  self.uiname = self:FindGO("playerName"):GetComponent(Text)
  LuaVector3.Better_Set(tempVector3, 0, 0, 0)
  self.uiname.transform.localPosition = tempVector3
end
function SceneBottomNameFactionCell:SetName(creature)
  local creatureData = creature.data
  local staticData = creatureData.staticData
  local name = creatureData:GetName(true)
  local camp = creatureData:GetCamp()
  local creatureType = creature:GetCreatureType()
  local isWeaponPet = staticData and staticData.Type == "WeaponPet"
  local isNpc = creatureType == Creature_Type.Npc and camp ~= RoleDefines_Camp.ENEMY
  local isPlayerEnemy = creatureType == Creature_Type.Player and camp == RoleDefines_Camp.ENEMY
  local detailedType = creature.data.detailedType
  local isCopyNPCEnemy = detailedType == NpcData.NpcDetailedType.CopyNpc and camp == RoleDefines_Camp.ENEMY
  local isPetEnemy = creatureType == Creature_Type.Pet and camp == RoleDefines_Camp.ENEMY
  local color = self.uiname.color
  if isNpc or isWeaponPet then
    if color ~= SceneBottomNameFactionCell.npcColor then
      self.uiname.color = SceneBottomNameFactionCell.npcColor
    end
  elseif isPlayerEnemy or isCopyNPCEnemy or isPetEnemy then
    if color ~= SceneBottomNameFactionCell.playerEnemyColor then
      self.uiname.color = SceneBottomNameFactionCell.playerEnemyColor
    end
  elseif color ~= SceneBottomNameFactionCell.playerOrMstColor then
    self.uiname.color = SceneBottomNameFactionCell.playerOrMstColor
  end
  if isWeaponPet then
    local masterName = TeamProxy.Instance:GetCatMasterName(creatureData:GetGuid())
    if masterName then
      name = string.format(ZhString.SceneNameView_MasterName, name, masterName)
    end
  end
  if creatureData.GetAchievementtitle then
    local _GuildProxy = GuildProxy.Instance
    local isPlayerMercenary = _GuildProxy:IsPlayerMercenary(creatureData) and Game.MapManager:IsInGVG()
    if isPlayerMercenary then
      name = _GuildProxy:IsPlayerInMyGuildUnion(creatureData) or creatureData:GetMercenaryGuildName() or name
      name = ZhString.SceneBottomNameFactionCell_Mercenary .. name
    elseif not PvpObserveProxy.Instance:IsRunning() and not Game.MapManager:IsPvpMode_DesertWolf() then
      local titleId = creatureData:GetAchievementtitle()
      local titleData = Table_Appellation[titleId]
      if titleData then
        if titleData.OrderType == 1 then
          name = name .. " [" .. titleData.Name .. "]"
        else
          name = "[" .. titleData.Name .. "] " .. name
        end
      end
    end
  end
  name = Game.simpleReplace(name)
  self.uiname.text = name
end
function SceneBottomNameFactionCell:SetQuestPrefixName(creature, isShow)
  local name = creature.data:GetName(true)
  if isShow then
    name = string.format("{uiicon=%s}%s", "icon_39", name)
  end
  name = Game.simpleReplace(name)
  self.uiname.text = name
end
function SceneBottomNameFactionCell:SetFaction(creature)
  local objNull = self:ObjIsNil(self.factionName)
  if objNull then
    return
  end
  local creatureType = creature:GetCreatureType()
  local creatureData = creature.data
  local isPlayer = creatureType == Creature_Type.Player
  local inOb = PvpObserveProxy.Instance:IsRunning()
  local isInDesertWolf = Game.MapManager:IsPvpMode_DesertWolf()
  if inOb and isPlayer or isInDesertWolf and (isPlayer or creatureData.id == Game.Myself.data.id) then
    self:Hide(self.factionJob.gameObject)
    self:Hide(self.factionIcon_.gameObject)
    self.factionInfo:SetActive(false)
    local classID = creatureData:GetClassID()
    local classData = classID and Table_Class[classID]
    if not classData then
      return
    end
    local careerIcon = classData.icon
    careerIcon = careerIcon and string.gsub(careerIcon, "icon", "career")
    local careerIconSetSuccess = SpriteManager.SetUISprite("sceneui", careerIcon, self.factionIcon)
    if not careerIconSetSuccess then
      self.factionIcon.sprite = nil
      self:Hide(self.factionIcon.gameObject)
    else
      local tempVector3 = LuaGeometry.GetTempVector3(0, 10, 0)
      self.factionIcon.transform.localPosition = tempVector3
      self:Show(self.factionIcon.gameObject)
    end
    local careerIconBgSetSuccess = SpriteManager.SetUISprite("sceneui", "com_bg_career_s", self.factionIconBg)
    if careerIconBgSetSuccess then
      local colorKey = "CareerIconBg" .. classData.Type
      self:Show(self.factionIconBg.gameObject)
      self.factionIconBg.color = ProfessionProxy.Instance:SafeGetColorFromColorUtil(colorKey)
    end
    return
  end
  self.factionIcon.transform.localPosition = LuaGeometry.Const_V3_zero
  self.factionInfo:SetActive(true)
  self:Hide(self.factionIconBg.gameObject)
  local notHuSongPet = false
  local ismyselfPet = creatureType == Creature_Type.Pet and creature:IsMyPet()
  if ismyselfPet and self.detailedType ~= NpcData.NpcDetailedType.Escort then
    notHuSongPet = true
  end
  local npcOrMonstData = creatureData.staticData
  local guildjob = ""
  local guildname = ""
  local guildicon, customicon, picType
  local guildData = Game.MapManager:IsInGVG() and creatureData:GetMercenaryGuildData() or creatureData:GetGuildData()
  if guildData then
    guildjob = guildData.job
    guildicon = guildData.icon
    guildname = guildData.name
    if guildData.customIconIndex and guildData.customIconIndex ~= 0 then
      customicon = guildData.customIconIndex
      picType = guildData.picType
    end
  end
  local factionNameActive, factionJobActive = true, true
  if npcOrMonstData and npcOrMonstData.Guild ~= "" then
    self.factionName.text = npcOrMonstData.Guild
    self:Show(self.factionName.gameObject)
  elseif guildname and guildname ~= "" then
    self.factionName.text = guildname
    self:Show(self.factionName.gameObject)
  else
    self:Hide(self.factionName.gameObject)
    self.factionName.text = " "
    factionNameActive = false
  end
  if npcOrMonstData and npcOrMonstData.Position ~= "" then
    self.factionJob.text = npcOrMonstData.Position
    self:Show(self.factionJob.gameObject)
  elseif guildjob and guildjob ~= "" then
    self.factionJob.text = "<color=#FFC514FF>[" .. OverSea.LangManager.Instance():GetLangByKey(guildjob) .. "]</color>"
    self:Show(self.factionJob.gameObject)
  else
    self.factionJob.text = ""
    self:Hide(self.factionJob.gameObject)
    factionJobActive = false
  end
  local showFc = npcOrMonstData and npcOrMonstData.GuildEmblem and npcOrMonstData.GuildEmblem ~= ""
  local lplayerFc = guildicon ~= nil
  if ismyselfPet and not notHuSongPet then
    self.factionName.text = ZhString.PlayerBottomViewCell_Husong
    self.factionJob.text = ""
  end
  self:Hide(self.factionIcon.gameObject)
  self:Hide(self.factionIcon_.gameObject)
  if self.customIconGuildID then
    GuildPictureManager.Instance():RemoveGuildPicRelative(self.customIconGuildID, self.masterID)
    self.customIconGuildID = nil
  end
  self.masterID = creatureData.id
  if showFc or lplayerFc or customicon then
    if not npcOrMonstData or not npcOrMonstData.GuildEmblem then
      local guildEmblem
    end
    if lplayerFc then
      self:Hide(self.factionIcon_.gameObject)
      local result = SpriteManager.SetUISprite("sceneui", guildicon, self.factionIcon)
      if not result then
        self.factionIcon.sprite = nil
        self:Hide(self.factionIcon.gameObject)
      else
        self:Show(self.factionIcon.gameObject)
      end
    elseif customicon ~= nil then
      self.factionIcon.sprite = nil
      self:Hide(self.factionIcon.gameObject)
      if GuildPictureManager.Instance():CanSetGuildIcon(guildData.id, self.masterID) then
        local texture = GuildPictureManager.Instance():GetThumbnailTexture(guildData.id, UnionLogo.CallerIndex.RoleFootDetail, customicon, guildData.customIconUpTime, true)
        if texture then
          self:Show(self.factionIcon_.gameObject)
          self.factionIcon_.texture = texture
          self.customIconGuildID = guildData.id
          if self.customIconGuildID then
            GuildPictureManager.Instance():AddGuildPicRelative(self.customIconGuildID, self.masterID)
          end
        else
          self:Hide(self.factionIcon_.gameObject)
          GuildPictureManager.Instance():AddMyThumbnailInfos({
            {
              callIndex = UnionLogo.CallerIndex.RoleFootDetail,
              guild = guildData.id,
              index = customicon,
              time = guildData.customIconUpTime,
              picType = picType
            }
          })
        end
      end
    elseif guildEmblem then
      self:Hide(self.factionIcon_.gameObject)
      local result = SpriteManager.SetUISprite("sceneui", guildEmblem, self.factionIcon)
      if not result then
        self.factionIcon.sprite = nil
        self:Hide(self.factionIcon.gameObject)
      else
        self:Show(self.factionIcon.gameObject)
      end
    end
    LuaVector2.Better_Set(tempVector2, LuaGameObject.GetRectAnchoredPosition(self.factionInfoRectTrans))
    tempVector2[1] = 0
    self.factionInfoRectTrans.anchoredPosition = tempVector2
  else
    LuaVector2.Better_Set(tempVector2, LuaGameObject.GetRectAnchoredPosition(self.factionInfoRectTrans))
    local guidPositionWith = factionJobActive and self.factionJob.preferredWidth or 0
    local guildNameWith = factionNameActive and self.factionName.preferredWidth or 0
    local uiNameWidth = self.uiname.preferredWidth
    self:Hide(self.factionIcon.gameObject)
    local posX = -(guidPositionWith + guildNameWith - uiNameWidth) / 2
    tempVector2[1] = posX
    self.factionInfoRectTrans.anchoredPosition = tempVector2
    self:Hide(self.factionIcon_.gameObject)
  end
  self:RefreshFactionLayout()
end
function SceneBottomNameFactionCell:initSprite()
  if not self:ObjIsNil(self.factionIcon) then
    self.factionIcon.sprite = nil
  end
  if not self:ObjIsNil(self.factionIcon_) then
    self.factionIcon_.texture = nil
  end
end
function SceneBottomNameFactionCell:HideCustomFaction(directRemove)
  if self.customIconGuildID then
    self:Hide(self.factionIcon_.gameObject)
    if not directRemove then
      GuildPictureManager.Instance():RemoveGuildPicRelative(self.customIconGuildID, self.masterID)
    end
    self.customIconGuildID = nil
    return true
  end
  return false
end
function SceneBottomNameFactionCell:ChangeNameFactionForServant(creature)
  local servantID = MyselfProxy.Instance:GetMyServantID() or 0
  if servantID > 0 and creature and creature.data and creature.data.staticData then
    local creatureType = creature:GetCreatureType()
    local staticType = creature.data.staticData.Type
    if creatureType == Creature_Type.Pet and staticType == "NPC" and creature.data.staticData.id == servantID then
      local factionJobText = self.factionJob.text
      self.factionJob.text = self.uiname.text
      self.uiname.color = SceneBottomNameFactionCell.npcColor
      self.uiname.text = factionJobText
      tempVector3:Set(LuaGameObject.GetLocalPosition(self.factionInfo.transform))
      LuaVector3.Better_Set(tempVector3, LuaGameObject.GetLocalPosition(self.factionInfo.transform))
      tempVector3[1] = -(self.factionJob.preferredWidth + 2) / 2
      tempVector3[3] = 0
      self.factionInfo.transform.localPosition = tempVector3
      self:RefreshFactionLayout()
    end
  end
end
function SceneBottomNameFactionCell:setNameFactionVisible(visible)
  local objNull = self:ObjIsNil(self.uiname)
  if objNull then
    return
  end
  self:SetActive(visible)
end
function SceneBottomNameFactionCell:SetActive(visible)
  if not self.canvasGroup then
    return
  end
  if self.isVisible == visible then
    return
  end
  self.isVisible = visible
  LeanTween.alphaCanvasGroup(self.canvasGroup, visible and 0 or 1, visible and 1 or 0, 0.2)
end
function SceneBottomNameFactionCell:updateNameVisible()
  local objNull = self:ObjIsNil(self.uiname)
  if objNull then
    return
  end
end
function SceneBottomNameFactionCell:RefreshFactionLayout()
  LayoutRebuilder.ForceRebuildLayoutImmediate(self.factionInfoRectTrans)
end
function SceneBottomNameFactionCell:Alive()
  return self._alive
end
function SceneBottomNameFactionCell:Reposition(rePos, delta)
  if rePos then
  else
  end
  self.transform.localPosition = LuaGeometry.GetTempVector3(0, -32 or -19, 0)
end
