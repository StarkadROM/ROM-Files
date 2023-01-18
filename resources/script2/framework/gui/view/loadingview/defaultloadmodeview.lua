autoImport("LoadingCardCell")
DefaultLoadModeView = class("DefaultLoadModeView", SubView)
function DefaultLoadModeView:Init()
  self:FindObjs()
  self:AddViewListeners()
end
function DefaultLoadModeView:FindObjs()
  self.bg = self:FindGO("Bg"):GetComponent(UITexture)
  self.effectContainer = self:FindGO("effectContainer")
  self.labelBg = self:FindGO("labelBg"):GetComponent(UIWidget)
end
function DefaultLoadModeView:AddViewListeners()
  self:AddListenEvt(LoadingSceneView.ServerReceiveLoaded, self.ServerReceiveLoadedHandler)
end
function DefaultLoadModeView:TryLoadPic(bgName)
  self.bgName = bgName or "loading"
  if self.bgName == "black" then
    PictureManager.Instance:SetUI("com_mask", self.bg)
    self.bg.color = LuaGeometry.Const_Col_black
    self.bg.width = 2000
    self.bg.height = 1800
    self.isBlack = true
  else
    PictureManager.Instance:SetLoading(self.bgName, self.bg)
    self.bg:MakePixelPerfect()
    PictureManager.ReFitManualHeight(self.bg)
    self:ReFitLabelBg()
  end
end
function DefaultLoadModeView:UnLoadPic()
  if self.bgName then
    PictureManager.Instance:UnLoadLoading(self.bgName, self.bg)
  end
end
function DefaultLoadModeView:ServerReceiveLoadedHandler(note)
  TimeTickManager.Me():ClearTick(self)
  self.serverReceivedLoaded = true
  self:TryClose()
end
function DefaultLoadModeView:TryClose()
  if not self.container.Loaded then
    return
  end
  if SceneProxy.Instance:IsMask() or SceneProxy.Instance:IsNeedWaitCutScene() then
    self.container:SafeDelayClose(SceneProxy.Instance:IsNeedWaitCutScene_NoDelayClose())
    return
  end
  self:AllDone()
end
function DefaultLoadModeView:OnExit()
  DefaultLoadModeView.super.OnExit(self)
  self:UnLoadPic()
end
function DefaultLoadModeView:AllDone()
  self.container:CloseSelf()
  self:UnLoadPic()
end
function DefaultLoadModeView:SceneFadeOut(note)
  self.bg.gameObject:SetActive(false)
  self.container:DoFadeOut()
end
function DefaultLoadModeView:SceneFadeOutFinish()
end
function DefaultLoadModeView:StartLoadScene(note)
  self:RandomLoadingBg()
  if not self.isBlack then
    self:PlayUIEffect(EffectMap.UI.Eff_loading2_ui, self.effectContainer)
  end
end
function DefaultLoadModeView:Update(delta)
end
function DefaultLoadModeView:RandomLoadingBg()
  if not GameConfig.DefaultLoadingBgWeight then
    redlog("no DefaultLoadingBgWeight in GameConfig!!!")
    return
  end
  local config = GameConfig.DefaultLoadingBgWeight
  local curMapID = Game.MapManager:GetMapID()
  local targetLoadingBGList
  if not config[curMapID] then
    targetLoadingBGList = config.default
  else
    targetLoadingBGList = config[curMapID]
  end
  local weights = 0
  for _, weight in pairs(targetLoadingBGList) do
    weights = weights + weight
  end
  local randomWeight = math.random(1, weights)
  for bgName, weight in pairs(targetLoadingBGList) do
    weights = weights - weight
    if randomWeight >= weights then
      self:TryLoadPic(bgName)
      break
    end
  end
end
function DefaultLoadModeView:ReFitLabelBg()
  local scale = self.labelBg.width / self.labelBg.height
  self.labelBg.height = self.bg.width
  self.labelBg.width = self.labelBg.height * scale
  local y = self.bg.localCorners[1].y + self.labelBg.width * 0.5
  local pos = self.labelBg.transform.localPosition
  pos.y = y
  self.labelBg.transform.localPosition = pos
end
function DefaultLoadModeView:SceneFadeInFinish()
  self.container:CloseSelf()
end
function DefaultLoadModeView:LoadFinish()
  self.container:FireLoadFinishEvent()
end
