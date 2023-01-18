local baseCell = autoImport("BaseCell")
local _DifficultyConfig = GameConfig.Pve.Difficulty
local _BgSpriteName = {
  unlockSp = "Novicecopy_bg_06",
  unlockSp2 = "Novicecopy_bg_15",
  lockSp = "Novicecopy_bg_07",
  unlockOutlineColor = Color(0.12156862745098039, 0.4549019607843137, 0.7490196078431373, 1),
  unlock2OutlineColor = Color(0.2980392156862745, 0.2549019607843137, 0.7725490196078432, 1),
  lockOutlineColor = Color(0.3803921568627451, 0.3803921568627451, 0.3803921568627451, 1)
}
local _RomanType = 9
PveDifficultyCell = class("PveDifficultyCell", baseCell)
function PveDifficultyCell:Init()
  PveDifficultyCell.super.Init(self)
  self:FindObj()
  self:AddCellClickEvent()
end
function PveDifficultyCell:FindObj()
  self.bg = self.gameObject:GetComponent(UISprite)
  self.choosenObj = self:FindGO("Choosen")
  self.desc = self:FindComponent("Desc", UILabel)
  self.finishGo = self:FindGO("Finish")
end
function PveDifficultyCell:SetData(data)
  self.data = data
  self.diff = self.data.difficulty
  local isPveCard = self.data:IsPveCard()
  if self.data.diffType == _RomanType then
    self.desc.text = StringUtil.IntToRoman(self.data.pveCardDifficulty)
  else
    self.desc.text = _DifficultyConfig[self.data.diffType][self.diff]
  end
  local open = data:IsOpen(id)
  if not open then
    self.bg.spriteName = _BgSpriteName.lockSp
    self.desc.effectColor = _BgSpriteName.lockOutlineColor
  else
    self.bg.spriteName = self.data.pveCardlayer and self.data.pveCardlayer > 0 and _BgSpriteName.unlockSp2 or _BgSpriteName.unlockSp
    self.desc.effectColor = self.data.pveCardlayer and self.data.pveCardlayer > 0 and _BgSpriteName.unlock2OutlineColor or _BgSpriteName.unlockOutlineColor
  end
  self:UpdateChoose()
  local max_challengeCount = self.data.staticData.ChallengeCount
  if isPveCard then
    max_challengeCount = max_challengeCount + (PveEntranceProxy.Instance.pveCard_addTimes or 0)
  end
  local server_challengeCount = PveEntranceProxy.Instance:GetPassTime(self.data.id)
  if isPveCard then
    self.finishGo:SetActive(PveEntranceProxy.Instance:IsSweepOpen(self.data.id))
  else
    self.finishGo:SetActive(max_challengeCount == server_challengeCount)
  end
end
function PveDifficultyCell:SetChoosen(id)
  self.chooseDifficulty = id
  self:UpdateChoose()
end
function PveDifficultyCell:UpdateChoose()
  if self.diff and self.chooseDifficulty and self.diff == self.chooseDifficulty then
    self.choosenObj:SetActive(true)
  else
    self.choosenObj:SetActive(false)
  end
end
