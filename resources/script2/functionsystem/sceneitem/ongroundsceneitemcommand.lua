OnGroundSceneItemCommand = class("OnGroundSceneItemCommand")
function OnGroundSceneItemCommand.Me()
  if nil == OnGroundSceneItemCommand.me then
    OnGroundSceneItemCommand.me = OnGroundSceneItemCommand.new()
  end
  return OnGroundSceneItemCommand.me
end
function OnGroundSceneItemCommand:ctor()
  self:Reset()
end
function OnGroundSceneItemCommand:Clear()
  for _, item in pairs(self.hasPickRight) do
    item:DestorySelf(true)
  end
  for _, item in pairs(self.noPickRight) do
    item:DestorySelf(true)
  end
  self.hasPickRight = {}
  self.noPickRight = {}
end
function OnGroundSceneItemCommand:Reset()
  self.hasPickRight = {}
  self.noPickRight = {}
  if self.timeTick == nil then
    self.timeTick = TimeTickManager.Me():CreateTick(0, 33, self.Tick, self)
  end
end
function OnGroundSceneItemCommand:Removes(guids)
  local id = 0
  for i = 1, #guids do
    self:Remove(guids[i])
  end
end
function OnGroundSceneItemCommand:RemoveItem(item)
  self:Remove(item.id)
end
function OnGroundSceneItemCommand:Remove(id)
  local item = self.hasPickRight[id]
  if item == nil then
    item = self.noPickRight[id]
    self.noPickRight[id] = nil
  else
    self.hasPickRight[id] = nil
  end
  if item ~= nil then
    item:DestorySelf()
  end
end
function OnGroundSceneItemCommand:SetRemoveFlag(id)
  local item = self.hasPickRight[id]
  if item == nil then
    item = self.noPickRight[id]
  end
  if item ~= nil and not item.isPicked then
    self.noPickRight[id] = nil
    self.hasPickRight[id] = nil
    item:DestorySelf()
  end
end
function OnGroundSceneItemCommand:Pick(itemID, creatureID)
  local item
  if type(itemID) == "number" then
    item = self.hasPickRight[itemID]
    if item == nil then
      item = self.noPickRight[itemID]
    end
  else
    item = itemID
  end
  local canPick = item ~= nil
  if canPick then
    item:Pick(self.PickSuccess, self, creatureID)
  end
  return canPick
end
function OnGroundSceneItemCommand:PickItem(item, creatureID)
  item:Pick(self.PickSuccess, self, creatureID, true)
end
local tmpPos = LuaVector3.Zero()
function OnGroundSceneItemCommand:PickSuccess(item, creatureID, removeDirect)
  function item.animPlayer.animatorHelper.loopCountChangedListener(state, old, new)
    if state:IsName(GameConfig.SceneDropItem.Anims.ItemOpen) then
      if removeDirect then
        item:DestorySelf()
      else
        self:Remove(item.id)
      end
    end
  end
  if not creatureID then
    return
  end
  local creature = SceneCreatureProxy.FindCreature(creatureID)
  if creature then
    local path = GameConfig.SceneDropItem.ItemPickBall[item.staticData.Quality]
    local pos = tmpPos
    if item.pointSub ~= nil then
      pos[1], pos[2], pos[3] = LuaGameObject.GetPosition(item.pointSub:GetEffectPoint(RoleDefines_EP.Top).transform)
    else
      pos = item.pos
    end
    creature:PlayPickUpTrackEffect(path, pos, GameConfig.SceneDropItem.ItemPickBallSpeed, item.config.pickedAudio)
  end
end
function OnGroundSceneItemCommand:AddToHasRightPick(item)
  self.noPickRight[item.id] = nil
  self.hasPickRight[item.id] = item
  item:SetCanPickUp(true)
  item:ClearOnGroundCallBack()
end
function OnGroundSceneItemCommand:AddToNoRightPick(item)
  self.noPickRight[item.id] = item
  item:ClearOnGroundCallBack()
end
function OnGroundSceneItemCommand:Tick(deltaTime)
  for id, item in pairs(self.noPickRight) do
    if item.iCanPickUp == false then
      item.privateOwnLeftTime = item.privateOwnLeftTime - deltaTime
      if item.privateOwnLeftTime <= 0 then
        local creatureId = FunctionSceneItemCommand.Me():GetCreatureIdByItemId(item.id)
        if creatureId then
          self:Pick(item.id, creatureId)
        else
          self:RemoveItem(item)
        end
      end
    end
  end
end
