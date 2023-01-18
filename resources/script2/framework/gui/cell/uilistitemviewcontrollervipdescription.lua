UIListItemViewControllerVIPDescription = class("UIListItemViewControllerVIPDescription", BaseCell)
function UIListItemViewControllerVIPDescription:Init()
  self:GetGameObjects()
end
function UIListItemViewControllerVIPDescription:SetData(data)
  self.depositFunctionConfID = data:GetDescriptionConfigID()
  self.headDress = data:GetHeadDress()
  self:GetModelSet()
  self:LoadView()
end
function UIListItemViewControllerVIPDescription:GetModelSet()
  self.depositFunctionConf = Table_DepositFunction[self.depositFunctionConfID]
end
function UIListItemViewControllerVIPDescription:GetGameObjects()
  self.goLab = self:FindGO("Lab", self.gameObject)
  self.lab = self.goLab:GetComponent(UILabel)
  self.goLabBc = self.goLab:GetComponent(BoxCollider)
  self.goLabDragScroll = self.goLab:GetComponent(UIDragScrollView)
  self.clickUrl = self.goLab:GetComponent(UILabelClickUrl)
  function self.clickUrl.callback(url)
    local tipData = {}
    tipData.itemdata = ItemData.new("Dress", tonumber(url))
    self:ShowItemTip(tipData, self.lab, NGUIUtil.AnchorSide.Left, {-220, 0})
  end
end
function UIListItemViewControllerVIPDescription:LoadView()
  self.lab.text = self:GetDepositDesc(self.depositFunctionConf) .. "\n"
  if self.hasLabelClickUrl then
    self.goLabBc.enabled = true
    self.goLabDragScroll.enabled = true
  else
    self.goLabBc.enabled = false
    self.goLabDragScroll.enabled = false
  end
end
function UIListItemViewControllerVIPDescription:GetDepositDesc(descConfig)
  self.hasLabelClickUrl = nil
  if descConfig == nil then
    return ""
  end
  if descConfig.DescArgument == nil or #descConfig.DescArgument == 0 then
    return OverSea.LangManager.Instance():GetLangByKey(descConfig.Desc)
  end
  local tempArray = {}
  table.insert(tempArray, descConfig.Desc)
  local arg
  for i = 1, #descConfig.DescArgument do
    arg = descConfig.DescArgument[i]
    if arg == "HeadDress" and self.headDress then
      self.hasLabelClickUrl = true
      arg = string.format("[url=%s][c][1F74BF] {%s} [-][/c][/url]", self.headDress, Table_Item[self.headDress].NameZh)
    end
    table.insert(tempArray, arg)
  end
  return string.format(unpack(tempArray))
end
