local _FlagSp = {
  [1] = {
    spriteName = "Novicecopy_bg_10",
    text = ZhString.Pve_FirstCompleteReward
  },
  [2] = {
    spriteName = "Novicecopy_bg_11",
    text = ZhString.Pve_ProbabilisticReward
  }
}
PveDropItemCell = class("PveDropItemCell", ItemCell)
function PveDropItemCell:Init()
  self.itemobj = self:LoadPreferb("cell/ItemCell", self.gameObject)
  self.itemobj.transform.localPosition = LuaGeometry.GetTempVector3()
  PveDropItemCell.super.Init(self)
  self:FindObjs()
  self:AddCellClickEvent()
end
function PveDropItemCell:FindObjs()
  self.flagSp = self:FindComponent("FlagSp", UISprite)
  self.flagName = self:FindComponent("Label", UILabel, self.flagSp.gameObject)
  self.mask = self:FindGO("Mask")
end
function PveDropItemCell:SetData(data)
  self.itemobj:SetActive(nil ~= data)
  if data then
    PveDropItemCell.super.SetData(self, data)
  end
  self:SetFlag()
  self.mask:SetActive(nil ~= data.IsPickup and data:IsPickup())
end
function PveDropItemCell:SetFlag()
  if self.data.IsFirst and self.data:IsFirst() then
    self:Show(self.flagSp)
    self.flagSp.spriteName = _FlagSp[1].spriteName
    self.flagName.text = _FlagSp[1].text
  elseif self.data.IsProbability and self.data:IsProbability() then
    self:Show(self.flagSp)
    self.flagSp.spriteName = _FlagSp[2].spriteName
    self.flagName.text = _FlagSp[2].text
  else
    self:Hide(self.flagSp)
  end
end
