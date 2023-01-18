autoImport("EquipMakeData")
EquipMakeProxy = class("EquipMakeProxy", pm.Proxy)
EquipMakeProxy.Instance = nil
EquipMakeProxy.NAME = "EquipMakeProxy"
local packageCheck = GameConfig.PackageMaterialCheck and GameConfig.PackageMaterialCheck.produce
function EquipMakeProxy:ctor(proxyName, data)
  self.proxyName = proxyName or EquipMakeProxy.NAME
  if EquipMakeProxy.Instance == nil then
    EquipMakeProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end
function EquipMakeProxy:Init()
  self.makeList = {}
  self.makeTable = {}
  self.selfProfessionMakeList = {}
  self.lastNpcId = 0
end
function EquipMakeProxy:InitMakeList()
  TableUtility.ArrayClear(self.makeList)
  for k, v in pairs(Table_Compose) do
    local valid = true
    if v.Product then
      valid = EquipComposeProxy.CheckValid(v.Product.id)
    end
    if valid and v.Category == 1 and v.NpcId == self.npcId then
      self.makeList[#self.makeList + 1] = k
      if self.makeTable[k] == nil then
        self.makeTable[k] = EquipMakeData.new(k)
      end
    end
  end
  table.sort(self.makeList, function(l, r)
    local lData = self.makeTable[l]
    local rData = self.makeTable[r]
    if lData.sortId == rData.sortId then
      return lData.composeId < rData.composeId
    else
      return lData.sortId < rData.sortId
    end
  end)
  self.lastNpcId = self.npcId
end
function EquipMakeProxy:SetNpcId(npcId)
  self.npcId = npcId
end
function EquipMakeProxy:GetMakeList()
  self:InitMakeListByNpc()
  return self.makeList
end
function EquipMakeProxy:InitMakeListByNpc()
  if self.lastNpcId ~= self.npcId then
    self:InitMakeList()
  end
end
function EquipMakeProxy:GetMakeItemDatas()
  self:InitMakeListByNpc()
  local result = {}
  for i = 1, #self.makeList do
    local composeId = self.makeList[i]
    result[#result + 1] = self.makeTable[composeId].itemData
  end
  return result
end
function EquipMakeProxy:GetSelfProfessionMakeList()
  TableUtility.ArrayClear(self.selfProfessionMakeList)
  for i = 1, #self.makeList do
    local composeId = self.makeList[i]
    local makeData = self.makeTable[composeId]
    if makeData and makeData.itemData:CanEquip() then
      self.selfProfessionMakeList[#self.selfProfessionMakeList + 1] = composeId
    end
  end
  return self.selfProfessionMakeList
end
function EquipMakeProxy:GetMakeData(composeId)
  return self.makeTable[composeId]
end
function EquipMakeProxy:GetItemNumByStaticID(itemid)
  local _BagProxy = BagProxy.Instance
  local count = 0
  for i = 1, #packageCheck do
    count = count + _BagProxy:GetItemNumByStaticID(itemid, packageCheck[i])
  end
  return count
end
function EquipMakeProxy:HandleProduceDone(dtype, itemid, delay, count, num)
  if dtype ~= SceneItem_pb.EPRODUCETYPE_COMMON then
    return
  end
  if type(delay) == "number" and delay > 0 then
    TimeTickManager.Me():CreateOnceDelayTick(delay * 1000, function(owner, deltaTime)
      self:_FloatMsg(itemid, count, num)
    end, self)
  else
    self:_FloatMsg(itemid, count, num)
  end
end
function EquipMakeProxy:_FloatMsg(itemid, count, num)
  local itemData = ItemData.new("Temp", itemid)
  itemData = BagProxy.Instance:GetNewestItemByStaticID(itemid)
  if BagProxy.CheckIs3DTypeItem(itemData.staticData.Type) then
    FloatAwardView.addItemDatasToShow({itemData})
  else
    local params = {}
    params[1] = itemid
    params[2] = itemid
    params[3] = num * count
    MsgManager.ShowMsgByIDTable(6, params)
  end
end
