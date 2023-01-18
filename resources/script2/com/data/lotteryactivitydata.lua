local _format = "%s/%s %s:%s - %s/%s %s:%s"
LotteryActivityData = class("LotteryActivityData")
function LotteryActivityData:ctor(type, open, st, et)
  self.lotteryType = type
  self.open = open
  self.startTime = st
  self.endTime = et
  self:SetData()
end
function LotteryActivityData:SetData()
  local config = GameConfig.Lottery.activity
  if config then
    config = config[self.lotteryType]
    if config then
      self.name = config.activityName
      self.texture = config.textureName
      if config.always then
        self.time = ""
      else
        self.time = ServantCalendarProxy.GetTimeDate(self.startTime, self.endTime, _format)
      end
    end
  end
end
