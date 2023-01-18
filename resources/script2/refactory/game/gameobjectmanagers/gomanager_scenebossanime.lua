GOManager_SceneBossAnime = class("GOManager_SceneBossAnime")
function GOManager_SceneBossAnime:ctor()
  self.animators = {}
  self.pendingAnimID = {}
  self.explicitlyPendingPlayAnimInfo = {}
  self.animStateRecord = {}
end
function GOManager_SceneBossAnime:Clear()
  TableUtility.TableClear(self.animators)
  TableUtility.TableClear(self.pendingAnimID)
  TableUtility.TableClear(self.explicitlyPendingPlayAnimInfo)
end
function GOManager_SceneBossAnime:RegisterGameObject(obj)
  if obj then
    local objID = obj.ID
    Debug_AssertFormat(objID > 0, "RegisterSceneBossAnime({0}) invalid id: {1}", obj, objID)
    self.animStateRecord[objID] = nil
    local animator = obj:GetComponentProperty(0)
    animator = animator or obj:GetComponent(Animator)
    if animator then
      self.animators[objID] = animator
      while true do
        if self.explicitlyPendingPlayAnimInfo and self.explicitlyPendingPlayAnimInfo[objID] then
          self:PlayAnimation(objID, self.explicitlyPendingPlayAnimInfo[objID][1], self.explicitlyPendingPlayAnimInfo[objID][2])
          self.explicitlyPendingPlayAnimInfo[objID] = nil
          break
        end
        if self.pendingAnimID and self.pendingAnimID[objID] then
          self:SwitchToAnimation(objID, self.pendingAnimID[objID])
          self.pendingAnimID[objID] = nil
          break
        end
        break
      end
      return true
    end
  end
end
function GOManager_SceneBossAnime:UnregisterGameObject(obj)
  local objID = obj.ID
  Debug_AssertFormat(objID > 0, "UnregisterSceneBossAnime({0}) invalid id: {1}", obj, objID)
  self.animators[objID] = nil
  self.animStateRecord[objID] = nil
  return true
end
function GOManager_SceneBossAnime:PlayAnimation(objID, anim, progress)
  progress = progress or 0
  local animator = self.animators[objID]
  if animator then
    GameObjectUtil.SetBehaviourEnabled(animator, true)
    animator:Play(anim, -1, progress)
    self.animStateRecord[objID] = anim
    return true
  end
end
function GOManager_SceneBossAnime:StopAnimation(objID)
  local animator = self.animators[objID]
  if animator then
    GameObjectUtil.SetBehaviourEnabled(animator, false)
    return true
  end
end
function GOManager_SceneBossAnime:SwitchToAnimation(objID, anim)
  return self:PlayAnimation(objID, anim, 1)
end
function GOManager_SceneBossAnime:ClearPendingAnimID()
  TableUtility.TableClear(self.pendingAnimID)
end
function GOManager_SceneBossAnime:SetPendingAnimID(data)
  TableUtility.TableClear(self.pendingAnimID)
  if data and data.mapid == SceneProxy.Instance:GetCurMapID() and data.animeid then
    for i = 1, #data.animeid do
      self:AddPendingAnimID(data.animeid[i])
    end
  end
end
function GOManager_SceneBossAnime:AddPendingAnimID(id)
  local animData = id and Table_SceneBossAnime[id]
  if not animData then
    return
  end
  if not self:SwitchToAnimation(animData.ObjID, animData.Name) then
    self.pendingAnimID[animData.ObjID] = animData.Name
  end
end
function GOManager_SceneBossAnime:ExplicitlyPlaySceneAnime(objID, name, progress)
  progress = math.clamp(progress or 0, 0, 1)
  if not self:PlayAnimation(objID, name, progress) then
    self.explicitlyPendingPlayAnimInfo[objID] = {name, progress}
  end
end
function GOManager_SceneBossAnime:GetAnimator(objID)
  return self.animators[objID]
end
function GOManager_SceneBossAnime:GetCurAnimState(objID)
  return self.animStateRecord[objID]
end
