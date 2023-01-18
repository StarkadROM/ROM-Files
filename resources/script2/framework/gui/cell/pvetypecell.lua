local baseCell = autoImport("BaseCell")
autoImport("PveCrackTypeCell")
local _RaidTypeConfig = GameConfig.Pve.RaidType
local _RedTipProxy, _EntranceRedTipEnum
PveTypeCell = class("PveTypeCell", baseCell)
function PveTypeCell:Init()
  _RedTipProxy = RedTipProxy.Instance
  _EntranceRedTipEnum = SceneTip_pb.EREDSYS_PVERAID_ENTRANCE
  PveTypeCell.super.Init(self)
  self:FindObj()
end
function PveTypeCell:FindObj()
  self.content = self:FindGO("Content")
  self.crackBtn = self:FindGO("CrackBtn", self.content)
  self.crackRoot = self:FindGO("CrackRoot")
  self.crackGrid = self:FindComponent("CrackGrid", UIGrid, self.crackRoot)
  self.crackBg = self:FindComponent("CrackBg", UISprite, self.crackRoot)
  self.crackGridCtl = UIGridListCtrl.new(self.crackGrid, PveCrackTypeCell, "PveCrackTypeCell")
  self.crackGridCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickCrackCell, self)
  self.crackCells = self.crackGridCtl:GetCells()
  self.newObj = self:FindGO("New", self.content)
  self.nameLab = self:FindComponent("NameLab", UILabel, self.content)
  self.extraLab = self:FindComponent("Extra", UILabel, self.content)
  self.lockObj = self:FindGO("lockObj", self.content)
  self.texture = self:FindComponent("Texture", UITexture, self.content)
  self.choosenObj = self:FindGO("Choosen", self.content)
  self.multiplySymbol = self:FindGO("MultiplySymbol")
  self.multiplySymbol_label = self:FindComponent("muLabel", UILabel, self.multiplySymbol.gameObject)
  self.bg = self:FindGO("Bg", self.content)
  self:SetEvent(self.bg, function()
    if self.groupid and not self.data:IsCrack() then
      _RedTipProxy:SeenNew(_EntranceRedTipEnum, self.groupid)
      self.redtip:SetActive(false)
    end
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self.redtip = self:FindGO("redtip")
  self.crackRoot:SetActive(false)
end
function PveTypeCell:OnClickCrackCell(cell)
  self:SetData(cell.data)
  self:PassEvent(MouseEvent.MouseClick, self)
  self:UpdateCrackChoose(self.data.id)
end
local tempV3, tempRot = LuaVector3(), LuaQuaternion()
function PveTypeCell:ReverseCrack()
  local active = self.crackRoot.activeSelf
  self.crackRoot:SetActive(not active)
  local zRotation = active and 0 or 180
  LuaVector3.Better_Set(tempV3, 0, 0, zRotation)
  LuaQuaternion.Better_SetEulerAngles(tempRot, tempV3)
  self.crackBtn.transform.localRotation = tempRot
end
function PveTypeCell:UpdateCrack()
  local isCrack = self.data:IsCrack()
  self.crackBtn:SetActive(isCrack)
  if not isCrack then
    return
  end
  local crackData = PveEntranceProxy.Instance:GetAllCrackEntranceData()
  self.crackGridCtl:ResetDatas(crackData)
  self.crackBg.height = #crackData * 48
  local entranceData = PveEntranceProxy.Instance:GetCurCrackRaidFirstEnternceData()
  self:UpdateCrackChoose(entranceData.id)
end
function PveTypeCell:UpdateCrackChoose(id)
  for i = 1, #self.crackCells do
    self.crackCells[i]:SetChoosen(id)
  end
end
function PveTypeCell:UpdateUnlock()
  if not self.data then
    return
  end
  local open = self.data:IsOpen()
  self.lockObj:SetActive(not open)
  if open then
    self.extraLab.text = string.format(ZhString.Pve_RecommendLv, self.data.lv)
  else
    self.extraLab.text = string.format(ZhString.Pve_MenuLv, self.data.UnlockLv)
  end
end
function PveTypeCell:UpdateServerMerge()
  if not self.data then
    return
  end
  local isServerTimeMerge = TeamProxy.Instance:CheckRaidIdSupportDiffServer(self.data.id)
  local isRaidCombined = self.data:IsRaidCombined()
  self.serverMergeStatus:SetActive(false)
end
function PveTypeCell:SetData(entrance_data)
  self.data = entrance_data
  if not entrance_data then
    self.content:SetActive(false)
    return
  end
  self.content:SetActive(true)
  self:UpdateUnlock()
  self:UpdateCrack()
  self.nameLab.text = entrance_data.name
  local _raidTypeConfig = _RaidTypeConfig[entrance_data.groupid]
  if not _raidTypeConfig then
    redlog("检查配置 GameConfig.Pve.RaidType , ID : ", entrance_data.raidType, entrance_data.groupid)
    return
  end
  self.groupid = entrance_data.groupid
  self.textureName = _raidTypeConfig.typeIcon
  if self.textureName then
    PictureManager.Instance:SetUI(self.textureName, self.texture)
  end
  self.newObj:SetActive(entrance_data:IsNew())
  self:UpdateChoose()
  self:UpdateRewardInfo(entrance_data.staticData.GroupId)
  self:UpdateRedtip()
  if entrance_data.guideButtonId ~= nil then
    self:AddOrRemoveGuideId(self.bg, entrance_data.guideButtonId)
  end
end
function PveTypeCell:UpdateRedtip()
  local isNew = false
  local hasReward = false
  if self.data:IsCrack() then
    local crackCells = self.crackGridCtl:GetCells()
    if crackCells then
      for _, cell in ipairs(crackCells) do
        cell:UpdateRedTip()
        if _RedTipProxy:IsNew(_EntranceRedTipEnum, cell.data and cell.data.groupid) then
          isNew = true
          break
        end
        if _RedTipProxy:IsNew(SceneTip_pb.EREDSYS_PVERAID_ACHIEVE, cell.data and cell.data.groupid) then
          hasReward = true
          break
        end
      end
    end
  else
    isNew = _RedTipProxy:IsNew(_EntranceRedTipEnum, self.groupid)
    hasReward = _RedTipProxy:IsNew(SceneTip_pb.EREDSYS_PVERAID_ACHIEVE, self.groupid)
  end
  self.redtip:SetActive(isNew or hasReward)
end
function PveTypeCell:OnCellDestroy()
  if self.textureName then
    PictureManager.Instance:UnLoadUI(self.textureName, self.texture)
  end
  self:_RemoveChoosenEntranceRedTip()
end
function PveTypeCell:_RemoveChoosenEntranceRedTip()
  local isChoosenCell = self.data and self.chooseId and self.data.id == self.chooseId
  if not isChoosenCell then
    return
  end
  local isNewEntrance = _RedTipProxy:IsNew(_EntranceRedTipEnum, self.groupid)
  if not isNewEntrance then
    return
  end
  _RedTipProxy:SeenNew(_EntranceRedTipEnum, self.groupid)
end
function PveTypeCell:SetChoosen(id)
  self.chooseId = id
  self:UpdateChoose()
end
function PveTypeCell:UpdateChoose()
  if self.data and self.chooseId and self.data.id == self.chooseId then
    self.choosenObj:SetActive(true)
  else
    self.choosenObj:SetActive(false)
  end
end
local Multiply_RewardMap = {
  [1] = AERewardType.ComodoRaid,
  [2] = AERewardType.SevenRoyalFamiliesRaid,
  [4] = AERewardType.PveCard,
  [5] = AERewardType.Tower,
  [7] = AERewardType.TeamGroup
}
function PveTypeCell:UpdateRewardInfo(typeid)
  local rewardType = Multiply_RewardMap[typeid]
  if rewardType == nil then
    self.multiplySymbol:SetActive(false)
    return
  end
  local rewardInfo = ActivityEventProxy.Instance:GetRewardByType(rewardType)
  if rewardInfo == nil then
    self.multiplySymbol:SetActive(false)
    return
  end
  local multiply = rewardInfo:GetMultiple() or 1
  if multiply > 1 then
    self.multiplySymbol_label.text = "*" .. multiply
    self.multiplySymbol:SetActive(true)
  else
    self.multiplySymbol:SetActive(false)
  end
end
