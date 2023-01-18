AttrExtractionProxy = class("AttrExtractionProxy", pm.Proxy)
AttrExtractionProxy.Instance = nil
AttrExtractionProxy.NAME = "AttrExtractionProxy"
autoImport("ExtractionData")
local FilterConfig = GameConfig.EquipExtractionFilter
function AttrExtractionProxy:ctor(proxyName, data)
  self.proxyName = proxyName or AttrExtractionProxy.NAME
  if AttrExtractionProxy.Instance == nil then
    AttrExtractionProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end
local EquipExtractionConfig = GameConfig.EquipExtraction
function AttrExtractionProxy:Init()
  self.discountMap = {}
  if GameConfig.EquipExtraction then
    self.MaxCount = EquipExtractionConfig.GridCountDefault + EquipExtractionConfig.GridBuyLimit
    if self.extractionDataMap then
      TableUtility.TableClear(self.extractionDataMap)
    else
      self.extractionDataMap = {}
    end
    for i = 1, self.MaxCount do
      local single = ExtractionData.new(i)
      self.extractionDataMap[single.gridid] = single
    end
  end
end
function AttrExtractionProxy:RecvExtractionQueryUserCmd(data)
  if not self.extractionDataMap then
    return
  end
  local datas = data.datas
  local index = 1
  for i = 1, #datas do
    index = datas[i].gridid
    if self.extractionDataMap[index] then
      self.extractionDataMap[index]:Update(datas[i])
    end
  end
  self.gridCount = data.gridcount
  for i = self.gridCount + 1, self.MaxCount do
    self.extractionDataMap[i]:Lock(true)
  end
  local activeids = data.activeids
  if self.activeids then
    TableUtility.ArrayClear(self.activeids)
  else
    self.activeids = {}
  end
  for k, v in pairs(self.extractionDataMap) do
    self.extractionDataMap[k]:SetActive(false)
  end
  for i = 1, #activeids do
    index = activeids[i]
    table.insert(self.activeids, index)
    if self.extractionDataMap[index] then
      self.extractionDataMap[index]:SetActive(true)
    end
  end
end
function AttrExtractionProxy:RecvExtractionOperateUserCmd(data)
  if data and data.data then
    local index = data.data.gridid
    if not self.extractionDataMap[index] then
      local single = ExtractionData.new(index)
      self.extractionDataMap[index] = single
    end
    self.extractionDataMap[index]:Update(data.data)
  else
    redlog("not data.data")
  end
end
function AttrExtractionProxy:GetExtractionDataByGrid(gridid)
  if self.extractionDataMap and gridid then
    return self.extractionDataMap[gridid]
  else
    return nil
  end
end
function AttrExtractionProxy:GetExtractDataList()
  if self.gridList then
    TableUtility.ArrayClear(self.gridList)
  else
    self.gridList = {}
  end
  for k, v in pairs(self.extractionDataMap) do
    table.insert(self.gridList, self.extractionDataMap[k])
  end
  table.sort(self.gridList, function(a, b)
    return a.gridid < b.gridid
  end)
  return self.gridList
end
function AttrExtractionProxy:RecvExtractionRemoveUserCmd(data)
  if data and data.success and self.extractionDataMap and data.gridid then
    self.extractionDataMap[data.gridid]:Empty()
  end
end
function AttrExtractionProxy:RecvExtractionActiveUserCmd(data)
  local newactiveids = {}
  local index = 1
  for i = 1, #data.activeids do
    index = data.activeids[i]
    newactiveids[index] = true
    if self.extractionDataMap and self.extractionDataMap[index] then
      self.extractionDataMap[index]:SetActive(true)
    end
  end
  for i = 1, #self.activeids do
    index = self.activeids[i]
    if not newactiveids[index] then
      self.extractionDataMap[index]:SetActive(false)
    end
  end
  if self.activeids then
    TableUtility.ArrayClear(self.activeids)
  else
    self.activeids = {}
  end
  for i = 1, #data.activeids do
    index = data.activeids[i]
    table.insert(self.activeids, index)
  end
end
function AttrExtractionProxy:RecvExtractionGridBuyUserCmd(data)
  if not self.extractionDataMap or not data then
    return
  end
  local newcount = data.gridcount
  for i = self.gridCount, newcount do
    if self.extractionDataMap[i] then
      self.extractionDataMap[i]:Lock(false)
    end
  end
end
function AttrExtractionProxy:RecvExtractionRefreshUserCmd(data)
  if not self.extractionDataMap or not data then
    return
  end
  if self.extractionDataMap[data.gridid] then
    self.extractionDataMap[data.gridid]:Update(data.data)
  end
end
function AttrExtractionProxy:InitIllustrationEquip()
  if self.initedEquip then
    return
  end
  self.initedEquip = true
  if not self.equipIData then
    self.equipIData = {}
  else
    TableUtility.TableClear(self.equipIData)
  end
  local attrType, equipVID, VIDType, VID, index
  for k, v in pairs(FilterConfig) do
    if not self.equipIData[k] then
      self.equipIData[k] = {}
    end
    if not self.recordMap then
      self.recordMap = {}
    else
      TableUtility.TableClear(self.recordMap)
    end
    for equipID, staticData in pairs(Table_EquipExtraction) do
      attrType = staticData.AttrType
      equipVID = Table_Equip[equipID] and Table_Equip[equipID].VID
      VIDType = math.floor(equipVID / 10000)
      VID = equipVID % 1000
      index = VIDType * 1000 + VID
      if not self.recordMap[index] and table.ContainsValue(v.AttrType, attrType) then
        table.insert(self.equipIData[k], equipID)
        self.recordMap[index] = true
      end
    end
  end
end
function AttrExtractionProxy:GetEquipDataByFilter(filterdata)
  self:InitIllustrationEquip()
  if not self.equipIData or not filterdata or not self.equipIData[filterdata] then
    redlog("no data", filterdata)
    return
  end
  return self.equipIData[filterdata]
end
function AttrExtractionProxy:SetDiscount(params)
  if #params & 1 ~= 0 then
    redlog("GlobalActivity 萃取打折折扣配置错误")
    return
  end
  for i = 1, #params, 2 do
    self.discountMap[params[i]] = params[i + 1] / 10000
  end
end
function AttrExtractionProxy:ResetDiscount()
  TableUtility.TableClear(self.discountMap)
end
function AttrExtractionProxy:GetDiscount(id)
  return self.discountMap[id] or 1
end
