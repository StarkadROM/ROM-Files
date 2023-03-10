SceneFloatMsgQueueCtrl = reusableClass("SceneFloatMsgQueueCtrl")
SceneFloatMsgQueueCtrl.PoolSize = 20
function SceneFloatMsgQueueCtrl:Add(data)
  self.excutequeue[#self.excutequeue + 1] = data
end
local lastTime = 0
local waitTime = 0
local tableRemove = table.remove
function SceneFloatMsgQueueCtrl:Tick()
  local excutequeue = self.excutequeue
  local leftnum = #excutequeue
  if leftnum == 0 then
    return
  end
  local mul = math.floor(leftnum / 10)
  mul = math.min(mul, 32)
  mul = 1 << mul
  waitTime = self.args[2] / mul
  waitTime = math.max(33, waitTime)
  local deltaTime = (RealTime.time - lastTime) * 1000
  if deltaTime >= waitTime then
    lastTime = RealTime.time
    local data = tableRemove(excutequeue, 1)
    self.args[3](self.args[4], data)
  end
end
function SceneFloatMsgQueueCtrl:DoConstruct(asArray, params)
  self.args = ReusableTable.CreateTable()
  self.args[1] = params[1]
  self.args[2] = params[2]
  self.args[3] = params[3]
  self.args[4] = params[4]
  Debug_Assert(self.args[3] ~= nil, "SceneFloatMsgQueueCtrl excuteFunc CANNOT be nil!!!")
  self.isBusy = false
  self.excutequeue = ReusableTable.CreateTable()
  TimeTickManager.Me():CreateTick(0, 33, self.Tick, self, 1)
end
function SceneFloatMsgQueueCtrl:DoDeconstruct(asArray)
  TimeTickManager.Me():ClearTick(self, 1)
  ReusableTable.DestroyAndClearTable(self.args)
  ReusableTable.DestroyAndClearTable(self.excutequeue)
  self.args = nil
  self.excutequeue = nil
  self.isBusy = false
end
function SceneFloatMsgQueueCtrl:Clear()
  TableUtility.ArrayClear(self.excutequeue)
end
