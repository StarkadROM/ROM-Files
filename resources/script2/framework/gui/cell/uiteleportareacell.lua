local baseCell = autoImport("BaseCell")
UITeleportAreaCell = class("UITeleportAreaCell", baseCell)
function UITeleportAreaCell:Init()
  self.labName = self:FindGO("Name"):GetComponent(UILabel)
  self.goCurrency = self:FindGO("Currency")
  self.choose = self:FindGO("Choose")
  self:AddCellClickEvent()
end
function UITeleportAreaCell:SetData(data)
  self.choose:SetActive(false)
  self.data = data
  self.labName.text = data.name
  if AppBundleConfig.GetSDKLang() == "pt" then
    self.labName.text = self.labName.text:gsub("Área", ""):gsub(" ", "")
  end
end
function UITeleportAreaCell:SetChoose(bool)
  if bool then
    self.choose.gameObject:SetActive(true)
  else
    self.choose.gameObject:SetActive(false)
  end
end
