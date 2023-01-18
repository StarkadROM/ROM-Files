autoImport("BaseItemCell")
MyselfEquipItemCell = class("MyselfEquipItemCell", BaseItemCell)
local MaxRefine = 15
local equipTypeCfg, equipPosCdCfg = GameConfig.EquipType, GameConfig.EquipPosCD
local myselfIns
function MyselfEquipItemCell:ctor(obj, index, isfashion)
  if not myselfIns then
    myselfIns = MyselfProxy.Instance
  end
  if index then
    self.index = index
  else
    LogUtility.Warning("index is nil while initializing MyselfEquipItemCell!")
  end
  MyselfEquipItemCell.super.ctor(self, obj)
  self.isfashion = isfashion or false
  if self.index then
    local spname
    if index == 5 or index == 6 then
      spname = "bag_equip_6"
    else
      spname = "bag_equip_" .. self.index
    end
    self.symbol = self:FindComponent("Symbol", UISprite)
    IconManager:SetUIIcon(spname, self.symbol)
    self.symbol:MakePixelPerfect()
  end
  self.itemRoot = self:FindGO("ItemRoot")
  self.siteRoot = self:FindGO("SiteRoot")
  self.noEffect = self:FindGO("NoEffect")
  self.offForbid = self:FindGO("OffForbid")
  self.siteStrenthenLv = self:FindComponent("StrengthenLv", UILabel)
  self.siteStrenthenLv2 = self:FindComponent("StrengthenLv2", UILabel)
  self.forbidColdDown = self:FindComponent("ForbidColdDown", UISprite)
  self:AddCellClickEvent()
  self:AddCellDoubleClickEvt()
end
function MyselfEquipItemCell:SetData(data)
  MyselfEquipItemCell.super.SetData(self, data)
  if self.isPureSite then
    return
  end
  self:UpdateMyselfInfo(data)
  if data and data.staticData then
    local equipType = data.equipInfo.equipData.EquipType
    local config = equipTypeCfg[equipType]
    if config then
      local site = config.site
      local isPosRight = false
      for k, v in pairs(site) do
        if v == data.index then
          isPosRight = true
        end
      end
      if isPosRight == false and self.invalid then
        self:SetActive(self.invalid, true)
      end
    end
    if self.isfashion and not Slua.IsNull(self.noEffect) then
      self.noEffect:SetActive(not self:IsEffective())
    end
    if data.equipInfo and data.equipInfo.strengthlv > 0 then
      self.siteStrenthenLv.text = data.equipInfo.strengthlv
    else
      self.siteStrenthenLv.text = ""
    end
    self:UpdateStrengthLevelByPlayer()
    self:UpdateRefineLevelByPlayer()
    self:Hide(self.symbol)
    if self.siteStrenthenLv2 then
      self.siteStrenthenLv2.text = ""
    end
  else
    local isInStrengthView = StrengthProxy.Instance:IsPackageStrengthenShow()
    local lv = StrengthProxy.Instance:GetStrengthLvByPos(SceneItem_pb.ESTRENGTHTYPE_NORMAL, self.index)
    if lv == nil or lv == 0 or not isInStrengthView then
      self.siteStrenthenLv.text = ""
    else
      self.siteStrenthenLv.text = lv
    end
    if self.siteStrenthenLv2 then
      local lv2 = StrengthProxy.Instance:GetStrengthLvByPos(SceneItem_pb.ESTRENGTHTYPE_GUILD, self.index)
      if lv2 == nil or lv2 == 0 or not isInStrengthView then
        self.siteStrenthenLv2.text = ""
      else
        self.siteStrenthenLv2.text = lv2
      end
    end
    self:Show(self.symbol)
  end
  self:UpdateEquipUpgradeTip()
end
function MyselfEquipItemCell:ShowPureSite(active)
  self:addGuideButtonId()
  if nil == self.normalItem or nil == self.empty then
    return
  end
  self.isPureSite = active
  if active and self.index <= StrengthProxy.MaxPos then
    local lv = StrengthProxy.Instance:GetStrengthLvByPos(SceneItem_pb.ESTRENGTHTYPE_NORMAL, self.index)
    self:UpdateSiteStrengthenLv(lv)
    self:Show(self.symbol)
  else
    self.siteStrenthenLv.text = ""
    if self.data and self.data.staticData then
      self:Hide(self.symbol)
    else
      self:Show(self.symbol)
    end
  end
  self.itemRoot:SetActive(not active)
end
function MyselfEquipItemCell:UpdateSiteStrengthenLv(level)
  self.siteStrenthenLv.text = level > 0 and level or ""
end
function MyselfEquipItemCell:IsEffective()
  if self.data then
    local roleEquipBag = BagProxy.Instance:GetRoleEquipBag()
    local equip = roleEquipBag:GetEquipBySite(self.index)
    if equip then
      return equip.equipInfo.equipData.Type == self.data.equipInfo.equipData.Type
    end
  end
  return true
end
function MyselfEquipItemCell:GetCD()
  local onCdTime = self:GetEquipPosOnCdTime()
  if onCdTime then
    return onCdTime
  end
  if self.data == nil then
    local stateTime = myselfIns:GetEquipPos_StateTime(self.index)
    if stateTime and stateTime.offendtime then
      local delta = ServerTime.ServerDeltaSecondTime(stateTime.offendtime * 1000)
      if delta > 0 then
        return delta
      end
    end
  end
  return MyselfEquipItemCell.super.GetCD(self)
end
function MyselfEquipItemCell:GetMaxCD()
  local onCdTime = self:GetEquipPosOnCdTime()
  if onCdTime then
    local maxCd = equipPosCdCfg[self.index]
    if maxCd then
      return maxCd
    end
  end
  if self.data == nil then
    local stateTime = myselfIns:GetEquipPos_StateTime(self.index)
    if stateTime and stateTime.offduration then
      return stateTime.offduration
    end
  end
  return MyselfEquipItemCell.super.GetMaxCD(self)
end
function MyselfEquipItemCell:RefreshCD(f)
  local onCdTime = self:GetEquipPosOnCdTime()
  if self.data == nil then
    self:TrySetShowOffForbid(f > 0 and not onCdTime)
    if self.forbidColdDown then
      self.forbidColdDown.fillAmount = f
    end
    return f == 0
  else
    self:TrySetShowOffForbid(false)
    if onCdTime then
      self.coldDown.fillAmount = f
      return onCdTime <= 0
    end
    return MyselfEquipItemCell.super.RefreshCD(self, f)
  end
end
function MyselfEquipItemCell:UpdateTwelveInfo()
  if self.refinelv then
    self.refinelv.gameObject:SetActive(true)
    self.refinelv.text = string.format("+%d", MaxRefine)
  end
end
function MyselfEquipItemCell:GetEquipPosOnCdTime()
  return myselfIns:GetEquipPosOnCdTime(self.index)
end
function MyselfEquipItemCell:TrySetShowOffForbid(isShow)
  isShow = isShow and true or false
  if not Slua.IsNull(self.offForbid) then
    self.offForbid:SetActive(isShow)
  end
end
function MyselfEquipItemCell:UpdateStrengthLevelByPlayer(playerId)
  if BlackSmithProxy.CheckShowStrengthBuffUpLevel(self.data, playerId) then
    local getFunc = BlackSmithProxy.GetStrengthBuffUpLevel
    local withLimitBuffUpLv, withoutLimitBuffUpLv = getFunc(self.index, playerId, true), getFunc(self.index, playerId, false)
    local player = playerId and SceneCreatureProxy.FindCreature(playerId) or Game.Myself
    local strengthLv = BlackSmithProxy.CalculateBuffUpLevel(self.data.equipInfo.strengthlv or 0, player.data.userdata:Get(UDEnum.ROLELEVEL), withLimitBuffUpLv, withoutLimitBuffUpLv)
    self:UpdateStrengthLevel(strengthLv, withLimitBuffUpLv + withoutLimitBuffUpLv > 0)
  end
end
function MyselfEquipItemCell:UpdateRefineLevelByPlayer(playerId)
  if self.data and self.data.staticData and ItemUtil.IsGVGSeasonEquip(self.data.staticData.id) or BlackSmithProxy.CheckShowRefineBuffUpLevel(self.data, playerId) then
    local getFunc = BlackSmithProxy.GetRefineBuffUpLevel
    local withLimitBuffUpLv, withoutLimitBuffUpLv = getFunc(self.index, playerId, true), getFunc(self.index, playerId, false)
    local refinelv = self.data.equipInfo.refinelv or 0
    local maxRefineLv = BlackSmithProxy.Instance:MaxRefineLevelByData(self.data.staticData)
    if PvpProxy.Instance:IsFreeFire() then
      refinelv = MaxRefine
    end
    refinelv = BlackSmithProxy.CalculateBuffUpLevel(refinelv, maxRefineLv, withLimitBuffUpLv, withoutLimitBuffUpLv)
    self:UpdateRefineLevel(refinelv, withLimitBuffUpLv + withoutLimitBuffUpLv > 0)
  end
end
function MyselfEquipItemCell:UpdateRefineLevel(refinelv, withBuff)
  if PvpProxy.Instance:IsFreeFire() and refinelv < MaxRefine then
    local maxRefineIndexes = GameConfig.TwelvePvp.FullRefinePos
    if self.index and maxRefineIndexes and TableUtil.HasValue(maxRefineIndexes, self.index) then
      refinelv = MaxRefine
    end
  end
  MyselfEquipItemCell.super.UpdateRefineLevel(self, refinelv, withBuff)
end
function MyselfEquipItemCell:addGuideButtonId()
  if GameConfig.SpecialGuide_Bag_QuestId == nil or #GameConfig.SpecialGuide_Bag_QuestId <= 0 then
    return
  end
  local questData
  for _, v in ipairs(GameConfig.SpecialGuide_Bag_QuestId) do
    questData = FunctionGuide.Me():checkHasGuide(v)
    if questData == nil then
    end
  end
  if questData ~= nil then
    local guideId = questData.params.guideID
    local tbGuide = Table_GuideID[guideId]
    if tbGuide ~= nil and tbGuide.SpecialID == self.index then
      if self.index == 7 then
        self:AddOrRemoveGuideId(self.gameObject, 1003)
      elseif self.index == 5 then
        self:AddOrRemoveGuideId(self.gameObject, 1005)
      end
    end
  end
end
