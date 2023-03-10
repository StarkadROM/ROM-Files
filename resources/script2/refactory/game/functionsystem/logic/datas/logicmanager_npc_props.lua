LogicManager_Npc_Props = class("LogicManager_Npc_Props", LogicManager_Creature_Props)
function LogicManager_Npc_Props:ctor()
  LogicManager_Npc_Props.super.ctor(self)
end
function LogicManager_Npc_Props:UpdateHiding(ncreature, propName, oldValue, p)
  local _bokiProxy = BokiProxy.Instance
  if ncreature.data.id == _bokiProxy:GetBokiGuid() then
    GameFacade.Instance:sendNotification(MyselfEvent.BokiHidePropsChange, ncreature)
  end
  if 1 > p:GetValue() then
    ncreature:Show()
    Game.AreaTrigger_Buff:RemoveTrigger(AreaTrigger_Buff.SeeHide, ncreature.data.id)
  else
    local needHide = true
    local behaviourData = ncreature.data.behaviourData
    if behaviourData and behaviourData:IsGhost() and FunctionPhoto.Me():IsRunningCmd(PhotoCommandShowGhost) then
      needHide = false
    end
    if needHide then
      ncreature:Hide()
      Game.AreaTrigger_Buff:AddTrigger(AreaTrigger_Buff.SeeHide, ncreature.data.id)
      return true
    end
  end
end
