local BaseCell = autoImport("BaseCell")
GuildApplyCell = class("GuildApplyCell", BaseCell)
GuildApplyCell.DoProgress = "GuildApplyCell_DoProgress"
autoImport("PlayerFaceCell")
function GuildApplyCell:Init()
  self.headCell = self:FindGO("PlayerHeadCell")
  self.headCell = PlayerFaceCell.new(self.headCell)
  self.name = self:FindComponent("Name", UILabel)
  self.lv = self:FindComponent("Lv", UILabel)
  self.sex = self:FindComponent("Sex", UISprite)
  self.tip = self:FindComponent("Tip", UILabel)
  local agreeButton = self:FindGO("AgreeButton")
  self:AddClickEvent(agreeButton, function(go)
    self:PassEvent(GuildApplyCell.DoProgress, {self, true})
  end)
  local refuseButton = self:FindGO("RefuseButton")
  self:AddClickEvent(refuseButton, function(go)
    self:PassEvent(GuildApplyCell.DoProgress, {self, false})
  end)
end
function GuildApplyCell:SetData(data)
  self.data = data
  if data then
    local headData = HeadImageData.new()
    headData:TransByGuildMemberData(data)
    self.headCell:SetData(headData)
    self.name.text = data.name
    self.lv.text = string.format("Lv.%s", data.baselevel)
    self.sex.spriteName = data:IsBoy() and "friend_icon_man" or "friend_icon_woman"
    if data:IsMercenaryApply() then
      self.tip.text = ZhString.GuildApplyListMercenary
    else
      self.tip.text = ZhString.GuildApplyListMember
    end
  end
end
