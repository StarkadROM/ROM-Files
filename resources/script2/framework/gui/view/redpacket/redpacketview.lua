RedPacketView = class("RedPacketView", ContainerView)
RedPacketView.ViewType = UIViewType.PopUpLayer
local historyInfoCellPrefab = "RedPacketHistoryInfoCell"
local grabBgName = "returnactivity_bg_red_06"
local decorationBgName = "returnactivity_bg_boli_02"
local restAreaMaxWidth = 110
function RedPacketView:Init()
  self:FindObjs()
  self:AddEventListener()
  self.curRedPacketId = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.redPacketId
  self.senderId = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.senderId
  self.senderName = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.senderName
  self.historyInfos = {}
end
function RedPacketView:FindObjs()
  self.grabPanel = self:FindGO("grab")
  self.historyPanel = self:FindGO("history")
  self.grabBg = self.grabPanel:GetComponent(UITexture)
  self.senderLabel = self:FindComponent("senderName", UILabel, self.grabPanel)
  self.grabBtn = self:FindGO("grabBtn")
  self.grabLabel = self:FindGO("grabLabel", self.grabBtn)
  self.receivedLabel = self:FindGO("receivedLabel", self.grabBtn)
  self.overLabel = self:FindGO("overLabel", self.grabBtn)
  self:AddClickEvent(self.grabBtn, function()
    self:OnGrabBtnClick()
  end)
  self:AddButtonEvent("closeCollider", function()
    self:CloseSelf()
  end)
  self.receivedTitle = self:FindGO("title", self.historyPanel)
  self.notReceivedTitle = self:FindGO("title2", self.historyPanel)
  self.decoration = self:FindComponent("decoration", UITexture, self.historyPanel)
  self.timer = self:FindComponent("timer", UILabel, self.historyPanel)
  local grabNumGo = self:FindGO("grabNum", self.historyPanel)
  self.grabNumLabel = grabNumGo:GetComponent(UILabel)
  self.grabIcon = self:FindComponent("icon", UISprite, grabNumGo)
  self.redPacketNumLabel = self:FindComponent("redPacketNum", UILabel, self.historyPanel)
  self.grid = self:FindComponent("grid", UIGrid, self.historyPanel)
  local restArea = self:FindGO("restArea")
  self.restAreaContainer = self:FindGO("Container", restArea)
  self.restIcon = self:FindComponent("icon", UISprite, restArea)
  self.restNumLabel = self:FindComponent("num", UILabel, restArea)
  self:AddButtonEvent("closeButton", function()
    self:CloseSelf()
  end)
end
function RedPacketView:AddEventListener()
  self:AddListenEvt(ServiceEvent.ChatCmdReceiveRedPacketRet, self.OnChatCmdReceiveRedPacketRet)
end
function RedPacketView:OnChatCmdReceiveRedPacketRet(note)
  local data = note.body
  if not data.bRedPacketExist then
    redlog("redPacket not exist!!!")
    return
  end
  if data.bRedPacketUsable then
    local redPacketContent = RedPacketProxy.Instance:GetRedPacketContent(self.curRedPacketId)
    if redPacketContent then
      local redPacketConfig = Table_RedPacket[redPacketContent.redPacketCFGID]
      if redPacketConfig and redPacketConfig.thanksContext then
        local channel = ChatRoomProxy.Instance:GetChatRoomChannel()
        local contextIndex = math.random(1, #redPacketConfig.thanksContext)
        local context = redPacketConfig.thanksContext[contextIndex]
        ServiceChatCmdProxy.Instance:CallChatCmd(channel, context)
      end
    end
  elseif self.isFirstGrab then
    MsgManager.ShowMsgByID(42079)
  end
  self:ShowHistoryPanel()
  self.isFirstGrab = false
end
function RedPacketView:InitView()
  self:ShowGrabPanel()
  PictureManager.Instance:SetReturnActivityTexture(grabBgName, self.grabBg)
  PictureManager.Instance:SetReturnActivityTexture(decorationBgName, self.decoration)
end
function RedPacketView:ShowGrabPanel()
  self.grabPanel:SetActive(true)
  self.historyPanel:SetActive(false)
  self:InitGrabPanel()
end
function RedPacketView:ShowHistoryPanel()
  self.grabPanel:SetActive(false)
  self.historyPanel:SetActive(true)
  self:InitHistoryPanel()
  if self.isFirstGrab then
    self:sendNotification(ChatRoomEvent.UpdateCurChannel)
  end
end
function RedPacketView:InitGrabPanel()
  if self.senderName then
    self.senderLabel.text = string.format(ZhString.RedPacketSender, self.senderName)
  end
  self:RefreshGrabPanel()
end
function RedPacketView:RefreshGrabPanel()
  local isReceived = RedPacketProxy.Instance:CheckIfReceived(self.curRedPacketId)
  local isRedPacketContentExist = RedPacketProxy.Instance:IsRedPacketContentExist(self.curRedPacketId)
  if isReceived then
    self.grabLabel:SetActive(false)
    self.receivedLabel:SetActive(true)
    self.overLabel:SetActive(false)
  elseif isRedPacketContentExist then
    self.grabLabel:SetActive(false)
    self.receivedLabel:SetActive(false)
    self.overLabel:SetActive(true)
  else
    self.grabLabel:SetActive(true)
    self.receivedLabel:SetActive(false)
    self.overLabel:SetActive(false)
    self.isFirstGrab = true
  end
end
function RedPacketView:InitHistoryPanel()
  local redPacketContent = RedPacketProxy.Instance:GetRedPacketContent(self.curRedPacketId)
  if not redPacketContent then
    return
  end
  local redPacketConfig = Table_RedPacket[redPacketContent.redPacketCFGID]
  if not redPacketConfig then
    return
  end
  local config = Table_Item[redPacketConfig.moneyID]
  if not config then
    return
  end
  local receivedNum = RedPacketProxy.Instance:GetReceivedItemNum(self.curRedPacketId)
  if receivedNum then
    self.receivedTitle:SetActive(true)
    self.notReceivedTitle:SetActive(false)
  else
    self.receivedTitle:SetActive(false)
    self.notReceivedTitle:SetActive(true)
  end
  self:SetNumText(self.grabNumLabel, receivedNum or 0)
  IconManager:SetItemIcon(config.Icon, self.grabIcon)
  local restRedPacketNum = redPacketContent.restNum
  local totalRedPacketNum = redPacketContent.totalNum
  self.redPacketNumLabel.text = string.format("%s/%s", totalRedPacketNum - restRedPacketNum, totalRedPacketNum)
  self:SetNumText(self.restNumLabel, redPacketContent.restMoney)
  local offset = restAreaMaxWidth - self.restNumLabel.width
  local pos = self.restAreaContainer.transform.localPosition
  LuaGameObject.SetLocalPositionGO(self.restAreaContainer, pos.x + offset * 0.5, pos.y, pos.z)
  IconManager:SetItemIcon(config.Icon, self.restIcon)
  self:InitHistoryInfo(redPacketContent)
  local restTime = redPacketContent.overtime - ServerTime.CurServerTime() / 1000
  TimeTickManager.Me():CreateTick(0, 1000, function()
    self:UpdateRestTimer(restTime)
    restTime = math.max(restTime - 1, 0)
  end, self)
end
function RedPacketView:OnEnter()
  self:InitView()
end
function RedPacketView:OnExit()
  TableUtility.ArrayClearByDeleter(self.historyInfos, function(child)
    Game.GOLuaPoolManager:AddToUIPool(historyInfoCellPrefab, child)
  end)
  TimeTickManager.Me():ClearTick(self)
  PictureManager.Instance:UnloadReturnActivityTexture(grabBgName, self.grabBg)
  PictureManager.Instance:UnloadReturnActivityTexture(decorationBgName, self.decoration)
end
function RedPacketView:OnGrabBtnClick()
  ServiceChatCmdProxy.Instance:CallReceiveRedPacketCmd(self.curRedPacketId, self.senderId)
  UIEventListener.Get(self.grabBtn).onClick = nil
end
function RedPacketView:InitHistoryInfo(redPacketContent)
  local infos = redPacketContent.receivedInfos
  local redPacketConfig = Table_RedPacket[redPacketContent.redPacketCFGID]
  if not redPacketConfig then
    return
  end
  local config = Table_Item[redPacketConfig.moneyID]
  if not config then
    return
  end
  for i = 1, #infos do
    local info = infos[i]
    local child = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(historyInfoCellPrefab), self.grid.gameObject)
    if child then
      local nameLabel = self:FindComponent("name", UILabel, child)
      local icon = self:FindComponent("icon", UISprite, child)
      local numLabel = self:FindComponent("num", UILabel, child)
      nameLabel.text = info.receivedName
      IconManager:SetItemIcon(config.Icon, icon)
      self:SetNumText(numLabel, info.receivedMoney)
      self.historyInfos[i] = child
    end
  end
  self.grid:Reposition()
end
function RedPacketView:UpdateRestTimer(restTime)
  if restTime <= 0 then
    TimeTickManager.Me():ClearTick(self)
    restTime = 0
  end
  local min, sec = ClientTimeUtil.GetFormatSecTimeStr(restTime)
  self.timer.text = string.format("%02d:%02d", min, sec)
end
function RedPacketView:SetNumText(label, num)
  label.text = StringUtil.NumThousandFormat(num)
end
