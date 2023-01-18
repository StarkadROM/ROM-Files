autoImport("GuildHeadCell")
GuildFindPage = class("GuildFindPage", SubView)
autoImport("GuildCell")
local GvgDroiyanReward_Config = GameConfig.GvgDroiyan.GvgDroiyanReward
local HEAD_TEX = "shop_bg_05"
local GRAY_LABEL_COLOR = Color(0.5764705882352941, 0.5686274509803921, 0.5686274509803921, 1)
function GuildFindPage:Init(parent)
  local GuildFindPage = self:FindGO("GuildFindPage")
  if GuildFindPage ~= nil then
    GuildFindPage:SetActive(false)
  end
  self:CreatePageObj(parent)
  self:InitUI()
  self.searchConds = {}
  self:InitCityFilter()
  self:MapListenEvt()
  self.pageMap = {}
end
function GuildFindPage:AddSearchCond(cond)
  if not cond then
    return false
  end
  if not table.ContainsValue(self.searchConds, cond) then
    table.insert(self.searchConds, cond)
    return true
  end
  return false
end
function GuildFindPage:RemoveSearchCond(cond)
  if not cond then
    return false
  end
  for i = #self.searchConds, 1, -1 do
    if self.searchConds[i] == cond then
      table.remove(self.searchConds, i)
      return true
    end
  end
  return false
end
function GuildFindPage:ClearSearchConds()
  self.searchConds = {}
end
function GuildFindPage:CreatePageObj(parent)
  self.parent = parent
  if self.parent then
    self:LoadPreferb("view/GuildFindPage", self.parent, true)
  end
end
function GuildFindPage:InitUI()
  local guildWrap = self:FindGO("GuildWrapContent")
  local wrapConfig = {
    wrapObj = guildWrap,
    cellName = "GuildCell",
    control = GuildCell
  }
  self.guildlstCtl = WrapCellHelper.new(wrapConfig)
  self.guildlstCtl:AddEventListener(MouseEvent.MouseClick, self.ClickGuildCell, self)
  self.keyInput = self:FindComponent("Input", UIInput)
  local inputLimit = BranchMgr.IsJapan() and 12 or 8
  UIUtil.LimitInputCharacter(self.keyInput, inputLimit)
  self.loadingFlag = self:FindGO("Loading")
  self.loadingFlag:SetActive(true)
  self.noneTip = self:FindGO("NoneTip", self.parent)
  self.noneTipLab = self:FindComponent("Label", UILabel, self.noneTip)
  self.noneTipLab.text = ZhString.GuildFindPage_NoData
  self.noneTip:SetActive(false)
  self.exitCDTime = self:FindComponent("ExitCDTime", UILabel)
  local searchButton = self:FindGO("SearchButton")
  local searchLab = self:FindComponent("Label", UILabel, searchButton)
  searchLab.text = ZhString.GuildFindPage_Search
  self:AddClickEvent(searchButton, function()
    self:DoSearch()
  end)
  local gridTitle = self:FindGO("GridTitle")
  self.cityScaleTitle = self:FindComponent("CityScale", UILabel, gridTitle)
  self.recruitPos = self:FindGO("RecruitPos")
  self.unchooseLab = self:FindComponent("UnChooseGuild", UILabel, self.recruitPos)
  self.unchooseLab.text = ZhString.GuildFindPage_UnChoose
  self.infoPos = self:FindGO("InfoPos", self.recruitPos)
  local recruitTitle = self:FindComponent("RecruitTitle", UILabel, self.infoPos)
  recruitTitle.text = ZhString.GuildApproved_recruitLab
  self.recruitLab = self:FindComponent("RecruitLab", UILabel, self.infoPos)
  local chairman = self:FindComponent("ChairMan", UILabel, self.infoPos)
  chairman.text = ZhString.GuildApproved_ChairMan
  self.chairManLab = self:FindComponent("ChairManLab", UILabel, self.infoPos)
  self.guildLv = self:FindComponent("GuildLv", UILabel, self.infoPos)
  self.enterLevel = self:FindComponent("EnterLevel", UILabel, self.infoPos)
  self.cityName = self:FindComponent("City", UILabel, self.infoPos)
  self.guildGvg = self:FindComponent("GuildGvg", UILabel, self.infoPos)
  self.headTexture = self:FindComponent("HeadTexture", UITexture, self.infoPos)
  self.battleLine = self:FindComponent("BattleLine", UILabel, self.infoPos)
  self.changeLine = self:FindComponent("ChangeLine", UILabel, self.infoPos)
  self.changeLine.text = ZhString.GuildFindPage_ChangeLine
  self.currentLine = self:FindComponent("CurrentLine", UILabel, self.changeLine.gameObject)
  self.nextLine = self:FindComponent("NextLine", UILabel, self.changeLine.gameObject)
  self.changeBattleLine = self:FindComponent("ChangeBattleLine", UILabel, self.infoPos)
  self.changeBattleLine.text = ZhString.GuildFindPage_ChangeBattleLine
  self.currentBattleLine = self:FindComponent("CurrentBattleLine", UILabel, self.changeBattleLine.gameObject)
  self.nextBattleLine = self:FindComponent("NextBattleLine", UILabel, self.changeBattleLine.gameObject)
  self.changeBattleLineArrow = self:FindGO("Img", self.changeBattleLine.gameObject)
  self.applyBtn = self:FindComponent("ApplyBtn", UISprite, self.recruitPos)
  self.applyBtnCollider = self.applyBtn:GetComponent(BoxCollider)
  self.applyBtnTitle = self:FindComponent("ApplyBtnTitle", UILabel, self.applyBtn.gameObject)
  self.applyBtnTitle.text = ZhString.GuildFindPage_ApplyGuild
  self:ApplyBtnStateOn(false)
  local guildHeadCellGO = self:FindGO("GuildHeadCell")
  self.headCell = GuildHeadCell.new(guildHeadCellGO)
  self.headCell:SetCallIndex(UnionLogo.CallerIndex.UnionList)
  self.selectedGuildData = nil
  self:AddClickEvent(self.applyBtn.gameObject, function()
    if GuildProxy.Instance:IHaveGuild() then
      return
    end
    if self.selectedGuildData then
      if GuildProxy.Instance:IsInJoinCD() then
        MsgManager.ShowMsgByIDTable(4046)
        return
      end
      ServiceGuildCmdProxy.Instance:CallApplyGuildGuildCmd(self.selectedGuildData.id)
      self:ApplyBtnStateOn(false)
    end
  end)
  local scrollView = self:FindComponent("GuildScroll", UIScrollView)
  scrollView.momentumAmount = 100
  NGUIUtil.HelpChangePageByDrag(scrollView, function()
    self:GetPrePageGuilds()
  end, function()
    self:GetNextPageGuilds()
  end, 120)
  self.applyMercenaryBtn = self:FindComponent("ApplyMercenaryBtn", UISprite, self.recruitPos)
  self.applyMercenaryBtnCollider = self.applyMercenaryBtn:GetComponent(BoxCollider)
  self.applyMercenaryTitle = self:FindComponent("ApplyMercenaryTitle", UILabel, self.applyMercenaryBtn.gameObject)
  self:UpdateMercenaryBtn()
  self:AddClickEvent(self.applyMercenaryBtn.gameObject, function()
    self:OnMercenaryBtnClicked()
  end)
  self.condTable = self:FindComponent("CondTable", UITable, self.parent)
  self.condToggle_1 = self:FindComponent("CondToggle_1", UIToggle, self.condTable.gameObject)
  self.condLab_1 = self:FindComponent("CondLab", UILabel, self.condToggle_1.gameObject)
  self.condLab_1.text = ZhString.GuildFindPage_SearchCondNoApproval
  self.condToggle_1.value = false
  EventDelegate.Add(self.condToggle_1.onChange, function()
    if self.condToggle_1.value then
      if self:AddSearchCond(GuildCmd_pb.EQUERYGUILD_NOCHECK) then
        self:ClearAndDoSearch()
      end
    elseif self:RemoveSearchCond(GuildCmd_pb.EQUERYGUILD_NOCHECK) then
      self:ClearAndDoSearch()
    end
  end)
  self.condToggle_2 = self:FindComponent("CondToggle_2", UIToggle, self.condTable.gameObject)
  self.condLab_2 = self:FindComponent("CondLab", UILabel, self.condToggle_2.gameObject)
  self.condLab_2.text = ZhString.GuildFindPage_SearchCondMatchLevel
  self.condToggle_2.value = false
  EventDelegate.Add(self.condToggle_2.onChange, function()
    if self.condToggle_2.value then
      if self:AddSearchCond(GuildCmd_pb.EQUERYGUILD_LEVEL) then
        self:ClearAndDoSearch()
      end
    elseif self:RemoveSearchCond(GuildCmd_pb.EQUERYGUILD_LEVEL) then
      self:ClearAndDoSearch()
    end
  end)
  self.cityFilterPopup = self:FindComponent("CityFilterPopup", UIPopupList)
  EventDelegate.Add(self.cityFilterPopup.onChange, function()
    if not self.cityFilterPopup.data then
      return
    end
    self.cityScaleTitle.text = self:GetCityFilterTitle(self.cityFilterPopup.data)
    local queryType = math.floor(self.cityFilterPopup.data)
    local rmL = queryType ~= GuildCmd_pb.EQUERYGUILD_CITY_LARGE and self:RemoveSearchCond(GuildCmd_pb.EQUERYGUILD_CITY_LARGE)
    local rmM = queryType ~= GuildCmd_pb.EQUERYGUILD_CITY_MIDDLE and self:RemoveSearchCond(GuildCmd_pb.EQUERYGUILD_CITY_MIDDLE)
    local rmS = queryType ~= GuildCmd_pb.EQUERYGUILD_CITY_SMALL and self:RemoveSearchCond(GuildCmd_pb.EQUERYGUILD_CITY_SMALL)
    local addType = queryType > 0 and self:AddSearchCond(queryType)
    if addType or rmL or rmM or rmS then
      self:ClearAndDoSearch()
    end
  end)
  self.helpBtn = self:FindGO("HelpBtn")
  self:AddClickEvent(self.helpBtn, function()
    self:OnHelpClicked()
  end)
end
function GuildFindPage:OnHelpClicked()
  local Desc = Table_Help[524] and Table_Help[524].Desc or "Table_Help[524]"
  TipsView.Me():ShowGeneralHelp(Desc)
end
function GuildFindPage:ClearAndDoSearch()
  self.curPopData = nil
  self.nowPage = nil
  self.prePage = nil
  self:DoSearch()
end
function GuildFindPage:DoSearch()
  local key = self.keyInput.value
  if key and key ~= "" then
    self.keyword = key
    self:QueryGuildPageList(nil, key)
  else
    self.pageMap = {}
    self:QueryGuildPageList(1)
    self.guildlstCtl:ResetPosition()
  end
end
function GuildFindPage:GetMyGuildHeadData()
  if self.myGuildHeadData == nil then
    self.myGuildHeadData = GuildHeadData.new()
  end
  if self.selectedGuildData ~= nil then
    self.myGuildHeadData:SetBy_InfoId(self.selectedGuildData.portrait)
    self.myGuildHeadData:SetGuildId(self.selectedGuildData.id)
  end
  return self.myGuildHeadData
end
function GuildFindPage:InitCityFilter()
  local nameConfig, valueConfig = GuildProxy.Instance:GetGuildCityFilterConfig()
  if nameConfig and valueConfig and #nameConfig == #valueConfig then
    for i, name in ipairs(nameConfig) do
      self.cityFilterPopup:AddItem(name, valueConfig[i])
    end
  end
end
function GuildFindPage:ResetCitySearchFilter()
  local nameConfig, valueConfig = GuildProxy.Instance:GetGuildCityFilterConfig()
  if nameConfig and valueConfig and #valueConfig > 0 then
    self.cityFilterPopup.value = nameConfig[1]
  end
end
function GuildFindPage:GetFilterTitle(selectedValue)
  if self.rangeList and selectedValue == self.rangeList[1] then
    return ZhString.GuildFindPage_FilterTitleAll
  end
end
function GuildFindPage:GetCityFilterTitle(selectedValue)
  local nameConfig, valueConfig = GuildProxy.Instance:GetGuildCityFilterConfig()
  if nameConfig and valueConfig then
    for i, v in ipairs(valueConfig) do
      if v == selectedValue then
        if i == 1 then
          return ZhString.GuildFindPage_CityTitle
        else
          return nameConfig[i] or ""
        end
      end
    end
  end
  return ""
end
function GuildFindPage:ClickGuildCell(cellctl)
  local data = cellctl and cellctl.data
  if not data then
    return
  end
  self:HandleClickCell(data)
end
function GuildFindPage:HandleClickCell(data, forceRefresh)
  if not forceRefresh and self.selectedGuildData and self.selectedGuildData.guid == data.guid then
    return
  end
  self.selectedGuildData = data
  self.guildLv.text = string.format(ZhString.GuildFindPage_Lv, data.level)
  if data.gvglevel and data.gvglevel > 0 then
    self.guildGvg.gameObject:SetActive(true)
    self.guildGvg.text = string.format(ZhString.GuildFindPage_GvgLevel, GvgDroiyanReward_Config[data.gvglevel].LvDesc)
  else
    self.guildGvg.gameObject:SetActive(false)
  end
  self.changeLine.gameObject:SetActive(false)
  if data.battle_group and 0 < data.battle_group and data.zoneid and 0 < data.zoneid then
    if data.nextzoneid and data.nextzoneid ~= 0 then
      self.changeBattleLine.gameObject:SetActive(true)
      self.battleLine.gameObject:SetActive(false)
      self.currentBattleLine.text = string.format(ZhString.GuildFindPage_LineAndBattleLine, GvgProxy.ClientGroupId(data.battle_group), ChangeZoneProxy.Instance:ZoneNumToString(data.zoneid))
      self.nextBattleLine.text = string.format(ZhString.GuildFindPage_LineAndBattleLine, GvgProxy.ClientGroupId(data.next_battle_group), ChangeZoneProxy.Instance:ZoneNumToString(data.nextzoneid))
    else
      self.changeBattleLine.gameObject:SetActive(false)
      self.battleLine.gameObject:SetActive(true)
      self.battleLine.text = string.format(ZhString.GuildFindPage_BattleLine, GvgProxy.ClientGroupId(data.battle_group), ChangeZoneProxy.Instance:ZoneNumToString(data.zoneid))
    end
  else
    self.changeBattleLine.gameObject:SetActive(false)
    self.battleLine.gameObject:SetActive(false)
  end
  self.enterLevel.text = string.format(ZhString.GuildFindPage_EnterLevel, self.selectedGuildData.needlevel or 0)
  self.cityName.text = string.format(ZhString.GuildFindPage_City, self.selectedGuildData:GetOccupiedCityName())
  local hasGuild = GuildProxy.Instance:IHaveGuild()
  self:ApplyBtnStateOn(not hasGuild)
  self.headCell:SetData(self:GetMyGuildHeadData())
  self.chairManLab.text = data.chairmanname
  self.recruitLab.text = data.recruitinfo
  local cells = self.guildlstCtl:GetCellCtls()
  if cells then
    for i = 1, #cells do
      cells[i]:SetChoose(data.guid)
    end
  end
  self:UpdateMercenaryBtn()
end
function GuildFindPage:ApplyBtnStateOn(on)
  if on then
    self.applyBtnTitle.effectColor = ColorUtil.ButtonLabelOrange
    self.applyBtn.spriteName = "com_btn_2s"
    if self.applyBtnCollider then
      self.applyBtnCollider.enabled = true
    end
  else
    self.applyBtnTitle.effectColor = GRAY_LABEL_COLOR
    self.applyBtn.spriteName = "com_btn_13s"
    if self.applyBtnCollider then
      self.applyBtnCollider.enabled = false
    end
  end
end
function GuildFindPage:GetPrePageGuilds()
  if self.nowPage then
    local page = math.max(self.nowPage - 1, 1)
    self:QueryGuildPageList(page)
  end
end
function GuildFindPage:GetNextPageGuilds()
  if self.nowPage then
    local page = self.nowPage + 1
    if self.maxPage then
      page = math.min(self.maxPage, page)
    end
    self:QueryGuildPageList(page)
  end
end
function GuildFindPage:QueryGuildPageList(page, keyword)
  self.prePage = self.nowPage
  self.nowPage = page or 1
  if keyword then
    self.nowPage = nil
    self.prePage = nil
    self.pageMap = {}
    self.keyword = keyword
    self.loadingFlag:SetActive(true)
    ServiceGuildCmdProxy.Instance:CallQueryGuildListGuildCmd(keyword, 1, self.searchConds)
  elseif not self.pageMap[self.nowPage] then
    self.pageMap[self.nowPage] = 1
    self.loadingFlag:SetActive(true)
    ServiceGuildCmdProxy.Instance:CallQueryGuildListGuildCmd(nil, self.nowPage, self.searchConds)
    if self.nowPage > 1 then
      MsgManager.FloatMsg(nil, ZhString.GuildFindPage_Loading)
    end
  end
end
function GuildFindPage:MapListenEvt()
  self:AddListenEvt(ServiceEvent.GuildCmdQueryGuildListGuildCmd, self.HandleGuildListUpdate)
  self:AddListenEvt(GuildEvent.ExitMercenary, self.OnExitMercenary)
  self:AddListenEvt(GuildEvent.EnterMercenary, self.OnEnterMercenary)
  self:AddListenEvt(ServiceEvent.GuildCmdEnterGuildGuildCmd, self.OnEnterGuild)
end
function GuildFindPage:OnEnterGuild()
  self:UpdateMercenaryBtn()
end
function GuildFindPage:OnEnterMercenary()
  self:UpdateMercenaryBtn()
  self:DoSearch()
end
function GuildFindPage:OnExitMercenary()
  self:UpdateMercenaryBtn()
  self:DoSearch()
end
function GuildFindPage:HandleGuildListUpdate(note)
  self.loadingFlag:SetActive(false)
  local datas = GuildProxy.Instance:GetGuildList()
  local needResetPosition = false
  if self.keyword then
    self.keyword = nil
    self.guildlstCtl:ResetDatas(datas)
    needResetPosition = true
  elseif self.prePage then
    if #datas > 0 then
      if self.nowPage < self.prePage then
        for i = #datas, 1, -1 do
          self.guildlstCtl:InsertData(datas[i], 1)
        end
      elseif self.prePage < self.nowPage then
        for i = 1, #datas do
          self.guildlstCtl:InsertData(datas[i])
        end
      end
    else
      self.nowPage = self.prePage
      self.maxPage = self.nowPage
    end
  elseif self.nowPage then
    self.guildlstCtl:ResetDatas(datas)
    needResetPosition = true
  end
  local alldatas = self.guildlstCtl:GetDatas()
  self:ApplyBtnStateOn(false)
  if #alldatas > 0 then
    if #datas > 0 then
      self:HandleClickCell(datas[1], true)
    end
    self.noneTip:SetActive(false)
    self.infoPos:SetActive(true)
    self.unchooseLab.gameObject:SetActive(false)
  else
    self.noneTip:SetActive(true)
    self.infoPos:SetActive(false)
    self.unchooseLab.gameObject:SetActive(true)
    self.selectedGuildData = nil
  end
  if needResetPosition then
    self.guildlstCtl:ResetPosition()
  end
  self:UpdateMercenaryBtn()
end
function GuildFindPage:UpdateCDTime()
  local exit_timetick = GuildProxy.Instance:GetExitTimeTick()
  if exit_timetick == nil or exit_timetick == 0 then
    self.exitCDTime.text = ""
    self.exitCDTime.gameObject:SetActive(false)
    self.condTable:Reposition()
    return
  end
  local delta_sec = ServerTime.ServerDeltaSecondTime(exit_timetick * 1000)
  if delta_sec <= 0 then
    self.exitCDTime.text = ""
    self.exitCDTime.gameObject:SetActive(false)
    self.condTable:Reposition()
    return
  end
  self.exitCDTime.gameObject:SetActive(true)
  local hour = math.ceil(delta_sec / 3600)
  self.exitCDTime.text = string.format(ZhString.GuildFindPage_ExitCDTip, hour)
  self.condTable:Reposition()
end
function GuildFindPage:OnEnter()
  GuildFindPage.super.OnEnter(self)
  PictureManager.Instance:SetUI(HEAD_TEX, self.headTexture)
  self:QueryGuildPageList(1)
  self:UpdateCDTime()
end
function GuildFindPage:OnExit()
  PictureManager.Instance:UnLoadUI(HEAD_TEX, self.headTexture)
  GuildFindPage.super.OnExit(self)
end
function GuildFindPage:UpdateMercenaryBtn()
  local proxy = GuildProxy.Instance
  local myMercenaryGuildData = proxy:GetMyMercenaryGuildData()
  local isMyMercenaryGuild = proxy:IsMyMercenaryGuild(self.selectedGuildData and self.selectedGuildData.id)
  local isMyGuild = proxy:IsMyGuild(self.selectedGuildData and self.selectedGuildData.id)
  local canClick = true
  if not self.selectedGuildData or self.selectedGuildData.id <= 0 then
    self.applyMercenaryTitle.text = ZhString.GuildFindPage_ApplyMercenary
    self.applyMercenaryTitle.effectColor = GRAY_LABEL_COLOR
    self.applyMercenaryBtn.spriteName = "com_btn_13s"
    canClick = false
  elseif myMercenaryGuildData and myMercenaryGuildData.id and myMercenaryGuildData.id > 0 then
    if isMyMercenaryGuild then
      self.applyMercenaryTitle.text = ZhString.GuildFindPage_QuitMercenary
      self.applyMercenaryTitle.effectColor = ColorUtil.ButtonLabelBlue
      self.applyMercenaryBtn.spriteName = "com_btn_1s"
    else
      self.applyMercenaryTitle.text = ZhString.GuildFindPage_ApplyMercenary
      self.applyMercenaryTitle.effectColor = GRAY_LABEL_COLOR
      self.applyMercenaryBtn.spriteName = "com_btn_13s"
      canClick = false
    end
  else
    self.applyMercenaryTitle.text = ZhString.GuildFindPage_ApplyMercenary
    if isMyGuild then
      self.applyMercenaryTitle.effectColor = GRAY_LABEL_COLOR
      self.applyMercenaryBtn.spriteName = "com_btn_13s"
      canClick = false
    else
      self.applyMercenaryTitle.effectColor = ColorUtil.ButtonLabelBlue
      self.applyMercenaryBtn.spriteName = "com_btn_1s"
    end
  end
  if self.applyMercenaryBtnCollider then
    self.applyMercenaryBtnCollider.enabled = canClick
  end
end
function GuildFindPage:OnMercenaryBtnClicked()
  if not self.selectedGuildData then
    return
  end
  local proxy = GuildProxy.Instance
  local selectedGuildId = self.selectedGuildData.id
  local myMercenaryGuildData = proxy:GetMyMercenaryGuildData()
  local myMercenaryGuildId = myMercenaryGuildData and myMercenaryGuildData.id
  if myMercenaryGuildId and myMercenaryGuildId > 0 then
    if proxy:IsMyMercenaryGuild(selectedGuildId) then
      MsgManager.ConfirmMsgByID(31039, function()
        ServiceGuildCmdProxy.Instance:CallExitGuildGuildCmd(myMercenaryGuildData.id)
      end)
    end
  elseif not proxy:IsMyGuild(selectedGuildId) then
    ServiceGuildCmdProxy.Instance:CallApplyGuildGuildCmd(selectedGuildId, GuildCmd_pb.EGUILDJOB_APPLY_MERCENARY)
  end
end
