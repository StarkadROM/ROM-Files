AdventureUtil = {}
AdventureUtil.ItemRefreshCount = 10
function AdventureUtil:CheckManualUpdateData(note, type)
  if not note then
    return false
  end
  local result = false
  local adventureType = note.update.type
  if type == "AdventureItemNormalListPage" then
    result = adventureType == SceneManual_pb.EMANUALTYPE_FASHION or adventureType == SceneManual_pb.EMANUALTYPE_CARD or adventureType == SceneManual_pb.EMANUALTYPE_SCENERY or adventureType == SceneManual_pb.EMANUALTYPE_COLLECTION or adventureType == SceneManual_pb.EMANUALTYPE_TOY or adventureType == SceneManual_pb.EMANUALTYPE_FURNITURE or adventureType == SceneManual_pb.EMANUALTYPE_EQUIP or true
  elseif type == "AdventureNpcListPage" then
    result = adventureType == SceneManual_pb.EMANUALTYPE_MONSTER or adventureType == SceneManual_pb.EMANUALTYPE_NPC or adventureType == SceneManual_pb.EMANUALTYPE_PRESTIGE or true
  elseif type == "AdventureResearchPage" then
    result = adventureType == SceneManual_pb.EMANUALTYPE_RESEARCH or true
  elseif type == "AdventureTabItemListPage" then
    result = adventureType == SceneManual_pb.EMANUALTYPE_PET or adventureType == SceneManual_pb.EMANUALTYPE_MOUNT or true
  else
    LogUtility.Error(string.format("[%s] CheckManualUpdateData() Error : type = %s is not case!", self.__cname, tostring(type)))
    return false
  end
  return result, adventureType
end
function AdventureUtil:DelayCallback(note, callback)
  local data = note.body
  TimeTickManager.Me():CreateOnceDelayTick(100, function(owner, deltaTime)
    if callback then
      callback(data)
    end
  end, self)
end
function AdventureUtil:CheckoutCanRefreshItems(page)
  page.itemRefreshCooldownNum = not page.itemRefreshCooldownNum and 1 or page.gameObject.activeSelf and page.itemRefreshCooldownNum + 1 or page.itemRefreshCooldownNum
  if page.itemRefreshCooldownNum >= AdventureUtil.ItemRefreshCount then
    page.itemRefreshCooldownNum = 0
    return true
  else
    return false
  end
end
