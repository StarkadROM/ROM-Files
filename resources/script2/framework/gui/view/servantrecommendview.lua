autoImport("WrapCellHelper")
autoImport("ServantRecommendCell")
autoImport("ServantRaidStatView")
local BTN_BG_IMG = {
  "taskmanual_btn_1",
  "taskmanual_btn_2"
}
local BTN_BG_IMG2 = {
  "taskmanual_btn_3",
  "taskmanual_btn_3b"
}
ServantRecommendView = class("ServantRecommendView", SubView)
ServantRecommendView._ColorEffectBlue = Color(0.25882352941176473, 0.4823529411764706, 0.7568627450980392, 1)
ServantRecommendView._ColorTitleGray = ColorUtil.TitleGray
local ColorEffectOrange = ColorUtil.ButtonLabelOrange
local ColorEffectBlue = ColorUtil.ButtonLabelBlue
local Prefab_Path = ResourcePathHelper.UIView("ServantRecommendView")
local KJMC_QUEST_ID = 305000001
local KJMC_GUIDE_QUEST_ID = 99090033
function ServantRecommendView:Init()
  self:FindObjs()
  self:AddUIEvts()
  self:AddViewEvts()
  self.chooseTypeId = 1
  self:ShowUI(self.chooseTypeId)
  self:UpdateWeekLimited()
end
function ServantRecommendView:FindObjs()
  self:LoadSubView()
  self.scrollView = self:FindComponent("ScrollView", UIScrollView)
  self.table = self:FindComponent("ItemWrap", UITable)
  self.cellCtl = UIGridListCtrl.new(self.table, ServantRecommendCell, "ServantRecommendCell")
  self.calendarBtn = self:FindGO("CalendarTog")
  self.raidstatBtn = self:FindGO("RaidStatTog")
  self:RegisterRedTipCheck(ServantRaidStatProxy.WholeRedTipID, self.raidstatBtn, 9, {-10, 0})
  self.recommendBtn = self:FindGO("RecommendTog")
  self:RegisterRedTipCheck(ServantRecommendProxy.WholeRedTipID, self.recommendBtn, 9, {-10, 0})
  self.calendarBtnImg = self.calendarBtn:GetComponent(UISprite)
  self.raidstatBtnImg = self.raidstatBtn:GetComponent(UISprite)
  self.recommendBtnImg = self.recommendBtn:GetComponent(UISprite)
  self.calendarLab = self:FindComponent("Lab", UILabel, self.calendarBtn)
  self.calendarLab.text = ZhString.Servant_Calendar_CalendarTogLab
  self.raidstatLab = self:FindComponent("Lab", UILabel, self.raidstatBtn)
  self.raidstatLab.text = ZhString.Servant_Calendar_RaidStatTogLab
  self.recommendLab = self:FindComponent("Lab", UILabel, self.recommendBtn)
  self.recommendLab.text = ZhString.Servant_Calendar_RecommendTogLab
  self.calPos = self:FindGO("calendarViewPos")
  self.raidstatPos = self:FindGO("raidstatViewPos")
  self.recomPos = self:FindGO("recommendPos")
  self.helpBtn = self:FindGO("HelpBtn")
  self:SetBtn(1)
  local dailyObj = self:FindGO("DailyToggle")
  self.dailyToggle = dailyObj:GetComponent(UIToggle)
  self.dailyLab = dailyObj:GetComponent(UILabel)
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_SERVANT_RECOMMNED_DAY, dailyObj, 6, {0, 6})
  self.dailyLab.text = ZhString.Servant_Recommend_PageDaily
  local weekObj = self:FindGO("WeeklyToggle")
  self.weeklyToggle = weekObj:GetComponent(UIToggle)
  self.weeklyLab = weekObj:GetComponent(UILabel)
  self.weeklyLab.text = ZhString.Servant_Recommend_PageWeek
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_SERVANT_RECOMMNED_WEEK, weekObj, 6, {0, 6})
  local guideObj = self:FindGO("GuideToggle")
  self.guideToggle = guideObj:GetComponent(UIToggle)
  self.guideLab = guideObj:GetComponent(UILabel)
  self.guideLab.text = ZhString.Servant_Recommend_PageGuide
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_SERVANT_RECOMMNED_FOREVER, guideObj, 6, {0, 6})
  local shortcutObj = self:FindGO("ShortCutToggle")
  self.shortcutToggle = shortcutObj:GetComponent(UIToggle)
  self.shortcutLab = shortcutObj:GetComponent(UILabel)
  self.shortcutLab.text = ZhString.Servant_Recommend_PageShortCut
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_SERVANT_RECOMMNED_SHORTCUT, shortcutObj, 6, {0, 6})
  self.weekLimitedLab = self:FindComponent("WeekLimitedLab", UILabel)
  self.fixedWeekLimitedLab = self:FindComponent("FixedWeekLimitedLab", UILabel)
  self.fixedWeekLimitedLab.text = ZhString.Servant_Recommend_WeeklyLimited
  self.favoriteItem = self:FindComponent("FavoriteItem", UISprite)
  self.empty = self:FindGO("Empty")
  local emptyLab = self:FindComponent("EmptyLab", UILabel)
  emptyLab.text = ZhString.Servant_Recommend_EmptyWeek
  self:Hide(self.raidstatBtn)
  self:Hide(guideObj)
  self:Hide(shortcutObj)
end
local maxLimited = GameConfig.Servant.recommend_max_coin or 4500
function ServantRecommendView:UpdateWeekLimited()
  local myServant = MyselfProxy.Instance:GetMyServantID()
  local favorCFG = HappyShopProxy.Instance:GetServantShopMap()
  local favoritemid = favorCFG and favorCFG[myServant] and favorCFG[myServant].npcFavoriteItemid or 100
  local iconName = Table_Item[favoritemid] and Table_Item[favoritemid].Icon or ""
  IconManager:SetItemIcon(iconName, self.favoriteItem)
  local weeknum = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_SERVANT_RECOMMEND_COIN) or 0
  self.weekLimitedLab.text = string.format(ZhString.GuildBuilding_Submit_MatNum, weeknum, maxLimited)
end
function ServantRecommendView:PageToggleChange(toggle, label, toggleColor, normalColor, handler, param)
  EventDelegate.Add(toggle.onChange, function()
    if toggle.value then
      label.color = toggleColor
      if handler ~= nil then
        self.chooseTypeId = param
        handler(self, param)
      end
    else
      label.color = normalColor
    end
  end)
end
function ServantRecommendView:SetBtn(var)
  self.isCalendar = false
  if var == 2 then
    self.calendarLab.effectColor = ColorEffectBlue
    self.raidstatLab.effectColor = ColorEffectOrange
    self.recommendLab.effectColor = ColorEffectBlue
    self.calendarBtnImg.spriteName = BTN_BG_IMG[1]
    self.raidstatBtnImg.spriteName = BTN_BG_IMG2[2]
    self.recommendBtnImg.spriteName = BTN_BG_IMG[1]
  elseif var == 3 then
    self.isCalendar = true
    self.calendarLab.effectColor = ColorEffectOrange
    self.raidstatLab.effectColor = ColorEffectBlue
    self.recommendLab.effectColor = ColorEffectBlue
    self.calendarBtnImg.spriteName = BTN_BG_IMG[2]
    self.raidstatBtnImg.spriteName = BTN_BG_IMG2[1]
    self.recommendBtnImg.spriteName = BTN_BG_IMG[1]
  else
    self.calendarLab.effectColor = ColorEffectBlue
    self.raidstatLab.effectColor = ColorEffectBlue
    self.recommendLab.effectColor = ColorEffectOrange
    self.calendarBtnImg.spriteName = BTN_BG_IMG[1]
    self.raidstatBtnImg.spriteName = BTN_BG_IMG2[1]
    self.recommendBtnImg.spriteName = BTN_BG_IMG[2]
  end
end
function ServantRecommendView:AddUIEvts()
  self:AddClickEvent(self.helpBtn, function()
    local data = Table_Help[30000]
    if data then
      TipsView.Me():ShowGeneralHelp(data.Desc)
    end
  end)
  self:AddClickEvent(self.calendarBtn, function(go)
    if not self.calendarView then
      self.calendarView = self:AddSubView("ServantCalendarView", ServantCalendarView)
    end
    self:SetBtn(3)
    self:Show(self.calPos)
    self:Hide(self.raidstatPos)
    self:Hide(self.recomPos)
    self.calendarView:OnClickWeekTog()
  end)
  self:AddClickEvent(self.raidstatBtn, function(go)
    if not self.raidstatView then
      self.raidstatView = self:AddSubView("ServantRaidStatView", ServantRaidStatView)
    end
    self:SetBtn(2)
    self:Hide(self.calPos)
    self:Show(self.raidstatPos)
    self:Hide(self.recomPos)
    self.container:SetMainTexture()
  end)
  self:AddClickEvent(self.recommendBtn, function(go)
    self:SetBtn(1)
    self:Hide(self.calPos)
    self:Hide(self.raidstatPos)
    self:Show(self.recomPos)
    self.container:SetMainTexture()
    self:ShowUI(self.chooseTypeId)
  end)
  self:PageToggleChange(self.dailyToggle, self.dailyLab, ServantRecommendView._ColorEffectBlue, ServantRecommendView._ColorTitleGray, self.ShowUI, 1)
  self:PageToggleChange(self.weeklyToggle, self.weeklyLab, ServantRecommendView._ColorEffectBlue, ServantRecommendView._ColorTitleGray, self.ShowUI, 2)
  self:PageToggleChange(self.guideToggle, self.guideLab, ServantRecommendView._ColorEffectBlue, ServantRecommendView._ColorTitleGray, self.ShowUI, 3)
  self:PageToggleChange(self.shortcutToggle, self.shortcutLab, ServantRecommendView._ColorEffectBlue, ServantRecommendView._ColorTitleGray, self.ShowUI, ServantRecommendProxy.TSHORTCUT)
end
function ServantRecommendView:LoadSubView()
  local container = self:FindGO("recommendView")
  local obj = self:LoadPreferb_ByFullPath(Prefab_Path, container, true)
  obj.name = "ServantRecommendView"
end
function ServantRecommendView:AddViewEvts()
  self:AddListenEvt(ServiceEvent.NUserRecommendServantUserCmd, self.RecvRecommendServant)
  self:AddListenEvt(ServiceEvent.NUserVarUpdate, self.HandleVarUpdate)
  self:AddListenEvt(ServiceEvent.QuestQuestUpdate, self.RecvRecommendServant)
  self:AddListenEvt(ServiceEvent.QuestQuestStepUpdate, self.HandleRecvQuestStepUpdate)
end
function ServantRecommendView:HandleVarUpdate()
  self:UpdateWeekLimited()
  self:RecvRecommendServant()
end
function ServantRecommendView:HandleRecvQuestStepUpdate(note)
  local questId = note.body.id
  if questId == KJMC_QUEST_ID or questId == KJMC_GUIDE_QUEST_ID then
    self:RecvRecommendServant()
  end
end
function ServantRecommendView:RecvRecommendServant(note)
  self:ShowUI(self.chooseTypeId)
end
function ServantRecommendView:ShowTexture()
  if self.isCalendar then
    local _, m = ServantCalendarProxy.Instance:ViewDate()
    self.container:SetSeasonTexture(m)
  else
    self.container:SetMainTexture()
  end
end
function ServantRecommendView:ShowUI(type)
  if self.fixedWeekLimitedLab == nil then
    return
  end
  local resultList = {}
  local doubleData
  if type == 1 then
    doubleData = ServantRecommendProxy.Instance:GetRecommendDataByType(6)
  elseif type == 2 then
    doubleData = ServantRecommendProxy.Instance:GetRecommendDataByType(9)
  end
  if doubleData and #doubleData > 0 then
    for i = 1, #doubleData do
      table.insert(resultList, doubleData[i])
    end
  end
  local data = ServantRecommendProxy.Instance:GetRecommendDataByType(type)
  if data and #data > 0 then
    for i = 1, #data do
      table.insert(resultList, data[i])
    end
  end
  table.sort(resultList, function(l, r)
    if l == nil or r == nil then
      return false
    end
    local lFinished = l.status == ServantRecommendProxy.STATUS.FINISHED
    local rFinished = r.status == ServantRecommendProxy.STATUS.FINISHED
    local lReceive = l.status == ServantRecommendProxy.STATUS.RECEIVE
    local rReceive = r.status == ServantRecommendProxy.STATUS.RECEIVE
    local lGo = l.status == ServantRecommendProxy.STATUS.GO
    local rGo = r.status == ServantRecommendProxy.STATUS.GO
    local lDouble = l.double
    local rDouble = r.double
    local sameRecycle = l.staticData.Recycle == r.staticData.Recycle
    if lDouble and rDouble then
      if sameRecycle then
        if l.staticData.Sort and r.staticData.Sort then
          return l.staticData.Sort < r.staticData.Sort
        elseif l.staticData.Sort or r.staticData.Sort then
          return l.staticData.Sort ~= nil
        else
          return l.staticData.id < r.staticData.id
        end
      else
        return l.staticData.Recycle > r.staticData.Recycle
      end
    end
    if lDouble or rDouble then
      return lDouble == true and not lFinished
    end
    if lReceive and rReceive then
      if sameRecycle then
        if l.staticData.Sort and r.staticData.Sort then
          return l.staticData.Sort < r.staticData.Sort
        elseif l.staticData.Sort or r.staticData.Sort then
          return l.staticData.Sort ~= nil
        else
          return l.staticData.id < r.staticData.id
        end
      else
        return l.staticData.Recycle > r.staticData.Recycle
      end
    end
    if lReceive or rReceive then
      return lReceive == true
    end
    if lGo and rGo then
      if sameRecycle then
        if l.staticData.Sort and r.staticData.Sort then
          return l.staticData.Sort < r.staticData.Sort
        elseif l.staticData.Sort or r.staticData.Sort then
          return l.staticData.Sort ~= nil
        else
          return l.staticData.id < r.staticData.id
        end
      else
        return l.staticData.Recycle > r.staticData.Recycle
      end
    end
    if lGo or rGo then
      return lGo == true
    end
    if lFinished and rFinished then
      if sameRecycle then
        if l.staticData.Sort and r.staticData.Sort then
          return l.staticData.Sort < r.staticData.Sort
        elseif l.staticData.Sort or r.staticData.Sort then
          return l.staticData.Sort ~= nil
        else
          return l.staticData.id < r.staticData.id
        end
      else
        return l.staticData.Recycle > r.staticData.Recycle
      end
    end
    if lFinished or rFinished then
      return lFinished == false
    end
  end)
  self.empty:SetActive(#resultList <= 0)
  self.cellCtl:ResetDatas(resultList)
  self.table:Reposition()
  self.scrollView:ResetPosition()
  ServantRecommendProxy.Instance:UpdateWholeRedTip()
  for k, cell in pairs(self.cellCtl:GetCells()) do
    if cell.data and cell.data.staticData.Finish == "wanted_quest_day" then
      self:AddOrRemoveGuideId(cell.bg, 520)
    end
  end
end
