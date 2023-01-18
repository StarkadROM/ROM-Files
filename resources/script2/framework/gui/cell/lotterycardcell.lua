local IconMap = {
  [1] = "mall_twistedegg_card_01",
  [2] = "mall_twistedegg_card_02",
  [3] = "mall_twistedegg_card_03",
  [4] = "mall_twistedegg_card_04",
  [5] = "mall_twistedegg_card_05"
}
autoImport("LotteryCell")
LotteryCardCell = class("LotteryCardCell", LotteryCell)
function LotteryCardCell:FindObjs()
  self.rate = self:FindGO("Rate"):GetComponent(UILabel)
  self.quality = self:FindGO("Quality"):GetComponent(UISprite)
end
function LotteryCardCell:SetData(data)
  LotteryCardCell.super.SetData(self, data)
  if not self.data then
    return
  end
  if self.rate then
    local zhstr = BranchMgr.IsJapan() and ZhString.CardLottery_DetailRate_JP or ZhString.CardLottery_DetailRate
    self.rate.text = string.format(zhstr, data:GetRate())
  end
  if self.quality then
    self.quality.spriteName = IconMap[data.itemType]
  end
  self.data = data
end
