RedPacketSendView = class("RedPacketSendView", ContainerView)
RedPacketSendView.ViewType = UIViewType.PopUpLayer
local RedPacketType = {SYS = 1, USER = 2}
local NumType = {ITEM = 1, REDPACKET = 2}
local decorationBg = "returnactivity_bg_boli_02"
local bg1Name = "returnactivity_bg_red_01"
local bg5Name = "returnactivity_bg_red_05"
local ownedMaxWidth = 110
function RedPacketSendView:Init()
  self:FindObjs()
  self:InitData()
  self.dropdownView = self:AddSubView("DropdownMessageView", DropdownMessageView)
end
function RedPacketSendView:FindObjs()
  self:AddButtonEvent("closeButton", function()
    self:CloseSelf()
  end)
  self:AddButtonEvent("helpBtn", function()
    self:OnHelpBtnClick()
  end)
  self.bg1 = self:FindComponent("bg1", UITexture)
  self.bg5 = self:FindComponent("bg5", UITexture)
  self.decoration = self:FindComponent("decoration", UITexture)
  local messageGo = self:FindGO("message")
  self.messageLabel = messageGo:GetComponent(UILabel)
  self:AddClickEvent(messageGo, function()
    self:OnDropdownBtnClick()
  end)
  self.dropArrow = self:FindComponent("arrow", UISprite, messageGo)
  self.dropdown = self:FindGO("dropdown")
  local closeScript = self.dropdown:GetComponent(CloseWhenClickOtherPlace)
  if closeScript then
    function closeScript.callBack()
      self.dropArrow.flip = 0
    end
  end
  self.dropdown:SetActive(false)
  local itemNumArea = self:FindGO("itemNum")
  self.itemNumInput = itemNumArea:GetComponent(UIInput)
  self.itemNumLabel = itemNumArea:GetComponent(UILabel)
  self.itemNumPlusBtn = self:FindGO("plusBtn", itemNumArea)
  self.itemNumMinusBtn = self:FindGO("minusBtn", itemNumArea)
  self.totalItemIcon = self:FindComponent("icon", UISprite, itemNumArea)
  EventDelegate.Set(self.itemNumInput.onChange, function()
    self:OnItemNumInputChange()
  end)
  UIEventListener.Get(itemNumArea).onSelect = function(go, state)
    if not state then
      self:OnItemNumInputChange()
    end
  end
  self:AddPressEvent(self.itemNumPlusBtn, function(obj, isPressed)
    self:OnItemNumPlusPress(isPressed)
  end)
  self:AddPressEvent(self.itemNumMinusBtn, function(obj, isPressed)
    self:OnItemNumMinusPress(isPressed)
  end)
  local redPacketNumArea = self:FindGO("redPacketNum")
  self.redPacketNumInput = redPacketNumArea:GetComponent(UIInput)
  self.redPacketNumLabel = redPacketNumArea:GetComponent(UILabel)
  self.redPacketNumPlusBtn = self:FindGO("plusBtn", redPacketNumArea)
  self.redPacketNumMinusBtn = self:FindGO("minusBtn", redPacketNumArea)
  EventDelegate.Set(self.redPacketNumInput.onChange, function()
    self:OnRedPacketNumInputChange()
  end)
  UIEventListener.Get(redPacketNumArea).onSelect = function(go, state)
    if not state then
      self:OnRedPacketNumInputChange()
    end
  end
  self:AddPressEvent(self.redPacketNumPlusBtn, function(obj, isPressed)
    self:OnRedPacketNumPlusPress(isPressed)
  end)
  self:AddPressEvent(self.redPacketNumMinusBtn, function(obj, isPressed)
    self:OnRedPacketNumMinusPress(isPressed)
  end)
  self.hint = self:FindGO("hint")
  self.owned = self:FindGO("owned")
  self.ownedContainer = self:FindGO("Container", self.owned)
  self.ownedTitle = self:FindGO("title", self.owned)
  self.sendTitle = self:FindGO("title2", self.owned)
  self.itemIcon = self:FindComponent("icon", UISprite, self.owned)
  self.ownedNum = self:FindComponent("num", UILabel, self.owned)
  self:AddButtonEvent("sendBtn", function()
    self:OnSendBtnClick()
  end)
end
function RedPacketSendView:InitView()
  if not self.staticData then
    return
  end
  local messages = self.staticData.context
  if messages and #messages > 0 then
    self.messageLabel.text = messages[1]
  end
  local redPacketNumLimit = self.staticData.totalNumLimit
  if redPacketNumLimit[1] >= redPacketNumLimit[2] then
    self:SetButtonEnabled(self.redPacketNumPlusBtn, false)
  else
    self:SetButtonEnabled(self.redPacketNumPlusBtn, true)
  end
  self:SetButtonEnabled(self.redPacketNumMinusBtn, false)
  self:SetRedPacketNum(redPacketNumLimit[1])
  local itemNumLimit = self.staticData.totalMoneyLimit
  if itemNumLimit[1] >= itemNumLimit[2] then
    self:SetButtonEnabled(self.itemNumPlusBtn, false)
  else
    self:SetButtonEnabled(self.itemNumPlusBtn, true)
  end
  self:SetButtonEnabled(self.itemNumMinusBtn, false)
  self:SetItemNum(itemNumLimit[1])
  local itemId = self.staticData.moneyID
  local itemData = Table_Item[itemId]
  if itemData then
    IconManager:SetItemIcon(itemData.Icon, self.itemIcon)
    IconManager:SetItemIcon(itemData.Icon, self.totalItemIcon)
    local num = 0
    if self.staticData.redPacketType == RedPacketType.SYS then
      self.hint:SetActive(true)
      self.ownedTitle:SetActive(false)
      self.sendTitle:SetActive(true)
      num = itemNumLimit[1]
    else
      self.hint:SetActive(false)
      self.ownedTitle:SetActive(true)
      self.sendTitle:SetActive(false)
      local ref = GameConfig.Wallet.MoneyRef[itemId]
      if ref then
        num = Game.Myself.data.userdata:Get(UDEnum[ref])
      else
        num = BagProxy.Instance:GetItemNumByStaticID(itemId)
      end
    end
    self:SetNumText(self.ownedNum, num)
    local offset = ownedMaxWidth - self.ownedNum.width
    local pos = self.ownedContainer.transform.localPosition
    LuaGameObject.SetLocalPositionGO(self.ownedContainer, pos.x + offset * 0.5, pos.y, pos.z)
  end
  self.dropdownView:InitView(self.staticData)
  PictureManager.Instance:SetReturnActivityTexture(decorationBg, self.decoration)
  PictureManager.Instance:SetReturnActivityTexture(bg1Name, self.bg1)
  PictureManager.Instance:SetReturnActivityTexture(bg5Name, self.bg5)
end
function RedPacketSendView:InitData()
  self.curRedPacketId = self.viewdata and self.viewdata.viewdata
  self.staticData = Table_RedPacket[self.curRedPacketId]
end
function RedPacketSendView:OnEnter()
  self:InitView()
  self:sendNotification(ChatRoomEvent.OnRedPacketSendViewEnter)
end
function RedPacketSendView:OnExit()
  PictureManager.Instance:UnloadReturnActivityTexture(decorationBg, self.decoration)
  PictureManager.Instance:UnloadReturnActivityTexture(bg1Name, self.bg1)
  PictureManager.Instance:UnloadReturnActivityTexture(bg5Name, self.bg5)
  self:sendNotification(ChatRoomEvent.OnRedPacketSendViewExit)
end
function RedPacketSendView:OnMessageSelected(message)
  self.messageLabel.text = message
  self:HideDropdownPanel()
  self.dropArrow.flip = 0
end
function RedPacketSendView:SetItemNum(num)
  self.itemNum = num
  self.itemNumInput.value = self.itemNum
  self:SetNumText(self.itemNumLabel, num)
end
function RedPacketSendView:SetRedPacketNum(num)
  self.redPacketNum = num
  self.redPacketNumInput.value = self.redPacketNum
  self:SetNumText(self.redPacketNumLabel, num)
end
function RedPacketSendView:SetButtonEnabled(button, enable)
  local sp = button:GetComponent(UISprite)
  local collider = button:GetComponent(BoxCollider)
  if enable then
    sp.alpha = 1
    collider.enabled = true
  else
    sp.alpha = 0.5
    collider.enabled = false
  end
end
function RedPacketSendView:OnHelpBtnClick()
  local data = Table_Help[35096]
  if data and data.Desc then
    TipsView.Me():ShowGeneralHelp(data.Desc)
  end
end
function RedPacketSendView:OnDropdownBtnClick()
  self:ShowDropdownPanel()
  self.dropArrow.flip = 2
end
function RedPacketSendView:OnItemNumPlusPress(isPressed)
  if not self.staticData then
    return
  end
  local itemNumLimit = self.staticData.totalMoneyLimit
  if isPressed then
    local num = self.itemNum
    TimeTickManager.Me():CreateTick(0, 100, function(owner, deltaTime)
      self:OnPlusUpdate(NumType.ITEM, self.itemNumPlusBtn, self.itemNumMinusBtn, num, itemNumLimit[2])
    end, self, 1)
    break
  else
    TimeTickManager.Me():ClearTick(self, 1)
  end
end
function RedPacketSendView:OnItemNumMinusPress(isPressed)
  if not self.staticData then
    return
  end
  local itemNumLimit = self.staticData.totalMoneyLimit
  if isPressed then
    local num = self.itemNum
    TimeTickManager.Me():CreateTick(0, 100, function(owner, deltaTime)
      self:OnMinusUpdate(NumType.ITEM, self.itemNumPlusBtn, self.itemNumMinusBtn, num, itemNumLimit[1])
    end, self, 2)
    break
  else
    TimeTickManager.Me():ClearTick(self, 2)
  end
end
function RedPacketSendView:OnRedPacketNumPlusPress(isPressed)
  if not self.staticData then
    return
  end
  local redPacketNumLimit = self.staticData.totalNumLimit
  if isPressed then
    local num = self.redPacketNum
    TimeTickManager.Me():CreateTick(0, 100, function(owner, deltaTime)
      self:OnPlusUpdate(NumType.REDPACKET, self.redPacketNumPlusBtn, self.redPacketNumMinusBtn, num, redPacketNumLimit[2])
    end, self, 3)
    break
  else
    TimeTickManager.Me():ClearTick(self, 3)
  end
end
function RedPacketSendView:OnRedPacketNumMinusPress(isPressed)
  if not self.staticData then
    return
  end
  local redPacketNumLimit = self.staticData.totalNumLimit
  if isPressed then
    local num = self.redPacketNum
    TimeTickManager.Me():CreateTick(0, 100, function(owner, deltaTime)
      self:OnMinusUpdate(NumType.REDPACKET, self.redPacketNumPlusBtn, self.redPacketNumMinusBtn, num, redPacketNumLimit[1])
    end, self, 4)
    break
  else
    TimeTickManager.Me():ClearTick(self, 4)
  end
end
function RedPacketSendView:OnPlusUpdate(type, plusButton, minusButton, originNum, max)
  local num = type == NumType.ITEM and self.itemNum or self.redPacketNum
  if num >= originNum + 10 and num < originNum + 20 then
    num = self:AddNum(num, 1, 2, max)
  elseif num >= originNum + 20 then
    num = self:AddNum(num, 1, 10, max)
  else
    num = self:AddNum(num, 1, 1, max)
  end
  if type == NumType.ITEM then
    self:SetItemNum(num)
  else
    self:SetRedPacketNum(num)
  end
  if max <= num then
    self:SetButtonEnabled(plusButton, false)
  else
    self:SetButtonEnabled(plusButton, true)
  end
  self:SetButtonEnabled(minusButton, true)
end
function RedPacketSendView:OnMinusUpdate(type, plusButton, minusButton, originNum, min)
  local num = type == NumType.ITEM and self.itemNum or self.redPacketNum
  if num > originNum - 20 and num <= originNum - 10 then
    num = self:ReduceNum(num, 1, 2, min)
  elseif num <= originNum - 20 then
    num = self:ReduceNum(num, 1, 10, min)
  else
    num = self:ReduceNum(num, 1, 1, min)
  end
  if type == NumType.ITEM then
    self:SetItemNum(num)
  else
    self:SetRedPacketNum(num)
  end
  if min >= num then
    self:SetButtonEnabled(minusButton, false)
  else
    self:SetButtonEnabled(minusButton, true)
  end
  self:SetButtonEnabled(plusButton, true)
end
function RedPacketSendView:AddNum(num, step, ratio, maxLimit)
  num = num + step * ratio
  num = math.min(num, maxLimit)
  return num
end
function RedPacketSendView:ReduceNum(num, step, ratio, minLimit)
  num = num - step * ratio
  num = math.max(num, minLimit)
  return num
end
function RedPacketSendView:OnItemNumInputChange()
  if not self.staticData then
    return
  end
  local limit = self.staticData.totalMoneyLimit
  local min = limit[1]
  local max = limit[2]
  self:OnInputChange(NumType.ITEM, self.itemNumInput, self.itemNumPlusBtn, self.itemNumMinusBtn, min, max)
end
function RedPacketSendView:OnRedPacketNumInputChange()
  if not self.staticData then
    return
  end
  local limit = self.staticData.totalNumLimit
  local min = limit[1]
  local max = limit[2]
  self:OnInputChange(NumType.REDPACKET, self.redPacketNumInput, self.redPacketNumPlusBtn, self.redPacketNumMinusBtn, min, max)
end
function RedPacketSendView:OnInputChange(type, input, plusBtn, minusBtn, min, max)
  local value = tonumber(input.value)
  if not value then
    return
  end
  value = math.clamp(value, min, max)
  if type == NumType.ITEM then
    self:SetItemNum(value)
  else
    self:SetRedPacketNum(value)
  end
  if max <= value then
    self:SetButtonEnabled(plusBtn, false)
  else
    self:SetButtonEnabled(plusBtn, true)
  end
  if min >= value then
    self:SetButtonEnabled(minusBtn, false)
  else
    self:SetButtonEnabled(minusBtn, true)
  end
end
function RedPacketSendView:OnSendBtnClick()
  MsgManager.DontAgainConfirmMsgByID(42081, function()
    if self.staticData.redPacketType == RedPacketType.USER then
      local myItemNum = 0
      local ref = GameConfig.Wallet.MoneyRef[self.staticData.moneyID]
      if ref then
        myItemNum = Game.Myself.data.userdata:Get(UDEnum[ref])
      else
        myItemNum = BagProxy.Instance:GetItemNumByStaticID(self.staticData.moneyID)
      end
      if myItemNum < self.itemNum then
        MsgManager.ShowMsgByID(42078)
        return
      end
    end
    local message = self.messageLabel.text
    local data = ReusableTable.CreateTable()
    data.redPacketCFGID = self.curRedPacketId
    data.str = message
    data.totalMoney = self.itemNum
    data.totalNum = self.redPacketNum
    data.channel = ChatRoomProxy.Instance:GetChatRoomChannel()
    ServiceChatCmdProxy.Instance:CallSendRedPacketCmd(data)
    ReusableTable.DestroyAndClearTable(data)
    self:CloseSelf()
  end)
end
function RedPacketSendView:ShowDropdownPanel()
  self.dropdown:SetActive(true)
end
function RedPacketSendView:HideDropdownPanel()
  self.dropdown:SetActive(false)
end
function RedPacketSendView:SetNumText(label, num)
  label.text = StringUtil.NumThousandFormat(num)
end
local dropdownCellPrefab = "RedPacketContextCell"
DropdownMessageView = class("DropdownMessageView", SubView)
local maxBgHeight = 176
function DropdownMessageView:Init()
  self.children = {}
  self:FindObjs()
end
function DropdownMessageView:FindObjs()
  self.grid = self:FindComponent("grid", UIGrid)
  self.bg = self:FindComponent("bg", UISprite, self.container.dropdown)
end
function DropdownMessageView:OnExit()
  TableUtility.ArrayClearByDeleter(self.children, function(child)
    Game.GOLuaPoolManager:AddToUIPool(dropdownCellPrefab, child)
  end)
end
function DropdownMessageView:InitView(data)
  if not data then
    return
  end
  if data.context then
    local bgHeight = 0
    for i = 1, #data.context do
      do
        local message = data.context[i]
        local child = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(dropdownCellPrefab), self.grid.gameObject)
        if child then
          local label = child:GetComponent(UILabel)
          local selectLabel = self:FindComponent("selectMsg", UILabel, child)
          label.text = message
          selectLabel.text = message
          self:AddClickEvent(child, function()
            self:OnContextClick(i)
          end)
          self.children[i] = child
          bgHeight = bgHeight + label.height
        else
        end
      end
    end
    self.grid:Reposition()
    bgHeight = math.min(bgHeight, maxBgHeight)
    self.bg.height = bgHeight
  end
end
function DropdownMessageView:OnContextClick(index)
  local child = self.children[index]
  local selectMsg = child:GetComponent(UILabel).text
  self.container:OnMessageSelected(selectMsg)
end
