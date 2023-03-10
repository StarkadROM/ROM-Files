autoImport("BaseCell")
autoImport("MaterialHomeCell")
HomeMakeCell = class("HomeMakeCell", BaseCell)
HomeMakeCell.ClickToItem = "HomeMakeCell_ClickToItem"
HomeMakeCell.ClickMaterial = "HomeMakeCell_ClickMaterial"
HomeMakeCell.GoToMake = "HomeMakeCell_GoToMake"
HomeMakeCell.TraceMaterial = "HomeMakeCell_TraceMaterial"
HomeMakeCell.RTBGName = "home_compose_BG2"
local _tempVec3 = LuaVector3()
function HomeMakeCell:Init()
  self.composeCount = 1
  self.combine_lacMats = {}
  self.cache_sortingOrder = {}
  self:InitView()
end
function HomeMakeCell:InitView()
  self.roblab = self:FindComponent("ROGold", UILabel)
  self.makeTip = self:FindComponent("MakeTip", UILabel)
  self.composeCountLabel = self:FindComponent("CountLabel", UILabel)
  local materialGrid = self:FindComponent("MaterialGrid", UIGrid)
  self.materialCtl = UIGridListCtrl.new(materialGrid, MaterialHomeCell, "MaterialHomeCell")
  self.materialCtl:AddEventListener(MouseEvent.MouseClick, self.ClickMaterial, self)
  self.texFurniture = self:FindComponent("texFurniture", UITexture)
  local effectContainer = self:FindGO("EffectContainer")
  self:LoadPreferb_ByFullPath(ResourcePathHelper.Effect("UI/14itemShine"), effectContainer)
  self.trackButton = self:FindGO("TrackButton")
  if self.trackButton then
    self.trackButton:SetActive(false)
  end
  LuaVector3.Better_Set(_tempVec3, 0, -300, 0)
  self.goMakeButton = self:FindGO("GoMakeButton")
  self.goMakeButton.transform.localPosition = _tempVec3
  self:AddClickEvent(self.goMakeButton, function(go)
    self:PassEvent(HomeMakeCell.GoToMake, self)
  end)
  self.quickBuyButton = self:FindGO("QuickBuyButton")
  self.quickBuyButton.transform.localPosition = _tempVec3
  self:AddClickEvent(self.quickBuyButton, function(go)
    if #self.combine_lacMats > 0 and QuickBuyProxy.Instance:TryOpenView(self.combine_lacMats) then
      return
    end
  end)
  self.makeBtn = self:FindGO("MakeButton")
  self.quickBuyButton.transform.localPosition = _tempVec3
  self:AddClickEvent(self.makeBtn, function(go)
    if #self.combine_lacMats > 0 and QuickBuyProxy.Instance:TryOpenView(self.combine_lacMats) then
      return
    end
    if self.canCompose then
      self:PassEvent(MouseEvent.MouseClick, self)
    else
      MsgManager.ShowMsgByIDTable(8)
    end
  end)
  self.minusBtn = self:FindComponent("MinusBtn", UIButton)
  self.plusBtn = self:FindComponent("PlusBtn", UIButton)
  self:AddClickEvent(self.minusBtn.gameObject, function(go)
    self:ReduceCount()
  end)
  self:AddClickEvent(self.plusBtn.gameObject, function(go)
    self:AddCount()
  end)
end
function HomeMakeCell:AddCount()
  self.composeCount = self.composeCount + 1
  self.data.composeCount = self.composeCount
  if self.data.viewdata and self.data.viewdata.chooseCount then
    self.data.viewdata.chooseCount = self.composeCount
  end
  self:UpdateLacMaterials()
  self.materialCtl:ResetDatas(self.materialsData)
  self:UpdateComposeLabel()
  self:UpdateCountBtns()
  self:UpdateROBLabel()
  self:UpdateButtons()
end
function HomeMakeCell:ReduceCount()
  self.composeCount = self.composeCount - 1
  self.data.composeCount = self.composeCount
  if self.data.viewdata and self.data.viewdata.chooseCount then
    self.data.viewdata.chooseCount = self.composeCount
  end
  self:UpdateLacMaterials()
  self.materialCtl:ResetDatas(self.materialsData)
  self:UpdateComposeLabel()
  self:UpdateCountBtns()
  self:UpdateROBLabel()
  self:UpdateButtons()
end
function HomeMakeCell:UpdateCountBtns()
  if self.composeCount <= 1 then
    self.minusBtn.isEnabled = false
  elseif self.composeCount > 1 then
    self.minusBtn.isEnabled = true
  end
  if self.composeCount < 20 then
    self.plusBtn.isEnabled = true
  else
    self.plusBtn.isEnabled = false
  end
end
function HomeMakeCell:Refresh()
  self:SetData(self.data)
end
function HomeMakeCell:SetData(data)
  local composeID
  if type(data.viewdata) == "number" then
    local itemData = Table_Item[data.viewdata]
    composeID = itemData and itemData.ComposeID
    self.data = {}
    self.data.composeId = composeID
  elseif data.viewdata and data.viewdata.staticData then
    self.data = data
    composeID = self.data.viewdata.staticData.ComposeID
    self.data.composeId = composeID
  end
  if not self.data.composeId then
    return
  else
    composeID = self.data.composeId
  end
  if self.data then
    self.composeCount = self.data.viewdata and self.data.viewdata.chooseCount or math.min(math.max(1, self:GetItemNum(composeID)), 20)
  else
    self.composeCount = math.min(math.max(1, self:GetItemNum(composeID)), 20)
  end
  if not Table_Compose[composeID] then
    return
  end
  self.composeID = composeID
  local cdata = Table_Compose[composeID]
  self.toItem = ItemData.new(0, cdata.Product.id)
  local toSdata = self.toItem.staticData
  self:UpdateFashionModel(self.toItem)
  self.materialsData = {}
  self.canCompose = true
  TableUtility.ArrayClear(self.combine_lacMats)
  local failIndexMap = {}
  if cdata.FailStayItem then
    for i = 1, #cdata.FailStayItem do
      local index = cdata.FailStayItem[i]
      if index then
        failIndexMap[index] = 1
      end
    end
  end
  for i = 1, #cdata.BeCostItem do
    local v = cdata.BeCostItem[i]
    if v and not failIndexMap[i] then
      local tempData = ItemData.new("Material", v.id)
      tempData.num = self:GetItemNum(v.id)
      tempData.neednum = v.num * math.max(1, self.composeCount)
      if tempData.num < tempData.neednum then
        local lackItem = {
          id = v.id,
          count = tempData.neednum - tempData.num
        }
        table.insert(self.combine_lacMats, lackItem)
      end
      if tempData.staticData and tempData.staticData.Type ~= 50 then
        table.insert(self.materialsData, tempData)
      end
    end
  end
  self.paperCount = self:GetItemNum(self.composeID)
  self.data.composeCount = self.composeCount
  self:UpdateComposeLabel()
  for k, v in pairs(self.materialsData) do
    v.composeCount = self.composeCount
  end
  self.materialCtl:ResetDatas(self.materialsData)
  self:UpdateCountBtns()
  self:UpdateROBLabel()
  self:UpdateButtons()
end
function HomeMakeCell:UpdateLacMaterials()
  local cdata = Table_Compose[self.composeID]
  if cdata then
    self.materialsData = {}
    TableUtility.ArrayClear(self.combine_lacMats)
    local failIndexMap = {}
    if cdata.FailStayItem then
      for i = 1, #cdata.FailStayItem do
        local index = cdata.FailStayItem[i]
        if index then
          failIndexMap[index] = 1
        end
      end
    end
    for i = 1, #cdata.BeCostItem do
      local v = cdata.BeCostItem[i]
      if v and not failIndexMap[i] then
        local tempData = ItemData.new("Material", v.id)
        tempData.num = self:GetItemNum(v.id)
        tempData.neednum = v.num * self.composeCount
        if tempData.num < tempData.neednum then
          local lackItem = {
            id = v.id,
            count = tempData.neednum - tempData.num
          }
          table.insert(self.combine_lacMats, lackItem)
        end
        if tempData.staticData.Type ~= 50 then
          table.insert(self.materialsData, tempData)
        end
      end
    end
  end
  for k, v in pairs(self.materialsData) do
    v.composeCount = self.composeCount
  end
  self.data.composeCount = self.composeCount
end
function HomeMakeCell:UpdateROBLabel()
  local cdata = Table_Compose[self.composeID]
  if cdata and self.composeCount then
    local rob = cdata.ROB * self.composeCount
    if rob > 0 then
      self.roblab.gameObject:SetActive(true)
      if rob > MyselfProxy.Instance:GetROB() then
        self.lackMoney = true
        self.roblab.text = CustomStrColor.BanRed .. tostring(rob) .. "[-]"
      else
        self.lackMoney = false
        self.roblab.text = tostring(rob)
      end
    else
      self.roblab.gameObject:SetActive(false)
    end
  end
end
function HomeMakeCell:UpdateComposeLabel()
  self.composeCountLabel.text = self.composeCount or 1
end
local DEFAULT_MATERIAL_SEARCH_BAGTYPES, PRODUCE_MATERIAL_SEARCH_BAGTYPES
local pacakgeCheck = GameConfig.PackageMaterialCheck
DEFAULT_MATERIAL_SEARCH_BAGTYPES = pacakgeCheck and pacakgeCheck.default or {1, 9}
PRODUCE_MATERIAL_SEARCH_BAGTYPES = pacakgeCheck and pacakgeCheck.produce or DEFAULT_MATERIAL_SEARCH_BAGTYPES
function HomeMakeCell:GetItemNum(itemid)
  local items = BagProxy.Instance:GetMaterialItems_ByItemId(itemid, PRODUCE_MATERIAL_SEARCH_BAGTYPES)
  local searchNum = 0
  if items then
    for i = 1, #items do
      searchNum = searchNum + items[i].num
    end
  end
  return searchNum
end
function HomeMakeCell:UpdateFashionModel(fashionData)
  local staticData = self.data.staticData
  if self.modelTimer then
    TimeTickManager.Me():ClearTick(self)
  end
  local composeID
  if staticData then
    composeID = staticData.ComposeID
  else
    composeID = self.composeID
  end
  local composeInfo = Table_Compose[composeID]
  if not composeInfo then
    return
  end
  local furnitureId = composeInfo.Product.id
  if Table_HomeFurniture[furnitureId] then
    UIModelUtil.Instance:SetFurnitureModelTexture(self.texFurniture, furnitureId, UIModelCameraTrans.FurnitureMake, function(obj)
      self:UpdateFashionModelCallBack(obj, false)
    end)
  elseif Table_HomeFurnitureMaterial[furnitureId] then
    UIModelUtil.Instance:SetHomeMaterialModelTexture(self.texFurniture, furnitureId, UIModelCameraTrans.FurnitureMake, function(obj)
      self:UpdateFashionModelCallBack(obj, true)
    end)
  else
    redlog("nothing can show :" .. furnitureId)
  end
end
function HomeMakeCell:UpdateFashionModelCallBack(obj, isHomeMat)
  self.furnitureModel = obj
  UIModelUtil.Instance:ChangeBGMeshRenderer(HomeMakeCell.RTBGName, self.texFurniture)
  if self.furnitureModel then
    self.modelTimer = TimeTickManager.Me():CreateTick(0, 17, function()
      if LuaGameObject.ObjectIsNull(self.furnitureModel.gameObject) then
        return
      end
      if not isHomeMat then
        self.furnitureModel:RotateDelta(-1)
      else
        LuaGameObject.LocalRotateDeltaByAxisY(self.furnitureModel.transform, -1)
      end
    end, self)
  end
end
function HomeMakeCell:ActiveGoMakeButton(b)
  self.gotoMake_active = b
  self:UpdateButtons()
end
function HomeMakeCell:UpdateButtons()
  local canMake = #self.combine_lacMats <= 0
  self.data.lackMoney = self.lackMoney
  self.quickBuyButton:SetActive(not canMake)
  self.makeTip.gameObject:SetActive(not canMake)
  if canMake then
    self.makeBtn:SetActive(self.gotoMake_active ~= true)
    self.goMakeButton:SetActive(self.gotoMake_active == true)
  else
    self.makeBtn:SetActive(false)
    self.goMakeButton:SetActive(false)
  end
  if self.composeCount == 0 then
    self.goMakeButton:SetActive(false)
  end
end
function HomeMakeCell:ClickMaterial(cellctl)
  self:PassEvent(HomeMakeCell.ClickMaterial, cellctl)
end
function HomeMakeCell:RemoveModel()
  if self.furnitureModel then
    UIModelUtil.Instance:ResetTexture(self.furnitureModel)
  end
  if self.modelTimer then
    TimeTickManager.Me():ClearTick(self)
    self.modelTimer = nil
  end
end
function HomeMakeCell:OnRemove()
  self:RemoveModel()
end
