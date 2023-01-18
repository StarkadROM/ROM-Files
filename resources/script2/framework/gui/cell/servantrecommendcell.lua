local BaseCell = autoImport("BaseCell")
ServantRecommendCell = class("ServantRecommendCell", BaseCell)
local tmpPos = LuaVector3.Zero()
local OFFSET = 200
local greenBtn, yellowBtn, greenEffect, yellowEffect = "new-com_btn_a", "new-com_btn_c", Color(0.27058823529411763, 0.37254901960784315, 0.6823529411764706), Color(0.7686274509803922, 0.5254901960784314, 0 / 255)
local btnStatus = {
  GO = {
    greenBtn,
    ZhString.Servant_Recommend_MoveTo,
    greenEffect,
    true
  },
  RECEIVE = {
    yellowBtn,
    ZhString.Servant_Recommend_Receive,
    yellowEffect,
    false
  },
  RECEIVED = {
    greenBtn,
    ZhString.Servant_Recommend_Received,
    yellowEffect,
    false
  },
  KJMC = {
    textname = {
      [1] = ZhString.Servant_Recommend_Go,
      [2] = ZhString.AnnounceQuestPanel_AcceptQuest,
      [3] = ZhString.Servant_Recommend_Go,
      [4] = ZhString.AnnounceQuestPanel_CommitQuest
    }
  }
}
local tempVector3 = LuaVector3.Zero()
local EQUIP_SHORTCUT_ID = 522
local KJMC_ID = 521
local KJMC_QUEST_ID = 305000001
local KJMC_GUIDE_QUEST_ID = 99090033
local SEAL_REPAIR = {2, 1002}
local ANNOUNCE_QUEST = {1, 1001}
local XGL = 18
local typeCfgColor = {
  [1] = "[ffa0bf]",
  [2] = "[6ca7ff]",
  [3] = "[ffd44f]",
  [4] = "[bde379]",
  [5] = "[dbb8ef]"
}
function ServantRecommendCell:Init()
  ServantRecommendCell.super.Init(self)
  self:FindObjs()
  self:AddUIEvts()
end
function ServantRecommendCell:FindObjs()
  self.bg = self:FindGO("Bg")
  self.icon = self:FindComponent("Icon", UISprite)
  self.quickFinishBtn = self:FindGO("QuickFinishBtn")
  local btnText = self:FindComponent("BtnText", UILabel, self.quickFinishBtn)
  btnText.text = ZhString.Servant_Recommend_QuickFinish
  self.name = self:FindComponent("Name", UILabel)
  self.nameCorner = self:FindComponent("NameCorner", UISprite)
  self.title = self:FindComponent("Title", UILabel)
  self.progress = self:FindComponent("Progress", UILabel)
  self.equipShortCutPos = self:FindGO("EquipShortCutPos")
  self.equipShortCutGrid = self:FindGO("EquipShortCutGrid")
  self.progressSlider = self:FindComponent("ProgressSlider", UISlider)
  self.btn = self:FindComponent("Btn", UISprite)
  self.btnLab = self:FindComponent("BtnText", UILabel)
  self.finishedFlag = self:FindComponent("FinishedImg", UISprite)
  IconManager:SetArtFontIcon("com_bg_reached", self.finishedFlag)
  self.everPassLab = self:FindGO("EverPass")
  self.difficulty = self:FindGO("Difficulty")
  self.newRewardIcon = self:FindComponent("Reward", UISprite)
  self.newRewardNum = self:FindComponent("RewardNum", UILabel)
  self.favRewardIcon = self:FindComponent("FavReward", UISprite)
  self.favRewardNum = self:FindComponent("FavRewardNum", UILabel)
  self.BpExp = self:FindGO("BPEXP")
  self.BpExpNum = self:FindComponent("BPEXPNum", UILabel)
  self.pagePfb = self:FindGO("PagePfb")
  self.pageWidget = self:FindComponent("PageWidget", UIWidget)
  self.PageText1 = self:FindComponent("PageText1", UILabel)
  self.PageBg1 = self:FindComponent("PageBg", UISprite, self.PageText1.gameObject)
  self.PageText2 = self:FindComponent("PageText2", UILabel)
  self.PageBg2 = self:FindComponent("PageBg", UISprite, self.PageText2.gameObject)
  self.PageText3 = self:FindComponent("PageText3", UILabel)
  self.PageBg3 = self:FindComponent("PageBg", UISprite, self.PageText3.gameObject)
  self.rewardScrollView = self:FindGO("RewardScrollView"):GetComponent(UIScrollView)
  self.rewardGrid = self:FindGO("RewardGrid"):GetComponent(UIGrid)
  self.rewardGridCtrl = UIGridListCtrl.new(self.rewardGrid, BagItemCell, "BagItemCell")
  self.rewardGridCtrl:AddEventListener(MouseEvent.MouseClick, self.handleClickReward, self)
  local rewardPanel = self:FindComponent("RewardScrollView", UIPanel)
  local upPanel = UIUtil.GetComponentInParents(self.gameObject, UIPanel)
  if upPanel and rewardPanel then
    rewardPanel.depth = upPanel.depth + 1
  end
  self.tipData = {}
  self.tipData.funcConfig = {}
end
function ServantRecommendCell:AddUIEvts()
  self:AddClickEvent(self.btn.gameObject, function(obj)
    self:OnClickBtn()
  end)
  self:AddClickEvent(self.quickFinishBtn, function(go)
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.SealTaskPopUp,
      viewdata = {costID = 5503}
    })
  end)
  for i = 0, 5 do
    do
      local trans = self.equipShortCutGrid.transform:GetChild(i)
      self:AddClickEvent(trans.gameObject, function(g)
        if self.gotoMode and #self.gotoMode >= 6 then
          FuncShortCutFunc.Me():CallByID(self.gotoMode[i + 1])
        else
          redlog("请检查执事装备打洞的配置GotoMode")
        end
      end)
    end
    break
  end
end
function ServantRecommendCell:OnClickBtn()
  local questData = QuestProxy.Instance:GetQuestDataBySameQuestID(KJMC_QUEST_ID)
  if self.data.id == KJMC_ID then
    local status = self:GetSpecialState()
    if status == 1 then
      if #self.gotoMode == 2 then
        local temp = Game.Myself.data:IsDoram() and self.gotoMode[1] or self.gotoMode[2]
        FuncShortCutFunc.Me():CallByID(temp)
        GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.NormalLayer)
      else
        redlog("执事抗击魔潮引导任务GotoMode字段长度应该为2，分别为猫和人")
      end
    elseif status == 2 then
      QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
    elseif status == 3 then
      FunctionQuest.Me():executeManualQuest(questData)
      GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.NormalLayer)
    elseif status == 4 then
      QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
    end
    return
  end
  if self.data.id == EQUIP_SHORTCUT_ID then
    self.equipShortCutPos:SetActive(not self.equipShortCutPos.activeSelf)
    return
  end
  if ServantRecommendProxy.STATUS.GO == self.status then
    if self.data and self.data:IsActive() and not self.data.real_open then
      MsgManager.ShowMsgByID(25423)
      return
    end
    local finishType = self.data.staticData and self.data.staticData.Finish
    if finishType == "repair_seal" then
      if GameConfig.Servant.SealGeneration then
        self:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.SealTaskPopUpV2,
          viewdata = {costID = 5503}
        })
        return
      end
    elseif finishType == "petwork" then
      self:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.PetView,
        viewdata = {tab = 3}
      })
      return
    elseif finishType == "wanted_quest_day" then
      NewLookBoardProxy.Instance:SetOpenNewPanel(false)
      FunctionVisitNpc.openWantedQuestPanel(101, nil, false)
    elseif finishType == "guild_pray" or finishType == "guild_pray_daily" or finishType == "guild_donate" or finishType == "guild_fuben" then
      if Game.MapManager:IsInGuildMap() then
        FuncShortCutFunc.Me():CallByID(self.gotoMode)
      elseif Game.Myself:IsDead() then
        MsgManager.ShowMsgByIDTable(2500)
      elseif not GuildProxy.Instance:IHaveGuild() then
        self:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.GuildInfoView
        })
        return
      else
        xdlog("申请进入公会")
        ServiceGuildCmdProxy.Instance:CallEnterTerritoryGuildCmd()
        local gotoModeList = {}
        TableUtility.ArrayShallowCopy(gotoModeList, self.gotoMode)
        FunctionChangeScene.Me():SetSceneLoadFinishActionForOnce(function(gotoModeList)
          FuncShortCutFunc.Me():CallByID(gotoModeList)
        end, gotoModeList)
        GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.NormalLayer)
      end
    elseif finishType == "submit_spec_quest" then
      FuncShortCutFunc.Me():CallByID(self.gotoMode)
      GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.NormalLayer)
      GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.PopUpLayer)
    else
      FuncShortCutFunc.Me():CallByID(self.gotoMode)
    end
  elseif ServantRecommendProxy.STATUS.RECEIVE == self.status then
    ServiceNUserProxy.Instance:CallReceiveServantUserCmd(false, self.id)
  end
end
local reward_icon, reward_num
local CONST_GIFT_ID, CONST_GIFT_NUM, FAVOR_ICON = 700108, 1, "food_icon_10"
local tempColor = LuaColor.white
local num_Format = "X%s"
function ServantRecommendCell:SetData(data)
  self.data = data
  local servantID = MyselfProxy.Instance:GetMyServantID()
  if data then
    self.bg:SetActive(true)
    local cfg = data.staticData
    if nil == cfg then
      helplog("女仆今日推荐前后端表不一致")
      return
    end
    self.id = data.id
    self.status = data.status
    self.gotoMode = cfg.GotoMode
    self.name.text = string.format("【%s】", cfg.Name)
    self.title.text = data.finish_time and string.format(cfg.Title, data.finish_time) or cfg.Title
    local dailyData = QuestProxy.Instance:getDailyQuestData(SceneQuest_pb.EOTHERDATA_DAILY)
    local totalcount, curCount = 0, 0
    local isEverPass = data.status == ServantRecommendProxy.STATUS.EVERPASS
    if dailyData then
      totalcount = dailyData.param1
      curCount = dailyData.param2
    end
    if StringUtil.IsEmpty(cfg.Progress) or isEverPass then
      self.progress.gameObject:SetActive(false)
    else
      self.progress.gameObject:SetActive(true)
      if self.id ~= KJMC_ID then
        self.progress.text = string.format(cfg.Progress, data.finish_time)
        self.progressSlider.value = data.finish_time / tonumber(string.sub(cfg.Progress, 4))
      else
        self.progress.text = string.format(cfg.Progress, curCount, totalcount)
        self.progressSlider.value = curCount / totalcount
        self.progress.gameObject:SetActive(totalcount ~= 0)
      end
    end
    self.difficulty:SetActive(cfg.Difficulty == 1)
    local exitIcon = IconManager:SetUIIcon(cfg.Icon, self.icon)
    if not exitIcon then
      exitIcon = IconManager:SetItemIcon(cfg.Icon, self.icon)
      if not exitIcon then
      end
    end
    local rewardList = {}
    if cfg.Reward then
      self:UpdateRewards(cfg.Reward, rewardList)
    end
    if cfg.Favorability and 0 < cfg.Favorability then
      local favorCFG = HappyShopProxy.Instance:GetServantShopMap()
      local itemId = favorCFG and favorCFG[servantID] and favorCFG[servantID].npcFavoriteItemid or 100
      local itemData = ItemData.new("Reward", itemId)
      if itemData then
        itemData:SetItemNum(cfg.Favorability)
      end
      table.insert(rewardList, itemData)
    end
    if cfg.BattlePassExp and 0 < cfg.BattlePassExp then
      local itemId = 184
      local itemData = ItemData.new("Reward", itemId)
      if itemData then
        itemData:SetItemNum(cfg.BattlePassExp)
      end
      table.insert(rewardList, itemData)
    end
    self.rewardGridCtrl:RemoveAll()
    self.rewardGridCtrl:ResetDatas(rewardList)
    self.icon:MakePixelPerfect()
    ColorUtil.WhiteUIWidget(self.btn)
    if self.id ~= KJMC_ID then
      self.everPassLab:SetActive(false)
      self.finishedFlag.gameObject:SetActive(false)
      LuaVector3.Better_Set(tmpPos, 422, 39.7, 0)
      self.progress.gameObject.transform.localPosition = tmpPos
      if ServantRecommendProxy.STATUS.FINISHED == data.status then
        self:_setBtnStatue(false)
      elseif ServantRecommendProxy.STATUS.RECEIVE == data.status then
        self:_setBtnStatue(true, btnStatus.RECEIVE)
      elseif ServantRecommendProxy.STATUS.GO == data.status then
        if self.gotoMode == _EmptyTable then
          self.btn.gameObject:SetActive(false)
          LuaVector3.Better_Set(tmpPos, 422, 15, 0)
          self.progress.gameObject.transform.localPosition = tmpPos
          self.finishedFlag.gameObject:SetActive(false)
        else
          self:_setBtnStatue(true, btnStatus.GO)
        end
      elseif isEverPass then
        self:_setBtnStatue(false)
        self.finishedFlag.gameObject:SetActive(false)
        self.everPassLab:SetActive(true)
      end
    else
      local status = self:GetSpecialState()
      self.btn.spriteName = status == 4 and greenBtn or yellowBtn
      self.btnLab.text = btnStatus.KJMC.textname[status]
      self.btnLab.effectColor = status == 4 and greenEffect or yellowEffect
      local complete = curCount == totalcount and curCount ~= 0
      self.btn.gameObject:SetActive(not complete)
      self.everPassLab:SetActive(complete)
      self.progress.gameObject:SetActive(not complete)
    end
    self:SetPage(cfg)
    self.equipShortCutPos:SetActive(false)
    if cfg.Recycle == 6 or cfg.Recycle == 9 or data.double then
      self.nameCorner.color = LuaGeometry.GetTempVector4(1, 0.8980392156862745, 0.4980392156862745, 1)
      self.name.color = LuaGeometry.GetTempVector4(1, 0.47058823529411764, 0, 1)
    else
      self.nameCorner.color = LuaGeometry.GetTempVector4(0.7803921568627451, 0.9686274509803922, 1, 1)
      self.name.color = LuaGeometry.GetTempVector4(0.12156862745098039, 0.4549019607843137, 0.7490196078431373, 1)
    end
    local cells = self.rewardGridCtrl:GetCells()
    for i = 1, #cells do
      if cfg.Recycle == 6 or cfg.Recycle == 9 then
        cells[i]:SetDoubleSymbol(true, true)
      elseif data.double then
        cells[i]:SetDoubleSymbol(true)
      else
        cells[i]:SetDoubleSymbol(false)
      end
    end
    self.rewardScrollView:ResetPosition()
  else
    self.bg:SetActive(false)
  end
end
local pageCFG = GameConfig.Servant.ServantRecommendPageType
local CONST_INTERVAL = 10
local CONST_BGWIDTH = 16
function ServantRecommendCell:SetPage(cfg)
  if cfg.PageType[1] then
    self.PageText1.gameObject:SetActive(true)
    local result, value = ColorUtil.TryParseHexString(pageCFG[cfg.PageType[1]].color)
    if result then
      self.PageBg1.color = value
    end
    self.PageText1.text = pageCFG[cfg.PageType[1]].name
    self.PageBg1.width = CONST_BGWIDTH + self.PageText1.width
    self.pageWidget:ResetAndUpdateAnchors()
  else
    self.PageText1.gameObject:SetActive(false)
  end
  if cfg.PageType[2] then
    self.PageText2.gameObject:SetActive(true)
    local result, value = ColorUtil.TryParseHexString(pageCFG[cfg.PageType[2]].color)
    if result then
      self.PageBg2.color = value
    end
    self.PageText2.text = pageCFG[cfg.PageType[2]].name
    self.PageBg2.width = CONST_BGWIDTH + self.PageText2.width
    local x = CONST_INTERVAL + self.PageBg1.width
    tempVector3[1] = x
    self.PageText2.gameObject.transform.localPosition = tempVector3
  else
    self.PageText2.gameObject:SetActive(false)
  end
  if cfg.PageType[3] then
    self.PageText3.gameObject:SetActive(true)
    local result, value = ColorUtil.TryParseHexString(pageCFG[cfg.PageType[3]].color)
    if result then
      self.PageBg3.color = value
    end
    self.PageText3.text = pageCFG[cfg.PageType[3]].name
    self.PageBg3.width = CONST_BGWIDTH + self.PageText3.width
    local x = CONST_INTERVAL * 2 + self.PageBg2.width + self.PageBg1.width
    tempVector3[1] = x
    self.PageText3.gameObject.transform.localPosition = tempVector3
  else
    self.PageText3.gameObject:SetActive(false)
  end
end
function ServantRecommendCell:GetSpecialState()
  local preQuestData = QuestProxy.Instance:GetQuestDataBySameQuestID(KJMC_GUIDE_QUEST_ID)
  if preQuestData then
    return 1
  else
  end
  local questData = QuestProxy.Instance:GetQuestDataBySameQuestID(KJMC_QUEST_ID)
  if questData then
    if questData.params.canSubmit then
      return 4
    elseif questData.params.canAccept then
      return 2
    else
      if questData and questData.questDataStepType == QuestDataStepType.QuestDataStepType_DAILY then
        return 3
      else
      end
    end
  else
  end
end
function ServantRecommendCell:_setBtnStatue(showBtn, statusCfg)
  if showBtn then
    self.btn.spriteName = statusCfg[1]
    self.btnLab.text = statusCfg[2]
    self.btnLab.effectColor = statusCfg[3]
    self.progress.gameObject:SetActive(statusCfg[4])
  else
    self.progress.gameObject:SetActive(false)
  end
  local sealValid = self.id == 3 and SealProxy.Instance:CheckQuickFinishValid()
  self.quickFinishBtn:SetActive(sealValid and ServantRecommendProxy.STATUS.GO == self.data.status)
  self.btn.gameObject:SetActive(showBtn)
  self.everPassLab.gameObject:SetActive(not showBtn)
  if sealValid then
    LuaVector3.Better_Set(tmpPos, 422, -32, 0)
  else
    LuaVector3.Better_Set(tmpPos, 422, self.progress.gameObject.activeSelf and -20 or 0, 0)
  end
  self.btn.gameObject.transform.localPosition = tmpPos
end
function ServantRecommendCell:UpdateRewards(rewardid, array)
  local list = ItemUtil.GetRewardItemIdsByTeamId(rewardid)
  if list then
    for i = 1, #list do
      local single = list[i]
      local hasAdd = false
      for j = 1, #array do
        local temp = array[j]
        if temp.id == single.id then
          temp.num = temp.num + single.num
          hasAdd = true
          break
        end
      end
      if not hasAdd then
        local itemData = ItemData.new("Reward", single.id)
        if itemData then
          itemData:SetItemNum(single.num)
          table.insert(array, itemData)
        end
      end
    end
  end
end
function ServantRecommendCell:handleClickReward(cellCtrl)
  if cellCtrl and cellCtrl.data then
    self.tipData.itemdata = cellCtrl.data
    self:ShowItemTip(self.tipData, cellCtrl.icon, NGUIUtil.AnchorSide.Left, {0, 0})
  end
end
