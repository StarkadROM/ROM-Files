autoImport("BaseTip")
MonthScoreTip = class("MonthScoreTip", BaseView)
autoImport("AdvTipRewardCell")
autoImport("TipLabelCell")
autoImport("UIModelShowConfig")
autoImport("AdvTipRewardCell")
autoImport("AdventureAppendCell")
autoImport("AdventureBaseAttrCell")
autoImport("AdventureDropCell")
function MonthScoreTip:ctor(parent)
  self.resID = ResourcePathHelper.UITip("MonthScoreTip")
  self.gameObject = Game.AssetManager_UI:CreateAsset(self.resID, parent)
  self.gameObject.transform.localPosition = LuaGeometry.GetTempVector3()
  self:Init()
end
function MonthScoreTip:adjustPanelDepth(startDepth)
  local upPanel = Game.GameObjectUtil:FindCompInParents(self.gameObject, UIPanel)
  local panels = self:FindComponents(UIPanel)
  local minDepth
  for i = 1, #panels do
    if minDepth == nil then
      minDepth = panels[i].depth
    else
      minDepth = math.min(panels[i].depth, minDepth)
    end
  end
  startDepth = startDepth or 1
  for i = 1, #panels do
    panels[i].depth = panels[i].depth + startDepth + upPanel.depth - minDepth
  end
end
function MonthScoreTip:Init()
  self.monstername = self:FindComponent("MonsterName", UILabel)
  self.scrollView = self:FindComponent("ScrollView", UIScrollView)
  self.unlockBord = self:FindGO("UnLockBord")
  self.locksymbol = self:FindGO("Lock")
  self.table = self:FindComponent("AttriTable", UITable)
  self.attriCtl = UIGridListCtrl.new(self.table, TipLabelCell, "AdventureTipLabelCell")
  self.adventureValue = self:FindComponent("adventureValue", UILabel)
  local ModelTextureObj = self:FindGO("ModelTexture")
  self.ModelTexture = self:FindComponent("ModelTexture", UITexture)
  self:AddClickEvent(ModelTextureObj, function(obj)
    if self.data.monthCardInfo then
      local viewData = {
        viewname = "MonthCardDetailPanel",
        monthCardData = self.data.monthCardInfo
      }
      GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewData)
    end
  end)
  local appTb = self:FindComponent("AppendTable", UITable)
  self.appCtl = UIGridListCtrl.new(appTb, AdventureAppendCell, "AdventureAppendCell")
  self:initLockBord()
  self.epLabel = self:FindComponent("epLabel", UILabel)
  self.epModelTexture = self:FindComponent("EpModelTexture", UITexture)
  self.epCt = self:FindGO("epCt")
  self.lockCt = self:FindGO("lockCt")
  self:AddClickEvent(self.epModelTexture.gameObject, function(obj)
    local viewData = {
      viewname = "EpCardDetailPanel",
      monthCardData = self.data
    }
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewData)
  end)
  self:AddListenEvt(LotteryEvent.MagicPictureComplete, self.HandlePicture)
end
function MonthScoreTip:adjustLockRewardPos()
  local UnlockReward = self:FindGO("UnlockReward")
  local bound = NGUIMath.CalculateRelativeWidgetBounds(self.table.transform)
  local pos = self.table.transform.localPosition
  local y = pos.y - bound.size.y - 20
  UnlockReward.transform.localPosition = LuaGeometry.GetTempVector3(pos.x, y, pos.z)
end
function MonthScoreTip:initLockBord()
  self.lockTipLabel = self:FindComponent("LockTipLabel", UILabel)
  local LockReward = self:FindComponent("LockReward", UILabel)
  LockReward.text = ZhString.MonsterTip_LockReward
  self.fixedAttrLabel = self:FindComponent("fixedAttrLabel", UILabel)
  local fixLabelCt = self:FindComponent("fixLabelCt", UILabel)
  fixLabelCt.text = ZhString.MonsterTip_FixAttrCt
  self.FixAttrCt = self:FindGO("FixAttrCt")
  self:Hide(self.FixAttrCt)
  local grid = self:FindComponent("LockInfoGrid", UIGrid)
  self.advRewardCtl = UIGridListCtrl.new(grid, AdvTipRewardCell, "AdvTipRewardCell")
end
function MonthScoreTip:SetData(monsterData)
  self.data = monsterData
  self:SetLockState()
  self:UpdateAttriText()
  self:UpdateAppendData()
  self:adjustPanelDepth(4)
  self:adjustLockRewardPos()
  self:adjustLockView()
end
function MonthScoreTip:adjustLockView()
  local sbg = self:FindComponent("SpriteBg", UISprite)
  sbg.width = 450
  sbg.height = 300
  local pos = sbg.gameObject.transform.localPosition
  sbg.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(pos.x, 151.85, pos.y)
end
function MonthScoreTip:SetLockState()
  self.isUnlock = false
  if self.data then
    if self.data.monthCardInfo then
      self:Show(self.ModelTexture)
      self:Hide(self.epCt)
      if self.data.monthCardInfo and not StringUtil.IsEmpty(self.data.monthCardInfo.Picture) then
        PictureManager.Instance:SetMonthCardUI(self.data.monthCardInfo.Picture, self.ModelTexture)
        self.monthCardPictureName = self.data.monthCardInfo.Picture
      elseif self.data.monthCardURl then
        local bytes = LotteryProxy.Instance:DownloadMagicPicFromUrl(self.data.monthCardURl)
        if bytes then
          self:UpdatePicture(bytes)
        else
          self.ModelTexture.mainTexture = nil
        end
      end
    elseif GameConfig.EpCardTexture and GameConfig.EpCardTexture[self.data.staticId] then
      self:Show(self.epCt)
      self.epLabel.text = self.data:GetName()
      self:Hide(self.ModelTexture)
      PictureManager.Instance:SetEPCardUI(GameConfig.EpCardTexture[self.data.staticId], self.epModelTexture)
      self.epCardPictureName = GameConfig.EpCardTexture[self.data.staticId]
    else
      PictureManager.Instance:SetMonthCardUI("", self.ModelTexture)
      self.monthCardPictureName = ""
    end
    self.isUnlock = self.data.status ~= SceneManual_pb.EMANUALSTATUS_DISPLAY
    if self.data.AdventureValue and self.data.AdventureValue > 0 and not self.isUnlock then
      self.adventureValue.text = tostring(self.data.AdventureValue)
    else
    end
    local unlockCondition = AdventureDataProxy.getUnlockCondition(self.data)
    self.lockTipLabel.text = unlockCondition
    self:UpdateAdvReward()
  end
  self.lockCt.gameObject:SetActive(not self.isUnlock)
end
function MonthScoreTip:UpdatePicture(bytes)
  local texture = Texture2D(0, 0, TextureFormat.RGB24, false)
  local ret = ImageConversion.LoadImage(texture, bytes)
  if ret then
    self.ModelTexture.mainTexture = texture
  end
end
function MonthScoreTip:HandlePicture(note)
  local data = note.body
  if data and self.data and self.data.monthCardUrl == data.picUrl then
    self:UpdatePicture(data.bytes)
  end
end
function MonthScoreTip:UpdateAdvReward()
  local advReward, advRDatas = self.data.staticData.AdventureReward, {}
  if self.data.staticData.AdventureValue and self.data.staticData.AdventureValue > 0 then
    local temp = {}
    temp.type = "AdventureValue"
    temp.value = self.data.staticData.AdventureValue
    temp.showName = true
    table.insert(advRDatas, temp)
  end
  if type(advReward) == "table" then
    if advReward.AdvPoints then
      local temp = {}
      temp.type = "AdvPoints"
      temp.value = advReward.AdvPoints
      table.insert(advRDatas, temp)
    end
    if type(advReward.buffid) == "table" then
      if 0 < #advReward.buffid then
        self:Show(self.FixAttrCt)
      end
      local str = ""
      for i = 1, #advReward.buffid do
        local value = advReward.buffid[i]
        str = str .. (ItemUtil.getBufferDescByIdNotConfigDes(value) or "")
      end
      self.fixedAttrLabel.text = str
    end
    if advReward.item then
      for i = 1, #advReward.item do
        local temp = {}
        temp.type = "item"
        temp.value = advReward.item[i]
        table.insert(advRDatas, temp)
      end
    end
  else
    self:Hide(self.FixAttrCt)
  end
  local rewards = AdventureDataProxy.Instance:getAppendRewardByTargetId(self.data.staticId, "selfie")
  if rewards and #rewards > 0 then
    local temp = {}
    temp.type = "item"
    local items = ItemUtil.GetRewardItemIdsByTeamId(rewards[1])
    local value = {}
    value[1] = items[1].id
    value[2] = items[1].num
    temp.value = value
    table.insert(advRDatas, temp)
  end
  local UnlockReward = self:FindGO("UnlockReward")
  self:Show(UnlockReward)
  self.advRewardCtl:ResetDatas(advRDatas)
end
function MonthScoreTip:UpdateAttriText()
  local contextData = {}
  local data = self.data
  local sdata = self.data.staticData
  if data and sdata then
    local desc = {}
    desc.label = GameConfig.ItemQualityDesc[sdata.Quality]
    desc.hideline = true
    desc.tiplabel = ZhString.MonthTip_QualityRate
    table.insert(contextData, desc)
    local desc = {}
    desc.label = sdata.Desc
    desc.hideline = true
    table.insert(contextData, desc)
  end
  self.attriCtl:ResetDatas(contextData)
end
function MonthScoreTip:UpdateAppendData()
  if self.isUnlock then
    local trans = self.attriCtl.layoutCtrl.transform
    local bound = NGUIMath.CalculateRelativeWidgetBounds(trans, true)
    local pos = trans.localPosition
    pos = Vector3(pos.x, pos.y - bound.size.y, pos.z - 20)
    trans = self.appCtl.layoutCtrl.transform
    trans.localPosition = pos
    local appends = self.data:getNoRewardAppend()
    if #appends > 0 then
      self.appCtl:ResetDatas(appends)
    end
  end
end
function MonthScoreTip:OnEnable()
end
function MonthScoreTip:OnExit()
  self.attriCtl:ResetDatas()
  self.appCtl:ResetDatas()
  self.advRewardCtl:ResetDatas()
  Game.GOLuaPoolManager:AddToUIPool(self.resID, self.gameObject)
  if self.monthCardPictureName then
    PictureManager.Instance:UnLoadMonthCard(self.monthCardPictureName, self.ModelTexture)
  end
  if self.epCardPictureName then
    PictureManager.Instance:UnLoadEPCard(self.epCardPictureName, self.epModelTexture)
  end
  MonthScoreTip.super.OnExit(self)
end
