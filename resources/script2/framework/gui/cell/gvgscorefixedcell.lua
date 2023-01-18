local _continue_score = GameConfig.GvgNewConfig and GameConfig.GvgNewConfig.continue_score or 2
local _GetMaxValue = function(key)
  if key == "occupyCity" then
    return GvgProxy.Instance:GetMaxOccupyCityScore()
  elseif key == "contineOccupyCity" then
    return _continue_score
  end
end
GvgScoreFixedCell = class("GvgScoreFixedCell", BaseCell)
function GvgScoreFixedCell:Init()
  GvgScoreFixedCell.super.Init(self)
  self.nameLab = self:FindComponent("Name", UILabel)
  self.descLab = self:FindComponent("DescLab", UILabel)
  self.extraRoot = self:FindGO("CityRoot")
  if self.extraRoot then
    self:Hide(self.extraRoot)
  end
end
function GvgScoreFixedCell:SetData(configData)
  local maxValue = _GetMaxValue(configData.type)
  self.nameLab.text = string.format(configData.title, maxValue)
  self.descLab.text = configData.desc
end
