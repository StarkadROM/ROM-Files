autoImport("ServiceMapAutoProxy")
ServiceMapProxy = class("ServiceMapProxy", ServiceMapAutoProxy)
ServiceMapProxy.Instance = nil
ServiceMapProxy.NAME = "ServiceMapProxy"
function ServiceMapProxy:ctor(proxyName)
  if ServiceMapProxy.Instance == nil then
    self.proxyName = proxyName or ServiceMapProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceMapProxy.Instance = self
  end
end
function ServiceMapProxy:RecvAddMapItem(data)
  SceneItemProxy.Instance:DropItems(data.items)
  self:Notify(ServiceEvent.MapAddMapItem, data)
end
function ServiceMapProxy:RecvPickupItem(data)
  local player = SceneCreatureProxy.FindCreature(data.playerguid)
  if player ~= nil then
    if data.success then
      FunctionSceneItemCommand.Me():PickUpItem(player, data.itemguid)
    end
  else
    FunctionSceneItemCommand.Me():SetToListPickUp(data.itemguid, data.playerguid)
  end
  self:Notify(ServiceEvent.MapPickupItem, data)
end
function ServiceMapProxy:RecvAddMapUser(data)
  NSceneUserProxy.Instance:AddSome(data.users)
end
function ServiceMapProxy:RecvAddMapNpc(data)
  NSceneNpcProxy.Instance:AddSome(data.npcs)
  self:Notify(ServiceEvent.MapAddMapNpc, data)
end
function ServiceMapProxy:RecvAddMapTrap(data)
  SceneTrapProxy.Instance:AddSome(data.traps)
end
function ServiceMapProxy:RecvExitPointState(data)
  local id, state = data.visible == 1, true
  Game.AreaTrigger_ExitPoint:SetEPEnable(id, state)
  DungeonProxy.Instance:TryUpdateExitPointState(id, state)
  local note = ReusableTable.CreateTable()
  note.id, note.state = id, state
  self:Notify(MiniMapEvent.ExitPointStateChange, note)
  ReusableTable.DestroyAndClearTable(note)
end
function ServiceMapProxy:RecvAddMapAct(data)
  SceneTriggerProxy.Instance:AddSome(data.acts)
end
function ServiceMapProxy:RecvMapCmdEnd(data)
  self:Notify(ServiceEvent.MapMapCmdEnd, data)
  FunctionMapEnd.Me():Launch()
  FunctionChangeScene.Me():RecvServerSceneLoaded()
end
function ServiceMapProxy:RecvNpcSearchRangeCmd(data)
  NSceneNpcProxy.Instance:SetSearchRange(data)
end
function ServiceMapProxy:RecvUserHandsCmd(data)
end
function ServiceMapProxy:RecvSpEffectCmd(data)
  local creature = SceneCreatureProxy.FindCreature(data.senderid)
  if nil == creature then
    return
  end
  local spEffectData = data.data
  if data.isadd then
    creature:Server_AddMultipleTargetSpEffect(spEffectData)
  else
    creature:Server_RemoveMultipleTargetSpEffect(spEffectData)
  end
  self:Notify(ServiceEvent.MapSpEffectCmd, data)
end
function ServiceMapProxy:RecvUserHandNpcCmd(data)
  SceneAINpcProxy.Instance:SetHandNpc(data)
  self:Notify(ServiceEvent.MapUserHandNpcCmd, data)
end
function ServiceMapProxy:RecvGingerBreadNpcCmd(data)
  SceneAINpcProxy.Instance:SetExpressNpc(data)
  self:Notify(ServiceEvent.MapGingerBreadNpcCmd, data)
end
function ServiceMapProxy:RecvUserSecretQueryMapCmd(data)
  BFBuildingProxy.Instance:RecvUserSecretQueryMapCmd(data)
  self:Notify(ServiceEvent.MapUserSecretQueryMapCmd, data)
end
function ServiceMapProxy:RecvUserSecretGetMapCmd(data)
  BFBuildingProxy.Instance:RecvUserSecretGetMapCmd(data)
  self:Notify(ServiceEvent.MapUserSecretGetMapCmd, data)
end
function ServiceMapProxy:RecvObjStateSyncMapCmd(data)
  Game.GameObjectManagers[Game.GameObjectType.SceneBossAnime]:PlayAnimation(data.objid, data.state)
end
function ServiceMapProxy:RecvMultiObjStateSyncMapCmd(data)
  local state
  local manager = Game.GameObjectManagers[Game.GameObjectType.SceneBossAnime]
  for i = 1, #data.obj_states do
    state = data.obj_states[i]
    manager:PlayAnimation(state.objid, state.state)
  end
end
function ServiceMapProxy:RecvAddMapObjNpc(data)
  NSceneNpcProxy.Instance:AddSome(data.npcs)
end
function ServiceMapProxy:RecvTeamFollowBanListCmd(data)
  WorldMapProxy.Instance:RecvFollowBannedMapList(data)
  self:Notify(ServiceEvent.MapTeamFollowBanListCmd, data)
end
function ServiceMapProxy:RecvQueryCloneMapStatusMapCmd(data)
  WorldMapProxy.Instance:RecvQueryCloneMapStatusMap(data)
  self:Notify(ServiceEvent.MapQueryCloneMapStatusMapCmd, data)
end
function ServiceMapProxy:RecvStormBossAffixQueryCmd(data)
  WildMvpProxy.Instance:UpdateActiveAffixDatas(data)
  self:Notify(ServiceEvent.MapStormBossAffixQueryCmd, data)
end
function ServiceMapProxy:RecvBuffRewardQueryCmd(data)
  WildMvpProxy.Instance:UpdateActiveBuffDatas(data)
  self:Notify(ServiceEvent.MapBuffRewardQueryCmd, data)
end
function ServiceMapProxy:RecvBuffRewardSelectCmd(data)
  if data.dialog and data.dialog > 0 and data.npc_guid and 0 < data.npc_guid then
    autoImport("DialogView")
    local ret = DialogView.ShowNPCDialog(data.dialog, data.npc_guid, function()
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.WildMvpSelectBuffView,
        viewdata = data
      })
    end)
    if not ret then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.WildMvpSelectBuffView,
        viewdata = data
      })
    end
  else
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.WildMvpSelectBuffView,
      viewdata = data
    })
  end
end
function ServiceMapProxy:RecvUpdateZoneMapCmd(data)
  FloatingPanel.Instance:RecvUpdateZoneMapCmd(data)
end
