VisitNpcManager = class("VisitNpcManager")
local CheckRangeInterval = 1
function VisitNpcManager:ctor()
  self.nextCheckRangeTime = 0
end
function VisitNpcManager:Launch()
  if self.running then
    return
  end
  self.running = true
  self:AddEventListener()
end
function VisitNpcManager:Shutdown()
  if not self.running then
    return
  end
  self.running = false
  self.nextCheckRangeTime = 0
  self:RemoveEventListener()
end
function VisitNpcManager:Update(time, deltaTime)
  if not self.running then
    return
  end
  if time >= self.nextCheckRangeTime then
    self.nextCheckRangeTime = time + CheckRangeInterval
    self:UpdateRangeNpcs()
  end
end
function VisitNpcManager:AddEventListener()
  EventManager.Me():AddEventListener(SceneUserEvent.SceneRemoveNpcs, self.UpdateRangeNpcs, self)
end
function VisitNpcManager:RemoveEventListener()
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneRemoveNpcs, self.UpdateRangeNpcs, self)
end
function VisitNpcManager:UpdateRangeNpcs()
  local myPos = Game.Myself:GetPosition()
  local npcs = NSceneNpcProxy.Instance:FindNearNpcs(myPos, 5, function(npc)
    local npcid = npc.data.staticData.id
    local npcData = Table_Npc[npcid]
    if npcData then
      local accessRange = npcData and npcData.AccessRange or 1
      if accessRange * accessRange >= LuaVector3.Distance_Square(npc:GetPosition(), myPos) then
        return true
      end
    end
  end)
  local result = {}
  for i = 1, #npcs do
    local npc = npcs[i]
    if npc:GetCreatureType() == Creature_Type.Npc then
      local questList = QuestProxy.Instance:getDialogQuestListByNpcId(npc.data.staticData.id, npc.data.uniqueid)
      if questList and #questList > 0 then
        if self:HandleQuestShow(questList) then
          local npcid = npc.data.staticData.id
          if not result[npcid] then
            local data = {target = npc, state = 1}
            result[npcid] = data
          end
        end
      else
        local collectQuestList = QuestProxy.Instance:getCollectQuestListByNpcId(npc.data.staticData.id)
        if collectQuestList and #collectQuestList > 0 then
          local npcid = npc.data.staticData.id
          local data = {target = npc, state = 2}
          if not result[npcid] then
            data.count = 1
            result[npcid] = data
          else
            result[npcid].count = result[npcid].count + 1
          end
        end
      end
    end
  end
  table.sort(result, function(l, r)
    return l.state < r.state
  end)
  GameFacade.Instance:sendNotification(InteractNpcEvent.RefreshNpcVisitList, result)
end
function VisitNpcManager:HandleQuestShow(questList)
  for i = 1, #questList do
    if VisitSymbolLimitType and TableUtility.ArrayFindIndex(VisitSymbolLimitType, questList[i].type) > 0 then
      return false
    end
    local showSymbol = questList[i].staticData and questList[i].staticData.Params.ShowSymbol
    showSymbol = tonumber(showSymbol)
    if showSymbol ~= 3 then
      return true
    end
  end
  return false
end
