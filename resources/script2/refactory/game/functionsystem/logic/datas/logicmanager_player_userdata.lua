autoImport("LogicManager_Creature_Userdata")
LogicManager_Player_Userdata = class("LogicManager_Player_Userdata", LogicManager_Creature_Userdata)
local PVPTeam = RoleDefines.PVPTeam
local bodyUserdataID, headUserdataID, mountUserdataID = 0, 0, 0
function LogicManager_Player_Userdata:ctor()
  LogicManager_Player_Userdata.super.ctor(self)
  bodyUserdataID = ProtoCommon_pb.EUSERDATATYPE_BODY
  headUserdataID = ProtoCommon_pb.EUSERDATATYPE_HEAD
  mountUserdataID = ProtoCommon_pb.EUSERDATATYPE_MOUNT
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_MUSIC_DEMAND, self.UpdateMusicDJ)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_PVP_COLOR, self.SetPvpColor)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_PEAK_EFFECT, self.UpdatePeakEffect)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_DRESSUP, self.UpdateOnStageHiding)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_PROFESSION, self.SetProfession)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_CHAIR, self.UpdateChair)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_TRAIN, self.UpdateTrain)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_PET_PARTNER, self.UpdatePartner)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_REFINE_HEAD, self.UpdateRefineHead)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_REFINE_FACE, self.UpdateRefineFace)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_REFINE_MOUTH, self.UpdateRefineMouth)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_REFINE_BACK, self.UpdateRefineBack)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_REFINE_TAIL, self.UpdateRefineTail)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_RIDING_CHARID, self.UpdateMultiMount)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_RIDING_POS, self.UpdateMultiMount)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_JOBLEVEL, self.UpdateJobLevel)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_JOBEXP, self.UpdateJobExpLevel)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_PROFESSION, self.UpdateProfession)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_MUSIC_DEMAND, self.UpdateMusicDJ)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_PVP_COLOR, self.UpdatePvpColor)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_PEAK_EFFECT, self.UpdatePeakEffect)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_DRESSUP, self.UpdateOnStageHiding)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_CHAIR, self.UpdateChair)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_TRAIN, self.UpdateTrain)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_SEX, self.UpdateSex)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_PET_PARTNER, self.UpdatePartner)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_REFINE_HEAD, self.UpdateRefineHead)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_REFINE_FACE, self.UpdateRefineFace)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_REFINE_MOUTH, self.UpdateRefineMouth)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_REFINE_BACK, self.UpdateRefineBack)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_REFINE_TAIL, self.UpdateRefineTail)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_BACKGROUND, self.UpdateBackground)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_RIDING_CHARID, self.UpdateMultiMount)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_RIDING_POS, self.UpdateMultiMount)
  self:AddDirtyCall(ProtoCommon_pb.EUSERDATATYPE_MOUNT, self.UpdateMount)
end
function LogicManager_Player_Userdata:SetProfession(ncreature, userDataID, oldValue, newValue)
  ncreature:Logic_PartnerVisible()
  ncreature:UpdateSkillOverAction()
end
function LogicManager_Player_Userdata:UpdateRoleLevel(ncreature, userDataID, oldValue, newValue)
  LogicManager_Player_Userdata.super.UpdateRoleLevel(self, ncreature, userDataID, oldValue, newValue)
  GameFacade.Instance:sendNotification(SceneUserEvent.LevelUp, ncreature, SceneUserEvent.BaseLevelUp)
end
function LogicManager_Player_Userdata:UpdateJobLevel(ncreature, userDataID, oldValue, newValue)
  local occ = ncreature.data:GetCurOcc()
  if occ then
    occ:SetLevel(newValue)
  end
  GameFacade.Instance:sendNotification(SceneUserEvent.LevelUp, ncreature, SceneUserEvent.JobLevelUp)
end
function LogicManager_Player_Userdata:UpdateJobExpLevel(ncreature, userDataID, oldValue, newValue)
  local occ = ncreature.data:GetCurOcc()
  if occ then
    occ:SetExp(newValue)
  end
end
function LogicManager_Player_Userdata:SetChangeDressDirty(ncreature, userDataID, oldValue, newValue)
  self.changeDressDirty = true
  if userDataID == bodyUserdataID then
    ncreature:HandlerAssetRoleSuffixMap()
  end
  if userDataID == headUserdataID or userDataID == mountUserdataID then
    NSceneUserProxy.Instance:CheckUpdataUserData(oldValue, newValue)
  end
end
function LogicManager_Player_Userdata:UpdateProfession(ncreature, userDataID, oldValue, newValue)
  ncreature:UpdateProfession()
  ncreature:Logic_PartnerVisible()
  EventManager.Me():PassEvent(SceneUserEvent.ChangeProfession, ncreature)
  if ncreature == Game.Myself:GetLockTarget() then
    EventManager.Me():PassEvent(MyselfEvent.SelectTargetClassChange, ncreature)
  end
end
function LogicManager_Player_Userdata:UpdateMusicDJ(ncreature, userDataID, oldValue, newValue)
  if newValue == 1 then
    FunctionMusicBox.Me():AddDJPlayer(ncreature)
  elseif newValue == 0 then
    FunctionMusicBox.Me():RemoveDJPlayer(ncreature)
  end
end
function LogicManager_Player_Userdata:SetPvpColor(ncreature, userDataID, oldValue, newValue)
  ncreature:PlayTeamCircle(newValue)
end
function LogicManager_Player_Userdata:UpdatePvpColor(ncreature, userDataID, oldValue, newValue)
  ncreature:PlayTeamCircle(newValue)
end
function LogicManager_Player_Userdata:UpdatePeakEffect(ncreature, userDataID, oldValue, newValue)
  if newValue == 1 then
    ncreature:PlayPeakEffect()
  elseif newValue == 0 then
    ncreature:RemovePeakEffect()
  end
end
function LogicManager_Player_Userdata:UpdateOnStageHiding(ncreature, userDataID, oldValue, newValue)
  if newValue ~= 0 then
    FunctionStage.Me():AddPlayerOnStage(ncreature.data.id, ncreature, newValue)
  else
    FunctionStage.Me():RemovePlayerOnStage(ncreature.data.id)
  end
  EventManager.Me():PassEvent(CreatureEvent.Hiding_Change, ncreature.data.id)
end
function LogicManager_Player_Userdata:UpdateChair(ncreature, userDataID, oldValue, newValue)
  if newValue == 0 then
    ncreature:Server_GetOffSeat(newValue, true)
  else
    ncreature:Server_GetOnSeat(newValue, true)
  end
end
function LogicManager_Player_Userdata:UpdateTrain(ncreature, userDataID, oldValue, newValue)
  if newValue == 0 then
    ncreature:SetVisible(true, LayerChangeReason.InteractNpc)
    FunctionPlayerUI.Me():UnMaskAllUI(ncreature, PUIVisibleReason.InteractNpc)
  else
    ncreature:SetVisible(false, LayerChangeReason.InteractNpc)
    FunctionPlayerUI.Me():MaskAllUI(ncreature, PUIVisibleReason.InteractNpc)
  end
end
function LogicManager_Player_Userdata:UpdateMount(ncreature, userDataID, oldValue, newValue)
  self:SetChangeDressDirty(ncreature, userDataID, oldValue, newValue)
  ncreature:Logic_PartnerVisible()
end
function LogicManager_Player_Userdata:UpdateSex(ncreature, userDataID, oldValue, newValue)
  GameFacade.Instance:sendNotification(CreatureEvent.Sex_Change, ncreature)
end
function LogicManager_Player_Userdata:UpdatePartner(ncreature, userDataID, oldValue, newValue)
  LogicManager_Player_Userdata.super.UpdatePartner(self, ncreature, userDataID, oldValue, newValue)
  ncreature:Logic_PartnerVisible()
end
function LogicManager_Player_Userdata:UpdateRefineHead(ncreature, userDataID, oldValue, newValue)
  ncreature:UpdateRefinePerformance(Asset_Role.PartIndex.Head, oldValue, newValue)
end
function LogicManager_Player_Userdata:UpdateRefineFace(ncreature, userDataID, oldValue, newValue)
  ncreature:UpdateRefinePerformance(Asset_Role.PartIndex.Face, oldValue, newValue)
end
function LogicManager_Player_Userdata:UpdateRefineMouth(ncreature, userDataID, oldValue, newValue)
  ncreature:UpdateRefinePerformance(Asset_Role.PartIndex.Mouth, oldValue, newValue)
end
function LogicManager_Player_Userdata:UpdateRefineBack(ncreature, userDataID, oldValue, newValue)
  ncreature:UpdateRefinePerformance(Asset_Role.PartIndex.Wing, oldValue, newValue)
end
function LogicManager_Player_Userdata:UpdateRefineTail(ncreature, userDataID, oldValue, newValue)
  ncreature:UpdateRefinePerformance(Asset_Role.PartIndex.Tail, oldValue, newValue)
end
function LogicManager_Player_Userdata:UpdateBackground(ncreature, userDataID, oldValue, newValue)
  GameFacade.Instance:sendNotification(CreatureEvent.Background_Change, ncreature)
end
function LogicManager_Player_Userdata:UpdateMultiMount(ncreature, userDataID, oldValue, newValue)
  redlog("UpdateMultiMount", ncreature.data:GetName(), oldValue, newValue)
  ncreature:UpdateMultiMountStatus()
end
