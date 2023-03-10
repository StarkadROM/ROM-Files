AssetManager_UI = class("AssetManager_UI")
local GetFromUIPool = GOLuaPoolManager.GetFromUIPool
local AddToUIPool = GOLuaPoolManager.AddToUIPool
local GetFromChatPool = GOLuaPoolManager.GetFromChatPool
local GetFromSceneUIPool = GOLuaPoolManager.GetFromSceneUIPool
local GetFromSceneUIMovePool = GOLuaPoolManager.GetFromSceneUIMovePool
local GetFromeAstrolabePool = GOLuaPoolManager.GetFromAstrolabePool
function AssetManager_UI:ctor(assetManager)
  self.assetManager = assetManager
end
function AssetManager_UI:LoadAsset(path, type, callback, owner, custom)
  self.assetManager:LoadAsset(path, type, callback, owner, custom)
end
function AssetManager_UI:UnLoadAsset(path)
  self.assetManager:UnloadAsset(path)
end
function AssetManager_UI:_LoadAndCreate(path, parent)
  local asset = self.assetManager.resManager:SLoad(path)
  if asset ~= nil then
    local go = GameObject.Instantiate(asset)
    LuaGameObject.TrimNameClone(go.gameObject)
    if not Slua.IsNull(parent) and not Slua.IsNull(go) then
      go.transform:SetParent(parent.transform, false)
    end
    local curBranchName = BranchInfo.GetBranchName()
    if curBranchName ~= "China" then
      do
        local configName = asset.name .. "_" .. curBranchName
        pcall(function()
          autoImport(configName)
        end)
        local configScript = _G[configName]
        if configScript then
          configScript.Execute(go)
        end
      end
    else
    end
    return go
  end
  return nil
end
function AssetManager_UI:CreateAsset(path, parent)
  local go = GetFromUIPool(Game.GOLuaPoolManager, path, parent)
  if go == nil then
    return self:_LoadAndCreate(path, parent)
  end
  return go
end
function AssetManager_UI:CreateChatAsset(path, parent)
  local go = GetFromChatPool(Game.GOLuaPoolManager, path, parent)
  if go == nil then
    return self:_LoadAndCreate(path, parent)
  end
  return go
end
function AssetManager_UI:CreateSceneUIAsset(path, parent)
  local go = GetFromSceneUIPool(Game.GOLuaPoolManager, path, parent)
  if go == nil then
    return self:_LoadAndCreate(path, parent)
  end
  go.gameObject:SetActive(true)
  return go
end
function AssetManager_UI:CreateAstrolabeAsset(path, parent)
  local go = GetFromeAstrolabePool(Game.GOLuaPoolManager, path, parent)
  if go == nil then
    return self:_LoadAndCreate(path, parent)
  end
  return go
end
function AssetManager_UI:CreateSceneUIAssetOpimized(path, parent)
  local go = GetFromSceneUIMovePool(Game.GOLuaPoolManager, path, parent)
  if go == nil then
    return self:CreateSceneUIAsset(path, parent)
  end
  return go
end
