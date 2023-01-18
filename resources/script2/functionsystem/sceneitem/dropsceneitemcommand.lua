autoImport("OnGroundSceneItemCommand")
DropSceneItemCommand = class("DropSceneItemCommand")
function DropSceneItemCommand.Me()
  if nil == DropSceneItemCommand.me then
    DropSceneItemCommand.me = DropSceneItemCommand.new()
  end
  return DropSceneItemCommand.me
end
function DropSceneItemCommand:ctor()
  self.onGroundCmd = OnGroundSceneItemCommand.Me()
  self.configPrivateOwnTime = GameConfig.SceneDropItem.privateOwnTime
  self:Reset()
end
function DropSceneItemCommand:Reset()
  self.waiting = {}
  self.dropping = {}
  self.appearing = {}
  if self.timeTick == nil then
    self.timeTick = TimeTickManager.Me():CreateTick(0, 33, self.Tick, self)
  end
end
function DropSceneItemCommand:Clear()
  for _, item in pairs(self.waiting) do
    item:DestorySelf(true)
  end
  for _, item in pairs(self.dropping) do
    item:DestorySelf(true)
  end
  for _, item in pairs(self.appearing) do
    item:DestorySelf(true)
  end
  self.waiting = {}
  self.dropping = {}
  TableUtility.TableClear(self.appearing)
end
function DropSceneItemCommand:AddItems(items)
  for i = 1, #items do
    self:AddItem(items[i])
  end
end
function DropSceneItemCommand:AddItem(item)
  if item.privateOwnLeftTime < self.configPrivateOwnTime then
    self.appearing[item.id] = item
    item:Appear(function(itemCallBack)
      self:PickUpCreatureById(itemCallBack)
      self.appearing[itemCallBack.id] = nil
    end, item)
  else
    self:AddToWaitDrop(item)
  end
  return nil
end
function DropSceneItemCommand:AddToWaitDrop(item)
  self.waiting[item.id] = item
end
function DropSceneItemCommand:AddToDropping(item)
  self.waiting[item.id] = nil
  item:PlayAppear(function(itemCallBack)
    local creatureId = FunctionSceneItemCommand.Me():GetCreatureIdByItemId(itemCallBack.id)
    if creatureId then
      self.onGroundCmd:PickItem(itemCallBack, creatureId)
      FunctionSceneItemCommand.Me():SetToListPickUp(itemCallBack.id, nil)
    else
      self.dropping[itemCallBack.id] = itemCallBack
      itemCallBack.privateOwnLeftTime = self.configPrivateOwnTime
      itemCallBack:SetOnGroundCallBack(self.DropOnGround, self, itemCallBack.iCanPickUp)
    end
  end, item)
end
function DropSceneItemCommand:PickUpCreatureById(item)
  local creatureId = FunctionSceneItemCommand.Me():GetCreatureIdByItemId(item.id)
  if creatureId then
    self.onGroundCmd:PickItem(item, creatureId)
    FunctionSceneItemCommand.Me():SetToListPickUp(item.id, nil)
  else
    self:DropOnGround(item, item.privateOwnLeftTime <= 0 or item.iCanPickUp)
  end
end
function DropSceneItemCommand:DropOnGround(item, hasRight)
  self.dropping[item.id] = nil
  if item.config.ShowName then
    item:ShowName()
  end
  if hasRight then
    self.onGroundCmd:AddToHasRightPick(item)
  else
    self.onGroundCmd:AddToNoRightPick(item)
  end
end
function DropSceneItemCommand:SetRemoveFlag(id)
  if self:RemoveWaitDrop(id) == false and self:RemoveDropping(id) == false then
    self.onGroundCmd:SetRemoveFlag(id)
  end
end
function DropSceneItemCommand:RemoveWaitDrop(guid)
  local dropItem = self.waiting[guid]
  if dropItem ~= nil then
    dropItem:DestorySelf()
    self.waiting[guid] = nil
    return true
  end
  return false
end
function DropSceneItemCommand:ForceRemove(item)
  if item ~= nil then
    item:DestorySelf()
    self.dropping[item.id] = nil
  end
end
function DropSceneItemCommand:RemoveDropping(guid, force)
  local dropItem = self.dropping[guid]
  if dropItem ~= nil then
    if force then
      self:ForceRemove(dropItem)
    else
      dropItem:SetDestroyFlag(self.ForceRemove, self)
    end
    return true
  end
  return false
end
function DropSceneItemCommand:PickUpDropping(creature, guid)
  local dropItem = self.dropping[guid]
  if dropItem ~= nil then
    dropItem:SetPickUpFlag(self.onGroundCmd.Pick, self.onGroundCmd, creature.data.id)
    return true
  end
  return false
end
function DropSceneItemCommand:RemoveItems(items)
  for i = 1, #items do
    self:RemoveItem(items[i])
  end
end
function DropSceneItemCommand:RemoveItem(item)
  self.waiting[item.id] = nil
  self.dropping[item.id] = nil
  self.appearing[item.id] = nil
  item:DestorySelf()
end
function DropSceneItemCommand:Tick(deltaTime)
  self:TickWaiting(deltaTime)
end
function DropSceneItemCommand:TickWaiting(deltaTime)
  for id, item in pairs(self.waiting) do
    item.privateOwnLeftTime = item.privateOwnLeftTime - deltaTime
    if item.privateOwnLeftTime <= self.configPrivateOwnTime then
      self:AddToDropping(item)
    end
  end
end
