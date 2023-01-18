autoImport("BaseTip")
autoImport("GainWayTipCell")
GainWayTip = class("GainWayTip", BaseTip)
GainWayTip.CloseGainWay = "GainWayTip_CloseGainWay"
function GainWayTip:ctor(parent, depth)
  self.depth = depth
  GainWayTip.super.ctor(self, "GainWayTip", parent)
end
function GainWayTip:Init()
  self:FindObjs()
  self:InitContentList()
  function self.closecomp.callBack(go)
    self:OnExit()
  end
  if self.depth then
    self.panel.depth = self.depth
    self.contentScrollView:GetComponent(UIPanel).depth = self.panel.depth + 1
  else
    local temp = self.gameObject.transform.parent:GetComponentInParent(UIPanel)
    if temp then
      self.panel.depth = temp.depth + 1
      self.contentScrollView:GetComponent(UIPanel).depth = self.panel.depth + 1
    end
  end
  self.gameObject.transform.localPosition = LuaGeometry.GetTempVector3()
  self.gameObject:SetActive(false)
  self.closeButton = self:FindGO("CloseButton")
  self:AddClickEvent(self.closeButton, function(go)
    self:OnExit()
  end)
  self.noTip = self:FindGO("NoTip")
end
function GainWayTip:FindObjs()
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  self.contentScrollView = self:FindGO("contentScrollView"):GetComponent(UIScrollView)
  self.contentGrid = self:FindGO("contentGrid"):GetComponent(UIGrid)
  self.panel = self.gameObject:GetComponent(UIPanel)
end
function GainWayTip:InitContentList()
  self.contentList = UIGridListCtrl.new(self.contentGrid, GainWayTipCell, "GainWayTipCell")
  self.contentList:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
  self.contentList:AddEventListener(GainWayTipCell.AddItemTrace, self.SetData, self)
  self.contentList:AddEventListener(ItemEvent.GoTraceItem, self.GoTraceItem, self)
end
function GainWayTip:GoTraceItem(data)
  local id = data.addWayID
  local gotoMode = Table_AddWay[id] and Table_AddWay[id].GotoMode
  if (id == GainWayTipProxy.MonsterAddWayID or id == GainWayItemData.MonsterList_ID) and data.shortCutMapParam then
    local myself = Game.Myself
    if Game.MapManager:GetMapID() == data.shortCutMapParam then
      if data.tracePos then
        local cmdArgs, cmd = ReusableTable.CreateTable()
        cmdArgs.targetMapID = data.shortCutMapParam
        cmdArgs.targetPos = LuaGeometry.GetTempVector3(data.tracePos[1] or 0, data.tracePos[2] or 0, data.tracePos[3] or 0)
        cmd = MissionCommandFactory.CreateCommand(cmdArgs, MissionCommandMove)
        myself:Client_SetMissionCommand(cmd)
        ReusableTable.DestroyAndClearTable(cmdArgs)
      else
        myself:Client_SetAutoBattleLockID(data.monsterID)
        myself:Client_SetAutoBattle(true)
      end
    elseif Game.MapManager:IsInGVG() then
      ServiceNUserProxy.Instance:ReturnToHomeCity()
      FunctionChangeScene.Me():SetSceneLoadFinishActionForOnce(function()
        local cmdArgs, cmd = ReusableTable.CreateTable()
        cmdArgs.targetMapID = data.shortCutMapParam
        if data.tracePos then
          cmdArgs.targetPos = LuaGeometry.GetTempVector3(data.tracePos[1] or 0, data.tracePos[2] or 0, data.tracePos[3] or 0)
          cmd = MissionCommandFactory.CreateCommand(cmdArgs, MissionCommandMove)
        else
          cmdArgs.npcID = data.monsterID
          cmd = MissionCommandFactory.CreateCommand(cmdArgs, MissionCommandSkill)
        end
        myself:Client_SetMissionCommand(cmd)
        ReusableTable.DestroyAndClearTable(cmdArgs)
      end)
    else
      local cmdArgs, cmd = ReusableTable.CreateTable()
      cmdArgs.targetMapID = data.shortCutMapParam
      if data.tracePos then
        cmdArgs.targetPos = LuaGeometry.GetTempVector3(data.tracePos[1] or 0, data.tracePos[2] or 0, data.tracePos[3] or 0)
        cmd = MissionCommandFactory.CreateCommand(cmdArgs, MissionCommandMove)
      else
        cmdArgs.npcID = data.monsterID
        cmd = MissionCommandFactory.CreateCommand(cmdArgs, MissionCommandSkill)
      end
      myself:Client_SetMissionCommand(cmd)
      ReusableTable.DestroyAndClearTable(cmdArgs)
    end
    GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.NormalLayer)
    break
  elseif gotoMode then
    if Game.MapManager:IsInGVG() then
      ServiceNUserProxy.Instance:ReturnToHomeCity()
      FunctionChangeScene.Me():SetSceneLoadFinishActionForOnce(function()
        FuncShortCutFunc.Me():CallByID(gotoMode)
      end)
    else
      FuncShortCutFunc.Me():CallByID(gotoMode)
    end
  end
  self:PassEvent(ItemEvent.GoTraceItem, self.data)
end
function GainWayTip:HandleClickItem(cellctl)
  local data = cellctl.data
  self.selectItemData = data
  if data.isOpen then
  else
    MsgManager.FloatMsgTableParam(nil, ZhString.GainWayTip_notOpen)
  end
end
function GainWayTip:SetData(itemStaticID)
  if itemStaticID then
    self.itemStaticID = itemStaticID
  end
  if self.itemStaticID then
    self.data = GainWayTipProxy.Instance:GetDataByStaticID(self.itemStaticID)
    if self.data then
      local t = self.data.datas
      for i = #t, 1, -1 do
        if not t[i].name and not t[i].icon or not t[i].isOpen then
          table.remove(t, i)
        end
      end
      self:SetListDatas(self.data.datas)
    end
  end
end
function GainWayTip:SetListDatas(datas)
  if not datas then
    return
  end
  self.contentList:ResetDatas(datas)
  self.contentScrollView:ResetPosition()
  self.noTip:SetActive(#datas == 0)
  self.gameObject:SetActive(true)
end
function GainWayTip:OnEnter()
end
function GainWayTip:OnExit()
  GainWayTipProxy.Instance.GainWayItemDataDic = {}
  GameObject.Destroy(self.gameObject)
  self:PassEvent(GainWayTip.CloseGainWay)
  return true
end
function GainWayTip:AddIgnoreBounds(obj)
  if self.gameObject and self.closecomp then
    self.closecomp:AddTarget(obj.transform)
  end
end
function GainWayTip:SetAnchorPos(isright)
  self.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(isright and 0 or -490, 0, 0)
end
function GainWayTip:SetPivotOffset(offsetX, offsetY)
  local x, y, z = LuaGameObject.GetLocalPositionGO(self.gameObject)
  LuaGameObject.SetLocalPositionGO(self.gameObject, offsetX and x + offsetX or x, offsetY and y + offsetY or y, z)
end
function GainWayTip:SetLocalPos(x, y, z)
  LuaGameObject.SetLocalPositionGO(self.gameObject, x, y, z)
end
