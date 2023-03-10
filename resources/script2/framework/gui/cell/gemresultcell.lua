autoImport("GemCell")
GemResultCell = class("GemResultCell", GemCell)
function GemResultCell:Init()
  local obj = self:LoadPreferb("cell/GemCell", self.gameObject)
  obj.transform.localPosition = LuaVector3.Zero()
  GemResultCell.super.Init(self)
  self.effectContainer = self:FindGO("EffectContainer")
end
function GemResultCell:SetData(data)
  self.data = data
  if not data then
    return
  end
  GemResultCell.super.SetData(self, data)
  self:HideNum()
  self:SetShowNewTag(false)
  self:PlayQualityEffect(data)
end
function GemResultCell:PlayQualityEffect(data)
  local quality = GemProxy.GetSkillQualityFromItemData(data) or 1
  if (not (quality >= 3) or not EffectMap.UI.Egg10BoomR) and (quality ~= 2 or not EffectMap.UI.Egg10BoomB) then
    local effectId
  end
  self:PlayUIEffect(effectId, self.effectContainer, true)
  effectId = quality >= 3 and EffectMap.UI.Egg10DritP or quality == 2 and EffectMap.UI.Egg10DritB or nil
  self:PlayUIEffect(effectId, self.effectContainer, false)
end
function GemResultCell:PlayUIEffect(id, container, once)
  if id and id ~= "" then
    GemResultCell.super.PlayUIEffect(self, id, container, once)
  end
end
