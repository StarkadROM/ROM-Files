RoguelikeHeadIconCell = class("RoguelikeHeadIconCell", HeadIconCell)
function RoguelikeHeadIconCell:FindObjs()
  RoguelikeHeadIconCell.super.FindObjs(self)
  local professionObj = self:FindGO("Profession")
  self.professionSp = self:FindComponent("Icon", UISprite, professionObj)
  self.professionBg = self:FindComponent("Color", UISprite, professionObj)
  self:AddCellClickEvent()
end
function RoguelikeHeadIconCell:SetData(data)
  self.gameObject:SetActive(data ~= nil)
  if not data then
    return
  end
  local headData = HeadImageData.new()
  headData:TransByRoguelikeUserData(data)
  local iconData = headData.iconData
  if iconData.type == HeadImageIconType.Avatar then
    RoguelikeHeadIconCell.super.SetData(self, iconData)
  elseif iconData.type == HeadImageIconType.Simple then
    RoguelikeHeadIconCell.super.SetSimpleIcon(self, iconData.icon, iconData.frameType)
    RoguelikeHeadIconCell.super.SetPortraitFrame(self, iconData.portraitframe)
  end
  local proData = data and data.profession and Table_Class[data.profession]
  self:SetProfession(proData)
end
function RoguelikeHeadIconCell:SetProfession(proData)
  IconManager:SetNewProfessionIcon(proData.icon, self.professionSp)
  self.professionBg.color = ColorUtil[string.format("CareerIconBg%s", proData.Type)] or ColorUtil.CareerIconBg0
end
function RoguelikeHeadIconCell:SetIndex(index)
  self.index = index
end
