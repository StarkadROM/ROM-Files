AdventureHomePage = class("AdventureHomePage", SubView)
autoImport("AdventureProfessionCell")
autoImport("AdventureCollectionAchShowCell")
autoImport("AdventureAchievementCell")
autoImport("AdventureRewardPanel")
autoImport("AdventureFriendCell")
autoImport("Charactor")
autoImport("ProfessionSkillCell")
autoImport("AdventureAttrCell")
local tempArray = {}
AdventureHomePage.ProfessionIconClick = "ProfessionPage_ProfessionIconClick"
function AdventureHomePage:Init()
  self:initView()
  self:addViewEventListener()
  self:AddListenerEvts()
  self:initData()
end
function AdventureHomePage:initView()
  self.gameObject = self:FindGO("AdventureHomePage")
  self.playerName = self:FindGO("UserName"):GetComponent(UILabel)
  self.manualPoint = self:FindComponent("manualPoint", UILabel)
  self.manualLevel = self:FindComponent("manualLevel", UILabel)
  self.achievementScoreSlider = self:FindGO("progressCt", self:FindGO("achievementCt")):GetComponent(UISlider)
  self.achievementCurScore = self:FindGO("curScore", self:FindGO("achievementCt")):GetComponent(UILabel)
  local rewardLabel = self:FindGO("rewardLabel"):GetComponent(UILabel)
  self.levelGrid = self:FindGO("levelGrid"):GetComponent(UIGrid)
  rewardLabel.text = ZhString.AdventureRewardPanel_RewardLabel
  self.friendScrollview = self:FindGO("friendRankCt")
  self.friendScrollview = self:FindComponent("content", UIScrollView, self.friendScrollview)
  self.myRank = self:FindComponent("myRank", UILabel)
  self.loading = self:FindGO("Loading")
  local ContentContainer = self:FindGO("ContentContainer")
  local wrapConfig = {
    wrapObj = ContentContainer,
    pfbNum = 7,
    cellName = "AdventureFriendCell",
    control = AdventureFriendCell,
    dir = 1,
    disableDragIfFit = true
  }
  self.itemWrapHelper = WrapCellHelper.new(wrapConfig)
  self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
  self.descriptionText = self:FindGO("DescriptionText"):GetComponent(UILabel)
  self.secondContent = self:FindGO("secondContent")
  local secondContentTitle = self:FindComponent("secondContentTitle", UILabel)
  secondContentTitle.text = ZhString.AdventureHomePage_SecondContentTitle
  local collectionShowGrid = self:FindComponent("adventureProgressGrid", UIGrid)
  self.collectionShowGrid = UIGridListCtrl.new(collectionShowGrid, AdventureCollectionAchShowCell, "AdventureCollectionAchShowCell")
  self.thirdContent = self:FindGO("thirdContent")
  self.thirdContentTitle = self:FindComponent("thirdContentTitle", UILabel)
  self.fourthContent = self:FindGO("fourthContent")
  self.fourthContentTitle = self:FindComponent("fourthContentTitle", UILabel)
  local unlockAdventureSkillTitle = self:FindComponent("unlockAdventureSkillTitle", UILabel)
  unlockAdventureSkillTitle.text = ZhString.AdventureHomePage_UnlockSkillitle
  self.fourthSrl = self:FindComponent("ScrollView", UIScrollView, self.fourthContent)
  local nextSkills = self:FindComponent("unlockAdventureSkillGrid", UIGrid)
  self.nextSkillsGrid = UIGridListCtrl.new(nextSkills, ProfessionSkillCell, "ProfessionSkillCell")
  self.nextSkillsGrid:AddEventListener(MouseEvent.MouseClick, self.cellClick, self)
  self.propBord = self:FindGO("PropBord")
  local proptyBtn = self:FindGO("proptyBtn")
  local lable = self:FindComponent("Label", UILabel, proptyBtn)
  lable.text = ZhString.AdventureHomePage_PropBordBtn
  IconManager:SetUIIcon("123", self:FindComponent("Sprite", UISprite, proptyBtn))
  self:AddClickEvent(proptyBtn, function()
    if PvpProxy.Instance:IsFreeFire() or TwelvePvPProxy.Instance:IsInNormalTwelvePvp() then
      MsgManager.ShowMsgByIDTable(26259)
      return
    end
    self:showPropView()
  end)
  self.oneClickActivateBtn = self:FindGO("oneClickActivateBtn")
  self.oneClickFakeActivateBtn = self:FindGO("oneClickFakeActivateBtn")
  self:AddClickEvent(self.oneClickActivateBtn, function()
    self:CallOneClickActivate()
  end)
  self:AddButtonEvent("PropBordClose", function()
    self:Hide(self.propBord)
  end)
  self:AddButtonEvent("PropBordHelp", function()
    local data = Table_Help[100001]
    if data then
      TipsView.Me():ShowGeneralHelp(data.Desc, data.Title)
    end
  end)
  lable = self:FindComponent("PropBordTitle", UILabel)
  lable.text = ZhString.AdventureHomePage_PropBordTitleDes
  lable = self:FindComponent("emptyDes", UILabel)
  lable.text = ZhString.AdventureHomePage_EmptyPropDes
  self.emptyCt = self:FindGO("emptyCt")
  self.appellationPropCt = self:FindGO("AppellationPropCt")
  self.applationTitle = self:FindComponent("title", UILabel, self.appellationPropCt)
  local grid = self:FindComponent("Grid", UIGrid, self.appellationPropCt)
  self.appellationGrid = UIGridListCtrl.new(grid, AdventureAttrCell, "AdventureAttrCell")
  self.adventurePropCt = self:FindGO("AdventurePropCt")
  local title = self:FindComponent("title", UILabel, self.adventurePropCt)
  title.text = ZhString.AdventureHomePage_PropBordPropTitleDes
  grid = self:FindComponent("Grid", UIGrid, self.adventurePropCt)
  self.adventurePropGrid = UIGridListCtrl.new(grid, AdventureAttrCell, "AdventureAttrCell")
end
function AdventureHomePage:cellClick(obj)
  local skillId = obj.data
  local skillItem = SkillItemData.new(skillId, nil, nil, MyselfProxy.Instance:GetMyProfession())
  local tipData = {}
  tipData.data = skillItem
  TipsView.Me():ShowTip(SkillTip, tipData, "SkillTip")
  local tip = TipsView.Me().currentTip
  if tip then
    tip.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(200, 0, 0)
  end
end
function AdventureHomePage:Show(target)
  AdventureHomePage.super.Show(self, target)
  self:setCurrentAchIcon()
  self:setCollectionAchievement()
  self:setAdventureLevel()
  self:setAppellationLevel()
end
function AdventureHomePage:initData()
  self.playerName.text = Game.Myself.data:GetName()
  self.manualScore = nil
end
function AdventureHomePage:SetData()
  self:setCurrentAchIcon()
  self:setCollectionAchievement()
  self:setAdventureLevel()
  self:setAppellationLevel()
  self:setAchievementScore()
  self:showScoreUpdateAnim()
  self:UpdateOneClickActivate()
end
function AdventureHomePage:showNextSkillInfo()
  local skills = self:unlockAdventureSkills()
  if skills and #skills > 0 then
    TableUtility.ArrayClear(tempArray)
    for i = 1, #skills do
      local data = {}
      data[1] = MyselfProxy.Instance:GetMyProfession()
      data[2] = skills[i]
      tempArray[#tempArray + 1] = data
    end
    self.nextSkillsGrid:ResetDatas(tempArray)
  end
end
function AdventureHomePage:unlockAdventureSkills()
  local achData = MyselfProxy.Instance:GetCurManualAppellation()
  if achData then
    local skills = AdventureDataProxy.Instance:getAdventureSkillByAppellation(achData.staticData.PostID)
    return skills
  end
end
function AdventureHomePage:showScoreUpdateAnim()
  self:setAchievementScore()
  local curScore = AdventureDataProxy.Instance:getPointData()
  if self.manualScore and curScore ~= self.manualScore then
    local score = curScore - self.manualScore
    if score < 0 then
      local manualLevel = AdventureDataProxy.Instance:getManualLevel()
      if Table_AdventureLevel[manualLevel - 1] then
        score = curScore + Table_AdventureLevel[manualLevel - 1].AdventureExp - self.manualScore
      end
    end
    MsgManager.ShowMsgByIDTable(44, {score})
  end
  self.manualScore = curScore
end
function AdventureHomePage:setCurrentAchIcon()
  local achData = MyselfProxy.Instance:GetCurManualAppellation()
  if achData then
    local manualLevel = AdventureDataProxy.Instance:getManualLevel()
    local itemData = Table_Item[achData.id]
    if itemData then
      self.descriptionText.text = string.format(ZhString.AdventureHomePage_AppellationDes, itemData.NameZh)
      self.manualLevel.text = string.format(ZhString.AdventureHomePage_manualLevel, manualLevel)
    else
      errorLog("AdventureHomePage:setCurrentAchIcon can't find ItemData by id:", achData.id)
    end
  else
    errorLog("AdventureHomePage:appellation is nil")
  end
end
function AdventureHomePage:setCollectionAchievement()
  local bd = NGUIMath.CalculateRelativeWidgetBounds(self.descriptionText.transform)
  local height = bd.size.y
  local x, y, z = LuaGameObject.GetLocalPosition(self.descriptionText.transform)
  y = y - height - 20
  local x1, y1, z1 = LuaGameObject.GetLocalPosition(self.secondContent.transform)
  self.secondContent.transform.localPosition = LuaGeometry.GetTempVector3(x1, y, z1)
  local list = ReusableTable.CreateArray()
  for key, bgData in pairs(AdventureDataProxy.Instance.bagMap) do
    if bgData.tableData then
      if bgData.tableData.Position == 1 or bgData.tableData.Position == 3 or key == SceneManual_pb.EMANUALTYPE_MOUNT then
        table.insert(list, bgData)
      end
    else
      LogUtility.Error("error table data ")
    end
  end
  table.sort(list, function(l, r)
    local lTable = Table_ItemTypeAdventureLog[l.type]
    local rTable = Table_ItemTypeAdventureLog[r.type]
    local lOrder = lTable.Order or 0
    local rOrder = rTable.Order or 0
    return lOrder < rOrder
  end)
  self.collectionShowGrid:ResetDatas(list)
  ReusableTable.DestroyAndClearArray(list)
end
function AdventureHomePage:OnEnter()
  AdventureHomePage.super.OnEnter(self)
  self:setAchievementScore()
  ServiceSessionSocialityProxy.Instance:CallFrameStatusSocialCmd(true)
  self:setFriendAdData(true)
  self:UpdateHead()
  self:initScoreData()
  self:UpdateOneClickActivate()
end
function AdventureHomePage:initScoreData()
  local curScore = AdventureDataProxy.Instance:getPointData()
  self.manualScore = curScore
end
function AdventureHomePage:OnExit()
  self.manualScore = nil
  ServiceSessionSocialityProxy.Instance:CallFrameStatusSocialCmd(false)
  AdventureHomePage.super.OnExit(self)
end
function AdventureHomePage:OnDestroy()
  self.itemWrapHelper:Destroy()
  AdventureHomePage.super.OnDestroy(self)
end
function AdventureHomePage:setAdventureLevel()
  local bd = NGUIMath.CalculateRelativeWidgetBounds(self.secondContent.transform)
  local height = bd.size.y
  local x, y, z = LuaGameObject.GetLocalPosition(self.secondContent.transform)
  local manualLevel = AdventureDataProxy.Instance:getManualLevel()
  local nextLevel = AdventureDataProxy.Instance:getNextAdventureLevelProp(manualLevel)
  y = y - height - 20
  if nextLevel ~= "" then
    self.thirdContentTitle.text = string.format(ZhString.AdventureHomePage_ThirdContentTitle, manualLevel, manualLevel + 1, nextLevel)
  else
    self.thirdContentTitle.text = string.format(ZhString.AdventureHomePage_ThirdContentTitle, manualLevel, manualLevel + 1, "Max")
  end
  local x1, y1, z1 = LuaGameObject.GetLocalPosition(self.thirdContent.transform)
  self.thirdContent.transform.localPosition = LuaGeometry.GetTempVector3(x1, y, z1)
end
function AdventureHomePage:setAppellationLevel()
  local bd = NGUIMath.CalculateRelativeWidgetBounds(self.thirdContent.transform)
  local height = bd.size.y
  local x, y, z = LuaGameObject.GetLocalPosition(self.thirdContent.transform)
  y = y - height - 20
  local sRet = AdventureDataProxy.Instance:getNextAppellationProp()
  local achData = MyselfProxy.Instance:GetCurManualAppellation()
  if sRet ~= "" then
    local needLv = GameConfig.AdventureAppellationLevel and GameConfig.AdventureAppellationLevel[achData.staticData.PostID]
    self.fourthContentTitle.text = string.format(ZhString.AdventureHomePage_FourThContentTitle, needLv, sRet)
  end
  local x1, y1, z1 = LuaGameObject.GetLocalPosition(self.fourthContent.transform)
  self.fourthContent.transform.localPosition = LuaGeometry.GetTempVector3(x1, y, z1)
  bd = NGUIMath.CalculateRelativeWidgetBounds(self.fourthContentTitle.transform)
  local height = bd.size.y
  local x, y, z = LuaGameObject.GetLocalPosition(self.fourthContentTitle.transform)
  y = y - height - 95
  local x1, y1, z1 = LuaGameObject.GetLocalPosition(self.fourthSrl.transform)
  self.fourthSrl.transform.localPosition = LuaGeometry.GetTempVector3(x1, y, z1)
  self:showNextSkillInfo()
end
function AdventureHomePage:setAchievementScore()
  local score = AdventureDataProxy.Instance:getPointData()
  local curAch = AdventureDataProxy.Instance:getCurAchievement()
  local nextScore = curAch.AdventureExp
  local manualLevel = AdventureDataProxy.Instance:getManualLevel()
  manualLevel = StringUtil.StringToCharArray(tostring(manualLevel))
  Game.GameObjectUtil:DestroyAllChildren(self.levelGrid.gameObject)
  for i = 1, #manualLevel do
    local obj = GameObject("tx")
    obj.transform:SetParent(self.levelGrid.transform, false)
    obj.layer = self.levelGrid.gameObject.layer
    obj.transform.localPosition = LuaGeometry.Const_V3_zero
    local sprite = obj:AddComponent(UISprite)
    sprite.depth = 100
    local atlas = RO.AtlasMap.GetAtlas("NewCom")
    sprite.atlas = atlas
    sprite.spriteName = string.format("txt_%d", manualLevel[i])
    sprite:MakePixelPerfect()
  end
  self.levelGrid:Reposition()
  self.achievementCurScore.text = score .. "/" .. nextScore
  self.achievementScoreSlider.value = score / nextScore
  if self.manualPoint then
    self:Hide(self.manualPoint.gameObject)
  end
end
function AdventureHomePage:addViewEventListener()
end
function AdventureHomePage:AddListenerEvts()
  self:AddListenEvt(AdventureDataEvent.SceneManualQueryManualData, self.QueryManualHandler)
  self:AddListenEvt(AdventureDataEvent.SceneManualManualUpdate, self.ManualUpdateHandler)
  self:AddListenEvt(ServiceEvent.SceneManualPointSync, self.showScoreUpdateAnim)
  self:AddListenEvt(SceneUserEvent.LevelUp, self.LevelUp)
  self:AddListenEvt(ServiceEvent.UserEventNewTitle, self.setCurrentAchIcon)
  self:AddListenEvt(ServiceEvent.SessionSocialitySocialUpdate, self.setFriendAdData)
  self:AddListenEvt(ServiceEvent.SessionSocialitySocialDataUpdate, self.setFriendAdData)
  self:AddListenEvt(ServiceEvent.SessionSocialityQuerySocialData, self.setFriendAdData)
  self:AddListenEvt(ServiceEvent.AchieveCmdQueryAchieveDataAchCmd, self.setCollectionAchievement)
  self:AddListenEvt(ServiceEvent.AchieveCmdNewAchieveNtfAchCmd, self.NewAchieveNtfAchCmdHandler)
  self:AddListenEvt(ServiceEvent.SceneFoodNewFoodDataNtf, self.NewFoodDataNtfHandler)
  self:AddListenEvt(PVPEvent.TeamTwelve_Launch, self.HandleTwelveLaunch)
end
function AdventureHomePage:HandleTwelveLaunch(note)
  self:Hide(self.propBord)
end
function AdventureHomePage:QueryManualHandler(note)
  self:setFriendAdData(false)
  self:SetData()
end
function AdventureHomePage:ManualUpdateHandler(note)
  self:SetData()
  self:showNextSkillInfo()
end
function AdventureHomePage:NewAchieveNtfAchCmdHandler(note)
  self:SetData()
  self:setCollectionAchievement()
end
function AdventureHomePage:NewFoodDataNtfHandler(note)
  self:SetData()
end
function AdventureHomePage:LevelUp(note)
  if note.type == SceneUserEvent.ManualLevelUp then
    FloatingPanel.Instance:ShowManualUp()
  end
end
function AdventureHomePage:UpdateHead()
  if not self.targetCell then
    local headCellObj = self:FindGO("PortraitCell")
    self.headCellObj = Game.AssetManager_UI:CreateAsset(Charactor.PlayerHeadCellResId, headCellObj)
    self.headCellObj.transform.localPosition = LuaGeometry.Const_V3_zero
    self.targetCell = PlayerFaceCell.new(self.headCellObj)
    self.targetCell:HideLevel()
    self.targetCell:HideHpMp()
  end
  local headData = HeadImageData.new()
  headData:TransByLPlayer(Game.Myself)
  headData.frame = nil
  headData.job = nil
  self.targetCell:SetData(headData)
end
function AdventureHomePage:setFriendAdData(resetPos)
  local isQuerySocialData = ServiceSessionSocialityProxy.Instance:IsQuerySocialData()
  local friends = {
    unpack(FriendProxy.Instance:GetFriendData())
  }
  if isQuerySocialData then
    local data = {}
    data.myself = true
    data.adventureLv = AdventureDataProxy.Instance:getManualLevel()
    data.adventureExp = AdventureDataProxy.Instance:getPointData()
    data.guid = Game.Myself.data.id
    data.appellation = ""
    data.name = Game.Myself.data:GetName()
    local achData = MyselfProxy.Instance:GetCurManualAppellation()
    if achData then
      data.appellation = achData.id
    end
    table.insert(friends, data)
    table.sort(friends, function(l, r)
      if l.adventureLv == r.adventureLv then
        if l.adventureExp == r.adventureExp then
          return l.guid > r.guid
        else
          return l.adventureExp > r.adventureExp
        end
      else
        return l.adventureLv > r.adventureLv
      end
    end)
    for i = 1, #friends do
      local single = friends[i]
      single.rank = i
      if single.myself then
        self.myRank.text = string.format(ZhString.AdventureHomePage_MyRank, i)
      end
    end
    self.itemWrapHelper:UpdateInfo(friends)
    if resetPos then
      self.friendScrollview:ResetPosition()
      self.itemWrapHelper:ResetPosition()
    end
  end
  self.loading:SetActive(not isQuerySocialData)
end
function AdventureHomePage:showPropView()
  self.propBord:SetActive(not self.propBord.activeSelf)
  if self.propBord.activeSelf then
    local approps = AdventureDataProxy.Instance:GetAppellationProp()
    local x, y, z = LuaGameObject.GetLocalPosition(self.appellationPropCt.transform)
    local apSize = #approps
    if apSize == 0 then
      self:Hide(self.appellationPropCt)
    else
      local appData = MyselfProxy.Instance:GetCurManualAppellation()
      self.applationTitle.text = string.format(ZhString.AdventureHomePage_PropBordAppllationTitleDes, appData.staticData.Name)
      self.appellationGrid:ResetDatas(approps)
      self:Show(self.appellationPropCt)
      local bd = NGUIMath.CalculateRelativeWidgetBounds(self.appellationPropCt.transform)
      local height = bd.size.y
      y = y - height - 20
    end
    local x1, y1, z1 = LuaGameObject.GetLocalPosition(self.adventurePropCt.transform)
    self.adventurePropCt.transform.localPosition = LuaGeometry.GetTempVector3(x1, y, z1)
    local props = AdventureDataProxy.Instance:GetAllAdventureProp()
    local propSize = #props
    if propSize == 0 then
      self:Hide(self.adventurePropCt)
    else
      self.adventurePropGrid:ResetDatas(props)
      self:Show(self.adventurePropCt)
    end
    if propSize == 0 and apSize == 0 then
      self:Show(self.emptyCt)
    else
      self:Hide(self.emptyCt)
    end
  end
end
function AdventureHomePage:UpdateOneClickActivate()
  local availableNum = AdventureDataProxy.Instance:getTotalCanBeClickNum() + AdventureDataProxy.Instance:getCollectionNumWithRewardCanGet() + AdventureAchieveProxy.Instance:getCanGetRewardNum() + FoodProxy.Instance:GetManualDataNumByStatus()
  local available = availableNum > 0
  self.oneClickActivateBtn:SetActive(available)
  self.oneClickFakeActivateBtn:SetActive(not available)
end
function AdventureHomePage:CallOneClickActivate()
  local temp1, temp2, temp3, serverSingle, single, tmpList, appendData = ReusableTable.CreateArray(), ReusableTable.CreateArray(), ReusableTable.CreateArray()
  AdventureDataProxy.Instance:getTotalCanBeClickNum(temp1)
  for i = 1, #temp1 do
    single = temp1[i]
    if single.status == SceneManual_pb.EMANUALSTATUS_UNLOCK_CLIENT then
      serverSingle = NetConfig.PBC and {} or SceneManual_pb.UnlockList()
      serverSingle.type = single.type
      serverSingle.id = single.staticId
      table.insert(temp2, serverSingle)
    elseif single:canBeClick() then
      tmpList = ReusableTable.CreateArray()
      appendData = single:getCompleteNoRewardAppend(tmpList)
      appendData = appendData[1]
      table.insert(temp3, appendData.staticId)
      ReusableTable.DestroyAndClearArray(tmpList)
    end
  end
  if #temp2 > 0 then
    ServiceSceneManualProxy.Instance:CallUnlockQuickManualCmd(temp2)
  end
  if #temp3 > 0 then
    ServiceSceneManualProxy.Instance:CallGetQuestRewardQuickManualCmd(temp3)
  end
  ReusableTable.DestroyAndClearArray(temp3)
  TableUtility.ArrayClear(temp1)
  TableUtility.ArrayClear(temp2)
  AdventureAchieveProxy.Instance:getCanGetRewardNum(temp1)
  for i = 1, #temp1 do
    table.insert(temp2, temp1[i].id)
  end
  if #temp2 > 0 then
    ServiceAchieveCmdProxy.Instance:CallRewardGetQuickAchCmd(temp2)
  end
  ReusableTable.DestroyAndClearArray(temp2)
  TableUtility.ArrayClear(temp1)
  FoodProxy.Instance:GetManualDataNumByStatus(SceneFood_pb.EFOODSTATUS_ADD, temp1)
  for i = 1, #temp1 do
    serverSingle = NetConfig.PBC and {} or SceneManual_pb.UnlockFoodList()
    serverSingle.type = SceneFood_pb.EFOODDATATYPE_FOODCOOK
    serverSingle.id = temp1[i].itemData.staticData.id
    table.insert(temp1, serverSingle)
  end
  if #temp1 > 0 then
    ServiceSceneManualProxy.Instance:CallUnlockQuickManualCmd(nil, temp1)
  end
  ReusableTable.DestroyAndClearArray(temp1)
  ServiceSceneManualProxy.Instance:CallGroupActionManualCmd(SceneManual_pb.EGROUPACTION_COLLECTION_REWARD_QUICK)
end
