autoImport("LotteryCell")
LotteryMagicDetailCell = class("LotteryMagicDetailCell", LotteryCell)
function LotteryMagicDetailCell:FindObjs()
  self.rate = self:FindGO("Rate")
  if self.rate then
    self.rate = self.rate:GetComponent(UILabel)
  end
  self.up = self:FindGO("Up")
  self.fashionUnlock = self:FindGO("FashionUnlock")
  if self.fashionUnlock then
    self.fashionUnlock = self.fashionUnlock:GetComponent(UIMultiSprite)
  end
  self.magicLotteryRate = self:FindGO("ItemRate")
  if self.magicLotteryRate then
    self.magicLotteryRate = self.magicLotteryRate:GetComponent(UILabel)
  end
  self.dressLab = self:FindComponent("DressLab", UILabel)
end
function LotteryMagicDetailCell:EnterDress(var)
  if self.rate then
    self.rate.gameObject:SetActive(not var)
  end
  if self.magicLotteryRate then
    self.magicLotteryRate.gameObject:SetActive(not var)
  end
  if self.dressLab then
    self.dressLab.gameObject:SetActive(var)
  end
end
function LotteryMagicDetailCell:SetData(data)
  self.gameObject:SetActive(data ~= nil)
  if data then
    LotteryMagicDetailCell.super.SetData(self, data)
    if self.up then
      self.up:SetActive(data.isCurBatch == 1)
    end
    if self.fashionUnlock then
      local id = data.itemid
      local equip = Table_Equip[id]
      if equip and equip.GroupID then
        id = equip.GroupID
      end
      local _AdventureDataProxy = AdventureDataProxy.Instance
      if _AdventureDataProxy:IsFashionStored(id) or _AdventureDataProxy:IsMountStored(id) then
        self.fashionUnlock.gameObject:SetActive(true)
        self.fashionUnlock.CurrentState = 1
      elseif _AdventureDataProxy:IsFashionOrMountUnlock(id) then
        self.fashionUnlock.gameObject:SetActive(true)
        self.fashionUnlock.CurrentState = 0
      else
        self.fashionUnlock.gameObject:SetActive(false)
      end
    end
    if LotteryProxy.Instance:InLotteryDress() then
      self:EnterDress(true)
      if self.dressLab then
        self.dressLab.text = LotteryProxy.Instance:GetDressItemDesc(data:GetRealItemID())
      end
    else
      self:EnterDress(false)
      if self.rate then
        self.rate.text = string.format(ZhString.Lottery_DetailRate, data:GetRate())
      end
      if GameConfig.Lottery.MagicLotteryRateShow == 1 then
        if self.magicLotteryRate then
          self.magicLotteryRate.text = string.format(ZhString.Lottery_DetailRate, data:GetRate())
        end
      elseif self.magicLotteryRate then
        self.magicLotteryRate.text = ""
      end
    end
  end
  self.data = data
end
