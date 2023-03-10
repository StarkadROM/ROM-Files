local BaseCell = autoImport("BaseCell")
EnchantInfoLabelCell = class("EnchantInfoLabelCell", BaseCell)
local grayFormat = "[c][9c9c9c]%s[-][/c]"
EnchantInfoLabelMenuTypePos = {
  [EnchantMenuType.SixBaseAttri] = {
    name = Vector3(0, 0, 0),
    value = Vector3(160, 0, 0),
    nameWidth = 75,
    nameHight = 30,
    valueWidth = 85
  },
  [EnchantMenuType.BaseAttri] = {
    name = Vector3(0, 0, 0),
    value = Vector3(430, 0, 0),
    nameWidth = 320,
    nameHight = 60,
    valueWidth = 150
  },
  [EnchantMenuType.DefAttri] = {
    name = Vector3(0, 0, 0),
    value = Vector3(430, 0, 0),
    nameWidth = 320,
    nameHight = 60,
    valueWidth = 150
  },
  [EnchantMenuType.CombineAttri] = {
    name = Vector3(0, 0, 0),
    value = Vector3(430, -28, 0),
    nameWidth = 320,
    nameHight = 60,
    valueWidth = 150
  }
}
function EnchantInfoLabelCell:Init()
  EnchantInfoLabelCell.super.Init()
  self.name = self:FindComponent("Name", UILabel)
  self.value = self:FindComponent("Value", UILabel)
end
function EnchantInfoLabelCell:SetData(data)
  if data then
    self:Show()
    local esData = data.enchantData
    local attriMenuType = data.attriMenuType
    self.name.transform.localPosition = EnchantInfoLabelMenuTypePos[attriMenuType].name
    self.name.width = EnchantInfoLabelMenuTypePos[attriMenuType].nameWidth
    self.name.height = EnchantInfoLabelMenuTypePos[attriMenuType].nameHight
    self.value.transform.localPosition = EnchantInfoLabelMenuTypePos[attriMenuType].value
    self.value.width = EnchantInfoLabelMenuTypePos[attriMenuType].valueWidth
    local propVO = EnchantEquipUtil.Instance:GetAttriPropVO(esData.AttrType)
    if propVO then
      self.name.text = tostring(propVO.displayName)
      if attriMenuType == EnchantMenuType.SixBaseAttri then
        if BranchMgr.IsChina() or BranchMgr.IsTW() then
          self.name.text = tostring(propVO.displayName) .. esData.AttrType
        else
          self.name.text = OverSea.LangManager.Instance():GetLangByKey(tostring(propVO.displayName))
        end
      end
      local range = esData.AttrBound and esData.AttrBound[1]
      if range then
        if propVO.isPercent then
          local min, max = range[1] * 100, range[2] * 100
          self.value.text = string.format("+%d%%~+%d%%", tostring(min), tostring(max))
        else
          self.value.text = string.format("+%d~+%d", tostring(range[1]), tostring(range[2]))
        end
      end
    end
    if attriMenuType ~= EnchantMenuType.CombineAttri then
      if not data.canGet then
        self.name.text = string.format(grayFormat, self.name.text)
        self.value.text = string.format(grayFormat, self.value.text)
      end
    else
      self.name.text = string.format(ZhString.EnchantInfoLabelCell_CombineEffectFormat, esData.Name, esData.ComBineAttr, esData.Dsc)
      self.value.text = esData.AttrSectionDsc
      if not data.canGet then
        self.name.text = string.format(grayFormat, self.name.text)
        self.value.text = string.format(grayFormat, self.value.text)
      end
    end
  else
    self:Hide()
  end
end
