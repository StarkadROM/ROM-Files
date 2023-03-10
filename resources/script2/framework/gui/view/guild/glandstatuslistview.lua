GLandStatusListView = class("GLandStatusListView", ContainerView)
GLandStatusListView.ViewType = UIViewType.NormalLayer
autoImport("WrapListCtrl")
autoImport("GLandStatusListCell")
autoImport("PopupCombineCell")
local _BaseNum = 10000
local _GetRealGroupId = function(id)
  if id >= _BaseNum * 1000 then
    return math.floor(id / 1000)
  elseif id >= _BaseNum * 100 then
    return math.floor(id / 100)
  elseif id >= _BaseNum * 10 then
    return math.floor(id / 10)
  end
end
function GLandStatusListView:Init()
  self:MapEvent()
  self:InitUI()
end
function GLandStatusListView:InitUI()
  self.title = self:FindComponent("Title", UILabel)
  self.title.text = ZhString.GLandStatusListView_Title
  local container = self:FindGO("WrapContent")
  self.listCtl = WrapListCtrl.new(container, GLandStatusListCell, "GLandStatusListCell")
  self.listCtl:AddEventListener(MouseEvent.MouseClick, self.ClickGLandStatusCell, self)
  self.listCtl:AddEventListener(GLandStatusList_CellEvent_Trace, self.DoTrace, self)
  self.popUp = self:FindGO("PopUp")
  self.popUpCtl = PopupCombineCell.new(self.popUp, PopupCombineCellType.GVGLand)
  self.popUpCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickFilter, self)
  local fiterConfig = GvgProxy.Instance:GetGLandGroupZoneFilter()
  if not next(fiterConfig) then
    GvgProxy.Instance:DoQueryGvgZoneGroup()
  else
    self.popUpCtl:SetData(fiterConfig)
  end
end
function GLandStatusListView:UpdateByGvgZone()
  local fiterConfig = GvgProxy.Instance:GetGLandGroupZoneFilter()
  self.popUpCtl:SetData(fiterConfig)
  self:InitQueryGCity()
end
function GLandStatusListView:OnClickFilter()
  if self.groupid == self.popUpCtl.goal then
    return
  end
  self.groupid = self.popUpCtl.goal
  local groupid = _GetRealGroupId(self.groupid)
  GvgProxy.Instance:Debug("[NewGVG] CallQueryGCityShowInfoGuildCmd :", groupid)
  ServiceGuildCmdProxy.Instance:CallQueryGCityShowInfoGuildCmd(nil, groupid)
end
function GLandStatusListView:ClickGLandStatusCell(cell)
  local cityid = cell.data_cityid
  local groupid = cell.data_groupid
  local viewdata = {
    view = PanelConfig.GvgLandInfoPopUp,
    viewdata = {
      flagid = cityid,
      groupid = groupid,
      hide_downinfo = true
    }
  }
  self:sendNotification(UIEvent.JumpPanel, viewdata)
end
local posV3 = LuaVector3(0, 0, 0)
function GLandStatusListView:DoTrace(cell)
  local interval_time = GameConfig.GvgNewConfig.transport_interval or 5
  local cur_time = ServerTime.CurServerTime() / 1000
  if self.sendtime and interval_time > cur_time - self.sendtime then
    MsgManager.ShowMsgByID(2247)
    return
  end
  local curRaidID = Game.MapManager:GetRaidID()
  if not Game.MapManager:IsInGVG() and curRaidID ~= 0 then
    MsgManager.ShowMsgByIDTable(2240)
    return
  end
  local cityid = cell.data_cityid
  local city2RaidId = Table_Guild_StrongHold[cityid] and Table_Guild_StrongHold[cityid].LobbyRaidID or 0
  local groupid = cell.data_groupid
  if curRaidID == city2RaidId and GvgProxy.Instance:GetCurMapGvgGroupID() == groupid then
    MsgManager.ShowMsgByIDTable(2245)
    return
  end
  self.sendtime = cur_time
  GvgProxy.Instance:Debug("[NewGVG] CallGvgReqEnterCityGuildCmd groupid|cityid ", groupid, cityid)
  ServiceGuildCmdProxy.Instance:CallGvgReqEnterCityGuildCmd(groupid, cityid)
end
function GLandStatusListView:MapEvent()
  self:AddListenEvt(ServiceEvent.GuildCmdQueryGCityShowInfoGuildCmd, self.UpdateInfo)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
  self:AddListenEvt(ServiceEvent.GuildCmdQueryGvgZoneGroupGuildCCmd, self.UpdateByGvgZone)
end
function GLandStatusListView:UpdateInfo(note)
  local data = note.body
  local groupid = data.groupid
  local landInfos = GvgProxy.Instance:Get_GLandStatusInfos(groupid)
  self.listCtl:ResetDatas(landInfos, true)
end
function GLandStatusListView:OnEnter()
  GLandStatusListView.super.OnEnter(self)
  self:InitQueryGCity()
end
function GLandStatusListView:InitQueryGCity()
  self.groupid = self.popUpCtl.goal
  if not self.groupid then
    return
  end
  local groupid = _GetRealGroupId(self.groupid)
  GvgProxy.Instance:Debug("[NewGVG] CallQueryGCityShowInfoGuildCmd :", groupid)
  ServiceGuildCmdProxy.Instance:CallQueryGCityShowInfoGuildCmd(nil, groupid)
end
