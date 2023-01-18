autoImport("Table_EquipComposeProduct")
autoImport("EquipComposeItemData")
EquipComposeProxy = class("EquipComposeProxy", pm.Proxy)
EquipComposeProxy.Instance = nil
EquipComposeProxy.NAME = "EquipComposeProxy"
local _PushArray = TableUtility.ArrayPushBack
local COMPOSE_TYPE = GameConfig.EquipComposeType
function EquipComposeProxy:ctor(proxyName, data)
  self.proxyName = proxyName or EquipComposeProxy.NAME
  if EquipComposeProxy.Instance == nil then
    EquipComposeProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end
function EquipComposeProxy:Init()
  self.composeData = {}
  self.classifiedMap = {}
  self.categoryMap = {}
  self.inited = false
end
function EquipComposeProxy.CheckValid(id)
  local tryParse_FuncStateId = Game.Config_EquipComposeIDForbidMap[id]
  if tryParse_FuncStateId then
    return FunctionUnLockFunc.checkFuncStateValid(tryParse_FuncStateId)
  end
  return true
end
function EquipComposeProxy:InitData()
  if self.inited then
    return
  end
  self.inited = true
  local tempdata = {}
  for k, v in pairs(Table_EquipCompose) do
    local valid = EquipComposeProxy.CheckValid(v.id)
    if valid then
      local itemData = EquipComposeItemData.new(v)
      _PushArray(tempdata, itemData)
    end
  end
  table.sort(tempdata, function(l, r)
    return l.composeID < r.composeID
  end)
  local id = {}
  for i = 1, #tempdata do
    if 0 == TableUtility.ArrayFindIndex(id, tempdata[i].composeID) then
      _PushArray(self.composeData, tempdata[i])
      for j = 1, #tempdata do
        if tempdata[i].VIDType == tempdata[j].VIDType and tempdata[i].VID == tempdata[j].VID and tempdata[i].composeID ~= tempdata[j].composeID then
          _PushArray(self.composeData, tempdata[j])
          id[#id + 1] = tempdata[j].composeID
          break
        end
      end
    end
  end
  for k, v in pairs(COMPOSE_TYPE) do
    for i = 1, #self.composeData do
      if 0 ~= TableUtility.ArrayFindIndex(v.types, self.composeData[i]:GetItemType()) then
        if nil == self.classifiedMap[k] then
          self.classifiedMap[k] = {}
          self.categoryMap[k] = true
        end
        _PushArray(self.classifiedMap[k], self.composeData[i])
      end
    end
  end
end
function EquipComposeProxy:SetCategoryActive(c)
  local active = not self.categoryMap[c]
  self.categoryMap[c] = active
  return active
end
function EquipComposeProxy:ResetCategoryActive()
  for i = 1, #self.categoryMap do
    self.categoryMap[i] = true
  end
end
local ReUniteCellData = function(datas, perRowNum)
  local newData = {}
  if datas ~= nil and #datas > 0 then
    for i = 1, #datas do
      local i1 = math.floor((i - 1) / perRowNum) + 1
      local i2 = math.floor((i - 1) % perRowNum) + 1
      newData[i1] = newData[i1] or {}
      if datas[i] == nil then
        newData[i1][i2] = nil
      else
        newData[i1][i2] = datas[i]
      end
    end
  end
  return newData
end
function EquipComposeProxy:GetTypeFilterData(professionCheck)
  local data = {}
  local tabKey = {}
  for k, composeArray in pairs(self.classifiedMap) do
    if nil == tabKey[k] then
      local cell = EquipComposeData.new(k)
      _PushArray(data, cell)
      tabKey[k] = 1
    end
    local composeData = {}
    if not professionCheck then
      composeData = composeArray
    else
      for i = 1, #composeArray do
        if composeArray[i]:CheckProfessionValid() then
          composeData[#composeData + 1] = composeArray[i]
        end
      end
    end
    local composeData = ReUniteCellData(composeData, 5)
    for _, v in pairs(composeData) do
      if self.categoryMap[k] then
        local cell = EquipComposeData.new(k, v)
        _PushArray(data, cell)
      end
    end
  end
  return data
end
function EquipComposeProxy:SetCurrentData(data)
  if self.curData ~= data then
    self.curData = data
    if self.curData then
      self.curData:ResetChooseMat()
    end
  end
end
function EquipComposeProxy:SetChooseMat(index, id)
  if not self.curData then
    return
  end
  self.curData:SetChooseMat(index, id)
end
function EquipComposeProxy:GetCurData()
  return self.curData
end
