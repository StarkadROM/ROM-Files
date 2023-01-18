NSceneTopFuncWord = reusableClass("NSceneTopFuncWord")
NSceneTopFuncWord.PoolSize = 50
NSceneTopFuncWord.ResID = ResourcePathHelper.UIPrefab_Cell("SceneTopFuncWord")
local _gameUtilInstance = GameObjectUtil.Instance
local func_deepFind = _gameUtilInstance.DeepFind
function NSceneTopFuncWord:InitCellGO()
  if LuaGameObject.ObjectIsNull(self.gameObject) then
    return
  end
  LuaGameObject.SetLocalPositionGO(self.gameObject, 0, 0, 0)
  LuaGameObject.SetLocalRotationGO(self.gameObject, 0, 0, 0, 1)
  LuaGameObject.SetLocalScaleGO(self.gameObject, 1, 1, 1)
  self.labelGo = func_deepFind(_gameUtilInstance, self.gameObject, "Label")
  self.label = self.labelGo:GetComponent(Text)
  self.labelCanvas = self.labelGo:GetComponent(CanvasGroup)
  self.labelOriginalDepth = self.label.depth
  self.leftlabelGo = func_deepFind(_gameUtilInstance, self.gameObject, "LeftLabel")
  self.leftlabel = self.leftlabelGo:GetComponent(Text)
  self.leftlabelCanvas = self.leftlabelGo:GetComponent(CanvasGroup)
  self.leftlabelOriginalDepth = self.leftlabel.depth
  self.rightlabelGo = func_deepFind(_gameUtilInstance, self.gameObject, "RightLabel")
  self.rightlabel = self.rightlabelGo:GetComponent(Text)
  self.rightlabelCanvas = self.rightlabelGo:GetComponent(CanvasGroup)
  self.rightlabelOriginalDepth = self.rightlabel.depth
  self.symbolGO = func_deepFind(_gameUtilInstance, self.gameObject, "Symbol")
  self.symbol = self.symbolGO:GetComponent(Image)
  self.symbolCanvas = self.symbolGO:GetComponent(CanvasGroup)
  self.symbolOriginalDepth = self.symbol.depth
  self.bg = func_deepFind(_gameUtilInstance, self.gameObject, "Bg1"):GetComponent(Image)
  self.bgOriginalDepth = self.bg.depth
end
function NSceneTopFuncWord:SetMinDepth(mindepth)
end
function NSceneTopFuncWord:Active(b)
  if not LuaGameObject.ObjectIsNull(self.gameObject) then
    self:SetActive(self.canvasGroup, b, true)
  end
end
function NSceneTopFuncWord:SetActive(canvasGroup, visible, isRoot)
  if not canvasGroup then
    return
  end
  if isRoot then
    if self.isVisible == visible then
      return
    end
    self.isVisible = visible
    self.bg.gameObject:SetActive(visible)
  end
  canvasGroup.alpha = visible and 1 or 0
end
function NSceneTopFuncWord:DoConstruct(asArray, args)
  self.gameObject = args[1]
  self.canvasGroup = self.gameObject:GetComponent(CanvasGroup)
  self:InitCellGO()
  local text = args[2]
  local icon = args[3]
  local clickFunc = args[4]
  local clickArgs = args[5]
  local creature = args[6]
  self.isVisible = false
  local typeString = type(text) == "string"
  local typeTable = type(text) == "table"
  self:SetActive(self.labelCanvas, typeString)
  self:SetActive(self.leftlabelCanvas, typeTable)
  self:SetActive(self.rightlabelCanvas, typeTable)
  if typeString then
    self.label.text = text
  elseif typeTable then
    self.leftlabel.text = text.left
    self.rightlabel.text = text.right
  end
  if icon then
    self:SetActive(self.symbolCanvas, true)
    SpriteManager.SetUISprite("sceneui", tostring(icon), self.symbol)
  else
    self:SetActive(self.symbolCanvas, false)
  end
  if clickFunc and self.bg then
    self:AddClickEvent(self.bg.gameObject, function(go)
      if not self.isVisible then
        return
      end
      clickFunc(clickArgs)
    end)
  end
  self:SetActive(self.canvasGroup, not FunctionSceneFilter.Me():IsFilterBy(GameConfig.Booth.screenFilterID), true)
end
function NSceneTopFuncWord:DoDeconstruct(asArray)
  self.parent = nil
  if not LuaGameObject.ObjectIsNull(self.gameObject) then
    Game.GOLuaPoolManager:AddToSceneUIPool(NSceneTopFuncWord.ResID, self.gameObject)
    self:AddClickEvent(self.bg.gameObject, nil)
  end
  self:SetActive(self.canvasGroup, false, true)
  self.label = nil
  self.labelGo = nil
  self.labelCanvas = nil
  self.leftlabel = nil
  self.leftlabelGo = nil
  self.leftlabelCanvas = nil
  self.rightlabel = nil
  self.rightlabelGo = nil
  self.rightlabelCanvas = nil
  self.symbol = nil
  self.symbolGO = nil
  self.symbolCanvas = nil
  self.bg = nil
  self.gameObject = nil
  self.canvasGroup = nil
  self.symbolCanvas = nil
  self.isVisible = false
end
function NSceneTopFuncWord:AddClickEvent(obj, event)
  if event == nil then
    UGUIEventListener.Get(obj).onClick = nil
    return
  end
  UGUIEventListener.Get(obj).onClick = function(go)
    if UICamera.isOverUI then
      return
    end
    if event then
      event(go)
    end
  end
end
