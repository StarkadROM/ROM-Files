FunctionItemFunc = class("FunctionItemFunc")
autoImport("EquipUtil")
ItemFuncState = {
  Active = 1,
  InActive = 2,
  Grey = 3
}
FunctionItemFunc_Source = {
  MainBag = 1,
  RoleEquipBag = 2,
  StorageBag = 4,
  CommonStorageBag = 8,
  TempBag = 16,
  BarrowBag = 32,
  HomeBag = 64
}
local ItemFunction = GameConfig.ItemFunction
function FunctionItemFunc.Me()
  if nil == FunctionItemFunc.me then
    FunctionItemFunc.me = FunctionItemFunc.new()
  end
  return FunctionItemFunc.me
end
function FunctionItemFunc:ctor()
  self.funcMap = {}
  self.checkMap = {}
  self.funcMap.GetTask = FunctionItemFunc.GetQuestByItem
  self.funcMap.MakePic = FunctionItemFunc.MakePicEvt
  self.funcMap.DepositFashion = FunctionItemFunc.DepositFashionEvt
  self.funcMap.Dress = FunctionItemFunc.EquipEvt
  self.funcMap.Apply = FunctionItemFunc.ItemUseEvt
  self.funcMap.Shortcutkey = FunctionItemFunc.ShortcutkeyEvt
  self.funcMap.Sale = FunctionItemFunc.SaleEvt
  self.funcMap.Discharge = FunctionItemFunc.OffEquip_Equip
  self.funcMap.GetoutFashion = FunctionItemFunc.OffEquip_Fashion
  self.funcMap.Combine = FunctionItemFunc.Combine
  self.funcMap.CombineTip = FunctionItemFunc.Combine
  self.funcMap.DepositRepository = FunctionItemFunc.DepositRepositoryEvt
  self.funcMap.WthdrawnRepository = FunctionItemFunc.WthdrawnRepositoryEvt
  self.funcMap.PersonalDepositRepository = FunctionItemFunc.PersonalDepositRepositoryEvt
  self.funcMap.PersonalWthdrawnRepository = FunctionItemFunc.PersonalWthdrawnRepositoryEvt
  self.funcMap.RemoveEquipCard = FunctionItemFunc.RemoveEquipCardEvt
  self.funcMap.Active = FunctionItemFunc.ActiveEvt
  self.funcMap.Inlay = FunctionItemFunc.InlayEvt
  self.funcMap.Pitch = FunctionItemFunc.PitchEvt
  self.funcMap.PickUpFromTempBag = FunctionItemFunc.PickUpFromTempBag
  self.funcMap.OpenBarrowBag = FunctionItemFunc.OpenBarrowBag
  self.funcMap.Adventure = FunctionItemFunc.Adventure
  self.funcMap.Hatch = FunctionItemFunc.Hatch
  self.funcMap.PutInBarrow = FunctionItemFunc.PutInBarrow
  self.funcMap.PutBackBarrow = FunctionItemFunc.PutBackBarrow
  self.funcMap.PutFood_Public = FunctionItemFunc.PutFood_Public
  self.funcMap.PutFood_Team = FunctionItemFunc.PutFood_Team
  self.funcMap.PutFood_Self = FunctionItemFunc.PutFood_Self
  self.funcMap.PutFood_Pet = FunctionItemFunc.PutFood_Pet
  self.funcMap.Open_Letter = FunctionItemFunc.Open_Letter
  self.funcMap.UnloadPetEquip = FunctionItemFunc.UnloadPetEquip
  self.funcMap.Open_MarriageManual = FunctionItemFunc.Open_MarriageManual
  self.funcMap.Open_MarriageCertificate = FunctionItemFunc.Open_MarriageCertificate
  self.funcMap.Send_WeddingDress = FunctionItemFunc.Send_WeddingDress
  self.funcMap.OpenRegistTicket = FunctionItemFunc.OpenRegistTicket
  self.funcMap.EmbedGem = FunctionItemFunc.EmbedGem
  self.funcMap.AppraiseGem = FunctionItemFunc.AppraiseGem
  self.funcMap.HomeCompose = FunctionItemFunc.HomeCompose
  self.funcMap.HomeStoreIn = FunctionItemFunc.HomeStoreIn
  self.funcMap.HomeStoreOut = FunctionItemFunc.HomeStoreOut
  self.funcMap.ShowCoupleCode = FunctionItemFunc.ShowCoupleCode
  self.funcMap.UseSkillItem = FunctionItemFunc.UseSkillItem
  self.funcMap.QuickMake = FunctionItemFunc.QuickMake
  self.funcMap.TwentyOneDaysDevelop = FunctionItemFunc.TwentyOneDaysDevelop
  self.funcMap.PersonalArtifactIdentify = FunctionItemFunc.PersonalArtifactIdentify
  self.funcMap.PersonalArtifactPutIn = FunctionItemFunc.PersonalArtifactPutIn
  self.funcMap.AutoHealing = FunctionItemFunc.AutoHealing
  self.checkMap.Inlay = FunctionItemFunc.CheckInlay
  self.checkMap.Combine = FunctionItemFunc.CheckCombine
  self.checkMap.MakePic = FunctionItemFunc.CheckMakePic
  self.checkMap.DepositFashion = FunctionItemFunc.CheckEquip
  self.checkMap.Dress = FunctionItemFunc.CheckEquip
  self.checkMap.Apply = FunctionItemFunc.CheckApply
  self.checkMap.GotoUse = FunctionItemFunc.CheckGotoUse
  self.checkMap.Send_WeddingDress = FunctionItemFunc.CheckSend_WeddingDress
  self.checkMap.PutFood = FunctionItemFunc.CheckPutFood
  self.checkMap.PutFood_Pet = FunctionItemFunc.CheckPutFoodPet
  self.checkMap.HomeCompose = FunctionItemFunc.CheckHomeCompose
  self.checkMap.HomeStoreIn = FunctionItemFunc.CheckHomeStoreIn
  self.checkMap.HomeStoreOut = FunctionItemFunc.CheckHomeStoreOut
end
function FunctionItemFunc:GetItemDefaultFunc(data, source, dest_isfashion)
  if data and data.staticData then
    if source == FunctionItemFunc_Source.RoleEquipBag then
      return self.funcMap.Discharge
    else
      local fids = FunctionItemFunc.GetItemFuncIds(data.staticData.id, source, dest_isfashion)
      if fids then
        for i = 1, #fids do
          local default = ItemFunction[fids[i]]
          local ftype = default and default.type
          if default and FunctionItemFunc.Me():CheckFuncState(ftype, data) == ItemFuncState.Active then
            return self.funcMap[ftype], fids[i]
          end
        end
      end
    end
  end
end
local FashionEquipMap = {
  [6] = 5,
  [8] = 7
}
local EquipFashionMap = {
  [5] = 6,
  [7] = 8
}
function FunctionItemFunc.GetItemFuncIds(itemId, surtype, dest_isfashion)
  local Function
  if GameConfig.SpecialItemFunction and GameConfig.SpecialItemFunction[itemId] then
    Function = GameConfig.SpecialItemFunction[itemId]
  end
  if Function == nil then
    local sData = Table_Item[itemId]
    if sData == nil then
      return
    end
    local typeConfig = Table_ItemType[sData.Type]
    if typeConfig == nil then
      return
    end
    Function = typeConfig.Function
  end
  if Function == nil then
    return
  end
  surtype = surtype or FunctionItemFunc_Source.MainBag
  local result, itemFunction = {}, nil
  for i = 1, #Function do
    local fid = Function[i]
    itemFunction = ItemFunction[fid]
    if itemFunction and itemFunction.showtype & surtype > 0 then
      if dest_isfashion then
        if FashionEquipMap[fid] then
          fid = FashionEquipMap[fid]
        end
      elseif EquipFashionMap[fid] then
        fid = EquipFashionMap[fid]
      end
      table.insert(result, fid)
    end
  end
  return result
end
function FunctionItemFunc:GetFuncById(id)
  if id then
    local config = GameConfig.ItemFunction[id]
    if config then
      return self:GetFunc(config.type)
    end
  end
  return nil
end
function FunctionItemFunc:GetFunc(key)
  return self.funcMap[key]
end
function FunctionItemFunc.GetQuestByItem(data)
  local canGo = FunctionItemFunc.bGetTaskItemType(data.staticData)
  if canGo then
    return
  end
  local itemData = BagProxy.Instance:GetItemByStaticID(data.staticData.id)
  if itemData then
    FunctionItemFunc.TryUseItem(itemData)
  end
end
function FunctionItemFunc.bGetTaskItemType(staticData)
  if not Table_UseItem[staticData.id] or not Table_UseItem[staticData.id].UseEffect then
    return false
  end
  local questID = Table_UseItem[staticData.id].UseEffect.id
  if questID then
    local bGet = QuestProxy.Instance:checkQuestHasAccept(questID)
    if bGet then
      return true
    end
  end
  return false
end
function FunctionItemFunc.MakePicEvt(data)
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
    viewname = "PicTipPopUp",
    data = data
  })
end
function FunctionItemFunc.DepositFashionEvt(data)
  local limitlv = data.staticData.Level
  if limitlv and limitlv > 0 then
    local mylv = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
    if limitlv > mylv then
      MsgManager.ShowMsgByIDTable(40, limitlv)
      return
    end
  end
  if data.IsPetEgg and data:IsPetEgg() and (not data.petEggInfo or not data.petEggInfo:PetMountCanEquip()) then
    return
  end
  if data.equipInfo and data.equipInfo:IsMyDisplayForbid() then
    MsgManager.ShowMsgByID(40310)
  end
  ServiceItemProxy.Instance:CallEquip(SceneItem_pb.EEQUIPOPER_PUTFASHION, nil, data.id)
  GameFacade.Instance:sendNotification(ItemEvent.Equip)
end
function FunctionItemFunc.Combine(data, count)
  if data ~= nil and data.staticData ~= nil then
    local composeid = data.staticData.ComposeID
    if composeid ~= nil then
      local maxNum = FunctionItemFunc._GetCombineMaxNum(data.staticData.id)
      if not count or count <= maxNum then
        ServiceItemProxy.Instance:CallProduce(nil, composeid, nil, nil, count)
      elseif maxNum > 0 then
        ServiceItemProxy.Instance:CallProduce(nil, composeid, nil, nil, maxNum)
        MsgManager.ShowMsgByIDTable(43238, maxNum)
      else
        MsgManager.ShowMsgByIDTable(3004)
      end
    end
  end
end
function FunctionItemFunc._GetCombineMaxNum(itemid)
  local cid = itemid and Table_Item[itemid].ComposeID
  if cid == nil then
    return 0
  end
  local beCostItem = Table_Compose[cid].BeCostItem
  local _BagProxy = BagProxy.Instance
  local packageCheck = _BagProxy:Get_PackageMaterialCheck_BagTypes(BagProxy.MaterialCheckBag_Type.Produce)
  local hasleft, maxNum, num, cNum = false, nil, nil, nil
  for i = 1, #beCostItem do
    local cost = beCostItem[i]
    if cost.id ~= 100 then
      num = _BagProxy:GetItemNumByStaticID(cost.id, packageCheck)
      cNum = math.floor(num / cost.num)
      maxNum = maxNum == nil and cNum or math.min(cNum, maxNum)
      if hasleft == false and 0 < num % cost.num then
        hasleft = true
      end
    end
  end
  return maxNum, hasleft
end
function FunctionItemFunc.EquipEvt(data)
  local site = BagProxy.Instance:GetToEquipPos()
  FunctionItemFunc.CallEquipEvt(data, site)
end
function FunctionItemFunc.ActiveEvt(data)
  FunctionItemFunc.ItemUseEvt(data)
end
function FunctionItemFunc.ItemUseEvt(data, count, cellCtl)
  FunctionSecurity.Me():UseItem(function()
    FunctionItemFunc.TryUseItem(data, nil, count, cellCtl)
  end, {itemData = data})
end
function FunctionItemFunc.ShortcutkeyEvt(data)
end
function FunctionItemFunc.SaleEvt(data)
  AudioUtility.PlayOneShot2D_Path(AudioMap.UI.Coin, AudioSourceType.UI)
  ServiceItemProxy.Instance:CallSellItem(data.id, data.num)
end
function FunctionItemFunc.OffEquip_Equip(data)
  if not data or not data.staticData then
    return
  end
  if not data:CanIOffEquip() then
    return
  end
  ServiceItemProxy.Instance:CallEquip(SceneItem_pb.EEQUIPOPER_OFF, nil, data.id)
end
function FunctionItemFunc.OffEquip_Fashion(data)
  if not data or not data.staticData then
    return
  end
  if not data:CanIOffEquip() then
    return
  end
  ServiceItemProxy.Instance:CallEquip(SceneItem_pb.EEQUIPOPER_OFFFASHION, nil, data.id)
end
function FunctionItemFunc.DepositRepositoryEvt(data, count)
  if data then
    if not data:CanStorage(BagProxy.BagType.Storage) then
      MsgManager.ShowMsgByID(38)
      return
    end
    ServiceItemProxy.Instance:CallEquip(SceneItem_pb.EEQUIPOPER_PUTSTORE, nil, data.id, nil, count)
  end
end
function FunctionItemFunc.WthdrawnRepositoryEvt(data, count)
  if data then
    if RepositoryViewProxy.Instance:GetViewTab() == RepositoryView.Tab.CommonTab then
      local itemdata = BagProxy.Instance:GetItemByGuid(data.id, BagProxy.BagType.Storage)
      if itemdata ~= nil then
        local roleLevel = MyselfProxy.Instance:RoleLevel()
        if itemdata.petEggInfo ~= nil and roleLevel < itemdata.petEggInfo.lv then
          MsgManager.ConfirmMsgByID(8024, function()
            ServiceItemProxy.Instance:CallEquip(SceneItem_pb.EEQUIPOPER_OFFSTORE, nil, data.id, nil, count)
          end, nil, nil, roleLevel)
          return
        end
      end
    end
    ServiceItemProxy.Instance:CallEquip(SceneItem_pb.EEQUIPOPER_OFFSTORE, nil, data.id, nil, count)
  end
end
function FunctionItemFunc.PersonalDepositRepositoryEvt(data, count)
  if data then
    if not data:CanStorage(BagProxy.BagType.PersonalStorage) then
      MsgManager.ShowMsgByID(38)
      return
    end
    ServiceItemProxy.Instance:CallEquip(SceneItem_pb.EEQUIPOPER_PUTPSTORE, nil, data.id, nil, count)
  end
end
function FunctionItemFunc.PersonalWthdrawnRepositoryEvt(data, count)
  if data then
    ServiceItemProxy.Instance:CallEquip(SceneItem_pb.EEQUIPOPER_OFFPSTORE, nil, data.id, nil, count)
  end
end
function FunctionItemFunc.RemoveEquipCardEvt(data)
  if data and data.equipedCardInfo then
    for k, v in pairs(data.equipedCardInfo) do
      ServiceItemProxy.Instance:CallEquipCard(SceneItem_pb.ECARDOPER_EQUIPOFF, v.guid, data.id)
    end
  end
end
function FunctionItemFunc.InlayEvt(data)
  if data then
    if data.cardInfo then
      local filterDatas = BagProxy.Instance:FilterEquipedCardItems(data.cardInfo.Position)
      if #filterDatas > 0 then
        GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.UseCardPopUp,
          viewdata = {carddata = data, equipdatas = filterDatas}
        })
        return true
      else
        MsgManager.ShowMsgByIDTable(510)
      end
    else
      local cardSlotNum = data.cardSlotNum
      local equipCards = data.equipedCardInfo or {}
      if cardSlotNum > 0 then
        local filterCards = {}
        local pos = ItemUtil.getEquipPos(data.staticData.id)
        local items = BagProxy.Instance.bagData:GetItems()
        for i = 1, #items do
          if items[i].cardInfo and items[i].cardInfo.Position == pos then
            table.insert(filterCards, items[i])
          end
        end
        if #filterCards > 0 then
          GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
            viewname = "SetCardPopUp",
            viewdata = {itemdata = data, carddatas = filterCards}
          })
          return true
        else
          MsgManager.ShowMsgByIDTable(512)
        end
      end
    end
  end
end
function FunctionItemFunc.PitchEvt(data)
  local viewdata = {
    view = PanelConfig.ShopMallExchangeView,
    viewdata = {
      exchange = ShopMallExchangeEnum.Sell
    }
  }
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, viewdata)
end
function FunctionItemFunc.CallEquipEvt(data, site)
  if data and (data.equipInfo or data:IsMount()) then
    local poses = data.equipInfo:GetEquipSite()
    if poses then
      local posIsRight = false
      for _, sc in pairs(poses) do
        if sc == site then
          posIsRight = true
          break
        end
      end
      if not posIsRight then
        local nullPos, lowPos, lowEquipScore
        for _, pos in pairs(poses) do
          local equip = BagProxy.Instance.roleEquip:GetEquipBySite(pos)
          if not equip then
            nullPos = pos
            break
          else
            local score = equip.equipInfo:GetReplaceValues()
            if not lowEquipScore then
              lowEquipScore = score
              lowPos = pos
            elseif score < lowEquipScore then
              lowEquipScore = score
              lowPos = pos
            end
          end
        end
        site = nullPos or lowPos
      end
    end
    if data:IsMountPet() then
      local fashionMount = BagProxy.Instance.fashionEquipBag:GetMount()
      if fashionMount and fashionMount.staticData.id == data.staticData.id then
        MsgManager.ShowMsgByIDTable(27204)
        return
      end
    end
    local myPro = Game.Myself.data.userdata:Get(UDEnum.PROFESSION)
    local isValid = data.equipInfo:CanUseByProfess(myPro)
    if not isValid then
      MsgManager.ShowMsgByIDTable(18)
      return
    end
    local limitlv = data.staticData.Level
    if limitlv and limitlv > 0 then
      local mylv = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
      if limitlv > mylv then
        MsgManager.ShowMsgByIDTable(40, limitlv)
        return
      end
    end
    local equipPosOnCdTime = MyselfProxy.Instance:GetEquipPosOnCdTime(site)
    if equipPosOnCdTime then
      local itemTypeSData = Table_ItemType[data.staticData.Type]
      MsgManager.FloatMsg(nil, string.format(ZhString.PackageView_EquipPosOnCd, itemTypeSData and OverSea.LangManager.Instance():GetLangByKey(itemTypeSData.Name) or "", math.ceil(equipPosOnCdTime)))
      return
    end
    if data.equipInfo and data.equipInfo:IsMyDisplayForbid() then
      MsgManager.ShowMsgByID(40310)
    end
    ServiceItemProxy.Instance:CallEquip(SceneItem_pb.EEQUIPOPER_ON, site, data.id, false)
    GameFacade.Instance:sendNotification(ItemEvent.Equip)
  end
end
local Adventure_Card_MenuId = 29
function FunctionItemFunc.TryUseItem(data, target, count)
  local sdata = data and data.staticData
  local myPro = MyselfProxy.Instance:GetMyProfession()
  local myTypeBranch = ProfessionProxy.GetTypeBranchFromProf(myPro)
  local bUnlock = false
  local classTab = Table_UseItem[sdata.id] and Table_UseItem[sdata.id].Class
  if nil ~= classTab and #classTab > 0 then
    for k, v in pairs(classTab) do
      if myTypeBranch == ProfessionProxy.GetTypeBranchFromProf(v) and v <= myPro then
        bUnlock = true
      end
    end
  else
    bUnlock = true
  end
  if not bUnlock then
    MsgManager.ShowMsgByID(18)
    return
  end
  if not GVGCookingHelper.Me():isCanUseCooking(sdata.id) then
    return
  end
  if 0 < data.cdTime then
    return
  end
  if sdata.Level and 0 < sdata.Level then
    local mylv = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
    if mylv < sdata.Level then
      MsgManager.ShowMsgByIDTable(40, sdata.Level)
      return
    end
  end
  local joblv = sdata.JobLevel
  if joblv and joblv > 0 then
    local myjob = Game.Myself.data.userdata:Get(UDEnum.JOBLEVEL)
    if joblv > myjob then
      MsgManager.ShowMsgByIDTable(28005, joblv)
      return
    end
  end
  if (sdata.id == 500503 or sdata.id == 500516) and not TeamProxy.Instance:IHaveTeam() then
    MsgManager.ShowMsgByID(332)
    return
  end
  local itemRefConfig = Table_ItemRef[sdata.id]
  if itemRefConfig then
    local showPanel = false
    if itemRefConfig.Menu_ID and not FunctionUnLockFunc.Me():CheckCanOpen(itemRefConfig.Menu_ID) then
      showPanel = true
    end
    if itemRefConfig.Time_ID and not FunctionUnLockFunc.checkFuncTimeValid(itemRefConfig.Time_ID) then
      showPanel = true
    end
    if showPanel then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.ItemGuidePopUp,
        viewdata = {
          ID = sdata.id
        }
      })
      return
    end
  end
  if sdata.UseMode ~= nil and sdata.Type ~= 75 then
    if sdata.id == 5800 and sdata.UseMode == 92 then
      local canuse = LotteryProxy.Instance:CheckCanUseTicket()
      if not canuse then
        MsgManager.ShowMsgByID(3605)
        return
      end
    end
    if sdata.id == 5501 and ProfessionProxy.GetJobDepth() < 2 then
      MsgManager.ShowMsgByID(800)
      return
    end
    if GameConfig.ShortcutFuncParam and GameConfig.ShortcutFuncParam[sdata.id] then
      FuncShortCutFunc.Me():CallByID(sdata.UseMode, GameConfig.ShortcutFuncParam[sdata.id], nil, nil, nil, data and data.cellCtl)
    else
      FuncShortCutFunc.Me():CallByID(sdata.UseMode, data.id, nil, nil, nil, data and data.cellCtl)
    end
    return
  end
  if not ItemsWithRoleStatusChange.Instance():ItemIsCouldUseWithCurrentStatus(sdata.Type, sdata.id) then
    return
  end
  if data:IsLimitUse() then
    return
  end
  if DungeonProxy.Instance:CheckRoguelikeItemUsable(sdata.id) then
    if sdata.id == 5901 then
      local deadPlayerCount, player = 0, nil
      local memberList = TeamProxy.Instance.myTeam:GetPlayerMemberList(true, true)
      for i = 1, #memberList do
        if memberList[i]:IsRobotMember() then
          player = NSceneNpcProxy.Instance:Find(memberList[i].id)
        else
          player = NSceneUserProxy.Instance:Find(memberList[i].id)
        end
        if player and player:IsDead() then
          deadPlayerCount = deadPlayerCount + 1
        end
      end
      if deadPlayerCount == 0 then
        MsgManager.ShowMsgByID(40721)
        return
      end
    elseif DungeonProxy.Instance:CheckIsInTarotProgress() then
      local forbidItems = GameConfig.Roguelike.TarotRoomForbidItems
      if forbidItems and 0 < TableUtility.ArrayFindIndex(forbidItems, sdata.id) then
        MsgManager.ShowMsgByID(26267)
        return
      end
    end
  end
  local useItem = Table_UseItem[sdata.id]
  if useItem then
    local useEffect = useItem.UseEffect
    if useEffect.type == "unlockpetwear" then
      local isUnlock = PetComposeProxy.Instance:IsItemUnlock(useEffect.body, useEffect.pos, useEffect.itemid)
      if isUnlock then
        MsgManager.ShowMsgByID(31001)
        return
      end
    end
    if useEffect.type == "equip" then
      if useEffect.refine ~= nil and useEffect.pos ~= nil then
        local euqipData = BagProxy.Instance.roleEquip:GetEquipBySite(useEffect.pos)
        if euqipData == nil then
          MsgManager.ShowMsgByID(8001)
          return
        end
        local refinelv = useEffect.refinelv
        if refinelv < euqipData.equipInfo.refinelv then
          MsgManager.ShowMsgByID(1358)
          return
        end
        local maxRefinelv = BlackSmithProxy.Instance:MaxRefineLevelByData(euqipData.staticData)
        if maxRefinelv < useEffect.refinelv then
          MsgManager.ShowMsgByID(1358)
          return
        end
        if useEffect.new == 1 and not euqipData.equipInfo:IsNextGen() then
          MsgManager.ShowMsgByID(1361)
          return
        end
        if useEffect.refusedamage == 1 and euqipData.equipInfo.damage then
          MsgManager.ShowMsgByID(26106)
          return
        end
        if type(useItem.UsingSys) == "number" then
          MsgManager.ConfirmMsgByID(useItem.UsingSys, function()
            FunctionItemFunc.DoUseItem(data, target, count)
          end, nil, nil, euqipData:GetName(), refinelv)
        else
          FunctionItemFunc.DoUseItem(data, target, count)
        end
        return
      end
    elseif useEffect.type == "manual" then
      if useEffect.method == "card" then
        if not FunctionUnLockFunc.Me():CheckCanOpen(Adventure_Card_MenuId) then
          MsgManager.FloatMsgTableParam(nil, ZhString.FunctionItemFunc_UseFail)
          return
        end
        local quality, cardtype, cardtypenew = useEffect.quality, useEffect.cardtype, useEffect.cardtypenew
        local hasLockedCard = false
        if quality then
          for _, sq in pairs(quality) do
            if cardtype then
              for _, t in pairs(cardtype) do
                if AdventureDataProxy.Instance:HasLockedCard(sq, t) then
                  hasLockedCard = true
                  break
                end
              end
            end
            if cardtypenew then
              for _, t in pairs(cardtypenew) do
                if AdventureDataProxy.Instance:HasLockedCard(sq, nil, t) then
                  hasLockedCard = true
                  break
                end
              end
            end
          end
        end
        if not hasLockedCard then
          if useItem.UsingSys then
            local apology = useEffect.apology
            MsgManager.ConfirmMsgByID(useItem.UsingSys, function()
              FunctionItemFunc.DoUseItem(data, target, count)
            end, nil, nil, apology)
          else
            FunctionItemFunc.DoUseItem(data, target, count)
          end
        else
          FunctionItemFunc.DoUseItem(data, target, count)
        end
        return
      end
    elseif useEffect.type == "lottery" then
      if useEffect.method == "bag" then
        local c = LotteryProxy.Instance:GetLotteryBuyCnt()
        count = count or 1
        ServiceItemProxy.Instance:CallLotteryCmd(nil, nil, nil, true, nil, nil, LotteryType.Head, count, nil, nil, data.id, c)
      elseif type(useItem.UsingSys) == "number" then
        local viewdata = {
          viewname = "UseLotteryItemPopUp",
          itemdata = data,
          count = count,
          sysMsgId = useItem.UsingSys,
          rarity = useEffect.rarity
        }
        GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
      else
        FunctionItemFunc.DoUseItem(data, target, count)
      end
      return
    elseif useEffect.type == "redeemCode" then
      FunctionSecurity.Me():RedeemCode(function()
        GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.RedeemCodeView,
          viewdata = {
            id = sdata.id
          }
        })
      end)
      return
    elseif useEffect.type == "marriageproposal" then
      if target ~= nil and FriendProxy.Instance:IsInBlacklist(target.id) then
        MsgManager.ShowMsgByIDTable(464)
        return
      end
    elseif useEffect.type == "tower" then
      if not FunctionUnLockFunc.Me():CheckCanOpen(26) then
        MsgManager.ShowMsgByID(56)
        return false
      end
      local min, max = useEffect.min, useEffect.max
      local effectlayers = ""
      local endlessTowerProxy = EndlessTowerProxy.Instance
      local allWeekChallenged = true
      local allHistoryNoChallenged = true
      local allHistoryAllChallenged = true
      for i = min, max do
        local hasChallenged = endlessTowerProxy:IsCurLayerHasChallenged(i)
        if hasChallenged then
          allHistoryNoChallenged = false
          local mylayerInfo = endlessTowerProxy:GetMyLayersInfo(i)
          if mylayerInfo == nil or not mylayerInfo.rewarded then
            allWeekChallenged = false
            if effectlayers == "" then
              effectlayers = tostring(i)
            else
              effectlayers = effectlayers .. "," .. i
            end
          end
        else
          allHistoryAllChallenged = false
        end
      end
      if useEffect.check and useEffect.check == 1 and allHistoryNoChallenged then
        MsgManager.ShowMsgByID(59)
        return false
      end
      if useEffect.check and useEffect.check == 1 and allWeekChallenged then
        MsgManager.ShowMsgByID(57)
        return false
      end
      if useEffect.check and useEffect.check == 1 and not allHistoryAllChallenged then
        MsgManager.ShowMsgByID(130)
        return false
      elseif useEffect.check and useEffect.check == 2 and not endlessTowerProxy:IsCurLayerHasChallenged(100) then
        MsgManager.ShowMsgByID(130)
        return false
      end
      if useEffect.check and useEffect.check == 2 then
        MsgManager.ConfirmMsgByID(68, function()
          ServiceItemProxy.Instance:CallItemUse(data, nil, count)
        end, nil, nil)
      else
        MsgManager.ConfirmMsgByID(65, function()
          ServiceItemProxy.Instance:CallItemUse(data, nil, count)
        end, nil, nil, effectlayers)
      end
      return true
    elseif useEffect.type == "loveletter" then
      local pTarget = Game.Myself:GetLockTarget()
      local pGuild
      if pTarget then
        pGuild = pTarget.data.id
      end
      StarProxy.Instance:CacheData(data, pTarget)
      ServiceNUserProxy.Instance:CallCheckRelationUserCmd(pGuild, SocialManager.PbRelation.Friend)
      return
    elseif useEffect.type == "addhandnpc" then
      local isholding = Game.Myself:IsPlayingHoldAction() or Game.Myself:IsPlayingHoldMoveAction()
      helplog("isholding:", isholding)
      if isholding then
        MsgManager.ShowMsgByID(933)
        return
      end
      FunctionItemFunc.DoUseItem(data, target, count)
      return
    elseif useEffect.type == "addresist" then
      local confirmMsg = useItem.UsingSys
      local dailyData = QuestProxy.Instance:getDailyQuestData(SceneQuest_pb.EOTHERDATA_DAILY)
      if dailyData then
        local pcount = dailyData.param1
        local pcurCount = dailyData.param2
        if pcount and pcurCount then
          local leftCount = pcount - pcurCount
          if leftCount >= 6 then
            MsgManager.ShowMsgByIDTable(26017)
            return
          elseif leftCount > 4 then
            MsgManager.ConfirmMsgByID(confirmMsg, function()
              FunctionItemFunc.DoUseItem(data, target, count)
            end, nil, nil, leftCount)
            return
          end
        end
      end
      FunctionItemFunc.DoUseItem(data, target, count)
      return
    elseif useEffect.type == "addtutorbattletime" then
      ServiceNUserProxy.Instance:CallBattleTimelenUserCmd()
      BagProxy.Instance:SaveBattleTimeItem(data)
      BagProxy.Instance.callBattletime = true
      return
    elseif useEffect.type == "addbaseexp" then
      count = count or 1
      local tempExpNeed = MyselfProxy.Instance:GetTotalNeedBaseExp()
      if tempExpNeed < useEffect.num * count then
        MsgManager.ConfirmMsgByID(3399, function()
          FunctionItemFunc.DoUseItem(data, target, count)
        end)
        return
      else
        FunctionItemFunc.DoUseItem(data, target, count)
        return
      end
    elseif useEffect.type == "addjobexp" then
      count = count or 1
      local tempJobExpNeed = MyselfProxy.Instance:GetTotalNeedJobExp()
      if tempJobExpNeed < useEffect.num * count then
        MsgManager.ConfirmMsgByID(3399, function()
          FunctionItemFunc.DoUseItem(data, target, count)
        end)
        return
      else
        FunctionItemFunc.DoUseItem(data, target, count)
        return
      end
    elseif useEffect.type == "reward" then
      count = count or 1
      local items = ItemUtil.GetRewardItemIdsByTeamId(useEffect.id)
      for _, item in pairs(items) do
        if item.id == 300 then
          local tempExpNeed = MyselfProxy.Instance:GetTotalNeedBaseExp()
          if tempExpNeed < item.num * count then
            MsgManager.ConfirmMsgByID(3399, function()
              FunctionItemFunc.DoUseItem(data, target, count)
            end)
            return
          else
            FunctionItemFunc.DoUseItem(data, target, count)
            return
          end
        elseif item.id == 400 then
          local tempJobExpNeed = MyselfProxy.Instance:GetTotalNeedJobExp()
          if tempJobExpNeed < item.num * count then
            MsgManager.ConfirmMsgByID(3399, function()
              FunctionItemFunc.DoUseItem(data, target, count)
            end)
            return
          else
            FunctionItemFunc.DoUseItem(data, target, count)
            return
          end
        elseif item.id == 12904 then
          local value = Game.Myself.data.userdata:Get(UDEnum.NIGHTMARE)
          local limit = GameConfig.Nightmare.NightmareMax or 15000
          if limit < item.num * count + value then
            MsgManager.ConfirmMsgByID(3399, function()
              FunctionItemFunc.DoUseItem(data, target, count)
            end)
            return
          else
            FunctionItemFunc.DoUseItem(data, target, count)
            return
          end
        end
      end
    elseif useEffect.type == "deathfalvor" then
      if useEffect.method == "addexp" then
        if not FunctionUnLockFunc.Me():CheckCanOpen(451) then
          MsgManager.ShowMsgByID(40301)
          return
        end
        local deadCoin = Game.Myself.data.userdata:Get(UDEnum.DEADCOIN)
        if deadCoin >= GameConfig.Dead.max_deadcoin then
          MsgManager.ShowMsgByID(40303)
          return
        end
        local exp = useEffect.dead_exp
        if deadCoin + exp >= GameConfig.Dead.max_deadcoin then
          MsgManager.ConfirmMsgByID(40304, function()
            FunctionItemFunc.DoUseItem(data, target, count)
          end)
          return
        end
      end
      FunctionItemFunc.DoUseItem(data, target, count)
      return
    elseif useEffect.type == "selectreward" then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.OptionalGiftRewardView,
        viewdata = {
          gift = sdata.id,
          reward = useEffect.item
        }
      })
      return
    elseif useEffect.type == "recommendreward" then
      if useEffect.classlimit and useEffect.classlimit == 1 then
        if ProfessionProxy.GetJobDepth() < 2 then
          MsgManager.ShowMsgByID(43155)
        else
          GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
            view = PanelConfig.RecommendRewardView,
            viewdata = {
              gift = sdata.id,
              reward = useEffect.item,
              useCount = count
            }
          })
        end
      else
        GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.RecommendRewardView,
          viewdata = {
            gift = sdata.id,
            reward = useEffect.item,
            useCount = count
          }
        })
      end
      return
    elseif useEffect.type == "refine" then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.HeadwearRefinePanel,
        viewdata = {
          useItemId = sdata.id
        }
      })
      return
    elseif useEffect.type == "signin" then
      local nowCfg = ActivitySignInProxy.Instance:GetNowConfigData()
      if not nowCfg then
        return
      end
      if ActivitySignInProxy.Instance.signedCount >= nowCfg.SignInMax then
        MsgManager.ShowMsgByID(40546)
        return
      end
      if not ActivitySignInProxy.Instance.isTodaySigned then
        MsgManager.ShowMsgByID(40547)
        return
      end
    elseif useEffect.type == "openurl" then
      if useEffect.url then
        Application.OpenURL(useEffect.url)
      end
      return
    elseif useEffect.type == "client_transport" then
      mapid = SceneProxy.Instance:GetCurMapID()
      if data and not data:CheckMapLimit(mapid) then
        MsgManager.ShowMsgByID(40700)
        return
      end
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.TeleportToyPopUp,
        viewdata = data
      })
      return
    elseif useEffect.type == "randpos" then
      Game.Myself:ConfirmUseItem_RandPos(function()
        FunctionItemFunc.DoUseItem(data, target, count)
      end)
      return
    elseif useEffect.type == "summon" and useEffect.edit_dialog then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.NPCHeadMsgInputView,
        viewdata = {
          data = data,
          msgType = 2,
          npcdata = useEffect.id
        }
      })
      return
    elseif useEffect.type == "addexpraidreward" then
      GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.TipLayer)
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.ExpRaidQuickFinishChooseView,
        viewdata = data
      })
      return
    elseif useEffect.type == "musical_harp" then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.HarpView
      })
      return
    elseif useEffect.type == "pray_level_up" then
      local func = function()
        FunctionItemFunc.DoUseItem(data, target, count)
      end
      local limitLv = useEffect.up_limit
      local toLv = 0
      if limitLv ~= nil then
        toLv = useEffect.up_level == nil and 0 or useEffect.up_level
        local checkRetList = {}
        local msgTxt = ""
        for _, prayId in pairs(useEffect.pray_id) do
          local ret = GuildPrayProxy.Instance:TryGoddessPrayAddLevel(prayId, toLv, limitLv)
          table.insert(checkRetList, ret)
          if ret.msg ~= nil then
            msgTxt = msgTxt .. string.format(ZhString.ItemTip_CHBracket, ret.msg .. ZhString.GPrayTypeCell_Pray)
          end
        end
        local b = true
        for _, v in ipairs(checkRetList) do
          b = b and v.flag
        end
        if b then
          MsgManager.ConfirmMsgByID(41200, func)
        elseif msgTxt ~= "" and msgTxt ~= nil then
          MsgManager.ConfirmMsgByID(41236, func, nil, nil, msgTxt)
        else
          func()
        end
      else
        toLv = useEffect.to_level
        local b = true
        for _, prayId in pairs(useEffect.pray_id) do
          b = b and GuildPrayProxy.Instance:CheckGoddessPrayReachedLevel(prayId, toLv)
        end
        if b then
          MsgManager.ConfirmMsgByID(41200, func)
        else
          func()
        end
      end
      return
    elseif useEffect.type == "quest" then
      if useEffect.action == "complete" then
        MsgManager.ConfirmMsgByID(28092, function()
          FunctionItemFunc.DoUseItem(data, target, count)
        end, nil, nil)
        return
      end
    elseif useEffect.type == "play_plot" then
      if useEffect.id then
        Game.PlotStoryManager:Start_PQTLP(useEffect.id, nil, nil, nil, false, nil, nil, false)
      end
      return
    end
    if type(useItem.UsingSys) == "number" then
      MsgManager.ConfirmMsgByID(useItem.UsingSys, function()
        FunctionItemFunc.DoUseItem(data, target, count)
      end, nil, nil)
    else
      FunctionItemFunc.DoUseItem(data, target, count)
    end
  elseif DungeonProxy.GetRoguelikeItemMaxLevel(sdata.id) == 1 then
    FunctionItemFunc.DoUseItem(data, target, count)
  else
    errorLog(string.format("Item:%s not Config in Table_UseItem", sdata.id))
    ServiceItemProxy.Instance:CallItemUse(data)
  end
end
local mapid, tipid
function FunctionItemFunc.DoUseItem(data, target, count)
  if not data then
    redlog("DoUseItem data is nil")
    return
  end
  local sdata = data.staticData
  mapid = SceneProxy.Instance:GetCurMapID()
  if not data:CheckMapLimit(mapid) then
    tipid = data:GetMapLimitTipID()
    if not tipid or tipid == 0 then
      MsgManager.ShowMsgByID(40700)
    else
      MsgManager.ShowMsgByID(tipid)
    end
    return
  end
  local realTarget = target or Game.Myself:GetLockTarget()
  local itemTarget = data.staticData.ItemTarget
  local st = itemTarget.type
  local needShowTipBord = false
  if st ~= nil then
    if realTarget == nil then
      needShowTipBord = true
    else
      local creatureType = realTarget:GetCreatureType()
      if Creature_Type.Player == creatureType and not data:CanUseForTarget(ItemTarget_Type.Player) then
        needShowTipBord = true
      elseif Creature_Type.Npc == creatureType then
        if realTarget.data:IsNpc() and not realTarget.data:IsRobotNpc() and not data:CanUseForTarget(ItemTarget_Type.Npc) then
          needShowTipBord = true
        elseif realTarget.data:IsMonster() and not realTarget.data:IsRobotNpc() and not data:CanUseForTarget(ItemTarget_Type.Monster) then
          needShowTipBord = true
        elseif realTarget.data:IsMonster() and not realTarget.data:IsRobotNpc() and not data:CanUseForTarget(ItemTarget_Type.Monster, nil, realTarget.data:GetDetailedType()) then
          needShowTipBord = true
        end
      end
    end
  end
  if needShowTipBord then
    local useTipData = {}
    useTipData.type = QuickUseProxy.Type.Item
    useTipData.data = data
    GameFacade.Instance:sendNotification(ItemEvent.ItemUseTip, useTipData)
    GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.NormalLayer)
    GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.ChitchatLayer)
    return false
  end
  local inRange = true
  if itemTarget.range and realTarget ~= nil then
    local myPos, targetPos = Game.Myself:GetPosition(), realTarget:GetPosition()
    inRange = LuaVector3.Distance_Square(myPos, targetPos) <= itemTarget.range * itemTarget.range
  end
  if not inRange then
    Game.Myself:Client_AccessTarget(realTarget, data, nil, AccessCustomType.UseItem, itemTarget.range)
    return false
  end
  local useItem = Table_UseItem[sdata.id]
  if not useItem and Game.MapManager:IsPVEMode_Roguelike() then
    for _, d in pairs(Table_RoguelikeItem) do
      if d.ItemID == sdata.id then
        useItem = d
        break
      end
    end
  end
  if useItem and useItem.UseEffect then
    if useItem.UseInterval and data.CanIntervalUse and not data:CanIntervalUse() then
      MsgManager.ShowMsgByID(27030)
      return
    end
    local useEffectType = useItem.UseEffect.type
    if useEffectType == "client_useskill" then
      if sdata.id == 50001 then
        FunctionSystem.WeakInterruptMyself()
        FunctionSystem.InterruptMyselfAI()
      end
      local confirmMsg = 0
      if sdata.id == 50001 or sdata.id == 50002 then
        local raidReward = MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_HAS_USERRETURN_RAID_AWARD) or 0
        if raidReward > 0 then
          confirmMsg = 42085
        end
      end
      if confirmMsg > 0 then
        MsgManager.ConfirmMsgByID(confirmMsg, function()
          FunctionSkill.Me():TryUseSkill(useItem.UseEffect.id, realTarget, true)
          GameFacade.Instance:sendNotification(ItemEvent.ItemUse, useItem)
        end, nil)
      else
        FunctionSkill.Me():TryUseSkill(useItem.UseEffect.id, realTarget, true)
        GameFacade.Instance:sendNotification(ItemEvent.ItemUse, useItem)
      end
      return true
    elseif useEffectType == "catchpet" then
      local npcids = useItem.UseEffect.npcid
      local npcIsRight = false
      if realTarget then
        for i = 1, #npcids do
          if npcids[i] == realTarget.data.staticData.id then
            npcIsRight = true
            break
          end
        end
      end
      if not npcIsRight then
        MsgManager.ShowMsgByID(711)
        return false
      end
      local targetId = realTarget and realTarget.data.id
      ServiceItemProxy.Instance:CallItemUse(data, targetId, count)
      return true
    elseif useEffectType == "settowermaxlayer" then
      if not FunctionUnLockFunc.Me():CheckCanOpen(26) then
        MsgManager.ShowMsgByID(3400)
        return false
      end
      MsgManager.ConfirmMsgByID(3403, function()
        ServiceItemProxy.Instance:CallItemUse(data, nil, count)
      end, nil, nil, data:GetName())
      return true
    elseif useEffectType == "random_effect" then
      local mySceneUI = Game.Myself:GetSceneUI()
      if not mySceneUI then
        LogUtility.Warning("Cannot find SceneUI of myself when throwing the dice!!")
        return false
      end
      local effectIndex = useItem.UseEffect.effectIndex or 1
      local effectConfig = GameConfig.UseItemRandomEffect and GameConfig.UseItemRandomEffect[effectIndex]
      if effectConfig and effectIndex ~= 1 then
        local effectName = effectConfig.effect
        local randomMax = effectConfig.max
        if randomMax == 1 then
          local assetRole = Game.Myself.assetRole
          assetRole:PlayEffectOneShotOn(effectName, RoleDefines_EP.Top)
        else
          local result = math.clamp(Game.Myself.data:GetRandom() % randomMax + 1, 1, randomMax)
          mySceneUI.roleTopUI:PlayTopSpine(ResourcePathHelper.Public(effectName), "animation" .. result, 1, 2, Game.Myself)
        end
      else
        local result = math.clamp(Game.Myself.data:GetRandom() % 6 + 1, 1, 6)
        mySceneUI.roleTopUI:PlayTopSpine(ResourcePathHelper.SceneEmoji(EffectMap.Emoji.dice), "animation" .. result, 1, 2, Game.Myself)
      end
    elseif useEffectType == "rand_select_reward" then
      ServiceItemProxy.Instance:CallItemUse(data, nil, count, 0)
      return true
    elseif useEffectType == "show_local_npc_pos" then
      GameFacade.Instance:sendNotification(SceneUserEvent.ShowLocalNpcPos, useItem.UseEffect.npcid)
    end
  end
  if DungeonProxy.Instance:CheckRoguelikeItemUsable(sdata.id) then
    DungeonProxy.RoguelikeUseItem(sdata.id, count)
    return true
  end
  if TwelvePvPProxy.Instance:CheckCanUseRaidItem(sdata.id) then
    ServiceFuBenCmdAutoProxy:CallTwelvePvpUseItemCmd(sdata.id, count)
    return true
  end
  local targetId = realTarget and realTarget.data.id
  ServiceItemProxy.Instance:CallItemUse(data, targetId, count)
  GameFacade.Instance:sendNotification(ItemEvent.ItemUse, useItem)
  return true
end
function FunctionItemFunc.PickUpFromTempBag(data)
  if data and BagProxy.Instance:CheckItemCanPutIn(nil, data.staticData.id, nil, true) then
    ServiceItemProxy.Instance:CallEquip(SceneItem_pb.EEQUIPOPER_OFFTEMP, nil, data.id)
  end
end
function FunctionItemFunc.OpenBarrowBag(data)
  local myPro = Game.Myself.data.userdata:Get(UDEnum.PROFESSION)
  if not data.equipInfo:CanUseByProfess(myPro) then
    return
  end
  GameFacade.Instance:sendNotification(PackageEvent.OpenBarrowBag)
end
function FunctionItemFunc.PutInBarrow(data, count)
  if not data:CanStorage(BagProxy.BagType.Barrow) then
    local sBagType = ZhString.ItemTip_BarrowStorage
    MsgManager.ShowMsgByIDTable(3807, sBagType)
    return
  end
  if count == 0 or count == nil then
    ServiceItemProxy.Instance:CallEquip(SceneItem_pb.EEQUIPOPER_PUTBARROW, nil, data.id, nil, data.num)
  else
    ServiceItemProxy.Instance:CallEquip(SceneItem_pb.EEQUIPOPER_PUTBARROW, nil, data.id, nil, count)
  end
end
function FunctionItemFunc.PutBackBarrow(data, count)
  if count == 0 or count == nil then
    ServiceItemProxy.Instance:CallEquip(SceneItem_pb.EEQUIPOPER_OFFBARROW, nil, data.id, nil, data.num)
  else
    ServiceItemProxy.Instance:CallEquip(SceneItem_pb.EEQUIPOPER_OFFBARROW, nil, data.id, nil, count)
  end
end
function FunctionItemFunc.Adventure(data)
  FunctionItemFunc.DoUseItem(data)
end
function FunctionItemFunc.PutFood_Public(data, count)
  ServiceSceneFoodProxy.Instance:CallPutFood(data.id, SceneFood_pb.EEATPOWR_ALL, count, false)
end
function FunctionItemFunc.PutFood_Team(data, count)
  ServiceSceneFoodProxy.Instance:CallPutFood(data.id, SceneFood_pb.EEATPOWR_TEAM, count, false)
end
function FunctionItemFunc.PutFood_Self(data, count)
  local foodList = FoodProxy.Instance:GetEatFoods()
  local currentEatFoodCount = #foodList
  local overrideNotice = LocalSaveProxy.Instance:GetFoodBuffOverrideNoticeShow()
  local level = Game.Myself.data.userdata:Get(UDEnum.TASTER_LV)
  local tasteLvInfo = Table_TasterLevel[level]
  local foodMaxCount = 3
  if tasteLvInfo then
    foodMaxCount = tasteLvInfo.AddBuffs
  end
  local item = BagProxy.Instance:GetItemByGuid(data.id)
  local itemId = item.staticData.id
  if overrideNotice and foodMaxCount < currentEatFoodCount + count and itemId ~= 551019 then
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
      viewname = "FoodOverridePopView",
      foodItemId = itemId,
      foodGuid = data.id,
      foodCount = count
    })
  else
    ServiceSceneFoodProxy.Instance:CallPutFood(data.id, SceneFood_pb.EEATPOWR_SELF, count, false)
  end
end
function FunctionItemFunc.PutFood_Pet(data, count)
  ServiceSceneFoodProxy.Instance:CallPutFood(data.id, SceneFood_pb.EEATPOWR_SELF, count, true)
end
function FunctionItemFunc.Hatch(data)
  local petInfoData = PetProxy.Instance:GetMyPetInfoData()
  local eggInfo = data.petEggInfo
  if eggInfo ~= nil and eggInfo.name ~= "" then
    ServiceScenePetProxy.Instance:CallEggHatchPetCmd(nil, data.id)
  else
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.PetMakeNamePopUp,
      viewdata = {etype = 1, item = data}
    })
  end
end
function FunctionItemFunc.Open_Letter(data)
  if data:IsLoveLetter() then
    local panel = StarProxy.Instance:GetPanelConfig(data.loveLetter.type)
    if panel ~= nil then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = panel,
        viewdata = data.loveLetter
      })
    end
  end
end
function FunctionItemFunc.Open_MarriageManual(data)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.WeddingManualMainView,
    viewdata = data
  })
end
function FunctionItemFunc.Open_MarriageCertificate(data)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.MarriageCertificate,
    viewdata = data
  })
end
function FunctionItemFunc.UnloadPetEquip(data)
  ServiceScenePetProxy.super.CallEquipOperPetCmd(self, ScenePet_pb.EPETEQUIPOPER_OFF)
end
function FunctionItemFunc.Send_WeddingDress(data)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.WeddingDressSendView,
    viewdata = data.id
  })
end
function FunctionItemFunc.OpenRegistTicket(data)
  local codeData = data.CodeData
  local staticData = data.staticData
  if not staticData then
    helplog("服务器发来的数据是 null")
    return
  end
  local id = staticData.id
  local useData = Table_UseItem[id]
  if not useData then
    helplog("Table_UseItem 表里没配 请策划检查")
    return
  end
  local startTime = useData.UseStartTime
  local endTime = useData.UseEndTime
  local p = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
  local year, month, day, hour, min, sec = startTime:match(p)
  local startTs = os.time({
    day = day,
    month = month,
    year = year,
    hour = hour,
    min = min,
    sec = sec
  })
  year, month, day, hour, min, sec = endTime:match(p)
  local endTs = os.time({
    day = day,
    month = month,
    year = year,
    hour = hour,
    min = min,
    sec = sec
  })
  local server = ServerTime.CurServerTime() / 1000
  helplog("startTime:", startTime, "endTime:", endTime)
  helplog("currentTime:", os.date("%Y-%m-%d %H:%M:%S", server))
  if startTs > server or endTs < server then
    MsgManager.ShowMsgByIDTable(25316)
    return
  end
  if codeData and codeData.code and codeData.code ~= "" then
    local functionSdk = FunctionLogin.Me():getFunctionSdk()
    local url = ""
    if functionSdk and functionSdk:getToken() then
      url = string.format(ZhString.KFCShareURL, Game.Myself.data.id, codeData.code, functionSdk:getToken())
    else
      url = ZhString.KFCShareURL_BeiFen
    end
    Application.OpenURL(url)
    helplog("kfc url:" .. url)
  else
    ItemUtil.SetUseCodeCmd(data)
    ServiceItemProxy.Instance:CallUseCodItemCmd(data.id)
  end
end
local tipEquips = {}
local rv_Items = {}
function FunctionItemFunc.RecoverEquips(equipItems, confirmCall, cancelCall)
  if equipItems == nil then
    return false, _EmptyTable
  end
  local recoverNames, recoverCost = "", 0
  TableUtility.ArrayClear(tipEquips)
  TableUtility.ArrayClear(rv_Items)
  for i = 1, #equipItems do
    local equipItem = equipItems[i]
    if equipItem.equipInfo.refinelv >= GameConfig.Item.material_max_refine then
      table.insert(tipEquips, equipItem)
    end
    local sCost = EquipUtil.GetRecoverCost(equipItem, true, true, true, true, true)
    if sCost > 0 then
      recoverCost = recoverCost + sCost
      recoverNames = recoverNames .. " " .. equipItem:GetName()
      table.insert(rv_Items, equipItem)
    end
  end
  if #rv_Items > 0 then
    local confirmHandler = function()
      local myRob = MyselfProxy.Instance:GetROB()
      if myRob < recoverCost then
        MsgManager.ShowMsgByIDTable(1)
        return
      end
      for i = 1, #rv_Items do
        local item = rv_Items[i]
        local cardids = {}
        local equipedCards = item.equipedCardInfo
        if equipedCards then
          for j = 1, item.cardSlotNum do
            if equipedCards[j] then
              table.insert(cardids, equipedCards[j].id)
            end
          end
        end
        local equipInfo = item.equipInfo
        local hasenchant = item.enchantInfo and item.enchantInfo:HasAttri() or false
        local hasupgrade = equipInfo.equiplv > 0
        ServiceItemProxy.Instance:CallRestoreEquipItemCmd(item.id, false, cardids, hasenchant, hasupgrade, false)
        if confirmCall then
          confirmCall()
        end
      end
    end
    MsgManager.DontAgainConfirmMsgByID(246, confirmHandler, function()
      if cancelCall then
        cancelCall()
      end
    end, nil, recoverNames, recoverCost)
    return true, tipEquips
  end
  return false, tipEquips
end
function FunctionItemFunc.EmbedGem()
  if not GemProxy.CheckGemIsUnlocked(true) then
    return
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.GemContainerView
  })
end
function FunctionItemFunc.AppraiseGem()
  if not GemProxy.CheckGemIsUnlocked(true) then
    return
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.GemContainerView,
    viewdata = {
      page = "GemAppraisePage"
    }
  })
end
function FunctionItemFunc.HomeCompose(data)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.HomeTipPopUp,
    viewdata = data
  })
end
function FunctionItemFunc.HomeStoreIn(data, count)
  HomeManager.Me():TryPutHomeStore(data, count)
end
function FunctionItemFunc.HomeStoreOut(data, count)
  HomeManager.Me():TryPutOffHomeStore(data, count)
end
function FunctionItemFunc.ShowCoupleCode(data, count)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.CouponCodeView,
    viewdata = data
  })
end
function FunctionItemFunc.UseSkillItem(data)
  FunctionItemFunc.ItemUseEvt(data)
end
function FunctionItemFunc.QuickMake(data)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.QuickMakePopUp,
    viewdata = data.staticData.id
  })
end
function FunctionItemFunc.TwentyOneDaysDevelop()
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.SignIn21View
  })
end
function FunctionItemFunc.PersonalArtifactIdentify(data, count)
  if not FunctionUnLockFunc.Me():CheckCanOpen(GameConfig.SystemOpen_MenuId.PersonalArtifactAttr) then
    MsgManager.ShowMsgByID(41404)
    return
  end
  if not count or count <= 0 then
    count = 1
  end
  local bagIns = BagProxy.Instance
  if bagIns:CheckBagIsFull(BagProxy.BagType.PersonalArtifact) or bagIns:CheckBagIsFull(BagProxy.BagType.PersonalArtifactFragment) then
    MsgManager.ShowMsgByID(41339)
    return
  end
  ServiceItemProxy.Instance:CallPersonalArtifactAppraisalItemCmd(data.staticData.id, count)
end
function FunctionItemFunc.PersonalArtifactPutIn(data, count)
  if not count or count <= 0 then
    return
  end
  GameFacade.Instance:sendNotification(PersonalArtifactDecomposeEvent.PutIn, {data = data, count = count})
end
function FunctionItemFunc.AutoHealing(data)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.SetAutoHealingView
  })
end
function FunctionItemFunc:CheckFuncState(key, itemdata)
  if not key then
    return
  end
  if self.checkMap[key] then
    return self.checkMap[key](itemdata)
  end
  return ItemFuncState.Active
end
function FunctionItemFunc:SetLeftViewState(s)
  self.viewState = s
end
function FunctionItemFunc:GetLeftViewState()
  return self.viewState
end
function FunctionItemFunc.CheckApply(itemdata)
  local sData = itemdata and itemdata.staticData
  if sData then
    local typeData = Table_ItemType[sData.Type]
    if typeData and typeData.UseNumber then
      return ItemFuncState.Active
    end
    local access = GainWayTipProxy.Instance:GetItemAccessByItemId(sData.id)
    if access ~= nil then
      return ItemFuncState.InActive
    end
    if sData.UseMode or Table_UseItem[sData.id] then
      return ItemFuncState.Active
    end
    if DungeonProxy.GetRoguelikeItemMaxLevel(sData.id) == 1 and DungeonProxy.Instance:CheckRoguelikeItemUsable(sData.id) then
      return ItemFuncState.Active
    end
  end
  return ItemFuncState.InActive
end
function FunctionItemFunc.CheckEquip(itemdata)
  if itemdata and itemdata:CanEquip() then
    return ItemFuncState.Active
  end
  return ItemFuncState.InActive
end
function FunctionItemFunc.CheckInlay(itemdata)
  if itemdata.cardInfo ~= nil then
    return ItemFuncState.Active
  end
  if itemdata and itemdata.cardSlotNum and itemdata.cardSlotNum > 0 then
    return ItemFuncState.Active
  end
  return ItemFuncState.InActive
end
function FunctionItemFunc.CheckCombine(itemdata)
  local combineid = itemdata and itemdata.staticData.ComposeID
  if combineid then
    local maxNum = FunctionItemFunc._GetCombineMaxNum(itemdata.staticData.id)
    if maxNum >= 1 then
      return ItemFuncState.Active
    end
  end
  return ItemFuncState.InActive
end
function FunctionItemFunc.CheckMakePic(itemdata)
  local combineid = itemdata and itemdata.staticData.ComposeID
  if combineid and combineid ~= nil and Table_Compose[combineid] then
    return ItemFuncState.Active
  end
  return ItemFuncState.InActive
end
function FunctionItemFunc.CheckGotoUse(itemdata)
  local access = GainWayTipProxy.Instance:GetItemAccessByItemId(itemdata.staticData.id)
  if access ~= nil then
    return ItemFuncState.Active
  end
  return ItemFuncState.InActive
end
function FunctionItemFunc.CheckSend_WeddingDress(itemdata)
  if itemdata.sender_charid ~= nil then
    return ItemFuncState.InActive
  end
  return ItemFuncState.Active
end
function FunctionItemFunc.CheckPutFoodPet(itemdata)
  local pet = PetProxy.Instance:GetMySceneNpet()
  if pet == nil then
    return ItemFuncState.InActive
  end
  return ItemFuncState.Active
end
function FunctionItemFunc.CheckPutFood(itemData)
  if Game.MapManager:IsPVPMode_TeamPws() then
    return ItemFuncState.InActive
  end
  if Game.MapManager:IsPvPMode_TeamTwelve() then
    return ItemFuncState.InActive
  end
  return ItemFuncState.Active
end
function FunctionItemFunc.CheckHomeCompose(itemData)
  local composeid = itemData.staticData.ComposeID
  if composeid == nil or Table_Compose[composeid] == nil then
    return ItemFuncState.InActive
  end
  return ItemFuncState.Active
end
function FunctionItemFunc.CheckHomeStoreIn(itemData)
  if not UIManagerProxy.Instance:HasUINode(PanelConfig.RepositoryView) then
    return ItemFuncState.InActive
  end
  return ItemFuncState.Active
end
function FunctionItemFunc.CheckHomeStoreOut(itemData)
  if not UIManagerProxy.Instance:HasUINode(PanelConfig.RepositoryView) then
    return ItemFuncState.InActive
  elseif itemData.homeOwnerId and itemData.homeOwnerId ~= FunctionLogin.Me():getLoginData().accid then
    return ItemFuncState.InActive
  end
  return ItemFuncState.Active
end
