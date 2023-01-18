autoImport("BaseItemCell")
QuickItemCell = class("QuickItemCell", BaseItemCell)
local tempV3 = LuaVector3()
local _ArrayIndex = TableUtil.ArrayIndexOf
local _HpConfigID = GameConfig.QuickItemTip.HpItemIds
local _SpConfigID = GameConfig.QuickItemTip.SpItemIds
local _HpPer = GameConfig.QuickItemTip.HpPct / 100
local _SpPer = GameConfig.QuickItemTip.SpPct / 100
local _HpSpTipEffectLv = GameConfig.QuickItemTip.Level
local _MAX = math.max
function QuickItemCell:Init()
  QuickItemCell.super.Init(self)
  self.tipEffect = self:FindGO("TipEffect")
  self.tipEffect:SetActive(true)
  self:SetDefaultBgSprite(RO.AtlasMap.GetAtlas("NewCom"), "com_icon_bottom2")
  self.effectShowed = false
end
function QuickItemCell:SetData(data)
  self.data = data
  if data and data.staticData then
    self.gameObject:SetActive(true)
    QuickItemCell.super.SetData(self, data)
    self:SetIconDark(data.id == "Shadow")
    self:RefreshNumLab()
    self:UpdateMyselfInfo()
    local staticId = data.staticData.id
    self.isSp, self.isHp = 0 ~= _ArrayIndex(_SpConfigID, staticId), 0 ~= _ArrayIndex(_HpConfigID, staticId)
  else
    self.isSp, self.isHp = false, false
    self.gameObject:SetActive(false)
  end
  self:UpdateHpSpTipEffect()
end
function QuickItemCell:SetActiveSymbol(active)
  if not active and nil ~= BagProxy.Instance.roleEquip:GetItemByGuid(self.data.id) then
    active = true
  end
  QuickItemCell.super.SetActiveSymbol(self, active)
end
function QuickItemCell:UpdateHpSpTipEffect()
  local needShow = false
  local needCheck = self.isSp or self.isHp
  if needCheck and self.data and self.data.num > 0 and self.data.id ~= "Shadow" and MyselfProxy.Instance:RoleLevel() < _HpSpTipEffectLv then
    local props = Game.Myself.data.props
    if self.isHp then
      needShow = _HpPer > props:GetPropByName("Hp"):GetValue() / _MAX(props:GetPropByName("MaxHp"):GetValue(), 1)
    else
      needShow = _SpPer > props:GetPropByName("Sp"):GetValue() / _MAX(props:GetPropByName("MaxSp"):GetValue(), 1)
    end
  end
  if self.effectShowed ~= needShow then
    self.effectShowed = needShow
    if needShow then
      if nil == self.hpSpEffect then
        self.hpSpEffect = self:LoadPreferb_ByFullPath(ResourcePathHelper.Effect("UI/45Click_icon"), self.tipEffect)
      end
      self.hpSpEffect:SetActive(true)
    elseif nil ~= self.hpSpEffect then
      self.hpSpEffect:SetActive(false)
    end
  end
end
function QuickItemCell:RefreshNumLab()
  self.numLabGO = self:FindGO("NumLabel", self.item)
  if self.numLabGO then
    self.numLabTrans = self.numLabGO.transform
    LuaVector3.Better_Set(tempV3, 40.2, -43.2, 0)
    self.numLabTrans.localPosition = tempV3
  end
end
