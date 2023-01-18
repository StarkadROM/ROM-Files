local _chooseColorFormat = "[c][1F74BF]%s[-][/c]"
local _unChooseColorFormat = "[c][383838]%s[-][/c]"
local baseCell = autoImport("BaseCell")
PveCrackTypeCell = class("PveCrackTypeCell", baseCell)
function PveCrackTypeCell:Init()
  PveCrackTypeCell.super.Init(self)
  self:FindObj()
end
function PveCrackTypeCell:FindObj()
  self.label = self:FindComponent("Label", UILabel)
  self.sp = self:FindComponent("Sprite", UISprite)
  self.redTipGO = self:FindGO("RedTip")
  if not self.redTipGO then
    self.redTipGO = Game.AssetManager_UI:CreateAsset(RedTip.resID, self.gameObject)
    if self.redTipGO then
      LuaGameObject.SetLocalPositionGO(self.redTipGO, 100, 0, 0)
    end
  end
  self:AddClickEvent(self.label.gameObject, function()
    local proxy = RedTipProxy.Instance
    if proxy:IsNew(SceneTip_pb.EREDSYS_PVERAID_ENTRANCE, self.data.groupid) then
      proxy:SeenNew(SceneTip_pb.EREDSYS_PVERAID_ENTRANCE, self.data.groupid)
    end
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end
function PveCrackTypeCell:SetData(entrance_data)
  self.data = entrance_data
  if not entrance_data then
    self:Hide(self.label)
    return
  end
  self:Show(self.label)
  self.label.text = entrance_data.name
  self:UpdateChoose()
  self:UpdateRedTip()
end
function PveCrackTypeCell:SetChoosen(id)
  self.chooseId = id
  self:UpdateChoose()
end
function PveCrackTypeCell:UpdateChoose()
  local textFormat
  if self.data and self.chooseId and self.data.id == self.chooseId then
    textFormat = _chooseColorFormat
    ColorUtil.WhiteUIWidget(self.sp)
  else
    textFormat = _unChooseColorFormat
    ColorUtil.BlackLabel(self.sp)
  end
  self.label.text = string.format(textFormat, self.data.name)
end
function PveCrackTypeCell:UpdateRedTip()
  if not self.redTipGO then
    return
  end
  if RedTipProxy.Instance:IsNew(SceneTip_pb.EREDSYS_PVERAID_ENTRANCE, self.data.groupid) then
    self.redTipGO:SetActive(true)
  else
    self.redTipGO:SetActive(false)
  end
end
