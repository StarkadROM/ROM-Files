ReturnActivityShopPage = class("ReturnActivityShopPage", SubView)
ReturnActivityShopPage.ViewType = UIViewType.NormalLayer
autoImport("RewardGridCell")
autoImport("ReturnActivityShopCell")
autoImport("HappyShopBuyItemCell")
local viewPath = ResourcePathHelper.UIView("ReturnActivityShopPage")
local picIns = PictureManager.Instance
local tempVector3 = LuaVector3.Zero()
function ReturnActivityShopPage:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddMapEvts()
  self:InitDatas()
end
function ReturnActivityShopPage:LoadSubView()
  local obj = self:LoadPreferb_ByFullPath(viewPath, self.container.shopPageObj, true)
  obj.name = "ReturnActivityShopPage"
end
function ReturnActivityShopPage:FindObjs()
  self:LoadSubView()
  self.gameObject = self:FindGO("ReturnActivityShopPage")
  self.shopScrollView = self:FindGO("GoodsScrollView", self.gameObject):GetComponent(UIScrollView)
  self.shopGrid = self:FindGO("Grid", self.gameObject):GetComponent(UIGrid)
  self.shopCtrl = UIGridListCtrl.new(self.shopGrid, ReturnActivityShopCell, "ReturnActivityShopCell")
  self.shopCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
  function self.shopScrollView.onDragStarted()
    self.selectGo = nil
    self.buyCell.gameObject:SetActive(false)
    TipsView.Me():HideCurrent()
  end
  self.uiCamera = NGUIUtil:GetCameraByLayername("UI")
  self:InitBuyItemCell()
end
function ReturnActivityShopPage:AddEvts()
end
function ReturnActivityShopPage:AddMapEvts()
  self:AddListenEvt(ServiceEvent.SessionShopBuyShopItem, self.RecvQueryShopConfig)
  self:AddListenEvt(ServiceEvent.SessionShopShopDataUpdateCmd, self.RecvQueryShopConfig)
  self:AddListenEvt(ServiceEvent.SessionShopUpdateShopConfigCmd, self.RecvQueryShopConfig)
  self:AddListenEvt(ServiceEvent.SessionShopQueryShopConfigCmd, self.RecvQueryShopConfig)
  self:AddListenEvt(ServiceEvent.NUserVarUpdate, self.UpdateMoney)
end
function ReturnActivityShopPage:InitDatas()
  self.tipData = {}
  self.tipData.funcConfig = {}
  local globalActID = ReturnActivityProxy.Instance.curActID
  self.config = globalActID and GameConfig.Return.Feature[globalActID]
  self.shopType = ReturnActivityProxy.Instance.shopType
end
function ReturnActivityShopPage:InitShow()
end
function ReturnActivityShopPage:LoadCellPfb(cName)
  local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(cName))
  if cellpfb == nil then
    error("can not find cellpfb" .. cName)
  end
  cellpfb.transform:SetParent(self.gameObject.transform, false)
  return cellpfb
end
function ReturnActivityShopPage:InitBuyItemCell()
  local go = self:LoadCellPfb("HappyShopBuyItemCell")
  self.buyCell = HappyShopBuyItemCell.new(go)
  self.buyCell:AddCloseWhenClickOtherPlaceCallBack(self)
  self.buyCell.gameObject:SetActive(false)
end
function ReturnActivityShopPage:RecvQueryShopConfig(note)
  self:UpdateShopInfo()
end
function ReturnActivityShopPage:UpdateShopInfo()
  local shopData = ShopProxy.Instance:GetShopDataByTypeId(self.shopType, 1)
  if not self.shopItems then
    self.shopItems = {}
  else
    TableUtility.ArrayClear(self.shopItems)
  end
  if shopData then
    local config = shopData:GetGoods()
    for k, v in pairs(config) do
      TableUtility.ArrayPushBack(self.shopItems, k)
    end
  end
  table.sort(self.shopItems, ReturnActivityShopPage._SortItem)
  self.shopCtrl:ResetDatas(self.shopItems)
end
function ReturnActivityShopPage._SortItem(l, r)
  local _HappyShopProxy = HappyShopProxy.Instance
  local ldata = _HappyShopProxy:GetShopItemDataByTypeId(l)
  local rdata = _HappyShopProxy:GetShopItemDataByTypeId(r)
  local lCanByCount = _HappyShopProxy:GetCanBuyCount(ldata) or 999
  local rCanByCount = _HappyShopProxy:GetCanBuyCount(rdata) or 999
  if ldata.CanOpen ~= rdata.CanOpen then
    return not ldata:GetLock()
  elseif lCanByCount and rCanByCount then
    if lCanByCount > 0 and rCanByCount > 0 then
      if ldata.ShopOrder == rdata.ShopOrder then
        return ldata.id < rdata.id
      else
        return ldata.ShopOrder < rdata.ShopOrder
      end
    else
      return lCanByCount > rCanByCount
    end
  end
end
function ReturnActivityShopPage:UpdateMoney()
  local costID = self.config.ShopItemID
end
function ReturnActivityShopPage:UpdateBuyItemInfo(data)
  if data then
    local itemType = data.itemtype
    if itemType and itemType ~= 2 then
      local positionX, positionY = self:GetScreenTouchedPos()
      if positionX > 0 then
        self.buyCell.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(-217, 0, 0)
      elseif positionX < 0 then
        self.buyCell.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(300, 0, 0)
      end
      self.buyCell:SetData(data)
      TipsView.Me():HideCurrent()
    else
      self.buyCell.gameObject:SetActive(false)
    end
  end
end
function ReturnActivityShopPage:HandleClickItem(cellctl)
  xdlog("点选商品", cellctl.data)
  if self.currentItem ~= cellctl then
    if self.currentItem then
    end
    self.currentItem = cellctl
  end
  local id = cellctl.data
  local data = ShopProxy.Instance:GetShopItemDataByTypeId(self.shopType, self.config.ShopID, id)
  local go = cellctl.gameObject
  if self.selectGo == go then
    self.selectGo = nil
    return
  end
  self.selectGo = go
  if data then
    if data:GetLock() then
      FunctionUnLockFunc.Me():CheckCanOpen(data.MenuID, true)
      self.buyCell.gameObject:SetActive(false)
      return
    end
    local _HappyShopProxy = HappyShopProxy
    local config = Table_NpcFunction[_HappyShopProxy.Instance:GetShopType()]
    if config ~= nil and config.Parama.Source == _HappyShopProxy.SourceType.Guild and not GuildProxy.Instance:CanIDoAuthority(GuildAuthorityMap.Shop) then
      MsgManager.ShowMsgByID(3808)
      self.buyCell.gameObject:SetActive(false)
      return
    end
    if HappyShopProxy.Instance:isGuildMaterialType() then
      local npcdata = HappyShopProxy.Instance:GetNPC()
      if npcdata then
        self:CameraReset()
        self:CameraFocusAndRotateTo(npcdata.assetRole.completeTransform, CameraConfig.GuildMaterial_Choose_ViewPort, CameraConfig.GuildMaterial_Choose_Rotation)
      end
    end
    HappyShopProxy.Instance:SetSelectId(id)
    self:UpdateBuyItemInfo(data)
  end
end
function ReturnActivityShopPage:GetScreenTouchedPos()
  local positionX, positionY, positionZ = LuaGameObject.GetMousePosition()
  LuaVector3.Better_Set(tempVector3, positionX, positionY, positionZ)
  if not UIUtil.IsScreenPosValid(positionX, positionY) then
    LogUtility.Error(string.format("HarpView MousePosition is Invalid! x: %s, y: %s", positionX, positionY))
    return 0, 0
  end
  positionX, positionY, positionZ = LuaGameObject.ScreenToWorldPointByVector3(self.uiCamera, tempVector3)
  LuaVector3.Better_Set(tempVector3, positionX, positionY, positionZ)
  positionX, positionY, positionZ = LuaGameObject.InverseTransformPointByVector3(self.gameObject.transform, tempVector3)
  return positionX, positionY
end
function ReturnActivityShopPage:OnEnter()
  ReturnActivityShopPage.super.OnEnter(self)
  ServiceSessionShopProxy.Instance:CallQueryShopConfigCmd(self.shopType, self.config.ShopID)
  HappyShopProxy.Instance:InitShop(nil, self.config.ShopID, self.shopType)
end
