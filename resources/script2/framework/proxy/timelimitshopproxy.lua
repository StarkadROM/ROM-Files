TimeLimitShopProxy = class("TimeLimitShopProxy", pm.Proxy)
function TimeLimitShopProxy:ctor(proxyName, data)
  self.proxyName = proxyName or "TimeLimitShopProxy"
  if TimeLimitShopProxy.Instance == nil then
    TimeLimitShopProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end
function TimeLimitShopProxy:Init()
  self.timeLimitGoods = {}
  self.showView = false
  EventManager.Me():AddEventListener(LoadSceneEvent.FinishLoadScene, self.sceneLoadFinish, self)
end
function TimeLimitShopProxy:RecvGiftTimeLimitNtfUserEvent(infos)
  TableUtility.TableClear(self.timeLimitGoods)
  if infos and #infos > 0 then
    for i = 1, #infos do
      local single = infos[i]
      local data = {}
      data.id = single.id
      data.time = single.time
      data.state = single.state
      xdlog("四叶草商店商品", data.id, data.state)
      if data.state == 1 then
        table.insert(self.timeLimitGoods, data)
      end
    end
  end
end
function TimeLimitShopProxy:RecvGiftTimeLimitActiveUserEvent(data)
  self.showView = true
end
function TimeLimitShopProxy:GetShopInfos()
  if self.timeLimitGoods and #self.timeLimitGoods > 0 then
    local result = {}
    for i = 1, #self.timeLimitGoods do
      local single = self.timeLimitGoods[i]
      local config = Table_GiftTimeLimit[single.id]
      if config then
        local liveTime = config.LiveTime
        if single.time + config.LiveTime > ServerTime.CurServerTime() / 1000 then
          local copy = {}
          TableUtility.TableShallowCopy(copy, single)
          table.insert(result, copy)
        end
      end
    end
    return result
  end
end
function TimeLimitShopProxy:CheckDojiBtnValid()
  if self.timeLimitGoods and #self.timeLimitGoods > 0 then
    for i = 1, #self.timeLimitGoods do
      local single = self.timeLimitGoods[i]
      local valid = self:CheckGiftTimeLimitValid(single.id, single.time) and single.state == 1 or false
      if valid then
        xdlog("CheckDojiBtnValid  --- true", single.id)
        return true
      end
    end
  end
  return false
end
function TimeLimitShopProxy:CheckGiftTimeLimitValid(id, startTimeStamp)
  local config = Table_GiftTimeLimit[id]
  if not config then
    return false
  end
  local endTimeStamp, endTime
  local curServerTime = ServerTime.CurServerTime() / 1000
  if EnvChannel.IsTFBranch() then
    endTime = config.EndTimeTF
  else
    endTime = config.EndTime
  end
  local st_year, st_month, st_day, st_hour, st_min, st_sec = StringUtil.GetDateData(endTime)
  local goodEndTimeStamp = os.time({
    day = st_day,
    month = st_month,
    year = st_year,
    hour = st_hour,
    min = st_min,
    sec = st_sec
  })
  endTimeStamp = startTimeStamp + config.LiveTime
  if curServerTime > endTimeStamp then
    return false
  end
  return true
end
function TimeLimitShopProxy:sceneLoadFinish()
  local mapId = Game.MapManager:GetMapID()
  local mapData = mapId and Table_Map[mapId]
  if mapData and mapData.IsCommonline and mapData.IsCommonline == 1 then
    self:viewPopUp()
  end
end
function TimeLimitShopProxy:CallGiftTimeLimitBuyUserEvent(id)
  xdlog("申请购买ID", id)
  ServiceUserEventProxy.Instance:CallGiftTimeLimitBuyUserEvent(id)
end
function TimeLimitShopProxy:viewPopUp()
  if self.showView and self.timeLimitGoods and #self.timeLimitGoods > 0 then
    for i = 1, #self.timeLimitGoods do
      local single = self.timeLimitGoods[i]
      if single.id == self.newInstock and single.state == 1 then
        GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.TimeLimitShopView
        })
        break
      end
    end
  end
  self.showView = false
end
