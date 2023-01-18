ItemUtil = {}
ItemUtil.staticRewardDropsItems = {}
local InitEquipPos = function()
  if not ItemUtil.equipPosInited then
    ItemUtil.equipPosInited = true
    ItemUtil.EquipPosConfig = {
      [1] = SceneItem_pb.EEQUIPPOS_SHIELD,
      [2] = SceneItem_pb.EEQUIPPOS_ARMOUR,
      [3] = SceneItem_pb.EEQUIPPOS_ROBE,
      [4] = SceneItem_pb.EEQUIPPOS_SHOES,
      [5] = SceneItem_pb.EEQUIPPOS_ACCESSORY1,
      [6] = SceneItem_pb.EEQUIPPOS_ACCESSORY2,
      [7] = SceneItem_pb.EEQUIPPOS_WEAPON,
      [8] = SceneItem_pb.EEQUIPPOS_HEAD,
      [9] = SceneItem_pb.EEQUIPPOS_FACE,
      [10] = SceneItem_pb.EEQUIPTYPE_MOUTH,
      [11] = SceneItem_pb.EEQUIPPOS_BACK,
      [12] = SceneItem_pb.EEQUIPPOS_TAIL,
      [13] = SceneItem_pb.EEQUIPPOS_MOUNT,
      [14] = SceneItem_pb.EEQUIPPOS_BARROW,
      [15] = SceneItem_pb.EEQUIPPOS_ARTIFACT,
      [16] = SceneItem_pb.EEQUIPPOS_ARTIFACT_HEAD,
      [17] = SceneItem_pb.EEQUIPPOS_ARTIFACT_BACK,
      [19] = SceneItem_pb.EEQUIPPOS_ARTIFACT_RING1
    }
  end
end
function ItemUtil.GetRewardItemIdsByTeamId(teamId)
  return Game.Config_RewardTeam[teamId]
end
function ItemUtil.GetRewardTeamIdsByItemId(itemId)
  return ItemIdTeamIdsMap[itemId]
end
function ItemUtil.getAssetPartByItemData(itemId, parent)
  local partIndex = ItemUtil.getItemRolePartIndex(itemId)
  if partIndex then
    local model = Asset_RolePart.Create(partIndex, itemId, function(rolePart, arg, assetRolePart)
      assetRolePart:ResetParent(parent.transform)
      LogUtility.InfoFormat("getAssetPartByItemData parent.layer:{0}", LogUtility.ToString(parent.layer))
      assetRolePart:SetLayer(parent.layer)
    end)
    return model
  end
end
function ItemUtil.CheckDateValidByItemId(id)
  local staticData = Table_Item[id]
  if staticData == nil then
    redlog("not find itemid", id)
    return
  end
  local array = {}
  array[1] = staticData.ValidDate
  array[2] = staticData.TFValidDate
  return ItemUtil.CheckDateValid(array)
end
function ItemUtil.CheckDateValidByAchievementId(id)
  local staticData = Table_Achievement[id]
  local array = {}
  if staticData then
    array[1] = staticData.ValidDate
    array[2] = staticData.TFValidDate
    return ItemUtil.CheckDateValid(array)
  end
end
function ItemUtil.GetValidDateByPetId(petid)
  local validDateArray = {}
  local itemid = Table_Pet[petid] and Table_Pet[petid].EggID
  if itemid then
    local staticdata = Table_Item[itemid]
    if staticdata then
      validDateArray[1] = staticdata.ValidDate
      validDateArray[2] = staticdata.TFValidDate
    end
  end
  return validDateArray
end
function ItemUtil.CheckDateValid(validArray)
  if not validArray or #validArray ~= 2 or not validArray[1] or not validArray[2] then
    return true
  end
  if StringUtil.IsEmpty(validArray[1]) and StringUtil.IsEmpty(validArray[2]) then
    return true
  end
  local validDate
  if EnvChannel.IsReleaseBranch() or not BranchMgr.IsChina() then
    validDate = validArray[1]
  elseif EnvChannel.IsTFBranch() then
    validDate = validArray[2]
  else
    validDate = validArray[1]
  end
  if not StringUtil.IsEmpty(validDate) then
    local p = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
    local year, month, day, hour, min, sec = validDate:match(p)
    local dateTab = ReusableTable.CreateTable()
    dateTab.year = year
    dateTab.month = month
    dateTab.day = day
    dateTab.hour = hour
    dateTab.min = min
    dateTab.sec = sec
    local startDate = os.time(dateTab)
    ReusableTable.DestroyAndClearTable(dateTab)
    local curServerTime = ServerTime.CurServerTime()
    if curServerTime and startDate > curServerTime / 1000 then
      return false
    end
  end
  return true
end
function ItemUtil.getComposeMaterialsByComposeID(id)
  local compData = Table_Compose[id]
  local all, materials, failStay = {}, {}, {}
  if compData then
    if compData.BeCostItem then
      for i = 1, #compData.BeCostItem do
        local id = compData.BeCostItem[i].id
        local num = compData.BeCostItem[i].num
        local tempItem = ItemData.new("Compose", id)
        tempItem.num = num
        table.insert(all, tempItem)
      end
    end
    if compData.FailStayItem then
      local indexMap = {}
      for i = 1, #compData.FailStayItem do
        local index = compData.FailStayItem[i]
        if index then
          indexMap[index] = 1
        end
      end
      for i = 1, #all do
        if indexMap[i] then
          table.insert(failStay, all[i])
        else
          table.insert(materials, all[i])
        end
      end
    end
  end
  return all, materials, failStay
end
function ItemUtil.checkEquipIsWeapon(type)
  for i = 1, #Table_WeaponType do
    local single = Table_WeaponType[i]
    if single.NameEn == type then
      return true
    end
  end
end
function ItemUtil.checkIsFashion(itemId)
  local itemData = Table_Item[itemId]
  if itemData then
    for k, v in pairs(GameConfig.ItemFashion) do
      for i = 1, #v.types do
        local single = v.types[i]
        if single == itemData.Type then
          return true
        end
      end
    end
  end
end
function ItemUtil.getEquipPos(equipId)
  if Table_Item[equipId] then
    local type = Table_Item[equipId].Type
    for k, v in pairs(GameConfig.CardComposeType) do
      for kk, vv in pairs(v.types) do
        if vv == type then
          return k
        end
      end
    end
  end
end
function ItemUtil.getFashionDefaultEquipFunc(data)
  if data.bagtype == BagProxy.BagType.RoleFashionEquip then
    return FunctionItemFunc.Me():GetFunc("GetoutFashion")
  elseif data.bagtype == BagProxy.BagType.RoleEquip then
    return FunctionItemFunc.Me():GetFunc("Discharge")
  elseif data.bagtype == BagProxy.BagType.MainBag then
    return FunctionItemFunc.Me():GetFunc("Dress")
  end
end
function ItemUtil.getBufferDescById(bufferid)
  if Table_Buffer[bufferid] then
    local bufferStr = Table_Buffer[bufferid].Dsc
    if StringUtil.IsEmpty(bufferStr) then
      bufferStr = Table_Buffer[bufferid].BuffName .. ZhString.ItemUtil_NoBufferDes
    end
    return bufferStr
  else
    LogUtility.WarningFormat("Cannot find desc of buffer {0}", bufferid)
    return ""
  end
end
function ItemUtil.getBufferDescByIdNotConfigDes(bufferid)
  local result = ""
  local config = Table_Buffer[bufferid]
  if config and config.BuffEffect and config.BuffEffect.type == "AttrChange" then
    for key, value in pairs(config.BuffEffect) do
      local kprop = RolePropsContainer.config[key]
      if kprop and kprop.displayName and value > 0 then
        result = result .. kprop.displayName .. " [c][9fc33dff]+" .. value .. "[-][/c] "
      end
    end
  end
  return result
end
function ItemUtil.getFashionItemRoleBodyPart(itemid, isMale)
  local equipData = Table_Equip[itemid]
  if not equipData or not equipData.GroupID then
    return equipData
  end
  local GroupID = equipData.GroupID
  local equipDatas = AdventureDataProxy.Instance.fashionGroupData[GroupID]
  if not equipDatas or #equipDatas == 0 then
    return
  end
  for i = 1, #equipDatas do
    local single = equipDatas[i]
    if isMale and single.RealShowModel == 1 then
      return single
    elseif not isMale and single.RealShowModel == 2 then
      return single
    end
  end
  return equipDatas[1]
end
function ItemUtil.getExactFashionItemRoleBodyPart(itemid)
  local equipData = Table_Equip[itemid]
  if not equipData or not equipData.GroupID then
    return equipData
  end
  local GroupID = equipData.GroupID
  local equipDatas = AdventureDataProxy.Instance.fashionGroupData[GroupID]
  if not equipDatas or #equipDatas == 0 then
    return
  end
  for i = 1, #equipDatas do
    local single = equipDatas[i]
    if single.id == itemid then
      return single
    end
  end
  return equipDatas[1]
end
local EquipType2BodyIndex, ItemType2BodyIndex
local _inited = false
local _InitRolePartConfig = function()
  if _inited then
    return
  end
  _inited = true
  EquipType2BodyIndex = {
    [1] = Asset_Role.PartIndex.RightWeapon,
    [21] = Asset_Role.PartIndex.RightWeapon,
    [3] = Asset_Role.PartIndex.LeftWeapon,
    [8] = Asset_Role.PartIndex.Head,
    [9] = Asset_Role.PartIndex.Wing,
    [10] = Asset_Role.PartIndex.Face,
    [11] = Asset_Role.PartIndex.Tail,
    [13] = Asset_Role.PartIndex.Mouth
  }
  ItemType2BodyIndex = {
    [820] = Asset_Role.PartIndex.Hair,
    [821] = Asset_Role.PartIndex.Hair,
    [822] = Asset_Role.PartIndex.Hair,
    [823] = Asset_Role.PartIndex.Eye,
    [824] = Asset_Role.PartIndex.Eye
  }
end
function ItemUtil.getItemRolePartIndex(itemid)
  _InitRolePartConfig()
  if Table_Mount[itemid] then
    return Asset_Role.PartIndex.Mount
  end
  local equipData = Table_Equip[itemid]
  if equipData then
    local typeId = equipData.EquipType
    if EquipType2BodyIndex[typeId] then
      return EquipType2BodyIndex[typeId]
    end
    if equipData.Body then
      return Asset_Role.PartIndex.Body
    end
    local mtype = equipData.Type
    if mtype == "Head" then
      return Asset_Role.PartIndex.Head
    elseif mtype == "Wing" then
      return Asset_Role.PartIndex.Wing
    end
  end
  local itemType = Table_Item[itemid].Type
  if ItemType2BodyIndex[itemType] then
    return ItemType2BodyIndex[itemType]
  end
  return 0
end
function ItemUtil.AddItemsTrace(datas)
  local traceDatas = {}
  for i = 1, #datas do
    local data = datas[i]
    local staticId = data.staticData.id
    local cell = QuestProxy:GetTraceCell(QuestDataType.QuestDataType_ITEMTR, data.staticData.id)
    if not cell then
      local odata = GainWayTipProxy.Instance:GetItemOriginMonster(staticId)
      local itemName = odata.name
      local haveNum = BagProxy.Instance:GetAllItemNumByStaticID(staticId)
      local origin = odata.origins and odata.origins[1]
      if origin then
        local traceData = {
          type = QuestDataType.QuestDataType_ITEMTR,
          questDataStepType = QuestDataStepType.QuestDataStepType_MOVE,
          id = staticId,
          map = origin.mapID,
          pos = origin.pos,
          traceTitle = ZhString.MainViewSealInfo_TraceTitle,
          traceInfo = string.format(ZhString.ItemUtil_ItemTraceInfo, itemName, haveNum)
        }
        table.insert(traceDatas, traceData)
      else
        errorLog(string.format(ZhString.ItemUtil_NoMonsterDrop, staticId))
      end
    end
  end
  if #traceDatas > 0 then
    QuestProxy.Instance:AddTraceCells(traceDatas)
  end
end
function ItemUtil.CancelItemTrace(data)
  QuestProxy.Instance:RemoveTraceCell(QuestDataType.QuestDataType_ITEMTR, data.staticData.id)
end
function ItemUtil.CheckItemIsSpecialInAdventureAppend(itemType)
  for i = 1, #GameConfig.AdventureAppendSpecialItemType do
    local single = GameConfig.AdventureAppendSpecialItemType[i]
    if single == itemType then
      return true
    end
  end
end
function ItemUtil.GetComposeItemByBlueItem(itemData)
  if itemData and 50 == itemData.Type then
    local compose = Table_Compose[itemData.id]
    if compose then
      return compose.Product.id
    end
  end
end
function ItemUtil.GetDeath_Dead_Reward(monsterId)
  local tempArray, tempMap = {}, ReusableTable.CreateTable()
  local Dead_Reward, single
  local deadbossCfg = Game.Config_Deadboss[monsterId]
  if deadbossCfg then
    for _, v in pairs(deadbossCfg) do
      Dead_Reward = v.Dead_Reward
      for i = 1, #Dead_Reward do
        single = Dead_Reward[i]
        if not tempMap[single] then
          tempArray[#tempArray + 1] = single
          tempMap[single] = 1
        end
      end
    end
  end
  ReusableTable.DestroyAndClearTable(tempMap)
  if #tempArray > 1 then
    return tempArray
  else
    return nil
  end
end
function ItemUtil.GetWorldBoss_Reward(monsterId)
  if GameConfig.Card.worldboss and GameConfig.Card.worldboss[monsterId] then
    return GameConfig.Card.worldboss[monsterId].Dead_Reward
  end
end
function ItemUtil.GetDeath_Drops(monsterId)
  if ItemUtil.staticRewardDropsItems[monsterId] then
    return ItemUtil.staticRewardDropsItems[monsterId]
  end
  local tempArray = {}
  local staticData = Table_Monster[monsterId]
  if not staticData then
    return
  end
  local numLimit = false
  local Dead_Reward = staticData.Dead_Reward
  if not (#Dead_Reward > 0) or not Dead_Reward then
    Dead_Reward = nil
  end
  if not Dead_Reward then
    Dead_Reward = ItemUtil.GetDeath_Dead_Reward(monsterId)
    numLimit = true
  end
  local worldbossReward = ItemUtil.GetWorldBoss_Reward(monsterId)
  if not Dead_Reward and not worldbossReward then
    return
  end
  if Dead_Reward then
    ItemUtil.GetRewardItemListByRewardGroup(Dead_Reward, tempArray, numLimit)
  end
  if worldbossReward then
    ItemUtil.GetRewardItemListByRewardGroup(worldbossReward, tempArray, numLimit)
  end
  ItemUtil.staticRewardDropsItems[monsterId] = tempArray
  return ItemUtil.staticRewardDropsItems[monsterId]
end
function ItemUtil.GetRewardItemListByRewardGroup(grouplist, array, numLimit)
  if grouplist and #grouplist > 0 then
    for i = 1, #grouplist do
      local singleRewardTeamID = grouplist[i]
      local list = ItemUtil.GetRewardItemIdsByTeamId(singleRewardTeamID)
      if list then
        for j = 1, #list do
          local single = list[j]
          local hasAdd = false
          for j = 1, #array do
            local tmp = array[j]
            if tmp.itemData.id == single.id then
              if not numLimit then
                tmp.num = tmp.num + single.num
              end
              hasAdd = true
              break
            end
          end
          if not hasAdd then
            local data = {}
            data.itemData = Table_Item[single.id]
            if data.itemData then
              data.num = single.num
              table.insert(array, data)
            end
          end
        end
      end
    end
  end
end
function ItemUtil.GetEquipEnchantEffectSucRate(attriType)
end
local useCodeItemId
function ItemUtil.SetUseCodeCmd(data)
  useCodeItemId = data.id
end
function ItemUtil.HandleUseCodeCmd(data)
  if useCodeItemId and data.guid == useCodeItemId then
    useCodeItemId = nil
    local functionSdk = FunctionLogin.Me():getFunctionSdk()
    local url
    if functionSdk and functionSdk:getToken() then
      url = string.format(ZhString.KFCShareURL, Game.Myself.data.id, data.code, functionSdk:getToken())
    else
      url = ZhString.KFCShareURL_BeiFen
    end
    Application.OpenURL(url)
  end
end
function ItemUtil.CheckIfNeedRequestUseCode(data)
  local type = data.staticData.Type
  if type and (type == 4000 or type == 4200 or type == 4201) then
    return true
  end
  return false
end
local seaon_equip = GameConfig.GVGConfig.season_equip
function ItemUtil.IsGVGSeasonEquip(id)
  return nil ~= seaon_equip and nil ~= seaon_equip[id]
end
local CONFIGTIME_FORMAT = "%Y-%m-%d %H:%M:%S"
local getNowTimeString = function()
  return os.date(CONFIGTIME_FORMAT, ServerTime.CurServerTime() / 1000)
end
function ItemUtil.CheckCardCanComposeByTime(cardId)
  return ItemUtil.CheckCardCanGetByTime(cardId, "TFComposeDate", "ComposeDate")
end
function ItemUtil.CheckCardCanLotteryByTime(cardId)
  return ItemUtil.CheckCardCanGetByTime(cardId, "TFLotteryDate", "LotteryDate")
end
function ItemUtil.CheckCardCanGetByTime(cardId, tfkey, releaseKey)
  local sData = Table_Card[cardId]
  if sData == nil then
    return false
  end
  local timeKey
  if EnvChannel.IsTFBranch() then
    timeKey = tfkey
  elseif EnvChannel.IsReleaseBranch() then
    timeKey = releaseKey
  end
  if timeKey == nil then
    return true
  end
  local ct = sData[timeKey]
  if ct == nil or #ct == 0 then
    return true
  end
  local nowTimeStr = getNowTimeString()
  if #ct == 1 then
    return nowTimeStr > ct[1]
  elseif #ct == 2 then
    return nowTimeStr > ct[1] and nowTimeStr <= ct[2]
  end
  return false
end
function ItemUtil.CheckRecipeIsValidByTime(recipeId)
  return ItemUtil.CheckRecipeCanUseByTime(recipeId, "TFValidDate", "ValidDate", "Item")
end
function ItemUtil.CheckFoodCanMakeByTime(recipeId)
  return ItemUtil.CheckRecipeCanUseByTime(recipeId, "TFStartTime", "ReleaseStartTime", "Recipe")
end
function ItemUtil.CheckRecipeCanUseByTime(recipeId, tfKey, releaseKey, searchTableName)
  local recipeData = Table_Recipe[recipeId]
  if recipeData == nil then
    return false
  end
  if recipeData.Product == 551019 then
    return false
  end
  local timeKey
  if EnvChannel.IsReleaseBranch() or not BranchMgr.IsChina() then
    timeKey = releaseKey
  elseif EnvChannel.IsTFBranch() then
    timeKey = tfKey
  end
  if timeKey == nil then
    return true
  end
  local searchTable = recipeData
  if searchTableName == "Item" then
    searchTable = Table_Item[recipeData.Product]
  end
  local validDate = searchTable[timeKey]
  if StringUtil.IsEmpty(validDate) then
    return true
  end
  return validDate < getNowTimeString()
end
local bagItemDataFunctionCD, cdProxy
function ItemUtil.GetCdTime(item)
  if type(item) ~= "table" then
    return 0
  end
  if not bagItemDataFunctionCD then
    bagItemDataFunctionCD = FunctionCDCommand.Me():GetBagItemDataCDProxy(BagProxy.Instance)
    cdProxy = CDProxy.Instance
  end
  local cd = bagItemDataFunctionCD:TryGetItemClientUseSkillInId(item)
  if not cd then
    if item.cdGroup then
      cd = cdProxy:GetItemGroupInCD(item.cdGroup)
    else
      cd = cdProxy:GetItemInCD(item.staticData.id)
    end
  end
  return cd and cd:GetCd() or 0
end
local itemIdCollectionNameMap = {}
function ItemUtil.GetCollectionNameByItemId(itemId)
  if not itemIdCollectionNameMap[itemId] then
    itemIdCollectionNameMap[itemId] = ""
    local teamIds, cName = ItemUtil.GetRewardTeamIdsByItemId(itemId)
    if teamIds then
      for i = 1, #teamIds do
        cName = AdventureDataProxy.Instance.advRewardCollectionNameMap[teamIds[i]]
        if cName then
          itemIdCollectionNameMap[itemId] = cName
        end
      end
    end
  end
  return itemIdCollectionNameMap[itemId]
end
local EQUIP_MAXINDEX
function ItemUtil.EquipMaxIndex()
  if not EQUIP_MAXINDEX then
    EQUIP_MAXINDEX = 0
    InitEquipPos()
    for index, _ in pairs(ItemUtil.EquipPosConfig) do
      if index > EQUIP_MAXINDEX then
        EQUIP_MAXINDEX = index
      end
    end
  end
  return EQUIP_MAXINDEX
end
function ItemUtil.GetEposByIndex(index)
  InitEquipPos()
  return index and ItemUtil.EquipPosConfig[index] or nil
end
function ItemUtil.GetItemSite(itemData)
  local site = BagProxy.Instance:GetToEquipPos()
  if itemData and (itemData.equipInfo or itemData:IsMount()) then
    local poses = itemData.equipInfo:GetEquipSite()
    if poses then
      local posIsRight = false
      for _, sc in pairs(poses) do
        if sc == site then
          posIsRight = true
          break
        end
      end
      if not posIsRight then
        local nullPos, lowPos, lowEquipScore
        for _, pos in pairs(poses) do
          local equip = BagProxy.Instance.roleEquip:GetEquipBySite(pos)
          if not equip then
            nullPos = pos
            break
          else
            local score = equip.equipInfo:GetReplaceValues()
            if not lowEquipScore then
              lowEquipScore = score
              lowPos = pos
            elseif score < lowEquipScore then
              lowEquipScore = score
              lowPos = pos
            end
          end
        end
        site = nullPos or lowPos
      end
    end
  end
  return site
end
function ItemUtil.GetItemTypeName(itemTypeId, prefix)
  local typeConfig = Table_ItemType[itemTypeId]
  if not typeConfig then
    return ""
  end
  prefix = prefix or ZhString.ItemTip_ItemType
  return prefix .. OverSea.LangManager.Instance():GetLangByKey(typeConfig.Name)
end
function ItemUtil.GetRefineAttrPreview(equipInfo, refineCeil)
  if equipInfo then
    local refineEffect, currentLv = equipInfo.equipData.RefineEffect, equipInfo.refinelv
    local nextRefineLv = refineCeil or currentLv + 1
    local effectName, effectAddValue = next(refineEffect)
    if effectName and effectAddValue then
      local proName = GameConfig.EquipEffect[effectName]
      local pro, isPercent = Game.Config_PropName[effectName], false
      if pro then
        isPercent = pro.IsPercent == 1
        proName = proName or pro.PropName
      end
      proName = proName .. ZhString.EquipRefineBord_EffectSperator
      local currentRefineValueText, nextRefineValueText
      if isPercent then
        currentRefineValueText = string.format(" +%s%%", effectAddValue * currentLv * 100)
        nextRefineValueText = string.format(" +%s%%", effectAddValue * nextRefineLv * 100)
      else
        currentRefineValueText = string.format(" +%s", effectAddValue * currentLv)
        nextRefineValueText = string.format(" +%s", effectAddValue * nextRefineLv)
      end
      return proName, currentRefineValueText, nextRefineValueText
    end
  end
  return "", "", ""
end
function ItemUtil.GetAttributeNameFromAbbreviation(str_abbreviation)
  return Game.Config_PropName[str_abbreviation] and Game.Config_PropName[str_abbreviation].PropName or nil
end
function ItemUtil.CheckCardPreviewValid(itemid)
  local config = GameConfig.NewPveRaid and GameConfig.NewPveRaid.PveCardPreview
  return nil ~= config and nil ~= config[itemid]
end
function ItemUtil.CheckItemDisplayValid(itemid)
  local config = Table_ItemDisplay[itemid]
  return nil ~= config
end
