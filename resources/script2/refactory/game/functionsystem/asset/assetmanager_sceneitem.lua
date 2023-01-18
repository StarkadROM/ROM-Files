AssetManager_SceneItem = class("AssetManager_SceneItem")
local LoadInterval = 0.1
local ListItemId = {
  1,
  2,
  3,
  4,
  5,
  6,
  7
}
local GetFromSceneDropPool = GOLuaPoolManager.GetFromSceneDropPool
local AddToSceneDropPool = GOLuaPoolManager.AddToSceneDropPool
local GetFromSceneSeatPool = GOLuaPoolManager.GetFromSceneSeatPool
local AddToSceneSeatPool = GOLuaPoolManager.AddToSceneSeatPool
local SceneSeatType = Game.GameObjectType.SceneSeat
local IsNull = Slua.IsNull
local CreateReusableTable = ReusableTable.CreateTable
local DestroyAndClearReusableTable = ReusableTable.DestroyAndClearTable
function AssetManager_SceneItem:ctor(assetManager)
  self.goLuaPoolManager = Game.GOLuaPoolManager
  self.assetManager = assetManager
  self.nextLoadTime = 0
  self.sceneDropQueue = {}
  self.sceneSeatQueue = {}
  self.preLoadCount = 15
end
function AssetManager_SceneItem:PreLoadSceneItem()
  for j = 1, #ListItemId do
    local model = ListItemId[j]
    self.assetManager:PreLoadAsset(ResourcePathHelper.Item(model), "resources/", function(asset)
      if asset ~= nil then
        for i = 1, self.preLoadCount do
          local obj = GameObject.Instantiate(asset)
          self:DestroySceneDrop(model, obj)
        end
      end
    end)
    break
  end
end
function AssetManager_SceneItem:GetGoLuaPoolManager()
  if self.goLuaPoolManager == nil then
    self.goLuaPoolManager = Game.GOLuaPoolManager
  end
  return self.goLuaPoolManager
end
function AssetManager_SceneItem:CreateSceneDrop(id, key, parent, callBack, owner)
  local sceneDrop = GetFromSceneDropPool(self:GetGoLuaPoolManager(), key, parent)
  if sceneDrop == nil then
    local drop = CreateReusableTable()
    drop.isLoading = false
    drop.id = id
    drop.key = key
    drop.callBack = callBack
    drop.owner = owner
    self.sceneDropQueue[#self.sceneDropQueue + 1] = drop
  elseif callBack then
    callBack(sceneDrop)
  end
end
function AssetManager_SceneItem:CancelCreateSceneDrop(id)
  local drop
  for i = #self.sceneDropQueue, 1, -1 do
    drop = self.sceneDropQueue[i]
    if drop and drop.id == id then
      self:_RemoveSceneDropQueue(i, drop)
    end
  end
end
function AssetManager_SceneItem:_RemoveSceneDropQueue(index, drop)
  DestroyAndClearReusableTable(drop)
  table.remove(self.sceneDropQueue, index)
end
function AssetManager_SceneItem:DestroySceneDrop(key, gameobject)
  if nil == gameobject or IsNull(gameobject) then
    return
  end
  if AddToSceneDropPool(self:GetGoLuaPoolManager(), key, gameobject) then
    return
  end
  LuaGameObject.DestroyObject(gameobject)
end
function AssetManager_SceneItem:CreateSceneSeat(id, parent, callback, owner)
  local sceneSeat = GetFromSceneSeatPool(self:GetGoLuaPoolManager(), Game.Prefab_SceneSeat.name, parent)
  if sceneSeat == nil then
    local seat = CreateReusableTable()
    seat.id = id
    seat.callback = callback
    seat.owner = owner
    self.sceneSeatQueue[#self.sceneSeatQueue + 1] = seat
  end
  return sceneSeat
end
function AssetManager_SceneItem:CancelCreateSceneSeat(id)
  local seat
  for i = #self.sceneSeatQueue, 1, -1 do
    seat = self.sceneSeatQueue[i]
    if seat.id == id then
      self:_RemoveSceneSeatQueue(i, seat)
    end
  end
end
function AssetManager_SceneItem:DestroySceneSeat(gameobject)
  if nil == gameobject or IsNull(gameobject) then
    return
  end
  if AddToSceneSeatPool(self:GetGoLuaPoolManager(), Game.Prefab_SceneSeat.name, gameobject) then
    return
  end
  LuaGameObject.DestroyObject(gameobject)
end
function AssetManager_SceneItem:_RemoveSceneSeatQueue(index, seat)
  DestroyAndClearReusableTable(seat)
  table.remove(self.sceneSeatQueue, index)
end
function AssetManager_SceneItem:Update(time, deltaTime)
  if time < self.nextLoadTime then
    return
  end
  self.nextLoadTime = time + LoadInterval
  if #self.sceneSeatQueue > 0 then
    local seat = self.sceneSeatQueue[1]
    if seat ~= nil then
      local prefab = Game.Prefab_SceneSeat
      if prefab then
        prefab.type = SceneSeatType
        prefab.ID = seat.id
        local seatObj = LuaGameObjectClickable.Instantiate(prefab)
        if seat.callback ~= nil then
          seat.callback(seat.owner, seatObj)
        end
        self:_RemoveSceneSeatQueue(1, seat)
      end
    end
  end
  if 0 < #self.sceneDropQueue then
    do
      local drop = self.sceneDropQueue[1]
      if drop and not drop.isLoading then
        drop.isLoading = true
        self.assetManager:LoadAsync(ResourcePathHelper.Item(drop.key), function(asset)
          if asset ~= nil and drop and drop.callBack then
            drop.callBack(GameObject.Instantiate(asset))
          end
          self:_RemoveSceneDropQueue(1, drop)
        end)
      end
    end
  else
  end
end
