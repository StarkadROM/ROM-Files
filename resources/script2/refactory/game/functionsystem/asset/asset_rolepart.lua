Asset_RolePart = class("Asset_RolePart", ReusableObject)
if not Asset_RolePart.Asset_RolePart_Inited then
  Asset_RolePart.Asset_RolePart_Inited = true
  Asset_RolePart.PoolSize = 10
  Asset_RolePart.SkinQuality = {
    Auto = 0,
    Bone1 = 1,
    Bone2 = 2,
    Bone4 = 4
  }
end
local tempArgs = {
  0,
  0,
  nil,
  LuaVector3.Zero(),
  LuaVector3.Zero(),
  LuaVector3.One(),
  nil,
  nil,
  Asset_RolePart.SkinQuality.Auto
}
function Asset_RolePart.Create(partIndex, ID, callback, callbackArg, skinQuality)
  tempArgs[1] = partIndex
  tempArgs[2] = ID
  tempArgs[3] = nil
  LuaVector3.Better_Set(tempArgs[4], 0, 0, 0)
  LuaVector3.Better_Set(tempArgs[5], 0, 0, 0)
  LuaVector3.Better_Set(tempArgs[6], 1, 1, 1)
  tempArgs[7] = callback
  tempArgs[8] = callbackArg
  tempArgs[9] = skinQuality or Asset_RolePart.SkinQuality.Auto
  return ReusableObject.Create(Asset_RolePart, true, tempArgs)
end
function Asset_RolePart:ctor()
  self.args = {}
  Asset_RolePart.super.ctor(self)
end
function Asset_RolePart:SetLayer(layer)
  self.args[11] = layer
  if nil ~= self.args[9] then
    self.args[9].layer = layer
  end
end
function Asset_RolePart:ResetParent(parent)
  self.args[3] = parent
  if nil ~= self.args[9] then
    self.args[9].transform:SetParent(parent, false)
    self.args[9]:RefreshLightMapColor()
  end
end
function Asset_RolePart:GetTransform()
  if nil ~= self.args[9] then
    return self.args[9].transform
  end
end
function Asset_RolePart:ResetLocalPositionXYZ(x, y, z)
  self.args[4]:Set(x, y, z)
  if nil ~= self.args[9] then
    self.args[9].transform.localPosition = self.args[4]
  end
end
function Asset_RolePart:ResetLocalPosition(p)
  self:ResetLocalPositionXYZ(p[1], p[2], p[3])
end
function Asset_RolePart:ResetLocalEulerAnglesXYZ(x, y, z)
  self.args[5]:Set(x, y, z)
  if nil ~= self.args[9] then
    self.args[9].transform.localEulerAngles = self.args[5]
  end
end
function Asset_RolePart:RotateDelta(y)
  local vector = self.args[5]
  LuaVector3.Better_Set(self.args[5], vector.x, vector.y + y, vector.z)
  if nil ~= self.args[9] then
    self.args[9].transform.localEulerAngles = self.args[5]
  end
end
function Asset_RolePart:ResetLocalEulerAngles(p)
  self:ResetLocalEulerAnglesXYZ(p[1], p[2], p[3])
end
function Asset_RolePart:ResetLocalScaleXYZ(x, y, z)
  LuaVector3.Better_Set(self.args[6], x, y, z)
  if nil ~= self.args[9] then
    self.args[9].transform.localScale = self.args[6]
  end
end
function Asset_RolePart:ResetLocalScale(p)
  self:ResetLocalScaleXYZ(p[1], p[2], p[3])
end
function Asset_RolePart:_ResetRolePart()
  local rolePart = self.args[9]
  local objTransform = rolePart.transform
  objTransform.parent = self.args[3]
  objTransform.localPosition = self.args[4]
  objTransform.localEulerAngles = self.args[5]
  objTransform.localScale = self.args[6]
  rolePart:RefreshLightMapColor()
  rolePart.layer = self.args[11]
  if self.skinQuality ~= Asset_RolePart.SkinQuality.Auto then
    rolePart:SetPartsQuality(self.skinQuality, false)
  end
end
function Asset_RolePart:_Destroy()
  if nil ~= self.args[9] then
    self:ReSetEPNode()
    self:ResetSkinQuality()
    self.assetManager:DestroyPart(self.args[1], self.args[2], self.args[9])
    self.args[9] = nil
  end
end
function Asset_RolePart:_CancelLoading()
  if nil ~= self.args[10] then
    self.assetManager:CancelCreatePart(self.args[1], self.args[2], self.args[10])
    self.args[10] = nil
  end
end
function Asset_RolePart:OnPartCreated(tag, obj, part, ID)
  if self.args[10] ~= tag then
    self.assetManager:DestroyPart(part, ID, obj)
    return
  end
  self.args[10] = nil
  if nil == obj then
    LogUtility.WarningFormat("Load Role Part Failed: part={0}, ID={1}", part, ID)
    return
  end
  obj.gameObject:SetActive(true)
  self.args[9] = obj
  self:_ResetRolePart()
  if nil ~= self.args[7] then
    self.args[7](obj, self.args[8], self)
    self:RemoveCreatedCallBack()
  end
  if self.epNodesDisplay then
    self:UpdateEpNodesDisplay(obj)
  end
end
function Asset_RolePart:_IsLoading()
  return self.args and self.args[10] ~= nil
end
function Asset_RolePart:SetCreatedCallBack(callback, callbackArg)
  self.args[7] = callback
  self.args[8] = callbackArg
end
function Asset_RolePart:RemoveCreatedCallBack()
  self.args[7] = nil
  self.args[8] = nil
end
function Asset_RolePart:SetEpNodesDisplay(display)
  if self.epNodesDisplay == display then
    return
  end
  self.epNodesDisplay = display
  self:UpdateEpNodesDisplay()
end
local IsNull = Slua.IsNull
function Asset_RolePart:UpdateEpNodesDisplay(PartObj)
  PartObj = PartObj or self.args[9]
  if not PartObj then
    return
  end
  if not IsNull(self.EpNodesObj) then
    local _LODLevel = PerformanceManager.LODLevel
    self.EpNodesObj.level = self.epNodesDisplay and _LODLevel.High or _LODLevel.Mid
  else
    self.EpNodesObj = RoleUtil.UpdateEPNodesDisplay(PartObj, self.epNodesDisplay)
  end
end
function Asset_RolePart:ReSetEPNode()
  if not IsNull(self.EpNodesObj) then
    self.EpNodesObj.level = PerformanceManager.LODLevel.Mid
  end
  self.EpNodesObj = nil
end
function Asset_RolePart:ResetSkinQuality()
  if self.skinQuality ~= Asset_RolePart.SkinQuality.Auto then
    self.skinQuality = Asset_RolePart.SkinQuality.Auto
    self.args[9]:SetPartsQuality(self.skinQuality, false)
  end
end
function Asset_RolePart:DoConstruct(asArray, args)
  self.assetManager = Game.AssetManager_Role
  self.args[1] = args[1]
  self.args[2] = args[2]
  self.args[3] = args[3]
  self.args[4] = LuaVector3.Better_Clone(args[4])
  self.args[5] = LuaVector3.Better_Clone(args[5])
  self.args[6] = LuaVector3.Better_Clone(args[6])
  self.args[7] = args[7]
  self.args[8] = args[8]
  self.args[9] = nil
  self.args[10] = nil
  self.args[11] = 0
  self.skinQuality = args[9] or Asset_RolePart.SkinQuality.Auto
  self.epNodesDisplay = false
  self.EpNodesObj = nil
  local loadTag = self.assetManager:CreatePart(args[1], args[2], self.OnPartCreated, self)
  self.args[10] = loadTag
end
function Asset_RolePart:DoDeconstruct(asArray)
  self:_CancelLoading()
  self:_Destroy()
  self.args[3] = nil
  LuaVector3.Destroy(self.args[4])
  LuaVector3.Destroy(self.args[5])
  LuaVector3.Destroy(self.args[6])
  self:RemoveCreatedCallBack()
  self.epNodesDisplay = false
  self.EpNodesObj = nil
end
