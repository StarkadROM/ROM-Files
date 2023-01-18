autoImport("EquipInfo")
autoImport("AdventureAppendData")
AdventureItemData = class("AdventureItemData")
local CheckInvalid = function(id)
  if not FunctionUnLockFunc.checkFuncStateValid(136) and 0 ~= TableUtility.ArrayFindIndex(Table_FuncState[136].ItemID, id) then
    return true
  end
  return false
end
function AdventureItemData:ctor(serverData, type)
  self.type = type
  self.cardSlotNum = 0
  self.num = 0
  self.tabData = nil
  self.staticId = serverData.id
  self.savedItemDatas = {}
  self.savedItemDatasMap = {}
  self:updateManualData(serverData)
  self:initStaticData(self.staticId, serverData)
  self.isAdventureItemData = true
end
function AdventureItemData:test()
  if #self.setAppendDatas > 0 then
    self.status = SceneManual_pb.EMANUALSTATUS_UNLOCK_STEP
    for i = 1, #self.setAppendDatas do
      local single = self.setAppendDatas[i]
      single.finish = true
      single.rewardget = false
    end
  end
end
function AdventureItemData:GetFoodSData()
end
function AdventureItemData:IsLimitUse()
  return false
end
function AdventureItemData:isCollectionGroup()
  if self.type == nil then
    return true
  end
end
function AdventureItemData:canBeClick()
  if self.status == SceneManual_pb.EMANUALSTATUS_UNLOCK_CLIENT then
    return true
  end
  local tmpList = ReusableTable.CreateArray()
  local cps = self:getCompleteNoRewardAppend(tmpList)
  local haveReward = false
  if cps and #cps > 0 then
    haveReward = true
  end
  ReusableTable.DestroyAndClearArray(tmpList)
  return haveReward
end
function AdventureItemData:updateManualData(serverData)
  self.status = serverData.status
  self.attrUnlock = serverData.unlock
  self.store = serverData.store
  if serverData.data_params and self.type == SceneManual_pb.EMANUALTYPE_SCENERY then
    self:updateSceneData(serverData.data_params)
  end
  if serverData.quests then
    self:updateAppendData(serverData.quests)
  end
  local storeditems = serverData.storeditems
  TableUtility.TableClear(self.savedItemDatas)
  TableUtility.TableClear(self.savedItemDatasMap)
  if storeditems and #storeditems > 0 then
    local serverItem, itemData
    for i = 1, #storeditems do
      serverItem = storeditems[i].base
      if serverItem.id and serverItem.id ~= 0 then
        itemData = ItemData.new(serverItem.guid, serverItem.id)
        itemData:ParseFromServerData(storeditems[i])
        self.savedItemDatas[#self.savedItemDatas + 1] = itemData
        self.savedItemDatasMap[itemData.staticData.id] = true
      end
    end
  end
  local item = serverData.item
  if self.equipInfo and item and item.id and item.id ~= 0 then
    self:SetStrength(item)
    self.equipInfo:SetRefine(item.equip.refinelv)
  end
end
function AdventureItemData:updateSceneData(params)
  self.anglez = params[1] or 0
  self.anglez = tonumber(self.anglez)
  self.time = params[2] == "" and 0 or params[2] or 0
  self.time = tonumber(self.time)
  self.roleId = params[3]
  if not self.oldRoleId then
    self.oldRoleId = self.roleId
  end
  if self.roleId then
    self.roleId = tonumber(self.roleId)
  end
  if self.oldRoleId then
    self.oldRoleId = tonumber(self.oldRoleId)
  end
  MySceneryPictureManager.Instance():log("updateSceneData:", self.staticId, tostring(self.roleId), tostring(self.time), self.anglez, self.oldRoleId)
end
function AdventureItemData:updateAppendData(appends)
  self.setAppendDatas = self.setAppendDatas or {}
  for i = 1, #appends do
    local single = appends[i]
    local appData = self:getAppendDataById(single.id)
    if appData then
      appData:updateData(single)
    else
      appData = AdventureAppendData.new(single)
      table.insert(self.setAppendDatas, appData)
    end
  end
  table.sort(self.setAppendDatas, function(l, r)
    return l.staticId < r.staticId
  end)
end
function AdventureItemData:getAppendDataById(appendId)
  if self.setAppendDatas then
    for i = 1, #self.setAppendDatas do
      local single = self.setAppendDatas[i]
      if single.staticId == appendId then
        return single
      end
    end
  end
end
function AdventureItemData:setIsSelected(isSelected)
  if self.isSelected ~= isSelected then
    self.isSelected = isSelected
  end
end
function AdventureItemData:initStaticData(staticId, serverData)
  self.staticId = staticId
  self.validDateArray = {}
  if self.type == SceneManual_pb.EMANUALTYPE_NPC then
    self.staticData = Table_Npc[staticId]
  elseif self.type == SceneManual_pb.EMANUALTYPE_MONSTER or self.type == SceneManual_pb.EMANUALTYPE_MATE or self.type == SceneManual_pb.EMANUALTYPE_PET then
    self.staticData = Table_Monster[staticId]
    if self.type == SceneManual_pb.EMANUALTYPE_PET then
      self.validDateArray = ItemUtil.GetValidDateByPetId(staticId)
    end
  elseif self.type == SceneManual_pb.EMANUALTYPE_MAP then
    self.staticData = Table_Map[staticId]
  elseif self.type == SceneManual_pb.EMANUALTYPE_ACHIEVE then
    self.staticData = Table_Achievement[staticId]
  elseif self.type == SceneManual_pb.EMANUALTYPE_SCENERY then
    self.staticData = Table_Viewspot[staticId]
  elseif self.type == SceneManual_pb.EMANUALTYPE_PRESTIGE then
    self.staticData = Table_Prestige[staticId]
  else
    self.staticData = Table_Item[staticId]
    if not self.staticData then
      return
    end
    self.validDateArray[1] = self.staticData.ValidDate
    self.validDateArray[2] = self.staticData.TFValidDate
    local equipData = Table_Equip[staticId]
    if equipData ~= nil then
      self.equipInfo = EquipInfo.new(equipData)
      local item = serverData.item
      if item then
        self:SetStrengthLv(item)
        self.equipInfo:SetRefine(item.equip.refinelv)
      end
    else
      self.equipInfo = nil
    end
    self.cardInfo = Table_Card[staticId]
    self.monthCardInfo = Table_MonthCard[staticId]
    if serverData.data_params and #serverData.data_params > 0 then
      self.monthCardURl = serverData.data_params[1]
    end
    self.furnitureInfo = Table_HomeFurniture[staticId]
    self.homeMaterialInfo = Table_HomeFurnitureMaterial[staticId]
  end
  if self.staticData and self.staticData.AdventureValue and 0 < self.staticData.AdventureValue then
    self.AdventureValue = self.staticData.AdventureValue
  else
    self.AdventureValue = 0
  end
end
function AdventureItemData:SetStrengthLv(server_item)
  local guid, pos = server_item.base.guid, server_item.base.index
  local lv = BagProxy.Instance:GetItemSiteStrengthLv(guid, pos)
  self.equipInfo:SetEquipStrengthLv(lv)
end
function AdventureItemData:SetStrengthLv(server_item)
  local guid, pos = server_item.base.guid, server_item.base.index
  local lv = BagProxy.Instance:GetItemSiteStrengthLv(guid, pos)
  self.equipInfo:SetEquipStrengthLv(lv)
end
function AdventureItemData:SetStrengthLv(server_item)
  local guid, pos = server_item.base.guid, server_item.base.index
  local lv = BagProxy.Instance:GetItemSiteStrengthLv(guid, pos)
  self.equipInfo:SetEquipStrengthLv(lv)
end
function AdventureItemData:SetStrengthLv(server_item)
  local guid, pos = server_item.base.guid, server_item.base.index
  local lv = BagProxy.Instance:GetItemSiteStrengthLv(guid, pos)
  self.equipInfo:SetEquipStrengthLv(lv)
end
function AdventureItemData:CanEquip()
  return false
end
function AdventureItemData:getAdventureValue()
  return self.AdventureValue
end
function AdventureItemData:GetName()
  local result = ""
  if self.staticData then
    if self.type == SceneManual_pb.EMANUALTYPE_SCENERY then
      result = self.staticData.SpotName
    elseif self.type == SceneManual_pb.EMANUALTYPE_CARD then
      result = ZhString.AdventureHomePage_CardName
    elseif self:IsWeapon() or self:IsShield() then
      local name = self.staticData.NameZh
      local pos = string.find(name, "[[%d]")
      result = pos and string.sub(name, 1, pos - 1) or name
    else
      result = self.staticData.NameZh
    end
  end
  return OverSea.LangManager.Instance():GetLangByKey(result)
end
function AdventureItemData:IsEquip()
  return self.equipInfo ~= nil
end
function AdventureItemData:IsWeapon()
  return self.equipInfo ~= nil and self.equipInfo:IsWeapon()
end
function AdventureItemData:IsShield()
  local equipType = self.equipInfo and self.equipInfo:GetEquipType()
  return (equipType and equipType == EquipTypeEnum.Shield) == true
end
function AdventureItemData:IsTrolley()
  return self.staticData.Type == 91
end
function AdventureItemData:IsFashion()
  if self.staticData and self.staticData.Type then
    return BagProxy.fashionType[self.staticData.Type]
  end
end
function AdventureItemData:IsMount()
  return self.staticData.Type == 90 or self:IsPetMount()
end
function AdventureItemData:IsPetMount()
  return (self.staticData.Type == 101 and self.equipInfo and self.equipInfo:IsMount()) == true
end
function AdventureItemData:IsFurniture()
  return self.furnitureInfo ~= nil
end
function AdventureItemData:IsHomeMaterial()
  return self.homeMaterialInfo ~= nil
end
function AdventureItemData:IsNew()
  return self.isNew or false
end
function AdventureItemData:IsLimitPackageByLv()
  if not NewRechargeProxy.Ins:AmIMonthlyVIP() then
  elseif Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL) >= (GameConfig.AdventureEquipStoreLv or 40) then
    return false
  end
  local equipType = self.equipInfo and self.equipInfo:GetEquipType()
  if not equipType then
    return false
  end
  return equipType == EquipTypeEnum.Weapon or equipType == EquipTypeEnum.Shield
end
function AdventureItemData:Clone()
  local id = self.savedItemDatas[1] and self.savedItemDatas[1].id
  local sId = self.staticData and self.staticData.id or 0
  if id == nil or id == "" then
    id = "Adventure" .. sId
  end
  local item = ItemData.new(id, sId)
  if item.equipInfo then
    item.equipInfo:Clone(self.equipInfo)
  end
  item.isAdv = true
  return item
end
function AdventureItemData:getCompleteNoRewardAppend(tarList)
  local list = tarList or {}
  if self.setAppendDatas then
    for i = 1, #self.setAppendDatas do
      local single = self.setAppendDatas[i]
      if single.finish and not single.rewardget then
        table.insert(list, single)
      end
    end
  end
  return list
end
function AdventureItemData:getNoRewardAppend()
  local list = {}
  if self.setAppendDatas then
    for i = 1, #self.setAppendDatas do
      local single = self.setAppendDatas[i]
      if not single.rewardget then
        table.insert(list, single)
      end
    end
  end
  return list
end
function AdventureItemData:getAppendDatas()
  return self.setAppendDatas
end
function AdventureItemData:getCatId()
  return self.CatId
end
function AdventureItemData:setCatId(CatId)
  self.CatId = CatId
end
function AdventureItemData:CheckEquipCanShowInFashion()
  if not self.staticData.Condition then
    return false
  end
  if self:IsWeapon() or self:IsShield() then
    local config = GameConfig.AdventureHideEquips
    if self.status == SceneManual_pb.EMANUALSTATUS_DISPLAY and config and TableUtility.ArrayFindIndex(config, self.staticId) > 0 then
      return false
    end
  end
  return true
end
function AdventureItemData:IsValid()
  if self.type == SceneManual_pb.EMANUALTYPE_PRESTIGE then
    return FunctionUnLockFunc.Me():CheckCanOpen(self.staticData.MenuID)
  end
  local forbidden = false
  if self.cardInfo and CheckInvalid(self.cardInfo.id) then
    forbidden = true
  elseif self.type == SceneManual_pb.EMANUALTYPE_FURNITURE and CheckInvalid(self.staticId) then
    forbidden = true
  elseif self.type == SceneManual_pb.EMANUALTYPE_EQUIP and CheckInvalid(self.staticId) then
    forbidden = true
  elseif self.type == SceneManual_pb.EMANUALTYPE_COLLECTION and self.collectionGroupId == 50 then
    forbidden = self.status ~= SceneManual_pb.EMANUALSTATUS_UNLOCK_STEP or self.status ~= SceneManual_pb.EMANUALSTATUS_UNLOCK
  end
  if forbidden then
    return false
  else
    return ItemUtil.CheckDateValid(self.validDateArray)
  end
end
function AdventureItemData:setCollectionGroupId(groupId)
  self.collectionGroupId = groupId
end
function AdventureItemData:getCollectionGroupId()
  return self.collectionGroupId
end
function AdventureItemData:CompareTo(item)
  if item then
    return self.battlepoint - item.battlepoint
  end
  return self.battlepoint
end
function AdventureItemData.GetCdTimeOfAnySavedItem(advItemData)
  if type(advItemData) == "table" and type(advItemData.savedItemDatas) == "table" then
    local item = advItemData.savedItemDatas[1]
    if item then
      return ItemUtil.GetCdTime(item)
    end
  end
  return 0
end
