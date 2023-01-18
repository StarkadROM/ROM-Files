autoImport("SoundItemCell")
autoImport("HappyShopBuyItemCell")
SoundItemChoosePopUp = class("SoundItemChoosePopUp", BaseView)
SoundItemChoosePopUp.ViewType = UIViewType.PopUpLayer
local soundItemId = "SoundItem"
local shopIns
function SoundItemChoosePopUp:Init()
  if not shopIns then
    shopIns = HappyShopProxy.Instance
  end
  self:InitData()
  self:InitUI()
  self:AddListenEvts()
end
function SoundItemChoosePopUp:InitData()
  self.playTipData = {
    customFuncConfig = {
      name = ZhString.QuickUsePopupFuncCell_UseBtn,
      needCountChoose = true,
      callback = function(id, count)
        self:DoPlay(id, count, self.npc and self.npc.data.id, self.furniture and self.furniture.data.id)
      end
    },
    callback = function(self)
      self.playTip = nil
    end,
    callbackParam = self
  }
  self.npc = self.viewdata.viewdata.npc
  if not self.npc then
    self.furniture = self.viewdata.viewdata.furniture
  end
  shopIns:InitShop(nil, 1, 3329)
end
function SoundItemChoosePopUp:InitUI()
  self.soundItemCtl = UIGridListCtrl.new(self:FindComponent("SoundListGrid", UIGrid), SoundItemCell, "SoundItemCell")
  self.soundItemCtl:AddEventListener(SoundItemCellEvent.Play, self.OnClickPlay, self)
  self.soundItemCtl:AddEventListener(SoundItemCellEvent.Buy, self.OnClickBuy, self)
  self:UpdateSoundItems()
  self:InitBuyCell()
end
function SoundItemChoosePopUp:AddListenEvts()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateSoundItems)
  self:AddListenEvt(ServiceEvent.NUserQueryMusicList, self.OnQueryMusicList)
  self:AddListenEvt(HomeEvent.SoundListUpdate, self.OnHouseListUpdate)
  self:AddListenEvt(HomeEvent.ExitHome, self.CloseSelf)
end
local comparer = function(a, b)
  local hasA = a.id ~= soundItemId
  local hasB = b.id ~= soundItemId
  if hasA ~= hasB then
    return hasA
  end
  return a.staticData.id < b.staticData.id
end
function SoundItemChoosePopUp:UpdateSoundItems()
  local soundItems, bagIns = ReusableTable.CreateArray(), BagProxy.Instance
  for _, mdata in pairs(Table_MusicBox) do
    local item = bagIns:GetItemByStaticID(mdata.id)
    if not item and mdata.SaleChannel ~= 0 then
      item = ItemData.new(soundItemId, mdata.id)
    end
    table.insert(soundItems, item)
  end
  table.sort(soundItems, comparer)
  self.soundItemCtl:ResetDatas(soundItems)
  ReusableTable.DestroyAndClearArray(soundItems)
end
function SoundItemChoosePopUp:InitBuyCell()
  local go = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("HappyShopBuyItemCell"))
  if not go then
    return
  end
  go.transform:SetParent(self.gameObject.transform, false)
  go.transform.localPosition = LuaGeometry.GetTempVector3(0, 8)
  self.buyCell = HappyShopBuyItemCell.new(go)
  self.buyCell.gameObject:SetActive(false)
end
function SoundItemChoosePopUp:OnClickPlay(cellctl)
  local data = cellctl and cellctl.data
  if not data then
    return
  end
  if self:GetRemainingMusicCountOfList() <= 0 then
    MsgManager.ShowMsgByID(42086)
    return
  end
  self.playTipData.itemdata = data
  self.playTipData.customFuncConfig.callbackParam = data.staticData.id
  self.playTip = self:ShowItemTip(self.playTipData, nil, NGUIUtil.AnchorSide.Up)
  self:TryUpdatePlayTip()
end
function SoundItemChoosePopUp:DoPlay(musicId, count, npcId, furnitureId)
  if not musicId or not Table_Item[musicId] then
    return
  end
  self:TryUpdatePlayTip()
  count = count or 1
  local remainingCount = self:GetRemainingMusicCountOfList()
  if count > remainingCount then
    MsgManager.ShowMsgByID(42086)
    return
  end
  for i = 1, count do
    if npcId then
      ServiceNUserProxy.Instance:CallDemandMusic(npcId, musicId)
    elseif furnitureId then
      ServiceHomeCmdProxy.Instance:CallFurnitureOperHomeCmd(HomeCmd_pb.EFURNITUREOPER_RADIO_DEMAND, furnitureId, musicId)
    end
  end
  redlog("SoundItemChoosePopUp ChoosePlay", musicId, count)
  AudioUtil.Play2DRandomSound(AudioMap.Maps.PlayMusic)
  TipManager.CloseTip()
  self:CloseSelf()
end
function SoundItemChoosePopUp:OnClickBuy(cellctl)
  if not cellctl.data then
    return
  end
  TipManager.CloseTip()
  local sid = cellctl.data.staticData.id
  local musicData = Table_MusicBox[sid]
  if musicData and musicData.SaleChannel > 0 then
    local shopItems, item = shopIns:GetShopItems()
    for _, typeId in pairs(shopItems) do
      item = shopIns:GetShopItemDataByTypeId(typeId)
      if item.goodsID == sid then
        self.buyCell:SetData(item)
        self.buyCell.gameObject:SetActive(true)
        shopIns:SetSelectId(item.id)
        return
      end
    end
  end
  self.buyCell.gameObject:SetActive(false)
end
function SoundItemChoosePopUp:OnQueryMusicList()
  self:TryUpdatePlayTip()
end
function SoundItemChoosePopUp:OnHouseListUpdate()
  self:TryUpdatePlayTip()
end
function SoundItemChoosePopUp:TryUpdatePlayTip()
  if not self.playTip then
    return
  end
  local rem = self:GetRemainingMusicCountOfList()
  if rem <= 0 then
    TipManager.CloseTip()
    return
  end
  local cell = self.playTip.cells[1]
  cell:UpdateCountChooseBord(rem)
  if rem < cell.countChoose_maxCount then
    cell:SetChooseCount(rem)
  end
end
function SoundItemChoosePopUp:GetRemainingMusicCountOfList()
  local list
  if self.npc then
    list = ServiceNUserProxy.Instance.musicList
  elseif self.furniture then
    list = HomeProxy.Instance.curSoundList
  end
  return GameConfig.Music.max_music_count - (list and #list or 0)
end
