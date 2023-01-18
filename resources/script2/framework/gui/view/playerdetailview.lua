PlayerDetailView = class("PlayerDetailView", ContainerView)
PlayerDetailView.ViewType = UIViewType.CheckLayer
autoImport("SimplePlayer")
autoImport("MyselfEquipItemCell")
autoImport("PlayerAttriButeView")
autoImport("PackageEquipPage")
autoImport("GemSkillProfitCell")
autoImport("GemAttributeProfitCell")
autoImport("GemPageData")
PlayerDetailView.State = {
  None = "PlayerDetailView_State_None",
  Equip = "PlayerDetailView_State_Equip",
  Attri = "PlayerDetailView_State_Attri",
  Fashion = "PlayerDetailView_State_Fashion",
  Gem = "PlayerDetailView_State_Gem"
}
PlayerDetailView.TabName = {
  EquipTab = ZhString.PlayerDetailView_EquipTabName,
  AttriTab = ZhString.PlayerDetailView_AttriTabName,
  FashionTab = ZhString.PlayerDetailView_FashionTabName,
  GemTab = ZhString.PlayerDetailView_GemTabName
}
function PlayerDetailView:Init()
  self:InitUI()
  self:AddListenEvt(ServiceEvent.ChatCmdQueryUserGemChatCmd, self.HandleUserGemChatCmd)
end
function PlayerDetailView:TransEquipGrid(grid, width)
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
local fashion_reposition = function(fashionGrid_self)
  local childCount = fashionGrid_self.transform.childCount
  fashionGrid_self.grid.cellHeight = childCount > 6 and 582 / math.ceil(childCount / 2) or 195.6
  fashionGrid_self.grid:Reposition()
end
function PlayerDetailView:GetFashionGrid()
  local grid = self:FindComponent("FashionGrid", UIGrid)
  local fashionGrid = {}
  fashionGrid.grid = grid
  fashionGrid.transform = grid.transform
  fashionGrid.gameObject = grid.gameObject
  fashionGrid.Reposition = fashion_reposition
  fashionGrid.comp = fashionGrid.gameObject:GetComponent(GameObjectForLua)
  if not fashionGrid.comp then
    fashionGrid.comp = fashionGrid.gameObject:AddComponent(GameObjectForLua)
  end
  function fashionGrid.comp.onEnable()
    fashionGrid.Reposition(fashionGrid)
  end
  return fashionGrid
end
function PlayerDetailView:InitUI()
  self.roleBord = self:FindGO("RoleBord")
  self.roleTex = self:FindComponent("RoleTexture", UITexture)
  self.myEquips = self:FindGO("MyEquips")
  self.roleEquips = self:FindGO("RoleEquips")
  local myGrid = self:FindComponent("MyEquipGrid", UIGrid)
  self.myEquipGrid = self:TransEquipGrid(myGrid, 144)
  local playerGrid = self:FindComponent("PlayerEquipGrid", UIGrid)
  self.playerEquipGrid = self:TransEquipGrid(playerGrid, 129)
  self.myRoleEquip, self.playerRoleEquip = {}, {}
  for i = 1, 14 do
    local myObj = self:LoadPreferb("cell/RoleEquipItemCell", self.myEquipGrid)
    myObj.name = "RoleEquipItemCell" .. i
    local playerObj = self:LoadPreferb("cell/RoleEquipItemCell", self.playerEquipGrid)
    playerObj.name = "RoleEquipItemCell" .. i
    self.myRoleEquip[i] = MyselfEquipItemCell.new(myObj, i)
    self.myRoleEquip[i]:AddEventListener(MouseEvent.MouseClick, self.ClickMyEquip, self)
    self.playerRoleEquip[i] = MyselfEquipItemCell.new(playerObj, i)
    self.playerRoleEquip[i]:AddEventListener(MouseEvent.MouseClick, self.ClickPlayerEquip, self)
  end
  self.myEquipGrid:Reposition()
  self.playerEquipGrid:Reposition()
  self.myAttriHolder = self:FindGO("attrViewHolder")
  self.playerAttriHolder = self:FindGO("PlayerAttriViewHolder")
  self.roleFashions = self:FindGO("RoleFashions")
  self.playerGemProfit = self:FindGO("PlayerGemProfit")
  self.playerGemNoneTip = self:FindGO("GemNoneTip", self.playerGemProfit)
  self.skillGemTable = self:FindComponent("SkillGemContainer", UITable, self.playerGemProfit)
  self.heroSkillInfoRoot = self:FindGO("HeroSkillInfoRoot", self.skillGemTable.gameObject)
  self.attrGemTable = self:FindComponent("AttrGemContainer", UITable, self.playerGemProfit)
  self.skillGemProfitListCtrl = ListCtrl.new(self.skillGemTable, GemSkillProfitCell, "GemSkillPlayerDetailCell")
  self.attrGemProfitListCtrl = ListCtrl.new(self.attrGemTable, GemAttributeProfitCell, "GemAttributePlayerDetailCell")
  self.gemTogRoot = self:FindGO("GemTogRoot")
  self.skillGemTog = self:FindGO("SkillGemTog", self.gemTogRoot)
  self.skillGemTogLab1 = self:FindComponent("Label1", UILabel, self.skillGemTog)
  self.skillGemTogLab2 = self:FindComponent("Label2", UILabel, self.skillGemTog)
  self.skillGemTogLab1.text = ZhString.Gem_SkillGemCountLabel
  self.skillGemTogLab2.text = ZhString.Gem_SkillGemCountLabel
  self:AddClickEvent(self.skillGemTog, function()
    self:Show(self.skillGemTable)
    self:Hide(self.attrGemTable)
    self.skillGemProfitListCtrl:ResetPosition()
  end)
  self.attrGemTog = self:FindGO("AttrGemTog", self.gemTogRoot)
  self.attrGemTogLab1 = self:FindComponent("Label1", UILabel, self.attrGemTog)
  self.attrGemTogLab2 = self:FindComponent("Label2", UILabel, self.attrGemTog)
  self.attrGemTogLab1.text = ZhString.Gem_AttributeGemCountLabel
  self.attrGemTogLab2.text = ZhString.Gem_AttributeGemCountLabel
  self:AddClickEvent(self.attrGemTog, function()
    self:Hide(self.skillGemTable)
    self:Show(self.attrGemTable)
    self.attrGemProfitListCtrl:ResetPosition()
  end)
  self.roleInfo = self:FindGO("RoleInfo")
  self.playerName = self:FindComponent("Name", UILabel, self.roleInfo)
  self.partnerName = self:FindComponent("PartnerName", UILabel, self.roleInfo)
  self.normalStick = self:FindComponent("NormalStick", UISprite)
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self:InitTabEvent()
  self.leftState = PlayerDetailView.State.None
  self.rightState = PlayerDetailView.State.Equip
  self:UpdateLeftState()
  self:UpdateRightState()
  self:SetCurrentTabIconColor(self.equipTab)
  self.myBaseAttriView = self:AddSubView("BaseAttributeView", BaseAttributeView)
  self.playerAttriView = self:AddSubView("PlayerAttriButeView", PlayerAttriButeView)
end
function PlayerDetailView:UpdateHeroSkill()
  if self.heroSkillStaticData then
    self:Show(self.heroSkillInfoRoot)
    if not self.heroTitleLab then
      self.heroTitleLab = self:FindComponent("TitleLab", UILabel, self.heroSkillInfoRoot)
      self.heroTitleBg = self:FindComponent("TitleBg", UISprite, self.heroTitleLab.gameObject)
      self.heroTitleBgHeight = self.heroTitleBg.height
      self.heroFeatureLvLab = self:FindComponent("LvLab", UILabel, self.heroTitleLab.gameObject)
      self.heroSkillNameLab = self:FindComponent("SkillNameLab", UILabel, self.heroSkillInfoRoot)
      self.heroDescLab = self:FindComponent("SkillDescLab", UILabel, self.heroSkillInfoRoot)
    end
    self.heroTitleLab.text = ZhString.Gem_HeroProfessionTitle
    self.heroFeatureLvLab.text = tostring(self.extra_feature_level) .. "/" .. ProfessionProxy.Instance:GetMaxHeroFeatureLv()
    self.heroSkillNameLab.text = string.format(ZhString.Gem_HeroSkillName, self.heroSkillStaticData.NameZh)
    self.heroDescLab.text = SkillTip:GetHeroDesc(self.heroSkillStaticData, self.extra_feature_level)
    self.heroTitleBg.height = self.heroTitleBgHeight + self.heroDescLab.height
  else
    self:Hide(self.heroSkillInfoRoot)
  end
end
function PlayerDetailView:InitPlayerHeroSkill()
  local profId = self.playerPro
  if not profId or not ProfessionProxy.IsHero(profId) then
    return
  end
  local familyId = profId and Table_Class[profId] and Table_Class[profId].FeatureSkill
  if not familyId then
    return
  end
  local skillId = familyId * 1000 + self.extra_feature_level
  self.heroSkillStaticData = Table_Skill[skillId]
end
function PlayerDetailView:InitFashionCtl(playerPro)
  self.playerPro = playerPro
  local shieldShow = TableUtility.ArrayFindIndex(PackageEquip_ShowShieldPart_Class, playerPro) ~= 0
  if nil ~= self.shieldShow and shieldShow == self.shieldShow then
    return
  end
  self.shieldShow = shieldShow
  local fashionGrid = self:GetFashionGrid()
  if 0 < fashionGrid.transform.childCount then
    for i = fashionGrid.transform.childCount - 1, 0, -1 do
      local go = fashionGrid.transform:GetChild(i)
      if go then
        GameObject.DestroyImmediate(go.gameObject)
      end
    end
  end
  self.fashionEquips = {}
  for i = 1, #PackageEquip_FashionParts do
    local index = PackageEquip_FashionParts[i]
    if index ~= 1 and index ~= 5 or shieldShow then
      local obj = self:LoadPreferb("cell/RoleEquipItemCell", fashionGrid)
      obj.name = "FashionEquipItemCell" .. index
      self.fashionEquips[index] = MyselfEquipItemCell.new(obj, index, true)
      self.fashionEquips[index]:AddEventListener(MouseEvent.MouseClick, self.ClickPlayerEquip, self)
    end
  end
  fashionGrid:Reposition()
end
function PlayerDetailView:ClickMyEquip(cellCtl)
  self:ClickEquip(cellCtl, true)
end
function PlayerDetailView:ClickPlayerEquip(cellCtl)
  self:ClickEquip(cellCtl, false)
end
local myEquipTipOffset, playerEquipTipOffset = {190, 0}, {-190, 0}
function PlayerDetailView:ClickEquip(cellCtl, isClickMyself)
  if cellCtl ~= nil and self.chooseEquip ~= cellCtl then
    local data = cellCtl.data
    if data then
      local offset = isClickMyself and myEquipTipOffset or playerEquipTipOffset
      self:ShowPlayerEquipTip(data, cellCtl.gameObject, offset, isClickMyself)
      self.chooseSymbol.transform:SetParent(cellCtl.gameObject.transform, false)
      self.chooseSymbol.transform.localPosition = LuaGeometry.GetTempVector3()
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
local equipTipOffset = {0, 0}
function PlayerDetailView:ShowPlayerEquipTip(data, ignoreBound, offset, isClickMyself)
  local callback = function()
    self:CancelChoose()
  end
  local sdata = {
    itemdata = data,
    ignoreBounds = {ignoreBound},
    callback = callback,
    equipBuffUpSource = isClickMyself and Game.Myself.data.id or self.playerData.charid
  }
  local itemtip = self:ShowItemTip(sdata, self.normalStick, nil, offset)
  local compareData
  if isClickMyself then
    compareData = self.playerEquipDatas[data.index]
  else
    compareData = BagProxy.Instance.roleEquip:GetEquipBySite(data.index)
    itemtip:HideShowUpBtn()
  end
  if itemtip then
    if compareData and self.rightState ~= PlayerDetailView.State.Fashion then
      local cell = itemtip:GetCell(1)
      if cell then
        local compareFunc = function(data1)
          self.leftState = PlayerDetailView.State.Equip
          self:UpdateLeftState()
          self:CancelChoose()
          local sdata1 = {}
          if isClickMyself then
            sdata1.itemdata = compareData
            sdata1.compdata1 = data1
            sdata1.equipBuffUpSource = self.playerData.charid
            sdata1.compEquipBuffUpSource1 = Game.Myself.data.id
          else
            sdata1.itemdata = data1
            sdata1.compdata1 = compareData
            sdata1.equipBuffUpSource = self.playerData.charid
            sdata1.compEquipBuffUpSource1 = Game.Myself.data.id
          end
          self:ShowItemTip(sdata1, self.normalStick, nil, equipTipOffset)
        end
        cell:AddTipFunc(ZhString.PlayerDetailView_CompareTip, compareFunc, data, true)
      end
    end
    itemtip:HideEquipedSymbol()
  end
end
function PlayerDetailView:CancelChoose()
  if self.__destroyed then
    return
  end
  self.chooseEquip = nil
  self.chooseSymbol.transform:SetParent(self.trans, false)
  self.chooseSymbol:SetActive(false)
end
function PlayerDetailView:InitTabEvent()
  self.leftequipInfoTab = self:FindGO("EquipInfoTab")
  self:AddClickEvent(self.leftequipInfoTab, function(go)
    if self.leftState == PlayerDetailView.State.Equip then
      self.leftState = PlayerDetailView.State.None
    else
      self.leftState = PlayerDetailView.State.Equip
    end
    self:UpdateLeftState()
  end)
  self.rightattrInfoTab = self:FindGO("AttrInfoTab")
  self:AddClickEvent(self.rightattrInfoTab, function(go)
    if self.leftState == PlayerDetailView.State.Attri then
      self.leftState = PlayerDetailView.State.None
    else
      self.leftState = PlayerDetailView.State.Attri
    end
    self:UpdateLeftState()
  end)
  self.equipTab = self:FindGO("EquipTab")
  self.attriTab = self:FindGO("AttriTab")
  self.fashionTab = self:FindGO("FashionTab")
  self.gemTab = self:FindGO("GemTab")
  self:AddTabClickEvents()
  self.tabIconSpList = {}
  local tabList = {
    self.equipTab,
    self.attriTab,
    self.fashionTab,
    self.gemTab
  }
  for _, v in pairs(tabList) do
    local icon = Game.GameObjectUtil:DeepFindChild(v, "Icon")
    self.tabIconSpList[#self.tabIconSpList + 1] = icon:GetComponent(UISprite)
    local label = Game.GameObjectUtil:DeepFindChild(v, "Label")
    TabNameTip.SwitchShowTabIconOrLabel(icon, label)
  end
  local longPressEvent = function(obj, state)
    self:PassEvent(TipLongPressEvent.PlayerDetailView, {
      state,
      obj.gameObject
    })
  end
  for _, t in pairs(tabList) do
    local longPress = t:GetComponent(UILongPress)
    if longPress then
      longPress.pressEvent = longPressEvent
    end
  end
  self:AddEventListener(TipLongPressEvent.PlayerDetailView, self.HandleLongPress, self)
  self.gemTab:SetActive(FunctionUnLockFunc.checkFuncStateValid(117))
end
function PlayerDetailView:AddTabClickEvents()
  local onTabClick = function(tab, state)
    self.leftState = state
    self.rightState = state
    self:UpdateLeftState()
    self:UpdateRightState()
    self:SetCurrentTabIconColor(tab)
  end
  self:AddClickEvent(self.equipTab, function(go)
    onTabClick(go, PlayerDetailView.State.Equip)
  end)
  self:AddClickEvent(self.attriTab, function(go)
    onTabClick(go, PlayerDetailView.State.Attri)
  end)
  self:AddClickEvent(self.fashionTab, function(go)
    onTabClick(go, PlayerDetailView.State.Fashion)
  end)
  self:AddClickEvent(self.gemTab, function(go)
    onTabClick(go, PlayerDetailView.State.Gem)
  end)
end
function PlayerDetailView:UpdateLeftState()
  local isEquip, isAttri = self.leftState == PlayerDetailView.State.Attri, true
  self.leftequipInfoTab.transform.localRotation = isEquip and Quaternion.Euler(0, 180, 0) or Quaternion.identity
  self.rightattrInfoTab.transform.localRotation = isAttri and Quaternion.Euler(0, 180, 0) or Quaternion.identity
  self.myEquips.gameObject:SetActive(isEquip)
  self.myAttriHolder:SetActive(isAttri)
  if isAttri then
    self.myBaseAttriView:showMySelf()
  end
end
function PlayerDetailView:UpdateRightState()
  local isEquip, isFashion = self.rightState == PlayerDetailView.State.Fashion, true
  local isAttri, isGem = self.rightState == PlayerDetailView.State.Gem, true
  self.roleInfo:SetActive(isEquip or isFashion or isGem)
  self.roleBord:SetActive(isEquip or isFashion)
  self.roleEquips:SetActive(isEquip)
  self.roleFashions:SetActive(isFashion)
  if isEquip or isFashion then
    self:TrySetPlayerModelTex()
  end
  self.playerAttriHolder:SetActive(isAttri)
  if isAttri then
    self.playerAttriView:updateGeneralData(self.playerAttriView.data)
  end
  self.playerGemProfit:SetActive(isGem)
  if isGem then
    self.partnerName.gameObject:SetActive(false)
    TimeTickManager.Me():CreateOnceDelayTick(33, function()
      if not self or not self.skillGemProfitListCtrl then
        return
      end
      self.skillGemProfitListCtrl:ResetPosition()
      self.attrGemProfitListCtrl:ResetPosition()
    end, self)
  else
    self:UpdatePartnerName()
  end
end
function PlayerDetailView:SetCurrentTabIconColor(currentTabGo)
  TabNameTip.ResetColorOfTabIconList(self.tabIconSpList)
  TabNameTip.SetupIconColorOfCurrentTabObj(currentTabGo)
end
function PlayerDetailView:TrySetPlayerModelTex()
  if self.playerData then
    local parts = Asset_Role.CreatePartArray()
    local userdata = self.playerData.userdata
    local partIndex = Asset_Role.PartIndex
    local partIndexEx = Asset_Role.PartIndexEx
    parts[partIndex.Body] = userdata:Get(UDEnum.BODY) or 0
    parts[partIndex.Hair] = userdata:Get(UDEnum.HAIR) or 0
    parts[partIndex.LeftWeapon] = userdata:Get(UDEnum.LEFTHAND) or 0
    parts[partIndex.RightWeapon] = userdata:Get(UDEnum.RIGHTHAND) or 0
    parts[partIndex.Head] = userdata:Get(UDEnum.HEAD) or 0
    parts[partIndex.Wing] = userdata:Get(UDEnum.BACK) or 0
    parts[partIndex.Face] = userdata:Get(UDEnum.FACE) or 0
    parts[partIndex.Tail] = userdata:Get(UDEnum.TAIL) or 0
    parts[partIndex.Eye] = userdata:Get(UDEnum.EYE) or 0
    parts[partIndex.Mount] = 0
    parts[partIndex.Mouth] = userdata:Get(UDEnum.MOUTH) or 0
    parts[partIndexEx.Gender] = userdata:Get(UDEnum.SEX) or 0
    parts[partIndexEx.HairColorIndex] = userdata:Get(UDEnum.HAIRCOLOR) or 0
    parts[partIndexEx.EyeColorIndex] = userdata:Get(UDEnum.EYECOLOR) or 0
    parts[partIndexEx.BodyColorIndex] = userdata:Get(UDEnum.CLOTHCOLOR) or 0
    UIModelUtil.Instance:SetRoleModelTexture(self.roleTex, parts, UIModelCameraTrans.Team)
    Asset_Role.DestroyPartArray(parts)
  end
end
function PlayerDetailView:UpdatePlayerRoleEquips()
  if self.playerRoleEquip then
    for i = 1, #self.playerRoleEquip do
      local equipCell = self.playerRoleEquip[i]
      equipCell:SetData(self.playerEquipDatas[i])
      equipCell:UpdateStrengthLevelByPlayer(self.playerData.charid)
      equipCell:UpdateRefineLevelByPlayer(self.playerData.charid)
    end
  end
end
function PlayerDetailView:HandleUserGemChatCmd(note)
  local info = note.body and note.body.info
  self.playerSkillGems = self.playerSkillGems or {}
  self.playerAttrGems = self.playerAttrGems or {}
  TableUtility.TableClear(self.playerSkillGems)
  TableUtility.TableClear(self.playerAttrGems)
  self:ParseItemDatasFromServer(self.playerSkillGems, info and info.skillgems, true)
  self:ParseItemDatasFromServer(self.playerAttrGems, info and info.attrgems, true)
  local gems = ReusableTable.CreateArray()
  for _, sGem in pairs(self.playerSkillGems) do
    TableUtility.ArrayPushBack(gems, sGem)
  end
  for _, aGem in pairs(self.playerAttrGems) do
    TableUtility.ArrayPushBack(gems, aGem)
  end
  self.playerGemPageData = self.playerGemPageData or GemPageData.new()
  self.playerGemPageData:SetData(gems)
  self.extra_feature_level = self.playerGemPageData:GetHeroFeatureLv()
  self:InitPlayerHeroSkill()
  ReusableTable.DestroyAndClearArray(gems)
  self:UpdateHeroSkill()
  self.skillGemProfitListCtrl:ResetDatas(self.playerSkillGems)
  local cells = self.skillGemProfitListCtrl:GetCells()
  for _, c in pairs(cells) do
    c:UpdateInvalidByGemPageData(self.playerGemPageData)
  end
  self.attrGemProfitListCtrl:ResetDatas(GemProxy.GetDescNameValueDataFromAttributeItemDatas(self.playerAttrGems))
  self:Hide(self.attrGemTable)
  local isEmpty = #self.playerSkillGems + #self.playerAttrGems == 0 and not self.heroSkillStaticData
  self.playerGemNoneTip:SetActive(isEmpty)
  self.gemTogRoot:SetActive(not isEmpty)
end
function PlayerDetailView:UpdateRoleInfo()
  local str = self.playerData.name
  local guildData = self.playerData:GetGuildData()
  if guildData then
    str = string.format("%s<%s>", str, guildData.name)
  end
  self.playerName.text = str
  self.playerName.text = AppendSpace2Str(str)
  self:UpdatePartnerName()
end
function PlayerDetailView:UpdatePartnerName()
  local partner = self.playerData_partner
  if partner and partner ~= "" then
    self.partnerName.gameObject:SetActive(true)
    self.partnerName.text = string.format(ZhString.PlayerDetailView_PartnerName, partner)
  else
    self.partnerName.gameObject:SetActive(false)
  end
end
function PlayerDetailView:UpdateMyRoleEquips()
  local equipdata = BagProxy.Instance.roleEquip.siteMap
  for i = 1, #self.myRoleEquip do
    self.myRoleEquip[i]:SetData(equipdata[i])
  end
end
function PlayerDetailView:UpdatePlayerRoleFashions()
  local fashiondata = self.playerFashionDatas
  for i = 1, #PackageEquip_FashionParts do
    local index = PackageEquip_FashionParts[i]
    if self.fashionEquips[index] then
      self.fashionEquips[index]:SetData(fashiondata[index])
    end
  end
end
function PlayerDetailView:CreatePlayerData(serverData)
  self:DestroyPlayerData()
  self.playerData = PlayerData.CreateAsTable(serverData)
  self.playerData.charid = serverData.charid
  local datas = serverData.datas
  if datas then
    for i = 1, #datas do
      local celldata = datas[i]
      if celldata ~= nil then
        self.playerData.userdata:SetByID(celldata.type, celldata.value, celldata.data)
      end
    end
  end
  local attrs = serverData.attrs
  if attrs then
    for i = 1, #attrs do
      local cellAttri = attrs[i]
      if cellAttri ~= nil then
        self.playerData.props:SetValueById(cellAttri.type, cellAttri.value)
      end
    end
  end
  local tempArray = ReusableTable.CreateArray()
  tempArray[1] = serverData.guildid
  tempArray[2] = serverData.guildname
  tempArray[3] = serverData.guildportrait
  tempArray[4] = serverData.guildjob
  self.playerData:SetGuildData(tempArray)
  ReusableTable.DestroyArray(tempArray)
  self:InitFashionCtl(self.playerData.userdata:Get(UDEnum.PROFESSION))
end
function PlayerDetailView:DestroyPlayerData()
  if self.playerData then
    self.playerData:Destroy()
    self.playerData = nil
  end
end
function PlayerDetailView:UpdateViewInfo(dataInfo)
  if dataInfo then
    self:CreatePlayerData(dataInfo)
    self.playerEquipDatas = {}
    self:ParseItemDatasFromServer(self.playerEquipDatas, dataInfo.equip)
    self.playerFashionDatas = {}
    self:ParseItemDatasFromServer(self.playerFashionDatas, dataInfo.fashion)
    self.playerAttriView:SetPlayer(self.playerData)
    self.playerData_partner = dataInfo.partner
  end
  self:TrySetPlayerModelTex()
  self:UpdatePlayerRoleEquips()
  self:UpdatePlayerRoleFashions()
  self:UpdateRoleInfo()
  self:UpdateMyRoleEquips()
  self:CameraRotateToMe()
  ServiceChatCmdProxy.Instance:CallQueryUserGemChatCmd(self.playerData.accid, self.playerData.charid)
end
function PlayerDetailView:ParseItemDatasFromServer(targetTable, sourceTable, ignoreIndex)
  if type(targetTable) ~= "table" or type(sourceTable) ~= "table" then
    return
  end
  local itemdata
  for i = 1, #sourceTable do
    itemdata = ItemData.new()
    itemdata:ParseFromServerData(sourceTable[i])
    if not ignoreIndex and itemdata.index then
      targetTable[itemdata.index] = itemdata
    elseif ignoreIndex then
      table.insert(targetTable, itemdata)
    end
  end
end
function PlayerDetailView:OnEnter()
  PlayerDetailView.super.OnEnter(self)
  local viewData = self.viewdata.viewdata
  local dataInfo = viewData and viewData.dataInfo
  if dataInfo then
    self:UpdateViewInfo(dataInfo)
  else
    self:CloseSelf()
  end
  self.myBaseAttriView:OnEnter()
  self.myBaseAttriView:HideHelpBtn()
  self.playerAttriView:OnEnter()
  self.playerAttriView:HideHelpBtn()
  UIManagerProxy.Instance:NeedEnableAndroidKey(true, function()
    self:CloseSelf()
  end)
end
function PlayerDetailView:OnExit()
  PlayerDetailView.super.OnExit(self)
  self:ShowItemTip(nil)
  self:CameraReset()
  self:DestroyPlayerData()
  TimeTickManager.Me():ClearTick(self)
  UIManagerProxy.Instance:NeedEnableAndroidKey(true, UIManagerProxy.GetDefaultNeedEnableAndroidKeyCallback())
end
function PlayerDetailView:HandleLongPress(param)
  local isPressing, go = param[1], param[2]
  TabNameTip.OnLongPress(isPressing, PlayerDetailView.TabName[go.name], false, go:GetComponent(UISprite))
end
