PersonalPictureDetailPanel = class("PersonalPictureDetailPanel", ContainerView)
PersonalPictureDetailPanel.picNameName = "RO_Picture"
function PersonalPictureDetailPanel:Init()
  self:initView()
  self:initData()
  self:AddEventListener()
  self:AddViewEvts()
end
function PersonalPictureDetailPanel:AddViewEvts()
  self:AddListenEvt(PersonalPictureManager.PersonalOriginPhotoDownloadCompleteCallback, self.photoCompleteCallback)
  self:AddListenEvt(PersonalPictureManager.PersonalOriginPhotoDownloadProgressCallback, self.photoProgressCallback)
  self:AddListenEvt(MySceneryPictureManager.MySceneryOriginPhotoDownloadCompleteCallback, self.photoCompleteCallback)
  self:AddListenEvt(MySceneryPictureManager.MySceneryOriginPhotoDownloadProgressCallback, self.photoProgressCallback)
  self:AddListenEvt(PictureWallDataEvent.MapEnd, self.MapEnd)
  self:AddListenEvt(PictureWallDataEvent.PhotoCompleteCallback, self.wallPhotoCompleteCallback)
  self:AddListenEvt(PictureWallDataEvent.PhotoProgressCallback, self.wallPhotoProgressCallback)
end
function PersonalPictureDetailPanel:MapEnd(note)
  if self.from then
    self:CloseSelf()
  end
end
function PersonalPictureDetailPanel:photoCompleteCallback(note)
  local data = note.body
  if self.index == data.index then
    self:completeCallback(data.byte)
  end
end
function PersonalPictureDetailPanel:wallPhotoCompleteCallback(note)
  local data = note.body
  if self.PhotoData and Game.PictureWallManager:checkSamePicture(data.photoData, self.PhotoData) then
    self:completeCallback(data.byte, false, true)
  end
end
function PersonalPictureDetailPanel:photoProgressCallback(note)
  local data = note.body
  if self.index == data.index then
    self:progressCallback(data.progress)
  end
end
function PersonalPictureDetailPanel:wallPhotoProgressCallback(note)
  local data = note.body
  if self.PhotoData and Game.PictureWallManager:checkSamePicture(data.photoData, self.PhotoData) then
    self:progressCallback(data.progress)
  end
end
function PersonalPictureDetailPanel:initData()
  self.readOnly = self.viewdata.viewdata.readOnly
  self.PhotoData = self.viewdata.viewdata.PhotoData
  self.index = self.PhotoData.index
  self.from = self.viewdata.viewdata.from
  self.frameId = self.viewdata.viewdata.frameId
  self.isThumbnail = false
  self.canbeShare = false
  self:initDefaultTextureSize()
  TimeTickManager.Me():ClearTick(self)
  self.background.gameObject:SetActive(false)
  TimeTickManager.Me():CreateOnceDelayTick(100, function(owner, deltaTime)
    self:getPhoto()
  end, self)
  if self.PhotoData and self.PhotoData.type == PhotoDataProxy.PhotoType.SceneryPhotoType and not self.from then
    self:Hide(self.delBtn)
  end
  if self.from then
    self:checkHasSelected()
  else
    self:Hide(self.tipDesCt)
  end
  if self.readOnly then
    self:Hide(self.delBtn)
    self:Hide(self.shareBtn)
    self:Hide(self.confirmBtn)
  end
end
function PersonalPictureDetailPanel:checkHasSelected()
  local uploadData = PhotoDataProxy.Instance:checkPhotoFrame(self.PhotoData, self.frameId)
  local isCurrent = false
  if uploadData then
    self:Show(self.tipDesCt)
    local find = false
    for i = 1, #uploadData do
      local single = uploadData[i]
      if single.frameid == self.frameId then
        find = true
        break
      end
    end
    if not find then
      self.tipDesLabel.text = ZhString.PersonalPictureCell_DetailPictureShowOther
    else
      isCurrent = true
      self.tipDesLabel.text = ZhString.PersonalPictureCell_DetailPictureShowCur
    end
    self.delBtnSp.spriteName = "photo_icon_remove"
  else
    self:Hide(self.tipDesCt)
    self.delBtnSp.spriteName = "photo_icon_update"
  end
  self.delBtnSp:MakePixelPerfect()
end
function PersonalPictureDetailPanel:initView()
  self.photo = self:FindGO("photo"):GetComponent(UITexture)
  self.noneTxIcon = self:FindGO("noneTxIcon"):GetComponent(UISprite)
  self.progress = self:FindGO("loadProgress"):GetComponent(UILabel)
  self:Hide(self.progress.gameObject)
  self.delBtn = self:FindGO("delBtn")
  self.shareBtn = self:FindGO("shareBtn")
  self.closeShare = self:FindGO("closeShare")
  self.confirmBtn = self:FindGO("confirmBtn")
  self:AddClickEvent(self.confirmBtn, function(go)
    self:savePicture()
    self:CloseSelf()
  end)
  self:AddClickEvent(self.closeShare, function()
    self:Hide(self.goUIViewSocialShare)
  end)
  self:AddClickEvent(self.shareBtn, function()
    if not BranchMgr.IsChina() and not BranchMgr.IsJapan() then
      self:sharePicture("fb", "", "")
      return
    end
    self:Show(self.goUIViewSocialShare)
  end)
  self.checkBox = self:FindComponent("selectedBg", UIToggle)
  self.delBtnSp = self:FindComponent("Sprite", UISprite, self.delBtn)
  self:GetGameObjects()
  self:RegisterButtonClickEvent()
  self.tipDesCt = self:FindGO("tipDesCt")
  self.tipDesLabel = self:FindComponent("tipDesLabel", UILabel)
  self.background = self:FindGO("background")
  self.backgroundAnchor = self.background:GetComponent(UISprite)
  self.backgroundIconAnchor = self:FindGO("GameObject", self.background):GetComponent(UIWidget)
  self.buttomBtnAnchor = self:FindGO("buttom_Btn"):GetComponent(UIWidget)
  self:ROOShare()
end
function PersonalPictureDetailPanel:ROOShare()
  if BranchMgr.IsChina() then
    return
  end
  local sp = self.goButtonQQ:GetComponent(UISprite)
  IconManager:SetUIIcon("Facebook", sp)
  sp = self.goButtonWechat:GetComponent(UISprite)
  IconManager:SetUIIcon("Twitter", sp)
  sp = self.goButtonWechatMoments:GetComponent(UISprite)
  IconManager:SetUIIcon("line", sp)
  GameObject.Destroy(self.goButtonSina)
  self:AddClickEvent(self.goButtonWechatMoments, function()
    self:sharePicture("line", "", "")
  end)
  self:AddClickEvent(self.goButtonWechat, function()
    self:sharePicture("twitter", OverseaHostHelper.TWITTER_MSG, "")
  end)
  self:AddClickEvent(self.goButtonQQ, function()
    self:sharePicture("fb", "", "")
  end)
  local lbl = self:FindGO("Label", self.goButtonWechatMoments):GetComponent(UILabel)
  lbl.text = "LINE"
  lbl = self:FindGO("Label", self.goButtonWechat):GetComponent(UILabel)
  lbl.text = "Twitter"
  lbl = self:FindGO("Label", self.goButtonQQ):GetComponent(UILabel)
  lbl.text = "Facebook"
end
function PersonalPictureDetailPanel:savePicture()
  local result = PermissionUtil.Access_SavePicToMediaStorage()
  if result and self.photo.mainTexture then
    local picName = PersonalPictureDetailPanel.picNameName
    local path = PathUtil.GetSavePath(PathConfig.PhotographPath) .. "/" .. picName
    ScreenShot.SaveJPG(self.photo.mainTexture, path, 100)
    path = path .. ".jpg"
    FunctionSaveToDCIM.Me():TrySavePicToDCIM(path)
  end
end
function PersonalPictureDetailPanel:updatePhotoFrameAnchors()
  self.backgroundAnchor:UpdateAnchors()
  self.backgroundIconAnchor:UpdateAnchors()
  self.buttomBtnAnchor:UpdateAnchors()
end
function PersonalPictureDetailPanel:initDefaultTextureSize()
  self.originWith = self.photo.width
  self.originHeight = self.photo.height
end
function PersonalPictureDetailPanel:setTexture(texture)
  local orginRatio = self.originWith / self.originHeight
  local textureRatio = texture.width / texture.height
  local wRatio = math.min(orginRatio, textureRatio) == orginRatio
  local height = self.originHeight
  local width = self.originWith
  if wRatio then
    height = self.originWith / textureRatio
  else
    width = self.originHeight * textureRatio
  end
  Object.DestroyImmediate(self.photo.mainTexture)
  self.photo.width = width
  self.photo.height = height
  self.photo.mainTexture = texture
  self.background.gameObject:SetActive(true)
end
function PersonalPictureDetailPanel:AddEventListener()
  self:AddClickEvent(self.delBtn, function(go)
    if not _G.PicutureWallSyncPanel then
      autoImport("PicutureWallSyncPanel")
    end
    if self.from == PicutureWallSyncPanel.PictureSyncFrom.GuildWall or self.from == PicutureWallSyncPanel.PictureSyncFrom.WeddingWall then
      local uploadData = PhotoDataProxy.Instance:checkPhotoFrame(self.PhotoData, self.frameId)
      local action = PhotoCmd_pb.EFRAMEACTION_UPLOAD
      local list = {
        {
          source = self.PhotoData.source,
          sourceid = self.PhotoData.sourceid
        }
      }
      local frameId = self.frameId
      if uploadData then
        action = PhotoCmd_pb.EFRAMEACTION_REMOVE
        if #uploadData > 0 and self.from == PicutureWallSyncPanel.PictureSyncFrom.GuildWall then
          frameId = uploadData[1].frameid
        end
      else
        local count = PhotoDataProxy.Instance:getCurUpSize()
        if PhotoDataProxy.Instance.totoalUpSize ~= -1 and count >= PhotoDataProxy.Instance.totoalUpSize then
          MsgManager.ShowMsgByIDTable(999)
          return
        end
      end
      ServicePhotoCmdProxy.Instance:CallFrameActionPhotoCmd(frameId, action, list)
      self:CloseSelf()
    elseif self.from == PicutureWallSyncPanel.PictureSyncFrom.WeddingCertificate or self.from == PicutureWallSyncPanel.PictureSyncFrom.WeddingCertificateDiy then
      if self.canbeShare then
        Game.WeddingWallPicManager:UploadWeddingPicture(self.photo.mainTexture, self.PhotoData.index, self.PhotoData.time, self.from)
        self:CloseSelf()
      else
        MsgManager.FloatMsg(nil, ZhString.WeddingPictureDownloading)
        return
      end
    else
      MsgManager.ConfirmMsgByID(993, function()
        PersonalPictureManager.Instance():removePhotoFromeAlbum(self.index, self.PhotoData.time)
        self:CloseSelf()
      end, nil)
    end
  end)
  self:AddButtonEvent("closeBtn", function(go)
    self:CloseSelf()
  end)
end
function PersonalPictureDetailPanel:getPhoto()
  if self.PhotoData then
    if self.PhotoData.type == PhotoDataProxy.PhotoType.SceneryPhotoType then
      local tBytes = ScenicSpotPhotoNew.Ins():TryGetThumbnailFromLocal_Share(self.index, self.PhotoData.time)
      if tBytes then
        self:completeCallback(tBytes, true)
        self:updatePhotoFrameAnchors()
        self.background.gameObject:SetActive(true)
      end
      MySceneryPictureManager.Instance():tryGetMySceneryOriginImage(self.PhotoData.roleId, self.index, self.PhotoData.time)
    elseif self.PhotoData.type == PhotoDataProxy.PhotoType.PersonalPhotoType then
      local tBytes = PersonalPhoto.Ins():TryGetThumbnailFromLocal(self.index, self.PhotoData.time, true)
      if tBytes then
        self:completeCallback(tBytes, true)
        self:updatePhotoFrameAnchors()
        self.background.gameObject:SetActive(true)
      end
      PersonalPictureManager.Instance():tryGetOriginImage(self.index, self.PhotoData.time)
      self:updatePhotoFrameAnchors()
      self.background.gameObject:SetActive(true)
    else
      local photoData = self.PhotoData
      local serverData = Game.PictureWallManager:getServerData(photoData)
      local bytes = Game.PictureWallManager:GetBytes(photoData)
      if bytes then
        self:completeCallback(bytes)
      else
        local tBytes
        local thumbnail = true
        if photoData.source == ProtoCommon_pb.ESOURCE_PHOTO_SCENERY then
          if photoData.isBelongAccPic then
            tBytes = UnionWallPhotoNew.Ins():TryGetThumbnailFromLocal_ScenicSpot_Account(photoData.charid, photoData.sourceid, photoData.time)
          else
            tBytes = UnionWallPhotoNew.Ins():TryGetThumbnailFromLocal_ScenicSpot(photoData.charid, photoData.sourceid, photoData.time)
          end
        elseif photoData.source == ProtoCommon_pb.ESOURCE_PHOTO_SELF then
          tBytes = UnionWallPhotoNew.Ins():TryGetThumbnailFromLocal_Personal(photoData.charid, photoData.sourceid, photoData.time)
        end
        if tBytes then
          self:completeCallback(tBytes, thumbnail, true)
        elseif serverData and serverData.texture then
          self:completeCallbackThumbnailTexture(serverData.texture)
        end
        Game.PictureWallManager:tryGetOriginImage(photoData)
        self:updatePhotoFrameAnchors()
        self.background.gameObject:SetActive(true)
      end
    end
  end
end
function PersonalPictureDetailPanel:completeCallbackThumbnailTexture(texture)
  local texture = Texture2D(0, 0, TextureFormat.RGB24, false)
  texture:LoadRawTextureData(texture:GetRawTextureData())
  texture:Apply()
  self:setTexture(texture)
end
function PersonalPictureDetailPanel:getPhotoPath()
  if self.PhotoData and self.PhotoData.type == PhotoDataProxy.PhotoType.SceneryPhotoType then
    return ScenicSpotPhotoNew.Ins():GetLocalAbsolutePath_Share(self.index, true)
  else
    return PersonalPhoto.Ins():GetLocalAbsolutePath(self.index, true)
  end
end
function PersonalPictureDetailPanel:sharePicture(platform_type, content_title, content_body)
  if self.canbeShare then
    do
      local path = self:getPhotoPath()
      self:Log("sharePicture pic path:", path)
      if path and path ~= "" then
        if not BranchMgr.IsChina() then
          local overseasManager = OverSeas_TW.OverSeasManager.GetInstance()
          if platform_type ~= "fb" then
            xdlog("startSharePicture", platform_type .. "??????")
            Debug.Log("??????")
            Debug.Log(content_title)
            Debug.Log(OverseaHostHelper.Share_URL)
            Debug.Log(content_body)
            overseasManager:ShareImgWithChannel(path, content_title, OverseaHostHelper.Share_URL, content_body, platform_type, function(msg)
              redlog("msg" .. msg)
              ROFileUtils.FileDelete(path)
              if msg == "1" then
                Debug.Log("success")
              else
                MsgManager.FloatMsgTableParam(nil, ZhString.LineNotInstalled)
              end
            end)
            return true
          end
          xdlog("startSharePicture", "fb ????????????")
          overseasManager:ShareImg(path, content_title, OverseaHostHelper.Share_URL, content_body, function(msg)
            redlog("msg" .. msg)
            ROFileUtils.FileDelete(path)
            if msg == "1" then
              MsgManager.FloatMsgTableParam(nil, ZhString.FaceBookShareSuccess)
            else
              MsgManager.FloatMsgTableParam(nil, ZhString.FaceBookShareFailed)
            end
          end)
          return true
        end
        SocialShare.Instance:ShareImage(path, content_title, content_body, platform_type, function(succMsg)
          self:Log("SocialShare.Instance:Share success")
          if platform_type == E_PlatformType.Sina then
            MsgManager.ShowMsgByIDTable(566)
          end
          ROFileUtils.FileDelete(path)
        end, function(failCode, failMsg)
          self:Log("SocialShare.Instance:Share failure")
          local errorMessage = failMsg or "error"
          if failCode ~= nil then
            errorMessage = failCode .. ", " .. errorMessage
          end
          ROFileUtils.FileDelete(path)
          MsgManager.ShowMsg("", errorMessage, MsgManager.MsgType.Float)
        end, function()
          self:Log("SocialShare.Instance:Share cancel")
          ROFileUtils.FileDelete(path)
        end)
      else
        MsgManager.FloatMsg(nil, ZhString.ShareAwardView_EmptyPath)
      end
      return true
    end
  else
  end
  return false
end
function PersonalPictureDetailPanel:progressCallback(progress)
  self:Show(self.progress.gameObject)
  if progress >= 1 then
    progress = 1 or progress
  end
  local value = progress * 100
  value = math.floor(value)
  self.progress.text = value .. "%"
end
function PersonalPictureDetailPanel:completeCallback(bytes, thumbnail, addOrigin)
  if not thumbnail then
    self:Hide(self.progress.gameObject)
  end
  self.isThumbnail = thumbnail
  if bytes then
    local texture = Texture2D(0, 0, TextureFormat.RGB24, false)
    local bRet = ImageConversion.LoadImage(texture, bytes)
    if bRet then
      self.canbeShare = not thumbnail
      self:setTexture(texture)
      if not thumbnail and addOrigin then
        Game.PictureWallManager:addOriginBytesBySceneryId(self.PhotoData, bytes)
      end
    else
      Object.DestroyImmediate(texture)
    end
  end
end
function PersonalPictureDetailPanel:OnExit()
  TimeTickManager.Me():ClearTick(self)
  Object.DestroyImmediate(self.photo.mainTexture)
end
function PersonalPictureDetailPanel:GetGameObjects()
  self.goUIViewSocialShare = self:FindGO("UIViewSocialShare", self.gameObject)
  self.goButtonWechatMoments = self:FindGO("WechatMoments", self.goUIViewSocialShare)
  self.goButtonWechat = self:FindGO("Wechat", self.goUIViewSocialShare)
  self.goButtonQQ = self:FindGO("QQ", self.goUIViewSocialShare)
  self.goButtonSina = self:FindGO("Sina", self.goUIViewSocialShare)
  local enable = FloatAwardView.ShareFunctionIsOpen()
  if not enable then
    self:Hide(self.shareBtn)
  end
end
function PersonalPictureDetailPanel:RegisterButtonClickEvent()
  self:AddClickEvent(self.goButtonWechatMoments, function()
    self:OnClickForButtonWechatMoments()
  end)
  self:AddClickEvent(self.goButtonWechat, function()
    self:OnClickForButtonWechat()
  end)
  self:AddClickEvent(self.goButtonQQ, function()
    self:OnClickForButtonQQ()
  end)
  self:AddClickEvent(self.goButtonSina, function()
    self:OnClickForButtonSina()
  end)
end
function PersonalPictureDetailPanel:OnClickForButtonWechatMoments()
  if SocialShare.Instance:IsClientValid(E_PlatformType.WechatMoments) then
    local result = self:sharePicture(E_PlatformType.WechatMoments, "", "")
    if result then
      self:CloseSelf()
    else
      MsgManager.ShowMsgByID(559)
    end
  else
    MsgManager.ShowMsgByIDTable(561)
  end
end
function PersonalPictureDetailPanel:OnClickForButtonWechat()
  if SocialShare.Instance:IsClientValid(E_PlatformType.Wechat) then
    local result = self:sharePicture(E_PlatformType.Wechat, "", "")
    if result then
      self:CloseSelf()
    else
      MsgManager.ShowMsgByID(559)
    end
  else
    MsgManager.ShowMsgByIDTable(561)
  end
end
function PersonalPictureDetailPanel:OnClickForButtonQQ()
  if SocialShare.Instance:IsClientValid(E_PlatformType.QQ) then
    local result = self:sharePicture(E_PlatformType.QQ, "", "")
    if result then
      self:CloseSelf()
    else
      MsgManager.ShowMsgByID(559)
    end
  else
    MsgManager.ShowMsgByIDTable(562)
  end
end
function PersonalPictureDetailPanel:OnClickForButtonSina()
  if SocialShare.Instance:IsClientValid(E_PlatformType.Sina) then
    local contentBody = GameConfig.PhotographResultPanel_ShareDescription
    if contentBody == nil or #contentBody <= 0 then
      contentBody = "RO"
    end
    local result = self:sharePicture(E_PlatformType.Sina, "", contentBody)
    if result then
      self:CloseSelf()
    else
      MsgManager.ShowMsgByID(559)
    end
  else
    MsgManager.ShowMsgByIDTable(563)
  end
end
