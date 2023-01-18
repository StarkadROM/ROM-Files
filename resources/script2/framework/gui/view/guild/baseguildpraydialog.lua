autoImport("WrapCellHelper")
autoImport("DialogCell")
BaseGuildPrayDialog = class("BaseGuildPrayDialog", ContainerView)
function BaseGuildPrayDialog:Init()
  local npc = self.viewdata.viewdata.npcdata
  self.npcguid = npc.data.id
  self:InitUI()
  self:AddMapEvent()
end
function BaseGuildPrayDialog:AddMapEvent()
  self:AddListenEvt(ServiceEvent.GuildCmdGuildPrayNtfGuildCmd, self.HandleNtfGuildCmd)
  self:AddListenEvt(ItemEvent.ItemUpdate, self._updateCoins)
  self:AddListenEvt(MyselfEvent.MyDataChange, self._updateCoins)
  self:AddListenEvt(SceneGlobalEvent.Map2DChanged, self.CloseSelf)
end
function BaseGuildPrayDialog:GetCurNpc()
  if self.npcguid then
    return NSceneNpcProxy.Instance:Find(self.npcguid)
  end
end
function BaseGuildPrayDialog:InitUI()
  self.mask = self:FindGO("Mask")
  self.prayButton = self:FindGO("PrayButton")
  self:AddClickEvent(self.prayButton, function(go)
    self:OnClickPray()
  end)
  self.prayDialog = self:FindGO("PrayDialog")
  self.prayDialog = DialogCell.new(self.prayDialog)
  self:ActiveLock(false)
end
function BaseGuildPrayDialog:ActiveLock(b)
  self.mask:SetActive(b)
  self.lockState = b
end
function BaseGuildPrayDialog:OnClickPray()
end
function BaseGuildPrayDialog:InitPray()
end
function BaseGuildPrayDialog:_updatePrayGrid()
end
function BaseGuildPrayDialog:_updateCoins()
end
function BaseGuildPrayDialog:_updateDialogContent()
end
function BaseGuildPrayDialog:HandleNtfGuildCmd(note)
  self:_updatePrayGrid()
  self:_updateCoins()
  self:_updateDialogContent()
end
function BaseGuildPrayDialog:OnEnter()
  BaseGuildPrayDialog.super.OnEnter(self)
  local npcInfo = self:GetCurNpc()
  if not npcInfo then
    return
  end
  local viewPort = CameraConfig.Guild_Pray_ViewPort
  local rotation = CameraConfig.Guild_Pray_Rotation
  local npcRootTrans = npcInfo.assetRole.completeTransform
  self:CameraFocusAndRotateTo(npcRootTrans, viewPort, rotation)
end
function BaseGuildPrayDialog:OnExit()
  BaseGuildPrayDialog.super.OnExit(self)
  TimeTickManager.Me():ClearTick(self)
  self:CameraReset()
end
