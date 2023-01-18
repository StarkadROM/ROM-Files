autoImport("MiniGameCell")
autoImport("MiniGameRewardCell")
autoImport("ServiceMiniGameCmdAutoProxy")
autoImport("DailyCountCell")
MiniGameEntranceView = class("MiniGameEntranceView", ContainerView)
MiniGameEntranceView.ViewType = UIViewType.NormalLayer
local TEXTURE = {
  "monsterphoto",
  "cardpairs",
  "monsteranswer"
}
local progressSTR = ZhString.MiniGame_CardLevel
local Color_Gray = Color(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 1)
local Color_White = Color(1, 1, 1, 1)
local Config = {
  [1] = {
    id = 1,
    name = ZhString.MiniGame_GameName1,
    pic = "Games_pic_mwsy",
    key = MiniGameCmd_pb.EMINIGAMETYPE_MONSTER_PHOTO,
    panelid = 2033
  },
  [2] = {
    id = 2,
    name = ZhString.MiniGame_GameName2,
    pic = "Games_pic_kppd",
    key = MiniGameCmd_pb.EMINIGAMETYPE_CARD_PAIR,
    panelid = 2031
  },
  [3] = {
    id = 3,
    name = ZhString.MiniGame_GameName3,
    pic = "Games_pic_mwwd",
    key = MiniGameCmd_pb.EMINIGAMETYPE_MONSTER_ANSWER,
    panelid = 2032
  }
}
local DATA_FORMAT = "%Y/%m/%d %H:%M:%S"
function MiniGameEntranceView:Init()
  self.challengeFilterData = 99
  self:FindObjs()
  self:AddEvts()
  self:InitShow()
end
function MiniGameEntranceView:FindObjs()
  self.gameCover = self:FindGO("gameCover"):GetComponent(UITexture)
  self.popUpList = self:FindGO("popUpList"):GetComponent(UIPopupList)
  local rewardGrid = self:FindGO("rewardGrid"):GetComponent(UIGrid)
  self.rewardGridCtrl = UIGridListCtrl.new(rewardGrid, MiniGameRewardCell, "MiniGameRewardCell")
  local typeGrid = self:FindGO("typeGrid"):GetComponent(UIGrid)
  self.typeGridCtrl = UIGridListCtrl.new(typeGrid, MiniGameCell, "MiniGameCell")
  self.currentLv = self:FindGO("currentLv"):GetComponent(UILabel)
  self.gameLabel = self:FindGO("gameLabel"):GetComponent(UILabel)
  self.rewardStatus = self:FindGO("rewardStatus")
  self.rewardContainer = self:FindGO("RewardContainer")
  self.recordContainer = self:FindGO("RecordContainer")
  self.record = self:FindGO("record", self.recordContainer):GetComponent(UILabel)
  self.recordtime = self:FindGO("recordtime", self.recordContainer):GetComponent(UILabel)
  self.noRecordTip = self:FindGO("noRecordTip")
  self.recordContent = self:FindGO("recordContent")
  self.dailyContainer = self:FindGO("DailyContainer")
  self.dailyGrid = self:FindGO("Grid", self.dailyContainer):GetComponent(UIGrid)
  self.dailyGridCtrl = UIGridListCtrl.new(self.dailyGrid, DailyCountCell, "DailyCountCell")
end
function MiniGameEntranceView:AddEvts()
  EventDelegate.Add(self.popUpList.onChange, function()
    if self.popUpList.data == nil then
      return
    end
    if self.filterData ~= self.popUpList.data then
      self.filterData = self.popUpList.data
      self.curFilterValuel = self.popUpList.value
      if self.filterData < self.challengeFilterData then
        self.rewardContainer:SetActive(true)
        self:SetReward(self.currentType)
        self.recordContainer:SetActive(false)
      else
        self.rewardContainer:SetActive(false)
        self.recordContainer:SetActive(true)
        self:SetRecord(self.currentType)
      end
      self:SetReward(self.currentType)
    end
  end)
  self:AddClickEvent(self:FindGO("enterBtn"), function()
    self:CallEnter()
  end)
  local panelid
  self:AddClickEvent(self:FindGO("helpBtn"), function()
    if not self.currentType then
      return
    end
    panelid = Config[self.currentType].panelid
    local Desc = Table_Help[panelid] and Table_Help[panelid].Desc or ZhString.Help_RuleDes
    TipsView.Me():ShowGeneralHelp(Desc)
  end)
  self.rewardGridCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickItemCell, self)
  self.typeGridCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickMiniGameCell, self)
  self:AddListenEvt(PVPEvent.PVEDungeonLaunch, self.HandleDungeonLaunch)
  self:AddListenEvt(ServiceEvent.MiniGameCmdMiniGameUnlockList, self.InitShow)
  self:AddListenEvt(LoadSceneEvent.FinishLoad, self.CloseSelf)
  self:AddListenEvt(PVEEvent.MiniGameMonsterShot_PreLaunch, self.HandleDungeonLaunch)
  self:AddClickEvent(self:FindGO("rankBtn"), function()
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.MiniGameRankPopUp,
      viewdata = self.currentType and Config[self.currentType].key
    })
  end)
end
function MiniGameEntranceView:HandleDungeonLaunch(note)
  self:CloseSelf()
end
function MiniGameEntranceView:ClickItemCell(cell)
  local itemid = cell.itemid
  if not itemid then
    self:ShowItemTip()
    return
  end
  local sdata = {
    itemdata = ItemData.new("", itemid),
    funcConfig = {},
    ignoreBounds = ignoreBounds,
    hideGetPath = true
  }
  self:ShowItemTip(sdata, cell.icon, NGUIUtil.AnchorSide.Left, {-212, 0})
end
local progress
local rewardIndex = 1
local pbKey = 1
function MiniGameEntranceView:ClickMiniGameCell(cell)
  local data = cell.data
  if not data then
    return
  end
  self.currentType = data.id
  self:SetUpUI(self.currentType)
  local cells = self.typeGridCtrl:GetCells()
  for i = 1, #cells do
    cells[i]:UpdateChoose(cells[i].id == self.currentType)
  end
  self.progressMap = MiniGameProxy.Instance:GetMiniGameUnlockList()
  pbKey = Config[self.currentType].key
  progress = self.progressMap[pbKey] or 1
  local isCleared = MiniGameProxy.Instance:IsCleared(pbKey)
  self:InitFilter(progress, isCleared)
  if not isCleared then
    self.rewardContainer:SetActive(true)
    self:SetReward(self.currentType)
    self.recordContainer:SetActive(false)
  else
    self.rewardContainer:SetActive(false)
    self.recordContainer:SetActive(true)
    self:SetRecord(self.currentType)
  end
end
local rewardList
function MiniGameEntranceView:SetReward(currentType)
  self.progressMap = MiniGameProxy.Instance:GetMiniGameUnlockList()
  pbKey = Config[currentType].key
  rewardIndex = self.filterData + pbKey * 100
  if rewardIndex and Table_Minigame_reward[rewardIndex] then
    self.rewardGridCtrl:ResetDatas(Table_Minigame_reward[rewardIndex].Reward or {})
  end
  local got = MiniGameProxy.Instance:CheckRewardGet(pbKey, self.filterData)
  self.rewardStatus:SetActive(got)
end
function MiniGameEntranceView:SetRecord(currentType)
  pbKey = Config[currentType].key
  local record, time = MiniGameProxy.Instance:GetChallengeRecord(pbKey)
  self.recordContent:SetActive(record ~= 0)
  self.noRecordTip:SetActive(record == 0)
  if record ~= 0 then
    self.record.text = record
    self.recordtime.text = os.date(DATA_FORMAT, time)
  end
end
function MiniGameEntranceView:InitFilter(currentProgress, isCleared)
  if not self.popUpList then
    return
  end
  self.popUpList:Clear()
  for i = 1, currentProgress do
    self.popUpList:AddItem(string.format(progressSTR, i), i)
  end
  if isCleared then
    self.popUpList:AddItem(ZhString.MiniGame_ChallengeMode, self.challengeFilterData)
    self.popUpList.value = ZhString.MiniGame_ChallengeMode
    self.filterData = self.challengeFilterData
  else
    self.popUpList.value = string.format(progressSTR, currentProgress)
    self.filterData = currentProgress
  end
end
function MiniGameEntranceView:InitShow(note)
  self.typeGridCtrl:ResetDatas(Config)
  local showdata = {}
  showdata.data = Config[1]
  showdata.id = 1
  self:ClickMiniGameCell(showdata)
end
function MiniGameEntranceView:SetUpUI(key)
  if not key or not TEXTURE[key] or not self.progressMap then
    return
  end
  self.pic = TEXTURE[key]
  PictureManager.Instance:SetUI(self.pic, self.gameCover)
  self.gameLabel.text = Config[key].name
  local leftcount = MiniGameProxy.Instance:GetDailyRest(Config[key].key)
  pbKey = Config[self.currentType].key
  local isCleared = MiniGameProxy.Instance:IsCleared(pbKey)
  if not isCleared then
    self.currentLv.text = string.format("Lv.%d", self.progressMap[Config[key].key] or 1)
  else
    self.currentLv.text = ZhString.MiniGame_ChallengeMode
  end
  local max = GameConfig.MiniGame.DailyLimit[pbKey][2]
  local counts = {}
  for i = 1, max do
    local entry = {}
    entry.id = i
    entry.active = i <= leftcount
    TableUtility.ArrayPushBack(counts, entry)
  end
  self.dailyGridCtrl:ResetDatas(counts)
end
function MiniGameEntranceView:OnEnter()
  MiniGameEntranceView.super.OnEnter(self)
end
function MiniGameEntranceView:OnExit()
  local cells = self.typeGridCtrl:GetCells()
  for i = 1, #cells do
    cells[i]:OnDestroy()
  end
  MiniGameEntranceView.super.OnExit(self)
  if self.pic then
    PictureManager.Instance:UnLoadUI(self.pic, self.gameCover)
  end
end
function MiniGameEntranceView:CallEnter()
  local pbKey = Config[self.currentType].key
  local isCleared = MiniGameProxy.Instance:IsCleared(pbKey)
  local currentmode = 0
  if isCleared and self.filterData == self.challengeFilterData then
    currentmode = MiniGameCmd_pb.EMINIGAMEMODE_CHALLENGE
  else
    currentmode = MiniGameCmd_pb.EMINIGAMEMODE_NORMAL
  end
  if self.currentType == 2 then
    ServiceMiniGameCmdAutoProxy:CallMiniGameAction(currentmode, MiniGameCmd_pb.EMINIGAMETYPE_CARD_PAIR, self.filterData, MiniGameCmd_pb.EMINIGAME_ERROR_NONE, false)
  elseif self.currentType == 3 then
    ServiceMiniGameCmdAutoProxy:CallMiniGameAction(currentmode, MiniGameCmd_pb.EMINIGAMETYPE_MONSTER_ANSWER, self.filterData)
    self:CloseSelf()
  elseif self.currentType == 1 then
    if FunctionUnLockFunc.Me():CheckCanOpenByPanelId(PanelConfig.PhotographPanel.id, true) then
      ServiceMiniGameCmdAutoProxy:CallMiniGameAction(currentmode, MiniGameCmd_pb.EMINIGAMETYPE_MONSTER_PHOTO, self.filterData)
    else
      MsgManager.FloatMsg("", ZhString.MiniGame_MonsterShot_FuncLock)
    end
  end
end
