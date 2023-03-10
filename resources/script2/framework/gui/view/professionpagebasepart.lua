ProfessionPageBasePart = class("ProfessionPageBasePart", SubView)
local Prefab_Path = ResourcePathHelper.UIView("ProfessionPageBasePart")
autoImport("ProfessionAttrCell")
autoImport("RoleEquipItemCell")
autoImport("ProfessionProecessCell")
local picIns = PictureManager.Instance
local _ProfessionProxy = ProfessionProxy.Instance
local _ArrayPushBack = TableUtility.ArrayPushBack
local _GetTempVector3 = LuaGeometry.GetTempVector3
local _ProfessionProxy, _PictureManager
local _GetPosition = LuaGameObject.GetPosition
local _GetRotation = LuaGameObject.GetRotation
local _GetTempQuaternion = LuaGeometry.GetTempQuaternion
local _ObjectIsNull = LuaGameObject.ObjectIsNull
local _SetPositionGO = LuaGameObject.SetPositionGO
local _LuaDestroyObject = LuaGameObject.DestroyObject
local _MyGender, _MyRace
local _tmpPos = LuaVector3.Zero()
local _TweenDelay = 0.3
local PropsPartTween = {
  CurJob = Vector3(-247.4, 0, 0),
  AdvanceJob = Vector3(-418.7, 0, 0),
  Ymir = Vector3(-188, 0, 0),
  Equip = Vector3(-400, 0, 0)
}
local ClassBranchPartTween = {
  FadeIn = Vector3(0, 0, 0),
  FadeOut = Vector3(230, 0, 0)
}
local SwitchNodePartTween = {
  FadeIn = Vector3(0, -360, 0),
  FadeOut = Vector3(100, -360, 0)
}
local ClassProcessTween = {
  CurJob = Vector3(197.3, 0, 0),
  AdvanceJob = Vector3(400, 0, 0),
  Ymir = Vector3(240, 0, 0),
  Equip = Vector3(400, 0, 0)
}
ProfessionPageBasePart.TweenGroup = {
  AllHide = {
    [1] = {
      pos = PropsPartTween.Equip,
      alpha = 0
    },
    [2] = {
      pos = ClassBranchPartTween.FadeOut,
      alpha = 0
    },
    [3] = {
      pos = ClassProcessTween.Equip,
      alpha = 0
    }
  },
  CurJob = {
    [1] = {
      pos = PropsPartTween.CurJob,
      alpha = 1
    },
    [2] = {
      pos = ClassBranchPartTween.FadeIn,
      alpha = 1
    },
    [3] = {
      pos = ClassProcessTween.CurJob,
      alpha = 1
    }
  },
  AdvanceJob = {
    [1] = {
      pos = PropsPartTween.AdvanceJob,
      alpha = 1
    },
    [2] = {
      pos = ClassBranchPartTween.FadeIn,
      alpha = 1
    },
    [3] = {
      pos = ClassProcessTween.AdvanceJob,
      alpha = 0
    }
  },
  Ymir = {
    [1] = {
      pos = PropsPartTween.Ymir,
      alpha = 1
    },
    [2] = {
      pos = ClassBranchPartTween.FadeIn,
      alpha = 1
    },
    [3] = {
      pos = ClassProcessTween.Ymir,
      alpha = 1
    }
  },
  Equip = {
    [1] = {
      pos = PropsPartTween.Equip,
      alpha = 0
    },
    [2] = {
      pos = ClassBranchPartTween.FadeIn,
      alpha = 1
    },
    [3] = {
      pos = ClassProcessTween.Equip,
      alpha = 0
    }
  },
  HeroStory = {
    [1] = {
      pos = PropsPartTween.Equip,
      alpha = 0
    },
    [2] = {
      pos = ClassBranchPartTween.FadeIn,
      alpha = 1
    },
    [3] = {
      pos = ClassProcessTween.Equip,
      alpha = 0
    }
  },
  YmirNoRecord = {
    [1] = {
      pos = PropsPartTween.Ymir,
      alpha = 0
    },
    [2] = {
      pos = ClassBranchPartTween.FadeIn,
      alpha = 0
    },
    [3] = {
      pos = ClassProcessTween.Ymir,
      alpha = 0
    }
  }
}
local classProcessConfig = {
  SkillStatus = {
    Icon = "tab_icon_10",
    order = 1,
    Name = ZhString.ProfessionPage_SkillStatus
  },
  HeroStoryStatus = {
    Icon = "icon_134",
    order = 2,
    Name = ZhString.ProfessionPage_HeroStatus
  },
  SkillGemStatus = {
    Icon = "icon_134",
    order = 3,
    Name = ZhString.ProfessionPage_SkillGemStatus
  },
  AttrGemStatus = {
    Icon = "icon_134",
    order = 4,
    Name = ZhString.ProfessionPage_AttrGemStatus
  },
  AstrolabeStatus = {
    Icon = "icon_133",
    order = 5,
    Name = ZhString.ProfessionPage_AstrolabeStatus
  },
  ArtifactStatus = {
    Icon = "tab_icon_119",
    order = 6,
    Name = ZhString.ProfessionPage_ArtifactStatus
  },
  ExtractStatus = {
    Icon = "tab_icon_54",
    order = 7,
    Name = ZhString.ProfessionPage_ExtractStatus
  }
}
function ProfessionPageBasePart:UpdatePageTween(TweenGroup)
  if not TweenGroup then
    return
  end
  for i = 1, 3 do
    if TweenGroup[i] then
      TweenPosition.Begin(self.tweensGO[i], _TweenDelay, TweenGroup[i].pos)
      TweenAlpha.Begin(self.tweensGO[i], _TweenDelay, TweenGroup[i].alpha)
      if i == 1 then
        if TweenGroup[i].alpha == 0 then
          self.polygon.gameObject:SetActive(false)
        else
          self.polygon.gameObject:SetActive(true)
        end
      end
    end
  end
end
function ProfessionPageBasePart:ResetPageToDefault()
  local TweenGroup = ProfessionPageBasePart.TweenGroup.AllHide
  for i = 1, 3 do
    if TweenGroup[i] then
      TweenPosition.Begin(self.tweensGO[i], 0, TweenGroup[i].pos)
      TweenAlpha.Begin(self.tweensGO[i], 0, TweenGroup[i].alpha)
      if i == 1 then
        if TweenGroup[i].alpha == 0 then
          self.polygon.gameObject:SetActive(false)
        else
          self.polygon.gameObject:SetActive(true)
        end
      end
    end
  end
end
function ProfessionPageBasePart:Init()
  _ProfessionProxy = ProfessionProxy.Instance
  _PictureManager = PictureManager.Instance
  _MyGender = MyselfProxy.Instance:GetMySex()
  _MyRace = MyselfProxy.Instance:GetMyRace()
  self:LoadSubView()
  self:FindObjs()
  self:AddEvts()
end
function ProfessionPageBasePart:LoadSubView()
  local container = self.container.basePartContainer
  local obj = self:LoadPreferb_ByFullPath(Prefab_Path, container, true)
  obj.name = "ProfessionPageBasePart"
  self.gameObject = obj
end
function ProfessionPageBasePart:FindObjs()
  self.propsPart = self:FindGO("PropsPart")
  self.propsPart_TweenPos = self.propsPart:GetComponent(TweenPosition)
  self.polygonDots = {}
  self.attrRoot = self:FindGO("AttrRoot", self.rightRoot)
  self.attrTexture = self:FindComponent("AttrTexture", UITexture, self.attrRoot)
  local dotRoot = self:FindGO("DotRoot", self.attrRoot)
  _ArrayPushBack(self.polygonDots, self:FindGO("Str", dotRoot).transform:GetChild(0))
  _ArrayPushBack(self.polygonDots, self:FindGO("Int", dotRoot).transform:GetChild(0))
  _ArrayPushBack(self.polygonDots, self:FindGO("Vit", dotRoot).transform:GetChild(0))
  _ArrayPushBack(self.polygonDots, self:FindGO("Agi", dotRoot).transform:GetChild(0))
  _ArrayPushBack(self.polygonDots, self:FindGO("Dex", dotRoot).transform:GetChild(0))
  _ArrayPushBack(self.polygonDots, self:FindGO("Luk", dotRoot).transform:GetChild(0))
  self.polygon = self:FindComponent("PowerPolyGo", PolygonSprite, self.attrRoot)
  self.polygon:ReBuildPolygon()
  self.polyValues = {}
  local valueRoot = self:FindGO("Value", self.attrRoot)
  _ArrayPushBack(self.polyValues, self:FindGO("StrValue", valueRoot):GetComponent(UILabel))
  _ArrayPushBack(self.polyValues, self:FindGO("IntValue", valueRoot):GetComponent(UILabel))
  _ArrayPushBack(self.polyValues, self:FindGO("VitValue", valueRoot):GetComponent(UILabel))
  _ArrayPushBack(self.polyValues, self:FindGO("AgiValue", valueRoot):GetComponent(UILabel))
  _ArrayPushBack(self.polyValues, self:FindGO("DexValue", valueRoot):GetComponent(UILabel))
  _ArrayPushBack(self.polyValues, self:FindGO("LukValue", valueRoot):GetComponent(UILabel))
  self.props = self:FindGO("Props")
  self.propsGrid = self:FindGO("PropsGrid"):GetComponent(UIGrid)
  self.propsCtrl = UIGridListCtrl.new(self.propsGrid, ProfessionAttrCell, "ProfessionAttrCell")
  self.infomations = {
    unpack(GameConfig.SavePreviewAttrSec)
  }
  self.propsCtrl:SetEmptyDatas(#self.infomations)
  self.maxJobTip = self:FindGO("MaxJobTip")
  self.equipPart = self:FindGO("EquipPart")
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self.tipContainer = self:FindComponent("TipContainer", UISprite)
  local grid = self:FindGO("EquipGrid", self.equipPart):GetComponent(UIGrid)
  self.equipGrid = self:TransEquipGrid(grid, 129)
  self.equipList = {}
  for i = 1, 14 do
    local go = self:LoadPreferb("cell/RoleEquipItemCell", grid)
    go.name = "RoleEquipItemCell" .. i
    self.equipList[i] = RoleEquipItemCell.new(go, i)
    self.equipList[i]:AddEventListener(MouseEvent.MouseClick, self.ClickEquip, self)
  end
  self.anchor_rightTop = self:FindGO("Anchor_RightTop")
  self.curClassGO = self:FindGO("CurClassSprite", self.anchor_rightTop)
  self.curClassGOCollider = self.curClassGO:GetComponent(BoxCollider)
  self.curClassIcon = self:FindGO("JobIcon", self.curClassGO):GetComponent(UISprite)
  self.curClassName = self:FindGO("ClassName", self.anchor_rightTop):GetComponent(UILabel)
  self.curClassLevel = self:FindGO("JobLevel", self.anchor_rightTop):GetComponent(UILabel)
  self.curClassCheckMark = self:FindGO("CheckMark", self.curClassGO)
  self.curClassCheckMark_Icon = self:FindGO("Sprite", self.curClassCheckMark):GetComponent(UISprite)
  self.curClass_TweenScale = self.curClassGO:GetComponent(TweenScale)
  self.advancedJob = {}
  for i = 1, 2 do
    self.advancedJob[i] = {}
    self.advancedJob[i].go = self:FindGO("AdvancedJob" .. i, self.anchor_rightTop)
    self.advancedJob[i].tweenScale = self.advancedJob[i].go:GetComponent(TweenScale)
    self.advancedJob[i].checkMark = self:FindGO("CheckMark", self.advancedJob[i].go)
    self.advancedJob[i].checkMark_Icon = self:FindGO("Sprite", self.advancedJob[i].checkMark):GetComponent(UISprite)
    self.advancedJob[i].jobIcon = self:FindGO("JobIcon", self.advancedJob[i].go):GetComponent(UISprite)
    self.advancedJob[i].jobName = self:FindGO("ClassName", self.advancedJob[i].go):GetComponent(UILabel)
  end
  self.line1 = self:FindGO("Line1", self.anchor_rightTop)
  self.line2 = self:FindGO("Line2", self.anchor_rightTop)
  self.anchor_Right = self:FindGO("Anchor_Right")
  self.pageSwitchBG = self:FindGO("bg", self.anchor_Right):GetComponent(UISprite)
  self.statusBtn = self:FindGO("StatusBtn", self.anchor_Right)
  self.statusBtn_Icon = self.statusBtn:GetComponent(UISprite)
  self.equipBtn = self:FindGO("EquipBtn", self.anchor_Right)
  self.equipBtn_Icon = self.equipBtn:GetComponent(UISprite)
  self.fateBtn = self:FindGO("FateBtn", self.anchor_Right)
  self.fateBtn_Icon = self.fateBtn:GetComponent(UISprite)
  self.switchNodePart = self:FindGO("SwitchNodePart")
  self.switchNode = self:FindGO("SwitchNode", self.anchor_Right)
  self.switchNode_TweenPos = self.switchNode:GetComponent(TweenPosition)
  self.classProcess = self:FindGO("ClassProcess")
  self.classProcessGrid = self:FindGO("Grid", self.classProcess):GetComponent(UIGrid)
  self.classProcessCells = {}
  for k, v in pairs(classProcessConfig) do
    local data = {}
    data.go = self:FindGO(k, self.classProcess)
    data.Icon = self:FindGO("Icon", data.go):GetComponent(UISprite)
    IconManager:SetUIIcon(v.Icon, data.Icon)
    data.ProcessLabel = self:FindGO("ProcessLabel", data.go):GetComponent(UILabel)
    data.Name = self:FindGO("Name", data.go):GetComponent(UILabel)
    data.Name.text = v.Name
    self.classProcessCells[v.order] = data
  end
  self.tweensGO = {}
  self.tweensGO[1] = self:FindGO("PropsPart")
  self.tweensGO[2] = self:FindGO("ClassBranchPart")
  self.tweensGO[3] = self:FindGO("ClassProcess")
  self:UpdateSwitchNode(1)
end
function ProfessionPageBasePart:AddEvts()
  self:AddClickEvent(self.statusBtn, function()
    self:UpdateSwitchNode(1)
  end)
  self:AddClickEvent(self.equipBtn, function()
    self:UpdateSwitchNode(2)
  end)
  self:AddClickEvent(self.fateBtn, function()
    self:UpdateSwitchNode(3)
  end)
  self:AddClickEvent(self.curClassGO, function()
    self:ResetClassIconTween()
    EventManager.Me():DispatchEvent(MultiProfessionEvent.ClickCurClass)
  end)
  for i = 1, 2 do
    self:AddClickEvent(self.advancedJob[i].go, function()
      self:PlayAdvancedClassTween(i)
      local targetJob = self.advancedJob[i].targetJob
      EventManager.Me():DispatchEvent(MultiProfessionEvent.ClickAdvanceClass, targetJob)
    end)
    break
  end
  for i = 1, #self.classProcessCells do
    self:AddClickEvent(self.classProcessCells[i].go, function()
      if self.classProcessCells[i].clickFunc then
        self.container:SetPushToStack(true)
        self.classProcessCells[i].clickFunc(self.classProcessCells[i].owner, self.classProcessCells[i].funcParams)
      end
    end)
    break
  end
end
function ProfessionPageBasePart:UpdateSwitchNode(index)
  self.curSwitchNode = index
  local bRet = self.container:SwitchToNode(index)
  if not bRet then
    return
  end
  if index == 1 then
    self:PlayPageNodeTween(self.statusBtn)
    self.statusBtn_Icon.color = LuaGeometry.GetTempVector4(0.3843137254901961, 0.4392156862745098, 0.49019607843137253, 1)
    self.equipBtn_Icon.color = LuaGeometry.GetTempVector4(0.615686274509804, 0.6588235294117647, 0.7294117647058823, 1)
    self.fateBtn_Icon.color = LuaGeometry.GetTempVector4(0.615686274509804, 0.6588235294117647, 0.7294117647058823, 1)
    if self.curTab == 1 then
      self:UpdatePageTween(ProfessionPageBasePart.TweenGroup.CurJob)
    elseif self.curTab == 2 then
      self:UpdatePageTween(ProfessionPageBasePart.TweenGroup.Ymir)
    end
    self.equipPart:SetActive(false)
  elseif index == 2 then
    self:PlayPageNodeTween(self.equipBtn)
    self.statusBtn_Icon.color = LuaGeometry.GetTempVector4(0.615686274509804, 0.6588235294117647, 0.7294117647058823, 1)
    self.equipBtn_Icon.color = LuaGeometry.GetTempVector4(0.3843137254901961, 0.4392156862745098, 0.49019607843137253, 1)
    self.fateBtn_Icon.color = LuaGeometry.GetTempVector4(0.615686274509804, 0.6588235294117647, 0.7294117647058823, 1)
    self:UpdatePageTween(ProfessionPageBasePart.TweenGroup.Equip)
    self.equipPart:SetActive(true)
    self.equipGrid:Reposition()
  elseif index == 3 then
    self:PlayPageNodeTween(self.fateBtn)
    self.statusBtn_Icon.color = LuaGeometry.GetTempVector4(0.615686274509804, 0.6588235294117647, 0.7294117647058823, 1)
    self.equipBtn_Icon.color = LuaGeometry.GetTempVector4(0.615686274509804, 0.6588235294117647, 0.7294117647058823, 1)
    self.fateBtn_Icon.color = LuaGeometry.GetTempVector4(0.3843137254901961, 0.4392156862745098, 0.49019607843137253, 1)
    self:UpdatePageTween(ProfessionPageBasePart.TweenGroup.HeroStory)
    self.equipPart:SetActive(false)
  end
end
function ProfessionPageBasePart:SetCurTabIndex(tab)
  self.curTab = tab
end
function ProfessionPageBasePart:ResetClassIconTween()
  self.curClass_TweenScale:PlayReverse()
  TweenAlpha.Begin(self.curClassCheckMark, 0.2, 1)
  for i = 1, 2 do
    self.advancedJob[i].tweenScale:PlayForward()
    TweenAlpha.Begin(self.advancedJob[i].checkMark, 0.2, 0)
  end
end
function ProfessionPageBasePart:PlayAdvancedClassTween(index)
  self.curClass_TweenScale:PlayForward()
  TweenAlpha.Begin(self.curClassCheckMark, 0.2, 0)
  for i = 1, 2 do
    if i == index then
      self.advancedJob[i].tweenScale:PlayReverse()
      TweenAlpha.Begin(self.advancedJob[i].checkMark, 0.2, 1)
    else
      self.advancedJob[i].tweenScale:PlayForward()
      TweenAlpha.Begin(self.advancedJob[i].checkMark, 0.2, 0)
    end
  end
end
function ProfessionPageBasePart:PlayPageNodeTween(obj)
  if not obj then
    return
  end
  local targetPos = obj.transform.localPosition
  LuaVector3.Better_SetPos(_tmpPos, targetPos)
  self.switchNode_TweenPos.to = _tmpPos
  local curPos = self.switchNode.transform.localPosition
  LuaVector3.Better_SetPos(_tmpPos, curPos)
  self.switchNode_TweenPos.from = _tmpPos
  self.switchNode_TweenPos:ResetToBeginning()
  self.switchNode_TweenPos:PlayForward()
end
function ProfessionPageBasePart:RefreshNodes(classid)
  local isHero = ProfessionProxy.IsHero(classid)
  self:SetFateBtnState(isHero)
end
function ProfessionPageBasePart:SetFateBtnState(state)
  self.fateBtn:SetActive(state)
  self.pageSwitchBG.height = state and 232 or 156
end
function ProfessionPageBasePart:SetClassGOClickState(state)
  self.curClassGOCollider.enabled = state
end
function ProfessionPageBasePart:SetEquipPartPos(index)
  if index == 1 then
    self.equipPart.transform.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
  elseif index == 2 then
    self.equipPart.transform.localPosition = LuaGeometry.GetTempVector3(100, 0, 0)
  end
end
function ProfessionPageBasePart:TransEquipGrid(grid, width)
  local equipGrid = {}
  equipGrid.grid = grid
  equipGrid.transform = grid.transform
  equipGrid.gameObject = grid.gameObject
  function equipGrid.Reposition(equipGrid_self)
    equipGrid_self.grid:Reposition()
    local childCount = equipGrid_self.transform.childCount
    if childCount == 13 then
      local cell13 = equipGrid_self.transform:GetChild(12)
      if cell13 then
        cell13.transform.localPosition = LuaGeometry.GetTempVector3(216, -488)
      end
    elseif childCount == 14 then
      local cell13 = equipGrid_self.transform:GetChild(12)
      if cell13 then
        cell13.transform.localPosition = LuaGeometry.GetTempVector3(width, -488)
      end
      local cell14 = equipGrid_self.transform:GetChild(13)
      if cell14 then
        cell14.transform.localPosition = LuaGeometry.GetTempVector3(width * 2, -488)
      end
    end
  end
  return equipGrid
end
function ProfessionPageBasePart:UpdateProps(classid)
  local typeBranch = ProfessionProxy.GetTypeBranchFromProf(classid)
  local state = ProfessionProxy.Instance:GetClassState(classid)
  local _BranchInfoSaveProxy = BranchInfoSaveProxy.Instance
  local saveInfoData = _BranchInfoSaveProxy:GetUsersaveData(typeBranch)
  local props
  if state == 3 then
    props = Game.Myself.data.props
  elseif state == 1 then
    if saveInfoData then
      props = _BranchInfoSaveProxy:GetProps(typeBranch)
    else
      self.props:SetActive(false)
      return
    end
  else
    self.props:SetActive(false)
    return
  end
  self:SetProps(props)
end
function ProfessionPageBasePart:SetProps(props)
  if not props then
    self.props:SetActive(false)
    return
  else
    self.props:SetActive(true)
  end
  local cells = self.propsCtrl:GetCells()
  local showDatas = {}
  for i = 1, #GameConfig.SavePreviewAttrSec do
    local single = GameConfig.SavePreviewAttrSec[i]
    local test = props:GetPropByName(single)
    if test ~= nil then
      local data = {}
      data.prop = test
      cells[i]:SetData(data, props)
    end
  end
end
function ProfessionPageBasePart:UpdatePolygon(classid)
  local thisIdClass = Table_Class[classid]
  local isHero = ProfessionProxy.IsHero(classid)
  if thisIdClass.MaxJobLevel then
    self.attrRoot:SetActive(true)
    for i = 1, #GameConfig.ClassInitialAttr do
      local single = GameConfig.ClassInitialAttr[i]
      local prop = Game.Myself.data.props:GetPropByName(single)
      local value = 0
      if isHero then
        value = CommonFun.calHeroAttrPoint(thisIdClass.MaxJobLevel, thisIdClass.TypeBranch, single)
      else
        value = CommonFun.calProfessionPropValue(thisIdClass.MaxJobLevel, thisIdClass.TypeBranch, single) or 0
      end
      self:SetPolyonValue(i, value, true)
    end
    self.maxJobTip:SetActive(true)
  else
    self.attrRoot:SetActive(false)
    self.maxJobTip:SetActive(false)
  end
end
function ProfessionPageBasePart:SetPolyonValue(index, value, showPlus)
  local showLength = self:getWeightByValue(value)
  self.polygon:SetLength(index - 1, showLength * 93)
  self.polygonDots[index].localPosition = _GetTempVector3(showLength * 93, 0, 0)
  local extendStr = showPlus and "+" or ""
  self.polyValues[index].text = extendStr .. math.floor(value)
end
function ProfessionPageBasePart:SetAttrRootActive(bool)
  self.attrRoot:SetActive(bool)
end
function ProfessionPageBasePart:SetMaxJobTipActive(bool)
  self.maxJobTip:SetActive(bool)
end
function ProfessionPageBasePart:getWeightByValue(value)
  local A = 0
  if value >= 200 then
    A = 100
  elseif value >= 100 then
    A = 75 + (value - 100) / 100 * 25
  elseif value >= 40 then
    A = 50 + (value - 40) / 60 * 25
  elseif value >= 10 then
    A = 25 + (value - 10) / 30 * 25
  else
    A = 10 + (value - 1) * 15 / 9
  end
  return A / 100
end
function ProfessionPageBasePart:UpdateClassBranchByBranchType(typeBranch, showAdvance, showLevel, jobLevel)
  local S_data = ProfessionProxy.Instance:GetProfessionQueryUserTable()
  local professionData = S_data[typeBranch]
  local professionList = ProfessionProxy.Instance:GetMultiProfessionList()
  local classConfig
  local isBuy = false
  local isMPOpen = ProfessionProxy.Instance:IsMPOpen()
  if professionData then
    classConfig = Table_Class[professionData.profession]
    xdlog("????????????", professionData.profession)
    if professionData.profession == ProfessionProxy.doramNovice then
      typeBranch = Table_Class[ProfessionProxy.doramTypical1st].TypeBranch
    end
    isBuy = true
  else
    local baseid = professionList[typeBranch] and professionList[typeBranch].baseid
    baseid = baseid or Table_Branch[typeBranch].base_id
    classConfig = baseid and Table_Class[baseid]
  end
  if classConfig then
    IconManager:SetNewProfessionIcon(classConfig.icon, self.curClassIcon)
    IconManager:SetNewProfessionIcon(classConfig.icon, self.curClassCheckMark_Icon)
    self.curClassName.text = classConfig.NameZh
  end
  if showLevel then
    self.curClassLevel.text = "Job." .. jobLevel
    self.curClassName.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(44, 11.52, 0)
  else
    self.curClassLevel.text = ""
    self.curClassName.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(44, 0, 0)
  end
  if showAdvance then
    local advClass = {}
    if isBuy then
      local advanceClass = classConfig.AdvanceClass
      for i = 1, #advanceClass do
        if ProfessionProxy.GetTypeBranchFromProf(advanceClass[i]) == typeBranch then
          table.insert(advClass, advanceClass[i])
        end
      end
    else
      local branchInfo = Table_Branch[typeBranch]
      if branchInfo then
        local proList = string.split(branchInfo.profession_list, ",")
        local targetClass = proList and tonumber(proList[1])
        table.insert(advClass, targetClass)
      end
    end
    for i = 1, 2 do
      if advClass[i] then
        self["line" .. i]:SetActive(true)
        self.advancedJob[i].go:SetActive(true)
        local targetClass = advClass[i]
        local targetConfig = Table_Class[targetClass]
        if targetConfig then
          self.advancedJob[i].targetJob = targetClass
          self.advancedJob[i].jobName.text = targetConfig.NameZh
          IconManager:SetNewProfessionIcon(targetConfig.icon, self.advancedJob[i].jobIcon)
          IconManager:SetNewProfessionIcon(targetConfig.icon, self.advancedJob[i].checkMark_Icon)
        end
      else
        self["line" .. i]:SetActive(false)
        self.advancedJob[i].go:SetActive(false)
      end
    end
  else
    self.line1:SetActive(false)
    self.line2:SetActive(false)
    for i = 1, 2 do
      self.advancedJob[i].go:SetActive(false)
    end
  end
end
function ProfessionPageBasePart:GetAdvClassList()
  local result = {}
  for i = 1, 2 do
    if self.advancedJob[i].go.activeSelf then
      table.insert(result, self.advancedJob[i].targetJob)
    end
  end
  return result
end
function ProfessionPageBasePart:UpdateCurClassBranch(classid, showAdvance, showLevel, jobLevel)
  local thisIdClass = Table_Class[classid]
  if thisIdClass then
    IconManager:SetNewProfessionIcon(thisIdClass.icon, self.curClassIcon)
    IconManager:SetNewProfessionIcon(thisIdClass.icon, self.curClassCheckMark_Icon)
    self.curClassName.text = thisIdClass.NameZh
  end
  if showLevel then
    self.curClassLevel.text = "Job." .. jobLevel
    self.curClassName.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(44, 11.52, 0)
  else
    self.curClassLevel.text = ""
    self.curClassName.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(44, 0, 0)
  end
  if showAdvance then
    local state = ProfessionProxy.Instance:GetClassState(classid)
    if thisIdClass.AdvanceClass and state ~= 7 then
      for i = 1, 2 do
        if thisIdClass.AdvanceClass[i] then
          self["line" .. i]:SetActive(true)
          self.advancedJob[i].go:SetActive(true)
          local targetClass = thisIdClass.AdvanceClass[i]
          local targetConfig = Table_Class[targetClass]
          if targetConfig then
            self.advancedJob[i].targetJob = targetClass
            self.advancedJob[i].jobName.text = targetConfig.NameZh
            IconManager:SetNewProfessionIcon(targetConfig.icon, self.advancedJob[i].jobIcon)
            IconManager:SetNewProfessionIcon(targetConfig.icon, self.advancedJob[i].checkMark_Icon)
          end
        else
          self["line" .. i]:SetActive(false)
          self.advancedJob[i].go:SetActive(false)
        end
      end
    else
      self.line1:SetActive(false)
      self.line2:SetActive(false)
      for i = 1, 2 do
        self.advancedJob[i].go:SetActive(false)
      end
    end
  else
    self.line1:SetActive(false)
    self.line2:SetActive(false)
    for i = 1, 2 do
      self.advancedJob[i].go:SetActive(false)
    end
  end
end
function ProfessionPageBasePart:UpdateEquip(data)
  if data == nil then
    self.equipPart:SetActive(false)
    return
  end
  if data.showType == MPShowType.FromSave then
    self:UpdateViewInfo_byUserSaveInfoData(data.userSaveInfoData)
  elseif data.showType == MPShowType.FromSelf then
    self:UpdateViewInfo_byMyself()
  elseif data.showType == MPShowType.FromPurchasePreview then
    local myself = Game.Myself
  end
end
function ProfessionPageBasePart:ShowEquip(bool)
  self.equipPart:SetActive(bool)
  if bool then
    self.equipGrid:Reposition()
  end
end
function ProfessionPageBasePart:UpdateViewInfo_byUserSaveInfoData(dataInfo)
  local saveEquips = dataInfo:GetRoleEquipsSaveDatas() or {}
  local roleEquipsMap = self:TransRoleEquipData_ByEquipsInfoSaveDatas(saveEquips)
  self:UpdatePlayerRoleEquips(roleEquipsMap)
end
function ProfessionPageBasePart:UpdateViewInfo_byMyself()
  local myself = Game.Myself
  self:UpdatePlayerRoleEquips(BagProxy.Instance.roleEquip.siteMap)
end
local SearChBagTypes = {
  1,
  2,
  4,
  6,
  7,
  9
}
function ProfessionPageBasePart:TransRoleEquipData_ByEquipsInfoSaveDatas(saveEquipDatas)
  if self.roleEquipsMap == nil then
    self.roleEquipsMap = {}
  else
    TableUtility.TableClear(self.roleEquipsMap)
  end
  local _BagProxy = BagProxy.Instance
  for k, v in pairs(saveEquipDatas) do
    local itemData = _BagProxy:GetItemByGuid(v.guid, SearChBagTypes)
    if itemData == nil then
      itemData = ItemData.new(RoleEquipItemCell.FakeID, v.type_id)
    end
    self.roleEquipsMap[v.pos] = itemData
  end
  return self.roleEquipsMap
end
function ProfessionPageBasePart:UpdatePlayerRoleEquips(roleEquipsMap)
  if roleEquipsMap == nil then
    return
  end
  for pos, equipCell in pairs(self.equipList) do
    equipCell:SetData(roleEquipsMap[pos])
  end
end
function ProfessionPageBasePart:ClickEquip(cellCtl)
  if cellCtl ~= nil and self.chooseEquip ~= cellCtl then
    local data = cellCtl.data
    if data and data.id == RoleEquipItemCell.FakeID then
      return
    end
    if data then
      local offsetX
      if cellCtl.index <= 6 or cellCtl.index == 13 then
        offsetX = 190
      elseif cellCtl.index > 6 then
        offsetX = -190
      end
      self:ShowPlayerEquipTip(data, cellCtl.gameObject, {offsetX, 0})
      self.chooseSymbol.transform:SetParent(cellCtl.gameObject.transform, false)
      self.chooseSymbol.transform.localPosition = LuaGeometry.Const_V3_zero
      self.chooseSymbol:SetActive(true)
    else
      self:CancelChoose()
      self:ShowItemTip()
    end
    self.chooseEquip = cellCtl
  else
    self:CancelChoose()
    self:ShowItemTip()
  end
end
function ProfessionPageBasePart:CancelChoose()
  self.chooseEquip = nil
  self.chooseSymbol.transform:SetParent(self.trans, false)
  self.chooseSymbol:SetActive(false)
end
local tipOffset = {0, 0}
function ProfessionPageBasePart:ShowPlayerEquipTip(data, ignoreBound, offset, isClickMyself)
  local callback = function()
    self:CancelChoose()
  end
  local sdata = {
    itemdata = data,
    ignoreBounds = {ignoreBound},
    callback = callback
  }
  local itemtip = self:ShowItemTip(sdata, self.tipContainer, NGUIUtil.AnchorSide.Left, offset)
  local compareData
  if isClickMyself then
    compareData = self.playerEquipDatas[data.index]
  else
    compareData = BagProxy.Instance.roleEquip:GetEquipBySite(data.index)
  end
  if itemtip then
    if compareData then
      local cell = itemtip:GetCell(1)
      if cell then
        local compareFunc = function(data)
          self:CancelChoose()
          local sdata = {}
          if isClickMyself then
            sdata.itemdata = compareData
            sdata.compdata1 = data
          else
            sdata.itemdata = data
            sdata.compdata1 = compareData
          end
          self:ShowItemTip(sdata, self.tipContainer, nil, tipOffset)
        end
        cell:AddTipFunc(ZhString.PlayerDetailView_CompareTip, compareFunc, data, true)
      end
    end
    itemtip:HideEquipedSymbol()
  end
end
function ProfessionPageBasePart:UpdateClassProcess(list)
  if not list then
    for i = 1, #self.classProcessCells do
      self.classProcessCells[i].go:SetActive(false)
    end
    return
  end
  for i = 1, #self.classProcessCells do
    if list[i] then
      self.classProcessCells[i].go:SetActive(true)
      local curValue = list[i].curValue
      local maxValue = list[i].maxValue
      local process = maxValue and curValue .. "/" .. maxValue or curValue .. "%"
      self.classProcessCells[i].ProcessLabel.text = process
      self.classProcessCells[i].clickFunc = list[i].clickFunc
      self.classProcessCells[i].funcParams = list[i].funcParams
    else
      self.classProcessCells[i].go:SetActive(false)
    end
  end
  self.classProcessGrid:Reposition()
end
function ProfessionPageBasePart:SetSwitchNodeActive(active)
  self.switchNodePart:SetActive(active)
end
function ProfessionPageBasePart:OnExit()
  ProfessionPageBasePart.super.OnExit(self)
  _PictureManager:UnLoadUI("login_new_bg_data", self.attrTexture)
  self:ShowItemTip(nil)
end
function ProfessionPageBasePart:OnEnter()
  ProfessionPageBasePart.super.OnExit(self)
  _PictureManager:SetUI("login_new_bg_data", self.attrTexture)
end
