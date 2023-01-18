EquipsInfoSaveData = class("EquipsInfoSaveData")
function EquipsInfoSaveData:ctor(serverequipinfo)
  if serverequipinfo then
    self.pos = serverequipinfo.pos
    self.type_id = serverequipinfo.type_id
    self.guid = serverequipinfo.guid
  end
end
function EquipsInfoSaveData:IsPersonalArtifactPos()
  return self.pos == SceneItem_pb.EEQUIPPOS_ARTIFACT_RING1
end
