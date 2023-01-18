local _TextureName = "Sevenroyalfamilies_bg_decoration4"
PveAchievementCell = class("PveAchievementCell", BaseCell)
function PveAchievementCell:Init()
  PveAchievementCell.super.Init(self)
  self:FindObj()
  self:AddEvt()
end
function PveAchievementCell:FindObj()
  self.bgImg = self:FindComponent("Bg", UISprite)
  self.descLab = self:FindComponent("DescLab", UILabel)
  self.grid = self:FindComponent("Grid", UIGrid)
  self.texture = self:FindComponent("Texture", UITexture)
  self.extraDesc = self:FindComponent("ExtraDesc", UILabel)
  self.receiveBtn = self:FindGO("receiveBtn"):GetComponent(UIButton)
  self.receiveLabel = self:FindGO("receiveLabel"):GetComponent(UILabel)
  self:AddClickEvent(self.receiveBtn.gameObject, function()
    if self.data then
      ServiceFuBenCmdProxy.Instance:CallPickupPveRaidAchieveFubenCmd(self.data.GroupId, self.data.id)
    end
  end)
  self.status = self:FindGO("status")
end
function PveAchievementCell:AddEvt()
  self.gridCtrl = UIGridListCtrl.new(self.grid, ItemCell, "ItemCell")
  self.gridCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickItemCell, self)
end
function PveAchievementCell:SetData(data)
  if not data or not Table_PveRaidAchievement[data] then
    return
  end
  self.data = Table_PveRaidAchievement[data]
  PictureManager.Instance:SetUI(_TextureName, self.texture)
  local done = PveEntranceProxy.Instance:CheckDone(self.data.GroupId, self.data.id)
  if done then
    self:Show(self.texture)
    self.bgImg.enabled = false
    self:Hide(self.receiveBtn.gameObject)
    self:Show(self.status)
  elseif done == false then
    self:Show(self.receiveBtn.gameObject)
    self.receiveBtn.isEnabled = true
    self.receiveLabel.text = ZhString.Pve_Reward
    self.receiveLabel.effectColor = ColorUtil.ButtonLabelOrange
    self:Hide(self.status)
  else
    self:Hide(self.texture)
    self.bgImg.enabled = true
    self:Show(self.receiveBtn.gameObject)
    self.receiveBtn.isEnabled = false
    self.receiveLabel.text = ZhString.Pve_Reward
    self.receiveLabel.effectColor = ColorUtil.TitleGray
    self:Hide(self.status)
  end
  self.descLab.text = self.data.desc
  if self.data.extraReward and self.data.extraReward == 1 then
    self.extraDesc.text = self.data.extraDesc or ""
    self.gridCtrl:ResetDatas({})
  else
    local staticReward = ItemUtil.GetRewardItemIdsByTeamId(self.data.rewardid) or {}
    local rewardData = {}
    local itemData
    for i = 1, #staticReward do
      local itemData = ItemData.new("PveAchievementReward", staticReward[i].id)
      itemData:SetItemNum(staticReward[i].num)
      rewardData[#rewardData + 1] = itemData
    end
    self.gridCtrl:ResetDatas(rewardData)
    self.extraDesc.text = ""
  end
end
function PveAchievementCell:OnClickItemCell(cellctl)
  if cellctl and cellctl ~= self.chooseReward then
    local data = cellctl.data
    local stick = cellctl.gameObject:GetComponent(UIWidget)
    if data then
      local callback = function()
        self:CancelChooseReward()
      end
      local sdata = {
        itemdata = data,
        funcConfig = {},
        callback = callback,
        ignoreBounds = {
          cellctl.gameObject
        }
      }
      TipManager.Instance:ShowItemFloatTip(sdata, stick, NGUIUtil.AnchorSide.Left, {-250, 0})
    end
    self.chooseReward = cellctl
  else
    self:CancelChooseReward()
  end
end
function PveAchievementCell:CancelChooseReward()
  self.chooseReward = nil
  self:ShowItemTip()
end
function PveAchievementCell:OnRemove()
  PictureManager.Instance:UnLoadUI(_TextureName, self.texture)
end
