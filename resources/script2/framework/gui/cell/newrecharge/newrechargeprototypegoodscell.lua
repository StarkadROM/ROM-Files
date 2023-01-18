NewRechargePrototypeGoodsCell = class("NewRechargePrototypeGoodsCell", BaseCell)
NewRechargePrototypeGoodsCell.GoodsTypeEnum = {Deposit = 1, Shop = 2}
NewRechargePrototypeGoodsCell.goodsType = nil
function NewRechargePrototypeGoodsCell:Init()
  self:FindObjs()
  self:RegisterClickEvent()
  self:Func_AddListenEvent()
end
function NewRechargePrototypeGoodsCell:OnCellDestroy()
  self:Func_RemoveListenEvent()
end
function NewRechargePrototypeGoodsCell:FindObjs()
end
function NewRechargePrototypeGoodsCell:GetGoodsType()
  return self.data.confType
end
function NewRechargePrototypeGoodsCell:IsDepositGoods()
  return self.goodsType == self.GoodsTypeEnum.Deposit
end
function NewRechargePrototypeGoodsCell:IsShopGoods()
  return self.goodsType == self.GoodsTypeEnum.Shop
end
function NewRechargePrototypeGoodsCell:SetData(data)
  if data then
    self.data = data
  end
  if not self.data then
    return
  end
  self.goodsType = self:GetGoodsType()
  if self.goodsType == self.GoodsTypeEnum.Deposit then
    self:SetData_Deposit()
  else
    self:SetData_Shop()
  end
  self:SetCell()
  self:updateItemPricePosition()
end
function NewRechargePrototypeGoodsCell:SetCell()
  if self.goodsType == self.GoodsTypeEnum.Deposit then
    self:SetCell_Deposit()
  else
    self:SetCell_Shop()
  end
end
function NewRechargePrototypeGoodsCell:Purchase()
  if self.goodsType == self.GoodsTypeEnum.Deposit then
    self:Purchase_Deposit()
  else
    self:Purchase_Shop()
  end
end
function NewRechargePrototypeGoodsCell:Func_AddListenEvent()
end
function NewRechargePrototypeGoodsCell:Func_RemoveListenEvent()
end
function NewRechargePrototypeGoodsCell:SetData_Deposit()
end
function NewRechargePrototypeGoodsCell:SetData_Shop()
end
function NewRechargePrototypeGoodsCell:SetCell_Deposit()
end
function NewRechargePrototypeGoodsCell:SetCell_Shop()
end
function NewRechargePrototypeGoodsCell:Purchase_Deposit()
end
function NewRechargePrototypeGoodsCell:Purchase_Shop()
end
function NewRechargePrototypeGoodsCell:Set_DescMark(active, desc)
  if not self.u_desMark then
    return
  end
  self.u_desMark:SetActive(active)
  self.u_desMarkText.text = desc or ""
end
function NewRechargePrototypeGoodsCell:Set_SoldOutMark(active)
  if not self.u_soldOutMark then
    return
  end
  self.u_soldOutMark:SetActive(active)
end
function NewRechargePrototypeGoodsCell:Set_PriceAndDiscount()
end
function NewRechargePrototypeGoodsCell:Set_DiscountMark(active, oriPrice, curPrice, showDiscount)
  if not self.u_itemPrice then
    return
  end
  if not self.u_itemOriPrice then
    return
  end
  if active then
    if oriPrice then
      self.u_itemOriPrice.text = string.format(ZhString.Shop_OriginPrice, FunctionNewRecharge.FormatMilComma(oriPrice))
    end
    if curPrice then
      self.u_itemPrice.text = FunctionNewRecharge.FormatMilComma(curPrice)
    end
  elseif oriPrice then
    self.u_itemPrice.text = FunctionNewRecharge.FormatMilComma(oriPrice)
  end
  self.u_itemOriPrice.gameObject:SetActive(active)
  if self.u_discountMark then
    self.u_discountMark:SetActive(showDiscount == true and active == true)
    if showDiscount and active and oriPrice and curPrice then
      local discount = math.ceil(curPrice / oriPrice * 100)
      self.u_discountValue.text = discount .. "%"
      Game.convert2OffLbl(self.u_discountValue)
    end
  end
end
function NewRechargePrototypeGoodsCell:updateItemPricePosition()
  if Slua.IsNull(self.u_itemPriceIcon) then
    return
  end
  if self.u_itemPriceIcon.gameObject.activeSelf then
    local iconLen = self.u_itemPriceIcon.width * 0.6
    self.u_itemPrice.transform.localPosition = LuaGeometry.GetTempVector3(iconLen / 2, 0, 0)
  else
    self.u_itemPrice.transform.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
  end
end
function NewRechargePrototypeGoodsCell:isShowSuperValue(value)
  if self.m_goSuperValue ~= nil then
    if value ~= nil then
      self.m_goSuperValue.gameObject:SetActive(true)
      self.m_uiTxtSuperValueNum.text = value .. "%"
    else
      self.m_goSuperValue.gameObject:SetActive(false)
    end
  end
end
function NewRechargePrototypeGoodsCell:Set_FirstDoubleMark(active)
  if not self.u_firstDoubleMark then
    return
  end
  self.u_firstDoubleMark:SetActive(active)
end
function NewRechargePrototypeGoodsCell:Set_GainMoreMark(active, gainMoreMtpCount)
  if not self.u_gainMoreMark then
    return
  end
  self.u_gainMoreMark:SetActive(active)
  self.u_gainMore.text = gainMoreMtpCount and "x" .. gainMoreMtpCount or ""
end
function NewRechargePrototypeGoodsCell:Set_FreeBonusMark(active, freeBonusCount)
  if not self.u_freeBonusMark then
    return
  end
  self.u_freeBonusMark:SetActive(false)
  self.u_freeBonus.text = string.format(ZhString.Giving, FunctionNewRecharge.FormatMilComma(freeBonusCount))
  UIUtil.FitLableMaxWidth(self.u_freeBonus, 200)
  self.u_freeBonusMark:SetActive(active)
end
function NewRechargePrototypeGoodsCell:Set_LeftTimeMark(active, left_time)
  if not self.u_leftTimeMark then
    return
  end
  self.u_leftTimeMark:SetActive(active)
  self.u_leftTime.text = left_time or ""
end
function NewRechargePrototypeGoodsCell:Set_BuyTimesMark(active, buy_times)
  if not self.u_buyTimes then
    return
  end
  self.u_buyTimes.gameObject:SetActive(active)
  self.u_buyTimes.text = buy_times or ""
end
function NewRechargePrototypeGoodsCell:Set_ContentMark(active, item_id, item_count)
  if not self.u_content then
    return
  end
  self.u_content:SetActive(active)
  if item_id and nil ~= Table_Item and nil ~= Table_Item[item_id] then
    IconManager:SetItemIcon(Table_Item[item_id].Icon, self.u_contentIcon)
  end
  if item_count then
    self.u_contentNum.text = " " .. FunctionNewRecharge.FormatMilComma(item_count) or ""
  end
  local lLen = self.u_contentIcon.gameObject.activeSelf and self.u_contentIcon.width or 0
  lLen = lLen * self.u_contentIcon.transform.localScale[1]
  local rLen = self.u_contentNum.gameObject.activeSelf and self.u_contentNum.width or 0
  self.u_contentPH.transform.localPosition = LuaGeometry.GetTempVector3(lLen / 2 - rLen / 2, 0, 0)
end
function NewRechargePrototypeGoodsCell:Set_InstMark(active)
  if not self.u_instBtn then
    return
  end
  self.u_instBtn:SetActive(active)
end
function NewRechargePrototypeGoodsCell:Set_NewMark(active)
  if not self.u_newMark then
    return
  end
  self.u_newMark:SetActive(active)
end
function NewRechargePrototypeGoodsCell:Set_LeftTimeMark(active)
  if not self.u_leftTimeMark then
    return
  end
  self.u_leftTimeMark:SetActive(active)
end
