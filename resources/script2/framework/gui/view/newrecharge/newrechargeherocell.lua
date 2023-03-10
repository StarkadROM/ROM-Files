local BaseCell = autoImport("BaseCell")
NewRechargeHeroCell = class("NewRechargeHeroCell", BaseCell)
NewRechargeHeroCell_Event = {
  PreView = "NewRechargeHeroCell_Event_PreView",
  Buy = "NewRechargeHeroCell_Event_Buy",
  More = "NewRechargeHeroCell_Event_More",
  ClickItem1 = "NewRechargeHeroCell_Event_ClickItem1",
  ClickItem2 = "NewRechargeHeroCell_Event_ClickItem2",
  GetTimeOut = "NewRechargeHeroCell_Event_GetTimeOut"
}
local typeBranchNameIdMap = GameConfig.NewClassEquip and GameConfig.NewClassEquip.typeBranchNameIdMap
function NewRechargeHeroCell:Init()
  self.heroTexture = self:FindComponent("herotexture", UITexture)
  self.classIcon = self:FindComponent("classicon", UISprite)
  self.classNameSprite = SpriteLabel.new(self:FindGO("classname"), nil, 40, 40, true)
  self.classDesc = self:FindComponent("classdesc", UILabel)
  self.u_leftTimeGO = self:FindGO("lefttimeicon")
  self.u_leftTime = self:FindComponent("lefttimeicon/lefttime", UILabel)
  self.rbgGO = self:FindGO("rbg")
  self.itemIcon1GO = self:FindGO("rbg/itemicon1")
  self.itemIcon1 = self.itemIcon1GO:GetComponent(UISprite)
  self.itemIcon2GO = self:FindGO("rbg/itemicon2")
  self.itemIcon2 = self.itemIcon2GO:GetComponent(UISprite)
  self.videoGO = self:FindGO("movietexture")
  self.videoPlayerNGUI = self.videoGO:GetComponent(VideoPlayerNGUI)
  self.previewButton = self:FindGO("previewbutton")
  self:AddClickEvent(self.previewButton, function(go)
    self:PassEvent(NewRechargeHeroCell_Event.PreView, self)
  end)
  self.buyedtip = self:FindGO("buyedtip")
  self.buyButton = self:FindGO("buybutton")
  self.priceLabel = self:FindComponent("buybutton/pricelabel", UILabel)
  self.priceIcon = self:FindComponent("buybutton/priceicon", UISprite)
  self.priceBg = self:FindGO("buybutton/pricebg")
  self.getLabel = self:FindGO("buybutton/getlabel")
  self.buyPrecondition = self:FindGO("precondition", self.buyButton)
  self.buyPreconditionLabelGO = self:FindGO("preconditlabel", self.buyPrecondition)
  self.buyPreconditionLabel = self.buyPreconditionLabelGO:GetComponent(UILabel)
  self.buyPreconditionBg = self:FindComponent("preconditbg", UISprite, self.buyPrecondition)
  function self.buyPreconditionLabel.onPostFill(widget)
    if self.buyPreconditionLabel.width >= 202 then
      self.buyPreconditionLabel.width = 199
      self.buyPreconditionLabel.overflowMethod = 3
      LuaGameObject.SetLocalPositionGO(self.buyPreconditionLabelGO, -101, -9, 0)
    end
    self.buyPreconditionBg.width = self.buyPreconditionLabel.width + 38
    self.buyPreconditionBg.height = self.buyPreconditionLabel.height + 35
  end
  self.buyButton_sp = self.buyButton:GetComponent(UISprite)
  self.buyButton_collider = self.buyButton:GetComponent(BoxCollider)
  self:AddClickEvent(self.buyButton, function(go)
    self:PassEvent(NewRechargeHeroCell_Event.Buy, self)
  end)
  self.morelabel = self:FindGO("rbg/morelabel")
  self:AddClickEvent(self.morelabel, function(go)
    self:PassEvent(NewRechargeHeroCell_Event.More, self)
  end)
  self:AddClickEvent(self.itemIcon1GO, function(go)
    self:PassEvent(NewRechargeHeroCell_Event.ClickItem1, self)
  end)
  self:AddClickEvent(self.itemIcon2GO, function(go)
    self:PassEvent(NewRechargeHeroCell_Event.ClickItem2, self)
  end)
end
function NewRechargeHeroCell:SetBuyType(t)
  if t == 1 then
    self.priceLabel.gameObject:SetActive(true)
    self.priceIcon.gameObject:SetActive(true)
    self.priceBg:SetActive(true)
    self.getLabel:SetActive(false)
  else
    self.priceLabel.gameObject:SetActive(false)
    self.priceIcon.gameObject:SetActive(false)
    self.priceBg:SetActive(false)
    self.getLabel:SetActive(true)
  end
end
function NewRechargeHeroCell:ActiveBuyButton(b)
  if b then
    self.priceLabel.effectColor = LuaGeometry.GetTempColor(0.7725490196078432, 0.5607843137254902, 0.011764705882352941, 1)
    self.priceIcon.color = LuaGeometry.GetTempColor(1, 1, 1, 1)
    self.buyButton_sp.color = LuaGeometry.GetTempColor(1, 1, 1, 1)
    self.buyButton_collider.enabled = true
  else
    self.priceLabel.effectColor = LuaGeometry.GetTempColor(0.615686274509804, 0.615686274509804, 0.615686274509804, 1)
    self.priceIcon.color = LuaGeometry.GetTempColor(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 1)
    self.buyButton_sp.color = LuaGeometry.GetTempColor(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 1)
    self.buyButton_collider.enabled = false
  end
end
local TeamFunctionIcon = {
  [1] = "skill_icon_02",
  [2] = "skill_icon_03",
  [3] = "skill_icon_01"
}
function NewRechargeHeroCell:SetData(data)
  self.data = data
  PictureManager.Instance:SetHeroTexture(data.heropic, self.heroTexture)
  if data.teamfunction then
    local functionIcon = TeamFunctionIcon[data.teamfunction] or "skill_icon_01"
    TimeTickManager.Me():CreateOnceDelayTick(100, function(owner, deltaTime)
      self.classNameSprite:SetText(data.classname .. string.format("{uiicon=%s}", functionIcon))
      self:UpdateLeftTime(true)
    end, self, 526)
    break
  else
    self.classNameSprite:SetText(data.classname)
    self:UpdateLeftTime(false)
  end
  self.classDesc.text = data.classdesc
  self.priceLabel.text = data.price
  self.previewButton:SetActive(data.preview)
  if data.isbuy then
    self.buyedtip:SetActive(true)
    self.buyButton:SetActive(false)
    self.buyPrecondition:SetActive(false)
  else
    self.buyedtip:SetActive(false)
    self.buyButton:SetActive(true)
    if self.data.addway or self.data.helpid then
      self:SetBuyType(2)
      self.buyPrecondition:SetActive(false)
    else
      self:SetBuyType(1)
      local canBuy, previewClass = ProfessionProxy.Instance:CheckHeroCanBuy(data.classid)
      self:ActiveBuyButton(canBuy)
      if not canBuy and previewClass then
        self.buyPrecondition:SetActive(true)
        local classConfig = Table_Class[data.classid]
        local originId = classConfig and classConfig.OriginId
        if originId then
          local rootBranchName = Table_Class[originId].NameZh
          local previewClassName = Table_Class[previewClass] and Table_Class[previewClass].NameZh
          self.buyPreconditionLabel.text = string.format(ZhString.NewRechargeHeroCell_HeroAdvanceClass, rootBranchName, previewClassName)
          self.buyPreconditionLabel.overflowMethod = 2
          self.buyPreconditionLabel:MakePixelPerfect()
        end
      else
        self.buyPrecondition:SetActive(false)
      end
    end
  end
  IconManager:SetNewProfessionIcon(data.classicon, self.classIcon)
  IconManager:SetItemIcon(data.costicon, self.priceIcon)
  if data.reward then
    self.rbgGO:SetActive(true)
    local rid1, rid2 = data.reward[1], data.reward[2]
    if rid1 then
      self.itemIcon1GO:SetActive(true)
      IconManager:SetItemIcon(Table_Item[rid1].Icon, self.itemIcon1)
    else
      self.itemIcon1GO:SetActive(false)
    end
    if rid2 then
      self.itemIcon2GO:SetActive(true)
      IconManager:SetItemIcon(Table_Item[rid2].Icon, self.itemIcon2)
    else
      self.itemIcon2GO:SetActive(false)
    end
  else
    self.rbgGO:SetActive(false)
  end
  self.videoPath = VideoPanel.VideoPath .. self.data.video
  if not FileHelper.ExistFile(self.videoPath) then
    self.videoPath = Application.streamingAssetsPath .. "/Videos/" .. self.data.video
  end
  self:PlayBgm()
end
function NewRechargeHeroCell:RemoveTimeTick()
  TimeTickManager.Me():ClearTick(self)
end
function NewRechargeHeroCell:UpdateLeftTime(rePos)
  if self.m_tickTime then
    TimeTickManager.Me():ClearTick(self, 988)
    self.m_tickTime = nil
  end
  local leftTime, d, h, m, s = self.data:GetLeftTime()
  if leftTime and leftTime > 0 then
    if leftTime <= 0 then
      self.u_leftTimeGO.gameObject:SetActive(false)
    else
      self.u_leftTimeGO.gameObject:SetActive(true)
      if rePos then
        local spGO = self.classNameSprite:GetSprite(0)
        local sx = LuaGameObject.InverseTransformPointByTransform(self.trans, spGO.transform, Space.World)
        local x, y, z = LuaGameObject.GetLocalPositionGO(self.u_leftTimeGO)
        LuaGameObject.SetLocalPositionGO(self.u_leftTimeGO, sx + 40, y, z)
      else
        LuaGameObject.SetLocalPositionGO(self.u_leftTimeGO, 40, 217, 0)
      end
      if d == 0 and h == 0 then
        self.m_tickTime = TimeTickManager.Me():CreateTick(0, 1000, self.mUpdateLeftTime, self, 988)
      else
        self.m_tickTime = TimeTickManager.Me():CreateTick(0, 60000, self.mUpdateLeftTime, self, 988)
      end
    end
  else
    self.u_leftTimeGO.gameObject:SetActive(false)
  end
end
function NewRechargeHeroCell:mUpdateLeftTime()
  local leftTime, d, h, m, s = self.data:GetLeftTime()
  if not leftTime then
    TimeTickManager.Me():ClearTick(self, 988)
    self.m_tickTime = nil
    self:PassEvent(NewRechargeHeroCell_Event.GetTimeOut, self)
    return
  end
  if leftTime <= 0 then
    return
  end
  if d > 0 then
    self.u_leftTime.text = string.format(ZhString.NewRechargeHeroCell_LeftTime, d, h)
  elseif h > 0 then
    self.u_leftTime.text = string.format(ZhString.NewRechargeHeroCell_LeftTime_Hour, h, m)
  else
    self.u_leftTime.text = string.format(ZhString.NewRechargeHeroCell_LeftTime_Min, m, s)
  end
end
function NewRechargeHeroCell:PlayBgm()
  if self.data.bgm and self.data.bgm ~= "" then
    FunctionBGMCmd.Me():PlayUIBgm(self.data.bgm, 0)
  end
end
local F_SafePlayVideo = function(videoPlayerNGUI)
  videoPlayerNGUI:Play()
end
local F_SafePauseVideo = function(videoPlayerNGUI)
  videoPlayerNGUI:Pause()
end
local F_SafeOpenVideo = function(videoPlayerNGUI, videoPath, pathAbsolute)
  videoPlayerNGUI:OpenVideo(videoPath, pathAbsolute)
end
local F_SafeCloseVideo = function(videoPlayerNGUI)
  videoPlayerNGUI:Close()
end
local F_SafeVideo_loop = function(videoPlayerNGUI, b)
  videoPlayerNGUI.loop = b
end
function NewRechargeHeroCell:PlayVideo(b)
  if self.nowVideoPlaying == b or not self.nowVideoPath then
    return
  end
  local exeRet, errorMsg
  if b then
    exeRet, errorMsg = xpcall(F_SafePlayVideo, debug.traceback, self.videoPlayerNGUI)
  else
    exeRet, errorMsg = xpcall(F_SafePauseVideo, debug.traceback, self.videoPlayerNGUI)
  end
  if not exeRet then
    LogUtility.Error(tostring(errorMsg))
  end
end
function NewRechargeHeroCell:OpenVideo()
  if self.videoPath ~= self.nowVideoPath then
    if self.nowVideoPath then
      self:CloseVideo()
    end
    self.videoGO:SetActive(true)
    self.nowVideoPath = self.videoPath
    local exeRet, errorMsg
    exeRet, errorMsg = xpcall(F_SafeOpenVideo, debug.traceback, self.videoPlayerNGUI, self.nowVideoPath, true)
    if not exeRet then
      LogUtility.Error(tostring(errorMsg))
    end
    exeRet, errorMsg = xpcall(F_SafeVideo_loop, debug.traceback, self.videoPlayerNGUI, true)
    if not exeRet then
      LogUtility.Error(tostring(errorMsg))
    end
  end
end
function NewRechargeHeroCell:CloseVideo()
  if self.nowVideoPath then
    self.nowVideoPath = nil
  end
  if self.videoGO.activeSelf then
    local exeRet, errorMsg = xpcall(F_SafeCloseVideo, debug.traceback, self.videoPlayerNGUI)
    if not exeRet then
      LogUtility.Error(tostring(errorMsg))
    end
  end
  self.nowVideoPlaying = nil
end
function NewRechargeHeroCell:OnCellDestroy()
  self:CloseVideo()
  self:RemoveTimeTick()
end
