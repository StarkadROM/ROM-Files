LoveLetterData = class("LoveLetterData")
LoveLetterData.Type = {
  Valentine = 1,
  Star = 2,
  Christmas = 3,
  SpringActivity = 4,
  Lottery = 5,
  WeddingDress = 6,
  IOS = 7
}
LoveLetterData.FromType = {Server = 1, Client = 2}
function LoveLetterData:ctor(data)
  self:SetData(data)
end
function LoveLetterData:SetData(data)
  if data then
    self.id = data.letterID
    self.staticId = data.configID
    self.name = data.name
    self.type = data.type
    self.bg = data.bg
    self.content = data.content
    self.content2 = data.content2
    self.from = LoveLetterData.FromType.Server
  end
end
function LoveLetterData:SetDataByItemServerData(itemid, data)
  if data then
    self.staticId = data.configID
    self.name = data.sendUserName
    self.type = self:GetType(itemid)
    self.bg = data.bg
    self.content = data.content
    self.content2 = data.content2
    self.from = LoveLetterData.FromType.Client
  end
end
function LoveLetterData:CheckValid()
  return self.staticId ~= nil and self.staticId ~= 0 or self.content ~= ""
end
function LoveLetterData:GetType(itemid)
  local loveLetter = GameConfig.LoveLetter
  if loveLetter ~= nil then
    if itemid == loveLetter.StarId then
      return self.Type.Star
    elseif itemid == loveLetter.ChristmasId then
      return self.Type.Christmas
    elseif itemid == loveLetter.SpringId then
      return self.Type.SpringActivity
    elseif itemid == GameConfig.Lottery.LoveLetterItemId then
      return self.Type.Lottery
    elseif itemid == loveLetter.letter_wedding_clother then
      return self.Type.WeddingDress
    end
  end
  return nil
end
