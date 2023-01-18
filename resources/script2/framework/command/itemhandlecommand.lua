local ItemHandleCommand = class("ItemHandleCommand", pm.SimpleCommand)
function ItemHandleCommand:execute(note)
  if note ~= nil then
    self.cdRefreshcmd = FunctionCDCommand.Me():GetBagItemDataCDProxy(BagProxy.Instance)
    self.equipBag = BagProxy.Instance.bagMap[SceneItem_pb.EPACKTYPE_EQUIP]
    self.equipItems = nil
    self.profess = Game.Myself.data.userdata:Get(UDEnum.PROFESSION)
    if note.name == ServiceEvent.ItemPackageItem then
      self:ReInit(note)
    elseif note.name == ServiceEvent.ItemPackageUpdate then
      self:Update(note)
    elseif note.name == ServiceEvent.ItemPackageSort then
      self:ReArrange(note)
    end
    local instance = GuideMaskView.Instance
    if instance then
      instance:showGuideByQuestDataRepeat()
    end
  end
end
function ItemHandleCommand:ReInit(note)
  local PackageItem = note.body
  local bagData = BagProxy.Instance.bagMap[PackageItem.type]
  if bagData ~= nil then
    BagProxy.Instance:InitMoneyItem()
    bagData:UpdateItems(PackageItem.data)
    bagData:SetUplimit(PackageItem.maxslot)
    self:ForEachInitItems(bagData, PackageItem.data)
    if PackageItem.type == SceneItem_pb.EPACKTYPE_MAIN then
      self.facade:sendNotification(ItemEvent.ItemUpdate)
    elseif PackageItem.type == SceneItem_pb.EPACKTYPE_STORE then
      self.facade:sendNotification(ItemEvent.ItemUpdate)
    elseif PackageItem.type == SceneItem_pb.EPACKTYPE_PERSONAL_STORE then
      self.facade:sendNotification(ItemEvent.ItemUpdate)
    elseif PackageItem.type == SceneItem_pb.EPACKTYPE_EQUIP then
      self.facade:sendNotification(ItemEvent.EquipUpdate)
    elseif PackageItem.type == SceneItem_pb.EPACKTYPE_FASHIONEQUIP then
      self.facade:sendNotification(ItemEvent.EquipUpdate)
    elseif PackageItem.type == SceneItem_pb.EPACKTYPE_FASHION then
      self.facade:sendNotification(ItemEvent.FashionUpdate)
    elseif PackageItem.type == SceneItem_pb.EPACKTYPE_CARD then
      self.facade:sendNotification(ItemEvent.CardBagUpdate)
    elseif PackageItem.type == SceneItem_pb.EPACKTYPE_TEMP_MAIN then
      self.facade:sendNotification(ItemEvent.TempBagUpdate)
    elseif PackageItem.type == SceneItem_pb.EPACKTYPE_BARROW then
      self.facade:sendNotification(ItemEvent.BarrowUpdate)
    elseif PackageItem.type == SceneItem_pb.EPACKTYPE_QUEST then
      self.facade:sendNotification(ItemEvent.QuestUpdate)
      EventManager.Me():PassEvent(ItemEvent.QuestUpdate)
    elseif PackageItem.type == SceneItem_pb.EPACKTYPE_FOOD then
      self.facade:sendNotification(ItemEvent.FoodUpdate)
      EventManager.Me():PassEvent(ItemEvent.FoodUpdate)
    elseif PackageItem.type == SceneItem_pb.EPACKTYPE_PET then
      self.facade:sendNotification(ItemEvent.PetUpdate)
      EventManager.Me():PassEvent(ItemEvent.PetUpdate)
      PetProxy.Instance:ResetCFGExistPets()
    elseif PackageItem.type == SceneItem_pb.EPACKTYPE_GEM_ATTR then
      EventManager.Me():PassEvent(ItemEvent.GemUpdate)
      self.facade:sendNotification(ItemEvent.GemUpdate)
    elseif PackageItem.type == SceneItem_pb.EPACKTYPE_GEM_SKILL then
      EventManager.Me():PassEvent(ItemEvent.GemUpdate)
      self.facade:sendNotification(ItemEvent.GemUpdate)
    elseif PackageItem.type == SceneItem_pb.EPACKTYPE_HOME then
      self.facade:sendNotification(ItemEvent.ItemUpdate)
    elseif PackageItem.type == SceneItem_pb.EPACKTYPE_WALLET then
      self.facade:sendNotification(ItemEvent.ItemUpdate)
      self.facade:sendNotification(ItemEvent.WalletUpdate)
    elseif PackageItem.type == SceneItem_pb.EPACKTYPE_ARTIFACT then
      self.facade:sendNotification(ItemEvent.PersonalArtifactUpdate)
      EventManager.Me():PassEvent(ItemEvent.PersonalArtifactUpdate)
    elseif PackageItem.type == SceneItem_pb.EPACKTYPE_ARTIFACT_FLAGMENT then
      self.facade:sendNotification(ItemEvent.PersonalArtifactUpdate)
      EventManager.Me():PassEvent(ItemEvent.PersonalArtifactUpdate)
    end
    if self.betterEquipChanged then
      self.facade:sendNotification(ItemEvent.BetterEquipAdd)
    end
  end
  ServiceUserProxy.Instance:SetInited()
end
function ItemHandleCommand:Update(note)
  local PackageItem = note.body
  local bagData = BagProxy.Instance.bagMap[PackageItem.type]
  if bagData ~= nil then
    self:DelWalletItem(PackageItem.delItems, PackageItem.type)
    self:ForEachRemoveItems(bagData, PackageItem.delItems)
    bagData:RemoveItems(PackageItem.delItems)
    bagData:UpdateItems(PackageItem.updateItems)
    self:ForEachAddItems(bagData, PackageItem.updateItems)
    if PackageItem.type == SceneItem_pb.EPACKTYPE_MAIN then
      self.facade:sendNotification(ItemEvent.ItemUpdate)
      EventManager.Me():PassEvent(ItemEvent.ItemUpdate)
    elseif PackageItem.type == SceneItem_pb.EPACKTYPE_STORE then
      self.facade:sendNotification(ItemEvent.ItemUpdate)
    elseif PackageItem.type == SceneItem_pb.EPACKTYPE_PERSONAL_STORE then
      EventManager.Me():PassEvent(ItemEvent.ItemUpdate)
      self.facade:sendNotification(ItemEvent.ItemUpdate)
    elseif PackageItem.type == SceneItem_pb.EPACKTYPE_EQUIP then
      self.facade:sendNotification(ItemEvent.EquipUpdate)
    elseif PackageItem.type == SceneItem_pb.EPACKTYPE_FASHIONEQUIP then
      self.facade:sendNotification(ItemEvent.EquipUpdate)
    elseif PackageItem.type == SceneItem_pb.EPACKTYPE_FASHION then
      self.facade:sendNotification(ItemEvent.FashionUpdate)
    elseif PackageItem.type == SceneItem_pb.EPACKTYPE_CARD then
      self.facade:sendNotification(ItemEvent.CardBagUpdate)
    elseif PackageItem.type == SceneItem_pb.EPACKTYPE_TEMP_MAIN then
      self.facade:sendNotification(ItemEvent.TempBagUpdate)
    elseif PackageItem.type == SceneItem_pb.EPACKTYPE_BARROW then
      self.facade:sendNotification(ItemEvent.BarrowUpdate)
      EventManager.Me():PassEvent(ItemEvent.ItemUpdate)
    elseif PackageItem.type == SceneItem_pb.EPACKTYPE_QUEST then
      self.facade:sendNotification(ItemEvent.QuestUpdate)
      self.facade:sendNotification(ItemEvent.ItemUpdate)
      EventManager.Me():PassEvent(ItemEvent.ItemUpdate)
    elseif PackageItem.type == SceneItem_pb.EPACKTYPE_FOOD then
      self.facade:sendNotification(ItemEvent.FoodUpdate)
      EventManager.Me():PassEvent(ItemEvent.FoodUpdate)
    elseif PackageItem.type == SceneItem_pb.EPACKTYPE_PET then
      self.facade:sendNotification(ItemEvent.PetUpdate)
      EventManager.Me():PassEvent(ItemEvent.PetUpdate)
      PetProxy.Instance:ResetCFGExistPets()
    elseif PackageItem.type == SceneItem_pb.EPACKTYPE_FURNITURE then
      self.facade:sendNotification(ItemEvent.FurnitureUpdate)
      EventManager.Me():PassEvent(ItemEvent.FurnitureUpdate)
    elseif PackageItem.type == SceneItem_pb.EPACKTYPE_GEM_ATTR then
      EventManager.Me():PassEvent(ItemEvent.GemUpdate)
      self.facade:sendNotification(ItemEvent.GemUpdate)
    elseif PackageItem.type == SceneItem_pb.EPACKTYPE_GEM_SKILL then
      EventManager.Me():PassEvent(ItemEvent.GemUpdate)
      self.facade:sendNotification(ItemEvent.GemUpdate)
    elseif PackageItem.type == SceneItem_pb.EPACKTYPE_HOME then
      EventManager.Me():PassEvent(ItemEvent.ItemUpdate)
      self.facade:sendNotification(ItemEvent.ItemUpdate)
    elseif PackageItem.type == SceneItem_pb.EPACKTYPE_WALLET then
      self.facade:sendNotification(ItemEvent.ItemUpdate)
      self.facade:sendNotification(ItemEvent.WalletUpdate)
    elseif PackageItem.type == SceneItem_pb.EPACKTYPE_ARTIFACT then
      self.facade:sendNotification(ItemEvent.PersonalArtifactUpdate)
      EventManager.Me():PassEvent(ItemEvent.PersonalArtifactUpdate)
    elseif PackageItem.type == SceneItem_pb.EPACKTYPE_ARTIFACT_FLAGMENT then
      self.facade:sendNotification(ItemEvent.PersonalArtifactUpdate)
      EventManager.Me():PassEvent(ItemEvent.PersonalArtifactUpdate)
    end
    if self.betterEquipChanged then
      self.facade:sendNotification(ItemEvent.BetterEquipAdd)
    end
    self:QuickUseNtf()
  end
end
function ItemHandleCommand:ForEachInitItems(bagData, list)
  self:ForEachItems(bagData, list, self.InitItemHandle)
end
function ItemHandleCommand:ForEachAddItems(bagData, list)
  self.equipItems = self.equipBag.siteMap
  self:ForEachItems(bagData, list, self.AddItemHandle)
end
function ItemHandleCommand:InitItemHandle(bagData, item)
  self:TryAddCD(item)
  self:TryAddReviveItem(bagData, item)
  self:AddTempItemDelCheck(bagData, item)
  self:TryAddMonthCardCheck(bagData, item, true)
  self:CheckQuickUseItem(bagData.type, item.staticData.id)
  item.bagtype = bagData.type
end
function ItemHandleCommand:AddItemHandle(bagData, item, sItem)
  self:TryAddCD(item)
  self:TryAddCompare(bagData, item, sItem)
  self:TryAddReviveItem(bagData, item)
  self:AddTempItemDelCheck(bagData, item)
  self:TryAddMonthCardCheck(bagData, item)
  self:CheckQuickUseItem(bagData.type, item.staticData.id)
  item.bagtype = bagData.type
end
function ItemHandleCommand:ForEachRemoveItems(bagData, list)
  self:ForEachItems(bagData, list, self.RemoveItemHandle)
end
function ItemHandleCommand:RemoveItemHandle(bagData, item, sItem)
  self:TryRemoveCD(item)
  self:TryRemoveCompare(bagData, item, sItem)
  self:TryRemoveReviveItem(bagData, item)
  self:RemoveTempItemDelCheck(bagData, item)
  self:CheckQuickUseItem(bagData.type, item.staticData.id)
end
function ItemHandleCommand:DelWalletItem(server_delItems, type)
  if type ~= SceneItem_pb.EPACKTYPE_MAIN then
    return
  end
  local walletDelItems = {}
  local walletType = BagProxy.BagType.Wallet
  local _proxy = BagProxy.Instance
  local walletBag = _proxy.bagMap[walletType]
  for i = 1, #server_delItems do
    local delItem = _proxy:GetItemByGuid(server_delItems[i].base.guid, walletType)
    if delItem then
      walletDelItems[#walletDelItems + 1] = server_delItems[i]
    end
  end
  if #walletDelItems > 0 then
    self:ForEachRemoveItems(walletBag, server_delItems)
    walletBag:RemoveItems(walletDelItems)
    self.facade:sendNotification(ItemEvent.ItemUpdate)
    self.facade:sendNotification(ItemEvent.WalletUpdate)
  end
end
function ItemHandleCommand:ForEachItems(bagData, list, func)
  for i = 1, #list do
    local sItem = list[i]
    local item = bagData:GetItemByGuid(sItem.base.guid)
    if item then
      func(self, bagData, item, sItem)
    end
  end
  if bagData.type == BagProxy.BagType.RoleEquip then
    FunctionBuff.Me():UpdateBreakEquipBuff()
  end
end
function ItemHandleCommand:TryRemoveCD(item)
  if item then
    self.cdRefreshcmd:Remove(item)
  end
end
function ItemHandleCommand:TryAddCD(item)
  if item:GetCdConfigTime() > 0 then
    self.cdRefreshcmd:Add(item)
  end
end
function ItemHandleCommand:TryAddCompare(bagData, item, sItem)
  if bagData.type == BagProxy.BagType.MainBag or bagData.type == BagProxy.BagType.Temp then
    self:NewAddCompare(item, sItem)
  end
end
local table_MonthCard
function ItemHandleCommand:TryAddMonthCardCheck(bagData, item, isInit)
  if bagData.type ~= BagProxy.BagType.MainBag then
    return
  end
  if table_MonthCard == nil then
    table_MonthCard = Table_MonthCard
  end
  if not table_MonthCard[item.staticData.id] then
    return
  end
  if isInit then
    item.oldNum = item.num
    return
  end
  if item.oldNum == nil or item.num > item.oldNum then
    local amIMonthlyVIP = NewRechargeProxy.Ins:AmIMonthlyVIP()
    if amIMonthlyVIP then
      return
    end
    MsgManager.ConfirmMsgByID(4102, function()
      FunctionItemFunc.TryUseItem(item)
    end, nil, nil)
  end
  item.oldNum = item.num
end
function ItemHandleCommand:TryAddReviveItem(bagData, item)
  local itemid = item.staticData.id
  if bagData.type == BagProxy.BagType.MainBag then
    local playerRelive = GameConfig.PlayerRelive
    if playerRelive then
      local leafreviveId = playerRelive.deathcost[1].id
      local skillItemId = playerRelive.Skillcost[1].id
      if itemid == leafreviveId or itemid == skillItemId then
        self.facade:sendNotification(ItemEvent.ReviveItemAdd, item)
      end
    end
  end
end
function ItemHandleCommand:CheckQuickUseItem(bagType, itemid)
  if ShortCutProxy.Instance:IsQuickUseItem(itemid) then
    if bagType == BagProxy.BagType.RoleEquip or bagType == BagProxy.BagType.RoleFashionEquip then
      self.quickEquipUpdate = true
    else
      self.quickItemUpdate = true
    end
  end
end
function ItemHandleCommand:QuickUseNtf()
  if self.quickEquipUpdate then
    self.facade:sendNotification(ItemEvent.QuickUseItemCheckEquipUpdate)
    self.quickEquipUpdate = false
  end
  if self.quickItemUpdate then
    self.facade:sendNotification(ItemEvent.QuickUseItemCheckUpdate)
    self.quickItemUpdate = false
  end
end
function ItemHandleCommand:TryAddResurrectionToy(bagData, item)
  if bagData.type == BagProxy.BagType.MainBag then
    local resurrection = GameConfig.Resurrection
    if resurrection then
      local rType = resurrection.itemType
      local rItemId = resurrection.itemId
      if item.staticData.id == rItemId or item.staticData.Type == rType then
        self.facade:sendNotification(ItemEvent.ResurrectionToyAdd, item)
      end
    end
  end
end
function ItemHandleCommand:AddTempItemDelCheck(bagData, item)
  if bagData.type == BagProxy.BagType.Temp then
    if item and item.staticData and item.staticData.NoSale ~= 1 then
      FunctionTempItem.Me():AddTempItemDelCheck(item.id, item.deltime)
    end
  elseif bagData.type == BagProxy.BagType.MainBag then
    local sid = item and item.staticData and item.staticData.id
    local interval = sid and Table_UseItem[sid] and Table_UseItem[sid].UseInterval
    if interval then
      FunctionTempItem.Me():AddUseIntervalCheck(item, interval)
    end
  end
end
function ItemHandleCommand:NewAddCompare(item)
  if FunctionItemCompare.Me():CompareItem(item) then
    self.betterEquipChanged = true
  end
end
function ItemHandleCommand:UpdateCompare(item, sItem)
  if item:IsFashion() and not item:IsNew() and QuickUseProxy.Instance:RemoveNeverEquipedFashion(item.staticData.id, true) then
    self.betterEquipChanged = true
  end
end
function ItemHandleCommand:TryRemoveCompare(bagData, item, sItem)
  if bagData.type == BagProxy.BagType.MainBag and FunctionItemCompare.Me():TryRemove(item) then
    self.betterEquipChanged = true
  end
end
function ItemHandleCommand:TryRemoveReviveItem(bagData, item)
  local itemId = item.staticData.id
  if bagData.type == BagProxy.BagType.MainBag then
    local playerRelive = GameConfig.PlayerRelive
    if playerRelive then
      local leafreviveId = playerRelive.deathcost[1].id
      local skillItemId = playerRelive.Skillcost[1].id
      if itemId == leafreviveId or itemId == skillItemId then
        self.facade:sendNotification(ItemEvent.ReviveItemRemove, item)
      end
    end
  end
end
function ItemHandleCommand:RemoveTempItemDelCheck(bagData, item)
  if bagData.type == BagProxy.BagType.Temp then
    FunctionTempItem.Me():RemoveTempItemDelCheck(item.id)
  elseif bagData.type == BagProxy.BagType.MainBag then
    local sid = item and item.staticData and item.staticData.id
    local interval = sid and Table_UseItem[sid] and Table_UseItem[sid].UseInterval
    if interval then
      FunctionTempItem.Me():RemoveIntervalUseItem(item.id)
    end
  end
end
function ItemHandleCommand:TryRemoveResurrectionToy(bagData, item)
  if bagData.type == BagProxy.BagType.MainBag then
    local resurrection = GameConfig.Resurrection
    if resurrection then
      local rType = resurrection.itemType
      local rItemId = resurrection.itemId
      if item.staticData.id == rItemId or item.staticData.Type == rType then
        self.facade:sendNotification(ItemEvent.ResurrectionToyRemove, item)
      end
    end
  end
end
function ItemHandleCommand:CheckHasType(items, typeID)
  local item
  if items ~= nil then
    for i = 1, #items do
      item = Table_Item[items[i].base.id]
      if item ~= nil and item.Type == typeID then
        return true
      end
    end
  end
  return false
end
function ItemHandleCommand:CheckHasGUID(items, guid)
  if items ~= nil then
    for i = 1, #items do
      if items[i].base.guid == guid then
        return true
      end
    end
  end
  return false
end
function ItemHandleCommand:CheckHasID(items, id)
  if items ~= nil then
    for i = 1, #items do
      if items[i].base.id == id then
        return true
      end
    end
  end
  return false
end
function ItemHandleCommand:ReArrange(note)
  local bagType = note.body.type or SceneItem_pb.EPACKTYPE_MAIN
  local bagData = BagProxy.Instance.bagMap[bagType]
  bagData.wholeTab:ReArrange(note.body.item)
  self.facade:sendNotification(ItemEvent.ItemReArrage, bagType)
end
function ItemHandleCommand:TestRemove(bagData, datas)
  local removes = {}
  local t = os.clock()
  for i = 2, 5 do
    table.insert(removes, datas[i].base.guid)
  end
  bagData:RemoveItemsByGuid(removes)
end
function ItemHandleCommand:TestAddNew(bagData, datas)
  local newAdd = {}
  local count = #datas
  for i = 1, 8 do
    datas[i].base.guid = "TestAddnew_" .. i
    datas[i].base.count = math.random(10, 50)
    datas[i].base.index = count + i
    table.insert(newAdd, datas[i])
  end
  bagData:UpdateItems(newAdd)
end
function ItemHandleCommand:TestAddSame(bagData, datas)
  local newAdd = {}
  for i = 1, 8 do
    datas[i].base.count = math.random(10, 50)
    table.insert(newAdd, datas[i])
  end
  bagData:UpdateItems(newAdd)
end
return ItemHandleCommand
