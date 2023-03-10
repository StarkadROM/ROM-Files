Game = class("Game")
Game.GameObjectType = {
  Camera = 1,
  Light = 2,
  RoomHideObject = 3,
  SceneObjectFinder = 4,
  SceneAnimation = 5,
  LocalNPC = 6,
  DynamicObject = 7,
  CullingObject = 8,
  SceneSeat = 9,
  ScenePhotoFrame = 10,
  SceneGuildFlag = 11,
  WeddingPhotoFrame = 12,
  MenuUnlockObj = 14,
  InteractNpc = 13,
  Furniture = 15,
  InteractCard = 16,
  SceneBossAnime = 17,
  RoomShowObject = 18,
  LockCameraForceRoomShow = 19,
  CameraFocusObj = 20,
  RaidPuzzle_Light = 21,
  Skybox = 22,
  AreaCP = 23,
  ShadowPuzzle = 24,
  StealthGame = 25,
  InsightGO = 26,
  TextMesh = 27,
  BehaviourTree = 28,
  ObjectFinder = 29
}
Game.EState = {Running = 1, Finished = 2}
Game.ELayer = {
  Default = 0,
  TransparentFX = 1,
  IgnoreRaycast = 2,
  Water = 4,
  UI = 5,
  Terrain = 8,
  StaticObject = 9,
  DynamicObject = 10,
  Accessable = 11,
  SceneUI = 12,
  SceneUIBackground = 13,
  InVisible = 14,
  UIBackground = 15,
  PhotographPanel = 16,
  NavMeshDelegateDraw = 17,
  UIModel = 18,
  Barrage = 19,
  HomeBuildingCell_EditorOnly = 20,
  PPEffect = 21,
  Outline = 22,
  Cam_Filter = 27,
  HomeDefaultGround = 20,
  HomeGround = 21,
  HomeFurniture = 22,
  HomeOperate = 23,
  UIEffect = 23,
  HomeFurniture_BP = 24
}
autoImport("DataStructureManager")
autoImport("FunctionSystemManager")
autoImport("GUISystemManager")
autoImport("GCSystemManager")
autoImport("GOManager_Camera")
autoImport("GOManager_Light")
autoImport("GOManager_Room")
autoImport("GOManager_SceneObject")
autoImport("GOManager_LocalNPC")
autoImport("GOManager_DynamicObject")
autoImport("GOManager_CullingObject")
autoImport("GOManager_SceneSeat")
autoImport("GOManager_ScenePhotoFrame")
autoImport("GOManager_SceneGuildFlag")
autoImport("GOManager_WeddingPhotoFrame")
autoImport("GOManager_MenuUnlockObj")
autoImport("GOManager_InteractNpc")
autoImport("GOManager_Furniture")
autoImport("GOManager_InteractCard")
autoImport("GOManager_SceneBossAnime")
autoImport("GOManager_RoomShow")
autoImport("GOManager_LockCameraForceRoomShow")
autoImport("GOManager_CameraFocusObj")
autoImport("GOManager_RaidPuzzleLight")
autoImport("GOManager_Skybox")
autoImport("GOManager_AreaCP")
autoImport("GOManager_ShadowPuzzle")
autoImport("GOManager_InsightGO")
autoImport("GOManager_StealthGame")
autoImport("GOManager_TextMesh")
autoImport("GOManager_BehaviourTree")
autoImport("GOManager_ObjectFinder")
autoImport("BTInclude")
autoImport("PreprocessHelper")
autoImport("Preprocess_Table")
autoImport("Preprocess_SceneInfo")
autoImport("Preprocess_EnviromentInfo")
autoImport("Game_Interface_ForCSharp")
autoImport("BranchMgr")
autoImport("OverSeaFunc")
autoImport("AudioDefines")
local ResolutionPool = {
  1836.0,
  1224.0,
  918.0,
  720,
  540
}
local ResolutionTextPool = {
  "4K",
  "2K",
  "1080p",
  "720p",
  "540p"
}
local ResolutionGap = 50
Game.SwitchRoleScene = "SwitchRoleLoader"
Game.Param_SwitchRole = "Param_SwitchRole"
function Game.Me(param)
  if nil == Game.me then
    Game.me = Game.new(param)
  end
  return Game.me
end
function Game.GetResolutionNames()
  return Game.ScreenResolutionTexts
end
function Game.SetResolution(index)
  if nil == Game.ScreenResolutions or #Game.ScreenResolutions <= 0 then
    return
  end
  index = RandomUtil.Clamp(index, 1, #Game.ScreenResolutions)
  if index < 1 then
    index = 1
  end
  local resolution = Game.ScreenResolutions[index]
  if ApplicationInfo.IsRunOnWindowns() then
    index = LocalSaveProxy.Instance:GetWindowsResolution()
    helplog("Game SetResolution 1:", index)
    if index == 1 then
      Game.WindowSetting:SetFullScreen()
    else
      local p = RenderingManager.Instance:GetNowURPAssetParam()
      p.renderScale = 0.75 + 0.05 * ROSystemInfo.DeviceRate
      local scaleHeight = LuaLuancher.originalScreenHeight * p.renderScale
      if scaleHeight > 1080 then
        p.renderScale = 1080 / LuaLuancher.originalScreenHeight
      elseif scaleHeight < 720 then
        p.renderScale = 720 / LuaLuancher.originalScreenHeight
      end
      LogUtility.Info("Game SetResolution 2:", p.renderScale)
      RenderingManager.Instance:UpdateURPAssetParam(p)
    end
  else
    local p = RenderingManager.Instance:GetNowURPAssetParam()
    p.renderScale = 0.75 + 0.05 * ROSystemInfo.DeviceRate
    local scaleHeight = LuaLuancher.originalScreenHeight * p.renderScale * resolution
    if scaleHeight > 1080 then
      p.renderScale = 1080 / LuaLuancher.originalScreenHeight
    elseif scaleHeight < 720 then
      if resolution < 1 then
        p.renderScale = 540 / LuaLuancher.originalScreenHeight
      else
        p.renderScale = 720 / LuaLuancher.originalScreenHeight
      end
    end
    LogUtility.Info("Game SetResolution 2:", p.renderScale)
    RenderingManager.Instance:UpdateURPAssetParam(p)
  end
end
function Game.InitAppIsInReview()
  local inAppStoreReview = false
  local verStr = VersionUpdateManager.serverResJsonString
  helplog(verStr)
  if verStr ~= nil and verStr ~= "" then
    local result = StringUtil.Json2Lua(verStr)
    if result and result.data then
      local data = result.data
      local res = data[BranchMgr.IsChina() and "inAppStoreReview" or "lizi"]
      if res then
        if type(res) == "string" then
          if res == "true" then
            inAppStoreReview = true
          end
        elseif type(res) == "boolean" then
          inAppStoreReview = res
        end
      end
    end
  end
  Game.inAppStoreReview = inAppStoreReview
end
local MaxScreenHeight = 918
function Game:InitResolutions()
  local screenWidth = LuaLuancher.originalScreenWidth
  local screenHeight = LuaLuancher.originalScreenHeight
  local screenPct = screenWidth / screenHeight
  if not ApplicationInfo.IsEmulator() and not ApplicationInfo.IsRunOnEditor() and screenHeight > MaxScreenHeight then
    screenHeight = math.max(MaxScreenHeight, screenHeight * 0.85)
    screenWidth = screenHeight * screenPct
  end
  if ApplicationInfo.IsRunOnWindowns() then
    Game.ScreenResolutions = {
      1,
      720 / screenHeight,
      800 / screenHeight,
      600 / screenHeight
    }
    Game.ScreenResolutionTexts = {
      ZhString.Game_FullScreen,
      "1280 x 720",
      "1280 x 800",
      "800 x 600"
    }
    return
  end
  Game.ScreenResolutions = {1}
  Game.ScreenResolutionTexts = {
    ZhString.OriginalResolution
  }
  for i = 1, #ResolutionPool do
    if screenHeight > ResolutionPool[i] + ResolutionGap then
      TableUtility.ArrayPushBack(Game.ScreenResolutions, ResolutionPool[i] / screenHeight)
      TableUtility.ArrayPushBack(Game.ScreenResolutionTexts, ResolutionTextPool[i])
    end
  end
  RenderingManager.Instance:SetUICameraClearAll(false)
end
function Game:ctor(param)
  Buglylog("Game:ctor")
  self:XDELogin()
  Game.State = Game.EState.Running
  Game.FrameCount = 0
  self:InitResolutions()
  LogUtility.SetEnable(ROLogger.enable)
  LogUtility.SetTraceEnable(ROLogger.enable)
  if Application.isEditor then
    LogUtility.SetEnable(true)
    LogUtility.SetTraceEnable(true)
    helplog("Editor ?????????????????????")
  else
    LogUtility.SetEnable(false)
    LogUtility.SetTraceEnable(false)
  end
  local luaLuancher = LuaLuancher.Instance
  self.prefabs = luaLuancher.prefabs
  self.objects = luaLuancher.objects
  ApplicationInfo.SetTargetFrameRate(30)
  Time.fixedDeltaTime = 0.02
  Time.maximumDeltaTime = 0.3333
  UnityEngine.Screen.sleepTimeout = -1
  LeanTween.init(1000)
  Game.InitAppIsInReview()
  Game.Preprocess_Table()
  if ApplicationInfo.IsRunOnWindowns() then
    Game.InputKey = InputKey and InputKey.Instance
    Game.WindowSetting = WindowSetting and WindowSetting.Instance
  end
  self.dataStructureManager = DataStructureManager.new()
  self.functionSystemManager = FunctionSystemManager.new()
  self.guiSystemManager = GUISystemManager.new()
  self.gcSystemManager = GCSystemManager.new()
  local gameObjectManagers = {}
  gameObjectManagers[Game.GameObjectType.Camera] = GOManager_Camera.new()
  gameObjectManagers[Game.GameObjectType.Light] = GOManager_Light.new()
  gameObjectManagers[Game.GameObjectType.RoomHideObject] = GOManager_Room.new()
  local sceneObjectManager = GOManager_SceneObject.new()
  gameObjectManagers[Game.GameObjectType.SceneObjectFinder] = sceneObjectManager
  gameObjectManagers[Game.GameObjectType.SceneAnimation] = sceneObjectManager
  gameObjectManagers[Game.GameObjectType.LocalNPC] = GOManager_LocalNPC.new()
  gameObjectManagers[Game.GameObjectType.DynamicObject] = GOManager_DynamicObject.new()
  gameObjectManagers[Game.GameObjectType.CullingObject] = GOManager_CullingObject.new()
  gameObjectManagers[Game.GameObjectType.SceneSeat] = GOManager_SceneSeat.new()
  gameObjectManagers[Game.GameObjectType.ScenePhotoFrame] = GOManager_ScenePhotoFrame.new()
  gameObjectManagers[Game.GameObjectType.SceneGuildFlag] = GOManager_SceneGuildFlag.new()
  gameObjectManagers[Game.GameObjectType.WeddingPhotoFrame] = GOManager_WeddingPhotoFrame.new()
  gameObjectManagers[Game.GameObjectType.MenuUnlockObj] = GOManager_MenuUnlockObj.new()
  gameObjectManagers[Game.GameObjectType.InteractNpc] = GOManager_InteractNpc.new()
  gameObjectManagers[Game.GameObjectType.Furniture] = GOManager_Furniture.new()
  gameObjectManagers[Game.GameObjectType.InteractCard] = GOManager_InteractCard.new()
  gameObjectManagers[Game.GameObjectType.SceneBossAnime] = GOManager_SceneBossAnime.new()
  gameObjectManagers[Game.GameObjectType.RoomShowObject] = GOManager_RoomShow.new()
  gameObjectManagers[Game.GameObjectType.LockCameraForceRoomShow] = GOManager_LockCameraForceRoomShow.new()
  gameObjectManagers[Game.GameObjectType.CameraFocusObj] = GOManager_CameraFocusObj.new()
  gameObjectManagers[Game.GameObjectType.RaidPuzzle_Light] = GOManager_RaidPuzzleLight.new()
  gameObjectManagers[Game.GameObjectType.Skybox] = GOManager_Skybox.new()
  gameObjectManagers[Game.GameObjectType.AreaCP] = GOManager_AreaCP.new()
  gameObjectManagers[Game.GameObjectType.ShadowPuzzle] = GOManager_ShadowPuzzle.new()
  gameObjectManagers[Game.GameObjectType.InsightGO] = GOManager_InsightGO.new()
  gameObjectManagers[Game.GameObjectType.StealthGame] = GOManager_StealthGame.new()
  gameObjectManagers[Game.GameObjectType.TextMesh] = GOManager_TextMesh.new()
  gameObjectManagers[Game.GameObjectType.BehaviourTree] = GOManager_BehaviourTree.new()
  gameObjectManagers[Game.GameObjectType.ObjectFinder] = GOManager_ObjectFinder.new()
  self.gameObjectManagers = gameObjectManagers
  Game.Instance = self
  Game.Prefab_RoleComplete = self.prefabs[1]:GetComponent(RoleComplete)
  Game.Prefab_SceneSeat = self.prefabs[2]:GetComponent(LuaGameObjectClickable)
  Game.Prefab_ScenePhoto = self.prefabs[3]:GetComponent(Renderer)
  Game.Prefab_SceneGuildIcon = self.prefabs[4]:GetComponent(Renderer)
  Game.Object_Rect = self.objects[1]
  Game.Object_GameObjectMap = self.objects[2]
  local audioCtrl = self.objects[3]
  if not audioCtrl.gameObject:GetComponent(AudioController) then
    audioCtrl.gameObject:AddComponent(AudioController)
  end
  Game.Object_AudioSource2D = audioCtrl.gameObject:GetComponent(AudioController)
  Game.ShaderManager = ShaderManager.Instance
  Game.RoleFollowManager = RoleFollowManager.Instance
  Game.TransformFollowManager = TransformFollowManager.Instance
  Game.InputManager = InputManager.Instance
  Game.CameraPointManager = CameraPointManager.Instance
  Game.BusManager = BusManager.Instance
  Game.Map2DManager = Map2DManager.Instance
  Game.ResourceManager = ResourceManager.Instance
  Game.MapCellManager = MapCellManager.Instance
  Game.GameObjectUtil = GameObjectUtil.Instance
  Game.EffectHandleManager = EffectHandleManager.Instance
  Game.NetConnectionManager = NetConnectionManager.Instance
  Game.NetConnectionManager.EnableLog = false
  Game.InternetUtil = InternetUtil.Ins
  Game.NetIngFileTaskManager = NetIngFileTaskManager.Ins
  Game.HttpWWWRequest = HttpWWWRequest.Instance
  Game.FarmlandManager = FarmlandManager.Ins
  Game.GameObjectManagers = self.gameObjectManagers
  Game.DataStructureManager = self.dataStructureManager
  Game.FunctionSystemManager = self.functionSystemManager
  Game.GUISystemManager = self.guiSystemManager
  Game.GCSystemManager = self.gcSystemManager
  Game.AssetManager_Role:PreloadComplete(200)
  NetConnectionManager.Instance:Restart()
  GameFacade.Instance:registerCommand(StartEvent.StartUp, StartUpCommand)
  GameFacade.Instance:sendNotification(StartEvent.StartUp)
  AppStorePurchase.Ins():AddListener()
  if param == nil then
    SceneProxy.Instance:SyncLoad("CharacterChoose", function()
      GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
        viewname = "StartGamePanel"
      })
    end)
  elseif Game.Param_SwitchRole == param then
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
      viewname = "SwitchRolePanel"
    })
  end
  DiskFileHandler.Ins():EnterRoot()
  DiskFileHandler.Ins():EnterExtension()
  DiskFileHandler.Ins():EnterPublicPicRoot()
  DiskFileHandler.Ins():EnterActivityPicture()
  DiskFileHandler.Ins():EnterLotteryPicture()
  FunctionsCallerInMainThread.Ins:Call(nil)
  CloudFile.CloudFileManager.Ins:Open()
  Game.MapManager:SetInputDisable(true)
  math.randomseed(tostring(os.time()):reverse():sub(1, 6))
  Game.PerformanceManager:LODHigh()
  RenderingManager.Instance:SetSRPBatch(SystemInfo.graphicsMultiThreaded)
  if not BackwardCompatibilityUtil.CompatibilityMode(50) then
    local str = SystemInfo.processorType
    if type(str) == "string" and str:lower():find("armv7") then
      ResourceManager.Instance.GCDeltatime = 60
    end
  end
  if not BackwardCompatibilityUtil.CompatibilityMode(51) then
    local oriLst = ResourceManager.Instance.GCDeltaTimes
    oriLst:Clear()
    local memSize = math.ceil(SystemInfo.systemMemorySize / 1024)
    oriLst:Add(math.max(1200, 300 * memSize))
    oriLst:Add(0.5)
    oriLst:Add(1)
    oriLst:Add(1)
  end
  if GameConfig.SystemForbid.Joystick2_0 then
    InputJoystickProcesser.UseVersion2 = false
  end
  SpyInfo.RegisterAllTracking()
end
function Game:End(toScene, keepResManager)
  DynamicSceneBottomUIPool.Me():clear()
  RenderingManager.Instance:SetUICameraClearAll(true)
  Game.InputManager:Interrupt()
  local list = LuaUtils.CreateStringList()
  if ApplicationInfo.IsRunOnEditor() then
  else
    ROPush.SetTags(os.time(), list)
  end
  FunctionCameraEffect.Me():SaveCameraInfoToLocal()
  HomeManager.Me():Shutdown()
  MountLotteryProxy.Instance:Reset()
  Game.PlotStoryManager:Clear()
  Game.PlotStoryManager:ClearMyTempEffect()
  toScene = toScene or "Launch"
  Buglylog("Game:end toScene:" .. toScene)
  Game.State = Game.EState.Finished
  Game.isSecurityDevice = false
  FunctionCloudFile.Me():Clear()
  local netError = FunctionNetError.Me()
  netError:DisConnect()
  NetManager.GameClose()
  UpYunNetIngFileTaskManager.Ins:Close()
  CloudFile.CloudFileManager.Ins:Close()
  DiskFileManager.Instance:Reset()
  FrameRateSpeedUpChecker.Instance():Close()
  AppStorePurchase.Ins():ClearCallbackAppStorePurchase()
  netError:Clear()
  if Game.Myself then
    Game.Myself:Destroy()
    Game.Myself = nil
  end
  UIModelUtil.Instance:Reset()
  UIMultiModelUtil.Instance:Reset()
  FunctionAppStateMonitor.Me():Reset()
  HttpWWWRequest.Instance:Clear()
  local independentTestGo = GameObject.Find("IndependentTest (delete)")
  if independentTestGo ~= nil then
    GameObject.Destroy(independentTestGo)
  end
  FunctionPreload.Me():Reset()
  local shaderManager = GameObject.Find("ShaderManager(Clone)")
  if shaderManager then
    GameObject.Destroy(shaderManager)
  end
  local ImageCrop = GameObject.Find("ImageCrop")
  if ImageCrop then
    GameObject.Destroy(ImageCrop)
  end
  local gmeMgr = GameObject.Find("GME(Clone)")
  if gmeMgr ~= nil then
    GameObject.DestroyImmediate(gmeMgr)
    gmeMgr = nil
  end
  UIManagerProxy.Instance:Clear()
  if LuaLuancher.Instance then
    GameObject.DestroyImmediate(LuaLuancher.Instance.monoGameObject)
  end
  ModelEpPointRefs.Clear()
  EffectHandleManager.Instance:ClearCheckList()
  LeanTween.CancelAll()
  TimeTickManager.Me():Clear()
  FunctionGetIpStrategy.Me():GameEnd()
  FunctionServerForbidTable.Me():TryRestore()
  SceneUtil.SyncLoad(toScene)
  PlotAudioProxy.Instance:ResetAll()
  SceneUIManager.Instance:Destroy()
  if not keepResManager then
    ResourceManager.Instance.IsAsyncLoadOn = false
  end
  redlog("ResourceManager.Instance.IsAsyncLoadOn =======1======= " .. tostring(ResourceManager.Instance.IsAsyncLoadOn))
  SkillProxy.Instance:ClearSkillLeftCDMap()
  Game.GameHealthProtector:GameEnd()
  FunctionLogin.Me():ClearLoginOutListen()
end
function Game:BackToSwitchRole()
  if CameraController.Instance ~= nil and CameraController.Instance.monoGameObject ~= nil then
    CameraController.Instance.monoGameObject:SetActive(false)
  end
  EventManager.Me():DispatchEvent(AppStateEvent.BackToLogo)
  if ApplicationHelper.AssetBundleLoadMode then
    ResourceManager.Instance:SAsyncLoadScene(Game.SwitchRoleScene, function()
      self:End(Game.SwitchRoleScene, true)
    end)
  else
    self:End(Game.SwitchRoleScene, true)
  end
end
function Game:BackToLogo(toScene)
  if CameraController.Instance ~= nil and CameraController.Instance.monoGameObject ~= nil then
    CameraController.Instance.monoGameObject:SetActive(false)
  end
  EventManager.Me():DispatchEvent(AppStateEvent.BackToLogo)
  self:End(toScene)
end
function Game:BackToLogo(toScene)
  if CameraController.Instance ~= nil and CameraController.Instance.monoGameObject ~= nil then
    CameraController.Instance.monoGameObject:SetActive(false)
  end
  EventManager.Me():DispatchEvent(AppStateEvent.BackToLogo)
  self:End(toScene)
end
NoTransString = {}
OverseasConfig = {}
OverseasConfig.EquipParts = {}
OverseasConfig.IsPlayerInGuild = false
OverseasConfig.LastEnterAreaTime = 0
OverseasConfig.EnterAreaCD = 20
function clone(object)
  local lookup_table = {}
  local function copyObj(object)
    if type(object) ~= "table" then
      return object
    elseif lookup_table[object] then
      return lookup_table[object]
    end
    local new_table = {}
    lookup_table[object] = new_table
    for key, value in pairs(object) do
      new_table[copyObj(key)] = copyObj(value)
    end
    return setmetatable(new_table, getmetatable(object))
  end
  return copyObj(object)
end
function Game:XDELogin()
  OverseasConfig.Award_EN = "Areward"
  OverseasConfig.OriginTeamName = GameConfig.Team and GameConfig.Team.teamname or "_?????????"
  if BranchMgr.IsChina() then
    return
  end
  if BranchMgr.IsJapan() then
    ZhString.Lottery_DetailRate = ZhString.Lottery_DetailRate_Japan
    ZhString.Lottery_RateTip = ZhString.Lottery_RateTip_Japan
    ZhString.QuotaCard_Desc = ZhString.QuotaCard_Desc_JP
    ZhString.NpcCharactorSplit = OverSea.LangManager.Instance():GetLangByKey(ZhString.NpcCharactorSplit)
  elseif BranchMgr.IsTW() then
    ZhString.Oversea_Hard_Code_Client_1 = ZhString.Oversea_Hard_Code_Client_1_TW
    ZhString.Oversea_Hard_Code_Client_2 = ZhString.Oversea_Hard_Code_Client_2_TW
    ZhString.Oversea_Hard_Code_Client_3 = ZhString.Oversea_Hard_Code_Client_3_TW
    ZhString.Oversea_Hard_Code_Client_4 = ZhString.Oversea_Hard_Code_Client_4_TW
  elseif BranchMgr.IsNA() then
    ZhString.QuickUsePopupFuncCell_EquipBtn = ZhString.Verb_Translation_1
    ZhString.Lottery_RateUrl = ZhString.Lottery_RateUrl_Na
  elseif BranchMgr.IsEU() then
    ZhString.QuickUsePopupFuncCell_EquipBtn = ZhString.Verb_Translation_1
  elseif BranchMgr.IsSEA() then
    if BackwardCompatibilityUtil.CompatibilityMode_V65 then
      NGUIText.RemoveIgnoreEasternRange(3584)
    end
    ZhString.QuickUsePopupFuncCell_EquipBtn = ZhString.Verb_Translation_1
  elseif BranchMgr.IsKorea() then
    ZhString.StartGamePanel_CopyRightTips = ZhString.StartGamePanel_CopyRightTips_KR
  end
  OverseasConfig.EquipParts = clone(GameConfig.EquipParts)
  NoTransString.FunctionDialogEvent_Replace = ZhString.FunctionDialogEvent_Replace
  if BranchMgr.IsSEA() or BranchMgr.IsNA() or BranchMgr.IsEU() then
    local lastSetLang = PlayerPrefs.GetString("lastSetLang")
    if lastSetLang == "" then
      lastSetLang = AppBundleConfig.GetLangString(tostring(Application.systemLanguage))
      helplog("?????????????????????????????????????????????????????????lua????????????????????????????????????", lastSetLang)
      OverSea.LangManager.Instance():SetCurLang(lastSetLang)
      OverSeas_TW.OverSeasManager.GetInstance():SetSDKLang(AppBundleConfig.GetSDKLang_TDSG())
    elseif lastSetLang ~= "English" and OverSea.LangManager.Instance().CurSysLang == "English" then
      helplog("?????????????????????????????????????????????????????????lua????????????????????????", lastSetLang)
      OverSea.LangManager.Instance():SetCurLang(lastSetLang)
      OverSeas_TW.OverSeasManager.GetInstance():SetSDKLang(AppBundleConfig.GetSDKLang_TDSG())
    end
    if OverSea.LangManager.Instance().CurSysLang == "French" or OverSea.LangManager.Instance().CurSysLang == "Turkish" then
      OverSea.LangManager.Instance():SetCurLang("English")
      OverSeas_TW.OverSeasManager.GetInstance():SetSDKLang(AppBundleConfig.GetSDKLang_TDSG())
    end
    OverSea.LangManager.Instance():InitLangConfig()
  end
  orginStringFormat = string.format
  function string.format(format, ...)
    local arg = {}
    for i = 1, select("#", ...) do
      local p = select(i, ...)
      local langP = OverSea.LangManager.Instance():GetLangByKey(p)
      table.insert(arg, langP)
    end
    return orginStringFormat(OverSea.LangManager.Instance():GetLangByKey(format), unpack(arg))
  end
  OverSea.LangManager.Instance():InitAtlass()
  Game.track(Table_Map, {"NameZh", "CallZh"})
  Game.track(Table_Sysmsg, {"Text"})
  Game.track(Table_ItemType, {"Name"})
  Game.track(Table_NpcFunction, {"NameZh"})
  Game.track(Table_Class, {
    "NameZh",
    "NameZhFemale"
  })
  Game.track(Table_WantedQuest, {"Target"})
  Game.track(Table_AdventureAppend, {"Desc"})
  Game.track(Table_MCharacteristic, {"NameZh", "Desc"})
  Game.track(Table_Appellation, {"Name"})
  Game.track(Table_RoleData, {"PropName", "RuneName"})
  Game.track(Table_Viewspot, {"SpotName"})
  Game.track(Table_EquipSuit, {"EffectDesc"})
  Game.track(Table_ChatEmoji, {"Emoji"})
  Game.track(Table_RuneSpecial, {"RuneName"})
  Game.track(Table_Guild_Faith, {"Name"})
  Game.track(Table_Recipe, {"Name"})
  Game.track(Table_ItemTypeAdventureLog, {"Name"})
  Game.track(Table_ActivityStepShow, {"Trace_Text"})
  Game.track(Table_GuildBuilding, {
    "FuncDesc",
    "LevelUpPreview"
  })
  Game.track(Table_ItemAdvManual, {"LockDesc"})
  Game.track(Table_Menu, {"text", "Tip"})
  Game.track(Table_Guild_Treasure, {"Desc"})
  Game.track(Table_QuestVersion, {
    "VersionStory"
  })
  Game.track(Table_Growth, {"desc"})
  Game.track(Table_ServantImproveGroup, {"desc", "maintitle"})
  Game.track(Table_ServantUnlockFunction, {"desc"})
  Game.track(Table_MercenaryCat, {"Job"})
  Game.track(Table_HomeFurniture, {"NameZh"})
  Game.track(Table_HomeFurnitureMaterial, {"NameZh"})
  autoImport("Table_HomeOfficialBluePrint")
  Game.track(Table_HomeOfficialBluePrint, {"RewardTip", "Desc"})
  Game.track(Table_GemEffect, {"Desc"})
  Game.track(Table_GemUpgrade, {"Dsc"})
  Game.track(Table_Exchange, {"NameZh"})
  Game.track(Table_Help, {"Desc"})
  Game.track(Table_AddWay, {"NameEn", "Desc"})
  Game.track(Table_TeamGoals, {
    "NameZh",
    "RootRaidDesc"
  })
  autoImport("DialogEventConfig")
  Game.track(EventDialog, {"DialogText"})
  Game.track(Table_AssetEffect, {"Desc"})
  Game.track(Table_Equip_recommend, {"genre"})
  Game.track(Table_DepositCountReward, {"Des", "Des2"})
  Game.track(Table_EquipExtraction, {"Dsc"})
  Game.track(Table_BuffReward, {"Name", "Desc"})
  Game.transTable(Table_RedPacket)
  Game.transTable(GameConfig)
  Game.transTable(ZhString)
  StrTablesManager.DoInitTranslate()
  ZhString.MultiProfession_SaveName = ZhString.MultiProfession_SaveName:gsub(" ", "_")
  local keys = {"Text"}
  for _, v in pairs(Table_Sysmsg) do
    for __, key in pairs(keys) do
      v[key] = v[key]:gsub("Item", "item")
    end
  end
  if BranchMgr.IsTW() and ObscenceLanguage.NameExclude == nil then
    XDLog("Error", "ObscenceLanguage.NameExclude ?????????")
    ObscenceLanguage.NameExclude = {
      " ",
      "%%",
      "-",
      "/",
      "*",
      "#",
      ",",
      ":",
      ";",
      ".",
      "???",
      "(",
      ")",
      "&",
      "$",
      "\"",
      "'",
      "!",
      "@",
      "|",
      "\n"
    }
  end
  for k, v in pairs(GameConfig.AdventureUnlockCodition) do
    GameConfig.AdventureUnlockCodition[k] = v:gsub(" $", "")
  end
  if OverSea.LangManager.Instance().CurSysLang == "Thai" then
    GameConfig.ActivityCountDown[28] = {
      effectPath = "HappyNewYear_time",
      finalEffectPath = "HappyNewYear_2"
    }
  end
end
function Game.track2(t, keys)
  if BranchMgr.IsChina() then
    return
  end
  for __, key in pairs(keys) do
    if t[key] == nil then
      t[key] = ""
    end
    t[key] = OverSea.LangManager.Instance():GetLangByKey(t[key])
  end
end
function Game.track3(t, keys)
  if BranchMgr.IsChina() then
    return
  end
  for __, key in pairs(keys) do
    if t[key] ~= nil then
      t[key] = OverSea.LangManager.Instance():GetLangByKey(t[key])
    end
  end
end
function Game.track(t, keys)
  if BranchMgr.IsChina() then
    return
  end
  if not t then
    LogUtility.Error("???????????????????????????????????????????????????")
    return
  end
  for _, v in pairs(t) do
    for __, key in pairs(keys) do
      if v[key] == nil then
        v[key] = ""
      end
      v[key] = OverSea.LangManager.Instance():GetLangByKey(v[key])
    end
  end
end
function Game.transTable(tbl)
  if BranchMgr.IsChina() then
    return
  end
  for k, v in pairs(tbl) do
    if type(v) == "string" then
      tbl[k] = OverSea.LangManager.Instance():GetLangByKey(v)
    elseif type(v) == "table" then
      Game.transTable(v)
    end
  end
end
function Game.transArray(arr)
  if BranchMgr.IsChina() then
    return
  end
  for i = 1, #arr do
    arr[i] = OverSea.LangManager.Instance():GetLangByKey(arr[i])
  end
end
local candidates = {
  "???????????????",
  "???????????????",
  "?????????????????????",
  "_?????????",
  "?????????"
}
function Game.simpleReplace(origin)
  if BranchMgr.IsChina() then
    return origin
  end
  local ret = origin
  for _, candidate in ipairs(candidates) do
    local translated = OverSea.LangManager.Instance():GetLangByKey(candidate)
    ret = string.gsub(ret, candidate, translated)
  end
  return ret
end
function Game.convert2OffLbl(lbl)
  local tmp = lbl.text
  local hasPct = tmp:find("%%")
  tmp = tmp:gsub("%%", "")
  tmp = tonumber(tmp)
  lbl.text = 100 - tmp
  if hasPct then
    lbl.text = lbl.text .. "%"
  end
end
function Game.DestroyDebugRoot()
  local runtimePlatform = ApplicationInfo.GetRunPlatform()
  if runtimePlatform ~= RuntimePlatform.IPhonePlayer or not EnvChannel.IsReleaseBranch() or CompatibilityVersion.version ~= 45 then
    return
  end
  Game.DoDestroyDebugRoot()
  TimeTickManager.Me():CreateOnceDelayTick(500, function(owner, deltaTime)
    Game.DoDestroyDebugRoot()
  end, self)
end
function Game.DoDestroyDebugRoot()
  local go = GameObject.Find("Debug(Clone)")
  if go then
    GameObject.DestroyImmediate(go)
  end
  go = GameObject.Find("DebugRoot(Clone)")
  if go then
    GameObject.DestroyImmediate(go)
  end
end
function Game.UseNewVersionInput()
  return Game.InputManager and Game.InputManager.USE_NEW_VERSION
end
