ServicePlayerActionCommand = class("ServicePlayerActionCommand", pm.SimpleCommand)
function ServicePlayerActionCommand:execute(note)
  local data = note.body
  if data ~= nil then
    do
      local type = data.type
      local value = data.value
      local delay = data.delay and tonumber(data.delay)
      if delay and delay > 0 then
        TimeTickManager.Me():CreateOnceDelayTick(delay, function(owner, deltaTime)
          self:DoServerPlayerBeheavior(data.charid, type, value)
        end, self)
      else
        self:DoServerPlayerBeheavior(data.charid, type, value)
      end
    end
  else
  end
end
function ServicePlayerActionCommand:DoServerPlayerBeheavior(playerid, type, value)
  local player
  if 0 == playerid then
    player = Game.Myself
  else
    player = SceneCreatureProxy.FindCreature(playerid)
  end
  if not player then
    return
  end
  if type == SceneUser2_pb.EUSERACTIONTYPE_ADDHP then
    player:PlayHpUp()
    if player == Game.Myself then
      local pos = LuaVector3.Zero()
      LuaVector3.Better_Set(pos, player.assetRole:GetEPOrRootPosition(RoleDefines_EP.Chest))
      SkillLogic_Base.ShowDamage_Single(CommonFun.DamageType.Normal, value, pos, HurtNumType.HealNum, HurtNumColorType.Treatment, player, nil, player)
      LuaVector3.Destroy(pos)
    end
    GameFacade.Instance:sendNotification(SceneUserEvent.EatHp, value)
  elseif type == SceneUser2_pb.EUSERACTIONTYPE_EXPRESSION then
    local emojiLength = #Table_Expression
    local emojiId = tonumber(value)
    if emojiId then
      if Table_Expression[emojiId] == nil then
        if emojiId > 700 then
          emojiId = emojiId - 700
        end
        if emojiLength < emojiId then
          emojiId = emojiId % emojiLength
          if emojiId <= 0 then
            emojiId = 1
          end
        end
      end
      GameFacade.Instance:sendNotification(EmojiEvent.PlayEmoji, {
        emoji = emojiId,
        roleid = player.data.id
      })
    end
  elseif type == SceneUser2_pb.EUSERACTIONTYPE_MOTION then
    local actionid = tonumber(value)
    if actionid and Table_ActionAnime[actionid] then
      local actionName = Table_ActionAnime[actionid].Name
      player:Server_PlayActionCmd(actionName, nil, true)
    end
  elseif type == SceneUser2_pb.EUSERACTIONTYPE_NORMALMOTION then
    local actionid = tonumber(value)
    if actionid and Table_ActionAnime[actionid] then
      local actionName = Table_ActionAnime[actionid].Name
      player:Server_PlayActionCmd(actionName, nil, false)
    end
  elseif type == SceneUser2_pb.EUSERACTIONTYPE_GEAR_ACTION then
    local actionid = tonumber(value)
    if actionid then
      local actionName = string.format("state%d", actionid)
      player:Server_PlayActionCmd(actionName, nil, false)
    end
  elseif type == SceneUser2_pb.EUSERACTIONTYPE_DIALOG then
    if playerid == Game.Myself.data.id then
      GameFacade.Instance:sendNotification(MyselfEvent.AddWeakDialog, DialogUtil.GetDialogData(value))
    end
  elseif type == SceneUser2_pb.EUSERACTIONTYPE_ANIMATION then
    local animid = tonumber(value)
    if animid and Table_SceneBossAnime[animid] then
      local objId = Table_SceneBossAnime[animid].ObjID
      local anim = Table_SceneBossAnime[animid].Name
      Game.GameObjectManagers[Game.GameObjectType.SceneBossAnime]:PlayAnimation(objId, anim)
    end
  elseif type == SceneUser2_pb.EUSERACTIONTYPE_WALKACTION then
    xdlog("Recv--->WALKACTION")
    local actionid = tonumber(value)
    if actionid and Table_ActionAnime[actionid] then
      local actionName = Table_ActionAnime[actionid].Name
      player:SetDefaultWalkAnime(actionName)
      xdlog("变更默认移动动画", actionName)
    end
  end
end
