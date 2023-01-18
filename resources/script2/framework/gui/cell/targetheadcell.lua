autoImport("PlayerFaceCell")
TargetHeadCell = class("TargetHeadCell", PlayerFaceCell)
TargetHeadEvent = {
  CancelChoose = "TargetHeadEvent_CancelChoose"
}
MonsterTextColorConfig = {
  Level = {H = 15, L = 20},
  Color = {
    H = Color(0.9882352941176471, 0.1607843137254902, 0.20392156862745098),
    N = Color(1, 1, 1),
    L = Color(1, 1, 1)
  },
  EffectColor = {
    H = Color(0.3686274509803922, 0 / 255, 0.03137254901960784),
    N = Color(0.4549019607843137, 0.6039215686274509, 0.7686274509803922),
    L = Color(0.4549019607843137, 0.6039215686274509, 0.7686274509803922)
  }
}
function TargetHeadCell:ctor(go)
  local contentGO = self:FindGO("Content", go)
  TargetHeadCell.super.ctor(self, contentGO)
end
function TargetHeadCell:Init()
  TargetHeadCell.super.Init(self)
  self.lvmat = "%s"
  self.headIconCell:HideFrame()
  self.headBg = self:FindComponent("HeadBg", UISprite)
  self.restTip = self:FindGO("RestTip")
  self.restTime = self:FindComponent("RestTime", UILabel)
  self.levelObj = self:FindGO("level")
  self:SetData(nil)
  self.cancelChoose = self:FindGO("CancelChoose")
  self:AddClickEvent(self.cancelChoose, function(go)
    self:PassEvent(TargetHeadEvent.CancelChoose, self)
  end)
  self.redFrame = self:FindGO("Red")
  self.nature = self:FindComponent("nature", UISprite)
end
function TargetHeadCell:InitHeadIconCell()
  self.headIconCell = MainViewHeadIconCell.new()
  self.headIconCell:CreateSelf(self.gameObject)
  self.headIconCell:SetMinDepth(3)
  self.headIconCell:IsPet(true)
end
function TargetHeadCell:SetData(data)
  TargetHeadCell.super.SetData(self, data)
  if self.nature then
    local natureIcon = self.data and self.data.isMonster and self.data.nature
    if natureIcon and natureIcon ~= "" then
      self.nature.gameObject:SetActive(true)
      IconManager:SetUIIcon(natureIcon, self.nature)
    else
      self.nature.gameObject:SetActive(false)
    end
  end
end
function TargetHeadCell:RefreshSelf(data)
  local data = data or self.data
  self.parentObj = self.gameObject.transform.parent.gameObject
  if data == nil or data:IsEmpty() then
    self.parentObj:SetActive(false)
    return
  end
  self.parentObj:SetActive(true)
  TargetHeadCell.super.RefreshSelf(self, data)
  if data.isMonster then
    self:RefreshLevelColor()
    local boss = Table_Boss[data.id]
    if boss and boss.Type == 4 then
      self:UpdateHeadBg(4)
    else
      self:UpdateHeadBg(2)
    end
    local monster = Table_Monster[data.id]
    if monster and monster.Features and monster.Features & 1024 > 0 then
      self.level.text = "Lv.???"
    end
  elseif data.camp == RoleDefines_Camp.ENEMY then
    self:UpdateHeadBg(3)
  else
    self:UpdateLevelColor(MonsterTextColorConfig.Color.N, MonsterTextColorConfig.EffectColor.N)
    self:UpdateHeadBg(2)
  end
  local headType = data:GetCustomParam("HeadType")
  if headType == MainViewHeadPage.HeadType.Pet or headType == MainViewHeadPage.HeadType.Being then
    self:UpdatePetHead()
    self:UpdateHeadBg(2)
  elseif headType == MainViewHeadPage.HeadType.Boki then
    self:UpdatePetHead()
  end
  if self.hp then
    self.hp.gameObject:SetActive(headType == MainViewHeadPage.HeadType.Pet or headType == MainViewHeadPage.HeadType.Being or headType == MainViewHeadPage.HeadType.Boki)
  end
  if data.isNpc then
    self.level.text = ""
    self.levelObj:SetActive(false)
  else
    self.levelObj:SetActive(true)
  end
  self.cancelChoose:SetActive(headType == MainViewHeadPage.HeadType.LockTarget)
end
function TargetHeadCell:UpdateHeadBg(headType)
  if self.headBg == nil then
    return
  end
  if headType == 3 then
    self.redFrame:SetActive(true)
  else
    self.redFrame:SetActive(false)
  end
end
function TargetHeadCell:UpdateSpecialFrame(headType)
  if headType == MainViewHeadPage.HeadType.Pet then
    self.headBg.spriteName = "new-main_bg_headframe_pet"
    self.headBg.color = LuaGeometry.GetTempColor()
  else
    self.headBg.spriteName = "new-main_bg_headframe_02"
  end
end
function TargetHeadCell:RefreshLevelColor()
  if self.data and self.data.level and self.level then
    local myself = Game.Myself
    local mylv = myself.data.userdata:Get(UDEnum.ROLELEVEL)
    local deltalv = mylv - self.data.level
    if deltalv >= MonsterTextColorConfig.Level.L then
      self:UpdateLevelColor(MonsterTextColorConfig.Color.L, MonsterTextColorConfig.EffectColor.L)
    elseif deltalv <= -1 * MonsterTextColorConfig.Level.H then
      self:UpdateLevelColor(MonsterTextColorConfig.Color.H, MonsterTextColorConfig.EffectColor.H)
    else
      self:UpdateLevelColor(MonsterTextColorConfig.Color.N, MonsterTextColorConfig.EffectColor.N)
    end
  end
end
function TargetHeadCell:UpdateLevelColor(levelColor, levelEffectColor)
  if self._levelColor == levelColor and self._levelEffectColor == levelEffectColor then
    return
  end
  self._levelColor = levelColor
  self._levelEffectColor = levelEffectColor
  self.level.color = self._levelColor
  self.level.effectColor = self._levelEffectColor
end
function TargetHeadCell:UpdatePetHead()
  self:UpdateRestTip(self.data:GetCustomParam("relivetime"))
  self:UpdateHp()
end
function TargetHeadCell:UpdateRestTip(resttime)
  if type(self.data) ~= "table" then
    self.restTip:SetActive(false)
    self:RemoveRestTimeTick()
    return
  end
  resttime = resttime or 0
  local curtime = ServerTime.CurServerTime() / 1000
  local restSec = resttime - curtime
  if restSec > 0 then
    self.restTip:SetActive(true)
    if not self.restTimeTick then
      self.restTimeTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateRestTime, self, 1111)
    end
    self:SetIconActive(false)
    self.name.gameObject:SetActive(false)
    if self.hp then
      self.hp.gameObject:SetActive(false)
    end
  else
    self.restTip:SetActive(false)
    self:RemoveRestTimeTick()
    if self.hp then
      self.hp.gameObject:SetActive(true)
    end
  end
end
function TargetHeadCell:UpdateRestTime()
  if type(self.data) ~= "table" then
    self.restTip:SetActive(false)
    self:RemoveRestTimeTick()
    return
  end
  local resttime = self.data and self.data:GetCustomParam("relivetime")
  resttime = resttime or 0
  local restSec = resttime - ServerTime.CurServerTime() / 1000
  if restSec > 0 then
    local min, sec = ClientTimeUtil.GetFormatSecTimeStr(restSec)
    self.restTime.text = string.format(ZhString.TMInfoCell_RestTip, min, sec)
  else
    self:RemoveRestTimeTick()
  end
end
function TargetHeadCell:RemoveRestTimeTick()
  if self.restTimeTick then
    TimeTickManager.Me():ClearTick(self, 1111)
    self.restTimeTick = nil
    self.restTime.text = ""
  end
  if self.data and self.data.offline ~= true then
    self:SetIconActive(true, true)
  else
    self:SetIconActive(false, false)
  end
  self.name.gameObject:SetActive(true)
end
function TargetHeadCell:UpdateHp()
  if self.data == nil then
    return
  end
  local headType = self.data:GetCustomParam("HeadType")
  if headType ~= MainViewHeadPage.HeadType.Pet and headType ~= MainViewHeadPage.HeadType.Being and headType ~= MainViewHeadPage.HeadType.Boki then
    return
  end
  local npet = NScenePetProxy.Instance:Find(self.data.guid)
  if npet then
    local props = npet.data.props
    if props then
      local hp = props:GetPropByName("Hp"):GetValue()
      local maxhp = props:GetPropByName("MaxHp"):GetValue()
      self.data.hp = hp / maxhp
      if headType == MainViewHeadPage.HeadType.Boki then
        self:SetIconActive(0 ~= hp, 0 ~= hp)
      end
    end
  else
    self.data.hp = 0
    self:SetIconActive(false, false)
  end
  TargetHeadCell.super.UpdateHp(self, self.data.hp)
end
function TargetHeadCell:SetIconActive(b1, b2)
  TargetHeadCell.super.SetIconActive(self, b1, b2)
end
