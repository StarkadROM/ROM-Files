autoImport("BagData")
autoImport("FashionBagData")
autoImport("RoleEquipBagData")
autoImport("FashionEquipBagData")
autoImport("CardBagData")
autoImport("Table_ItemBeTransformedWay")
autoImport("ItemFun")
local BagProxy = class("BagProxy", pm.Proxy)
BagProxy.Instance = nil
BagProxy.NAME = "BagProxy"
BagProxy.BagType = {
  MainBag = SceneItem_pb.EPACKTYPE_MAIN,
  RoleEquip = SceneItem_pb.EPACKTYPE_EQUIP,
  RoleFashionEquip = SceneItem_pb.EPACKTYPE_FASHIONEQUIP,
  Storage = SceneItem_pb.EPACKTYPE_STORE,
  Card = SceneItem_pb.EPACKTYPE_CARD,
  Fashion = SceneItem_pb.EPACKTYPE_FASHION,
  PersonalStorage = SceneItem_pb.EPACKTYPE_PERSONAL_STORE,
  Temp = SceneItem_pb.EPACKTYPE_TEMP_MAIN,
  Barrow = SceneItem_pb.EPACKTYPE_BARROW,
  Quest = SceneItem_pb.EPACKTYPE_QUEST,
  Food = SceneItem_pb.EPACKTYPE_FOOD,
  Pet = SceneItem_pb.EPACKTYPE_PET,
  Furniture = SceneItem_pb.EPACKTYPE_FURNITURE,
  AttributeGem = SceneItem_pb.EPACKTYPE_GEM_ATTR,
  SkillGem = SceneItem_pb.EPACKTYPE_GEM_SKILL,
  Home = SceneItem_pb.EPACKTYPE_HOME,
  Wallet = SceneItem_pb.EPACKTYPE_WALLET,
  PersonalArtifact = SceneItem_pb.EPACKTYPE_ARTIFACT,
  PersonalArtifactFragment = SceneItem_pb.EPACKTYPE_ARTIFACT_FLAGMENT
}
BagProxy.ItemTypeGroup = {Card = 2}
BagProxy.EquipUpgrade_RefreshBagType = {
  [1] = 1,
  [2] = 1
}
function BagProxy:ctor(proxyName, data)
  self.proxyName = proxyName or BagProxy.NAME
  if BagProxy.Instance == nil then
    BagProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:InitItemKind()
  self.bagData = BagData.new({
    {
      data = GameConfig.ItemPage[1],
      class = BagEquipTab
    },
    {
      data = GameConfig.ItemPage[2]
    },
    {
      data = GameConfig.ItemPage[3]
    },
    {
      data = GameConfig.ItemPage[4]
    }
  }, nil, BagProxy.BagType.MainBag)
  self:InitFashionBag()
  self.repositoryBag = BagData.new({
    {
      data = GameConfig.ItemPage[1],
      class = BagEquipTab
    },
    {
      data = GameConfig.ItemPage[2]
    },
    {
      data = GameConfig.ItemPage[3]
    },
    {
      data = GameConfig.ItemPage[4]
    }
  }, nil, BagProxy.BagType.Storage)
  self.personalRepositoryBag = BagData.new({
    {
      data = GameConfig.ItemPage[1],
      class = BagEquipTab
    },
    {
      data = GameConfig.ItemPage[2]
    },
    {
      data = GameConfig.ItemPage[3]
    },
    {
      data = GameConfig.ItemPage[4]
    }
  }, nil, BagProxy.BagType.PersonalStorage)
  self.homeRepositoryBag = BagData.new({
    {
      data = GameConfig.ItemPage[1],
      class = BagEquipTab
    },
    {
      data = GameConfig.ItemPage[2]
    },
    {
      data = GameConfig.ItemPage[3]
    },
    {
      data = GameConfig.ItemPage[4]
    }
  }, nil, BagProxy.BagType.Home)
  self.barrowBag = BagData.new({
    {
      data = GameConfig.ItemPage[1],
      class = BagEquipTab
    },
    {
      data = GameConfig.ItemPage[2]
    },
    {
      data = GameConfig.ItemPage[3]
    },
    {
      data = GameConfig.ItemPage[4]
    }
  }, nil, BagProxy.BagType.Barrow)
  self.tempBagData = BagData.new(nil, nil, BagProxy.BagType.Temp)
  self.questBagData = BagData.new({
    {
      data = GameConfig.ItemPage[5]
    }
  }, nil, BagProxy.BagType.Quest)
  self.petBagData = BagData.new(nil, nil, BagProxy.BagType.Pet)
  self.attributeGemBagData = BagData.new(nil, nil, BagProxy.BagType.AttributeGem)
  self.skillGemBagData = BagData.new(nil, nil, BagProxy.BagType.SkillGem)
  self.furnitureBagData = BagData.new(nil, nil, BagProxy.BagType.Furniture)
  self.walletBagData = BagData.new({
    {
      data = GameConfig.Wallet.PackageWallet[1]
    },
    {
      data = GameConfig.Wallet.PackageWallet[2]
    },
    {
      data = GameConfig.Wallet.PackageWallet[3]
    }
  }, nil, BagProxy.BagType.Wallet)
  self.personalArtifactBagData = BagData.new(nil, nil, BagProxy.BagType.PersonalArtifact)
  self.personalArtifactFragmentBagData = BagData.new(nil, nil, BagProxy.BagType.PersonalArtifactFragment)
  local FoodPackPage = GameConfig.FoodPackPage
  if FoodPackPage then
    self.foodBagData = BagData.new({
      {
        data = FoodPackPage[1]
      },
      {
        data = FoodPackPage[2]
      }
    }, nil, BagProxy.BagType.Food)
  end
  self.bagMap = {}
  self.bagMap[BagProxy.BagType.MainBag] = self.bagData
  self.bagMap[BagProxy.BagType.RoleEquip] = self.roleEquip
  self.bagMap[BagProxy.BagType.RoleFashionEquip] = self.fashionEquipBag
  self.bagMap[BagProxy.BagType.Storage] = self.repositoryBag
  self.bagMap[BagProxy.BagType.PersonalStorage] = self.personalRepositoryBag
  self.bagMap[BagProxy.BagType.Home] = self.homeRepositoryBag
  self.bagMap[BagProxy.BagType.Temp] = self.tempBagData
  self.bagMap[BagProxy.BagType.Fashion] = self.fashionBag
  self.bagMap[BagProxy.BagType.Card] = self.cardBag
  self.bagMap[BagProxy.BagType.Barrow] = self.barrowBag
  self.bagMap[BagProxy.BagType.Quest] = self.questBagData
  self.bagMap[BagProxy.BagType.Food] = self.foodBagData
  self.bagMap[BagProxy.BagType.Pet] = self.petBagData
  self.bagMap[BagProxy.BagType.Furniture] = self.furnitureBagData
  self.bagMap[BagProxy.BagType.AttributeGem] = self.attributeGemBagData
  self.bagMap[BagProxy.BagType.SkillGem] = self.skillGemBagData
  self.bagMap[BagProxy.BagType.Wallet] = self.walletBagData
  self.bagMap[BagProxy.BagType.PersonalArtifact] = self.personalArtifactBagData
  self.bagMap[BagProxy.BagType.PersonalArtifactFragment] = self.personalArtifactFragmentBagData
  FunctionCDCommand.Me():StartCDProxy(BagCDRefresher, 33)
  FunctionCDCommand.Me():StartCDProxy(BagItemDataFunctionCD, 33, self)
  self._moneyGet = {}
  self._moneyGet[GameConfig.MoneyId.Zeny] = function()
    return MyselfProxy.Instance:GetROB()
  end
  self.callBattletime = false
end
function BagProxy:InitFashionBag()
  local tabs = {}
  for i = 1, #GameConfig.ItemFashion do
    tabs[#tabs + 1] = {
      data = GameConfig.ItemFashion[i]
    }
  end
  self.fashionBag = FashionBagData.new(tabs, BagFashionTab, BagProxy.BagType.Fashion)
  self.fashionEquipBag = FashionEquipBagData.new(BagProxy.BagType.RoleFashionEquip)
  self.roleEquip = RoleEquipBagData.new(nil, nil, BagProxy.BagType.RoleEquip)
  tabs = {}
  for i = 1, #GameConfig.CardPage do
    tabs[#tabs + 1] = {
      data = GameConfig.CardPage[i]
    }
  end
  self.cardBag = CardBagData.new(tabs, nil, BagProxy.BagType.Card)
end
function BagProxy:InitItemKind()
  BagProxy.fashionType = {}
  local types
  for i = 1, #GameConfig.ItemFashion do
    types = GameConfig.ItemFashion[i].types
    for k, v in pairs(types) do
      BagProxy.fashionType[v] = true
    end
  end
end
function BagProxy:onRegister()
end
function BagProxy:onRemove()
end
function BagProxy:SetIsNewFlag(package, value)
  local bag = self.bagMap[package]
  local items = bag:GetItems()
  for i = 1, #items do
    items[i].isNew = value
  end
end
function BagProxy:GetBagByType(t)
  return self.bagMap[t]
end
function BagProxy:GetBagUseTab()
  return self.bagData:GetTab(GameConfig.ItemPage[4])
end
function BagProxy:GetBagEquipTab()
  return self.bagData:GetTab(GameConfig.ItemPage[1])
end
function BagProxy:GetBagEquipItems()
  local items = self.bagData:GetItems()
  if self.equips == nil then
    self.equips = {}
  else
    TableUtility.ArrayClear(self.equips)
  end
  for i = 1, #items do
    if items[i].equipInfo then
      table.insert(self.equips, items[i])
    end
  end
  return self.equips
end
function BagProxy:GetBagChipTab()
  return self.bagData:GetTab(GameConfig.ItemPage[3])
end
function BagProxy:GetMainBag()
  return self.bagData
end
function BagProxy:GetRepositoryBagData()
  return self.repositoryBag
end
function BagProxy:GetPersonalRepositoryBagData()
  return self.personalRepositoryBag
end
function BagProxy:GetHomeRepositoryBagData()
  return self.homeRepositoryBag
end
function BagProxy:GetRoleEquipBag()
  return self.roleEquip
end
function BagProxy:GetBagItemsByType(type, bagType)
  local bagData = self:GetBagByType(bagType) or self.bagData
  local bagItems = bagData:GetItems()
  local result = {}
  for _, item in pairs(bagItems) do
    if item.staticData and item.staticData.Type == type then
      table.insert(result, item)
    end
  end
  return result
end
local tmpTypes = {}
function BagProxy:GetBagItemsByTypes(types, bagType)
  if types == nil or type(types) ~= "table" then
    return nil
  end
  bagType = bagType or BagProxy.BagType.MainBag
  local bagItems = self.bagMap[bagType]:GetItems()
  local result = {}
  TableUtility.TableClear(tmpTypes)
  for k, v in pairs(types) do
    tmpTypes[v] = 1
  end
  for _, item in pairs(bagItems) do
    if item.staticData and tmpTypes[item.staticData.Type] ~= nil then
      table.insert(result, item)
    end
  end
  return result
end
function BagProxy:GetItemNumByStaticIDInCard(staticID)
  return self:GetItemNumByStaticID(staticID, BagProxy.BagType.Card)
end
function BagProxy:GetAllItemNumByStaticID(staticID)
  local itemInMain = self:GetItemNumByStaticID(staticID)
  local itemInStore = self:GetItemNumByStaticID(staticID, BagProxy.BagType.Storage)
  local itemInPersonalStore = self:GetItemNumByStaticID(staticID, BagProxy.BagType.PersonalStorage)
  local itemInHomeStore = self:GetItemNumByStaticID(staticID, BagProxy.BagType.Home)
  return itemInMain + itemInStore + itemInPersonalStore + itemInHomeStore
end
function BagProxy:GetAllItemNumByStaticIDIncludeMoney(staticID)
  if staticID == 151 then
    return MyselfProxy.Instance:GetLottery()
  elseif staticID == 100 then
    return MyselfProxy.Instance:GetROB()
  else
    return self:GetAllItemNumByStaticID(staticID)
  end
end
function BagProxy:GetItemByGuid(guid, bagType)
  local type_bagType = type(bagType)
  if type_bagType == "number" then
    local bagData = self.bagMap[bagType]
    return bagData and bagData:GetItemByGuid(guid)
  elseif type_bagType == "table" then
    for i = 1, #bagType do
      local item = self:GetItemByGuid(guid, bagType[i])
      if item ~= nil then
        return item
      end
    end
  else
    for _, bagData in pairs(self.bagMap) do
      local item = bagData:GetItemByGuid(guid)
      if item then
        return item
      end
    end
  end
end
function BagProxy:GetItemNumByStaticID(staticID, bagType)
  local func = self._moneyGet[staticID]
  if func ~= nil then
    return func()
  end
  local staticData = Table_Item[staticID]
  local v_type = type(bagType)
  if v_type == "nil" then
    if Game.Config_Wallet and Game.Config_Wallet[staticID] then
      bagType = BagProxy.BagType.Wallet
    else
      bagType = BagProxy.BagType.MainBag
    end
  elseif v_type == "table" then
    local count = 0
    for i = 1, #bagType do
      count = count + self:GetItemNumByStaticID(staticID, bagType[i])
    end
    return count
  end
  local bag = self.bagMap[bagType]
  if staticData then
    local tab = bag.itemMapTab[staticData.Type] or bag.wholeTab
    return tab:GetItemNumByStaticID(staticID)
  end
  return 0
end
function BagProxy:GetItemsByStaticID(staticID, bagType)
  local staticData = Table_Item[staticID]
  bagType = bagType or BagProxy.BagType.MainBag
  local bag = self.bagMap[bagType]
  if staticData then
    local tab = bag.itemMapTab[staticData.Type] or bag.wholeTab
    return tab:GetItemsByStaticID(staticID)
  end
  return nil
end
function BagProxy:GetNewestItemByStaticID(staticID, bagType)
  local items = self:GetItemsByStaticID(staticID, bagType)
  local resultItem
  if items then
    local maxtime = 0
    for i = 1, #items do
      if maxtime < items[i].createtime then
        maxtime = items[i].createtime
        resultItem = items[i]
      end
    end
  end
  return resultItem
end
function BagProxy:GetItemNumByStaticIDs(staticIDs, page)
  local tab = self.bagData:GetTab(page)
  if tab then
    return tab:GetItemNumByStaticIDs(staticIDs)
  end
  return nil
end
function BagProxy:FilterEquipedCardItems(Type)
  local filterItems = {}
  self:FilterEquipedCardItemsByBagType(BagProxy.BagType.RoleEquip, Type, filterItems)
  self:FilterEquipedCardItemsByBagType(BagProxy.BagType.MainBag, Type, filterItems)
  return filterItems
end
function BagProxy:FilterEquipedCardItemsByBagType(bagType, Type, filterItems)
  local items = self.bagMap[bagType]:GetItems()
  local item
  for i = 1, #items do
    item = items[i]
    if self.CheckEquipTypeInCardComposeType(Type, item.staticData.Type) and item.cardSlotNum ~= nil and item.cardSlotNum > 0 then
      filterItems[#filterItems + 1] = item
    end
  end
end
function BagProxy.CheckIsCoinTypeItem(type)
  local tb = Table_ItemType[type]
  if tb and tb.EffectShow then
    return tb.EffectShow & 2 > 0
  else
    printRed("can't find itemType data by type:" .. (type or 0))
  end
end
function BagProxy.CheckIs3DTypeItem(type)
  local tb = Table_ItemType[type]
  if tb and tb.EffectShow then
    return tb.EffectShow & 1 > 0
  else
    printRed("can't find itemType data by type:" .. (type or 0))
  end
end
function BagProxy.CheckIsCardTypeItem(type)
  local tb = Table_ItemType[type]
  if tb and tb.EffectShow then
    return tb.EffectShow & 4 > 0
  else
    printRed("can't find itemType data by type:" .. (type or 0))
  end
end
function BagProxy.CheckIsFoodTypeItem(type)
  local tb = Table_ItemType[type]
  if tb and tb.EffectShow then
    return tb.EffectShow & 8 > 0
  else
    printRed("can't find itemType data by type:" .. (type or 0))
  end
end
function BagProxy.CheckEquipTypeInCardComposeType(type, equipType)
  local types = GameConfig.CardComposeType[type].types
  for i = 1, #types do
    if types[i] == equipType then
      return true
    end
  end
end
function BagProxy:GetItemByStaticID(staticID, bagType)
  local staticData = Table_Item[staticID]
  if staticData then
    bagType = bagType or BagProxy.BagType.MainBag
    local bagData = self.bagMap[bagType]
    local tab = bagData.itemMapTab[staticData.Type]
    tab = tab or bagData.wholeTab
    return tab:GetItemByStaticID(staticID)
  end
  return nil
end
function BagProxy:GetItemByStaticIDWithoutCard(staticID)
  local staticData = Table_Item[staticID]
  if staticData then
    local tab = self.bagData.itemMapTab[staticData.Type]
    if tab then
      local items = tab:GetItemsByStaticID(staticID)
      if items and #items > 0 then
        for i = 1, #items do
          local noEquipCard = not items[i]:HasEquipedCard()
          local noStrengthlv = true
          local equipInfo = items[i].equipInfo
          noStrengthlv = equipInfo and equipInfo.strengthlv == 0
          if noEquipCard and noStrengthlv then
            return items[i]
          end
        end
      end
    end
  end
  return nil
end
function BagProxy:SetProToEquipTab(pro)
  self:GetBagEquipTab():SetProfess(pro)
end
function BagProxy:SetToEquipPos(pos)
  self.ToEquipPos = pos
end
function BagProxy:GetToEquipPos()
  return self.ToEquipPos
end
function BagProxy:GetNowActiveItem()
  return self.bagData:GetActiveItem()
end
function BagProxy.CheckEquipIsClean(item, expRefine)
  local equipInfo = item.equipInfo
  local enchantInfo = item.enchantInfo
  local nocards = not item:HasEquipedCard()
  if equipInfo and equipInfo.strengthlv <= 0 and 0 >= equipInfo.strengthlv2 and 0 >= equipInfo.equiplv and nocards and (not enchantInfo or not enchantInfo:HasAttri()) then
    if expRefine == true then
      return true
    else
      return 0 >= equipInfo.refinelv
    end
  end
  return false
end
function BagProxy:ServerSetBagUpLimit(bagType, limit)
  if not bagType then
    return
  end
  local bagData = self.bagMap[bagType]
  if bagData then
    local msgId
    if bagType == BagProxy.BagType.MainBag then
      msgId = 3103
    elseif bagType == BagProxy.BagType.PersonalStorage then
      msgId = 3109
    end
    if msgId then
      local oldlimit = bagData:GetUplimit()
      if oldlimit ~= 0 and limit > oldlimit then
        MsgManager.ShowMsgByIDTable(msgId, {
          limit - oldlimit
        })
      end
    end
    bagData:SetUplimit(limit)
  end
end
function BagProxy:GetBagUpLimit(bagType)
  if not bagType then
    return
  end
  local bagData = self.bagMap[bagType]
  if bagData then
    return bagData:GetUplimit()
  end
end
function BagProxy:CheckBagIsFull(bagType)
  bagType = bagType or BagProxy.BagType.MainBag
  local bagData = self.bagMap[bagType]
  if bagData then
    return bagData:IsFull()
  end
  return false
end
function BagProxy:GetItemFreeSpaceByStaticId(bagType, itemid)
  bagType = bagType or BagProxy.BagType.MainBag
  local bagData = self.bagMap[bagType]
  if bagData then
    return bagData:GetItemFreeSpaceByStaticId(itemid)
  end
  return 0
end
function BagProxy:CheckItemCanPutIn(bagType, itemid, num, withTip, tipId)
  local itype = itemid and Table_Item[itemid] and Table_Item[itemid].Type
  local moneyTypeValues = ProtoCommon_pb.EMONEYTYPE.values
  for i = 1, #moneyTypeValues do
    local value = moneyTypeValues[i] and moneyTypeValues[i].number
    if itype == value then
      return true
    end
  end
  local spaceNum = self:GetItemFreeSpaceByStaticId(bagType, itemid)
  num = num or 1
  local can = spaceNum >= num
  if not can and withTip then
    tipId = tipId or 3101
    MsgManager.ShowMsgByIDTable(tipId)
  end
  return can
end
local tempEggs = {}
local PACKAGE_CHECK = GameConfig.PackageMaterialCheck.pet_workspace
function BagProxy:GetMyPetEggs()
  TableUtility.ArrayClear(tempEggs)
  for i = 1, #PACKAGE_CHECK do
    local bagData = self.bagMap[PACKAGE_CHECK[i]]
    if bagData then
      local items = bagData:GetItems()
      for i = 1, #items do
        if items[i].petEggInfo and items[i].petEggInfo.name ~= nil and items[i].petEggInfo.name ~= "" then
          table.insert(tempEggs, items[i])
        end
      end
    end
  end
  return tempEggs
end
local upgradeProductKeyMap, replaceProductKeyMap, equipVidMap, upgradeReplaceInted
local InitUpgradeReplace = function()
  if upgradeReplaceInted then
    return
  end
  upgradeReplaceInted = true
  upgradeProductKeyMap = {}
  replaceProductKeyMap = {}
  equipVidMap = {}
  for upgradeid, upgradeData in pairs(Table_EquipUpgrade) do
    local productId = upgradeData.Product
    if productId then
      if upgradeProductKeyMap[productId] == nil then
        upgradeProductKeyMap[productId] = {}
      end
      table.insert(upgradeProductKeyMap[productId], upgradeData)
    end
  end
  for id, equipData in pairs(Table_Equip) do
    local replaceID = equipData.SubstituteID
    if replaceID then
      local composeData = Table_Compose[replaceID]
      if composeData == nil then
        error(string.format("Equip:%s SubstituteID:%s Not Config In Table_Compose ", id, replaceID))
      end
      local productId = composeData.Product.id
      if productId == nil then
        error(string.format("ComposeData:%s not Find ProductId", replaceID))
        return
      end
      if replaceProductKeyMap[productId] == nil then
        replaceProductKeyMap[productId] = {}
      end
      table.insert(replaceProductKeyMap[productId], id)
    end
    local vid = equipData.VID
    if vid then
      local key1, key2 = math.floor(vid / 10000), vid % 1000
      local map1 = equipVidMap[key1]
      if not map1 then
        map1 = {}
        equipVidMap[key1] = map1
      end
      local equipArray = map1[key2]
      if not equipArray then
        equipArray = {}
        map1[key2] = equipArray
      end
      equipArray[#equipArray + 1] = id
    end
  end
end
local sourceEquipMap = {}
local sourceEquipTypeMap = {}
function BagProxy.GetSurceEquipIds(equipId)
  if equipId == nil then
    return
  end
  local equipIds = sourceEquipMap[equipId]
  if equipIds ~= nil then
    return equipIds, sourceEquipTypeMap[equipId]
  end
  InitUpgradeReplace()
  equipIds = {}
  sourceEquipMap[equipId] = equipIds
  local srcType = 0
  local upgradeDatas = upgradeProductKeyMap[equipId]
  if upgradeDatas then
    for i = 1, #upgradeDatas do
      local baseid = upgradeDatas[i].id
      if TableUtility.ArrayFindIndex(equipIds, baseid) == 0 then
        srcType = srcType | 1
        table.insert(equipIds, baseid)
      end
      local surIds = BagProxy.GetSurceEquipIds(baseid)
      for j = 1, #surIds do
        if TableUtility.ArrayFindIndex(equipIds, surIds[j]) == 0 then
          srcType = srcType | 1
          table.insert(equipIds, surIds[j])
        end
      end
    end
  end
  local replaceIds = replaceProductKeyMap[equipId]
  if replaceIds then
    for i = 1, #replaceIds do
      local baseid = replaceIds[i]
      if TableUtility.ArrayFindIndex(equipIds, baseid) == 0 then
        srcType = srcType | 2
        table.insert(equipIds, baseid)
      end
      local surIds = BagProxy.GetSurceEquipIds(baseid)
      for j = 1, #surIds do
        if TableUtility.ArrayFindIndex(equipIds, surIds[j]) == 0 then
          srcType = srcType | 2
          table.insert(equipIds, surIds[j])
        end
      end
    end
  end
  sourceEquipTypeMap[equipId] = srcType
  return equipIds, srcType
end
function BagProxy.GetReplaceEquipIds(equipId)
  InitUpgradeReplace()
  local equipData = Table_Equip[equipId]
  local vid = equipData and equipData.VID
  if vid then
    local key1, key2 = math.floor(vid / 10000), vid % 1000
    local map = equipVidMap[key1]
    return map and map[key2]
  end
end
function BagProxy:GetItemSiteStrengthLv(guid, pos)
  local itemdata = self.roleEquip:GetEquipBySite(pos)
  if itemdata and itemdata.id and itemdata.id == guid then
    return StrenthProxy.Instance:GetStrengthLvByPos(pos)
  end
  return 0
end
local suitIdsMap = {}
function BagProxy.GetSuitIds(itemid)
  local ids = suitIdsMap[itemid]
  if ids ~= nil then
    return ids
  end
  ids = {}
  suitIdsMap[itemid] = ids
  local s1 = Table_Equip[itemid] and Table_Equip[itemid].SuitID
  for i = 1, #s1 do
    table.insert(ids, s1[i])
  end
  local surEquips = BagProxy.GetSurceEquipIds(itemid)
  for i = 1, #surEquips do
    local equipId = surEquips[i]
    local suitids = BagProxy.GetSuitIds(equipId)
    for i = 1, #suitids do
      if TableUtility.ArrayFindIndex(ids, suitids[i]) == 0 then
        table.insert(ids, suitids[i])
      end
    end
  end
  return ids
end
local suitEquipMap = {}
function BagProxy:MatchEquipSuitBySuitId(suitId)
  local suitData = Table_EquipSuit[suitId]
  if suitData == nil then
    return 0
  end
  local suitEquips = suitData.Suitid
  for i = 1, #suitEquips do
    suitEquipMap[suitEquips[i]] = 0
  end
  local items = self.roleEquip:GetItems()
  for i = 1, #items do
    local itemid = items[i].staticData.id
    local find = false
    if suitEquipMap[itemid] then
      find = true
      suitEquipMap[itemid] = suitEquipMap[itemid] + 1
    end
    if not find then
      local surEquips = BagProxy.GetSurceEquipIds(itemid)
      for j = 1, #surEquips do
        local surId = surEquips[j]
        if suitEquipMap[surId] then
          find = true
          suitEquipMap[surId] = suitEquipMap[surId] + 1
          break
        end
      end
    end
  end
  local matchCount = 0
  for k, v in pairs(suitEquipMap) do
    if v > 0 then
      matchCount = matchCount + 1
    end
  end
  TableUtility.TableClear(suitEquipMap)
  return matchCount
end
local initUnlockSpace
function BagProxy:GetBagUnlockSpaceData()
  if not initUnlockSpace then
    initUnlockSpace = true
    self.unloceSpaceLvs = {}
    for id, data in pairs(Table_UnlockSpace) do
      table.insert(self.unloceSpaceLvs, data.id)
    end
    table.sort(self.unloceSpaceLvs, function(ida, idb)
      return ida < idb
    end)
  end
  local mylv = MyselfProxy.Instance:RoleLevel()
  local index = 0
  for i = 1, #self.unloceSpaceLvs do
    if mylv < self.unloceSpaceLvs[i] then
      index = i
      break
    end
  end
  return Table_UnlockSpace[self.unloceSpaceLvs[index]]
end
function BagProxy:CheckItemCanMakeByComposeID(composeID, checkBagType)
  local composeData = Table_Compose[composeID]
  if not composeData then
    return false
  end
  local tbItem = Table_Item
  local bagtype = self:Get_PackageMaterialCheck_BagTypes(checkBagType)
  local costItems = composeData.BeCostItem
  local singleCostItem, itemData, matItemDatas, matExistNum
  for i = 1, #costItems do
    singleCostItem = costItems[i]
    itemData = tbItem[singleCostItem.id]
    if itemData and itemData.Type ~= 50 then
      matItemDatas = self:GetMaterialItems_ByItemId(singleCostItem.id, bagtype)
      matExistNum = 0
      if matItemDatas then
        for j = 1, #matItemDatas do
          matExistNum = matExistNum + matItemDatas[j].num
        end
      end
      if matExistNum < (singleCostItem.num or 0) then
        return false
      end
    end
  end
  return true
end
function BagProxy:GetMaterialItems_ByItemId(itemid, bagTypes, matchCall, matchCallParam)
  if bagTypes == nil then
    return self:GetItemsByStaticID(itemid)
  else
    local result = {}
    local mItems
    for i = 1, #bagTypes do
      mItems = self:GetItemsByStaticID(itemid, bagTypes[i])
      if mItems then
        for j = 1, #mItems do
          if matchCall then
            matchCall(matchCallParam, mItems[j])
          end
          table.insert(result, mItems[j])
        end
      end
    end
    return result
  end
end
local upgrade_checkbagtypes_map
function BagProxy:RefreshUpgradeCheckInfo(bagData)
  if bagData == nil then
    return
  end
  if upgrade_checkbagtypes_map == nil then
    upgrade_checkbagtypes_map = {}
    local upgradeCheckTypes = EquipInfo.GetEquipCheckTypes()
    for i = 1, #upgradeCheckTypes do
      upgrade_checkbagtypes_map[upgradeCheckTypes[i]] = 1
    end
  end
  if upgrade_checkbagtypes_map[bagData.type] == nil then
    return
  end
  local bagData, bagTab, items
  for bagType, v in pairs(self.EquipUpgrade_RefreshBagType) do
    bagData = self.bagMap[bagType]
    bagTab = bagData:GetTab(GameConfig.ItemPage[1]) or bagData.wholeTab
    items = bagTab:GetItems()
    for j = 1, #items do
      if items[j].equipInfo then
        items[j].equipInfo:SetUpgradeCheckDirty()
      end
    end
  end
end
BagProxy.MaterialCheckBag_Type = {
  Produce = "produce",
  Upgrade = "upgrade",
  Equipexchange = "equipexchange",
  Exchange = "exchange",
  Refine = "refine",
  Repair = "repair",
  Enchant = "enchant",
  Guilddonate = "guilddonate",
  Restore = "restore",
  Shop = "shop",
  adventureProduce = "adventureProduce",
  Furniture = "furniture"
}
function BagProxy:Get_PackageMaterialCheck_BagTypes(key)
  local packageMaterialCheck = GameConfig.PackageMaterialCheck
  if packageMaterialCheck == nil then
    return
  end
  if packageMaterialCheck[key] == nil then
    return packageMaterialCheck.default
  end
  return packageMaterialCheck[key]
end
function BagProxy:GetMarryInviteLetters()
  local result = {}
  local mainBag = self:GetBagByType(BagProxy.BagType.MainBag)
  local items = mainBag:GetItems()
  for i = 1, #items do
    if items[i]:IsMarryInviteLetter() then
      table.insert(result, items[i])
    end
  end
  return result
end
function BagProxy:NeedShowEnchantTip()
  FunctionUnLockFunc.Me():CheckCanOpenByPanelId(305, withTip, unlockType)
end
local t_srched = {}
function BagProxy:CollectQuickStorageItems(ref_recv, bagType)
  if ref_recv == nil then
    error("ref_recv is nil")
  end
  local items = self.personalRepositoryBag:GetItems()
  if items == nil then
    return
  end
  for i = 1, #items do
    local sid = items[i].staticData.id
    if items[i]:CanStack() and t_srched[sid] == nil then
      t_srched[sid] = 1
      local bitems = self:GetItemsByStaticID(sid, bagType)
      if bitems then
        for k, bitem in pairs(bitems) do
          if bitem:CanStack() then
            table.insert(ref_recv, bitem)
          end
        end
      end
    end
  end
  TableUtility.TableClear(t_srched)
end
function BagProxy:CollectQuickSaleItems(ref_recv, bagType)
  if ref_recv == nil then
    error("ref_recv is nil")
  end
  bagType = bagType or BagProxy.BagType.MainBag
  local bagData = self.bagMap[bagType]
  if bagData == nil then
    return
  end
  local items = bagData:GetItems()
  if items == nil then
    return
  end
  local item, sData
  for i = 1, #items do
    item = items[i]
    if self:CanQuickSell(item) then
      table.insert(ref_recv, item)
    end
  end
end
function BagProxy:CheckExistItems()
  if not self.existItems then
    self.existItems = {}
  else
    TableUtility.ArrayClear(self.existItems)
  end
  local checkItems = GameConfig.AdventureExist or {}
  for i = 1, #checkItems do
    local packages = GameConfig.PackageMaterialCheck.Exist
    local count = 0
    count = count + BagProxy.Instance:GetItemNumByStaticID(checkItems[i], packages)
    count = count + BagProxy.Instance.roleEquip:GetEquipedItemNum(checkItems[i])
    self.existItems[checkItems[i]] = count > 0
  end
end
function BagProxy:CanQuickSell(item)
  if item == nil then
    return false
  end
  local sData = item.staticData
  if not ItemFun.canQuickSell(sData.id) then
    return false
  end
  if self:CheckIsFavorite(item) then
    return false
  end
  if item.equipInfo ~= nil and item.equipInfo.damage then
    return false
  end
  if item.equipInfo ~= nil and item.equipInfo.refinelv >= 5 then
    return false
  end
  local equipedCards = item.equipedCardInfo
  if equipedCards ~= nil and type(item.cardSlotNum) == "number" then
    for i = 1, item.cardSlotNum do
      if equipedCards[i] then
        return false
      end
    end
  end
  if item.equipInfo ~= nil and item.equipInfo.strengthlv > 0 then
    return false
  end
  local enchantInfo = item.enchantInfo
  local enchantAttrs = enchantInfo and enchantInfo:GetEnchantAttrs()
  if enchantAttrs and #enchantAttrs > 0 then
    return false
  end
  return true
end
function BagProxy:GetFavoriteItemDatas()
  self.favoriteItemDatas = self.favoriteItemDatas or {}
  if next(self.favoriteItemDatas) then
    TableUtility.TableClear(self.favoriteItemDatas)
  end
  local allItemDatas = self.bagData:GetItems()
  local data
  for i = 1, #allItemDatas do
    data = allItemDatas[i]
    if self:CheckIsFavorite(data) then
      TableUtility.ArrayPushBack(self.favoriteItemDatas, data)
    end
  end
  return self.favoriteItemDatas
end
function BagProxy:TryNegateFavoriteOfItem(itemData, packType)
  if not BagProxy.CheckIfCanDoFavoriteActions(itemData) then
    return
  end
  local wasFavorite = itemData.isFavorite
  local arr = ReusableTable.CreateArray()
  arr[1] = itemData.id
  if not wasFavorite then
    self:CallAddFavoriteItems(arr, packType)
  else
    self:CallDelFavoriteItems(arr, packType)
  end
  ReusableTable.DestroyAndClearArray(arr)
end
local findPackType = function(guid, bagMap)
  if not guid or not bagMap then
    return
  end
  local item
  for bagType, bagData in pairs(bagMap) do
    item = bagData:GetItemByGuid(guid)
    if item then
      return bagType
    end
  end
end
local callFavoriteItemAction = function(t, guids, packType, bagMap)
  if not packType and bagMap then
    packType = findPackType(guids and guids[1], bagMap)
  end
  ServiceItemProxy.Instance:CallFavoriteItemActionItemCmd(t, guids, packType)
end
function BagProxy:CallAddFavoriteItems(itemIds, packType)
  callFavoriteItemAction(SceneItem_pb.EFAVORITEACTION_ADD, itemIds, packType, self.bagMap)
end
function BagProxy:CallDelFavoriteItems(itemIds, packType)
  callFavoriteItemAction(SceneItem_pb.EFAVORITEACTION_DEL, itemIds, packType, self.bagMap)
end
function BagProxy:CheckIsFavorite(itemData, bagTypesToCheck)
  if not BagProxy.CheckIfCanDoFavoriteActions(itemData) then
    return false
  end
  if not itemData.isFavorite and bagTypesToCheck then
    local typeOfParam, itemInBag = type(bagTypesToCheck)
    if typeOfParam == "table" and next(bagTypesToCheck) then
      for i = 1, #bagTypesToCheck do
        itemInBag = self:GetItemByGuid(itemData.id, bagTypesToCheck[i])
      end
    elseif not itemInBag and typeOfParam == "number" then
      itemInBag = self:GetItemByGuid(itemData.id, bagTypesToCheck)
    end
    if itemInBag then
      return itemInBag.isFavorite
    end
  end
  return itemData.isFavorite
end
function BagProxy:CheckIfFavoriteCanBeMaterial(itemData, bagTypesToCheck)
  if not self:CheckIsFavorite(itemData, bagTypesToCheck) then
    return nil
  end
  return not ItemFun.favoriteCheck(2, itemData.staticData.id, itemData.staticData.Type)
end
function BagProxy.CheckIfCanDoFavoriteActions(itemData)
  if not itemData then
    return false
  end
  if itemData.staticData and itemData.staticData.Type == 65 then
    return false
  end
  return true
end
function BagProxy:SaveBattleTimeItem(itemData)
  self.battletimeItem = itemData
end
function BagProxy:GetBattleTimeItem()
  return self.battletimeItem
end
function BagProxy:GetMountPets()
  local items = self.petBagData:GetItems()
  local pets = {}
  for i = 1, #items do
    if items[i].petEggInfo and items[i].petEggInfo:PetMountCanEquip() then
      pets[#pets + 1] = items[i]
    end
  end
  return pets
end
function BagProxy:GetMountPetsID()
  local pets, ids = self:GetMountPets(), {}
  for i = 1, #pets do
    ids[#ids + 1] = pets[i].id
  end
  return ids
end
local baseSortWalletFunc = function(lId, rId, lSort, rSort)
  if lSort == rSort then
    return lId < rId
  else
    return lSort < rSort
  end
end
local SortWalletFunc = function(l, r)
  local lNew = l:IsNew()
  local rNew = r:IsNew()
  local walletCfg = Game.Config_Wallet
  local lSortId = walletCfg[l.staticData.id].Sort
  local RSortId = walletCfg[r.staticData.id].Sort
  local lId = walletCfg[l.staticData.id].id
  local rId = walletCfg[r.staticData.id].id
  if lNew and rNew then
    return baseSortWalletFunc(lId, rId, lSortId, RSortId)
  end
  if lNew or rNew then
    return lNew
  end
  if lNew == false and rNew == false then
    return baseSortWalletFunc(lId, rId, lSortId, RSortId)
  end
  return baseSortWalletFunc(lId, rId, lSortId, RSortId)
end
function BagProxy:GetwalletBagData(type, isWallet, filter)
  local datas = self.walletBagData.wholeTab:GetItems()
  local result = {}
  local walletCfg = Game.Config_Wallet
  for i = 1, #datas do
    local isaccount = datas[i]:IsWalletAccountItem()
    local isRole = not isaccount
    local canAdd = true
    if filter == 1 then
      canAdd = true
    elseif filter == 2 then
      canAdd = isaccount
    else
      canAdd = isRole
    end
    if canAdd and datas[i].staticData and datas[i].staticData.id and walletCfg[datas[i].staticData.id].Type == type then
      datas[i].isWallet = isWallet
      result[#result + 1] = datas[i]
    end
  end
  table.sort(result, function(l, r)
    return SortWalletFunc(l, r)
  end)
  return result
end
function BagProxy:InitMoneyItem()
  if not Table_Wallet then
    return
  end
  if not self.bindItem and GameConfig.BindItem then
    self.bindItem = {}
    for _, v in pairs(GameConfig.BindItem) do
      self.bindItem[#self.bindItem + 1] = v
    end
  end
  self.moneyItems = {}
  for k, v in pairs(Table_Wallet) do
    local item
    if v.Type == 1 and 0 == TableUtility.ArrayFindIndex(self.bindItem, v.ItemID) then
      item = ItemData.new("wallet", v.ItemID)
      local value, bindValue = 0, 0
      local uName = GameConfig.Wallet.MoneyRef[v.ItemID]
      local bindID, bindName = GameConfig.BindItem[v.ItemID], nil
      if bindID then
        bindName = GameConfig.Wallet.MoneyRef[bindID]
        bindValue = bindName and (Game.Myself.data.userdata:Get(bindName) or 0)
      end
      if uName then
        local dnum = Game.Myself.data.userdata:Get(uName) or 0
        value = bindValue and bindValue + dnum or dnum
      else
        local walletNum = self:GetItemNumByStaticID(v.ItemID, BagProxy.BagType.Wallet)
        if bindID then
          value = walletNum + self:GetItemNumByStaticID(bindID, BagProxy.BagType.Wallet)
        else
          value = walletNum
        end
      end
      item:SetItemNum(value)
      if v.KeepDisplay == 1 or value > 0 then
        self.moneyItems[#self.moneyItems + 1] = item
      end
    end
  end
  local debts = MyselfProxy.Instance:GetDebts()
  for i = 1, #debts do
    local item = ItemData.new("wallet", debts[i].id)
    item:SetItemNum(-debts[i].num)
    item.debtType = debts[i].type
    self.moneyItems[#self.moneyItems + 1] = item
  end
end
local staticEquipRandomEffectsSortFunc = function(l, r)
  return l.id < r.id
end
function BagProxy:GetStaticEquipRandomEffectData(staticId)
  if not self.staticRandomEffectMap then
    self.staticRandomEffectMap = {}
    local list
    for _, d in pairs(Table_EquipEffect) do
      list = self.staticRandomEffectMap[d.EquipID] or {}
      TableUtility.ArrayPushBack(list, d)
      self.staticRandomEffectMap[d.EquipID] = list
    end
    for _, effects in pairs(self.staticRandomEffectMap) do
      table.sort(effects, staticEquipRandomEffectsSortFunc)
    end
  end
  return self.staticRandomEffectMap[staticId]
end
return BagProxy
