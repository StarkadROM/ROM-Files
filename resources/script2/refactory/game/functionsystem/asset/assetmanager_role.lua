autoImport("Asset_Role")
autoImport("Asset_RolePart")
AssetManager_Role = class("AssetManager_Role")
local ROLE_LIMIT_STYPE = "ROLE"
ROLELOAD_AB_SPEED = 2
LoadAssetManager.Ins:SetMaxLoadingCount(ROLE_LIMIT_STYPE, 4)
local GetFromRoleCompletePool = GOLuaPoolManager.GetFromRoleCompletePool
local AddToRoleCompletePool = GOLuaPoolManager.AddToRoleCompletePool
local GetFromRolePartPool = {
  GOLuaPoolManager.GetFromRolePartBodyPool,
  GOLuaPoolManager.GetFromRolePartHairPool,
  GOLuaPoolManager.GetFromRolePartWeaponPool,
  GOLuaPoolManager.GetFromRolePartWeaponPool,
  GOLuaPoolManager.GetFromRolePartHeadPool,
  GOLuaPoolManager.GetFromRolePartWingPool,
  GOLuaPoolManager.GetFromRolePartFacePool,
  GOLuaPoolManager.GetFromRolePartTailPool,
  GOLuaPoolManager.GetFromRolePartEyePool,
  GOLuaPoolManager.GetFromRolePartMouthPool,
  GOLuaPoolManager.GetFromRolePartTailPool,
  GOLuaPoolManager.GetFromRolePartMountPool
}
local AddToRolePartPool = {
  GOLuaPoolManager.AddToRolePartBodyPool,
  GOLuaPoolManager.AddToRolePartHairPool,
  GOLuaPoolManager.AddToRolePartWeaponPool,
  GOLuaPoolManager.AddToRolePartWeaponPool,
  GOLuaPoolManager.AddToRolePartHeadPool,
  GOLuaPoolManager.AddToRolePartWingPool,
  GOLuaPoolManager.AddToRolePartFacePool,
  GOLuaPoolManager.AddToRolePartTailPool,
  GOLuaPoolManager.AddToRolePartEyePool,
  GOLuaPoolManager.AddToRolePartMouthPool,
  GOLuaPoolManager.AddToRolePartTailPool,
  GOLuaPoolManager.AddToRolePartMountPool
}
local RolePartPoolKeyFull = {
  GOLuaPoolManager.RolePartBodyKeyFull,
  GOLuaPoolManager.RolePartHairKeyFull,
  GOLuaPoolManager.RolePartWeaponKeyFull,
  GOLuaPoolManager.RolePartWeaponKeyFull,
  GOLuaPoolManager.RolePartHeadKeyFull,
  GOLuaPoolManager.RolePartWingKeyFull,
  GOLuaPoolManager.RolePartFaceKeyFull,
  GOLuaPoolManager.RolePartTailKeyFull,
  GOLuaPoolManager.RolePartEyeKeyFull,
  GOLuaPoolManager.RolePartMouthKeyFull,
  GOLuaPoolManager.RolePartTailKeyFull,
  GOLuaPoolManager.RolePartMountKeyFull
}
local RolePartPoolElementFull = {
  GOLuaPoolManager.RolePartBodyElementFull,
  GOLuaPoolManager.RolePartHairElementFull,
  GOLuaPoolManager.RolePartWeaponElementFull,
  GOLuaPoolManager.RolePartWeaponElementFull,
  GOLuaPoolManager.RolePartHeadElementFull,
  GOLuaPoolManager.RolePartWingElementFull,
  GOLuaPoolManager.RolePartFaceElementFull,
  GOLuaPoolManager.RolePartTailElementFull,
  GOLuaPoolManager.RolePartEyeElementFull,
  GOLuaPoolManager.RolePartMouthElementFull,
  GOLuaPoolManager.RolePartTailElementFull,
  GOLuaPoolManager.RolePartMountElementFull
}
local RolePartPoolElementCount = {
  GOLuaPoolManager.RolePartBodyElementCount,
  GOLuaPoolManager.RolePartHairElementCount,
  GOLuaPoolManager.RolePartWeaponElementCount,
  GOLuaPoolManager.RolePartWeaponElementCount,
  GOLuaPoolManager.RolePartHeadElementCount,
  GOLuaPoolManager.RolePartWingElementCount,
  GOLuaPoolManager.RolePartFaceElementCount,
  GOLuaPoolManager.RolePartTailElementCount,
  GOLuaPoolManager.RolePartEyeElementCount,
  GOLuaPoolManager.RolePartMouthElementCount,
  GOLuaPoolManager.RolePartTailElementCount,
  GOLuaPoolManager.RolePartMountElementCount
}
local LoadInterval = 0.1
local DestroyObserver = function(observer)
  observer[1] = nil
  observer[2] = nil
  observer[3] = nil
  observer[4] = nil
  ReusableTable.DestroyArray(observer)
end
local Tag_RemoveAllLoadInfo = -1000
local math_floor = math.floor
local table_remove = table.remove
local table_insert = table.insert
function AssetManager_Role.SetLoadInterval(value)
  LoadInterval = value
end
function AssetManager_Role.ResetLoadInterval()
  LoadInterval = 0.1
end
function AssetManager_Role.RemoveObserverPredicate(observer, tag)
  if observer[1] == tag then
    DestroyObserver(observer)
    return true
  end
  return false
end
function AssetManager_Role:ctor(assetManager)
  self.ResPathHelperFuncs = {
    [Asset_Role.PartIndex.Body] = ResourcePathHelper.RoleBody,
    [Asset_Role.PartIndex.Hair] = ResourcePathHelper.RoleHair,
    [Asset_Role.PartIndex.LeftWeapon] = ResourcePathHelper.RoleWeapon,
    [Asset_Role.PartIndex.RightWeapon] = ResourcePathHelper.RoleWeapon,
    [Asset_Role.PartIndex.Head] = ResourcePathHelper.RoleHead,
    [Asset_Role.PartIndex.Wing] = ResourcePathHelper.RoleWing,
    [Asset_Role.PartIndex.Face] = ResourcePathHelper.RoleFace,
    [Asset_Role.PartIndex.Tail] = ResourcePathHelper.RoleTail,
    [Asset_Role.PartIndex.Eye] = ResourcePathHelper.RoleEye,
    [Asset_Role.PartIndex.Mouth] = ResourcePathHelper.RoleMouth,
    [Asset_Role.PartIndex.DefaultTail] = ResourcePathHelper.RoleTail,
    [Asset_Role.PartIndex.Mount] = ResourcePathHelper.RoleMount
  }
  self.loadingDatas = {
    [Asset_Role.PartIndex.Body] = {},
    [Asset_Role.PartIndex.Hair] = {},
    [Asset_Role.PartIndex.LeftWeapon] = {},
    [Asset_Role.PartIndex.RightWeapon] = {},
    [Asset_Role.PartIndex.Head] = {},
    [Asset_Role.PartIndex.Wing] = {},
    [Asset_Role.PartIndex.Face] = {},
    [Asset_Role.PartIndex.Tail] = {},
    [Asset_Role.PartIndex.Eye] = {},
    [Asset_Role.PartIndex.Mouth] = {},
    [Asset_Role.PartIndex.DefaultTail] = {},
    [Asset_Role.PartIndex.Mount] = {}
  }
  self.loadingDataQueue = {}
  self.nextLoadTag = 1
  self.tabMaterialMap = {}
  self.assetManager = assetManager
  self.nextLoadTime = 0
  self.forceLoadAll = 0
end
function AssetManager_Role:SetForceLoadAll(force)
  if force then
    self.forceLoadAll = self.forceLoadAll + 1
  else
    self.forceLoadAll = self.forceLoadAll - 1
  end
end
function AssetManager_Role:NewTag()
  local tag = self.nextLoadTag
  self.nextLoadTag = (self.nextLoadTag + 1) % 1000000000
  return tag
end
function AssetManager_Role:CreateComplete()
  local obj = GetFromRoleCompletePool(Game.GOLuaPoolManager)
  if nil ~= obj then
    obj:InitRole()
    obj:AlphaTo(1, 0)
    obj:ChangeColorTo(LuaGeometry.Const_Col_whiteClear, 0)
  else
    obj = RoleComplete.Instantiate(Game.Prefab_RoleComplete)
    obj:InitRole()
  end
  GameObject.DontDestroyOnLoad(obj.gameObject)
  return obj
end
function AssetManager_Role:DestroyComplete(obj)
  if nil == obj or LuaGameObject.ObjectIsNull(obj) then
    return
  end
  if AddToRoleCompletePool(Game.GOLuaPoolManager, obj) then
    obj:RemoveRole()
    return
  end
  LuaGameObject.DestroyObject(obj.gameObject)
end
function AssetManager_Role:PreloadComplete(instantiateCount)
  if nil == instantiateCount or instantiateCount <= 0 then
    return
  end
  local prefab = Game.Prefab_RoleComplete
  local obj
  for i = 1, instantiateCount do
    obj = RoleComplete.Instantiate(prefab)
    if not AddToRoleCompletePool(Game.GOLuaPoolManager, obj) then
      GameObject.Destroy(obj.gameObject)
      break
    end
  end
end
function AssetManager_Role:_AddObserver_Part(part, ID, tag, callback, owner, custom, isLoadedFirst, showLayer)
  local partLoadingInfo = self.loadingDatas[part][ID]
  if partLoadingInfo == nil then
    partLoadingInfo = {
      part = part,
      ID = ID,
      observers = {},
      loaded = false,
      waittime = 0
    }
    self.loadingDatas[part][ID] = partLoadingInfo
    if isLoadedFirst then
      table_insert(self.loadingDataQueue, 1, partLoadingInfo)
    else
      table_insert(self.loadingDataQueue, partLoadingInfo)
    end
  elseif partLoadingInfo.observers == nil then
    partLoadingInfo.observers = {}
  end
  local observer = ReusableTable.CreateArray()
  observer[1] = tag
  observer[2] = callback
  observer[3] = owner
  observer[4] = custom
  observer[5] = showLayer
  TableUtility.ArrayPushBack(partLoadingInfo.observers, observer)
end
function AssetManager_Role:_RemoveObserver(part, ID, tag)
  local partLoadingInfo = self.loadingDatas[part][ID]
  if partLoadingInfo == nil then
    return true
  end
  local observers = partLoadingInfo.observers
  if observers == nil then
    return true
  end
  if Tag_RemoveAllLoadInfo == tag then
    for i = #observers, 1, -1 do
      DestroyObserver(observers[i])
    end
    partLoadingInfo.observers = nil
    partLoadingInfo.loaded = false
    partLoadingInfo.waittime = 0
  else
    for i = #observers, 1, -1 do
      if observers[i][1] == tag then
        DestroyObserver(observers[i])
        table_remove(observers, i)
        break
      end
    end
    if #observers == 0 then
      partLoadingInfo.observers = nil
      partLoadingInfo.loaded = false
      partLoadingInfo.waittime = 0
    end
  end
  return partLoadingInfo.observers == nil
end
local _NotifyObservers_Part = function(self, part, ID, asset)
  local partLoadingInfo = self.loadingDatas[part][ID]
  if partLoadingInfo == nil then
    return
  end
  local observers = partLoadingInfo.observers
  if observers == nil then
    return
  end
  for i = 1, #observers do
    local observer = observers[i]
    local obj
    if nil ~= asset then
      obj = RolePart.Instantiate(asset)
    end
    observer[2](observer[3], observer[1], obj, part, ID, observer[4])
  end
end
function AssetManager_Role:OnAssetLoaded_Part(asset, resPath, partInfo)
  local part = partInfo[1]
  local ID = partInfo[2]
  local suc, errorMsg = pcall(_NotifyObservers_Part, self, part, ID, asset)
  if not suc then
    Debug.LogError(errorMsg)
  end
  self:_RemoveObserver(part, ID, Tag_RemoveAllLoadInfo)
  ReusableTable.DestroyArray(partInfo)
end
function AssetManager_Role:GetPartCacheCount(part, ID)
  return RolePartPoolElementCount[part](Game.GOLuaPoolManager, ID)
end
function AssetManager_Role:CreatePart(part, ID, callback, owner, custom, isLoadedFirst, showLayer)
  local obj = GetFromRolePartPool[part](Game.GOLuaPoolManager, ID)
  if nil ~= obj then
    obj.layer = 0
    obj:SetAlpha(1)
    callback(owner, nil, obj, part, ID, custom)
    return nil
  end
  local tag = self:NewTag()
  self:_AddObserver_Part(part, ID, tag, callback, owner, custom, isLoadedFirst, showLayer)
  return tag
end
function AssetManager_Role:CancelCreatePart(part, ID, tag)
  if self:_RemoveObserver(part, ID, tag) then
    self.assetManager:CancelLoadAsset(ROLE_LIMIT_STYPE, self.ResPathHelperFuncs[part](ID))
  end
end
function AssetManager_Role:DestroyPart(part, ID, obj, isForceDestroy)
  if nil == obj or LuaGameObject.ObjectIsNull(obj) then
    return
  end
  if isForceDestroy then
    LuaGameObject.DestroyObject(obj.gameObject)
    return
  end
  if AddToRolePartPool[part](Game.GOLuaPoolManager, ID, obj) then
    obj.partAction = false
    return
  end
  LuaGameObject.DestroyObject(obj.gameObject)
end
function AssetManager_Role:PreloadPart(part, ID, instantiateCount)
  local poolManager = Game.GOLuaPoolManager
  if nil == instantiateCount then
    return
  end
  local elementCount = RolePartPoolElementCount[part](poolManager, ID)
  instantiateCount = instantiateCount - elementCount
  if instantiateCount <= 0 then
    return
  end
  local path = self.ResPathHelperFuncs[part](ID)
  self.assetManager:PreloadAssetAsync(path, RolePart, function(asset)
    if nil == asset then
      return
    end
    local PoolElementFull = RolePartPoolElementFull[part]
    local AddToPool = AddToRolePartPool[part]
    local obj
    for i = 1, instantiateCount do
      if PoolElementFull(poolManager, ID) then
        return
      end
      obj = RolePart.Instantiate(asset)
      if not AddToPool(poolManager, ID, obj) then
        GameObject.Destroy(obj.gameObject)
        return
      end
    end
  end)
end
function AssetManager_Role:ClearPreloadPart(part, ID)
end
function AssetManager_Role:GetFaceMatetial(bodyRaceType, isFemale, index)
  local key = string.format("%s_%s_%s", tostring(bodyRaceType), tostring(isFemale and 2 or 1), tostring(index))
  if self.tabMaterialMap[key] then
    return self.tabMaterialMap[key]
  end
  local path = ResourcePathHelper.FaceMaterial(bodyRaceType, isFemale, index)
  local material = path and self.assetManager:Load(path)
  self.tabMaterialMap[key] = material
  if not material then
    LogUtility.Error(string.format("加载材质失败! 路径: %s", tostring(path)))
  end
  return material
end
function AssetManager_Role:GetFaceMatetialNew(prefix, index)
  local key = string.format("%sf%s_m", tostring(prefix), tostring(index))
  if self.tabMaterialMap[key] then
    return self.tabMaterialMap[key]
  end
  local path = ResourcePathHelper.FaceMaterialNew(key)
  local material = path and self.assetManager:Load(path)
  self.tabMaterialMap[key] = material
  if not material then
    LogUtility.Error(string.format("加载材质失败! 路径: %s", tostring(path)))
  end
  return material
end
function AssetManager_Role:Update(time, deltaTime)
  if self.forceLoadAll > 0 then
  elseif time < self.nextLoadTime then
    return
  end
  self.nextLoadTime = time + LoadInterval
  for i = #self.loadingDataQueue, 1, -1 do
    local partLoadingInfo = self.loadingDataQueue[i]
    if partLoadingInfo then
      if partLoadingInfo.loaded then
        partLoadingInfo.waittime = partLoadingInfo.waittime + deltaTime
      end
      if partLoadingInfo.observers == nil then
        table_remove(self.loadingDataQueue, i)
        self.loadingDatas[partLoadingInfo.part][partLoadingInfo.ID] = nil
      elseif partLoadingInfo.waittime > 20 then
        self:OnAssetLoaded_Part(nil, nil, {
          partLoadingInfo.part,
          partLoadingInfo.ID
        })
        table_remove(self.loadingDataQueue, i)
        self.loadingDatas[partLoadingInfo.part][partLoadingInfo.ID] = nil
        Debug.LogError(string.format("Load RolePart TimeOut. Part:%s ID:%s", tostring(partLoadingInfo.part), tostring(partLoadingInfo.ID)))
      end
    else
      table_remove(self.loadingDataQueue, i)
      self.loadingDatas[partLoadingInfo.part][partLoadingInfo.ID] = nil
    end
  end
  local loadCount = math.min(ROLELOAD_AB_SPEED, #self.loadingDataQueue)
  for i = 1, loadCount do
    local partLoadingInfo = self.loadingDataQueue[i]
    if not partLoadingInfo.loaded then
      partLoadingInfo.loaded = true
      self:_DoLoadPart(partLoadingInfo.part, partLoadingInfo.ID)
    end
  end
end
function AssetManager_Role:_DoLoadPart(part, ID)
  local path = self.ResPathHelperFuncs[part](ID)
  local partInfo = ReusableTable.CreateArray()
  partInfo[1] = part
  partInfo[2] = ID
  local suc, errorMsg = pcall(function()
    self.assetManager:LimitLoadAsset(ROLE_LIMIT_STYPE, path, RolePart, self.OnAssetLoaded_Part, self, partInfo, nil, Asset_Role.LoadPriority[part])
  end)
  if not suc then
    Debug.LogError("Load Role Error:" .. errorMsg)
    self:OnAssetLoaded_Part(nil, path, partInfo)
  end
end
