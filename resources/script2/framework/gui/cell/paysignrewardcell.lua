PaySignRewardCell = class("PaySignRewardCell", ItemCell)
local SIGN_STYLE = {
  {
    bg_spriteName = "sign_bg_day1",
    bg2_Color = "0039ff19",
    bg3_spriteName = "sign_bg_icon1",
    bg4_Color = "adc1ef",
    index_Color = "8baadf",
    cat_spriteName = "sign_pic_cat_day1",
    embeSp_Color = "7088c1"
  },
  {
    bg_spriteName = "sign_bg_day2",
    bg2_Color = "0039ff19",
    bg3_spriteName = "sign_bg_icon1",
    bg4_Color = "adc1ef",
    index_Color = "778ee0",
    cat_spriteName = "sign_pic_cat_day2",
    embeSp_Color = "7088c1"
  },
  {
    bg_spriteName = "sign_bg_day3",
    bg2_Color = "aeb5fe",
    bg3_spriteName = "sign_bg_icon1",
    bg4_Color = "adc1ef",
    index_Color = "8290d2",
    cat_spriteName = "sign_pic_cat_day3",
    embeSp_Color = "707dc1"
  },
  {
    bg_spriteName = "sign_bg_day4",
    bg2_Color = "abacfe",
    bg3_spriteName = "sign_bg_icon1",
    bg4_Color = "adc1ef",
    index_Color = "7971d9",
    cat_spriteName = "sign_pic_cat_day4",
    embeSp_Color = "707dc1"
  },
  {
    bg_spriteName = "sign_bg_day5",
    bg2_Color = "a6a3fe",
    bg3_spriteName = "sign_bg_icon1",
    bg4_Color = "acbbed",
    index_Color = "8366cc",
    cat_spriteName = "sign_pic_cat_day5",
    embeSp_Color = "707dc1"
  },
  {
    bg_spriteName = "sign_bg_day6",
    bg2_Color = "a69efe",
    bg3_spriteName = "sign_bg_icon1",
    bg4_Color = "acbbed",
    index_Color = "7858b3",
    cat_spriteName = "sign_pic_cat_day6",
    embeSp_Color = "707dc1"
  },
  {
    bg_spriteName = "sign_bg_day7",
    bg2_Color = "f2baa8",
    bg3_spriteName = "sign_bg_icon2",
    bg4_Color = "f1deb2",
    index_Color = "ff9656",
    cat_spriteName = "sign_pic_cat_day7",
    embeSp_Color = "9a655e"
  }
}
function PaySignRewardCell:Init()
  local itemroot = self:FindGO("Item")
  local itemCell = self:FindGO("Common_ItemCell")
  if not itemCell then
    local go = self:LoadPreferb("cell/ItemCell", itemroot)
    go.name = "Common_ItemCell"
  end
  self.finishFlag = self:FindGO("Finished")
  self.cbg = self:FindComponent("Bg0", UISprite)
  self.cbg2 = self:FindComponent("Bg2", UISprite)
  self.cbg3 = self:FindComponent("Bg3", UISprite)
  self.cbg4 = self:FindComponent("Bg4", UISprite)
  self.index = self:FindComponent("Index", UILabel)
  self.cat = self:FindComponent("Cat", UISprite)
  self.embe = self:FindComponent("Embe", UISprite)
  self.embe1 = self:FindComponent("Embe1", UISprite)
  self.embeSp = self:FindComponent("EmbeSp", UISprite)
  self.customNum = self:FindComponent("CustomNum", UILabel)
  PaySignRewardCell.super.Init(self)
  self:HideNum()
  self:AddClickEvent(self.gameObject, function()
    local stick = self.gameObject:GetComponent(UIWidget)
    local callback = function()
      self:CancelChoose()
    end
    local tipdata = ReusableTable.CreateTable()
    tipdata.itemdata = self.data
    tipdata.funcConfig = {}
    tipdata.callback = callback
    TipManager.Instance:ShowItemFloatTip(tipdata, stick, NGUIUtil.AnchorSide.Right, {220, 0})
    ReusableTable.DestroyAndClearTable(tipdata)
  end)
end
function PaySignRewardCell:CancelChoose()
  self:ShowItemTip()
end
function PaySignRewardCell:RefreshStyle(index)
  local style = SIGN_STYLE[index]
  if not style then
    return
  end
  self.cbg.spriteName = style.bg_spriteName
  self.cbg3.spriteName = style.bg3_spriteName
  local suc1, col1 = ColorUtil.TryParseHexString(style.bg2_Color)
  if suc1 then
    self.cbg2.color = col1
    self.embe.color = col1
    self.embe1.color = col1
  end
  local suc2, col2 = ColorUtil.TryParseHexString(style.index_Color)
  if suc2 then
    self.index.color = col2
  end
  self.cat.spriteName = style.cat_spriteName
  local suc3, col3 = ColorUtil.TryParseHexString(style.embeSp_Color)
  if suc3 then
    self.embeSp.color = col3
    self.customNum.effectColor = col3
  end
  local suc4, col4 = ColorUtil.TryParseHexString(style.bg4_Color)
  if suc4 then
    self.cbg4.color = col4
  end
end
function PaySignRewardCell:SetData(data)
  self.data = data
  if data then
    PaySignRewardCell.super.SetData(self, data)
    if self.numLab then
      self.numLab.effectStyle = UILabel.Effect.Outline
    end
    local bg = self:GetBgSprite()
    if bg then
      self:Hide(bg)
    end
    self:SetGOActive(self.empty, false)
    self.index.text = string.format(ZhString.PaySignRewardView_DayIndex, data.index)
    self.customNum.text = "x" .. data.num
    self:RefreshStyle(data.index)
    self.gameObject:SetActive(true)
  else
    self.gameObject:SetActive(false)
  end
end
function PaySignRewardCell:SetFinishFlag(var)
  self.finishFlag:SetActive(var)
  self:SetIconDark(var)
  if var and self.numLab then
    self.numLab.effectStyle = UILabel.Effect.None
  end
end
