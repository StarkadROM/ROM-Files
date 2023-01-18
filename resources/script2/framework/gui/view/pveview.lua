local _BgTextureName = "calendar_bg1_picture2"
local _EntranceProxy
local _PopUpItemConfig = {}
local _BtnDropMonster = {
  ChoosenSp = "recharge_btn_1",
  UnchoosenSp = "recharge_btn_2",
  ChoosenColor = Color(0.7019607843137254, 0.4196078431372549, 0.1411764705882353, 1),
  UnchoosenColor = Color(0.24313725490196078, 0.34901960784313724, 0.6549019607843137, 1)
}
local _DetailTexture = "shop_bg_05"
local _ChallengeRedColor = Color(0.8941176470588236, 0.34901960784313724, 0.23921568627450981, 1)
local _PveGroupTogColor = {
  [1] = Color(0.12156862745098039, 0.4549019607843137, 0.7490196078431373, 1),
  [2] = Color(0.5137254901960784, 0.34901960784313724, 0.7647058823529411, 1)
}
local _PveConfig = GameConfig.Pve
local _SetLocalPositionGo = LuaGameObject.SetLocalPositionGO
local _GetLocalPositionGo = LuaGameObject.GetLocalPositionGO
local ERedSys = SceneTip_pb.EREDSYS_PVERAID_ACHIEVE
autoImport("PveTypeCell")
autoImport("PveDropItemCell")
autoImport("PveMonsterCell")
autoImport("PveDifficultyCell")
autoImport("HappyShopBuyItemCell")
PveView = class("PveView", ContainerView)
PveView.ViewType = UIViewType.NormalLayer
function PveView:Init()
  self:InitStatic()
  _EntranceProxy = PveEntranceProxy.Instance
  _RedTipProxy = RedTipProxy.Instance
  _EntranceProxy:PreprocessTable()
  self.root = self:FindGO("Root")
  self.root:SetActive(false)
  self.loadingRoot = self:FindGO("LoadingRoot")
  self.loadingRoot:SetActive(true)
  self:AddEvt()
  self:InitBuyItemCell()
end
function PveView:_Init()
  self:FindObj()
  self:AddUIEvts()
end
function PveView:InitStatic()
  self.pveCardRewardMultiples = GameConfig.NewPveRaid and GameConfig.NewPveRaid.MultiTimes or 3
end
function PveView:FindObj()
  self.nameLab = self:FindComponent("NameLab", UILabel)
  self.raidHelpBtn = self:FindGO("RaidHelpTip")
  self.bgTexture = self:FindComponent("BgTexture", UITexture)
  PictureManager.Instance:SetUI(_BgTextureName, self.bgTexture)
  self.dropBtn = self:FindComponent("DropItemBtn", UISprite)
  self.trebleReward = self:FindComponent("TrebleReward", UILabel, self.dropBtn.gameObject)
  self.trebleReward.text = "x" .. tostring(self.pveCardRewardMultiples)
  self.dropBtnLab = self:FindComponent("Label", UILabel, self.dropBtn.gameObject)
  self.curBtnSprite = self.dropBtn
  self.monsterBtn = self:FindComponent("MonsterBtn", UISprite)
  self.monsterBtnLab = self:FindComponent("Label", UILabel, self.monsterBtn.gameObject)
  self.matchBtn = self:FindGO("MatchBtn")
  self.matchBtnLab = self:FindComponent("Label", UILabel, self.matchBtn)
  self.challengeBtn = self:FindGO("ChallengeBtn")
  self:AddOrRemoveGuideId(self.challengeBtn, 489)
  self:AddOrRemoveGuideId(self.challengeBtn, 493)
  self.challengeBtnLab = self:FindComponent("Label", UILabel, self.challengeBtn)
  self.publishBtn = self:FindGO("PublishBtn")
  self.recommendPlayerNumLab = self:FindComponent("RecommendPlayerNum", UILabel)
  self.challengeNumLab = self:FindComponent("ChallengeNum", UILabel)
  self:InitPveCard_AddTime()
  self.pvecardProgress = self:FindComponent("PveCardProgress", UILabel, self.root)
  self.pvecardGroup = self:FindGO("PveCardGroup")
  self.tog1Lab = self:FindComponent("Tog1", UILabel, self.pvecardGroup)
  self:AddClickEvent(self.tog1Lab.gameObject, function()
    self:OnPveCardTabChange(0)
  end)
  self.tog1Bg = self:FindGO("SpriteBg", self.tog1Lab.gameObject)
  self.tog2Lab = self:FindComponent("Tog2", UILabel, self.pvecardGroup)
  self:AddClickEvent(self.tog2Lab.gameObject, function()
    self:OnPveCardTabChange(1)
  end)
  self.tog2Bg = self:FindGO("SpriteBg", self.tog2Lab.gameObject)
  self.expPanel = self:FindGO("ExpPanel")
  self.baseExp_fixedLab = self:FindComponent("BaseExpFixed", UILabel, self.expPanel)
  self.baseExpValue = self:FindComponent("BaseExpDeltaLab", UILabel, self.expPanel)
  self.jobExp_fixedLab = self:FindComponent("JobExpFixed", UILabel, self.expPanel)
  self.jobExpValue = self:FindComponent("JobExpDeltaLab", UILabel, self.expPanel)
  self.baseExp_SliderGo = self:FindGO("BaseExpSlider", self.expPanel)
  self.baseExp_Slider = self.baseExp_SliderGo:GetComponent(UISlider)
  self.baseExp_MaxWidth = self.baseExp_Slider.foregroundWidget.width
  self.baseExp_Animation = self:FindGO("AnimSp", self.baseExp_SliderGo)
  self.baseExp_AddSp = self:FindComponent("AddValueSp", UISprite, self.baseExp_SliderGo)
  self.baseExp_AddSp_OffsetX = _GetLocalPositionGo(self.baseExp_Slider.foregroundWidget.gameObject)
  self.baseExp_CoverSp = self:FindComponent("CoverValueSp", UISprite, self.baseExp_SliderGo)
  self.jobExp_SliderGo = self:FindGO("JobExpSlider", self.expPanel)
  self.jobExp_Slider = self.jobExp_SliderGo:GetComponent(UISlider)
  self.jobExp_MaxWidth = self.jobExp_Slider.foregroundWidget.width
  self.jobExp_Animation = self:FindGO("AnimSp", self.jobExp_SliderGo)
  self.jobExp_AddSp = self:FindComponent("AddValueSp", UISprite, self.jobExp_SliderGo)
  self.jobExp_AddSp_OffsetX = _GetLocalPositionGo(self.jobExp_Slider.foregroundWidget.gameObject)
  self.jobExp_CoverSp = self:FindComponent("CoverValueSp", UISprite, self.jobExp_SliderGo)
  self.detailIcon = self:FindComponent("DetailIcon", UISprite)
  self.fixed_DetailTexture = self:FindComponent("Fixed_DetailTexture", UITexture, self.root)
  PictureManager.Instance:SetUI(_DetailTexture, self.fixed_DetailTexture)
  self.starRoot = self:FindGO("StarRoot")
  self.stars = {}
  for i = 1, 3 do
    local msp = self:FindGO("Star" .. i):GetComponent(UIMultiSprite)
    table.insert(self.stars, msp)
  end
  self.checkBtn = self:FindGO("CheckBtn", self.starRoot)
  self.checkBtnLab = self:FindComponent("Label", UILabel, self.checkBtn)
  self.starRoot:SetActive(false)
  self.raidTypeTable = self:FindComponent("RaidTypeTable", UITable)
  self.pveWraplist = UIGridListCtrl.new(self.raidTypeTable, PveTypeCell, "PveTypeCell")
  self.pveWraplist:AddEventListener(MouseEvent.MouseClick, self.OnClickRaidTypeCell, self)
  self.itemScrollViewPanel = self:FindComponent("ItemScrollView", UIPanel)
  local itemGrid = self:FindComponent("ItemGrid", UIGrid, self.itemScrollViewPanel.gameObject)
  self.itemCtl = UIGridListCtrl.new(itemGrid, PveDropItemCell, "PveDropItemCell")
  self.itemCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickRewardItem, self)
  local monsterGrid = self:FindComponent("MonsterGrid", UIGrid, self.itemScrollViewPanel.gameObject)
  self.monsterCtl = UIGridListCtrl.new(monsterGrid, PveMonsterCell, "PveMonsterCell")
  self.monsterCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickPveMonster, self)
  self.emptyMonsterRoot = self:FindGO("EmptyMonsterRoot")
  local emptyMonsterLab = self:FindComponent("Label", UILabel, self.emptyMonsterRoot)
  emptyMonsterLab.text = ZhString.Pve_EmptyMonster
  local difficultyGrid = self:FindComponent("DifficultyGrid", UIGrid)
  self.difficultyCtl = UIGridListCtrl.new(difficultyGrid, PveDifficultyCell, "PveDifficultyCell")
  self.difficultyCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickDifficulty, self)
  self:SetFixedLabel()
  self:InitSomePveObj()
  self.sweepBtn = self:FindGO("SweepBtn")
  self:AddClickEvent(self.sweepBtn, function()
    if self.call_lock then
      MsgManager.ShowMsgByID(49)
      return
    end
    self:LockCall()
    self:ConfirmChallenge(function(arg)
      self:DoSweep(arg)
    end)
  end)
  self.sweepSp = self.sweepBtn:GetComponent(UISprite)
  self:AddOrRemoveGuideId(self.checkBtn.gameObject, 1028)
  self.leftTimeTip = self:FindGO("LeftTimeTip")
  self.leftTimeBord = self:FindGO("LeftTimeBord")
  self:AddClickEvent(self.leftTimeTip, function(go)
    self.leftTimeBord:SetActive(not self.leftTimeBord.activeSelf)
    self:UpdateLeftTimeInfo()
  end)
  self.battleTimeLabel = self:FindComponent("BattleTImeLabel", UILabel, self.leftTimeBord)
  self.playTimeLabel = self:FindComponent("PlayTimeLabel", UILabel, self.leftTimeBord)
end
local BattleTimeStringColor = {
  "[41c419]%s[-]",
  "[ffc945]%s[-]",
  "[cf1c0f]%s[-]"
}
function PveView:UpdateLeftTimeInfo()
  local data = ExpRaidProxy.Instance.battleTimelen
  local timeLen = math.floor(data.timelen / 60)
  local timeTotal = math.floor(data.totaltime / 60)
  self.battleTimeLabel.text = string.format(ZhString.PveView_BattleTime, string.format(BattleTimeStringColor[data.estatus or 1], timeLen), timeTotal)
  local playTimeLen = data.usedplaytime and math.floor(data.usedplaytime / 60) or 0
  local playTotalTimeLen = data.playtime and math.floor(data.playtime / 60) or 0
  self.playTimeLabel.text = string.format(ZhString.PveView_PlayTime, playTimeLen, playTotalTimeLen)
end
function PveView:InitPveCard_AddTime()
  self.pveCard_addMaxCountBtn = self:FindComponent("PVE_Card_AddMaxCountBtn", UISprite)
  self.pveCard_addMaxCountBtnSp = self:FindComponent("Sprite", UISprite, self.pveCard_addMaxCountBtn.gameObject)
  self:AddClickEvent(self.pveCard_addMaxCountBtn.gameObject, function()
    self:OnClickPveCardAddMaxCnt()
  end)
end
function PveView:InitBuyItemCell()
  self.frontPanel = self:FindGO("FrontPanel")
  local go = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("HappyShopBuyItemCell"), self.frontPanel)
  if not go then
    return
  end
  go.transform.localPosition = LuaGeometry.GetTempVector3(185, 40, 0)
  self.buyCell = HappyShopBuyItemCell.new(go)
  self.buyCell:Hide()
  local shopCfg = _PveConfig.AddPlayTimeDepositeId
  if shopCfg then
    local sType, sId = next(shopCfg)
    if sType and sId and type(sId) == "table" then
      HappyShopProxy.Instance:InitShop(Game.Myself, sId[1], sType)
    end
  end
end
function PveView:OnClickPveCardAddMaxCnt()
  local itemId = _PveConfig.AddPlayTimeItemId and _PveConfig.AddPlayTimeItemId[1] or 12390
  local d = BagProxy.Instance:GetItemByStaticID(itemId)
  if not d then
    d = BagProxy.Instance:GetItemByStaticID(itemId, BagProxy.BagType.Storage)
    d = d or BagProxy.Instance:GetItemByStaticID(itemId, BagProxy.BagType.Barrow)
  end
  if d then
    local sdata = {
      itemdata = d,
      ignoreBounds = {
        self.pveCard_addMaxCountBtnSp
      },
      applyClose = true,
      callback = function()
        ServiceNUserProxy.Instance:CallBattleTimelenUserCmd()
      end
    }
    sdata.funcConfig = FunctionItemFunc.GetItemFuncIds(itemId)
    self:ShowItemTip(sdata, self.pveCard_addMaxCountBtnSp, NGUIUtil.AnchorSide.Right, {210, 300})
  else
    local shopCfg = _PveConfig.AddPlayTimeDepositeId
    if shopCfg then
      local sType, sId = next(shopCfg)
      if sType and sId and type(sId) == "table" then
        local shopData = ShopProxy.Instance:GetShopDataByTypeId(sType, sId[1])
        if shopData then
          local goods = shopData:GetGoods()
          for k, good in pairs(goods) do
            if good.id == sId[2] then
              self.buyCell:Show()
              self.buyCell:SetData(good)
              HappyShopProxy.Instance:SetSelectId(good.id)
              return
            end
          end
        end
      end
    end
  end
end
function PveView:LockCall()
  if self.call_lock then
    return
  end
  self.call_lock = true
  if self.lock_lt == nil then
    self.lock_lt = TimeTickManager.Me():CreateOnceDelayTick(1000, function(owner, deltaTime)
      self:CancelLockCall()
    end, self)
  end
end
function PveView:CancelLockCall()
  if not self.call_lock then
    return
  end
  self.call_lock = false
  if self.lock_lt then
    self.lock_lt:Destroy()
    self.lock_lt = nil
  end
end
function PveView:LockCall()
  if self.call_lock then
    return
  end
  self.call_lock = true
  if self.lock_lt == nil then
    self.lock_lt = TimeTickManager.Me():CreateOnceDelayTick(1000, function(owner, deltaTime)
      self:CancelLockCall()
    end, self)
  end
end
function PveView:CancelLockCall()
  if not self.call_lock then
    return
  end
  self.call_lock = false
  if self.lock_lt then
    self.lock_lt:Destroy()
    self.lock_lt = nil
  end
end
function PveView:DoSweep(sufficientTime)
  if not self.curData then
    return
  end
  local raidid = self.curData.difficultyRaid
  if self.curData:IsPveCard() then
    local isSweepOpen = PveEntranceProxy.Instance:IsSweepOpen(self.curData.id)
    if not isSweepOpen then
      MsgManager.ShowMsgByID(43114)
      return
    end
    if self.pveSweepLimited then
      MsgManager.ShowMsgByID(39210)
      return
    end
    if self.sufficientTime ~= 1 then
      MsgManager.ShowMsgByID(43115)
      return
    end
    if not LocalSaveProxy.Instance:GetDontShowAgain(28112) then
      local desc = ZhString.PveShenYu .. GameConfig.CardRaid.cardraid_DifficultyName[raidid]
      MsgManager.DontAgainConfirmMsgByID(28112, function()
        ServiceFuBenCmdProxy.Instance:CallQuickFinishPveRaidFubenCmd(raidid)
        FunctionPlayerPrefs.Me():SetInt("PveQuickFinish_LastDataTime", os.time())
      end, nil, nil, desc)
    else
      ServiceFuBenCmdProxy.Instance:CallQuickFinishPveRaidFubenCmd(raidid)
    end
    return
  end
  local fp = PveEntranceProxy.Instance:IsSweepOpen(self.curData.id)
  if fp then
    sufficientTime = sufficientTime or self.sufficientTime
    if sufficientTime ~= 1 then
      MsgManager.ShowMsgByID(43115)
    else
      local msgID = self.timeType == 2 and 43113 or 43214
      local dont = LocalSaveProxy.Instance:GetDontShowAgain(msgID)
      if not dont then
        MsgManager.DontAgainConfirmMsgByID(msgID, function()
          ServiceFuBenCmdProxy.Instance:CallQuickFinishCrackRaidFubenCmd(raidid)
        end, nil, nil, tostring(self.costBattleTime))
      else
        ServiceFuBenCmdProxy.Instance:CallQuickFinishCrackRaidFubenCmd(raidid)
      end
    end
  else
    MsgManager.ShowMsgByID(43114)
  end
end
function PveView:InitSomePveObj()
  self.roguelikeLoadBtn = self:FindGO("RoguelikeLoadBtn")
  self.roguelikeLoadBtn:SetActive(false)
  self:AddClickEvent(self.roguelikeLoadBtn, function()
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.RoguelikeDungeonView
    })
  end)
end
function PveView:AddUIEvts()
  self:AddClickEvent(self.publishBtn, function()
    FunctionPve.Me():OnClickPublish()
  end)
  self:AddClickEvent(self.matchBtn, function()
    if FunctionPve.Me():DoMatch() then
      self:CloseSelf()
    end
  end)
  self:AddClickEvent(self.challengeBtn, function()
    local guideParam = FunctionGuide.Me():tryTakeCustomGuideParam(nil, "fake_crackraid")
    if guideParam then
      self:CloseSelf()
      return
    end
    if self.curData and self.curData:IsHeadWear() and not ExpRaidProxy.Instance:CheckBattleTimelen(true) then
      MsgManager.ShowMsgByID(28020)
    end
    self:ConfirmChallenge(function()
      if FunctionPve.Me():DoChallenge() then
        self:CloseSelf()
      end
    end)
  end)
  self:AddClickEvent(self.checkBtn.gameObject, function()
    if self.curData then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.PveAchievementPopup,
        viewdata = {
          id = self.curData.id
        }
      })
    end
  end)
  self:AddClickEvent(self.raidHelpBtn, function()
    if not self.curData then
      return
    end
    TipsView.Me():ShowGeneralHelpByHelpId(self.curData.staticData.HelpID)
  end)
  self:AddClickEvent(self.dropBtn.gameObject, function()
    if self.curBtnSprite == self.dropBtn then
      return
    end
    self.curBtnSprite = self.dropBtn
    self:UpdateItemDropList()
  end)
  self:AddClickEvent(self.monsterBtn.gameObject, function()
    if self.curBtnSprite == self.monsterBtn then
      return
    end
    self.curBtnSprite = self.monsterBtn
    self:UpdateMonsterList()
  end)
end
function PveView:ChooseDropOrMonster(drop)
  self.dropBtn.spriteName = drop and _BtnDropMonster.ChoosenSp or _BtnDropMonster.UnchoosenSp
  self.dropBtnLab.color = drop and _BtnDropMonster.ChoosenColor or _BtnDropMonster.UnchoosenColor
  self.monsterBtn.spriteName = drop and _BtnDropMonster.UnchoosenSp or _BtnDropMonster.ChoosenSp
  self.monsterBtnLab.color = drop and _BtnDropMonster.UnchoosenColor or _BtnDropMonster.ChoosenColor
end
function PveView:SetFixedLabel()
  self.checkBtnLab.text = ZhString.Pve_CheckAchievement
  self.matchBtnLab.text = ZhString.Pve_Match
  self.challengeBtnLab.text = ZhString.Pve_Challenge
  self.dropBtnLab.text = ZhString.Pve_DropBtn
  self.monsterBtnLab.text = ZhString.Pve_MonsterBtn
  self.baseExp_fixedLab.text = ZhString.Pve_BaseExp
  self.jobExp_fixedLab.text = ZhString.Pve_JobExp
end
function PveView:OnEnter()
  FunctionPve.DoQuery()
  PveView.super.OnEnter(self)
end
function PveView:OnExit()
  PveView.super.OnExit(self)
  PictureManager.Instance:UnLoadUI(_BgTextureName, self.bgTexture)
  PictureManager.Instance:UnLoadUI(_DetailTexture, self.fixed_DetailTexture)
  FunctionPve.Me():ClearClientData()
  TimeTickManager.Me():ClearTick(self)
  if self.pveWraplist then
    self.pveWraplist:Destroy()
  end
end
function PveView:InitCatalog()
  if self._initCatalog then
    return
  end
  self._initCatalog = true
  self.loadingRoot:SetActive(false)
  self.root:SetActive(true)
  self:_Init()
  self.targetData = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.targetData
  self.catalogAllData = self.targetData or _EntranceProxy.catalogAll
  self.filterPanel = self:FindComponent("FilterPanel", UIPanel)
  self.filterColider = self:FindComponent("ItemTabs", BoxCollider, self.filterPanel.gameObject)
  self.filterColider.enabled = true
  self.filterArrow = self:FindComponent("tabsArrow", UISprite, self.filterColider.gameObject)
  self.raidTypeTabs = PopupGridList.new(self:FindGO("ItemTabs"), function(self, data)
    if not self.fromNpc and self.selectTab ~= data then
      self.selectTab = data
      self:OnTabChange(self.selectTab)
      self.fromNpc = nil ~= self.targetData
      self.filterColider.enabled = not self.fromNpc
      self.filterArrow.enabled = not self.fromNpc
    end
  end, self, self.filterPanel.depth + 2)
  self:InitFilter()
end
function PveView:OnTabChange(selectTab)
  self.selectTab = selectTab
  local catalog = selectTab.Catalog
  local result
  if catalog == 0 then
    result = self.catalogAllData
  else
    result = _EntranceProxy:GetCatalogData(catalog)
  end
  if #result > 0 then
    local targetRow, targetChoose = self:addGuideData(result)
    self.pveWraplist:ResetDatas(result)
    self.pveWraplist:ResetPosition()
    local firstTypeCell
    local cells = self.pveWraplist:GetCells()
    for i = 1, #cells do
      if cells[i].data and cells[i].data == result[targetChoose] then
        firstTypeCell = cells[i]
      end
    end
    firstTypeCell = firstTypeCell or cells[1]
    self:OnClickRaidTypeCell(firstTypeCell, true)
  end
end
function PveView:InitFilter()
  TableUtility.ArrayClear(_PopUpItemConfig)
  for k, v in pairs(_PveConfig.Catalog) do
    local data = {}
    data.Name = v
    data.Catalog = k
    table.insert(_PopUpItemConfig, data)
  end
  self.raidTypeTabs:SetData(_PopUpItemConfig)
  local vCatalog = self.viewdata.viewdata and self.viewdata.viewdata.catalog
  local catalogStr = vCatalog and _PveConfig.Catalog[vCatalog]
  if catalogStr then
    self.raidTypeTabs:SetValue(catalogStr)
  end
end
function PveView:OnClickRewardItem(cellctl)
  if cellctl and cellctl ~= self.chooseReward then
    local data = cellctl.data
    local stick = cellctl.icon
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
      TipManager.Instance:ShowItemFloatTip(sdata, stick, NGUIUtil.AnchorSide.Left, {-200, 0})
    end
    self.chooseReward = cellctl
  else
    self:CancelChooseReward()
  end
end
function PveView:CancelChooseReward()
  self.chooseReward = nil
  self:ShowItemTip()
end
function PveView:OnClickPveMonster(cell)
  local monsterId = cell.data
  if not monsterId then
    return
  end
  if self.curData and self.curData.staticData.MonsterClickable == 1 then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.PveMonsterPopUp,
      viewdata = {monsterID = monsterId}
    })
  end
end
function PveView:OnClickDifficulty(cell)
  local data = cell.data
  if not data then
    return
  end
  if self.curData and self.curData.id == data.id then
    return
  end
  self:UpdateViewData(data)
  self:ChooseDiff(data.difficulty)
end
function PveView:UpdateViewData(data)
  self.curData = data
  FunctionPve.Me():SetCurPve(data)
  self.nameLab.text = data.name
  local iconstr = _PveConfig.RaidType[data.groupid].detailIcon
  if iconstr then
    IconManager:SetUIIcon(iconstr, self.detailIcon)
  end
  self.detailIcon:MakePixelPerfect()
  local posX = self.nameLab.transform.localPosition.x + self.nameLab.width / 2 + 30
  self.raidHelpBtn.transform.localPosition = LuaGeometry.GetTempVector3(posX, 294, 0)
  _EntranceProxy:SetRewardData(data)
  self:UpdateExp()
  self:UpdateOptionBtn()
  self:UpdateContentLabel()
  self:UpdateItemList()
  self:UpdateAchieve()
end
local BattleTimeStringColor = {
  [1] = "[000000]%d[-])",
  [2] = "[E4593D]%d[-]"
}
function PveView:SetContentLabel(contentFormat, contentParam, contentLabel)
  if not contentFormat then
    return
  end
  self.pveSweepLimited = false
  if contentFormat == 1 then
    self.pveCard_addMaxCountBtn.gameObject:SetActive(false)
    contentLabel.text = string.format(ZhString.Pve_RecommendPlayerNum, contentParam)
  elseif contentFormat == 2 then
    local max_challengeCount = contentParam
    local server_challengeCount = PveEntranceProxy.Instance:GetPassTime(self.curData.id)
    local leftTime = math.max(0, max_challengeCount - server_challengeCount)
    contentLabel.text = string.format(ZhString.PveView_LeftTime, leftTime)
    local isPveCard = self.curData:IsPveCard()
    if isPveCard then
      self.pveSweepLimited = max_challengeCount <= server_challengeCount
    end
    if max_challengeCount <= server_challengeCount then
      contentLabel.color = _ChallengeRedColor
    else
      ColorUtil.BlackLabel(contentLabel)
    end
  elseif contentFormat == 3 then
    self.pveCard_addMaxCountBtn.gameObject:SetActive(true)
    self.costBattleTime = contentParam
    self.sufficientTime = 2
    local timeType = ExpRaidProxy.Instance:GetGameTimeSetting()
    local battleTime = ExpRaidProxy.Instance:GetPveTime(timeType)
    if battleTime >= contentParam * 60 then
      self.sufficientTime = 1
    else
      local repTimeType = timeType == 1 and 2 or 1
      local repBattleTime = ExpRaidProxy.Instance:GetPveTime(repTimeType)
      if repBattleTime >= contentParam * 60 then
        self.sufficientTime = 1
        timeType = repTimeType
      end
    end
    self.timeType = timeType
    if timeType == 1 then
      contentLabel.text = string.format(ZhString.PveView_CostPlayTime, string.format(BattleTimeStringColor[self.sufficientTime], contentParam))
    else
      contentLabel.text = string.format(ZhString.PveEntranceContent_3, string.format(BattleTimeStringColor[self.sufficientTime], contentParam))
    end
  elseif contentFormat == 4 then
    local max_challengeCount = contentParam
    local server_challengeCount = PveEntranceProxy.Instance:GetPassTime(self.curData.id)
    contentLabel.text = string.format(ZhString.PveEntranceContent_4, server_challengeCount, max_challengeCount)
    if max_challengeCount <= server_challengeCount then
      contentLabel.color = _ChallengeRedColor
    else
      ColorUtil.BlackLabel(contentLabel)
    end
  end
end
function PveView:UpdateContentLabel()
  if self.curData then
    self:SetContentLabel(self.curData.staticData.RecommendPlayerNum, self.curData.staticData.PlayerNumCount, self.recommendPlayerNumLab)
    local total = self.curData.staticData.RewardLimit
    total = total or self.curData.staticData.ChallengeCount
    self:SetContentLabel(self.curData.staticData.ChallengeContent, total, self.challengeNumLab)
  end
end
function PveView:UpdateItemList()
  if self.curBtnSprite == self.dropBtn then
    self:UpdateItemDropList()
  elseif self.curBtnSprite == self.monsterBtn then
    self:UpdateMonsterList()
  end
end
function PveView:UpdateOptionBtn()
  local id = self.curData and self.curData.id
  if not id then
    return
  end
  local open = FunctionPve.IsOpen(id)
  if not open then
    local unlockMsg = self.curData.unlockMsgId
    if unlockMsg and unlockMsg ~= 0 then
      MsgManager.ShowMsgByID(unlockMsg)
    else
      redlog("策划未配置 unlockMsgId.  PveRaidEntrance表ID ： ", id)
    end
  end
  local isRoguelike = FunctionPve.Me():IsClientRoguelike()
  local isQuick = PveEntranceProxy.Instance:IsSweepOpen(self.curData.id)
  local isPveCard = self.curData:IsPveCard()
  self:UpdateTrebleRewardTip()
  local goalid = self.curData.staticData.Goal or 0
  self.matchBtn:SetActive(open and goalid > 0)
  self.challengeBtn:SetActive(open)
  self.publishBtn:SetActive(open and goalid > 0)
  self.roguelikeLoadBtn:SetActive(open and isRoguelike)
  self.challengeNumLab.gameObject:SetActive(open)
  if not self.curData.staticData.ShowSweep or self.curData.staticData.ShowSweep == 0 then
    self.sweepBtn:SetActive(false)
  else
    self.sweepBtn:SetActive(open)
    if isQuick then
      ColorUtil.WhiteUIWidget(self.sweepSp)
    else
      ColorUtil.ShaderGrayUIWidget(self.sweepSp)
    end
  end
end
function PveView:UpdateTrebleRewardTip()
  if not self.curData then
    return
  end
  if not self.trebleReward then
    return
  end
  local passtime = PveEntranceProxy.Instance:GetPassTime(self.curData.id)
  local isPveCard = self.curData:IsPveCard()
  self.trebleReward.gameObject:SetActive(isPveCard and passtime < 3)
end
function PveView:UpdateExp()
  if not self.curData then
    return
  end
  local isRift = self.curData.raidType == PveRaidType.Crack
  local configBaseExp = 0
  local configJobExp = 0
  if isRift then
    local userdata = Game.Myself.data.userdata
    local myExp = userdata:Get(UDEnum.ROLEEXP)
    local curOcc = Game.Myself.data:GetCurOcc()
    local myJobExp = curOcc.exp
    local roleLv = userdata:Get(UDEnum.ROLELEVEL)
    local maxlv = self.curData.staticData.RecommendLv
    local difficulty = self.curData.difficulty
    local monthcard = NewRechargeProxy.Ins:AmIMonthlyVIP()
    configBaseExp = CommonFun.CalcRiftBaseExp(roleLv, maxlv, difficulty, monthcard) or 0
    configJobExp = CommonFun.CalcRiftJobExp(roleLv, maxlv, difficulty, monthcard) or 0
    local nextBaseLvNeedExp = Table_BaseLevel[roleLv + 1]
    nextBaseLvNeedExp = nextBaseLvNeedExp and nextBaseLvNeedExp.NeedExp or 1
    local isHero = ProfessionProxy.IsHero(curOcc.profession)
    local nextJobNeedExp = Table_JobLevel[curOcc.level + 1]
    if isHero then
      nextJobNeedExp = nextJobNeedExp and nextJobNeedExp.HeroJobExp or 1
    else
      nextJobNeedExp = nextJobNeedExp and nextJobNeedExp.JobExp or 1
    end
    if configBaseExp > 0 then
      local addLv, left = MyselfProxy.Instance:GetWantedBaseLv(configBaseExp)
      self:SetSliderAnimation(roleLv, myExp, nextBaseLvNeedExp, addLv, left, self.baseExp_AddSp, self.baseExp_CoverSp, self.baseExp_Animation, self.baseExp_MaxWidth, self.baseExpValue, self.baseExp_Slider, self.baseExp_AddSp_OffsetX, true)
    end
    if configJobExp > 0 then
      local addLv, left = MyselfProxy.Instance:GetWantedJobLv(configJobExp)
      self:SetSliderAnimation(curOcc.level, curOcc.exp, nextJobNeedExp, addLv, left, self.jobExp_AddSp, self.jobExp_CoverSp, self.jobExp_Animation, self.jobExp_MaxWidth, self.jobExpValue, self.jobExp_Slider, self.jobExp_AddSp_OffsetX, false)
    end
  end
  local isPveCard = self.curData:IsPveCard()
  self.pvecardGroup:SetActive(isPveCard)
  local noExp = configBaseExp <= 0 and configJobExp <= 0
  self:Hide(self.pvecardProgress)
  if isPveCard then
    self:Show(self.pvecardProgress)
    self:SmallRangeScrollView(true)
    self:Hide(self.expPanel)
    if self.curData.pveCardlayer == 1 and 1 < self.curData.pveCardDifficulty then
      self.pvecardProgress.text = string.format(ZhString.Pve_CardDesc, self.curData.pveCardDifficulty)
    else
      self.pvecardProgress.text = ""
    end
  elseif noExp then
    self:SmallRangeScrollView(false)
    self:Hide(self.expPanel)
  elseif configBaseExp <= 0 then
    self:Hide(self.expPanel)
  else
    self:SmallRangeScrollView(true)
    self:Show(self.expPanel)
  end
end
function PveView:ChoosePvecardGroup(simple)
  if self.pvecardLayer == 0 then
    self:Show(self.tog1Bg)
    self:Hide(self.tog2Bg)
    self.tog2Lab.color = _PveGroupTogColor[2]
    self.tog1Lab.color = ColorUtil.NGUIWhite
  else
    self.tog1Lab.color = _PveGroupTogColor[1]
    self.tog2Lab.color = ColorUtil.NGUIWhite
    self:Hide(self.tog1Bg)
    self:Show(self.tog2Bg)
  end
end
function PveView:SmallRangeScrollView(var)
  local clip = self.itemScrollViewPanel.baseClipRegion
  if var then
    self.itemScrollViewPanel.transform.localPosition = LuaGeometry.GetTempVector3(154, -70, 0)
    self.itemScrollViewPanel.baseClipRegion = LuaGeometry.GetTempVector4(clip.x, clip.y, 782, 220)
    self.itemScrollViewPanel.clipOffset = LuaGeometry.GetTempVector2(0, 0)
  else
    self.itemScrollViewPanel.transform.localPosition = LuaGeometry.GetTempVector3(154, -90, 0)
    self.itemScrollViewPanel.baseClipRegion = LuaGeometry.GetTempVector4(clip.x, clip.y, 782, 270)
    self.itemScrollViewPanel.clipOffset = LuaGeometry.GetTempVector2(0, 0)
  end
end
function PveView:SetSliderAnimation(curlv, currentValue, nextValue, addLv, left, addValueSp, coverSp, animationGo, maxWidth, uiLabel, slider, addOffset, isBase)
  local ratio = currentValue / nextValue
  slider.value = ratio
  _SetLocalPositionGo(addValueSp.gameObject, maxWidth * ratio + addOffset, 0, 0)
  animationGo:SetActive(addLv > 0)
  if addLv > 0 then
    local newTotal
    if isBase then
      newTotal = Table_BaseLevel[addLv + curlv].NeedExp
    elseif MyselfProxy.Instance:IsHero() then
      newTotal = Table_JobLevel[addLv + curlv].HeroJobExp
    else
      newTotal = Table_JobLevel[addLv + curlv].JobExp
    end
    coverSp.gameObject:SetActive(left > 0)
    coverSp.width = maxWidth * (left / newTotal)
    uiLabel.text = string.format(ZhString.Pve_ExpLv, addLv)
    addValueSp.width = maxWidth - maxWidth * ratio
  else
    coverSp.gameObject:SetActive(false)
    addValueSp.gameObject:SetActive(left > 0)
    local addPercent = left / nextValue
    uiLabel.text = string.format(ZhString.Pve_Exp, addPercent * 100)
    addValueSp.width = maxWidth * addPercent
  end
end
function PveView:UpdateServerInfoData()
  self:InitCatalog()
  self:UpdateTypeUnlock()
  self:UpdateContentLabel()
  self:UpdateDiff()
  self:UpdateTrebleRewardTip()
end
function PveView:UpdateDiff()
  if not self.difficultyCtl then
    return
  end
  if not self.curData then
    return
  end
  local diffs = _EntranceProxy:GetDifficultyData(self.curData.groupid, self.pvecardLayer)
  self.difficultyCtl:ResetDatas(diffs)
end
function PveView:UpdateTypeUnlock()
  if not self.pveWraplist then
    return
  end
  local cells = self.pveWraplist:GetCells()
  for i = 1, #cells do
    cells[i]:UpdateUnlock()
  end
end
function PveView:ReverseCrack()
  self.crackTypeCell:ReverseCrack()
  self.pveWraplist:ResetPosition()
end
function PveView:OnClickRaidTypeCell(cell, auto)
  local entranceData = cell.data
  if not entranceData then
    return
  end
  local isCrack = entranceData:IsCrack()
  local clickSameTypeCell = self.curData and self.curData.groupid == entranceData.groupid
  if clickSameTypeCell then
    if isCrack then
      self.crackTypeCell = cell
      if not auto then
        self:ReverseCrack()
      end
    end
    return
  end
  local isNew = _RedTipProxy:IsNew(ERedSys, entranceData.groupid)
  if isNew then
    _RedTipProxy:RegisterUI(ERedSys, self.checkBtn, 8, {-6, -2})
  else
    _RedTipProxy:UnRegisterUI(ERedSys, self.checkBtn)
  end
  local isCrack = entranceData:IsCrack()
  if isCrack then
    self.crackTypeCell = cell
  end
  self:UpdateViewData(entranceData)
  self:SetChooseRaidType(entranceData.id)
  if entranceData:IsPveCard() then
    local _tempPveLayer
    local diffs = _EntranceProxy:GetDifficultyData(self.curData.groupid, 1)
    for i = 1, #diffs do
      if PveEntranceProxy.Instance:IsPass(diffs[i].id) then
        _tempPveLayer = 1
        break
      end
    end
    self.pvecardLayer = _tempPveLayer or 0
    self:ChoosePvecardGroup(self.pvecardLayer == 0)
    self:InitPveDiffRaid()
  else
    self.pvecardLayer = nil
    self:InitDiffRaid()
  end
end
function PveView:InitDiffRaid()
  local diffs = _EntranceProxy:GetDifficultyData(self.curData.groupid, self.pvecardLayer)
  self.difficultyCtl:ResetDatas(diffs)
  self:ChooseBestFit(diffs)
  self:ChooseDiff(self.curData.difficulty)
end
function PveView:OnPveCardTabChange(layer)
  if self.pvecardLayer == layer then
    return
  end
  self.pvecardLayer = layer
  self:ChoosePvecardGroup(layer == 0)
  self:InitPveDiffRaid()
end
function PveView:InitPveDiffRaid()
  local diffs = _EntranceProxy:GetDifficultyData(self.curData.groupid, self.pvecardLayer)
  self:UpdateViewData(diffs[1])
  self.difficultyCtl:ResetDatas(diffs)
  self:ChooseBestFit(diffs)
  self:ChooseDiff(self.curData.difficulty)
end
function PveView:ChooseBestFit(diffs)
  self.difficultyCtl:ResetPosition()
  local diffCells = self.difficultyCtl:GetCells()
  local _EntranceMgr = PveEntranceProxy.Instance
  for i = #diffs, 1, -1 do
    local isFirstPass = _EntranceMgr:IsPass(diffs[i].id)
    if isFirstPass then
      if i > 4 then
        local diffScrollView = self.difficultyCtl.scrollView
        local panel = diffScrollView.panel
        local bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform, diffCells[i].gameObject.transform)
        local offset = panel:CalculateConstrainOffset(bound.min, bound.max)
        offset = Vector3(offset.x, 0, 0)
        diffScrollView:MoveRelative(offset)
      end
      self:UpdateViewData(diffs[i])
      break
    end
  end
end
function PveView:SetChooseRaidType(id)
  if not self.pveWraplist then
    return
  end
  local cells = self.pveWraplist:GetCells()
  for i = 1, #cells do
    cells[i]:SetChoosen(id)
  end
end
function PveView:ChooseDiff(id)
  local cells = self.difficultyCtl:GetCells()
  for i = 1, #cells do
    cells[i]:SetChoosen(id)
  end
end
function PveView:UpdateItemDropList()
  if not self.curData then
    return
  end
  self:ChooseDropOrMonster(true)
  local dropItems = _EntranceProxy:GetDropData(self.curData.id)
  self.itemCtl:ResetDatas(dropItems)
  self:Show(self.itemCtl.layoutCtrl)
  self:Hide(self.monsterCtl.layoutCtrl)
  self.itemCtl:ResetPosition()
  self.emptyMonsterRoot:SetActive(#dropItems == 0)
end
function PveView:UpdateMonsterList()
  if not self.curData then
    return
  end
  self:ChooseDropOrMonster(false)
  local monsters = self.curData.staticData.Monster
  self.monsterCtl:ResetDatas(monsters)
  self.emptyMonsterRoot:SetActive(#monsters == 0)
  self:Hide(self.itemCtl.layoutCtrl)
  self:Show(self.monsterCtl.layoutCtrl)
  self.monsterCtl:ResetPosition()
end
function PveView:AddEvt()
  self:AddListenEvt(ServiceEvent.FuBenCmdSyncPveCardOpenStateFubenCmd, self.UpdateDiff)
  self:AddListenEvt(PVEEvent.SyncPvePassInfo, self.UpdateServerInfoData)
  self:AddListenEvt(PVEEvent.AutoCreatTeamForInvite, self.CloseSelf)
  self:AddListenEvt(ServiceEvent.UserEventDepositCardInfo, self.UpdateMonthCard)
  self:AddListenEvt(ServiceEvent.NUserBattleTimelenUserCmd, self.HandleTimelen)
  self:AddListenEvt(ServiceEvent.FuBenCmdSyncPvePassInfoFubenCmd, self.HandleAddPveCardTimes)
  self:AddListenEvt(ServiceEvent.FuBenCmdAddPveCardTimesFubenCmd, self.HandleAddPveCardTimes)
  self:AddListenEvt(ServiceEvent.FuBenCmdSyncPveRaidAchieveFubenCmd, self.UpdateAchieve)
  self:AddListenEvt(ServiceEvent.SceneTipGameTipCmd, self.UpdateRedTips)
end
function PveView:UpdateAchieve()
  if self.curData then
    self.starRoot:SetActive(#self.curData.staticData.ShowAchievement > 0)
    local achievesCount = PveEntranceProxy.Instance:GetGroupAchieve(self.curData.groupid)
    for i = 1, 3 do
      if i <= achievesCount then
        self.stars[i].CurrentState = 1
      else
        self.stars[i].CurrentState = 0
      end
    end
  end
end
function PveView:HandleAddPveCardTimes()
  self:UpdateContentLabel()
  self:UpdateLeftTimeInfo()
end
function PveView:HandleTimelen(note)
  local data = note.body
  if data then
    self:SetGameTime(data)
  end
  self:UpdateLeftTimeInfo()
  self:UpdateContentLabel()
end
function PveView:SetGameTime(data)
  if data.timelen then
    self.usedTime = math.floor(data.timelen / 60)
  end
  if data.totaltime then
    self.timeTotal = math.floor(data.totaltime / 60)
  end
end
function PveView:UpdateMonthCard(data)
end
function PveView:addGuideData(list)
  local guideParam = FunctionGuide.Me():tryTakeCustomGuideParam(nil, "trace_crackraid")
  if guideParam then
    if guideParam.fitlevel then
      local mylv = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
      local retIndex = -1
      local recommendMaxLv = 0
      for k, v in pairs(list) do
        if v.staticData and v.staticData.RaidType == 65 then
          local recommendLevel = v.staticData.RecommendLv
          if mylv > recommendLevel and recommendMaxLv < recommendLevel then
            recommendMaxLv = recommendLevel
            retIndex = k
          end
        end
      end
      if retIndex > 0 then
        return retIndex, retIndex
      end
    elseif guideParam.groupid then
      local retIndex = -1
      for k, v in pairs(list) do
        if v.staticData and v.staticData.GroupId == guideParam.groupid then
          retIndex = k
          break
        end
      end
      if retIndex > 0 then
        return retIndex, retIndex
      end
    end
  end
  if GameConfig.SpecialGuide_Pve_QuestId == nil or 0 >= #GameConfig.SpecialGuide_Pve_QuestId then
    return 1
  end
  local questData
  for _, v in ipairs(GameConfig.SpecialGuide_Pve_QuestId) do
    questData = FunctionGuide.Me():checkHasGuide(v)
    if not questData then
    end
  end
  local row = 1
  if questData ~= nil then
    local guideId = questData.params.guideID
    local tbGuide = Table_GuideID[guideId]
    if tbGuide ~= nil and tbGuide.SpecialID then
      for k, v in pairs(list) do
        if v.staticData ~= nil and v.staticData.GroupId == tbGuide.SpecialID then
          v.guideButtonId = tbGuide.ButtonID
          v.questData = questData
          row = k
          break
        end
      end
    end
  end
  return row
end
function PveView:ConfirmChallenge(confirmHandler)
  local cost = self.curData.staticData.TimeCost
  if cost ~= nil then
    local _ExpRaidProxy = ExpRaidProxy.Instance
    local time = _ExpRaidProxy:GetPveTime()
    if time > 0 and cost > time then
      local timeType = _ExpRaidProxy:GetGameTimeSetting()
      local t = _ExpRaidProxy:GetPveTime(timeType == 1 and 2 or 1)
      if cost <= t + time then
        local id = timeType == 1 and 43242 or 43243
        MsgManager.ConfirmMsgByID(id, confirmHandler, nil, 1, (cost - time) // 60)
        return
      end
    end
  end
  confirmHandler()
end
function PveView:UpdateRedTips()
  local cells = self.pveWraplist and self.pveWraplist:GetCells()
  if cells then
    for _, cell in ipairs(cells) do
      cell:UpdateRedtip()
    end
  end
end
