autoImport("BaseTip")
SettingViewHelp = class("SettingViewHelp", BaseTip)
autoImport("SettingViewToggleCell")
autoImport("SettingViewTitleCell")
local _ArrayClear = TableUtility.ArrayClear
local getTitleData = function(sLabel, sAtlas, sSpriteName, bline)
  return {
    label = sLabel,
    atlas = sAtlas,
    spriteName = sSpriteName,
    line = bline
  }
end
function SettingViewHelp:GetTitleDatas(index)
  if not self.titleDatas then
    self.titleDatas = {}
  else
    _ArrayClear(self.titleDatas)
  end
  local helpData = self.datas[index]
  if helpData.id == GameConfig.Setting.GametimeHelpId then
    local battleTimelen = ExpRaidProxy.Instance.battleTimelen
    if battleTimelen then
      local musicTime, tutorTime, powerTime = 0, 0, 0
      if battleTimelen.musictime then
        musicTime = math.ceil(battleTimelen.musictime / 60)
      end
      if battleTimelen.tutortime then
        tutorTime = math.floor(battleTimelen.tutortime / 60)
      end
      if battleTimelen.powertime then
        powerTime = math.floor(battleTimelen.powertime / 60)
      end
      local len = 0
      if musicTime > 0 then
        table.insert(self.titleDatas, getTitleData(musicTime .. ZhString.SettingViewHelp_Min, "NEWUI2", "Music_icon_02", true))
        len = len + 1
      end
      if tutorTime > 0 then
        table.insert(self.titleDatas, getTitleData(tutorTime .. ZhString.SettingViewHelp_Min, "NewUI4", "V1_tecexp", true))
        len = len + 1
      end
      if powerTime > 0 then
        table.insert(self.titleDatas, getTitleData(powerTime .. ZhString.SettingViewHelp_Min, "NewUI8", "V1_battle", true))
        len = len + 1
      end
      if len > 0 then
        self.titleDatas[len].line = false
      end
    end
  elseif helpData.id == GameConfig.Setting.PlaytimeHelpId then
    local battleTimelen = ExpRaidProxy.Instance.battleTimelen
    if battleTimelen then
      local playtime = 0
      if battleTimelen.playtime then
        playtime = math.ceil(battleTimelen.playtime / 60)
      end
      if playtime > 0 then
        table.insert(self.titleDatas, getTitleData(playtime .. ZhString.SettingViewHelp_Min, "NewUI8", "V1_battle", false))
      end
    end
  end
  return self.titleDatas
end
function SettingViewHelp:Init()
  self:InitTip()
  local closeBtn = self:FindGO("CloseButton")
  self:AddClickEvent(closeBtn, function()
    TipsView.Me():HideCurrent()
    EventManager.Me():DispatchEvent(UICloseEvent.GeneralHelpClose)
  end)
end
function SettingViewHelp:InitTip()
  self.content = self:FindComponent("Content", UIRichLabel)
  self.contentLabel = SpriteLabel.new(self.content)
  local toggleGrid = self:FindComponent("ToggleGrid", UIGrid)
  self.toggleCtrl = UIGridListCtrl.new(toggleGrid, SettingViewToggleCell, "SettingViewToggleCell")
  self.toggleCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickToggle, self)
  local titleGrid = self:FindComponent("TitleGrid", UIGrid)
  self.titleCtrl = UIGridListCtrl.new(titleGrid, SettingViewTitleCell, "SettingViewTitleCell")
  self.emptyTipGO = self:FindGO("EmptyTip")
  self.contentScrollView = self:FindComponent("ContentScrollView", UIScrollView)
  self:FindComponent("Label", UILabel, self.emptyTipGO).text = ZhString.SettingViewHelp_EmptyTip
end
function SettingViewHelp:ClickToggle(cell)
  self:SetToggle(cell.indexInList)
end
function SettingViewHelp:SetToggle(index)
  self.toggleIndex = index
  local cells = self.toggleCtrl:GetCells()
  for i = 1, #cells do
    cells[i]:SetActive(self.toggleIndex == i)
  end
  local titleDatas = self:GetTitleDatas(index)
  self.titleCtrl:ResetDatas(titleDatas)
  self.emptyTipGO:SetActive(#titleDatas == 0)
  self.contentLabel:SetText(self.datas[index].Desc)
  self.contentScrollView:ResetPosition()
end
function SettingViewHelp:SetData(datas)
  if not datas then
    return
  end
  self.datas = datas
  self.toggleCtrl:ResetDatas(datas)
  self:SetToggle(1)
end
function SettingViewHelp:DestroySelf()
  GameObject.Destroy(self.gameObject)
end
