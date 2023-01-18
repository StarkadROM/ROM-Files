autoImport("SkadaRaceCell")
autoImport("SkadaSettingToggleCell")
SkadaSettingView = class("SkadaSettingView", BaseView)
SkadaSettingView.ViewType = UIViewType.NormalLayer
local OperSourceID = {
  Race = 1,
  Shape = 2,
  Nature = 3,
  HpReduce = 4,
  BossType = 5
}
function SkadaSettingView:Init()
  self:FindObjs()
  self:AddButtonEvt()
  self:AddViewEvt()
end
function SkadaSettingView:FindObjs()
  local l_objSettings = self:FindGO("containerSettings")
  self.tableSettings = l_objSettings:GetComponent(UITable)
  self.listRace = UIGridListCtrl.new(self:FindComponent("gridRace", UIGrid, l_objSettings), SkadaRaceCell, "SkadaRaceCell")
  self.listShape = UIGridListCtrl.new(self:FindComponent("gridShape", UIGrid, l_objSettings), SkadaSettingToggleCell, "SkadaSettingToggleCell")
  self.listNature = UIGridListCtrl.new(self:FindComponent("gridNature", UIGrid, l_objSettings), SkadaSettingToggleCell, "SkadaSettingToggleCell")
  self.listType = UIGridListCtrl.new(self:FindComponent("gridType", UIGrid, l_objSettings), SkadaSettingToggleCell, "SkadaSettingToggleCell")
  self.objPowerAdjust = self:FindGO("PowerAdjust", l_objSettings)
  self.labPower = self:FindComponent("labPower", UILabel, self.objPowerAdjust)
  self.objEmptyList = self:FindGO("NoneTip", l_objSettings)
  local bosstypeObj = self:FindGO("BossType", l_objSettings)
  if bosstypeObj then
    bosstypeObj:SetActive(true)
  end
  local line4Obj = self:FindGO("Line4", l_objSettings)
  if line4Obj then
    line4Obj:SetActive(true)
  end
end
function SkadaSettingView:AddButtonEvt()
  self:AddClickEvent(self:FindGO("BtnHelp"), function()
    self:ClickBtnHelp()
  end)
  self:AddClickEvent(self:FindGO("CloseButton"), function()
    self:CloseSelf()
  end)
  self:AddClickEvent(self:FindGO("BtnSave"), function()
    self:ClickBtnSave()
  end)
  self:AddClickEvent(self:FindGO("btnPowerDown", self.objPowerAdjust), function()
    self:SetPower(self.curPower - 1)
  end)
  self:AddClickEvent(self:FindGO("btnPowerUp", self.objPowerAdjust), function()
    self:SetPower(self.curPower + 1)
  end)
end
function SkadaSettingView:AddViewEvt()
  self.listRace:AddEventListener(MouseEvent.MouseClick, self.ClickRace, self)
  self.listShape:AddEventListener(MouseEvent.MouseClick, self.ClickShape, self)
  self.listNature:AddEventListener(MouseEvent.MouseClick, self.ClickNature, self)
  self.listType:AddEventListener(MouseEvent.MouseClick, self.ClickType, self)
end
function SkadaSettingView:InitSettings()
  self:DeleteSettings()
  local nameConfig = GameConfig.MonsterAttr
  local singleTable
  self.raceDatas = ReusableTable.CreateArray()
  for nameEn, id in pairs(CommonFun.Race) do
    singleTable = ReusableTable.CreateTable()
    singleTable.id = id
    singleTable.NameEn = nameEn
    singleTable.NameZh = nameConfig.Race[nameEn]
    self.raceDatas[#self.raceDatas + 1] = singleTable
  end
  table.sort(self.raceDatas, function(a, b)
    return a.id < b.id
  end)
  self.listRace:ResetDatas(self.raceDatas)
  self.natureDatas = ReusableTable.CreateArray()
  for nameEn, id in pairs(CommonFun.Nature) do
    singleTable = ReusableTable.CreateTable()
    singleTable.id = id
    singleTable.NameEn = nameEn
    singleTable.NameZh = nameConfig.Nature[nameEn]
    self.natureDatas[#self.natureDatas + 1] = singleTable
  end
  table.sort(self.natureDatas, function(a, b)
    return a.id < b.id
  end)
  self.listNature:ResetDatas(self.natureDatas)
  self.shapeDatas = ReusableTable.CreateArray()
  for nameEn, id in pairs(CommonFun.Shape) do
    singleTable = ReusableTable.CreateTable()
    for index, shapeID in pairs(CreatureData.ShapeIndex) do
      if shapeID == id then
        singleTable.id = index
        break
      end
    end
    singleTable.NameEn = nameEn
    singleTable.NameZh = nameConfig.Body[nameEn]
    self.shapeDatas[#self.shapeDatas + 1] = singleTable
  end
  table.sort(self.shapeDatas, function(a, b)
    return a.id < b.id
  end)
  self.listShape:ResetDatas(self.shapeDatas)
  self.typeDatas = ReusableTable.CreateArray()
  for nameEn, id in pairs(CommonFun.BossType) do
    singleTable = ReusableTable.CreateTable()
    singleTable.id = id
    singleTable.NameEn = nameEn
    singleTable.NameZh = nameConfig.BossType[nameEn]
    self.typeDatas[#self.typeDatas + 1] = singleTable
  end
  table.sort(self.typeDatas, function(a, b)
    return a.id < b.id
  end)
  self.listType:ResetDatas(self.typeDatas)
end
function SkadaSettingView:DeleteSettings()
  if self.raceDatas then
    for i = 1, #self.raceDatas do
      ReusableTable.DestroyAndClearTable(self.raceDatas[i])
    end
    ReusableTable.DestroyAndClearArray(self.raceDatas)
    self.raceDatas = nil
  end
  if self.natureDatas then
    for i = 1, #self.natureDatas do
      ReusableTable.DestroyAndClearTable(self.natureDatas[i])
    end
    ReusableTable.DestroyAndClearArray(self.natureDatas)
    self.natureDatas = nil
  end
  if self.shapeDatas then
    for i = 1, #self.shapeDatas do
      ReusableTable.DestroyAndClearTable(self.shapeDatas[i])
    end
    ReusableTable.DestroyAndClearArray(self.shapeDatas)
    self.shapeDatas = nil
  end
  if self.typeDatas then
    for i = 1, #self.typeDatas do
      ReusableTable.DestroyAndClearTable(self.typeDatas[i])
    end
    ReusableTable.DestroyAndClearArray(self.typeDatas)
    self.typeDatas = nil
  end
end
function SkadaSettingView:LoadCurSettings()
  local furnitureData = HomeProxy.Instance:FindFurnitureData(self.myFurnitureID)
  local curSettingID = furnitureData and furnitureData.woodRace
  local cells = self.listRace:GetCells()
  if curSettingID then
    for i = 1, #cells do
      if cells[i].id == curSettingID then
        self:ClickRace(cells[i])
        break
      end
    end
  end
  curSettingID = furnitureData and furnitureData.woodNature
  cells = self.listNature:GetCells()
  if curSettingID then
    for i = 1, #cells do
      if cells[i].id == curSettingID then
        self:ClickNature(cells[i])
        break
      end
    end
  end
  curSettingID = furnitureData and furnitureData.woodShape
  cells = self.listShape:GetCells()
  if curSettingID then
    for i = 1, #cells do
      if cells[i].id == curSettingID then
        self:ClickShape(cells[i])
        break
      end
    end
  end
  curSettingID = furnitureData and furnitureData.woodBossType or 0
  cells = self.listType:GetCells()
  if curSettingID then
    for i = 1, #cells do
      if cells[i].id == curSettingID then
        self:ClickType(cells[i])
        break
      end
    end
  end
  self:SetPower(furnitureData and furnitureData.woodDamageReduce or 1)
end
function SkadaSettingView:ClickBtnHelp()
  local helpData = Table_Help[PanelConfig.SkadaSettingView.id]
  local desc = helpData and helpData.Desc
  if desc then
    TipsView.Me():ShowGeneralHelp(desc)
  end
end
function SkadaSettingView:ClickRace(cellCtl)
  if self.curRaceCell then
    self.curRaceCell:SetIsSelect(false)
  end
  self.curRaceCell = cellCtl
  self.curRaceCell:SetIsSelect(true)
end
function SkadaSettingView:ClickShape(cellCtl)
  if self.curShapeCell then
    self.curShapeCell:SetIsSelect(false)
  end
  self.curShapeCell = cellCtl
  self.curShapeCell:SetIsSelect(true)
end
function SkadaSettingView:ClickNature(cellCtl)
  if self.curNatureCell then
    self.curNatureCell:SetIsSelect(false)
  end
  self.curNatureCell = cellCtl
  self.curNatureCell:SetIsSelect(true)
end
function SkadaSettingView:ClickType(cellCtl)
  if self.curTypeCell then
    self.curTypeCell:SetIsSelect(false)
  end
  self.curTypeCell = cellCtl
  self.curTypeCell:SetIsSelect(true)
end
function SkadaSettingView:SetPower(configIndex)
  local powerConfig = GameConfig.Home and GameConfig.Home.npc_set_reduce
  if not powerConfig then
    LogUtility.Error("没有找到配置GameConfig.Home.npc_set_reduce！")
    return
  end
  configIndex = math.clamp(configIndex, 1, #powerConfig)
  if configIndex == self.curPower then
    return
  end
  self.curPower = configIndex
  self.labPower.text = powerConfig[configIndex].value .. "%"
end
function SkadaSettingView:ClickBtnSave()
  local furnitureData = HomeProxy.Instance:FindFurnitureData(self.myFurnitureID)
  local newSetting = self.curRaceCell and self.curRaceCell.id
  local oldSetting = furnitureData and furnitureData.woodRace
  if newSetting and newSetting ~= oldSetting then
    ServiceHomeCmdProxy.Instance:CallFurnitureOperHomeCmd(HomeProxy.Oper.WoodSet, self.myFurnitureID, newSetting, OperSourceID.Race)
  end
  newSetting = self.curNatureCell and self.curNatureCell.id
  oldSetting = furnitureData and furnitureData.woodNature
  if newSetting and newSetting ~= oldSetting then
    ServiceHomeCmdProxy.Instance:CallFurnitureOperHomeCmd(HomeProxy.Oper.WoodSet, self.myFurnitureID, newSetting, OperSourceID.Nature)
  end
  newSetting = self.curShapeCell and self.curShapeCell.id
  oldSetting = furnitureData and furnitureData.woodShape
  if newSetting and newSetting ~= oldSetting then
    ServiceHomeCmdProxy.Instance:CallFurnitureOperHomeCmd(HomeProxy.Oper.WoodSet, self.myFurnitureID, newSetting, OperSourceID.Shape)
  end
  newSetting = self.curPower
  oldSetting = furnitureData and furnitureData.woodDamageReduce
  if newSetting and newSetting ~= oldSetting then
    ServiceHomeCmdProxy.Instance:CallFurnitureOperHomeCmd(HomeProxy.Oper.WoodSet, self.myFurnitureID, newSetting, OperSourceID.HpReduce)
  end
  newSetting = self.curTypeCell and self.curTypeCell.id
  oldSetting = furnitureData and furnitureData.woodBossType
  if newSetting and newSetting ~= oldSetting then
    ServiceHomeCmdProxy.Instance:CallFurnitureOperHomeCmd(HomeProxy.Oper.WoodSet, self.myFurnitureID, newSetting, OperSourceID.BossType)
  end
end
function SkadaSettingView:OnEnter()
  SkadaSettingView.super.OnEnter(self)
  self.myNpcID = self.viewdata and self.viewdata.viewdata
  local nCreature = self.myNpcID and NSceneNpcProxy.Instance:Find(self.myNpcID)
  self.myFurnitureID = nCreature and nCreature.data:GetRelativeFurnitureID()
  if not self.myFurnitureID then
    LogUtility.Error(string.format("没有找到npcid: %s的对应家具ID！", tostring(self.myNpcID)))
    self:CloseSelf()
    return
  end
  self:InitSettings()
  self:LoadCurSettings()
end
function SkadaSettingView:OnExit()
  self:DeleteSettings()
  SkadaSettingView.super.OnExit(self)
end
function SkadaSettingView:OnDestroy()
  self.listRace:Destroy()
  self.listNature:Destroy()
  self.listShape:Destroy()
  self.listType:Destroy()
  SkadaSettingView.super.OnDestroy(self)
end
