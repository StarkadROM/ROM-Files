autoImport("LotteryCell")
LotteryMixCell = class("LotteryMixCell", LotteryCell)
function LotteryMixCell:FindObjs()
  self.gotFlag = self:FindGO("Get")
  self.rateLab = self:FindComponent("RateLab", UILabel)
  self.dressLab = self:FindComponent("DressLab", UILabel)
end
function LotteryMixCell:SetData(data)
  self.gameObject:SetActive(nil ~= data)
  if data then
    LotteryMixCell.super.SetData(self, data)
    local unget = AdventureDataProxy.Instance:IsFashionNeverDisplay(data.itemid, true)
    self.gotFlag:SetActive(not unget)
    self:Hide(self.rateLab)
    if LotteryProxy.Instance:InLotteryDress() then
      self:Show(self.dressLab)
      self.dressLab.text = LotteryProxy.Instance:GetDressItemDesc(data.itemid)
    else
      self:Hide(self.dressLab)
    end
    self:UpdateMyselfInfo(data:GetItemData())
  end
  self.data = data
end
