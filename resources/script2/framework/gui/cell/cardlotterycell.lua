local IconMap = {
  [1] = "mall_twistedegg_card_01",
  [2] = "mall_twistedegg_card_02",
  [3] = "mall_twistedegg_card_03",
  [4] = "mall_twistedegg_card_04",
  [5] = "mall_twistedegg_card_05"
}
local _CurBatchIcon = {
  "mall_icon_exclamationpoint",
  "recharge_icon_up"
}
autoImport("LotteryCell")
CardLotteryCell = class("CardLotteryCell", LotteryCell)
function CardLotteryCell:FindObjs()
  self.rate = self:FindGO("rate"):GetComponent(UILabel)
  self.extraRate = self:FindGO("extraRate"):GetComponent(UILabel)
  self.up = self:FindGO("up")
  self.quality = self:FindGO("Quality"):GetComponent(UISprite)
  self.curBatchSp = self:FindGO("curBatch"):GetComponent(UISprite)
  self.dressFlag = self:FindGO("DressFlag")
end
function CardLotteryCell:SetData(data)
  CardLotteryCell.super.SetData(self, data)
  if not self.data then
    return
  end
  local baseRate, safatyRate = data:GetDisplayRate()
  local isJp = BranchMgr.IsJapan()
  local zhstr = isJp and ZhString.CardLottery_DetailRate_JP or ZhString.CardLottery_DetailRate
  self.rate.text = string.format(zhstr, baseRate)
  if safatyRate > 0 then
    self.extraRate.text = string.format(ZhString.CardLottery_ExtraRate, safatyRate)
  else
    self.extraRate.text = ""
  end
  self.up:SetActive(safatyRate > 0)
  self.quality.spriteName = IconMap[data.itemType]
  if data.isCurBatch == 1 then
    self.curBatchSp.gameObject:SetActive(true)
    self.curBatchSp.spriteName = isJp and _CurBatchIcon[1] or _CurBatchIcon[2]
    self.curBatchSp:MakePixelPerfect()
  else
    self.curBatchSp.gameObject:SetActive(false)
  end
  self.data = data
end
