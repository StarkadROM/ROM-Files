autoImport("ChangeHeadData")
ChangeHeadProxy = class("ChangeHeadProxy", pm.Proxy)
ChangeHeadProxy.Instance = nil
ChangeHeadProxy.NAME = "ChangeHeadProxy"
function ChangeHeadProxy:ctor(proxyName, data)
  self.proxyName = proxyName or ChangeHeadProxy.NAME
  if ChangeHeadProxy.Instance == nil then
    ChangeHeadProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end
function ChangeHeadProxy:Init()
  self.portraitList = {}
  self.frameList = {}
  self.backgroundList = {}
  self.chatframeList = {}
end
function ChangeHeadProxy:RecvQueryPortraitList(data)
  if data.portrait then
    TableUtility.ArrayClear(self.portraitList)
    local empty = ChangeHeadData.new(0)
    empty:SetType(ChangeHeadData.HeadCellType.Avatar)
    TableUtility.ArrayPushBack(self.portraitList, empty)
    for i = 1, #data.portrait do
      local changeHeadData = ChangeHeadData.new(data.portrait[i])
      changeHeadData:SetType(ChangeHeadData.HeadCellType.Avatar)
      TableUtility.ArrayPushBack(self.portraitList, changeHeadData)
    end
  end
end
function ChangeHeadProxy:RecvNewPortraitFrame(data)
  if data.portrait then
    if #self.portraitList == 0 then
      local empty = ChangeHeadData.new(0)
      empty:SetType(ChangeHeadData.HeadCellType.Avatar)
      TableUtility.ArrayPushBack(self.portraitList, empty)
    end
    for i = 1, #data.portrait do
      local changeHeadData = ChangeHeadData.new(data.portrait[i])
      changeHeadData:SetType(ChangeHeadData.HeadCellType.Avatar)
      TableUtility.ArrayPushBack(self.portraitList, changeHeadData)
    end
  end
end
function ChangeHeadProxy:GetPortraitList()
  return self.portraitList
end
function ChangeHeadProxy:RecvSyncAllPhotoFrame(data)
  if data.ids then
    TableUtility.ArrayClear(self.frameList)
    local empty = ChangeHeadData.new(0)
    empty:SetType(ChangeHeadData.HeadCellType.Portrait)
    TableUtility.ArrayPushBack(self.frameList, empty)
    for i = 1, #data.ids do
      local changeHeadData = ChangeHeadData.new(data.ids[i])
      changeHeadData:SetType(ChangeHeadData.HeadCellType.Portrait)
      TableUtility.ArrayPushBack(self.frameList, changeHeadData)
    end
  end
end
function ChangeHeadProxy:RecvSyncAllBackgroundFrame(data)
  if data.ids then
    TableUtility.ArrayClear(self.backgroundList)
    local empty = ChangeHeadData.new(0)
    empty:SetType(ChangeHeadData.HeadCellType.Frame)
    TableUtility.ArrayPushBack(self.backgroundList, empty)
    for i = 1, #data.ids do
      local changeHeadData = ChangeHeadData.new(data.ids[i])
      changeHeadData:SetType(ChangeHeadData.HeadCellType.Frame)
      TableUtility.ArrayPushBack(self.backgroundList, changeHeadData)
    end
  end
end
function ChangeHeadProxy:RecvSyncUnlockChatFrame(data)
  if #self.chatframeList == 0 then
    xdlog("首次添加0号空白数据")
    local empty = ChangeHeadData.new(0)
    empty:SetType(ChangeHeadData.HeadCellType.ChatFrame)
    TableUtility.ArrayPushBack(self.chatframeList, empty)
  end
  if data.ids then
    for i = 1, #data.ids do
      local id = data.ids[i]
      local isExist = false
      for j = 1, #self.chatframeList do
        if self.chatframeList[j].id == id then
          isExist = true
          break
        end
      end
      if not isExist then
        local changeHeadData = ChangeHeadData.new(id)
        xdlog("新增聊天框数据", id)
        changeHeadData:SetType(ChangeHeadData.HeadCellType.ChatFrame)
        TableUtility.ArrayPushBack(self.chatframeList, changeHeadData)
      end
    end
  end
end
function ChangeHeadProxy:RecvUnlockPhotoFrame(data)
  if data.del then
    for i = #self.frameList, 1, -1 do
      if data.id == self.frameList[i].id then
        table.remove(self.frameList, i)
      end
    end
  else
    if #self.frameList == 0 then
      local empty = ChangeHeadData.new(0)
      empty:SetType(ChangeHeadData.HeadCellType.Portrait)
      TableUtility.ArrayPushBack(self.frameList, empty)
    end
    local changeHeadData = ChangeHeadData.new(data.id)
    changeHeadData:SetType(ChangeHeadData.HeadCellType.Portrait)
    TableUtility.ArrayPushBack(self.frameList, changeHeadData)
  end
end
function ChangeHeadProxy:RecvUnlockBackgroundFrame(data)
  if data.del then
    for i = #self.backgroundList, 1, -1 do
      if data.id == self.backgroundList[i].id then
        table.remove(self.backgroundList, i)
      end
    end
  else
    if #self.backgroundList == 0 then
      local empty = ChangeHeadData.new(0)
      empty:SetType(ChangeHeadData.HeadCellType.Frame)
      TableUtility.ArrayPushBack(self.backgroundList, empty)
    end
    local changeHeadData = ChangeHeadData.new(data.id)
    changeHeadData:SetType(ChangeHeadData.HeadCellType.Frame)
    TableUtility.ArrayPushBack(self.backgroundList, changeHeadData)
  end
end
function ChangeHeadProxy:GetFrameList()
  return self.frameList
end
function ChangeHeadProxy:GetBackgroundList()
  return self.backgroundList
end
function ChangeHeadProxy:GetChatframeList()
  return self.chatframeList
end
