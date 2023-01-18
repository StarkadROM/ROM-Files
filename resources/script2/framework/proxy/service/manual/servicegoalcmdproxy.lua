autoImport("ServiceGoalCmdAutoProxy")
ServiceGoalCmdProxy = class("ServiceGoalCmdProxy", ServiceGoalCmdAutoProxy)
ServiceGoalCmdProxy.Instance = nil
ServiceGoalCmdProxy.NAME = "ServiceGoalCmdProxy"
function ServiceGoalCmdProxy:ctor(proxyName)
  if ServiceGoalCmdProxy.Instance == nil then
    self.proxyName = proxyName or ServiceGoalCmdProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceGoalCmdProxy.Instance = self
  end
end
function ServiceGoalCmdProxy:RecvQueryGoalListGoalCmd(data)
  redlog("Recv----->QueryGoalListGoalCmd")
  QuestManualProxy.Instance:RecvQueryGoalListGoalCmd(data)
  self:Notify(ServiceEvent.GoalCmdQueryGoalListGoalCmd, data)
end
function ServiceGoalCmdProxy:RecvNewGoalItemUpdateGoalCmd(data)
  redlog("Recv----->NewGoalItemUpdateGoalCmd 节点进度")
  QuestManualProxy.Instance:RecvNewGoalItemUpdateGoalCmd(data)
  self:Notify(ServiceEvent.GoalCmdNewGoalItemUpdateGoalCmd, data)
end
function ServiceGoalCmdProxy:RecvNewGroupUpdateGoalCmd(data)
  redlog("Recv----->NewGroupUpdateGoalCmd 奖励进度")
  QuestManualProxy.Instance:RecvNewGroupUpdateGoalCmd(data)
  self:Notify(ServiceEvent.GoalCmdNewGroupUpdateGoalCmd, data)
end
function ServiceGoalCmdProxy:RecvNewGoalScoreUpdateGoalCmd(data)
  redlog("Recv----->NewGoalScoreUpdateGoalCmd")
  QuestManualProxy.Instance:RecvNewGoalScoreUpdateGoalCmd(data)
  self:Notify(ServiceEvent.GoalCmdNewGoalScoreUpdateGoalCmd, data)
end
function ServiceGoalCmdProxy:RecvGetRewardGoalCmd(data)
  redlog("Recv----->GetRewardGoalCmd")
  self:Notify(ServiceEvent.GoalCmdGetRewardGoalCmd, data)
end
function ServiceGoalCmdProxy:RecvGetGroupRewardGoalCmd(data)
  redlog("Recv----->GetGroupRewardGoalCmd")
  self:Notify(ServiceEvent.GoalCmdGetRewardGoalCmd, data)
end
function ServiceGoalCmdProxy:RecvGetScoreGoalCmd(data)
  redlog("Recv----->GetScoreGoalCmd")
  self:Notify(ServiceEvent.GoalCmdGetScoreGoalCmd, data)
end
function ServiceGoalCmdProxy:RecvGetScoreRewardGoalCmd(data)
  redlog("Recv----->GetScoreRewardGoalCmd")
  self:Notify(ServiceEvent.GoalCmdGetScoreRewardGoalCmd, data)
end
