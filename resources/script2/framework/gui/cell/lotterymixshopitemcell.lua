LotteryMixShopItemCell = class("LotteryMixShopItemCell", LotteryCell)
function LotteryMixShopItemCell:Init()
  self:LoadPreferb("cell/LotteryMixShopItemCell", self.gameObject)
  LotteryMixShopItemCell.super.Init(self)
end
function LotteryMixShopItemCell:FindObjs()
  self.moneyIcon = self:FindComponent("MoneyIcon", UISprite)
  self.money = self:FindComponent("Money", UILabel)
  self.gotFlag = self:FindGO("Get")
end
function LotteryMixShopItemCell:SetData(data)
  self.gameObject:SetActive(nil ~= data)
  if data then
    LotteryMixShopItemCell.super.SetData(self, data)
    self:UpdateMyselfInfo(data:GetItemData())
    local costIcon = Table_Item[data.ItemID].Icon
    IconManager:SetItemIcon(costIcon, self.moneyIcon)
    self.money.text = data.ItemCount
    local unget = AdventureDataProxy.Instance:IsFashionNeverDisplay(data.goodsID)
    self.gotFlag:SetActive(not unget)
  end
  self.data = data
end
