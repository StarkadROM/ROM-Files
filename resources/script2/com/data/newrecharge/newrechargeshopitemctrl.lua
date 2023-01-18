NewRechargeShopItemCtrl = class("NewRechargeShopItemCtrl")
function NewRechargeShopItemCtrl:Ins()
  if NewRechargeShopItemCtrl.ins == nil then
    NewRechargeShopItemCtrl.ins = NewRechargeShopItemCtrl.new()
  end
  return NewRechargeShopItemCtrl.ins
end
function NewRechargeShopItemCtrl:ctor()
end
function NewRechargeShopItemCtrl:RequestQueryShopItem(shop_type, shop_id)
  ShopProxy.Instance:CallQueryShopConfig(shop_type, shop_id)
end
NewRechargeShopItemCtrl.ItemShopType = 650
NewRechargeShopItemCtrl.ItemShopID = 1
function NewRechargeShopItemCtrl:GetItemShopConf()
  return ShopProxy.Instance:GetConfigByTypeId(NewRechargeShopItemCtrl.ItemShopType, NewRechargeShopItemCtrl.ItemShopID)
end
NewRechargeShopItemCtrl.DailyOneZenyRedTipID = 10600
function NewRechargeShopItemCtrl:UpdateOneZenyGoodsBuyInfo()
  local shopConf = self:GetItemShopConf()
  if GameConfig.ShopRed and GameConfig.ShopRed.Shopid then
    local goodsid
    for i = 1, #GameConfig.ShopRed.Shopid do
      goodsid = GameConfig.ShopRed.Shopid[i]
      if shopConf[goodsid] then
        local pre_buyCount = HappyShopProxy.Instance:GetCachedHaveBoughtItemCount(goodsid) or 0
        if pre_buyCount == 0 then
          RedTipProxy.Instance:UpdateRedTip(self.DailyOneZenyRedTipID)
          return
        end
      end
    end
  end
  RedTipProxy.Instance:RemoveWholeTip(self.DailyOneZenyRedTipID)
end
