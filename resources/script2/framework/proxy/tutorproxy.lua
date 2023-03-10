autoImport("TutorTaskItem")
autoImport("TutorGrowthReward")
autoImport("TutorMatcherData")
TutorProxy = class("TutorProxy", pm.Proxy)
TutorProxy.Instance = nil
TutorProxy.NAME = "TutorProxy"
TutorType = {Tutor = 1, Student = 2}
TutorProxy.TutorMatchStatus = {
  Start = MatchCCmd_pb.ETUTORMATCH_START,
  Match = MatchCCmd_pb.ETUTORMATCH_MATCH,
  Agree = MatchCCmd_pb.ETUTORMATCH_AGREE,
  Refuse = MatchCCmd_pb.ETUTORMATCH_REFUSE,
  Stop = MatchCCmd_pb.ETUTORMATCH_STOP,
  Restart = MatchCCmd_pb.ETUTORMATCH_RESTART
}
local _TutorMatchStatus = TutorProxy.TutorMatchStatus
function TutorProxy:ctor(proxyName, data)
  self.proxyName = proxyName or TutorProxy.NAME
  if TutorProxy.Instance == nil then
    TutorProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end
function TutorProxy:Init()
  self.studentList = {}
  self.recentStudentList = {}
  self.classmateList = {}
  self.applyList = {}
  self.callAddTimeMap = {}
  self.questMap = {}
  self.callQuestTimeMap = {}
  self.rewardStatesList = {}
end
function TutorProxy:CallAddTutor(guid)
  local now = UnityUnscaledTime
  local gameConfigTutor = GameConfig.Tutor
  if self._callAddTime == nil or now - self._callAddTime >= gameConfigTutor.call_protecttime then
    if self.callAddTimeMap[guid] ~= nil and now - self.callAddTimeMap[guid] < gameConfigTutor.apply_same_interval then
      MsgManager.ShowMsgByID(3210)
      return
    end
    if not self:CheckAsTutorLevel() then
      MsgManager.ShowMsgByID(3201, gameConfigTutor.tutor_baselv_req)
      return
    end
    if not FunctionUnLockFunc.Me():CheckCanOpen(gameConfigTutor.tutor_menuid) then
      MsgManager.ShowMsgByID(3238)
      return
    end
    if self:CheckStudentFull() then
      MsgManager.ShowMsgByID(3209)
      return
    end
    if self:IsMyStudent(guid) then
      MsgManager.ShowMsgByID(3237)
      return
    end
    self._callAddTime = now
    self.callAddTimeMap[guid] = now
    local tempArray = ReusableTable.CreateArray()
    tempArray[1] = guid
    ServiceSessionSocialityProxy.Instance:CallAddRelation(tempArray, SocialManager.PbRelation.TutorApply)
    ReusableTable.DestroyArray(tempArray)
  else
    MsgManager.ShowMsgByID(3210)
  end
end
function TutorProxy:CallAddStudent(guid)
  local now = UnityUnscaledTime
  local gameConfigTutor = GameConfig.Tutor
  if self._callAddTime == nil or now - self._callAddTime >= gameConfigTutor.call_protecttime then
    if self.callAddTimeMap[guid] ~= nil and now - self.callAddTimeMap[guid] < gameConfigTutor.apply_same_interval then
      MsgManager.ShowMsgByID(3210)
      return
    end
    if not FunctionUnLockFunc.Me():CheckCanOpen(gameConfigTutor.student_menuid) then
      MsgManager.ShowMsgByID(3200)
      return
    end
    if MyselfProxy.Instance:RoleLevel() >= gameConfigTutor.tutor_baselv_req then
      MsgManager.ShowMsgByID(3202, gameConfigTutor.tutor_baselv_req)
      return
    end
    if self:IsMyTutor(guid) then
      MsgManager.ShowMsgByID(3237)
      return
    end
    if self.myTutor ~= nil then
      MsgManager.ShowMsgByID(3217)
      return
    end
    self._callAddTime = now
    self.callAddTimeMap[guid] = now
    local tempArray = ReusableTable.CreateArray()
    tempArray[1] = guid
    ServiceSessionSocialityProxy.Instance:CallAddRelation(tempArray, SocialManager.PbRelation.StudentApply)
    ReusableTable.DestroyArray(tempArray)
  else
    MsgManager.ShowMsgByID(3210)
  end
end
function TutorProxy:CallDeleteTutor(guid)
  MsgManager.ConfirmMsgByID(3219, function()
    ServiceSessionSocialityProxy.Instance:CallRemoveRelation(guid, SocialManager.PbRelation.Tutor)
  end)
end
function TutorProxy:CallDeleteStudent(guid)
  MsgManager.ConfirmMsgByID(3220, function()
    ServiceSessionSocialityProxy.Instance:CallRemoveRelation(guid, SocialManager.PbRelation.Student)
  end)
end
function TutorProxy:AddTutor(socialData)
  self.myTutor = socialData
end
function TutorProxy:RemoveTutor(guid)
  if self.myTutor.guid == guid then
    self.myTutor = nil
  end
end
function TutorProxy:AddStudent(socialData)
  self:_AddData(self.studentList, socialData)
end
function TutorProxy:RemoveStudent(guid)
  self:_RemoveData(self.studentList, guid)
end
function TutorProxy:AddRecentStudent(socialData)
  self:_AddData(self.recentStudentList, socialData)
end
function TutorProxy:RemoveRecentStudent(guid)
  self:_RemoveData(self.recentStudentList, guid)
end
function TutorProxy:AddTutorClassmate(socialData)
  self:_AddData(self.classmateList, socialData)
end
function TutorProxy:RemoveTutorClassmate(guid)
  self:_RemoveData(self.classmateList, guid)
end
function TutorProxy:AddApply(socialData)
  self:_AddData(self.applyList, socialData)
end
function TutorProxy:RemoveApply(guid)
  self:_RemoveData(self.applyList, guid)
end
function TutorProxy:SortApply()
  if #self.applyList > 1 then
    do
      local relation
      if self:CanAsTutor() then
        relation = SocialManager.SocialRelation.StudentApply
      else
        relation = SocialManager.SocialRelation.TutorApply
      end
      table.sort(self.applyList, function(l, r)
        return l:GetCreatetime(relation) > r:GetCreatetime(relation)
      end)
    end
  else
  end
end
function TutorProxy:_AddData(array, data)
  if not self:_CheckExist(array, data.guid) then
    TableUtility.ArrayPushBack(array, data)
  end
end
function TutorProxy:_RemoveData(array, guid)
  for i = 1, #array do
    if array[i].guid == guid then
      table.remove(array, i)
      return i
    end
  end
  return 0
end
function TutorProxy:_CheckExist(table, key)
  local data
  for i = 1, #table do
    if table[i].guid == key then
      data = table[i]
    end
  end
  return data
end
function TutorProxy:CanAsStudent()
  if not self:CheckAsStudentLevel() then
    return false
  end
  if MyselfProxy.Instance:RoleLevel() >= GameConfig.Tutor.tutor_baselv_req then
    return false
  end
  return true
end
function TutorProxy:CheckAsStudentLevel()
  return FunctionUnLockFunc.Me():CheckCanOpen(GameConfig.Tutor.student_menuid) and MyselfProxy.Instance:RoleLevel() >= GameConfig.Tutor.student_baselv_req
end
function TutorProxy:CanAsTutor()
  if #self.studentList > 0 then
    return true
  end
  if not self:CheckAsTutorLevel() then
    return false
  end
  if not FunctionUnLockFunc.Me():CheckCanOpen(GameConfig.Tutor.tutor_menuid) then
    return false
  end
  if 0 < #self.recentStudentList then
    return true
  end
  return true
end
function TutorProxy:CheckAsTutorLevel()
  return MyselfProxy.Instance:RoleLevel() >= GameConfig.Tutor.tutor_baselv_req
end
function TutorProxy:CheckStudentFull()
  return #self.studentList >= GameConfig.Tutor.max_student
end
function TutorProxy:IsMyStudent(guid)
  for i = 1, #self.studentList do
    if self.studentList[i].guid == guid then
      return true
    end
  end
  return false
end
function TutorProxy:IsMyTutor(guid)
  if self:CanAsStudent() and self.myTutor ~= nil and self.myTutor.guid == guid then
    return true
  end
  return false
end
function TutorProxy:GetMyTutor()
  return self.myTutor
end
function TutorProxy:GetStudentList()
  return self.studentList
end
function TutorProxy:GetRecentStudentList()
  return self.recentStudentList
end
function TutorProxy:GetClassmateList()
  return self.classmateList
end
function TutorProxy:GetApplyList()
  return self.applyList
end
function TutorProxy:GetProficiency(proficiency)
  local maxProficiency = GameConfig.Tutor.max_proficiency
  if proficiency >= maxProficiency then
    return 100
  else
    return proficiency * 100 / maxProficiency
  end
end
function TutorProxy:GetTutorProfic()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.TUTOR_PROFIC) or 0
end
function TutorProxy:CallTutorTaskQueryCmd(guid)
  local now = UnityUnscaledTime
  local time = self.callQuestTimeMap[guid]
  if guid ~= Game.Myself.data.id and (time == nil or now - time >= 300) then
    ServiceTutorProxy.Instance:CallTutorTaskQueryCmd(guid)
    self.callQuestTimeMap[guid] = now
    return true
  end
  return false
end
function TutorProxy:RecvTutorTaskQueryCmd(data)
  if data.refresh then
    self.callQuestTimeMap[data.charid] = nil
  else
    local charid = data.charid
    local items = data.items
    local questList = self.questMap[charid]
    if questList ~= nil then
      for i = 1, #questList do
        questList[i]:ResetData()
      end
    end
    self:UpdateQuest(items, charid)
    for i = 1, #data.finishtaskids do
      local quest = self:GetTutorTaskItem(charid, data.finishtaskids[i])
      if quest ~= nil then
        quest:SetCanReward(true)
      end
    end
  end
end
function TutorProxy:RecvTutorTaskTeacherRewardCmd(data)
  local questList = self.questMap[data.charid]
  if questList ~= nil then
    for i = 1, #questList do
      local quest = questList[i]
      if quest.id == data.taskid then
        quest.canReward = false
        break
      end
    end
  end
end
function TutorProxy:TryInitQuestData(guid)
  if self.questMap[guid] == nil then
    self.questMap[guid] = {}
    for k, v in pairs(Table_StudentAdventureQuest) do
      local newData = TutorTaskItem.new()
      newData:SetId(k, guid)
      TableUtility.ArrayPushBack(self.questMap[guid], newData)
    end
    table.sort(self.questMap[guid], function(l, r)
      return l.id < r.id
    end)
  end
end
function TutorProxy:UpdateQuest(items, guid)
  if items and #items > 0 then
    if guid == nil then
      guid = Game.Myself.data.id
    end
    self:TryInitQuestData(guid)
    for i = 1, #items do
      local single = items[i]
      local exsitData = self:GetTutorTaskItem(guid, single.id)
      if exsitData then
        exsitData:UpdateData(single)
      else
        local newData = TutorTaskItem.new(single)
        TableUtility.ArrayPushBack(self.questMap[guid], newData)
      end
    end
  end
end
function TutorProxy:GetTutorTaskItems(guid)
  self:TryInitQuestData(guid)
  return self.questMap[guid]
end
function TutorProxy:GetTutorTaskItem(guid, id)
  local questList = self.questMap[guid]
  if questList ~= nil then
    for i = 1, #questList do
      local single = questList[i]
      if single.id == id then
        return single
      end
    end
  end
end
function TutorProxy:TryInitGrowthRewards()
  if self.growthRewards == nil then
    self.growthRewards = {}
    for k, v in pairs(Table_TutorGrowUpReward) do
      local newData = TutorGrowthReward.new()
      newData:SetData(v.MaxLevel, v)
      TableUtility.ArrayPushBack(self.growthRewards, newData)
    end
  end
end
function TutorProxy:RefreshState()
  self:TryInitGrowthRewards()
  self.needRedTip = false
  local Length = #self.growthRewards
  for j = 1, Length do
    local level = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
    if not self:CheckGrowthReward(self.growthRewards[j].MaxLevel) then
      if level >= self.growthRewards[j].MaxLevel then
        self.growthRewards[j].canGet = 0
        if self.growthRewards[j].Type == 1 then
          self.needRedTip = true
        else
          self.needRedTip = false
        end
      else
        self.growthRewards[j].canGet = 1
      end
    elseif self.growthRewards[j].Type == 1 then
      self.growthRewards[j].canGet = 2
    elseif level >= self.growthRewards[j].MaxLevel then
      self.growthRewards[j].canGet = 0
    else
      self.growthRewards[j].canGet = 1
    end
  end
end
function TutorProxy:UpdateRewardState(rewardStates)
  local length = #rewardStates.growrewards
  if rewardStates and length >= 0 then
    for i = 1, length do
      self.rewardStatesList[i] = rewardStates.growrewards[i]
    end
  end
end
function TutorProxy:GetGrowthRewards()
  self:TryInitGrowthRewards()
  self:RefreshState()
  table.sort(self.growthRewards, function(a, b)
    local rtn
    if a.canGet == b.canGet then
      if a.id == b.id then
        rtn = a.Type > b.Type
      else
        rtn = a.id > b.id
      end
    else
      rtn = a.canGet > b.canGet
    end
    return rtn
  end)
  return self.growthRewards
end
function TutorProxy:CheckGrowthReward(level)
  local n = math.floor(level / 32) + 1
  local m = level % 32
  if m == 0 then
    m = 32
  end
  if self.rewardStatesList and self.rewardStatesList[n] then
    m = m - 1
    local result = self.rewardStatesList[n] >> m
    result = result & 1
    if result == 0 then
      return false
    else
      return true
    end
  end
  return false
end
function TutorProxy:UpdateTutorMatchInfo(data)
  self.matchStatus = data.status
  GameFacade.Instance:sendNotification(MainViewEvent.UpdateTutorMatchBtn)
  if self.matchStatus == _TutorMatchStatus.Match then
    if data.target then
      if not self.tutorMatcher then
        self.tutorMatcher = TutorMatcherData.new(data.target)
      else
        self.tutorMatcher:ResetData(data.target)
      end
    end
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.TutorMatchResultView
    })
  end
end
function TutorProxy:GetTutorMatStatus()
  return self.matchStatus
end
function TutorProxy:GetTutorMatcherInfo()
  return self.tutorMatcher
end
function TutorProxy:ShowTutorUpdateMsg(newsocialData)
  if BitUtil.band(newsocialData.relation, SocialManager.SocialRelation.Tutor) ~= 0 then
    self:ConfirmMsg(newsocialData)
  end
end
function TutorProxy:ShowStudentUpdateMsg(newsocialData)
  if BitUtil.band(newsocialData.relation, SocialManager.SocialRelation.Student) ~= 0 then
    self:ConfirmMsg(newsocialData)
  end
end
function TutorProxy:ShowSocialDataUpdateMsg(data)
  if data then
    for i = 1, #data.items do
      local updateData = data.items[i]
      if updateData.type == SessionSociality_pb.ESOCIALDATA_RELATION and (BitUtil.band(updateData.value, SocialManager.SocialRelation.Tutor) ~= 0 or BitUtil.band(updateData.value, SocialManager.SocialRelation.Student) ~= 0) then
        local socialData = Game.SocialManager:Find(data.guid)
        if socialData then
          self:ConfirmMsg(socialData)
        end
      end
    end
  end
end
function TutorProxy:ConfirmMsg(socialData)
  if not FriendProxy.Instance:IsFriend(socialData.guid) then
    MsgManager.ConfirmMsgByID(3218, function()
      local tempArray = ReusableTable.CreateArray()
      tempArray[1] = socialData.guid
      FriendProxy.Instance:CallAddFriend(tempArray)
      ReusableTable.DestroyArray(tempArray)
    end, nil, nil, socialData.name)
  end
end
function TutorProxy:RecvTutorFuncState(open)
  self.isOpen = open
end
function TutorProxy:GetFuncState()
  return self.isOpen
end
function TutorProxy:RecvTutorTaskUpdateBoxCmd(data)
  if data and data.items then
    if not self.tutorBoxList then
      self.tutorBoxList = {}
    else
      TableUtility.TableClear(self.tutorBoxList)
    end
    local tempArray = ReusableTable.CreateArray()
    TableUtility.ArrayShallowCopy(tempArray, data.items)
    for i = 1, #tempArray do
      local entry = ItemData.new("", tempArray[i].itemid)
      entry:SetItemNum(tempArray[i].count)
      table.insert(self.tutorBoxList, entry)
    end
    if #self.tutorBoxList > 0 and 0 < self.tutorBoxList[1].num then
      RedTipProxy.Instance:UpdateRedTip(SceneTip_pb.EREDSYS_TUTOR_BOX)
    else
      RedTipProxy.Instance:RemoveWholeTip(SceneTip_pb.EREDSYS_TUTOR_BOX)
    end
  end
end
function TutorProxy:GetTutorBoxList()
  return self.tutorBoxList
end
